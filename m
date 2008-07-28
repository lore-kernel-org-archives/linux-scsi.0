From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: aic7xxx: aic7892(B): possible regression in 2.6.26: intermittent
 unexpected busfrees
Date: Mon, 28 Jul 2008 15:19:03 +0200
Message-ID: <488DC747.9060200@gmail.com>
Reply-To: thomas.schorpp@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.251]:64174 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYG1NTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 09:19:11 -0400
Received: by hs-out-0708.google.com with SMTP id 4so612092hsl.5
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2008 06:19:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

hi,

got dozens of intermittent bus-frees in few days with my Cheetah X15 si=
nce upgrading to vanilla release kernel 2.6.26.0

-did not touch the hw
-fsck ok
-smart short/long selftest ok
-temperatures/voltages ok

is this the hot weather, my old adaptec 19160 hba or the on disc contro=
ller dying or have You guys done=20
some "performance" changes in aic7xxx released with 2.6.26 ?

the errors are not reproducable by accessing the same disc sectors belo=
w.

now system backup, then checking cable etc.

tom1:~# zcat /var/log/syslog.1.gz |grep 9243015
tom1:~# zcat /var/log/syslog.2.gz |grep 9243015

(scsi0:A:1:0): Unexpected busfree in Data-in phase
SEQADDR =3D=3D 0x55
sd 0:0:1:0: [sda] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sda, sector 9242887
sd 0:0:1:0: [sda] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sda, sector 9243015

<hdd manufacturer selftest sound hearable, device reset>

tom1:~# grep busfree /var/log/syslog
Jul 28 13:44:35 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
tom1:~# grep busfree /var/log/syslog.0
tom1:~# zcat /var/log/syslog.1.gz |grep busfree
Jul 26 15:19:43 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 15:22:43 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 17:02:37 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 19:15:43 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 19:15:49 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 20:15:44 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 20:15:52 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 20:15:58 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 20:16:07 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 20:16:17 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 20:16:25 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
Jul 26 20:16:32 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
tom1:~#
tom1:~# zcat /var/log/syslog.2.gz |grep busfree
Jul 25 23:56:44 tom1 kernel: (scsi0:A:1:0): Unexpected busfree in Data-=
in phase
tom1:~#
tom1:~# zcat /var/log/syslog.3.gz |grep busfree
tom1:~# zcat /var/log/syslog.4.gz |grep busfree
tom1:~# zcat /var/log/syslog.5.gz |grep busfree
tom1:~# zcat /var/log/syslog.6.gz |grep busfree

ac3dec[4069]: segfault at 0 ip 40186c sp 7fff8d48ce40 error 4 in ac3dec=
[400000+b000]
scsi 0:0:6:0: Processor         HP       C2520A           3503 PQ: 0 AN=
SI: 2
 target0:0:6: Beginning Domain Validation
 target0:0:6: Ending Domain Validation
scsi 0:0:6:0: Attached scsi generic sg2 type 3
tom1:~#
tom1:~#
tom1:~# lsscsi -lv
[0:0:1:0]    disk    SEAGATE  ST336752LW       0003  /dev/sda
  state=3Drunning queue_depth=3D32 scsi_level=3D4 type=3D0 device_block=
ed=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/0:0:1:0  [/sys/devices/pci0000:00/0000:00:=
06.0/host0/target0:0:1/0:0:1:0]
[0:0:6:0]    process HP       C2520A           3503  -
  state=3Drunning queue_depth=3D2 scsi_level=3D3 type=3D3 device_blocke=
d=3D0 timeout=3D0
  dir: /sys/bus/scsi/devices/0:0:6:0  [/sys/devices/pci0000:00/0000:00:=
06.0/host0/target0:0:6/0:0:6:0]
[3:0:0:0]    cd/dvd  TOSHIBA  ODD-DVD SD-M1802 1051  /dev/scd0
  state=3Drunning queue_depth=3D1 scsi_level=3D6 type=3D5 device_blocke=
d=3D0 timeout=3D0
  dir: /sys/bus/scsi/devices/3:0:0:0  [/sys/devices/pci0000:00/0000:00:=
0d.0/host3/target3:0:0/3:0:0:0]
tom1:~#
tom1:~#
tom1:~# scsiinfo -avv /dev/sda
 Scsiinfo version 1.7(eowmob)

