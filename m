From: Meelis Roos <mroos@linux.ee>
Subject: Re: parisc late boot crash in 4.4-rc, scsi-related
Date: Mon, 16 May 2016 23:40:09 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1605162336050.12607@math.ut.ee>
References: <alpine.LRH.2.20.1601082329270.23187@math.ut.ee> <56902D77.1020200@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:56395 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcEPUy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2016 16:54:26 -0400
In-Reply-To: <56902D77.1020200@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

> > I noticed on RP3440 and A500 that recent 4.4-rc* crashes on boot.
> 
> I've not seen it with 4.4-rc yet, but I've seen it on debian kernel 4.3.3:

This is still present in 4.6, just tested. All my pariscs are broken  
- A500, RP3410, RP3440. 4.3 is the latest working release for me. If 
4.3.3 is broken, it might be possible to bisect more easily.

sym0: <1010-66> rev 0x1 at pci 0000:20:01.0 irq 22
sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi host0: sym-2.2.3
scsi 0:0:0:0: Direct-Access     COMPAQ   BF07285A36       HPB7 PQ: 0 ANSI: 3
scsi target0:0:0: tagged command queuing enabled, command queue depth 16.
scsi target0:0:0: Beginning Domain Validation
scsi target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi target0:0:0: Ending Domain Validation
random: nonblocking pool is initialized
sym1: <1010-66> rev 0x1 at pci 0000:20:01.1 irq 23
sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi host1: sym-2.2.3
bioset (67) used greatest stack depth: 13864 bytes left
bioset (82) used greatest stack depth: 13608 bytes left
mousedev: PS/2 mouse device common for all mice
sd 0:0:0:0: [sda] 142264000 512-byte logical blocks: (72.8 GB/67.8 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
NET: Registered protocol family 17
rtc-generic rtc-generic: setting system clock to 2016-05-16 20:41:06 UTC (1463431266)
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
EXT4-fs (sda3): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda3): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
devtmpfs: mounted
Freeing unused kernel memory: 1024K (0000000040100000 - 0000000040200000)
This architecture does not have kernel memory protection.
------------[ cut here ]------------
WARNING: CPU: 2 PID: 1 at block/blk-merge.c:462 blk_rq_map_sg+0x5d8/0x610
Modules linked in:
CPU: 2 PID: 1 Comm: init Not tainted 4.6.0 #85
task: 000000007fce8000 ti: 000000007fc3c000 task.ti: 000000007fc3c000

     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001101111111100001111 Not tainted
r00-03  000000ff0806ff0f 000000007fc3d090 0000000000000000 000000007fc3d090
r04-07  00000000407c8d50 0000000000000000 0000000000000000 0000000000000120
r08-11  0000000000000000 0000000000000001 000000033f146c08 0000004080095e28
r12-15  0000000000001000 000000033f168000 0000000000000003 0000000000000012
r16-19  0000000000001000 000000033f146c08 000000033f146930 0000000000001000
r20-23  0000000000000000 0000000000015698 000000007fe2b800 0000000004040000
r24-27  0000000004040000 8fffdfe1c0000000 000000033f146c08 00000000407c8d50
r28-31  0000000000000001 0000000000001000 000000007fc3d1c0 0000000000000002
sr00-03  0000000000000000 0000000000000000 0000000000000000 0000000000000800
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040496340 0000000040496344
 IIR: 03ffe01f    ISR: 0000000010340800  IOR: 000003fc51946c08
 CPU:        2   CR30: 000000007fc3c000 CR31: ffffffffffffffff
 ORIG_R28: 000000007fc3d360
 IAOQ[0]: blk_rq_map_sg+0x5d8/0x610
 IAOQ[1]: blk_rq_map_sg+0x5dc/0x610
 RP(r2):           (null)
