From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/6] lpfc 8.1.4 : Fix Discovery processing for NPorts that
	change their NPortId on the fly
Date: Tue, 07 Mar 2006 15:02:37 -0500
Message-ID: <1141761758.25430.15.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36044 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932247AbWCGUEA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 15:04:00 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k27K3wrf021496
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 12:03:59 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix Discovery processing for NPorts that change their NPortId on the fly
due to a cable swap.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -59,6 +59,7 @@ static void lpfc_disc_timeout_handler(st
 static void
 lpfc_process_nodev_timeout(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
+	uint8_t *name = (uint8_t *)&ndlp->nlp_portname;
 	int warn_on = 0;
 
 	spin_lock_irq(phba->host->host_lock);
@@ -79,15 +80,23 @@ lpfc_process_nodev_timeout(struct lpfc_h
 
 	if (warn_on) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-				"%d:0203 Nodev timeout on NPort x%x "
-				"Data: x%x x%x x%x\n",
-				phba->brd_no, ndlp->nlp_DID, ndlp->nlp_flag,
+				"%d:0203 Nodev timeout on "
+				"WWPN %x:%x:%x:%x:%x:%x:%x:%x "
+				"NPort x%x Data: x%x x%x x%x\n",
+				phba->brd_no,
+				*name, *(name+1), *(name+2), *(name+3),
+				*(name+4), *(name+5), *(name+6), *(name+7),
+				ndlp->nlp_DID, ndlp->nlp_flag,
 				ndlp->nlp_state, ndlp->nlp_rpi);
 	} else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
-				"%d:0204 Nodev timeout on NPort x%x "
-				"Data: x%x x%x x%x\n",
-				phba->brd_no, ndlp->nlp_DID, ndlp->nlp_flag,
+				"%d:0204 Nodev timeout on "
+				"WWPN %x:%x:%x:%x:%x:%x:%x:%x "
+				"NPort x%x Data: x%x x%x x%x\n",
+				phba->brd_no,
+				*name, *(name+1), *(name+2), *(name+3),
+				*(name+4), *(name+5), *(name+6), *(name+7),
+				ndlp->nlp_DID, ndlp->nlp_flag,
 				ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
@@ -945,7 +954,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		}
 		ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 		lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-		lpfc_issue_els_plogi(phba, ndlp, 0);
+		lpfc_issue_els_plogi(phba, NameServer_DID, 0);
 		if (phba->cfg_fdmi_on) {
 			ndlp_fdmi = mempool_alloc(phba->nlp_mem_pool,
 								GFP_KERNEL);
@@ -953,7 +962,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 				lpfc_nlp_init(phba, ndlp_fdmi, FDMI_DID);
 				ndlp_fdmi->nlp_type |= NLP_FABRIC;
 				ndlp_fdmi->nlp_state = NLP_STE_PLOGI_ISSUE;
-				lpfc_issue_els_plogi(phba, ndlp_fdmi, 0);
+				lpfc_issue_els_plogi(phba, FDMI_DID, 0);
 			}
 		}
 	}
@@ -2516,6 +2525,49 @@ lpfc_findnode_rpi(struct lpfc_hba * phba
 	return NULL;
 }
 
