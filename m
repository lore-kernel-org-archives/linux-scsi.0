From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] qla2xxx: Protect access to qpair members with qpair->qp_lock
Date: Thu, 22 Jun 2017 15:43:25 +0200
Message-ID: <20170622134325.26931-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, qla2xxx-upstream@qlogic.com, Himanshu Madhani <himanshu.madhani@cavium.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

In qla2xx_start_scsi_mq() and qla2xx_dif_start_scsi_mq() we grab the
qpair->qp_lock but do access members of the qpair before having the lock.
Re-order the locking sequence to have all read and write access to qpair
members under the qpair->qp_lock.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8404f17f3c6c..425ca1646a9a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1770,10 +1770,6 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair = sp->qpair;
 
-	/* Setup qpair pointers */
-	rsp = qpair->rsp;
-	req = qpair->req;
-
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
 
@@ -1788,6 +1784,10 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	/* Acquire qpair specific lock */
 	spin_lock_irqsave(&qpair->qp_lock, flags);
 
+	/* Setup qpair pointers */
+	rsp = qpair->rsp;
+	req = qpair->req;
+
 	/* Check for room in outstanding command list. */
 	handle = req->current_outstanding_cmd;
 	for (index = 1; index < req->num_outstanding_cmds; index++) {
@@ -1924,24 +1924,33 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 #define QDSS_GOT_Q_SPACE	BIT_0
 
+	/* Acquire ring specific lock */
+	spin_lock_irqsave(&qpair->qp_lock, flags);
+
 	/* Check for host side state */
 	if (!qpair->online) {
 		cmd->result = DID_NO_CONNECT << 16;
+		spin_unlock_irqrestore(&qpair->qp_lock, flags);
 		return QLA_INTERFACE_ERROR;
 	}
 
 	if (!qpair->difdix_supported &&
 		scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
 		cmd->result = DID_NO_CONNECT << 16;
+		spin_unlock_irqrestore(&qpair->qp_lock, flags);
 		return QLA_INTERFACE_ERROR;
 	}
 
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+
 	/* Only process protection or >16 cdb in this routine */
 	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL) {
 		if (cmd->cmd_len <= 16)
 			return qla2xxx_start_scsi_mq(sp);
 	}
 
+	spin_lock_irqsave(&qpair->qp_lock, flags);
+
 	/* Setup qpair pointers */
 	rsp = qpair->rsp;
 	req = qpair->req;
@@ -1957,9 +1966,6 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 		vha->marker_needed = 0;
 	}
 
-	/* Acquire ring specific lock */
-	spin_lock_irqsave(&qpair->qp_lock, flags);
-
 	/* Check for room in outstanding command list. */
 	handle = req->current_outstanding_cmd;
 	for (index = 1; index < req->num_outstanding_cmds; index++) {
-- 
2.12.3
