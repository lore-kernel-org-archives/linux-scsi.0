From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/14] lpfc: Correct loss of RSCNs during array
 takeaway/giveback testing.
Date: Mon, 20 Apr 2015 09:56:34 -0400
Message-ID: <55350592.91ZVVhzucumFWSKG%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:30920 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbbDTN5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct loss of RSCNs during array takeaway/giveback testing.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6009158..e1f7085 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1514,7 +1514,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	struct fc_rport *rport;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
-	uint32_t rc, keepDID = 0;
+	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
 	int  put_node;
 	int  put_rport;
 	unsigned long *active_rrqs_xri_bitmap = NULL;
@@ -1603,9 +1603,9 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		       ndlp->active_rrqs_xri_bitmap,
 		       phba->cfg_rrq_xri_bitmap_sz);
 
-	if (ndlp->nlp_flag & NLP_NPR_2B_DISC)
-		new_ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	keep_nlp_flag = new_ndlp->nlp_flag;
+	new_ndlp->nlp_flag = ndlp->nlp_flag;
+	ndlp->nlp_flag = keep_nlp_flag;
 
 	/* Set state will put new_ndlp on to node list if not already done */
 	lpfc_nlp_set_state(vport, new_ndlp, ndlp->nlp_state);
@@ -1649,7 +1649,9 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			memcpy(ndlp->active_rrqs_xri_bitmap,
 			       active_rrqs_xri_bitmap,
 			       phba->cfg_rrq_xri_bitmap_sz);
-		lpfc_drop_node(vport, ndlp);
+
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			lpfc_drop_node(vport, ndlp);
 	}
 	else {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-- 
1.7.11.7

