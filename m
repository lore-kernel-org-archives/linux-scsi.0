From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 12/15] be2iscsi: Fix IOPOLL implementation
Date: Tue, 15 Dec 2015 21:25:03 +0530
Message-ID: <1450194906-12925-13-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:63989 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754113AbbLOPzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 10:55:37 -0500
In-Reply-To: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

OS not responding when running 2 port traffic on 72 CPUs system.

be2iscsi IRQs gets affined to CPU0 when irqbalancer is disabled.
be_iopoll processing completions in BLOCK_IOPOLL_SOFTIRQ hogged CPU0.

1. Use budget to exit the polling loop. beiscsi_process_cq didn't honour it.
2. Rearming of EQ is done only after iopoll completes.

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |    2 +-
 drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
 drivers/scsi/be2iscsi/be_main.c  |   91 +++++++++++++++++++++-----------------
 drivers/scsi/be2iscsi/be_main.h  |    5 +-
 4 files changed, 56 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index eced82b..3dbf6af 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -543,7 +543,7 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 	}
 
 	if (num)
-		hwi_ring_cq_db(phba, phba->ctrl.mcc_obj.cq.id, num, 1, 0);
+		hwi_ring_cq_db(phba, phba->ctrl.mcc_obj.cq.id, num, 1);
 
 	spin_unlock_bh(&phba->ctrl.mcc_cq_lock);
 	return status;
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index c89a025..3545721 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1298,7 +1298,7 @@ static void beiscsi_flush_cq(struct beiscsi_hba *phba)
 	for (i = 0; i < phba->num_cpus; i++) {
 		pbe_eq = &phwi_context->be_eq[i];
 		blk_iopoll_disable(&pbe_eq->iopoll);
-		beiscsi_process_cq(pbe_eq);
+		beiscsi_process_cq(pbe_eq, BE2_MAX_NUM_CQ_PROC);
 		blk_iopoll_enable(&pbe_eq->iopoll);
 	}
 }
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a665e6a..9a86044 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -895,32 +895,21 @@ static irqreturn_t be_isr_mcc(int irq, void *dev_id)
 static irqreturn_t be_isr_msix(int irq, void *dev_id)
 {
 	struct beiscsi_hba *phba;
-	struct be_eq_entry *eqe = NULL;
 	struct be_queue_info *eq;
-	struct be_queue_info *cq;
-	unsigned int num_eq_processed;
 	struct be_eq_obj *pbe_eq;
 
 	pbe_eq = dev_id;
 	eq = &pbe_eq->q;
-	cq = pbe_eq->cq;
-	eqe = queue_tail_node(eq);
 
 	phba = pbe_eq->phba;
-	num_eq_processed = 0;
-	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
-				& EQE_VALID_MASK) {
-		if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
-			blk_iopoll_sched(&pbe_eq->iopoll);
-
-		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-		queue_tail_inc(eq);
-		eqe = queue_tail_node(eq);
-		num_eq_processed++;
-	}
-
-	if (num_eq_processed)
-		hwi_ring_eq_db(phba, eq->id, 1,	num_eq_processed, 0, 1);
+	/* disable interrupt till iopoll completes */
+	hwi_ring_eq_db(phba, eq->id, 1,	0, 0, 1);
+	if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
+		blk_iopoll_sched(&pbe_eq->iopoll);
+	else
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_IO,
+			    "BM_%d: received event while polling eq %d cq %d\n",
+			    eq->id, pbe_eq->cq->id);
 
 	return IRQ_HANDLED;
 }
@@ -998,6 +987,7 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 		return IRQ_NONE;
 }
 
+
 static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 {
 	struct pci_dev *pcidev = phba->pcidev;
@@ -1072,7 +1062,7 @@ free_msix_irqs:
 
 void hwi_ring_cq_db(struct beiscsi_hba *phba,
 			   unsigned int id, unsigned int num_processed,
-			   unsigned char rearm, unsigned char event)
+			   unsigned char rearm)
 {
 	u32 val = 0;
 
@@ -2044,7 +2034,7 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
 
 		if (num_processed >= 32) {
 			hwi_ring_cq_db(phba, mcc_cq->id,
-					num_processed, 0, 0);
+					num_processed, 0);
 			num_processed = 0;
 		}
 		if (mcc_compl->flags & CQE_FLAGS_ASYNC_MASK) {
@@ -2062,24 +2052,25 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
 	}
 
 	if (num_processed > 0)
-		hwi_ring_cq_db(phba, mcc_cq->id, num_processed, 1, 0);
+		hwi_ring_cq_db(phba, mcc_cq->id, num_processed, 1);
 
 }
 
 /**
  * beiscsi_process_cq()- Process the Completion Queue
  * @pbe_eq: Event Q on which the Completion has come
+ * @budget: Max number of events to processed
  *
  * return
  *     Number of Completion Entries processed.
  **/
-unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
+unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 {
 	struct be_queue_info *cq;
 	struct sol_cqe *sol;
 	struct dmsg_cqe *dmsg;
+	unsigned int total = 0;
 	unsigned int num_processed = 0;
-	unsigned int tot_nump = 0;
 	unsigned short code = 0, cid = 0;
 	uint16_t cri_index = 0;
 	struct beiscsi_conn *beiscsi_conn;
@@ -2130,12 +2121,12 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		beiscsi_ep = ep->dd_data;
 		beiscsi_conn = beiscsi_ep->conn;
 
-		if (num_processed >= 32) {
-			hwi_ring_cq_db(phba, cq->id,
-					num_processed, 0, 0);
-			tot_nump += num_processed;
+		/* replenish cq */
+		if (num_processed == 32) {
+			hwi_ring_cq_db(phba, cq->id, 32, 0);
 			num_processed = 0;
 		}
+		total++;
 
 		switch (code) {
 		case SOL_CMD_COMPLETE:
@@ -2180,7 +2171,13 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				    "BM_%d : Ignoring %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 			break;
+		case CXN_KILLED_HDR_DIGEST_ERR:
 		case SOL_CMD_KILLED_DATA_DIGEST_ERR:
+			beiscsi_log(phba, KERN_ERR,
+				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+				    "BM_%d : Cmd Notification %s[%d] on CID : %d\n",
+				    cqe_desc[code], code,  cid);
+			break;
 		case CMD_KILLED_INVALID_STATSN_RCVD:
 		case CMD_KILLED_INVALID_R2T_RCVD:
 		case CMD_CXN_KILLED_LUN_INVALID:
@@ -2206,7 +2203,6 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CXN_KILLED_PDU_SIZE_EXCEEDS_DSL:
 		case CXN_KILLED_BURST_LEN_MISMATCH:
 		case CXN_KILLED_AHS_RCVD:
-		case CXN_KILLED_HDR_DIGEST_ERR:
 		case CXN_KILLED_UNKNOWN_HDR:
 		case CXN_KILLED_STALE_ITT_TTT_RCVD:
 		case CXN_KILLED_INVALID_ITT_TTT_RCVD:
@@ -2241,13 +2237,12 @@ proc_next_cqe:
 		queue_tail_inc(cq);
 		sol = queue_tail_node(cq);
 		num_processed++;
+		if (total == budget)
+			break;
 	}
 
-	if (num_processed > 0) {
-		tot_nump += num_processed;
-		hwi_ring_cq_db(phba, cq->id, num_processed, 1, 0);
-	}
-	return tot_nump;
+	hwi_ring_cq_db(phba, cq->id, num_processed, 1);
+	return total;
 }
 
 void beiscsi_process_all_cqs(struct work_struct *work)
@@ -2274,7 +2269,7 @@ void beiscsi_process_all_cqs(struct work_struct *work)
 		spin_lock_irqsave(&phba->isr_lock, flags);
 		pbe_eq->todo_cq = false;
 		spin_unlock_irqrestore(&phba->isr_lock, flags);
-		beiscsi_process_cq(pbe_eq);
+		beiscsi_process_cq(pbe_eq, BE2_MAX_NUM_CQ_PROC);
 	}
 
 	/* rearm EQ for further interrupts */
@@ -2283,20 +2278,36 @@ void beiscsi_process_all_cqs(struct work_struct *work)
 
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
-	ret = beiscsi_process_cq(pbe_eq);
+	phba = pbe_eq->phba;
+	eq = &pbe_eq->q;
+	eqe = queue_tail_node(eq);
+
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32] &
+			EQE_VALID_MASK) {
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+		num_eq_processed++;
+	}
+
+	hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 0, 1);
+
+	ret = beiscsi_process_cq(pbe_eq, budget);
 	pbe_eq->cq_count += ret;
 	if (ret < budget) {
-		phba = pbe_eq->phba;
 		blk_iopoll_complete(iop);
 		beiscsi_log(phba, KERN_INFO,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d : rearm pbe_eq->q.id =%d\n",
-			    pbe_eq->q.id);
+			    "BM_%d : rearm pbe_eq->q.id =%d ret %d\n",
+			    pbe_eq->q.id, ret);
 		hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
 	}
 	return ret;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index f89861b..fabade3 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -63,6 +63,7 @@
 #define BE2_SGE			32
 #define BE2_DEFPDU_HDR_SZ	64
 #define BE2_DEFPDU_DATA_SZ	8192
+#define BE2_MAX_NUM_CQ_PROC	512
 
 #define MAX_CPUS		64
 #define BEISCSI_MAX_NUM_CPUS	7
@@ -848,9 +849,9 @@ void beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
 
 void hwi_ring_cq_db(struct beiscsi_hba *phba,
 		     unsigned int id, unsigned int num_processed,
-		     unsigned char rearm, unsigned char event);
+		     unsigned char rearm);
 
-unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq);
+unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget);
 
 static inline bool beiscsi_error(struct beiscsi_hba *phba)
 {
-- 
1.7.1