+/*
+ * This routine looks up the ndlp  lists
+ * for the given WWPN. If WWPN found
+ * it return the node list pointer
+ * else return NULL.
+ */
+struct lpfc_nodelist *
+lpfc_findnode_wwpn(struct lpfc_hba * phba, uint32_t order,
+		   struct lpfc_name * wwpn)
+{
+	struct lpfc_nodelist *ndlp;
+	struct list_head * lists[]={&phba->fc_nlpunmap_list,
+				    &phba->fc_nlpmap_list,
+				    &phba->fc_npr_list,
+				    &phba->fc_plogi_list,
+				    &phba->fc_adisc_list,
+				    &phba->fc_reglogin_list,
+				    &phba->fc_prli_list};
+	uint32_t search[]={NLP_SEARCH_UNMAPPED,
+			   NLP_SEARCH_MAPPED,
+			   NLP_SEARCH_NPR,
+			   NLP_SEARCH_PLOGI,
+			   NLP_SEARCH_ADISC,
+			   NLP_SEARCH_REGLOGIN,
+			   NLP_SEARCH_PRLI};
+	int i;
+
+	spin_lock_irq(phba->host->host_lock);
+	for (i = 0; i < ARRAY_SIZE(lists); i++ ) {
+		if (!(order & search[i]))
+			continue;
+		list_for_each_entry(ndlp, lists[i], nlp_listp) {
+			if (memcmp(&ndlp->nlp_portname, wwpn,
+				   sizeof(struct lpfc_name)) == 0) {
+				spin_unlock_irq(phba->host->host_lock);
+				return ndlp;
+			}
+		}
+	}
+	spin_unlock_irq(phba->host->host_lock);
+	return NULL;
+}
+
 void
 lpfc_nlp_init(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp,
 		 uint32_t did)
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -880,7 +880,7 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_h
 	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 	ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 	lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-	lpfc_issue_els_plogi(phba, ndlp, 0);
+	lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 
 	return ndlp->nlp_state;
 }
@@ -1503,11 +1503,12 @@ lpfc_rcv_plogi_npr_node(struct lpfc_hba 
 
 	/* send PLOGI immediately, move to PLOGI issue state */
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
-			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-			lpfc_issue_els_plogi(phba, ndlp, 0);
+		ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
+		ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
+		lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+		lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 	}
+
 	return ndlp->nlp_state;
 }
 
@@ -1539,8 +1540,9 @@ lpfc_rcv_prli_npr_node(struct lpfc_hba *
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-			lpfc_issue_els_plogi(phba, ndlp, 0);
+			lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 		}
+
 	}
 	return ndlp->nlp_state;
 }
@@ -1579,7 +1581,7 @@ lpfc_rcv_padisc_npr_node(struct lpfc_hba
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-			lpfc_issue_els_plogi(phba, ndlp, 0);
+			lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 		}
 	}
 	return ndlp->nlp_state;
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -70,7 +70,7 @@ int lpfc_els_abort(struct lpfc_hba *, st
 			int);
 int lpfc_els_abort_flogi(struct lpfc_hba *);
 int lpfc_initial_flogi(struct lpfc_hba *);
-int lpfc_issue_els_plogi(struct lpfc_hba *, struct lpfc_nodelist *, uint8_t);
+int lpfc_issue_els_plogi(struct lpfc_hba *, uint32_t, uint8_t);
 int lpfc_issue_els_prli(struct lpfc_hba *, struct lpfc_nodelist *, uint8_t);
 int lpfc_issue_els_adisc(struct lpfc_hba *, struct lpfc_nodelist *, uint8_t);
 int lpfc_issue_els_logo(struct lpfc_hba *, struct lpfc_nodelist *, uint8_t);
@@ -168,8 +168,9 @@ int lpfc_sli_abort_iocb(struct lpfc_hba 
 void lpfc_mbox_timeout(unsigned long);
 void lpfc_mbox_timeout_handler(struct lpfc_hba *);
 
-struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_hba * phba, uint32_t order,
-					uint32_t did);
+struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_hba *, uint32_t, uint32_t);
+struct lpfc_nodelist *lpfc_findnode_wwpn(struct lpfc_hba *, uint32_t,
+					struct lpfc_name *);
 
 int lpfc_sli_issue_mbox_wait(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq,
 			 uint32_t timeout);
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -97,10 +97,9 @@ lpfc_els_chk_latt(struct lpfc_hba * phba
 }
 
 static struct lpfc_iocbq *
