From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 17/19] Fix implicit logo and RSCN handling for NVMET
Date: Tue,  4 Apr 2017 10:17:10 -0700
Message-ID: <1491326232-11255-18-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38163 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755090AbdDDRZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:39 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 34DE430C09E
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:36 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

Symptoms: NVMET didn't have any RSCN handling at all and
would not execute implicit LOGO when receiving a PLOGI
from an rport that NVMET had in state UNMAPPED.

Clean up the logic in lpfc_nlp_state_cleanup for
initiators (FCP and NVME). NVMET should not respond to
RSCN including allocating new ndlps so this code was
conditionalized when nvmet_support is true.  The check
for NLP_RCV_PLOGI in lpfc_setup_disc_node was moved
below the check for nvmet_support to allow the NVMET
to recover initiator nodes correctly.  The implicit
logo was introduced with lpfc_rcv_plogi when NVMET gets
a PLOGI on an ndlp in UNMAPPED state.  The RSCN handling
was modified to not respond to an RSCN in NVMET.  Instead
NVMET sends a GID_FT and determines if an NVMEP_INITIATOR
it has is UNMAPPED but no longer in the zone membership.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c        | 68 +++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_disc.h      |  1 +
 drivers/scsi/lpfc/lpfc_els.c       | 23 ++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 62 ++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  8 +++--
 5 files changed, 110 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index d3e9af9..7e6a38f 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -537,19 +537,53 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 	}
 }
 
+static void
+lpfc_ns_rsp_audit_did(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_nodelist *ndlp = NULL;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+
+	/*
+	 * To conserve rpi's, filter out addresses for other
+	 * vports on the same physical HBAs.
+	 */
+	if (Did != vport->fc_myDID &&
+	    (!lpfc_find_vport_by_did(phba, Did) ||
+	     vport->cfg_peer_port_login)) {
+		if (!phba->nvmet_support) {
+			/* FCPI/NVMEI path. Process Did */
+			lpfc_prep_node_fc4type(vport, Did, fc4_type);
+		} else {
+			/* NVMET path.  NVMET only cares about NVMEI nodes. */
+			list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
+				if (ndlp->nlp_type != NLP_NVME_INITIATOR ||
+				    ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
+					continue;
+				spin_lock_irq(shost->host_lock);
+				if (ndlp->nlp_DID == Did)
+					ndlp->nlp_flag &= ~NLP_NVMET_RECOV;
+				else
+					ndlp->nlp_flag |= NLP_NVMET_RECOV;
+				spin_unlock_irq(shost->host_lock);
+			}
+		}
+	}
+}
+
 static int
 lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
 	    uint32_t Size)
 {
-	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_sli_ct_request *Response =
 		(struct lpfc_sli_ct_request *) mp->virt;
-	struct lpfc_nodelist *ndlp = NULL;
 	struct lpfc_dmabuf *mlast, *next_mp;
 	uint32_t *ctptr = (uint32_t *) & Response->un.gid.PortType;
 	uint32_t Did, CTentry;
 	int Cnt;
 	struct list_head head;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_nodelist *ndlp = NULL;
 
 	lpfc_set_disctmo(vport);
 	vport->num_disc_nodes = 0;
@@ -574,19 +608,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
 			/* Get next DID from NameServer List */
 			CTentry = *ctptr++;
 			Did = ((be32_to_cpu(CTentry)) & Mask_DID);
-
-			ndlp = NULL;
-
-			/*
-			 * Check for rscn processing or not
-			 * To conserve rpi's, filter out addresses for other
-			 * vports on the same physical HBAs.
-			 */
-			if ((Did != vport->fc_myDID) &&
-			    ((lpfc_find_vport_by_did(phba, Did) == NULL) ||
-			     vport->cfg_peer_port_login))
-				lpfc_prep_node_fc4type(vport, Did, fc4_type);
-
+			lpfc_ns_rsp_audit_did(vport, Did, fc4_type);
 			if (CTentry & (cpu_to_be32(SLI_CT_LAST_ENTRY)))
 				goto nsout1;
 
@@ -596,6 +618,22 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
 
 	}
 
