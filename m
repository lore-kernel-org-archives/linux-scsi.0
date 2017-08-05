From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 12/20] lpfc: Limit amount of work processed in IRQ
Date: Fri,  4 Aug 2017 17:47:23 -0700
Message-ID: <20170805004731.1335-13-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38447 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdHEAsD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:48:03 -0400
Received: by mail-pg0-f68.google.com with SMTP id 123so3103497pga.5
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:48:03 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Various oops being seen on being in the ISR too long and cpu
lockups, when under heavy load.

The amount of work being posted off of completion queues kept
the ISR running almost all the time

Correct the issue by limiting the amount of work per itteration.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c  | 31 +++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli4.h |  1 +
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d68afec00f57..9ccd8fed0bed 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -80,8 +80,8 @@ static int lpfc_sli4_fp_handle_cqe(struct lpfc_hba *, struct lpfc_queue *,
 				    struct lpfc_cqe *);
 static int lpfc_sli4_post_sgl_list(struct lpfc_hba *, struct list_head *,
 				       int);
-static void lpfc_sli4_hba_handle_eqe(struct lpfc_hba *, struct lpfc_eqe *,
-			uint32_t);
+static int lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba,
+				    struct lpfc_eqe *eqe, uint32_t qidx);
 static bool lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba);
 static bool lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba);
 static int lpfc_sli4_abort_nvme_io(struct lpfc_hba *phba,
@@ -13010,7 +13010,7 @@ lpfc_sli4_sp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
  * completion queue, and then return.
  *
  **/
-static void
+static int
 lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	struct lpfc_queue *speq)
 {
@@ -13034,7 +13034,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"0365 Slow-path CQ identifier "
 					"(%d) does not exist\n", cqid);
-		return;
+		return 0;
 	}
 
 	/* Save EQ associated with this CQ */
@@ -13071,7 +13071,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0370 Invalid completion queue type (%d)\n",
 				cq->type);
-		return;
+		return 0;
 	}
 
 	/* Catch the no cq entry condition, log an error */
@@ -13086,6 +13086,8 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
 		lpfc_worker_wake_up(phba);
+
+	return ecount;
 }
 
 /**
@@ -13393,7 +13395,7 @@ lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
  * queue and process all the entries on the completion queue, rearm the
  * completion queue, and then return.
  **/
-static void
+static int
 lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 			uint32_t qidx)
 {
@@ -13409,7 +13411,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				"event: majorcode=x%x, minorcode=x%x\n",
 				bf_get_le32(lpfc_eqe_major_code, eqe),
 				bf_get_le32(lpfc_eqe_minor_code, eqe));
-		return;
+		return 0;
 	}
 
 	/* Get the reference to the corresponding CQ */
@@ -13446,8 +13448,9 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 
 	/* Otherwise this is a Slow path event */
 	if (cq == NULL) {
-		lpfc_sli4_sp_handle_eqe(phba, eqe, phba->sli4_hba.hba_eq[qidx]);
-		return;
+		ecount = lpfc_sli4_sp_handle_eqe(phba, eqe,
+						 phba->sli4_hba.hba_eq[qidx]);
+		return ecount;
 	}
 
 process_cq:
@@ -13456,7 +13459,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				"0368 Miss-matched fast-path completion "
 				"queue identifier: eqcqid=%d, fcpcqid=%d\n",
 				cqid, cq->queue_id);
-		return;
+		return 0;
 	}
 
 	/* Save EQ associated with this CQ */
@@ -13486,6 +13489,8 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
 		lpfc_worker_wake_up(phba);
+
+	return ecount;
 }
 
 static void
@@ -13706,6 +13711,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	struct lpfc_eqe *eqe;
 	unsigned long iflag;
 	int ecount = 0;
+	int ccount = 0;
 	int hba_eqidx;
 
 	/* Get the driver's phba structure from the dev_id */
@@ -13757,8 +13763,9 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		if (eqe == NULL)
 			break;
 
-		lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
-		if (!(++ecount % fpeq->entry_repost))
+		ccount += lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
+		if (!(++ecount % fpeq->entry_repost) ||
+		    ccount > LPFC_MAX_ISR_CQE)
 			break;
 		fpeq->EQ_processed++;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 7a1d74e9e877..540454b03587 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -158,6 +158,7 @@ struct lpfc_queue {
 #define LPFC_MQ_REPOST		8
 #define LPFC_CQ_REPOST		64
 #define LPFC_RQ_REPOST		64
+#define LPFC_MAX_ISR_CQE	64
 #define LPFC_RELEASE_NOTIFICATION_INTERVAL	32  /* For WQs */
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
 	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
-- 
2.13.1
