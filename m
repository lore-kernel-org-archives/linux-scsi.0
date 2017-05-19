From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 15/25] qla2xxx: Convert 32-bit LUN usage to 64-bit
Date: Fri, 19 May 2017 14:53:34 -0700
Message-ID: <20170519215344.2168-16-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:53860
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756823AbdESVyO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:54:14 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Convert 32bit LUN field to 64bit LUN.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 30 +++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_target.h  |  4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  2 +-
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a2e17a5794ab..d6ad8d711e4c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1799,7 +1799,7 @@ static int abort_cmd_for_tag(struct scsi_qla_host *vha, uint32_t tag)
  *     for the same lun)
  */
 static void abort_cmds_for_lun(struct scsi_qla_host *vha,
-				uint32_t lun, uint8_t *s_id)
+	u64 lun, uint8_t *s_id)
 {
 	struct qla_tgt_sess_op *op;
 	struct qla_tgt_cmd *cmd;
@@ -1810,7 +1810,7 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 	spin_lock_irqsave(&vha->cmd_list_lock, flags);
 	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {
 		uint32_t op_key;
-		uint32_t op_lun;
+		u64 op_lun;
 
 		op_key = sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
 		op_lun = scsilun_to_int(
@@ -1832,7 +1832,7 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 
 	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
 		uint32_t cmd_key;
-		uint32_t cmd_lun;
+		u64 cmd_lun;
 
 		cmd_key = sid_to_key(cmd->atio.u.isp24.fcp_hdr.s_id);
 		cmd_lun = scsilun_to_int(
@@ -1851,17 +1851,13 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_mgmt_cmd *mcmd;
 	struct se_cmd *se_cmd;
-	u32 lun = 0;
 	int rc;
 	bool found_lun = false;
 	unsigned long flags;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		struct qla_tgt_cmd *cmd =
-			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
 		if (se_cmd->tag == abts->exchange_addr_to_abort) {
-			lun = cmd->unpacked_lun;
 			found_lun = true;
 			break;
 		}
@@ -1900,7 +1896,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	mcmd->reset_count = vha->hw->chip_reset;
 	mcmd->tmr_func = QLA_TGT_ABTS;
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, mcmd->tmr_func,
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, mcmd->tmr_func,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,
@@ -4334,13 +4330,12 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt;
 	struct fc_port *sess;
-	uint32_t lun, unpacked_lun;
+	u64 unpacked_lun;
 	int fn;
 	unsigned long flags;
 
 	tgt = vha->vha_tgt.qla_tgt;
 
-	lun = a->u.isp24.fcp_cmnd.lun;
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -4348,7 +4343,8 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	    a->u.isp24.fcp_hdr.s_id);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
-	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
+	unpacked_lun =
+	    scsilun_to_int((struct scsi_lun *)&a->u.isp24.fcp_cmnd.lun);
 
 	if (!sess) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf024,
@@ -4371,7 +4367,7 @@ static int __qlt_abort_task(struct scsi_qla_host *vha,
 	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_mgmt_cmd *mcmd;
-	uint32_t lun, unpacked_lun;
+	u64 unpacked_lun;
 	int rc;
 
 	mcmd = mempool_alloc(qla_tgt_mgmt_cmd_mempool, GFP_ATOMIC);
@@ -4387,8 +4383,8 @@ static int __qlt_abort_task(struct scsi_qla_host *vha,
 	memcpy(&mcmd->orig_iocb.imm_ntfy, iocb,
 	    sizeof(mcmd->orig_iocb.imm_ntfy));
 
-	lun = a->u.isp24.fcp_cmnd.lun;
-	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
+	unpacked_lun =
+	    scsilun_to_int((struct scsi_lun *)&a->u.isp24.fcp_cmnd.lun);
 	mcmd->reset_count = vha->hw->chip_reset;
 	mcmd->tmr_func = QLA_TGT_2G_ABORT_TASK;
 
@@ -5877,7 +5873,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	unsigned long flags;
 	uint8_t *s_id = NULL; /* to hide compiler warnings */
 	int rc;
-	uint32_t lun, unpacked_lun;
+	u64 unpacked_lun;
 	int fn;
 	void *iocb;
 
@@ -5913,9 +5909,9 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	}
 
 	iocb = a;
-	lun = a->u.isp24.fcp_cmnd.lun;
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
-	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
+	unpacked_lun =
+	    scsilun_to_int((struct scsi_lun *)&a->u.isp24.fcp_cmnd.lun);
 
 	rc = qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
 	ha->tgt.tgt_ops->put_sess(sess);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index d64420251194..dadd9c81bd1d 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -675,7 +675,7 @@ struct qla_tgt_func_tmpl {
 	int (*handle_cmd)(struct scsi_qla_host *, struct qla_tgt_cmd *,
 			unsigned char *, uint32_t, int, int, int);
 	void (*handle_data)(struct qla_tgt_cmd *);
-	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, uint32_t, uint16_t,
+	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, u64, uint16_t,
 			uint32_t);
 	void (*free_cmd)(struct qla_tgt_cmd *);
 	void (*free_mcmd)(struct qla_tgt_mgmt_cmd *);
@@ -885,7 +885,7 @@ struct qla_tgt_cmd {
 	int sg_cnt;		/* SG segments count */
 	int bufflen;		/* cmd buffer length */
 	int offset;
-	uint32_t unpacked_lun;
+	u64 unpacked_lun;
 	enum dma_data_direction dma_data_direction;
 	uint32_t reset_count;
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 07f8ad001bcb..871a75ffc3a8 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -595,7 +595,7 @@ static int tcm_qla2xxx_dif_tags(struct qla_tgt_cmd *cmd,
 /*
  * Called from qla_target.c:qlt_issue_task_mgmt()
  */
-static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
+static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 	uint16_t tmr_func, uint32_t tag)
 {
 	struct fc_port *sess = mcmd->sess;
-- 
2.12.0
