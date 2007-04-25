From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/16] lpfc 8.1.12 : Reorganize lpfc_nlp_list() and callers
	to prepare for nodelist simplification
Date: Wed, 25 Apr 2007 09:52:27 -0400
Message-ID: <1177509147.23155.12.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51640 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031003AbXDYNwT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:52:19 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDqHvS006572
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:52:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reorganize lpfc_nlp_list() and callers to prepare for nodelist simplification.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:41.000000000 -0400
@@ -43,7 +43,9 @@ void lpfc_mbx_cmpl_reg_login(struct lpfc
 void lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
-int lpfc_nlp_list(struct lpfc_hba *, struct lpfc_nodelist *, int);
+void lpfc_dequeue_node(struct lpfc_hba *, struct lpfc_nodelist *);
+void lpfc_nlp_set_state(struct lpfc_hba *, struct lpfc_nodelist *, int);
+void lpfc_drop_node(struct lpfc_hba *, struct lpfc_nodelist *);
 void lpfc_set_disctmo(struct lpfc_hba *);
 int lpfc_can_disctmo(struct lpfc_hba *);
 int lpfc_unreg_rpi(struct lpfc_hba *, struct lpfc_nodelist *);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2007-04-24 11:12:41.000000000 -0400
@@ -83,7 +83,6 @@ struct lpfc_nodelist {
 };
 
 /* Defines for nlp_flag (uint32) */
-#define NLP_NO_LIST        0x0		/* Indicates immediately free node */
 #define NLP_UNUSED_LIST    0x1		/* Flg to indicate node will be freed */
 #define NLP_PLOGI_LIST     0x2		/* Flg to indicate sent PLOGI */
 #define NLP_ADISC_LIST     0x3		/* Flg to indicate sent ADISC */
@@ -92,7 +91,6 @@ struct lpfc_nodelist {
 #define NLP_UNMAPPED_LIST  0x6		/* Node is now unmapped */
 #define NLP_MAPPED_LIST    0x7		/* Node is now mapped */
 #define NLP_NPR_LIST       0x8		/* Node is in NPort Recovery state */
-#define NLP_JUST_DQ        0x9		/* just deque ndlp in lpfc_nlp_list */
 #define NLP_LIST_MASK      0xf		/* mask to see what list node is on */
 #define NLP_PLOGI_SND      0x20		/* sent PLOGI request for this entry */
 #define NLP_PRLI_SND       0x40		/* sent PRLI request for this entry */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:41.000000000 -0400
@@ -387,8 +387,7 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_hb
 				sizeof(struct lpfc_name));
 		memcpy(&ndlp->nlp_nodename, &sp->nodeName,
 				sizeof(struct lpfc_name));
-		ndlp->nlp_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 	} else {
 		/* This side will wait for the PLOGI */
@@ -605,7 +604,7 @@ lpfc_initial_flogi(struct lpfc_hba * phb
 			return 0;
 		lpfc_nlp_init(phba, ndlp, Fabric_DID);
 	} else {
-		lpfc_nlp_list(phba, ndlp, NLP_JUST_DQ);
+		lpfc_dequeue_node(phba, ndlp);
 	}
 	if (lpfc_issue_els_flogi(phba, ndlp, 0)) {
 		mempool_free( ndlp, phba->nlp_mem_pool);
@@ -679,18 +678,15 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	lpfc_unreg_rpi(phba, new_ndlp);
 	new_ndlp->nlp_DID = ndlp->nlp_DID;
 	new_ndlp->nlp_prev_state = ndlp->nlp_prev_state;
-	new_ndlp->nlp_state = ndlp->nlp_state;
-	lpfc_nlp_list(phba, new_ndlp, ndlp->nlp_flag & NLP_LIST_MASK);
+	lpfc_nlp_set_state(phba, new_ndlp, ndlp->nlp_state);
 
 	/* Move this back to NPR list */
-	if (memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name)) == 0) {
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	}
+	if (memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name)) == 0)
+		lpfc_drop_node(phba, ndlp);
 	else {
 		lpfc_unreg_rpi(phba, ndlp);
 		ndlp->nlp_DID = 0; /* Two ndlps cannot have the same did */
-		ndlp->nlp_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	}
 	return new_ndlp;
 }
@@ -704,7 +700,6 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 	struct lpfc_dmabuf *prsp;
 	int disc, rc, did, type;
 
-
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
@@ -1538,29 +1533,25 @@ lpfc_els_retry_delay_handler(struct lpfc
 	case ELS_CMD_PLOGI:
 		if(!lpfc_issue_els_plogi(phba, ndlp->nlp_DID, retry)) {
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_PLOGI_ISSUE);
 		}
 		break;
 	case ELS_CMD_ADISC:
 		if (!lpfc_issue_els_adisc(phba, ndlp, retry)) {
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_ADISC_ISSUE);
 		}
 		break;
 	case ELS_CMD_PRLI:
 		if (!lpfc_issue_els_prli(phba, ndlp, retry)) {
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_PRLI_ISSUE);
 		}
 		break;
 	case ELS_CMD_LOGO:
 		if (!lpfc_issue_els_logo(phba, ndlp, retry)) {
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_NPR_NODE;
-			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 		}
 		break;
 	}
@@ -1730,8 +1721,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
 
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_NPR_NODE;
-			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 			ndlp->nlp_last_elscmd = cmd;
 
 			return 1;
