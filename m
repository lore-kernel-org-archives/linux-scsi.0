From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/5] lpfc 8.2.7 : Change device reset behavior
Date: Sat, 14 Jun 2008 22:52:38 -0400
Message-ID: <1213498358.10002.10.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33070 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbYFOCwm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jun 2008 22:52:42 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m5F2qf59018778
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jun 2008 19:52:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Change device reset behavior. 
  Prior handler was only waiting for I/O on one lun to finish before
  returning completion. Now, wait for all LUNs on the target.
  Also performed some rudimentary cleanup while in this code.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |  201 +++++++++++++++++++++++-------------------------------------
 1 file changed, 80 insertions(+), 121 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-04-10 17:07:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-06-14 22:16:48.000000000 -0400
@@ -849,14 +849,15 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *iocbqrsp;
 	int ret;
+	int status;
 
 	if (!rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
 		return FAILED;
 
 	lpfc_cmd->rdata = rdata;
-	ret = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun,
+	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun,
 					   FCP_TARGET_RESET);
-	if (!ret)
+	if (!status)
 		return FAILED;
 
 	iocbq = &lpfc_cmd->cur_iocbq;
@@ -869,12 +870,15 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			 "0702 Issue Target Reset to TGT %d Data: x%x x%x\n",
 			 tgt_id, rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
-	ret = lpfc_sli_issue_iocb_wait(phba,
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
 	} else {
 		ret = SUCCESS;
@@ -1142,121 +1146,96 @@ lpfc_device_reset_handler(struct scsi_cm
 	struct lpfc_iocbq *iocbq, *iocbqrsp;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
-	uint32_t cmd_result = 0, cmd_status = 0;
-	int ret = FAILED;
-	int iocb_status = IOCB_SUCCESS;
-	int cnt, loopcnt;
+	unsigned long later;
+	int ret = SUCCESS;
+	int status;
+	int cnt;
 
 	lpfc_block_error_handler(cmnd);
-	loopcnt = 0;
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
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
 			break;
+		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
+		rdata = cmnd->device->hostdata;
+		if (!rdata)
+			break;
+		pnode = rdata->pnode;
+	}
+	if (!rdata || pnode->nlp_state != NLP_STE_MAPPED_NODE) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+				 "0721 LUN Reset rport "
+				 "failure: msec x%x rdata x%p\n",
+				 jiffies_to_msecs(jiffies - later), rdata);
+		return FAILED;
 	}
-
 	lpfc_cmd = lpfc_get_scsi_buf(phba);
 	if (lpfc_cmd == NULL)
-		goto out;
-
+		return FAILED;
 	lpfc_cmd->timeout = 60;
 	lpfc_cmd->rdata = rdata;
 
-	ret = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, cmnd->device->lun,
-					   FCP_TARGET_RESET);
-	if (!ret)
-		goto out_free_scsi_buf;
-
+	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd,
+					      cmnd->device->lun,
+					      FCP_TARGET_RESET);
+	if (!status) {
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+		return FAILED;
+	}
 	iocbq = &lpfc_cmd->cur_iocbq;
 
 	/* get a buffer for this IOCB command response */
 	iocbqrsp = lpfc_sli_get_iocbq(phba);
-	if (iocbqrsp == NULL)
-		goto out_free_scsi_buf;
-
+	if (iocbqrsp == NULL) {
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+		return FAILED;
+	}
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			 "0703 Issue target reset to TGT %d LUN %d "
 			 "rpi x%x nlp_flag x%x\n", cmnd->device->id,
 			 cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
-	iocb_status = lpfc_sli_issue_iocb_wait(phba,
-				       &phba->sli.ring[phba->sli.fcp_ring],
-				       iocbq, iocbqrsp, lpfc_cmd->timeout);
-
-	if (iocb_status == IOCB_TIMEDOUT)
+	status = lpfc_sli_issue_iocb_wait(phba,
+					  &phba->sli.ring[phba->sli.fcp_ring],
+					  iocbq, iocbqrsp, lpfc_cmd->timeout);
+	if (status == IOCB_TIMEDOUT) {
 		iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
-
-	if (iocb_status == IOCB_SUCCESS)
-		ret = SUCCESS;
-	else
-		ret = iocb_status;
-
-	cmd_result = iocbqrsp->iocb.un.ulpWord[4];
-	cmd_status = iocbqrsp->iocb.ulpStatus;
-
+		ret = TIMEOUT_ERROR;
+	} else {
+		if (status != IOCB_SUCCESS)
+			ret = FAILED;
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+	}
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			 "0713 SCSI layer issued device reset (%d, %d) "
+			 "return x%x status x%x result x%x\n",
+			 cmnd->device->id, cmnd->device->lun, ret,
+			 iocbqrsp->iocb.ulpStatus,
+			 iocbqrsp->iocb.un.ulpWord[4]);
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
-
-	/*
-	 * All outstanding txcmplq I/Os should have been aborted by the device.
-	 * Unfortunately, some targets do not abide by this forcing the driver
-	 * to double check.
-	 */
 	cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id, cmnd->device->lun,
