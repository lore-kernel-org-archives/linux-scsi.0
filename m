From: Jeremy Linton <jlinton@tributary.com>
Subject: [RESEND][PATCH] lpfc should check return status for task mgmt IOCBs
  (now with correct code formatting)
Date: Mon, 4 Mar 2013 12:20:32 -0600
Message-ID: <5134E5F0.3070905@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:46676 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3CDSUk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Mar 2013 13:20:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, Linux Scsi <linux-scsi@vger.kernel.org>

I realized after I sent the last patch, that it was the wrong file (incorrectly
formatted) and missing the signature. That has been corrected in this version.

Other than that, the two patches are functionally identical.

This patch adds code to the lpfc driver to check the return status from the
firmware/wire for task mgmt commands. As the firmware tends to also return
IOSTAT_FCP_RSP_ERROR, indicating an attached FCP_RSP info field, there is a new
function to parse the FCP RSP info field. If the info field indicates the given
task mgmt function succeeded, then the error status is cleared and the command
is marked as completing successfully.

The lun and target reset callbacks have been slightly tweaked to run the flush
io context routines only if the reset is successful. The return code from the
reset routines now correctly indicates whether the reset was successful allowing
the mid layer to escalate the error handling. I considered simply returning
SUCCESS from the target reset callback, as that approximates the behavior before
this patch. That stops the bus/host reset from being called while allowing lun
reset to become a target reset if necessary.

As part of this patch a couple general code errors were also corrected. The
ulpFCP2Rcvy bit is now set/cleared for task management routines in the same way
as SCSI commands, some code which could never execute has been removed from
lpfc_sli_issue_iocb_wait(), and the out of resources error in lpfc_prep_seq is
now tagged as a IOSTAT_LOCAL_REJECT as there isn't a FCP RSP associated with the
error.



Signed-off-by: Jeremy Linton <jlinton@tributary.com>


diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 60e5a17..b940f04 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4080,7 +4080,9 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 	}
 	if (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
 		piocb->ulpFCP2Rcvy = 1;
-	}
+	} else
+		piocb->ulpFCP2Rcvy = 0;
+
 	piocb->ulpClass = (ndlp->nlp_fcp_info & 0x0f);

 	/* ulpTimeout is only one byte */
@@ -4569,6 +4571,73 @@ lpfc_taskmgmt_name(uint8_t task_mgmt_cmd)
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
+
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
+				 "0702X fcp_rsp is missing\n");
+	else {
+		rsp_info = fcprsp->rspStatus2;
+		rsp_len = be32_to_cpu(fcprsp->rspRspLen);
+		rsp_info_code = fcprsp->rspInfo3;
+
+
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_FCP,
+				 "0702XX fcp_rsp valid 0x%x,"
+				 " rsp len=%d code 0x%x\n",
+				 rsp_info,
+				 rsp_len, rsp_info_code);
+
+		if ((fcprsp->rspStatus2&RSP_LEN_VALID) && (rsp_len == 8)) {
+			switch (rsp_info_code) {
+			case RSP_NO_FAILURE:
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+						 "0702XX Task Mgmt actually OK,"
+						 " cancel error\n");
+				ret = SUCCESS;
+				break;
+			case RSP_TM_NOT_SUPPORTED: /* TM rejected */
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+						 "0702XX Target rejected task "
+						 "management\n");
+				break;
+			case RSP_TM_NOT_COMPLETED: /* TM failed */
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+						 "0702XX Target failed TM\n");
+				break;
+			case RSP_TM_INVALID_LU: /* TM to invalid LU! */
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+						 "0702XX Task Mgmt "
+						 "to invalid LUN\n");
+				break;
+			}
+		}
+	}
+	return ret;
+}
+
 /**
  * lpfc_send_taskmgmt - Generic SCSI Task Mgmt Handler
  * @vport: The virtual port for which this call is being executed.
@@ -4630,12 +4701,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct
lpfc_rport_data *rdata,
 	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if (status != IOCB_SUCCESS) {
-		if (status == IOCB_TIMEDOUT) {
-			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
-			ret = TIMEOUT_ERROR;
-		} else
-			ret = FAILED;
-		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
+
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "0727 TMF %s to TGT %d LUN %d failed (%d, %d) "
 			 "iocb_flag x%x\n",
@@ -4643,9 +4709,24 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct
lpfc_rport_data *rdata,
 			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
 			 iocbqrsp->iocb.un.ulpWord[4],
 			 iocbq->iocb_flag);
-	} else if (status == IOCB_BUSY)
-		ret = FAILED;
-	else
+
+		if (status == IOCB_TIMEDOUT) {
+			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
+			ret = TIMEOUT_ERROR;
+		} else	{
+			if (iocbqrsp->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR) {
+				/* the firmware says that we need to
+				 * check the FCP_RSP ourselves */
+				ret = lpfc_check_fcp_rsp(vport, lpfc_cmd);
+			} else	{
+				/* other common returns are IOSTAT_LOCAL_REJECT
+				 * IOERR_SEQUENCE_TIMEOUT, indicating the
+				 * device is not responding */
+				ret = FAILED;
+			}
+		}
+
+	} else
 		ret = SUCCESS;

 	lpfc_sli_release_iocbq(phba, iocbqrsp);
