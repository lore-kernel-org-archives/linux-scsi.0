From: Pete Wyckoff <pw@osc.edu>
Subject: [BUG 2/3] bsg null sdev with iscsi logout
Date: Sun, 9 Mar 2008 12:54:53 -0400
Message-ID: <20080309165453.GB24388@osc.edu>
References: <20080309165359.GA24388@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:54847 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYCIQyz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 12:54:55 -0400
Content-Disposition: inline
In-Reply-To: <20080309165359.GA24388@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Here's a different oops that may happen when the target goes away
unexpectedly.  Mount a slow target with iscsi.  Start a process that
uses bsg to issue an oustanding command, kill off the target before it
can respond (or unplug the network), but do not ctrl-C the bsg process.

In another shell, use iscsiadm to logout.  This provokes a kref
complaint and a bug.  The bug looks like the bsg app has seen completion
in error of its hung command, issues andother command, and ends up with
a NULL sdev later in the SCSI processing.

WARNING: at lib/kref.c:43 kref_get+0x2d/0x30()
Modules linked in: crc32c libcrc32c rdma_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_ucm ib_cm ib_sa ib_umad ib_uverbs ib_mthca iscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd ib_mad sg ib_core sd_mod i2c_nforce2 i2c_core sata_nv tg3 nfs lockd sunrpc
Pid: 3045, comm: sgio Not tainted 2.6.25-rc4-bidi-pw #29

Call Trace:
 [<ffffffff8022f82f>] warn_on_slowpath+0x5f/0x80
 [<ffffffff802ea243>] ? get_request+0x153/0x330
 [<ffffffff80247d26>] ? hrtimer_start+0xd6/0x150
 [<ffffffff80239b96>] ? lock_timer_base+0x36/0x70
 [<ffffffff802fc07d>] kref_get+0x2d/0x30
 [<ffffffff802fafea>] kobject_get+0x1a/0x30
 [<ffffffff803559f7>] get_device+0x17/0x20
 [<ffffffff80367357>] scsi_request_fn+0x37/0x3b0
 [<ffffffff802e9d94>] __generic_unplug_device+0x24/0x30
 [<ffffffff802ece63>] blk_execute_rq_nowait+0x63/0x90
 [<ffffffff802f1b48>] bsg_write+0x188/0x2e0
 [<ffffffff8028d4a7>] vfs_write+0xc7/0x150
 [<ffffffff8028db10>] sys_write+0x50/0x90
 [<ffffffff8020b58b>] system_call_after_swapgs+0x7b/0x80

---[ end trace dbc99ed69e02749c ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000420
IP: [<ffffffff8036513c>] scsi_prep_state_check+0xc/0xb0
PGD 3d111067 PUD 3e9b3067 PMD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in: crc32c libcrc32c rdma_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_ucm ib_cm ib_sa ib_umad ib_uverbs ib_mthca iscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd ib_mad sg ib_core sd_mod i2c_nforce2 i2c_core sata_nv tg3 nfs lockd sunrpc
Pid: 3045, comm: sgio Not tainted 2.6.25-rc4-bidi-pw #29
RIP: 0010:[<ffffffff8036513c>]  [<ffffffff8036513c>] scsi_prep_state_check+0xc/0xb0
RSP: 0018:ffff81007f5dfd68  EFLAGS: 00010092
RAX: ffffffff80366150 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000001 RSI: ffff81003fdcd3e0 RDI: 0000000000000000
RBP: ffff81007f5dfd78 R08: 0000000000000000 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000020 R12: 0000000000000000
R13: ffff81007e4ed800 R14: ffff81007c8b94e8 R15: 0000000000000001
FS:  00007f34d7ad96f0(0000) GS:ffffffff80515000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000420 CR3: 000000003d0e0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sgio (pid: 3045, threadinfo ffff81007f5de000, task ffff81007e4977b0)
Stack:  0000000100000000 ffff81003fdcd3e0 ffff81007f5dfda8 ffffffff80365fd8
 ffff81007f5dfdb8 ffff81003fdcd3e0 ffff81007c8b94e8 ffff81007e4ed800
 ffff81007f5dfdc8 ffffffff80366195 ffff81007c8b94e8 ffff81003fdcd3e0
Call Trace:
 [<ffffffff80365fd8>] scsi_setup_blk_pc_cmnd+0x18/0x190
 [<ffffffff80366195>] scsi_prep_fn+0x45/0x50
 [<ffffffff802e7809>] elv_next_request+0xc9/0x280
 [<ffffffff802fafea>] ? kobject_get+0x1a/0x30
 [<ffffffff80367529>] scsi_request_fn+0x209/0x3b0
 [<ffffffff802e9d94>] __generic_unplug_device+0x24/0x30
 [<ffffffff802ece63>] blk_execute_rq_nowait+0x63/0x90
 [<ffffffff802f1b48>] bsg_write+0x188/0x2e0
 [<ffffffff8028d4a7>] vfs_write+0xc7/0x150
 [<ffffffff8028db10>] sys_write+0x50/0x90
 [<ffffffff8020b58b>] system_call_after_swapgs+0x7b/0x80


Code: 0a 00 4c 89 f7 48 89 45 d0 e8 a1 a4 ff ff eb ab 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 <8b> 87 20 04 00 00 83 f8 02 75 09 31 c0 48 83 c4 08 5b c9 c3 83 
RIP  [<ffffffff8036513c>] scsi_prep_state_check+0xc/0xb0
 RSP <ffff81007f5dfd68>
CR2: 0000000000000420
---[ end trace dbc99ed69e02749c ]---

Same setup as the bug 1/3.

		-- Pete
