From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 07/19] lpfc: Move CQ processing to a soft IRQ
Date: Thu, 21 Sep 2017 23:17:29 -0700
Message-ID: <20170922061741.12347-8-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37634 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbdIVGSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:03 -0400
Received: by mail-pg0-f65.google.com with SMTP id v5so118153pgn.4
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:02 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Under heavy target nvme load duration, the lpfc irq handler
is encountering cpu lockup warnings.

Convert the driver to a shortened ISR handler which identifies
the interrupting condition then schedules a workq thread to
process the completion queue the interrupt was for. This moves
all the real work into the workq element.

As nvmet_fc upcalls are no longer in ISR context, don't set the
feature flags

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h       |   3 +
 drivers/scsi/lpfc/lpfc_init.c  |  15 +++++
 drivers/scsi/lpfc/lpfc_nvmet.c |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c   | 148 ++++++++++++++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_sli4.h  |   4 +-
 5 files changed, 109 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8eb3f96fe068..231302273257 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -23,6 +23,7 @@
 
 #include <scsi/scsi_host.h>
 #include <linux/ktime.h>
+#include <linux/workqueue.h>
 
 #if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_SCSI_LPFC_DEBUG_FS)
 #define CONFIG_SCSI_LPFC_DEBUG_FS
@@ -653,6 +654,8 @@ struct lpfc_hba {
 	/* SLI4 specific HBA data structure */
 	struct lpfc_sli4_hba sli4_hba;
 
+	struct workqueue_struct *wq;
+
 	struct lpfc_sli sli;
 	uint8_t pci_dev_grp;	/* lpfc PCI dev group: 0x0, 0x1, 0x2,... */
 	uint32_t sli_rev;		/* SLI2, SLI3, or SLI4 */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b50c3b559a7a..4ffdde5808ee 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3216,6 +3216,9 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 	lpfc_destroy_vport_work_array(phba, vports);
 
 	lpfc_sli_mbox_sys_shutdown(phba, mbx_action);
+
+	if (phba->wq)
+		flush_workqueue(phba->wq);
 }
 
 /**
@@ -4176,6 +4179,9 @@ void
 lpfc_stop_port(struct lpfc_hba *phba)
 {
 	phba->lpfc_stop_port(phba);
+
+	if (phba->wq)
+		flush_workqueue(phba->wq);
 }
 
 /**
@@ -6369,6 +6375,9 @@ lpfc_setup_driver_resource_phase2(struct lpfc_hba *phba)
 		return error;
 	}
 
+	/* workqueue for deferred irq use */
+	phba->wq = alloc_workqueue("lpfc_wq", WQ_MEM_RECLAIM, 0);
+
 	return 0;
 }
 
@@ -6383,6 +6392,12 @@ lpfc_setup_driver_resource_phase2(struct lpfc_hba *phba)
 static void
 lpfc_unset_driver_resource_phase2(struct lpfc_hba *phba)
 {
+	if (phba->wq) {
+		flush_workqueue(phba->wq);
+		destroy_workqueue(phba->wq);
+		phba->wq = NULL;
+	}
+
 	/* Stop kernel worker thread */
 	kthread_stop(phba->worker_thread);
 }
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 46b411894964..d065f5e4fa1a 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1156,9 +1156,7 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	}
 	lpfc_tgttemplate.max_sgl_segments = phba->cfg_nvme_seg_cnt + 1;
 	lpfc_tgttemplate.max_hw_queues = phba->cfg_nvme_io_channel;
-	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
-					   NVMET_FCTGTFEAT_CMD_IN_ISR |
-					   NVMET_FCTGTFEAT_OPDONE_IN_ISR;
+	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP;
 
 #if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	error = nvmet_fc_register_targetport(&pinfo, &lpfc_tgttemplate,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3ace438d8f2e..a69332f0abcd 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -80,8 +80,8 @@ static int lpfc_sli4_fp_handle_cqe(struct lpfc_hba *, struct lpfc_queue *,
 				    struct lpfc_cqe *);
 static int lpfc_sli4_post_sgl_list(struct lpfc_hba *, struct list_head *,
 				       int);
-static int lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba,
-				    struct lpfc_eqe *eqe, uint32_t qidx);
+static void lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba,
+				     struct lpfc_eqe *eqe, uint32_t qidx);
 static bool lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba);
 static bool lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba);
 static int lpfc_sli4_abort_nvme_io(struct lpfc_hba *phba,
@@ -13022,14 +13022,11 @@ lpfc_sli4_sp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
  * completion queue, and then return.
  *
  **/
-static int
+static void
 lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	struct lpfc_queue *speq)
 {
 	struct lpfc_queue *cq = NULL, *childq;
-	struct lpfc_cqe *cqe;
-	bool workposted = false;
-	int ecount = 0;
 	uint16_t cqid;
 
 	/* Get the reference to the corresponding CQ */
@@ -13046,18 +13043,47 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"0365 Slow-path CQ identifier "
 					"(%d) does not exist\n", cqid);