@@ -1743,27 +1733,24 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 		case ELS_CMD_PLOGI:
 			if (ndlp) {
 				ndlp->nlp_prev_state = ndlp->nlp_state;
-				ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-				lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+				lpfc_nlp_set_state(phba, ndlp,
+						   NLP_STE_PLOGI_ISSUE);
 			}
 			lpfc_issue_els_plogi(phba, did, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_ADISC:
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_ADISC_ISSUE);
 			lpfc_issue_els_adisc(phba, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_PRLI:
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_PRLI_ISSUE);
 			lpfc_issue_els_prli(phba, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_LOGO:
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_NPR_NODE;
-			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 			lpfc_issue_els_logo(phba, ndlp, cmdiocb->retry);
 			return 1;
 		}
@@ -1827,7 +1814,7 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 
 	switch (ndlp->nlp_state) {
 	case NLP_STE_UNUSED_NODE:	/* node is just allocated */
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 		break;
 	case NLP_STE_NPR_NODE:		/* NPort Recovery mode */
 		lpfc_unreg_rpi(phba, ndlp);
@@ -1885,8 +1872,7 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 			mbox->context2 = ndlp;
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_REG_LOGIN_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_REGLOGIN_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_REG_LOGIN_ISSUE);
 			if (lpfc_sli_issue_mbox(phba, mbox,
 						(MBX_NOWAIT | MBX_STOP_IOCB))
 			    != MBX_NOT_FINISHED) {
@@ -1901,7 +1887,7 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 			       (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 			       (irsp->un.ulpWord[4] == IOERR_SLI_DOWN)))) {
 				if (ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
-					lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+					lpfc_drop_node(phba, ndlp);
 					ndlp = NULL;
 				}
 			}
@@ -2311,9 +2297,8 @@ lpfc_els_disc_adisc(struct lpfc_hba * ph
 			if (ndlp->nlp_flag & NLP_NPR_ADISC) {
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 				ndlp->nlp_prev_state = ndlp->nlp_state;
-				ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
-				lpfc_nlp_list(phba, ndlp,
-					NLP_ADISC_LIST);
+				lpfc_nlp_set_state(phba, ndlp,
+						   NLP_STE_ADISC_ISSUE);
 				lpfc_issue_els_adisc(phba, ndlp, 0);
 				sentadisc++;
 				phba->num_disc_nodes++;
@@ -2349,8 +2334,8 @@ lpfc_els_disc_plogi(struct lpfc_hba * ph
 		   (!(ndlp->nlp_flag & NLP_DELAY_TMO))) {
 			if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 				ndlp->nlp_prev_state = ndlp->nlp_state;
-				ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-				lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+				lpfc_nlp_set_state(phba, ndlp,
+						   NLP_STE_PLOGI_ISSUE);
 				lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 				sentplogi++;
 				phba->num_disc_nodes++;
@@ -2647,8 +2632,7 @@ lpfc_els_handle_rscn(struct lpfc_hba * p
 			lpfc_nlp_init(phba, ndlp, NameServer_DID);
 			ndlp->nlp_type |= NLP_FABRIC;
 			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(phba, NameServer_DID, 0);
 			/* Wait for NameServer login cmpl before we can
 			   continue */
@@ -3074,8 +3058,8 @@ lpfc_els_rcv_farp(struct lpfc_hba * phba
 			/* Log back into the node before sending the FARP. */
 			if (fp->Rflags & FARP_REQUEST_PLOGI) {
 				ndlp->nlp_prev_state = ndlp->nlp_state;
-				ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-				lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+				lpfc_nlp_set_state(phba, ndlp,
+						   NLP_STE_PLOGI_ISSUE);
 				lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 			}
 
@@ -3159,7 +3143,7 @@ lpfc_els_rcv_fan(struct lpfc_hba * phba,
 					 * Clean up old Fabric, Nameserver and
 					 * other NLP_FABRIC logins
 					 */
-					lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+					lpfc_drop_node(phba, ndlp);
 				} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 					/* Fail outstanding I/O now since this
 					 * device is marked for PLOGI
@@ -3182,14 +3166,14 @@ lpfc_els_rcv_fan(struct lpfc_hba * phba,
 			switch (ndlp->nlp_prev_state) {
 			case NLP_STE_UNMAPPED_NODE:
 				ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-				ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
-				lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+				lpfc_nlp_set_state(phba, ndlp,
+						   NLP_STE_UNMAPPED_NODE);
 				break;
 
 			case NLP_STE_MAPPED_NODE:
 				ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-				ndlp->nlp_state = NLP_STE_MAPPED_NODE;
-				lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
+				lpfc_nlp_set_state(phba, ndlp,
+						   NLP_STE_MAPPED_NODE);
 				break;
 
 			default:
@@ -3431,8 +3415,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK) {
 			ndlp->nlp_type |= NLP_FABRIC;
 		}
-		ndlp->nlp_state = NLP_STE_UNUSED_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNUSED_NODE);
 	}
 
 	phba->fc_stat.elsRcvFrame++;
@@ -3460,9 +3443,8 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_FLOGI:
 		phba->fc_stat.elsRcvFLOGI++;
 		lpfc_els_rcv_flogi(phba, elsiocb, ndlp, newnode);
-		if (newnode) {
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-		}
+		if (newnode)
+			lpfc_drop_node(phba, ndlp);
 		break;
 	case ELS_CMD_LOGO:
 		phba->fc_stat.elsRcvLOGO++;
@@ -3483,9 +3465,8 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_RSCN:
 		phba->fc_stat.elsRcvRSCN++;
 		lpfc_els_rcv_rscn(phba, elsiocb, ndlp, newnode);
-		if (newnode) {
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-		}
+		if (newnode)
+			lpfc_drop_node(phba, ndlp);
 		break;
 	case ELS_CMD_ADISC:
 		phba->fc_stat.elsRcvADISC++;
@@ -3526,30 +3507,26 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_LIRR:
 		phba->fc_stat.elsRcvLIRR++;
 		lpfc_els_rcv_lirr(phba, elsiocb, ndlp);
-		if (newnode) {
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-		}
+		if (newnode)
+			lpfc_drop_node(phba, ndlp);
 		break;
 	case ELS_CMD_RPS:
 		phba->fc_stat.elsRcvRPS++;
 		lpfc_els_rcv_rps(phba, elsiocb, ndlp);
-		if (newnode) {
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-		}
+		if (newnode)
+			lpfc_drop_node(phba, ndlp);
 		break;
 	case ELS_CMD_RPL:
 		phba->fc_stat.elsRcvRPL++;
 		lpfc_els_rcv_rpl(phba, elsiocb, ndlp);
-		if (newnode) {
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-		}
+		if (newnode)
+			lpfc_drop_node(phba, ndlp);
 		break;
 	case ELS_CMD_RNID:
 		phba->fc_stat.elsRcvRNID++;
 		lpfc_els_rcv_rnid(phba, elsiocb, ndlp);
-		if (newnode) {
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-		}
+		if (newnode)
+			lpfc_drop_node(phba, ndlp);
 		break;
 	default:
 		/* Unsupported ELS command, reject */
@@ -3559,9 +3536,8 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
 				"%d:0115 Unknown ELS command x%x received from "
 				"NPORT x%x\n", phba->brd_no, cmd, did);
-		if (newnode) {
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-		}
+		if (newnode)
+			lpfc_drop_node(phba, ndlp);
 		break;
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:41.000000000 -0400
@@ -429,9 +429,8 @@ lpfc_linkdown(struct lpfc_hba * phba)
 
 	/* free any ndlp's on unused list */
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_unused_list,
-				nlp_listp) {
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	}
+				nlp_listp)
+		lpfc_drop_node(phba, ndlp);
 
 	/* Setup myDID for link up if we are in pt2pt mode */
 	if (phba->fc_flag & FC_PT2PT) {
@@ -497,8 +496,8 @@ lpfc_linkup(struct lpfc_hba * phba)
 					/* On Linkup its safe to clean up the
 					 * ndlp from Fabric connections.
 					 */
-					lpfc_nlp_list(phba, ndlp,
-							NLP_UNUSED_LIST);
+					lpfc_nlp_set_state(phba, ndlp,
+						       NLP_STE_UNUSED_NODE);
 				} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 					/* Fail outstanding IO now since device
 					 * is marked for PLOGI.
@@ -511,9 +510,8 @@ lpfc_linkup(struct lpfc_hba * phba)
 
 	/* free any ndlp's on unused list */
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_unused_list,
-				nlp_listp) {
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	}
+				nlp_listp)
+		lpfc_drop_node(phba, ndlp);
 
 	return 0;
 }
