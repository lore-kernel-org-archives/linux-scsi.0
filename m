From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Subject: sym53c8xx driver hangs
Date: Thu, 17 Feb 2005 16:51:44 +0100
Message-ID: <4214BD90.7030002@ludd.luth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms050504040802080101080109"
Received: from mother.ludd.ltu.se ([130.240.16.3]:50816 "EHLO
	mother.ludd.ltu.se") by vger.kernel.org with ESMTP id S262261AbVBQPvr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 10:51:47 -0500
Received: from [127.0.0.1] (brother.ludd.ltu.se [130.240.16.78])
	by mother.ludd.ltu.se (8.12.10+Sun/8.12.10) with ESMTP id j1HFpjtw023817
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 16:51:45 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050504040802080101080109
Content-Type: multipart/mixed;
 boundary="------------040803060208000702080403"

This is a multi-part message in MIME format.
--------------040803060208000702080403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have a machine with a Tekram DC-390U2W and a HP Surestore 1/9 
Autoloader (with a Ultrium-1 drive) attached .
I've tried to get it to work with FC3(2.6.10-1.766_FC3) with no luck.
I've also tested it with Knoppix-3.3(2.4.24) and it works just fine 
(output from test-dump in dump.txt and from dmesg in dmesg4.txt).

If I boot with the autoloader powered up, the sym53c8xx-driver hangs 
(dmesg messages in attched dmesg1.txt) and when it has gotten that far, 
there is noting that will help but resetting the machine.

If I boot with the autoloader powered up and power it down when the 
first "batch" of error messages have been printed it detects that and 
aborts the driver and continues (dmesg2.txt)

Also attached(dmesg3.txt) is the dmesg output with "debug=0xffff".

I've replaced all SCSI-cables and the terminator, but unfortunately this 
is the only LVD-capable controller I've got(except the internal AIC-7899 
but I have no internal-68pin<->-external-68pin converter yet so I can't 
test the autoloader on that yet) so I can't test with different controller.

I've seen that there are more people having similar problem and some 
patches have also been suggested, but I haven't tested any of them yet.

--------------040803060208000702080403
Content-Type: text/plain;
 name="dump.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dump.txt"

# dump 0f /dev/st0 /mnt
  DUMP: Date of this level 0 dump: Thu Feb 17 10:12:26 2005
  DUMP: Dumping /dev/rd/c0d0p1 (/mnt) to /dev/st0
  DUMP: Excluding inode 8 (journal inode) from dump
  DUMP: Excluding inode 7 (resize inode) from dump
  DUMP: Label: none
  DUMP: Writing 10 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 308932 blocks.
  DUMP: Volume 1 started with block 1 at: Thu Feb 17 10:13:19 2005
  DUMP: dumping (Pass III) [directories]
  DUMP: dumping (Pass IV) [regular files]
  DUMP: Closing /dev/st0
  DUMP: Volume 1 completed at: Thu Feb 17 10:14:00 2005
  DUMP: Volume 1 321990 blocks (314.44MB)
  DUMP: Volume 1 took 0:00:41
  DUMP: Volume 1 transfer rate: 7853 kB/s
  DUMP: 321990 blocks (314.44MB) on 1 volume(s)
  DUMP: finished in 20 seconds, throughput 16099 kBytes/sec
  DUMP: Date of this level 0 dump: Thu Feb 17 10:12:26 2005
  DUMP: Date this dump completed:  Thu Feb 17 10:14:00 2005
  DUMP: Average transfer rate: 7853 kB/s
  DUMP: DUMP IS DONE
#

--------------040803060208000702080403
Content-Type: text/plain;
 name="dmesg1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg1.txt"

sym0: <895> rev 0x1 at pci 0000:00:07.0 irq 4
sym0: Tekram NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18m
  Vendor: HP        Model: Ultrium 1-SCSI    Rev: E15V
  Type:   Sequential-Access                  ANSI SCSI revision: 03
 target1:0:8: Beginning Domain Validation
