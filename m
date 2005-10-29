From: James.Smart@Emulex.Com
Subject: [PATCH 13/15]  lpfc 8.1.0 : Fix eh_ return codes for commands
Date: Fri, 28 Oct 2005 20:30:02 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A5C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:11217 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750936AbVJ2AaF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:30:05 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0U3Dp018568
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:30:04 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Return FAILED from eh_ routines if command(s) is(are) not completed

Fix:  There were scenarios where we may have returned from the error
  handlers prior to all affected commands being flushed to the midlayer.
  Add changes to ensure this doesn't happen.
 

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -41,6 +41,7 @@ struct lpfc_iocbq {
 	uint8_t iocb_flag;
 #define LPFC_IO_LIBDFC	1	/* libdfc iocb */
 #define LPFC_IO_WAKE	2	/* High Priority Queue signal flag */
+#define LPFC_IO_FCP	4	/* FCP command -- iocbq in scsi_buf */
 
 	uint8_t abort_count;
 	uint8_t rsvd2;
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -50,7 +50,7 @@
  * and the BPL BDE is setup in the IOCB.
  */
 static struct lpfc_scsi_buf *
-lpfc_get_scsi_buf(struct lpfc_hba * phba)
+lpfc_new_scsi_buf(struct lpfc_hba * phba)
 {
 	struct lpfc_scsi_buf *psb;
 	struct ulp_bde64 *bpl;
@@ -88,6 +88,7 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba
 		kfree (psb);
 		return NULL;
 	}
+	psb->cur_iocbq.iocb_flag |= LPFC_IO_FCP;
 
 	psb->fcp_cmnd = psb->data;
 	psb->fcp_rsp = psb->data + sizeof(struct fcp_cmnd);
@@ -135,11 +136,19 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba
 	return psb;
 }
 
-static void
-lpfc_free_scsi_buf(struct lpfc_scsi_buf * psb)
+struct  lpfc_scsi_buf*
+lpfc_sli_get_scsi_buf(struct lpfc_hba * phba)
 {
-	struct lpfc_hba *phba = psb->scsi_hba;
+	struct  lpfc_scsi_buf * lpfc_cmd = NULL;
+	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
+
+	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
+	return  lpfc_cmd;
+}
 
+static void
+lpfc_release_scsi_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
+{
 	/*
 	 * There are only two special cases to consider.  (1) the scsi command
 	 * requested scatter-gather usage or (2) the scsi command allocated
@@ -157,6 +166,7 @@ lpfc_free_scsi_buf(struct lpfc_scsi_buf 
 		 }
 	}
 
+	psb->pCmd = NULL;
 	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list);
 }
 
@@ -431,12 +441,11 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 				*lp, *(lp + 3), cmd->retries, cmd->resid);
 	}
 
+	cmd->scsi_done(cmd);
+
 	spin_lock_irqsave(phba->host->host_lock, iflag);
-	lpfc_free_scsi_buf(lpfc_cmd);
-	cmd->host_scribble = NULL;
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
 	spin_unlock_irqrestore(phba->host->host_lock, iflag);
-
-	cmd->scsi_done(cmd);
 }
 
 static void
@@ -623,8 +632,7 @@ static int
 lpfc_scsi_tgt_reset(struct lpfc_scsi_buf * lpfc_cmd, struct lpfc_hba * phba)
 {
 	struct lpfc_iocbq *iocbq;
-	struct lpfc_iocbq *iocbqrsp = NULL;
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
+	struct lpfc_iocbq *iocbqrsp;
 	int ret;
 
 	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, FCP_TARGET_RESET);
@@ -633,7 +641,8 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 
 	lpfc_cmd->scsi_hba = phba;
 	iocbq = &lpfc_cmd->cur_iocbq;
-	list_remove_head(lpfc_iocb_list, iocbqrsp, struct lpfc_iocbq, list);
+	iocbqrsp = lpfc_sli_get_iocbq(phba);
+
 	if (!iocbqrsp)
 		return FAILED;
 
@@ -652,44 +661,10 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 				lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 	}
 
-	/*
-	 * All outstanding txcmplq I/Os should have been aborted by the target.
-	 * Unfortunately, some targets do not abide by this forcing the driver
-	 * to double check.
-	 */
-	lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-			    lpfc_cmd->pCmd->device->id,
-			    lpfc_cmd->pCmd->device->lun, 0, LPFC_CTX_TGT);
-
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
 	return ret;
 }
 
