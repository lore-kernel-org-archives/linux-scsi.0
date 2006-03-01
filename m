From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 10/22] lpfc 8.1.2: Misc FC Discovery changes :
Date: Tue, 28 Feb 2006 19:25:23 -0500
Message-ID: <20060301002523.GA15457@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:45478 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964851AbWCAAZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:26 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PN8h015463
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:23 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PN82015462
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Misc FC Discovery changes :
   - Added FC_BYPASSED_MODE statistic
   - Corrected some log message data
   - Fix up Discovery infrastructure to support FAN:
       Allow Fabric entities to flow thru DSM
       Fix up linkup/linkdown unregister login processing for Fabric entities
       Clean up Discovery code
       Utilize nodev_tmo for Fabric entities
   - Use of 3 * ratov for CT handling timeouts
   - Fix up DSM to make more appropriate decisions and clean up code.


Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -283,16 +283,18 @@ lpfc_linkdown(struct lpfc_hba * phba)
 {
 	struct lpfc_sli       *psli;
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
-	struct list_head *listp;
-	struct list_head *node_list[7];
+	struct list_head *listp, *node_list[7];
 	LPFC_MBOXQ_t     *mb;
 	int               rc, i;
 
 	psli = &phba->sli;
 
-	spin_lock_irq(phba->host->host_lock);
-	phba->hba_state = LPFC_LINK_DOWN;
-	spin_unlock_irq(phba->host->host_lock);
+	/* sysfs or selective reset may call this routine to clean up */
+	if (phba->hba_state > LPFC_LINK_DOWN) {
+		spin_lock_irq(phba->host->host_lock);
+		phba->hba_state = LPFC_LINK_DOWN;
+		spin_unlock_irq(phba->host->host_lock);
+	}
 
 	/* Clean up any firmware default rpi's */
 	if ((mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))) {
@@ -324,32 +326,20 @@ lpfc_linkdown(struct lpfc_hba * phba)
 			continue;
 
 		list_for_each_entry_safe(ndlp, next_ndlp, listp, nlp_listp) {
-			/* Fabric nodes are not handled thru state machine for
-			   link down */
-			if (ndlp->nlp_type & NLP_FABRIC) {
-				/* Remove ALL Fabric nodes except Fabric_DID */
-				if (ndlp->nlp_DID != Fabric_DID) {
-					/* Take it off current list and free */
-					lpfc_nlp_list(phba, ndlp,
-						NLP_NO_LIST);
-				}
-			}
-			else {
 
-				rc = lpfc_disc_state_machine(phba, ndlp, NULL,
-						     NLP_EVT_DEVICE_RECOVERY);
+			rc = lpfc_disc_state_machine(phba, ndlp, NULL,
+					     NLP_EVT_DEVICE_RECOVERY);
 
-				/* Check config parameter use-adisc or FCP-2 */
-				if ((rc != NLP_STE_FREED_NODE) &&
-					(phba->cfg_use_adisc == 0) &&
-					!(ndlp->nlp_fcp_info &
-						NLP_FCP_2_DEVICE)) {
-					/* We know we will have to relogin, so
-					 * unreglogin the rpi right now to fail
-					 * any outstanding I/Os quickly.
-					 */
-					lpfc_unreg_rpi(phba, ndlp);
-				}
+			/* Check config parameter use-adisc or FCP-2 */
+			if ((rc != NLP_STE_FREED_NODE) &&
+				(phba->cfg_use_adisc == 0) &&
+				!(ndlp->nlp_fcp_info &
+					NLP_FCP_2_DEVICE)) {
+				/* We know we will have to relogin, so
+				 * unreglogin the rpi right now to fail
+				 * any outstanding I/Os quickly.
+				 */
+				lpfc_unreg_rpi(phba, ndlp);
 			}
 		}
 	}
@@ -391,6 +381,8 @@ static int
 lpfc_linkup(struct lpfc_hba * phba)
 {
 	struct lpfc_nodelist *ndlp, *next_ndlp;
+	struct list_head *listp, *node_list[7];
+	int i;
 
 	spin_lock_irq(phba->host->host_lock);
 	phba->hba_state = LPFC_LINK_UP;
@@ -401,14 +393,33 @@ lpfc_linkup(struct lpfc_hba * phba)
 	spin_unlock_irq(phba->host->host_lock);
 
 
-	/*
-	 * Clean up old Fabric NLP_FABRIC logins.
-	 */
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nlpunmap_list,
-				nlp_listp) {
-		if (ndlp->nlp_DID == Fabric_DID) {
-			/* Take it off current list and free */
-			lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+	node_list[0] = &phba->fc_plogi_list;
+	node_list[1] = &phba->fc_adisc_list;
+	node_list[2] = &phba->fc_reglogin_list;
+	node_list[3] = &phba->fc_prli_list;
+	node_list[4] = &phba->fc_nlpunmap_list;
+	node_list[5] = &phba->fc_nlpmap_list;
+	node_list[6] = &phba->fc_npr_list;
+	for (i = 0; i < 7; i++) {
+		listp = node_list[i];
+		if (list_empty(listp))
+			continue;
+
+		list_for_each_entry_safe(ndlp, next_ndlp, listp, nlp_listp) {
+			if (phba->fc_flag & FC_LBIT) {
+				if (ndlp->nlp_type & NLP_FABRIC) {
+					/* On Linkup its safe to clean up the
+					 * ndlp from Fabric connections.
+					 */
+					lpfc_nlp_list(phba, ndlp,
+							NLP_UNUSED_LIST);
+				} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
+					/* Fail outstanding IO now since device
+					 * is marked for PLOGI.
+					 */
+					lpfc_unreg_rpi(phba, ndlp);
+				}
+			}
 		}
 	}
 
@@ -784,6 +795,13 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba * 
 
 	memcpy(&phba->alpa_map[0], mp->virt, 128);
 
+	spin_lock_irq(phba->host->host_lock);
+	if (la->pb)
+		phba->fc_flag |= FC_BYPASSED_MODE;
+	else
+		phba->fc_flag &= ~FC_BYPASSED_MODE;
+	spin_unlock_irq(phba->host->host_lock);
+
 	if (((phba->fc_eventTag + 1) < la->eventTag) ||
 	     (phba->fc_eventTag == la->eventTag)) {
 		phba->fc_stat.LinkMultiEvent++;
@@ -904,32 +922,36 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		 */
 		lpfc_issue_els_scr(phba, SCR_DID, 0);
 
-		/* Allocate a new node instance.  If the pool is empty, just
-		 * start the discovery process and skip the Nameserver login
-		 * process.  This is attempted again later on.  Otherwise, issue
-		 * a Port Login (PLOGI) to the NameServer
-		 */
-		if ((ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL))
-		    == 0) {
-			lpfc_disc_start(phba);
-		} else {
-			lpfc_nlp_init(phba, ndlp, NameServer_DID);
-			ndlp->nlp_type |= NLP_FABRIC;
-			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-			lpfc_issue_els_plogi(phba, ndlp, 0);
-			if (phba->cfg_fdmi_on) {
-				if ((ndlp_fdmi = mempool_alloc(
-						       phba->nlp_mem_pool,
-						       GFP_KERNEL))) {
-					lpfc_nlp_init(phba, ndlp_fdmi,
-						FDMI_DID);
-					ndlp_fdmi->nlp_type |= NLP_FABRIC;
-					ndlp_fdmi->nlp_state =
-					    NLP_STE_PLOGI_ISSUE;
-					lpfc_issue_els_plogi(phba, ndlp_fdmi,
-							     0);
-				}
+		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, NameServer_DID);
+		if (!ndlp) {
+			/* Allocate a new node instance. If the pool is empty,
+			 * start the discovery process and skip the Nameserver
+			 * login process.  This is attempted again later on.
+			 * Otherwise, issue a Port Login (PLOGI) to NameServer.
+			 */
+			ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_ATOMIC);
+			if (!ndlp) {
+				lpfc_disc_start(phba);
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+				mempool_free( pmb, phba->mbox_mem_pool);
+				return;
+			} else {
+				lpfc_nlp_init(phba, ndlp, NameServer_DID);
+				ndlp->nlp_type |= NLP_FABRIC;
+			}
+		}
+		ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
+		lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
+		lpfc_issue_els_plogi(phba, ndlp, 0);
+		if (phba->cfg_fdmi_on) {
+			ndlp_fdmi = mempool_alloc(phba->nlp_mem_pool,
+								GFP_KERNEL);
+			if (ndlp_fdmi) {
+				lpfc_nlp_init(phba, ndlp_fdmi, FDMI_DID);
+				ndlp_fdmi->nlp_type |= NLP_FABRIC;
+				ndlp_fdmi->nlp_state = NLP_STE_PLOGI_ISSUE;
+				lpfc_issue_els_plogi(phba, ndlp_fdmi, 0);
 			}
 		}
 	}
@@ -937,7 +959,6 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free( pmb, phba->mbox_mem_pool);
-
 	return;
 }
 
