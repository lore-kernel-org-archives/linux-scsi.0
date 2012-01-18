From: James Smart <james.smart@emulex.com>
Subject: [PATCH 04/07] lpfc 8.3.29: FC Discovery state machine fixes
Date: Wed, 18 Jan 2012 16:25:25 -0500
Message-ID: <1326921925.32733.13.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:33058 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751866Ab2ARVZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2012 16:25:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FC Discovery state machine fixes.

- Fix bug with driver returning the inactive ndlp (125743)
- Fix discovery problem when in pt2pt by copying old ndlp state before
  state change (126887)
- Fix ndlp nodelist not empty wait timeout during driver unloading (127052)


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |    2 +-
 lpfc_hbadisc.c |    4 ++++
 lpfc_init.c    |    9 ++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-01-18 11:32:50.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-01-18 11:33:56.000000000 -0500
@@ -1526,7 +1526,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 			memcpy(&ndlp->active_rrqs.xri_bitmap,
 				&rrq.xri_bitmap,
 				sizeof(ndlp->active_rrqs.xri_bitmap));
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		/* Since we are swapping the ndlp passed in with the new one
 		 * and the did has already been swapped, copy over the
 		 * state and names.
@@ -1536,6 +1535,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 		memcpy(&new_ndlp->nlp_nodename, &ndlp->nlp_nodename,
 			sizeof(struct lpfc_name));
 		new_ndlp->nlp_state = ndlp->nlp_state;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		/* Fix up the rport accordingly */
 		rport = ndlp->rport;
 		if (rport) {
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-01-12 22:43:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-01-18 11:33:56.000000000 -0500
@@ -5332,6 +5332,10 @@ lpfc_filter_by_rpi(struct lpfc_nodelist 
 {
 	uint16_t *rpi = param;
 
+	/* check for active node */
+	if (!NLP_CHK_NODE_ACT(ndlp))
+		return 0;
+
 	return ndlp->nlp_rpi == *rpi;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-01-18 11:33:41.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-01-18 11:33:56.000000000 -0500
@@ -2341,13 +2341,20 @@ lpfc_cleanup(struct lpfc_vport *vport)
 			continue;
 		}
 
+		/* take care of nodes in unused state before the state
+		 * machine taking action.
+		 */
+		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
+			lpfc_nlp_put(ndlp);
+			continue;
+		}
+
 		if (ndlp->nlp_type & NLP_FABRIC)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					     NLP_EVT_DEVICE_RM);
-
 	}
 
 	/* At this point, ALL ndlp's should be gone



