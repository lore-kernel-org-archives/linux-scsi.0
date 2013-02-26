From: Jeremy Linton <jlinton@tributary.com>
Subject: [PATCH][BUG] lpfc doesn't handle failures in lpfc_send_taskmgmt()
Date: Tue, 26 Feb 2013 17:12:33 -0600
Message-ID: <512D4161.30401@tributary.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------060305040208040608070906"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:54752 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3BZXMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Feb 2013 18:12:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>

--------------060305040208040608070906
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

The lpfc_send_taskmgmt() routine fails to check the return IOCB from the
firmware. This means that all taskmgmt functions appear to complete even when
they are failing due to device failures, or task mgmt errors.

This patch corrects this by checking the iocb.ulpStatus after the command has
completed. Of course even when the command completes successfully the firmware
sets IOSTAT_FCP_RSP_ERROR. This indicates that the driver needs to verify the
return code in the FCP RSP. So a new routine lpfc_check_fcp_rsp() has been added
which verifies the RSP has a info field, and that the info field indicates success.

I've also added in a check to see if the task mgmt function succeeds in the
reset handlers before running lpfc_reset_flush_io_context(). In a way this is
bad because now its possible to actually fall through the mid layer error
handlers into the bus and host reset logic. This behavior itself changed not to
long ago when the io_context calls were added. The lpfc driver would never get
past device_reset_handler() because it would _ALWAYS_ return success even if the
io_context failed to abort properly because the firmware would handshake the
flushes. This leads to another set of bugs when there are actually commands hung
against the device. I have a partial set of patches to fix that problem too..


Trace with successful LU reset.


[16785.323122] lpfc 0000:10:00.1: 3:(0):0702 Issue FCP_LUN_RESET to TGT 5 LUN
510 rpi xa nlp_flag x80000000 Data: x0 x4
[16785.323329] lpfc 0000:10:00.1: 3:0336 Rsp Ring 0 error: IOCB Data: xff000020
x60 x0 x0 xfe x0 x28208ce x3ca29d12
[16785.323349] lpfc 0000:10:00.1: 3:0331 IOCB wake signaled
[16785.323356] lpfc 0000:10:00.1: 3:(0):0727 TMF FCP_LUN_RESET to TGT 5 LUN 510
failed (1, 254) iocb_flag x6
[16785.323359] lpfc 0000:10:00.1: 3:(0):0702XX fcp_rsp valid 0x1, rsp len=8 code 0x0
[16785.323362] lpfc 0000:10:00.1: 3:(0):0702XX Task Mgmt actually OK, cancel error
[16785.323366] lpfc 0000:10:00.1: 3:(0):0713 SCSI layer issued Device Reset (5,
510) return x2002
[16785.323562] scsi_reset_provider: waking up host to restart after TMF



trace with LS reject Target reset.


[16870.975793] lpfc 0000:10:00.1: 3:(0):0702 Issue FCP_TARGET_RESET to TGT 5 LUN
510 rpi xa nlp_flag x80000000 Data: x0 x4
[16870.976043] lpfc 0000:10:00.1: 3:0336 Rsp Ring 0 error: IOCB Data: xff000020
x60 x0 x0 xfe x0 x28408d1 x3ca29d12
[16870.976061] lpfc 0000:10:00.1: 3:0331 IOCB wake signaled
[16870.976067] lpfc 0000:10:00.1: 3:(0):0727 TMF FCP_TARGET_RESET to TGT 5 LUN
510 failed (1, 254) iocb_flag x6
[16870.976071] lpfc 0000:10:00.1: 3:(0):0702XX fcp_rsp valid 0x1, rsp len=8 code 0x4
[16870.976074] lpfc 0000:10:00.1: 3:(0):0702XX Target rejected task management
[16870.976078] lpfc 0000:10:00.1: 3:(0):0723 SCSI layer issued Target Reset (5,
510) return x2003


trace with bad device failing to respond to target reset.


[17383.880074] lpfc 0000:10:00.1: 3:(0):0702 Issue FCP_TARGET_RESET to TGT 5 LUN
510 rpi xa nlp_flag x80000000 Data: x0 x6
[17443.116283] lpfc 0000:10:00.1: 3:0336 Rsp Ring 0 error: IOCB Data: x1000020
x60 x0 x0 x2 x0 x2408d3 x10229d32
[17443.116310] lpfc 0000:10:00.1: 3:0331 IOCB wake signaled
[17443.116316] lpfc 0000:10:00.1: 3:(0):0727 TMF FCP_TARGET_RESET to TGT 5 LUN
510 failed (3, 2) iocb_flag x6
[17443.116321] lpfc 0000:10:00.1: 3:(0):0723 SCSI layer issued Target Reset (5,
510) return x2003



