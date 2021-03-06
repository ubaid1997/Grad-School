clc; clear; close all;
%Ubaid Rahim ME6103 Assingment #2

% Using a numerical search algorithm, you have to find a design in terms of:
% � the spring wire diameter d,
% � the mean coil diameter D, and
% � the number of active coils N.

% following (customer-specific) goals as much as possible:
% � Cost,
% � Energy storage capacity (?2/8E), where ? is the bending stress and E is Young�s modulus, and
% � Space efficiency (?C/(C+1)2), where C is the spring index, C = D/d.
% A trade-off study is suggested and the problem has to be solved

% for at least  following three different prioritization scenarios ((you are welcome to add more scenarios if you want/like):
% 1) All goals have equal priority,
% 2) Cost is much more important than the other goals,
% 3) Cost has the lowest priority.

% Tasks:
% 1) Formulate a compromise Decision Support Problem representing the design optimization problem of this spring in terms
% of variables, goals, constraints, bounds, etc. organized using the keywords Given, Find, Satisfy, Minimize (see paper)
% 2) Write a computer program for solving this problem. This program should include:
% a) Goals and constraints for the model characterizing the design,
% b) A clearly separate generalizable routine for determining a lexicographic minimum. This routine should not be limited
% to the spring problem because you will need it later in the class as well.
% c) A solution scheme for finding the system variables (d, D and N) for various scenarios
% 3) Solve the problem for all listed prioritization scenarios
% a) Using an Archimedean weighting scheme, and
% b) Using the concept of the lexicographic minimum for finding a solution.
% 4) Write a technical report in which the following is documented (not necessarily in this order):
% A. A discussion on your model, solution scheme and results, which should include:
% Model:
% a) the compromise Decision Support Problem formulation
% b) your assumptions made and the reasoning behind it
% c) the (analytical) relationships used,
% d) how you have applied the principles of modeling (see lecture notes) to this problem,
% e) how you validated the model,
% Solution scheme:
% f) the solution technique(s) used,
% g) a short description with a flow chart of your program,
% Results and verification:
% h) the results for the different scenarios,
% i) your assessment of the results,
% j) how you validated the results and your solutions (include graphs, etc.),
% k) your conclusions and product recommendations,
% l) your recommendations for future work and
% m) a discussion on what you have learned from this assignment
% B. The source code of your program and examples of the program�s output.

%% Step 0. Assumptions
fprintf('------------Assumptions------------------\n')
fprintf('(1) Mouse trap width is 3in. As a results coils length must be <= 2in.\n ')
fprintf('(2) Material properties are homogeneous')
fprintf('(3) Spring Cost is a function of C(x) = material cost * material volume \n')
fprintf('(4) Spring material assumed to be Music Wire - ASTM A 228 - Spring Wire \n')

%% Step 1. Formulate constraints
fprintf('-----------Constraints-------------------\n')
fprintf('(1 & 2) F >= 50N & F <= 60N [Spring loaded Force Constraint] \n')
fprintf('(3) Mandrel_Clearance >= 0.5 mm. [Spring inner diameter clearance Constraint] \n')
fprintf('(4) Axial_length <= 2in (50mm). [Axial length of coiled spring] \n')

%% Design Variables
fprintf('-----------Design variables-----------\n')
fprintf('(1) Wire Diameter (d) \n(2) Mean Coil Diameter (D) \n(3) Number of Coils (N) \n')
% fprintf('------------------------------\n')


%% Objective Function
fprintf('----------Objective Function----------\n')
fprintf('(1) minmize cost  C(x) = \n')
fprintf('(2) Maximize Space Efficency SE(x) = pi*C/(C*(C+1)^2) where C=D/d \n')
fprintf('(3) Maximize Energy Storage ES = sigma^2/8E \n')
fprintf('(4) C_length <= 2in (50mm). [Spring inner diameter clearance Constraint] \n')




%% Compromise Decision Support Problem
fprintf('----------Compromise Decision Support Problem----------\n')
fprintf('GIVEN: \n E = 30Psi  \n M_d = 2.5mm\n')
fprintf('FIND:\n Spring wire diameter d \n Mean coil diameter D\n Number of active coils N\n')
fprintf('SATISFY: \n F(X) >= 50N \n F(X) <= 60N \n Axial_length(X) <= 2in. \n Mandrel_Clearance >=0.5mm \n')
fprintf('MAXIMIZE: \n Spacial Efficency (SE) of spring \n Energy Storage Capcity (ESC)\n')
fprintf('MINMIZE: \n Cost of spring (C)\n')

%%






%% Define constants
Load_Angle = 180; % [deg]
E  = 30*10^6; % [psi] Music Wire - ASTM A 228 - Spring Wire 
M_d = 0.0984252; %[in] mandrel Diameter
F1 = 11.24; %[lbf] Force min
F2 = 13.48; %[lbf] Force Max
N_s = 0.5; % [turns] 0.5 turns for set position - 180 deg
L =3.3125; %[in] 3 5/16 in. moment arm 
Clc = 0.019685; % clearnace between OD of mandrel and ID of coil
AL = 2; %[in] maximum axial length of spring

%Design Variables - guess at solution that meets constraints
D = 0.2366; %[in] 15 mm
d = 0.077 ;%[in] 1.8mm
N=5  ;

%
%% Formulate Constraints in terms of Design Variables
K = ((E*d^4)/(10.8*D*N)); %spring rate [lbf*in/turn]
D >= M_d; % mean diameter constraint
(D*N)/(N+N_s)-(d/2) - M_d >= Clc; % clearance
N*d <= 2;  %axial Length 
K*N_s/L >= F1;
K*N_s/L <= F2;

%% Formulate Goals
%minimze Cost
%Cost model is function of material used % number of coils
% C = 5 + Material Volume Cost + Manufacturing costs
% base cost estimated from https://www.thespringstore.com/catalogsearch/advanced/result/?ts_od%5Bfrom%5D=0.102&ts_od%5Bto%5D=0.5&ts_bl%5Bfrom%5D=&ts_bl%5Bto%5D=&ts_rt%5Bfrom%5D=&ts_rt%5Bto%5D=&ts_ld%5Bfrom%5D=&ts_ld%5Bto%5D=&ts_dt%5Bfrom%5D=&ts_dt%5Bto%5D=&ts_tc%5Bfrom%5D=&ts_tc%5Bto%5D=&ts_id%5Bfrom%5D=&ts_id%5Bto%5D=&ts_wd%5Bfrom%5D=&ts_wd%5Bto%5D=&ts_ll%5Bfrom%5D=&ts_ll%5Bto%5D=&ts_mt=50&ts_hd=58&search=stock-torsion-springs&unit_measure=en
% additional cost from material & manufacturing formulated
Cost = 5 + (pi*(d/2)*2*N*d)*5 + (.7*d + .3*N)*.4;
%maximize Spacial Efficiency
C=D/d;
SE = pi*C/(C*(C+1)^2);
%maximize 
sigma = ((32*K*N_s)/(pi*d^3))*((4*C^2-C-1)/(4*C*(C-1)));
ES = sigma^2/(8*E);
% ES2 = .5*K*pi^2


D = [0:.01:1];
d = [0:.001:.2];
N = [0:1:25];



% for D