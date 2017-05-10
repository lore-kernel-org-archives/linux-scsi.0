From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 12/15] lpfc: Cleanup entry_repost settings on SLI4 queues
Date: Wed, 10 May 2017 12:07:10 -0700
Message-ID: <20170510190713.30171-13-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34263 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754038AbdEJTHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:38 -0400
Received: by mail-qk0-f194.google.com with SMTP id u75so726615qka.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:37 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Too many work items being processed in IRQ context take a lot
of CPU time and cause problems.

With a recent change, we get out of the ISR after hitting entry_repost
work items on a queue. However, the actual values for entry repost are
still high. EQ is 128 and CQ is 128, this could translate into
processing 128 * 128 (16384) work items under IRQ context.

Set entry_repost in the actual queue creation routine now.
Limit EQ repost to 8 and CQ repost to 64 to further limit the amount
of time spent in the IRQ.

Fix fof IRQ routines as well.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  3 --
 drivers/scsi/lpfc/lpfc_sli.c  | 64 +++++++++++--------------------------------
 drivers/scsi/lpfc/lpfc_sli4.h |  8 ++++--
 3 files changed, 21 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 472117eb9257..9f6c7e71814b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8733,9 +8733,6 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		goto out_destroy;
 	}
 
-	lpfc_rq_adjust_repost(phba, phba->sli4_hba.hdr_rq, LPFC_ELS_HBQ);
-	lpfc_rq_adjust_repost(phba, phba->sli4_hba.dat_rq, LPFC_ELS_HBQ);
-
 	rc = lpfc_rq_create(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq,
 			    phba->sli4_hba.els_cq, LPFC_USOL);
 	if (rc) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c8f597f4d49a..903c06ff828a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6978,11 +6978,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 			rqbp->entry_count = LPFC_NVMET_RQE_DEF_COUNT;
 			rqbp->buffer_count = 0;
 
-			phba->sli4_hba.nvmet_mrq_hdr[i]->entry_repost =
-				LPFC_QUEUE_MAX_REPOST;
-			phba->sli4_hba.nvmet_mrq_data[i]->entry_repost =
-				LPFC_QUEUE_MAX_REPOST;
-
 			lpfc_post_rq_buffer(
 				phba, phba->sli4_hba.nvmet_mrq_hdr[i],
 				phba->sli4_hba.nvmet_mrq_data[i],
@@ -13037,7 +13032,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		while ((cqe = lpfc_sli4_cq_get(cq))) {
 			workposted |= lpfc_sli4_sp_handle_mcqe(phba, cqe);
 			if (!(++ecount % cq->entry_repost))
-				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+				break;
 			cq->CQ_mbox++;
 		}
 		break;
@@ -13051,7 +13046,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				workposted |= lpfc_sli4_sp_handle_cqe(phba, cq,
 								      cqe);
 			if (!(++ecount % cq->entry_repost))
-				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+				break;
 		}
 
 		/* Track the max number of CQEs processed in 1 EQ */
@@ -13547,7 +13542,7 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
 		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
-			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+			break;
 	}
 
 	/* Track the max number of CQEs processed in 1 EQ */
@@ -13629,7 +13624,7 @@ lpfc_sli4_fof_intr_handler(int irq, void *dev_id)
 	while ((eqe = lpfc_sli4_eq_get(eq))) {
 		lpfc_sli4_fof_handle_eqe(phba, eqe);
 		if (!(++ecount % eq->entry_repost))
-			lpfc_sli4_eq_release(eq, LPFC_QUEUE_NOARM);
+			break;
 		eq->EQ_processed++;
 	}
 
@@ -13927,17 +13922,10 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
 	}
 	queue->entry_size = entry_size;
 	queue->entry_count = entry_count;
-
-	/*
-	 * entry_repost is calculated based on the number of entries in the
-	 * queue. This works out except for RQs. If buffers are NOT initially
-	 * posted for every RQE, entry_repost should be adjusted accordingly.
-	 */
-	queue->entry_repost = (entry_count >> 3);
-	if (queue->entry_repost < LPFC_QUEUE_MIN_REPOST)
-		queue->entry_repost = LPFC_QUEUE_MIN_REPOST;
 	queue->phba = phba;
 
+	/* entry_repost will be set during q creation */
+
 	return queue;
 out_fail:
 	lpfc_sli4_queue_free(queue);
@@ -14168,6 +14156,7 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 		status = -ENXIO;
 	eq->host_index = 0;
 	eq->hba_index = 0;
+	eq->entry_repost = LPFC_EQ_REPOST;
 
 	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
@@ -14241,9 +14230,9 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0361 Unsupported CQ count: "
-				"entry cnt %d sz %d pg cnt %d repost %d\n",
+				"entry cnt %d sz %d pg cnt %d\n",
 				cq->entry_count, cq->entry_size,