@@ -993,8 +991,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_type |= NLP_FABRIC;
-	ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNMAPPED_NODE);
 
 	if (phba->hba_state == LPFC_FABRIC_CFG_LINK) {
 		/* This NPort has been assigned an NPort_ID by the fabric as a
@@ -1024,8 +1021,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 				ndlp->nlp_type |= NLP_FABRIC;
 			}
 		}
-		ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-		lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_PLOGI_ISSUE);
 		lpfc_issue_els_plogi(phba, NameServer_DID, 0);
 		if (phba->cfg_fdmi_on) {
 			ndlp_fdmi = mempool_alloc(phba->nlp_mem_pool,
@@ -1068,8 +1064,8 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 	if (mb->mbxStatus) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
-		mempool_free( pmb, phba->mbox_mem_pool);
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		mempool_free(pmb, phba->mbox_mem_pool);
+		lpfc_drop_node(phba, ndlp);
 
 		/* RegLogin failed, so just use loop map to make discovery
 		   list */
@@ -1084,8 +1080,7 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_type |= NLP_FABRIC;
-	ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNMAPPED_NODE);
 
 	if (phba->hba_state < LPFC_HBA_READY) {
 		/* Link up discovery requires Fabrib registration. */
@@ -1170,72 +1165,82 @@ lpfc_unregister_remote_port(struct lpfc_
 	return;
 }
 
-int
-lpfc_nlp_list(struct lpfc_hba * phba, struct lpfc_nodelist * nlp, int list)
+static void
+lpfc_nlp_counters(struct lpfc_hba *phba, int state, int count)
 {
-	enum { none, unmapped, mapped } rport_add = none, rport_del = none;
-	struct lpfc_sli      *psli;
-
-	psli = &phba->sli;
-	/* Sanity check to ensure we are not moving to / from the same list */
-	if ((nlp->nlp_flag & NLP_LIST_MASK) == list)
-		if (list != NLP_NO_LIST)
-			return 0;
-
-	spin_lock_irq(phba->host->host_lock);
-	switch (nlp->nlp_flag & NLP_LIST_MASK) {
-	case NLP_NO_LIST: /* Not on any list */
+	switch (state) {
+	case NLP_STE_UNUSED_NODE:
+		phba->fc_unused_cnt += count;
+		break;
+	case NLP_STE_PLOGI_ISSUE:
+		phba->fc_plogi_cnt += count;
+		break;
+	case NLP_STE_ADISC_ISSUE:
+		phba->fc_adisc_cnt += count;
 		break;
+	case NLP_STE_REG_LOGIN_ISSUE:
+		phba->fc_reglogin_cnt += count;
+		break;
+	case NLP_STE_PRLI_ISSUE:
+		phba->fc_prli_cnt += count;
+		break;
+	case NLP_STE_UNMAPPED_NODE:
+		phba->fc_unmap_cnt += count;
+		break;
+	case NLP_STE_MAPPED_NODE:
+		phba->fc_map_cnt += count;
+		break;
+	case NLP_STE_NPR_NODE:
+		phba->fc_npr_cnt += count;
+		break;
+	}
+}
+
+void
+lpfc_delink_node(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+{
+	switch (ndlp->nlp_flag & NLP_LIST_MASK) {
 	case NLP_UNUSED_LIST:
-		phba->fc_unused_cnt--;
-		list_del(&nlp->nlp_listp);
+		list_del_init(&ndlp->nlp_listp);
 		break;
 	case NLP_PLOGI_LIST:
-		phba->fc_plogi_cnt--;
-		list_del(&nlp->nlp_listp);
+		list_del_init(&ndlp->nlp_listp);
 		break;
 	case NLP_ADISC_LIST:
-		phba->fc_adisc_cnt--;
-		list_del(&nlp->nlp_listp);
+		list_del_init(&ndlp->nlp_listp);
 		break;
 	case NLP_REGLOGIN_LIST:
-		phba->fc_reglogin_cnt--;
-		list_del(&nlp->nlp_listp);
+		list_del_init(&ndlp->nlp_listp);
 		break;
 	case NLP_PRLI_LIST:
-		phba->fc_prli_cnt--;
-		list_del(&nlp->nlp_listp);
+		list_del_init(&ndlp->nlp_listp);
 		break;
 	case NLP_UNMAPPED_LIST:
-		phba->fc_unmap_cnt--;
-		list_del(&nlp->nlp_listp);
-		nlp->nlp_flag &= ~NLP_TGT_NO_SCSIID;
-		nlp->nlp_type &= ~NLP_FC_NODE;
-		phba->nport_event_cnt++;
-		if (nlp->rport)
-			rport_del = unmapped;
+		list_del_init(&ndlp->nlp_listp);
 		break;
 	case NLP_MAPPED_LIST:
-		phba->fc_map_cnt--;
-		list_del(&nlp->nlp_listp);
-		phba->nport_event_cnt++;
-		if (nlp->rport)
-			rport_del = mapped;
+		list_del_init(&ndlp->nlp_listp);
 		break;
 	case NLP_NPR_LIST:
-		phba->fc_npr_cnt--;
-		list_del(&nlp->nlp_listp);
-		/* Stop delay tmo if taking node off NPR list */
-		if ((nlp->nlp_flag & NLP_DELAY_TMO) &&
-		   (list != NLP_NPR_LIST)) {
-			spin_unlock_irq(phba->host->host_lock);
-			lpfc_cancel_retry_delay_tmo(phba, nlp);
-			spin_lock_irq(phba->host->host_lock);
-		}
+		list_del_init(&ndlp->nlp_listp);
 		break;
 	}
 
-	nlp->nlp_flag &= ~NLP_LIST_MASK;
+	ndlp->nlp_flag &= ~NLP_LIST_MASK;
+}
+
+static int
+lpfc_nlp_list(struct lpfc_hba * phba, struct lpfc_nodelist * nlp, int list)
+{
+	struct lpfc_sli      *psli;
+
+	psli = &phba->sli;
+	/* Sanity check to ensure we are not moving to / from the same list */
+	if ((nlp->nlp_flag & NLP_LIST_MASK) == list)
+		return 0;
+
+	spin_lock_irq(phba->host->host_lock);
+	lpfc_delink_node(phba, nlp);
 
 	/* Add NPort <did> to <num> list */
 	lpfc_printf_log(phba,
@@ -1246,102 +1251,85 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			nlp->nlp_DID, list, nlp->nlp_flag);
 
 	switch (list) {
-	case NLP_NO_LIST: /* No list, just remove it */
-		spin_unlock_irq(phba->host->host_lock);
-		lpfc_nlp_remove(phba, nlp);
-		spin_lock_irq(phba->host->host_lock);
-		/* as node removed - stop further transport calls */
-		rport_del = none;
-		break;
 	case NLP_UNUSED_LIST:
 		nlp->nlp_flag |= list;
 		/* Put it at the end of the unused list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_unused_list);
-		phba->fc_unused_cnt++;
 		break;
 	case NLP_PLOGI_LIST:
 		nlp->nlp_flag |= list;
 		/* Put it at the end of the plogi list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_plogi_list);
-		phba->fc_plogi_cnt++;
 		break;
 	case NLP_ADISC_LIST:
 		nlp->nlp_flag |= list;
 		/* Put it at the end of the adisc list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_adisc_list);
-		phba->fc_adisc_cnt++;
 		break;
 	case NLP_REGLOGIN_LIST:
 		nlp->nlp_flag |= list;
 		/* Put it at the end of the reglogin list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_reglogin_list);
-		phba->fc_reglogin_cnt++;
 		break;
 	case NLP_PRLI_LIST:
 		nlp->nlp_flag |= list;
 		/* Put it at the end of the prli list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_prli_list);
-		phba->fc_prli_cnt++;
 		break;
 	case NLP_UNMAPPED_LIST:
-		rport_add = unmapped;
-		/* ensure all vestiges of "mapped" significance are gone */
-		nlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
 		nlp->nlp_flag |= list;
 		/* Put it at the end of the unmap list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_nlpunmap_list);
-		phba->fc_unmap_cnt++;
-		phba->nport_event_cnt++;
-		nlp->nlp_flag &= ~NLP_NODEV_REMOVE;
-		nlp->nlp_type |= NLP_FC_NODE;
 		break;
 	case NLP_MAPPED_LIST:
-		rport_add = mapped;
 		nlp->nlp_flag |= list;
 		/* Put it at the end of the map list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_nlpmap_list);
-		phba->fc_map_cnt++;
-		phba->nport_event_cnt++;
-		nlp->nlp_flag &= ~NLP_NODEV_REMOVE;
 		break;
 	case NLP_NPR_LIST:
 		nlp->nlp_flag |= list;
 		/* Put it at the end of the npr list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_npr_list);
-		phba->fc_npr_cnt++;
-
-		nlp->nlp_flag &= ~NLP_RCV_PLOGI;
-		break;
-	case NLP_JUST_DQ:
 		break;
 	}
 
 	spin_unlock_irq(phba->host->host_lock);
+	return 0;
+}
 
-	/*
-	 * We make all the calls into the transport after we have
-	 * moved the node between lists. This so that we don't
-	 * release the lock while in-between lists.
-	 */
-
-	/* Don't upcall midlayer if we're unloading */
-	if (!(phba->fc_flag & FC_UNLOADING)) {
-		/*
-		 * We revalidate the rport pointer as the "add" function
-		 * may have removed the remote port.
-		 */
-		if ((rport_del != none) && nlp->rport)
-			lpfc_unregister_remote_port(phba, nlp);
+static void
+lpfc_nlp_state_cleanup(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
+		       int old_state, int new_state)
+{
+	if (new_state == NLP_STE_UNMAPPED_NODE) {
+		ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
+		ndlp->nlp_flag &= ~NLP_NODEV_REMOVE;
+		ndlp->nlp_type |= NLP_FC_NODE;
+	}
+	if (new_state == NLP_STE_MAPPED_NODE)
+		ndlp->nlp_flag &= ~NLP_NODEV_REMOVE;
+	if (new_state == NLP_STE_NPR_NODE)
+		ndlp->nlp_flag &= ~NLP_RCV_PLOGI;
+
+	/* Transport interface */
+	if (ndlp->rport && (old_state == NLP_STE_MAPPED_NODE ||
+			    old_state == NLP_STE_UNMAPPED_NODE)) {
+		phba->nport_event_cnt++;
+		lpfc_unregister_remote_port(phba, ndlp);
+	}
 
-		if (rport_add != none) {
+	if (new_state ==  NLP_STE_MAPPED_NODE ||
+	    new_state == NLP_STE_UNMAPPED_NODE) {
+		phba->nport_event_cnt++;
 			/*
 			 * Tell the fc transport about the port, if we haven't
 			 * already. If we have, and it's a scsi entity, be
 			 * sure to unblock any attached scsi devices
 			 */
-			if ((!nlp->rport) || (nlp->rport->port_state ==
-					FC_PORTSTATE_BLOCKED))
-				lpfc_register_remote_port(phba, nlp);
+		if (!ndlp->rport ||
+		    ndlp->rport->port_state == FC_PORTSTATE_BLOCKED)
+			lpfc_register_remote_port(phba, ndlp);
+	}
 
 			/*
 			 * if we added to Mapped list, but the remote port
@@ -1349,19 +1337,75 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			 * our presentable range - move the node to the
 			 * Unmapped List
 			 */
-			if ((rport_add == mapped) &&
-			    ((!nlp->rport) ||
-			     (nlp->rport->scsi_target_id == -1) ||
-			     (nlp->rport->scsi_target_id >= LPFC_MAX_TARGET))) {
-				nlp->nlp_state = NLP_STE_UNMAPPED_NODE;
-				spin_lock_irq(phba->host->host_lock);
-				nlp->nlp_flag |= NLP_TGT_NO_SCSIID;
-				spin_unlock_irq(phba->host->host_lock);
-				lpfc_nlp_list(phba, nlp, NLP_UNMAPPED_LIST);
-			}
-		}
+	if (new_state == NLP_STE_MAPPED_NODE &&
+	    (!ndlp->rport ||
+	     ndlp->rport->scsi_target_id == -1 ||
+	     ndlp->rport->scsi_target_id >= LPFC_MAX_TARGET)) {
+		spin_lock_irq(phba->host->host_lock);
+		ndlp->nlp_flag |= NLP_TGT_NO_SCSIID;
+		spin_unlock_irq(phba->host->host_lock);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNMAPPED_NODE);
 	}
-	return 0;
+}
+
+void
+lpfc_nlp_set_state(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp, int state)
+{
+	int  old_state = ndlp->nlp_state;
+	static int  list_id[] = {
+		[NLP_STE_UNUSED_NODE] = NLP_UNUSED_LIST,
+		[NLP_STE_PLOGI_ISSUE] = NLP_PLOGI_LIST,
+		[NLP_STE_ADISC_ISSUE] = NLP_ADISC_LIST,
+		[NLP_STE_REG_LOGIN_ISSUE] = NLP_REGLOGIN_LIST,
+		[NLP_STE_PRLI_ISSUE] = NLP_PRLI_LIST,
+		[NLP_STE_UNMAPPED_NODE] = NLP_UNMAPPED_LIST,
+		[NLP_STE_MAPPED_NODE] = NLP_MAPPED_LIST,
+		[NLP_STE_NPR_NODE] = NLP_NPR_LIST,
+	};
+
+	if (old_state == NLP_STE_NPR_NODE &&
+	    (ndlp->nlp_flag & NLP_DELAY_TMO) != 0 &&
+	    state != NLP_STE_NPR_NODE)
+		lpfc_cancel_retry_delay_tmo(phba, ndlp);
+	if (old_state == NLP_STE_UNMAPPED_NODE) {
+		ndlp->nlp_flag &= ~NLP_TGT_NO_SCSIID;
+		ndlp->nlp_type &= ~NLP_FC_NODE;
+	}
+
+	if (old_state && !list_empty(&ndlp->nlp_listp))
+		lpfc_nlp_counters(phba, old_state, -1);
+
+	ndlp->nlp_state = state;
+	lpfc_nlp_list(phba, ndlp, list_id[state]);
+	lpfc_nlp_counters(phba, state, 1);
+
+	lpfc_nlp_state_cleanup(phba, ndlp, old_state, state);
+}
+
+void
+lpfc_dequeue_node(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+{
+	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
+		lpfc_cancel_retry_delay_tmo(phba, ndlp);
+	spin_lock_irq(phba->host->host_lock);
+	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
+		lpfc_nlp_counters(phba, ndlp->nlp_state, -1);
+	lpfc_delink_node(phba, ndlp);
+	spin_unlock_irq(phba->host->host_lock);
+	lpfc_nlp_state_cleanup(phba, ndlp, ndlp->nlp_state, 0);
+}
+
+void
+lpfc_drop_node(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+{
+	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
+		lpfc_cancel_retry_delay_tmo(phba, ndlp);
+	spin_lock_irq(phba->host->host_lock);
+	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
+		lpfc_nlp_counters(phba, ndlp->nlp_state, -1);
+	lpfc_delink_node(phba, ndlp);
+	spin_unlock_irq(phba->host->host_lock);
+	lpfc_nlp_remove(phba, ndlp);
 }
 
 /*
@@ -1577,7 +1621,7 @@ lpfc_freenode(struct lpfc_hba * phba, st
 			phba->brd_no, ndlp->nlp_DID, ndlp->nlp_flag,
 			ndlp->nlp_state, ndlp->nlp_rpi);
 
-	lpfc_nlp_list(phba, ndlp, NLP_JUST_DQ);
+	lpfc_dequeue_node(phba, ndlp);
 
 	/* cleanup any ndlp on mbox q waiting for reglogin cmpl */
 	if ((mb = phba->sli.mbox_active)) {
@@ -1771,8 +1815,7 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 		if (!ndlp)
 			return NULL;
 		lpfc_nlp_init(phba, ndlp, did);
-		ndlp->nlp_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		return ndlp;
 	}
@@ -1791,8 +1834,7 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 		flg = ndlp->nlp_flag & NLP_LIST_MASK;
 		if ((flg == NLP_ADISC_LIST) || (flg == NLP_PLOGI_LIST))
 			return NULL;
-		ndlp->nlp_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 	}
 	return ndlp;
@@ -2099,7 +2141,7 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 					nlp_listp) {
 			if (ndlp->nlp_type & NLP_FABRIC) {
 				/* Clean up the ndlp on Fabric connections */
-				lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+				lpfc_drop_node(phba, ndlp);
 			} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 				/* Fail outstanding IO now since device
 				 * is marked for PLOGI.
@@ -2304,8 +2346,7 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_type |= NLP_FABRIC;
-	ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNMAPPED_NODE);
 
 	/* Start issuing Fabric-Device Management Interface (FDMI)
 	 * command to 0xfffffa (FDMI well known port)
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:41.000000000 -0400
@@ -1196,7 +1196,7 @@ lpfc_cleanup(struct lpfc_hba * phba)
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_unused_list,
 				nlp_listp) {
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 	}
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_plogi_list,
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:41.000000000 -0400
@@ -434,8 +434,7 @@ lpfc_rcv_padisc(struct lpfc_hba * phba,
 	spin_unlock_irq(phba->host->host_lock);
 	ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	ndlp->nlp_prev_state = ndlp->nlp_state;
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	return 0;
 }
 
@@ -465,12 +464,10 @@ lpfc_rcv_logo(struct lpfc_hba * phba,
 
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 		ndlp->nlp_prev_state = ndlp->nlp_state;
-		ndlp->nlp_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	} else {
 		ndlp->nlp_prev_state = ndlp->nlp_state;
-		ndlp->nlp_state = NLP_STE_UNUSED_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNUSED_NODE);
 	}
 
 	spin_lock_irq(phba->host->host_lock);
@@ -564,11 +561,10 @@ lpfc_rcv_plogi_unused_node(struct lpfc_h
 
 	if (lpfc_rcv_plogi(phba, ndlp, cmdiocb)) {
 		ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
-		ndlp->nlp_state = NLP_STE_UNUSED_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNUSED_NODE);
 		return ndlp->nlp_state;
 	}
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+	lpfc_drop_node(phba, ndlp);
 	return NLP_STE_FREED_NODE;
 }
 
@@ -577,7 +573,7 @@ lpfc_rcv_els_unused_node(struct lpfc_hba
 			 struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
 	lpfc_issue_els_logo(phba, ndlp, 0);
-	lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNUSED_NODE);
 	return ndlp->nlp_state;
 }
 
@@ -593,7 +589,7 @@ lpfc_rcv_logo_unused_node(struct lpfc_hb
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
 	spin_unlock_irq(phba->host->host_lock);
 	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
-	lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNUSED_NODE);
 
 	return ndlp->nlp_state;
 }
@@ -602,7 +598,7 @@ static uint32_t
 lpfc_cmpl_logo_unused_node(struct lpfc_hba * phba,
 			  struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+	lpfc_drop_node(phba, ndlp);
 	return NLP_STE_FREED_NODE;
 }
 
@@ -610,7 +606,7 @@ static uint32_t
 lpfc_device_rm_unused_node(struct lpfc_hba * phba,
 			   struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+	lpfc_drop_node(phba, ndlp);
 	return NLP_STE_FREED_NODE;
 }
 
@@ -690,8 +686,7 @@ lpfc_rcv_els_plogi_issue(struct lpfc_hba
 	spin_unlock_irq(phba->host->host_lock);
 	ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	ndlp->nlp_prev_state = NLP_STE_PLOGI_ISSUE;
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 
 	return ndlp->nlp_state;
 }
@@ -766,30 +761,23 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 		goto out;
 
 	lpfc_unreg_rpi(phba, ndlp);
-	if (lpfc_reg_login
-	    (phba, irsp->un.elsreq64.remoteID,
-	     (uint8_t *) sp, mbox, 0) == 0) {
+	if (lpfc_reg_login(phba, irsp->un.elsreq64.remoteID, (uint8_t *) sp,
+			   mbox, 0) == 0) {
 		switch (ndlp->nlp_DID) {
 		case NameServer_DID:
-			mbox->mbox_cmpl =
-				lpfc_mbx_cmpl_ns_reg_login;
+			mbox->mbox_cmpl = lpfc_mbx_cmpl_ns_reg_login;
 			break;
 		case FDMI_DID:
-			mbox->mbox_cmpl =
-				lpfc_mbx_cmpl_fdmi_reg_login;
+			mbox->mbox_cmpl = lpfc_mbx_cmpl_fdmi_reg_login;
 			break;
 		default:
-			mbox->mbox_cmpl =
-				lpfc_mbx_cmpl_reg_login;
+			mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 		}
 		mbox->context2 = ndlp;
 		if (lpfc_sli_issue_mbox(phba, mbox,
 					(MBX_NOWAIT | MBX_STOP_IOCB))
 		    != MBX_NOT_FINISHED) {
-			ndlp->nlp_state =
-				NLP_STE_REG_LOGIN_ISSUE;
-			lpfc_nlp_list(phba, ndlp,
-				      NLP_REGLOGIN_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_REG_LOGIN_ISSUE);
 			return ndlp->nlp_state;
 		}
 		mp = (struct lpfc_dmabuf *)mbox->context1;
@@ -804,7 +792,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
  out:
 	/* Free this node since the driver cannot login or has the wrong
 	   sparm */
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+	lpfc_drop_node(phba, ndlp);
 	return NLP_STE_FREED_NODE;
 }
 
@@ -820,7 +808,7 @@ lpfc_device_rm_plogi_issue(struct lpfc_h
 		/* software abort outstanding PLOGI */
 		lpfc_els_abort(phba, ndlp);
 
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
 }
@@ -834,8 +822,7 @@ lpfc_device_recov_plogi_issue(struct lpf
 	lpfc_els_abort(phba, ndlp);
 
 	ndlp->nlp_prev_state = NLP_STE_PLOGI_ISSUE;
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
@@ -859,8 +846,7 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_h
 		return ndlp->nlp_state;
 	}
 	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
-	ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-	lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_PLOGI_ISSUE);
 	lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 
 	return ndlp->nlp_state;
@@ -950,20 +936,17 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 		memset(&ndlp->nlp_portname, 0, sizeof (struct lpfc_name));
 
 		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
-		ndlp->nlp_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 		lpfc_unreg_rpi(phba, ndlp);
 		return ndlp->nlp_state;
 	}
 
 	if (ndlp->nlp_type & NLP_FCP_TARGET) {
 		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
-		ndlp->nlp_state = NLP_STE_MAPPED_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_MAPPED_NODE);
 	} else {
 		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
-		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNMAPPED_NODE);
 	}
 	return ndlp->nlp_state;
 }