-lpfc_prep_els_iocb(struct lpfc_hba * phba,
-		   uint8_t expectRsp,
-		   uint16_t cmdSize,
-		   uint8_t retry, struct lpfc_nodelist * ndlp, uint32_t elscmd)
+lpfc_prep_els_iocb(struct lpfc_hba * phba, uint8_t expectRsp,
+		   uint16_t cmdSize, uint8_t retry, struct lpfc_nodelist * ndlp,
+		   uint32_t did, uint32_t elscmd)
 {
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *elsiocb;
@@ -181,7 +180,7 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 	icmd->un.elsreq64.bdl.bdeFlags = BUFF_TYPE_BDL;
 	if (expectRsp) {
 		icmd->un.elsreq64.bdl.bdeSize = (2 * sizeof (struct ulp_bde64));
-		icmd->un.elsreq64.remoteID = ndlp->nlp_DID;	/* DID */
+		icmd->un.elsreq64.remoteID = did;	/* DID */
 		icmd->ulpCommand = CMD_ELS_REQUEST64_CR;
 	} else {
 		icmd->un.elsreq64.bdl.bdeSize = sizeof (struct ulp_bde64);
@@ -225,7 +224,7 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 				"%d:0116 Xmit ELS command x%x to remote "
 				"NPORT x%x Data: x%x x%x\n",
 				phba->brd_no, elscmd,
-				ndlp->nlp_DID, icmd->ulpIoTag, phba->hba_state);
+				did, icmd->ulpIoTag, phba->hba_state);
 	} else {
 		/* Xmit ELS response <elsCmd> to remote NPORT <did> */
 		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
@@ -516,10 +515,10 @@ lpfc_issue_els_flogi(struct lpfc_hba * p
 	pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	cmdsize = (sizeof (uint32_t) + sizeof (struct serv_parm));
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
-					  ndlp, ELS_CMD_FLOGI)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
+						 ndlp->nlp_DID, ELS_CMD_FLOGI);
+	if (!elsiocb)
 		return 1;
-	}
 
 	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
@@ -652,29 +651,80 @@ lpfc_more_plogi(struct lpfc_hba * phba)
 	return;
 }
 
+static struct lpfc_nodelist *
+lpfc_plogi_confirm_nport(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
+			 struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_nodelist *new_ndlp;
+	struct lpfc_dmabuf *pcmd, *prsp;
+	uint32_t *lp;
+	struct serv_parm *sp;
+	uint8_t name[sizeof (struct lpfc_name)];
+	uint32_t rc;
+
+	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	prsp = (struct lpfc_dmabuf *) pcmd->list.next;
+	lp = (uint32_t *) prsp->virt;
+	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
+
+	/* Now we to find out if the NPort we are logging into, matches the WWPN
+	 * we have for that ndlp. If not, we have some work to do.
+	 */
+	new_ndlp = lpfc_findnode_wwpn(phba, NLP_SEARCH_ALL, &sp->portName);
+
+	memset(name, 0, sizeof (struct lpfc_name));
+	rc =  memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name));
+	if (!rc || (new_ndlp == ndlp)) {
+		return ndlp;
+	}
+
+	if (!new_ndlp) {
+		new_ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_ATOMIC);
+		if (!new_ndlp)
+			return ndlp;
+
+		lpfc_nlp_init(phba, new_ndlp, ndlp->nlp_DID);
+	}
+
+	lpfc_unreg_rpi(phba, new_ndlp);
+	new_ndlp->nlp_prev_state = ndlp->nlp_state;
+	new_ndlp->nlp_DID = ndlp->nlp_DID;
+	new_ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
+	lpfc_nlp_list(phba, new_ndlp, NLP_PLOGI_LIST);
+
+	/* Move this back to NPR list */
+	lpfc_unreg_rpi(phba, ndlp);
+	ndlp->nlp_DID = 0; /* Two ndlps cannot have the same did */
+	ndlp->nlp_state = NLP_STE_NPR_NODE;
+	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+
+	return new_ndlp;
+}
+
 static void
 lpfc_cmpl_els_plogi(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
 		    struct lpfc_iocbq * rspiocb)
 {
 	IOCB_t *irsp;
-	struct lpfc_sli *psli;
 	struct lpfc_nodelist *ndlp;
 	int disc, rc, did, type;
 
-	psli = &phba->sli;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
 	irsp = &rspiocb->iocb;
-	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL,
+						irsp->un.elsreq64.remoteID);
+	if (!ndlp)
+		goto out;
 
 	/* Since ndlp can be freed in the disc state machine, note if this node
 	 * is being used during discovery.
 	 */
 	disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~(NLP_PLOGI_SND | NLP_NPR_2B_DISC);
