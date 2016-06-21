From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Tue, 21 Jun 2016 14:26:15 -0600
Message-ID: <CAANLjFpeL0AkuGW-q5Bmm-dff0UqFOM_sAOaG7=vyqmwnOoTcQ@mail.gmail.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
 <5756B7D2.5040009@mellanox.com> <CAANLjFq4CoOSbng=aPHiSsFB=1HMSwAhhLiCjt+88dzz24OT9w@mail.gmail.com>
 <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow@mail.gmail.com>
 <57582336.10407@mellanox.com> <CAANLjFrLK-ZVP5XX3TnkAMz+7_pd6qc+c88mbF4vF9DQ+F5U=A@mail.gmail.com>
 <CAANLjFrv-0VArTEkgqbrhzFjn1fg_egpCJuQZnAurVrHjbL_qA@mail.gmail.com>
 <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw@mail.gmail.com>
 <57693C6A.3020805@gmail.com> <CAANLjFpUyAYB+ZzMwFKBpa4yLmALPzcRGJX1kExVrLARZmZRkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFpUyAYB+ZzMwFKBpa4yLmALPzcRGJX1kExVrLARZmZRkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Sagi & Max,

Here is the results of SRP using the same ramdisk backstore that I was
using from iSER (as same as can be between reboots and restoring
targetcli config). I also tested the commit before 9679cc51eb13
(5adabdd122e471fe978d49471624bab08b5373a7) which is included here. I'm
not seeing a correlation between iSER and SRP that would lead me to
believe that the changes are happening in both implementations.

Does this provide enough information for you, or do you think TGT will
be needed?

4.4 (afd2ff9) vanilla default config
sdb;10.218.128.17;5150176;1287544;16288
sdd;10.218.202.17;5092337;1273084;16473
sdh;10.218.203.17;5129078;1282269;16355
sdk;10.218.204.17;5129078;1282269;16355
sdg;10.219.128.17;5155874;1288968;16270
sdf;10.219.202.17;5131588;1282897;16347
sdi;10.219.203.17;5165399;1291349;16240
sdl;10.219.204.17;5157459;1289364;16265
sdc;10.220.128.17;3684223;921055;22769
sde;10.220.202.17;3692169;923042;22720
sdj;10.220.203.17;3699170;924792;22677
Sdm;10.220.204.17;3697865;924466;22685

mlx5_0;sde;2968368;742092;28260
mlx4_0;sdd;3325645;831411;25224
mlx5_0;sdc;3023466;755866;27745

4.4.0_rc2_3e27c920
sdc;10.218.128.17;5291495;1322873;15853
sde;10.218.202.17;4966024;1241506;16892
sdh;10.218.203.17;4980471;1245117;16843
sdk;10.218.204.17;4966612;1241653;16890
sdd;10.219.128.17;5060084;1265021;16578
sdf;10.219.202.17;5065278;1266319;16561
sdi;10.219.203.17;5047600;1261900;16619
sdl;10.219.204.17;5036992;1259248;16654
sdn;10.220.128.17;3775081;943770;22221
sdg;10.220.202.17;3758336;939584;22320
sdj;10.220.203.17;3792832;948208;22117
Sdm;10.220.204.17;3771516;942879;22242

Mlx4_0;sde;4648715;1162178;18045  ~73% cpu ib_srpt_compl
Mlx5_0;sdd;3476566;869141;24129 ~80% cpu ib_srpt_compl
mlx5_0;sdc;3492343;873085;24020

4.4.0_rc2_ab46db0a
sdc;10.218.128.17;3792146;948036;22121
sdf;10.218.202.17;3738405;934601;22439
sdj;10.218.203.17;3764239;941059;22285
sdl;10.218.204.17;3785302;946325;22161
sdd;10.219.128.17;3762382;940595;22296
sdg;10.219.202.17;3765760;941440;22276
sdi;10.219.203.17;3873751;968437;21655
sdm;10.219.204.17;3769483;942370;22254
sde;10.220.128.17;5022517;1255629;16702
sdh;10.220.202.17;5018911;1254727;16714
sdk;10.220.203.17;5037295;1259323;16653
Sdn;10.220.204.17;5033064;1258266;16667

mlx4_0;sde;4635358;1158839;18097
mlx5_0;sdd;3459077;864769;24251
mlx5_0;sdc;3465650;866412;24205

4.5.0_rc3_1aaa57f5_00399

sdc;10.218.128.17;4627942;1156985;18126
sdf;10.218.202.17;4590963;1147740;18272
sdk;10.218.203.17;4564980;1141245;18376
sdn;10.218.204.17;4571946;1142986;18348
sdd;10.219.128.17;4591717;1147929;18269
sdi;10.219.202.17;4505644;1126411;18618
sdg;10.219.203.17;4562001;1140500;18388
sdl;10.219.204.17;4583187;1145796;18303
sde;10.220.128.17;5511568;1377892;15220
sdh;10.220.202.17;5515555;1378888;15209
sdj;10.220.203.17;5609983;1402495;14953
sdm;10.220.204.17;5509035;1377258;15227