-static void
-lpfc_scsi_cmd_iocb_cleanup (struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
-			    struct lpfc_iocbq *pIocbOut)
-{
-	unsigned long iflag;
-	struct lpfc_scsi_buf *lpfc_cmd =
-		(struct lpfc_scsi_buf *) pIocbIn->context1;
-
-	spin_lock_irqsave(phba->host->host_lock, iflag);
-	lpfc_free_scsi_buf(lpfc_cmd);
-	spin_unlock_irqrestore(phba->host->host_lock, iflag);
-}
-
-static void
-lpfc_scsi_cmd_iocb_cmpl_aborted(struct lpfc_hba *phba,
-				struct lpfc_iocbq *pIocbIn,
-				struct lpfc_iocbq *pIocbOut)
-{
-	struct scsi_cmnd *ml_cmd =
-		((struct lpfc_scsi_buf *) pIocbIn->context1)->pCmd;
-
-	lpfc_scsi_cmd_iocb_cleanup (phba, pIocbIn, pIocbOut);
-	ml_cmd->host_scribble = NULL;
-}
-
 const char *
 lpfc_info(struct Scsi_Host *host)
 {
@@ -726,9 +701,8 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
-	struct lpfc_scsi_buf *lpfc_cmd = NULL;
+	struct lpfc_scsi_buf *lpfc_cmd;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
-	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
 	int err;
 
 	err = fc_remote_port_chkready(rport);
@@ -745,8 +719,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 		cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
 		goto out_fail_command;
 	}
-
-	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
+	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
 	if (lpfc_cmd == NULL) {
 		printk(KERN_WARNING "%s: No buffer available - list empty, "
 		       "total count %d\n", __FUNCTION__, phba->total_scsi_bufs);
@@ -776,7 +749,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	return 0;
 
  out_host_busy_free_buf:
-	lpfc_free_scsi_buf(lpfc_cmd);
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
 	cmnd->host_scribble = NULL;
  out_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -792,116 +765,92 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 	struct lpfc_hba *phba =
 			(struct lpfc_hba *)cmnd->device->host->hostdata[0];
 	struct lpfc_sli_ring *pring = &phba->sli.ring[phba->sli.fcp_ring];
-	struct lpfc_iocbq *iocb, *next_iocb;
-	struct lpfc_iocbq *abtsiocb = NULL;
+	struct lpfc_iocbq *iocb;
+	struct lpfc_iocbq *abtsiocb;
 	struct lpfc_scsi_buf *lpfc_cmd;
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
 	IOCB_t *cmd, *icmd;
-	unsigned long snum;
-	unsigned int id, lun;
 	unsigned int loop_count = 0;
-	int ret = IOCB_SUCCESS;
+	int ret = SUCCESS;
+
 
-	/*
-	 * If the host_scribble data area is NULL, then the driver has already
-	 * completed this command, but the midlayer did not see the completion
-	 * before the eh fired.  Just return SUCCESS.
-	 */
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
-	if (!lpfc_cmd)
-		return SUCCESS;
+	BUG_ON(!lpfc_cmd);
 
-	/* save these now since lpfc_cmd can be freed */
-	id   = lpfc_cmd->pCmd->device->id;
-	lun  = lpfc_cmd->pCmd->device->lun;
-	snum = lpfc_cmd->pCmd->serial_number;
-
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
-		cmd = &iocb->iocb;
-		if (iocb->context1 != lpfc_cmd)
-			continue;
+	/*
+	 * If pCmd field of the corresponding lpfc_scsi_buf structure
+	 * points to a different SCSI command, then the driver has
+	 * already completed this command, but the midlayer did not
+	 * see the completion before the eh fired.  Just return
+	 * SUCCESS.
+	 */
+	iocb = &lpfc_cmd->cur_iocbq;
+	if (lpfc_cmd->pCmd != cmnd)
+		goto out;
 
-		list_del_init(&iocb->list);
-		pring->txq_cnt--;
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			lpfc_scsi_cmd_iocb_cmpl_aborted(phba, iocb, iocb);
-		}
+	BUG_ON(iocb->context1 != lpfc_cmd);
 