+	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 	spin_unlock_irq(phba->host->host_lock);
 	rc   = 0;
 
@@ -723,18 +773,11 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 		}
 	} else {
 		/* Good status, call state machine */
+		ndlp = lpfc_plogi_confirm_nport(phba, cmdiocb, ndlp);
 		rc = lpfc_disc_state_machine(phba, ndlp, cmdiocb,
 					NLP_EVT_CMPL_PLOGI);
 	}
 
-	if (type & NLP_FABRIC) {
-		/* If we cannot login to Nameserver, kick off discovery now */
-		if ((did == NameServer_DID) && (rc == NLP_STE_FREED_NODE)) {
-			lpfc_disc_start(phba);
-		}
-		goto out;
-	}
-
 	if (disc && phba->num_disc_nodes) {
 		/* Check to see if there are more PLOGIs to be sent */
 		lpfc_more_plogi(phba);
@@ -767,8 +810,7 @@ out:
 }
 
 int
-lpfc_issue_els_plogi(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp,
-		     uint8_t retry)
+lpfc_issue_els_plogi(struct lpfc_hba * phba, uint32_t did, uint8_t retry)
 {
 	struct serv_parm *sp;
 	IOCB_t *icmd;
@@ -782,7 +824,7 @@ lpfc_issue_els_plogi(struct lpfc_hba * p
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = (sizeof (uint32_t) + sizeof (struct serv_parm));
-	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, 0, did,
 								ELS_CMD_PLOGI);
 	if (!elsiocb)
 		return 1;
@@ -805,9 +847,7 @@ lpfc_issue_els_plogi(struct lpfc_hba * p
 	phba->fc_stat.elsXmitPLOGI++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_plogi;
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag |= NLP_PLOGI_SND;
 	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
-		ndlp->nlp_flag &= ~NLP_PLOGI_SND;
 		spin_unlock_irq(phba->host->host_lock);
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
@@ -890,10 +930,10 @@ lpfc_issue_els_prli(struct lpfc_hba * ph
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = (sizeof (uint32_t) + sizeof (PRLI));
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
-					  ndlp, ELS_CMD_PRLI)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
+					ndlp->nlp_DID, ELS_CMD_PRLI);
+	if (!elsiocb)
 		return 1;
-	}
 
 	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
@@ -1117,10 +1157,10 @@ lpfc_issue_els_adisc(struct lpfc_hba * p
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = (sizeof (uint32_t) + sizeof (ADISC));
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
-					  ndlp, ELS_CMD_ADISC)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
+						ndlp->nlp_DID, ELS_CMD_ADISC);
+	if (!elsiocb)
 		return 1;
-	}
 
 	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
@@ -1224,10 +1264,10 @@ lpfc_issue_els_logo(struct lpfc_hba * ph
 	pring = &psli->ring[LPFC_ELS_RING];
 
 	cmdsize = 2 * (sizeof (uint32_t) + sizeof (struct lpfc_name));
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
-					  ndlp, ELS_CMD_LOGO)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
+						ndlp->nlp_DID, ELS_CMD_LOGO);
+	if (!elsiocb)
 		return 1;
-	}
 
 	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
@@ -1296,8 +1336,9 @@ lpfc_issue_els_scr(struct lpfc_hba * phb
 
 	lpfc_nlp_init(phba, ndlp, nportid);
 
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
-					  ndlp, ELS_CMD_SCR)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
+						ndlp->nlp_DID, ELS_CMD_SCR);
+	if (!elsiocb) {
 		mempool_free( ndlp, phba->nlp_mem_pool);
 		return 1;
 	}