-				cq->page_count, cq->entry_repost);
+				cq->page_count);
 		if (cq->entry_count < 256) {
 			status = -EINVAL;
 			goto out;
@@ -14296,6 +14285,7 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	cq->assoc_qid = eq->queue_id;
 	cq->host_index = 0;
 	cq->hba_index = 0;
+	cq->entry_repost = LPFC_CQ_REPOST;
 
 out:
 	mempool_free(mbox, phba->mbox_mem_pool);
@@ -14487,6 +14477,7 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 		cq->assoc_qid = eq->queue_id;
 		cq->host_index = 0;
 		cq->hba_index = 0;
+		cq->entry_repost = LPFC_CQ_REPOST;
 
 		rc = 0;
 		list_for_each_entry(dmabuf, &cq->page_list, list) {
@@ -14735,6 +14726,7 @@ lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
 	mq->subtype = subtype;
 	mq->host_index = 0;
 	mq->hba_index = 0;
+	mq->entry_repost = LPFC_MQ_REPOST;
 
 	/* link the mq onto the parent cq child list */
 	list_add_tail(&mq->list, &cq->child_list);
@@ -14960,34 +14952,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 }
 
 /**
- * lpfc_rq_adjust_repost - Adjust entry_repost for an RQ
- * @phba: HBA structure that indicates port to create a queue on.
- * @rq:   The queue structure to use for the receive queue.
- * @qno:  The associated HBQ number
- *
- *
- * For SLI4 we need to adjust the RQ repost value based on
- * the number of buffers that are initially posted to the RQ.
- */
-void
-lpfc_rq_adjust_repost(struct lpfc_hba *phba, struct lpfc_queue *rq, int qno)
-{
-	uint32_t cnt;
-
-	/* sanity check on queue memory */
-	if (!rq)
-		return;
-	cnt = lpfc_hbq_defs[qno]->entry_count;
-
-	/* Recalc repost for RQs based on buffers initially posted */
-	cnt = (cnt >> 3);
-	if (cnt < LPFC_QUEUE_MIN_REPOST)
-		cnt = LPFC_QUEUE_MIN_REPOST;
-
-	rq->entry_repost = cnt;
-}
-
-/**
  * lpfc_rq_create - Create a Receive Queue on the HBA
  * @phba: HBA structure that indicates port to create a queue on.
  * @hrq: The queue structure to use to create the header receive queue.
@@ -15172,6 +15136,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	hrq->subtype = subtype;
 	hrq->host_index = 0;
 	hrq->hba_index = 0;
+	hrq->entry_repost = LPFC_RQ_REPOST;
 
 	/* now create the data queue */
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -15264,6 +15229,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	drq->subtype = subtype;
 	drq->host_index = 0;
 	drq->hba_index = 0;
+	drq->entry_repost = LPFC_RQ_REPOST;
 
 	/* link the header and data RQs onto the parent cq child list */
 	list_add_tail(&hrq->list, &cq->child_list);
@@ -15421,6 +15387,7 @@ lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
 		hrq->subtype = subtype;
 		hrq->host_index = 0;
 		hrq->hba_index = 0;
+		hrq->entry_repost = LPFC_RQ_REPOST;
 
 		drq->db_format = LPFC_DB_RING_FORMAT;
 		drq->db_regaddr = phba->sli4_hba.RQDBregaddr;
@@ -15429,6 +15396,7 @@ lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
 		drq->subtype = subtype;
 		drq->host_index = 0;
 		drq->hba_index = 0;
+		drq->entry_repost = LPFC_RQ_REPOST;
 
 		list_add_tail(&hrq->list, &cq->child_list);
 		list_add_tail(&drq->list, &cq->child_list);
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index a650308a95c5..6ab52c2a6100 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -24,7 +24,6 @@
 #define LPFC_XRI_EXCH_BUSY_WAIT_TMO		10000
 #define LPFC_XRI_EXCH_BUSY_WAIT_T1   		10
 #define LPFC_XRI_EXCH_BUSY_WAIT_T2              30000
-#define LPFC_RELEASE_NOTIFICATION_INTERVAL	32
 #define LPFC_RPI_LOW_WATER_MARK			10
 
 #define LPFC_UNREG_FCF                          1
@@ -155,8 +154,11 @@ struct lpfc_queue {
 	uint32_t entry_count;	/* Number of entries to support on the queue */
 	uint32_t entry_size;	/* Size of each queue entry. */
 	uint32_t entry_repost;	/* Count of entries before doorbell is rung */
-#define LPFC_QUEUE_MIN_REPOST	8
-#define LPFC_QUEUE_MAX_REPOST	64
+#define LPFC_EQ_REPOST		8
+#define LPFC_MQ_REPOST		8
+#define LPFC_CQ_REPOST		64
+#define LPFC_RQ_REPOST		64
+#define LPFC_RELEASE_NOTIFICATION_INTERVAL	32  /* For WQs */
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
 	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
 	uint32_t page_count;	/* Number of pages allocated for this queue */
-- 
2.11.0
