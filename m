From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Aic94xx and Linux kernel 2.6.19
Date: Fri, 10 Nov 2006 17:21:16 -0800 (PST)
Message-ID: <834553.41356.qm@web31804.mail.mud.yahoo.com>
References: <455510F0.6010000@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-774875687-1163208076=:41356"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:34715 "HELO
	web31804.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1424485AbWKKBVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 20:21:17 -0500
In-Reply-To: <455510F0.6010000@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, mike.redan@bell.ca
Cc: James.Bottomley@SteelEye.com, alexisb@us.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>

--0-774875687-1163208076=:41356
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

--- "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> [Hm, linux-scsi ought to be cc'd on this...]
> 
> mike.redan@bell.ca wrote:
> >> Here they are:
> >> Nov 10 02:08:08 192.168.207.10/192.168.207.10 kernel: sd 0:0:0:0: SCSI
> >> error: return code = 0x00070000
> >> Nov 10 02:08:08 192.168.207.10/192.168.207.10 kernel: end_request: I/O
> >> error, dev sda, sector 77429847 
> > 
> > Yep, I've seen that now too.  It looks to me like we're getting
> > DID_ERROR for some reason.  The only reason for that in the libata code
> > seems to deal with bad SCSI commands and/or memory allocation problems,
> > but I'll keep digging.
> 
> These errors are memory allocation problems in libata.  When I plug a
> whole lot of SAS and SATA disks into my x260 and run the pounder stress
> test, the amount of buffers on my system increases over a period of
> about twenty minutes until libata can no longer allocate ata_queued_cmd
> structures.  At this point we start seeing the errors above.  Since we
> can't allocate new commands, libsas/aic94xx never even get called, which
> is why they are silent on the matter.  However, if I kill pounder before
> totally running out of memory, the amount of buffers will decrease very
> rapidly and the system is ok.
> 
> So, a question to you, Mr. Redan: What does /proc/meminfo look like at
> crash time?  If you have a huge amount of buffers, then we're seeing the
> same thing.

I've been seeing the same thing for some time now.  Kernel log attached.
Notes on the kernel log:
1. Thread names are 20 chars not 16, this is so that I can fit a whole
   SAS port address into the name of a thread (SATL) so that I can see
   which device was problematic.  Patch posted long time ago to linux-kernel,
   http://marc.theaimsgroup.com/?l=linux-kernel&m=115171611120087&w=2.
2. I'm not using libata, but SATL, as the stack traces show.
3. I never see a crash.  After the transport driver couldn't allocate
   memory and returned 0xFFFFFFF4 (-ENOMEM), the SATL task is put
   back on the list of tasks to be executed, task order, NCQ, etc perfectly
   preserved. (SATL supports NCQ and Full Task Management, btw.)  The second time
   around* allocation succeeds and the task(s) are executed.  The application
   client (I/O tester application/whatever, in user space) never detects this,
   since the task does complete and status is returned to the application client.

That is,
  Nov 10 16:32:20 lion kernel: satl: satl_send_task: error queuing: 0xfffffff4
means deferred to be requeued as soon as possible but no sooner.  And when
this happens, memory allocation succeeds, the task is executed and completed,
and the block layer and application client don't know what happened.
(As you can see, there is no error recovery traces in the log.)

* "When" this happens, is naturally and dynamically determined based on the
overall load of the system, it could be immediate or after some scheduling.

E.g. mkfs.ext2 run simultaneously on many SATA drives, does evoke
this behavior, but mkfs.ext2 does succeed and finishes ok, since
the second time around allocation succeeds.

I.e the block layer never sees or detects this.

If, OTOH, memory allocation fails indefinitely, then the task
will timeout, and the application client/block layer/etc will
invoke error recovery (ABORT TASK) on the task and the task
will be recovered with response SERVICE DELIVERY OR TARGET FAILURE.

    Luben


