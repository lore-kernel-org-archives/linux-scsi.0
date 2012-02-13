From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] qla_target/tcm_qla2xxx: Fix TMR_ABORT_TASK with target mode usage
Date: Mon, 13 Feb 2012 11:42:27 +0000
Message-ID: <1329133347-13359-5-git-send-email-nab@linux-iscsi.org>
References: <1329133347-13359-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1329133347-13359-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes qla_target.c code use the proper TMR_ABORT_TASK
that target-core is expecting, instead of the incorrect ABORT_TASK
message code usage from include/scsi/scsi.h.

It also changes tgt_ops->handle_tmr() -> tcm_qla2xxx_handle_tmr()
to accept referenced tag for TMR_ABORT_TASK that is setup to
se_tmr_req->ref_task_tag.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c  |   15 +++++++--------
 drivers/scsi/qla2xxx/qla_target.h  |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    6 +++++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    3 ++-
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 4b24457..ac203ef 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1304,7 +1304,8 @@ static int __qla_tgt_24xx_handle_abts(struct scsi_qla_host *vha,
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 
-	rc = ha->tgt_ops->handle_tmr(mcmd, 0, ABORT_TASK);
+	rc = ha->tgt_ops->handle_tmr(mcmd, 0, TMR_ABORT_TASK,
+				abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		printk(KERN_ERR "qla_target(%d):  tgt_ops->handle_tmr()"
 				" failed: %d", vha->vp_idx, rc);
@@ -1428,7 +1429,7 @@ void qla_tgt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 	unsigned long flags;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xe116, "TM response mcmd"
-		" (%p) status %#x state %#x", mcmd, mcmd->se_tmr_req->response,
+		" (%p) status %#x state %#x", mcmd, mcmd->fc_tm_rsp,
 		mcmd->flags);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1436,7 +1437,7 @@ void qla_tgt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 		qla_tgt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
 			0, 0, 0, 0, 0, 0);
 	else {
-		if (mcmd->se_tmr_req->function == ABORT_TASK)
+		if (mcmd->se_tmr_req->function == TMR_ABORT_TASK)
 			qla_tgt_24xx_send_abts_resp(vha, &mcmd->orig_iocb.abts,
 				mcmd->fc_tm_rsp, false);
 		else
@@ -2804,7 +2805,7 @@ static int qla_tgt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 		return -ENOSYS;
 	}
 
-	res = ha->tgt_ops->handle_tmr(mcmd, lun, tmr_func);
+	res = ha->tgt_ops->handle_tmr(mcmd, lun, tmr_func, 0);
 	if (res != 0) {
 		printk(KERN_ERR "qla_target(%d): tgt_ops->handle_tmr() failed: %d\n",
 			    sess->vha->vp_idx, res);
@@ -2857,7 +2858,6 @@ static int __qla_tgt_abort_task(struct scsi_qla_host *vha,
 	struct qla_tgt_mgmt_cmd *mcmd;
 	uint32_t lun, unpacked_lun;
 	int rc;
-	uint16_t tag;
 
 	mcmd = mempool_alloc(qla_tgt_mgmt_cmd_mempool, GFP_ATOMIC);
 	if (mcmd == NULL) {
@@ -2870,12 +2870,11 @@ static int __qla_tgt_abort_task(struct scsi_qla_host *vha,
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.imm_ntfy, iocb, sizeof(mcmd->orig_iocb.imm_ntfy));
 
-	tag = le16_to_cpu(iocb->u.isp2x.seq_id);
-
 	lun = a->u.isp24.fcp_cmnd.lun;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
-	rc = ha->tgt_ops->handle_tmr(mcmd, unpacked_lun, ABORT_TASK);
+	rc = ha->tgt_ops->handle_tmr(mcmd, unpacked_lun, TMR_ABORT_TASK,
+				le16_to_cpu(iocb->u.isp2x.seq_id));
 	if (rc != 0) {
 		printk(KERN_ERR "qla_target(%d): tgt_ops->handle_tmr()"
 			" failed: %d\n", vha->vp_idx, rc);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index b98b923..935ea32 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -634,7 +634,7 @@ struct qla_tgt_func_tmpl {
 	int (*handle_cmd)(struct scsi_qla_host *, struct qla_tgt_cmd *,
 			unsigned char *, uint32_t, int, int, int);
 	int (*handle_data)(struct qla_tgt_cmd *);
-	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, uint32_t, uint8_t);
+	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, uint32_t, uint8_t, uint32_t);
 	void (*free_cmd)(struct qla_tgt_cmd *);
 	void (*free_session)(struct qla_tgt_sess *);
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 71de7a6..5456af2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -668,7 +668,8 @@ int tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 /*
  * Called from qla_target.c:qla_tgt_issue_task_mgmt()
  */
-int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun, uint8_t tmr_func)
+int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
+			uint8_t tmr_func, uint32_t tag)
 {
 	struct qla_tgt_sess *sess = mcmd->sess;
 	struct se_session *se_sess = sess->se_sess;
@@ -688,6 +689,9 @@ int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun, uint8_t
 	 * Save the se_tmr_req for qla_tgt_xmit_tm_rsp() callback into LLD code
 	 */
 	mcmd->se_tmr_req = &se_cmd->se_tmr_req;
+
+	if (tmr_func == TMR_ABORT_TASK)
+		mcmd->se_tmr_req->ref_task_tag = tag;
 	/*
 	 * Locate the underlying TCM struct se_lun from sc->device->lun
 	 */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 9dbac00..e700c15 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -139,7 +139,8 @@ extern int tcm_qla2xxx_handle_cmd(struct scsi_qla_host *, struct qla_tgt_cmd *,
 			unsigned char *, uint32_t, int, int, int);
 extern int tcm_qla2xxx_new_cmd_map(struct se_cmd *);
 extern int tcm_qla2xxx_handle_data(struct qla_tgt_cmd *);
-extern int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *, uint32_t, uint8_t);
+extern int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *, uint32_t,
+				uint8_t, uint32_t);
 extern int tcm_qla2xxx_queue_data_in(struct se_cmd *);
 extern int tcm_qla2xxx_queue_status(struct se_cmd *);
 extern int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *);
-- 
1.7.2.5
