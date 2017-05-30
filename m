From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 13/17] qla2xxx: Remove redundant code
Date: Tue, 30 May 2017 10:54:28 -0700
Message-ID: <20170530175432.26984-14-himanshu.madhani@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0076.outbound.protection.outlook.com ([104.47.37.76]:56960
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbdE3RzL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 13:55:11 -0400
In-Reply-To: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

During ABTS or Abort task, qla2xxx does a pre-search for
the se_cmd, based on command's tag. The same search is
performed by TCM. Remove the extra search from qla2xxx.

The reason for hard coding LUN ID to 0 is that, from the FC
protocol perspective, ABTS does not have any knowledge of
LUN ID. So, there is no reason for qla2xxx driver to
manufacture the LUN ID.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 765145151fa0..d2c9b565ca00 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1838,40 +1838,24 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
 }
 
+/*
+ * From FC protocol perspective, ABTS does not have any knowledge of LUN ID.
+ * Passing default LUN ID of 0.
+ */
+#define DEFAULT_LUN_ID 0
+
 /* ha->hardware_lock supposed to be held on entry */
 static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts, struct fc_port *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_mgmt_cmd *mcmd;
-	struct qla_tgt_cmd *cmd;
-	struct se_cmd *se_cmd;
 	int rc;
-	bool found_lun = false;
-	unsigned long flags;
 
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		if (se_cmd->tag == abts->exchange_addr_to_abort) {
-			found_lun = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-
-	/* cmd not in LIO lists, look in qla list */
-	if (!found_lun) {
-		if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
-			/* send TASK_ABORT response immediately */
-			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
-			return 0;
-		} else {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf081,
-			    "unable to find cmd in driver or LIO for tag 0x%x\n",
-			    abts->exchange_addr_to_abort);
-			return -ENOENT;
-		}
+	if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
+		/* send TASK_ABORT response immediately */
+		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
+		return 0;
 	}
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
@@ -1887,13 +1871,12 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	}
 	memset(mcmd, 0, sizeof(*mcmd));
 
-	cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 	mcmd->reset_count = vha->hw->chip_reset;
 	mcmd->tmr_func = QLA_TGT_ABTS;
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, cmd->unpacked_lun, mcmd->tmr_func,
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, DEFAULT_LUN_ID, mcmd->tmr_func,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,
-- 
2.12.0