@@ -1348,8 +1389,9 @@ lpfc_issue_els_farpr(struct lpfc_hba * p
 		return 1;
 	lpfc_nlp_init(phba, ndlp, nportid);
 
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
-					  ndlp, ELS_CMD_RNID)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
+						ndlp->nlp_DID, ELS_CMD_RNID);
+	if (!elsiocb) {
 		mempool_free( ndlp, phba->nlp_mem_pool);
 		return 1;
 	}
@@ -1448,7 +1490,7 @@ lpfc_els_retry_delay_handler(struct lpfc
 		lpfc_issue_els_flogi(phba, ndlp, retry);
 		break;
 	case ELS_CMD_PLOGI:
-		if (!lpfc_issue_els_plogi(phba, ndlp, retry)) {
+		if(!lpfc_issue_els_plogi(phba, ndlp->nlp_DID, retry)) {
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
@@ -1491,6 +1533,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 	int retry, maxretry;
 	int delay;
 	uint32_t cmd;
+	uint32_t did;
 
 	retry = 0;
 	delay = 0;
@@ -1499,6 +1542,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	cmd = 0;
+
 	/* Note: context2 may be 0 for internal driver abort
 	 * of delays ELS command.
 	 */
@@ -1508,6 +1552,16 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 		cmd = *elscmd++;
 	}
 
+	if(ndlp)
+		did = ndlp->nlp_DID;
+	else {
+		/* We should only hit this case for retrying PLOGI */
+		did = irsp->un.elsreq64.remoteID;
+		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, did);
+		if (!ndlp && (cmd != ELS_CMD_PLOGI))
+			return 1;
+	}
+
 	switch (irsp->ulpStatus) {
 	case IOSTAT_FCP_RSP_ERROR:
 	case IOSTAT_REMOTE_STOP:
@@ -1596,9 +1650,8 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 		break;
 	}
 
-	if (ndlp->nlp_DID == FDMI_DID) {
+	if (did == FDMI_DID)
 		retry = 1;
-	}
 
 	if ((++cmdiocb->retry) >= maxretry) {
 		phba->fc_stat.elsRetryExceeded++;
@@ -1612,7 +1665,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 				"%d:0107 Retry ELS command x%x to remote "
 				"NPORT x%x Data: x%x x%x\n",
 				phba->brd_no,
-				cmd, ndlp->nlp_DID, cmdiocb->retry, delay);
+				cmd, did, cmdiocb->retry, delay);
 
 		if ((cmd == ELS_CMD_PLOGI) || (cmd == ELS_CMD_ADISC)) {
 			/* If discovery / RSCN timer is running, reset it */
@@ -1623,7 +1676,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 		}
 
 		phba->fc_stat.elsXmitRetry++;