+	/* All GID_FT entries processed.  If the driver is running in
+	 * in target mode, put impacted nodes into recovery and drop
+	 * the RPI to flush outstanding IO.
+	 */
+	if (vport->phba->nvmet_support) {
+		list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
+			if (!(ndlp->nlp_flag & NLP_NVMET_RECOV))
+				continue;
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+						NLP_EVT_DEVICE_RECOVERY);
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag &= ~NLP_NVMET_RECOV;
+			spin_lock_irq(shost->host_lock);
+		}
+	}
+
 nsout1:
 	list_del(&head);
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index f4ff99d..9d5a379 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -157,6 +157,7 @@ struct lpfc_node_rrq {
 #define NLP_LOGO_SND       0x00000100	/* sent LOGO request for this entry */
 #define NLP_RNID_SND       0x00000400	/* sent RNID request for this entry */
 #define NLP_ELS_SND_MASK   0x000007e0	/* sent ELS request for this entry */
+#define NLP_NVMET_RECOV    0x00001000   /* NVMET auditing node for recovery. */
 #define NLP_DEFER_RM       0x00010000	/* Remove this ndlp if no longer used */
 #define NLP_DELAY_TMO      0x00020000	/* delay timeout is running for node */
 #define NLP_NPR_2B_DISC    0x00040000	/* node is included in num_disc_nodes */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 35fc260..8d1c689 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5861,8 +5861,11 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 		    (ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
 		    !lpfc_rscn_payload_check(vport, ndlp->nlp_DID))
 			continue;
+
+		/* NVME Target mode does not do RSCN Recovery. */
 		if (vport->phba->nvmet_support)
 			continue;
+
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
@@ -6150,22 +6153,16 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
 	    && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
-		/* Good ndlp, issue CT Request to NameServer */
+		/* Good ndlp, issue CT Request to NameServer.  Need to
+		 * know how many gidfts were issued.  If none, then just
+		 * flush the RSCN.  Otherwise, the outstanding requests
+		 * need to complete.
+		 */
 		vport->gidft_inp = 0;
-		if (lpfc_issue_gidft(vport) == 0)
-			/* Wait for NameServer query cmpl before we can
-			 * continue
-			 */
+		if (lpfc_issue_gidft(vport) > 0)
 			return 1;
 	} else {
-		/* If login to NameServer does not exist, issue one */
-		/* Good status, issue PLOGI to NameServer */
-		ndlp = lpfc_findnode_did(vport, NameServer_DID);
-		if (ndlp && NLP_CHK_NODE_ACT(ndlp))
-			/* Wait for NameServer login cmpl before we can
-			   continue */
-			return 1;
-
+		/* Nameserver login in question.  Revalidate. */
 		if (ndlp) {
 			ndlp = lpfc_enable_node(vport, ndlp,
 						NLP_STE_PLOGI_ISSUE);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index e824ec1..828fdee 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4148,7 +4148,6 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		       int old_state, int new_state)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_hba *phba = vport->phba;
 
 	if (new_state == NLP_STE_UNMAPPED_NODE) {
 		ndlp->nlp_flag &= ~NLP_NODEV_REMOVE;
@@ -4167,14 +4166,14 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			lpfc_unregister_remote_port(ndlp);
 		}
 
-		/* Notify the NVME transport of this rport's loss */
-		if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
-		     (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) &&
-		    (vport->phba->nvmet_support == 0) &&
-		    ((ndlp->nlp_fc4_type & NLP_FC4_NVME) ||
-		    (ndlp->nlp_DID == Fabric_DID))) {
+		/* Notify the NVME transport of this rport's loss on the
+		 * Initiator.  For NVME Target, should upcall transport
+		 * in the else clause when API available.
+		 */
+		if (ndlp->nlp_fc4_type & NLP_FC4_NVME) {
 			vport->phba->nport_event_cnt++;
-			lpfc_nvme_unregister_port(vport, ndlp);
+			if (vport->phba->nvmet_support == 0)
+				lpfc_nvme_unregister_port(vport, ndlp);
 		}
 	}
 
