From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 4/5] lpfc 8.3.3 : Add support for Target Reset handler
	entrypoint
Date: Wed, 10 Jun 2009 17:23:16 -0400
Message-ID: <1244668996.9571.21.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37954 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009AbZFJVXS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 17:23:18 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n5ALNK6w001406
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 14:23:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Add support for Target Reset handler entrypoint

Patch was originally submitted upstream on 4/21/2008:
  http://marc.info/?l=linux-scsi&m=120880973719266&w=2

Somewhere, it never get merged. The patch restructures the task mgmt
routines, commonizing like behavior. Then the patch changes device
reset to LUN resets, and adds a target reset handler.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |  484 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 291 insertions(+), 193 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-06-10 16:23:01.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-06-10 16:24:17.000000000 -0400
@@ -2676,72 +2676,6 @@ lpfc_tskmgmt_def_cmpl(struct lpfc_hba *p
 }
 
 /**
- * lpfc_scsi_tgt_reset - Target reset handler
- * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure
- * @vport: The virtual port for which this call is being executed.
- * @tgt_id: Target ID.
- * @lun: Lun number.
- * @rdata: Pointer to lpfc_rport_data.
- *
- * This routine issues a TARGET RESET iocb to reset a target with @tgt_id ID.
- *
- * Return Code:
- *   0x2003 - Error
- *   0x2002 - Success.
- **/
-static int
-lpfc_scsi_tgt_reset(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_vport *vport,
-		    unsigned  tgt_id, unsigned int lun,
-		    struct lpfc_rport_data *rdata)
-{
-	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_iocbq *iocbq;
-	struct lpfc_iocbq *iocbqrsp;
-	int ret;
-	int status;
-
-	if (!rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
-		return FAILED;
-
-	lpfc_cmd->rdata = rdata;
-	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun,
-					   FCP_TARGET_RESET);
-	if (!status)
-		return FAILED;
-
-	iocbq = &lpfc_cmd->cur_iocbq;
-	iocbqrsp = lpfc_sli_get_iocbq(phba);
-
-	if (!iocbqrsp)
-		return FAILED;
-
-	/* Issue Target Reset to TGT <num> */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-			 "0702 Issue Target Reset to TGT %d Data: x%x x%x\n",
-			 tgt_id, rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
-	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
-					  iocbq, iocbqrsp, lpfc_cmd->timeout);
-	if (status != IOCB_SUCCESS) {
-		if (status == IOCB_TIMEDOUT) {
-			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
-			ret = TIMEOUT_ERROR;
-		} else
-			ret = FAILED;
-		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
-	} else {
-		ret = SUCCESS;
-		lpfc_cmd->result = iocbqrsp->iocb.un.ulpWord[4];
-		lpfc_cmd->status = iocbqrsp->iocb.ulpStatus;
-		if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT &&
-			(lpfc_cmd->result & IOERR_DRVR_MASK))
-				lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
-	}
-
-	lpfc_sli_release_iocbq(phba, iocbqrsp);
-	return ret;
-}
-
-/**
  * lpfc_info - Info entry point of scsi_host_template data structure
  * @host: The scsi host for which this call is being executed.
  *
@@ -3121,156 +3055,334 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	return ret;
 }
 
+static char *
+lpfc_taskmgmt_name(uint8_t task_mgmt_cmd)
+{
+	switch (task_mgmt_cmd) {
+	case FCP_ABORT_TASK_SET:
+		return "ABORT_TASK_SET";
+	case FCP_CLEAR_TASK_SET:
+		return "FCP_CLEAR_TASK_SET";
+	case FCP_BUS_RESET:
+		return "FCP_BUS_RESET";
+	case FCP_LUN_RESET:
+		return "FCP_LUN_RESET";
+	case FCP_TARGET_RESET:
+		return "FCP_TARGET_RESET";
+	case FCP_CLEAR_ACA:
+		return "FCP_CLEAR_ACA";
+	case FCP_TERMINATE_TASK:
+		return "FCP_TERMINATE_TASK";
+	default:
+		return "unknown";
+	}
+}
+
 /**
- * lpfc_device_reset_handler - scsi_host_template eh_device_reset entry point
- * @cmnd: Pointer to scsi_cmnd data structure.
+ * lpfc_send_taskmgmt - Generic SCSI Task Mgmt Handler
+ * @vport: The virtual port for which this call is being executed.
+ * @rdata: Pointer to remote port local data
+ * @tgt_id: Target ID of remote device.
+ * @lun_id: Lun number for the TMF
+ * @task_mgmt_cmd: type of TMF to send
  *
- * This routine does a device reset by sending a TARGET_RESET task management
- * command.
+ * This routine builds and sends a TMF (SCSI Task Mgmt Function) to
+ * a remote port.
  *
- * Return code :
- *  0x2003 - Error
- *  0x2002 - Success
+ * Return Code:
+ *   0x2003 - Error
+ *   0x2002 - Success.
  **/
 static int
-lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
+lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
+		    unsigned  tgt_id, unsigned int lun_id,
+		    uint8_t task_mgmt_cmd)
 {
-	struct Scsi_Host  *shost = cmnd->device->host;
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_scsi_buf *lpfc_cmd;
-	struct lpfc_iocbq *iocbq, *iocbqrsp;
-	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
-	struct lpfc_nodelist *pnode = rdata->pnode;
-	unsigned long later;
-	int ret = SUCCESS;
+	struct lpfc_iocbq *iocbq;
+	struct lpfc_iocbq *iocbqrsp;
+	int ret;
 	int status;
-	int cnt;
-	struct lpfc_scsi_event_header scsi_event;
-
-	lpfc_block_error_handler(cmnd);
-	/*
-	 * If target is not in a MAPPED state, delay the reset until
-	 * target is rediscovered or devloss timeout expires.
-	 */
-	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
-	while (time_after(later, jiffies)) {
-		if (!pnode || !NLP_CHK_NODE_ACT(pnode))
-			return FAILED;
-		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
-			break;
-		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
-		rdata = cmnd->device->hostdata;
-		if (!rdata)
-			break;
-		pnode = rdata->pnode;
-	}
 
-	scsi_event.event_type = FC_REG_SCSI_EVENT;
-	scsi_event.subcategory = LPFC_EVENT_TGTRESET;
-	scsi_event.lun = 0;
-	memcpy(scsi_event.wwpn, &pnode->nlp_portname, sizeof(struct lpfc_name));
-	memcpy(scsi_event.wwnn, &pnode->nlp_nodename, sizeof(struct lpfc_name));
-
-	fc_host_post_vendor_event(shost,
-		fc_get_event_number(),
-		sizeof(scsi_event),
-		(char *)&scsi_event,
-		LPFC_NL_VENDOR_ID);
-
-	if (!rdata || pnode->nlp_state != NLP_STE_MAPPED_NODE) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-				 "0721 LUN Reset rport "
-				 "failure: msec x%x rdata x%p\n",
-				 jiffies_to_msecs(jiffies - later), rdata);
+	if (!rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
 		return FAILED;
-	}
+
 	lpfc_cmd = lpfc_get_scsi_buf(phba);
 	if (lpfc_cmd == NULL)
 		return FAILED;
 	lpfc_cmd->timeout = 60;
 	lpfc_cmd->rdata = rdata;
 
-	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd,
-					      cmnd->device->lun,
-					      FCP_TARGET_RESET);
+	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
+					   task_mgmt_cmd);
 	if (!status) {
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
 	}
-	iocbq = &lpfc_cmd->cur_iocbq;
 
-	/* get a buffer for this IOCB command response */
+	iocbq = &lpfc_cmd->cur_iocbq;
 	iocbqrsp = lpfc_sli_get_iocbq(phba);
 	if (iocbqrsp == NULL) {
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
 	}
+
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-			 "0703 Issue target reset to TGT %d LUN %d "
-			 "rpi x%x nlp_flag x%x\n", cmnd->device->id,
-			 cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
+			 "0702 Issue %s to TGT %d LUN %d "
+			 "rpi x%x nlp_flag x%x\n",
+			 lpfc_taskmgmt_name(task_mgmt_cmd), tgt_id, lun_id,
+			 rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
+
 	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
