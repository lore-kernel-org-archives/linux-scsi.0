From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/16] lpfc 8.1.12 : Modify ELS abort handling to prevent
	double completion
Date: Wed, 25 Apr 2007 09:51:38 -0400
Message-ID: <1177509098.23155.9.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51538 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031003AbXDYNva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:51:30 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDpTrW006467
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:51:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Modify ELS abort handling to prevent double completion

Rework portions of ELS abort handling to prevent double completion
 - Rework ELS iotags and correct abort routine
 - Move the (badly wrong) ELS completion logic from the initial ELS
   abort request function to the ELS completion function.
 - Fixup the iocb completion handling to account for the ELS abort
   completions.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:40.000000000 -0400
@@ -66,8 +66,7 @@ int lpfc_disc_state_machine(struct lpfc_
 
 int lpfc_check_sparm(struct lpfc_hba *, struct lpfc_nodelist *,
 		     struct serv_parm *, uint32_t);
-int lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist * ndlp,
-			int);
+int lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist * ndlp);
 int lpfc_els_abort_flogi(struct lpfc_hba *);
 int lpfc_initial_flogi(struct lpfc_hba *);
 int lpfc_issue_els_plogi(struct lpfc_hba *, uint32_t, uint8_t);
@@ -162,8 +161,8 @@ int lpfc_sli_ringpostbuf_put(struct lpfc
 struct lpfc_dmabuf *lpfc_sli_ringpostbuf_get(struct lpfc_hba *,
 					     struct lpfc_sli_ring *,
 					     dma_addr_t);
-int lpfc_sli_issue_abort_iotag32(struct lpfc_hba *, struct lpfc_sli_ring *,
-				 struct lpfc_iocbq *);
+int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
+			       struct lpfc_iocbq *);
 int lpfc_sli_sum_iocb(struct lpfc_hba *, struct lpfc_sli_ring *, uint16_t,
 			  uint64_t, lpfc_ctx_cmd);
 int lpfc_sli_abort_iocb(struct lpfc_hba *, struct lpfc_sli_ring *, uint16_t,
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:40.000000000 -0400
@@ -582,24 +582,8 @@ lpfc_els_abort_flogi(struct lpfc_hba * p
 		icmd = &iocb->iocb;
 		if (icmd->ulpCommand == CMD_ELS_REQUEST64_CR) {
 			ndlp = (struct lpfc_nodelist *)(iocb->context1);
-			if (ndlp && (ndlp->nlp_DID == Fabric_DID)) {
-				list_del(&iocb->list);
-				pring->txcmplq_cnt--;
-
-				if ((icmd->un.elsreq64.bdl.ulpIoTag32)) {
-					lpfc_sli_issue_abort_iotag32
-						(phba, pring, iocb);
-				}
-				if (iocb->iocb_cmpl) {
-					icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-					icmd->un.ulpWord[4] =
-					    IOERR_SLI_ABORTED;
-					spin_unlock_irq(phba->host->host_lock);
-					(iocb->iocb_cmpl) (phba, iocb, iocb);
-					spin_lock_irq(phba->host->host_lock);
-				} else
-					lpfc_sli_release_iocbq(phba, iocb);
-			}
+			if (ndlp && (ndlp->nlp_DID == Fabric_DID))
+				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
 		}
 	}
 	spin_unlock_irq(phba->host->host_lock);
@@ -3245,7 +3229,6 @@ lpfc_els_timeout_handler(struct lpfc_hba
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	IOCB_t *cmd = NULL;
 	struct lpfc_dmabuf *pcmd;
-	struct list_head *dlp;
 	uint32_t *elscmd;
 	uint32_t els_command;
 	uint32_t timeout;
@@ -3262,7 +3245,6 @@ lpfc_els_timeout_handler(struct lpfc_hba
 	timeout = (uint32_t)(phba->fc_ratov << 1);
 
 	pring = &phba->sli.ring[LPFC_ELS_RING];
-	dlp = &pring->txcmplq;
 
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
 		cmd = &piocb->iocb;
@@ -3288,19 +3270,12 @@ lpfc_els_timeout_handler(struct lpfc_hba
 			continue;
 		}
 
-		list_del(&piocb->list);
-		pring->txcmplq_cnt--;
-
 		if (cmd->ulpCommand == CMD_GEN_REQUEST64_CR) {
 			struct lpfc_nodelist *ndlp;
 			spin_unlock_irq(phba->host->host_lock);
 			ndlp = lpfc_findnode_rpi(phba, cmd->ulpContext);
 			spin_lock_irq(phba->host->host_lock);
 			remote_ID = ndlp->nlp_DID;
-			if (cmd->un.elsreq64.bdl.ulpIoTag32) {
-				lpfc_sli_issue_abort_iotag32(phba,
-					pring, piocb);
-			}
 		} else {
 			remote_ID = cmd->un.elsreq64.remoteID;
 		}
@@ -3312,17 +3287,7 @@ lpfc_els_timeout_handler(struct lpfc_hba
 				phba->brd_no, els_command,
 				remote_ID, cmd->ulpCommand, cmd->ulpIoTag);
 
-		/*
-		 * The iocb has timed out; abort it.
-		 */
-		if (piocb->iocb_cmpl) {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			spin_unlock_irq(phba->host->host_lock);
-			(piocb->iocb_cmpl) (phba, piocb, piocb);
-			spin_lock_irq(phba->host->host_lock);
-		} else
-			lpfc_sli_release_iocbq(phba, piocb);
+		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
 	}
 	if (phba->sli.ring[LPFC_ELS_RING].txcmplq_cnt)
 		mod_timer(&phba->els_tmofunc, jiffies + HZ * timeout);
@@ -3336,9 +3301,6 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	IOCB_t *cmd = NULL;
-	struct lpfc_dmabuf *pcmd;
-	uint32_t *elscmd;
-	uint32_t els_command;
 
 	pring = &phba->sli.ring[LPFC_ELS_RING];
 	spin_lock_irq(phba->host->host_lock);
@@ -3357,10 +3319,6 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 			continue;
 		}
 
-		pcmd = (struct lpfc_dmabuf *) piocb->context2;
-		elscmd = (uint32_t *) (pcmd->virt);
-		els_command = *elscmd;
-
 		list_del(&piocb->list);
 		pring->txq_cnt--;
 
@@ -3381,22 +3339,8 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 		if (piocb->iocb_flag & LPFC_IO_LIBDFC) {
 			continue;
 		}
-		pcmd = (struct lpfc_dmabuf *) piocb->context2;
-		elscmd = (uint32_t *) (pcmd->virt);
-		els_command = *elscmd;
-
-		list_del(&piocb->list);
-		pring->txcmplq_cnt--;
 
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-
-		if (piocb->iocb_cmpl) {
-			spin_unlock_irq(phba->host->host_lock);
-			(piocb->iocb_cmpl) (phba, piocb, piocb);
-			spin_lock_irq(phba->host->host_lock);
-		} else
-			lpfc_sli_release_iocbq(phba, piocb);
+		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
 	}
 	spin_unlock_irq(phba->host->host_lock);
 	return;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:40.000000000 -0400