+	abtsiocb = lpfc_sli_get_iocbq(phba);
+	if (abtsiocb == NULL) {
+		ret = FAILED;
 		goto out;
 	}
 
-	list_remove_head(lpfc_iocb_list, abtsiocb, struct lpfc_iocbq, list);
-	if (abtsiocb == NULL)
-		return FAILED;
-
 	/*
-	 * The scsi command was not in the txq.  Check the txcmplq and if it is
-	 * found, send an abort to the FW.
+	 * The scsi command can not be in txq and it is in flight because the
+	 * pCmd is still pointig at the SCSI command we have to abort. There
+	 * is no need to search the txcmplq. Just send an abort to the FW.
 	 */
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-		if (iocb->context1 != lpfc_cmd)
-			continue;
-
-		iocb->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl_aborted;
-		cmd = &iocb->iocb;
-		icmd = &abtsiocb->iocb;
-		icmd->un.acxri.abortType = ABORT_TYPE_ABTS;
-		icmd->un.acxri.abortContextTag = cmd->ulpContext;
-		icmd->un.acxri.abortIoTag = cmd->ulpIoTag;
-
-		icmd->ulpLe = 1;
-		icmd->ulpClass = cmd->ulpClass;
-		if (phba->hba_state >= LPFC_LINK_UP)
-			icmd->ulpCommand = CMD_ABORT_XRI_CN;
-		else
-			icmd->ulpCommand = CMD_CLOSE_XRI_CN;
 
-		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
-		if (lpfc_sli_issue_iocb(phba, pring, abtsiocb, 0) ==
-								IOCB_ERROR) {
-			lpfc_sli_release_iocbq(phba, abtsiocb);
-			ret = IOCB_ERROR;
-			break;
-		}
+	cmd = &iocb->iocb;
+	icmd = &abtsiocb->iocb;
+	icmd->un.acxri.abortType = ABORT_TYPE_ABTS;
+	icmd->un.acxri.abortContextTag = cmd->ulpContext;
+	icmd->un.acxri.abortIoTag = cmd->ulpIoTag;
+
+	icmd->ulpLe = 1;
+	icmd->ulpClass = cmd->ulpClass;
+	if (phba->hba_state >= LPFC_LINK_UP)
+		icmd->ulpCommand = CMD_ABORT_XRI_CN;
+	else
+		icmd->ulpCommand = CMD_CLOSE_XRI_CN;
 
-		/* Wait for abort to complete */
-		while (cmnd->host_scribble)
-		{
-			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(LPFC_ABORT_WAIT*HZ);
-			spin_lock_irq(phba->host->host_lock);
-			if (++loop_count
-			    > (2 * phba->cfg_nodev_tmo)/LPFC_ABORT_WAIT)
-				break;
-		}
+	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
+	if (lpfc_sli_issue_iocb(phba, pring, abtsiocb, 0) == IOCB_ERROR) {
+		lpfc_sli_release_iocbq(phba, abtsiocb);
+		ret = FAILED;
+		goto out;
+	}
 
