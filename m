From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/16] lpfc 8.1.12 : Fix unlock inside list traversal
Date: Wed, 25 Apr 2007 09:52:20 -0400
Message-ID: <1177509140.23155.11.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51630 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030956AbXDYNwM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:52:12 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDqBOT006561
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:52:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix unlock inside list traversal.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:41.000000000 -0400
@@ -57,6 +57,7 @@ void lpfc_disc_start(struct lpfc_hba *);
 void lpfc_disc_flush_list(struct lpfc_hba *);
 void lpfc_disc_timeout(unsigned long);
 
+struct lpfc_nodelist *__lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi);
 struct lpfc_nodelist *lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi);
 
 int lpfc_workq_post_event(struct lpfc_hba *, void *, void *, uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:41.000000000 -0400
@@ -3272,9 +3272,7 @@ lpfc_els_timeout_handler(struct lpfc_hba
 
 		if (cmd->ulpCommand == CMD_GEN_REQUEST64_CR) {
 			struct lpfc_nodelist *ndlp;
-			spin_unlock_irq(phba->host->host_lock);
-			ndlp = lpfc_findnode_rpi(phba, cmd->ulpContext);
-			spin_lock_irq(phba->host->host_lock);
+			ndlp = __lpfc_findnode_rpi(phba, cmd->ulpContext);
 			remote_ID = ndlp->nlp_DID;
 		} else {
 			remote_ID = cmd->un.elsreq64.remoteID;
@@ -3298,6 +3296,7 @@ lpfc_els_timeout_handler(struct lpfc_hba
 void
 lpfc_els_flush_cmd(struct lpfc_hba * phba)
 {
+	LIST_HEAD(completions);
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	IOCB_t *cmd = NULL;
@@ -3319,18 +3318,9 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 			continue;
 		}
 
-		list_del(&piocb->list);
+		list_move_tail(&piocb->list, &completions);
 		pring->txq_cnt--;
 
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-
-		if (piocb->iocb_cmpl) {
-			spin_unlock_irq(phba->host->host_lock);
-			(piocb->iocb_cmpl) (phba, piocb, piocb);
-			spin_lock_irq(phba->host->host_lock);
-		} else
-			lpfc_sli_release_iocbq(phba, piocb);
 	}
 
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
@@ -3343,6 +3333,20 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
 	}
 	spin_unlock_irq(phba->host->host_lock);
+
+	while(!list_empty(&completions)) {
+		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
+		cmd = &piocb->iocb;
+		list_del(&piocb->list);
+
+		if (piocb->iocb_cmpl) {
+			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+			(piocb->iocb_cmpl) (phba, piocb, piocb);
+		} else
+			lpfc_sli_release_iocbq(phba, piocb);
+	}
+
 	return;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:41.000000000 -0400
@@ -1473,6 +1473,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba * ph
 static int
 lpfc_no_rpi(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
 {
+	LIST_HEAD(completions);
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
@@ -1501,29 +1502,29 @@ lpfc_no_rpi(struct lpfc_hba * phba, stru
 				     (phba, pring, iocb, ndlp))) {
 					/* It matches, so deque and call compl
 					   with an error */
-					list_del(&iocb->list);
+					list_move_tail(&iocb->list,
+						       &completions);
 					pring->txq_cnt--;
-					if (iocb->iocb_cmpl) {
-						icmd = &iocb->iocb;
-						icmd->ulpStatus =
-						    IOSTAT_LOCAL_REJECT;
-						icmd->un.ulpWord[4] =
-						    IOERR_SLI_ABORTED;
-						spin_unlock_irq(phba->host->
-								host_lock);
-						(iocb->iocb_cmpl) (phba,
-								   iocb, iocb);
-						spin_lock_irq(phba->host->
-							      host_lock);
-					} else
-						lpfc_sli_release_iocbq(phba,
-								       iocb);
 				}
 			}
 			spin_unlock_irq(phba->host->host_lock);
 
 		}
 	}
