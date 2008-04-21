From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch] lpfc: convert lpfc to use target reset handler
Date: Mon, 21 Apr 2008 16:28:24 -0400
Message-ID: <1208809704.4952.14.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63604 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYDUU2Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Apr 2008 16:28:24 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m3LKS0kA003705
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2008 13:28:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2/29, Mike Christie sent out a patch to add target reset support to lpfc
http://marc.info/?l=linux-scsi&m=120433120021478&w=2

This patch replaces Mike's and formally adds support for target resets 
(uses TARGET_RESET tmf) and device resets (uses LUN_RESET tmf).

The patch not only corrected a few things that mike pointed out, but also
reorg'd the code better for task management functionality.

The patch was made against scsi-misc-2.6.

There was one question posed by Mike that needed a reply:

michaelc@cs.wisc.edu wrote:
> One thing I was not sure of was if lpfc_scsi_tgt_reset fails, but
> the caller ends up calling lpfc_sli_abort_iocb and that aborts all
> the commands for the context that is requested and those are all
> cleaned up by the driver/firmware, should we return SUCCESS.

Whether this is true or not depends on what the definition of a 
"target reset" request means. Is it simply that the related I/O was
terminated, or did it track the SCSI side-effects of the TARGET_RESET
task management command, which affects more than just I/O.  We deemed
any error in this path as returning an error status. I can also make
a case where if the TMF failed, there's still something bad going on in
the target.

-- james s



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |  355 +++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 189 insertions(+), 166 deletions(-)


diff -upNr a.8.2.6/drivers/scsi/lpfc/lpfc_scsi.c a/drivers/scsi/lpfc/lpfc_scsi.c
--- a.8.2.6/drivers/scsi/lpfc/lpfc_scsi.c	2008-04-08 11:30:39.000000000 -0400
+++ a/drivers/scsi/lpfc/lpfc_scsi.c	2008-04-10 16:13:56.000000000 -0400
@@ -840,52 +840,94 @@ lpfc_tskmgmt_def_cmpl(struct lpfc_hba *p
 	return;
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
 static int
-lpfc_scsi_tgt_reset(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_vport *vport,
-		    unsigned  tgt_id, unsigned int lun,
-		    struct lpfc_rport_data *rdata)
+lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
+		    unsigned  tgt_id, unsigned int lun_id,
+		    uint8_t task_mgmt_cmd)
 {
 	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_scsi_buf *lpfc_cmd;
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *iocbqrsp;
 	int ret;
+	int status;
 
 	if (!rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
 		return FAILED;
 
+	lpfc_cmd = lpfc_get_scsi_buf(phba);
+	if (lpfc_cmd == NULL)
+		return FAILED;
+	lpfc_cmd->timeout = 60;
 	lpfc_cmd->rdata = rdata;
-	ret = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun,
-					   FCP_TARGET_RESET);
-	if (!ret)
+
+	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
+					   task_mgmt_cmd);
+	if (!status) {
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
+	}
 
 	iocbq = &lpfc_cmd->cur_iocbq;
 	iocbqrsp = lpfc_sli_get_iocbq(phba);
 
-	if (!iocbqrsp)
+	if (iocbqrsp == NULL) {
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
+	}
 