@@ -981,7 +964,7 @@ lpfc_device_rm_adisc_issue(struct lpfc_h
 		/* software abort outstanding ADISC */
 		lpfc_els_abort(phba, ndlp);
 
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
 }
@@ -995,8 +978,7 @@ lpfc_device_recov_adisc_issue(struct lpf
 	lpfc_els_abort(phba, ndlp);
 
 	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	ndlp->nlp_flag |= NLP_NPR_ADISC;
@@ -1096,8 +1078,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 		 */
 		if (mb->mbxStatus == MBXERR_RPI_FULL) {
 			ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
-			ndlp->nlp_state = NLP_STE_UNUSED_NODE;
-			lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNUSED_NODE);
 			return ndlp->nlp_state;
 		}
 
@@ -1110,8 +1091,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 
 		lpfc_issue_els_logo(phba, ndlp, 0);
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-		ndlp->nlp_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 		return ndlp->nlp_state;
 	}
 
@@ -1120,13 +1100,11 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 	/* Only if we are not a fabric nport do we issue PRLI */
 	if (!(ndlp->nlp_type & NLP_FABRIC)) {
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-		ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
-		lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_PRLI_ISSUE);
 		lpfc_issue_els_prli(phba, ndlp, 0);
 	} else {
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNMAPPED_NODE);
 	}
 	return ndlp->nlp_state;
 }