Inquiry command
---------------
Relative Address                   0
Wide bus 32                        0
Wide bus 16                        1
Synchronous neg.                   1
Linked Commands                    1
Command Queueing                   1
SftRe                              0
Device Type                        0
Peripheral Qualifier               0
Removable?                         0
Device Type Modifier               0
ISO Version                        0
ECMA Version                       0
ANSI Version                       3
AENC                               0
TrmIOP                             0
Response Data Format               2
Vendor:                    SEAGATE
Product:                   ST336752LW
Revision level:            00033ET03GB5

Serial Number '3ET03GB500007212EE51'
Data from Rigid Disk Drive Geometry Page
----------------------------------------
Number of cylinders                18496
Number of heads                    8
Starting write precomp             0
Starting reduced current           0
Drive step rate                    0
Landing Zone Cylinder              0
RPL                                0
Rotational Offset                  0
Rotational Rate                    14996

Data from Caching Page
----------------------
Write Cache                        1
Read Cache                         1
Prefetch units                     0
Demand Read Retention Priority     0
Demand Write Retention Priority    0
Disable Pre-fetch Transfer Length  65535
Minimum Pre-fetch                  0
Maximum Pre-fetch                  65535
Maximum Pre-fetch Ceiling          65535

Data from Format Device Page
----------------------------
Removable Medium                   0
Supports Hard Sectoring            1
Supports Soft Sectoring            0
Addresses assigned by surface      0
Tracks per Zone                    9960
Alternate sectors per zone         0
Alternate tracks per zone          51
Alternate tracks per lun           0
Sectors per track                  488
Bytes per sector                   512
Interleave                         1
Track skew factor                  152
Cylinder skew factor               84

Data from Error Recovery Page
-----------------------------
AWRE                               1
ARRE                               1
TB                                 0
RC                                 0
EER                                0
PER                                0
DTE                                0
DCR                                0
Read Retry Count                   11
Correction Span                    240
Head Offset Count                  0
Data Strobe Offset Count           0
Write Retry Count                  5
Recovery Time Limit                65535

Data from Control Page
----------------------
RLEC                               0
QErr                               0
DQue                               0
EECA                               0
RAENP                              0
UUAENP                             0
EAENP                              0
Queue Algorithm Modifier           0
Ready AEN Holdoff Period           0

Data from Disconnect-Reconnect Page
-----------------------------------
Buffer full ratio                  128
Buffer empty ratio                 128
Bus Inactivity Limit               10
Disconnect Time Limit              0
Connect Time Limit                 0
Maximum Burst Size                 0
DTDC                               0x0

Data from Defect Lists
----------------------
506 entries in manufacturer table.
=46ormat is: bytes from index [Cyl:Head:Off]
Offset -1 marks whole track as bad.

     149:5:34136     150:5:34136     151:5:34136     152:5:34136     15=
3:5:34136
     154:5:34149     155:5:34147     156:5:34136     157:5:34136     15=
8:5:34136
     159:5:34136     160:5:34136    300:0:288905    373:5:281588    373=
:5:281789
    373:5:281821    504:7:284939    762:4:157852    763:4:157852    764=
:4:157852
    765:4:157852    766:4:157852    767:4:157869    768:4:157869    769=
:4:157852
    770:4:157852    771:4:157852    772:4:157852    773:4:157852    805=
:2:289191
    814:6:285657    951:2:153505    951:2:153611    951:2:154209    951=
:2:154305
    951:2:154491    951:2:154577    951:2:155067    951:2:155665     97=
4:5:84265
    1165:7:88233    1166:7:88233    1167:7:88233    1168:7:88233    116=
9:7:88233
    1170:7:88233    1171:7:88233    1172:7:88233    1173:7:88233    117=
4:7:88233
    1175:7:88233    1176:7:88233    1177:7:88233    1178:7:88233    117=
9:7:88243
    1180:7:88245    1181:7:88247    1182:7:88245    1183:7:88233    118=
4:7:88233
    1185:7:88233    1186:7:88233    1187:7:88233    1188:7:88233    118=
9:7:88233
    1190:7:88233    1191:7:88233    1192:7:88233    1193:7:88233    119=
4:7:88233
    1195:7:88233    1196:7:88233    1526:0:62618   1566:7:238223   1691=
:6:152844
   1692:6:152844   1693:6:152844   1694:6:152844   1695:6:152844   1696=
:6:152864
   1697:6:152864   1698:6:152844   1699:6:152844   1700:6:152844   1701=
:6:152844
   1702:6:152844    1798:5:79845   1867:2:299803   2344:5:118199   2403=
:5:118153
   2404:5:118153   2405:5:118153   2406:5:118153   2407:5:118153   2408=
:5:118153
   2409:5:118153   2410:5:118153   2411:5:118153   2412:5:118153   2413=
