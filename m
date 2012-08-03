From: James Smart <james.smart@emulex.com>
Subject: [PATCH 18/21] lpfc 8.3.33: Add lpfc_fcp_look_ahead module parameter
Date: Fri, 3 Aug 2012 12:36:52 -0400
Message-ID: <1344011812.6110.43.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:44849 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2HCQg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:36:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add lpfc_fcp_look_ahead module parameter


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    2 +
 lpfc_attr.c |   11 +++++++
 lpfc_crtn.h |    1 
 lpfc_init.c |    3 ++
 lpfc_sli.c  |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 lpfc_sli4.h |    1 
 6 files changed, 102 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2012-07-22 14:30:08.545267563 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2012-07-22 14:32:56.345261734 -0400
@@ -3918,6 +3918,17 @@ LPFC_ATTR_R(enable_hba_heartbeat, 0, 0,
 LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable BlockGuard Support");
 
 /*
+# lpfc_fcp_look_ahead: Look ahead for completions in FCP start routine
+#       0  = disabled (default)
+#       1  = enabled
+# Value range is [0,1]. Default value is 0.
+*/
+unsigned int lpfc_fcp_look_ahead = LPFC_LOOK_AHEAD_OFF;
+
+module_param(lpfc_fcp_look_ahead, uint, S_IRUGO);
+MODULE_PARM_DESC(lpfc_fcp_look_ahead, "Look ahead for completions");
+
+/*
 # lpfc_prot_mask: i
 #	- Bit mask of host protection capabilities used to register with the
 #	  SCSI mid-layer
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2012-07-22 14:29:51.213268165 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2012-07-22 14:32:56.353261734 -0400
@@ -390,6 +390,7 @@ extern spinlock_t pgcnt_lock;
 extern unsigned int pgcnt;
 extern unsigned int lpfc_prot_mask;
 extern unsigned char lpfc_prot_guard;
+extern unsigned int lpfc_fcp_look_ahead;
 
 /* Interface exported by fabric iocb scheduler */
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-07-22 14:30:08.549267563 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2012-07-22 14:32:56.356261734 -0400
@@ -73,6 +73,8 @@ struct lpfc_sli2_slim;
 #define LPFC_HB_MBOX_INTERVAL   5	/* Heart beat interval in seconds. */
 #define LPFC_HB_MBOX_TIMEOUT    30	/* Heart beat timeout  in seconds. */
 
+#define LPFC_LOOK_AHEAD_OFF	0	/* Look ahead logic is turned off */
+
 /* Error Attention event polling interval */
 #define LPFC_ERATT_POLL_INTERVAL	5 /* EATT poll interval in seconds */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-07-22 14:29:51.443268157 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-07-22 14:32:56.370261734 -0400
@@ -8111,6 +8111,7 @@ enable_msix_vectors:
 
 		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
 		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+		atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].fcp_eq_in_use, 1);
 		rc = request_irq(phba->sli4_hba.msix_entries[index].vector,
 				 &lpfc_sli4_hba_intr_handler, IRQF_SHARED,
 				 (char *)&phba->sli4_hba.handler_name[index],
@@ -8283,6 +8284,8 @@ lpfc_sli4_enable_intr(struct lpfc_hba *p
 			     index++) {
 				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
 				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
+					fcp_eq_in_use, 1);
 			}
 		}
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2012-07-22 14:29:51.446268155 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2012-07-22 14:32:56.381261733 -0400
@@ -373,6 +373,7 @@ struct lpfc_hba;
 struct lpfc_fcp_eq_hdl {
 	uint32_t idx;
 	struct lpfc_hba *phba;
+	atomic_t fcp_eq_in_use;
 };
 
 /* Port Capabilities for SLI4 Parameters */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 14:30:08.566267563 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 14:32:56.396261733 -0400
@@ -69,6 +69,8 @@ static int lpfc_sli4_fp_handle_wcqe(stru
 				    struct lpfc_cqe *);
 static int lpfc_sli4_post_els_sgl_list(struct lpfc_hba *, struct list_head *,
 				       int);
+static void lpfc_sli4_hba_handle_eqe(struct lpfc_hba *, struct lpfc_eqe *,
+			uint32_t);
 
 static IOCB_t *
 lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
