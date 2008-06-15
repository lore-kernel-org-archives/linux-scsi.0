From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/5] lpfc 8.2.7 : Discovery Fixes
Date: Sat, 14 Jun 2008 22:52:47 -0400
Message-ID: <1213498367.10002.11.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33075 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbYFOCwu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jun 2008 22:52:50 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m5F2qn1N018784
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jun 2008 19:52:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Discovery Fixes:
- Fix ADISC timeout on initiators causing devloss timeout on targets
- Correct FAN processing : port state vs unreg rpi's wasn't consistent
- Correct mismatches between ASICs and PLOGI that would skip PLOGI


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c       |  141 ++++++++++++-----------------------------------------
 lpfc_hbadisc.c   |   23 +++-----
 lpfc_init.c      |    3 +
 lpfc_nportdisc.c |  145 ++++++++++++++++++++-----------------------------------
 4 files changed, 99 insertions(+), 213 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-04-10 17:07:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-06-14 22:19:37.000000000 -0400
@@ -1754,29 +1754,34 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_work_evt *evtp;
 
+	if (!(nlp->nlp_flag & NLP_DELAY_TMO))
+		return;
 	spin_lock_irq(shost->host_lock);
 	nlp->nlp_flag &= ~NLP_DELAY_TMO;
 	spin_unlock_irq(shost->host_lock);
 	del_timer_sync(&nlp->nlp_delayfunc);
 	nlp->nlp_last_elscmd = 0;
-
 	if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
 		list_del_init(&nlp->els_retry_evt.evt_listp);
 		/* Decrement nlp reference count held for the delayed retry */
 		evtp = &nlp->els_retry_evt;
 		lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
 	}