+
+	while (!list_empty(&completions)) {
+		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
+		list_del(&iocb->list);
+
+		if (iocb->iocb_cmpl) {
+			icmd = &iocb->iocb;
+			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+			(iocb->iocb_cmpl) (phba, iocb, iocb);
+		} else
+			lpfc_sli_release_iocbq(phba, iocb);
+	}
+
 	return 0;
 }
 
@@ -1951,11 +1952,11 @@ lpfc_disc_start(struct lpfc_hba * phba)
 static void
 lpfc_free_tx(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
 {
+	LIST_HEAD(completions);
 	struct lpfc_sli *psli;
 	IOCB_t     *icmd;
 	struct lpfc_iocbq    *iocb, *next_iocb;
 	struct lpfc_sli_ring *pring;
-	struct lpfc_dmabuf   *mp;
 
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];
@@ -1963,6 +1964,7 @@ lpfc_free_tx(struct lpfc_hba * phba, str
 	/* Error matching iocb on txq or txcmplq
 	 * First check the txq.
 	 */
+	spin_lock_irq(phba->host->host_lock);
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
 		if (iocb->context1 != ndlp) {
 			continue;
@@ -1971,9 +1973,8 @@ lpfc_free_tx(struct lpfc_hba * phba, str
 		if ((icmd->ulpCommand == CMD_ELS_REQUEST64_CR) ||
 		    (icmd->ulpCommand == CMD_XMIT_ELS_RSP64_CX)) {
 
-			list_del(&iocb->list);
+			list_move_tail(&iocb->list, &completions);
 			pring->txq_cnt--;
-			lpfc_els_free_iocb(phba, iocb);
 		}
 	}
 
@@ -1985,44 +1986,23 @@ lpfc_free_tx(struct lpfc_hba * phba, str
 		icmd = &iocb->iocb;
 		if ((icmd->ulpCommand == CMD_ELS_REQUEST64_CR) ||
 		    (icmd->ulpCommand == CMD_XMIT_ELS_RSP64_CX)) {
-
-			iocb->iocb_cmpl = NULL;
-			/* context2 = cmd, context2->next = rsp, context3 =
-			   bpl */
-			if (iocb->context2) {
-				/* Free the response IOCB before handling the
-				   command. */
-
-				mp = (struct lpfc_dmabuf *) (iocb->context2);
-				mp = list_get_first(&mp->list,
-						    struct lpfc_dmabuf,
-						    list);
-				if (mp) {
-					/* Delay before releasing rsp buffer to
-					 * give UNREG mbox a chance to take
-					 * effect.
-					 */
-					list_add(&mp->list,
-						&phba->freebufList);
-				}
-				lpfc_mbuf_free(phba,
-					       ((struct lpfc_dmabuf *)
-						iocb->context2)->virt,
-					       ((struct lpfc_dmabuf *)
-						iocb->context2)->phys);
-				kfree(iocb->context2);
-			}
-
-			if (iocb->context3) {
-				lpfc_mbuf_free(phba,
-					       ((struct lpfc_dmabuf *)
-						iocb->context3)->virt,
-					       ((struct lpfc_dmabuf *)
-						iocb->context3)->phys);
-				kfree(iocb->context3);
-			}
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
 		}
 	}
+	spin_unlock_irq(phba->host->host_lock);
+
+	while (!list_empty(&completions)) {
+		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
+		list_del(&iocb->list);
+
+		if (iocb->iocb_cmpl) {
+			icmd = &iocb->iocb;
+			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+			(iocb->iocb_cmpl) (phba, iocb, iocb);
+		} else
+			lpfc_sli_release_iocbq(phba, iocb);
+	}
 
 	return;
 }
@@ -2354,7 +2334,7 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
  * else return NULL.
  */
 struct lpfc_nodelist *
-lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi)
+__lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi)
 {
 	struct lpfc_nodelist *ndlp;
 	struct list_head * lists[]={&phba->fc_nlpunmap_list,
@@ -2364,17 +2344,25 @@ lpfc_findnode_rpi(struct lpfc_hba * phba
 				    &phba->fc_reglogin_list};
 	int i;
 
-	spin_lock_irq(phba->host->host_lock);
 	for (i = 0; i < ARRAY_SIZE(lists); i++ )
 		list_for_each_entry(ndlp, lists[i], nlp_listp)
 			if (ndlp->nlp_rpi == rpi) {
-				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
-	spin_unlock_irq(phba->host->host_lock);
 	return NULL;
 }
 
+struct lpfc_nodelist *
+lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi)
+{
+	struct lpfc_nodelist *ndlp;
+
+	spin_lock_irq(phba->host->host_lock);
+	ndlp = __lpfc_findnode_rpi(phba, rpi);
+	spin_unlock_irq(phba->host->host_lock);
+	return ndlp;
+}
+
 /*
  * This routine looks up the ndlp  lists
  * for the given WWPN. If WWPN found
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:41.000000000 -0400
@@ -170,11 +170,11 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba 
 int
 lpfc_els_abort(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
 {
+	LIST_HEAD(completions);
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *icmd;
-	int    found = 0;
+	IOCB_t *cmd;
 
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
@@ -187,45 +187,40 @@ lpfc_els_abort(struct lpfc_hba * phba, s
 	pring = &psli->ring[LPFC_ELS_RING];
 
 	/* First check the txq */
-	do {
-		found = 0;
-		spin_lock_irq(phba->host->host_lock);
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
-			/* Check to see if iocb matches the nport we are looking
-			   for */
-			if ((lpfc_check_sli_ndlp(phba, pring, iocb, ndlp))) {
-				found = 1;
-				/* It matches, so deque and call compl with an
-				   error */
-				list_del(&iocb->list);
-				pring->txq_cnt--;
-				if (iocb->iocb_cmpl) {
-					icmd = &iocb->iocb;
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
+	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
+		/* Check to see if iocb matches the nport we are looking
+		   for */
+		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp)) {
+			/* It matches, so deque and call compl with an
+			   error */
+			list_move_tail(&iocb->list, &completions);
+			pring->txq_cnt--;
 		}
-		spin_unlock_irq(phba->host->host_lock);
-	} while (found);
+	}
 
 	/* Next check the txcmplq */