-	/* Issue Target Reset to TGT <num> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-			 "0702 Issue Target Reset to TGT %d Data: x%x x%x\n",
-			 tgt_id, rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
-	ret = lpfc_sli_issue_iocb_wait(phba,
+			 "0702 Issue %s to TGT %d LUN %d "
+			 "rpi x%x nlp_flag x%x\n",
+			 lpfc_taskmgmt_name(task_mgmt_cmd), tgt_id, lun_id,
+			 rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
+
+	status = lpfc_sli_issue_iocb_wait(phba,
 				       &phba->sli.ring[phba->sli.fcp_ring],
 				       iocbq, iocbqrsp, lpfc_cmd->timeout);
-	if (ret != IOCB_SUCCESS) {
-		if (ret == IOCB_TIMEDOUT)
+	if (status != IOCB_SUCCESS) {
+		if (status == IOCB_TIMEDOUT) {
 			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
+			ret = TIMEOUT_ERROR;
+		} else
+			ret = FAILED;
 		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
-	} else {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			 "0727 TMF %s to TGT %d LUN %d failed (%d, %d)\n",
+			 lpfc_taskmgmt_name(task_mgmt_cmd),
+			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
+			 iocbqrsp->iocb.un.ulpWord[4]);
+	} else
 		ret = SUCCESS;
-		lpfc_cmd->result = iocbqrsp->iocb.un.ulpWord[4];
-		lpfc_cmd->status = iocbqrsp->iocb.ulpStatus;
-		if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT &&
-			(lpfc_cmd->result & IOERR_DRVR_MASK))
-				lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
-	}
 
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
+
+	if (ret != TIMEOUT_ERROR)
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+
 	return ret;
 }
 
@@ -1133,154 +1175,159 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 }
 
 static int
-lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
+lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
 {
-	struct Scsi_Host  *shost = cmnd->device->host;
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_scsi_buf *lpfc_cmd;
-	struct lpfc_iocbq *iocbq, *iocbqrsp;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
-	uint32_t cmd_result = 0, cmd_status = 0;
-	int ret = FAILED;
-	int iocb_status = IOCB_SUCCESS;
-	int cnt, loopcnt;
+	unsigned long later;
 
-	lpfc_block_error_handler(cmnd);
-	loopcnt = 0;
 	/*
-	 * If target is not in a MAPPED state, delay the reset until
+	 * If target is not in a MAPPED state, delay until
 	 * target is rediscovered or devloss timeout expires.
 	 */
-	while (1) {
+	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
+	while (time_after(later, jiffies)) {
 		if (!pnode || !NLP_CHK_NODE_ACT(pnode))
-			goto out;
-
-		if (pnode->nlp_state != NLP_STE_MAPPED_NODE) {
-			schedule_timeout_uninterruptible(msecs_to_jiffies(500));
-			loopcnt++;
-			rdata = cmnd->device->hostdata;
-			if (!rdata ||
-				(loopcnt > ((vport->cfg_devloss_tmo * 2) + 1))){
-				lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-						 "0721 LUN Reset rport "
-						 "failure: cnt x%x rdata x%p\n",
-						 loopcnt, rdata);
-				goto out;
-			}
-			pnode = rdata->pnode;
-			if (!pnode || !NLP_CHK_NODE_ACT(pnode))
-				goto out;
-		}
+			return FAILED;
 		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
-			break;
+			return SUCCESS;
+		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
+		rdata = cmnd->device->hostdata;
+		if (!rdata)
+			return FAILED;
+		pnode = rdata->pnode;
 	}
+	if (!pnode || !NLP_CHK_NODE_ACT(pnode) ||
+	    (pnode->nlp_state != NLP_STE_MAPPED_NODE))
+		return FAILED;
+	return SUCCESS;
+}
 
-	lpfc_cmd = lpfc_get_scsi_buf(phba);
-	if (lpfc_cmd == NULL)
-		goto out;
-
-	lpfc_cmd->timeout = 60;
-	lpfc_cmd->rdata = rdata;
+static int
+lpfc_reset_flush_io_context(struct lpfc_vport *vport, uint16_t tgt_id,
+			uint64_t lun_id, lpfc_ctx_cmd context)
+{
+	struct lpfc_hba   *phba = vport->phba;
+	unsigned long later;
+	int cnt;
 
-	ret = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, cmnd->device->lun,
-					   FCP_TARGET_RESET);
-	if (!ret)
-		goto out_free_scsi_buf;
+	/*
+	 * After a reset condition via TMF, we need to flush orphaned
+	 * i/o contexts from the adapter. This routine aborts any
+	 * contexts outstanding, then waits for their completions.
+	 * The wait is bounded by devloss_tmo though.
+	 */
 
