From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 03/17] lpfc: Handle XRI_ABORTED_CQE in soft IRQ
Date: Thu,  9 Nov 2017 17:08:20 -0800
Message-ID: <20171110010834.4542-4-jsmart2021@gmail.com>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:56235 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755472AbdKJBIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 20:08:47 -0500
Received: by mail-qt0-f196.google.com with SMTP id v41so10030538qtv.12
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 17:08:46 -0800 (PST)
In-Reply-To: <20171110010834.4542-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

XRI_ABORTED_CQE completions were not being handled in the fast path.
They were being queued and deferred to the lpfc worker thread
for processing. This is an artifact of the driver design prior
to moving queue processing out of the isr and into a workq
element. Now that queue processing is already in a deferred context,
remove this artifact and process them directly.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc.h         |  1 -
 drivers/scsi/lpfc/lpfc_hbadisc.c |  2 -
 drivers/scsi/lpfc/lpfc_init.c    |  8 ----
 drivers/scsi/lpfc/lpfc_sli.c     | 97 +++++++++++++++-------------------------
 drivers/scsi/lpfc/lpfc_sli4.h    |  2 -
 5 files changed, 35 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 231302273257..7219b6ce5dc7 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -705,7 +705,6 @@ struct lpfc_hba {
 					 * capability
 					 */
 #define HBA_NVME_IOQ_FLUSH      0x80000 /* NVME IO queues flushed. */
-#define NVME_XRI_ABORT_EVENT	0x100000
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d9a03beb76a4..3468257bda02 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -640,8 +640,6 @@ lpfc_work_done(struct lpfc_hba *phba)
 			lpfc_handle_rrq_active(phba);
 		if (phba->hba_flag & FCP_XRI_ABORT_EVENT)
 			lpfc_sli4_fcp_xri_abort_event_proc(phba);
-		if (phba->hba_flag & NVME_XRI_ABORT_EVENT)
-			lpfc_sli4_nvme_xri_abort_event_proc(phba);
 		if (phba->hba_flag & ELS_XRI_ABORT_EVENT)
 			lpfc_sli4_els_xri_abort_event_proc(phba);
 		if (phba->hba_flag & ASYNC_EVENT)
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 52c039e9f4a4..745aff753396 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5954,9 +5954,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_io_wait_list);
-
-		/* Fast-path XRI aborted CQ Event work queue list */
-		INIT_LIST_HEAD(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue);
 	}
 
 	/* This abort list used by worker thread */
@@ -9199,11 +9196,6 @@ lpfc_sli4_cq_event_release_all(struct lpfc_hba *phba)
 	/* Pending ELS XRI abort events */
 	list_splice_init(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
 			 &cqelist);
-	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
-		/* Pending NVME XRI abort events */
-		list_splice_init(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue,
-				 &cqelist);
-	}
 	/* Pending asynnc events */
 	list_splice_init(&phba->sli4_hba.sp_asynce_work_queue,
 			 &cqelist);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2ad444ce7529..4b76db19ef73 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12318,41 +12318,6 @@ void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_nvme_xri_abort_event_proc - Process nvme xri abort event
- * @phba: pointer to lpfc hba data structure.
- *
- * This routine is invoked by the worker thread to process all the pending
- * SLI4 NVME abort XRI events.
- **/
-void lpfc_sli4_nvme_xri_abort_event_proc(struct lpfc_hba *phba)
-{
-	struct lpfc_cq_event *cq_event;
-
-	/* First, declare the fcp xri abort event has been handled */
-	spin_lock_irq(&phba->hbalock);
-	phba->hba_flag &= ~NVME_XRI_ABORT_EVENT;
-	spin_unlock_irq(&phba->hbalock);
-	/* Now, handle all the fcp xri abort events */
-	while (!list_empty(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue)) {
-		/* Get the first event from the head of the event queue */
-		spin_lock_irq(&phba->hbalock);
-		list_remove_head(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue,
-				 cq_event, struct lpfc_cq_event, list);
-		spin_unlock_irq(&phba->hbalock);
-		/* Notify aborted XRI for NVME work queue */
-		if (phba->nvmet_support) {
-			lpfc_sli4_nvmet_xri_aborted(phba,
-						    &cq_event->cqe.wcqe_axri);
-		} else {
-			lpfc_sli4_nvme_xri_aborted(phba,
-						   &cq_event->cqe.wcqe_axri);
-		}
-		/* Free the event processed back to the free pool */
-		lpfc_sli4_cq_event_release(phba, cq_event);
-	}
-}
-
-/**
  * lpfc_sli4_els_xri_abort_event_proc - Process els xri abort event
  * @phba: pointer to lpfc hba data structure.
  *
@@ -12548,6 +12513,24 @@ lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 	return irspiocbq;
 }
 
+inline struct lpfc_cq_event *
+lpfc_cq_event_setup(struct lpfc_hba *phba, void *entry, int size)
+{
+	struct lpfc_cq_event *cq_event;
+
+	/* Allocate a new internal CQ_EVENT entry */
+	cq_event = lpfc_sli4_cq_event_alloc(phba);
+	if (!cq_event) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0602 Failed to alloc CQ_EVENT entry\n");
+		return NULL;
+	}
+
+	/* Move the CQE into the event */
+	memcpy(&cq_event->cqe, entry, size);
+	return cq_event;
+}
+
 /**
  * lpfc_sli4_sp_handle_async_event - Handle an asynchroous event
  * @phba: Pointer to HBA context object.
@@ -12569,16 +12552,9 @@ lpfc_sli4_sp_handle_async_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
 			"word2:x%x, word3:x%x\n", mcqe->word0,
 			mcqe->mcqe_tag0, mcqe->mcqe_tag1, mcqe->trailer);
 
-	/* Allocate a new internal CQ_EVENT entry */
-	cq_event = lpfc_sli4_cq_event_alloc(phba);
-	if (!cq_event) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0394 Failed to allocate CQ_EVENT entry\n");
+	cq_event = lpfc_cq_event_setup(phba, mcqe, sizeof(struct lpfc_mcqe));
+	if (!cq_event)
 		return false;
