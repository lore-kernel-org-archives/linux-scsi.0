From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 6/9] lpfc 8.1.3: Protect NPL lists with host lock
Date: Tue, 28 Feb 2006 22:33:10 -0500
Message-ID: <20060301033310.GA21595@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:64209 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S1750861AbWCADdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:33:14 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k213XAQL021602
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 22:33:11 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k213XAl3021601
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 22:33:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Protect NPL lists with host lock

Symptoms: lpfc_findnode_rpi and lpfc_findnode_did can be called
outside of the discovery thread context. We have to iterate
through the NPL lists under the host lock and all add/del
operations on those lists have to be done under host lock.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1097,6 +1097,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		if (list != NLP_NO_LIST)
 			return 0;
 
+	spin_lock_irq(phba->host->host_lock);
 	switch (nlp->nlp_flag & NLP_LIST_MASK) {
 	case NLP_NO_LIST: /* Not on any list */
 		break;
@@ -1123,10 +1124,8 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 	case NLP_UNMAPPED_LIST:
 		phba->fc_unmap_cnt--;
 		list_del(&nlp->nlp_listp);
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag &= ~NLP_TGT_NO_SCSIID;
 		nlp->nlp_type &= ~NLP_FC_NODE;
-		spin_unlock_irq(phba->host->host_lock);
 		phba->nport_event_cnt++;
 		if (nlp->rport)
 			rport_del = unmapped;
@@ -1144,20 +1143,18 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		/* Stop delay tmo if taking node off NPR list */
 		if ((nlp->nlp_flag & NLP_DELAY_TMO) &&
 		   (list != NLP_NPR_LIST)) {
-			spin_lock_irq(phba->host->host_lock);
 			nlp->nlp_flag &= ~NLP_DELAY_TMO;
-			spin_unlock_irq(phba->host->host_lock);
 			nlp->nlp_last_elscmd = 0;
+			spin_unlock_irq(phba->host->host_lock);
 			del_timer_sync(&nlp->nlp_delayfunc);
+			spin_lock_irq(phba->host->host_lock);
 			if (!list_empty(&nlp->els_retry_evt.evt_listp))
 				list_del_init(&nlp->els_retry_evt.evt_listp);
 		}
 		break;
 	}
 
-	spin_lock_irq(phba->host->host_lock);
 	nlp->nlp_flag &= ~NLP_LIST_MASK;
