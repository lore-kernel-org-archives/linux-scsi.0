From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/22] lpfc 8.3.39: Remove driver dependency on HZ
Date: Wed, 17 Apr 2013 20:14:58 -0400
Message-ID: <1366244098.1513.3.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24287 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935459Ab3DRAPB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:15:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove driver dependency on HZ


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    6 ++++--
 lpfc_bsg.c       |    6 ++++--
 lpfc_ct.c        |    3 ++-
 lpfc_els.c       |   10 ++++++----
 lpfc_hbadisc.c   |    5 +++--
 lpfc_init.c      |   45 +++++++++++++++++++++++++++++----------------
 lpfc_nportdisc.c |   19 ++++++++++++-------
 lpfc_scsi.c      |    2 +-
 lpfc_sli.c       |   33 +++++++++++++++++++--------------
 9 files changed, 80 insertions(+), 49 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2013-04-15 18:26:24.122040826 -0400
@@ -2576,7 +2576,8 @@ static int lpfcdiag_loop_get_xri(struct
 	evt->wait_time_stamp = jiffies;
 	time_left = wait_event_interruptible_timeout(
 		evt->wq, !list_empty(&evt->events_to_see),
-		((phba->fc_ratov * 2) + LPFC_DRVR_TIMEOUT) * HZ);
+		msecs_to_jiffies(1000 *
+			((phba->fc_ratov * 2) + LPFC_DRVR_TIMEOUT)));
 	if (list_empty(&evt->events_to_see))
 		ret_val = (time_left) ? -EINTR : -ETIMEDOUT;
 	else {
@@ -3151,7 +3152,8 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg
 	evt->waiting = 1;
 	time_left = wait_event_interruptible_timeout(
 		evt->wq, !list_empty(&evt->events_to_see),
-		((phba->fc_ratov * 2) + LPFC_DRVR_TIMEOUT) * HZ);
+		msecs_to_jiffies(1000 *
+			((phba->fc_ratov * 2) + LPFC_DRVR_TIMEOUT)));
 	evt->waiting = 0;
 	if (list_empty(&evt->events_to_see)) {
 		rc = (time_left) ? -EINTR : -ETIMEDOUT;
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2013-04-15 18:26:24.128040826 -0400
@@ -1811,7 +1811,8 @@ lpfc_fdmi_timeout_handler(struct lpfc_vp
 		if (init_utsname()->nodename[0] != '\0')
 			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA);
 		else
-			mod_timer(&vport->fc_fdmitmo, jiffies + HZ * 60);
+			mod_timer(&vport->fc_fdmitmo, jiffies +
+				  msecs_to_jiffies(1000 * 60));
 	}
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2013-04-15 18:26:24.178040827 -0400
@@ -6241,7 +6241,8 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 	}
 
 	if (!list_empty(&phba->sli.ring[LPFC_ELS_RING].txcmplq))
-		mod_timer(&vport->els_tmofunc, jiffies + HZ * timeout);
+		mod_timer(&vport->els_tmofunc,
+			  jiffies + msecs_to_jiffies(1000 * timeout));
 }
 
 /**
@@ -7003,7 +7004,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 	if (vport->fc_flag & FC_DISC_DELAYED) {
 		spin_unlock_irq(shost->host_lock);
 		mod_timer(&vport->delayed_disc_tmo,
-			jiffies + HZ * phba->fc_ratov);
+			jiffies + msecs_to_jiffies(1000 * phba->fc_ratov));
 		return;
 	}
 	spin_unlock_irq(shost->host_lock);
@@ -7287,7 +7288,7 @@ lpfc_retry_pport_discovery(struct lpfc_h
 		return;
 
 	shost = lpfc_shost_from_vport(phba->pport);
-	mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+	mod_timer(&ndlp->nlp_delayfunc, jiffies + msecs_to_jiffies(1000));
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_DELAY_TMO;
 	spin_unlock_irq(shost->host_lock);
@@ -7791,7 +7792,8 @@ lpfc_block_fabric_iocbs(struct lpfc_hba
 	blocked = test_and_set_bit(FABRIC_COMANDS_BLOCKED, &phba->bit_flags);
 	/* Start a timer to unblock fabric iocbs after 100ms */
 	if (!blocked)
