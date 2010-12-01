From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/27] libfc: fix NULL pointer dereference bug in
	fc_fcp_pkt_release
Date: Tue, 30 Nov 2010 16:18:07 -0800
Message-ID: <20101201001807.18369.99723.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:14723 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab0LAASI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:08 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

This happens when then tearing down the fcoe interface with active I/O.
The back trace shows dead000000200200 in RAX, i.e., LIST_POISON2, indicating
that the fsp is already being dequeued, which is probably why no complaining
was seen in fc_fcp_destroy() about outstanding fsp not freed, since we dequeue
it in the end of fc_io_compl() before releasing it. The bug is due to the
fact that we have already destroyed lport's scsi_pkt_pool while on-going i/o
is still accessing it through fc_fcp_pkt_release(), like this trace or the
similar code path from scsi-ml to fc_eh_abort, etc. This is fixed by moving
the fc_fcp_destroy() after lport is detached from scsi-ml since fc_fcp_destroy
is supposed to called only once where no lport lock is taken, otherwise the
fc_fcp_pkt_release() would have to grab the lport lock.

 BUG: unable to handle kernel NULL pointer dereference at (null)
 .......
 RIP: 0010:[<0000000000000000>]
 [<(null)>] (null)
 RSP: 0018:ffff8803270f7b88  EFLAGS: 00010282
 RAX: dead000000200200 RBX: ffff880197d2fbc0 RCX: 0000000000005908
 RDX: ffff880195ea6d08 RSI: 0000000000000282 RDI: ffff880180f4fec0
 RBP: ffff8803270f7bc0 R08: ffff880197d2fbe0 R09: 0000000000000000
 R10: ffff88032867f090 R11: 0000000000000000 R12: ffff880195ea6d08
 R13: 0000000000000282 R14: ffff880180f4fec0 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff8801b5820000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 00000001a6eae000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process fc_rport_eq (pid: 5278, threadinfo ffff8803270f6000, task ffff880326254ab0)
 Stack:
 ffffffffa02c39ca ffff8803270f7ba0 ffff88019331cbc0 ffff880197d2fbc0
 0000000000000000 ffff8801a8c895e0 ffff8801a8c895e0 ffff8803270f7c10
 ffffffffa02c4962 ffff8803270f7be0 ffffffff814c94ab ffff8803270f7c10
 Call Trace:
 [<ffffffffa02c39ca>] ? fc_io_compl+0x10a/0x530 [libfc]
 [<ffffffffa02c4962>] fc_fcp_complete_locked+0x72/0x150 [libfc]
 [<ffffffff814c94ab>] ? _spin_unlock_bh+0x1b/0x20
 [<ffffffffa02b98ff>] ? fc_exch_done+0x3f/0x60 [libfc]
 [<ffffffffa02c4a8f>] fc_fcp_retry_cmd+0x4f/0x60 [libfc]
 [<ffffffffa02c6150>] fc_fcp_recv+0x9b0/0xc30 [libfc]
 [<ffffffff8106ba7a>] ? _call_console_drivers+0x4a/0x80
 [<ffffffff8107d5ec>] ? lock_timer_base+0x3c/0x70
 [<ffffffff8107e06b>] ? try_to_del_timer_sync+0x7b/0xe0
 [<ffffffffa02b9dcf>] fc_exch_mgr_reset+0x1df/0x250 [libfc]
 [<ffffffffa02c57a0>] ? fc_fcp_recv+0x0/0xc30 [libfc]
 [<ffffffffa02c1042>] fc_rport_work+0xf2/0x4e0 [libfc]
 [<ffffffff8109203e>] ? prepare_to_wait+0x4e/0x80
 [<ffffffffa02c0f50>] ? fc_rport_work+0x0/0x4e0 [libfc]
 [<ffffffff8108c6c0>] worker_thread+0x170/0x2a0
 [<ffffffff81091d50>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8108c550>] ? worker_thread+0x0/0x2a0
 [<ffffffff810919e6>] kthread+0x96/0xa0
 [<ffffffff810141ca>] child_rip+0xa/0x20
 [<ffffffff81091950>] ? kthread+0x0/0xa0
 [<ffffffff810141c0>] ? child_rip+0x0/0x20
 Code:
 Bad RIP value.

 RIP
 [<(null)>] (null)
 RSP <ffff8803270f7b88>
 CR2: 0000000000000000

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index d23a538..9f9600b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -854,7 +854,6 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 
 	/* Cleanup the fc_lport */
 	fc_lport_destroy(lport);
-	fc_fcp_destroy(lport);
 
 	/* Stop the transmit retry timer */
 	del_timer_sync(&port->timer);
@@ -876,6 +875,9 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	fc_remove_host(lport->host);
 	scsi_remove_host(lport->host);
 
+	/* Destroy lport scsi_priv */
+	fc_fcp_destroy(lport);
+
 	/* There are no more rports or I/O, free the EM */
 	fc_exch_mgr_free(lport);
 

