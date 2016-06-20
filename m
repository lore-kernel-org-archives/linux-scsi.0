From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Tue, 21 Jun 2016 00:27:55 +0300
Message-ID: <3646a0c9-3f2d-66b8-c4da-c91ca1d01cee@mellanox.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
 <5756B7D2.5040009@mellanox.com>
 <CAANLjFq4CoOSbng=aPHiSsFB=1HMSwAhhLiCjt+88dzz24OT9w@mail.gmail.com>
 <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow@mail.gmail.com>
 <57582336.10407@mellanox.com>
 <CAANLjFrLK-ZVP5XX3TnkAMz+7_pd6qc+c88mbF4vF9DQ+F5U=A@mail.gmail.com>
 <CAANLjFrv-0VArTEkgqbrhzFjn1fg_egpCJuQZnAurVrHjbL_qA@mail.gmail.com>
 <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Did you see this kind of regression in SRP ? or with some other target 
(e.g TGT) ?
Trying to understand if it's a ULP issue or LLD...

On 6/20/2016 6:23 PM, Robert LeBlanc wrote:
> Adding linux-scsi
>
> This last week I tried to figure out where a 10-15% decrease in
> performance showed up between 4.5 and 4.6 using iSER and ConnectX-3
> and Connect-IB cards (10.{218,219}.*.17 are Connect-IB and 10.220.*.17
> are ConnectX-3). To review, straight RDMA transfers between cards
> showed line rate was being achieved, just iSER was not able to achieve
> those same rates for some cards on different kernels.
>
> 4.5 vanilla default config
> sdc;10.218.128.17;3800048;950012;22075
> sdi;10.218.202.17;3757158;939289;22327
> sdg;10.218.203.17;3774062;943515;22227
> sdn;10.218.204.17;3816299;954074;21981
> sdd;10.219.128.17;3821863;955465;21949
> sdf;10.219.202.17;3784106;946026;22168
> sdj;10.219.203.17;3827094;956773;21919
> sdm;10.219.204.17;3788208;947052;22144
> sde;10.220.128.17;5054596;1263649;16596
> sdh;10.220.202.17;5013811;1253452;16731
> sdl;10.220.203.17;5052160;1263040;16604
> sdk;10.220.204.17;4990248;1247562;16810
>
> 4.6 vanilla default config
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
> I narrowed the performance degradation to this series
> 7861728..5e47f19, but while trying to bisect it, the changes were
> erratic between each commit that I could not figure out exactly which
> introduced the issue. If someone could give me some pointers on what
> to do, I can keep trying to dig through this.
>
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
> sdm;10.220.204.17;5087087;1271771;16490
>
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
> sdl;10.220.204.17;3763901;940975;22287
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
>
> While bisecting the kernel, I also stumbled across one that worked
> really well for both adapters which I haven't seen in the release
> kernels.
>
> 4.5.0_rc3_1aaa57f5_00399
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
>
> Here the ConnectX-3 card is performing perfectly while the Connect-IB
> card still has some room for improvement.
>
> I'd like to get to the bottom of why I'm not seeing the same
> performance out of the newer kernels, but I just don't understand the
> code. I've tried to do what I can in narrowing down where major
> changes happened in the kernel to cause these changes in hopes that it
> would help someone on the list. If there is anything I can do to help
> out, please let me know.
>
> Thank you,
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Fri, Jun 10, 2016 at 3:36 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> I bisected the kernel and it looks like the performance of the
>> Connect-IB card goes down and the performance of the ConnectX-3 card
>> goes up with this commit (but I'm not sure why this would cause this):
>>
>> ab46db0a3325a064bb24e826b12995d157565efb is the first bad commit
>> commit ab46db0a3325a064bb24e826b12995d157565efb
>> Author: Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Date:   Thu Dec 3 10:06:43 2015 +0100
>>
>>    perf stat: Use perf_evlist__enable in handle_initial_delay
>>
>>    No need to mimic the behaviour of perf_evlist__enable, we can use it
>>    directly.
>>
>>    Signed-off-by: Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>    Tested-by: Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>    Cc: Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>    Cc: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>    Cc: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>    Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
>>    Link: http://lkml.kernel.org/r/1449133606-14429-5-git-send-email-jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>>    Signed-off-by: Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> :040000 040000 67e69893bf6d47b372e08d7089d37a7b9f602fa7
>> b63d9b366f078eabf86f4da3d1cc53ae7434a949 M      tools
>>
>> 4.4.0_rc2_3e27c920
>> sdc;10.218.128.17;5291495;1322873;15853
>> sde;10.218.202.17;4966024;1241506;16892
>> sdh;10.218.203.17;4980471;1245117;16843
>> sdk;10.218.204.17;4966612;1241653;16890
>> sdd;10.219.128.17;5060084;1265021;16578
>> sdf;10.219.202.17;5065278;1266319;16561
>> sdi;10.219.203.17;5047600;1261900;16619
>> sdl;10.219.204.17;5036992;1259248;16654
>> sdn;10.220.128.17;3775081;943770;22221
>> sdg;10.220.202.17;3758336;939584;22320
>> sdj;10.220.203.17;3792832;948208;22117
>> sdm;10.220.204.17;3771516;942879;22242
>>
>> 4.4.0_rc2_ab46db0a
>> sdc;10.218.128.17;3792146;948036;22121
>> sdf;10.218.202.17;3738405;934601;22439
>> sdj;10.218.203.17;3764239;941059;22285
>> sdl;10.218.204.17;3785302;946325;22161
>> sdd;10.219.128.17;3762382;940595;22296
>> sdg;10.219.202.17;3765760;941440;22276
>> sdi;10.219.203.17;3873751;968437;21655
>> sdm;10.219.204.17;3769483;942370;22254
>> sde;10.220.128.17;5022517;1255629;16702
>> sdh;10.220.202.17;5018911;1254727;16714
>> sdk;10.220.203.17;5037295;1259323;16653
>> sdn;10.220.204.17;5033064;1258266;16667
>>
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>>
>> On Wed, Jun 8, 2016 at 9:33 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>> With 4.1.15, the C-IB card gets about 1.15 MIOPs, while the CX3 gets
>>> about 0.99 MIOPs. But starting with the 4.4.4 kernel, the C-IB card
>>> drops to 0.96 MIOPs and the CX3 card jumps to 1.25 MIOPs. In the 4.6.0
>>> kernel, both cards drop, the C-IB to 0.82 MIOPs and the CX3 to 1.15
>>> MIOPs. I confirmed this morning that the card order was swapped on the
>>> 4.6.0 kernel and it was not different ports of the C-IB performing
>>> differently, but different cards.
>>>
>>> Given the limitations of the PCIe 8x port for the CX3, I think 1.25
>>> MIOPs is about the best we can do there. In summary, the performance
>>> of the C-IB card drops after 4.1.15 and gets progressively worse as
>>> the kernels increase. The CX3 card peaks at the 4.4.4 kernel and
>>> degrades a bit on the 4.6.0 kernel.
>>>
>>> Increasing the IO depth by adding jobs does not improve performance,
>>> it actually decreases performance. Based on an average of 4 runs at
>>> each job number from 1-80, the Goldilocks zone is 31-57 jobs where the
>>> difference in performance is less than 1%.
>>>
>>> Similarly, increasing block request size does not really change the
>>> figures to reach line speed.
>>>
>>> Here is the output of the 4.6.0 kernel with 4M bs:
>>> sdc;10.218.128.17;3354638;819;25006
>>> sdf;10.218.202.17;3376920;824;24841
>>> sdm;10.218.203.17;3367431;822;24911
>>> sdk;10.218.204.17;3378960;824;24826
>>> sde;10.219.128.17;3366350;821;24919
>>> sdl;10.219.202.17;3379641;825;24821
>>> sdg;10.219.203.17;3391254;827;24736
>>> sdn;10.219.204.17;3401706;830;24660
>>> sdd;10.220.128.17;4597505;1122;18246
>>> sdi;10.220.202.17;4594231;1121;18259
>>> sdj;10.220.203.17;4667598;1139;17972
>>> sdh;10.220.204.17;4628197;1129;18125
>>>
>>> The CPU on the target is a kworker thread at 96%, but no single
>>> processor over 15%. The initiator has low fio CPU utilization (<10%)
>>> for each job and no single CPU over 22% utilized.
>>>
>>> I have tried manually spreading the IRQ affinity over the processors
>>> of the respective NUMA nodes and there was no noticeable change in
>>> performance when doing so.
>>>
>>> Loading ib_iser on the initiator shows maybe a slight increase in performance:
>>>
>>> sdc;10.218.128.17;3396885;849221;24695
>>> sdf;10.218.202.17;3429240;857310;24462
>>> sdi;10.218.203.17;3454234;863558;24285
>>> sdm;10.218.204.17;3391666;847916;24733
>>> sde;10.219.128.17;3403914;850978;24644
>>> sdh;10.219.202.17;3491034;872758;24029
>>> sdk;10.219.203.17;3390569;847642;24741
>>> sdl;10.219.204.17;3498898;874724;23975
>>> sdd;10.220.128.17;4664743;1166185;17983
>>> sdg;10.220.202.17;4624880;1156220;18138
>>> sdj;10.220.203.17;4616227;1154056;18172
>>> sdn;10.220.204.17;4619786;1154946;18158
>>>
>>> I'd like to see the C-IB card at 1.25+ MIOPs (I know that the target
>>> can do that performance and we were limited on the CX3 by the PCIe bus
>>> which isn't an issue with the 16x C-IB card for a single port).
>>> Although the loss of performance in the CX3 card is concerning, I'm
>>> mostly focused on the C-IB card at the moment. I will probably start
>>> bisecting 4.1.15 to 4.4.4 to see if I can identify when the
>>> performance of the C-IB card degrades.
>>> ----------------
>>> Robert LeBlanc
>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>
>>>
>>> On Wed, Jun 8, 2016 at 7:52 AM, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>
>>>>
>>>> On 6/8/2016 1:37 AM, Robert LeBlanc wrote:
>>>>>
>>>>> On the 4.1.15 kernel:
>>>>> sdc;10.218.128.17;3971878;992969;21120
>>>>> sdd;10.218.202.17;3967745;991936;21142
>>>>> sdg;10.218.203.17;3938128;984532;21301
>>>>> sdk;10.218.204.17;3952602;988150;21223
>>>>> sdn;10.219.128.17;4615719;1153929;18174
>>>>> sdf;10.219.202.17;4622331;1155582;18148
>>>>> sdi;10.219.203.17;4602297;1150574;18227
>>>>> sdl;10.219.204.17;4565477;1141369;18374
>>>>> sde;10.220.128.17;4594986;1148746;18256
>>>>> sdh;10.220.202.17;4590209;1147552;18275
>>>>> sdj;10.220.203.17;4599017;1149754;18240
>>>>> sdm;10.220.204.17;4610898;1152724;18193
>>>>>
>>>>> On the 4.6.0 kernel:
>>>>> sdc;10.218.128.17;3239219;809804;25897
>>>>> sdf;10.218.202.17;3321300;830325;25257
>>>>> sdm;10.218.203.17;3339015;834753;25123
>>>>> sdk;10.218.204.17;3637573;909393;23061
>>>>> sde;10.219.128.17;3325777;831444;25223
>>>>> sdl;10.219.202.17;3305464;826366;25378
>>>>> sdg;10.219.203.17;3304032;826008;25389
>>>>> sdn;10.219.204.17;3330001;832500;25191
>>>>> sdd;10.220.128.17;4624370;1156092;18140
>>>>> sdi;10.220.202.17;4619277;1154819;18160
>>>>> sdj;10.220.203.17;4610138;1152534;18196
>>>>> sdh;10.220.204.17;4586445;1146611;18290
>>>>>
>>>>> It seems that there is a lot of changes between the kernels. I had
>>>>> these kernels already on the box and I can bisect them if you think it
>>>>> would help. It is really odd that port 2 on the Connect-IB card did
>>>>> better than port 1 on the 4.6.0 kernel.
>>>>> ----------------
>>>>> Robert LeBlanc
>>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>
>>>>
>>>> so in these kernels you get better performance with the C-IB than CX3 ?
>>>> we need to find the bottleneck.
>>>> Can you increase the iodepth and/or block size to see if we can reach the
>>>> wire speed.
>>>> another try is to load ib_iser with always_register=N.
>>>>
>>>> what is the cpu utilzation in both initiator/target ?
>>>> did you spread the irq affinity ?
>>>>
>>>>
>>>>>
>>>>>
>>>>> On Tue, Jun 7, 2016 at 10:48 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
>>>>> wrote:
>>>>>>
>>>>>> The target is LIO (same kernel) with a 200 GB RAM disk and I'm running
>>>>>> fio as follows:
>>>>>>
>>>>>> fio --rw=read --bs=4K --size=2G --numjobs=40 --name=worker.matt
>>>>>> --group_reporting --minimal |  cut -d';' -f7,8,9
>>>>>>
>>>>>> All of the paths are set the same with noop and nomerges to either 1
>>>>>> or 2 (doesn't make a big difference).
>>>>>>
>>>>>> I started looking into this when the 4.6 kernel wasn't performing as
>>>>>> well as we were able to get the 4.4 kernel to work. I went back to the
>>>>>> 4.4 kernel and I could not replicate the 4+ million IOPs. So I started
>>>>>> breaking down the problem to smaller pieces and found this anomaly.
>>>>>> Since there hasn't been any suggestions up to this point, I'll check
>>>>>> other kernel version to see if it is specific to certain kernels. If
>>>>>> you need more information, please let me know.
>>>>>>
>>>>>> Thanks,
>>>>>> ----------------
>>>>>> Robert LeBlanc
>>>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>>>
>>>>>>
>>>>>> On Tue, Jun 7, 2016 at 6:02 AM, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 6/7/2016 1:36 AM, Robert LeBlanc wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> I'm trying to understand why our Connect-IB card is not performing as
>>>>>>>> well as our ConnectX-3 card. There are 3 ports between the two cards
>>>>>>>> and 12 paths to the iSER target which is a RAM disk.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> <snip>
>>>>>>>
>>>>>>>>
>>>>>>>> When I run fio against each path individually, I get:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> What is the scenario (bs, numjobs, iodepth) for each run ?
>>>>>>> Which target do you use ? backing store ?
>>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> disk;target IP;bandwidth,IOPs,Execution time
>>>>>>>> sdn;10.218.128.17;5053682;1263420;16599
>>>>>>>> sde;10.218.202.17;5032158;1258039;16670
>>>>>>>> sdh;10.218.203.17;4993516;1248379;16799
>>>>>>>> sdk;10.218.204.17;5081848;1270462;16507
>>>>>>>> sdc;10.219.128.17;3750942;937735;22364
>>>>>>>> sdf;10.219.202.17;3746921;936730;22388
>>>>>>>> sdi;10.219.203.17;3873929;968482;21654
>>>>>>>> sdl;10.219.204.17;3841465;960366;21837
>>>>>>>> sdd;10.220.128.17;3760358;940089;22308
>>>>>>>> sdg;10.220.202.17;3866252;966563;21697
>>>>>>>> sdj;10.220.203.17;3757495;939373;22325
>>>>>>>> sdm;10.220.204.17;4064051;1016012;20641
>>>>>>>>
>>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