@@ -1241,16 +1262,9 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		list_add_tail(&nlp->nlp_listp, &phba->fc_npr_list);
 		phba->fc_npr_cnt++;
 
-		/*
-		 * Sanity check for Fabric entity.
-		 * Set nodev_tmo for NPR state, for Fabric use 1 sec.
-		 */
-		if (nlp->nlp_type & NLP_FABRIC) {
-			mod_timer(&nlp->nlp_tmofunc, jiffies + HZ);
-		}
-		else {
+		if (!(nlp->nlp_flag & NLP_NODEV_TMO)) {
 			mod_timer(&nlp->nlp_tmofunc,
-			    jiffies + HZ * phba->cfg_nodev_tmo);
+		 			jiffies + HZ * phba->cfg_nodev_tmo);
 		}
 		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= NLP_NODEV_TMO;
@@ -1314,7 +1328,15 @@ lpfc_set_disctmo(struct lpfc_hba * phba)
 {
 	uint32_t tmo;
 
-	tmo = ((phba->fc_ratov * 2) + 1);
+	if (phba->hba_state == LPFC_LOCAL_CFG_LINK) {
+		/* For FAN, timeout should be greater then edtov */
+		tmo = (((phba->fc_edtov + 999) / 1000) + 1);
+	} else {
+		/* Normal discovery timeout should be > then ELS/CT timeout
+		 * FC spec states we need 3 * ratov for CT requests
+		 */
+		tmo = ((phba->fc_ratov * 3) + 3);
+	}
 
 	mod_timer(&phba->fc_disctmo, jiffies + HZ * tmo);
 	spin_lock_irq(phba->host->host_lock);
@@ -1846,8 +1868,9 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 	struct lpfc_nodelist *ndlp;
 	uint32_t flg;
 
-	if ((ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, did)) == 0) {
-		if ((phba->hba_state == LPFC_HBA_READY) &&
+	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, did);
+	if (!ndlp) {
+		if ((phba->fc_flag & FC_RSCN_MODE) &&
 		   ((lpfc_rscn_payload_check(phba, did) == 0)))
 			return NULL;
 		ndlp = (struct lpfc_nodelist *)
@@ -1860,10 +1883,23 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		return ndlp;
 	}
-	if ((phba->hba_state == LPFC_HBA_READY) &&
-	    (phba->fc_flag & FC_RSCN_MODE)) {
+	if (phba->fc_flag & FC_RSCN_MODE) {
 		if (lpfc_rscn_payload_check(phba, did)) {
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
+
+			/* Since this node is marked for discovery,
+			 * delay timeout is not needed.
+			 */
+			if (ndlp->nlp_flag & NLP_DELAY_TMO) {
+				ndlp->nlp_flag &= ~NLP_DELAY_TMO;
+				spin_unlock_irq(phba->host->host_lock);
+				del_timer_sync(&ndlp->nlp_delayfunc);
+				spin_lock_irq(phba->host->host_lock);
+				if (!list_empty(&ndlp->els_retry_evt.
+						evt_listp))
+					list_del_init(&ndlp->els_retry_evt.
+				      		evt_listp);
+			}
 		}
 		else {
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
@@ -1872,10 +1908,8 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 	}
 	else {
 		flg = ndlp->nlp_flag & NLP_LIST_MASK;
-		if ((flg == NLP_ADISC_LIST) ||
-		(flg == NLP_PLOGI_LIST)) {
+		if ((flg == NLP_ADISC_LIST) || (flg == NLP_PLOGI_LIST))
 			return NULL;
-		}
 		ndlp->nlp_state = NLP_STE_NPR_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
@@ -2174,7 +2208,7 @@ static void
 lpfc_disc_timeout_handler(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli;
-	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *ndlp, *next_ndlp;
 	LPFC_MBOXQ_t *clearlambox, *initlinkmbox;
 	int rc, clrlaerr = 0;
 
@@ -2201,10 +2235,20 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 				 "%d:0221 FAN timeout\n",
 				 phba->brd_no);
 
-		/* Forget about FAN, Start discovery by sending a FLOGI
-		 * hba_state is identically LPFC_FLOGI while waiting for FLOGI
-		 * cmpl
-		 */
+		/* Start discovery by sending FLOGI, clean up old rpis */
+		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
+					nlp_listp) {
+			if (ndlp->nlp_type & NLP_FABRIC) {
+				/* Clean up the ndlp on Fabric connections */
+				lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+			}
+			else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
+				/* Fail outstanding IO now since device
+				 * is marked for PLOGI.
+				 */
+				lpfc_unreg_rpi(phba, ndlp);
+			}
+		}
 		phba->hba_state = LPFC_FLOGI;
 		lpfc_set_disctmo(phba);
 		lpfc_initial_flogi(phba);
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -46,13 +46,13 @@ lpfc_check_adisc(struct lpfc_hba * phba,
 	 * table entry for that node.
 	 */
 	if (memcmp(nn, &ndlp->nlp_nodename, sizeof (struct lpfc_name)) != 0)
-		return (0);
+		return 0;
 
 	if (memcmp(pn, &ndlp->nlp_portname, sizeof (struct lpfc_name)) != 0)
-		return (0);
+		return 0;
 
 	/* we match, return success */
-	return (1);
+	return 1;
 }
 
 int
@@ -159,7 +159,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba 
 		}
 		ptr = NULL;
 	}
-	return (ptr);
+	return ptr;
 }
 
 
@@ -266,7 +266,7 @@ lpfc_els_abort(struct lpfc_hba * phba, s
 		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
 			list_del_init(&ndlp->els_retry_evt.evt_listp);
 	}
-	return (0);
+	return 0;
 }
 
 static int
@@ -321,7 +321,7 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_SPARM_OPTIONS;
 		lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
-		return (0);
+		return 0;
 	}
 	icmd = &cmdiocb->iocb;
 
@@ -362,7 +362,7 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 	case  NLP_STE_UNMAPPED_NODE:
 	case  NLP_STE_MAPPED_NODE:
 		lpfc_els_rsp_acc(phba, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL, 0);
-		return (1);
+		return 1;
 	}
 
 	if ((phba->fc_flag & FC_PT2PT)
@@ -409,13 +409,13 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 	}
 	ndlp->nlp_flag |= NLP_RCV_PLOGI;
 	lpfc_els_rsp_acc(phba, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox, 0);
-	return (1);
+	return 1;
 
 out:
 	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 	stat.un.b.lsRjtRsnCodeExp = LSEXP_OUT_OF_RESOURCE;
 	lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
-	return (0);
+	return 0;
 }
 
 static int
@@ -456,7 +456,7 @@ lpfc_rcv_padisc(struct lpfc_hba * phba,
 			lpfc_els_rsp_acc(phba, ELS_CMD_PLOGI, cmdiocb, ndlp,
 				NULL, 0);
 		}
-		return (1);
+		return 1;
 	}
 	/* Reject this request because invalid parameters */
 	stat.un.b.lsRjtRsvd0 = 0;
@@ -474,7 +474,7 @@ lpfc_rcv_padisc(struct lpfc_hba * phba,
 	spin_unlock_irq(phba->host->host_lock);
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
-	return (0);
+	return 0;
 }
 
 static int
