From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/16] lpfc 8.1.12 : Round 2 of Miscellaneous fixes
Date: Wed, 25 Apr 2007 09:52:34 -0400
Message-ID: <1177509154.23155.13.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51653 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031006AbXDYNwZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:52:25 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDqOnu006583
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:52:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Round 2 of Miscellaneous fixes:
 - Ensure we don't prematurely re-enable IRQs in lpfc_sli_abort_fcp_cmpl().
 - Prevent freeing of iocb after IOCB_TIMEDOUT error.
 - Added code to cleanup REG_LOGIN mailbox command when a LOGO is received.
 - Fix offline window where more work can sneak in after clearing work_ha
 - Use target reset instead of LU reset in bus_device_reset_handler
 - Fixed system hangs due to leaked host_lock.
 - Fixed NULL pointer dereference during I/O with LIP.
 - Fixed false iocb timeout.
 - Fixed name server query response handling.
 - Change rport dev_loss_tmo value when user change lpfc HBA's dev_loss_tmo.
 - Fixed a memory leak in lpfc_sli_wake_mbox_wait.
 - Fixed check for dropped frames.
 - Removed hba queue depth calculation based on device PCI IDs
 - Change min cr_count value specified in comment to agree with setting

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:41.000000000 -0400
@@ -828,6 +828,18 @@ lpfc_nodev_tmo_init(struct lpfc_hba *phb
 	return -EINVAL;
 }
 