-		mod_timer(&phba->fabric_block_timer, jiffies + HZ/10 );
+		mod_timer(&phba->fabric_block_timer,
+			  jiffies + msecs_to_jiffies(100));
 
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2013-04-15 18:26:24.180040827 -0400
@@ -66,8 +66,10 @@ struct lpfc_sli2_slim;
  * queue depths when there are driver resource error or Firmware
  * resource error.
  */
-#define QUEUE_RAMP_DOWN_INTERVAL	(1 * HZ)   /* 1 Second */
-#define QUEUE_RAMP_UP_INTERVAL		(300 * HZ) /* 5 minutes */
+/* 1 Second */
+#define QUEUE_RAMP_DOWN_INTERVAL	(msecs_to_jiffies(1000 * 1))
+/* 5 minutes */
+#define QUEUE_RAMP_UP_INTERVAL		(msecs_to_jiffies(1000 * 300))
 
 /* Number of exchanges reserved for discovery to complete */
 #define LPFC_DISC_IOCB_BUFF_COUNT 20
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:14.814040614 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:24.187040829 -0400
@@ -4247,7 +4247,7 @@ lpfc_set_disctmo(struct lpfc_vport *vpor
 			tmo, vport->port_state, vport->fc_flag);
 	}
 
-	mod_timer(&vport->fc_disctmo, jiffies + HZ * tmo);
+	mod_timer(&vport->fc_disctmo, jiffies + msecs_to_jiffies(1000 * tmo));
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag |= FC_DISC_TMO;
 	spin_unlock_irq(shost->host_lock);
@@ -5422,7 +5422,8 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 	if (vport->cfg_fdmi_on == 1)
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA);
 	else
-		mod_timer(&vport->fc_fdmitmo, jiffies + HZ * 60);
+		mod_timer(&vport->fc_fdmitmo,
+			  jiffies + msecs_to_jiffies(1000 * 60));
 
 	/* decrement the node reference count held for this callback
 	 * function.
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:14.875040617 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:24.220040829 -0400
@@ -541,13 +541,16 @@ lpfc_config_port_post(struct lpfc_hba *p
 
 	/* Set up ring-0 (ELS) timer */
 	timeout = phba->fc_ratov * 2;
-	mod_timer(&vport->els_tmofunc, jiffies + HZ * timeout);
+	mod_timer(&vport->els_tmofunc,
+		  jiffies + msecs_to_jiffies(1000 * timeout));
 	/* Set up heart beat (HB) timer */
