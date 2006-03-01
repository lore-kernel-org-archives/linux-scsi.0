From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 16/22] lpfc 8.1.2: Code style changes for Discovery code
Date: Tue, 28 Feb 2006 19:25:31 -0500
Message-ID: <20060301002531.GA15533@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:48550 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964864AbWCAAZd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:33 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PVrK015539
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:31 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PVIA015538
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Code style changes for Discovery code

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -108,7 +108,7 @@ lpfc_work_list_done(struct lpfc_hba * ph
 				 evt_listp);
 		spin_unlock_irq(phba->host->host_lock);
 		free_evt = 1;
-		switch(evtp->evt) {
+		switch (evtp->evt) {
 		case LPFC_EVT_NODEV_TMO:
 			ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
 			lpfc_process_nodev_timeout(phba, ndlp);
@@ -173,13 +173,13 @@ lpfc_work_done(struct lpfc_hba * phba)
 	work_hba_events=phba->work_hba_events;
 	spin_unlock_irq(phba->host->host_lock);
 
-	if(ha_copy & HA_ERATT)
+	if (ha_copy & HA_ERATT)
 		lpfc_handle_eratt(phba);
 
-	if(ha_copy & HA_MBATT)
+	if (ha_copy & HA_MBATT)
 		lpfc_sli_handle_mb_event(phba);
 
-	if(ha_copy & HA_LATT)
+	if (ha_copy & HA_LATT)
 		lpfc_handle_latt(phba);
 
 	if (work_hba_events & WORKER_DISC_TMO)
@@ -357,8 +357,7 @@ lpfc_linkdown(struct lpfc_hba * phba)
 			/* Check config parameter use-adisc or FCP-2 */
 			if ((rc != NLP_STE_FREED_NODE) &&
 				(phba->cfg_use_adisc == 0) &&
-				!(ndlp->nlp_fcp_info &
-					NLP_FCP_2_DEVICE)) {
+				!(ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE)) {
 				/* We know we will have to relogin, so
 				 * unreglogin the rpi right now to fail
 				 * any outstanding I/Os quickly.
@@ -398,7 +397,7 @@ lpfc_linkdown(struct lpfc_hba * phba)
 	lpfc_can_disctmo(phba);
 
 	/* Must process IOCBs on all rings to handle ABORTed I/Os */
-	return (0);
+	return 0;
 }
 
 static int
@@ -497,7 +496,7 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *
 		lpfc_els_disc_plogi(phba);
 	}
 
-	if(!phba->num_disc_nodes) {
+	if (!phba->num_disc_nodes) {
 		spin_lock_irq(phba->host->host_lock);
 		phba->fc_flag &= ~FC_NDISC_ACTIVE;
 		spin_unlock_irq(phba->host->host_lock);
@@ -685,7 +684,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 
 	spin_lock_irq(phba->host->host_lock);
-	switch(la->UlnkSpeed) {
+	switch (la->UlnkSpeed) {
 		case LA_1GHZ_LINK:
 			phba->fc_linkspeed = LA_1GHZ_LINK;
 			break;
@@ -1115,12 +1114,11 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 
 	psli = &phba->sli;
 	/* Sanity check to ensure we are not moving to / from the same list */
-	if ((nlp->nlp_flag & NLP_LIST_MASK) == list) {
+	if ((nlp->nlp_flag & NLP_LIST_MASK) == list)
 		if (list != NLP_NO_LIST)
-			return(0);
-	}
+			return 0;
 
-	switch(nlp->nlp_flag & NLP_LIST_MASK) {
+	switch (nlp->nlp_flag & NLP_LIST_MASK) {
 	case NLP_NO_LIST: /* Not on any list */
 		break;
 	case NLP_UNUSED_LIST:
@@ -1190,7 +1188,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			phba->brd_no,
 			nlp->nlp_DID, list, nlp->nlp_flag);
 
-	switch(list) {
+	switch (list) {
 	case NLP_NO_LIST: /* No list, just remove it */
 		lpfc_nlp_remove(phba, nlp);
 		/* as node removed - stop further transport calls */
@@ -1287,10 +1285,10 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		list_add_tail(&nlp->nlp_listp, &phba->fc_npr_list);
 		phba->fc_npr_cnt++;
 
-		if (!(nlp->nlp_flag & NLP_NODEV_TMO)) {
+		if (!(nlp->nlp_flag & NLP_NODEV_TMO))
 			mod_timer(&nlp->nlp_tmofunc,
 		 			jiffies + HZ * phba->cfg_nodev_tmo);
-		}
+
 		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= NLP_NODEV_TMO;
 		nlp->nlp_flag &= ~NLP_RCV_PLOGI;
@@ -1342,7 +1340,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			}
 		}
 	}
-	return (0);
+	return 0;
 }
 
 /*
@@ -1401,7 +1399,7 @@ lpfc_can_disctmo(struct lpfc_hba * phba)
 			phba->brd_no, phba->hba_state, phba->fc_flag,
 			phba->fc_plogi_cnt, phba->fc_adisc_cnt);
 
-	return (0);
+	return 0;
 }
 
 /*
@@ -1422,11 +1420,11 @@ lpfc_check_sli_ndlp(struct lpfc_hba * ph
 		switch (icmd->ulpCommand) {
 		case CMD_GEN_REQUEST64_CR:
 			if (icmd->ulpContext == (volatile ushort)ndlp->nlp_rpi)
-				return (1);
+				return 1;
 		case CMD_ELS_REQUEST64_CR:
 		case CMD_XMIT_ELS_RSP64_CX:
 			if (iocb->context1 == (uint8_t *) ndlp)
-				return (1);
+				return 1;
 		}
 	} else if (pring->ringno == psli->ip_ring) {
 
@@ -1434,15 +1432,15 @@ lpfc_check_sli_ndlp(struct lpfc_hba * ph
 		/* Skip match check if waiting to relogin to FCP target */
 		if ((ndlp->nlp_type & NLP_FCP_TARGET) &&
 		  (ndlp->nlp_flag & NLP_DELAY_TMO)) {
-			return (0);
+			return 0;
 		}
 		if (icmd->ulpContext == (volatile ushort)ndlp->nlp_rpi) {
-			return (1);
+			return 1;
 		}
 	} else if (pring->ringno == psli->next_ring) {
 
 	}
-	return (0);
+	return 0;
 }
 
 /*
@@ -1503,7 +1501,7 @@ lpfc_no_rpi(struct lpfc_hba * phba, stru
 
 		}
 	}
-	return (0);
+	return 0;
 }
 
 /*
@@ -1604,7 +1602,7 @@ lpfc_freenode(struct lpfc_hba * phba, st
 
 	lpfc_unreg_rpi(phba, ndlp);
 
-	return (0);
+	return 0;
 }
 
 /*
@@ -1640,12 +1638,11 @@ lpfc_nlp_remove(struct lpfc_hba * phba, 
 		spin_lock_irq(phba->host->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_REMOVE;
 		spin_unlock_irq(phba->host->host_lock);
-	}
-	else {
+	} else {
 		lpfc_freenode(phba, ndlp);
 		mempool_free( ndlp, phba->nlp_mem_pool);
 	}
-	return(0);
+	return 0;
 }
 
 static int
@@ -1656,20 +1653,20 @@ lpfc_matchdid(struct lpfc_hba * phba, st
 	D_ID matchdid;
 
 	if (did == Bcast_DID)
-		return (0);
+		return 0;
 
 	if (ndlp->nlp_DID == 0) {
-		return (0);
+		return 0;
 	}
 
 	/* First check for Direct match */
 	if (ndlp->nlp_DID == did)
-		return (1);
+		return 1;
 
 	/* Next check for area/domain identically equals 0 match */
 	mydid.un.word = phba->fc_myDID;
 	if ((mydid.un.b.domain == 0) && (mydid.un.b.area == 0)) {
-		return (0);
+		return 0;
 	}
 
 	matchdid.un.word = did;
@@ -1680,9 +1677,9 @@ lpfc_matchdid(struct lpfc_hba * phba, st
 			if ((ndlpdid.un.b.domain == 0) &&
 			    (ndlpdid.un.b.area == 0)) {
 				if (ndlpdid.un.b.id)
-					return (1);
+					return 1;
 			}
-			return (0);
+			return 0;
 		}
 
 		matchdid.un.word = ndlp->nlp_DID;
@@ -1691,11 +1688,11 @@ lpfc_matchdid(struct lpfc_hba * phba, st
 			if ((matchdid.un.b.domain == 0) &&
 			    (matchdid.un.b.area == 0)) {
 				if (matchdid.un.b.id)
-					return (1);
+					return 1;
 			}
 		}
 	}
-	return (0);
+	return 0;
 }
 
 /* Search for a nodelist entry on a specific list */