+static void
+lpfc_update_rport_devloss_tmo(struct lpfc_hba *phba)
+{
+	struct lpfc_nodelist  *ndlp;
+
+	spin_lock_irq(phba->host->host_lock);
+	list_for_each_entry(ndlp, &phba->fc_nodes, nlp_listp)
+		if (ndlp->rport)
+			ndlp->rport->dev_loss_tmo = phba->cfg_devloss_tmo;
+	spin_unlock_irq(phba->host->host_lock);
+}
+
 static int
 lpfc_nodev_tmo_set(struct lpfc_hba *phba, int val)
 {
@@ -843,6 +855,7 @@ lpfc_nodev_tmo_set(struct lpfc_hba *phba
 	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
 		phba->cfg_nodev_tmo = val;
 		phba->cfg_devloss_tmo = val;
+		lpfc_update_rport_devloss_tmo(phba);
 		return 0;
 	}
 
@@ -878,6 +891,7 @@ lpfc_devloss_tmo_set(struct lpfc_hba *ph
 		phba->cfg_nodev_tmo = val;
 		phba->cfg_devloss_tmo = val;
 		phba->dev_loss_tmo_changed = 1;
+		lpfc_update_rport_devloss_tmo(phba);
 		return 0;
 	}
 
@@ -997,7 +1011,7 @@ LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 
 /*
 # lpfc_cr_delay & lpfc_cr_count: Default values for I/O colaesing
 # cr_delay (msec) or cr_count outstanding commands. cr_delay can take
-# value [0,63]. cr_count can take value [0,255]. Default value of cr_delay
+# value [0,63]. cr_count can take value [1,255]. Default value of cr_delay
 # is 0. Default value of cr_count is 1. The cr_count feature is disabled if
 # cr_delay is set to 0.
 */
@@ -1955,25 +1969,8 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 			sizeof(struct fcp_rsp) +
 			(phba->cfg_sg_seg_cnt * sizeof(struct ulp_bde64));
 
-	switch (phba->pcidev->device) {
-	case PCI_DEVICE_ID_LP101:
-	case PCI_DEVICE_ID_BSMB:
-	case PCI_DEVICE_ID_ZSMB:
-		phba->cfg_hba_queue_depth = LPFC_LP101_HBA_Q_DEPTH;
-		break;
-	case PCI_DEVICE_ID_RFLY:
-	case PCI_DEVICE_ID_PFLY:
-	case PCI_DEVICE_ID_BMID:
-	case PCI_DEVICE_ID_ZMID:
-	case PCI_DEVICE_ID_TFLY:
-		phba->cfg_hba_queue_depth = LPFC_LC_HBA_Q_DEPTH;
-		break;
-	default:
-		phba->cfg_hba_queue_depth = LPFC_DFT_HBA_Q_DEPTH;
-	}
 
-	if (phba->cfg_hba_queue_depth > lpfc_hba_queue_depth)
-		lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
+	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-04-24 11:12:41.000000000 -0400
@@ -334,22 +334,22 @@ lpfc_ns_rsp(struct lpfc_hba * phba, stru
 
 	lpfc_set_disctmo(phba);
 
-	Cnt = Size  > FCELSSIZE ? FCELSSIZE : Size;
 
 	list_add_tail(&head, &mp->list);
 	list_for_each_entry_safe(mp, next_mp, &head, list) {
 		mlast = mp;
 
+		Cnt = Size  > FCELSSIZE ? FCELSSIZE : Size;
+
 		Size -= Cnt;
 
 		if (!ctptr) {
-			Cnt = FCELSSIZE;
 			ctptr = (uint32_t *) mlast->virt;
 		} else
 			Cnt -= 16;	/* subtract length of CT header */
 
 		/* Loop through entire NameServer list of DIDs */
-		while (Cnt) {
+		while (Cnt >= sizeof (uint32_t)) {
 
 			/* Get next DID from NameServer List */
 			CTentry = *ctptr++;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:41.000000000 -0400
@@ -3214,7 +3214,7 @@ lpfc_els_timeout_handler(struct lpfc_hba
 	IOCB_t *cmd = NULL;
 	struct lpfc_dmabuf *pcmd;
 	uint32_t *elscmd;
-	uint32_t els_command;
+	uint32_t els_command=0;
 	uint32_t timeout;
 	uint32_t remote_ID;
 
@@ -3233,12 +3233,16 @@ lpfc_els_timeout_handler(struct lpfc_hba
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
 		cmd = &piocb->iocb;
 
-		if (piocb->iocb_flag & LPFC_IO_LIBDFC) {
+		if ((piocb->iocb_flag & LPFC_IO_LIBDFC) ||
+			(piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN) ||
+			(piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)) {
 			continue;
 		}
 		pcmd = (struct lpfc_dmabuf *) piocb->context2;
-		elscmd = (uint32_t *) (pcmd->virt);
-		els_command = *elscmd;
+		if (pcmd) {
+			elscmd = (uint32_t *) (pcmd->virt);
+			els_command = *elscmd;
+		}
 
 		if ((els_command == ELS_CMD_FARP)
 		    || (els_command == ELS_CMD_FARPR)) {
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:41.000000000 -0400
@@ -27,10 +27,6 @@ struct lpfc_sli2_slim;
 					   requests */
 #define LPFC_MAX_NS_RETRY	3	/* Number of retry attempts to contact
 					   the NameServer  before giving up. */
-#define LPFC_DFT_HBA_Q_DEPTH	2048	/* max cmds per hba */
-#define LPFC_LC_HBA_Q_DEPTH	1024	/* max cmds per low cost hba */
-#define LPFC_LP101_HBA_Q_DEPTH	128	/* max cmds per low cost hba */
-
 #define LPFC_CMD_PER_LUN	3	/* max outstanding cmds per lun */
 #define LPFC_SG_SEG_CNT		64	/* sg element count per scsi cmnd */
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:41.000000000 -0400
@@ -1375,8 +1375,6 @@ lpfc_offline(struct lpfc_hba * phba)
 
 	/* stop all timers associated with this hba */
 	lpfc_stop_timer(phba);
-	phba->work_hba_events = 0;
-	phba->work_ha = 0;
 
 	lpfc_printf_log(phba,
 		       KERN_WARNING,
@@ -1389,6 +1387,8 @@ lpfc_offline(struct lpfc_hba * phba)
 	lpfc_sli_hba_down(phba);
 	lpfc_cleanup(phba);
 	spin_lock_irqsave(phba->host->host_lock, iflag);
+	phba->work_hba_events = 0;
+	phba->work_ha = 0;
 	phba->fc_flag |= FC_OFFLINE_MODE;
 	spin_unlock_irqrestore(phba->host->host_lock, iflag);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:41.000000000 -0400
@@ -1019,9 +1019,36 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 			     uint32_t evt)
 {
 	struct lpfc_iocbq *cmdiocb;
+	LPFC_MBOXQ_t	  *mb;
+	LPFC_MBOXQ_t	  *nextmb;
+	struct lpfc_dmabuf *mp;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
+	/* cleanup any ndlp on mbox q waiting for reglogin cmpl */
+	if ((mb = phba->sli.mbox_active)) {
+		if ((mb->mb.mbxCommand == MBX_REG_LOGIN64) &&
+		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
+			mb->context2 = NULL;
+			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		}
+	}
+
+	spin_lock_irq(phba->host->host_lock);
+	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
+		if ((mb->mb.mbxCommand == MBX_REG_LOGIN64) &&
+		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
+			mp = (struct lpfc_dmabuf *) (mb->context1);
+			if (mp) {
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
+			list_del(&mb->list);
+			mempool_free(mb, phba->mbox_mem_pool);
+		}
+	}
+	spin_unlock_irq(phba->host->host_lock);
+
 	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-04-24 11:12:41.000000000 -0400
@@ -292,13 +292,13 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba
 }
 
 static void
-lpfc_handle_fcp_err(struct lpfc_scsi_buf *lpfc_cmd)
+lpfc_handle_fcp_err(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_iocbq *rsp_iocb)
 {
 	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
 	struct fcp_cmnd *fcpcmd = lpfc_cmd->fcp_cmnd;
 	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
 	struct lpfc_hba *phba = lpfc_cmd->scsi_hba;
-	uint32_t fcpi_parm = lpfc_cmd->cur_iocbq.iocb.un.fcpi.fcpi_parm;
+	uint32_t fcpi_parm = rsp_iocb->iocb.un.fcpi.fcpi_parm;
 	uint32_t resp_info = fcprsp->rspStatus2;
 	uint32_t scsi_status = fcprsp->rspStatus3;
 	uint32_t *lp;
@@ -360,6 +360,24 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 				fcpi_parm, cmnd->cmnd[0], cmnd->underflow);
 
 		/*
+		 * If there is an under run check if under run reported by
+		 * storage array is same as the under run reported by HBA.
+		 * If this is not same, there is a dropped frame.
+		 */
+		if ((cmnd->sc_data_direction == DMA_FROM_DEVICE) &&
+			fcpi_parm &&
+			(cmnd->resid != fcpi_parm)) {
+			lpfc_printf_log(phba, KERN_WARNING,
+				LOG_FCP | LOG_FCP_ERROR,
+				"%d:0735 FCP Read Check Error and Underrun "
+				"Data: x%x x%x x%x x%x\n", phba->brd_no,
+				be32_to_cpu(fcpcmd->fcpDl),
+				cmnd->resid,
+				fcpi_parm, cmnd->cmnd[0]);
+			cmnd->resid = cmnd->request_bufflen;
+			host_status = DID_ERROR;
+		}
+		/*
 		 * The cmnd->underflow is the minimum number of bytes that must
 		 * be transfered for this command.  Provided a sense condition
 		 * is not present, make sure the actual amount transferred is at
@@ -439,7 +457,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		switch (lpfc_cmd->status) {
 		case IOSTAT_FCP_RSP_ERROR:
 			/* Call FCP RSP handler to determine result */
-			lpfc_handle_fcp_err(lpfc_cmd);
+			lpfc_handle_fcp_err(lpfc_cmd,pIocbOut);
 			break;
 		case IOSTAT_NPORT_BSY:
 		case IOSTAT_FABRIC_BSY:
@@ -673,6 +691,18 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	return (1);
 }
 
+static void
+lpfc_tskmgmt_def_cmpl(struct lpfc_hba *phba,
+			struct lpfc_iocbq *cmdiocbq,
+			struct lpfc_iocbq *rspiocbq)
+{
+	struct lpfc_scsi_buf *lpfc_cmd =
+		(struct lpfc_scsi_buf *) cmdiocbq->context1;
+	if (lpfc_cmd)
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+	return;
+}
+
 static int
 lpfc_scsi_tgt_reset(struct lpfc_scsi_buf * lpfc_cmd, struct lpfc_hba * phba,
 		    unsigned  tgt_id, unsigned int lun,
@@ -709,8 +739,9 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 				       &phba->sli.ring[phba->sli.fcp_ring],
 				       iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if (ret != IOCB_SUCCESS) {
+		if (ret == IOCB_TIMEDOUT)
+			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
 		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
-		ret = FAILED;
 	} else {
 		ret = SUCCESS;
 		lpfc_cmd->result = iocbqrsp->iocb.un.ulpWord[4];
@@ -977,7 +1008,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 }
 
 static int
-lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
+lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
@@ -987,6 +1018,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	uint32_t cmd_result = 0, cmd_status = 0;
 	int ret = FAILED;
+	int iocb_status = IOCB_SUCCESS;
 	int cnt, loopcnt;
 
 	lpfc_block_error_handler(cmnd);
@@ -998,7 +1030,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	 */
 	while ( 1 ) {
 		if (!pnode)
-			return FAILED;
+			goto out;
 
 		if (pnode->nlp_state != NLP_STE_MAPPED_NODE) {
 			spin_unlock_irq(phba->host->host_lock);
@@ -1016,7 +1048,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 			}
 			pnode = rdata->pnode;
 			if (!pnode)
-				return FAILED;
+				goto out;
 		}
 		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
 			break;
@@ -1031,7 +1063,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	lpfc_cmd->rdata = rdata;
 
 	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, cmnd->device->lun,
-					   FCP_LUN_RESET);
+					   FCP_TARGET_RESET);
 	if (!ret)
 		goto out_free_scsi_buf;
 
@@ -1043,16 +1075,21 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 		goto out_free_scsi_buf;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
-			"%d:0703 Issue LUN Reset to TGT %d LUN %d "
-			"Data: x%x x%x\n", phba->brd_no, cmnd->device->id,
+			"%d:0703 Issue target reset to TGT %d LUN %d rpi x%x "
+			"nlp_flag x%x\n", phba->brd_no, cmnd->device->id,
 			cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
 
-	ret = lpfc_sli_issue_iocb_wait(phba,
+	iocb_status = lpfc_sli_issue_iocb_wait(phba,
 				       &phba->sli.ring[phba->sli.fcp_ring],
 				       iocbq, iocbqrsp, lpfc_cmd->timeout);
-	if (ret == IOCB_SUCCESS)
-		ret = SUCCESS;
 
+	if (iocb_status == IOCB_TIMEDOUT)
+		iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
+
+	if (iocb_status == IOCB_SUCCESS)
+		ret = SUCCESS;
+	else
+		ret = iocb_status;
 
 	cmd_result = iocbqrsp->iocb.un.ulpWord[4];
 	cmd_status = iocbqrsp->iocb.ulpStatus;
@@ -1090,18 +1127,19 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 
 	if (cnt) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-			"%d:0719 LUN Reset I/O flush failure: cnt x%x\n",
+			"%d:0719 device reset I/O flush failure: cnt x%x\n",
 			phba->brd_no, cnt);
 		ret = FAILED;
 	}
 
 out_free_scsi_buf:
-	lpfc_release_scsi_buf(phba, lpfc_cmd);
-
+	if (iocb_status != IOCB_TIMEDOUT) {
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+	}
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-			"%d:0713 SCSI layer issued LUN reset (%d, %d) "
-			"Data: x%x x%x x%x\n",
-			phba->brd_no, cmnd->device->id,cmnd->device->lun,
+			"%d:0713 SCSI layer issued device reset (%d, %d) "
+			"return x%x status x%x result x%x\n",
+			phba->brd_no, cmnd->device->id, cmnd->device->lun,
 			ret, cmd_status, cmd_result);
 
 out:
@@ -1110,7 +1148,7 @@ out:
 }
 
 static int
-lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
+lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
@@ -1155,13 +1193,17 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 				"%d:0700 Bus Reset on target %d failed\n",
 				phba->brd_no, i);
 			err_count++;
+			break;
 		}
 	}
 
+	if (ret != IOCB_TIMEDOUT)
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+
 	if (err_count == 0)
 		ret = SUCCESS;
-
-	lpfc_release_scsi_buf(phba, lpfc_cmd);
+	else
+		ret = FAILED;
 
 	/*
 	 * All outstanding txcmplq I/Os should have been aborted by
@@ -1302,8 +1344,8 @@ struct scsi_host_template lpfc_template 
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
-	.eh_device_reset_handler= lpfc_reset_lun_handler,
-	.eh_bus_reset_handler	= lpfc_reset_bus_handler,
+	.eh_device_reset_handler= lpfc_device_reset_handler,
+	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:41.000000000 -0400
@@ -528,6 +528,7 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba 
 	 * If pdone_q is empty, the driver thread gave up waiting and
 	 * continued running.
 	 */
+	pmboxq->mbox_flag |= LPFC_MBX_WAKE;
 	pdone_q = (wait_queue_head_t *) pmboxq->context1;
 	if (pdone_q)
 		wake_up_interruptible(pdone_q);
@@ -538,11 +539,32 @@ void
 lpfc_sli_def_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
 	struct lpfc_dmabuf *mp;
+	uint16_t rpi;
+	int rc;
+
 	mp = (struct lpfc_dmabuf *) (pmb->context1);
+
 	if (mp) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
 	}