:5:118153
   2414:5:118153   2415:5:118153   2416:5:118153   2417:5:118153   2418=
:5:118153
   2419:5:118153   2420:5:118153   2421:5:118153   2422:5:118153   2423=
:5:118153
   2424:5:118165   2425:5:118153   2426:5:118153   2427:5:118153   2428=
:5:118153
   2429:5:118153   2430:5:118153   2431:5:118153   2432:5:118153   2433=
:5:118153
   2434:5:118153   2435:5:118153   2436:5:118153   2437:5:118153   2438=
:5:118153
   2439:5:118153   2440:5:118153   2441:5:118153   2442:5:118153   2443=
:5:118153
   2444:5:118153   2445:5:118153   2446:5:118153   2447:5:118153   2448=
:5:118153
   2449:5:118153   2450:5:118153   2451:5:118153   2452:5:118153   2453=
:5:118153
   2454:5:118153   2455:5:118153   2456:5:118153   2457:5:118153   2458=
:5:118153
   2459:5:118153   2460:5:118153   2461:5:118153   2462:5:118153   2463=
:5:118153
   2464:5:118153   2465:5:118153   2466:5:118153   2467:5:118153   2468=
:5:118153
   2469:5:118153   2470:5:118153   2471:5:118153   2472:5:118153   2473=
:5:118153
   2474:5:118153   2475:5:118153   2476:5:118153   2477:5:118153   2478=
:5:118153
   2479:5:118153   2480:5:118153   2481:5:118153   2482:5:118153   2483=
:5:118153
   2484:5:118153   2485:5:118153   2486:5:118153   2487:5:118153   2488=
:5:118153
   2489:5:118153   2490:5:118153   2491:5:118153   2492:5:118153   2493=
:5:118153
   2494:5:118153   2495:5:118153   2496:5:118189   2497:5:118153   2498=
:5:118153
   2499:5:118153   2500:5:118153   2501:5:118153   2502:5:118153   2503=
:5:118153
   2504:5:118153   2505:5:118153   2506:5:118153   2507:5:118153   2508=
:5:118153
   2509:5:118153   2510:5:118153   2511:5:118153   2512:5:118153   2513=
:5:118153
   2514:2:252956   2514:5:118153   2515:2:252956   2515:5:118153   2516=
:2:252956
   2516:5:118153   2517:2:252956   2517:5:118153   2518:2:252956   2519=
:2:252956
   2520:2:252956   2521:2:252956   2522:2:252956   2523:2:252956   2524=
:2:252956
   2525:2:252956   2526:2:252956   2527:2:252956   2528:2:252956   2529=
:2:252956
   2530:2:252956   2531:2:252956   2532:2:252956   2533:2:252956   2534=
:2:252956
   2535:2:252959   2536:2:252956   2537:2:252956   2538:2:252956   2539=
:2:252956
   2540:2:252956   2541:2:252956   2542:2:252956   2543:2:252956   2544=
:2:252956
   2545:2:252956   2546:2:252956   2547:2:252956   2548:2:252956   2549=
:2:252956
   2550:2:252956   2551:2:252956   2552:2:252956   2553:2:252956   2554=
:2:252956
   2555:2:252956   2556:2:252956   2557:2:252956   2558:2:252956    255=
8:4:62473
   2559:2:252956   2560:2:252956   2561:2:252956   2562:2:252956   2563=
:2:252956
   2564:2:252956   2565:2:252956   2566:2:252956   2567:2:252956   2568=
:2:252956
   2569:2:252956   2570:2:252956   2571:2:252956   2572:2:252956   2573=
:2:252956
   2574:2:252933   2575:2:252911   2576:2:252913   2577:2:252910   2578=
:2:252910
   2579:2:252910   2580:2:252910   2581:2:252910   2582:2:252910   2583=
:2:252910
   2584:2:252910   2585:2:252910   2586:2:252910   2587:2:252910   2588=
:2:252910
   2589:2:252910   2590:2:252910   2591:2:252910   2592:2:252910   2593=
:2:252910
   2594:2:252910   2595:2:252910   2596:2:252910   2597:2:252910    264=
3:3:32593
    2851:3:44527   2918:1:311235   3025:4:146627    3725:3:22943   3866=
:5:247877
   3918:5:188327   4155:2:190933   4174:6:122779   4370:0:193471    453=
4:0:35293
    4662:7:57757   4852:2:176121    4882:0:35111   5084:6:228590    511=
9:4:86905
   5771:5:224041   5772:5:224041   5773:5:224041   5774:5:224041   5775=