-
 	if (nlp->nlp_flag & NLP_NPR_2B_DISC) {
 		spin_lock_irq(shost->host_lock);
 		nlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
 		if (vport->num_disc_nodes) {
-			/* Check to see if there are more
-			 * PLOGIs to be sent
-			 */
-			lpfc_more_plogi(vport);
-
+			if (vport->port_state < LPFC_VPORT_READY) {
+				/* Check if there are more ADISCs to be sent */
+				lpfc_more_adisc(vport);
+				if ((vport->num_disc_nodes == 0) &&
+				    (vport->fc_npr_cnt))
+					lpfc_els_disc_plogi(vport);
+			} else {
+				/* Check if there are more PLOGIs to be sent */
+				lpfc_more_plogi(vport);
+			}
 			if (vport->num_disc_nodes == 0) {
 				spin_lock_irq(shost->host_lock);
 				vport->fc_flag &= ~FC_NDISC_ACTIVE;
@@ -1798,10 +1803,6 @@ lpfc_els_retry_delay(unsigned long ptr)
 	unsigned long flags;
 	struct lpfc_work_evt  *evtp = &ndlp->els_retry_evt;
 
-	ndlp = (struct lpfc_nodelist *) ptr;
-	phba = ndlp->vport->phba;
-	evtp = &ndlp->els_retry_evt;
-
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (!list_empty(&evtp->evt_listp)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
@@ -2761,10 +2762,11 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport 
 	npr = (PRLI *) pcmd;
 	vpd = &phba->vpd;
 	/*
-	 * If our firmware version is 3.20 or later,
-	 * set the following bits for FC-TAPE support.
+	 * If the remote port is a target and our firmware version is 3.20 or
+	 * later, set the following bits for FC-TAPE support.
 	 */
-	if (vpd->rev.feaLevelHigh >= 0x02) {
+	if ((ndlp->nlp_type & NLP_FCP_TARGET) &&
+	    (vpd->rev.feaLevelHigh >= 0x02)) {
 		npr->ConfmComplAllowed = 1;
 		npr->Retry = 1;
 		npr->TaskRetryIdReq = 1;
@@ -3056,27 +3058,16 @@ lpfc_rscn_recovery_check(struct lpfc_vpo
 {
 	struct lpfc_nodelist *ndlp = NULL;
 
-	/* Look at all nodes effected by pending RSCNs and move
-	 * them to NPR state.
-	 */
-
+	/* Move all affected nodes by pending RSCNs to NPR state. */
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (!NLP_CHK_NODE_ACT(ndlp) ||
-		    ndlp->nlp_state == NLP_STE_UNUSED_NODE ||
-		    lpfc_rscn_payload_check(vport, ndlp->nlp_DID) == 0)
+		    (ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
+		    !lpfc_rscn_payload_check(vport, ndlp->nlp_DID))
 			continue;
-
 		lpfc_disc_state_machine(vport, ndlp, NULL,
-						NLP_EVT_DEVICE_RECOVERY);
-
-		/*
-		 * Make sure NLP_DELAY_TMO is NOT running after a device
-		 * recovery event.
-		 */
-		if (ndlp->nlp_flag & NLP_DELAY_TMO)
-			lpfc_cancel_retry_delay_tmo(vport, ndlp);
+					NLP_EVT_DEVICE_RECOVERY);
+		lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	}
-
 	return 0;
 }
 
@@ -3781,91 +3772,27 @@ static int
 lpfc_els_rcv_fan(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		 struct lpfc_nodelist *fan_ndlp)
 {
-	struct lpfc_dmabuf *pcmd;
+	struct lpfc_hba *phba = vport->phba;
 	uint32_t *lp;
-	IOCB_t *icmd;
-	uint32_t cmd, did;
 	FAN *fp;
-	struct lpfc_nodelist *ndlp, *next_ndlp;
-	struct lpfc_hba *phba = vport->phba;
-
-	/* FAN received */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0265 FAN received\n");
-	icmd = &cmdiocb->iocb;
-	did = icmd->un.elsreq64.remoteID;
-	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
-	lp = (uint32_t *)pcmd->virt;
-
-	cmd = *lp++;
-	fp = (FAN *) lp;
 
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS, "0265 FAN received\n");
+	lp = (uint32_t *)((struct lpfc_dmabuf *)cmdiocb->context2)->virt;
+	fp = (FAN *) ++lp;
 	/* FAN received; Fan does not have a reply sequence */
-
-	if (phba->pport->port_state == LPFC_LOCAL_CFG_LINK) {
+	if ((vport == phba->pport) &&
+	    (vport->port_state == LPFC_LOCAL_CFG_LINK)) {
 		if ((memcmp(&phba->fc_fabparam.nodeName, &fp->FnodeName,
-			sizeof(struct lpfc_name)) != 0) ||
+			    sizeof(struct lpfc_name))) ||
 		    (memcmp(&phba->fc_fabparam.portName, &fp->FportName,
-			sizeof(struct lpfc_name)) != 0)) {
-			/*
-			 * This node has switched fabrics.  FLOGI is required
-			 * Clean up the old rpi's
-			 */
-
-			list_for_each_entry_safe(ndlp, next_ndlp,
-						 &vport->fc_nodes, nlp_listp) {
-				if (!NLP_CHK_NODE_ACT(ndlp))
-					continue;
-				if (ndlp->nlp_state != NLP_STE_NPR_NODE)
-					continue;
-				if (ndlp->nlp_type & NLP_FABRIC) {
-					/*
-					 * Clean up old Fabric, Nameserver and
-					 * other NLP_FABRIC logins
-					 */
-					lpfc_drop_node(vport, ndlp);
-
-				} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
-					/* Fail outstanding I/O now since this
-					 * device is marked for PLOGI
-					 */
-					lpfc_unreg_rpi(vport, ndlp);
-				}
-			}
-
+			    sizeof(struct lpfc_name)))) {
+			/* This port has switched fabrics. FLOGI is required */
 			lpfc_initial_flogi(vport);
-			return 0;
-		}
-		/* Discovery not needed,
-		 * move the nodes to their original state.
-		 */
-		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
-					 nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(ndlp))
-				continue;
-			if (ndlp->nlp_state != NLP_STE_NPR_NODE)
-				continue;
-
-			switch (ndlp->nlp_prev_state) {
-			case NLP_STE_UNMAPPED_NODE:
-				ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-				lpfc_nlp_set_state(vport, ndlp,
-						   NLP_STE_UNMAPPED_NODE);
-				break;
-
-			case NLP_STE_MAPPED_NODE:
-				ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-				lpfc_nlp_set_state(vport, ndlp,
-						   NLP_STE_MAPPED_NODE);
-				break;
-
-			default:
-				break;
-			}
+		} else {
+			/* FAN verified - skip FLOGI */
+			vport->fc_myDID = vport->fc_prevDID;
+			lpfc_issue_fabric_reglogin(vport);
 		}
