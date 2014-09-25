From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 15/19] qla2xxx: Fix hang due to cmd_kref not decrementing
Date: Thu, 25 Sep 2014 04:10:08 -0400
Message-ID: <1411632612-7320-16-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   18 ++++++------------
 drivers/scsi/qla2xxx/qla_target.h |    1 +
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b07b180..51aa888 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2404,6 +2404,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 
 
 	cmd->state = QLA_TGT_STATE_PROCESSED; /* Mid-level is done processing */
+	cmd->cmd_sent_to_fw = 1;
 
 	qla2x00_start_iocbs(vha, vha->req);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -2479,6 +2480,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 		qlt_load_data_segments(&prm, vha);
 
 	cmd->state = QLA_TGT_STATE_NEED_DATA;
+	cmd->cmd_sent_to_fw = 1;
 
 	qla2x00_start_iocbs(vha, vha->req);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -2712,19 +2714,10 @@ static void qlt_send_term_exchange(struct scsi_qla_host *vha,
 	if (rc == -ENOMEM)
 		qlt_alloc_qfull_cmd(vha, atio, 0, 0);
 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+
 done:
-	/*
-	 * Terminate exchange will tell fw to release any active CTIO
-	 * that's in FW posession and cleanup the exchange.
-	 *
-	 * "cmd->state == QLA_TGT_STATE_ABORTED" means CTIO is still
-	 * down at FW.  Free the cmd later when CTIO comes back later
-	 * w/aborted(0x2) status.
-	 *
-	 * "cmd->state != QLA_TGT_STATE_ABORTED" means CTIO is already
-	 * back w/some err.  Free the cmd now.
-	 */
-	if ((rc == 1) && (cmd->state != QLA_TGT_STATE_ABORTED)) {
+	if (cmd && ((cmd->state != QLA_TGT_STATE_ABORTED) ||
+	    !cmd->cmd_sent_to_fw)) {
 		if (!ha_locked && !in_interrupt())
 			msleep(250); /* just in case */
 
@@ -3066,6 +3059,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 
 	se_cmd = &cmd->se_cmd;
 	tfo = se_cmd->se_tfo;
+	cmd->cmd_sent_to_fw = 0;
 
 	if (cmd->sg_mapped)
 		qlt_unmap_sg(vha, cmd);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 0c768f5..b07b230 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -917,6 +917,7 @@ struct qla_tgt_cmd {
 	unsigned int ctx_dsd_alloced:1;
 	unsigned int q_full:1;
 	unsigned int term_exchg:1;
+	unsigned int cmd_sent_to_fw:1;
 
 	struct scatterlist *sg;	/* cmd data buffer SG vector */
 	int sg_cnt;		/* SG segments count */
-- 
1.7.7