-	iocbq = &lpfc_cmd->cur_iocbq;
+	cnt = lpfc_sli_sum_iocb(vport, tgt_id, lun_id, context);
+	if (cnt)
+		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
+				    tgt_id, lun_id, context);
+	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
+	while (time_after(later, jiffies) && cnt) {
+		schedule_timeout_uninterruptible(msecs_to_jiffies(20));
+		cnt = lpfc_sli_sum_iocb(vport, tgt_id, lun_id, context);
+	}
+	if (cnt) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			"0724 I/O flush failure for context %s : cnt x%x\n",
+			((context == LPFC_CTX_LUN) ? "LUN" :
+			 ((context == LPFC_CTX_TGT) ? "TGT" :
+			  ((context == LPFC_CTX_HOST) ? "HOST" : "Unknown"))),
+			cnt);
+		return FAILED;
+	}
+	return SUCCESS;
+}
 
-	/* get a buffer for this IOCB command response */
-	iocbqrsp = lpfc_sli_get_iocbq(phba);
-	if (iocbqrsp == NULL)
-		goto out_free_scsi_buf;
 
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-			 "0703 Issue target reset to TGT %d LUN %d "
-			 "rpi x%x nlp_flag x%x\n", cmnd->device->id,
-			 cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
-	iocb_status = lpfc_sli_issue_iocb_wait(phba,
-				       &phba->sli.ring[phba->sli.fcp_ring],
-				       iocbq, iocbqrsp, lpfc_cmd->timeout);
+static int
+lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host  *shost = cmnd->device->host;
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
+	unsigned tgt_id = cmnd->device->id;
+	unsigned int lun_id = cmnd->device->lun;
+	int status;
 
-	if (iocb_status == IOCB_TIMEDOUT)
-		iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
+	lpfc_block_error_handler(cmnd);
 
-	if (iocb_status == IOCB_SUCCESS)
-		ret = SUCCESS;
-	else
-		ret = iocb_status;
+	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	if (status == FAILED) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			"0721 Device Reset rport failure: rdata x%p\n", rdata);
+		return FAILED;
+	}
 
-	cmd_result = iocbqrsp->iocb.un.ulpWord[4];
-	cmd_status = iocbqrsp->iocb.ulpStatus;
+	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+						FCP_LUN_RESET);
 
-	lpfc_sli_release_iocbq(phba, iocbqrsp);
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			 "0713 SCSI layer issued Device Reset (%d, %d) "
+			 "return x%x\n", tgt_id, lun_id, status);
 
 	/*
-	 * All outstanding txcmplq I/Os should have been aborted by the device.
-	 * Unfortunately, some targets do not abide by this forcing the driver
-	 * to double check.
+	 * We have to clean up i/o as : they may be orphaned by the TMF;
+	 * or if the TMF failed, they may be in an indeterminate state.
+	 * So, continue on.
+	 * We will report success if all the i/o aborts successfully.
 	 */
-	cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id, cmnd->device->lun,
-				LPFC_CTX_LUN);
-	if (cnt)
-		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
-				    cmnd->device->id, cmnd->device->lun,
-				    LPFC_CTX_LUN);
-	loopcnt = 0;
-	while(cnt) {
-		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
 
-		if (++loopcnt
-		    > (2 * vport->cfg_devloss_tmo)/LPFC_RESET_WAIT)
-			break;
+	status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						LPFC_CTX_LUN);
+	return status;
+}
 
-		cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id,
-					cmnd->device->lun, LPFC_CTX_LUN);
-	}
 
-	if (cnt) {
+static int
+lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host  *shost = cmnd->device->host;
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
+	unsigned tgt_id = cmnd->device->id;
+	unsigned int lun_id = cmnd->device->lun;
+	int status;
+
+	lpfc_block_error_handler(cmnd);
+
+	status = lpfc_chk_tgt_mapped(vport, cmnd);
+	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-				 "0719 device reset I/O flush failure: "
-				 "cnt x%x\n", cnt);
-		ret = FAILED;
+			"0722 Target Reset rport failure: rdata x%p\n", rdata);
+		return FAILED;
 	}
 