--------------060305040208040608070906
Content-Type: text/x-patch; name="lpfc_tsk_mgmt_error_handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lpfc_tsk_mgmt_error_handling.patch"

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 60e5a17..0ff3883 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4081,6 +4081,9 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 	if (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
 		piocb->ulpFCP2Rcvy = 1;
 	}
+	else
+		piocb->ulpFCP2Rcvy = 0;
+
 	piocb->ulpClass = (ndlp->nlp_fcp_info & 0x0f);
 
 	/* ulpTimeout is only one byte */
@@ -4569,6 +4572,76 @@ lpfc_taskmgmt_name(uint8_t task_mgmt_cmd)
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
+lpfc_check_fcp_rsp(struct lpfc_vport *vport,struct lpfc_scsi_buf *lpfc_cmd)
+{
+	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
+	uint32_t rsp_info; 
+	uint32_t rsp_len; 
+	uint8_t  rsp_info_code;
+	int ret=FAILED;
+
+
+	if (fcprsp==NULL)
+	{
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP, 
+				 "0702X fcp_rsp is missing\n");
+	}
+	else
+	{
+		rsp_info = fcprsp->rspStatus2;
+		rsp_len = be32_to_cpu(fcprsp->rspRspLen);
+		rsp_info_code=fcprsp->rspInfo3;
+
+
+		lpfc_printf_vlog(vport, KERN_INFO, 
+				 LOG_FCP, 
+				 "0702XX fcp_rsp valid 0x%x,"	
+				 " rsp len=%d code 0x%x\n",
+				 rsp_info,
+				 rsp_len,rsp_info_code);
+
+		if ( (fcprsp->rspStatus2&RSP_LEN_VALID) && (rsp_len==8) ) {
+			switch (rsp_info_code) {
+			case RSP_NO_FAILURE:
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP, 
+						 "0702XX Task Mgmt actually OK,"
+						 " cancel error\n");
+				ret=SUCCESS;
+				break;
+			case RSP_TM_NOT_SUPPORTED: //TM rejected
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP, 
+						 "0702XX Target rejected task "
+						 "management\n");
+				break;
+			case RSP_TM_NOT_COMPLETED: //TM failed
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP, 
+						 "0702XX Target failed TM\n");
+				break;
+			case RSP_TM_INVALID_LU: //TM to invalid LU!
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
@@ -4630,12 +4705,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
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
@@ -4643,9 +4713,24 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
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
+			if (iocbqrsp->iocb.ulpStatus==IOSTAT_FCP_RSP_ERROR) {
+				/* the firmware says that we need to 
+				 * check the FCP_RSP ourselves */
+				ret = lpfc_check_fcp_rsp(vport,lpfc_cmd);
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
@@ -4797,12 +4882,12 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
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
@@ -4810,8 +4895,12 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	 * So, continue on.
 	 * We will report success if all the i/o aborts successfully.
 	 */
-	ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
-						LPFC_CTX_LUN);
+	if (ret==SUCCESS)
+	{
+		ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						  LPFC_CTX_LUN);
+	}
+
 	return ret;
 }
 
@@ -4864,12 +4953,12 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
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
@@ -4877,8 +4966,11 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	 * So, continue on.
 	 * We will report success if all the i/o aborts successfully.
 	 */
-	ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
-					  LPFC_CTX_TGT);
+	if (ret==SUCCESS)
+	{
+		ret = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						  LPFC_CTX_TGT);
+	}
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
index 624eab3..b335533 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9958,8 +9958,12 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 				timeout_req);
 
 		if (piocb->iocb_flag & LPFC_IO_WAKE) {
-			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			lpfc_printf_log(phba, KERN_INFO, LOG_SLI, 
 					"0331 IOCB wake signaled\n");
+			if ((prspiocbq) && (prspiocbq->iocb.ulpStatus))
+			{
+				retval = IOCB_ERROR;
+			}
 		} else if (timeleft == 0) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"0338 IOCB wait timeout error - no "
@@ -14415,7 +14419,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 			if (!iocbq) {
 				if (first_iocbq) {
 					first_iocbq->iocb.ulpStatus =
-							IOSTAT_FCP_RSP_ERROR;
+					                IOSTAT_LOCAL_REJECT; 
 					first_iocbq->iocb.un.ulpWord[4] =
 							IOERR_NO_RESOURCES;
 				}

--------------060305040208040608070906--