-		return 0;
+		return;
 	}
 
 	/* Save EQ associated with this CQ */
 	cq->assoc_qp = speq;
 
+	if (!queue_work(phba->wq, &cq->spwork))
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0390 Cannot schedule soft IRQ "
+				"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
+				cqid, cq->queue_id, smp_processor_id());
+}
+
+/**
+ * lpfc_sli4_sp_process_cq - Process a slow-path event queue entry
+ * @phba: Pointer to HBA context object.
+ *
+ * This routine process a event queue entry from the slow-path event queue.
+ * It will check the MajorCode and MinorCode to determine this is for a
+ * completion event on a completion queue, if not, an error shall be logged
+ * and just return. Otherwise, it will get to the corresponding completion
+ * queue and process all the entries on that completion queue, rearm the
+ * completion queue, and then return.
+ *
+ **/
+static void
+lpfc_sli4_sp_process_cq(struct work_struct *work)
+{
+	struct lpfc_queue *cq =
+		container_of(work, struct lpfc_queue, spwork);
+	struct lpfc_hba *phba = cq->phba;
+	struct lpfc_cqe *cqe;
+	bool workposted = false;
+	int ccount = 0;
+
 	/* Process all the entries to the CQ */
 	switch (cq->type) {
 	case LPFC_MCQ:
 		while ((cqe = lpfc_sli4_cq_get(cq))) {
 			workposted |= lpfc_sli4_sp_handle_mcqe(phba, cqe);
-			if (!(++ecount % cq->entry_repost))
+			if (!(++ccount % cq->entry_repost))
 				break;
 			cq->CQ_mbox++;
 		}
@@ -13078,23 +13104,23 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				workposted |= lpfc_sli4_sp_handle_cqe(phba, cq,
 								      cqe);
 			}
-			if (!(++ecount % cq->entry_repost))
+			if (!(++ccount % cq->entry_repost))
 				break;
 		}
 
 		/* Track the max number of CQEs processed in 1 EQ */
-		if (ecount > cq->CQ_max_cqe)
-			cq->CQ_max_cqe = ecount;
+		if (ccount > cq->CQ_max_cqe)
+			cq->CQ_max_cqe = ccount;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0370 Invalid completion queue type (%d)\n",
 				cq->type);
-		return 0;
+		return;
 	}
 
 	/* Catch the no cq entry condition, log an error */
-	if (unlikely(ecount == 0))
+	if (unlikely(ccount == 0))
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0371 No entry from the CQ: identifier "
 				"(x%x), type (%d)\n", cq->queue_id, cq->type);
@@ -13105,8 +13131,6 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
 		lpfc_worker_wake_up(phba);
-
-	return ecount;
 }
 
 /**
@@ -13412,15 +13436,12 @@ lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
  * queue and process all the entries on the completion queue, rearm the
  * completion queue, and then return.
  **/
-static int
+static void
 lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 			uint32_t qidx)
 {
 	struct lpfc_queue *cq = NULL;
-	struct lpfc_cqe *cqe;
-	bool workposted = false;
 	uint16_t cqid, id;
-	int ecount = 0;
 
 	if (unlikely(bf_get_le32(lpfc_eqe_major_code, eqe) != 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -13428,7 +13449,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				"event: majorcode=x%x, minorcode=x%x\n",
 				bf_get_le32(lpfc_eqe_major_code, eqe),
 				bf_get_le32(lpfc_eqe_minor_code, eqe));
-		return 0;
+		return;
 	}
 
 	/* Get the reference to the corresponding CQ */
@@ -13465,9 +13486,8 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 
 	/* Otherwise this is a Slow path event */
 	if (cq == NULL) {
-		ecount = lpfc_sli4_sp_handle_eqe(phba, eqe,
-						 phba->sli4_hba.hba_eq[qidx]);
-		return ecount;
+		lpfc_sli4_sp_handle_eqe(phba, eqe, phba->sli4_hba.hba_eq[qidx]);
+		return;
 	}
 
 process_cq:
@@ -13476,12 +13496,41 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				"0368 Miss-matched fast-path completion "
 				"queue identifier: eqcqid=%d, fcpcqid=%d\n",
 				cqid, cq->queue_id);
-		return 0;
+		return;
 	}
 
 	/* Save EQ associated with this CQ */
 	cq->assoc_qp = phba->sli4_hba.hba_eq[qidx];
 