-		if (delay) {
+		if (ndlp && delay) {
 			phba->fc_stat.elsDelayRetry++;
 			ndlp->nlp_retry = cmdiocb->retry;
 
@@ -1642,10 +1695,12 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 			lpfc_issue_els_flogi(phba, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_PLOGI:
-			ndlp->nlp_prev_state = ndlp->nlp_state;
-			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-			lpfc_issue_els_plogi(phba, ndlp, cmdiocb->retry);
+			if (ndlp) {
+				ndlp->nlp_prev_state = ndlp->nlp_state;
+				ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
+				lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+			}
+			lpfc_issue_els_plogi(phba, did, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_ADISC:
 			ndlp->nlp_prev_state = ndlp->nlp_state;
@@ -1671,9 +1726,9 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 	/* No retry ELS command <elsCmd> to remote NPORT <did> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"%d:0108 No retry ELS command x%x to remote NPORT x%x "
-			"Data: x%x x%x\n",
+			"Data: x%x\n",
 			phba->brd_no,
-			cmd, ndlp->nlp_DID, cmdiocb->retry, ndlp->nlp_flag);
+			cmd, did, cmdiocb->retry);
 
 	return 0;
 }
@@ -1827,9 +1882,9 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 	switch (flag) {
 	case ELS_CMD_ACC:
 		cmdsize = sizeof (uint32_t);
-		if ((elsiocb =
-		     lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
-					ndlp, ELS_CMD_ACC)) == 0) {
+		elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
+					ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
+		if (!elsiocb) {
 			ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 			return 1;
 		}
@@ -1841,11 +1896,11 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 		break;
 	case ELS_CMD_PLOGI:
 		cmdsize = (sizeof (struct serv_parm) + sizeof (uint32_t));
-		if ((elsiocb =
-		     lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
-					ndlp, ELS_CMD_ACC)) == 0) {
+		elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
+					ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
+		if (!elsiocb)
 			return 1;
-		}
+
 		icmd = &elsiocb->iocb;
 		icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
 		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
@@ -1910,10 +1965,10 @@ lpfc_els_rsp_reject(struct lpfc_hba * ph
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = 2 * sizeof (uint32_t);
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
-					  ndlp, ELS_CMD_LS_RJT)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
+					ndlp, ndlp->nlp_DID, ELS_CMD_LS_RJT);
+	if (!elsiocb)
 		return 1;
-	}
 
 	icmd = &elsiocb->iocb;
 	oldcmd = &oldiocb->iocb;
@@ -1963,10 +2018,10 @@ lpfc_els_rsp_adisc_acc(struct lpfc_hba *
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = sizeof (uint32_t) + sizeof (ADISC);
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
-					  ndlp, ELS_CMD_ACC)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
+					ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
+	if (!elsiocb)
 		return 1;
-	}
 
 	/* Xmit ADISC ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
@@ -2023,7 +2078,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_hba * 
 
 	cmdsize = sizeof (uint32_t) + sizeof (PRLI);
 	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry, ndlp,
-				(ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK)));
+		ndlp->nlp_DID, (ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK)));
 	if (!elsiocb)
 		return 1;
 
@@ -2103,10 +2158,10 @@ lpfc_els_rsp_rnid_acc(struct lpfc_hba * 
 	if (format)
 		cmdsize += sizeof (RNID_TOP_DISC);
 
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
-					  ndlp, ELS_CMD_ACC)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
+					ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
+	if (!elsiocb)
 		return 1;
-	}
 
 	/* Xmit RNID ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
@@ -2217,7 +2272,7 @@ lpfc_els_disc_plogi(struct lpfc_hba * ph
 				ndlp->nlp_prev_state = ndlp->nlp_state;
 				ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 				lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-				lpfc_issue_els_plogi(phba, ndlp, 0);
+				lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 				sentplogi++;
 				phba->num_disc_nodes++;
 				if (phba->num_disc_nodes >=
@@ -2516,7 +2571,7 @@ lpfc_els_handle_rscn(struct lpfc_hba * p
 			ndlp->nlp_type |= NLP_FABRIC;
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-			lpfc_issue_els_plogi(phba, ndlp, 0);
+			lpfc_issue_els_plogi(phba, NameServer_DID, 0);
 			/* Wait for NameServer login cmpl before we can
 			   continue */
 			return 1;
@@ -2694,8 +2749,8 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba * p
 
 	cmdsize = sizeof(RPS_RSP) + sizeof(uint32_t);
 	mempool_free( pmb, phba->mbox_mem_pool);
-	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, lpfc_max_els_tries,
-					  		ndlp, ELS_CMD_ACC);
+	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, lpfc_max_els_tries, ndlp,
+						ndlp->nlp_DID, ELS_CMD_ACC);
 	if (!elsiocb)
 		return;
 
@@ -2806,11 +2861,11 @@ lpfc_els_rsp_rpl_acc(struct lpfc_hba * p
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
-	if ((elsiocb =
-	     lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
-				ndlp, ELS_CMD_ACC)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
+					ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
+	if (!elsiocb)
 		return 1;
-	}
+
 	icmd = &elsiocb->iocb;
 	oldcmd = &oldiocb->iocb;
 	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
@@ -2943,7 +2998,7 @@ lpfc_els_rcv_farp(struct lpfc_hba * phba
 				ndlp->nlp_prev_state = ndlp->nlp_state;
 				ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 				lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-				lpfc_issue_els_plogi(phba, ndlp, 0);
+				lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
 			}
 
 			/* Send a FARP response to that node */