:5:224041
   5776:5:224041   5777:5:224041   5778:5:224041   5779:5:224041   5780=
:5:224049
   5781:5:224051   5782:5:224051   5783:5:224041   5784:5:224041   5785=
:5:224041
   5786:5:224041   5787:5:224041   5788:5:224041   5789:5:224041   5790=
:5:224041
   5791:5:224041    5987:7:65457    5988:7:65457    5989:7:65457    599=
0:7:65457
    5991:7:65457    5992:7:65471    5993:7:65471    5994:7:65457    599=
5:7:65457
    5996:7:65457    5997:7:65457    5998:7:65457   6008:0:185357    615=
1:0:92315
    6587:4:10217   7279:7:226343     7555:4:2777   7663:1:154580   7664=
:1:154580
   7665:1:154580   7666:1:154580   7667:1:154580   7668:1:154585   7669=
:1:154581
   7670:1:154580   7671:1:154580   7672:1:154580   7673:1:154580   7674=
:1:154580
   7711:4:247510   7790:0:156976   7792:0:155005   8121:0:165906   8122=
:0:287021
    8169:0:66440   8305:6:267425   9357:6:252276   9813:7:279670   9814=
:7:279670
   9815:7:279670   9816:7:279670   9817:7:279670   9818:7:279677   9819=
:7:279675
   9820:7:279670   9821:7:279670   9822:7:279670   9823:7:279670   9824=
:7:279670
  10251:0:107381   10308:0:37981  10529:4:229840  10530:4:229840  10531=
:4:229840
  10532:4:229840  10533:4:229840  10534:4:229850  10535:4:229854  10536=
:4:229840
  10537:4:229840  10538:4:229840  10539:4:229840  10540:4:229840  10830=
:1:304877
  10833:7:155513  10922:4:248129  11028:0:178285  11029:0:178285  11030=
:0:178285
  11031:0:178285  11032:0:178285  11033:0:178293  11034:0:178293  11035=
:0:178285
  11036:0:178285  11037:0:178285  11038:0:178285  11039:0:178285  11115=
:7:145762
  11116:7:145762  11117:7:145762  11118:7:145762  11119:7:145762  11120=
:7:145762
  11121:7:145762  11122:7:145762  11123:7:145762  11124:7:145764  11125=
:7:145764
  11126:7:145766  11127:7:145762  11128:7:145762  11129:7:145762  11130=
:7:145762
  11131:7:145762  11132:7:145762  11133:7:145762  11134:7:145762  11135=
:7:145762
    11457:6:2215     11679:4:197  11719:0:108513  11720:0:108659  11721=
:0:108804
  11722:0:108950  11723:0:109096  11724:0:109255  11725:0:109389  11726=
:0:109532
  11727:0:109678  11728:0:109824  11729:0:109969  11730:0:110115   1221=
0:7:91000
   12211:7:91104   12212:7:91208   12213:7:91312   12214:7:91416   1221=
5:7:91537
   12216:7:91631   12217:7:91728   12218:7:91832   12219:7:91936   1222=
0:7:92040
   12221:7:92144  13622:0:162715  13623:0:162715  13624:0:162715  13625=
:0:162715
  13626:0:162715  13627:0:162721  13628:0:162721  13629:0:162715  13630=
:0:162715
  13631:0:162715  13632:0:162715  13633:0:162715  14505:6:148042  14785=
:0:167045
   15813:0:99317   15814:0:99412   15815:0:99506   15816:0:99601   1581=
7:0:99696
  15817:0:100339   15818:0:99795  15818:0:100193  15818:0:100259  15818=
:0:100305
  15818:0:100341  15818:0:100939   15819:0:99899  15819:0:100339   1582=
0:0:99979
  15821:0:100074  15822:0:100168  15823:0:100263  15824:0:100358   1604=
0:0:44251
   16141:6:22475   16168:2:25787  16302:6:186337  16466:5:231672  16467=
:5:231672
  16468:5:231672  16469:5:231672  16470:5:231672  16471:5:231685  16472=
:5:231685
  16473:5:231672  16474:5:231672  16475:5:231672  16476:5:231672  16477=
:5:231672
  16508:4:241301   17301:7:48039   17749:5:86629   17778:1:52671  17804=
:0:120241
  17958:6:152551

0 entries in grown table.
=46ormat is: bytes from index [Cyl:Head:Off]
Offset -1 marks whole track as bad.

Unable to read Notch and Partition Page 0ch
sense buffer: 70 00 05 00 00 00 00 0a 00 00 00 00 24 00 01 cd

