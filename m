From: James Smart <james.smart@emulex.com>
Subject: [PATCH 16/20] lpfc 8.3.31: Fix unsol abts xri lookup
Date: Wed, 9 May 2012 21:19:14 -0400
Message-ID: <1336612755.1996.45.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27899 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756994Ab2EJBTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:19:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix unsol abts xri lookup.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c  |    8 +++++---
 lpfc_scsi.c |    9 +++++----
 lpfc_sli.c  |   22 +++++++++++++++-------
 3 files changed, 25 insertions(+), 14 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-05-07 10:01:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-05-07 10:01:26.000000000 -0400
@@ -3003,7 +3003,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 			 * ABTS we cannot generate and RRQ.
 			 */
 			lpfc_set_rrq_active(phba, ndlp,
-					 cmdiocb->sli4_xritag, 0, 0);
+					 cmdiocb->sli4_lxritag, 0, 0);
 		}
 		break;
 	case IOSTAT_LOCAL_REJECT:
@@ -5673,7 +5673,7 @@ lpfc_issue_els_rrq(struct lpfc_vport *vp
 	pcmd += sizeof(uint32_t);
 	els_rrq = (struct RRQ *) pcmd;
 
-	bf_set(rrq_oxid, els_rrq, rrq->xritag);
+	bf_set(rrq_oxid, els_rrq, phba->sli4_hba.xri_ids[rrq->xritag]);
 	bf_set(rrq_rxid, els_rrq, rrq->rxid);
 	bf_set(rrq_did, els_rrq, vport->fc_myDID);
 	els_rrq->rrq = cpu_to_be32(els_rrq->rrq);
@@ -7960,7 +7960,9 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hb
 			sglq_entry->state = SGL_FREED;
 			spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
-			lpfc_set_rrq_active(phba, ndlp, xri, rxid, 1);
+			lpfc_set_rrq_active(phba, ndlp,
+				sglq_entry->sli4_lxritag,
+				rxid, 1);
 
 			/* Check if TXQ queue needs to be serviced */
 			if (pring->txq_cnt)
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:26.000000000 -0400
@@ -696,7 +696,8 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hb
 			rrq_empty = list_empty(&phba->active_rrq_list);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			if (ndlp) {
-				lpfc_set_rrq_active(phba, ndlp, xri, rxid, 1);
+				lpfc_set_rrq_active(phba, ndlp,
+					psb->cur_iocbq.sli4_lxritag, rxid, 1);
 				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
 			}
 			lpfc_release_scsi_buf_s4(phba, psb);
@@ -1099,7 +1100,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *ph
 	list_for_each_entry(lpfc_cmd, &phba->lpfc_scsi_buf_list,
 							list) {
 		if (lpfc_test_rrq_active(phba, ndlp,
-					 lpfc_cmd->cur_iocbq.sli4_xritag))
+					 lpfc_cmd->cur_iocbq.sli4_lxritag))
 			continue;
 		list_del(&lpfc_cmd->list);
 		found = 1;
@@ -3758,8 +3759,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 				 * ABTS we cannot generate and RRQ.
 				 */
 				lpfc_set_rrq_active(phba, pnode,
-						lpfc_cmd->cur_iocbq.sli4_xritag,
-						0, 0);
+					lpfc_cmd->cur_iocbq.sli4_lxritag,
+					0, 0);
 			}
 		/* else: fall through */
 		default:
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:26.000000000 -0400
@@ -885,7 +885,7 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 	while (!found) {
 		if (!sglq)
 			return NULL;
-		if (lpfc_test_rrq_active(phba, ndlp, sglq->sli4_xritag)) {
+		if (lpfc_test_rrq_active(phba, ndlp, sglq->sli4_lxritag)) {
 			/* This xri has an rrq outstanding for this DID.
 			 * put it back in the list and get another xri.
 			 */
@@ -13953,7 +13953,6 @@ lpfc_sli4_xri_inrange(struct lpfc_hba *p
 	return NO_XRI;
 }
 
-
 /**
  * lpfc_sli4_seq_abort_rsp - bls rsp to sequence abort
  * @phba: Pointer to HBA context object.
@@ -13968,7 +13967,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba 
 {
 	struct lpfc_iocbq *ctiocb = NULL;
 	struct lpfc_nodelist *ndlp;
-	uint16_t oxid, rxid;
+	uint16_t oxid, rxid, xri, lxri;
 	uint32_t sid, fctl;
 	IOCB_t *icmd;
 	int rc;
@@ -13987,8 +13986,6 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba 
 				"SID:x%x\n", oxid, sid);
 		return;
 	}
-	if (lpfc_sli4_xri_inrange(phba, rxid))
-		lpfc_set_rrq_active(phba, ndlp, rxid, oxid, 0);
 
 	/* Allocate buffer for rsp iocb */
 	ctiocb = lpfc_sli_get_iocbq(phba);
@@ -14019,13 +14016,24 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba 
 	ctiocb->sli4_lxritag = NO_XRI;
 	ctiocb->sli4_xritag = NO_XRI;
 
+	if (fctl & FC_FC_EX_CTX)
+		/* Exchange responder sent the abort so we
+		 * own the oxid.
+		 */
+		xri = oxid;
+	else
+		xri = rxid;
+	lxri = lpfc_sli4_xri_inrange(phba, xri);
+	if (lxri != NO_XRI)
+		lpfc_set_rrq_active(phba, ndlp, lxri,
+			(xri == oxid) ? rxid : oxid, 0);
 	/* If the oxid maps to the FCP XRI range or if it is out of range,
 	 * send a BLS_RJT.  The driver no longer has that exchange.
 	 * Override the IOCB for a BA_RJT.
 	 */
-	if (oxid > (phba->sli4_hba.max_cfg_param.max_xri +
+	if (xri > (phba->sli4_hba.max_cfg_param.max_xri +
 		    phba->sli4_hba.max_cfg_param.xri_base) ||
-	    oxid > (lpfc_sli4_get_els_iocb_cnt(phba) +
+	    xri > (lpfc_sli4_get_els_iocb_cnt(phba) +
 		    phba->sli4_hba.max_cfg_param.xri_base)) {
 		icmd->un.xseq64.w5.hcsw.Rctl = FC_RCTL_BA_RJT;
 		bf_set(lpfc_vndr_code, &icmd->un.bls_rsp, 0);



