From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/15] lpfc 8.1.7 : Fix panic in lpfc_sli_validate_fcp_iocb
Date: Thu, 06 Jul 2006 15:50:16 -0400
Message-ID: <1152215416.23158.26.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:25484 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750779AbWGFTuF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:50:05 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JnxU6006960
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix panic in lpfc_sli_validate_fcp_iocb due to access of scsi_cmnd after
returning it to the midlayer

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2006-07-06 14:54:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2006-07-06 14:55:19.000000000 -0400
@@ -616,6 +616,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_hba * ph
 static int
 lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_hba *phba,
 			     struct lpfc_scsi_buf *lpfc_cmd,
+			     unsigned int lun,
 			     uint8_t task_mgmt_cmd)
 {
 	struct lpfc_sli *psli;
@@ -634,8 +635,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	piocb = &piocbq->iocb;
 
 	fcp_cmnd = lpfc_cmd->fcp_cmnd;
-	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
-			&lpfc_cmd->fcp_cmnd->fcp_lun);
+	int_to_scsilun(lun, &lpfc_cmd->fcp_cmnd->fcp_lun);
 	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
 
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
@@ -662,14 +662,16 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 
 static int
 lpfc_scsi_tgt_reset(struct lpfc_scsi_buf * lpfc_cmd, struct lpfc_hba * phba,
-		    unsigned  tgt_id, struct lpfc_rport_data *rdata)
+		    unsigned  tgt_id, unsigned int lun,
+		    struct lpfc_rport_data *rdata)
 {
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *iocbqrsp;
 	int ret;
 
 	lpfc_cmd->rdata = rdata;
-	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, FCP_TARGET_RESET);
+	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, lun,
+					   FCP_TARGET_RESET);
 	if (!ret)
 		return FAILED;
 
@@ -977,12 +979,12 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	if (lpfc_cmd == NULL)
 		goto out;
 
-	lpfc_cmd->pCmd = cmnd;
 	lpfc_cmd->timeout = 60;
 	lpfc_cmd->scsi_hba = phba;
 	lpfc_cmd->rdata = rdata;
 
-	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, FCP_LUN_RESET);
+	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, cmnd->device->lun,
+					   FCP_LUN_RESET);
 	if (!ret)
 		goto out_free_scsi_buf;
 
@@ -1009,7 +1011,6 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	cmd_status = iocbqrsp->iocb.ulpStatus;
 
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
-	lpfc_release_scsi_buf(phba, lpfc_cmd);
 
 	/*
 	 * All outstanding txcmplq I/Os should have been aborted by the device.
@@ -1048,6 +1049,8 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	}
 
 out_free_scsi_buf:
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
+
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 			"%d:0713 SCSI layer issued LUN reset (%d, %d) "
 			"Data: x%x x%x x%x\n",
@@ -1078,7 +1081,6 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 
 	/* The lpfc_cmd storage is reused.  Set all loop invariants. */
 	lpfc_cmd->timeout = 60;
-	lpfc_cmd->pCmd = cmnd;
 	lpfc_cmd->scsi_hba = phba;
 
 	/*
@@ -1098,8 +1100,8 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 		if (!match)
 			continue;
 
-		ret = lpfc_scsi_tgt_reset(lpfc_cmd, phba,
-					  i, ndlp->rport->dd_data);
+		ret = lpfc_scsi_tgt_reset(lpfc_cmd, phba, i, cmnd->device->lun,
+					  ndlp->rport->dd_data);
 		if (ret != SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 				"%d:0713 Bus Reset on target %d failed\n",