@@ -489,25 +489,31 @@ lpfc_rcv_logo(struct lpfc_hba * phba,
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
 	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
 
-	if (!(ndlp->nlp_type & NLP_FABRIC)) {
+	if (!(ndlp->nlp_type & NLP_FABRIC) ||
+		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
 		/* Only try to re-login if this is NOT a Fabric Node */
 		ndlp->nlp_last_elscmd = (unsigned long)ELS_CMD_PLOGI;
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
 		spin_lock_irq(phba->host->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		spin_unlock_irq(phba->host->host_lock);
-	}
 
-	ndlp->nlp_state = NLP_STE_NPR_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+		ndlp->nlp_state = NLP_STE_NPR_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
+	} else {
+		ndlp->nlp_state = NLP_STE_UNUSED_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
+	}
 
+	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+	spin_unlock_irq(phba->host->host_lock);
 	/* The driver has to wait until the ACC completes before it continues
 	 * processing the LOGO.  The action will resume in
 	 * lpfc_cmpl_els_logo_acc routine. Since part of processing includes an
 	 * unreg_login, the driver waits so the ACC does not get aborted.
 	 */
-	return (0);
+	return 0;
 }
 
 static void
@@ -555,20 +561,12 @@ lpfc_disc_set_adisc(struct lpfc_hba * ph
 	if ((phba->cfg_use_adisc == 0) &&
 		!(phba->fc_flag & FC_RSCN_MODE)) {
 		if (!(ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE))
-			return (0);
+			return 0;
 	}
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag |= NLP_NPR_ADISC;
 	spin_unlock_irq(phba->host->host_lock);
-	return (1);
-}
-
-static uint32_t
-lpfc_disc_noop(struct lpfc_hba * phba,
-		struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
-{
-	/* This routine does nothing, just return the current state */
-	return (ndlp->nlp_state);
+	return 1;
 }
 
 static uint32_t
@@ -583,7 +581,7 @@ lpfc_disc_illegal(struct lpfc_hba * phba
 			phba->brd_no,
 			ndlp->nlp_DID, evt, ndlp->nlp_state, ndlp->nlp_rpi,
 			ndlp->nlp_flag);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 /* Start of Discovery State Machine routines */
@@ -599,10 +597,10 @@ lpfc_rcv_plogi_unused_node(struct lpfc_h
 	if (lpfc_rcv_plogi(phba, ndlp, cmdiocb)) {
 		ndlp->nlp_state = NLP_STE_UNUSED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
@@ -611,7 +609,7 @@ lpfc_rcv_els_unused_node(struct lpfc_hba
 {
 	lpfc_issue_els_logo(phba, ndlp, 0);
 	lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -628,7 +626,7 @@ lpfc_rcv_logo_unused_node(struct lpfc_hb
 	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
 	lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
 
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -636,7 +634,7 @@ lpfc_cmpl_logo_unused_node(struct lpfc_h
 			  struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
@@ -644,7 +642,7 @@ lpfc_device_rm_unused_node(struct lpfc_h
 			   struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
@@ -682,7 +680,22 @@ lpfc_rcv_plogi_plogi_issue(struct lpfc_h
 		lpfc_rcv_plogi(phba, ndlp, cmdiocb);
 	} /* if our portname was less */
 
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
+}
+
+static uint32_t
+lpfc_rcv_logo_plogi_issue(struct lpfc_hba * phba,
+			  struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
+{
+	struct lpfc_iocbq     *cmdiocb;
+
+	cmdiocb = (struct lpfc_iocbq *) arg;
+
+	/* software abort outstanding PLOGI */
+	lpfc_els_abort(phba, ndlp, 1);
+
+	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -712,7 +725,7 @@ lpfc_rcv_els_plogi_issue(struct lpfc_hba
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -731,7 +744,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
 	if (ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 
 	irsp = &rspiocb->iocb;
@@ -812,7 +825,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 				NLP_STE_REG_LOGIN_ISSUE;
 			lpfc_nlp_list(phba, ndlp,
 				      NLP_REGLOGIN_LIST);
-			return (ndlp->nlp_state);
+			return ndlp->nlp_state;
 		}
 		mempool_free(mbox, phba->mbox_mem_pool);
 	} else {
@@ -824,7 +837,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 	/* Free this node since the driver cannot login or has the wrong
 	   sparm */
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
@@ -835,7 +848,7 @@ lpfc_device_rm_plogi_issue(struct lpfc_h
 	lpfc_els_abort(phba, ndlp, 1);
 
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
@@ -852,7 +865,7 @@ lpfc_device_recov_plogi_issue(struct lpf
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 	spin_unlock_irq(phba->host->host_lock);
 
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -868,13 +881,13 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_h
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	if (lpfc_rcv_plogi(phba, ndlp, cmdiocb)) {
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 	ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 	lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 	lpfc_issue_els_plogi(phba, ndlp, 0);
 
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -887,7 +900,7 @@ lpfc_rcv_prli_adisc_issue(struct lpfc_hb
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_els_rsp_prli_acc(phba, cmdiocb, ndlp);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -903,7 +916,7 @@ lpfc_rcv_logo_adisc_issue(struct lpfc_hb
 	lpfc_els_abort(phba, ndlp, 0);
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -916,7 +929,7 @@ lpfc_rcv_padisc_adisc_issue(struct lpfc_
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_padisc(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -930,7 +943,7 @@ lpfc_rcv_prlo_adisc_issue(struct lpfc_hb
 
 	/* Treat like rcv logo */
 	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -963,7 +976,7 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 		ndlp->nlp_state = NLP_STE_NPR_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 		lpfc_unreg_rpi(phba, ndlp);
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 	if (ndlp->nlp_type & NLP_FCP_TARGET) {
 		ndlp->nlp_state = NLP_STE_MAPPED_NODE;
@@ -972,7 +985,7 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
 	}
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -984,7 +997,7 @@ lpfc_device_rm_adisc_issue(struct lpfc_h
 	lpfc_els_abort(phba, ndlp, 1);
 
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
@@ -999,10 +1012,10 @@ lpfc_device_recov_adisc_issue(struct lpf
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	ndlp->nlp_flag |= NLP_NPR_ADISC;
 	spin_unlock_irq(phba->host->host_lock);
 
-	lpfc_disc_set_adisc(phba, ndlp);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1015,7 +1028,7 @@ lpfc_rcv_plogi_reglogin_issue(struct lpf
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_plogi(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1028,7 +1041,7 @@ lpfc_rcv_prli_reglogin_issue(struct lpfc
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_els_rsp_prli_acc(phba, cmdiocb, ndlp);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1041,7 +1054,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1054,7 +1067,7 @@ lpfc_rcv_padisc_reglogin_issue(struct lp
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_padisc(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1066,7 +1079,7 @@ lpfc_rcv_prlo_reglogin_issue(struct lpfc
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1100,7 +1113,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 		ndlp->nlp_last_elscmd = (unsigned long)ELS_CMD_PLOGI;
 		ndlp->nlp_state = NLP_STE_NPR_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
@@ -1114,7 +1127,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
 	}
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1123,7 +1136,7 @@ lpfc_device_rm_reglogin_issue(struct lpf
 			      uint32_t evt)
 {
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
@@ -1136,7 +1149,7 @@ lpfc_device_recov_reglogin_issue(struct 
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 	spin_unlock_irq(phba->host->host_lock);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1148,7 +1161,7 @@ lpfc_rcv_plogi_prli_issue(struct lpfc_hb
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_plogi(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1160,7 +1173,7 @@ lpfc_rcv_prli_prli_issue(struct lpfc_hba
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_els_rsp_prli_acc(phba, cmdiocb, ndlp);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1175,7 +1188,7 @@ lpfc_rcv_logo_prli_issue(struct lpfc_hba
 	lpfc_els_abort(phba, ndlp, 1);
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1187,7 +1200,7 @@ lpfc_rcv_padisc_prli_issue(struct lpfc_h
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_padisc(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 /* This routine is envoked when we rcv a PRLO request from a nport
@@ -1203,7 +1216,7 @@ lpfc_rcv_prlo_prli_issue(struct lpfc_hba
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1222,7 +1235,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_hb
 	if (irsp->ulpStatus) {
 		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 
 	/* Check out PRLI rsp */
@@ -1240,7 +1253,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_hb
 
 	ndlp->nlp_state = NLP_STE_MAPPED_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 /*! lpfc_device_rm_prli_issue
@@ -1268,7 +1281,7 @@ lpfc_device_rm_prli_issue(struct lpfc_hb
 	lpfc_els_abort(phba, ndlp, 1);
 
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 
@@ -1300,7 +1313,7 @@ lpfc_device_recov_prli_issue(struct lpfc
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 	spin_unlock_irq(phba->host->host_lock);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1312,7 +1325,7 @@ lpfc_rcv_plogi_unmap_node(struct lpfc_hb
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_plogi(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1325,7 +1338,7 @@ lpfc_rcv_prli_unmap_node(struct lpfc_hba
 
 	lpfc_rcv_prli(phba, ndlp, cmdiocb);
 	lpfc_els_rsp_prli_acc(phba, cmdiocb, ndlp);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1337,7 +1350,7 @@ lpfc_rcv_logo_unmap_node(struct lpfc_hba
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1349,7 +1362,7 @@ lpfc_rcv_padisc_unmap_node(struct lpfc_h
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_padisc(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1360,9 +1373,8 @@ lpfc_rcv_prlo_unmap_node(struct lpfc_hba
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
-	/* Treat like rcv logo */
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1374,7 +1386,7 @@ lpfc_device_recov_unmap_node(struct lpfc
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 	lpfc_disc_set_adisc(phba, ndlp);
 
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1386,7 +1398,7 @@ lpfc_rcv_plogi_mapped_node(struct lpfc_h
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_plogi(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1398,7 +1410,7 @@ lpfc_rcv_prli_mapped_node(struct lpfc_hb
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_els_rsp_prli_acc(phba, cmdiocb, ndlp);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1410,7 +1422,7 @@ lpfc_rcv_logo_mapped_node(struct lpfc_hb
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1423,7 +1435,7 @@ lpfc_rcv_padisc_mapped_node(struct lpfc_
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_padisc(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1442,7 +1454,7 @@ lpfc_rcv_prlo_mapped_node(struct lpfc_hb
 
 	/* Treat like rcv logo */
 	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1456,7 +1468,7 @@ lpfc_device_recov_mapped_node(struct lpf
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 	spin_unlock_irq(phba->host->host_lock);
 	lpfc_disc_set_adisc(phba, ndlp);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1470,14 +1482,14 @@ lpfc_rcv_plogi_npr_node(struct lpfc_hba 
 
 	/* Ignore PLOGI if we have an outstanding LOGO */
 	if (ndlp->nlp_flag & NLP_LOGO_SND) {
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 
 	if (lpfc_rcv_plogi(phba, ndlp, cmdiocb)) {
 		spin_lock_irq(phba->host->host_lock);
 		ndlp->nlp_flag &= ~(NLP_NPR_ADISC | NLP_NPR_2B_DISC);
 		spin_unlock_irq(phba->host->host_lock);
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 
 	/* send PLOGI immediately, move to PLOGI issue state */
@@ -1486,7 +1498,7 @@ lpfc_rcv_plogi_npr_node(struct lpfc_hba 
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 			lpfc_issue_els_plogi(phba, ndlp, 0);
 	}
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1506,6 +1518,9 @@ lpfc_rcv_prli_npr_node(struct lpfc_hba *
 
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
 		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
+			spin_lock_irq(phba->host->host_lock);
+			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+			spin_unlock_irq(phba->host->host_lock);
 			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
 			lpfc_issue_els_adisc(phba, ndlp, 0);
@@ -1515,7 +1530,7 @@ lpfc_rcv_prli_npr_node(struct lpfc_hba *
 			lpfc_issue_els_plogi(phba, ndlp, 0);
 		}
 	}
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1528,7 +1543,7 @@ lpfc_rcv_logo_npr_node(struct lpfc_hba *
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_logo(phba, ndlp, cmdiocb);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1553,7 +1568,7 @@ lpfc_rcv_padisc_npr_node(struct lpfc_hba
 			lpfc_issue_els_plogi(phba, ndlp, 0);
 		}
 	}
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1565,25 +1580,46 @@ lpfc_rcv_prlo_npr_node(struct lpfc_hba *
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
+	spin_lock_irq(phba->host->host_lock);
+	ndlp->nlp_flag |= NLP_LOGO_ACC;
+	spin_unlock_irq(phba->host->host_lock);
+
 	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
 
-	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-		if (ndlp->nlp_last_elscmd == (unsigned long)ELS_CMD_PLOGI) {
-			return (ndlp->nlp_state);
-		} else {
-			spin_lock_irq(phba->host->host_lock);
-			ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-			spin_unlock_irq(phba->host->host_lock);
-			del_timer_sync(&ndlp->nlp_delayfunc);
-			if (!list_empty(&ndlp->els_retry_evt.evt_listp))
-				list_del_init(&ndlp->els_retry_evt.evt_listp);
-		}
+	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
+		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
+		spin_lock_irq(phba->host->host_lock);
+		ndlp->nlp_flag |= NLP_DELAY_TMO;
+		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+		spin_unlock_irq(phba->host->host_lock);
+	} else {
+		spin_lock_irq(phba->host->host_lock);
+		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+		spin_unlock_irq(phba->host->host_lock);
 	}
+	return ndlp->nlp_state;
+}
 
-	ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
-	lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
-	lpfc_issue_els_plogi(phba, ndlp, 0);
-	return (ndlp->nlp_state);
+static uint32_t
+lpfc_cmpl_plogi_npr_node(struct lpfc_hba * phba,
+			  struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
+{
+	struct lpfc_iocbq *cmdiocb, *rspiocb;
+
+	cmdiocb = (struct lpfc_iocbq *) arg;
+	rspiocb = cmdiocb->context_un.rsp_iocb;
+	return ndlp->nlp_state;
+}
+
+static uint32_t
+lpfc_cmpl_prli_npr_node(struct lpfc_hba * phba,
+			  struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
+{
+	struct lpfc_iocbq *cmdiocb, *rspiocb;
+
+	cmdiocb = (struct lpfc_iocbq *) arg;
+	rspiocb = cmdiocb->context_un.rsp_iocb;
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1592,7 +1628,19 @@ lpfc_cmpl_logo_npr_node(struct lpfc_hba 
 {
 	lpfc_unreg_rpi(phba, ndlp);
 	/* This routine does nothing, just return the current state */
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
+}
+
+static uint32_t
+lpfc_cmpl_adisc_npr_node(struct lpfc_hba * phba,
+			    struct lpfc_nodelist * ndlp, void *arg,
+			    uint32_t evt)
+{
+	struct lpfc_iocbq *cmdiocb, *rspiocb;
+
+	cmdiocb = (struct lpfc_iocbq *) arg;
+	rspiocb = cmdiocb->context_un.rsp_iocb;
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1606,9 +1654,10 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_
 	pmb = (LPFC_MBOXQ_t *) arg;
 	mb = &pmb->mb;
 
-	ndlp->nlp_rpi = mb->un.varWords[0];
+	if (!mb->mbxStatus)
+		ndlp->nlp_rpi = mb->un.varWords[0];
 
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 static uint32_t
@@ -1617,7 +1666,7 @@ lpfc_device_rm_npr_node(struct lpfc_hba 
 			    uint32_t evt)
 {
 	lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-	return (NLP_STE_FREED_NODE);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
@@ -1633,10 +1682,10 @@ lpfc_device_recov_npr_node(struct lpfc_h
 			list_del_init(&ndlp->els_retry_evt.evt_listp);
 		spin_unlock_irq(phba->host->host_lock);
 		del_timer_sync(&ndlp->nlp_delayfunc);
-		return (ndlp->nlp_state);
+		return ndlp->nlp_state;
 	}
 	spin_unlock_irq(phba->host->host_lock);
-	return (ndlp->nlp_state);
+	return ndlp->nlp_state;
 }
 
 
@@ -1715,7 +1764,7 @@ static uint32_t (*lpfc_disc_action[NLP_S
 
 	lpfc_rcv_plogi_plogi_issue,	/* RCV_PLOGI   PLOGI_ISSUE    */
 	lpfc_rcv_els_plogi_issue,	/* RCV_PRLI        */
-	lpfc_rcv_els_plogi_issue,	/* RCV_LOGO        */
+	lpfc_rcv_logo_plogi_issue,	/* RCV_LOGO        */
 	lpfc_rcv_els_plogi_issue,	/* RCV_ADISC       */
 	lpfc_rcv_els_plogi_issue,	/* RCV_PDISC       */
 	lpfc_rcv_els_plogi_issue,	/* RCV_PRLO        */
@@ -1803,10 +1852,10 @@ static uint32_t (*lpfc_disc_action[NLP_S
 	lpfc_rcv_padisc_npr_node,       /* RCV_ADISC       */
 	lpfc_rcv_padisc_npr_node,       /* RCV_PDISC       */
 	lpfc_rcv_prlo_npr_node,         /* RCV_PRLO        */
-	lpfc_disc_noop,			/* CMPL_PLOGI      */
-	lpfc_disc_noop,			/* CMPL_PRLI       */
+	lpfc_cmpl_plogi_npr_node,	/* CMPL_PLOGI      */
+	lpfc_cmpl_prli_npr_node,	/* CMPL_PRLI       */
 	lpfc_cmpl_logo_npr_node,        /* CMPL_LOGO       */
-	lpfc_disc_noop,			/* CMPL_ADISC      */
+	lpfc_cmpl_adisc_npr_node,       /* CMPL_ADISC      */
 	lpfc_cmpl_reglogin_npr_node,    /* CMPL_REG_LOGIN  */
 	lpfc_device_rm_npr_node,        /* DEVICE_RM       */
 	lpfc_device_recov_npr_node,     /* DEVICE_RECOVERY */
@@ -1852,10 +1901,10 @@ lpfc_disc_state_machine(struct lpfc_hba 
 		ndlp->nlp_flag &= ~NLP_DELAY_REMOVE;
 		spin_unlock_irq(phba->host->host_lock);
 		lpfc_nlp_remove(phba, ndlp);
-		return (NLP_STE_FREED_NODE);
+		return NLP_STE_FREED_NODE;
 	}
 	if (rc == NLP_STE_FREED_NODE)
-		return (NLP_STE_FREED_NODE);
+		return NLP_STE_FREED_NODE;
 	ndlp->nlp_state = rc;
-	return (rc);
+	return rc;
 }
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -260,8 +260,10 @@ lpfc_gen_req(struct lpfc_hba *phba, stru
 	icmd->un.genreq64.w5.hcsw.Rctl = FC_UNSOL_CTL;
 	icmd->un.genreq64.w5.hcsw.Type = FC_COMMON_TRANSPORT_ULP;
 
-	if (!tmo)
-		tmo = (2 * phba->fc_ratov) + 1;
+	if (!tmo) {
+		 /* FC spec states we need 3 * ratov for CT requests */
+		tmo = (3 * phba->fc_ratov);
+	}
 	icmd->ulpTimeout = tmo;
 	icmd->ulpBdeCount = 1;
 	icmd->ulpLe = 1;
@@ -449,6 +451,11 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC)) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
+					"%d:0239 NameServer Rsp "
+					"Data: x%x\n",
+					phba->brd_no,
+					phba->fc_flag);
 			lpfc_ns_rsp(phba, outp,
 				    (uint32_t) (irsp->un.genreq64.bdl.bdeSize));
 		} else if (CTrsp->CommandResponse.bits.CmdRsp ==
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -92,7 +92,7 @@ lpfc_els_chk_latt(struct lpfc_hba * phba
 		}
 	}
 
-	return (1);
+	return 1;
 
 }
 
@@ -235,7 +235,7 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 				ndlp->nlp_DID, icmd->ulpIoTag, cmdSize);
 	}
 
-	return (elsiocb);
+	return elsiocb;
 }
 
 
@@ -446,9 +446,10 @@ lpfc_cmpl_els_flogi(struct lpfc_hba * ph
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_ELS,
-				"%d:0100 FLOGI failure Data: x%x x%x\n",
+				"%d:0100 FLOGI failure Data: x%x x%x x%x\n",
 				phba->brd_no,
-				irsp->ulpStatus, irsp->un.ulpWord[4]);
+				irsp->ulpStatus, irsp->un.ulpWord[4],
+				irsp->ulpTimeout);
 		goto flogifail;
 	}
 
@@ -517,7 +518,7 @@ lpfc_issue_els_flogi(struct lpfc_hba * p
 	cmdsize = (sizeof (uint32_t) + sizeof (struct serv_parm));
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
 					  ndlp, ELS_CMD_FLOGI)) == 0) {
-		return (1);
+		return 1;
 	}
 
 	icmd = &elsiocb->iocb;
@@ -552,9 +553,9 @@ lpfc_issue_els_flogi(struct lpfc_hba * p
 	spin_unlock_irq(phba->host->host_lock);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
-	return (0);
+	return 0;
 }
 
 int
@@ -611,29 +612,21 @@ lpfc_initial_flogi(struct lpfc_hba * phb
 {
 	struct lpfc_nodelist *ndlp;
 
-	/* First look for Fabric ndlp on the unmapped list */
-
-	if ((ndlp =
-	     lpfc_findnode_did(phba, NLP_SEARCH_UNMAPPED,
-			       Fabric_DID)) == 0) {
+	/* First look for the Fabric ndlp */
+	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, Fabric_DID);
+	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
-		if ((ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL))
-		    == 0) {
-			return (0);
-		}
+		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		if (!ndlp)
+			return 0;
 		lpfc_nlp_init(phba, ndlp, Fabric_DID);
-	}
-	else {
-		phba->fc_unmap_cnt--;
-		list_del(&ndlp->nlp_listp);
-		spin_lock_irq(phba->host->host_lock);
-		ndlp->nlp_flag &= ~NLP_LIST_MASK;
-		spin_unlock_irq(phba->host->host_lock);
+	} else {
+		lpfc_nlp_list(phba, ndlp, NLP_JUST_DQ);
 	}
 	if (lpfc_issue_els_flogi(phba, ndlp, 0)) {
 		mempool_free( ndlp, phba->nlp_mem_pool);
 	}
-	return (1);
+	return 1;
 }
 
 static void
@@ -675,22 +668,23 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 
 	irsp = &rspiocb->iocb;
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
-	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_PLOGI_SND;
-	spin_unlock_irq(phba->host->host_lock);
 
 	/* Since ndlp can be freed in the disc state machine, note if this node
 	 * is being used during discovery.
 	 */
 	disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
+	spin_lock_irq(phba->host->host_lock);
+	ndlp->nlp_flag &= ~(NLP_PLOGI_SND | NLP_NPR_2B_DISC);
+	spin_unlock_irq(phba->host->host_lock);
 	rc   = 0;
 
 	/* PLOGI completes to NPort <nlp_DID> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"%d:0102 PLOGI completes to NPort x%x "
-			"Data: x%x x%x x%x x%x\n",
+			"Data: x%x x%x x%x x%x x%x\n",
 			phba->brd_no, ndlp->nlp_DID, irsp->ulpStatus,
-			irsp->un.ulpWord[4], disc, phba->num_disc_nodes);
+			irsp->un.ulpWord[4], irsp->ulpTimeout, disc,
+			phba->num_disc_nodes);
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(phba)) {
@@ -722,7 +716,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 		   ((irsp->un.ulpWord[4] == IOERR_SLI_ABORTED) ||
 		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
-			disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
+			rc = NLP_STE_FREED_NODE;
 		}
 		else {
 			rc = lpfc_disc_state_machine(phba, ndlp, cmdiocb,
@@ -747,18 +741,11 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 		lpfc_more_plogi(phba);
 	}
 
-	if (rc != NLP_STE_FREED_NODE) {
+	if (phba->num_disc_nodes == 0) {
 		spin_lock_irq(phba->host->host_lock);
-		ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+		phba->fc_flag &= ~FC_NDISC_ACTIVE;
 		spin_unlock_irq(phba->host->host_lock);
-	}
 
-	if (phba->num_disc_nodes == 0) {
-		if(disc) {
-			spin_lock_irq(phba->host->host_lock);
-			phba->fc_flag &= ~FC_NDISC_ACTIVE;
-			spin_unlock_irq(phba->host->host_lock);
-		}
 		lpfc_can_disctmo(phba);
 		if (phba->fc_flag & FC_RSCN_MODE) {
 			/* Check to see if more RSCNs came in while we were
@@ -796,10 +783,10 @@ lpfc_issue_els_plogi(struct lpfc_hba * p
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = (sizeof (uint32_t) + sizeof (struct serv_parm));
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
-					  ndlp, ELS_CMD_PLOGI)) == 0) {
-		return (1);
-	}
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
+							ELS_CMD_PLOGI);
+	if (!elsiocb)
+		return 1;
 
 	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
@@ -824,10 +811,10 @@ lpfc_issue_els_plogi(struct lpfc_hba * p
 		ndlp->nlp_flag &= ~NLP_PLOGI_SND;
 		spin_unlock_irq(phba->host->host_lock);
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
 	spin_unlock_irq(phba->host->host_lock);
-	return (0);
+	return 0;
 }
 
 static void
@@ -851,9 +838,10 @@ lpfc_cmpl_els_prli(struct lpfc_hba * phb
 	/* PRLI completes to NPort <nlp_DID> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"%d:0103 PRLI completes to NPort x%x "
-			"Data: x%x x%x x%x\n",
+			"Data: x%x x%x x%x x%x\n",
 			phba->brd_no, ndlp->nlp_DID, irsp->ulpStatus,
-			irsp->un.ulpWord[4], phba->num_disc_nodes);
+			irsp->un.ulpWord[4], irsp->ulpTimeout,
+			phba->num_disc_nodes);
 
 	phba->fc_prli_sent--;
 	/* Check to see if link went down during discovery */
@@ -906,7 +894,7 @@ lpfc_issue_els_prli(struct lpfc_hba * ph
 	cmdsize = (sizeof (uint32_t) + sizeof (PRLI));
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
 					  ndlp, ELS_CMD_PRLI)) == 0) {
-		return (1);
+		return 1;
 	}
 
 	icmd = &elsiocb->iocb;
@@ -943,11 +931,11 @@ lpfc_issue_els_prli(struct lpfc_hba * ph
 		ndlp->nlp_flag &= ~NLP_PRLI_SND;
 		spin_unlock_irq(phba->host->host_lock);
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
 	spin_unlock_irq(phba->host->host_lock);
 	phba->fc_prli_sent++;
-	return (0);
+	return 0;
 }
 
 static void
@@ -1016,21 +1004,22 @@ lpfc_cmpl_els_adisc(struct lpfc_hba * ph
 
 	irsp = &(rspiocb->iocb);
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
-	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_ADISC_SND;
-	spin_unlock_irq(phba->host->host_lock);
 
 	/* Since ndlp can be freed in the disc state machine, note if this node
 	 * is being used during discovery.
 	 */
 	disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
+	spin_lock_irq(phba->host->host_lock);
+	ndlp->nlp_flag &= ~(NLP_ADISC_SND | NLP_NPR_2B_DISC);
+	spin_unlock_irq(phba->host->host_lock);
 
 	/* ADISC completes to NPort <nlp_DID> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"%d:0104 ADISC completes to NPort x%x "
-			"Data: x%x x%x x%x x%x\n",
+			"Data: x%x x%x x%x x%x x%x\n",
 			phba->brd_no, ndlp->nlp_DID, irsp->ulpStatus,
-			irsp->un.ulpWord[4], disc, phba->num_disc_nodes);
+			irsp->un.ulpWord[4], irsp->ulpTimeout, disc,
+			phba->num_disc_nodes);
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(phba)) {
@@ -1054,13 +1043,10 @@ lpfc_cmpl_els_adisc(struct lpfc_hba * ph
 		}
 		/* ADISC failed */
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-		   ((irsp->un.ulpWord[4] == IOERR_SLI_ABORTED) ||
-		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
-		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
-			disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
-		}
-		else {
+		if ((irsp->ulpStatus != IOSTAT_LOCAL_REJECT) ||
+		   ((irsp->un.ulpWord[4] != IOERR_SLI_ABORTED) &&
+		   (irsp->un.ulpWord[4] != IOERR_LINK_DOWN) &&
+		   (irsp->un.ulpWord[4] != IOERR_SLI_DOWN))) {
 			lpfc_disc_state_machine(phba, ndlp, cmdiocb,
 					NLP_EVT_CMPL_ADISC);
 		}
@@ -1112,9 +1098,6 @@ lpfc_cmpl_els_adisc(struct lpfc_hba * ph
 			}
 		}
 	}
-	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-	spin_unlock_irq(phba->host->host_lock);
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 	return;
@@ -1138,7 +1121,7 @@ lpfc_issue_els_adisc(struct lpfc_hba * p
 	cmdsize = (sizeof (uint32_t) + sizeof (ADISC));
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
 					  ndlp, ELS_CMD_ADISC)) == 0) {
-		return (1);
+		return 1;
 	}
 
 	icmd = &elsiocb->iocb;
@@ -1163,10 +1146,10 @@ lpfc_issue_els_adisc(struct lpfc_hba * p
 		ndlp->nlp_flag &= ~NLP_ADISC_SND;
 		spin_unlock_irq(phba->host->host_lock);
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
 	spin_unlock_irq(phba->host->host_lock);
-	return (0);
+	return 0;
 }
 
 static void
@@ -1190,9 +1173,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba * phb
 	/* LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"%d:0105 LOGO completes to NPort x%x "
-			"Data: x%x x%x x%x\n",
+			"Data: x%x x%x x%x x%x\n",
 			phba->brd_no, ndlp->nlp_DID, irsp->ulpStatus,
-			irsp->un.ulpWord[4], phba->num_disc_nodes);
+			irsp->un.ulpWord[4], irsp->ulpTimeout,
+			phba->num_disc_nodes);
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(phba))
@@ -1247,7 +1231,7 @@ lpfc_issue_els_logo(struct lpfc_hba * ph
 	cmdsize = 2 * (sizeof (uint32_t) + sizeof (struct lpfc_name));
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
 					  ndlp, ELS_CMD_LOGO)) == 0) {
-		return (1);
+		return 1;
 	}
 
 	icmd = &elsiocb->iocb;
@@ -1268,10 +1252,10 @@ lpfc_issue_els_logo(struct lpfc_hba * ph
 		ndlp->nlp_flag &= ~NLP_LOGO_SND;
 		spin_unlock_irq(phba->host->host_lock);
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
 	spin_unlock_irq(phba->host->host_lock);
-	return (0);
+	return 0;
 }
 
 static void
@@ -1286,9 +1270,10 @@ lpfc_cmpl_els_cmd(struct lpfc_hba * phba
 	lpfc_printf_log(phba,
 			KERN_INFO,
 			LOG_ELS,
-			"%d:0106 ELS cmd tag x%x completes Data: x%x x%x\n",
+			"%d:0106 ELS cmd tag x%x completes Data: x%x x%x x%x\n",
 			phba->brd_no,
-			irsp->ulpIoTag, irsp->ulpStatus, irsp->un.ulpWord[4]);
+			irsp->ulpIoTag, irsp->ulpStatus,
+			irsp->un.ulpWord[4], irsp->ulpTimeout);
 
 	/* Check to see if link went down during discovery */
 	lpfc_els_chk_latt(phba);
@@ -1310,16 +1295,16 @@ lpfc_issue_els_scr(struct lpfc_hba * phb
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 	cmdsize = (sizeof (uint32_t) + sizeof (SCR));
-	if ((ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL)) == 0) {
-		return (1);
-	}
+	ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+	if (!ndlp)
+		return 1;
 
 	lpfc_nlp_init(phba, ndlp, nportid);
 
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
 					  ndlp, ELS_CMD_SCR)) == 0) {
 		mempool_free( ndlp, phba->nlp_mem_pool);
-		return (1);
+		return 1;
 	}
 
 	icmd = &elsiocb->iocb;
@@ -1339,11 +1324,11 @@ lpfc_issue_els_scr(struct lpfc_hba * phb
 		spin_unlock_irq(phba->host->host_lock);
 		mempool_free( ndlp, phba->nlp_mem_pool);
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
 	spin_unlock_irq(phba->host->host_lock);
 	mempool_free( ndlp, phba->nlp_mem_pool);
-	return (0);
+	return 0;
 }
 
 static int
@@ -1363,15 +1348,15 @@ lpfc_issue_els_farpr(struct lpfc_hba * p
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 	cmdsize = (sizeof (uint32_t) + sizeof (FARP));
-	if ((ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL)) == 0) {
-		return (1);
-	}
+	ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+	if (!ndlp)
+		return 1;
 	lpfc_nlp_init(phba, ndlp, nportid);
 
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry,
 					  ndlp, ELS_CMD_RNID)) == 0) {
 		mempool_free( ndlp, phba->nlp_mem_pool);
-		return (1);
+		return 1;
 	}
 
 	icmd = &elsiocb->iocb;
@@ -1405,11 +1390,11 @@ lpfc_issue_els_farpr(struct lpfc_hba * p
 		spin_unlock_irq(phba->host->host_lock);
 		mempool_free( ndlp, phba->nlp_mem_pool);
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
 	spin_unlock_irq(phba->host->host_lock);
 	mempool_free( ndlp, phba->nlp_mem_pool);
-	return (0);
+	return 0;
 }
 
 void
@@ -1541,11 +1526,6 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 
 		case IOERR_SEQUENCE_TIMEOUT:
 			retry = 1;
-			if ((cmd == ELS_CMD_FLOGI)
-			    && (phba->fc_topology != TOPOLOGY_LOOP)) {
-				delay = 1;
-				maxretry = 48;
-			}
 			break;
 
 		case IOERR_NO_RESOURCES:
@@ -1654,32 +1634,32 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 			ndlp->nlp_last_elscmd = cmd;
 
-			return (1);
+			return 1;
 		}
 		switch (cmd) {
 		case ELS_CMD_FLOGI:
 			lpfc_issue_els_flogi(phba, ndlp, cmdiocb->retry);
-			return (1);
+			return 1;
 		case ELS_CMD_PLOGI:
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 			lpfc_issue_els_plogi(phba, ndlp, cmdiocb->retry);
-			return (1);
+			return 1;
 		case ELS_CMD_ADISC:
 			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
 			lpfc_issue_els_adisc(phba, ndlp, cmdiocb->retry);
-			return (1);
+			return 1;
 		case ELS_CMD_PRLI:
 			ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
 			lpfc_issue_els_prli(phba, ndlp, cmdiocb->retry);
-			return (1);
+			return 1;
 		case ELS_CMD_LOGO:
 			ndlp->nlp_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 			lpfc_issue_els_logo(phba, ndlp, cmdiocb->retry);
-			return (1);
+			return 1;
 		}
 	}
 
@@ -1690,7 +1670,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 			phba->brd_no,
 			cmd, ndlp->nlp_DID, cmdiocb->retry, ndlp->nlp_flag);
 
-	return (0);
+	return 0;
 }
 
 int
@@ -1780,11 +1760,12 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 	/* ELS response tag <ulpIoTag> completes */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"%d:0110 ELS response tag x%x completes "
-			"Data: x%x x%x x%x x%x x%x x%x\n",
+			"Data: x%x x%x x%x x%x x%x x%x x%x\n",
 			phba->brd_no,
 			cmdiocb->iocb.ulpIoTag, rspiocb->iocb.ulpStatus,
-			rspiocb->iocb.un.ulpWord[4], ndlp->nlp_DID,
-			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
+			rspiocb->iocb.un.ulpWord[4], rspiocb->iocb.ulpTimeout,
+ 			ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
+			ndlp->nlp_rpi);
 
 	if (mbox) {
 		if ((rspiocb->iocb.ulpStatus == 0)
@@ -1846,7 +1827,7 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 		if ((elsiocb =
 		     lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
 					ndlp, ELS_CMD_ACC)) == 0) {
-			return (1);
+			return 1;
 		}
 		icmd = &elsiocb->iocb;
 		icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
@@ -1859,7 +1840,7 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 		if ((elsiocb =
 		     lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
 					ndlp, ELS_CMD_ACC)) == 0) {
-			return (1);
+			return 1;
 		}
 		icmd = &elsiocb->iocb;
 		icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
@@ -1873,7 +1854,7 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 		memcpy(pcmd, &phba->fc_sparam, sizeof (struct serv_parm));
 		break;
 	default:
-		return (1);
+		return 1;
 	}
 
 	if (newnode)
@@ -1889,6 +1870,9 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 
 	if (ndlp->nlp_flag & NLP_LOGO_ACC) {
+		spin_lock_irq(phba->host->host_lock);
+		ndlp->nlp_flag &= ~NLP_LOGO_ACC;
+		spin_unlock_irq(phba->host->host_lock);
 		elsiocb->iocb_cmpl = lpfc_cmpl_els_logo_acc;
 	} else {
 		elsiocb->iocb_cmpl = lpfc_cmpl_els_acc;
@@ -1900,9 +1884,9 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 	spin_unlock_irq(phba->host->host_lock);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
-	return (0);
+	return 0;
 }
 
 int
@@ -1924,7 +1908,7 @@ lpfc_els_rsp_reject(struct lpfc_hba * ph
 	cmdsize = 2 * sizeof (uint32_t);
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
 					  ndlp, ELS_CMD_LS_RJT)) == 0) {
-		return (1);
+		return 1;
 	}
 
 	icmd = &elsiocb->iocb;
@@ -1952,9 +1936,9 @@ lpfc_els_rsp_reject(struct lpfc_hba * ph
 	spin_unlock_irq(phba->host->host_lock);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
-	return (0);
+	return 0;
 }
 
 int
@@ -1977,7 +1961,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_hba *
 	cmdsize = sizeof (uint32_t) + sizeof (ADISC);
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
 					  ndlp, ELS_CMD_ACC)) == 0) {
-		return (1);
+		return 1;
 	}
 
 	/* Xmit ADISC ACC response tag <ulpIoTag> */
@@ -2010,9 +1994,9 @@ lpfc_els_rsp_adisc_acc(struct lpfc_hba *
 	spin_unlock_irq(phba->host->host_lock);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
-	return (0);
+	return 0;
 }
 
 int
@@ -2034,13 +2018,10 @@ lpfc_els_rsp_prli_acc(struct lpfc_hba * 
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = sizeof (uint32_t) + sizeof (PRLI);
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
-					  ndlp,
-					  (ELS_CMD_ACC |
-					   (ELS_CMD_PRLI & ~ELS_RSP_MASK)))) ==
-	    0) {
-		return (1);
-	}
+	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry, ndlp,
+				(ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK)));
+	if (!elsiocb)
+		return 1;
 
 	/* Xmit PRLI ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
@@ -2090,9 +2071,9 @@ lpfc_els_rsp_prli_acc(struct lpfc_hba * 
 	spin_unlock_irq(phba->host->host_lock);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
-	return (0);
+	return 0;
 }
 
 static int
@@ -2120,7 +2101,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_hba * 
 
 	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
 					  ndlp, ELS_CMD_ACC)) == 0) {
-		return (1);
+		return 1;
 	}
 
 	/* Xmit RNID ACC response tag <ulpIoTag> */
@@ -2173,9 +2154,9 @@ lpfc_els_rsp_rnid_acc(struct lpfc_hba * 
 	spin_unlock_irq(phba->host->host_lock);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return (1);
+		return 1;
 	}
-	return (0);
+	return 0;
 }
 
 int
@@ -2268,7 +2249,7 @@ lpfc_els_flush_rscn(struct lpfc_hba * ph
 	phba->fc_flag &= ~(FC_RSCN_MODE | FC_RSCN_DISCOVERY);
 	spin_unlock_irq(phba->host->host_lock);
 	lpfc_can_disctmo(phba);
-	return (0);
+	return 0;
 }
 
 int
@@ -2289,7 +2270,7 @@ lpfc_rscn_payload_check(struct lpfc_hba 
 
 	/* If we are doing a FULL RSCN rediscovery, match everything */
 	if (phba->fc_flag & FC_RSCN_DISCOVERY) {
-		return (did);
+		return did;
 	}
 
 	for (i = 0; i < phba->fc_rscn_id_cnt; i++) {
@@ -2337,7 +2318,7 @@ lpfc_rscn_payload_check(struct lpfc_hba 
 			}
 		}
 	}
-	return (match);
+	return match;
 }
 
 static int
@@ -2379,7 +2360,7 @@ lpfc_rscn_recovery_check(struct lpfc_hba
 			}
 		}
 	}
-	return (0);
+	return 0;
 }
 
 static int
@@ -2415,7 +2396,7 @@ lpfc_els_rcv_rscn(struct lpfc_hba * phba
 	if (phba->hba_state < LPFC_NS_QRY) {
 		lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL,
 								newnode);
-		return (0);
+		return 0;
 	}
 
 	/* If we are already processing an RSCN, save the received
@@ -2457,7 +2438,7 @@ lpfc_els_rcv_rscn(struct lpfc_hba * phba
 
 		/* send RECOVERY event for ALL nodes that match RSCN payload */
 		lpfc_rscn_recovery_check(phba);
-		return (0);
+		return 0;
 	}
 
 	phba->fc_flag |= FC_RSCN_MODE;
@@ -2476,7 +2457,7 @@ lpfc_els_rcv_rscn(struct lpfc_hba * phba
 	/* send RECOVERY event for ALL nodes that match RSCN payload */
 	lpfc_rscn_recovery_check(phba);
 
-	return (lpfc_els_handle_rscn(phba));
+	return lpfc_els_handle_rscn(phba);
 }
 
 int
@@ -2498,27 +2479,27 @@ lpfc_els_handle_rscn(struct lpfc_hba * p
 
 	/* To process RSCN, first compare RSCN data with NameServer */
 	phba->fc_ns_retry = 0;
-	if ((ndlp = lpfc_findnode_did(phba, NLP_SEARCH_UNMAPPED,
-				      NameServer_DID))) {
+	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_UNMAPPED, NameServer_DID);
+	if (ndlp) {
 		/* Good ndlp, issue CT Request to NameServer */
 		if (lpfc_ns_cmd(phba, ndlp, SLI_CTNS_GID_FT) == 0) {
 			/* Wait for NameServer query cmpl before we can
 			   continue */
-			return (1);
+			return 1;
 		}
 	} else {
 		/* If login to NameServer does not exist, issue one */
 		/* Good status, issue PLOGI to NameServer */
-		if ((ndlp =
-		     lpfc_findnode_did(phba, NLP_SEARCH_ALL, NameServer_DID))) {
+		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, NameServer_DID);
+		if (ndlp) {
 			/* Wait for NameServer login cmpl before we can
 			   continue */
-			return (1);
+			return 1;
 		}
-		if ((ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL))
-		    == 0) {
+		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		if (!ndlp) {
 			lpfc_els_flush_rscn(phba);
-			return (0);
+			return 0;
 		} else {
 			lpfc_nlp_init(phba, ndlp, NameServer_DID);
 			ndlp->nlp_type |= NLP_FABRIC;
@@ -2526,12 +2507,12 @@ lpfc_els_handle_rscn(struct lpfc_hba * p
 			lpfc_issue_els_plogi(phba, ndlp, 0);
 			/* Wait for NameServer login cmpl before we can
 			   continue */
-			return (1);
+			return 1;
 		}
 	}
 
 	lpfc_els_flush_rscn(phba);
-	return (0);
+	return 0;
 }
 
 static int
@@ -2565,7 +2546,7 @@ lpfc_els_rcv_flogi(struct lpfc_hba * phb
 				"%d:0113 An FLOGI ELS command x%x was received "
 				"from DID x%x in Loop Mode\n",
 				phba->brd_no, cmd, did);
-		return (1);
+		return 1;
 	}
 
 	did = Fabric_DID;
@@ -2581,7 +2562,7 @@ lpfc_els_rcv_flogi(struct lpfc_hba * phb
 		if (!rc) {
 			if ((mbox = mempool_alloc(phba->mbox_mem_pool,
 						  GFP_KERNEL)) == 0) {
-				return (1);
+				return 1;
 			}
 			lpfc_linkdown(phba);
 			lpfc_init_link(phba, mbox,
@@ -2594,7 +2575,7 @@ lpfc_els_rcv_flogi(struct lpfc_hba * phb
 			if (rc == MBX_NOT_FINISHED) {
 				mempool_free( mbox, phba->mbox_mem_pool);
 			}
-			return (1);
+			return 1;
 		}
 		else if (rc > 0) {	/* greater than */
 			spin_lock_irq(phba->host->host_lock);
@@ -2610,13 +2591,13 @@ lpfc_els_rcv_flogi(struct lpfc_hba * phb
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_SPARM_OPTIONS;
 		stat.un.b.vendorUnique = 0;
 		lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
-		return (1);
+		return 1;
 	}
 
 	/* Send back ACC */
 	lpfc_els_rsp_acc(phba, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL, newnode);
 
-	return (0);
+	return 0;
 }
 
 static int
@@ -2654,7 +2635,7 @@ lpfc_els_rcv_rnid(struct lpfc_hba * phba
 		stat.un.b.vendorUnique = 0;
 		lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
 	}
-	return (0);
+	return 0;
 }
 
 static int
@@ -2702,10 +2683,10 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba * p
 
 	cmdsize = sizeof(RPS_RSP) + sizeof(uint32_t);
 	mempool_free( pmb, phba->mbox_mem_pool);
-	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, 3,
-					  ndlp, ELS_CMD_ACC)) == 0) {
+	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, lpfc_max_els_tries,
+					  		ndlp, ELS_CMD_ACC);
+	if (!elsiocb)
 		return;
-	}
 
 	icmd = &elsiocb->iocb;
 	icmd->ulpContext = xri;
@@ -2926,7 +2907,7 @@ lpfc_els_rcv_farp(struct lpfc_hba * phba
 
 	/* We will only support match on WWPN or WWNN */
 	if (fp->Mflags & ~(FARP_MATCH_NODE | FARP_MATCH_PORT)) {
-		return (0);
+		return 0;
 	}
 
 	cnt = 0;
@@ -2960,7 +2941,7 @@ lpfc_els_rcv_farp(struct lpfc_hba * phba
 			}
 		}
 	}
-	return (0);
+	return 0;
 }
 
 static int
@@ -3026,14 +3007,14 @@ lpfc_els_rcv_fan(struct lpfc_hba * phba,
 			/* This node has switched fabrics.  An FLOGI is required
 			 * after the timeout
 			 */
-			return (0);
+			return 0;
 		}
 
 		/* Start discovery */
 		lpfc_disc_start(phba);
 	}
 
-	return (0);
+	return 0;
 }
 
 void
@@ -3156,7 +3137,6 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 	struct lpfc_dmabuf *pcmd;
 	uint32_t *elscmd;
 	uint32_t els_command;
-	uint32_t remote_ID;
 
 	pring = &phba->sli.ring[LPFC_ELS_RING];
 	spin_lock_irq(phba->host->host_lock);
@@ -3179,18 +3159,6 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 		elscmd = (uint32_t *) (pcmd->virt);
 		els_command = *elscmd;
 
-		if (cmd->ulpCommand == CMD_GEN_REQUEST64_CR) {
-			struct lpfc_nodelist *ndlp;
-
-			ndlp = lpfc_findnode_rpi(phba, cmd->ulpContext);
-			remote_ID = ndlp->nlp_DID;
-			if (phba->hba_state == LPFC_HBA_READY) {
-				continue;
-			}
-		} else {
-			remote_ID = cmd->un.elsreq64.remoteID;
-		}
-
 		list_del(&piocb->list);
 		pring->txcmplq_cnt--;
 
@@ -3216,18 +3184,6 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 		elscmd = (uint32_t *) (pcmd->virt);
 		els_command = *elscmd;
 
-		if (cmd->ulpCommand == CMD_GEN_REQUEST64_CR) {
-			struct lpfc_nodelist *ndlp;
-
-			ndlp = lpfc_findnode_rpi(phba, cmd->ulpContext);
-			remote_ID = ndlp->nlp_DID;
-			if (phba->hba_state == LPFC_HBA_READY) {
-				continue;
-			}
-		} else {
-			remote_ID = cmd->un.elsreq64.remoteID;
-		}
-
 		list_del(&piocb->list);
 		pring->txcmplq_cnt--;
 
@@ -3311,10 +3267,11 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	}
 
 	did = icmd->un.rcvels.remoteID;
-	if ((ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, did)) == 0) {
+	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, did);
+	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
-		if ((ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL))
-		    == 0) {
+		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		if (!ndlp) {
 			lpfc_mbuf_free(phba, mp->virt, mp->phys);
 			kfree(mp);
 			drop_cmd = 1;
@@ -3475,8 +3432,9 @@ dropit:
 	if (drop_cmd == 1) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
 				"%d:0111 Dropping received ELS cmd "
-				"Data: x%x x%x\n", phba->brd_no,
-				icmd->ulpStatus, icmd->un.ulpWord[4]);
+				"Data: x%x x%x x%x\n", phba->brd_no,
+				icmd->ulpStatus, icmd->un.ulpWord[4],
+				icmd->ulpTimeout);
 		phba->fc_stat.elsRcvDrop++;
 	}
 	return;
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -247,6 +247,7 @@ struct lpfc_hba {
 #define FC_SCSI_SCAN_TMO        0x4000	/* scsi scan timer running */
 #define FC_ABORT_DISCOVERY      0x8000	/* we want to abort discovery */
 #define FC_NDISC_ACTIVE         0x10000	/* NPort discovery active */
+#define FC_BYPASSED_MODE        0x20000	/* NPort is in bypassed mode */
 
 	uint32_t fc_topology;	/* link topology, from LINK INIT */
 
