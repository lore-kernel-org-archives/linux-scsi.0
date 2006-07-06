From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/15] lpfc 8.1.7 : Consolidate dma buf cleanup into a
	separate function
Date: Thu, 06 Jul 2006 15:50:08 -0400
Message-ID: <1152215408.23158.25.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:23948 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750778AbWGFTt4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:49:56 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JnskR006949
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Consolidate dma buf cleanup into a separate function

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2006-07-06 14:36:09.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2006-07-06 14:54:04.000000000 -0400
@@ -153,22 +153,6 @@ static void
 lpfc_release_scsi_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
 {
 	unsigned long iflag = 0;
-	/*
-	 * There are only two special cases to consider.  (1) the scsi command
-	 * requested scatter-gather usage or (2) the scsi command allocated
-	 * a request buffer, but did not request use_sg.  There is a third
-	 * case, but it does not require resource deallocation.
-	 */
-	if ((psb->seg_cnt > 0) && (psb->pCmd->use_sg)) {
-		dma_unmap_sg(&phba->pcidev->dev, psb->pCmd->request_buffer,
-				psb->seg_cnt, psb->pCmd->sc_data_direction);
-	} else {
-		 if ((psb->nonsg_phys) && (psb->pCmd->request_bufflen)) {
-			dma_unmap_single(&phba->pcidev->dev, psb->nonsg_phys,
-						psb->pCmd->request_bufflen,
-						psb->pCmd->sc_data_direction);
-		 }
-	}
 
 	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
 	psb->pCmd = NULL;
@@ -282,6 +266,27 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 }
 
 static void
+lpfc_scsi_unprep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
+{
+	/*
+	 * There are only two special cases to consider.  (1) the scsi command
+	 * requested scatter-gather usage or (2) the scsi command allocated
+	 * a request buffer, but did not request use_sg.  There is a third
+	 * case, but it does not require resource deallocation.
+	 */
+	if ((psb->seg_cnt > 0) && (psb->pCmd->use_sg)) {
+		dma_unmap_sg(&phba->pcidev->dev, psb->pCmd->request_buffer,
+				psb->seg_cnt, psb->pCmd->sc_data_direction);
+	} else {
+		 if ((psb->nonsg_phys) && (psb->pCmd->request_bufflen)) {
+			dma_unmap_single(&phba->pcidev->dev, psb->nonsg_phys,
+						psb->pCmd->request_bufflen,
+						psb->pCmd->sc_data_direction);
+		 }
+	}
+}
+
+static void
 lpfc_handle_fcp_err(struct lpfc_scsi_buf *lpfc_cmd)
 {
 	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
@@ -454,6 +459,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+		lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return;
 	}
@@ -511,6 +517,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		}
 	}
 
+	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
 
@@ -822,6 +829,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	return 0;
 
  out_host_busy_free_buf:
+	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
  out_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;


