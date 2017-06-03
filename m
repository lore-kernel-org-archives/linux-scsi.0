From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] qla2xxx: Convert QLA_TGT_ABTS to TARGET_SCF_LOOKUP_LUN_FROM_TAG
Date: Sat,  3 Jun 2017 22:10:08 +0000
Message-ID: <1496527808-28789-4-git-send-email-nab@linux-iscsi.org>
References: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@cavium.com>, Quinn Tran <quinn.tran@cavium.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Following Himanshu's earlier patch to drop the redundant tag
lookup within __qlt_24xx_handle_abts(), go ahead and drop this
now QLA_TGT_ABTS can use TARGET_SCF_LOOKUP_LUN_FROM_TAG and
have target_submit_tmr() do this from common code.

Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Quinn Tran <quinn.tran@cavium.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c  | 39 +++++++++-----------------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 +++-
 2 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0e03ca2..401e245 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1847,38 +1847,13 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts, struct fc_port *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_mgmt_cmd *mcmd;
-	struct se_cmd *se_cmd;
-	u32 lun = 0;
 	int rc;
-	bool found_lun = false;
-	unsigned long flags;
-
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		struct qla_tgt_cmd *cmd =
-			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
-		if (se_cmd->tag == abts->exchange_addr_to_abort) {
-			lun = cmd->unpacked_lun;
-			found_lun = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
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
@@ -1899,7 +1874,11 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	mcmd->reset_count = vha->hw->chip_reset;
 	mcmd->tmr_func = QLA_TGT_ABTS;
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, mcmd->tmr_func,
+	/*
+	 * LUN is looked up by target-core internally based on the passed
+	 * abts->exchange_addr_to_abort tag.
+	 */
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, mcmd->tmr_func,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7443e4e..75aeb9f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -601,11 +601,13 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 	struct fc_port *sess = mcmd->sess;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
 	int transl_tmr_func = 0;
+	int flags = TARGET_SCF_ACK_KREF;
 
 	switch (tmr_func) {
 	case QLA_TGT_ABTS:
 		pr_debug("%ld: ABTS received\n", sess->vha->host_no);
 		transl_tmr_func = TMR_ABORT_TASK;
+		flags |= TARGET_SCF_LOOKUP_LUN_FROM_TAG;
 		break;
 	case QLA_TGT_2G_ABORT_TASK:
 		pr_debug("%ld: 2G Abort Task received\n", sess->vha->host_no);
@@ -638,7 +640,7 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 	}
 
 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
-	    transl_tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
+	    transl_tmr_func, GFP_ATOMIC, tag, flags);
 }
 
 static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
-- 
1.9.1
