From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/6] lpfc 8.3.17: SCSI fixes
Date: Wed, 29 Sep 2010 11:19:08 -0400
Message-ID: <1285773548.25110.12.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16094 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752661Ab0I2PTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 11:19:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Fail I/Os with incomplete data that complete with SCSI Check condition.
- Complete aborted I/Os with host_scribble equal to NULL with success.
- Initialize context1 field of iocbq in the new_scsi_buf routines.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-09-08 12:08:03.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-09-29 10:20:25.000000000 -0400
@@ -599,6 +599,7 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *
 		iocb->ulpClass = CLASS3;
 		psb->status = IOSTAT_SUCCESS;
 		/* Put it back into the SCSI buffer list */
+		psb->cur_iocbq.context1  = psb;
 		lpfc_release_scsi_buf_s3(phba, psb);
 
 	}
@@ -849,6 +850,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 		iocb->ulpBdeCount = 1;
 		iocb->ulpLe = 1;
 		iocb->ulpClass = CLASS3;
+		psb->cur_iocbq.context1  = psb;
 		if (phba->cfg_sg_dma_buf_size > SGL_PAGE_SIZE)
 			pdma_phys_bpl1 = pdma_phys_bpl + SGL_PAGE_SIZE;
 		else
@@ -2276,15 +2278,24 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 	 * Check SLI validation that all the transfer was actually done
 	 * (fcpi_parm should be zero). Apply check only to reads.
 	 */
-	} else if ((scsi_status == SAM_STAT_GOOD) && fcpi_parm &&
-			(cmnd->sc_data_direction == DMA_FROM_DEVICE)) {
+	} else if (fcpi_parm && (cmnd->sc_data_direction == DMA_FROM_DEVICE)) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
 				 "9029 FCP Read Check Error Data: "
-				 "x%x x%x x%x x%x\n",
+				 "x%x x%x x%x x%x x%x\n",
 				 be32_to_cpu(fcpcmd->fcpDl),
 				 be32_to_cpu(fcprsp->rspResId),
-				 fcpi_parm, cmnd->cmnd[0]);
-		host_status = DID_ERROR;
+				 fcpi_parm, cmnd->cmnd[0], scsi_status);
+		switch (scsi_status) {
+		case SAM_STAT_GOOD:
+		case SAM_STAT_CHECK_CONDITION:
+			/* Fabric dropped a data frame. Fail any successful
+			 * command in which we detected dropped frames.
+			 * A status of good or some check conditions could
+			 * be considered a successful command.
+			 */
+			host_status = DID_ERROR;
+			break;
+		}
 		scsi_set_resid(cmnd, scsi_bufflen(cmnd));
 	}
 
@@ -3072,7 +3083,14 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	if (ret)
 		return ret;
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
-	BUG_ON(!lpfc_cmd);
+	if (!lpfc_cmd) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
+			 "x%x ID %d "
+			 "LUN %d snum %#lx\n", ret, cmnd->device->id,
+			 cmnd->device->lun, cmnd->serial_number);
+		return SUCCESS;
+	}
 
 	/*
 	 * If pCmd field of the corresponding lpfc_scsi_buf structure


