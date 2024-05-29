

TRUNCATE TABLE	[Database1].dbo.Example




INSERT INTO Scorecard.[dbo].Example
SELECT  DISTINCT  Masterkey
FROM	[AggregateDatabase1].dbo.[Example_Table]
WHERE	IDOrganization = 279
AND Masterkey LIKE '292%'





-- Getting patients first, last, and DOB


UPDATE Example
SET	[Patient's First Name]	= Pers..PsnFirst,	[Patient's Late Name]	=  Pers.PsnLaSt,	[Patient's Date of Birth]	=  Pers.Psnous,	[Client Name]	= Pers.PcPPracticeName
FROM [AggregateDatabase1].dbo.[Example_Table] Pers
JOIN  Scorecard.Example  samp
ON  Pers.MasterKey	=   samp.MRN
WHERE Pers.IDOrganization = Pers.IDMasterOrganization
AND  Pers.Idstatus = 1




--  getting most recent phone number

UPDATE  Example
SET	[Patient's  Phone  Number]	=  replace(replace(replace(replace(replace(replace(replace(replace(LTRIM(RTRIM(A.Phone)),'-',''),'(',''),')',''), ' ' ,''), '/' ,''),'x',''),'*',''),'calls','')
FROM (
 
SELECT  Phone [MasterKey],Phone.Phone,Phone.DateUpdated, ROW_NUMBER()  OVER (PARTITION BY Phone.MasterKey ORDER BY Phone.DateUpdated DESC) RN
FROM  [AggregateDatabase1].dbo.[Phone_Table]   Phone 
	INNER  JOIN  Scorecard.Example samp
ON Phone.Masterkey = samp.MRN
WHERE  PhoneType  in ('CELL','HOME') 
and  ISNULL ([Phone],'')  <> ''
and phone not  like  '%[a-z]%'
and  replace(replace(replace(replace(replace(replace(replace(replace(LTRIM(RTRIM(Phone.Phone)),'-',''),'(',''),')',''), ' ' ,''), '/' ,''),'x',''),'*',''),'calls','') NOT LIKE 'e%'
and lenreplace(replace(replace(replace(replace(replace(replace(replace(LTRIM(RTRIM(Phone.Phone)),'-',''),'(',''),')',''), ' ' ,''), '/' ,''),'x',''),'*',''),'calls','') = 10
) A

join [AggregateDatabase1].dbo.[Person_Table] j 	on a.MasterKey = j.MasterKey
join [AggregateDatabase1].dbo.[Master_Patient_Index_Table]  d  on  j.IDOrganization =  d.IDOrganization  END J.IDPerson = d.IDPerson 
INNER JOIN Scorecard.dbo.example Outp
ON A.MasterKey = OutP.MRN
WHERE  RN = 1





--  formats  phone  number

UPDATE  Example 
SET [Patient's   Phone  Number] =  SUBSTRING([Patient's  Phone  Number], 	1, 	3) +  '-' +
							SUBSTRING{[Patient's  Phone  Number],  4,	3) + '-' +
							SUBSTRING([Patient's  Phone  Number],  7,	4)















SELECT r.ProtCode
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%current'  THEN 1
								ELSE  0
							END)	[Met]	--Numerator
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%invalid' THEN 1
								ELSE  0
							END)	[Not Met]
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%incl'  THEN 1
								ELSE  0
							END)	[Denominator]
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%excl'  THEN 1
								ELSE  0
							END)	[Exclusion]
						,SUM(CASE  WHEN  R.Recommendation  LIKE	'%exception'  THEN 1
								ELSE  0
							END)	[Exception]
						,
					CONVERT(Decimal(20,1),
				  (CONVERT{Decimal(20,1), SUM(CASE WHEN R.Recommendation LIKE '%current' THEN 1  ELSE	0  END)*100)  )
						/
(SUM(CASE  WHEN  (R.Recommendation  LIKE   '%incl' THEN	1  ELSE	0  END)-SUM(CASE  WHEN  R.Recommendation  LIKE  '%exception'  THEN 1  ELSE	0  END) )
)	[Performance  Rate  %]


FROM 	[Example],[dbo].(Recommendations)  r WITH(NOLOCK)

				WHERE 	(R.Recommendation  LIKE  '%current'
						OR  R.Recommendation  LIKE  '%Excl' 
						OR  R.Recommendation  LIKE  '%Incl'
						OR  R.Recommendation  LIKE  '%Invalid'
						OR  R.Recommendation  LIKE  '%Exception')
GROUP BY r.ProtCode
ORDER BY 1



/*
Table 1 Query:
Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Table 2 Query:
Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
)



Table 1 Insert:
Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

Table 2 Insert:
Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)*/

/*

Table 1 Insert:
Insert into EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

Table 3 Query:
Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Table 3 Insert:
Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')
*/

/*

Today's Topic: Stored Procedures

*/

/*
CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee
GO;




CREATE PROCEDURE Temp_Employee2 
@JobTitle nvarchar(100)
AS
DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
where JobTitle = @JobTitle --- make sure to change this in this script from original above
group by JobTitle

Select * 
From #temp_employee3
GO;


exec Temp_Employee2 @jobtitle = 'Salesman'
exec Temp_Employee2 @jobtitle = 'Accountant'
*/

/*
/*

Today's Topic: String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

*/

--Drop Table EmployeeErrors;

/*

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

	



-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors


-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)



-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors

*/


/*

Today's Topic: Subqueries (in the Select, From, and Where Statement)

*/
/*

Select EmployeeID, JobTitle, Salary
From EmployeeSalary

-- Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID


-- Subquery in From

Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmployeeID


-- Subquery in Where


Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30)
	*/
	/*
	
	Create table #temp_employee2 (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

Select * From #temp_employee2

Insert into #temp_employee2 values (
'1001', 'HR', '45000'
)

Insert into #temp_employee2 
SELECT * From SQLTutorial..EmployeeSalary

Select * From #temp_employee2




DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee3

SELECT AvgAge * AvgSalary
from #temp_employee3


*/