-	spin_unlock_irq(phba->host->host_lock);
 
 	/* Add NPort <did> to <num> list */
 	lpfc_printf_log(phba,
@@ -1169,46 +1166,38 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 
 	switch (list) {
 	case NLP_NO_LIST: /* No list, just remove it */
+		spin_unlock_irq(phba->host->host_lock);
 		lpfc_nlp_remove(phba, nlp);
+		spin_lock_irq(phba->host->host_lock);
 		/* as node removed - stop further transport calls */
 		rport_del = none;
 		break;
 	case NLP_UNUSED_LIST:
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= list;
-		spin_unlock_irq(phba->host->host_lock);
 		/* Put it at the end of the unused list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_unused_list);
 		phba->fc_unused_cnt++;
 		break;
 	case NLP_PLOGI_LIST:
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= list;
-		spin_unlock_irq(phba->host->host_lock);
 		/* Put it at the end of the plogi list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_plogi_list);
 		phba->fc_plogi_cnt++;
 		break;
 	case NLP_ADISC_LIST:
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= list;
-		spin_unlock_irq(phba->host->host_lock);
 		/* Put it at the end of the adisc list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_adisc_list);
 		phba->fc_adisc_cnt++;
 		break;
 	case NLP_REGLOGIN_LIST:
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= list;
-		spin_unlock_irq(phba->host->host_lock);
 		/* Put it at the end of the reglogin list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_reglogin_list);
 		phba->fc_reglogin_cnt++;
 		break;
 	case NLP_PRLI_LIST:
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= list;
-		spin_unlock_irq(phba->host->host_lock);
 		/* Put it at the end of the prli list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_prli_list);
 		phba->fc_prli_cnt++;
@@ -1217,19 +1206,17 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		rport_add = unmapped;
 		/* ensure all vestiges of "mapped" significance are gone */
 		nlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= list;
-		spin_unlock_irq(phba->host->host_lock);
 		/* Put it at the end of the unmap list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_nlpunmap_list);
 		phba->fc_unmap_cnt++;
 		phba->nport_event_cnt++;
 		/* stop nodev tmo if running */
 		if (nlp->nlp_flag & NLP_NODEV_TMO) {
-			spin_lock_irq(phba->host->host_lock);
 			nlp->nlp_flag &= ~NLP_NODEV_TMO;
 			spin_unlock_irq(phba->host->host_lock);
 			del_timer_sync(&nlp->nlp_tmofunc);
+			spin_lock_irq(phba->host->host_lock);
 			if (!list_empty(&nlp->nodev_timeout_evt.evt_listp))
 				list_del_init(&nlp->nodev_timeout_evt.
 						evt_listp);
@@ -1239,9 +1226,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		break;
 	case NLP_MAPPED_LIST:
 		rport_add = mapped;
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= list;
-		spin_unlock_irq(phba->host->host_lock);
 		/* Put it at the end of the map list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_nlpmap_list);
 		phba->fc_map_cnt++;
@@ -1249,7 +1234,9 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		/* stop nodev tmo if running */
 		if (nlp->nlp_flag & NLP_NODEV_TMO) {
 			nlp->nlp_flag &= ~NLP_NODEV_TMO;
+			spin_unlock_irq(phba->host->host_lock);
 			del_timer_sync(&nlp->nlp_tmofunc);
+			spin_lock_irq(phba->host->host_lock);
 			if (!list_empty(&nlp->nodev_timeout_evt.evt_listp))
 				list_del_init(&nlp->nodev_timeout_evt.
 						evt_listp);
@@ -1257,9 +1244,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		}
 		break;
 	case NLP_NPR_LIST:
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= list;
-		spin_unlock_irq(phba->host->host_lock);
 		/* Put it at the end of the npr list */
 		list_add_tail(&nlp->nlp_listp, &phba->fc_npr_list);
 		phba->fc_npr_cnt++;
@@ -1268,15 +1253,15 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			mod_timer(&nlp->nlp_tmofunc,
 		 			jiffies + HZ * phba->cfg_nodev_tmo);
 
-		spin_lock_irq(phba->host->host_lock);
 		nlp->nlp_flag |= NLP_NODEV_TMO;
 		nlp->nlp_flag &= ~NLP_RCV_PLOGI;
-		spin_unlock_irq(phba->host->host_lock);
 		break;
 	case NLP_JUST_DQ:
 		break;
 	}
 
+	spin_unlock_irq(phba->host->host_lock);
+
 	/*
 	 * We make all the calls into the transport after we have
 	 * moved the node between lists. This so that we don't
@@ -1681,6 +1666,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 	uint32_t data1;
 
+	spin_lock_irq(phba->host->host_lock);
 	if (order & NLP_SEARCH_UNMAPPED) {
 		list_for_each_entry_safe(ndlp, next_ndlp,
 					 &phba->fc_nlpunmap_list, nlp_listp) {
@@ -1696,6 +1682,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
 		}
@@ -1717,6 +1704,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
 		}
@@ -1739,6 +1727,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
 		}
@@ -1783,6 +1772,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
 		}
@@ -1827,6 +1817,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
 		}
@@ -1849,11 +1840,14 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
 		}
 	}
 
+	spin_unlock_irq(phba->host->host_lock);
+
 	/* FIND node did <did> NOT FOUND */
 	lpfc_printf_log(phba,
 			KERN_INFO,
@@ -1895,9 +1889,7 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 			 */
 			if (ndlp->nlp_flag & NLP_DELAY_TMO) {
 				ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-				spin_unlock_irq(phba->host->host_lock);
 				del_timer_sync(&ndlp->nlp_delayfunc);
-				spin_lock_irq(phba->host->host_lock);
 				if (!list_empty(&ndlp->els_retry_evt.
 								evt_listp))
 					list_del_init(&ndlp->els_retry_evt.
@@ -2513,11 +2505,14 @@ lpfc_findnode_rpi(struct lpfc_hba * phba
 				    &phba->fc_reglogin_list};
 	int i;
 
+	spin_lock_irq(phba->host->host_lock);
 	for (i = 0; i < ARRAY_SIZE(lists); i++ )
 		list_for_each_entry(ndlp, lists[i], nlp_listp)
-			if (ndlp->nlp_rpi == rpi)
+			if (ndlp->nlp_rpi == rpi) {
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
-
+			}
+	spin_unlock_irq(phba->host->host_lock);
 	return NULL;
 }
 
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3144,8 +3144,9 @@ lpfc_els_timeout_handler(struct lpfc_hba
 
 		if (cmd->ulpCommand == CMD_GEN_REQUEST64_CR) {
 			struct lpfc_nodelist *ndlp;
-
+			spin_unlock_irq(phba->host->host_lock);
 			ndlp = lpfc_findnode_rpi(phba, cmd->ulpContext);
+			spin_lock_irq(phba->host->host_lock);
 			remote_ID = ndlp->nlp_DID;
 			if (cmd->un.elsreq64.bdl.ulpIoTag32) {
 				lpfc_sli_issue_abort_iotag32(phba,
