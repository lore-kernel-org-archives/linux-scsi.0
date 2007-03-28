From: Judith Lebzelter <judith@linux-foundation.org>
Subject: Panics for AACRAID driver during 'insmod' for kexec test.
Date: Wed, 28 Mar 2007 14:54:32 -0700
Message-ID: <20070328215432.GE25856@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbXC1Vyf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2007 17:54:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com, fastboot@lists.osdl.org

Hello, 

I have been running a series of kexec tests using LKDTT on the 
aacraid driver on this card (ASR-4805SAS (Marauder-E)) on x86_64
using the latest top of scsi-misc git-tree(as of yesterday), and 
I have found that it is not coming up consistantly when booted 
through kexec.

I have included 4 different types of failures I found here because 
I assume they might be related, and thought maybe there could 
be an issue with the card's state on reboot (through kexec).

The most common problem is this oops/panic, which has happened 
with various types of crash points (6 times out of 40):

Loading aacraid.Adaptec aacraid driver (1.1-5[2437]-mh4)^M
ko module^M
ACPI: PCI Interrupt 0000:03:0e.0[A] -> Link [LNKC] -> GSI 3 (level, low) -> IRQ 3^M
general protection fault: 0000 [1] ^M
CPU 0 ^M
Modules linked in: aacraid^M
Pid: 0, comm: swapper Not tainted 2.6.21-rc3-kdump #1^M
RIP: 0010:[<ffffffff88008a99>]  [<ffffffff88008a99>] :aacraid:aac_intr_normal+0x17a/0x1b1^M
RSP: 0000:ffffffff81523ed8  EFLAGS: 00010006^M
RAX: ffff810004102000 RBX: ffff8100014f01e0 RCX: 0000000000000086^M
RDX: ffff810004041540 RSI: ffff8100014f01e0 RDI: cccccccccccccccc^M
RBP: ffff810004702cd8 R08: 00000000a6037e6c R09: 00000016001562d7^M
R10: 0000000000000023 R11: 0000000000000000 R12: 0000000000000011^M
R13: ffff810004702cd8 R14: ffff810004001400 R15: 0000000000000000^M
FS:  0000000000000000(0000) GS:ffffffff814d5000(0000) knlGS:0000000000000000^M
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b^M
CR2: 00000000006ba5a0 CR3: 000000000474d000 CR4: 00000000000006e0^M
Process swapper (pid: 0, threadinfo ffffffff814e4000, task ffffffff81470360)^M
Stack:  0000000000000011 ffff810004702cd8 0000000000000100 0000000000000003^M
 0000000000000001 ffffffff88009470 0000000000000000 ffff810004041540^M
 ffffffff814d5080 ffffffff810428f4 0000000000000000 ffffffff814d5080^M
Call Trace:^M
 <IRQ>  [<ffffffff88009470>] :aacraid:aac_rx_intr_message+0x2c/0x60^M
 [<ffffffff810428f4>] note_interrupt+0xd3/0x1db^M
 [<ffffffff8104319b>] handle_level_irq+0x7e/0xab^M
 [<ffffffff8100b0b1>] do_IRQ+0xd7/0x132^M
 [<ffffffff810085a1>] mwait_idle+0x0/0x43^M
 [<ffffffff81009651>] ret_from_intr+0x0/0xa^M
 <EOI>  [<ffffffff810085e0>] mwait_idle+0x3f/0x43^M
 [<ffffffff81008540>] cpu_idle+0x3d/0x5c^M
 [<ffffffff814e78d2>] start_kernel+0x28f/0x29b^M
 [<ffffffff814e7140>] _sinittext+0x140/0x144^M
^M
^M
Code: ff 53 38 eb 20 9c 58 fa 83 7b 30 00 75 07 c7 43 30 01 00 00 ^M
RIP  [<ffffffff88008a99>] :aacraid:aac_intr_normal+0x17a/0x1b1^M
Kernel panic - not syncing: Aiee, killing interrupt handler!^M
 

Another failure:   for crash point 'TIMERADD-bug' I got this error 
loading insmod:

Loading aacraid.Adaptec aacraid driver (1.1-5[2437]-mh4)^M
ko module^M
ACPI: PCI Interrupt 0000:03:0e.0[A] -> Link [LNKC] -> GSI 3 (level, low) -> IRQ 3^M
input: ImExPS/2 Generic Explorer Mouse as /class/input/input3^M
aacraid: aac_fib_send: adapter blinkLED 0xc2.^M
Usually a result of a serious unrecoverable hardware problem^M
aac_fib_free, XferState != 0, fibptr = 0xffff8100014f0000, XferState = 0x810ad^M
aacraid: probe of 0000:03:0e.0 failed with error -14^M


