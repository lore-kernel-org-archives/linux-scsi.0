From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 15 Jun 2011 13:20:16 +0200
Message-ID: <20110615112016.GA4227@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:54061 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab1FOLUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 07:20:41 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p5FBKIg7002912
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2011 11:20:18 GMT
Received: from d06av09.portsmouth.uk.ibm.com (d06av09.portsmouth.uk.ibm.com [9.149.37.250])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5FBKIVB2572388
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2011 12:20:18 +0100
Received: from d06av09.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av09.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5FBKHu6032008
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2011 05:20:17 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

Hi James,

while running some error recovery tests we encountered the following bug:

[23710.196446] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
[23710.196453] Oops: 0038 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[23710.196460] Modules linked in: dm_round_robin sunrpc qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod ipv6 vmur qeth ccwgroup [last unloaded: scsi_wait_scan]
[23710.196477] CPU: 0 Not tainted 2.6.39.1-49.x.20110609-s390xdefault #1
[23710.196480] Process kworker/u:5 (pid: 18534, task: 000000002f4d2368, ksp: 000000002f48f268)
[23710.196483] Krnl PSW : 0704000180000000 000000000042407c (scsi_dispatch_cmd+0xd4/0x29c)
[23710.196492]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[23710.196496] Krnl GPRS: 0280000000000000 6b6b6b6b6b6b6b6b 0000000000000060 0000000000006b6b
[23710.196499]            00000000005a0ab2 000000002f4d2af0 00000000390d8090 000000002f611ac7
[23710.196502]            000000003a764600 000000002f6114f0 000000003a764600 0000000000000000
[23710.196505]            000000003a78e1b0 00000000005f0638 0000000000424070 000000002f48f530
[23710.196516] Krnl Code: 000000000042406a: c0e5fffffdf9        brasl   %r14,423c5c
[23710.196520]            0000000000424070: e310a0000004        lg      %r1,0(%r10)
[23710.196525]            0000000000424076: e330a04a0091        llgh    %r3,74(%r10)
[23710.196529]           >000000000042407c: e31010000004        lg      %r1,0(%r1)
[23710.196533]            0000000000424082: e34012480091        llgh    %r4,584(%r1)
[23710.196537]            0000000000424088: 1534                clr     %r3,%r4
[23710.196541]            000000000042408a: a7240033            brc     2,4240f0
[23710.196546]            000000000042408e: d503d008c2c0        clc     8(4,%r13),704(%r12)
[23710.196549] Call Trace:
[23710.196551] ([<0000000000424070>] scsi_dispatch_cmd+0xc8/0x29c)
[23710.196555]  [<000000000042bdb8>] scsi_request_fn+0x3b8/0x480
[23710.196560]  [<00000000003adfb6>] blk_execute_rq_nowait+0x76/0xd0
[23710.196565]  [<00000000003ae0a6>] blk_execute_rq+0x96/0xe8
[23710.196569]  [<000000000042af84>] scsi_execute+0x124/0x22c
[23710.196573]  [<000000000042b1cc>] scsi_execute_req+0x140/0x148
[23710.196577]  [<0000000000422f0c>] scsi_vpd_inquiry+0x80/0xac
[23710.196580]  [<0000000000422f80>] scsi_get_vpd_page+0x48/0x108
[23710.196584]  [<000000000043e240>] sd_revalidate_disk+0x984/0x1a6c
[23710.196590]  [<00000000002b898e>] rescan_partitions+0xc6/0x594
[23710.196596]  [<000000000027b1ca>] __blkdev_get+0x2f6/0x43c
[23710.196602]  [<000000000027b358>] blkdev_get+0x48/0x38c
[23710.196606]  [<00000000003b463e>] register_disk+0x182/0x19c
[23710.196610]  [<00000000003b4758>] add_disk+0x100/0x2ac
[23710.196614]  [<00000000004402bc>] sd_probe_async+0x118/0x1c8
[23710.196618]  [<0000000000173168>] async_run_entry_fn+0x98/0x188
[23710.196624]  [<000000000015ec5e>] process_one_work+0x1f6/0x4ec
[23710.196630]  [<0000000000162a48>] worker_thread+0x17c/0x370
[23710.196633]  [<0000000000168b7e>] kthread+0xa6/0xb0
[23710.196637]  [<00000000005a61fa>] kernel_thread_starter+0x6/0xc
[23710.196643]  [<00000000005a61f4>] kernel_thread_starter+0x0/0xc
[23710.196646] INFO: lockdep is turned off.
[23710.196648] Last Breaking-Event-Address:
[23710.196650]  [<00000000005a0abc>] printk+0x5c/0x60

Testcase is multipath setup (dm) where I/O happens to these SCSI devices and
while doing so randomly the channel paths to adapters get switched on and off.
Each time a channel path to a adapter gets switched off this results into a
call to fc_remote_port_delete() for each connected port of an adapter.

A short analysis for the call trace above: we use SLUB and have all debugging
options turned on. The system crashed within scsi_dispatch_cmd() when it tried
to derefence cmd->device in order to get the host pointer within this short
code snippet:

        /*
         * Before we queue this command, check if the command
         * length exceeds what the host adapter can handle.
         */
        if (cmd->cmd_len > cmd->device->host->max_cmd_len) {
                SCSI_LOG_MLQUEUE(3,

The struct scsi_cmnd contains 0x6b which means it got freed and we have a
use after free bug here. The interesting thing is that the code got so far
into this function without crashing. Since there are several other places
where derefencing happened before in the function (without crashing) this
means that this piece of memory got freed while this function got executed
(well, preemption is turned on, so maybe it got freed while being preempted).

SLUB caller tracking is turned on, which reveals that this piece of memory
got freed by __scsi_put_command().

As far as I can tell, in this case the device driver cannot be blamed since
the request in question didn't even reach the driver before it got freed and
the system crashed.
But of course I could be entirely wrong :)

Would you happen to have any ideas what could cause this bug?

FWIW, this is 2.6.39.1 which in addition contains
e73e079bf128d68284efedeba1fbbc18d78610f9 "[SCSI] Fix oops caused by queue
refcounting failure"

Thanks,
Heiko