> And a question for everyone else: Because the buffers drain out fairly
> quickly after pounder dies, does this mean that the controller is being
> subjected to too much I/O at once?
> 
> --D
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--0-774875687-1163208076=:41356
Content-Type: text/plain; name="mem_out.txt"
Content-Description: 2180057349-mem_out.txt
Content-Disposition: inline; filename="mem_out.txt"


Nov 10 16:30:49 lion kernel: ccaaaa1716014604: page allocation failure. order:0, mode:0x10d0
Nov 10 16:30:49 lion kernel: 
Nov 10 16:30:49 lion kernel: Call Trace:
Nov 10 16:30:49 lion kernel: [<ffffffff8020af31>] dump_trace+0xb3/0x426
Nov 10 16:30:49 lion kernel: [<ffffffff8020b2e0>] show_trace+0x3c/0x55
Nov 10 16:30:49 lion kernel: [<ffffffff8020b30e>] dump_stack+0x15/0x17
Nov 10 16:30:49 lion kernel: [<ffffffff802634aa>] __alloc_pages+0x2d4/0x2ec
Nov 10 16:30:49 lion kernel: [<ffffffff80210f6d>] dma_alloc_pages+0xaf/0xd8
Nov 10 16:30:50 lion kernel: [<ffffffff80211016>] dma_alloc_coherent+0x80/0x242
Nov 10 16:30:50 lion kernel: [<ffffffff8806e8a2>] xyz_execute_task+0x451/0xdd5 [__xyz__]
Nov 10 16:30:50 lion kernel: [<ffffffff88046ea6>] satl_send_task+0x18d/0x217 [sas_class]
Nov 10 16:30:50 lion kernel: [<ffffffff88045e70>] satl_task_thread+0x142/0x161 [sas_class]
Nov 10 16:30:50 lion kernel: [<ffffffff8020a788>] child_rip+0xa/0x12
Nov 10 16:30:50 lion kernel: 
Nov 10 16:30:50 lion kernel: Mem-info:
Nov 10 16:30:50 lion kernel: Node 0 DMA per-cpu:
Nov 10 16:30:50 lion kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:50 lion kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:50 lion kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:50 lion kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:50 lion kernel: Node 0 DMA32 per-cpu:
Nov 10 16:30:50 lion kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15 usd:  51
Nov 10 16:30:50 lion kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  58
Nov 10 16:30:50 lion kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  19   Cold: hi:   62, btch:  15 usd:  59
Nov 10 16:30:50 lion kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:   62, btch:  15 usd:  58
Nov 10 16:30:50 lion kernel: Active:131525 inactive:189569 dirty:99038 writeback:8888 unstable:0 free:4213 slab:181745 mapped:15017 pagetables:2133
Nov 10 16:30:50 lion kernel: Node 0 DMA free:8024kB min:24kB low:28kB high:36kB active:376kB inactive:176kB present:9128kB pages_scanned:96 all_unreclaimable? no
Nov 10 16:30:50 lion kernel: lowmem_reserve[]: 0 1999 1999
Nov 10 16:30:50 lion kernel: Node 0 DMA32 free:6904kB min:5708kB low:7132kB high:8560kB active:521596kB inactive:763684kB present:2047692kB pages_scanned:0 all_unreclaimable? no
Nov 10 16:30:50 lion kernel: lowmem_reserve[]: 0 0 0
Nov 10 16:30:50 lion kernel: Node 0 DMA: 2*4kB 0*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8024kB
Nov 10 16:30:50 lion kernel: Node 0 DMA32: 67*4kB 12*8kB 72*16kB 16*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 1*4096kB = 7468kB
Nov 10 16:30:50 lion kernel: Swap cache: add 1115, delete 1115, find 558/647, race 0+1
Nov 10 16:30:50 lion kernel: Free swap  = 2096244kB
Nov 10 16:30:50 lion kernel: Total swap = 2096440kB
Nov 10 16:30:50 lion kernel: Free swap:       2096244kB
Nov 10 16:30:50 lion kernel: 524144 pages of RAM
Nov 10 16:30:50 lion kernel: 10739 reserved pages
Nov 10 16:30:50 lion kernel: 236018 pages shared
Nov 10 16:30:50 lion kernel: 0 pages swap cached
Nov 10 16:30:50 lion kernel: satl: satl_send_task: error queuing: 0xfffffff4
Nov 10 16:30:53 lion kernel: ccaaaa1716014604: page allocation failure. order:0, mode:0x10d0
Nov 10 16:30:53 lion kernel: 
Nov 10 16:30:53 lion kernel: Call Trace:
Nov 10 16:30:53 lion kernel: [<ffffffff8020af31>] dump_trace+0xb3/0x426
Nov 10 16:30:53 lion kernel: [<ffffffff8020b2e0>] show_trace+0x3c/0x55
Nov 10 16:30:53 lion kernel: [<ffffffff8020b30e>] dump_stack+0x15/0x17
Nov 10 16:30:53 lion kernel: [<ffffffff802634aa>] __alloc_pages+0x2d4/0x2ec
Nov 10 16:30:53 lion kernel: [<ffffffff80210f6d>] dma_alloc_pages+0xaf/0xd8
Nov 10 16:30:53 lion kernel: [<ffffffff80211016>] dma_alloc_coherent+0x80/0x242
Nov 10 16:30:53 lion kernel: [<ffffffff8806e8a2>] xyz_execute_task+0x451/0xdd5 [__xyz__]
Nov 10 16:30:53 lion kernel: [<ffffffff88046ea6>] satl_send_task+0x18d/0x217 [sas_class]
Nov 10 16:30:53 lion kernel: [<ffffffff88045e70>] satl_task_thread+0x142/0x161 [sas_class]
Nov 10 16:30:53 lion kernel: [<ffffffff8020a788>] child_rip+0xa/0x12
Nov 10 16:30:53 lion kernel: 
Nov 10 16:30:53 lion kernel: Mem-info:
Nov 10 16:30:53 lion kernel: Node 0 DMA per-cpu:
Nov 10 16:30:53 lion kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:53 lion kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:53 lion kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:53 lion kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:53 lion kernel: Node 0 DMA32 per-cpu:
Nov 10 16:30:53 lion kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  65   Cold: hi:   62, btch:  15 usd:  52
Nov 10 16:30:53 lion kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  77   Cold: hi:   62, btch:  15 usd:  47
Nov 10 16:30:53 lion kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  59
Nov 10 16:30:53 lion kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  59
Nov 10 16:30:53 lion kernel: Active:97021 inactive:268063 dirty:137452 writeback:4914 unstable:0 free:3450 slab:138643 mapped:15017 pagetables:2133
Nov 10 16:30:53 lion kernel: Node 0 DMA free:8020kB min:24kB low:28kB high:36kB active:376kB inactive:400kB present:9128kB pages_scanned:0 all_unreclaimable? no
Nov 10 16:30:53 lion kernel: lowmem_reserve[]: 0 1999 1999
Nov 10 16:30:53 lion kernel: Node 0 DMA32 free:5880kB min:5708kB low:7132kB high:8560kB active:387708kB inactive:1072444kB present:2047692kB pages_scanned:32 all_unreclaimable? no
Nov 10 16:30:53 lion kernel: lowmem_reserve[]: 0 0 0
Nov 10 16:30:53 lion kernel: Node 0 DMA: 2*4kB 0*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8024kB
Nov 10 16:30:53 lion kernel: Node 0 DMA32: 70*4kB 9*8kB 17*16kB 4*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 1*4096kB = 6192kB
Nov 10 16:30:53 lion kernel: Swap cache: add 1115, delete 1115, find 558/647, race 0+1
Nov 10 16:30:53 lion kernel: Free swap  = 2096244kB
Nov 10 16:30:53 lion kernel: Total swap = 2096440kB
Nov 10 16:30:53 lion kernel: Free swap:       2096244kB
Nov 10 16:30:53 lion kernel: 524144 pages of RAM
Nov 10 16:30:53 lion kernel: 10739 reserved pages
Nov 10 16:30:53 lion kernel: 306043 pages shared
Nov 10 16:30:53 lion kernel: 0 pages swap cached
Nov 10 16:30:53 lion kernel: satl: satl_send_task: error queuing: 0xfffffff4
Nov 10 16:30:57 lion kernel: ddaabb1716013504: page allocation failure. order:0, mode:0x10d0
Nov 10 16:30:57 lion kernel: 
Nov 10 16:30:57 lion kernel: Call Trace:
Nov 10 16:30:57 lion kernel: [<ffffffff8020af31>] dump_trace+0xb3/0x426
Nov 10 16:30:57 lion kernel: [<ffffffff8020b2e0>] show_trace+0x3c/0x55
Nov 10 16:30:57 lion kernel: [<ffffffff8020b30e>] dump_stack+0x15/0x17
Nov 10 16:30:57 lion kernel: [<ffffffff802634aa>] __alloc_pages+0x2d4/0x2ec
Nov 10 16:30:57 lion kernel: [<ffffffff80210f6d>] dma_alloc_pages+0xaf/0xd8
Nov 10 16:30:57 lion kernel: [<ffffffff80211016>] dma_alloc_coherent+0x80/0x242
Nov 10 16:30:57 lion kernel: [<ffffffff8806e8a2>] xyz_execute_task+0x451/0xdd5 [__xyz__]
Nov 10 16:30:57 lion kernel: [<ffffffff88046ea6>] satl_send_task+0x18d/0x217 [sas_class]
Nov 10 16:30:57 lion kernel: [<ffffffff88045e70>] satl_task_thread+0x142/0x161 [sas_class]
Nov 10 16:30:57 lion kernel: [<ffffffff8020a788>] child_rip+0xa/0x12
Nov 10 16:30:57 lion kernel: 
Nov 10 16:30:57 lion kernel: Mem-info:
Nov 10 16:30:57 lion kernel: Node 0 DMA per-cpu:
Nov 10 16:30:57 lion kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:57 lion kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:57 lion kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:57 lion kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:57 lion kernel: Node 0 DMA32 per-cpu:
Nov 10 16:30:57 lion kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  57
Nov 10 16:30:57 lion kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  76   Cold: hi:   62, btch:  15 usd:  53
Nov 10 16:30:57 lion kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Nov 10 16:30:57 lion kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  59
Nov 10 16:30:57 lion kernel: Active:95731 inactive:301639 dirty:188572 writeback:12725 unstable:0 free:3687 slab:106032 mapped:15017 pagetables:2133
Nov 10 16:30:57 lion kernel: Node 0 DMA free:8024kB min:24kB low:28kB high:36kB active:376kB inactive:900kB present:9128kB pages_scanned:0 all_unreclaimable? no
Nov 10 16:30:57 lion kernel: lowmem_reserve[]: 0 1999 1999
Nov 10 16:30:57 lion kernel: Node 0 DMA32 free:7340kB min:5708kB low:7132kB high:8560kB active:382548kB inactive:1205580kB present:2047692kB pages_scanned:0 all_unreclaimable? no
Nov 10 16:30:57 lion kernel: lowmem_reserve[]: 0 0 0
Nov 10 16:30:57 lion kernel: Node 0 DMA: 2*4kB 0*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8024kB
Nov 10 16:30:57 lion kernel: Node 0 DMA32: 633*4kB 71*8kB 20*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 1*4096kB = 8892kB
Nov 10 16:30:57 lion kernel: Swap cache: add 1115, delete 1115, find 558/647, race 0+1
Nov 10 16:30:57 lion kernel: Free swap  = 2096244kB
Nov 10 16:30:57 lion kernel: Total swap = 2096440kB
Nov 10 16:30:57 lion kernel: Free swap:       2096244kB
Nov 10 16:30:57 lion kernel: 524144 pages of RAM
Nov 10 16:30:57 lion kernel: 10739 reserved pages
Nov 10 16:30:57 lion kernel: 352841 pages shared
Nov 10 16:30:57 lion kernel: 0 pages swap cached
Nov 10 16:30:57 lion kernel: satl: satl_send_task: error queuing: 0xfffffff4
Nov 10 16:30:59 lion kernel: ccaaaa1716014602: page allocation failure. order:0, mode:0x10d0
Nov 10 16:30:59 lion kernel: ddaabb1716013504: page allocation failure. order:0, mode:0x10d0
Nov 10 16:30:59 lion kernel: 
Nov 10 16:30:59 lion kernel: Call Trace:
Nov 10 16:30:59 lion kernel: [<ffffffff8020af31>] dump_trace+0xb3/0x426
Nov 10 16:30:59 lion kernel: [<ffffffff8020b2e0>] show_trace+0x3c/0x55
Nov 10 16:30:59 lion kernel: [<ffffffff8020b30e>] dump_stack+0x15/0x17
Nov 10 16:30:59 lion kernel: [<ffffffff802634aa>] __alloc_pages+0x2d4/0x2ec
Nov 10 16:30:59 lion kernel: [<ffffffff80210f6d>] dma_alloc_pages+0xaf/0xd8
Nov 10 16:30:59 lion kernel: [<ffffffff80211016>] dma_alloc_coherent+0x80/0x242
Nov 10 16:30:59 lion kernel: [<ffffffff8806e8a2>] xyz_execute_task+0x451/0xdd5 [__xyz__]
Nov 10 16:30:59 lion kernel: [<ffffffff88046ea6>] satl_send_task+0x18d/0x217 [sas_class]
Nov 10 16:30:59 lion kernel: [<ffffffff88045e70>] satl_task_thread+0x142/0x161 [sas_class]
Nov 10 16:30:59 lion kernel: [<ffffffff8020a788>] child_rip+0xa/0x12
Nov 10 16:30:59 lion kernel: 
Nov 10 16:30:59 lion kernel: Mem-info:
Nov 10 16:30:59 lion kernel: Node 0 DMA per-cpu:
Nov 10 16:30:59 lion kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:59 lion kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:59 lion kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:59 lion kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:59 lion kernel: Node 0 DMA32 per-cpu:
Nov 10 16:30:59 lion kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  32   Cold: hi:   62, btch:  15 usd:  58
Nov 10 16:30:59 lion kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  68   Cold: hi:   62, btch:  15 usd:  61
Nov 10 16:30:59 lion kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Nov 10 16:30:59 lion kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 130   Cold: hi:   62, btch:  15 usd:  59
Nov 10 16:30:59 lion kernel: Active:95821 inactive:309252 dirty:183634 writeback:19463 unstable:0 free:3432 slab:98400 mapped:15017 pagetables:2133
Nov 10 16:30:59 lion kernel: Node 0 DMA free:8020kB min:24kB low:28kB high:36kB active:376kB inactive:720kB present:9128kB pages_scanned:32 all_unreclaimable? no
Nov 10 16:30:59 lion kernel: lowmem_reserve[]: 0 1999 1999
Nov 10 16:30:59 lion kernel: Node 0 DMA32 free:5708kB min:5708kB low:7132kB high:8560kB active:382908kB inactive:1236288kB present:2047692kB pages_scanned:3168 all_unreclaimable? no
Nov 10 16:30:59 lion kernel: lowmem_reserve[]: 0 0 0
Nov 10 16:30:59 lion kernel: Node 0 DMA: 1*4kB 0*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8020kB
Nov 10 16:30:59 lion kernel: Node 0 DMA32: 9*4kB 11*8kB 1*16kB 4*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 1*4096kB = 5708kB
Nov 10 16:30:59 lion kernel: Swap cache: add 1265, delete 1115, find 558/647, race 0+1
Nov 10 16:30:59 lion kernel: Free swap  = 2095644kB
Nov 10 16:30:59 lion kernel: Total swap = 2096440kB
Nov 10 16:30:59 lion kernel: Free swap:       2095644kB
Nov 10 16:30:59 lion kernel: 524144 pages of RAM
Nov 10 16:30:59 lion kernel: 10739 reserved pages
Nov 10 16:30:59 lion kernel: 361141 pages shared
Nov 10 16:30:59 lion kernel: 162 pages swap cached
Nov 10 16:30:59 lion kernel: satl: satl_send_task: error queuing: 0xfffffff4
Nov 10 16:30:59 lion kernel: 
Nov 10 16:30:59 lion kernel: Call Trace:
Nov 10 16:30:59 lion kernel: [<ffffffff8020af31>] dump_trace+0xb3/0x426
Nov 10 16:30:59 lion kernel: [<ffffffff8020b2e0>] show_trace+0x3c/0x55
Nov 10 16:30:59 lion kernel: [<ffffffff8020b30e>] dump_stack+0x15/0x17
Nov 10 16:30:59 lion kernel: [<ffffffff802634aa>] __alloc_pages+0x2d4/0x2ec
Nov 10 16:30:59 lion kernel: [<ffffffff80210f6d>] dma_alloc_pages+0xaf/0xd8
Nov 10 16:30:59 lion kernel: [<ffffffff80211016>] dma_alloc_coherent+0x80/0x242
Nov 10 16:30:59 lion kernel: [<ffffffff8806e8a2>] xyz_execute_task+0x451/0xdd5 [__xyz__]
Nov 10 16:30:59 lion kernel: [<ffffffff88046ea6>] satl_send_task+0x18d/0x217 [sas_class]
Nov 10 16:30:59 lion kernel: [<ffffffff88045e70>] satl_task_thread+0x142/0x161 [sas_class]
Nov 10 16:30:59 lion kernel: [<ffffffff8020a788>] child_rip+0xa/0x12
Nov 10 16:30:59 lion kernel: 
Nov 10 16:30:59 lion kernel: Mem-info:
Nov 10 16:30:59 lion kernel: Node 0 DMA per-cpu:
Nov 10 16:30:59 lion kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:59 lion kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:59 lion kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:59 lion kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:30:59 lion kernel: Node 0 DMA32 per-cpu:
Nov 10 16:30:59 lion kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  32   Cold: hi:   62, btch:  15 usd:  58
Nov 10 16:30:59 lion kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  14   Cold: hi:   62, btch:  15 usd:  54
Nov 10 16:30:59 lion kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:  49
Nov 10 16:30:59 lion kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  59
Nov 10 16:30:59 lion kernel: Active:95821 inactive:309442 dirty:189916 writeback:14699 unstable:0 free:4144 slab:97718 mapped:15017 pagetables:2133
Nov 10 16:30:59 lion kernel: Node 0 DMA free:8024kB min:24kB low:28kB high:36kB active:376kB inactive:820kB present:9128kB pages_scanned:0 all_unreclaimable? no
Nov 10 16:30:59 lion kernel: lowmem_reserve[]: 0 1999 1999
Nov 10 16:30:59 lion kernel: Node 0 DMA32 free:8708kB min:5708kB low:7132kB high:8560kB active:382908kB inactive:1237076kB present:2047692kB pages_scanned:0 all_unreclaimable? no
Nov 10 16:30:59 lion kernel: lowmem_reserve[]: 0 0 0
Nov 10 16:30:59 lion kernel: Node 0 DMA: 15*4kB 0*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8076kB
Nov 10 16:30:59 lion kernel: Node 0 DMA32: 219*4kB 161*8kB 53*16kB 8*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 1*4096kB = 8708kB
Nov 10 16:30:59 lion kernel: Swap cache: add 1285, delete 1115, find 558/647, race 0+1
Nov 10 16:30:59 lion kernel: Free swap  = 2095564kB
Nov 10 16:30:59 lion kernel: Total swap = 2096440kB
Nov 10 16:30:59 lion kernel: Free swap:       2095564kB
Nov 10 16:30:59 lion kernel: 524144 pages of RAM
Nov 10 16:30:59 lion kernel: 10739 reserved pages
Nov 10 16:30:59 lion kernel: 361627 pages shared
Nov 10 16:31:00 lion kernel: 170 pages swap cached
Nov 10 16:31:00 lion kernel: satl: satl_send_task: error queuing: 0xfffffff4
Nov 10 16:32:20 lion kernel: ccaaaa1716014602: page allocation failure. order:0, mode:0x10d0
Nov 10 16:32:20 lion kernel: 
Nov 10 16:32:20 lion kernel: Call Trace:
Nov 10 16:32:20 lion kernel: [<ffffffff8020af31>] dump_trace+0xb3/0x426
Nov 10 16:32:20 lion kernel: [<ffffffff8020b2e0>] show_trace+0x3c/0x55
Nov 10 16:32:20 lion kernel: [<ffffffff8020b30e>] dump_stack+0x15/0x17
Nov 10 16:32:20 lion kernel: [<ffffffff802634aa>] __alloc_pages+0x2d4/0x2ec
Nov 10 16:32:20 lion kernel: [<ffffffff80210f6d>] dma_alloc_pages+0xaf/0xd8
Nov 10 16:32:20 lion kernel: [<ffffffff80211016>] dma_alloc_coherent+0x80/0x242
Nov 10 16:32:20 lion kernel: [<ffffffff8806e8a2>] xyz_execute_task+0x451/0xdd5 [__xyz__]
Nov 10 16:32:20 lion kernel: [<ffffffff88046ea6>] satl_send_task+0x18d/0x217 [sas_class]
Nov 10 16:32:20 lion kernel: [<ffffffff88045e70>] satl_task_thread+0x142/0x161 [sas_class]
Nov 10 16:32:20 lion kernel: [<ffffffff8020a788>] child_rip+0xa/0x12
Nov 10 16:32:20 lion kernel: 
Nov 10 16:32:20 lion kernel: Mem-info:
Nov 10 16:32:20 lion kernel: Node 0 DMA per-cpu:
Nov 10 16:32:20 lion kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:32:20 lion kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:32:20 lion kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:32:20 lion kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Nov 10 16:32:20 lion kernel: Node 0 DMA32 per-cpu:
Nov 10 16:32:20 lion kernel: CPU    0: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:   62, btch:  15 usd:  50
Nov 10 16:32:20 lion kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  59
Nov 10 16:32:20 lion kernel: CPU    2: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:  48
Nov 10 16:32:20 lion kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 176   Cold: hi:   62, btch:  15 usd:  61
Nov 10 16:32:20 lion kernel: Active:94212 inactive:345729 dirty:192467 writeback:12775 unstable:0 free:4065 slab:63317 mapped:15017 pagetables:2080
Nov 10 16:32:20 lion kernel: Node 0 DMA free:8028kB min:24kB low:28kB high:36kB active:376kB inactive:680kB present:9128kB pages_scanned:0 all_unreclaimable? no
Nov 10 16:32:20 lion kernel: lowmem_reserve[]: 0 1999 1999
Nov 10 16:32:20 lion kernel: Node 0 DMA32 free:8232kB min:5708kB low:7132kB high:8560kB active:376472kB inactive:1382248kB present:2047692kB pages_scanned:0 all_unreclaimable? no
Nov 10 16:32:20 lion kernel: lowmem_reserve[]: 0 0 0
Nov 10 16:32:20 lion kernel: Node 0 DMA: 1*4kB 1*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8028kB
Nov 10 16:32:20 lion kernel: Node 0 DMA32: 157*4kB 157*8kB 47*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 1*4096kB = 8108kB
Nov 10 16:32:20 lion kernel: Swap cache: add 1314, delete 1302, find 566/659, race 0+1
Nov 10 16:32:20 lion kernel: Free swap  = 2095564kB
Nov 10 16:32:20 lion kernel: Total swap = 2096440kB
Nov 10 16:32:20 lion kernel: Free swap:       2095564kB
Nov 10 16:32:20 lion kernel: 524144 pages of RAM
Nov 10 16:32:20 lion kernel: 10739 reserved pages
Nov 10 16:32:20 lion kernel: 398667 pages shared
Nov 10 16:32:20 lion kernel: 12 pages swap cached
Nov 10 16:32:20 lion kernel: satl: satl_send_task: error queuing: 0xfffffff4

--0-774875687-1163208076=:41356--
