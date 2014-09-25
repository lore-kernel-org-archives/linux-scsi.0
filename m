From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 17/17] qla2xxx: Add memory barrier before ringing doorbell.
Date: Thu, 25 Sep 2014 06:14:59 -0400
Message-ID: <1411640099-7856-18-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index f3287e1..829752c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1040,6 +1040,8 @@ static void qlt_send_notify_ack(struct scsi_qla_host *vha,
 	    "qla_target(%d): Sending 24xx Notify Ack %d\n",
 	    vha->vp_idx, nack->u.isp24.status);
 
+	/* Memory Barrier */
+	wmb();
 	qla2x00_start_iocbs(vha, vha->req);
 }
 
@@ -1117,6 +1119,8 @@ static void qlt_24xx_send_abts_resp(struct scsi_qla_host *vha,
 
 	vha->vha_tgt.qla_tgt->abts_resp_expected++;
 
+	/* Memory Barrier */
+	wmb();
 	qla2x00_start_iocbs(vha, vha->req);
 }
 
@@ -1162,6 +1166,8 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 		CTIO7_FLAGS_TERMINATE);
 	ctio->u.status1.ox_id = cpu_to_le16(entry->fcp_hdr_le.ox_id);
 
+	/* Memory Barrier */
+	wmb();
 	qla2x00_start_iocbs(vha, vha->req);
 
 	qlt_24xx_send_abts_resp(vha, (struct abts_recv_from_24xx *)entry,
@@ -1333,6 +1339,8 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	ctio->u.status1.response_len = __constant_cpu_to_le16(8);
 	ctio->u.status1.sense_data[0] = resp_code;
 
+	/* Memory Barrier */
+	wmb();
 	qla2x00_start_iocbs(ha, ha->req);
 }
 
@@ -2412,6 +2420,8 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	cmd->state = QLA_TGT_STATE_PROCESSED; /* Mid-level is done processing */
 	cmd->cmd_sent_to_fw = 1;
 
+	/* Memory Barrier */
+	wmb();
 	qla2x00_start_iocbs(vha, vha->req);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -2488,6 +2498,8 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	cmd->state = QLA_TGT_STATE_NEED_DATA;
 	cmd->cmd_sent_to_fw = 1;
 
+	/* Memory Barrier */
+	wmb();
 	qla2x00_start_iocbs(vha, vha->req);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -2696,6 +2708,8 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	if (ctio24->u.status1.residual != 0)
 		ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
 
+	/* Memory Barrier */
+	wmb();
 	qla2x00_start_iocbs(vha, vha->req);
 	return ret;
 }
@@ -4329,6 +4343,8 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	 */
 	ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
 	ctio24->u.status1.scsi_status = cpu_to_le16(status);
+	/* Memory Barrier */
+	wmb();
 	qla2x00_start_iocbs(vha, vha->req);
 	return 0;
 }
-- 
1.7.7