sym0:8:0:phase change 6-7 9@188b3f84 resid=5.
sym0:8:0: ABORT operation started.
sym0:8:0: ABORT operation timed-out.
sym0:8:0: DEVICE RESET operation started.
sym0:8:0: DEVICE RESET operation timed-out.
sym0:8:0: BUS RESET operation started.
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
sym0:8:0: BUS RESET operation complete.
sym0:8:0:phase change 6-7 9@188b3f84 resid=5.
sym0:8:0: ABORT operation started.
sym0:8:0: ABORT operation timed-out.
sym0:8:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
--------------040803060208000702080403
Content-Type: text/plain;
 name="dmesg2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg2.txt"

sym0: <895> rev 0x1 at pci 0000:00:07.0 irq 4
sym0: Tekram NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
  Vendor: HP        Model: Ultrium 1-SCSI    Rev: E15V
  Type:   Sequential-Access                  ANSI SCSI revision: 03
scsi(0:0:8:0): Beginning Domain Validation
sym0:8:0:phase change 6-7 9@016ddf84 resid=5.
sym0:8:0: ABORT operation started.
sym0:8:0: ABORT operation timed-out.
sym0:8:0: DEVICE RESET operation started.
sym0:8:0: DEVICE RESET operation timed-out.
sym0:8:0: BUS RESET operation started.
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
sym0:8:0: BUS RESET operation complete.
sym0:8:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
sym0:8:0: HOST RESET operation complete.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 8 lun 0
scsi(0:0:8:0): Wide Transfers Fail
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation detected failure, dropping back
scsi(0:0:8:0): Domain Validation Failure, dropping back to Asynchronous
scsi(0:0:8:0): Ending Domain Validation
--------------040803060208000702080403
Content-Type: text/plain;
 name="dmesg3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg3.txt"