-	spin_lock_irq(phba->host->host_lock);
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
 		/* Check to see if iocb matches the nport we are looking
 		   for */
-		if ((lpfc_check_sli_ndlp (phba, pring, iocb, ndlp))) {
-			icmd = &iocb->iocb;
+		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp))
 			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
-		}
 	}
 	spin_unlock_irq(phba->host->host_lock);
 
+	while (!list_empty(&completions)) {
+		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
+		cmd = &iocb->iocb;
+		list_del(&iocb->list);
+
+		if (iocb->iocb_cmpl) {
+			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+			(iocb->iocb_cmpl) (phba, iocb, iocb);
+		} else
+			lpfc_sli_release_iocbq(phba, iocb);
+	}
+
 	/* If we are delaying issuing an ELS command, cancel it */
 	if (ndlp->nlp_flag & NLP_DELAY_TMO)
 		lpfc_cancel_retry_delay_tmo(phba, ndlp);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:41.000000000 -0400
@@ -1455,8 +1455,9 @@ lpfc_sli_handle_slow_ring_event(struct l
 int
 lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
+	LIST_HEAD(completions);
 	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *icmd = NULL, *cmd = NULL;
+	IOCB_t *cmd = NULL;
 	int errcnt;
 
 	errcnt = 0;
@@ -1465,46 +1466,28 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 	 * First do the txq.
 	 */
 	spin_lock_irq(phba->host->host_lock);
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
-		list_del_init(&iocb->list);
-		if (iocb->iocb_cmpl) {
-			icmd = &iocb->iocb;
-			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			spin_unlock_irq(phba->host->host_lock);
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-			spin_lock_irq(phba->host->host_lock);
-		} else
-			lpfc_sli_release_iocbq(phba, iocb);
-	}
+	list_splice_init(&pring->txq, &completions);
 	pring->txq_cnt = 0;