-out_free_scsi_buf:
-	if (iocb_status != IOCB_TIMEDOUT) {
-		lpfc_release_scsi_buf(phba, lpfc_cmd);
-	}
+	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+					FCP_TARGET_RESET);
+
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0713 SCSI layer issued device reset (%d, %d) "
-			 "return x%x status x%x result x%x\n",
-			 cmnd->device->id, cmnd->device->lun, ret,
-			 cmd_status, cmd_result);
-out:
-	return ret;
+			 "0723 SCSI layer issued Target Reset (%d, %d) "
+			 "return x%x\n", tgt_id, lun_id, status);
+
+	/*
+	 * We have to clean up i/o as : they may be orphaned by the TMF;
+	 * or if the TMF failed, they may be in an indeterminate state.
+	 * So, continue on.
+	 * We will report success if all the i/o aborts successfully.
+	 */
+
+	status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+					LPFC_CTX_TGT);
+	return status;
 }
 
+
 static int
 lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL;
 	int match;
-	int ret = FAILED, i, err_count = 0;
-	int cnt, loopcnt;
-	struct lpfc_scsi_buf * lpfc_cmd;
+	int ret = SUCCESS, status, i;
 
 	lpfc_block_error_handler(cmnd);
-
-	lpfc_cmd = lpfc_get_scsi_buf(phba);
-	if (lpfc_cmd == NULL)
-		goto out;
-
-	/* The lpfc_cmd storage is reused.  Set all loop invariants. */
-	lpfc_cmd->timeout = 60;
-
 	/*
 	 * Since the driver manages a single bus device, reset all
 	 * targets known to the driver.  Should any target reset
@@ -1294,7 +1341,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 			if (!NLP_CHK_NODE_ACT(ndlp))
 				continue;
 			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
-			    i == ndlp->nlp_sid &&
+			    ndlp->nlp_sid == i &&
 			    ndlp->rport) {
 				match = 1;
 				break;
@@ -1304,56 +1351,30 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 		if (!match)
 			continue;
 
-		ret = lpfc_scsi_tgt_reset(lpfc_cmd, vport, i,
-					  cmnd->device->lun,
-					  ndlp->rport->dd_data);
-		if (ret != SUCCESS) {
+		status = lpfc_send_taskmgmt(vport, ndlp->rport->dd_data,
+					i, 0, FCP_TARGET_RESET);
+
+		if (status != SUCCESS) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 					 "0700 Bus Reset on target %d failed\n",
 					 i);
-			err_count++;
-			break;
+			ret = FAILED;
 		}
 	}
 
-	if (ret != IOCB_TIMEDOUT)
-		lpfc_release_scsi_buf(phba, lpfc_cmd);
-
-	if (err_count == 0)
-		ret = SUCCESS;
-	else
-		ret = FAILED;
-
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
-	loopcnt = 0;
-	while(cnt) {
-		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
 
-		if (++loopcnt
-		    > (2 * vport->cfg_devloss_tmo)/LPFC_RESET_WAIT)
-			break;
-
-		cnt = lpfc_sli_sum_iocb(vport, 0, 0, LPFC_CTX_HOST);
-	}
-
-	if (cnt) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-				 "0715 Bus Reset I/O flush failure: "
-				 "cnt x%x left x%x\n", cnt, i);
+	status = lpfc_reset_flush_io_context(vport, 0, 0, LPFC_CTX_HOST);
+	if (status != SUCCESS)
 		ret = FAILED;
-	}
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "0714 SCSI layer issued Bus Reset Data: x%x\n", ret);
-out:
 	return ret;
 }
 
@@ -1462,6 +1483,7 @@ struct scsi_host_template lpfc_template 
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler= lpfc_device_reset_handler,
+	.eh_target_reset_handler= lpfc_target_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
@@ -1482,6 +1504,7 @@ struct scsi_host_template lpfc_vport_tem
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler= lpfc_device_reset_handler,
+	.eh_target_reset_handler= lpfc_target_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,