@@ -4797,12 +4878,12 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);

-	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
-						FCP_LUN_RESET);
+	ret = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+				 FCP_LUN_RESET);

 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "0713 SCSI layer issued Device Reset (%d, %d) "
-			 "return x%x\n", tgt_id, lun_id, status);
+			 "return x%x\n", tgt_id, lun_id, ret);

 	/*
 	 * We have to clean up i/o as : they may be orphaned by the TMF;
@@ -4810,8 +4891,10 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	 * So, continue on.
 	 * We will report success if all the i/o aborts successfully.
 	 */
-	ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
-						LPFC_CTX_LUN);
+	if (ret == SUCCESS)
+		ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						  LPFC_CTX_LUN);
+
 	return ret;
 }

@@ -4864,12 +4947,12 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);

-	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+	ret = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
 					FCP_TARGET_RESET);

 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "0723 SCSI layer issued Target Reset (%d, %d) "
-			 "return x%x\n", tgt_id, lun_id, status);
+			 "return x%x\n", tgt_id, lun_id, ret);

 	/*
 	 * We have to clean up i/o as : they may be orphaned by the TMF;
@@ -4877,8 +4960,9 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	 * So, continue on.
 	 * We will report success if all the i/o aborts successfully.
 	 */
-	ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
-					  LPFC_CTX_TGT);
+	if (ret == SUCCESS)
+		ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						  LPFC_CTX_TGT);
 	return ret;
 }

diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 21a2ffe..dd199c9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -73,6 +73,7 @@ struct fcp_rsp {
 #define RSP_RO_MISMATCH_ERR  0x03
 #define RSP_TM_NOT_SUPPORTED 0x04	/* Task mgmt function not supported */
 #define RSP_TM_NOT_COMPLETED 0x05	/* Task mgmt function not performed */
+#define RSP_TM_INVALID_LU    0x09	/* Task mgmt function to invalid LU */

 	uint32_t rspInfoRsvd;	/* FCP_RSP_INFO bytes 4-7 (reserved) */

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 624eab3..7bdedb3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9960,6 +9960,9 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 		if (piocb->iocb_flag & LPFC_IO_WAKE) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"0331 IOCB wake signaled\n");
+			if ((prspiocbq) && (prspiocbq->iocb.ulpStatus))	{
+				retval = IOCB_ERROR;
+			}
 		} else if (timeleft == 0) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"0338 IOCB wait timeout error - no "
@@ -14415,7 +14418,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct
hbq_dmabuf *seq_dmabuf)
 			if (!iocbq) {
 				if (first_iocbq) {
 					first_iocbq->iocb.ulpStatus =
-							IOSTAT_FCP_RSP_ERROR;
+							IOSTAT_LOCAL_REJECT;
 					first_iocbq->iocb.un.ulpWord[4] =
 							IOERR_NO_RESOURCES;
 				}


