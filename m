From: Meelis Roos <mroos-Y27EyoLml9s@public.gmane.org>
Subject: Re: 5.1-rc1: mpt init crash in scsi_map_dma, dma_4v_map_sg on sparc64
Date: Tue, 2 Apr 2019 23:30:49 +0300
Message-ID: <b3b5bd7e-ac84-8371-cc26-a28d5ca1ee24@linux.ee>
References: <dbed1f7e-cf7b-0e87-841e-e4dd1eb1ed23@linux.ee>
	<CACVXFVPBj3N=tWEaj-yKK-2K_uaMUdYPp7zC4L1eCZG3_eXsvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CACVXFVPBj3N=tWEaj-yKK-2K_uaMUdYPp7zC4L1eCZG3_eXsvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: et-EE
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>> [   17.566584] scsi host0: ioc0: LSISAS1064 A3, FwRev=010a0000h, Ports=1, MaxQ=511, IRQ=27
>> [   17.595897] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c5001799a45d
>> [   17.598465] Unable to handle kernel NULL pointer dereference
>> [   17.598623] tsk->{mm,active_mm}->context = 0000000000000000
>> [   17.598723] tsk->{mm,active_mm}->pgd = ffff800008802000
>> [   17.598774]               \|/ ____ \|/
>> [   17.598774]               "@'/ .. \`@"
>> [   17.598774]               /_| \__/ |_\
>> [   17.598774]                  \__U_/
>> [   17.598894] swapper/0(1): Oops [#1]
>> [   17.598937] CPU: 12 PID: 1 Comm: swapper/0 Not tainted 5.1.0-rc1 #118
>> [   17.598994] TSTATE: 0000000080e01601 TPC: 00000000004483a8 TNPC: 00000000004483ac Y: 00000000    Not tainted
>> [   17.599086] TPC: <dma_4v_map_sg+0xe8/0x5c0>
> 
> You may use gdb to figure out what the NULL pointer points to:
> 
> gdb vmlinux
>> l *(dma_4v_map_sg+0xe8)

gdb did not parse the file but objdump --disassemble worked and +0xe8 seems to be 4483a8

00000000004482c0 <dma_4v_map_sg>:
   4482c0:       9d e3 be b0     save  %sp, -336, %sp
   4482c4:       80 a6 e0 03     cmp  %i3, 3
   4482c8:       02 40 00 c1     be,pn   %icc, 4485cc <dma_4v_map_sg+0x30c>
   4482cc:       92 10 21 e2     mov  0x1e2, %o1
   4482d0:       80 a0 00 1a     cmp  %g0, %i2
   4482d4:       c6 5e 22 18     ldx  [ %i0 + 0x218 ], %g3
   4482d8:       82 10 20 00     clr  %g1
   4482dc:       84 60 3f ff     subc  %g0, -1, %g2
   4482e0:       83 78 e4 01     movre  %g3, 1, %g1
   4482e4:       80 90 80 01     orcc  %g2, %g1, %g0
   4482e8:       12 40 00 bd     bne,pn   %icc, 4485dc <dma_4v_map_sg+0x31c>
   4482ec:       80 a6 e0 01     cmp  %i3, 1
   4482f0:       84 10 20 03     mov  3, %g2
   4482f4:       fa 58 e2 58     ldx  [ %g3 + 0x258 ], %i5
   4482f8:       85 64 60 01     move  %icc, 1, %g2
   4482fc:       b8 0f 20 02     and  %i4, 2, %i4
   448300:       c0 77 a7 f7     clrx  [ %fp + 0x7f7 ]
   448304:       82 10 a0 04     or  %g2, 4, %g1
   448308:       c0 26 60 18     clr  [ %i1 + 0x18 ]
   44830c:       85 7f 14 01     movrne  %i4, %g1, %g2
   448310:       8f 52 00 00     rdpr  %pil, %g7
   448314:       82 11 e0 0e     or  %g7, 0xe, %g1
   448318:       91 90 60 00     wrpr  %g1, 0, %pil
   44831c:       ce 77 a7 bf     stx  %g7, [ %fp + 0x7bf ]
   448320:       0f 00 02 00     sethi  %hi(0x80000), %g7
   448324:       27 00 00 40     sethi  %hi(0x10000), %l3
   448328:       ce 77 a7 df     stx  %g7, [ %fp + 0x7df ]
   44832c:       0f 00 28 21     sethi  %hi(0xa08400), %g7
   448330:       8e 11 e2 b0     or  %g7, 0x2b0, %g7     ! a086b0 <iommu_batch>
   448334:       f0 71 c0 05     stx  %i0, [ %g7 + %g5 ]
   448338:       82 01 c0 05     add  %g7, %g5, %g1
   44833c:       c4 70 60 08     stx  %g2, [ %g1 + 8 ]
   448340:       84 10 3f ff     mov  -1, %g2
   448344:       c0 70 60 20     clrx  [ %g1 + 0x20 ]
   448348:       c4 70 60 10     stx  %g2, [ %g1 + 0x10 ]
   44834c:       c2 5e 22 00     ldx  [ %i0 + 0x200 ], %g1
   448350:       22 c0 40 0d     brz,a,pn   %g1, 448384 <dma_4v_map_sg+0xc4>
   448354:       c2 5e 21 e0     ldx  [ %i0 + 0x1e0 ], %g1
   448358:       e6 00 40 00     ld  [ %g1 ], %l3
   44835c:       05 00 00 40     sethi  %hi(0x10000), %g2
   448360:       c2 58 60 08     ldx  [ %g1 + 8 ], %g1
   448364:       80 a4 e0 00     cmp  %l3, 0
   448368:       02 c8 40 06     brz  %g1, 448380 <dma_4v_map_sg+0xc0>
   44836c:       a7 64 40 02     move  %icc, %g2, %l3
   448370:       25 00 00 08     sethi  %hi(0x2000), %l2
   448374:       a4 00 40 12     add  %g1, %l2, %l2
   448378:       a5 34 b0 0d     srlx  %l2, 0xd, %l2
   44837c:       e4 77 a7 df     stx  %l2, [ %fp + 0x7df ]
   448380:       c2 5e 21 e0     ldx  [ %i0 + 0x1e0 ], %g1
   448384:       b8 07 60 10     add  %i5, 0x10, %i4
   448388:       c2 58 40 00     ldx  [ %g1 ], %g1
   44838c:       c2 77 a7 d7     stx  %g1, [ %fp + 0x7d7 ]
   448390:       82 10 3f ff     mov  -1, %g1
   448394:       ce 5f a7 d7     ldx  [ %fp + 0x7d7 ], %g7
   448398:       83 30 70 20     srlx  %g1, 0x20, %g1
   44839c:       80 a1 c0 01     cmp  %g7, %g1
   4483a0:       b9 65 10 03     movleu  %xcc, %g3, %i4
   4483a4:       80 a6 a0 00     cmp  %i2, 0
   4483a8:       c2 5f 00 00     ldx  [ %i4 ], %g1
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   4483ac:       83 30 70 0d     srlx  %g1, 0xd, %g1
   4483b0:       04 40 01 26     ble,pn   %icc, 448848 <dma_4v_map_sg+0x588>
   4483b4:       c2 77 a7 9f     stx  %g1, [ %fp + 0x79f ]
   4483b8:       c2 5f a7 df     ldx  [ %fp + 0x7df ], %g1
   4483bc:       84 10 3f ff     mov  -1, %g2
   4483c0:       23 00 28 21     sethi  %hi(0xa08400), %l1
   4483c4:       ce 5f a7 df     ldx  [ %fp + 0x7df ], %g7
   4483c8:       a2 14 62 b0     or  %l1, 0x2b0, %l1
   4483cc:       86 10 20 01     mov  1, %g3
   4483d0:       82 00 7f ff     add  %g1, -1, %g1
   4483d4:       e6 27 a7 af     st  %l3, [ %fp + 0x7af ]
   4483d8:       ab 30 b0 33     srlx  %g2, 0x33, %l5
   4483dc:       8e 08 40 07     and  %g1, %g7, %g7
   4483e0:       c2 77 a7 cf     stx  %g1, [ %fp + 0x7cf ]
   4483e4:       a0 10 00 19     mov  %i1, %l0
   4483e8:       f2 77 a7 a7     stx  %i1, [ %fp + 0x7a7 ]
   4483ec:       b6 10 20 00     clr  %i3
   4483f0:       a8 10 00 11     mov  %l1, %l4
   4483f4:       c6 27 a7 b3     st  %g3, [ %fp + 0x7b3 ]
   4483f8:       a6 10 00 19     mov  %i1, %l3
   4483fc:       c0 77 a7 e7     clrx  [ %fp + 0x7e7 ]
   448400:       e2 77 a7 c7     stx  %l1, [ %fp + 0x7c7 ]
   448404:       ce 77 a7 97     stx  %g7, [ %fp + 0x797 ]
   448408:       f2 77 a7 b7     stx  %i1, [ %fp + 0x7b7 ]
   44840c:       f2 04 e0 0c     ld  [ %l3 + 0xc ], %i1
   448410:       a5 36 60 00     srl  %i1, 0, %l2
   448414:       2a c4 80 1d     brnz,a,pn   %l2, 448488 <dma_4v_map_sg+0x1c8>
   448418:       fa 5c c0 00     ldx  [ %l3 ], %i5
   44841c:       c0 77 a7 e7     clrx  [ %fp + 0x7e7 ]
   448420:       90 10 00 13     mov  %l3, %o0
   448424:       40 09 4b 47     call  69b140 <sg_next>
   448428:       b6 06 e0 01     inc  %i3
   44842c:       80 a6 c0 1a     cmp  %i3, %i2
   448430:       12 4f ff f7     bne  %icc, 44840c <dma_4v_map_sg+0x14c>
   448434:       a6 10 00 08     mov  %o0, %l3
   448438:       f2 5f a7 b7     ldx  [ %fp + 0x7b7 ], %i1
   44843c:       03 00 28 21     sethi  %hi(0xa08400), %g1
   448440:       92 10 20 a9     mov  0xa9, %o1
   448444:       82 10 62 b0     or  %g1, 0x2b0, %g1
   448448:       90 00 40 05     add  %g1, %g5, %o0
   44844c:       c2 5a 20 20     ldx  [ %o0 + 0x20 ], %g1
   448450:       80 a0 63 ff     cmp  %g1, 0x3ff
   448454:       38 60 00 5f     bgu,a,pn   %xcc, 4485d0 <dma_4v_map_sg+0x310>
   448458:       11 00 25 01     sethi  %hi(0x940400), %o0
   44845c:       7f ff ff 29     call  448100 <iommu_batch_flush>
   448460:       d2 5f a7 d7     ldx  [ %fp + 0x7d7 ], %o1
   448464:       06 c2 00 fd     brlz,pn   %o0, 448858 <dma_4v_map_sg+0x598>
   448468:       ce 5f a7 bf     ldx  [ %fp + 0x7bf ], %g7
   44846c:       91 91 c0 00     wrpr  %g7, %pil
   448470:       c2 07 a7 b3     ld  [ %fp + 0x7b3 ], %g1
   448474:       80 a0 40 1a     cmp  %g1, %i2
   448478:       06 40 00 e8     bl,pn   %icc, 448818 <dma_4v_map_sg+0x558>
   44847c:       01 00 00 00     nop
   448480:       10 68 00 58     b  %xcc, 4485e0 <dma_4v_map_sg+0x320>
   448484:       f0 07 a7 b3     ld  [ %fp + 0x7b3 ], %i0
   448488:       2d 00 28 60     sethi  %hi(0xa18000), %l6
   44848c:       ae 04 80 15     add  %l2, %l5, %l7
   448490:       d4 04 e0 08     ld  [ %l3 + 8 ], %o2
   448494:       9a 10 20 00     clr  %o5
   448498:       90 10 00 18     mov  %i0, %o0
   44849c:       ba 0f 7f fc     and  %i5, -4, %i5
   4484a0:       c2 5d a2 b0     ldx  [ %l6 + 0x2b0 ], %g1
   4484a4:       92 10 00 1c     mov  %i4, %o1
   4484a8:       c4 07 60 38     ld  [ %i5 + 0x38 ], %g2
   4484ac:       96 07 a7 f7     add  %fp, 0x7f7, %o3
   4484b0:       98 10 3f ff     mov  -1, %o4
   4484b4:       fa 07 60 3c     ld  [ %i5 + 0x3c ], %i5
   4484b8:       9f 28 b0 20     sllx  %g2, 0x20, %o7
   4484bc:       84 17 40 0f     or  %i5, %o7, %g2
   4484c0:       ba 00 80 0a     add  %g2, %o2, %i5
   4484c4:       ba 27 40 01     sub  %i5, %g1, %i5
   4484c8:       84 0f 40 15     and  %i5, %l5, %g2
   4484cc:       ae 05 c0 02     add  %l7, %g2, %l7
   4484d0:       af 35 f0 0d     srlx  %l7, 0xd, %l7
   4484d4:       7f ff c5 4b     call  439a00 <iommu_tbl_range_alloc>
   4484d8:       94 10 00 17     mov  %l7, %o2
   4484dc:       80 a2 3f ff     cmp  %o0, -1
   4484e0:       02 60 00 70     be,pn   %xcc, 4486a0 <dma_4v_map_sg+0x3e0>
   4484e4:       9a 10 00 08     mov  %o0, %o5
   4484e8:       84 04 40 05     add  %l1, %g5, %g2
   4484ec:       d8 58 a0 10     ldx  [ %g2 + 0x10 ], %o4
   4484f0:       de 58 a0 20     ldx  [ %g2 + 0x20 ], %o7
   4484f4:       9e 03 00 0f     add  %o4, %o7, %o7
   4484f8:       80 a2 00 0f     cmp  %o0, %o7
   4484fc:       02 60 00 0b     be,pn   %xcc, 448528 <dma_4v_map_sg+0x268>
   448500:       80 a3 3f ff     cmp  %o4, -1
   448504:       02 60 00 08     be,pn   %xcc, 448524 <dma_4v_map_sg+0x264>
   448508:       d2 5f a7 d7     ldx  [ %fp + 0x7d7 ], %o1
   44850c:       90 10 00 02     mov  %g2, %o0
   448510:       c4 77 a7 7f     stx  %g2, [ %fp + 0x77f ]
   448514:       7f ff fe fb     call  448100 <iommu_batch_flush>
   448518:       da 77 a7 67     stx  %o5, [ %fp + 0x767 ]
   44851c:       da 5f a7 67     ldx  [ %fp + 0x767 ], %o5
   448520:       c4 5f a7 7f     ldx  [ %fp + 0x77f ], %g2
   448524:       da 70 a0 10     stx  %o5, [ %g2 + 0x10 ]
   448528:       c4 5f a7 c7     ldx  [ %fp + 0x7c7 ], %g2
   44852c:       86 10 3f ff     mov  -1, %g3
   448530:       ae 05 ff ff     add  %l7, -1, %l7
   448534:       9f 28 f0 0d     sllx  %g3, 0xd, %o7
   448538:       d8 5f 00 00     ldx  [ %i4 ], %o4
   44853c:       90 00 80 05     add  %g2, %g5, %o0
   448540:       ba 0f 40 0f     and  %i5, %o7, %i5
   448544:       c4 5a 20 20     ldx  [ %o0 + 0x20 ], %g2
   448548:       80 a0 a3 ff     cmp  %g2, 0x3ff
   44854c:       18 60 00 1f     bgu,pn   %xcc, 4485c8 <dma_4v_map_sg+0x308>
   448550:       d4 04 e0 08     ld  [ %l3 + 8 ], %o2
   448554:       82 10 00 11     mov  %l1, %g1
   448558:       f2 27 a7 93     st  %i1, [ %fp + 0x793 ]
   44855c:       a2 10 00 1b     mov  %i3, %l1
   448560:       b2 10 00 1a     mov  %i2, %i1
   448564:       b6 10 00 1c     mov  %i4, %i3
   448568:       b4 10 00 14     mov  %l4, %i2
   44856c:       b8 10 00 17     mov  %l7, %i4
   448570:       a8 10 00 18     mov  %i0, %l4
   448574:       17 00 00 08     sethi  %hi(0x2000), %o3
   448578:       b0 10 00 0c     mov  %o4, %i0
   44857c:       ae 10 00 01     mov  %g1, %l7
   448580:       c2 5a 20 18     ldx  [ %o0 + 0x18 ], %g1
   448584:       9e 00 a0 01     add  %g2, 1, %o7
   448588:       85 28 b0 03     sllx  %g2, 3, %g2
   44858c:       de 72 20 20     stx  %o7, [ %o0 + 0x20 ]
   448590:       fa 70 40 02     stx  %i5, [ %g1 + %g2 ]
   448594:       c2 5a 20 20     ldx  [ %o0 + 0x20 ], %g1
   448598:       80 a0 64 00     cmp  %g1, 0x400
   44859c:       02 60 00 13     be,pn   %xcc, 4485e8 <dma_4v_map_sg+0x328>
   4485a0:       d2 5f a7 d7     ldx  [ %fp + 0x7d7 ], %o1
   4485a4:       b8 07 3f ff     add  %i4, -1, %i4
   4485a8:       80 a7 3f ff     cmp  %i4, -1
   4485ac:       02 60 00 4f     be,pn   %xcc, 4486e8 <dma_4v_map_sg+0x428>
   4485b0:       ba 07 40 0b     add  %i5, %o3, %i5
   4485b4:       90 06 80 05     add  %i2, %g5, %o0
   4485b8:       c4 5a 20 20     ldx  [ %o0 + 0x20 ], %g2
   4485bc:       80 a0 a3 ff     cmp  %g2, 0x3ff
   4485c0:       28 6f ff f1     bleu,a   %xcc, 448584 <dma_4v_map_sg+0x2c4>
   4485c4:       c2 5a 20 18     ldx  [ %o0 + 0x18 ], %g1
   4485e0:       81 cf e0 08     rett  %i7 + 8
   4485e4:       91 3a 20 00     sra  %o0, 0, %o0
   4485e8:       d4 77 a7 77     stx  %o2, [ %fp + 0x777 ]
   4485ec:       d6 77 a7 6f     stx  %o3, [ %fp + 0x76f ]
   4485f0:       7f ff fe c4     call  448100 <iommu_batch_flush>
   4485f4:       da 77 a7 67     stx  %o5, [ %fp + 0x767 ]
   4485f8:       d4 5f a7 77     ldx  [ %fp + 0x777 ], %o2
   4485fc:       d6 5f a7 6f     ldx  [ %fp + 0x76f ], %o3
   448600:       0e f2 3f e9     brgez,pn   %o0, 4485a4 <dma_4v_map_sg+0x2e4>
   448604:       da 5f a7 67     ldx  [ %fp + 0x767 ], %o5
   448608:       b4 10 00 19     mov  %i1, %i2
   44860c:       f2 5f a7 b7     ldx  [ %fp + 0x7b7 ], %i1
   448610:       b8 10 00 1b     mov  %i3, %i4
   448614:       b6 10 3f ff     mov  -1, %i3
   448618:       ba 10 20 00     clr  %i5
   44861c:       b1 2e f0 0d     sllx  %i3, 0xd, %i0
   448620:       b7 36 f0 33     srlx  %i3, 0x33, %i3
   448624:       d4 06 60 18     ld  [ %i1 + 0x18 ], %o2
   448628:       80 a2 a0 00     cmp  %o2, 0
   44862c:       32 40 00 10     bne,a,pn   %icc, 44866c <dma_4v_map_sg+0x3ac>
   448630:       d2 5e 60 10     ldx  [ %i1 + 0x10 ], %o1
   448634:       80 a6 40 10     cmp  %i1, %l0
   448638:       02 60 00 09     be,pn   %xcc, 44865c <dma_4v_map_sg+0x39c>
   44863c:       c2 5f a7 bf     ldx  [ %fp + 0x7bf ], %g1
   448640:       90 10 00 19     mov  %i1, %o0
   448644:       40 09 4a bf     call  69b140 <sg_next>
   448648:       ba 07 60 01     inc  %i5
   44864c:       80 a7 40 1a     cmp  %i5, %i2
   448650:       06 4f ff f5     bl  %icc, 448624 <dma_4v_map_sg+0x364>
   448654:       b2 10 00 08     mov  %o0, %i1
   448658:       c2 5f a7 bf     ldx  [ %fp + 0x7bf ], %g1
   44865c:       91 90 40 00     wrpr  %g1, %pil
   448660:       b0 10 20 00     clr  %i0
   448664:       81 cf e0 08     rett  %i7 + 8
   448668:       91 3a 20 00     sra  %o0, 0, %o0
   44866c:       95 32 a0 00     srl  %o2, 0, %o2
   448670:       90 10 00 1c     mov  %i4, %o0
   448674:       96 10 3f ff     mov  -1, %o3
   448678:       82 0a 40 1b     and  %o1, %i3, %g1
   44867c:       92 0a 40 18     and  %o1, %i0, %o1
   448680:       94 02 80 01     add  %o2, %g1, %o2
   448684:       94 02 80 1b     add  %o2, %i3, %o2
   448688:       7f ff c5 c6     call  439da0 <iommu_tbl_range_free>
   44868c:       95 32 b0 0d     srlx  %o2, 0xd, %o2
   448690:       86 10 3f ff     mov  -1, %g3
   448694:       c0 26 60 18     clr  [ %i1 + 0x18 ]
   448698:       10 6f ff e7     b  %xcc, 448634 <dma_4v_map_sg+0x374>
   44869c:       c6 76 60 10     stx  %g3, [ %i1 + 0x10 ]
   4486a0:       11 00 26 b3     sethi  %hi(0x9acc00), %o0
   4486a4:       13 00 22 e3     sethi  %hi(0x8b8c00), %o1
.....


-- 
Meelis Roos
