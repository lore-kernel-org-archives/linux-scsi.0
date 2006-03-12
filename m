From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [SCSI] aic94xx: remove event thread
Date: Sun, 12 Mar 2006 10:06:06 -0600
Message-ID: <1142179567.3297.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38868 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750945AbWCLQGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Mar 2006 11:06:13 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k2CG67210085
	for <linux-scsi@vger.kernel.org>; Sun, 12 Mar 2006 11:06:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch moves the discovery and event processing entirely over to
being workqueue based.  Additionally, it tries to ensure discovery gets
time to proceed before finishing the module load.  There's still a
non-determinism in there since it starts with a port interrupt for a
connected phy after phys are enabled, so there's a ssleep(1) in there to
capture this before the scsi_flush_work() waits for it to complete.

James

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 7b6534a..f716c1d 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -84,6 +84,7 @@ int lpfc_els_rsp_adisc_acc(struct lpfc_h
 			   struct lpfc_nodelist *);
 int lpfc_els_rsp_prli_acc(struct lpfc_hba *, struct lpfc_iocbq *,
 			  struct lpfc_nodelist *);
+void lpfc_cancel_retry_delay_tmo(struct lpfc_hba *, struct lpfc_nodelist *);
 void lpfc_els_retry_delay(unsigned long);
 void lpfc_els_retry_delay_handler(struct lpfc_nodelist *);
 void lpfc_els_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index efba875..6d12cd0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1435,6 +1435,46 @@ lpfc_issue_els_farpr(struct lpfc_hba * p
 }
 
 void
+lpfc_cancel_retry_delay_tmo(struct lpfc_hba *phba, struct lpfc_nodelist * nlp)
+{
+	nlp->nlp_flag &= ~NLP_DELAY_TMO;
+	del_timer_sync(&nlp->nlp_delayfunc);
+	nlp->nlp_last_elscmd = 0;
+
+	if (!list_empty(&nlp->els_retry_evt.evt_listp))
+		list_del_init(&nlp->els_retry_evt.evt_listp);
+
+	if (nlp->nlp_flag & NLP_NPR_2B_DISC) {
+		nlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+		if (phba->num_disc_nodes) {
+			/* Check to see if there are more
+			 * PLOGIs to be sent
+			 */
+			lpfc_more_plogi(phba);
+		}
+
+		if (phba->num_disc_nodes == 0) {
+			phba->fc_flag &= ~FC_NDISC_ACTIVE;
+			lpfc_can_disctmo(phba);
+			if (phba->fc_flag & FC_RSCN_MODE) {
+				/* Check to see if more RSCNs
+				 * came in while we were
+				 * processing this one.
+				 */
+				if((phba->fc_rscn_id_cnt==0) &&
+				   (!(phba->fc_flag & FC_RSCN_DISCOVERY))) {
+					phba->fc_flag &= ~FC_RSCN_MODE;
+				}
+				else {
+					lpfc_els_handle_rscn(phba);
+				}
+			}
+		}
+	}
+	return;
+}
+
+void
 lpfc_els_retry_delay(unsigned long ptr)
 {
 	struct lpfc_nodelist *ndlp;
@@ -2415,15 +2455,8 @@ lpfc_rscn_recovery_check(struct lpfc_hba
 			/* Make sure NLP_DELAY_TMO is NOT running
 			 * after a device recovery event.
 			 */
-			if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-				ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-				ndlp->nlp_last_elscmd = 0;
-				del_timer_sync(&ndlp->nlp_delayfunc);
-				if (!list_empty(&ndlp->
-						els_retry_evt.evt_listp))
-					list_del_init(&ndlp->
-						els_retry_evt.evt_listp);
-			}
+			if (ndlp->nlp_flag & NLP_DELAY_TMO)
+				lpfc_cancel_retry_delay_tmo(phba, ndlp);
 		}
 	}
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2b227b3..e15120d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1152,13 +1152,9 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		/* Stop delay tmo if taking node off NPR list */
 		if ((nlp->nlp_flag & NLP_DELAY_TMO) &&
 		   (list != NLP_NPR_LIST)) {
-			nlp->nlp_flag &= ~NLP_DELAY_TMO;
-			nlp->nlp_last_elscmd = 0;
 			spin_unlock_irq(phba->host->host_lock);
-			del_timer_sync(&nlp->nlp_delayfunc);
+			lpfc_cancel_retry_delay_tmo(phba, nlp);
 			spin_lock_irq(phba->host->host_lock);
-			if (!list_empty(&nlp->els_retry_evt.evt_listp))
-				list_del_init(&nlp->els_retry_evt.evt_listp);
 		}
 		break;
 	}
@@ -1598,13 +1594,7 @@ lpfc_nlp_remove(struct lpfc_hba * phba, 
 
 
 	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-		spin_lock_irq(phba->host->host_lock);
-		ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-		spin_unlock_irq(phba->host->host_lock);
-		ndlp->nlp_last_elscmd = 0;
-		del_timer_sync(&ndlp->nlp_delayfunc);
-		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
-			list_del_init(&ndlp->els_retry_evt.evt_listp);
+		lpfc_cancel_retry_delay_tmo(phba, ndlp);
 	}
 
 	if (ndlp->nlp_disc_refcnt) {
@@ -1896,14 +1886,8 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 			/* Since this node is marked for discovery,
 			 * delay timeout is not needed.
 			 */
-			if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-				ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-				del_timer_sync(&ndlp->nlp_delayfunc);
-				if (!list_empty(&ndlp->els_retry_evt.
-								evt_listp))
-					list_del_init(&ndlp->els_retry_evt.
-						      		evt_listp);
-			}
+			if (ndlp->nlp_flag & NLP_DELAY_TMO)
+				lpfc_cancel_retry_delay_tmo(phba, ndlp);
 		} else {
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 			ndlp = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8affc15..3d77bd9 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -259,13 +259,8 @@ lpfc_els_abort(struct lpfc_hba * phba, s
 	} while(found);
 
 	/* If we are delaying issuing an ELS command, cancel it */
-	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-		ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-		ndlp->nlp_last_elscmd = 0;
-		del_timer_sync(&ndlp->nlp_delayfunc);
-		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
-			list_del_init(&ndlp->els_retry_evt.evt_listp);
-	}
+	if (ndlp->nlp_flag & NLP_DELAY_TMO)
+		lpfc_cancel_retry_delay_tmo(phba, ndlp);
 	return 0;
 }
 
@@ -1496,7 +1491,7 @@ lpfc_rcv_plogi_npr_node(struct lpfc_hba 
 
 	if (lpfc_rcv_plogi(phba, ndlp, cmdiocb)) {
 		spin_lock_irq(phba->host->host_lock);
-		ndlp->nlp_flag &= ~(NLP_NPR_ADISC | NLP_NPR_2B_DISC);
+		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 		spin_unlock_irq(phba->host->host_lock);
 		return ndlp->nlp_state;
 	}
@@ -1693,16 +1688,10 @@ lpfc_device_recov_npr_node(struct lpfc_h
 {
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	spin_unlock_irq(phba->host->host_lock);
 	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-		ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
-			list_del_init(&ndlp->els_retry_evt.evt_listp);
-		spin_unlock_irq(phba->host->host_lock);
-		ndlp->nlp_last_elscmd = 0;
-		del_timer_sync(&ndlp->nlp_delayfunc);
-		return ndlp->nlp_state;
+		lpfc_cancel_retry_delay_tmo(phba, ndlp);
 	}
-	spin_unlock_irq(phba->host->host_lock);
 	return ndlp->nlp_state;
 }
 