Yet another Failure: for crash point 'TIMERADD-panic' I got this error 
during insmod:

Loading aacraid.Adaptec aacraid driver (1.1-5[2437]-mh4)^M
ko module^M
ACPI: PCI Interrupt 0000:03:0e.0[A] -> Link [LNKC] -> GSI 3 (level, low) -> IRQ 3^M
input: ImExPS/2 Generic Explorer Mouse as /class/input/input3^M
Ecr^H ^H^H ^H^H ^HBUG: soft lockup detected on CPU#0!^M
^M
Call Trace:^M
 <IRQ>  [<ffffffff8102bcbb>] update_process_times+0x3b/0x5f^M
 [<ffffffff8100bebf>] main_timer_handler+0x2f/0x1ae^M
 [<ffffffff8102b504>] run_timer_softirq+0x14/0x161^M
 [<ffffffff8100c050>] timer_interrupt+0x12/0x27^M
 [<ffffffff81041f9c>] handle_IRQ_event+0x25/0x53^M
 [<ffffffff81028c1b>] __do_softirq+0x46/0x90^M
 [<ffffffff81043186>] handle_level_irq+0x69/0xab^M
 [<ffffffff8100b0b1>] do_IRQ+0xd7/0x132^M
 [<ffffffff81009651>] ret_from_intr+0x0/0xa^M
 <EOI>  [<ffffffff811229ed>] __delay+0x8/0x10^M
 [<ffffffff88007c68>] :aacraid:aac_fib_send+0x1ba/0x234^M
 [<ffffffff880048aa>] :aacraid:aac_get_adapter_info+0x76/0x536^M
 [<ffffffff88002bb3>] :aacraid:aac_probe_one+0x236/0x457^M
 [<ffffffff8112bd6d>] pci_device_probe+0x4c/0x75^M
 [<ffffffff8117d0da>] really_probe+0xc4/0x148^M
 [<ffffffff8117d30b>] __driver_attach+0x6d/0xab^M
 [<ffffffff8117d29e>] __driver_attach+0x0/0xab^M
 [<ffffffff8117d29e>] __driver_attach+0x0/0xab^M
 [<ffffffff8117c5b2>] bus_for_each_dev+0x43/0x6e^M
 [<ffffffff8117c8f4>] bus_add_driver+0x6b/0x18d^M
 [<ffffffff8112bf0b>] __pci_register_driver+0x72/0xa7^M
 [<ffffffff8801203a>] :aacraid:aac_init+0x3a/0x75^M
 [<ffffffff8103bafc>] sys_init_module+0x1195/0x12e6^M
 [<ffffffff8100913e>] system_call+0x7e/0x83^M
^M
BUG: soft lockup detected on CPU#0!^M

One last error I got for INT_TASKLET_ENTRY-exception was this
after the filesystem is mounted and I am copying the vmcore 
file to it:

Copying the dump
aacraid: Host adapter abort request (4,0,0,0)
aacraid: Host adapter abort request (4,0,0,0)
aacraid: Host adapter reset request. SCSI hang ?
[-- MARK -- Tue Mar 27 15:30:00 2007]
sd 4:0:0:0: [sdc] 143132672 512-byte hardware sectors (73284 MB)
sd 4:0:0:0: [sdc] Assuming Write Enabled
sd 4:0:0:0: [sdc] Assuming drive cache: write through
EXT3-fs error (device sdc1): ext3_new_block: Allocating block in system
zone - blocks from 1802240, length 1
EXT3-fs error (device sdc1): ext3_new_block: Allocating block in system
zone - blocks from 1802241, length 1
journal_bmap: journal block not found at offset 2184 on sdc1
Aborting journal on device sdc1.
ext3_abort called.
EXT3-fs error (device sdc1): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
EXT3-fs error (device sdc1): ext3_free_blocks: Freeing blocks in system
zones - Block = 1802241, count = 1
EXT3-fs error (device sdc1) in ext3_free_blocks_sb: Journal has aborted
/bin/dd: writing to `/dump/dumpfile': Read-only file system
13190265+0 r__journal_remove_journal_head: freeing b_committed_data
ecords in
13190__journal_remove_journal_head: freeing b_frozen_data
264+0 records out
6753415168 bytes (6.8 GB) copied, 745.436 s, 9.1 MB/s
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data


That file size should be 8.5G.

Thanks,
Judith
