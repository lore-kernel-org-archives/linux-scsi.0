From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 14/22] lpfc 8.1.2: Added support for FAN
Date: Tue, 28 Feb 2006 19:25:28 -0500
Message-ID: <20060301002528.GA15509@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:47526 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964848AbWCAAZb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:31 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PSdO015515
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:28 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PSJv015514
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Added support for FAN

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -309,14 +309,12 @@ lpfc_linkdown(struct lpfc_hba * phba)
 	LPFC_MBOXQ_t     *mb;
 	int               rc, i;
 
-	if (phba->hba_state == LPFC_LINK_DOWN) {
-		return 0;
-	}
-
 	psli = &phba->sli;
-
 	/* sysfs or selective reset may call this routine to clean up */
-	if (phba->hba_state > LPFC_LINK_DOWN) {
+	if (phba->hba_state >= LPFC_LINK_DOWN) {
+		if (phba->hba_state == LPFC_LINK_DOWN)
+			return 0;
+
 		spin_lock_irq(phba->host->host_lock);
 		phba->hba_state = LPFC_LINK_DOWN;
 		spin_unlock_irq(phba->host->host_lock);
@@ -1172,6 +1170,7 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			spin_lock_irq(phba->host->host_lock);
 			nlp->nlp_flag &= ~NLP_DELAY_TMO;
 			spin_unlock_irq(phba->host->host_lock);
+			nlp->nlp_last_elscmd = 0;
 			del_timer_sync(&nlp->nlp_delayfunc);
 			if (!list_empty(&nlp->els_retry_evt.evt_listp))
 				list_del_init(&nlp->els_retry_evt.evt_listp);
@@ -1595,6 +1594,7 @@ lpfc_freenode(struct lpfc_hba * phba, st
 	spin_unlock_irq(phba->host->host_lock);
 	del_timer_sync(&ndlp->nlp_tmofunc);
 
+	ndlp->nlp_last_elscmd = 0;
 	del_timer_sync(&ndlp->nlp_delayfunc);
 
 	if (!list_empty(&ndlp->nodev_timeout_evt.evt_listp))
@@ -1630,6 +1630,7 @@ lpfc_nlp_remove(struct lpfc_hba * phba, 
 		spin_lock_irq(phba->host->host_lock);
 		ndlp->nlp_flag &= ~NLP_DELAY_TMO;
 		spin_unlock_irq(phba->host->host_lock);
+		ndlp->nlp_last_elscmd = 0;
 		del_timer_sync(&ndlp->nlp_delayfunc);
 		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
 			list_del_init(&ndlp->els_retry_evt.evt_listp);
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -262,6 +262,7 @@ lpfc_els_abort(struct lpfc_hba * phba, s
 	/* If we are delaying issuing an ELS command, cancel it */
 	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
 		ndlp->nlp_flag &= ~NLP_DELAY_TMO;
+		ndlp->nlp_last_elscmd = 0;
 		del_timer_sync(&ndlp->nlp_delayfunc);
 		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
 			list_del_init(&ndlp->els_retry_evt.evt_listp);
@@ -398,16 +399,8 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 	 */
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 	mbox->context2  = ndlp;
-	ndlp->nlp_flag |= NLP_ACC_REGLOGIN;
+	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
 
-	/* If there is an outstanding PLOGI issued, abort it before
-	 * sending ACC rsp to PLOGI recieved.
-	 */
-	if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) {
-		/* software abort outstanding PLOGI */
-		lpfc_els_abort(phba, ndlp, 1);
-	}
-	ndlp->nlp_flag |= NLP_RCV_PLOGI;
 	lpfc_els_rsp_acc(phba, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox, 0);
 	return 1;
 
@@ -465,13 +458,14 @@ lpfc_rcv_padisc(struct lpfc_hba * phba,
 	stat.un.b.vendorUnique = 0;
 	lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
 
-	ndlp->nlp_last_elscmd = (unsigned long)ELS_CMD_PLOGI;
 	/* 1 sec timeout */
 	mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
 
 	spin_lock_irq(phba->host->host_lock);
 	ndlp->nlp_flag |= NLP_DELAY_TMO;
 	spin_unlock_irq(phba->host->host_lock);
+	ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+	ndlp->nlp_prev_state = ndlp->nlp_state;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	return 0;
@@ -492,15 +486,17 @@ lpfc_rcv_logo(struct lpfc_hba * phba,
 	if (!(ndlp->nlp_type & NLP_FABRIC) ||
 		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
 		/* Only try to re-login if this is NOT a Fabric Node */
-		ndlp->nlp_last_elscmd = (unsigned long)ELS_CMD_PLOGI;
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
 		spin_lock_irq(phba->host->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		spin_unlock_irq(phba->host->host_lock);
 
+		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+		ndlp->nlp_prev_state = ndlp->nlp_state;
 		ndlp->nlp_state = NLP_STE_NPR_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	} else {
+		ndlp->nlp_prev_state = ndlp->nlp_state;
 		ndlp->nlp_state = NLP_STE_UNUSED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
 	}
@@ -595,6 +591,7 @@ lpfc_rcv_plogi_unused_node(struct lpfc_h
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	if (lpfc_rcv_plogi(phba, ndlp, cmdiocb)) {
+		ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
 		ndlp->nlp_state = NLP_STE_UNUSED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
 		return ndlp->nlp_state;
@@ -708,10 +705,6 @@ lpfc_rcv_els_plogi_issue(struct lpfc_hba
 
 	/* software abort outstanding PLOGI */
 	lpfc_els_abort(phba, ndlp, 1);
-	mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
-	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag |= NLP_DELAY_TMO;
-	spin_unlock_irq(phba->host->host_lock);
 
 	if (evt == NLP_EVT_RCV_LOGO) {
 		lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
@@ -721,7 +714,12 @@ lpfc_rcv_els_plogi_issue(struct lpfc_hba
 	}
 
 	/* Put ndlp in npr list set plogi timer for 1 sec */
-	ndlp->nlp_last_elscmd = (unsigned long)ELS_CMD_PLOGI;
+	mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
+	spin_lock_irq(phba->host->host_lock);
+	ndlp->nlp_flag |= NLP_DELAY_TMO;
+	spin_unlock_irq(phba->host->host_lock);
+	ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+	ndlp->nlp_prev_state = NLP_STE_PLOGI_ISSUE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 
@@ -744,6 +742,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
 	if (ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
+		/* Recovery from PLOGI collision logic */
 		return ndlp->nlp_state;
 	}
 
@@ -859,6 +858,7 @@ lpfc_device_recov_plogi_issue(struct lpf
 	/* software abort outstanding PLOGI */
 	lpfc_els_abort(phba, ndlp, 1);
 
+	ndlp->nlp_prev_state = NLP_STE_PLOGI_ISSUE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
@@ -883,6 +883,7 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_h
 	if (lpfc_rcv_plogi(phba, ndlp, cmdiocb)) {
 		return ndlp->nlp_state;
 	}
+	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 	ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 	lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 	lpfc_issue_els_plogi(phba, ndlp, 0);
@@ -963,25 +964,29 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 
 	if ((irsp->ulpStatus) ||
 		(!lpfc_check_adisc(phba, ndlp, &ap->nodeName, &ap->portName))) {
-		ndlp->nlp_last_elscmd = (unsigned long)ELS_CMD_PLOGI;
 		/* 1 sec timeout */
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
 		spin_lock_irq(phba->host->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		spin_unlock_irq(phba->host->host_lock);
+		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
 		memset(&ndlp->nlp_nodename, 0, sizeof (struct lpfc_name));
 		memset(&ndlp->nlp_portname, 0, sizeof (struct lpfc_name));
 
+		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 		ndlp->nlp_state = NLP_STE_NPR_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 		lpfc_unreg_rpi(phba, ndlp);
 		return ndlp->nlp_state;
 	}
+
 	if (ndlp->nlp_type & NLP_FCP_TARGET) {
+		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 		ndlp->nlp_state = NLP_STE_MAPPED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
 	} else {
+		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
 	}
@@ -1008,6 +1013,7 @@ lpfc_device_recov_adisc_issue(struct lpf
 	/* software abort outstanding ADISC */
 	lpfc_els_abort(phba, ndlp, 1);
 
+	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
@@ -1103,14 +1109,15 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 				phba->brd_no,
 				did, mb->mbxStatus, phba->hba_state);
 
+		/* Put ndlp in npr list set plogi timer for 1 sec */
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
 		spin_lock_irq(phba->host->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		spin_unlock_irq(phba->host->host_lock);
+		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 
 		lpfc_issue_els_logo(phba, ndlp, 0);
-		/* Put ndlp in npr list set plogi timer for 1 sec */
-		ndlp->nlp_last_elscmd = (unsigned long)ELS_CMD_PLOGI;
+		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		ndlp->nlp_state = NLP_STE_NPR_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 		return ndlp->nlp_state;
@@ -1120,10 +1127,12 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 
 	/* Only if we are not a fabric nport do we issue PRLI */
 	if (!(ndlp->nlp_type & NLP_FABRIC)) {
+		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
 		lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
 		lpfc_issue_els_prli(phba, ndlp, 0);
 	} else {
+		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
 	}
@@ -1144,6 +1153,7 @@ lpfc_device_recov_reglogin_issue(struct 
 			       struct lpfc_nodelist * ndlp, void *arg,
 			       uint32_t evt)
 {
+	ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
@@ -1233,6 +1243,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_hb
 
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus) {
+		ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
 		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
 		return ndlp->nlp_state;
@@ -1251,6 +1262,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_hb
 			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
 	}
 
+	ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
 	ndlp->nlp_state = NLP_STE_MAPPED_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
 	return ndlp->nlp_state;
@@ -1308,6 +1320,7 @@ lpfc_device_recov_prli_issue(struct lpfc
 	/* software abort outstanding PRLI */
 	lpfc_els_abort(phba, ndlp, 1);
 
+	ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
@@ -1381,6 +1394,7 @@ static uint32_t
 lpfc_device_recov_unmap_node(struct lpfc_hba * phba,
 			   struct lpfc_nodelist * ndlp, void *arg, uint32_t evt)
 {
+	ndlp->nlp_prev_state = NLP_STE_UNMAPPED_NODE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
@@ -1462,6 +1476,7 @@ lpfc_device_recov_mapped_node(struct lpf
 			    struct lpfc_nodelist * ndlp, void *arg,
 			    uint32_t evt)
 {
+	ndlp->nlp_prev_state = NLP_STE_MAPPED_NODE;
 	ndlp->nlp_state = NLP_STE_NPR_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 	spin_lock_irq(phba->host->host_lock);
@@ -1494,6 +1509,7 @@ lpfc_rcv_plogi_npr_node(struct lpfc_hba 
 
 	/* send PLOGI immediately, move to PLOGI issue state */
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
+			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 			lpfc_issue_els_plogi(phba, ndlp, 0);
@@ -1521,10 +1537,12 @@ lpfc_rcv_prli_npr_node(struct lpfc_hba *
 			spin_lock_irq(phba->host->host_lock);
 			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 			spin_unlock_irq(phba->host->host_lock);
+			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
 			lpfc_issue_els_adisc(phba, ndlp, 0);
 		} else {
+			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 			lpfc_issue_els_plogi(phba, ndlp, 0);
@@ -1559,10 +1577,12 @@ lpfc_rcv_padisc_npr_node(struct lpfc_hba
 
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
 		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
+			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
 			lpfc_issue_els_adisc(phba, ndlp, 0);
 		} else {
+			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 			lpfc_issue_els_plogi(phba, ndlp, 0);
@@ -1592,6 +1612,7 @@ lpfc_rcv_prlo_npr_node(struct lpfc_hba *
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 		spin_unlock_irq(phba->host->host_lock);
+		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	} else {
 		spin_lock_irq(phba->host->host_lock);
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
@@ -1681,6 +1702,7 @@ lpfc_device_recov_npr_node(struct lpfc_h
 		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
 			list_del_init(&ndlp->els_retry_evt.evt_listp);
 		spin_unlock_irq(phba->host->host_lock);
+		ndlp->nlp_last_elscmd = 0;
 		del_timer_sync(&ndlp->nlp_delayfunc);
 		return ndlp->nlp_state;
 	}
@@ -1905,6 +1927,5 @@ lpfc_disc_state_machine(struct lpfc_hba 
 	}
 	if (rc == NLP_STE_FREED_NODE)
 		return NLP_STE_FREED_NODE;
-	ndlp->nlp_state = rc;
 	return rc;
 }
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1201,12 +1201,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba * phb
 					NLP_EVT_CMPL_LOGO);
 		}
 	} else {
-		/* Good status, call state machine */
+		/* Good status, call state machine.
+		 * This will unregister the rpi if needed.
+		 */
 		lpfc_disc_state_machine(phba, ndlp, cmdiocb, NLP_EVT_CMPL_LOGO);
-
-		if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-			lpfc_unreg_rpi(phba, ndlp);
-		}
 	}
 
 out:
@@ -1435,8 +1433,9 @@ lpfc_els_retry_delay_handler(struct lpfc
 
 	phba = ndlp->nlp_phba;
 	spin_lock_irq(phba->host->host_lock);
-	did = (uint32_t) (ndlp->nlp_DID);
-	cmd = (uint32_t) (ndlp->nlp_last_elscmd);
+	did = ndlp->nlp_DID;
+	cmd = ndlp->nlp_last_elscmd;
+	ndlp->nlp_last_elscmd = 0;
 
 	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
 		spin_unlock_irq(phba->host->host_lock);
@@ -1453,24 +1452,28 @@ lpfc_els_retry_delay_handler(struct lpfc
 		break;
 	case ELS_CMD_PLOGI:
 		if (!lpfc_issue_els_plogi(phba, ndlp, retry)) {
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 		}
 		break;
 	case ELS_CMD_ADISC:
 		if (!lpfc_issue_els_adisc(phba, ndlp, retry)) {
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
 		}
 		break;
 	case ELS_CMD_PRLI:
 		if (!lpfc_issue_els_prli(phba, ndlp, retry)) {
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
 		}
 		break;
 	case ELS_CMD_LOGO:
 		if (!lpfc_issue_els_logo(phba, ndlp, retry)) {
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 		}
@@ -1630,6 +1633,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 			mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
 
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 			ndlp->nlp_last_elscmd = cmd;
@@ -1641,21 +1645,25 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 			lpfc_issue_els_flogi(phba, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_PLOGI:
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 			lpfc_issue_els_plogi(phba, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_ADISC:
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_ADISC_LIST);
 			lpfc_issue_els_adisc(phba, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_PRLI:
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_PRLI_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_PRLI_LIST);
 			lpfc_issue_els_prli(phba, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_LOGO:
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_list(phba, ndlp, NLP_NPR_LIST);
 			lpfc_issue_els_logo(phba, ndlp, cmdiocb->retry);
@@ -1719,10 +1727,6 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 			phba->brd_no, ndlp->nlp_DID, ndlp->nlp_flag,
 			ndlp->nlp_state, ndlp->nlp_rpi);
 
-	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~NLP_LOGO_ACC;
-	spin_unlock_irq(phba->host->host_lock);
-
 	switch (ndlp->nlp_state) {
 	case NLP_STE_UNUSED_NODE:	/* node is just allocated */
 		lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
@@ -1776,6 +1780,7 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 			lpfc_unreg_rpi(phba, ndlp);
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 			mbox->context2 = ndlp;
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_REG_LOGIN_ISSUE;
 			lpfc_nlp_list(phba, ndlp, NLP_REGLOGIN_LIST);
 			if (lpfc_sli_issue_mbox(phba, mbox,
@@ -1790,6 +1795,7 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 			mempool_free( mbox, phba->mbox_mem_pool);
 			if (ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
 				lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+				ndlp = NULL;
 			}
 		}
 	}
@@ -1827,6 +1833,7 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 		if ((elsiocb =
 		     lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
 					ndlp, ELS_CMD_ACC)) == 0) {
+			ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 			return 1;
 		}
 		icmd = &elsiocb->iocb;
@@ -2172,6 +2179,7 @@ lpfc_els_disc_adisc(struct lpfc_hba * ph
 		if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
 			if (ndlp->nlp_flag & NLP_NPR_ADISC) {
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+				ndlp->nlp_prev_state = ndlp->nlp_state;
 				ndlp->nlp_state = NLP_STE_ADISC_ISSUE;
 				lpfc_nlp_list(phba, ndlp,
 					NLP_ADISC_LIST);
@@ -2209,6 +2217,7 @@ lpfc_els_disc_plogi(struct lpfc_hba * ph
 		if ((ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
 		   (!(ndlp->nlp_flag & NLP_DELAY_TMO))) {
 			if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
+				ndlp->nlp_prev_state = ndlp->nlp_state;
 				ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 				lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 				lpfc_issue_els_plogi(phba, ndlp, 0);
@@ -2350,8 +2359,13 @@ lpfc_rscn_recovery_check(struct lpfc_hba
 
 			lpfc_disc_state_machine(phba, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
+
+			/* Make sure NLP_DELAY_TMO is NOT running
+			 * after a device recovery event.
+			 */
 			if (ndlp->nlp_flag & NLP_DELAY_TMO) {
 				ndlp->nlp_flag &= ~NLP_DELAY_TMO;
+				ndlp->nlp_last_elscmd = 0;
 				del_timer_sync(&ndlp->nlp_delayfunc);
 				if (!list_empty(&ndlp->
 						els_retry_evt.evt_listp))
@@ -2503,6 +2517,7 @@ lpfc_els_handle_rscn(struct lpfc_hba * p
 		} else {
 			lpfc_nlp_init(phba, ndlp, NameServer_DID);
 			ndlp->nlp_type |= NLP_FABRIC;
+			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 			lpfc_issue_els_plogi(phba, ndlp, 0);
 			/* Wait for NameServer login cmpl before we can
@@ -2930,6 +2945,7 @@ lpfc_els_rcv_farp(struct lpfc_hba * phba
 		   (ndlp->nlp_state == NLP_STE_MAPPED_NODE)) {
 			/* Log back into the node before sending the FARP. */
 			if (fp->Rflags & FARP_REQUEST_PLOGI) {
+				ndlp->nlp_prev_state = ndlp->nlp_state;
 				ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
 				lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 				lpfc_issue_els_plogi(phba, ndlp, 0);
@@ -2974,46 +2990,89 @@ lpfc_els_rcv_farpr(struct lpfc_hba * phb
 
 static int
 lpfc_els_rcv_fan(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
-		 struct lpfc_nodelist * ndlp)
+		 struct lpfc_nodelist * fan_ndlp)
 {
 	struct lpfc_dmabuf *pcmd;
 	uint32_t *lp;
 	IOCB_t *icmd;
-	FAN *fp;
 	uint32_t cmd, did;
+	FAN *fp;
+	struct lpfc_nodelist *ndlp, *next_ndlp;
+
+	/* FAN received */
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS, "%d:265 FAN received\n",
+								phba->brd_no);
 
 	icmd = &cmdiocb->iocb;
 	did = icmd->un.elsreq64.remoteID;
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
-	lp = (uint32_t *) pcmd->virt;
+	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
+	lp = (uint32_t *)pcmd->virt;
 
 	cmd = *lp++;
-	fp = (FAN *) lp;
+	fp = (FAN *)lp;
 
-	/* FAN received */
-
-	/* ACCEPT the FAN request */
-	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	/* FAN received; Fan does not have a reply sequence */
 
 	if (phba->hba_state == LPFC_LOCAL_CFG_LINK) {
-		/* The discovery state machine needs to take a different
-		 * action if this node has switched fabrics
-		 */
-		if ((memcmp(&fp->FportName, &phba->fc_fabparam.portName,
-			    sizeof (struct lpfc_name)) != 0)
-		    ||
-		    (memcmp(&fp->FnodeName, &phba->fc_fabparam.nodeName,
-			    sizeof (struct lpfc_name)) != 0)) {
-			/* This node has switched fabrics.  An FLOGI is required
-			 * after the timeout
+		if ((memcmp(&phba->fc_fabparam.nodeName, &fp->FnodeName,
+			sizeof(struct lpfc_name)) != 0) ||
+		    (memcmp(&phba->fc_fabparam.portName, &fp->FportName,
+			sizeof(struct lpfc_name)) != 0)) {
+			/*
+			 * This node has switched fabrics.  FLOGI is required
+			 * Clean up the old rpi's
 			 */
+
+			list_for_each_entry_safe(ndlp, next_ndlp,
+				&phba->fc_npr_list, nlp_listp) {
+
+				if (ndlp->nlp_type & NLP_FABRIC) {
+					/*
+					 * Clean up old Fabric, Nameserver and
+					 * other NLP_FABRIC logins
+					 */
+					lpfc_nlp_list(phba, ndlp, NLP_NO_LIST);
+				}
+				else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
+					/* Fail outstanding I/O now since this
+					 * device is marked for PLOGI
+					 */
+					lpfc_unreg_rpi(phba, ndlp);
+				}
+			}
+
+			phba->hba_state = LPFC_FLOGI;
+			lpfc_set_disctmo(phba);
+			lpfc_initial_flogi(phba);
 			return 0;
 		}
+		/* Discovery not needed,
+		 * move the nodes to their original state.
+		 */
+		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
+			nlp_listp) {
 
-		/* Start discovery */
+			switch (ndlp->nlp_prev_state) {
+			case NLP_STE_UNMAPPED_NODE:
+				ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
+				ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
+				lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+				break;
+
+			case NLP_STE_MAPPED_NODE:
+				ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
+				ndlp->nlp_state = NLP_STE_MAPPED_NODE;
+				lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
+				break;
+
+			default:
+				break;
+			}
+		}
+
+		/* Start discovery - this should just do CLEAR_LA */
 		lpfc_disc_start(phba);
 	}
-
 	return 0;
 }
 
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -62,6 +62,7 @@ struct lpfc_nodelist {
 
 	uint16_t        nlp_rpi;
 	uint16_t        nlp_state;		/* state transition indicator */
+	uint16_t        nlp_prev_state;		/* state transition indicator */
 	uint16_t        nlp_xri;		/* output exchange id for RPI */
 	uint16_t        nlp_sid;		/* scsi id */
 #define NLP_NO_SID		0xffff
