From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/2] tcm_fc: Generate TASK_SET_FULL status for DataIN failures
Date: Thu,  5 Jun 2014 23:30:01 +0000
Message-ID: <1402011002-20771-2-git-send-email-nab@daterainc.com>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402011002-20771-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, fcoe-devel <fcoe-devel@open-fcoe.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Vasu Dev <vasu.dev@linux.intel.com>, Jun Wu <jwu@stormojo.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes ft_queue_data_in() to set SAM_STAT_TASK_SET_FULL
status upon a lport->tt.seq_send() failure, where it will now stop
sending subsequent DataIN, and immediately attempt to send the
response with exception status.

Sending a response with SAM_STAT_TASK_SET_FULL status is useful in
order to signal the initiator that it should try to reduce it's
current queue_depth, to lower the number of outstanding I/Os on
the wire.

Also, add a check to skip sending DataIN if TASK_SET_FULL status
has already been set due to a response lport->tt.seq_send()
failure, that has asked target-core to requeue a response.

Reported-by: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Jun Wu <jwu@stormojo.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_io.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index e415af3..140659f 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -82,6 +82,10 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 
 	if (cmd->aborted)
 		return 0;
+
+	if (se_cmd->scsi_status == SAM_STAT_TASK_SET_FULL)
+		goto queue_status;
+
 	ep = fc_seq_exch(cmd->seq);
 	lport = ep->lp;
 	cmd->seq = lport->tt.seq_start_next(cmd->seq);
@@ -178,14 +182,22 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			       FC_TYPE_FCP, f_ctl, fh_off);
 		error = lport->tt.seq_send(lport, seq, fp);
 		if (error) {
-			/* XXX For now, initiator will retry */
 			pr_err_ratelimited("%s: Failed to send frame %p, "
 						"xid <0x%x>, remaining %zu, "
 						"lso_max <0x%x>\n",
 						__func__, fp, ep->xid,
 						remaining, lport->lso_max);
+			/*
+			 * Generate a TASK_SET_FULL status to notify the
+			 * initiator to reduce it's queue_depth, ignoring
+			 * the rest of the data-in and immediately attempt
+			 * to send the response.
+			 */
+			se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
+			break;
 		}
 	}
+queue_status:
 	return ft_queue_status(se_cmd);
 }
 
-- 
1.7.10.4