-		if(cmnd->host_scribble) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-					"%d:0748 abort handler timed "
-					"out waiting for abort to "
-					"complete. Data: "
-					"x%x x%x x%x x%lx\n",
-					phba->brd_no, ret, id, lun, snum);
-			cmnd->host_scribble = NULL;
-			iocb->iocb_cmpl = lpfc_scsi_cmd_iocb_cleanup;
-			ret = IOCB_ERROR;
-		}
+	/* Wait for abort to complete */
+	while (lpfc_cmd->pCmd == cmnd)
+	{
+		spin_unlock_irq(phba->host->host_lock);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(LPFC_ABORT_WAIT*HZ);
+		spin_lock_irq(phba->host->host_lock);
+		if (++loop_count
+		    > (2 * phba->cfg_nodev_tmo)/LPFC_ABORT_WAIT)
+			break;
+	}
 
-		break;
+	if (lpfc_cmd->pCmd == cmnd) {
+		ret = FAILED;
+		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+				"%d:0748 abort handler timed out waiting for "
+				"abort to complete: ret %#x, ID %d, LUN %d, "
+				"snum %#lx\n",
+				phba->brd_no,  ret, cmnd->device->id,
+				cmnd->device->lun, cmnd->serial_number);
 	}
 
  out:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
-			"%d:0749 SCSI layer issued abort device "
-			"Data: x%x x%x x%x x%lx\n",
-			phba->brd_no, ret, id, lun, snum);
+			"%d:0749 SCSI layer issued abort device: ret %#x, "
+			"ID %d, LUN %d, snum %#lx\n",
+			phba->brd_no, ret, cmnd->device->id,
+			cmnd->device->lun, cmnd->serial_number);
 
-	return ret == IOCB_SUCCESS ? SUCCESS : FAILED;
+	return ret;
 }
 
 static int
@@ -919,10 +868,8 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
-	struct lpfc_scsi_buf *lpfc_cmd = NULL;
-	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
-	struct lpfc_iocbq *iocbq, *iocbqrsp = NULL;
+	struct lpfc_scsi_buf *lpfc_cmd;
+	struct lpfc_iocbq *iocbq, *iocbqrsp;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	int ret = FAILED;
@@ -946,7 +893,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 			break;
 	}
 
-	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
+	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
 	if (lpfc_cmd == NULL)
 		goto out;
 
@@ -961,7 +908,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 	iocbq = &lpfc_cmd->cur_iocbq;
 
 	/* get a buffer for this IOCB command response */
-	list_remove_head(lpfc_iocb_list, iocbqrsp, struct lpfc_iocbq, list);
+	iocbqrsp = lpfc_sli_get_iocbq(phba);
 	if (iocbqrsp == NULL)
 		goto out_free_scsi_buf;
 
@@ -1002,9 +949,10 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 	}
 
 	if (cnt) {
-		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
+		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 			"%d:0719 LUN Reset I/O flush failure: cnt x%x\n",
 			phba->brd_no, cnt);
+		ret = FAILED;
 	}
 
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
@@ -1016,7 +964,7 @@ out_free_scsi_buf:
 			phba->brd_no, lpfc_cmd->pCmd->device->id,
 			lpfc_cmd->pCmd->device->lun, ret, lpfc_cmd->status,
 			lpfc_cmd->result);
-	lpfc_free_scsi_buf(lpfc_cmd);
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
 out:
 	return ret;
 }
@@ -1044,10 +992,9 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 	int ret = FAILED, i, err_count = 0;
 	int cnt, loopcnt;
 	unsigned int midlayer_id = 0;
-	struct lpfc_scsi_buf * lpfc_cmd = NULL;
-	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
+	struct lpfc_scsi_buf * lpfc_cmd;
 
-	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
+	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
 	if (lpfc_cmd == NULL)
 		goto out;
 
@@ -1111,10 +1058,12 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 		   phba->brd_no, cnt, i);
 	}
 
-	if (!err_count)
+	if (cnt == 0)
 		ret = SUCCESS;
+	else
+		ret = FAILED;
 
