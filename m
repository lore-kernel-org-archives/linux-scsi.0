From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 09/12] tcm_fc: Fix ft_send_tm-bug and drop
 ft_get_lun_for_cmd usage
Date: Mon, 20 Jun 2011 16:59:36 -0700
Message-ID: <20110620235936.1777.869.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab1FTX7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:53 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Kiran Patil <kiran.patil@intel.com>

This patch fixes a bug in ft_send_tm() that was incorrectly calling
ft_get_lun_for_cmd() -> transport_get_lun_for_cmd(), instead of using
transport_get_lun_for_tmr() for the proper struct se_lun lookup.

It also drops the now unnecessary ft_get_lun_for_cmd() code, and uses
scsilun_to_int() directly ahead of direct transport_get_lun_for_cmd()
and transport_get_lun_for_tmr usage().

Patch was reworked due to NULL pointer access in function transport_get_lun_for_tmr(),
(NOTE: transport_get_lun_for_tmr access tmr_req pointer which caused
panic due to NULL pointer access) This patch fixes the issue by re-arranging
the codepath where function "transport_get_lun_for_tmr" is called
after tmr request is allocated and made it available as part of se_cmd.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/target/tcm_fc/tcm_fc.h  |    2 +
 drivers/target/tcm_fc/tfc_cmd.c |   62 ++++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index defff32..7b82f1b 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -144,7 +144,7 @@ enum ft_cmd_state {
  */
 struct ft_cmd {
 	enum ft_cmd_state state;
-	u16 lun;			/* LUN from request */
+	u32 lun;                        /* LUN from request */
 	struct ft_sess *sess;		/* session held for cmd */
 	struct fc_seq *seq;		/* sequence in exchange mgr */
 	struct se_cmd se_cmd;		/* Local TCM I/O descriptor */
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 1625b48..cdbcb6c 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -94,29 +94,6 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 		16, 4, cmd->cdb, MAX_COMMAND_SIZE, 0);
 }
 
-/*
- * Get LUN from CDB.
- */
-static int ft_get_lun_for_cmd(struct ft_cmd *cmd, u8 *lunp)
-{
-	u64 lun;
-
-	lun = lunp[1];
-	switch (lunp[0] >> 6) {
-	case 0:
-		break;
-	case 1:
-		lun |= (lunp[0] & 0x3f) << 8;
-		break;
-	default:
-		return -1;
-	}
-	if (lun >= TRANSPORT_MAX_LUNS_PER_TPG)
-		return -1;
-	cmd->lun = lun;
-	return transport_get_lun_for_cmd(&cmd->se_cmd, NULL, lun);
-}
-
 static void ft_queue_cmd(struct ft_sess *sess, struct ft_cmd *cmd)
 {
 	struct se_queue_obj *qobj;
@@ -426,13 +403,6 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	switch (fcp->fc_tm_flags) {
 	case FCP_TMF_LUN_RESET:
 		tm_func = TMR_LUN_RESET;
-		if (ft_get_lun_for_cmd(cmd, fcp->fc_lun) < 0) {
-			ft_dump_cmd(cmd, __func__);
-			transport_send_check_condition_and_sense(&cmd->se_cmd,
-				cmd->se_cmd.scsi_sense_reason, 0);
-			ft_sess_put(cmd->sess);
-			return;
-		}
 		break;
 	case FCP_TMF_TGT_RESET:
 		tm_func = TMR_TARGET_WARM_RESET;
@@ -464,6 +434,35 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		return;
 	}
 	cmd->se_cmd.se_tmr_req = tmr;
+
+	switch (fcp->fc_tm_flags) {
+	case FCP_TMF_LUN_RESET:
+		cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
+		if (transport_get_lun_for_tmr(&cmd->se_cmd, cmd->lun) < 0) {
+			/*
+			 * Make sure to clean up newly allocated TMR request
+			 * since "unable to  handle TMR request because failed
+			 * to get to LUN"
+			 */
+			FT_TM_DBG("Failed to get LUN for TMR func %d, "
+				  "se_cmd %p, unpacked_lun %d\n",
+				  tm_func, &cmd->se_cmd, cmd->lun);
+			transport_generic_free_cmd(&cmd->se_cmd, 0, 1, 0);
+			ft_dump_cmd(cmd, __func__);
+			transport_send_check_condition_and_sense(&cmd->se_cmd,
+				cmd->se_cmd.scsi_sense_reason, 0);
+			ft_sess_put(cmd->sess);
+			return;
+		}
+		break;
+	case FCP_TMF_TGT_RESET:
+	case FCP_TMF_CLR_TASK_SET:
+	case FCP_TMF_ABT_TASK_SET:
+	case FCP_TMF_CLR_ACA:
+		break;
+	default:
+		return;
+	}
 	transport_generic_handle_tmr(&cmd->se_cmd);
 }
 
@@ -636,7 +635,8 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 
 	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 
-	ret = ft_get_lun_for_cmd(cmd, fcp->fc_lun);
+	cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
+	ret = transport_get_lun_for_cmd(&cmd->se_cmd, NULL, cmd->lun);
 	if (ret < 0) {
 		ft_dump_cmd(cmd, __func__);
 		transport_send_check_condition_and_sense(&cmd->se_cmd,

