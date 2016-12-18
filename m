From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 2/9] qla2xxx: Cleanup TMF code translation from qla_target.
Date: Sun, 18 Dec 2016 01:02:42 -0800
Message-ID: <1482051769-22941-3-git-send-email-himanshu.madhani@cavium.com>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Move code code which converts Task Mgmt Command flags for
ATIO to TCM #defines, from qla2xxx driver to tcm_qla2xxx
driver.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 71 +++-----------------------------------
 drivers/scsi/qla2xxx/qla_target.h  |  6 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 37 ++++++++++++++++++--
 3 files changed, 43 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 9b92a74..452ac1d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1568,9 +1568,10 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 	mcmd->reset_count = vha->hw->chip_reset;
+	mcmd->tmr_func = QLA_TGT_ABTS;
 
 	/* handle_tmr will search for LUN id based on exchange addr*/
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, TMR_ABORT_TASK,
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, mcmd->tmr_func,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,
@@ -4035,7 +4036,6 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 	struct qla_tgt_mgmt_cmd *mcmd;
 	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	int res;
-	uint8_t tmr_func;
 
 	mcmd = mempool_alloc(qla_tgt_mgmt_cmd_mempool, GFP_ATOMIC);
 	if (!mcmd) {
@@ -4057,74 +4057,12 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 	mcmd->reset_count = vha->hw->chip_reset;
 
 	switch (fn) {
-	case QLA_TGT_CLEAR_ACA:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10000,
-		    "qla_target(%d): CLEAR_ACA received\n", sess->vha->vp_idx);
-		tmr_func = TMR_CLEAR_ACA;
-		break;
-
-	case QLA_TGT_TARGET_RESET:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10001,
-		    "qla_target(%d): TARGET_RESET received\n",
-		    sess->vha->vp_idx);
-		tmr_func = TMR_TARGET_WARM_RESET;
-		break;
-
 	case QLA_TGT_LUN_RESET:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10002,
-		    "qla_target(%d): LUN_RESET received\n", sess->vha->vp_idx);
-		tmr_func = TMR_LUN_RESET;
 		abort_cmds_for_lun(vha, lun, a->u.isp24.fcp_hdr.s_id);
 		break;
-
-	case QLA_TGT_CLEAR_TS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10003,
-		    "qla_target(%d): CLEAR_TS received\n", sess->vha->vp_idx);
-		tmr_func = TMR_CLEAR_TASK_SET;
-		break;
-
-	case QLA_TGT_ABORT_TS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10004,
-		    "qla_target(%d): ABORT_TS received\n", sess->vha->vp_idx);
-		tmr_func = TMR_ABORT_TASK_SET;
-		break;
-#if 0
-	case QLA_TGT_ABORT_ALL:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10005,
-		    "qla_target(%d): Doing ABORT_ALL_TASKS\n",
-		    sess->vha->vp_idx);
-		tmr_func = 0;
-		break;
-
-	case QLA_TGT_ABORT_ALL_SESS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10006,
-		    "qla_target(%d): Doing ABORT_ALL_TASKS_SESS\n",
-		    sess->vha->vp_idx);
-		tmr_func = 0;
-		break;
-
-	case QLA_TGT_NEXUS_LOSS_SESS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10007,
-		    "qla_target(%d): Doing NEXUS_LOSS_SESS\n",
-		    sess->vha->vp_idx);
-		tmr_func = 0;
-		break;
-
-	case QLA_TGT_NEXUS_LOSS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10008,
-		    "qla_target(%d): Doing NEXUS_LOSS\n", sess->vha->vp_idx);
-		tmr_func = 0;
-		break;
-#endif
-	default:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000a,
-		    "qla_target(%d): Unknown task mgmt fn 0x%x\n",
-		    sess->vha->vp_idx, fn);
-		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
-		return -ENOSYS;
 	}
 