-	INIT_LIST_HEAD(&(pring->txq));
 
 	/* Next issue ABTS for everything on the txcmplq */
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-		cmd = &iocb->iocb;
+	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+		lpfc_sli_issue_abort_iotag(phba, pring, iocb);
 
-		/*
-		 * Imediate abort of IOCB, deque and call compl
-		 */
+	spin_unlock_irq(phba->host->host_lock);
 
-		list_del_init(&iocb->list);
-		pring->txcmplq_cnt--;
+	while (!list_empty(&completions)) {
+		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
+		cmd = &iocb->iocb;
+		list_del(&iocb->list);
 
 		if (iocb->iocb_cmpl) {
 			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
 			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			spin_unlock_irq(phba->host->host_lock);
 			(iocb->iocb_cmpl) (phba, iocb, iocb);
-			spin_lock_irq(phba->host->host_lock);
 		} else
 			lpfc_sli_release_iocbq(phba, iocb);
 	}
 
-	INIT_LIST_HEAD(&pring->txcmplq);
-	pring->txcmplq_cnt = 0;
-	spin_unlock_irq(phba->host->host_lock);
-
 	return errcnt;
 }
 
@@ -2605,11 +2588,12 @@ lpfc_sli_queue_setup(struct lpfc_hba * p
 int
 lpfc_sli_hba_down(struct lpfc_hba * phba)
 {
+	LIST_HEAD(completions);
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
 	LPFC_MBOXQ_t *pmb;
-	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *icmd = NULL;
+	struct lpfc_iocbq *iocb;
+	IOCB_t *cmd = NULL;
 	int i;
 	unsigned long flags = 0;
 
@@ -2617,7 +2601,6 @@ lpfc_sli_hba_down(struct lpfc_hba * phba
 	lpfc_hba_down_prep(phba);
 
 	spin_lock_irqsave(phba->host->host_lock, flags);
-
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
 		pring->flag |= LPFC_DEFERRED_RING_EVENT;
@@ -2626,28 +2609,25 @@ lpfc_sli_hba_down(struct lpfc_hba * phba
 		 * Error everything on the txq since these iocbs have not been
 		 * given to the FW yet.
 		 */
+		list_splice_init(&pring->txq, &completions);
 		pring->txq_cnt = 0;
 
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
-			list_del_init(&iocb->list);
-			if (iocb->iocb_cmpl) {
-				icmd = &iocb->iocb;
-				icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-				icmd->un.ulpWord[4] = IOERR_SLI_DOWN;
-				spin_unlock_irqrestore(phba->host->host_lock,
-						       flags);
-				(iocb->iocb_cmpl) (phba, iocb, iocb);
-				spin_lock_irqsave(phba->host->host_lock, flags);
-			} else
-				lpfc_sli_release_iocbq(phba, iocb);
-		}
+	}
+	spin_unlock_irqrestore(phba->host->host_lock, flags);
 
-		INIT_LIST_HEAD(&(pring->txq));
+	while (!list_empty(&completions)) {
+		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
+		cmd = &iocb->iocb;
+		list_del(&iocb->list);
 
+		if (iocb->iocb_cmpl) {
+			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
+			(iocb->iocb_cmpl) (phba, iocb, iocb);
+		} else
+			lpfc_sli_release_iocbq(phba, iocb);
 	}
 
-	spin_unlock_irqrestore(phba->host->host_lock, flags);
-
 	/* Return any active mbox cmds */
 	del_timer_sync(&psli->mbox_tmo);
 	spin_lock_irqsave(phba->host->host_lock, flags);