@@ -5128,6 +5127,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 
 	ndlp = lpfc_findnode_did(vport, did);
 	if (!ndlp) {
+		if (vport->phba->nvmet_support)
+			return NULL;
 		if ((vport->fc_flag & FC_RSCN_MODE) != 0 &&
 		    lpfc_rscn_payload_check(vport, did) == 0)
 			return NULL;
@@ -5135,56 +5136,73 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		if (!ndlp)
 			return NULL;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-		if (vport->phba->nvmet_support)
-			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
 		return ndlp;
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		if (vport->phba->nvmet_support)
+			return NULL;
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
 		if (!ndlp)
 			return NULL;
-		if (vport->phba->nvmet_support)
-			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
 		return ndlp;
 	}
 
+	/* The NVME Target does not want to actively manage an rport.
+	 * The goal is to allow the target to reset its state and clear
+	 * pending IO in preparation for the initiator to recover.
+	 */
 	if ((vport->fc_flag & FC_RSCN_MODE) &&
 	    !(vport->fc_flag & FC_NDISC_ACTIVE)) {
 		if (lpfc_rscn_payload_check(vport, did)) {
-			/* If we've already received a PLOGI from this NPort
-			 * we don't need to try to discover it again.
-			 */
-			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
-				return NULL;
 
 			/* Since this node is marked for discovery,
 			 * delay timeout is not needed.
 			 */
 			lpfc_cancel_retry_delay_tmo(vport, ndlp);
+
+			/* NVME Target mode waits until rport is known to be
+			 * impacted by the RSCN before it transitions.  No
+			 * active management - just go to NPR provided the
+			 * node had a valid login.
+			 */
 			if (vport->phba->nvmet_support)
 				return ndlp;
+
+			/* If we've already received a PLOGI from this NPort
+			 * we don't need to try to discover it again.
+			 */
+			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
+				return NULL;
+
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
 		} else
 			ndlp = NULL;
 	} else {
-		/* If we've already received a PLOGI from this NPort,
-		 * or we are already in the process of discovery on it,
-		 * we don't need to try to discover it again.
+		/* If the initiator received a PLOGI from this NPort or if the
+		 * initiator is already in the process of discovery on it,
+		 * there's no need to try to discover it again.
 		 */
 		if (ndlp->nlp_state == NLP_STE_ADISC_ISSUE ||
 		    ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
-		    ndlp->nlp_flag & NLP_RCV_PLOGI)
+		    (!vport->phba->nvmet_support &&
+		     ndlp->nlp_flag & NLP_RCV_PLOGI))
 			return NULL;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+
 		if (vport->phba->nvmet_support)
 			return ndlp;
+
+		/* Moving to NPR state clears unsolicited flags and
+		 * allows for rediscovery
+		 */
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 061626b..8777c2d 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -361,8 +361,12 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	case  NLP_STE_PRLI_ISSUE:
 	case  NLP_STE_UNMAPPED_NODE:
 	case  NLP_STE_MAPPED_NODE:
-		/* lpfc_plogi_confirm_nport skips fabric did, handle it here */
-		if (!(ndlp->nlp_type & NLP_FABRIC)) {
+		/* For initiators, lpfc_plogi_confirm_nport skips fabric did.
+		 * For target mode, execute implicit logo.
+		 * Fabric nodes go into NPR.
+		 */
+		if (!(ndlp->nlp_type & NLP_FABRIC) &&
+		    !(phba->nvmet_support)) {
 			lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb,
 					 ndlp, NULL);
 			return 1;
-- 
2.1.0