-	res = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, tmr_func, 0);
+	res = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, mcmd->tmr_func, 0);
 	if (res != 0) {
 		ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000b,
 		    "qla_target(%d): tgt.tgt_ops->handle_tmr() failed: %d\n",
@@ -4199,8 +4137,9 @@ static int __qlt_abort_task(struct scsi_qla_host *vha,
 	lun = a->u.isp24.fcp_cmnd.lun;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 	mcmd->reset_count = vha->hw->chip_reset;
+	mcmd->tmr_func = QLA_TGT_2G_ABORT_TASK;
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, unpacked_lun, TMR_ABORT_TASK,
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, unpacked_lun, mcmd->tmr_func,
 	    le16_to_cpu(iocb->u.isp2x.seq_id));
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf060,
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index f26c5f6..7f11e0c 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -724,7 +724,7 @@ struct qla_tgt_func_tmpl {
 			unsigned char *, uint32_t, int, int, int);
 	void (*handle_data)(struct qla_tgt_cmd *);
 	void (*handle_dif_err)(struct qla_tgt_cmd *);
-	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, uint32_t, uint8_t,
+	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, uint32_t, uint16_t,
 			uint32_t);
 	void (*free_cmd)(struct qla_tgt_cmd *);
 	void (*free_mcmd)(struct qla_tgt_mgmt_cmd *);
@@ -775,6 +775,8 @@ struct qla_tgt_func_tmpl {
 #define QLA_TGT_ABORT_ALL               0xFFFE
 #define QLA_TGT_NEXUS_LOSS_SESS         0xFFFD
 #define QLA_TGT_NEXUS_LOSS              0xFFFC
+#define QLA_TGT_ABTS					0xFFFB
+#define QLA_TGT_2G_ABORT_TASK			0xFFFA
 
 /* Notify Acknowledge flags */
 #define NOTIFY_ACK_RES_COUNT        BIT_8
@@ -1036,7 +1038,7 @@ struct qla_tgt_sess_work_param {
 };
 
 struct qla_tgt_mgmt_cmd {
-	uint8_t tmr_func;
+	uint16_t tmr_func;
 	uint8_t fc_tm_rsp;
 	struct qla_tgt_sess *sess;
 	struct se_cmd se_cmd;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 9275f36..6e98573 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -563,15 +563,16 @@ static void tcm_qla2xxx_handle_dif_err(struct qla_tgt_cmd *cmd)
  * Called from qla_target.c:qlt_issue_task_mgmt()
  */
 static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
-	uint8_t tmr_func, uint32_t tag)
+	uint16_t tmr_func, uint32_t tag)
 {
 	struct qla_tgt_sess *sess = mcmd->sess;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
 	struct se_session *se_sess = sess->se_sess;
 	bool found_lun = false;
+	int transl_tmr_func;
 
 	switch (tmr_func) {
-	case TMR_ABORT_TASK:
+	case QLA_TGT_ABTS:
 		spin_lock(&se_sess->sess_cmd_lock);
 		list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
 			struct qla_tgt_cmd *cmd =
@@ -587,13 +588,43 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 		spin_unlock(&se_sess->sess_cmd_lock);
 		if (!found_lun)
 			return -ENOBUFS;
+
+		pr_debug("%ld: ABTS received\n", sess->vha->host_no);
+		transl_tmr_func = TMR_ABORT_TASK;
+		break;
+	case QLA_TGT_2G_ABORT_TASK:
+		pr_debug("%ld: 2G Abort Task received\n", sess->vha->host_no);
+		transl_tmr_func = TMR_ABORT_TASK;
+		break;
+	case QLA_TGT_CLEAR_ACA:
+		pr_debug("%ld: CLEAR_ACA received\n", sess->vha->host_no);
+		transl_tmr_func = TMR_CLEAR_ACA;
+		break;
+	case QLA_TGT_TARGET_RESET:
+		pr_debug("%ld: TARGET_RESET received\n", sess->vha->host_no);
+		transl_tmr_func = TMR_TARGET_WARM_RESET;
+		break;
+	case QLA_TGT_LUN_RESET:
+		pr_debug("%ld: LUN_RESET received\n", sess->vha->host_no);
+		transl_tmr_func = TMR_LUN_RESET;
+		break;
+	case QLA_TGT_CLEAR_TS:
+		pr_debug("%ld: CLEAR_TS received\n", sess->vha->host_no);
+		transl_tmr_func = TMR_CLEAR_TASK_SET;
+		break;
+	case QLA_TGT_ABORT_TS:
+		pr_debug("%ld: ABORT_TS received\n", sess->vha->host_no);
+		transl_tmr_func = TMR_ABORT_TASK_SET;
 		break;
 	default:
+		pr_debug("%ld: Unknown task mgmt fn 0x%x\n",
+		    sess->vha->host_no, tmr_func);
+		return -ENOSYS;
 		break;
 	}
 
 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
-			tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
+	    transl_tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
 }
 
 static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
-- 
1.8.3.1