Mlx5_0;sde;3593013;898253;23347 100% CPU kworker/u69:2
Mlx5_0;sdd;3588555;897138;23376 100% CPU kworker/u69:2
Mlx4_0;sdc;3525662;881415;23793 100% CPU kworker/u68:0

4.5.0_rc5_7861728d_00001
sdc;10.218.128.17;3747591;936897;22384
sdf;10.218.202.17;3750607;937651;22366
sdh;10.218.203.17;3750439;937609;22367
sdn;10.218.204.17;3771008;942752;22245
sde;10.219.128.17;3867678;966919;21689
sdg;10.219.202.17;3781889;945472;22181
sdk;10.219.203.17;3791804;947951;22123
sdl;10.219.204.17;3795406;948851;22102
sdd;10.220.128.17;5039110;1259777;16647
sdi;10.220.202.17;4992921;1248230;16801
sdj;10.220.203.17;5015610;1253902;16725
Sdm;10.220.204.17;5087087;1271771;16490

Mlx5_0;sde;2930722;732680;28623 ~98% CPU kworker/u69:0
Mlx5_0;sdd;2910891;727722;28818 ~98% CPU kworker/u69:0
Mlx4_0;sdc;3263668;815917;25703 ~98% CPU kworker/u68:0

4.5.0_rc5_f81bf458_00018
sdb;10.218.128.17;5023720;1255930;16698
sde;10.218.202.17;5016809;1254202;16721
sdj;10.218.203.17;5021915;1255478;16704
sdk;10.218.204.17;5021314;1255328;16706
sdc;10.219.128.17;4984318;1246079;16830
sdf;10.219.202.17;4986096;1246524;16824
sdh;10.219.203.17;5043958;1260989;16631
sdm;10.219.204.17;5032460;1258115;16669
sdd;10.220.128.17;3736740;934185;22449
sdg;10.220.202.17;3728767;932191;22497
sdi;10.220.203.17;3752117;938029;22357
Sdl;10.220.204.17;3763901;940975;22287

Srpt keeps crashing couldn't test

4.5.0_rc5_5adabdd1_00023
Sdc;10.218.128.17;3726448;931612;22511 ~97% CPU kworker/u69:4
sdf;10.218.202.17;3750271;937567;22368
sdi;10.218.203.17;3749266;937316;22374
sdj;10.218.204.17;3798844;949711;22082
sde;10.219.128.17;3759852;939963;22311 ~97% CPU kworker/u69:4
sdg;10.219.202.17;3772534;943133;22236
sdl;10.219.203.17;3769483;942370;22254
sdn;10.219.204.17;3790604;947651;22130
sdd;10.220.128.17;5171130;1292782;16222 ~96% CPU kworker/u68:3
sdh;10.220.202.17;5105354;1276338;16431
sdk;10.220.203.17;4995300;1248825;16793
sdm;10.220.204.17;4959564;1239891;16914

Srpt crashes

4.5.0_rc5_07b63196_00027
sdb;10.218.128.17;3606142;901535;23262
sdg;10.218.202.17;3570988;892747;23491
sdf;10.218.203.17;3576011;894002;23458
sdk;10.218.204.17;3558113;889528;23576
sdc;10.219.128.17;3577384;894346;23449
sde;10.219.202.17;3575401;893850;23462
sdj;10.219.203.17;3567798;891949;23512
sdl;10.219.204.17;3584262;896065;23404
sdd;10.220.128.17;4430680;1107670;18933
sdh;10.220.202.17;4488286;1122071;18690
sdi;10.220.203.17;4487326;1121831;18694
sdm;10.220.204.17;4441236;1110309;18888

Srpt crashes

4.5.0_rc5_5e47f198_00036
sdb;10.218.128.17;3519597;879899;23834
sdi;10.218.202.17;3512229;878057;23884
sdh;10.218.203.17;3518563;879640;23841
sdk;10.218.204.17;3582119;895529;23418
sdd;10.219.128.17;3550883;887720;23624
sdj;10.219.202.17;3558415;889603;23574
sde;10.219.203.17;3552086;888021;23616
sdl;10.219.204.17;3579521;894880;23435
sdc;10.220.128.17;4532912;1133228;18506
sdf;10.220.202.17;4558035;1139508;18404
sdg;10.220.203.17;4601035;1150258;18232
sdm;10.220.204.17;4548150;1137037;18444

srpt crashes

4.6.2 vanilla default config
sde;10.218.128.17;3431063;857765;24449
sdf;10.218.202.17;3360685;840171;24961
sdi;10.218.203.17;3355174;838793;25002
sdm;10.218.204.17;3360955;840238;24959
sdd;10.219.128.17;3337288;834322;25136
sdh;10.219.202.17;3327492;831873;25210
sdj;10.219.203.17;3380867;845216;24812
sdk;10.219.204.17;3418340;854585;24540
sdc;10.220.128.17;4668377;1167094;17969
sdg;10.220.202.17;4716675;1179168;17785
sdl;10.220.203.17;4675663;1168915;17941
sdn;10.220.204.17;4631519;1157879;18112

