From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [SCSI] bnx2fc: Fix debug messasges in bnx2fc_io.c
Date: Sun, 12 Apr 2015 23:07:13 +0900
Message-ID: <1428847633-30232-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35665 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbbDLOHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2015 10:07:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>

The debug messages in bnx2fc_process_seq_cleanup_compl() doesn't
match its function name.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9ecca85..1b53a68 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1319,7 +1319,7 @@ void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_cmd *seq_clnp_req,
 	int rc = 0;
 	struct bnx2fc_rport *tgt = orig_io_req->tgt;
 
-	BNX2FC_IO_DBG(orig_io_req, "Entered process_cleanup_compl xid = 0x%x"
+	BNX2FC_IO_DBG(orig_io_req, "Entered process_seq_cleanup_compl xid = 0x%x"
 			      "cmd_type = %d\n",
 		   seq_clnp_req->xid, seq_clnp_req->cmd_type);
 
@@ -1334,7 +1334,7 @@ void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_cmd *seq_clnp_req,
 	spin_lock_bh(&tgt->tgt_lock);
 
 	if (rc)
-		printk(KERN_ERR PFX "clnup_compl: Unable to send SRR"
+		printk(KERN_ERR PFX "process_seq_clenup_compl: Unable to send SRR"
 			" IO will abort\n");
 	seq_clnp_req->cb_arg = NULL;
 	kref_put(&orig_io_req->refcount, bnx2fc_cmd_release);
-- 
2.4.0.rc0.43.gcf8a8c6

