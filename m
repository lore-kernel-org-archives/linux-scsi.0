From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/7] lpfc 8.1.5 : Fix Discovery processing for NPorts that
	hit nodev_tmo during discovery
Date: Sat, 15 Apr 2006 11:52:56 -0400
Message-ID: <1145116376.3795.0.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38067 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030274AbWDOPw7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 11:52:59 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k3FFqwrf011028
	for <linux-scsi@vger.kernel.org>; Sat, 15 Apr 2006 08:52:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix Discovery processing for NPorts that hit nodev_tmo during discovery

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1238,6 +1238,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 						evt_listp);
 
 		}
+		nlp->nlp_flag &= ~NLP_NODEV_REMOVE;
 		nlp->nlp_type |= NLP_FC_NODE;
 		break;
 	case NLP_MAPPED_LIST:
@@ -1258,6 +1259,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 						evt_listp);
 
 		}
+		nlp->nlp_flag &= ~NLP_NODEV_REMOVE;
 		break;
 	case NLP_NPR_LIST:
 		nlp->nlp_flag |= list;
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -832,11 +832,17 @@ static uint32_t
 lpfc_device_rm_plogi_issue(struct lpfc_hba * phba,
 			   struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
-	/* software abort outstanding PLOGI */
-	lpfc_els_abort(phba, ndlp, 1);
+	if(ndlp->nlp_flag & NLP_NPR_2B_DISC) {
+		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
+		return ndlp->nlp_state;
+	}
+	else {
+		/* software abort outstanding PLOGI */
+		lpfc_els_abort(phba, ndlp, 1);
 
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return NLP_STE_FREED_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		return NLP_STE_FREED_NODE;
+	}
 }
 
 static uint32_t
@@ -851,7 +857,7 @@ lpfc_device_recov_plogi_issue(struct lpf
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
 
 	return ndlp->nlp_state;
@@ -987,11 +993,17 @@ lpfc_device_rm_adisc_issue(struct lpfc_h
 			    struct lpfc_nodelist * ndlp, void *arg,
 			    uint32_t evt)
 {
-	/* software abort outstanding ADISC */
-	lpfc_els_abort(phba, ndlp, 1);
+	if(ndlp->nlp_flag & NLP_NPR_2B_DISC) {
+		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
+		return ndlp->nlp_state;
+	}
+	else {
+		/* software abort outstanding ADISC */
+		lpfc_els_abort(phba, ndlp, 1);
 
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return NLP_STE_FREED_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		return NLP_STE_FREED_NODE;
+	}
 }
 
 static uint32_t
@@ -1006,7 +1018,7 @@ lpfc_device_recov_adisc_issue(struct lpf
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	ndlp->nlp_flag |= NLP_NPR_ADISC;
 	spin_unlock_irq(phba->host->host_lock);
 
@@ -1133,8 +1145,14 @@ lpfc_device_rm_reglogin_issue(struct lpf
 			      struct lpfc_nodelist * ndlp, void *arg,
 			      uint32_t evt)
 {
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return NLP_STE_FREED_NODE;
+	if(ndlp->nlp_flag & NLP_NPR_2B_DISC) {
+		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
+		return ndlp->nlp_state;
+	}
+	else {
+		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		return NLP_STE_FREED_NODE;
+	}
 }
 
 static uint32_t
@@ -1146,7 +1164,7 @@ lpfc_device_recov_reglogin_issue(struct 
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
 	return ndlp->nlp_state;
 }
@@ -1278,11 +1296,17 @@ static uint32_t
 lpfc_device_rm_prli_issue(struct lpfc_hba * phba,
 			  struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
-	/* software abort outstanding PRLI */
-	lpfc_els_abort(phba, ndlp, 1);
+	if(ndlp->nlp_flag & NLP_NPR_2B_DISC) {
+		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
+		return ndlp->nlp_state;
+	}
+	else {
+		/* software abort outstanding PLOGI */
+		lpfc_els_abort(phba, ndlp, 1);
 
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return NLP_STE_FREED_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		return NLP_STE_FREED_NODE;
+	}
 }
 

@@ -1313,7 +1337,7 @@ lpfc_device_recov_prli_issue(struct lpfc
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
 	return ndlp->nlp_state;
 }
@@ -1386,7 +1410,7 @@ lpfc_device_recov_unmap_node(struct lpfc
 	ndlp->nlp_prev_state = NLP_STE_UNMAPPED_NODE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	lpfc_disc_set_adisc(phba, ndlp);
 
 	return ndlp->nlp_state;
@@ -1469,7 +1493,7 @@ lpfc_device_recov_mapped_node(struct lpf
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
 	lpfc_disc_set_adisc(phba, ndlp);
 	return ndlp->nlp_state;
@@ -1617,9 +1641,16 @@ lpfc_cmpl_plogi_npr_node(struct lpfc_hba
 			  struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
+	IOCB_t *irsp;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
+
+	irsp = &rspiocb->iocb;
+	if (irsp->ulpStatus) {
+		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		return NLP_STE_FREED_NODE;
+	}
 	return ndlp->nlp_state;
 }
 
@@ -1628,9 +1659,16 @@ lpfc_cmpl_prli_npr_node(struct lpfc_hba 
 			  struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
+	IOCB_t *irsp;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
+
+	irsp = &rspiocb->iocb;
+	if (irsp->ulpStatus && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
+		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		return NLP_STE_FREED_NODE;
+	}
 	return ndlp->nlp_state;
 }
 
@@ -1649,9 +1687,16 @@ lpfc_cmpl_adisc_npr_node(struct lpfc_hba
 			    uint32_t evt)
 {
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
+	IOCB_t *irsp;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
+
+	irsp = &rspiocb->iocb;
+	if (irsp->ulpStatus && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
+		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		return NLP_STE_FREED_NODE;
+	}
 	return ndlp->nlp_state;
 }
 
@@ -1668,7 +1713,12 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_
 
 	if (!mb->mbxStatus)
 		ndlp->nlp_rpi = mb->un.varWords[0];
-
+	else {
+		if (ndlp->nlp_flag & NLP_NODEV_REMOVE) {
+			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+			return NLP_STE_FREED_NODE;
+		}
+	}
 	return ndlp->nlp_state;
 }
 
@@ -1677,6 +1727,10 @@ lpfc_device_rm_npr_node(struct lpfc_hba 
 			    struct lpfc_nodelist * ndlp, void *arg,
 			    uint32_t evt)
 {
+	if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
+		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
+		return ndlp->nlp_state;
+	}
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 	return NLP_STE_FREED_NODE;
 }
@@ -1687,7 +1741,7 @@ lpfc_device_recov_npr_node(struct lpfc_h
 			    uint32_t evt)
 {
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
 	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
 		lpfc_cancel_retry_delay_tmo(phba, ndlp);
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -113,6 +113,7 @@ struct lpfc_nodelist {
 #define NLP_NPR_ADISC      0x2000000	/* Issue ADISC when dq'ed from
 					   NPR list */
 #define NLP_DELAY_REMOVE   0x4000000	/* Defer removal till end of DSM */
+#define NLP_NODEV_REMOVE   0x8000000	/* Defer removal till discovery ends */
 
 /* Defines for list searchs */
 #define NLP_SEARCH_MAPPED    0x1	/* search mapped */


