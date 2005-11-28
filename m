From: James.Smart@Emulex.Com
Subject: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Mon, 28 Nov 2005 11:42:05 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4A@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42741 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751291AbVK1QmH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:42:07 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGg6s3014147
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:42:06 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Fixes to error handlers:
- Release task management command before counting outstanding commands.
  TMF was being erroneously counted as an active outstanding command.
- Serialize EH calls and block requests when EH function is running.


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2005-11-24 10:07:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2005-11-28 10:32:43.000000000 -0500
@@ -167,6 +167,7 @@ struct lpfc_hba {
 	dma_addr_t slim2p_mapping;
 	uint16_t pci_cfg_value;
 
+	struct semaphore hba_can_block;
 	uint32_t hba_state;
 
 #define LPFC_INIT_START           1	/* Initial state after board reset */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 10:15:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 10:32:43.000000000 -0500
@@ -1345,7 +1345,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_put_host;
 
 	host->unique_id = phba->brd_no;
-
+	init_MUTEX(&phba->hba_can_block);
 	INIT_LIST_HEAD(&phba->ctrspbuflist);
 	INIT_LIST_HEAD(&phba->rnidrspbuflist);
 	INIT_LIST_HEAD(&phba->freebufList);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-28 10:26:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-28 10:32:43.000000000 -0500
@@ -41,6 +41,20 @@
 #define LPFC_ABORT_WAIT  2
 
 
+static inline void
+lpfc_block_requests(struct lpfc_hba * phba)
+{
+	down(&phba->hba_can_block);
+	scsi_block_requests(phba->host);
+}
+
+static inline void
+lpfc_unblock_requests(struct lpfc_hba * phba)
+{
+	scsi_unblock_requests(phba->host);
+	up(&phba->hba_can_block);
+}
+
 /*
  * This routine allocates a scsi buffer, which contains all the necessary
  * information needed to initiate a SCSI I/O.  The non-DMAable buffer region
@@ -774,6 +788,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	unsigned int loop_count = 0;
 	int ret = SUCCESS;
 
+	lpfc_block_requests(phba);
 	spin_lock_irq(shost->host_lock);
 
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
@@ -853,6 +868,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 			cmnd->device->lun, cmnd->serial_number);
 
 	spin_unlock_irq(shost->host_lock);
+	lpfc_unblock_requests(phba);
 
 	return ret;
 }
@@ -866,9 +882,11 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	struct lpfc_iocbq *iocbq, *iocbqrsp;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
+	uint32_t cmd_result = 0, cmd_status = 0;
 	int ret = FAILED;
 	int cnt, loopcnt;
 
+	lpfc_block_requests(phba);
 	spin_lock_irq(shost->host_lock);
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
@@ -912,26 +930,28 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	if (ret == IOCB_SUCCESS)
 		ret = SUCCESS;
 
-	lpfc_cmd->result = iocbqrsp->iocb.un.ulpWord[4];
-	lpfc_cmd->status = iocbqrsp->iocb.ulpStatus;
-	if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT)
-		if (lpfc_cmd->result & IOERR_DRVR_MASK)
-			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
+
+	cmd_result = iocbqrsp->iocb.un.ulpWord[4];
+	cmd_status = iocbqrsp->iocb.ulpStatus;
+
+	lpfc_sli_release_iocbq(phba, iocbqrsp);
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
 
 	/*
-	 * All outstanding txcmplq I/Os should have been aborted by the target.
+	 * All outstanding txcmplq I/Os should have been aborted by the device.
 	 * Unfortunately, some targets do not abide by this forcing the driver
 	 * to double check.
 	 */
-	lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-			    cmnd->device->id, cmnd->device->lun, 0,
-			    LPFC_CTX_LUN);
-
+	cnt = lpfc_sli_sum_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
+				cmnd->device->id, cmnd->device->lun,
+				LPFC_CTX_LUN);
+	if (cnt)
+		lpfc_sli_abort_iocb(phba,
+				    &phba->sli.ring[phba->sli.fcp_ring],
+				    cmnd->device->id, cmnd->device->lun,
+				    0, LPFC_CTX_LUN);
 	loopcnt = 0;