Mlx5_0;sde;3390021;847505;24745 ~98% CPU kworker/u69:3
Mlx5_0;sdd;3207512;801878;26153 ~98% CPU kworker/u69:3
Mlx4_0;sdc;2998072;749518;27980 ~98% CPU kworker/u68:0

4.7.0_rc3_5edb5649
sdc;10.218.128.17;3260244;815061;25730
sdg;10.218.202.17;3405988;851497;24629
sdh;10.218.203.17;3307419;826854;25363
sdm;10.218.204.17;3430502;857625;24453
sdi;10.219.128.17;3544282;886070;23668
sdj;10.219.202.17;3412083;853020;24585
sdk;10.219.203.17;3422385;855596;24511
sdl;10.219.204.17;3444164;861041;24356
sdb;10.220.128.17;4803646;1200911;17463
sdd;10.220.202.17;4832982;1208245;17357
sde;10.220.203.17;4809430;1202357;17442
sdf;10.220.204.17;4808878;1202219;17444

mlx5_0;sdd;2986864;746716;28085
mlx5_0;sdc;2963648;740912;28305
mlx4_0;sdb;3317228;829307;25288

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Tue, Jun 21, 2016 at 8:50 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> Sagi,
>
> I'm working to implement SRP (I think I got it all working) to test
> some of the commits. I can try TGT afterwards and the commit you
> mention. I haven't been watching the CPU lately, but before when I was
> doing a lot of testing, there wasn't any one thread that was at 100%.
> There are several threads that have high utilization, but none 100%
> and there is plenty of CPU capacity available (32 cores). I can
> capture some of that data if it is helpful. I did test 4.7_rc3 on
> Friday, but it didn't change much, is that "new" enough?
>
> 4.7.0_rc3_5edb5649
> sdc;10.218.128.17;3260244;815061;25730
> sdg;10.218.202.17;3405988;851497;24629
> sdh;10.218.203.17;3307419;826854;25363
> sdm;10.218.204.17;3430502;857625;24453
> sdi;10.219.128.17;3544282;886070;23668
> sdj;10.219.202.17;3412083;853020;24585
> sdk;10.219.203.17;3422385;855596;24511
> sdl;10.219.204.17;3444164;861041;24356
> sdb;10.220.128.17;4803646;1200911;17463
> sdd;10.220.202.17;4832982;1208245;17357
> sde;10.220.203.17;4809430;1202357;17442
> sdf;10.220.204.17;4808878;1202219;17444
>
> Thanks for the suggestions, I'll work to get some of the requested
> data back to you guys quickly.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Tue, Jun 21, 2016 at 7:08 AM, Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hey Robert,
>>
>>> I narrowed the performance degradation to this series
>>> 7861728..5e47f19, but while trying to bisect it, the changes were
>>> erratic between each commit that I could not figure out exactly which
>>> introduced the issue. If someone could give me some pointers on what
>>> to do, I can keep trying to dig through this.
>>
>>
>> This bisection brings suspects:
>>
>> e3416ab2d156 iser-target: Kill the ->isert_cmd back pointer in struct
>> iser_tx_desc
>> d1ca2ed7dcf8 iser-target: Kill struct isert_rdma_wr
>> 9679cc51eb13 iser-target: Convert to new CQ API
>> 5adabdd122e4 iser-target: Split and properly type the login buffer
>> ed1083b251f0 iser-target: Remove ISER_RECV_DATA_SEG_LEN
>> 26c7b673db57 iser-target: Remove impossible condition from isert_wait_conn
>> 69c48846f1c7 iser-target: Remove redundant wait in release_conn
>> 6d1fba0c2cc7 iser-target: Rework connection termination
>> f81bf458208e iser-target: Separate flows for np listeners and connections
>> cma events
>> aea92980601f iser-target: Add new state ISER_CONN_BOUND to isert_conn
>> b89a7c25462b iser-target: Fix identification of login rx descriptor type
>>
>> However I don't really see performance implications in these patches,
>> not to mention something that would affect on ConnectIB...
>>
>> Given that your bisection brings up target side patches, I have
>> a couple questions:
>>
>> 1. Are the CPU usage in the target side at 100%, or the initiator side
>> is the bottleneck?
>>
>> 2. Would it be possible to use another target implementation? TGT maybe?
>>
>> 3. Can you try testing right before 9679cc51eb13? This is a patch that
>> involves data-plane.
>>
>> 4. Can you try the latest upstream kernel? The iser target code uses
>> a generic data-transfer library and I'm interested in knowing what is
>> the status there.
>>
>> Cheers,
>> Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
