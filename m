From: James.Smart@Emulex.Com
Subject: [PATCH 5/11]  lpfc 8.1.1 : Remove locking wrappers around error handlers
Date: Mon, 28 Nov 2005 11:41:53 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C49@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38133 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751290AbVK1Qlz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:41:55 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGfss3014127
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:41:54 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Remove locking wrappers around error handlers. Wrappers were added in
early 2.6.13 api change


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-28 09:44:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-28 10:26:47.000000000 -0500
@@ -760,11 +760,12 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	return 0;
 }
 
+
 static int
-__lpfc_abort_handler(struct scsi_cmnd *cmnd)
+lpfc_abort_handler(struct scsi_cmnd *cmnd)
 {
-	struct lpfc_hba *phba =
-			(struct lpfc_hba *)cmnd->device->host->hostdata[0];
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
 	struct lpfc_sli_ring *pring = &phba->sli.ring[phba->sli.fcp_ring];
 	struct lpfc_iocbq *iocb;
 	struct lpfc_iocbq *abtsiocb;
@@ -773,6 +774,7 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 	unsigned int loop_count = 0;
 	int ret = SUCCESS;
 
+	spin_lock_irq(shost->host_lock);
 
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
 	BUG_ON(!lpfc_cmd);
@@ -850,21 +852,13 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 			phba->brd_no, ret, cmnd->device->id,
 			cmnd->device->lun, cmnd->serial_number);
 
-	return ret;
-}
+	spin_unlock_irq(shost->host_lock);
 
-static int
-lpfc_abort_handler(struct scsi_cmnd *cmnd)
-{
-	int rc;
-	spin_lock_irq(cmnd->device->host->host_lock);
-	rc = __lpfc_abort_handler(cmnd);
-	spin_unlock_irq(cmnd->device->host->host_lock);
-	return rc;
+	return ret;
 }
 
 static int
-__lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
+lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
@@ -875,6 +869,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 	int ret = FAILED;
 	int cnt, loopcnt;
 
+	spin_lock_irq(shost->host_lock);
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
 	 * target is rediscovered or nodev timeout expires.
@@ -964,24 +959,12 @@ out_free_scsi_buf:
 			lpfc_cmd->result);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 out:
+	spin_unlock_irq(shost->host_lock);
 	return ret;
 }
 
 static int
-lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
-{
-	int rc;
-	spin_lock_irq(cmnd->device->host->host_lock);
-	rc = __lpfc_reset_lun_handler(cmnd);
-	spin_unlock_irq(cmnd->device->host->host_lock);
-	return rc;
-}
-
-/*
- * Note: midlayer calls this function with the host_lock held
- */
-static int
-__lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
+lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
@@ -992,6 +975,8 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 	unsigned int midlayer_id = 0;
 	struct lpfc_scsi_buf * lpfc_cmd;
 
+	spin_lock_irq(shost->host_lock);
+
 	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
 	if (lpfc_cmd == NULL)
 		goto out;
@@ -1067,20 +1052,11 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 			"%d:0714 SCSI layer issued Bus Reset Data: x%x\n",
 			phba->brd_no, ret);
 out:
+	spin_unlock_irq(shost->host_lock);
 	return ret;
 }
 
 static int
-lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
-{
-	int rc;
-	spin_lock_irq(cmnd->device->host->host_lock);
-	rc = __lpfc_reset_bus_handler(cmnd);
-	spin_unlock_irq(cmnd->device->host->host_lock);
-	return rc;
-}
-
-static int
 lpfc_slave_alloc(struct scsi_device *sdev)
 {
 	struct lpfc_hba *phba = (struct lpfc_hba *)sdev->host->hostdata[0];