+
+	/*
+	 * If a REG_LOGIN succeeded  after node is destroyed or node
+	 * is in re-discovery driver need to cleanup the RPI.
+	 */
+	if (!(phba->fc_flag & FC_UNLOADING) &&
+		(pmb->mb.mbxCommand == MBX_REG_LOGIN64) &&
+		(!pmb->mb.mbxStatus)) {
+
+		rpi = pmb->mb.un.varWords[0];
+		lpfc_unreg_login(phba, rpi, pmb);
+		pmb->mbox_cmpl=lpfc_sli_def_mbox_cmpl;
+		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+		if (rc != MBX_NOT_FINISHED)
+			return;
+	}
+
 	mempool_free( pmb, phba->mbox_mem_pool);
 	return;
 }
@@ -2862,9 +2884,11 @@ void
 lpfc_sli_abort_fcp_cmpl(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
 			   struct lpfc_iocbq * rspiocb)
 {
-	spin_lock_irq(phba->host->host_lock);
+	unsigned long iflags;
+
+	spin_lock_irqsave(phba->host->host_lock, iflags);
 	lpfc_sli_release_iocbq(phba, cmdiocb);
-	spin_unlock_irq(phba->host->host_lock);
+	spin_unlock_irqrestore(phba->host->host_lock, iflags);
 	return;
 }
 