@@ -1596,7 +1596,7 @@ lpfc_freenode(struct lpfc_hba * phba, st
 	}
 	spin_unlock_irq(phba->host->host_lock);
 
-	lpfc_els_abort(phba,ndlp,0);
+	lpfc_els_abort(phba,ndlp);
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~NLP_DELAY_TMO;
 	spin_unlock_irq(phba->host->host_lock);
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:40.000000000 -0400
@@ -168,8 +168,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba 
  * routine effectively results in a "software abort".
  */
 int
-lpfc_els_abort(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp,
-	int send_abts)
+lpfc_els_abort(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
 {
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
@@ -215,48 +214,17 @@ lpfc_els_abort(struct lpfc_hba * phba, s
 		spin_unlock_irq(phba->host->host_lock);
 	} while (found);
 
-	/* Everything on txcmplq will be returned by firmware
-	 * with a no rpi / linkdown / abort error.  For ring 0,
-	 * ELS discovery, we want to get rid of it right here.
-	 */
 	/* Next check the txcmplq */
-	do {
-		found = 0;
-		spin_lock_irq(phba->host->host_lock);
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq,
-					 list) {
-			/* Check to see if iocb matches the nport we are looking
-			   for */
-			if ((lpfc_check_sli_ndlp (phba, pring, iocb, ndlp))) {
-				found = 1;
-				/* It matches, so deque and call compl with an
-				   error */
-				list_del(&iocb->list);
-				pring->txcmplq_cnt--;
-
-				icmd = &iocb->iocb;
-				/* If the driver is completing an ELS
-				 * command early, flush it out of the firmware.
-				 */
-				if (send_abts &&
-				   (icmd->ulpCommand == CMD_ELS_REQUEST64_CR) &&
-				   (icmd->un.elsreq64.bdl.ulpIoTag32)) {
-					lpfc_sli_issue_abort_iotag32(phba,
-							     pring, iocb);
-				}
-				if (iocb->iocb_cmpl) {
-					icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-					icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-					spin_unlock_irq(phba->host->host_lock);
-					(iocb->iocb_cmpl) (phba, iocb, iocb);
-					spin_lock_irq(phba->host->host_lock);
-				} else
-					lpfc_sli_release_iocbq(phba, iocb);
-				break;
-			}
+	spin_lock_irq(phba->host->host_lock);
+	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
+		/* Check to see if iocb matches the nport we are looking
+		   for */
+		if ((lpfc_check_sli_ndlp (phba, pring, iocb, ndlp))) {
+			icmd = &iocb->iocb;
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
 		}
-		spin_unlock_irq(phba->host->host_lock);
-	} while(found);
+	}
+	spin_unlock_irq(phba->host->host_lock);
 
 	/* If we are delaying issuing an ELS command, cancel it */
 	if (ndlp->nlp_flag & NLP_DELAY_TMO)
@@ -404,7 +372,7 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 	 */
 	if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) {
 		/* software abort outstanding PLOGI */
-		lpfc_els_abort(phba, ndlp, 1);
+		lpfc_els_abort(phba, ndlp);
 	}
 
 	lpfc_els_rsp_acc(phba, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox, 0);
