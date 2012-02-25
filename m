From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/7] target: Allow target_submit_tmr to be called from interrupt context
Date: Sat, 25 Feb 2012 21:05:58 +0000
Message-ID: <1330203959-6170-7-git-send-email-nab@linux-iscsi.org>
References: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45547 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2BYVOU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Feb 2012 16:14:20 -0500
In-Reply-To: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Kiran Patil <kiran.patil@intel.com>, Arun Easi <arun.easi@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch allows target_submit_tmr() to pass gfp_t for se_cmd->se_tmr_req
allocation, and also sets up se_cmd->se_tmr_req->ref_task_tag for passed
tag with TMR_ABORT_TASK.

(nab: Add tcm_fc(fcoe) ref_task_tag FIXME for TMR_ABORT_TASK usage,
      and fix tcm_qla2xxx_release_cmd() callback for SCF_SCSI_TMR_CDB)

Cc: Andy Grover <agrover@redhat.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |   50 ++++---------------------------
 drivers/target/target_core_transport.c |    9 ++++--
 drivers/target/tcm_fc/tfc_cmd.c        |    4 +-
 include/target/target_core_fabric.h    |    3 +-
 4 files changed, 17 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c25e7db..384914d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -410,17 +410,6 @@ void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
  */
 int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 {
-	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
-		struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
-				struct qla_tgt_mgmt_cmd, se_cmd);
-		/*
-		 * Release the associated se_cmd->se_tmr_req and se_cmd
-		 * TMR related state now.
-		 */
-		transport_generic_free_cmd(se_cmd, 1);
-		qla_tgt_free_mcmd(mcmd);
-		return 1;
-	}
 	return target_put_sess_cmd(se_cmd->se_sess, se_cmd);
 }
 
@@ -431,8 +420,12 @@ void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd;
 
-	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
+		struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
+				struct qla_tgt_mgmt_cmd, se_cmd);
+		qla_tgt_free_mcmd(mcmd);
 		return;
+	}
 
 	cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
 	qla_tgt_free_cmd(cmd);
@@ -672,39 +665,10 @@ int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 			uint8_t tmr_func, uint32_t tag)
 {
 	struct qla_tgt_sess *sess = mcmd->sess;
-	struct se_session *se_sess = sess->se_sess;
-	struct se_portal_group *se_tpg = se_sess->se_tpg;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
-	int rc;
-	/*
-	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
-	 */
-	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
-				DMA_NONE, 0, NULL);
-
-	rc = core_tmr_alloc_req(se_cmd, mcmd, tmr_func, GFP_ATOMIC);
-	if (rc < 0) {
-		transport_generic_free_cmd(se_cmd, 1);
-		return -ENOMEM;
-	}
-	/*
-	 * Save the se_tmr_req for qla_tgt_xmit_tm_rsp() callback into LLD code
-	 */
-	mcmd->se_tmr_req = se_cmd->se_tmr_req;
 
-	if (tmr_func == TMR_ABORT_TASK)
-		mcmd->se_tmr_req->ref_task_tag = tag;
-	/*
-	 * Locate the underlying TCM struct se_lun from sc->device->lun
-	 */
-	if (transport_lookup_tmr_lun(se_cmd, lun) < 0) {
-		transport_generic_free_cmd(se_cmd, 1);
-		return -EINVAL;
-	}
-	/*
-	 * Queue the TMR associated se_cmd into TCM Core for processing
-	 */
-	return transport_generic_handle_tmr(se_cmd);
+	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
+			tmr_func, GFP_ATOMIC, tag, 0);
 }
 
 int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9bbbf89..711af7a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1726,14 +1726,14 @@ static void target_complete_tmr_failure(struct work_struct *work)
 
 int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u32 unpacked_lun,
-		void *fabric_tmr_ptr, unsigned char tm_type, int flags)
+		void *fabric_tmr_ptr, unsigned char tm_type,
+		gfp_t gfp, unsigned int tag, int flags)
 {
 	struct se_portal_group *se_tpg;
 	int ret;
 
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
-	BUG_ON(in_interrupt());
 
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
 			      0, DMA_NONE, MSG_SIMPLE_TAG, sense);
@@ -1741,10 +1741,13 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
 	 */
-	ret = core_tmr_alloc_req(se_cmd, fabric_tmr_ptr, tm_type, GFP_KERNEL);
+	ret = core_tmr_alloc_req(se_cmd, fabric_tmr_ptr, tm_type, gfp);
 	if (ret < 0)
 		return -ENOMEM;
 
+	if (tm_type == TMR_ABORT_TASK)
+		se_cmd->se_tmr_req->ref_task_tag = tag;
+
 	/* See target_submit_cmd for commentary */
 	target_get_sess_cmd(se_sess, se_cmd, (flags & TARGET_SCF_ACK_KREF));
 
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 00dcc5f..63f158d 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -383,10 +383,10 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		ft_send_resp_code_and_free(cmd, FCP_CMND_FIELDS_INVALID);
 		return;
 	}
-
+	/* FIXME: Add referenced task tag for ABORT_TASK */
 	rc = target_submit_tmr(&cmd->se_cmd, cmd->sess->se_sess,
 		&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
-			  cmd, tm_func, 0);
+			  cmd, tm_func, GFP_KERNEL, 0, 0);
 	if (rc < 0)
 		ft_send_resp_code_and_free(cmd, FCP_TMF_FAILED);
 }
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index a29092e..8a74200 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -123,7 +123,8 @@ void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u32, u32, int, int, int);
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u32 unpacked_lun,
-		void *fabric_tmr_ptr, unsigned char tm_type, int flags);
+		void *fabric_tmr_ptr, unsigned char tm_type,
+		gfp_t, unsigned int, int);
 int	transport_generic_handle_cdb_map(struct se_cmd *);
 int	transport_generic_handle_data(struct se_cmd *);
 int	transport_generic_map_mem_to_cmd(struct se_cmd *cmd,
-- 
1.7.2.5