@@ -258,6 +260,25 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
 }
 
 /**
+ * lpfc_sli4_eq_clr_intr - Turn off interrupts from this EQ
+ * @q: The Event Queue to disable interrupts
+ *
+ **/
+static inline void
+lpfc_sli4_eq_clr_intr(struct lpfc_queue *q)
+{
+	struct lpfc_register doorbell;
+
+	doorbell.word0 = 0;
+	bf_set(lpfc_eqcq_doorbell_eqci, &doorbell, 1);
+	bf_set(lpfc_eqcq_doorbell_qt, &doorbell, LPFC_QUEUE_TYPE_EVENT);
+	bf_set(lpfc_eqcq_doorbell_eqid_hi, &doorbell,
+		(q->queue_id >> LPFC_EQID_HI_FIELD_SHIFT));
+	bf_set(lpfc_eqcq_doorbell_eqid_lo, &doorbell, q->queue_id);
+	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+}
+
+/**
  * lpfc_sli4_eq_release - Indicates the host has finished processing an EQ
  * @q: The Event Queue that the host has completed processing for.
  * @arm: Indicates whether the host wants to arms this CQ.
@@ -8422,7 +8443,10 @@ int
 lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
 {
+	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
 	struct lpfc_sli_ring *pring;
+	struct lpfc_queue *fpeq;
+	struct lpfc_eqe *eqe;
 	unsigned long iflags;
 	int rc, idx;
 
@@ -8433,11 +8457,48 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 			idx = lpfc_sli4_scmd_to_wqidx_distr(phba);
 			piocb->fcp_wqidx = idx;
 			ring_number = MAX_SLI3_CONFIGURED_RINGS + idx;
+
+			pring = &phba->sli.ring[ring_number];
+			spin_lock_irqsave(&pring->ring_lock, iflags);
+			rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb,
+				flag);
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+
+			if (lpfc_fcp_look_ahead) {
+				fcp_eq_hdl = &phba->sli4_hba.fcp_eq_hdl[idx];
+
+				if (atomic_dec_and_test(&fcp_eq_hdl->
+					fcp_eq_in_use)) {
+
+					/* Get associated EQ with this index */
+					fpeq = phba->sli4_hba.hba_eq[idx];
+
+					/* Turn off interrupts from this EQ */
+					lpfc_sli4_eq_clr_intr(fpeq);
+
+					/*
+					 * Process all the events on FCP EQ
+					 */
+					while ((eqe = lpfc_sli4_eq_get(fpeq))) {
+						lpfc_sli4_hba_handle_eqe(phba,
+							eqe, idx);
+						fpeq->EQ_processed++;
+					}
+
+					/* Always clear and re-arm the EQ */
+					lpfc_sli4_eq_release(fpeq,
+						LPFC_QUEUE_REARM);
+				}
+				atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			}
+		} else {
+			pring = &phba->sli.ring[ring_number];
+			spin_lock_irqsave(&pring->ring_lock, iflags);
+			rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb,
+				flag);
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+
 		}
-		pring = &phba->sli.ring[ring_number];
-		spin_lock_irqsave(&pring->ring_lock, iflags);
-		rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
-		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	} else {
 		/* For now, SLI2/3 will still use hbalock */
 		spin_lock_irqsave(&phba->hbalock, iflags);
@@ -11854,6 +11915,15 @@ lpfc_sli4_hba_intr_handler(int irq, void
 	if (unlikely(!fpeq))
 		return IRQ_NONE;
 
+	if (lpfc_fcp_look_ahead) {
+		if (atomic_dec_and_test(&fcp_eq_hdl->fcp_eq_in_use))
+			lpfc_sli4_eq_clr_intr(fpeq);
+		else {
+			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			return IRQ_NONE;
+		}
+	}
+
 	/* Check device state for handling interrupt */
 	if (unlikely(lpfc_intr_state_check(phba))) {
 		fpeq->EQ_badstate++;
@@ -11863,6 +11933,8 @@ lpfc_sli4_hba_intr_handler(int irq, void
 			/* Flush, clear interrupt, and rearm the EQ */
 			lpfc_sli4_eq_flush(phba, fpeq);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		if (lpfc_fcp_look_ahead)
+			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
 		return IRQ_NONE;
 	}
 
@@ -11885,6 +11957,12 @@ lpfc_sli4_hba_intr_handler(int irq, void
 
 	if (unlikely(ecount == 0)) {
 		fpeq->EQ_no_entry++;
+
+		if (lpfc_fcp_look_ahead) {
+			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			return IRQ_NONE;
+		}
+
 		if (phba->intr_type == MSIX)
 			/* MSI-X treated interrupt served as no EQ share INT */
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
@@ -11894,6 +11972,8 @@ lpfc_sli4_hba_intr_handler(int irq, void
 			return IRQ_NONE;
 	}
 
+	if (lpfc_fcp_look_ahead)
+		atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
 	return IRQ_HANDLED;
 } /* lpfc_sli4_fp_intr_handler */
 



