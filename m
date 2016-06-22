From: Sagi Grimberg <sagi@lightbits.io>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Wed, 22 Jun 2016 19:21:47 +0300
Message-ID: <576ABB1B.4020509@grimberg.me>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
 <5756B7D2.5040009@mellanox.com>
 <CAANLjFq4CoOSbng=aPHiSsFB=1HMSwAhhLiCjt+88dzz24OT9w@mail.gmail.com>
 <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow@mail.gmail.com>
 <57582336.10407@mellanox.com>
 <CAANLjFrLK-ZVP5XX3TnkAMz+7_pd6qc+c88mbF4vF9DQ+F5U=A@mail.gmail.com>
 <CAANLjFrv-0VArTEkgqbrhzFjn1fg_egpCJuQZnAurVrHjbL_qA@mail.gmail.com>
 <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw@mail.gmail.com>
 <57693C6A.3020805@gmail.com>
 <CAANLjFpUyAYB+ZzMwFKBpa4yLmALPzcRGJX1kExVrLARZmZRkA@mail.gmail.com>
 <CAANLjFpeL0AkuGW-q5Bmm-dff0UqFOM_sAOaG7=vyqmwnOoTcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37448 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbcFVQVx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 12:21:53 -0400
Received: by mail-wm0-f52.google.com with SMTP id a66so13436597wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2016 09:21:52 -0700 (PDT)
In-Reply-To: <CAANLjFpeL0AkuGW-q5Bmm-dff0UqFOM_sAOaG7=vyqmwnOoTcQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, Sagi Grimberg <sagigrim@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>

Let me see if I get this correct:

> 4.5.0_rc3_1aaa57f5_00399
>
> sdc;10.218.128.17;4627942;1156985;18126
> sdf;10.218.202.17;4590963;1147740;18272
> sdk;10.218.203.17;4564980;1141245;18376
> sdn;10.218.204.17;4571946;1142986;18348
> sdd;10.219.128.17;4591717;1147929;18269
> sdi;10.219.202.17;4505644;1126411;18618
> sdg;10.219.203.17;4562001;1140500;18388
> sdl;10.219.204.17;4583187;1145796;18303
> sde;10.220.128.17;5511568;1377892;15220
> sdh;10.220.202.17;5515555;1378888;15209
> sdj;10.220.203.17;5609983;1402495;14953
> sdm;10.220.204.17;5509035;1377258;15227

In 1aaa57f5 you get on CIB ~115K IOPs per sd device
and on CX3 you get around 140K IOPs per sd device.

>
> Mlx5_0;sde;3593013;898253;23347 100% CPU kworker/u69:2
> Mlx5_0;sdd;3588555;897138;23376 100% CPU kworker/u69:2
> Mlx4_0;sdc;3525662;881415;23793 100% CPU kworker/u68:0

Is this on the host or the target?

> 4.5.0_rc5_7861728d_00001
> sdc;10.218.128.17;3747591;936897;22384
> sdf;10.218.202.17;3750607;937651;22366
> sdh;10.218.203.17;3750439;937609;22367
> sdn;10.218.204.17;3771008;942752;22245
> sde;10.219.128.17;3867678;966919;21689
> sdg;10.219.202.17;3781889;945472;22181
> sdk;10.219.203.17;3791804;947951;22123
> sdl;10.219.204.17;3795406;948851;22102
> sdd;10.220.128.17;5039110;1259777;16647
> sdi;10.220.202.17;4992921;1248230;16801
> sdj;10.220.203.17;5015610;1253902;16725
> Sdm;10.220.204.17;5087087;1271771;16490

In 7861728d you get on CIB ~95K IOPs per sd device
and on CX3 you get around 125K IOPs per sd device.

I don't see any difference in the code around iser/isert,
in fact, I don't see any commit in drivers/infiniband


>
> Mlx5_0;sde;2930722;732680;28623 ~98% CPU kworker/u69:0
> Mlx5_0;sdd;2910891;727722;28818 ~98% CPU kworker/u69:0
> Mlx4_0;sdc;3263668;815917;25703 ~98% CPU kworker/u68:0

Again, host or target?

> 4.5.0_rc5_f81bf458_00018
> sdb;10.218.128.17;5023720;1255930;16698
> sde;10.218.202.17;5016809;1254202;16721
> sdj;10.218.203.17;5021915;1255478;16704
> sdk;10.218.204.17;5021314;1255328;16706
> sdc;10.219.128.17;4984318;1246079;16830
> sdf;10.219.202.17;4986096;1246524;16824
> sdh;10.219.203.17;5043958;1260989;16631
> sdm;10.219.204.17;5032460;1258115;16669
> sdd;10.220.128.17;3736740;934185;22449
> sdg;10.220.202.17;3728767;932191;22497
> sdi;10.220.203.17;3752117;938029;22357
> Sdl;10.220.204.17;3763901;940975;22287

In f81bf458 you get on CIB ~125K IOPs per sd device
and on CX3 you get around 93K IOPs per sd device which
is the other way around? CIB is better than CX3?

The commits in this gap are:
f81bf458208e iser-target: Separate flows for np listeners and 
connections cma events
aea92980601f iser-target: Add new state ISER_CONN_BOUND to isert_conn
b89a7c25462b iser-target: Fix identification of login rx descriptor type

None of those should affect the data-path.

