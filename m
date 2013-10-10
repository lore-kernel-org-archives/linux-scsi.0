From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/8] lpfc 8.3.43: Fixed invalid mailbox timeouts
Date: Thu, 10 Oct 2013 12:21:30 -0400
Message-ID: <1381422090.20248.16.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:49060 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3JJQVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:21:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed invalid mailbox timeouts


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:28.940650536 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:35.740650691 -0400
@@ -71,6 +71,8 @@ static int lpfc_sli4_post_els_sgl_list(s
 				       int);
 static void lpfc_sli4_hba_handle_eqe(struct lpfc_hba *, struct lpfc_eqe *,
 			uint32_t);
+static bool lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba);
+static bool lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba);
 
 static IOCB_t *
 lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
@@ -6566,6 +6568,108 @@ lpfc_mbox_timeout(unsigned long ptr)
 	return;
 }
 
+/**
+ * lpfc_sli4_mbox_completions_pending - check to see if any mailbox completions
+ *                                    are pending
+ * @phba: Pointer to HBA context object.
+ *
+ * This function checks if any mailbox completions are present on the mailbox
+ * completion queue.
+ **/
+bool
+lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
+{
+
+	uint32_t idx;
+	struct lpfc_queue *mcq;
+	struct lpfc_mcqe *mcqe;
+	bool pending_completions = false;
+
+	if (unlikely(!phba) || (phba->sli_rev != LPFC_SLI_REV4))
+		return false;
+
+	/* Check for completions on mailbox completion queue */
+
+	mcq = phba->sli4_hba.mbx_cq;
+	idx = mcq->hba_index;
+	while (bf_get_le32(lpfc_cqe_valid, mcq->qe[idx].cqe)) {
+		mcqe = (struct lpfc_mcqe *)mcq->qe[idx].cqe;
+		if (bf_get_le32(lpfc_trailer_completed, mcqe) &&
+		    (!bf_get_le32(lpfc_trailer_async, mcqe))) {
+			pending_completions = true;
+			break;
+		}
+		idx = (idx + 1) % mcq->entry_count;
+		if (mcq->hba_index == idx)
+			break;
+	}
+	return pending_completions;
+
+}
+
+/**
+ * lpfc_sli4_process_missed_mbox_completions - process mbox completions
+ *					      that were missed.
+ * @phba: Pointer to HBA context object.
+ *
+ * For sli4, it is possible to miss an interrupt. As such mbox completions
+ * maybe missed causing erroneous mailbox timeouts to occur. This function
+ * checks to see if mbox completions are on the mailbox completion queue
+ * and will process all the completions associated with the eq for the
+ * mailbox completion queue.
+ **/
+bool
+lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
+{
+
+	uint32_t eqidx;
+	struct lpfc_queue *fpeq = NULL;
+	struct lpfc_eqe *eqe;
+	bool mbox_pending;
+
+	if (unlikely(!phba) || (phba->sli_rev != LPFC_SLI_REV4))
+		return false;
+
+	/* Find the eq associated with the mcq */
+
+	if (phba->sli4_hba.hba_eq)
+		for (eqidx = 0; eqidx < phba->cfg_fcp_io_channel; eqidx++)
+			if (phba->sli4_hba.hba_eq[eqidx]->queue_id ==
+			    phba->sli4_hba.mbx_cq->assoc_qid) {
+				fpeq = phba->sli4_hba.hba_eq[eqidx];
+				break;
+			}
+	if (!fpeq)
+		return false;
+
+	/* Turn off interrupts from this EQ */
+
+	lpfc_sli4_eq_clr_intr(fpeq);
+
+	/* Check to see if a mbox completion is pending */
+
+	mbox_pending = lpfc_sli4_mbox_completions_pending(phba);
+
+	/*
+	 * If a mbox completion is pending, process all the events on EQ
+	 * associated with the mbox completion queue (this could include
+	 * mailbox commands, async events, els commands, receive queue data
+	 * and fcp commands)
+	 */
+
+	if (mbox_pending)
+		while ((eqe = lpfc_sli4_eq_get(fpeq))) {
+			lpfc_sli4_hba_handle_eqe(phba, eqe, eqidx);
+			fpeq->EQ_processed++;
+		}
+
+	/* Always clear and re-arm the EQ */
+
+	lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
+
+	return mbox_pending;
+
+}
 
 /**
  * lpfc_mbox_timeout_handler - Worker thread function to handle mailbox timeout
@@ -6583,6 +6687,10 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 
+	/* If the mailbox completed, process the completion and return */
+	if (lpfc_sli4_process_missed_mbox_completions(phba))
+		return;
+
 	/* Check the pmbox pointer first.  There is a race condition
 	 * between the mbox timeout handler getting executed in the
 	 * worklist and the mailbox actually completing. When this
@@ -7077,6 +7185,10 @@ lpfc_sli4_async_mbox_block(struct lpfc_h
 						1000) + jiffies;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Make sure the mailbox is really active */
+	if (timeout)
+		lpfc_sli4_process_missed_mbox_completions(phba);
+
 	/* Wait for the outstnading mailbox command to complete */
 	while (phba->sli.mbox_active) {
 		/* Check active mailbox complete status every 2ms */