-	if (status == IOCB_TIMEDOUT) {
-		iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
-		ret = TIMEOUT_ERROR;
-	} else {
-		if (status != IOCB_SUCCESS)
+	if (status != IOCB_SUCCESS) {
+		if (status == IOCB_TIMEDOUT) {
+			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
+			ret = TIMEOUT_ERROR;
+		} else
 			ret = FAILED;
-		lpfc_release_scsi_buf(phba, lpfc_cmd);
-	}
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0713 SCSI layer issued device reset (%d, %d) "
-			 "return x%x status x%x result x%x\n",
-			 cmnd->device->id, cmnd->device->lun, ret,
-			 iocbqrsp->iocb.ulpStatus,
+		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			 "0727 TMF %s to TGT %d LUN %d failed (%d, %d)\n",
+			 lpfc_taskmgmt_name(task_mgmt_cmd),
+			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
 			 iocbqrsp->iocb.un.ulpWord[4]);
+	} else
+		ret = SUCCESS;
+
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
-	cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id, cmnd->device->lun,
-				LPFC_CTX_TGT);
+
+	if (ret != TIMEOUT_ERROR)
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+
+	return ret;
+}
+
+/**
+ * lpfc_chk_tgt_mapped -
+ * @vport: The virtual port to check on
+ * @cmnd: Pointer to scsi_cmnd data structure.
+ *
+ * This routine delays until the scsi target (aka rport) for the
+ * command exists (is present and logged in) or we declare it non-existent.
+ *
+ * Return code :
+ *  0x2003 - Error
+ *  0x2002 - Success
+ **/
+static int
+lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
+{
+	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
+	struct lpfc_nodelist *pnode = rdata->pnode;
+	unsigned long later;
+
+	/*
+	 * If target is not in a MAPPED state, delay until
+	 * target is rediscovered or devloss timeout expires.
+	 */
+	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
+	while (time_after(later, jiffies)) {
+		if (!pnode || !NLP_CHK_NODE_ACT(pnode))
+			return FAILED;
+		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
+			return SUCCESS;
+		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
+		rdata = cmnd->device->hostdata;
+		if (!rdata)
+			return FAILED;
+		pnode = rdata->pnode;
+	}
+	if (!pnode || !NLP_CHK_NODE_ACT(pnode) ||
+	    (pnode->nlp_state != NLP_STE_MAPPED_NODE))
+		return FAILED;
+	return SUCCESS;
+}
+
+/**
+ * lpfc_reset_flush_io_context -
+ * @vport: The virtual port (scsi_host) for the flush context
+ * @tgt_id: If aborting by Target contect - specifies the target id
+ * @lun_id: If aborting by Lun context - specifies the lun id
+ * @context: specifies the context level to flush at.
+ *
+ * After a reset condition via TMF, we need to flush orphaned i/o
+ * contexts from the adapter. This routine aborts any contexts
+ * outstanding, then waits for their completions. The wait is
+ * bounded by devloss_tmo though.
+ *
+ * Return code :
+ *  0x2003 - Error
+ *  0x2002 - Success
+ **/
+static int
+lpfc_reset_flush_io_context(struct lpfc_vport *vport, uint16_t tgt_id,
+			uint64_t lun_id, lpfc_ctx_cmd context)
+{
+	struct lpfc_hba   *phba = vport->phba;
+	unsigned long later;
+	int cnt;
+
+	cnt = lpfc_sli_sum_iocb(vport, tgt_id, lun_id, context);
 	if (cnt)
 		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
-				    cmnd->device->id, cmnd->device->lun,
-				    LPFC_CTX_TGT);
+				    tgt_id, lun_id, context);
 	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
 	while (time_after(later, jiffies) && cnt) {
 		schedule_timeout_uninterruptible(msecs_to_jiffies(20));
-		cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id,
-					cmnd->device->lun, LPFC_CTX_TGT);
+		cnt = lpfc_sli_sum_iocb(vport, tgt_id, lun_id, context);
 	}
 	if (cnt) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-				 "0719 device reset I/O flush failure: "
-				 "cnt x%x\n", cnt);
-		ret = FAILED;
+			"0724 I/O flush failure for context %s : cnt x%x\n",
+			((context == LPFC_CTX_LUN) ? "LUN" :
+			 ((context == LPFC_CTX_TGT) ? "TGT" :
+			  ((context == LPFC_CTX_HOST) ? "HOST" : "Unknown"))),
+			cnt);
+		return FAILED;
 	}