Data from Verify Error Recovery Page
------------------------------------
EER                                0
PER                                0
DTE                                0
DCR                                0
Verify Retry Count                 11
Verify Correction Span (bits)      240
Verify Recovery Time Limit (ms)    65535

Unable to read Peripheral Device Page 09h
sense buffer: 70 00 05 00 00 00 00 0a 00 00 00 00 24 00 01 cd

tom1:~# smartctl -a /dev/sda
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 B=
ruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: SEAGATE  ST336752LW       Version: 0003
Serial number: 3ET03GB500007212EE51
Device type: disk
Local Time is: Mon Jul 28 15:03:38 2008 CEST
Device supports SMART and is Enabled
Temperature Warning Enabled
SMART Health Status: OK

Current Drive Temperature:     49 C
Drive Trip Temperature:        65 C
Elements in grown defect list: 0
Vendor (Seagate) cache information
  Blocks sent to initiator =3D 2605838091
  Blocks received from initiator =3D 3464956162
  Blocks read from cache and sent to initiator =3D 288535939
  Number of read and write commands whose size <=3D segment size =3D 73=
9535927
  Number of read and write commands whose size > segment size =3D 41947=
29
Vendor (Seagate/Hitachi) factory information
  number of hours powered up =3D 11298.00
  number of minutes until next internal SMART test =3D 42

Error counter log:
           Errors Corrected by           Total   Correction     Gigabyt=
es    Total
               ECC          rereads/    errors   algorithm      process=
ed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 by=
tes]  errors
read:     194724        0         0    194724     194724      10793.415=
           0
write:         0        0         0         0          0       3832.149=
           0
verify:        0        0         0         0          0          0.000=
           0

Non-medium error count:        0

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_fi=
rst_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Completed                   -   11297           =
      - [-   -    -]
# 2  Background short  Completed                   -   11280           =
      - [-   -    -]
# 3  Background long   Completed                   -   11265           =
      - [-   -    -]
# 4  Background short  Completed                   -   11265           =
      - [-   -    -]
# 5  Background long   Interrupted (bus reset ?)   -       0           =
      - [-   -    -] <----------- XXXXX first shown up
# 6  Background short  Completed                   -   11264           =
      - [-   -    -]
# 7  Background short  Completed                   -   11245           =
      - [-   -    -]
# 8  Background short  Completed                   -   11221           =
      - [-   -    -]
# 9  Background short  Completed                   -   11205           =
      - [-   -    -]
#10  Background short  Completed                   -   11188           =
      - [-   -    -]
#11  Background short  Completed                   -   11171           =
      - [-   -    -]
#12  Background short  Completed                   -   11155           =
      - [-   -    -]
#13  Background long   Completed                   -   11140           =
      - [-   -    -]
#14  Background short  Completed                   -   11139           =
      - [-   -    -]
#15  Background short  Completed                   -   11125           =
      - [-   -    -]
#16  Background short  Completed                   -   11109           =
      - [-   -    -]
#17  Background short  Completed                   -   11093           =
      - [-   -    -]
#18  Background short  Completed                   -   11075           =
      - [-   -    -]
#19  Background long   Completed                   -   11025           =
      - [-   -    -]
#20  Background short  Completed                   -   11024           =
      - [-   -    -]

Long (extended) Self Test duration: 900 seconds [15.0 minutes]
tom1:~#                                  =20

tom1:~#       =20
tom1:~# hddtemp /dev/sda
/dev/sda: SEAGATE ST336752LW: 49=B0C
tom1:~#
tom1:~# sensors
k8temp-pci-00c3
Adapter: PCI adapter
Core0 Temp:  +49.0=B0C

w83627thf-isa-0290
Adapter: ISA adapter
VCore:       +1.42 V  (min =3D  +1.33 V, max =3D  +1.47 V)
+12V:       +12.16 V  (min =3D +10.82 V, max =3D +13.19 V)
+5V:         +4.99 V  (min =3D  +4.75 V, max =3D  +5.25 V)
V5SB:        +5.00 V  (min =3D  +4.76 V, max =3D  +5.24 V)
VBat:        +2.99 V  (min =3D  +1.80 V, max =3D  +3.20 V)
GPU Fan:    5443 RPM  (min =3D  998 RPM, div =3D 8)
CPU Fan:     815 RPM  (min =3D  664 RPM, div =3D 8)
M/B Temp:    +38.0=B0C  (high =3D +45.0=B0C, hyst =3D +42.0=B0C)  senso=
r =3D diode
beep_enable:enabled



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
