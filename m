From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 2/6] be2iscsi: relinquishing control after processing 512 CQE
Date: Thu, 27 Mar 2014 12:39:26 -0400
Message-ID: <1395938371-2149-2-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34522 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaC0Qjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 12:39:44 -0400
Received: by mail-pb0-f44.google.com with SMTP id rp16so3744359pbb.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2014 09:39:43 -0700 (PDT)
In-Reply-To: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 stuck in IO poll for a long time. In such cases driver
 did not rearm which could lead to unprocessed eq.Change
 sched iopoll once then check for valid bit of eqe from
 eq in be_iopoll.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 73 +++++++++++++++++++++++++----------------
 drivers/scsi/be2iscsi/be_main.h |  1 +
 2 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9be818f..0c9e270 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -895,45 +895,37 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
 	struct beiscsi_hba *phba;
 	struct be_eq_entry *eqe = NULL;
 	struct be_queue_info *eq;
-	struct be_queue_info *cq;
 	unsigned int num_eq_processed;
 	struct be_eq_obj *pbe_eq;
 	unsigned long flags;
 
 	pbe_eq = dev_id;
 	eq = &pbe_eq->q;
-	cq = pbe_eq->cq;
-	eqe = queue_tail_node(eq);
 
 	phba = pbe_eq->phba;
-	num_eq_processed = 0;
 	if (blk_iopoll_enabled) {
-		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
-					& EQE_VALID_MASK) {
-			if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
-				blk_iopoll_sched(&pbe_eq->iopoll);
-
-			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-			queue_tail_inc(eq);
-			eqe = queue_tail_node(eq);
-			num_eq_processed++;
-		}
-	} else {
-		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
-						& EQE_VALID_MASK) {
-			spin_lock_irqsave(&phba->isr_lock, flags);
-			pbe_eq->todo_cq = true;
-			spin_unlock_irqrestore(&phba->isr_lock, flags);
-			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-			queue_tail_inc(eq);
-			eqe = queue_tail_node(eq);
-			num_eq_processed++;
-		}
+		hwi_ring_eq_db(phba, eq->id, 1,	0, 1, 1);
+		if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
+			blk_iopoll_sched(&pbe_eq->iopoll);
+		return IRQ_HANDLED;
+	}
 
-		if (pbe_eq->todo_cq)
-			queue_work(phba->wq, &pbe_eq->work_cqs);
+	num_eq_processed = 0;
+	eqe = queue_tail_node(eq);
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+					& EQE_VALID_MASK) {
+		spin_lock_irqsave(&phba->isr_lock, flags);
+		pbe_eq->todo_cq = true;
+		spin_unlock_irqrestore(&phba->isr_lock, flags);
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+		num_eq_processed++;
 	}
 
+	if (pbe_eq->todo_cq)
+		queue_work(phba->wq, &pbe_eq->work_cqs);
+
 	if (num_eq_processed)
 		hwi_ring_eq_db(phba, eq->id, 1,	num_eq_processed, 0, 1);
 
@@ -2281,6 +2273,10 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		queue_tail_inc(cq);
 		sol = queue_tail_node(cq);
 		num_processed++;
+
+		/* we want to relinquish control to other tasks */
+		if (tot_nump >= BE2_MAX_NUM_CQ_PROC)
+			break;
 	}
 
 	if (num_processed > 0) {
@@ -2323,14 +2319,33 @@ void beiscsi_process_all_cqs(struct work_struct *work)
 
 static int be_iopoll(struct blk_iopoll *iop, int budget)
 {
-	unsigned int ret;
+	unsigned int ret, num_eq_processed;
 	struct beiscsi_hba *phba;
 	struct be_eq_obj *pbe_eq;
+	struct be_eq_entry *eqe = NULL;
+	struct be_queue_info *eq;
 
+	num_eq_processed = 0;
 	pbe_eq = container_of(iop, struct be_eq_obj, iopoll);
+	phba = pbe_eq->phba;
+	eq = &pbe_eq->q;
+	eqe = queue_tail_node(eq);
+
+	hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 0, 1);
+
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+			& EQE_VALID_MASK) {
+
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+		num_eq_processed++;
+	}
+
+	hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 0, 1);
+
 	ret = beiscsi_process_cq(pbe_eq);
 	if (ret < budget) {
-		phba = pbe_eq->phba;
 		blk_iopoll_complete(iop);
 		beiscsi_log(phba, KERN_INFO,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 9380b55..d5901a7 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -63,6 +63,7 @@
 #define BE2_SGE			32
 #define BE2_DEFPDU_HDR_SZ	64
 #define BE2_DEFPDU_DATA_SZ	8192
+#define BE2_MAX_NUM_CQ_PROC	512
 
 #define MAX_CPUS		64
 #define BEISCSI_MAX_NUM_CPUS	7
-- 
1.8.5.3