-	return ret;
+	return SUCCESS;
+}
+
+/**
+ * lpfc_device_reset_handler - scsi_host_template eh_device_reset entry point
+ * @cmnd: Pointer to scsi_cmnd data structure.
+ *
+ * This routine does a device reset by sending a LUN_RESET task management
+ * command.
+ *
+ * Return code :
+ *  0x2003 - Error
+ *  0x2002 - Success
+ **/
+static int
+lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host  *shost = cmnd->device->host;
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
+	struct lpfc_nodelist *pnode = rdata->pnode;
+	unsigned tgt_id = cmnd->device->id;
+	unsigned int lun_id = cmnd->device->lun;
+	struct lpfc_scsi_event_header scsi_event;
+	int status;
+
+	lpfc_block_error_handler(cmnd);
+
+	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	if (status == FAILED) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			"0721 Device Reset rport failure: rdata x%p\n", rdata);
+		return FAILED;
+	}
+
+	scsi_event.event_type = FC_REG_SCSI_EVENT;
+	scsi_event.subcategory = LPFC_EVENT_LUNRESET;
+	scsi_event.lun = lun_id;
+	memcpy(scsi_event.wwpn, &pnode->nlp_portname, sizeof(struct lpfc_name));
+	memcpy(scsi_event.wwnn, &pnode->nlp_nodename, sizeof(struct lpfc_name));
+
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
+
+	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+						FCP_LUN_RESET);
+
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			 "0713 SCSI layer issued Device Reset (%d, %d) "
+			 "return x%x\n", tgt_id, lun_id, status);
+
+	/*
+	 * We have to clean up i/o as : they may be orphaned by the TMF;
+	 * or if the TMF failed, they may be in an indeterminate state.
+	 * So, continue on.
+	 * We will report success if all the i/o aborts successfully.
+	 */
+	status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						LPFC_CTX_LUN);
+	return status;
+}
+
+/**
+ * lpfc_target_reset_handler - scsi_host_template eh_target_reset entry point
+ * @cmnd: Pointer to scsi_cmnd data structure.
+ *
+ * This routine does a target reset by sending a TARGET_RESET task management
+ * command.
+ *
+ * Return code :
+ *  0x2003 - Error
+ *  0x2002 - Success
+ **/
+static int
+lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host  *shost = cmnd->device->host;
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
+	struct lpfc_nodelist *pnode = rdata->pnode;
+	unsigned tgt_id = cmnd->device->id;
+	unsigned int lun_id = cmnd->device->lun;
+	struct lpfc_scsi_event_header scsi_event;
+	int status;
+
+	lpfc_block_error_handler(cmnd);
+
+	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	if (status == FAILED) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			"0722 Target Reset rport failure: rdata x%p\n", rdata);
+		return FAILED;
+	}
+
+	scsi_event.event_type = FC_REG_SCSI_EVENT;
+	scsi_event.subcategory = LPFC_EVENT_TGTRESET;
+	scsi_event.lun = 0;
+	memcpy(scsi_event.wwpn, &pnode->nlp_portname, sizeof(struct lpfc_name));
+	memcpy(scsi_event.wwnn, &pnode->nlp_nodename, sizeof(struct lpfc_name));
+
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
+
+	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+					FCP_TARGET_RESET);
+
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			 "0723 SCSI layer issued Target Reset (%d, %d) "
+			 "return x%x\n", tgt_id, lun_id, status);
+
+	/*
+	 * We have to clean up i/o as : they may be orphaned by the TMF;
+	 * or if the TMF failed, they may be in an indeterminate state.
+	 * So, continue on.
+	 * We will report success if all the i/o aborts successfully.
+	 */
+	status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+					LPFC_CTX_TGT);
+	return status;
 }
 
 /**
  * lpfc_bus_reset_handler - scsi_host_template eh_bus_reset_handler entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
- * This routine does target reset to all target on @cmnd->device->host.
+ * This routine does target reset to all targets on @cmnd->device->host.
+ * This emulates Parallel SCSI Bus Reset Semantics.
  *
- * Return Code:
- *   0x2003 - Error
- *   0x2002 - Success
+ * Return code :
+ *  0x2003 - Error
+ *  0x2002 - Success
  **/
 static int
 lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL;
