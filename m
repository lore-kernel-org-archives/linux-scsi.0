From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/3] lpfc 8.1.9 : Misc Bug Fixes
Date: Thu, 17 Aug 2006 11:57:58 -0400
Message-ID: <1155830278.24351.11.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65453 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932547AbWHQP5t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 11:57:49 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7HFvlEr014565
	for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2006 08:57:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Misc Bug Fixes:
- Cap MBX_DOWN_LINK command timeout to 60 seconds
- Fix double free of ndlp object
- Don't free mbox structures on error. The completion handlers expect to do so.
- Clear host attention work items when going offline
- Fixed discovery issues in multi-initiator environments.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -222,7 +222,7 @@ lpfc_issue_lip(struct Scsi_Host *host)
 	pmboxq->mb.mbxCommand = MBX_DOWN_LINK;
 	pmboxq->mb.mbxOwner = OWN_HOST;
 
-	mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+	mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq, LPFC_MBOX_TMO * 2);
 
 	if ((mbxstatus == MBX_SUCCESS) && (pmboxq->mb.mbxStatus == 0)) {
 		memset((void *)pmboxq, 0, sizeof (LPFC_MBOXQ_t));
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1848,9 +1848,12 @@ static void
 lpfc_cmpl_els_acc(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
 		  struct lpfc_iocbq * rspiocb)
 {
+	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	LPFC_MBOXQ_t *mbox = NULL;
 
+	irsp = &rspiocb->iocb;
+
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	if (cmdiocb->context_un.mbox)
 		mbox = cmdiocb->context_un.mbox;
@@ -1893,9 +1896,15 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 			mempool_free( mbox, phba->mbox_mem_pool);
 		} else {
 			mempool_free( mbox, phba->mbox_mem_pool);
-			if (ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
-				lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-				ndlp = NULL;
+			/* Do not call NO_LIST for lpfc_els_abort'ed ELS cmds */
+			if (!((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
+			      ((irsp->un.ulpWord[4] == IOERR_SLI_ABORTED) ||
+			       (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
+			       (irsp->un.ulpWord[4] == IOERR_SLI_DOWN)))) {
+				if (ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
+					lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+					ndlp = NULL;
+				}
 			}
 		}
 	}
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1557,6 +1557,8 @@ lpfc_freenode(struct lpfc_hba * phba, st
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		}
 	}
+
+	spin_lock_irq(phba->host->host_lock);
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
 		if ((mb->mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
@@ -1569,6 +1571,7 @@ lpfc_freenode(struct lpfc_hba * phba, st
 			mempool_free(mb, phba->mbox_mem_pool);
 		}
 	}
+	spin_unlock_irq(phba->host->host_lock);
 
 	lpfc_els_abort(phba,ndlp,0);
 	spin_lock_irq(phba->host->host_lock);
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -387,7 +387,8 @@ lpfc_config_port_post(struct lpfc_hba * 
 
 	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-	if (lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT) != MBX_SUCCESS) {
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	if (rc != MBX_SUCCESS) {
 		lpfc_printf_log(phba,
 				KERN_ERR,
 				LOG_INIT,
@@ -404,7 +405,8 @@ lpfc_config_port_post(struct lpfc_hba * 
 		readl(phba->HAregaddr); /* flush */
 
 		phba->hba_state = LPFC_HBA_ERROR;
-		mempool_free(pmb, phba->mbox_mem_pool);
+		if (rc != MBX_BUSY)
+			mempool_free(pmb, phba->mbox_mem_pool);
 		return -EIO;
 	}
 	/* MBOX buffer will be freed in mbox compl */
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1381,6 +1381,7 @@ lpfc_offline(struct lpfc_hba * phba)
 	/* stop all timers associated with this hba */
 	lpfc_stop_timer(phba);
 	phba->work_hba_events = 0;
+	phba->work_ha = 0;
 
 	lpfc_printf_log(phba,
 		       KERN_WARNING,
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -393,6 +393,20 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 	mbox->context2  = ndlp;
 	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
 
+	/*
+	 * If there is an outstanding PLOGI issued, abort it before
+	 * sending ACC rsp for received PLOGI. If pending plogi
+	 * is not canceled here, the plogi will be rejected by
+	 * remote port and will be retried. On a configuration with
+	 * single discovery thread, this will cause a huge delay in
+	 * discovery. Also this will cause multiple state machines
+	 * running in parallel for this node.
+	 */
+	if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) {
+		/* software abort outstanding PLOGI */
+		lpfc_els_abort(phba, ndlp, 1);
+	}
+
 	lpfc_els_rsp_acc(phba, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox, 0);
 	return 1;
 
@@ -1601,7 +1615,13 @@ lpfc_rcv_padisc_npr_node(struct lpfc_hba
 
 	lpfc_rcv_padisc(phba, ndlp, cmdiocb);
 
-	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
+	/*
+	 * Do not start discovery if discovery is about to start
+	 * or discovery in progress for this node. Starting discovery
+	 * here will affect the counting of discovery threads.
+	 */
+	if ((!(ndlp->nlp_flag & NLP_DELAY_TMO)) &&
+		(ndlp->nlp_flag & NLP_NPR_2B_DISC)){
 		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;


