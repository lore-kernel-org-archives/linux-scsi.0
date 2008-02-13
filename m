From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: ips.c broken since 2.6.23 on x86_64?
Date: Wed, 13 Feb 2008 13:43:24 -0800
Message-ID: <20080213214324.GB18227@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38970 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933418AbYBMVoH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 16:44:07 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1DLjLMp015796
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2008 16:45:21 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1DLhPeU143578
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2008 16:43:25 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1DLhPLk032577
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2008 16:43:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mark_Salyzyn@adaptec.com, ipslinux@adaptec.com

We recently upgraded a production x86_64 machine with serveraid
cards to 2.6.24 and noted that /proc/scsi/scsi showed garbage for our
serveraid service processors.  sg_inq also returned garbage from the
service processors' sg devices.  After a few iterations I started seeing
meaninful stuff in the garbage.  Not sure if it was returning live memory
or just unzero'd.  Either way not good so we went back to a known good,
older kernel and tried to repro on a similar machine.  We got different,
but still bad results in terms of pointing at memory badness.

FWIW, the original machine had the following hardware:
    scsi0 : IBM PCI ServeRAID 7.12.05  Build 761 <ServeRAID 4H>
    scsi1 : IBM PCI ServeRAID 7.12.05  Build 761 <ServeRAID 4M>
and the repro's have been on a machine with just:
    scsi0 : IBM PCI ServeRAID 7.12.05  Build 761 <ServeRAID 4Mx>

On the repro machine I'm getting a hang on ips driver load with the following
logged:

