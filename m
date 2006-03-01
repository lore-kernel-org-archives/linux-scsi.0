From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 21/22] lpfc 8.1.2: Modify RSCN handling to unregister rpis on lost FCP_TARGETs immediately
Date: Tue, 28 Feb 2006 19:25:38 -0500
Message-ID: <20060301002538.GA15594@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:63936 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964870AbWCAAZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:40 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210Pc4w015600
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:38 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PcgN015599
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Modify RSCN handling to unregister rpis on lost FCP_TARGETs immediately

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

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
