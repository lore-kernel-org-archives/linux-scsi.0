From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2] qla2xxx: Protect access to qpair members with qpair->qp_lock
Date: Fri, 23 Jun 2017 09:10:11 +0200
Message-ID: <20170623071011.21184-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, qla2xxx-upstream@qlogic.com, Himanshu Madhani <himanshu.madhani@cavium.com>, Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

In qla2xx_start_scsi_mq() and qla2xx_dif_start_scsi_mq() we grab the
qpair->qp_lock but do access members of the qpair before having the lock.
Re-order the locking sequence to have all read and write access to qpair
members under the qpair->qp_lock.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

Changes to v1:
* Use __qla2x00_marker() instead of qla2x00_marker which is fit to be called
  with the qp_lock held (John)
* Don't protect qpair->online and qpair->difdix_supported as it's not
  needed (Hannes)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8404f17f3c6c..c64036ddd365 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1770,6 +1770,9 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair = sp->qpair;
 
+	/* Acquire qpair specific lock */
+	spin_lock_irqsave(&qpair->qp_lock, flags);
+
 	/* Setup qpair pointers */
 	rsp = qpair->rsp;
 	req = qpair->req;
@@ -1779,15 +1782,14 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 
 	/* Send marker if required */
 	if (vha->marker_needed != 0) {
-		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
-		    QLA_SUCCESS)
+		if (__qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
+		    QLA_SUCCESS) {
+			spin_unlock_irqrestore(&qpair->qp_lock, flags);
 			return QLA_FUNCTION_FAILED;
+		}
 		vha->marker_needed = 0;
 	}
 
-	/* Acquire qpair specific lock */
-	spin_lock_irqsave(&qpair->qp_lock, flags);
-
 	/* Check for room in outstanding command list. */
 	handle = req->current_outstanding_cmd;
 	for (index = 1; index < req->num_outstanding_cmds; index++) {
@@ -1942,6 +1944,8 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 			return qla2xxx_start_scsi_mq(sp);
 	}
 
+	spin_lock_irqsave(&qpair->qp_lock, flags);
+
 	/* Setup qpair pointers */
 	rsp = qpair->rsp;
 	req = qpair->req;
@@ -1951,15 +1955,14 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 	/* Send marker if required */
 	if (vha->marker_needed != 0) {
-		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
-		    QLA_SUCCESS)
+		if (__qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
+		    QLA_SUCCESS) {
+			spin_unlock_irqrestore(&qpair->qp_lock, flags);
 			return QLA_FUNCTION_FAILED;
+		}
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