-	int match;
-	int ret = SUCCESS, status = SUCCESS, i;
-	int cnt;
-	struct lpfc_scsi_buf * lpfc_cmd;
-	unsigned long later;
 	struct lpfc_scsi_event_header scsi_event;
+	int match;
+	int ret = SUCCESS, status, i;
 
 	scsi_event.event_type = FC_REG_SCSI_EVENT;
 	scsi_event.subcategory = LPFC_EVENT_BUSRESET;
@@ -3278,13 +3390,11 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	memcpy(scsi_event.wwpn, &vport->fc_portname, sizeof(struct lpfc_name));
 	memcpy(scsi_event.wwnn, &vport->fc_nodename, sizeof(struct lpfc_name));
 
-	fc_host_post_vendor_event(shost,
-		fc_get_event_number(),
-		sizeof(scsi_event),
-		(char *)&scsi_event,
-		LPFC_NL_VENDOR_ID);
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
 	lpfc_block_error_handler(cmnd);
+
 	/*
 	 * Since the driver manages a single bus device, reset all
 	 * targets known to the driver.  Should any target reset
@@ -3307,16 +3417,11 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 		spin_unlock_irq(shost->host_lock);
 		if (!match)
 			continue;
-		lpfc_cmd = lpfc_get_scsi_buf(phba);
-		if (lpfc_cmd) {
-			lpfc_cmd->timeout = 60;
-			status = lpfc_scsi_tgt_reset(lpfc_cmd, vport, i,
-						     cmnd->device->lun,
-						     ndlp->rport->dd_data);
-			if (status != TIMEOUT_ERROR)
-				lpfc_release_scsi_buf(phba, lpfc_cmd);
-		}
-		if (!lpfc_cmd || status != SUCCESS) {
+
+		status = lpfc_send_taskmgmt(vport, ndlp->rport->dd_data,
+					i, 0, FCP_TARGET_RESET);
+
+		if (status != SUCCESS) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 					 "0700 Bus Reset on target %d failed\n",
 					 i);
@@ -3324,25 +3429,16 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 		}
 	}
 	/*
-	 * All outstanding txcmplq I/Os should have been aborted by
-	 * the targets.  Unfortunately, some targets do not abide by
-	 * this forcing the driver to double check.
+	 * We have to clean up i/o as : they may be orphaned by the TMFs
+	 * above; or if any of the TMFs failed, they may be in an
+	 * indeterminate state.
+	 * We will report success if all the i/o aborts successfully.
 	 */
-	cnt = lpfc_sli_sum_iocb(vport, 0, 0, LPFC_CTX_HOST);
-	if (cnt)
-		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
-				    0, 0, LPFC_CTX_HOST);
-	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
-	while (time_after(later, jiffies) && cnt) {
-		schedule_timeout_uninterruptible(msecs_to_jiffies(20));
-		cnt = lpfc_sli_sum_iocb(vport, 0, 0, LPFC_CTX_HOST);
-	}
-	if (cnt) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-				 "0715 Bus Reset I/O flush failure: "
-				 "cnt x%x left x%x\n", cnt, i);
+
+	status = lpfc_reset_flush_io_context(vport, 0, 0, LPFC_CTX_HOST);
+	if (status != SUCCESS)
 		ret = FAILED;
-	}
+
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "0714 SCSI layer issued Bus Reset Data: x%x\n", ret);
 	return ret;
@@ -3475,7 +3571,8 @@ struct scsi_host_template lpfc_template 
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
-	.eh_device_reset_handler= lpfc_device_reset_handler,
+	.eh_device_reset_handler = lpfc_device_reset_handler,
+	.eh_target_reset_handler = lpfc_target_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
@@ -3495,7 +3592,8 @@ struct scsi_host_template lpfc_vport_tem
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
-	.eh_device_reset_handler= lpfc_device_reset_handler,
+	.eh_device_reset_handler = lpfc_device_reset_handler,
+	.eh_target_reset_handler = lpfc_target_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,