-	mod_timer(&phba->hb_tmofunc, jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
+	mod_timer(&phba->hb_tmofunc,
+		  jiffies + msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
 	phba->hb_outstanding = 0;
 	phba->last_completion_time = jiffies;
 	/* Set up error attention (ERATT) polling timer */
-	mod_timer(&phba->eratt_poll, jiffies + HZ * LPFC_ERATT_POLL_INTERVAL);
+	mod_timer(&phba->eratt_poll,
+		  jiffies + msecs_to_jiffies(1000 * LPFC_ERATT_POLL_INTERVAL));
 
 	if (phba->hba_flag & LINK_DISABLED) {
 		lpfc_printf_log(phba,
@@ -1021,7 +1024,8 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba
 		!(phba->link_state == LPFC_HBA_ERROR) &&
 		!(phba->pport->load_flag & FC_UNLOADING))
 		mod_timer(&phba->hb_tmofunc,
-			jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
+			  jiffies +
+			  msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
 	return;
 }
 
@@ -1064,15 +1068,18 @@ lpfc_hb_timeout_handler(struct lpfc_hba
 
 	spin_lock_irq(&phba->pport->work_port_lock);
 
-	if (time_after(phba->last_completion_time + LPFC_HB_MBOX_INTERVAL * HZ,
-		jiffies)) {
+	if (time_after(phba->last_completion_time +
+			msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL),
+			jiffies)) {
 		spin_unlock_irq(&phba->pport->work_port_lock);
 		if (!phba->hb_outstanding)
 			mod_timer(&phba->hb_tmofunc,
-				jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
+				jiffies +
+				msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
 		else
 			mod_timer(&phba->hb_tmofunc,
-				jiffies + HZ * LPFC_HB_MBOX_TIMEOUT);
+				jiffies +
+				msecs_to_jiffies(1000 * LPFC_HB_MBOX_TIMEOUT));
 		return;
 	}
 	spin_unlock_irq(&phba->pport->work_port_lock);
@@ -1104,7 +1111,8 @@ lpfc_hb_timeout_handler(struct lpfc_hba
 				if (!pmboxq) {
 					mod_timer(&phba->hb_tmofunc,
 						 jiffies +
-						 HZ * LPFC_HB_MBOX_INTERVAL);
+						 msecs_to_jiffies(1000 *
+						 LPFC_HB_MBOX_INTERVAL));
 					return;
 				}
 
@@ -1120,7 +1128,8 @@ lpfc_hb_timeout_handler(struct lpfc_hba
 							phba->mbox_mem_pool);
 					mod_timer(&phba->hb_tmofunc,
 						jiffies +
-						HZ * LPFC_HB_MBOX_INTERVAL);
+						msecs_to_jiffies(1000 *
+						LPFC_HB_MBOX_INTERVAL));
 					return;
 				}
 				phba->skipped_hb = 0;
@@ -1136,7 +1145,8 @@ lpfc_hb_timeout_handler(struct lpfc_hba
 				phba->skipped_hb = jiffies;
 
 			mod_timer(&phba->hb_tmofunc,
-				  jiffies + HZ * LPFC_HB_MBOX_TIMEOUT);
+				 jiffies +
+				 msecs_to_jiffies(1000 * LPFC_HB_MBOX_TIMEOUT));
 			return;
 		} else {
 			/*
@@ -1150,7 +1160,8 @@ lpfc_hb_timeout_handler(struct lpfc_hba
 					jiffies_to_msecs(jiffies
 						 - phba->last_completion_time));
 			mod_timer(&phba->hb_tmofunc,
-				  jiffies + HZ * LPFC_HB_MBOX_TIMEOUT);
+				jiffies +
+				msecs_to_jiffies(1000 * LPFC_HB_MBOX_TIMEOUT));
 		}
 	}
 }
@@ -3207,14 +3218,15 @@ int lpfc_scan_finished(struct Scsi_Host
 		stat = 1;
 		goto finished;
 	}
-	if (time >= 30 * HZ) {
+	if (time >= msecs_to_jiffies(30 * 1000)) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0461 Scanning longer than 30 "
 				"seconds.  Continuing initialization\n");
 		stat = 1;
 		goto finished;
 	}
-	if (time >= 15 * HZ && phba->link_state <= LPFC_LINK_DOWN) {
+	if (time >= msecs_to_jiffies(15 * 1000) &&
+	    phba->link_state <= LPFC_LINK_DOWN) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0465 Link down longer than 15 "
 				"seconds.  Continuing initialization\n");
@@ -3226,7 +3238,7 @@ int lpfc_scan_finished(struct Scsi_Host
 		goto finished;
 	if (vport->num_disc_nodes || vport->fc_prli_sent)
 		goto finished;
-	if (vport->fc_map_cnt == 0 && time < 2 * HZ)
+	if (vport->fc_map_cnt == 0 && time < msecs_to_jiffies(2 * 1000))
 		goto finished;
 	if ((phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE) != 0)
 		goto finished;
@@ -4225,7 +4237,8 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba
 			 * If there are other active VLinks present,
 			 * re-instantiate the Vlink using FDISC.
 			 */
-			mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+			mod_timer(&ndlp->nlp_delayfunc,
+				  jiffies + msecs_to_jiffies(1000));
 			shost = lpfc_shost_from_vport(vport);
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2013-04-15 18:26:24.224040829 -0400
@@ -574,7 +574,7 @@ out:
 	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
 
 	/* 1 sec timeout */
-	mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+	mod_timer(&ndlp->nlp_delayfunc, jiffies + msecs_to_jiffies(1000));
 
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_DELAY_TMO;
@@ -631,7 +631,8 @@ lpfc_rcv_logo(struct lpfc_vport *vport,
 			 * If there are other active VLinks present,
 			 * re-instantiate the Vlink using FDISC.
 			 */
-			mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+			mod_timer(&ndlp->nlp_delayfunc,
+				  jiffies + msecs_to_jiffies(1000));
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
 			spin_unlock_irq(shost->host_lock);
@@ -648,7 +649,8 @@ lpfc_rcv_logo(struct lpfc_vport *vport,
 		!(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
 		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
 		/* Only try to re-login if this is NOT a Fabric Node */
-		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
+		mod_timer(&ndlp->nlp_delayfunc,
+			  jiffies + msecs_to_jiffies(1000 * 1));
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		spin_unlock_irq(shost->host_lock);
@@ -969,7 +971,7 @@ lpfc_rcv_els_plogi_issue(struct lpfc_vpo
 	}
 
 	/* Put ndlp in npr state set plogi timer for 1 sec */
-	mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
+	mod_timer(&ndlp->nlp_delayfunc, jiffies + msecs_to_jiffies(1000 * 1));
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_DELAY_TMO;
 	spin_unlock_irq(shost->host_lock);
@@ -1303,7 +1305,8 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 	if ((irsp->ulpStatus) ||
 	    (!lpfc_check_adisc(vport, ndlp, &ap->nodeName, &ap->portName))) {
 		/* 1 sec timeout */
-		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+		mod_timer(&ndlp->nlp_delayfunc,
+			  jiffies + msecs_to_jiffies(1000));
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		spin_unlock_irq(shost->host_lock);
@@ -1509,7 +1512,8 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 		}
 
 		/* Put ndlp in npr state set plogi timer for 1 sec */
-		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
+		mod_timer(&ndlp->nlp_delayfunc,
+			  jiffies + msecs_to_jiffies(1000 * 1));
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		spin_unlock_irq(shost->host_lock);
@@ -2145,7 +2149,8 @@ lpfc_rcv_prlo_npr_node(struct lpfc_vport
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
 	if ((ndlp->nlp_flag & NLP_DELAY_TMO) == 0) {
-		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
+		mod_timer(&ndlp->nlp_delayfunc,
+			  jiffies + msecs_to_jiffies(1000 * 1));
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_DELAY_TMO;
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:21.124040758 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:24.228040829 -0400
@@ -4771,7 +4771,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	/* Wait for abort to complete */
 	wait_event_timeout(waitq,
 			  (lpfc_cmd->pCmd != cmnd),
-			   (2*vport->cfg_devloss_tmo*HZ));
+			   msecs_to_jiffies(2*vport->cfg_devloss_tmo*1000));
 	lpfc_cmd->waitq = NULL;
 
 	if (lpfc_cmd->pCmd == cmnd) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:14.915040617 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:24.252040829 -0400
@@ -666,7 +666,7 @@ lpfc_handle_rrq_active(struct lpfc_hba *
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag &= ~HBA_RRQ_ACTIVE;
-	next_time = jiffies + HZ * (phba->fc_ratov + 1);
+	next_time = jiffies + msecs_to_jiffies(1000 * (phba->fc_ratov + 1));
 	list_for_each_entry_safe(rrq, nextrrq,
 				 &phba->active_rrq_list, list) {
 		if (time_after(jiffies, rrq->rrq_stop_time))
@@ -781,7 +781,7 @@ lpfc_cleanup_wt_rrqs(struct lpfc_hba *ph
 		return;
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag &= ~HBA_RRQ_ACTIVE;
-	next_time = jiffies + HZ * (phba->fc_ratov * 2);
+	next_time = jiffies + msecs_to_jiffies(1000 * (phba->fc_ratov * 2));
 	list_splice_init(&phba->active_rrq_list, &rrq_list);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
@@ -877,7 +877,8 @@ lpfc_set_rrq_active(struct lpfc_hba *phb
 	else
 		rrq->send_rrq = 0;
 	rrq->xritag = xritag;
-	rrq->rrq_stop_time = jiffies + HZ * (phba->fc_ratov + 1);
+	rrq->rrq_stop_time = jiffies +
+				msecs_to_jiffies(1000 * (phba->fc_ratov + 1));
 	rrq->ndlp = ndlp;
 	rrq->nlp_DID = ndlp->nlp_DID;
 	rrq->vport = ndlp->vport;
@@ -1338,7 +1339,8 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba
 			BUG();
 		else
 			mod_timer(&piocb->vport->els_tmofunc,
-				  jiffies + HZ * (phba->fc_ratov << 1));
+				jiffies +
+				msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
 	}
 

@@ -2907,8 +2909,9 @@ void lpfc_poll_eratt(unsigned long ptr)
 		lpfc_worker_wake_up(phba);
 	else
 		/* Restart the timer for next eratt poll */
-		mod_timer(&phba->eratt_poll, jiffies +
-					HZ * LPFC_ERATT_POLL_INTERVAL);
+		mod_timer(&phba->eratt_poll,
+			  jiffies +
+			  msecs_to_jiffies(1000 * LPFC_ERATT_POLL_INTERVAL));
 	return;
 }
 
@@ -6447,16 +6450,17 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 
 	/* Start the ELS watchdog timer */
 	mod_timer(&vport->els_tmofunc,
-		  jiffies + HZ * (phba->fc_ratov * 2));
+		  jiffies + msecs_to_jiffies(1000 * (phba->fc_ratov * 2)));
 
 	/* Start heart beat timer */
 	mod_timer(&phba->hb_tmofunc,
-		  jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
+		  jiffies + msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
 	phba->hb_outstanding = 0;
 	phba->last_completion_time = jiffies;
 
 	/* Start error attention (ERATT) polling timer */
-	mod_timer(&phba->eratt_poll, jiffies + HZ * LPFC_ERATT_POLL_INTERVAL);
+	mod_timer(&phba->eratt_poll,
+		  jiffies + msecs_to_jiffies(1000 * LPFC_ERATT_POLL_INTERVAL));
 
 	/* Enable PCIe device Advanced Error Reporting (AER) if configured */
 	if (phba->cfg_aer_support == 1 && !(phba->hba_flag & HBA_AER_ENABLED)) {
@@ -6823,8 +6827,9 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 			goto out_not_finished;
 		}
 		/* timeout active mbox command */
-		mod_timer(&psli->mbox_tmo, (jiffies +
-			       (HZ * lpfc_mbox_tmo_val(phba, pmbox))));
+		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, pmbox) *
+					   1000);
+		mod_timer(&psli->mbox_tmo, jiffies + timeout);
 	}
 
 	/* Mailbox cmd <cmd> issue */
@@ -7497,7 +7502,7 @@ lpfc_sli4_post_async_mbox(struct lpfc_hb
 
 	/* Start timer for the mbox_tmo and log some mailbox post messages */
 	mod_timer(&psli->mbox_tmo, (jiffies +
-		  (HZ * lpfc_mbox_tmo_val(phba, mboxq))));
+		  msecs_to_jiffies(1000 * lpfc_mbox_tmo_val(phba, mboxq))));
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
 			"(%d):0355 Mailbox cmd x%x (x%x/x%x) issue Data: "
@@ -10004,7 +10009,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	retval = lpfc_sli_issue_iocb(phba, ring_number, piocb,
 				     SLI_IOCB_RET_IOCB);
 	if (retval == IOCB_SUCCESS) {
-		timeout_req = timeout * HZ;
+		timeout_req = msecs_to_jiffies(timeout * 1000);
 		timeleft = wait_event_timeout(done_q,
 				lpfc_chk_iocb_flg(phba, piocb, LPFC_IO_WAKE),
 				timeout_req);
@@ -10109,7 +10114,7 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 	if (retval == MBX_BUSY || retval == MBX_SUCCESS) {
 		wait_event_interruptible_timeout(done_q,
 				pmboxq->mbox_flag & LPFC_MBX_WAKE,
-				timeout * HZ);
+				msecs_to_jiffies(timeout * 1000));
 
 		spin_lock_irqsave(&phba->hbalock, flag);
 		pmboxq->context1 = NULL;