-
-		/* Start discovery - this should just do CLEAR_LA */
-		lpfc_disc_start(vport);
 	}
 	return 0;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-04-10 17:07:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-06-14 22:19:37.000000000 -0400
@@ -1087,6 +1087,8 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 	MAILBOX_t *mb = &pmb->mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 
+	/* Unblock ELS traffic */
+	phba->sli.ring[LPFC_ELS_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
 	/* Check for error */
 	if (mb->mbxStatus) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
@@ -1650,7 +1652,6 @@ lpfc_nlp_set_state(struct lpfc_vport *vp
 		ndlp->nlp_DID, old_state, state);
 
 	if (old_state == NLP_STE_NPR_NODE &&
-	    (ndlp->nlp_flag & NLP_DELAY_TMO) != 0 &&
 	    state != NLP_STE_NPR_NODE)
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	if (old_state == NLP_STE_UNMAPPED_NODE) {
@@ -1687,8 +1688,7 @@ lpfc_dequeue_node(struct lpfc_vport *vpo
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
-	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
-		lpfc_cancel_retry_delay_tmo(vport, ndlp);
+	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
 		lpfc_nlp_counters(vport, ndlp->nlp_state, -1);
 	spin_lock_irq(shost->host_lock);
@@ -1701,8 +1701,7 @@ lpfc_dequeue_node(struct lpfc_vport *vpo
 static void
 lpfc_disable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
-		lpfc_cancel_retry_delay_tmo(vport, ndlp);
+	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
 		lpfc_nlp_counters(vport, ndlp->nlp_state, -1);
 	lpfc_nlp_state_cleanup(vport, ndlp, ndlp->nlp_state,
@@ -2121,10 +2120,8 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 	ndlp->nlp_last_elscmd = 0;
 	del_timer_sync(&ndlp->nlp_delayfunc);
 
-	if (!list_empty(&ndlp->els_retry_evt.evt_listp))
-		list_del_init(&ndlp->els_retry_evt.evt_listp);
-	if (!list_empty(&ndlp->dev_loss_evt.evt_listp))
-		list_del_init(&ndlp->dev_loss_evt.evt_listp);
+	list_del_init(&ndlp->els_retry_evt.evt_listp);
+	list_del_init(&ndlp->dev_loss_evt.evt_listp);
 
 	lpfc_unreg_rpi(vport, ndlp);
 
@@ -2144,10 +2141,7 @@ lpfc_nlp_remove(struct lpfc_vport *vport
 	LPFC_MBOXQ_t *mbox;
 	int rc;
 
-	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-		lpfc_cancel_retry_delay_tmo(vport, ndlp);
-	}
-
+	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	if (ndlp->nlp_flag & NLP_DEFER_RM && !ndlp->nlp_rpi) {
 		/* For this case we need to cleanup the default rpi
 		 * allocated by the firmware.
@@ -2317,8 +2311,7 @@ lpfc_setup_disc_node(struct lpfc_vport *
 			/* Since this node is marked for discovery,
 			 * delay timeout is not needed.
 			 */
-			if (ndlp->nlp_flag & NLP_DELAY_TMO)
-				lpfc_cancel_retry_delay_tmo(vport, ndlp);
+			lpfc_cancel_retry_delay_tmo(vport, ndlp);
 		} else
 			ndlp = NULL;
 	} else {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-04-10 17:07:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-06-14 22:19:08.000000000 -0400
@@ -851,6 +851,8 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	lpfc_read_la(phba, pmb, mp);
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_la;
 	pmb->vport = vport;
+	/* Block ELS IOCBs until we have processed this mbox command */
+	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
 	rc = lpfc_sli_issue_mbox (phba, pmb, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
 		rc = 4;
@@ -866,6 +868,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	return;
 
 lpfc_handle_latt_free_mbuf:
+	phba->sli.ring[LPFC_ELS_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 lpfc_handle_latt_free_mp:
 	kfree(mp);
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-04-10 17:07:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-06-14 22:19:37.000000000 -0400
@@ -235,10 +235,7 @@ lpfc_els_abort(struct lpfc_hba *phba, st
 			(iocb->iocb_cmpl) (phba, iocb, iocb);
 		}
 	}
-
-	/* If we are delaying issuing an ELS command, cancel it */
-	if (ndlp->nlp_flag & NLP_DELAY_TMO)
-		lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
+	lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
 	return 0;
 }
 
@@ -249,7 +246,6 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba    *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
-	struct lpfc_work_evt *evtp;
 	uint32_t *lp;
 	IOCB_t *icmd;
 	struct serv_parm *sp;
@@ -425,73 +421,8 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 			ndlp, mbox);
 		return 1;
 	}
-
-	/* If the remote NPort logs into us, before we can initiate
-	 * discovery to them, cleanup the NPort from discovery accordingly.
-	 */
-	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
-		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag &= ~NLP_DELAY_TMO;
-		spin_unlock_irq(shost->host_lock);
-		del_timer_sync(&ndlp->nlp_delayfunc);
-		ndlp->nlp_last_elscmd = 0;
-
-		if (!list_empty(&ndlp->els_retry_evt.evt_listp)) {
-			list_del_init(&ndlp->els_retry_evt.evt_listp);
-			/* Decrement ndlp reference count held for the
-			 * delayed retry
-			 */
-			evtp = &ndlp->els_retry_evt;
-			lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
-		}
-
-		if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-			spin_lock_irq(shost->host_lock);
-			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(shost->host_lock);
-
-			if ((ndlp->nlp_flag & NLP_ADISC_SND) &&
-			    (vport->num_disc_nodes)) {
-				/* Check to see if there are more
-				 * ADISCs to be sent
-				 */
-				lpfc_more_adisc(vport);
-
-				if ((vport->num_disc_nodes == 0) &&
-					(vport->fc_npr_cnt))
-					lpfc_els_disc_plogi(vport);
-
-				if (vport->num_disc_nodes == 0) {
-					spin_lock_irq(shost->host_lock);
-					vport->fc_flag &= ~FC_NDISC_ACTIVE;
-					spin_unlock_irq(shost->host_lock);
-					lpfc_can_disctmo(vport);
-					lpfc_end_rscn(vport);
-				}
-			}
-		}
-	} else if ((ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) &&
-		   (ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
-		   (vport->num_disc_nodes)) {
-		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-		spin_unlock_irq(shost->host_lock);
-		/* Check to see if there are more
-		 * PLOGIs to be sent
-		 */
-		lpfc_more_plogi(vport);
-		if (vport->num_disc_nodes == 0) {
-			spin_lock_irq(shost->host_lock);
-			vport->fc_flag &= ~FC_NDISC_ACTIVE;
-			spin_unlock_irq(shost->host_lock);
-			lpfc_can_disctmo(vport);
-			lpfc_end_rscn(vport);
-		}
-	}
-
 	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox);
 	return 1;
-
 out:
 	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 	stat.un.b.lsRjtRsnCodeExp = LSEXP_OUT_OF_RESOURCE;
@@ -574,7 +505,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, 
 	else
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
-	if (!(ndlp->nlp_type & NLP_FABRIC) ||
+	if ((!(ndlp->nlp_type & NLP_FABRIC) &&
+	     ((ndlp->nlp_type & NLP_FCP_TARGET) ||
+	      !(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
 	    (ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
 		/* Only try to re-login if this is NOT a Fabric Node */
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
@@ -751,6 +684,7 @@ static uint32_t
 lpfc_rcv_plogi_plogi_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
+	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb = arg;
 	struct lpfc_dmabuf *pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -776,7 +710,22 @@ lpfc_rcv_plogi_plogi_issue(struct lpfc_v
 		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp,
 			NULL);
 	} else {
-		lpfc_rcv_plogi(vport, ndlp, cmdiocb);
+		if (lpfc_rcv_plogi(vport, ndlp, cmdiocb) &&
+		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
+		    (vport->num_disc_nodes)) {
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+			spin_unlock_irq(shost->host_lock);
+			/* Check if there are more PLOGIs to be sent */
+			lpfc_more_plogi(vport);
+			if (vport->num_disc_nodes == 0) {
+				spin_lock_irq(shost->host_lock);
+				vport->fc_flag &= ~FC_NDISC_ACTIVE;
+				spin_unlock_irq(shost->host_lock);
+				lpfc_can_disctmo(vport);
+				lpfc_end_rscn(vport);
+			}
+		}
 	} /* If our portname was less */
 
 	return ndlp->nlp_state;
@@ -1040,6 +989,7 @@ static uint32_t
 lpfc_rcv_plogi_adisc_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
+	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb;
 
@@ -1048,9 +998,28 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_v
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
-	if (lpfc_rcv_plogi(vport, ndlp, cmdiocb))
-		return ndlp->nlp_state;
+	if (lpfc_rcv_plogi(vport, ndlp, cmdiocb)) {
+		if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+			spin_unlock_irq(shost->host_lock);
 
+			if (vport->num_disc_nodes) {
+				lpfc_more_adisc(vport);
+				if ((vport->num_disc_nodes == 0) &&
+				    (vport->fc_npr_cnt))
+					lpfc_els_disc_plogi(vport);
+				if (vport->num_disc_nodes == 0) {
+					spin_lock_irq(shost->host_lock);
+					vport->fc_flag &= ~FC_NDISC_ACTIVE;
+					spin_unlock_irq(shost->host_lock);
+					lpfc_can_disctmo(vport);
+					lpfc_end_rscn(vport);
+				}
+			}
+		}
+		return ndlp->nlp_state;
+	}
 	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 	lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
@@ -1742,24 +1711,21 @@ lpfc_rcv_plogi_npr_node(struct lpfc_vpor
 	struct lpfc_iocbq *cmdiocb  = (struct lpfc_iocbq *) arg;
 
 	/* Ignore PLOGI if we have an outstanding LOGO */
-	if (ndlp->nlp_flag & (NLP_LOGO_SND | NLP_LOGO_ACC)) {
+	if (ndlp->nlp_flag & (NLP_LOGO_SND | NLP_LOGO_ACC))
 		return ndlp->nlp_state;
-	}
-
 	if (lpfc_rcv_plogi(vport, ndlp, cmdiocb)) {
+		lpfc_cancel_retry_delay_tmo(vport, ndlp);
 		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+		ndlp->nlp_flag &= ~(NLP_NPR_ADISC | NLP_NPR_2B_DISC);
 		spin_unlock_irq(shost->host_lock);
-		return ndlp->nlp_state;
-	}
-
-	/* send PLOGI immediately, move to PLOGI issue state */
-	if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
-		ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
-		lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+	} else if (!(ndlp->nlp_flag & NLP_NPR_2B_DISC)) {
+		/* send PLOGI immediately, move to PLOGI issue state */
+		if (!(ndlp->nlp_flag & NLP_DELAY_TMO)) {
+			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
+			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+		}
 	}
-
 	return ndlp->nlp_state;
 }
 
@@ -1810,7 +1776,6 @@ lpfc_rcv_padisc_npr_node(struct lpfc_vpo
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
 	lpfc_rcv_padisc(vport, ndlp, cmdiocb);
-
 	/*
 	 * Do not start discovery if discovery is about to start
 	 * or discovery in progress for this node. Starting discovery
@@ -1973,9 +1938,7 @@ lpfc_device_recov_npr_node(struct lpfc_v
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(shost->host_lock);
-	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
-		lpfc_cancel_retry_delay_tmo(vport, ndlp);
-	}
+	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	return ndlp->nlp_state;
 }
 