sym0: <895> rev 0x1 at pci 0000:00:07.0 irq 9
new MPOOL     [ 184] @d56e3000.
new VTOB      [  12] @d56e3100.
new HCB       [1808] @d18a2000.
sym0: Tekram NVRAM, ID 7, Fast-40, LVD, parity checking
new VTOB      [  12] @d56e3110.
new SQUEUE    [3600] @d18a3000.
new VTOB      [  12] @d56e3120.
new DQUEUE    [3600] @d18a4000.
new TARGTBL   [ 256] @d18a2800.
new VTOB      [  12] @d56e3130.
new SCRIPTA0  [3024] @d18a5000.
new VTOB      [  12] @d56e3140.
new SCRIPTB0  [1324] @d18a6000.
new SCRIPTZ0  [  32] @d18a2900.
new CCBH      [1024] @d56e3400.
new CCB       [ 988] @d18a2c00.
new SNS_BBUF  [  32] @d18a2920.
0:  <7c07fe00>
2:  <721a0000>
4:  <72140000>
6:  <e3340004>
8:  <980cef10>
10:  <e3100004>
12:  <f31c0004>
14:  <e21c0004>
16:  <f3100004>
18:  <f31c0004>
20:  <90080000>
22:  <43000030>
24:  <f35c0004>
26:  <9e030000>
28:  <f3030001>
30:  <1e000000>
32:  <82030000>
34:  <1a000000>
36:  <870b0000>
38:  <800a0000>
40:  <810a0000>
42:  <830a0000>
44:  <820a0000>
46:  <860a0000>
48:  <84830000>
50:  <c000001>
52:  <848b0000>
54:  <85830000>
56:  <d000001>
58:  <858b0000>
60:  <98080000>
62:  <80080000>
64:  <860b0000>
66:  <870b0000>
68:  <725d0000>
70:  <980c0002>
72:  <80080000>
74:  <720d0000>
76:  <808cfd02>
78:  <80080000>
80:  <60000040>
82:  <80080000>
84:  <f21c0004>
86:  <72020000>
88:  <800cfe01>
90:  <830b0000>
92:  <80080000>
94:  <7a020100>
96:  <9f030000>
98:  <87030000>
100:  <f000001>
102:  <98040023>
104:  <80040023>
106:  <60000040>
108:  <f000001>
110:  <60000040>
112:  <80080000>
114:  <f21c0004>
116:  <72020000>
118:  <800cf708>
120:  <830b0000>
122:  <80080000>
124:  <7a020800>
126:  <98080000>
128:  <80080000>
130:  <f31c0004>
132:  <90080000>
134:  <7a3c0c80>
136:  <f31c0004>
138:  <90080000>
140:  <f000001>
142:  <800c0000>
144:  <800c0004>
146:  <800c0002>
148:  <800c0003>
150:  <80080000>
152:  <b000001>
154:  <6a5e0000>
156:  <785d8400>
158:  <870b0000>
160:  <80080000>
162:  <7c027f00>
164:  <60000048>
166:  <48000000>
168:  <f25c0004>
170:  <f35c0004>
172:  <725e0000>
174:  <88040000>
176:  <725f0000>
178:  <8004cf00>
180:  <e2100004>
182:  <e3100004>
184:  <e3340004>
186:  <f2340004>
188:  <f3340004>
190:  <98180000>
192:  <e2340004>
194:  <80080000>
196:  <e3340004>
198:  <98080000>
200:  <60000040>
202:  <7a5f0800>
204:  <f3340004>
206:  <f2340004>
208:  <870b0000>
210:  <80080000>
212:  <60000040>
214:  <f3340004>
216:  <f2340004>
218:  <80080000>
220:  <7c027f00>
222:  <60000048>
224:  <48000000>
226:  <785d0300>
228:  <f25c0004>
230:  <80080000>
232:  <7a070100>
234:  <7810ff00>
236:  <e2340004>
238:  <50000000>
240:  <7c07fe00>
242:  <740a8f00>
244:  <6a060000>
246:  <e3100004>
248:  <69100000>
250:  <79100000>
252:  <7c103c00>
254:  <f3100004>
256:  <9f030000>
258:  <f3030001>
260:  <f3050001>
262:  <f3bc0001>
264:  <f000001>
266:  <800c4080>
268:  <98047f80>
270:  <f3100004>
272:  <69100000>
274:  <79100000>
276:  <7c10fc00>
278:  <f3100004>
280:  <80880000>
282:  <f3100004>
284:  <f31c0004>
286:  <90080000>
288:  <60000040>
290:  <f000002>
292:  <f3100004>
294:  <71500000>
296:  <6c10fc00>
298:  <f3100004>
300:  <f31c0004>
302:  <90080000>
304:  <60000040>
306:  <f35c0004>
308:  <80080000>
310:  <f3100004>
312:  <f31c0004>
314:  <90080000>
316:  <11000000>
318:  <11000000>
320:  <11000000>
322:  <11000000>
324:  <11000000>
326:  <11000000>
328:  <11000000>
330:  <11000000>
332:  <11000000>
334:  <11000000>
336:  <11000000>
338:  <11000000>
340:  <11000000>
342:  <11000000>
344:  <11000000>
346:  <11000000>
348:  <11000000>
350:  <11000000>
352:  <11000000>
354:  <11000000>
356:  <11000000>
358:  <11000000>
360:  <11000000>
362:  <11000000>
364:  <11000000>
366:  <11000000>
368:  <11000000>
370:  <11000000>
372:  <11000000>
374:  <11000000>
376:  <11000000>
378:  <11000000>
380:  <11000000>
382:  <11000000>
384:  <11000000>
386:  <11000000>
388:  <11000000>
390:  <11000000>
392:  <11000000>
394:  <11000000>
396:  <11000000>
398:  <11000000>
400:  <11000000>
402:  <11000000>
404:  <11000000>
406:  <11000000>
408:  <11000000>
410:  <11000000>
412:  <11000000>
414:  <11000000>
416:  <11000000>
418:  <11000000>
420:  <11000000>
422:  <11000000>
424:  <11000000>
426:  <11000000>
428:  <11000000>
430:  <11000000>
432:  <11000000>
434:  <11000000>
436:  <11000000>
438:  <11000000>
440:  <11000000>
442:  <11000000>
444:  <11000000>
446:  <11000000>
448:  <11000000>
450:  <11000000>
452:  <11000000>
454:  <11000000>
456:  <11000000>
458:  <11000000>
460:  <11000000>
462:  <11000000>
464:  <11000000>
466:  <11000000>
468:  <11000000>
470:  <11000000>
472:  <11000000>
474:  <11000000>
476:  <11000000>
478:  <11000000>
480:  <11000000>
482:  <11000000>
484:  <11000000>
486:  <11000000>
488:  <11000000>
490:  <11000000>
492:  <11000000>
494:  <11000000>
496:  <11000000>
498:  <11000000>
500:  <11000000>
502:  <11000000>
504:  <11000000>
506:  <11000000>
508:  <88080000>
510:  <80080000>
512:  <10000000>
514:  <10000000>
516:  <10000000>
518:  <10000000>
520:  <10000000>
522:  <10000000>
524:  <10000000>
526:  <10000000>
528:  <10000000>
530:  <10000000>
532:  <10000000>
534:  <10000000>
536:  <10000000>
538:  <10000000>
540:  <10000000>
542:  <10000000>
544:  <10000000>
546:  <10000000>
548:  <10000000>
550:  <10000000>
552:  <10000000>
554:  <10000000>
556:  <10000000>
558:  <10000000>
560:  <10000000>
562:  <10000000>
564:  <10000000>
566:  <10000000>
568:  <10000000>
570:  <10000000>
572:  <10000000>
574:  <10000000>
576:  <10000000>
578:  <10000000>
580:  <10000000>
582:  <10000000>
584:  <10000000>
586:  <10000000>
588:  <10000000>
590:  <10000000>
592:  <10000000>
594:  <10000000>
596:  <10000000>
598:  <10000000>
600:  <10000000>
602:  <10000000>
604:  <10000000>
606:  <10000000>
608:  <10000000>
610:  <10000000>
612:  <10000000>
614:  <10000000>
616:  <10000000>
618:  <10000000>
620:  <10000000>
622:  <10000000>
624:  <10000000>
626:  <10000000>
628:  <10000000>
630:  <10000000>
632:  <10000000>
634:  <10000000>
636:  <10000000>
638:  <10000000>
640:  <10000000>
642:  <10000000>
644:  <10000000>
646:  <10000000>
648:  <10000000>
650:  <10000000>
652:  <10000000>
654:  <10000000>
656:  <10000000>
658:  <10000000>
660:  <10000000>
662:  <10000000>
664:  <10000000>
666:  <10000000>
668:  <10000000>
670:  <10000000>
672:  <10000000>
674:  <10000000>
676:  <10000000>
678:  <10000000>
680:  <10000000>
682:  <10000000>
684:  <10000000>
686:  <10000000>
688:  <10000000>
690:  <10000000>
692:  <10000000>
694:  <10000000>
696:  <10000000>
698:  <10000000>
700:  <10000000>
702:  <10000000>
704:  <88080000>
706:  <80080000>
708:  <725f0000>
710:  <81030000>
712:  <8004bf40>
714:  <7a5f0100>
716:  <11000000>
718:  <80080000>
720:  <800cbf40>
722:  <7a5f0100>
724:  <10000000>
726:  <7c5ffe00>
728:  <f31c0004>
730:  <90080000>
732:  <725f0000>
734:  <81030000>
736:  <8004bf40>
738:  <7a5f0200>
740:  <11000000>
742:  <80080000>
744:  <800cbf40>
746:  <7a5f0200>
748:  <10000000>
750:  <7c5ffd00>
752:  <f31c0004>
754:  <90080000>
0:  <80080000>
2:  <80080000>
4:  <43000708>
6:  <86830000>
8:  <98080000>
10:  <7c027f00>
12:  <1e000000>
14:  <60000048>
16:  <48000000>
18:  <98080000>
20:  <80080000>
22:  <800c0001>
24:  <800c0f00>
26:  <800c0f10>
28:  <80040f20>
30:  <60000040>
32:  <f000001>
34:  <f3340004>
36:  <98080000>
38:  <f3340004>
40:  <98080000>
42:  <60000040>
44:  <f000001>
46:  <800c0000>
48:  <6a340000>
50:  <7e08f800>
52:  <80280000>
54:  <f2340001>
56:  <60000040>
58:  <1f000000>
60:  <80080000>
62:  <98080000>
64:  <58000008>
66:  <80080000>
68:  <98080000>
70:  <58000008>
72:  <60000040>
74:  <87030000>
76:  <f000001>
78:  <80080000>
80:  <58000008>
82:  <60000040>
84:  <86030000>
86:  <e000004>
88:  <80080000>
90:  <58000008>
92:  <60000040>
94:  <86030000>
96:  <e000005>
98:  <80080000>
100:  <58000008>
102:  <60000040>
104:  <86030000>
106:  <e000008>
108:  <80080000>
110:  <98080000>
112:  <80080000>
114:  <e000001>
116:  <860b0000>
118:  <98080000>
120:  <80080000>
122:  <e3340004>
124:  <80830000>
126:  <1>
128:  <80080000>
130:  <72020000>
132:  <8084fe01>
134:  <7a020100>
136:  <80080000>
138:  <818b0000>
140:  <98080000>
142:  <80080000>
144:  <1000001>
146:  <7e340100>
148:  <7f350000>
150:  <7f360000>
152:  <80080000>
154:  <58000008>
156:  <60000040>
158:  <7c027f00>
160:  <e000001>
162:  <60000048>
164:  <48000000>
166:  <98080000>
168:  <80080000>
170:  <58000008>
172:  <80080000>
174:  <60000008>
176:  <80080000>
178:  <58000008>
180:  <80080000>
182:  <11000000>
184:  <88080000>
186:  <80080000>
188:  <98080000>
190:  <80080000>
192:  <98080000>
194:  <80080000>
196:  <98080000>
198:  <80080000>
200:  <e3340004>
202:  <98040004>
204:  <90080000>
206:  <725f0000>
208:  <800cf400>
210:  <8084f708>
212:  <7b080400>
214:  <800cfc00>
216:  <8084fe01>
218:  <f3d40004>
220:  <80080000>
222:  <f3d40004>
224:  <80080000>
226:  <7e540880>
228:  <7f550080>
230:  <6c5ff400>
232:  <800cfb04>
234:  <f2d40004>
236:  <72020000>
238:  <880cfe01>
240:  <f2c80004>
242:  <f2cc0004>
244:  <e3d40004>
246:  <f2d40004>
248:  <80080000>
250:  <f2d40004>
252:  <72020000>
254:  <880cfe01>
256:  <f2c80004>
258:  <f2cc0004>
260:  <e3d40004>
262:  <80080000>
264:  <f2cc0004>
266:  <7e4c0180>
268:  <7f4d0080>
270:  <7f4e0080>
272:  <7f4f0080>
274:  <e3340004>
276:  <7a340100>
278:  <724b0080>
280:  <6a370000>
282:  <f2340004>
284:  <81830000>
286:  <11000000>
288:  <72480080>
290:  <90040000>
292:  <72490080>
294:  <90040000>
296:  <724a0080>
298:  <90040000>
300:  <80080000>
302:  <11000000>
304:  <80080000>
306:  <800b0000>
308:  <f3340004>
310:  <f2340004>
312:  <f31c0004>
314:  <90080000>
316:  <7c5fbf00>
318:  <f3340004>
320:  <f2340004>
322:  <80080000>
0:  <f3340004>
2:  <f21c0004>
4:  <f31c0004>
6:  <98080000>
new BADLUNTBL [ 256] @d18a2a00.
sym0: SCSI BUS has been reset.
scsi2 : sym-2.1.18m
sym0:0:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=2.
[<0|0:400|fb006070:9e030000>T<7>]
[<0|84:0|fb006320:98080000>I#20CCB=d18a2c00 STAT=85/ff/40 DEV=0/0
sym0:0:0:ccb @d18a2c00 freeing tag 256.
]
sym0:1:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=4.
[<0|0:400|fb006070:9e030000>T<7>]
[<0|84:0|fb006320:98080000>I#20CCB=d18a2c00 STAT=85/ff/40 DEV=1/0
sym0:1:0:ccb @d18a2c00 freeing tag 256.
]
sym0:2:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=6.
[<0|0:400|fb006070:9e030000>T<7>]
[<0|84:0|fb006320:98080000>I#20CCB=d18a2c00 STAT=85/ff/40 DEV=2/0
sym0:2:0:ccb @d18a2c00 freeing tag 256.
]
sym0:3:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=8.
[<0|0:400|fb006070:9e030000>T<7>]
[<0|84:0|fb006320:98080000>I#20CCB=d18a2c00 STAT=85/ff/40 DEV=3/0
sym0:3:0:ccb @d18a2c00 freeing tag 256.
]
sym0:4:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=10.
[<0|0:400|fb006070:9e030000>T<7>]
[<0|84:0|fb006320:98080000>I#20CCB=d18a2c00 STAT=85/ff/40 DEV=4/0
sym0:4:0:ccb @d18a2c00 freeing tag 256.
]
sym0:5:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=12.
[<0|0:400|fb006070:9e030000>T<7>]
[<0|84:0|fb006320:98080000>I#20CCB=d18a2c00 STAT=85/ff/40 DEV=5/0
sym0:5:0:ccb @d18a2c00 freeing tag 256.
]
sym0:6:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=14.
[<0|0:400|fb006070:9e030000>T<7>]
[<0|84:0|fb006320:98080000>I#20CCB=d18a2c00 STAT=85/ff/40 DEV=6/0
sym0:6:0:ccb @d18a2c00 freeing tag 256.
]
sym0:8:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=16.
[F sym0:8:0:ccb @d18a2c00 freeing tag 256.
]
  Vendor: HP        Model: Ultrium 1-SCSI    Rev: E15V
  Type:   Sequential-Access                  ANSI SCSI revision: 03