-	}
-
-	/* Move the CQE into an asynchronous event entry */
-	memcpy(&cq_event->cqe, mcqe, sizeof(struct lpfc_mcqe));
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	list_add_tail(&cq_event->list, &phba->sli4_hba.sp_asynce_work_queue);
 	/* Set the async event flag */
@@ -12824,18 +12800,12 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 	struct lpfc_cq_event *cq_event;
 	unsigned long iflags;
 
-	/* Allocate a new internal CQ_EVENT entry */
-	cq_event = lpfc_sli4_cq_event_alloc(phba);
-	if (!cq_event) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0602 Failed to allocate CQ_EVENT entry\n");
-		return false;
-	}
-
-	/* Move the CQE into the proper xri abort event list */
-	memcpy(&cq_event->cqe, wcqe, sizeof(struct sli4_wcqe_xri_aborted));
 	switch (cq->subtype) {
 	case LPFC_FCP:
+		cq_event = lpfc_cq_event_setup(
+			phba, wcqe, sizeof(struct sli4_wcqe_xri_aborted));
+		if (!cq_event)
+			return false;
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		list_add_tail(&cq_event->list,
 			      &phba->sli4_hba.sp_fcp_xri_aborted_work_queue);
@@ -12845,6 +12815,10 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 		workposted = true;
 		break;
 	case LPFC_ELS:
+		cq_event = lpfc_cq_event_setup(
+			phba, wcqe, sizeof(struct sli4_wcqe_xri_aborted));
+		if (!cq_event)
+			return false;
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		list_add_tail(&cq_event->list,
 			      &phba->sli4_hba.sp_els_xri_aborted_work_queue);
@@ -12854,13 +12828,13 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 		workposted = true;
 		break;
 	case LPFC_NVME:
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		list_add_tail(&cq_event->list,
-			      &phba->sli4_hba.sp_nvme_xri_aborted_work_queue);
-		/* Set the nvme xri abort event flag */
-		phba->hba_flag |= NVME_XRI_ABORT_EVENT;
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-		workposted = true;
+		/* Notify aborted XRI for NVME work queue */
+		if (phba->nvmet_support)
+			lpfc_sli4_nvmet_xri_aborted(phba, wcqe);
+		else
+			lpfc_sli4_nvme_xri_aborted(phba, wcqe);
+
+		workposted = false;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -12868,7 +12842,6 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 				"%08x %08x %08x %08x\n",
 				cq->subtype, wcqe->word0, wcqe->parameter,
 				wcqe->word2, wcqe->word3);
-		lpfc_sli4_cq_event_release(phba, cq_event);
 		workposted = false;
 		break;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 301ce46d2d70..da302bfb0223 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -672,7 +672,6 @@ struct lpfc_sli4_hba {
 	struct list_head sp_asynce_work_queue;
 	struct list_head sp_fcp_xri_aborted_work_queue;
 	struct list_head sp_els_xri_aborted_work_queue;
-	struct list_head sp_nvme_xri_aborted_work_queue;
 	struct list_head sp_unsol_work_queue;
 	struct lpfc_sli4_link link_state;
 	struct lpfc_sli4_lnk_info lnk_info;
@@ -824,7 +823,6 @@ void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *);
 int lpfc_sli4_resume_rpi(struct lpfc_nodelist *,
 			void (*)(struct lpfc_hba *, LPFC_MBOXQ_t *), void *);
 void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *);
-void lpfc_sli4_nvme_xri_abort_event_proc(struct lpfc_hba *phba);
 void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *);
 void lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *,
 			       struct sli4_wcqe_xri_aborted *);
-- 
2.13.1