-	lpfc_free_scsi_buf(lpfc_cmd);
+	lpfc_release_scsi_buf(phba, lpfc_cmd);
 	lpfc_printf_log(phba,
 			KERN_ERR,
 			LOG_FCP,
@@ -1174,7 +1123,7 @@ lpfc_slave_alloc(struct scsi_device *sde
 	}
 
 	for (i = 0; i < num_to_alloc; i++) {
-		scsi_buf = lpfc_get_scsi_buf(phba);
+		scsi_buf = lpfc_new_scsi_buf(phba);
 		if (!scsi_buf) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 					"%d:0706 Failed to allocate command "
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -870,8 +870,7 @@ lpfc_post_buffer(struct lpfc_hba * phba,
 		 int type)
 {
 	IOCB_t *icmd;
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
-	struct lpfc_iocbq *iocb = NULL;
+	struct lpfc_iocbq *iocb;
 	struct lpfc_dmabuf *mp1, *mp2;
 
 	cnt += pring->missbufcnt;
@@ -880,7 +879,7 @@ lpfc_post_buffer(struct lpfc_hba * phba,
 	while (cnt > 0) {
 		/* Allocate buffer for  command iocb */
 		spin_lock_irq(phba->host->host_lock);
-		list_remove_head(lpfc_iocb_list, iocb, struct lpfc_iocbq, list);
+		iocb = lpfc_sli_get_iocbq(phba);
 		spin_unlock_irq(phba->host->host_lock);
 		if (iocb == NULL) {
 			pring->missbufcnt = cnt;
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -224,13 +224,12 @@ lpfc_gen_req(struct lpfc_hba *phba, stru
 
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
 	IOCB_t *icmd;
-	struct lpfc_iocbq *geniocb = NULL;
+	struct lpfc_iocbq *geniocb;
 
 	/* Allocate buffer for  command iocb */
 	spin_lock_irq(phba->host->host_lock);
-	list_remove_head(lpfc_iocb_list, geniocb, struct lpfc_iocbq, list);
+	geniocb = lpfc_sli_get_iocbq(phba);
 	spin_unlock_irq(phba->host->host_lock);
 
 	if (geniocb == NULL)
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -143,6 +143,7 @@ LPFC_MBOXQ_t *lpfc_mbox_get(struct lpfc_
 int lpfc_mem_alloc(struct lpfc_hba *);
 void lpfc_mem_free(struct lpfc_hba *);
 
+struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
 void lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 int lpfc_sli_hba_setup(struct lpfc_hba *);
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -102,9 +102,8 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 		   uint16_t cmdSize,
 		   uint8_t retry, struct lpfc_nodelist * ndlp, uint32_t elscmd)
 {
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
 	struct lpfc_sli_ring *pring;
-	struct lpfc_iocbq *elsiocb = NULL;
+	struct lpfc_iocbq *elsiocb;
 	struct lpfc_dmabuf *pcmd, *prsp, *pbuflist;
 	struct ulp_bde64 *bpl;
 	IOCB_t *icmd;
@@ -114,10 +113,9 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 	if (phba->hba_state < LPFC_LINK_UP)
 		return  NULL;
 
-
 	/* Allocate buffer for  command iocb */
 	spin_lock_irq(phba->host->host_lock);
-	list_remove_head(lpfc_iocb_list, elsiocb, struct lpfc_iocbq, list);
+	elsiocb = lpfc_sli_get_iocbq(phba);
 	spin_unlock_irq(phba->host->host_lock);
 
 	if (elsiocb == NULL)
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -65,6 +65,16 @@ typedef enum _lpfc_iocb_type {
 	LPFC_ABORT_IOCB
 } lpfc_iocb_type;
 
+struct lpfc_iocbq *
+lpfc_sli_get_iocbq(struct lpfc_hba * phba)
+{
+	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
+	struct lpfc_iocbq * iocbq = NULL;
+
+	list_remove_head(lpfc_iocb_list, iocbq, struct lpfc_iocbq, list);
+	return iocbq;
+}
+
 void
 lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocbq)
 {
@@ -1055,7 +1065,6 @@ lpfc_sli_handle_slow_ring_event(struct l
 	struct lpfc_iocbq *next_iocb;
 	struct lpfc_iocbq *cmdiocbp;
 	struct lpfc_iocbq *saveq;
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
 	struct lpfc_pgp *pgp = &phba->slim2p->mbx.us.s2.port[pring->ringno];
 	uint8_t iocb_cmd_type;
 	lpfc_iocb_type type;
@@ -1097,7 +1106,6 @@ lpfc_sli_handle_slow_ring_event(struct l
 	}
 
 	rmb();
-	lpfc_iocb_list = &phba->lpfc_iocb_list;
 	while (pring->rspidx != portRspPut) {
 		/*
 		 * Build a completion list and call the appropriate handler.
@@ -1113,8 +1121,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 		 * received.
 		 */
 		entry = IOCB_ENTRY(pring->rspringaddr, pring->rspidx);
-		list_remove_head(lpfc_iocb_list, rspiocbp, struct lpfc_iocbq,
-				 list);
+		rspiocbp = lpfc_sli_get_iocbq(phba);
 		if (rspiocbp == NULL) {
 			printk(KERN_ERR "%s: out of buffers! Failing "
 			       "completion.\n", __FUNCTION__);
@@ -2407,13 +2414,12 @@ lpfc_sli_issue_abort_iotag32(struct lpfc
 			     struct lpfc_sli_ring * pring,
 			     struct lpfc_iocbq * cmdiocb)
 {
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
-	struct lpfc_iocbq *abtsiocbp = NULL;
+	struct lpfc_iocbq *abtsiocbp;
 	IOCB_t *icmd = NULL;
 	IOCB_t *iabt = NULL;
 
 	/* issue ABTS for this IOCB based on iotag */
-	list_remove_head(lpfc_iocb_list, abtsiocbp, struct lpfc_iocbq, list);
+	abtsiocbp = lpfc_sli_get_iocbq(phba);
 	if (abtsiocbp == NULL)
 		return 0;
 
@@ -2454,28 +2460,37 @@ lpfc_sli_issue_abort_iotag32(struct lpfc
 }
 
 static int
-lpfc_sli_validate_iocb_cmd(struct lpfc_scsi_buf *lpfc_cmd, uint16_t tgt_id,
-			     uint64_t lun_id, struct lpfc_iocbq *iocb,
-			     uint32_t ctx, lpfc_ctx_cmd ctx_cmd)
+lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, uint16_t tgt_id,
+			   uint64_t lun_id, uint32_t ctx,
+			   lpfc_ctx_cmd ctx_cmd)
 {
+	struct lpfc_scsi_buf *lpfc_cmd;
+	struct scsi_cmnd *cmnd;
 	int rc = 1;
 
-	if (lpfc_cmd == NULL)
+	if (!(iocbq->iocb_flag &  LPFC_IO_FCP))
+		return rc;
+
+	lpfc_cmd = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
+	cmnd = lpfc_cmd->pCmd;
+
+	if (cmnd == NULL)
 		return rc;
 
 	switch (ctx_cmd) {
 	case LPFC_CTX_LUN:
-		if ((lpfc_cmd->pCmd->device->id == tgt_id) &&
-		    (lpfc_cmd->pCmd->device->lun == lun_id))
+		if ((cmnd->device->id == tgt_id) &&
+		    (cmnd->device->lun == lun_id))
 			rc = 0;
 		break;
 	case LPFC_CTX_TGT:
-		if (lpfc_cmd->pCmd->device->id == tgt_id)
+		if (cmnd->device->id == tgt_id)
 			rc = 0;
 		break;
 	case LPFC_CTX_CTX:
-		if (iocb->iocb.ulpContext == ctx)
+		if (iocbq->iocb.ulpContext == ctx)
 			rc = 0;
+		break;
 	case LPFC_CTX_HOST:
 		rc = 0;
 		break;
@@ -2492,30 +2507,17 @@ int
 lpfc_sli_sum_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd ctx_cmd)
 {
-	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *cmd = NULL;
-	struct lpfc_scsi_buf *lpfc_cmd;
-	int sum = 0, ret_val = 0;
+	struct lpfc_iocbq *iocbq;
+	int sum, i;
 
-	/* Next check the txcmplq */
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-		cmd = &iocb->iocb;
-
-		/* Must be a FCP command */
-		if ((cmd->ulpCommand != CMD_FCP_ICMND64_CR) &&
-		    (cmd->ulpCommand != CMD_FCP_IWRITE64_CR) &&
-		    (cmd->ulpCommand != CMD_FCP_IREAD64_CR)) {
-			continue;
-		}
+	for (i = 1, sum = 0; i <= phba->sli.last_iotag; i++) {
+		iocbq = phba->sli.iocbq_lookup[i];
 
-		/* context1 MUST be a struct lpfc_scsi_buf */
-		lpfc_cmd = (struct lpfc_scsi_buf *) (iocb->context1);
-		ret_val = lpfc_sli_validate_iocb_cmd(lpfc_cmd, tgt_id, lun_id,
-						     NULL, 0, ctx_cmd);
-		if (ret_val != 0)
-			continue;
-		sum++;
+		if (lpfc_sli_validate_fcp_iocb (iocbq, tgt_id, lun_id,
+						0, ctx_cmd) == 0)
+			sum++;
 	}
+
 	return sum;
 }
 
@@ -2534,38 +2536,27 @@ lpfc_sli_abort_iocb(struct lpfc_hba *phb
 		    uint16_t tgt_id, uint64_t lun_id, uint32_t ctx,
 		    lpfc_ctx_cmd abort_cmd)
 {
-	struct lpfc_iocbq *iocb, *next_iocb;
-	struct lpfc_iocbq *abtsiocb = NULL;
-	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
+	struct lpfc_iocbq *iocbq;
+	struct lpfc_iocbq *abtsiocb;
 	IOCB_t *cmd = NULL;
-	struct lpfc_scsi_buf *lpfc_cmd;
 	int errcnt = 0, ret_val = 0;
+	int i;
 
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-		cmd = &iocb->iocb;
-
-		/* Must be a FCP command */
-		if ((cmd->ulpCommand != CMD_FCP_ICMND64_CR) &&
-		    (cmd->ulpCommand != CMD_FCP_IWRITE64_CR) &&
-		    (cmd->ulpCommand != CMD_FCP_IREAD64_CR)) {
-			continue;
-		}
+	for (i = 1; i <= phba->sli.last_iotag; i++) {
+		iocbq = phba->sli.iocbq_lookup[i];
 
-		/* context1 MUST be a struct lpfc_scsi_buf */
-		lpfc_cmd = (struct lpfc_scsi_buf *) (iocb->context1);
-		ret_val = lpfc_sli_validate_iocb_cmd(lpfc_cmd, tgt_id, lun_id,
-						     iocb, ctx, abort_cmd);
-		if (ret_val != 0)
+		if (lpfc_sli_validate_fcp_iocb (iocbq, tgt_id, lun_id,
+						0, abort_cmd) != 0)
 			continue;
 
 		/* issue ABTS for this IOCB based on iotag */
-		list_remove_head(lpfc_iocb_list, abtsiocb, struct lpfc_iocbq,
-				 list);
+		abtsiocb = lpfc_sli_get_iocbq(phba);
 		if (abtsiocb == NULL) {
 			errcnt++;
 			continue;
 		}
 
+		cmd = &iocbq->iocb;
 		abtsiocb->iocb.un.acxri.abortType = ABORT_TYPE_ABTS;
 		abtsiocb->iocb.un.acxri.abortContextTag = cmd->ulpContext;
 		abtsiocb->iocb.un.acxri.abortIoTag = cmd->ulpIoTag;