Feb 13 13:16:08 ipstest kernel: [  915.236563] scsi3 : IBM PCI ServeRAID 7.12.05  Build 761 <ServeRAID 4Mx>
Feb 13 13:16:08 ipstest kernel: [  915.236839] Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
Feb 13 13:16:08 ipstest kernel: [  915.236863]  [check_addr+16/80] check_addr+0x10/0x50
Feb 13 13:16:08 ipstest kernel: [  915.237209] PGD 79fff067 PUD 7a898067 PMD 0
Feb 13 13:16:08 ipstest kernel: [  915.237341] Oops: 0000 [1] SMP
Feb 13 13:16:08 ipstest kernel: [  915.237463] CPU 1
Feb 13 13:16:08 ipstest kernel: [  915.239436] Modules linked in: ips aic94xx
Feb 13 13:16:08 ipstest kernel: [  915.239559] Pid: 5213, comm: scsi_scan_3 Not tainted 2.6.23-ips_as_module #3
Feb 13 13:16:08 ipstest kernel: [  915.239692] RIP: 0010:[check_addr+16/80]  [check_addr+16/80] check_addr+0x10/0x50
Feb 13 13:16:08 ipstest kernel: [  915.239932] RSP: 0018:ffff810076d87900  EFLAGS: 00010082
Feb 13 13:16:08 ipstest kernel: [  915.240059] RAX: 0000000000000000 RBX: ffff81007b636300 RCX: 0000000000000024
Feb 13 13:16:08 ipstest kernel: [  915.240196] RDX: 000000007b636b00 RSI: ffffffff8077cde0 RDI: ffffffff806c4ed5
Feb 13 13:16:08 ipstest kernel: [  915.240332] RBP: ffff810076d87900 R08: 0000000000000500 R09: 0000000000000000
Feb 13 13:16:08 ipstest kernel: [  915.240468] R10: ffff81007aa33b40 R11: 0000000000000060 R12: 0000000000000000
Feb 13 13:16:08 ipstest kernel: [  915.240605] R13: 0000000000000001 R14: ffffffff8077cde0 R15: ffff81007aa33a80
Feb 13 13:16:08 ipstest kernel: [  915.240741] FS:  0000000000000000(0000) GS:ffff810001039300(0000) knlGS:0000000000000000
Feb 13 13:16:08 ipstest kernel: [  915.240981] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 13 13:16:08 ipstest kernel: [  915.241111] CR2: 0000000000000000 CR3: 0000000078a98000 CR4: 00000000000006e0
Feb 13 13:16:08 ipstest kernel: [  915.241248] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 13 13:16:08 ipstest kernel: [  915.241384] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 13 13:16:08 ipstest kernel: [  915.241520] Process scsi_scan_3 (pid: 5213, threadinfo ffff810076d86000, task ffff81007be26720)
Feb 13 13:16:08 ipstest kernel: [  915.241761] Stack:  ffff810076d87930 ffffffff802125c3 ffff81007aa33a80 ffff81007480cf50
Feb 13 13:16:08 ipstest kernel: [  915.242006]  0000000000000000 ffff81007ba38ca8 ffff810076d87940 ffffffff8046fb42
Feb 13 13:16:08 ipstest kernel: [  915.242248]  ffff810076d879c0 ffffffff8801c2ee ffff81007aa33af0 000000017aa33af0
Feb 13 13:16:08 ipstest kernel: [  915.242389] Call Trace:
Feb 13 13:16:08 ipstest kernel: [  915.242606]  [nommu_map_sg+115/144] nommu_map_sg+0x73/0x90
Feb 13 13:16:08 ipstest kernel: [  915.242736]  [scsi_dma_map+66/96] scsi_dma_map+0x42/0x60
Feb 13 13:16:08 ipstest kernel: [  915.242867]  [_end+124884230/2127548952] :ips:ips_next+0x33e/0xc00
Feb 13 13:16:08 ipstest kernel: [  915.242986]  [scsi_done+0/48] scsi_done+0x0/0x30
Feb 13 13:16:08 ipstest kernel: [  915.243114]  [_end+124896894/2127548952] :ips:ips_queue+0x106/0x1f0
Feb 13 13:16:08 ipstest kernel: [  915.243240]  [scsi_dispatch_cmd+498/784] scsi_dispatch_cmd+0x1f2/0x310
Feb 13 13:16:08 ipstest kernel: [  915.243370]  [scsi_request_fn+491/976] scsi_request_fn+0x1eb/0x3d0
Feb 13 13:16:08 ipstest kernel: [  915.243500]  [__generic_unplug_device+37/48] __generic_unplug_device+0x25/0x30
Feb 13 13:16:08 ipstest kernel: [  915.243630]  [blk_execute_rq_nowait+99/176] blk_execute_rq_nowait+0x63/0xb0
Feb 13 13:16:08 ipstest kernel: [  915.243761]  [blk_execute_rq+122/224] blk_execute_rq+0x7a/0xe0
Feb 13 13:16:08 ipstest kernel: [  915.243889]  [scsi_execute+240/288] scsi_execute+0xf0/0x120
Feb 13 13:16:08 ipstest kernel: [  915.244016]  [scsi_execute_req+134/240] scsi_execute_req+0x86/0xf0
Feb 13 13:16:08 ipstest kernel: [  915.244145]  [scsi_probe_and_add_lun+594/3472] scsi_probe_and_add_lun+0x252/0xd90
Feb 13 13:16:08 ipstest kernel: [  915.244279]  [sas_expander_match+27/160] sas_expander_match+0x1b/0xa0
Feb 13 13:16:08 ipstest kernel: [  915.244412]  [get_device+23/32] get_device+0x17/0x20
Feb 13 13:16:08 ipstest kernel: [  915.244534]  [__scsi_scan_target+220/1696] __scsi_scan_target+0xdc/0x6a0
Feb 13 13:16:08 ipstest kernel: [  915.244665]  [enqueue_entity+172/432] enqueue_entity+0xac/0x1b0
Feb 13 13:16:08 ipstest kernel: [  915.244793]  [update_curr_load+135/160] update_curr_load+0x87/0xa0
Feb 13 13:16:08 ipstest kernel: [  915.244923]  [__check_preempt_curr_fair+107/128] __check_preempt_curr_fair+0x6b/0x80
Feb 13 13:16:08 ipstest kernel: [  915.245057]  [update_curr+258/272] update_curr+0x102/0x110
Feb 13 13:16:08 ipstest kernel: [  915.245186]  [scsi_scan_channel+139/160] scsi_scan_channel+0x8b/0xa0
Feb 13 13:16:08 ipstest kernel: [  915.245315]  [scsi_scan_host_selected+158/352] scsi_scan_host_selected+0x9e/0x160
Feb 13 13:16:08 ipstest kernel: [  915.245447]  [do_scan_async+0/320] do_scan_async+0x0/0x140
Feb 13 13:16:08 ipstest kernel: [  915.245574]  [do_scsi_scan_host+126/128] do_scsi_scan_host+0x7e/0x80
Feb 13 13:16:08 ipstest kernel: [  915.245703]  [do_scan_async+23/320] do_scan_async+0x17/0x140
Feb 13 13:16:08 ipstest kernel: [  915.245832]  [do_scan_async+0/320] do_scan_async+0x0/0x140
Feb 13 13:16:08 ipstest kernel: [  915.245962]  [kthread+77/128] kthread+0x4d/0x80
Feb 13 13:16:08 ipstest kernel: [  915.246086]  [child_rip+10/18] child_rip+0xa/0x12
Feb 13 13:16:08 ipstest kernel: [  915.246209]  [kthread+0/128] kthread+0x0/0x80
Feb 13 13:16:08 ipstest kernel: [  915.246333]  [child_rip+0/18] child_rip+0x0/0x12
Feb 13 13:16:08 ipstest kernel: [  915.246457]
Feb 13 13:16:08 ipstest kernel: [  915.246564]
Feb 13 13:16:08 ipstest kernel: [  915.246565] Code: 4c 8b 00 48 8d 04 0a 4c 39 c0 76 2b b8 fe ff ff ff 31 f6 49
Feb 13 13:16:08 ipstest kernel: [  915.246933] RIP  [check_addr+16/80] check_addr+0x10/0x50
Feb 13 13:16:08 ipstest kernel: [  915.247062]  RSP <ffff810076d87900>
Feb 13 13:16:08 ipstest kernel: [  915.247181] CR2: 0000000000000000

I was able to narrow it down in as much as with this reverted the machine
seems to run fine:
    commit 2f4cf91cc0a1f32f75e1fa0a4d70a9bc7340a302
    [SCSI] ips: convert to use the data buffer accessors

Nothing looks overly suspicious in that patch per se, although based
on the list archives it looks like related changes caused other drivers
grief.  I've tried a variety of things to get a little more debug info,
but to no avail.  If anybody has any suggestions, I'd appreciate them!

This repro's 100% on driver load so it's relatively easy (unfortunately
no remote power or serial console available) to test patches...

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