@@ -1720,7 +1717,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
-				return (ndlp);
+				return ndlp;
 			}
 		}
 	}
@@ -1741,7 +1738,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
-				return (ndlp);
+				return ndlp;
 			}
 		}
 	}
@@ -1763,7 +1760,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
-				return (ndlp);
+				return ndlp;
 			}
 		}
 	}
@@ -1785,7 +1782,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
-				return (ndlp);
+				return ndlp;
 			}
 		}
 	}
@@ -1807,7 +1804,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
-				return (ndlp);
+				return ndlp;
 			}
 		}
 	}
@@ -1829,7 +1826,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
-				return (ndlp);
+				return ndlp;
 			}
 		}
 	}
@@ -1851,7 +1848,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
-				return (ndlp);
+				return ndlp;
 			}
 		}
 	}
@@ -1873,7 +1870,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
-				return (ndlp);
+				return ndlp;
 			}
 		}
 	}
@@ -1923,17 +1920,15 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 				del_timer_sync(&ndlp->nlp_delayfunc);
 				spin_lock_irq(phba->host->host_lock);
 				if (!list_empty(&ndlp->els_retry_evt.
-						evt_listp))
+								evt_listp))
 					list_del_init(&ndlp->els_retry_evt.
-				      		evt_listp);
+						      		evt_listp);
 			}
