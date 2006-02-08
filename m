From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 21/22] lpfc 8.1.2 : Modify RSCN handling to unregister rpis
 on lost FCP_TARGETs immediately
Date: Wed, 08 Feb 2006 10:43:30 -0500
Message-ID: <43EA11A2.6050404@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57485 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161075AbWBHPng
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:43:36 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18FhYrf011955
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:43:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Modify RSCN handling to unregister rpis on lost FCP_TARGETs immediately


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -323,6 +323,7 @@ lpfc_ns_rsp(struct lpfc_hba * phba, stru
  	struct lpfc_sli_ct_request *Response =
  		(struct lpfc_sli_ct_request *) mp->virt;
  	struct lpfc_nodelist *ndlp = NULL;
+	struct lpfc_nodelist *next_ndlp;
  	struct lpfc_dmabuf *mlast, *next_mp;
  	uint32_t *ctptr = (uint32_t *) & Response->un.gid.PortType;
  	uint32_t Did;
@@ -391,8 +392,36 @@ lpfc_ns_rsp(struct lpfc_hba * phba, stru
  nsout1:
  	list_del(&head);

-	/* Here we are finished in the case RSCN */
+	/*
+ 	 * The driver has cycled through all Nports in the RSCN payload.
+ 	 * Complete the handling by cleaning up and marking the
+ 	 * current driver state.
+ 	 */
  	if (phba->hba_state == LPFC_HBA_READY) {
+
+		/*
+		 * Switch ports that connect a loop of multiple targets need
+		 * special consideration.  The driver wants to unregister the
+		 * rpi only on the target that was pulled from the loop.  On
+		 * RSCN, the driver wants to rediscover an NPort only if the
+		 * driver flagged it as NLP_NPR_2B_DISC.  Provided adisc is
+		 * not enabled and the NPort is not capable of retransmissions
+		 * (FC Tape) prevent timing races with the scsi error handler by
+		 * unregistering the Nport's RPI.  This action causes all
+		 * outstanding IO to flush back to the midlayer.
+		 */
+		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
+					 nlp_listp) {
+			if (!(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
+			    (lpfc_rscn_payload_check(phba, ndlp->nlp_DID))) {
+				if ((phba->cfg_use_adisc == 0) &&
+				    !(ndlp->nlp_fcp_info &
+				      NLP_FCP_2_DEVICE)) {
+					lpfc_unreg_rpi(phba, ndlp);
+					ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+				}
+			}
+		}
  		lpfc_els_flush_rscn(phba);
  		spin_lock_irq(phba->host->host_lock);
  		phba->fc_flag |= FC_RSCN_MODE; /* we are still in RSCN mode */

