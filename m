From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 24/43] qla2xxx: Reduce the use of terminate exchange
Date: Tue, 19 Dec 2017 22:56:25 -0800
Message-ID: <20171220065644.21511-25-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0078.outbound.protection.outlook.com ([104.47.36.78]:10320
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932462AbdLTG5R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:17 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

reduce usage of terminate exchange when command encounter
resource bottle neck.  Remote initiator view it as command
drop.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 140 ++++++++++++++++++++------------------
 1 file changed, 74 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c7c81d5cf69c..e7e0689d9ca5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -75,7 +75,8 @@ MODULE_PARM_DESC(ql2xuctrlirq,
 
 int ql2x_ini_mode = QLA2XXX_INI_MODE_EXCLUSIVE;
 
-static int temp_sam_status = SAM_STAT_BUSY;
+static int qla_sam_status = SAM_STAT_BUSY;
+static int tc_sam_status = SAM_STAT_TASK_SET_FULL; /* target core */
 
 /*
  * From scsi/fc/fc_fcp.h
@@ -4294,14 +4295,14 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 	if (op->atio.u.raw.entry_count > 1) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf023,
 		    "Dropping multy entry atio %p\n", &op->atio);
-		goto out_term;
+		goto out_busy;
 	}
 
 	sess = qlt_make_local_sess(vha, s_id);
 	/* sess has an extra creation ref. */
 
 	if (!sess)
-		goto out_term;
+		goto out_busy;
 	/*
 	 * Now obtain a pre-allocated session tag using the original op->atio
 	 * packet header, and dispatch into __qlt_do_work() using the existing
@@ -4312,7 +4313,7 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 		struct qla_qpair *qpair = ha->base_qpair;
 
 		spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-		qlt_send_busy(qpair, &op->atio, SAM_STAT_BUSY);
+		qlt_send_busy(qpair, &op->atio, tc_sam_status);
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -4332,6 +4333,17 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 out_term:
 	qlt_send_term_exchange(vha->hw->base_qpair, NULL, &op->atio, 0, 0);
 	kfree(op);
+	return;
+out_busy:
+	{
+		struct qla_qpair *qpair = ha->base_qpair;
+
+		spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+		qlt_send_busy(qpair, &op->atio, qla_sam_status);
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+		kfree(op);
+	}
+	return;
 }
 
 /* ha->hardware_lock supposed to be held on entry */
@@ -4348,7 +4360,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	if (unlikely(tgt->tgt_stop)) {
 		ql_dbg(ql_dbg_io, vha, 0x3061,
 		    "New command while device %p is shutting down\n", tgt);
-		return -EFAULT;
+		return -ENODEV;
 	}
 
 	id.b.al_pa = atio->u.isp24.fcp_hdr.s_id[2];
@@ -4403,7 +4415,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		ha->tgt.tgt_ops->put_sess(sess);
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-		return -ENOMEM;
+		return -EBUSY;
 	}
 
 	cmd->cmd_in_wq = 1;
@@ -5504,7 +5516,6 @@ qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha, struct qla_qpair *qpair,
 	struct atio_from_isp *atio, uint8_t ha_locked)
 {
 	struct qla_hw_data *ha = vha->hw;
-	uint16_t status;
 	unsigned long flags;
 
 	if (ha->tgt.num_pend_cmds < Q_FULL_THRESH_HOLD(ha))
@@ -5512,8 +5523,7 @@ qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha, struct qla_qpair *qpair,
 
 	if (!ha_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
-	status = temp_sam_status;
-	qlt_send_busy(qpair, atio, status);
+	qlt_send_busy(qpair, atio, qla_sam_status);
 	if (!ha_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -5528,7 +5538,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	int rc;
-	unsigned long flags;
+	unsigned long flags = 0;
 
 	if (unlikely(tgt == NULL)) {
 		ql_dbg(ql_dbg_tgt, vha, 0x3064,
@@ -5552,8 +5562,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 			    "sending QUEUE_FULL\n", vha->vp_idx);
 			if (!ha_locked)
 				spin_lock_irqsave(&ha->hardware_lock, flags);
-			qlt_send_busy(ha->base_qpair, atio,
-			    SAM_STAT_TASK_SET_FULL);
+			qlt_send_busy(ha->base_qpair, atio, qla_sam_status);
 			if (!ha_locked)
 				spin_unlock_irqrestore(&ha->hardware_lock,
 				    flags);
@@ -5572,42 +5581,37 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 			rc = qlt_handle_task_mgmt(vha, atio);
 		}
 		if (unlikely(rc != 0)) {
-			if (rc == -ESRCH) {
-				if (!ha_locked)
-					spin_lock_irqsave(&ha->hardware_lock,
-					    flags);
-
-#if 1 /* With TERM EXCHANGE some FC cards refuse to boot */
-				qlt_send_busy(ha->base_qpair, atio,
-				    SAM_STAT_BUSY);
-#else
+			if (!ha_locked)
+				spin_lock_irqsave(&ha->hardware_lock, flags);
+			switch (rc) {
+			case -ENODEV:
+				ql_dbg(ql_dbg_tgt, vha, 0xe05f,
+				    "qla_target: Unable to send command to target\n");
+				break;
+			case -EBADF:
+				ql_dbg(ql_dbg_tgt, vha, 0xe05f,
+				    "qla_target: Unable to send command to target, sending TERM EXCHANGE for rsp\n");
 				qlt_send_term_exchange(ha->base_qpair, NULL,
 				    atio, 1, 0);
-#endif
-				if (!ha_locked)
-					spin_unlock_irqrestore(
-					    &ha->hardware_lock, flags);
-			} else {
-				if (tgt->tgt_stop) {
-					ql_dbg(ql_dbg_tgt, vha, 0xe059,
-					    "qla_target: Unable to send "
-					    "command to target for req, "
-					    "ignoring.\n");
-				} else {
-					ql_dbg(ql_dbg_tgt, vha, 0xe05a,
-					    "qla_target(%d): Unable to send "
-					    "command to target, sending BUSY "
-					    "status.\n", vha->vp_idx);
-					if (!ha_locked)
-						spin_lock_irqsave(
-						    &ha->hardware_lock, flags);
-					qlt_send_busy(ha->base_qpair,
-					    atio, SAM_STAT_BUSY);
-					if (!ha_locked)
-						spin_unlock_irqrestore(
-						    &ha->hardware_lock, flags);
-				}
+				break;
+			case -EBUSY:
+				ql_dbg(ql_dbg_tgt, vha, 0xe060,
+				    "qla_target(%d): Unable to send command to target, sending BUSY status\n",
+				    vha->vp_idx);
+				qlt_send_busy(ha->base_qpair, atio,
+				    tc_sam_status);
+				break;
+			default:
+				ql_dbg(ql_dbg_tgt, vha, 0xe060,
+				    "qla_target(%d): Unable to send command to target, sending BUSY status\n",
+				    vha->vp_idx);
+				qlt_send_busy(ha->base_qpair, atio,
+				    qla_sam_status);
+				break;
 			}
+			if (!ha_locked)
+				spin_unlock_irqrestore(&ha->hardware_lock,
+				    flags);
 		}
 		break;
 
@@ -5690,27 +5694,31 @@ static void qlt_response_pkt(struct scsi_qla_host *vha,
 
 		rc = qlt_handle_cmd_for_atio(vha, atio);
 		if (unlikely(rc != 0)) {
-			if (rc == -ESRCH) {
-#if 1 /* With TERM EXCHANGE some FC cards refuse to boot */
-				qlt_send_busy(rsp->qpair, atio, 0);
-#else
-				qlt_send_term_exchange(rsp->qpair, NULL, atio, 1, 0);
-#endif
-			} else {
-				if (tgt->tgt_stop) {
-					ql_dbg(ql_dbg_tgt, vha, 0xe05f,
-					    "qla_target: Unable to send "
-					    "command to target, sending TERM "
-					    "EXCHANGE for rsp\n");
-					qlt_send_term_exchange(rsp->qpair, NULL,
-					    atio, 1, 0);
-				} else {
-					ql_dbg(ql_dbg_tgt, vha, 0xe060,
-					    "qla_target(%d): Unable to send "
-					    "command to target, sending BUSY "
-					    "status\n", vha->vp_idx);
-					qlt_send_busy(rsp->qpair, atio, 0);
-				}
+			switch (rc) {
+			case -ENODEV:
+				ql_dbg(ql_dbg_tgt, vha, 0xe05f,
+				    "qla_target: Unable to send command to target\n");
+				break;
+			case -EBADF:
+				ql_dbg(ql_dbg_tgt, vha, 0xe05f,
+				    "qla_target: Unable to send command to target, sending TERM EXCHANGE for rsp\n");
+				qlt_send_term_exchange(rsp->qpair, NULL,
+				    atio, 1, 0);
+				break;
+			case -EBUSY:
+				ql_dbg(ql_dbg_tgt, vha, 0xe060,
+				    "qla_target(%d): Unable to send command to target, sending BUSY status\n",
+				    vha->vp_idx);
+				qlt_send_busy(rsp->qpair, atio,
+				    tc_sam_status);
+				break;
+			default:
+				ql_dbg(ql_dbg_tgt, vha, 0xe060,
+				    "qla_target(%d): Unable to send command to target, sending BUSY status\n",
+				    vha->vp_idx);
+				qlt_send_busy(rsp->qpair, atio,
+				    qla_sam_status);
+				break;
 			}
 		}
 	}
-- 
2.12.0
