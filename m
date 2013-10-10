From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/8] lpfc 8.3.43: Fixed not processing task management IOCB
 response status
Date: Thu, 10 Oct 2013 12:24:07 -0400
Message-ID: <1381422247.20248.26.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5464 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3JJQYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:24:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jlinton@tributary.com

Fixed not processing task management IOCB response status

This patch implements the changes requested by Jeremy Linton:
http://marc.info/?l=linux-scsi&m=136242124409687&w=2

The patch revises the command issuing behavior, detecting cases where the
Task Mgmt command may have completed but with a non-successful status, which it
previously treated as a successful TMF. The patch also corrects a flushing of
I/O that was done which should only be done on successful TMF completion.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c  |    7 ++-
 lpfc_scsi.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
 lpfc_scsi.h |    1 
 lpfc_sli.c  |    5 ++
 4 files changed, 104 insertions(+), 21 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2013-10-09 10:39:20.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2013-10-09 17:25:40.036650788 -0400
@@ -2629,7 +2629,7 @@ static int lpfcdiag_loop_get_xri(struct
 				rspiocbq,
 				(phba->fc_ratov * 2)
 				+ LPFC_DRVR_TIMEOUT);
-	if (iocb_stat) {
+	if ((iocb_stat != IOCB_SUCCESS) || (rsp->ulpStatus != IOSTAT_SUCCESS)) {
 		ret_val = -EIO;
 		goto err_get_xri_exit;
 	}
@@ -3204,8 +3204,9 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg
 					     rspiocbq, (phba->fc_ratov * 2) +
 					     LPFC_DRVR_TIMEOUT);
 
-	if ((iocb_stat != IOCB_SUCCESS) || ((phba->sli_rev < LPFC_SLI_REV4) &&
-					   (rsp->ulpStatus != IOCB_SUCCESS))) {
+	if ((iocb_stat != IOCB_SUCCESS) ||
+	    ((phba->sli_rev < LPFC_SLI_REV4) &&
+	     (rsp->ulpStatus != IOSTAT_SUCCESS))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
 				"3126 Failed loopback test issue iocb: "
 				"iocb_stat:x%x\n", iocb_stat);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-10-09 17:25:23.297650407 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-10-09 17:25:40.049650788 -0400
@@ -4490,9 +4490,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		piocb->ulpContext =
 		  vport->phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
 	}
-	if (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
-		piocb->ulpFCP2Rcvy = 1;
-	}
+	piocb->ulpFCP2Rcvy = (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) ? 1 : 0;
 	piocb->ulpClass = (ndlp->nlp_fcp_info & 0x0f);
 
 	/* ulpTimeout is only one byte */
@@ -4986,6 +4984,73 @@ lpfc_taskmgmt_name(uint8_t task_mgmt_cmd
 	}
 }
 
