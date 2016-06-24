From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Fri, 24 Jun 2016 12:34:01 -0600
Message-ID: <CAANLjFroeeCu6bLkhaanrLZqgpBHagkoKFisOh54+BVXRUue0Q@mail.gmail.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
 <5756B7D2.5040009@mellanox.com> <CAANLjFq4CoOSbng=aPHiSsFB=1HMSwAhhLiCjt+88dzz24OT9w@mail.gmail.com>
 <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow@mail.gmail.com>
 <57582336.10407@mellanox.com> <CAANLjFrLK-ZVP5XX3TnkAMz+7_pd6qc+c88mbF4vF9DQ+F5U=A@mail.gmail.com>
 <CAANLjFrv-0VArTEkgqbrhzFjn1fg_egpCJuQZnAurVrHjbL_qA@mail.gmail.com>
 <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw@mail.gmail.com>
 <57693C6A.3020805@gmail.com> <CAANLjFpUyAYB+ZzMwFKBpa4yLmALPzcRGJX1kExVrLARZmZRkA@mail.gmail.com>
 <CAANLjFpeL0AkuGW-q5Bmm-dff0UqFOM_sAOaG7=vyqmwnOoTcQ@mail.gmail.com>
 <576ABB1B.4020509@grimberg.me> <CAANLjFqp8qStMCtcEjsoprfpD1=qnYguKU5+8rL9pkYwHv4PKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFqp8qStMCtcEjsoprfpD1=qnYguKU5+8rL9pkYwHv4PKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>
Cc: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Sagi,

Here is an example of the different types of tests. This was only on one kernel.

The first two are to set a baseline. The lines starting with buffer is
using fio with direct=0, the lines starting with direct is fio with
direct=1. The lines starting with block is fio running against a raw
block deice (technically 40 partitions on a single drive) with
direct=0. I also reduced the tests to only test one path per port
instead of four like before.

# /root/run_path_tests.sh check-paths
#### Test all iSER paths individually ####
4.5.0-rc5-5adabdd1-00023-g5adabdd
buffer;sdc;10.218.128.17;3815778;953944;21984
buffer;sdd;10.219.128.17;3743744;935936;22407
buffer;sde;10.220.128.17;4915392;1228848;17066
direct;sdc;10.218.128.17;876644;219161;95690
direct;sdd;10.219.128.17;881684;220421;95143
direct;sde;10.220.128.17;892215;223053;94020
block;sdc;10.218.128.17;3890459;972614;21562
block;sdd;10.219.128.17;4127642;1031910;20323
block;sde;10.220.128.17;4939705;1234926;16982
# /root/run_path_tests.sh check-paths
#### Test all iSER paths individually ####
4.5.0-rc5-5adabdd1-00023-g5adabdd
buffer;sdc;10.218.128.17;3983572;995893;21058
buffer;sdd;10.219.128.17;3774231;943557;22226
buffer;sde;10.220.128.17;4856204;1214051;17274
direct;sdc;10.218.128.17;875820;218955;95780
direct;sdd;10.219.128.17;884072;221018;94886
direct;sde;10.220.128.17;902486;225621;92950
block;sdc;10.218.128.17;3790433;947608;22131
block;sdd;10.219.128.17;3860025;965006;21732
block;sde;10.220.128.17;4946404;1236601;16959

For the following test, I set the IRQ on the initiator using mlx_tune
-p HIGH_THROUGHPUT with irqbalance disabled.

# /root/run_path_tests.sh check-paths
#### Test all iSER paths individually ####
4.5.0-rc5-5adabdd1-00023-g5adabdd
buffer;sdc;10.218.128.17;3742742;935685;22413
buffer;sdd;10.219.128.17;3786327;946581;22155
buffer;sde;10.220.128.17;5009619;1252404;16745
direct;sdc;10.218.128.17;871942;217985;96206
direct;sdd;10.219.128.17;883467;220866;94951
direct;sde;10.220.128.17;901138;225284;93089
block;sdc;10.218.128.17;3911319;977829;21447
block;sdd;10.219.128.17;3758168;939542;22321
block;sde;10.220.128.17;4968377;1242094;16884

For the following test, I also set the IRQs on the target using
mlx_tune -p HIGH_THROUGHPUT and disabled irqbalance.

# /root/run_path_tests.sh check-paths
#### Test all iSER paths individually ####
4.5.0-rc5-5adabdd1-00023-g5adabdd
buffer;sdc;10.218.128.17;3804357;951089;22050
buffer;sdd;10.219.128.17;3767113;941778;22268
buffer;sde;10.220.128.17;4966612;1241653;16890
direct;sdc;10.218.128.17;879742;219935;95353
direct;sdd;10.219.128.17;886641;221660;94611
direct;sde;10.220.128.17;886857;221714;94588
block;sdc;10.218.128.17;3760864;940216;22305
block;sdd;10.219.128.17;3763564;940891;22289
block;sde;10.220.128.17;4965436;1241359;16894

