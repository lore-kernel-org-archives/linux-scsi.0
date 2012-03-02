From: James Smart <james.smart@emulex.com>
Subject: [PATCH 07/21] lpfc 8.3.30: Fixed missing CVL event causing FCF
 failover
Date: Thu, 1 Mar 2012 22:35:45 -0500
Message-ID: <1330659347.18500.34.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38854 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756462Ab2CBDgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:36:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed missing CVL event causing round-robin FCF failover process
 to stop (CR: 123367)


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    2 ++
 lpfc_els.c     |   15 ++++++++++++---
 lpfc_hbadisc.c |   13 ++++++-------
 lpfc_init.c    |    2 ++
 lpfc_sli.c     |    1 +
 5 files changed, 23 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-03-01 17:33:40.000000000 -0500
@@ -925,9 +925,17 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		 * due to new FCF discovery
 		 */
 		if ((phba->hba_flag & HBA_FIP_SUPPORT) &&
-		    (phba->fcf.fcf_flag & FCF_DISCOVERY) &&
-		    !((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-		     (irsp->un.ulpWord[4] == IOERR_SLI_ABORTED))) {
+		    (phba->fcf.fcf_flag & FCF_DISCOVERY)) {
+			if (phba->link_state < LPFC_LINK_UP)
+				goto stop_rr_fcf_flogi;
+			if ((phba->fcoe_cvl_eventtag_attn ==
+			     phba->fcoe_cvl_eventtag) &&
+			    (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
+			    (irsp->un.ulpWord[4] == IOERR_SLI_ABORTED))
+				goto stop_rr_fcf_flogi;
+			else
+				phba->fcoe_cvl_eventtag_attn =
+					phba->fcoe_cvl_eventtag;
 			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP | LOG_ELS,
 					"2611 FLOGI failed on FCF (x%x), "
 					"status:x%x/x%x, tmo:x%x, perform "
@@ -943,6 +951,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 				goto out;
 		}
 
+stop_rr_fcf_flogi:
 		/* FLOGI failure */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				"2858 FLOGI failure Status:x%x/x%x TMO:x%x\n",
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2012-03-01 17:33:40.000000000 -0500
@@ -908,6 +908,8 @@ struct lpfc_hba {
 	atomic_t fast_event_count;
 	uint32_t fcoe_eventtag;
 	uint32_t fcoe_eventtag_at_fcf_scan;
+	uint32_t fcoe_cvl_eventtag;
+	uint32_t fcoe_cvl_eventtag_attn;
 	struct lpfc_fcf fcf;
 	uint8_t fc_map[3];
 	uint8_t valid_vlan;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-03-01 17:33:40.000000000 -0500
@@ -5673,14 +5673,13 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 				ret = 1;
 				spin_unlock_irq(shost->host_lock);
 				goto out;
-			} else {
+			} else if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
+				ret = 1;
 				lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-					"2624 RPI %x DID %x flg %x still "
-					"logged in\n",
-					ndlp->nlp_rpi, ndlp->nlp_DID,
-					ndlp->nlp_flag);
-				if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
-					ret = 1;
+						"2624 RPI %x DID %x flag %x "
+						"still logged in\n",
+						ndlp->nlp_rpi, ndlp->nlp_DID,
+						ndlp->nlp_flag);
 			}
 		}
 		spin_unlock_irq(shost->host_lock);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:39.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:40.000000000 -0500
@@ -3725,6 +3725,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 		break;
 
 	case LPFC_FIP_EVENT_TYPE_FCF_DEAD:
+		phba->fcoe_cvl_eventtag = acqe_fip->event_tag;
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
 			"2549 FCF (x%x) disconnected from network, "
 			"tag:x%x\n", acqe_fip->index, acqe_fip->event_tag);
@@ -3786,6 +3787,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 		}
 		break;
 	case LPFC_FIP_EVENT_TYPE_CVL:
+		phba->fcoe_cvl_eventtag = acqe_fip->event_tag;
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
 			"2718 Clear Virtual Link Received for VPI 0x%x"
 			" tag 0x%x\n", acqe_fip->index, acqe_fip->event_tag);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:39.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:40.000000000 -0500
@@ -15052,6 +15052,7 @@ lpfc_sli4_fcf_scan_read_fcf_rec(struct l
 	LPFC_MBOXQ_t *mboxq;
 
 	phba->fcoe_eventtag_at_fcf_scan = phba->fcoe_eventtag;
+	phba->fcoe_cvl_eventtag_attn = phba->fcoe_cvl_eventtag;
 	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,