@@ -1141,7 +1119,7 @@ lpfc_device_rm_reglogin_issue(struct lpf
 		return ndlp->nlp_state;
 	}
 	else {
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
 }
@@ -1152,8 +1130,7 @@ lpfc_device_recov_reglogin_issue(struct 
 			       uint32_t evt)
 {
 	ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
@@ -1242,8 +1219,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_hb
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus) {
 		ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
-		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
-		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNMAPPED_NODE);
 		return ndlp->nlp_state;
 	}
 
@@ -1261,8 +1237,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_hb
 	}
 
 	ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
-	ndlp->nlp_state = NLP_STE_MAPPED_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_MAPPED_NODE);
 	return ndlp->nlp_state;
 }
 
@@ -1295,7 +1270,7 @@ lpfc_device_rm_prli_issue(struct lpfc_hb
 		/* software abort outstanding PLOGI */
 		lpfc_els_abort(phba, ndlp);
 
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
 }
@@ -1325,8 +1300,7 @@ lpfc_device_recov_prli_issue(struct lpfc
 	lpfc_els_abort(phba, ndlp);
 
 	ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
@@ -1399,8 +1373,7 @@ lpfc_device_recov_unmap_node(struct lpfc
 			   struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
 	ndlp->nlp_prev_state = NLP_STE_UNMAPPED_NODE;
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	lpfc_disc_set_adisc(phba, ndlp);
 
@@ -1481,8 +1454,7 @@ lpfc_device_recov_mapped_node(struct lpf
 			    uint32_t evt)
 {
 	ndlp->nlp_prev_state = NLP_STE_MAPPED_NODE;
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(phba->host->host_lock);
@@ -1514,8 +1486,7 @@ lpfc_rcv_plogi_npr_node(struct lpfc_hba 
 	/* send PLOGI immediately, move to PLOGI issue state */
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
 		ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-		ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-		lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+		lpfc_nlp_set_state(phba, ndlp, NLP_STE_PLOGI_ISSUE);
 		lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 	}
 
@@ -1543,16 +1514,13 @@ lpfc_rcv_prli_npr_node(struct lpfc_hba *
 			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 			spin_unlock_irq(phba->host->host_lock);
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_ADISC_ISSUE);
 			lpfc_issue_els_adisc(phba, ndlp, 0);
 		} else {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 		}
-
 	}
 	return ndlp->nlp_state;
 }
