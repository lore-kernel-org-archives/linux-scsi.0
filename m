From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 1/9] qla2xxx: Move cmd search out of qla during ABTS
Date: Sun, 18 Dec 2016 01:02:41 -0800
Message-ID: <1482051769-22941-2-git-send-email-himanshu.madhani@cavium.com>
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

move cmd search out of qla to remove symbol dependency.
The command list is held in se_session struct.  This knowledege
should be in tcm_qla2xxx.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 45 +++++++++++---------------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 24 ++++++++++++++++++++
 2 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index bff9689..9b92a74 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1549,38 +1549,8 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts, struct qla_tgt_sess *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_mgmt_cmd *mcmd;
-	struct se_cmd *se_cmd;
-	u32 lun = 0;
 	int rc;
-	bool found_lun = false;
-
-	spin_lock(&se_sess->sess_cmd_lock);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		struct qla_tgt_cmd *cmd =
-			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
-		if (se_cmd->tag == abts->exchange_addr_to_abort) {
-			lun = cmd->unpacked_lun;
-			found_lun = true;
-			break;
-		}
-	}
-	spin_unlock(&se_sess->sess_cmd_lock);
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
-	}
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
 	    "qla_target(%d): task abort (tag=%d)\n",
@@ -1599,14 +1569,25 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 	mcmd->reset_count = vha->hw->chip_reset;
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, TMR_ABORT_TASK,
+	/* handle_tmr will search for LUN id based on exchange addr*/
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, TMR_ABORT_TASK,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,
 		    "qla_target(%d):  tgt_ops->handle_tmr()"
 		    " failed: %d", vha->vp_idx, rc);
 		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
-		return -EFAULT;
+
+		if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
+			/* send TASK_ABORT response immediately */
+			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
+			return 0;
+		} else {
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf081,
+			    "unable to find cmd in driver or LIO for tag 0x%x\n",
+			    abts->exchange_addr_to_abort);
+			return -ENOENT;
+		}
 	}
 
 	return 0;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6643f6f..9275f36 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -567,6 +567,30 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 {
 	struct qla_tgt_sess *sess = mcmd->sess;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
+	struct se_session *se_sess = sess->se_sess;
+	bool found_lun = false;
+
+	switch (tmr_func) {
+	case TMR_ABORT_TASK:
+		spin_lock(&se_sess->sess_cmd_lock);
+		list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
+			struct qla_tgt_cmd *cmd =
+				container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+			struct abts_recv_from_24xx *abts = &mcmd->orig_iocb.abts;
+
+			if (se_cmd->tag == abts->exchange_addr_to_abort) {
+				lun = cmd->unpacked_lun;
+				found_lun = true;
+				break;
+			}
+		}
+		spin_unlock(&se_sess->sess_cmd_lock);
+		if (!found_lun)
+			return -ENOBUFS;
+		break;
+	default:
+		break;
+	}
 
 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
 			tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
-- 
1.8.3.1