new LCB       [  72] @d18a2980.
 target2:0:8: Beginning Domain Validation
sym0:8:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=18.
[F sym0:8:0:ccb @d18a2c00 freeing tag 256.
]
sym0:8:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=20.
[F sym0:8:0:ccb @d18a2c00 freeing tag 256.
]
sym0:8:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=22.
[F sym0:8:0:ccb @d18a2c00 freeing tag 256.
]
sym0:8:0:ccb @d18a2c00 using tag 256.
sym0: queuepos=24.
[F sym0:8:0:ccb @d18a2c00 freeing tag 256.
]
sym0:8:0:ccb @d18a2c00 using tag 256.
sym0:8:ppr msgout: 1-6-4-a-0-0-1-0.
sym0: queuepos=26.
[<0|0:c0|fb006080:1e000000>P67 RL=5 D=4
CP=d18a2c00 DSP=fb006080 NXT=fb006080 VDSP=d18a5078 CMD=1e OCMD=1e
TBLP=d18a2c34 OLEN=9 OADR=118a2f84
sym0:8:0:phase change 6-7 9@118a2f84 resid=5.
]
[<0|84:0|118a6098:98080000>I#3<7>]
sym0:8:0: ABORT operation started.
sym0:8:0: ABORT operation timed-out.
sym0:8:0: DEVICE RESET operation started.
sym0:8:0: DEVICE RESET operation timed-out.
sym0:8:0: BUS RESET operation started.
[<0|0:2|0:0>sym0: SCSI BUS reset detected.
sym0:8:0:ccb @d18a2c00 freeing tag 256.
sym0: SCSI BUS has been reset.
]
sym0:8:0: BUS RESET operation complete.
sym0:8:0:ccb @d18a2c00 using tag 256.
sym0:8:ppr msgout: 1-6-4-a-0-0-1-0.
sym0: queuepos=2.
[<0|0:c0|fb006080:1e000000>P67 RL=5 D=4
CP=d18a2c00 DSP=fb006080 NXT=fb006080 VDSP=d18a5078 CMD=1e OCMD=1e
TBLP=d18a2c34 OLEN=9 OADR=118a2f84
sym0:8:0:phase change 6-7 9@118a2f84 resid=5.
]
[<0|84:0|118a6098:98080000>I#3<7>]
sym0:8:0: ABORT operation started.
sym0:8:0: ABORT operation timed-out.
sym0:8:0: HOST RESET operation started.
sym0:8:0:ccb @d18a2c00 freeing tag 256.
sym0: SCSI BUS has been reset.

--------------040803060208000702080403
Content-Type: text/plain;
 name="dmesg4.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg4.txt"

ncr53c8xx: at PCI bus 0, device 7, function 0
ncr53c8xx: 53c895 detected with Tekram NVRAM
ncr53c895-0: rev 0x1 on pci bus 0 device 7 function 0 irq 23
ncr53c895-0: Tekram format NVRAM, ID 7, Fast-40, Parity Checking
scsi3 : ncr53c8xx-3.4.3b-20010512
  Vendor: HP        Model: Ultrium 1-SCSI    Rev: E15V
  Type:   Sequential-Access                  ANSI SCSI revision: 03
  Vendor: HP        Model: C7145             Rev: 2300
  Type:   Medium Changer                     ANSI SCSI revision: 03
[snip]
st: Version 20030406, bufsize 32768, max init. bufs 4, s/g segs 16
Attached scsi tape st0 at scsi3, channel 0, id 8, lun 0
ncr53c895-0-<8,*>: FAST-40 WIDE SCSI 80.0 MB/s (25 ns, offset 15)
st0: Block limits 1 - 16777215 bytes.
--------------040803060208000702080403--

--------------ms050504040802080101080109
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
MIGRMBIGA1UdEwEB/wQIMAYBAf8CAQAwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC50
aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFsRnJlZW1haWxDQS5jcmwwCwYDVR0PBAQDAgEGMCkG
A1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTEzODANBgkqhkiG9w0BAQUF
AAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82L8D0HFAgk3A8/a3h
YWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr394fWxghOrvbqNOUQ
Gls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCArowggK2AgEBMGkwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAgMMmzAwCQYFKw4DAhoFAKCCAacwGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDUwMjE3MTU1MTQ0WjAj
BgkqhkiG9w0BCQQxFgQUnricg6yLto0wj37nDH8fINfWyL4wUgYJKoZIhvcNAQkPMUUwQzAK
BggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYI
KoZIhvcNAwICASgweAYJKwYBBAGCNxAEMWswaTBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECAwybMDB6BgsqhkiG9w0BCRACCzFroGkwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAgMMmzAwDQYJKoZIhvcNAQEB
BQAEgYAWGZQ8N/ybjM9n1I03Wmn3ZHROjo5PXOgQvsESkbqXs85I5p17jJO5hR8iemtd1FUL
GVAbx7FqkuUbXoTiGid7akRY4llM9mGzZ55jaIWy9PDJA0NJ8MJ20i830zFOjlNuIWTiDJ6G
PSi/o/Hvd4e6O2wTj0Sc7bmEdFxb/P+RiQAAAAAAAA==
--------------ms050504040802080101080109--