@@ -1590,13 +1558,11 @@ lpfc_rcv_padisc_npr_node(struct lpfc_hba
 		!(ndlp->nlp_flag & NLP_NPR_2B_DISC)){
 		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_ADISC_ISSUE);
 			lpfc_issue_els_adisc(phba, ndlp, 0);
 		} else {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 		}
 	}
@@ -1645,7 +1611,7 @@ lpfc_cmpl_plogi_npr_node(struct lpfc_hba
 
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus) {
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
 	return ndlp->nlp_state;
@@ -1663,7 +1629,7 @@ lpfc_cmpl_prli_npr_node(struct lpfc_hba 
 
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
 	return ndlp->nlp_state;
@@ -1691,7 +1657,7 @@ lpfc_cmpl_adisc_npr_node(struct lpfc_hba
 
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
-		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+		lpfc_drop_node(phba, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
 	return ndlp->nlp_state;
@@ -1712,7 +1678,7 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_
 		ndlp->nlp_rpi = mb->un.varWords[0];
 	else {
 		if (ndlp->nlp_flag & NLP_NODEV_REMOVE) {
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+			lpfc_drop_node(phba, ndlp);
 			return NLP_STE_FREED_NODE;
 		}
 	}
@@ -1728,7 +1694,7 @@ lpfc_device_rm_npr_node(struct lpfc_hba 
 		ndlp->nlp_flag |= NLP_NODEV_REMOVE;
 		return ndlp->nlp_state;
 	}
-	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+	lpfc_drop_node(phba, ndlp);
 	return NLP_STE_FREED_NODE;
 }
 


