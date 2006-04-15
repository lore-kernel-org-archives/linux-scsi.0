From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/7] lpfc 8.1.5 : Additional fixes to LOGO, PLOGI, and RSCN
	processing
Date: Sat, 15 Apr 2006 11:53:15 -0400
Message-ID: <1145116395.3795.4.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41139 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030278AbWDOPxU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 11:53:20 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k3FFrJrf011044
	for <linux-scsi@vger.kernel.org>; Sat, 15 Apr 2006 08:53:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Additional fixes to LOGO, PLOGI, and RSCN processing

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1404,6 +1404,8 @@ lpfc_check_sli_ndlp(struct lpfc_hba * ph
 			if (icmd->ulpContext == (volatile ushort)ndlp->nlp_rpi)
 				return 1;
 		case CMD_ELS_REQUEST64_CR:
+			if (icmd->un.elsreq64.remoteID == ndlp->nlp_DID)
+				return 1;
 		case CMD_XMIT_ELS_RSP64_CX:
 			if (iocb->context1 == (uint8_t *) ndlp)
 				return 1;
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -777,25 +777,26 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 	if (disc && phba->num_disc_nodes) {
 		/* Check to see if there are more PLOGIs to be sent */
 		lpfc_more_plogi(phba);
-	}
 
-	if (phba->num_disc_nodes == 0) {
-		spin_lock_irq(phba->host->host_lock);
-		phba->fc_flag &= ~FC_NDISC_ACTIVE;
-		spin_unlock_irq(phba->host->host_lock);
+		if (phba->num_disc_nodes == 0) {
+			spin_lock_irq(phba->host->host_lock);
+			phba->fc_flag &= ~FC_NDISC_ACTIVE;
+			spin_unlock_irq(phba->host->host_lock);
 
-		lpfc_can_disctmo(phba);
-		if (phba->fc_flag & FC_RSCN_MODE) {
-			/* Check to see if more RSCNs came in while we were
-			 * processing this one.
-			 */
-			if ((phba->fc_rscn_id_cnt == 0) &&
-			    (!(phba->fc_flag & FC_RSCN_DISCOVERY))) {
-				spin_lock_irq(phba->host->host_lock);
-				phba->fc_flag &= ~FC_RSCN_MODE;
-				spin_unlock_irq(phba->host->host_lock);
-			} else {
-				lpfc_els_handle_rscn(phba);
+			lpfc_can_disctmo(phba);
+			if (phba->fc_flag & FC_RSCN_MODE) {
+				/*
+				 * Check to see if more RSCNs came in while
+				 * we were processing this one.
+				 */
+				if ((phba->fc_rscn_id_cnt == 0) &&
+			    	(!(phba->fc_flag & FC_RSCN_DISCOVERY))) {
+					spin_lock_irq(phba->host->host_lock);
+					phba->fc_flag &= ~FC_RSCN_MODE;
+					spin_unlock_irq(phba->host->host_lock);
+				} else {
+					lpfc_els_handle_rscn(phba);
+				}
 			}
 		}
 	}
@@ -1259,7 +1260,7 @@ lpfc_issue_els_logo(struct lpfc_hba * ph
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];
 
-	cmdsize = 2 * (sizeof (uint32_t) + sizeof (struct lpfc_name));
+	cmdsize = (2 * sizeof (uint32_t)) + sizeof (struct lpfc_name);
 	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
 						ndlp->nlp_DID, ELS_CMD_LOGO);
 	if (!elsiocb)
@@ -1447,22 +1448,23 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_
 			 * PLOGIs to be sent
 			 */
 			lpfc_more_plogi(phba);
-		}
 
-		if (phba->num_disc_nodes == 0) {
-			phba->fc_flag &= ~FC_NDISC_ACTIVE;
-			lpfc_can_disctmo(phba);
-			if (phba->fc_flag & FC_RSCN_MODE) {
-				/* Check to see if more RSCNs
-				 * came in while we were
-				 * processing this one.
-				 */
-				if((phba->fc_rscn_id_cnt==0) &&
-				   (!(phba->fc_flag & FC_RSCN_DISCOVERY))) {
-					phba->fc_flag &= ~FC_RSCN_MODE;
-				}
-				else {
-					lpfc_els_handle_rscn(phba);
+			if (phba->num_disc_nodes == 0) {
+				phba->fc_flag &= ~FC_NDISC_ACTIVE;
+				lpfc_can_disctmo(phba);
+				if (phba->fc_flag & FC_RSCN_MODE) {
+					/*
+					 * Check to see if more RSCNs
+					 * came in while we were
+					 * processing this one.
+					 */
+					if((phba->fc_rscn_id_cnt==0) &&
+					 !(phba->fc_flag & FC_RSCN_DISCOVERY)) {
+						phba->fc_flag &= ~FC_RSCN_MODE;
+					}
+					else {
+						lpfc_els_handle_rscn(phba);
+					}
 				}
 			}
 		}


