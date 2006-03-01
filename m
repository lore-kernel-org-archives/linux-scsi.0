From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 5/22] lpfc 8.1.2: Fixed a race condition in the PLOGI retry logic.
Date: Tue, 28 Feb 2006 19:25:16 -0500
Message-ID: <20060301002516.GA15396@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:42918 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932738AbWCAAZS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:18 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PG2s015402
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:16 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PGT4015401
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed a race condition in the PLOGI retry logic.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1627,6 +1627,14 @@ lpfc_device_recov_npr_node(struct lpfc_h
 {
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
+		ndlp->nlp_flag &= ~NLP_DELAY_TMO;
+		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
+			list_del_init(&ndlp->els_retry_evt.evt_listp);
+		spin_unlock_irq(phba->host->host_lock);
+		del_timer_sync(&ndlp->nlp_delayfunc);
+		return (ndlp->nlp_state);
+	}
 	spin_unlock_irq(phba->host->host_lock);
 	return (ndlp->nlp_state);
 }
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1467,24 +1467,28 @@ lpfc_els_retry_delay_handler(struct lpfc
 		lpfc_issue_els_flogi(phba, ndlp, retry);
 		break;
 	case ELS_CMD_PLOGI:
-		ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-		lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-		lpfc_issue_els_plogi(phba, ndlp, retry);
+		if (!lpfc_issue_els_plogi(phba, ndlp, retry)) {
+			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
+			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+		}
 		break;
 	case ELS_CMD_ADISC:
-		ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
-		lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
-		lpfc_issue_els_adisc(phba, ndlp, retry);
+		if (!lpfc_issue_els_adisc(phba, ndlp, retry)) {
+			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
+			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
+		}
 		break;
 	case ELS_CMD_PRLI:
-		ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
-		lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
-		lpfc_issue_els_prli(phba, ndlp, retry);
+		if (!lpfc_issue_els_prli(phba, ndlp, retry)) {
+			ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
+			lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
+		}
 		break;
 	case ELS_CMD_LOGO:
-		ndlp->nlp_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
-		lpfc_issue_els_logo(phba, ndlp, retry);
+		if (!lpfc_issue_els_logo(phba, ndlp, retry)) {
+			ndlp->nlp_state = NLP_STE_NPR_NODE;
+			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		}
 		break;
 	}
 	return;
