#### Task 1 ####
library(haven)
survey2021 <- read_sav("C:/Users/User/Desktop/ERM-RM-with-R-Python/Econ-ana-SPSS-in-R/pratical2/survey2021.sav")

#### Task 2 dummy variables ####
survey2021$NL1dummy = ifelse(survey2021$version == 'NL1', 1, 0) 
survey2021$NL2dummy = ifelse(survey2021$version == 'NL2', 1, 0)
survey2021$UK1dummy = ifelse(survey2021$version == 'UK1', 1, 0) 
survey2021$UK2dummy = ifelse(survey2021$version == 'UK2', 1, 0)


#### Task 3(two-way tables and comparing means ####
## two-way table with gender and university education
survey2021 %>% select(gender,educ_university) %>% table()
# chi-square test
chisq.test(survey2021$gender, survey2021$educ_university)

## two-way table with university education and mean income
survey2021 %>% select(educ_university,income) %>% table()
# chi-square test
chisq.test(survey2021$educ_university, survey2021$income)

# Wilcoxon rank-sum
wilcox.test(survey2021$income[survey2021$educ_university==1], 
            survey2021$income[survey2021$educ_university==0], alternative = "two.sided")
#t.test:mean1 > mean2
t.test(survey2021$income[survey2021$educ_university==1], 
       survey2021$income[survey2021$educ_university==0],alternative = "greater")
#t.test:mean1 != mean2
t.test(survey2021$income[survey2021$educ_university==1], 
       survey2021$income[survey2021$educ_university==0],alternative = "two.sided")

## What is higher �Vthe mean WTP for nature in the Netherlands or in the Caribbean Netherlands?
library(ggplot2)
ggplot(survey2021, aes(x= nl_wtp))+
  geom_histogram(bins = 10)

ggplot(survey2021, aes(x= car_wtp))+
  geom_histogram(bins = 10)

wilcox.test(survey2021$nl_wtp, 
            survey2021$car_wtp, alternative = "two.sided",paired = T)

print(c(mean(survey2021$nl_wtp,na.rm = T),
        mean(survey2021$car_wtp,na.rm = T)))

## Compare WTP for nature in Caribbean Netherlands between those who have travelled to Aruba, Bonaire and Curacao and those who have not.
wilcox.test(survey2021$car_wtp[survey2021$visit_aruba==1],
            survey2021$car_wtp[survey2021$visit_aruba==0],alternative = "two.sided")

wilcox.test(survey2021$car_wtp[survey2021$visit_bonaire==1],
            survey2021$car_wtp[survey2021$visit_bonaire==0],alternative = "two.sided")

wilcox.test(survey2021$car_wtp[survey2021$visit_curacao==1],
            survey2021$car_wtp[survey2021$visit_curacao==0],alternative = "two.sided")

#### Task 4 regressions ####
##WTP for nature in Netherlands onto income
lm1 = lm(nl_wtp~income,data = survey2021)
summary(lm1)

#plot this relationship
ggplot(survey2021,aes(x = income,y = nl_wtp))+
  geom_point()+
  geom_smooth(method='lm',se = FALSE)

## WTP for nature in the Netherlands onto income, age, education dummies (take primary education as base scenario) and levels of importance (the first questions from the survey).
lm2 = lm(nl_wtp~income+age+
           imp_traffic+
           imp_defence+
           imp_social+
           imp_health+
           imp_immigration+
           imp_nature+
           imp_education+
           imp_aid+
           imp_transport+
           imp_employment+
           imp_security+
           imp_euro+
           educ_secondary+
           educ_vocational+
           educ_college+
           educ_university
           ,data = survey2021)
summary(lm2)

#fitted mean WTP for someone who has a high school diploma and is earning 1500 Euros permonth
cat("WTP is ", 1500*0.005625,"euro per month")

##WTP for nature in the Caribbean Netherlands onto income, age, education (take primary education as base scenario), levels of importance and visits to the islands dummies.
lm3 = lm(car_wtp~income+age+
           imp_traffic+
           imp_defence+
           imp_social+
           imp_health+
           imp_immigration+
           imp_nature+
           imp_education+
           imp_aid+
           imp_transport+
           imp_employment+
           imp_security+
           imp_euro+
           educ_secondary+
           educ_vocational+
           educ_college+
           educ_university+
           visit_aruba+
           visit_bonaire+
           visit_curacao+
           visit_saba+
           visit_maarten+
           visit_eustaitus
         ,data = survey2021)
summary(lm3)
cat("WTP is ", 0,"since selected variables are not significant")

## Add the survey versions (choose one version as base) as covariates to both regressions
lm2.1 = lm(nl_wtp~income+age+
           imp_traffic+
           imp_defence+
           imp_social+
           imp_health+
           imp_immigration+
           imp_nature+
           imp_education+
           imp_aid+
           imp_transport+
           imp_employment+
           imp_security+
           imp_euro+
           educ_secondary+
           educ_vocational+
           educ_college+
           educ_university+
           NL2dummy+
           UK1dummy+
           UK2dummy
         ,data = survey2021)
summary(lm2.1)

lm3.1 = lm(car_wtp~income+age+
           imp_traffic+
           imp_defence+
           imp_social+
           imp_health+
           imp_immigration+
           imp_nature+
           imp_education+
           imp_aid+
           imp_transport+
           imp_employment+
           imp_security+
           imp_euro+
           educ_secondary+
           educ_vocational+
           educ_college+
           educ_university+
           visit_aruba+
           visit_bonaire+
           visit_curacao+
           visit_saba+
           visit_maarten+
           visit_eustaitus+
           NL2dummy+
           UK1dummy+
           UK2dummy
         ,data = survey2021)
summary(lm3.1)

# WTP C-NL with the survey version dummy variables
summary(lm3.1)$adj.r.squared

# WTP C-NL without the survey version dummy variables
summary(lm3)$adj.r.squared

## Add the dummy variables for the surveyors
lm3.2 = lm(car_wtp~income+age+
             imp_traffic+
             imp_defence+
             imp_social+
             imp_health+
             imp_immigration+
             imp_nature+
             imp_education+
             imp_aid+
             imp_transport+
             imp_employment+
             imp_security+
             imp_euro+
             educ_secondary+
             educ_vocational+
             educ_college+
             educ_university+
             visit_aruba+
             visit_bonaire+
             visit_curacao+
             visit_saba+
             visit_maarten+
             visit_eustaitus+
             NL2dummy+
             UK1dummy+
             UK2dummy+
             surveyor2+
             surveyor3+
             surveyor4+
             surveyor5+
             surveyor6+
             surveyor7+
             surveyor8+
             surveyor9+
             surveyor10+
             surveyor11+
             surveyor12+
             surveyor13+
             surveyor14+
             surveyor15+
             surveyor16+
             surveyor17+
             surveyor18+
             surveyor19+
             surveyor20+
             surveyor21+
             surveyor22+
             surveyor23+
             surveyor24+
             surveyor25+
             surveyor26+
             surveyor27+
             surveyor28+
             surveyor29+
             surveyor30
           ,data = survey2021)
summary(lm3.2)
