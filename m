From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/2] tcm_fc: Generate TASK_SET_FULL status for response failures
Date: Thu,  5 Jun 2014 23:30:02 +0000
Message-ID: <1402011002-20771-3-git-send-email-nab@daterainc.com>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41328 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaFEXzL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 19:55:11 -0400
Received: by mail-ob0-f182.google.com with SMTP id wn1so1922824obc.27
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jun 2014 16:55:10 -0700 (PDT)
In-Reply-To: <1402011002-20771-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, fcoe-devel <fcoe-devel@open-fcoe.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Vasu Dev <vasu.dev@linux.intel.com>, Jun Wu <jwu@stormojo.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes ft_queue_status() to set SAM_STAT_TASK_SET_FULL
status upon lport->tt.seq_send( failure, and return -EAGAIN to notify
target-core to attempt to requeue the response.

It also does the same for a fc_frame_alloc() failures, in order to
signal the initiator that it should try to reduce it's current
queue_depth, to lower the number of outstanding I/Os on the wire.

Reported-by: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Jun Wu <jwu@stormojo.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_cmd.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index f5fd515..5585038 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -128,6 +128,7 @@ int ft_queue_status(struct se_cmd *se_cmd)
 	struct fc_lport *lport;
 	struct fc_exch *ep;
 	size_t len;
+	int rc;
 
 	if (cmd->aborted)
 		return 0;
@@ -137,9 +138,10 @@ int ft_queue_status(struct se_cmd *se_cmd)
 	len = sizeof(*fcp) + se_cmd->scsi_sense_length;
 	fp = fc_frame_alloc(lport, len);
 	if (!fp) {
-		/* XXX shouldn't just drop it - requeue and retry? */
-		return 0;
+		se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
+		return -ENOMEM;
 	}
+
 	fcp = fc_frame_payload_get(fp, len);
 	memset(fcp, 0, len);
 	fcp->resp.fr_status = se_cmd->scsi_status;
@@ -170,7 +172,18 @@ int ft_queue_status(struct se_cmd *se_cmd)
 	fc_fill_fc_hdr(fp, FC_RCTL_DD_CMD_STATUS, ep->did, ep->sid, FC_TYPE_FCP,
 		       FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ, 0);
 
-	lport->tt.seq_send(lport, cmd->seq, fp);
+	rc = lport->tt.seq_send(lport, cmd->seq, fp);
+	if (rc) {
+		pr_err_ratelimited("%s: Failed to send response frame %p, "
+				   "xid <0x%x>\n", __func__, fp, ep->xid);
+		/*
+		 * Generate a TASK_SET_FULL status to notify the initiator
+		 * to reduce it's queue_depth after the se_cmd response has
+		 * been re-queued by target-core.
+		 */
+		se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
+		return -ENOMEM;
+	}
 	lport->tt.exch_done(cmd->seq);
 	return 0;
 }
-- 
1.7.10.4

