From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 3/9] lpfc: Devices are not discovered during
 takeaway/giveback testing
Date: Fri, 22 May 2015 10:42:37 -0400
Message-ID: <555f405d.19aP4Ju4SItrRE4D%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35747 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbbEVOmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:45 -0400
Received: by qgew3 with SMTP id w3so9072662qge.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:44 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id f192sm1394322qhc.37.2015.05.22.07.42.43
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Devices are not discovered during takeaway/giveback testing

When a remote nport changes it's DID, a new ndlp is used.
However, we left the old ndlp state unchanged and still in
a discovery state. The may stall discovery resulting in some
devices not being discovered.  Correct by swapping the state
of the 2 ndlp's when a DID swap is detected.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 30021f3..21c4a3d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1509,12 +1509,14 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			 struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_vport    *vport = ndlp->vport;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *new_ndlp;
 	struct lpfc_rport_data *rdata;
 	struct fc_rport *rport;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
 	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
+	uint16_t keep_nlp_state;
 	int  put_node;
 	int  put_rport;
 	unsigned long *active_rrqs_xri_bitmap = NULL;
@@ -1603,11 +1605,14 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		       ndlp->active_rrqs_xri_bitmap,
 		       phba->cfg_rrq_xri_bitmap_sz);
 
+	spin_lock_irq(shost->host_lock);
 	keep_nlp_flag = new_ndlp->nlp_flag;
 	new_ndlp->nlp_flag = ndlp->nlp_flag;
 	ndlp->nlp_flag = keep_nlp_flag;
+	spin_unlock_irq(shost->host_lock);
 
-	/* Set state will put new_ndlp on to node list if not already done */
+	/* Set nlp_states accordingly */
+	keep_nlp_state = new_ndlp->nlp_state;
 	lpfc_nlp_set_state(vport, new_ndlp, ndlp->nlp_state);
 
 	/* Move this back to NPR state */
@@ -1668,20 +1673,13 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			       active_rrqs_xri_bitmap,
 			       phba->cfg_rrq_xri_bitmap_sz);
 
-		/* Since we are swapping the ndlp passed in with the new one
-		 * and the did has already been swapped, copy over state.
-		 * The new WWNs are already in new_ndlp since thats what
-		 * we looked it up by in the begining of this routine.
-		 */
-		new_ndlp->nlp_state = ndlp->nlp_state;
-
-		/* Since we are switching over to the new_ndlp, the old
-		 * ndlp should be put in the NPR state, unless we have
-		 * already started re-discovery on it.
+		/* Since we are switching over to the new_ndlp,
+		 * reset the old ndlp state
 		 */
 		if ((ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) ||
 		    (ndlp->nlp_state == NLP_STE_MAPPED_NODE))
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+			keep_nlp_state = NLP_STE_NPR_NODE;
+		lpfc_nlp_set_state(vport, ndlp, keep_nlp_state);
 
 		/* Fix up the rport accordingly */
 		rport = ndlp->rport;
-- 
1.7.11.7

