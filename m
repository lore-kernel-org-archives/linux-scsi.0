From: Pete Wyckoff <pw@osc.edu>
Subject: [BUG 1/3] bsg queue oops with iscsi logout
Date: Sun, 9 Mar 2008 12:53:59 -0400
Message-ID: <20080309165359.GA24388@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:53615 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYCIQyE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 12:54:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Here's an oops.  Mount a target with iscsi.  Start a process that
holds open the bsg device, in the debugger perhaps.  Then use
iscsiadm to logout.  Let the bsg process try to submit another
command.  Its queue is no longer usable, as blk_get_request() finds
a NULL q->elevator->ops.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
IP: [<ffffffff802e6adb>] elv_may_queue+0xb/0x20
PGD 3e8e1067 PUD 3e4ce067 PMD 0 
Oops: 0000 [1] SMP 
CPU 1 
Modules linked in: crc32c libcrc32c rdma_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_ucm ib_cm ib_sa ib_umad ib_uverbs ib_mthca iscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd ib_mad ib_core i2c_nforce2 i2c_core sg sd_mod sata_nv tg3 nfs lockd sunrpc
Pid: 3000, comm: sgio Not tainted 2.6.25-rc4-bidi-pw #29
RIP: 0010:[<ffffffff802e6adb>]  [<ffffffff802e6adb>] elv_may_queue+0xb/0x20
RSP: 0018:ffff81007d15fd28  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff81007d54d468 RCX: 0000000000000010
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff81007d54d468
RBP: ffff81007d15fd28 R08: 0000000000000001 R09: ffff81007d093e88
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81007d54d468
R13: ffff81007d54d488 R14: 0000000000000000 R15: 0000000000000000
FS:  00002b05a4a17b00(0000) GS:ffff81007f600840(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000070 CR3: 000000003e497000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process sgio (pid: 3000, threadinfo ffff81007d15e000, task ffff81007f712830)
Stack:  ffff81007d15fd98 ffffffff802ea129 ffff810040005358 ffff810040005350
 00000010000612d0 0000000000000000 ffff81007cda6a68 ffff81007d9de020
 0000000000000086 0000000000000000 ffff81007d54d468 0000000000000000
Call Trace:
 [<ffffffff802ea129>] get_request+0x39/0x330
 [<ffffffff802ea44f>] get_request_wait+0x2f/0x1c0
 [<ffffffff80286b27>] ? cache_grow+0x1b7/0x260
 [<ffffffff802ea7d8>] blk_get_request+0x38/0x80
 [<ffffffff802f171c>] bsg_map_hdr+0x9c/0x340
 [<ffffffff802f1aac>] bsg_write+0xec/0x2e0
 [<ffffffff8028d4a7>] vfs_write+0xc7/0x150
 [<ffffffff8028db10>] sys_write+0x50/0x90
 [<ffffffff8020b58b>] system_call_after_swapgs+0x7b/0x80


Code: 55 48 8b 47 18 48 89 e5 48 8b 00 48 8b 40 68 48 85 c0 74 05 48 89 f7 ff d0 c9 c3 0f 1f 44 00 00 48 8b 47 18 55 48 89 e5 48 8b 00 <48> 8b 50 70 31 c0 48 85 d2 74 02 ff d2 c9 c3 66 0f 1f 44 00 00 
RIP  [<ffffffff802e6adb>] elv_may_queue+0xb/0x20
 RSP <ffff81007d15fd28>
CR2: 0000000000000070
---[ end trace a020f2a7368afcb4 ]---

I think this used not to happen; not sure.  But I changed two things
lately.  2.6.25-rc1 to -rc4 and fedora 8 iscsi-initiator-utils (865) to
fedora devel (868).  Bidi and varlen patches always too.

I'll follow with some more variations on this theme.  Looks like bsg
needs to protect more carefully against the device going away.  Any
ideas how best to do this?  What was the approach in sg?

		-- Pete