+	if (!queue_work(phba->wq, &cq->irqwork))
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0363 Cannot schedule soft IRQ "
+				"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
+				cqid, cq->queue_id, smp_processor_id());
+}
+
+/**
+ * lpfc_sli4_hba_process_cq - Process a fast-path event queue entry
+ * @phba: Pointer to HBA context object.
+ * @eqe: Pointer to fast-path event queue entry.
+ *
+ * This routine process a event queue entry from the fast-path event queue.
+ * It will check the MajorCode and MinorCode to determine this is for a
+ * completion event on a completion queue, if not, an error shall be logged
+ * and just return. Otherwise, it will get to the corresponding completion
+ * queue and process all the entries on the completion queue, rearm the
+ * completion queue, and then return.
+ **/
+static void
+lpfc_sli4_hba_process_cq(struct work_struct *work)
+{
+	struct lpfc_queue *cq =
+		container_of(work, struct lpfc_queue, irqwork);
+	struct lpfc_hba *phba = cq->phba;
+	struct lpfc_cqe *cqe;
+	bool workposted = false;
+	int ccount = 0;
+
 	/* Process all the entries to the CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -13491,17 +13540,17 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 			cq->isr_timestamp = 0;
 #endif
 		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
-		if (!(++ecount % cq->entry_repost))
+		if (!(++ccount % cq->entry_repost))
 			break;
 	}
 
 	/* Track the max number of CQEs processed in 1 EQ */
-	if (ecount > cq->CQ_max_cqe)
-		cq->CQ_max_cqe = ecount;
-	cq->assoc_qp->EQ_cqe_cnt += ecount;
+	if (ccount > cq->CQ_max_cqe)
+		cq->CQ_max_cqe = ccount;
+	cq->assoc_qp->EQ_cqe_cnt += ccount;
 
 	/* Catch the no cq entry condition */
-	if (unlikely(ecount == 0))
+	if (unlikely(ccount == 0))
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0369 No entry from fast-path completion "
 				"queue fcpcqid=%d\n", cq->queue_id);
@@ -13512,8 +13561,6 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
 		lpfc_worker_wake_up(phba);
-
-	return ecount;
 }
 
 static void
@@ -13547,10 +13594,7 @@ static void
 lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 {
 	struct lpfc_queue *cq;
-	struct lpfc_cqe *cqe;
-	bool workposted = false;
 	uint16_t cqid;
-	int ecount = 0;
 
 	if (unlikely(bf_get_le32(lpfc_eqe_major_code, eqe) != 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -13585,30 +13629,12 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 	/* Save EQ associated with this CQ */
 	cq->assoc_qp = phba->sli4_hba.fof_eq;
 
-	/* Process all the entries to the OAS CQ */
-	while ((cqe = lpfc_sli4_cq_get(cq))) {
-		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
-		if (!(++ecount % cq->entry_repost))
-			break;
-	}
-
-	/* Track the max number of CQEs processed in 1 EQ */
-	if (ecount > cq->CQ_max_cqe)
-		cq->CQ_max_cqe = ecount;
-	cq->assoc_qp->EQ_cqe_cnt += ecount;
-
-	/* Catch the no cq entry condition */
-	if (unlikely(ecount == 0))
+	/* CQ work will be processed on CPU affinitized to this IRQ */
+	if (!queue_work(phba->wq, &cq->irqwork))
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"9153 No entry from fast-path completion "
-				"queue fcpcqid=%d\n", cq->queue_id);
-
-	/* In any case, flash and re-arm the CQ */
-	lpfc_sli4_cq_release(cq, LPFC_QUEUE_REARM);
-
-	/* wake up worker thread if there are works to be done */
-	if (workposted)
-		lpfc_worker_wake_up(phba);
+				"0367 Cannot schedule soft IRQ "
+				"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
+				cqid, cq->queue_id, smp_processor_id());
 }
 
 /**
@@ -13734,7 +13760,6 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	struct lpfc_eqe *eqe;
 	unsigned long iflag;
 	int ecount = 0;
-	int ccount = 0;
 	int hba_eqidx;
 
 	/* Get the driver's phba structure from the dev_id */
@@ -13781,9 +13806,8 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		if (eqe == NULL)
 			break;
 
-		ccount += lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
-		if (!(++ecount % fpeq->entry_repost) ||
-		    ccount > LPFC_MAX_ISR_CQE)
+		lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
+		if (!(++ecount % fpeq->entry_repost))
 			break;
 		fpeq->EQ_processed++;
 	}
@@ -13966,6 +13990,8 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
 	queue->entry_size = entry_size;
 	queue->entry_count = entry_count;
 	queue->phba = phba;
+	INIT_WORK(&queue->irqwork, lpfc_sli4_hba_process_cq);
+	INIT_WORK(&queue->spwork, lpfc_sli4_sp_process_cq);
 
 	/* entry_repost will be set during q creation */
 
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 60200385fe00..13b8f4d4da34 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -158,7 +158,6 @@ struct lpfc_queue {
 #define LPFC_MQ_REPOST		8
 #define LPFC_CQ_REPOST		64
 #define LPFC_RQ_REPOST		64
-#define LPFC_MAX_ISR_CQE	64
 #define LPFC_RELEASE_NOTIFICATION_INTERVAL	32  /* For WQs */
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
 	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
@@ -202,6 +201,9 @@ struct lpfc_queue {
 #define	RQ_buf_posted		q_cnt_3
 #define	RQ_rcv_buf		q_cnt_4
 
+	struct work_struct irqwork;
+	struct work_struct spwork;
+
 	uint64_t isr_timestamp;
 	struct lpfc_queue *assoc_qp;
 	union sli4_qe qe[1];	/* array to index entries (must be last) */
-- 
2.13.1