-	while((cnt = lpfc_sli_sum_iocb(phba,
-				       &phba->sli.ring[phba->sli.fcp_ring],
-				       cmnd->device->id, cmnd->device->lun,
-				       LPFC_CTX_LUN))) {
+	while(cnt) {
 		spin_unlock_irq(phba->host->host_lock);
 		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
 		spin_lock_irq(phba->host->host_lock);
@@ -939,6 +959,11 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 		if (++loopcnt
 		    > (2 * phba->cfg_nodev_tmo)/LPFC_RESET_WAIT)
 			break;
+
+		cnt = lpfc_sli_sum_iocb(phba,
+					&phba->sli.ring[phba->sli.fcp_ring],
+					cmnd->device->id, cmnd->device->lun,
+					LPFC_CTX_LUN);
 	}
 
 	if (cnt) {
@@ -948,18 +973,16 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 		ret = FAILED;
 	}
 
-	lpfc_sli_release_iocbq(phba, iocbqrsp);
-
 out_free_scsi_buf:
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 			"%d:0713 SCSI layer issued LUN reset (%d, %d) "
 			"Data: x%x x%x x%x\n",
-			phba->brd_no, lpfc_cmd->pCmd->device->id,
-			lpfc_cmd->pCmd->device->lun, ret, lpfc_cmd->status,
-			lpfc_cmd->result);
-	lpfc_release_scsi_buf(phba, lpfc_cmd);
+			phba->brd_no, cmnd->device->id,cmnd->device->lun,
+			ret, cmd_status, cmd_result);
+
 out:
 	spin_unlock_irq(shost->host_lock);
+	lpfc_unblock_requests(phba);
 	return ret;
 }
 
@@ -975,6 +998,7 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 	unsigned int midlayer_id = 0;
 	struct lpfc_scsi_buf * lpfc_cmd;
 
+	lpfc_block_requests(phba);
 	spin_lock_irq(shost->host_lock);
 
 	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
@@ -1008,18 +1032,31 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 		lpfc_cmd->pCmd->device->hostdata = ndlp->rport->dd_data;
 		ret = lpfc_scsi_tgt_reset(lpfc_cmd, phba);
 		if (ret != SUCCESS) {
-			lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
+			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 				"%d:0713 Bus Reset on target %d failed\n",
 				phba->brd_no, i);
 			err_count++;
 		}
 	}
 
+	if (err_count == 0)
+		ret = SUCCESS;
+
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
+
+	/*
+	 * All outstanding txcmplq I/Os should have been aborted by
+	 * the targets.  Unfortunately, some targets do not abide by
+	 * this forcing the driver to double check.
+	 */
 	cmnd->device->id = midlayer_id;
+	cnt = lpfc_sli_sum_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
+				0, 0, LPFC_CTX_HOST);
+	if (cnt)
+		lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
+				    0, 0, 0, LPFC_CTX_HOST);
 	loopcnt = 0;
-	while((cnt = lpfc_sli_sum_iocb(phba,
-				&phba->sli.ring[phba->sli.fcp_ring],
-				0, 0, LPFC_CTX_HOST))) {
+	while(cnt) {
 		spin_unlock_irq(phba->host->host_lock);
 		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
 		spin_lock_irq(phba->host->host_lock);
@@ -1027,25 +1064,19 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 		if (++loopcnt
 		    > (2 * phba->cfg_nodev_tmo)/LPFC_RESET_WAIT)
 			break;
+
+		cnt = lpfc_sli_sum_iocb(phba,
+					&phba->sli.ring[phba->sli.fcp_ring],
+					0, 0, LPFC_CTX_HOST);
 	}
 
 	if (cnt) {
-		/* flush all outstanding commands on the host */
-		i = lpfc_sli_abort_iocb(phba,
-				&phba->sli.ring[phba->sli.fcp_ring], 0, 0, 0,
-				LPFC_CTX_HOST);
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
+		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 		   "%d:0715 Bus Reset I/O flush failure: cnt x%x left x%x\n",
 		   phba->brd_no, cnt, i);
-	}
-
-	if (cnt == 0)
-		ret = SUCCESS;
-	else
 		ret = FAILED;
+	}
 
-	lpfc_release_scsi_buf(phba, lpfc_cmd);
 	lpfc_printf_log(phba,
 			KERN_ERR,
 			LOG_FCP,
@@ -1053,6 +1084,7 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 			phba->brd_no, ret);
 out:
 	spin_unlock_irq(shost->host_lock);
+	lpfc_unblock_requests(phba);
 	return ret;
 }
 