@@ -697,7 +665,7 @@ lpfc_rcv_logo_plogi_issue(struct lpfc_hb
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* software abort outstanding PLOGI */
-	lpfc_els_abort(phba, ndlp, 1);
+	lpfc_els_abort(phba, ndlp);
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
@@ -712,7 +680,7 @@ lpfc_rcv_els_plogi_issue(struct lpfc_hba
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* software abort outstanding PLOGI */
-	lpfc_els_abort(phba, ndlp, 1);
+	lpfc_els_abort(phba, ndlp);
 
 	if (evt == NLP_EVT_RCV_LOGO) {
 		lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
@@ -855,7 +823,7 @@ lpfc_device_rm_plogi_issue(struct lpfc_h
 	}
 	else {
 		/* software abort outstanding PLOGI */
-		lpfc_els_abort(phba, ndlp, 1);
+		lpfc_els_abort(phba, ndlp);
 
 		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		return NLP_STE_FREED_NODE;
@@ -868,7 +836,7 @@ lpfc_device_recov_plogi_issue(struct lpf
 			    uint32_t evt)
 {
 	/* software abort outstanding PLOGI */
-	lpfc_els_abort(phba, ndlp, 1);
+	lpfc_els_abort(phba, ndlp);
 
 	ndlp->nlp_prev_state = NLP_STE_PLOGI_ISSUE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
@@ -888,7 +856,7 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_h
 	struct lpfc_iocbq *cmdiocb;
 
 	/* software abort outstanding ADISC */
-	lpfc_els_abort(phba, ndlp, 1);
+	lpfc_els_abort(phba, ndlp);
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
@@ -926,7 +894,7 @@ lpfc_rcv_logo_adisc_issue(struct lpfc_hb
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* software abort outstanding ADISC */
-	lpfc_els_abort(phba, ndlp, 0);
+	lpfc_els_abort(phba, ndlp);
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
@@ -1016,7 +984,7 @@ lpfc_device_rm_adisc_issue(struct lpfc_h
 	}
 	else {
 		/* software abort outstanding ADISC */
-		lpfc_els_abort(phba, ndlp, 1);
+		lpfc_els_abort(phba, ndlp);
 
 		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		return NLP_STE_FREED_NODE;
@@ -1029,7 +997,7 @@ lpfc_device_recov_adisc_issue(struct lpf
 			    uint32_t evt)
 {
 	/* software abort outstanding ADISC */
-	lpfc_els_abort(phba, ndlp, 1);
+	lpfc_els_abort(phba, ndlp);
 
 	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
@@ -1230,7 +1198,7 @@ lpfc_rcv_logo_prli_issue(struct lpfc_hba
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* Software abort outstanding PRLI before sending acc */
-	lpfc_els_abort(phba, ndlp, 1);
+	lpfc_els_abort(phba, ndlp);
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
@@ -1330,7 +1298,7 @@ lpfc_device_rm_prli_issue(struct lpfc_hb
 	}
 	else {
 		/* software abort outstanding PLOGI */
-		lpfc_els_abort(phba, ndlp, 1);
+		lpfc_els_abort(phba, ndlp);
 
 		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		return NLP_STE_FREED_NODE;
@@ -1359,7 +1327,7 @@ lpfc_device_recov_prli_issue(struct lpfc
 			   struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
 	/* software abort outstanding PRLI */
-	lpfc_els_abort(phba, ndlp, 1);
+	lpfc_els_abort(phba, ndlp);
 
 	ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:40.000000000 -0400
@@ -816,6 +816,14 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 			 * All other are passed to the completion callback.
 			 */
 			if (pring->ringno == LPFC_ELS_RING) {
+				if (cmdiocbp->iocb_flag & LPFC_DRIVER_ABORTED) {
+					cmdiocbp->iocb_flag &=
+						~LPFC_DRIVER_ABORTED;
+					saveq->iocb.ulpStatus =
+						IOSTAT_LOCAL_REJECT;
+					saveq->iocb.un.ulpWord[4] =
+						IOERR_SLI_ABORTED;
+				}
 				spin_unlock_irqrestore(phba->host->host_lock,
 						       iflag);
 				(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
@@ -2728,85 +2736,81 @@ lpfc_sli_ringpostbuf_get(struct lpfc_hba
 }
 
 static void
-lpfc_sli_abort_elsreq_cmpl(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
-			   struct lpfc_iocbq * rspiocb)
+lpfc_sli_abort_els_cmpl(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
+			struct lpfc_iocbq * rspiocb)
 {
-	struct lpfc_dmabuf *buf_ptr, *buf_ptr1;
-	/* Free the resources associated with the ELS_REQUEST64 IOCB the driver
-	 * just aborted.
-	 * In this case, context2  = cmd,  context2->next = rsp, context3 = bpl
-	 */
-	if (cmdiocb->context2) {
-		buf_ptr1 = (struct lpfc_dmabuf *) cmdiocb->context2;
-
-		/* Free the response IOCB before completing the abort
-		   command.  */
-		buf_ptr = NULL;
-		list_remove_head((&buf_ptr1->list), buf_ptr,
-				 struct lpfc_dmabuf, list);
-		if (buf_ptr) {
-			lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
-			kfree(buf_ptr);
-		}
-		lpfc_mbuf_free(phba, buf_ptr1->virt, buf_ptr1->phys);
-		kfree(buf_ptr1);
-	}
-
-	if (cmdiocb->context3) {
-		buf_ptr = (struct lpfc_dmabuf *) cmdiocb->context3;
-		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
-		kfree(buf_ptr);
-	}
-
+	spin_lock_irq(phba->host->host_lock);
 	lpfc_sli_release_iocbq(phba, cmdiocb);
+	spin_unlock_irq(phba->host->host_lock);
 	return;
 }
 
 int
-lpfc_sli_issue_abort_iotag32(struct lpfc_hba * phba,
-			     struct lpfc_sli_ring * pring,
-			     struct lpfc_iocbq * cmdiocb)
+lpfc_sli_issue_abort_iotag(struct lpfc_hba * phba,
+			   struct lpfc_sli_ring * pring,
+			   struct lpfc_iocbq * cmdiocb)
 {
 	struct lpfc_iocbq *abtsiocbp;
 	IOCB_t *icmd = NULL;
 	IOCB_t *iabt = NULL;
+	int retval = IOCB_ERROR;
+
+	/* There are certain command types we don't want
+	 * to abort.
+	 */
+	icmd = &cmdiocb->iocb;
+	if ((icmd->ulpCommand == CMD_ABORT_XRI_CN) ||
+	    (icmd->ulpCommand == CMD_CLOSE_XRI_CN))
+		return 0;
+
+	/* If we're unloading, interrupts are disabled so we
+	 * need to cleanup the iocb here.
+	 */
+	if (phba->fc_flag & FC_UNLOADING)
+		goto abort_iotag_exit;
 
 	/* issue ABTS for this IOCB based on iotag */
 	abtsiocbp = lpfc_sli_get_iocbq(phba);
 	if (abtsiocbp == NULL)
 		return 0;
 
+	/* This signals the response to set the correct status
+	 * before calling the completion handler.
+	 */
+	cmdiocb->iocb_flag |= LPFC_DRIVER_ABORTED;
+
 	iabt = &abtsiocbp->iocb;
-	icmd = &cmdiocb->iocb;
-	switch (icmd->ulpCommand) {
-	case CMD_ELS_REQUEST64_CR:
-		/* Even though we abort the ELS command, the firmware may access
-		 * the BPL or other resources before it processes our
-		 * ABORT_MXRI64. Thus we must delay reusing the cmdiocb
-		 * resources till the actual abort request completes.
-		 */
-		abtsiocbp->context1 = (void *)((unsigned long)icmd->ulpCommand);
-		abtsiocbp->context2 = cmdiocb->context2;
-		abtsiocbp->context3 = cmdiocb->context3;
-		cmdiocb->context2 = NULL;
-		cmdiocb->context3 = NULL;
-		abtsiocbp->iocb_cmpl = lpfc_sli_abort_elsreq_cmpl;
-		break;
-	default:
-		lpfc_sli_release_iocbq(phba, abtsiocbp);
-		return 0;
-	}
+	iabt->un.acxri.abortType = ABORT_TYPE_ABTS;
+	iabt->un.acxri.abortContextTag = icmd->ulpContext;
+	iabt->un.acxri.abortIoTag = icmd->ulpIoTag;
+	iabt->ulpLe = 1;
+	iabt->ulpClass = icmd->ulpClass;
 
-	iabt->un.amxri.abortType = ABORT_TYPE_ABTS;
-	iabt->un.amxri.iotag32 = icmd->un.elsreq64.bdl.ulpIoTag32;
+	if (phba->hba_state >= LPFC_LINK_UP)
+		iabt->ulpCommand = CMD_ABORT_XRI_CN;
+	else
+		iabt->ulpCommand = CMD_CLOSE_XRI_CN;
 
-	iabt->ulpLe = 1;
-	iabt->ulpClass = CLASS3;
-	iabt->ulpCommand = CMD_ABORT_MXRI64_CN;
+	abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
+	retval = lpfc_sli_issue_iocb(phba, pring, abtsiocbp, 0);
 
-	if (lpfc_sli_issue_iocb(phba, pring, abtsiocbp, 0) == IOCB_ERROR) {
-		lpfc_sli_release_iocbq(phba, abtsiocbp);
-		return 0;
+abort_iotag_exit:
+
+	/* If we could not issue an abort dequeue the iocb and handle
+	 * the completion here.
+	 */
+	if (retval == IOCB_ERROR) {
+		list_del(&cmdiocb->list);
+		pring->txcmplq_cnt--;
+
+		if (cmdiocb->iocb_cmpl) {
+			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+			spin_unlock_irq(phba->host->host_lock);
+			(cmdiocb->iocb_cmpl) (phba, cmdiocb, cmdiocb);
+			spin_lock_irq(phba->host->host_lock);
+		} else
+			lpfc_sli_release_iocbq(phba, cmdiocb);
 	}
 
 	return 1;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2007-04-24 11:12:40.000000000 -0400
@@ -39,9 +39,10 @@ struct lpfc_iocbq {
 	IOCB_t iocb;		/* IOCB cmd */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	uint8_t iocb_flag;
-#define LPFC_IO_LIBDFC	1	/* libdfc iocb */
-#define LPFC_IO_WAKE	2	/* High Priority Queue signal flag */
-#define LPFC_IO_FCP	4	/* FCP command -- iocbq in scsi_buf */
+#define LPFC_IO_LIBDFC		1	/* libdfc iocb */
+#define LPFC_IO_WAKE		2	/* High Priority Queue signal flag */
+#define LPFC_IO_FCP		4	/* FCP command -- iocbq in scsi_buf */
+#define LPFC_DRIVER_ABORTED	8	/* driver aborted this request */
 
 	uint8_t abort_count;
 	uint8_t rsvd2;