Backtrace:
 [<000000004056afc0>] scsi_init_sgtable+0xa0/0x130
 [<000000004056b0a4>] scsi_init_io+0x54/0x160
 [<000000004058ac08>] sd_init_command+0x68/0x708
 [<000000004056b2b4>] scsi_setup_cmnd+0x104/0x1a0
 [<000000004056be58>] scsi_queue_rq+0x868/0xa00
 [<000000004049c074>] __blk_mq_run_hw_queue+0x2fc/0x508
 [<000000004049bd4c>] blk_mq_run_hw_queue+0xdc/0x108
 [<000000004049d76c>] blk_mq_insert_requests+0x15c/0x190
 [<000000004049e6a4>] blk_mq_flush_plug_list+0x18c/0x1b8
 [<000000004048f4d4>] blk_flush_plug_list+0x104/0x2c0
 [<000000004048fa44>] blk_finish_plug+0x44/0x68
 [<00000000402f81b4>] __do_page_cache_readahead+0x29c/0x3d0
 [<00000000402e8a88>] filemap_fault+0x6f0/0x838
 [<00000000404067b8>] ext4_filemap_fault+0x58/0x90
 [<00000000403193f8>] __do_fault+0x78/0x180
 [<0000000040320504>] handle_mm_fault+0x134c/0x1ec0

---[ end trace 1e7388db767b0433 ]---
------------[ cut here ]------------
kernel BUG at drivers/scsi/scsi_lib.c:1097!
CPU: 2 PID: 1 Comm: init Tainted: G        W       4.6.0 #85
task: 000000007fce8000 ti: 000000007fc3c000 task.ti: 000000007fc3c000

     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001101111111100001111 Tainted: G        W
r00-03  000000ff0806ff0f 000000007fc3d090 000000004056afc0 000000007fc3cff0
r04-07  00000000407c8d50 0000000000000001 000000033f146b48 000000033f146930
r08-11  000000007fdcb800 000000007fe28c00 0000000000012000 0000000040999660
r12-15  000000007fdcb800 000000033f146930 0000000000000000 000000007fdcb800
r16-19  0000000000000000 0000000000000158 000000033f10e120 0000000000001000
r20-23  0000000000000000 0000000000015698 000000007fe2b800 0000000004040000
r24-27  0000000004040000 8fffdfe1c0000000 000000033f146c08 00000000407c8d50
r28-31  0000000000000003 0000000000001000 000000007fc3d090 0000000000000002
sr00-03  0000000000000000 0000000000000000 0000000000000000 0000000000000800
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 000000004056b030 000000004056b034
 IIR: 03ffe01f    ISR: 0000000000000000  IOR: 0000000000000000
 CPU:        2   CR30: 000000007fc3c000 CR31: ffffffffffffffff
 ORIG_R28: 0000000000000000
 IAOQ[0]: scsi_init_sgtable+0x110/0x130
 IAOQ[1]: scsi_init_sgtable+0x114/0x130
 RP(r2): scsi_init_sgtable+0xa0/0x130
Backtrace:
 [<000000004056b0a4>] scsi_init_io+0x54/0x160
 [<000000004058ac08>] sd_init_command+0x68/0x708
 [<000000004056b2b4>] scsi_setup_cmnd+0x104/0x1a0
 [<000000004056be58>] scsi_queue_rq+0x868/0xa00
 [<000000004049c074>] __blk_mq_run_hw_queue+0x2fc/0x508
 [<000000004049bd4c>] blk_mq_run_hw_queue+0xdc/0x108
 [<000000004049d76c>] blk_mq_insert_requests+0x15c/0x190
 [<000000004049e6a4>] blk_mq_flush_plug_list+0x18c/0x1b8
 [<000000004048f4d4>] blk_flush_plug_list+0x104/0x2c0
 [<000000004048fa44>] blk_finish_plug+0x44/0x68
 [<00000000402f81b4>] __do_page_cache_readahead+0x29c/0x3d0
 [<00000000402e8a88>] filemap_fault+0x6f0/0x838
 [<00000000404067b8>] ext4_filemap_fault+0x58/0x90
 [<00000000403193f8>] __do_fault+0x78/0x180
 [<0000000040320504>] handle_mm_fault+0x134c/0x1ec0

CPU: 2 PID: 1 Comm: init Tainted: G        W       4.6.0 #85
Backtrace:
 [<0000000040216b58>] show_stack+0x20/0x38
 [<00000000404b8850>] dump_stack+0xa8/0x120
 [<0000000040216d2c>] die_if_kernel+0x19c/0x2b0
 [<0000000040217bf8>] handle_interruption+0x9b8/0x9e0

---[ end trace 1e7388db767b0434 ]---



-- 
Meelis Roos (mroos@linux.ee)