-		}
-		else {
+		} else {
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 			ndlp = NULL;
 		}
-	}
-	else {
+	} else {
 		flg = ndlp->nlp_flag & NLP_LIST_MASK;
 		if ((flg == NLP_ADISC_LIST) || (flg == NLP_PLOGI_LIST))
 			return NULL;
@@ -2084,8 +2079,7 @@ lpfc_disc_start(struct lpfc_hba * phba)
 				spin_lock_irq(phba->host->host_lock);
 				phba->fc_flag &= ~FC_RSCN_MODE;
 				spin_unlock_irq(phba->host->host_lock);
-			}
-			else
+			} else
 				lpfc_els_handle_rscn(phba);
 		}
 	}
@@ -2268,8 +2262,7 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 			if (ndlp->nlp_type & NLP_FABRIC) {
 				/* Clean up the ndlp on Fabric connections */
 				lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-			}
-			else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
+			} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 				/* Fail outstanding IO now since device
 				 * is marked for PLOGI.
 				 */
@@ -2544,7 +2537,7 @@ lpfc_findnode_rpi(struct lpfc_hba * phba
 	for (i = 0; i < ARRAY_SIZE(lists); i++ )
 		list_for_each_entry(ndlp, lists[i], nlp_listp)
 			if (ndlp->nlp_rpi == rpi)
-				return (ndlp);
+				return ndlp;
 
 	return NULL;
 }
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -150,8 +150,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba 
 			lp = (uint32_t *) prsp->virt;
 			ptr = (void *)((uint8_t *)lp + sizeof(uint32_t));
 		}
