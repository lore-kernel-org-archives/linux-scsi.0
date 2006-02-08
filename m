From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/22] lpfc 8.1.2 : Fixed a race condition in the PLOGI retry
 logic.
Date: Wed, 08 Feb 2006 10:41:38 -0500
Message-ID: <43EA1132.2080804@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:28301 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030439AbWBHPln
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:41:43 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Fffrf011831
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:41:42 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Fixed a race condition in the PLOGI retry logic.


Signed-off-by: James Smart <James.Smart@emulex.com>

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