>
> Srpt keeps crashing couldn't test
>
> 4.5.0_rc5_5adabdd1_00023
> Sdc;10.218.128.17;3726448;931612;22511 ~97% CPU kworker/u69:4
> sdf;10.218.202.17;3750271;937567;22368
> sdi;10.218.203.17;3749266;937316;22374
> sdj;10.218.204.17;3798844;949711;22082
> sde;10.219.128.17;3759852;939963;22311 ~97% CPU kworker/u69:4
> sdg;10.219.202.17;3772534;943133;22236
> sdl;10.219.203.17;3769483;942370;22254
> sdn;10.219.204.17;3790604;947651;22130
> sdd;10.220.128.17;5171130;1292782;16222 ~96% CPU kworker/u68:3
> sdh;10.220.202.17;5105354;1276338;16431
> sdk;10.220.203.17;4995300;1248825;16793
> sdm;10.220.204.17;4959564;1239891;16914

In 5adabdd1 you get on CIB ~94K IOPs per sd device
and on CX3 you get around 130K IOPs per sd device
which means you flipped again (very strange).

The commits in this gap are:
5adabdd122e4 iser-target: Split and properly type the login buffer
ed1083b251f0 iser-target: Remove ISER_RECV_DATA_SEG_LEN
26c7b673db57 iser-target: Remove impossible condition from isert_wait_conn
69c48846f1c7 iser-target: Remove redundant wait in release_conn
6d1fba0c2cc7 iser-target: Rework connection termination

Again, none are suspected to implicate the data-plane.

> Srpt crashes
>
> 4.5.0_rc5_07b63196_00027
> sdb;10.218.128.17;3606142;901535;23262
> sdg;10.218.202.17;3570988;892747;23491
> sdf;10.218.203.17;3576011;894002;23458
> sdk;10.218.204.17;3558113;889528;23576
> sdc;10.219.128.17;3577384;894346;23449
> sde;10.219.202.17;3575401;893850;23462
> sdj;10.219.203.17;3567798;891949;23512
> sdl;10.219.204.17;3584262;896065;23404
> sdd;10.220.128.17;4430680;1107670;18933
> sdh;10.220.202.17;4488286;1122071;18690
> sdi;10.220.203.17;4487326;1121831;18694
> sdm;10.220.204.17;4441236;1110309;18888

In 5adabdd1 you get on CIB ~89K IOPs per sd device
and on CX3 you get around 112K IOPs per sd device

The commits in this gap are:
e3416ab2d156 iser-target: Kill the ->isert_cmd back pointer in struct 
iser_tx_desc
d1ca2ed7dcf8 iser-target: Kill struct isert_rdma_wr
9679cc51eb13 iser-target: Convert to new CQ API

Which do effect the data-path, but nothing that can explain
a specific CIB issue. Moreover, the perf drop happened before that.

> Srpt crashes
>
> 4.5.0_rc5_5e47f198_00036
> sdb;10.218.128.17;3519597;879899;23834
> sdi;10.218.202.17;3512229;878057;23884
> sdh;10.218.203.17;3518563;879640;23841
> sdk;10.218.204.17;3582119;895529;23418
> sdd;10.219.128.17;3550883;887720;23624
> sdj;10.219.202.17;3558415;889603;23574
> sde;10.219.203.17;3552086;888021;23616
> sdl;10.219.204.17;3579521;894880;23435
> sdc;10.220.128.17;4532912;1133228;18506
> sdf;10.220.202.17;4558035;1139508;18404
> sdg;10.220.203.17;4601035;1150258;18232
> sdm;10.220.204.17;4548150;1137037;18444

Same results, and no commit added so makes sense.

> srpt crashes
>
> 4.6.2 vanilla default config
> sde;10.218.128.17;3431063;857765;24449
> sdf;10.218.202.17;3360685;840171;24961
> sdi;10.218.203.17;3355174;838793;25002
> sdm;10.218.204.17;3360955;840238;24959
> sdd;10.219.128.17;3337288;834322;25136
> sdh;10.219.202.17;3327492;831873;25210
> sdj;10.219.203.17;3380867;845216;24812
> sdk;10.219.204.17;3418340;854585;24540
> sdc;10.220.128.17;4668377;1167094;17969
> sdg;10.220.202.17;4716675;1179168;17785
> sdl;10.220.203.17;4675663;1168915;17941
> sdn;10.220.204.17;4631519;1157879;18112
>
> Mlx5_0;sde;3390021;847505;24745 ~98% CPU kworker/u69:3
> Mlx5_0;sdd;3207512;801878;26153 ~98% CPU kworker/u69:3
> Mlx4_0;sdc;2998072;749518;27980 ~98% CPU kworker/u68:0
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


Here there is a new rdma_rw api, which doesn't
make a difference in performance (but no improvement
also).


------------------
So all in all I still don't know what can be the root-cause
here.

You mentioned that you are running fio over a filesystem. Is
it possible to run your tests directly over the block devices? And
can you run the fio with DIRECT-IO?

Also, usually iser, srp and other rdma ULPs are sensitive to
the IRQ assignments of the HCA. An incorrect IRQ affinity assignment
might bring all sorts of noise to performance tests. The normal
practice to get the most out of the HCA is usually to spread the
IRQ assignments linearly on all CPUs
(https://community.mellanox.com/docs/DOC-1483).
Did you perform any steps to spread IRQ interrupts? is irqbalance daemon
on?

It would be good to try and isolate the drop and make sure it
is real and not randomly generated due to some noise in the form of
IRQ assignments.