-	}
-	else {
+	} else {
 		/* Force ulpStatus error since we are returning NULL ptr */
 		if (!(irsp->ulpStatus)) {
 			irsp->ulpStatus = IOSTAT_LOCAL_REJECT;
@@ -301,12 +300,10 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 				/* Start discovery - this should just do
 				   CLEAR_LA */
 				lpfc_disc_start(phba);
-			}
-			else {
+			} else {
 				lpfc_initial_flogi(phba);
 			}
-		}
-		else {
+		} else {
 			stat.un.b.lsRjtRsnCode = LSRJT_LOGICAL_BSY;
 			stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 			lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb,
@@ -354,7 +351,7 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 		((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) | sp->cmn.bbRcvSizeLsb;
 
 	/* no need to reg_login if we are already in one of these states */
-	switch(ndlp->nlp_state) {
+	switch (ndlp->nlp_state) {
 	case  NLP_STE_NPR_NODE:
 		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
 			break;
@@ -444,8 +441,7 @@ lpfc_rcv_padisc(struct lpfc_hba * phba,
 	    (lpfc_check_adisc(phba, ndlp, pnn, ppn))) {
 		if (cmd == ELS_CMD_ADISC) {
 			lpfc_els_rsp_adisc_acc(phba, cmdiocb, ndlp);
-		}
-		else {
+		} else {
 			lpfc_els_rsp_acc(phba, ELS_CMD_PLOGI, cmdiocb, ndlp,
 				NULL, 0);
 		}
@@ -672,8 +668,7 @@ lpfc_rcv_plogi_plogi_issue(struct lpfc_h
 		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_CMD_IN_PROGRESS;
 		lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
-	}
-	else {
+	} else {
 		lpfc_rcv_plogi(phba, ndlp, cmdiocb);
 	} /* if our portname was less */
 
@@ -708,8 +703,7 @@ lpfc_rcv_els_plogi_issue(struct lpfc_hba
 
 	if (evt == NLP_EVT_RCV_LOGO) {
 		lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
-	}
-	else {
+	} else {
 		lpfc_issue_els_logo(phba, ndlp, 0);
 	}
 
@@ -803,7 +797,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 		 * execute first, queue this command to
 		 * be processed later.
 		 */
-		switch(ndlp->nlp_DID) {
+		switch (ndlp->nlp_DID) {
 		case NameServer_DID:
 			mbox->mbox_cmpl =
 				lpfc_mbx_cmpl_ns_reg_login;
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -717,8 +717,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
 			rc = NLP_STE_FREED_NODE;
-		}
-		else {
+		} else {
 			rc = lpfc_disc_state_machine(phba, ndlp, cmdiocb,
 					NLP_EVT_CMPL_PLOGI);
 		}
@@ -784,7 +783,7 @@ lpfc_issue_els_plogi(struct lpfc_hba * p
 
 	cmdsize = (sizeof (uint32_t) + sizeof (struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
-							ELS_CMD_PLOGI);
+								ELS_CMD_PLOGI);
 	if (!elsiocb)
 		return 1;
 
@@ -861,8 +860,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba * phb
 		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
 			goto out;
-		}
-		else {
+		} else {
 			lpfc_disc_state_machine(phba, ndlp, cmdiocb,
 					NLP_EVT_CMPL_PRLI);
 		}
@@ -1195,8 +1193,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba * phb
 		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
 			goto out;
-		}
-		else {
+		} else {
 			lpfc_disc_state_machine(phba, ndlp, cmdiocb,
 					NLP_EVT_CMPL_LOGO);
 		}
@@ -2201,7 +2198,7 @@ lpfc_els_disc_adisc(struct lpfc_hba * ph
 		phba->fc_flag &= ~FC_NLP_MORE;
 		spin_unlock_irq(phba->host->host_lock);
 	}
-	return(sentadisc);
+	return sentadisc;
 }
 
 int
@@ -2238,7 +2235,7 @@ lpfc_els_disc_plogi(struct lpfc_hba * ph
 		phba->fc_flag &= ~FC_NLP_MORE;
 		spin_unlock_irq(phba->host->host_lock);
 	}
-	return(sentplogi);
+	return sentplogi;
 }
 
 int
@@ -2591,8 +2588,7 @@ lpfc_els_rcv_flogi(struct lpfc_hba * phb
 				mempool_free( mbox, phba->mbox_mem_pool);
 			}
 			return 1;
-		}
-		else if (rc > 0) {	/* greater than */
+		} else if (rc > 0) {	/* greater than */
 			spin_lock_irq(phba->host->host_lock);
 			phba->fc_flag |= FC_PT2PT_PLOGI;
 			spin_unlock_irq(phba->host->host_lock);
@@ -2755,8 +2751,8 @@ lpfc_els_rcv_rps(struct lpfc_hba * phba,
 	RPS *rps;
 	struct ls_rjt stat;
 
-	if((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
-	   (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
+	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
 		stat.un.b.lsRjtRsvd0 = 0;
 		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
@@ -2866,8 +2862,8 @@ lpfc_els_rcv_rpl(struct lpfc_hba * phba,
 	RPL *rpl;
 	struct ls_rjt stat;
 
-	if((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
-	   (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
+	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
 		stat.un.b.lsRjtRsvd0 = 0;
 		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
@@ -2886,8 +2882,7 @@ lpfc_els_rcv_rpl(struct lpfc_hba * phba,
 	    ((maxsize == 0) ||
 	     ((maxsize * sizeof(uint32_t)) >= sizeof(RPL_RSP)))) {
 		cmdsize = sizeof(uint32_t) + sizeof(RPL_RSP);
-	}
-	else {
+	} else {
 		cmdsize = sizeof(uint32_t) + maxsize * sizeof(uint32_t);
 	}
 	lpfc_els_rsp_rpl_acc(phba, cmdsize, cmdiocb, ndlp);
@@ -3032,8 +3027,7 @@ lpfc_els_rcv_fan(struct lpfc_hba * phba,
 					 * other NLP_FABRIC logins
 					 */
 					lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
-				}
-				else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
+				} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 					/* Fail outstanding I/O now since this
 					 * device is marked for PLOGI
 					 */
@@ -3228,8 +3222,7 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 			spin_unlock_irq(phba->host->host_lock);
 			(piocb->iocb_cmpl) (phba, piocb, piocb);
 			spin_lock_irq(phba->host->host_lock);
-		}
-		else
+		} else
 			lpfc_sli_release_iocbq(phba, piocb);
 	}
 
@@ -3253,8 +3246,7 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 			spin_unlock_irq(phba->host->host_lock);
 			(piocb->iocb_cmpl) (phba, piocb, piocb);
 			spin_lock_irq(phba->host->host_lock);
-		}
-		else
+		} else
 			lpfc_sli_release_iocbq(phba, piocb);
 	}
 	spin_unlock_irq(phba->host->host_lock);