-				LPFC_CTX_LUN);
+				LPFC_CTX_TGT);
 	if (cnt)
 		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
 				    cmnd->device->id, cmnd->device->lun,
-				    LPFC_CTX_LUN);
-	loopcnt = 0;
-	while(cnt) {
-		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
-
-		if (++loopcnt
-		    > (2 * vport->cfg_devloss_tmo)/LPFC_RESET_WAIT)
-			break;
-
+				    LPFC_CTX_TGT);
+	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
+	while (time_after(later, jiffies) && cnt) {
+		schedule_timeout_uninterruptible(msecs_to_jiffies(20));
 		cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id,
-					cmnd->device->lun, LPFC_CTX_LUN);
+					cmnd->device->lun, LPFC_CTX_TGT);
 	}
-
 	if (cnt) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0719 device reset I/O flush failure: "
 				 "cnt x%x\n", cnt);
 		ret = FAILED;
 	}
-
-out_free_scsi_buf:
-	if (iocb_status != IOCB_TIMEDOUT) {
-		lpfc_release_scsi_buf(phba, lpfc_cmd);
-	}
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0713 SCSI layer issued device reset (%d, %d) "
-			 "return x%x status x%x result x%x\n",
-			 cmnd->device->id, cmnd->device->lun, ret,
-			 cmd_status, cmd_result);
-out:
 	return ret;
 }
 
@@ -1268,19 +1247,12 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL;
 	int match;
-	int ret = FAILED, i, err_count = 0;
-	int cnt, loopcnt;
+	int ret = SUCCESS, status, i;
+	int cnt;
 	struct lpfc_scsi_buf * lpfc_cmd;
+	unsigned long later;
 
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
@@ -1294,7 +1266,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 			if (!NLP_CHK_NODE_ACT(ndlp))
 				continue;
 			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
-			    i == ndlp->nlp_sid &&
+			    ndlp->nlp_sid == i &&
 			    ndlp->rport) {
 				match = 1;
 				break;
@@ -1303,27 +1275,22 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 		spin_unlock_irq(shost->host_lock);
 		if (!match)
 			continue;
-
-		ret = lpfc_scsi_tgt_reset(lpfc_cmd, vport, i,
-					  cmnd->device->lun,
-					  ndlp->rport->dd_data);
-		if (ret != SUCCESS) {
+		lpfc_cmd = lpfc_get_scsi_buf(phba);
+		if (lpfc_cmd) {
+			lpfc_cmd->timeout = 60;
+			status = lpfc_scsi_tgt_reset(lpfc_cmd, vport, i,
+						     cmnd->device->lun,
+						     ndlp->rport->dd_data);
+			if (status != TIMEOUT_ERROR)
+				lpfc_release_scsi_buf(phba, lpfc_cmd);
+		}
+		if (!lpfc_cmd || status != SUCCESS) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 					 "0700 Bus Reset on target %d failed\n",
 					 i);
-			err_count++;
-			break;
+			ret = FAILED;
 		}
 	}
-
-	if (ret != IOCB_TIMEDOUT)
-		lpfc_release_scsi_buf(phba, lpfc_cmd);
-
-	if (err_count == 0)
-		ret = SUCCESS;
-	else
-		ret = FAILED;
-
 	/*
 	 * All outstanding txcmplq I/Os should have been aborted by
 	 * the targets.  Unfortunately, some targets do not abide by
@@ -1333,27 +1300,19 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	if (cnt)
 		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
 				    0, 0, LPFC_CTX_HOST);
-	loopcnt = 0;
-	while(cnt) {
-		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
-
-		if (++loopcnt
-		    > (2 * vport->cfg_devloss_tmo)/LPFC_RESET_WAIT)
-			break;
-
+	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
+	while (time_after(later, jiffies) && cnt) {
+		schedule_timeout_uninterruptible(msecs_to_jiffies(20));
 		cnt = lpfc_sli_sum_iocb(vport, 0, 0, LPFC_CTX_HOST);
 	}
-
 	if (cnt) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0715 Bus Reset I/O flush failure: "
 				 "cnt x%x left x%x\n", cnt, i);
 		ret = FAILED;
 	}
-
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "0714 SCSI layer issued Bus Reset Data: x%x\n", ret);
-out:
 	return ret;
 }
 


