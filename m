From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 09/13] target/fc: Call lookup_tmr_lun() for all TM types
Date: Thu, 19 Jan 2012 13:39:19 -0800
Message-ID: <1327009163-10177-10-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com
List-Id: linux-scsi@vger.kernel.org

Don't see a reason to differentiate.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/tcm_fc/tfc_cmd.c |   38 +++++++++++---------------------------
 1 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index bd69ce9..e784514 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -354,11 +354,10 @@ static void ft_send_resp_code_and_free(struct ft_cmd *cmd,
 static void ft_send_tm(struct ft_cmd *cmd)
 {
 	struct fcp_cmnd *fcp;
-	struct ft_sess *sess;
 	u8 tm_func;
+	int ret;
 
 	fcp = fc_frame_payload_get(cmd->req_frame, sizeof(*fcp));
-
 	switch (fcp->fc_tm_flags) {
 	case FCP_TMF_LUN_RESET:
 		tm_func = TMR_LUN_RESET;
@@ -393,33 +392,18 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	pr_debug("alloc tm cmd fn %d\n", tm_func);
 	core_tmr_req_init(&cmd->se_cmd, cmd, tm_func);
 
-	switch (fcp->fc_tm_flags) {
-	case FCP_TMF_LUN_RESET:
-		if (transport_lookup_tmr_lun(&cmd->se_cmd, scsilun_to_int(&fcp->fc_lun)) < 0) {
-			/*
-			 * Make sure to clean up newly allocated TMR request
-			 * since "unable to  handle TMR request because failed
-			 * to get to LUN"
-			 */
-			pr_debug("Failed to get LUN for TMR func %d, "
-				  "se_cmd %p, unpacked_lun %d\n",
-				  tm_func, &cmd->se_cmd, scsilun_to_int(&fcp->fc_lun));
-			ft_dump_cmd(cmd, __func__);
-			sess = cmd->sess;
-			transport_send_check_condition_and_sense(&cmd->se_cmd,
-				cmd->se_cmd.scsi_sense_reason, 0);
-			ft_sess_put(sess);
-			return;
-		}
-		break;
-	case FCP_TMF_TGT_RESET:
-	case FCP_TMF_CLR_TASK_SET:
-	case FCP_TMF_ABT_TASK_SET:
-	case FCP_TMF_CLR_ACA:
-		break;
-	default:
+	ret = transport_lookup_tmr_lun(&cmd->se_cmd, scsilun_to_int(&fcp->fc_lun));
+	if (ret < 0) {
+		pr_debug("Failed to get LUN for TMR func %d, "
+			 "se_cmd %p, unpacked_lun %d\n",
+			 tm_func, &cmd->se_cmd, scsilun_to_int(&fcp->fc_lun));
+		ft_dump_cmd(cmd, __func__);
+		transport_send_check_condition_and_sense(&cmd->se_cmd,
+			cmd->se_cmd.scsi_sense_reason, 0);
+		ft_sess_put(cmd->sess);
 		return;
 	}
+
 	transport_generic_handle_tmr(&cmd->se_cmd);
 }
 
-- 
1.7.1