It seems that mlx_tune marginally helps, but not really providing
anything groundbreaking.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Jun 22, 2016 at 11:46 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> Sagi,
>
> Yes you are understanding the data correctly and what I'm seeing. I
> think you are also seeing the confusion that I've been running into
> trying to figure this out as well. As far as your questions about SRP,
> the performance data is from the initiator and the CPU info is from
> the target (all fio threads on the initiator were low CPU
> utilization).
>
> I spent a good day tweaking the IRQ assignments (spreading IRQs to all
> cores, spreading to all cores on the NUMA node the card is attached
> to, and spreading to all non-hyperthreaded cores on the NUMA node).
> None of these provided any substantial gains/detriments (irqbalance
> was not running). I don't know if there is IRQ steering going on, but
> in some cases with irqbalance not running the IRQs would get pinned
> back to the previous core(s) and I'd have to set them again. I did not
> use the Mellanox scripts, I just did it by hand based on the
> documents/scripts. I also offlined all cores on the second NUMA node
> which didn't help either. I got more performance gains with nomerges
> (1 or 2 provided about the same gain, 2 slightly more) and the queue.
> It seems that something in 1aaa57f5 was going right as both cards
> performed very well without needing any IRQ fudging.
>
> I understand that there are many moving parts to try and figure this
> out, it could be anywhere in the IB drivers, LIO, and even the SCSI
> sub systems, RAM disk implementation or file system. However since the
> performance is bouncing between cards, it seems it is unlikely
> something very common (except when both cards show a loss/gain), but
> as you mentioned, there doesn't seem to be any rhyme or reason to the
> shifts.
>
> I haven't been using the straight block device in these tests, before
> when I did, after one thread read the data, if another read that same
> block it then started reading it from cache invalidating the test. I
> could only saturate the path/port by highly threaded jobs, I may have
> to partition out the disk for block testing. When I ran the tests
> using direct I/O the performance was far lower and harder for me to
> know when I was reaching the theoretical max of the card/links/PCIe. I
> just may have my scripts run the three tests in succession.
>
> Thanks for looking at this. Please let me know what you think would be
> most helpful so that I'm making the best use of your and my time.
>
> Thanks,
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Wed, Jun 22, 2016 at 10:21 AM, Sagi Grimberg <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org> wrote:
>> Let me see if I get this correct:
>>
>>> 4.5.0_rc3_1aaa57f5_00399
>>>
>>> sdc;10.218.128.17;4627942;1156985;18126
>>> sdf;10.218.202.17;4590963;1147740;18272
>>> sdk;10.218.203.17;4564980;1141245;18376
>>> sdn;10.218.204.17;4571946;1142986;18348
>>> sdd;10.219.128.17;4591717;1147929;18269
>>> sdi;10.219.202.17;4505644;1126411;18618
>>> sdg;10.219.203.17;4562001;1140500;18388
>>> sdl;10.219.204.17;4583187;1145796;18303
>>> sde;10.220.128.17;5511568;1377892;15220
>>> sdh;10.220.202.17;5515555;1378888;15209
>>> sdj;10.220.203.17;5609983;1402495;14953
>>> sdm;10.220.204.17;5509035;1377258;15227
>>
>>
>> In 1aaa57f5 you get on CIB ~115K IOPs per sd device
>> and on CX3 you get around 140K IOPs per sd device.
>>
>>>
>>> Mlx5_0;sde;3593013;898253;23347 100% CPU kworker/u69:2
>>> Mlx5_0;sdd;3588555;897138;23376 100% CPU kworker/u69:2
>>> Mlx4_0;sdc;3525662;881415;23793 100% CPU kworker/u68:0
>>
>>
>> Is this on the host or the target?
>>
>>> 4.5.0_rc5_7861728d_00001
>>> sdc;10.218.128.17;3747591;936897;22384
>>> sdf;10.218.202.17;3750607;937651;22366
>>> sdh;10.218.203.17;3750439;937609;22367
>>> sdn;10.218.204.17;3771008;942752;22245
>>> sde;10.219.128.17;3867678;966919;21689
>>> sdg;10.219.202.17;3781889;945472;22181
>>> sdk;10.219.203.17;3791804;947951;22123
>>> sdl;10.219.204.17;3795406;948851;22102
>>> sdd;10.220.128.17;5039110;1259777;16647
>>> sdi;10.220.202.17;4992921;1248230;16801
>>> sdj;10.220.203.17;5015610;1253902;16725
>>> Sdm;10.220.204.17;5087087;1271771;16490
>>
>>
>> In 7861728d you get on CIB ~95K IOPs per sd device
>> and on CX3 you get around 125K IOPs per sd device.
>>
>> I don't see any difference in the code around iser/isert,
>> in fact, I don't see any commit in drivers/infiniband
>>
>>
>>>
>>> Mlx5_0;sde;2930722;732680;28623 ~98% CPU kworker/u69:0
>>> Mlx5_0;sdd;2910891;727722;28818 ~98% CPU kworker/u69:0
>>> Mlx4_0;sdc;3263668;815917;25703 ~98% CPU kworker/u68:0
>>
>>
>> Again, host or target?
>>
>>> 4.5.0_rc5_f81bf458_00018
>>> sdb;10.218.128.17;5023720;1255930;16698
>>> sde;10.218.202.17;5016809;1254202;16721
>>> sdj;10.218.203.17;5021915;1255478;16704
>>> sdk;10.218.204.17;5021314;1255328;16706
>>> sdc;10.219.128.17;4984318;1246079;16830
>>> sdf;10.219.202.17;4986096;1246524;16824
>>> sdh;10.219.203.17;5043958;1260989;16631
>>> sdm;10.219.204.17;5032460;1258115;16669
>>> sdd;10.220.128.17;3736740;934185;22449
>>> sdg;10.220.202.17;3728767;932191;22497
>>> sdi;10.220.203.17;3752117;938029;22357
>>> Sdl;10.220.204.17;3763901;940975;22287
>>
>>
>> In f81bf458 you get on CIB ~125K IOPs per sd device
>> and on CX3 you get around 93K IOPs per sd device which
>> is the other way around? CIB is better than CX3?
>>
>> The commits in this gap are:
>> f81bf458208e iser-target: Separate flows for np listeners and connections
>> cma events
>> aea92980601f iser-target: Add new state ISER_CONN_BOUND to isert_conn
>> b89a7c25462b iser-target: Fix identification of login rx descriptor type
>>
>> None of those should affect the data-path.
>>
>>>
>>> Srpt keeps crashing couldn't test
>>>
>>> 4.5.0_rc5_5adabdd1_00023
>>> Sdc;10.218.128.17;3726448;931612;22511 ~97% CPU kworker/u69:4
>>> sdf;10.218.202.17;3750271;937567;22368
>>> sdi;10.218.203.17;3749266;937316;22374
>>> sdj;10.218.204.17;3798844;949711;22082
>>> sde;10.219.128.17;3759852;939963;22311 ~97% CPU kworker/u69:4
>>> sdg;10.219.202.17;3772534;943133;22236
>>> sdl;10.219.203.17;3769483;942370;22254
>>> sdn;10.219.204.17;3790604;947651;22130
>>> sdd;10.220.128.17;5171130;1292782;16222 ~96% CPU kworker/u68:3
>>> sdh;10.220.202.17;5105354;1276338;16431
>>> sdk;10.220.203.17;4995300;1248825;16793
>>> sdm;10.220.204.17;4959564;1239891;16914
>>
>>
>> In 5adabdd1 you get on CIB ~94K IOPs per sd device
>> and on CX3 you get around 130K IOPs per sd device
>> which means you flipped again (very strange).
>>
>> The commits in this gap are:
>> 5adabdd122e4 iser-target: Split and properly type the login buffer
>> ed1083b251f0 iser-target: Remove ISER_RECV_DATA_SEG_LEN
>> 26c7b673db57 iser-target: Remove impossible condition from isert_wait_conn
>> 69c48846f1c7 iser-target: Remove redundant wait in release_conn
>> 6d1fba0c2cc7 iser-target: Rework connection termination
>>
>> Again, none are suspected to implicate the data-plane.
>>
>>> Srpt crashes
>>>
>>> 4.5.0_rc5_07b63196_00027
>>> sdb;10.218.128.17;3606142;901535;23262
>>> sdg;10.218.202.17;3570988;892747;23491
>>> sdf;10.218.203.17;3576011;894002;23458
>>> sdk;10.218.204.17;3558113;889528;23576
>>> sdc;10.219.128.17;3577384;894346;23449
>>> sde;10.219.202.17;3575401;893850;23462
>>> sdj;10.219.203.17;3567798;891949;23512
>>> sdl;10.219.204.17;3584262;896065;23404
>>> sdd;10.220.128.17;4430680;1107670;18933
>>> sdh;10.220.202.17;4488286;1122071;18690
>>> sdi;10.220.203.17;4487326;1121831;18694
>>> sdm;10.220.204.17;4441236;1110309;18888
>>
>>
>> In 5adabdd1 you get on CIB ~89K IOPs per sd device
>> and on CX3 you get around 112K IOPs per sd device
>>
>> The commits in this gap are:
>> e3416ab2d156 iser-target: Kill the ->isert_cmd back pointer in struct
>> iser_tx_desc
>> d1ca2ed7dcf8 iser-target: Kill struct isert_rdma_wr
>> 9679cc51eb13 iser-target: Convert to new CQ API
>>
>> Which do effect the data-path, but nothing that can explain
>> a specific CIB issue. Moreover, the perf drop happened before that.
>>
>>> Srpt crashes
>>>
>>> 4.5.0_rc5_5e47f198_00036
>>> sdb;10.218.128.17;3519597;879899;23834
>>> sdi;10.218.202.17;3512229;878057;23884
>>> sdh;10.218.203.17;3518563;879640;23841
>>> sdk;10.218.204.17;3582119;895529;23418
>>> sdd;10.219.128.17;3550883;887720;23624
>>> sdj;10.219.202.17;3558415;889603;23574
>>> sde;10.219.203.17;3552086;888021;23616
>>> sdl;10.219.204.17;3579521;894880;23435
>>> sdc;10.220.128.17;4532912;1133228;18506
>>> sdf;10.220.202.17;4558035;1139508;18404
>>> sdg;10.220.203.17;4601035;1150258;18232
>>> sdm;10.220.204.17;4548150;1137037;18444
>>
>>
>> Same results, and no commit added so makes sense.
>>
>>
>>> srpt crashes
>>>
>>> 4.6.2 vanilla default config
>>> sde;10.218.128.17;3431063;857765;24449
>>> sdf;10.218.202.17;3360685;840171;24961
>>> sdi;10.218.203.17;3355174;838793;25002
>>> sdm;10.218.204.17;3360955;840238;24959
>>> sdd;10.219.128.17;3337288;834322;25136
>>> sdh;10.219.202.17;3327492;831873;25210
>>> sdj;10.219.203.17;3380867;845216;24812
>>> sdk;10.219.204.17;3418340;854585;24540
>>> sdc;10.220.128.17;4668377;1167094;17969
>>> sdg;10.220.202.17;4716675;1179168;17785
>>> sdl;10.220.203.17;4675663;1168915;17941
>>> sdn;10.220.204.17;4631519;1157879;18112
>>>
>>> Mlx5_0;sde;3390021;847505;24745 ~98% CPU kworker/u69:3
>>> Mlx5_0;sdd;3207512;801878;26153 ~98% CPU kworker/u69:3
>>> Mlx4_0;sdc;2998072;749518;27980 ~98% CPU kworker/u68:0
>>>
>>> 4.7.0_rc3_5edb5649
>>> sdc;10.218.128.17;3260244;815061;25730
>>> sdg;10.218.202.17;3405988;851497;24629
>>> sdh;10.218.203.17;3307419;826854;25363
>>> sdm;10.218.204.17;3430502;857625;24453
>>> sdi;10.219.128.17;3544282;886070;23668
>>> sdj;10.219.202.17;3412083;853020;24585
>>> sdk;10.219.203.17;3422385;855596;24511
>>> sdl;10.219.204.17;3444164;861041;24356
>>> sdb;10.220.128.17;4803646;1200911;17463
>>> sdd;10.220.202.17;4832982;1208245;17357
>>> sde;10.220.203.17;4809430;1202357;17442
>>> sdf;10.220.204.17;4808878;1202219;17444
>>
>>
>>
>> Here there is a new rdma_rw api, which doesn't
>> make a difference in performance (but no improvement
>> also).
>>
>>
>> ------------------
>> So all in all I still don't know what can be the root-cause
>> here.
>>
>> You mentioned that you are running fio over a filesystem. Is
>> it possible to run your tests directly over the block devices? And
>> can you run the fio with DIRECT-IO?
>>
>> Also, usually iser, srp and other rdma ULPs are sensitive to
>> the IRQ assignments of the HCA. An incorrect IRQ affinity assignment
>> might bring all sorts of noise to performance tests. The normal
>> practice to get the most out of the HCA is usually to spread the
>> IRQ assignments linearly on all CPUs
>> (https://community.mellanox.com/docs/DOC-1483).
>> Did you perform any steps to spread IRQ interrupts? is irqbalance daemon
>> on?
>>
>> It would be good to try and isolate the drop and make sure it
>> is real and not randomly generated due to some noise in the form of
>> IRQ assignments.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
