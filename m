From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/15] lpfc 8.1.7 : Correct bogus nodev_tmo message on NPort
	that changes its NPort Id
Date: Thu, 06 Jul 2006 15:50:02 -0400
Message-ID: <1152215403.23158.24.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:21900 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750777AbWGFTtq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:49:46 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66Jnj9N006942
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct bogus nodev_tmo message on NPort that changes its NPort Id

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2006-07-06 12:14:54.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2006-07-06 14:52:05.000000000 -0400
@@ -648,33 +648,32 @@ lpfc_more_plogi(struct lpfc_hba * phba)
 }
 
 static struct lpfc_nodelist *
-lpfc_plogi_confirm_nport(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
+lpfc_plogi_confirm_nport(struct lpfc_hba * phba, struct lpfc_dmabuf *prsp,
 			 struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_nodelist *new_ndlp;
-	struct lpfc_dmabuf *pcmd, *prsp;
 	uint32_t *lp;
 	struct serv_parm *sp;
 	uint8_t name[sizeof (struct lpfc_name)];
 	uint32_t rc;
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
-	prsp = (struct lpfc_dmabuf *) pcmd->list.next;
 	lp = (uint32_t *) prsp->virt;
 	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
+	memset(name, 0, sizeof (struct lpfc_name));
 
 	/* Now we to find out if the NPort we are logging into, matches the WWPN
 	 * we have for that ndlp. If not, we have some work to do.
 	 */
 	new_ndlp = lpfc_findnode_wwpn(phba, NLP_SEARCH_ALL, &sp->portName);
 
-	memset(name, 0, sizeof (struct lpfc_name));
-	rc =  memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name));
-	if (!rc || (new_ndlp == ndlp)) {
+	if (new_ndlp == ndlp)
 		return ndlp;
-	}
 
 	if (!new_ndlp) {
+		rc =
+		   memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name));
+		if (!rc)
+			return ndlp;
 		new_ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_ATOMIC);
 		if (!new_ndlp)
 			return ndlp;
@@ -683,17 +682,21 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	}
 
 	lpfc_unreg_rpi(phba, new_ndlp);
-	new_ndlp->nlp_prev_state = ndlp->nlp_state;
 	new_ndlp->nlp_DID = ndlp->nlp_DID;
-	new_ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-	lpfc_nlp_list(phba, new_ndlp, NLP_PLOGI_LIST);
+	new_ndlp->nlp_prev_state = ndlp->nlp_prev_state;
+	new_ndlp->nlp_state = ndlp->nlp_state;
+	lpfc_nlp_list(phba, new_ndlp, ndlp->nlp_flag & NLP_LIST_MASK);
 
 	/* Move this back to NPR list */
-	lpfc_unreg_rpi(phba, ndlp);
-	ndlp->nlp_DID = 0; /* Two ndlps cannot have the same did */
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
-
+	if (memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name)) == 0) {
+		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+	}
+	else {
+		lpfc_unreg_rpi(phba, ndlp);
+		ndlp->nlp_DID = 0; /* Two ndlps cannot have the same did */
+		ndlp->nlp_state = NLP_STE_NPR_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	}
 	return new_ndlp;
 }
 
@@ -703,6 +706,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 {
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_dmabuf *prsp;
 	int disc, rc, did, type;
 

@@ -769,7 +773,10 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 		}
 	} else {
 		/* Good status, call state machine */
-		ndlp = lpfc_plogi_confirm_nport(phba, cmdiocb, ndlp);
+		prsp = list_entry(((struct lpfc_dmabuf *)
+			cmdiocb->context2)->list.next,
+			struct lpfc_dmabuf, list);
+		ndlp = lpfc_plogi_confirm_nport(phba, prsp, ndlp);
 		rc = lpfc_disc_state_machine(phba, ndlp, cmdiocb,
 					NLP_EVT_CMPL_PLOGI);
 	}
@@ -3441,6 +3448,8 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK) {
 			ndlp->nlp_type |= NLP_FABRIC;
 		}
+		ndlp->nlp_state = NLP_STE_UNUSED_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
 	}
 
 	phba->fc_stat.elsRcvFrame++;
@@ -3462,13 +3471,14 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 			rjt_err = 1;
 			break;
 		}
+		ndlp = lpfc_plogi_confirm_nport(phba, mp, ndlp);
 		lpfc_disc_state_machine(phba, ndlp, elsiocb, NLP_EVT_RCV_PLOGI);
 		break;
 	case ELS_CMD_FLOGI:
 		phba->fc_stat.elsRcvFLOGI++;
 		lpfc_els_rcv_flogi(phba, elsiocb, ndlp, newnode);
 		if (newnode) {
-			mempool_free( ndlp, phba->nlp_mem_pool);
+			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		}
 		break;
 	case ELS_CMD_LOGO:
@@ -3491,7 +3501,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 		phba->fc_stat.elsRcvRSCN++;
 		lpfc_els_rcv_rscn(phba, elsiocb, ndlp, newnode);
 		if (newnode) {
-			mempool_free( ndlp, phba->nlp_mem_pool);
+			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		}
 		break;
 	case ELS_CMD_ADISC:
@@ -3534,28 +3544,28 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 		phba->fc_stat.elsRcvLIRR++;
 		lpfc_els_rcv_lirr(phba, elsiocb, ndlp);
 		if (newnode) {
-			mempool_free( ndlp, phba->nlp_mem_pool);
+			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		}
 		break;
 	case ELS_CMD_RPS:
 		phba->fc_stat.elsRcvRPS++;
 		lpfc_els_rcv_rps(phba, elsiocb, ndlp);
 		if (newnode) {
-			mempool_free( ndlp, phba->nlp_mem_pool);
+			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		}
 		break;
 	case ELS_CMD_RPL:
 		phba->fc_stat.elsRcvRPL++;
 		lpfc_els_rcv_rpl(phba, elsiocb, ndlp);
 		if (newnode) {
-			mempool_free( ndlp, phba->nlp_mem_pool);
+			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		}
 		break;
 	case ELS_CMD_RNID:
 		phba->fc_stat.elsRcvRNID++;
 		lpfc_els_rcv_rnid(phba, elsiocb, ndlp);
 		if (newnode) {
-			mempool_free( ndlp, phba->nlp_mem_pool);
+			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		}
 		break;
 	default:
@@ -3567,7 +3577,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 				"%d:0115 Unknown ELS command x%x received from "
 				"NPORT x%x\n", phba->brd_no, cmd, did);
 		if (newnode) {
-			mempool_free( ndlp, phba->nlp_mem_pool);
+			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
 		}
 		break;
 	}