+
+/**
+ * lpfc_check_fcp_rsp - check the returned fcp_rsp to see if task failed
+ * @vport: The virtual port for which this call is being executed.
+ * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
+ *
+ * This routine checks the FCP RSP INFO to see if the tsk mgmt command succeded
+ *
+ * Return code :
+ *   0x2003 - Error
+ *   0x2002 - Success
+ **/
+static int
+lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd)
+{
+	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
+	uint32_t rsp_info;
+	uint32_t rsp_len;
+	uint8_t  rsp_info_code;
+	int ret = FAILED;
+
+
+	if (fcprsp == NULL)
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+				 "0703 fcp_rsp is missing\n");
+	else {
+		rsp_info = fcprsp->rspStatus2;
+		rsp_len = be32_to_cpu(fcprsp->rspRspLen);
+		rsp_info_code = fcprsp->rspInfo3;
+
+
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_FCP,
+				 "0706 fcp_rsp valid 0x%x,"
+				 " rsp len=%d code 0x%x\n",
+				 rsp_info,
+				 rsp_len, rsp_info_code);
+
+		if ((fcprsp->rspStatus2&RSP_LEN_VALID) && (rsp_len == 8)) {
+			switch (rsp_info_code) {
+			case RSP_NO_FAILURE:
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+						 "0715 Task Mgmt No Failure\n");
+				ret = SUCCESS;
+				break;
+			case RSP_TM_NOT_SUPPORTED: /* TM rejected */
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+						 "0716 Task Mgmt Target "
+						"reject\n");
+				break;
+			case RSP_TM_NOT_COMPLETED: /* TM failed */
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+						 "0717 Task Mgmt Target "
+						"failed TM\n");
+				break;
+			case RSP_TM_INVALID_LU: /* TM to invalid LU! */
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+						 "0718 Task Mgmt to invalid "
+						"LUN\n");
+				break;
+			}
+		}
+	}
+	return ret;
+}
+
+
 /**
  * lpfc_send_taskmgmt - Generic SCSI Task Mgmt Handler
  * @vport: The virtual port for which this call is being executed.
@@ -5047,12 +5112,8 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 
 	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
-	if (status != IOCB_SUCCESS) {
-		if (status == IOCB_TIMEDOUT) {
-			ret = TIMEOUT_ERROR;
-		} else
-			ret = FAILED;
-		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
+	if ((status != IOCB_SUCCESS) ||
+	    (iocbqrsp->iocb.ulpStatus != IOSTAT_SUCCESS)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "0727 TMF %s to TGT %d LUN %d failed (%d, %d) "
 			 "iocb_flag x%x\n",
@@ -5060,9 +5121,21 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
 			 iocbqrsp->iocb.un.ulpWord[4],
 			 iocbq->iocb_flag);
-	} else if (status == IOCB_BUSY)
-		ret = FAILED;
-	else
+		/* if ulpStatus != IOCB_SUCCESS, then status == IOCB_SUCCESS */
+		if (status == IOCB_SUCCESS) {
+			if (iocbqrsp->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
+				/* Something in the FCP_RSP was invalid.
+				 * Check conditions */
+				ret = lpfc_check_fcp_rsp(vport, lpfc_cmd);
+			else
+				ret = FAILED;
+		} else if (status == IOCB_TIMEDOUT) {
+			ret = TIMEOUT_ERROR;
+		} else {
+			ret = FAILED;
+		}
+		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
+	} else
 		ret = SUCCESS;
 
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
@@ -5186,7 +5259,7 @@ lpfc_device_reset_handler(struct scsi_cm
 	unsigned tgt_id = cmnd->device->id;
 	unsigned int lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
-	int status, ret = SUCCESS;
+	int status;
 
 	if (!rdata) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5227,9 +5300,11 @@ lpfc_device_reset_handler(struct scsi_cm
 	 * So, continue on.
 	 * We will report success if all the i/o aborts successfully.
 	 */
-	ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+	if (status == SUCCESS)
+		status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
 						LPFC_CTX_LUN);
-	return ret;
+
+	return status;
 }
 
 /**
@@ -5253,7 +5328,7 @@ lpfc_target_reset_handler(struct scsi_cm
 	unsigned tgt_id = cmnd->device->id;
 	unsigned int lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
-	int status, ret = SUCCESS;
+	int status;
 
 	if (!rdata) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5294,9 +5369,10 @@ lpfc_target_reset_handler(struct scsi_cm
 	 * So, continue on.
 	 * We will report success if all the i/o aborts successfully.
 	 */
-	ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+	if (status == SUCCESS)
+		status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
 					  LPFC_CTX_TGT);
-	return ret;
+	return status;
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
--- a/drivers/scsi/lpfc/lpfc_scsi.h	2013-10-09 10:39:20.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.h	2013-10-09 17:25:40.050650788 -0400
@@ -73,6 +73,7 @@ struct fcp_rsp {
 #define RSP_RO_MISMATCH_ERR  0x03
 #define RSP_TM_NOT_SUPPORTED 0x04	/* Task mgmt function not supported */
 #define RSP_TM_NOT_COMPLETED 0x05	/* Task mgmt function not performed */
+#define RSP_TM_INVALID_LU    0x09	/* Task mgmt function to invalid LU */
 
 	uint32_t rspInfoRsvd;	/* FCP_RSP_INFO bytes 4-7 (reserved) */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:38.134650282 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:40.074650788 -0400
@@ -10196,6 +10196,11 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 		if (iocb_completed) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"0331 IOCB wake signaled\n");
+			/* Note: we are not indicating if the IOCB has a success
+			 * status or not - that's for the caller to check.
+			 * IOCB_SUCCESS means just that the command was sent and
+			 * completed. Not that it completed successfully.
+			 * */
 		} else if (timeleft == 0) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"0338 IOCB wait timeout error - no "