@@ -2987,22 +3011,22 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 				timeout_req);
 		spin_lock_irq(phba->host->host_lock);
 
-		if (timeleft == 0) {
+		if (piocb->iocb_flag & LPFC_IO_WAKE) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+					"%d:0331 IOCB wake signaled\n",
+					phba->brd_no);
+		} else if (timeleft == 0) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"%d:0338 IOCB wait timeout error - no "
 					"wake response Data x%x\n",
 					phba->brd_no, timeout);
 			retval = IOCB_TIMEDOUT;
-		} else if (!(piocb->iocb_flag & LPFC_IO_WAKE)) {
+		} else {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"%d:0330 IOCB wake NOT set, "
 					"Data x%x x%lx\n", phba->brd_no,
 					timeout, (timeleft / jiffies));
 			retval = IOCB_TIMEDOUT;
-		} else {
-			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-					"%d:0331 IOCB wake signaled\n",
-					phba->brd_no);
 		}
 	} else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
@@ -3031,8 +3055,6 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 			 uint32_t timeout)
 {
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(done_q);
-	DECLARE_WAITQUEUE(wq_entry, current);
-	uint32_t timeleft = 0;
 	int retval;
 
 	/* The caller must leave context1 empty. */
@@ -3045,27 +3067,25 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 	/* setup context field to pass wait_queue pointer to wake function  */
 	pmboxq->context1 = &done_q;
 
-	/* start to sleep before we wait, to avoid races */
-	set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&done_q, &wq_entry);
-
 	/* now issue the command */
 	retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
 
 	if (retval == MBX_BUSY || retval == MBX_SUCCESS) {
-		timeleft = schedule_timeout(timeout * HZ);
+		wait_event_interruptible_timeout(done_q,
+				pmboxq->mbox_flag & LPFC_MBX_WAKE,
+				timeout * HZ);
+
 		pmboxq->context1 = NULL;
-		/* if schedule_timeout returns 0, we timed out and were not
-		   woken up */
-		if ((timeleft == 0) || signal_pending(current))
-			retval = MBX_TIMEOUT;
-		else
+		/*
+		 * if LPFC_MBX_WAKE flag is set the mailbox is completed
+		 * else do not free the resources.
+		 */
+		if (pmboxq->mbox_flag & LPFC_MBX_WAKE)
 			retval = MBX_SUCCESS;
+		else
+			retval = MBX_TIMEOUT;
 	}
 
-
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&done_q, &wq_entry);
 	return retval;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2007-04-24 11:12:41.000000000 -0400
@@ -68,6 +68,8 @@ struct lpfc_iocbq {
 #define IOCB_ERROR          2
 #define IOCB_TIMEDOUT       3
 
+#define LPFC_MBX_WAKE	1
+
 typedef struct lpfcMboxq {
 	/* MBOXQs are used in single linked lists */
 	struct list_head list;	/* ptr to next mailbox command */
@@ -76,6 +78,7 @@ typedef struct lpfcMboxq {
 	void *context2;		/* caller context information */
 
 	void (*mbox_cmpl) (struct lpfc_hba *, struct lpfcMboxq *);
+	uint8_t mbox_flag;
 
 } LPFC_MBOXQ_t;
 


