From: James Smart <james.smart@emulex.com>
Subject: [PATCH 06/10] lpfc 8.3.32: Correct successful aborts returning
 error status
Date: Tue, 12 Jun 2012 13:54:42 -0400
Message-ID: <1339523683.2162.6.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17659 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753441Ab2FLRy7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:54:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix successful aborts returning incorrect status.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-08 11:55:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-08 11:55:46.000000000 -0400
@@ -4412,12 +4412,12 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	struct lpfc_iocbq *abtsiocb;
 	struct lpfc_scsi_buf *lpfc_cmd;
 	IOCB_t *cmd, *icmd;
-	int ret = SUCCESS;
+	int ret = SUCCESS, status = 0;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
-	ret = fc_block_scsi_eh(cmnd);
-	if (ret)
-		return ret;
+	status = fc_block_scsi_eh(cmnd);
+	if (status)
+		return status;
 
 	spin_lock_irq(&phba->hbalock);
 	/* driver queued commands are in process of being flushed */
@@ -4435,7 +4435,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
 			 "x%x ID %d LUN %d\n",
-			 ret, cmnd->device->id, cmnd->device->lun);
+			 SUCCESS, cmnd->device->id, cmnd->device->lun);
 		return SUCCESS;
 	}
 
@@ -4762,7 +4762,7 @@ lpfc_device_reset_handler(struct scsi_cm
 	unsigned tgt_id = cmnd->device->id;
 	unsigned int lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
-	int status;
+	int status, ret = SUCCESS;
 
 	if (!rdata) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -4803,9 +4803,9 @@ lpfc_device_reset_handler(struct scsi_cm
 	 * So, continue on.
 	 * We will report success if all the i/o aborts successfully.
 	 */
-	status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+	ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
 						LPFC_CTX_LUN);
-	return status;
+	return ret;
 }
 
 /**
@@ -4829,7 +4829,7 @@ lpfc_target_reset_handler(struct scsi_cm
 	unsigned tgt_id = cmnd->device->id;
 	unsigned int lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
-	int status;
+	int status, ret = SUCCESS;
 
 	if (!rdata) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -4870,9 +4870,9 @@ lpfc_target_reset_handler(struct scsi_cm
 	 * So, continue on.
 	 * We will report success if all the i/o aborts successfully.
 	 */
-	status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
-					LPFC_CTX_TGT);
-	return status;
+	ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+					  LPFC_CTX_TGT);
+	return ret;
 }
 
 /**



