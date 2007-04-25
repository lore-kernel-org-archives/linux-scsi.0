From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 10/16] lpfc 8.1.12 : Reference count node structures for
	node lifetime management
Date: Wed, 25 Apr 2007 09:53:01 -0400
Message-ID: <1177509181.23155.17.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51708 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031008AbXDYNwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:52:53 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDqqxP006642
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:52:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reference count node structures for node lifetime management.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:42.000000000 -0400
@@ -51,8 +51,9 @@ int lpfc_can_disctmo(struct lpfc_hba *);
 int lpfc_unreg_rpi(struct lpfc_hba *, struct lpfc_nodelist *);
 int lpfc_check_sli_ndlp(struct lpfc_hba *, struct lpfc_sli_ring *,
 		    struct lpfc_iocbq *, struct lpfc_nodelist *);
-int lpfc_nlp_remove(struct lpfc_hba *, struct lpfc_nodelist *);
 void lpfc_nlp_init(struct lpfc_hba *, struct lpfc_nodelist *, uint32_t);
+struct lpfc_nodelist *lpfc_nlp_get(struct lpfc_nodelist *);
+int  lpfc_nlp_put(struct lpfc_nodelist *);
 struct lpfc_nodelist *lpfc_setup_disc_node(struct lpfc_hba *, uint32_t);
 void lpfc_disc_list_loopmap(struct lpfc_hba *);
 void lpfc_disc_start(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2007-04-24 11:12:42.000000000 -0400
@@ -69,7 +69,6 @@ struct lpfc_nodelist {
 	uint16_t	nlp_maxframe;		/* Max RCV frame size */
 	uint8_t		nlp_class_sup;		/* Supported Classes */
 	uint8_t         nlp_retry;		/* used for ELS retries */
-	uint8_t         nlp_disc_refcnt;	/* used for DSM */
 	uint8_t         nlp_fcp_info;	        /* class info, bits 0-3 */
 #define NLP_FCP_2_DEVICE   0x10			/* FCP-2 device */
 
@@ -80,6 +79,7 @@ struct lpfc_nodelist {
 	struct lpfc_work_evt els_retry_evt;
 	unsigned long last_ramp_up_time;        /* jiffy of last ramp up */
 	unsigned long last_q_full_time;		/* jiffy of last queue full */
+	struct kref     kref;
 };
 
 /* Defines for nlp_flag (uint32) */
@@ -107,7 +107,6 @@ struct lpfc_nodelist {
 					   ACC */
 #define NLP_NPR_ADISC      0x2000000	/* Issue ADISC when dq'ed from
 					   NPR list */
-#define NLP_DELAY_REMOVE   0x4000000	/* Defer removal till end of DSM */
 #define NLP_NODEV_REMOVE   0x8000000	/* Defer removal till discovery ends */
 
 /* Defines for list searchs */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:42.000000000 -0400
@@ -209,9 +209,9 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 	}
 
 	/* Save for completion so we can release these resources */
-	elsiocb->context1 = (uint8_t *) ndlp;
-	elsiocb->context2 = (uint8_t *) pcmd;
-	elsiocb->context3 = (uint8_t *) pbuflist;
+	elsiocb->context1 = lpfc_nlp_get(ndlp);
+	elsiocb->context2 = pcmd;
+	elsiocb->context3 = pbuflist;
 	elsiocb->retry = retry;
 	elsiocb->drvrTimeout = (phba->fc_ratov << 1) + LPFC_DRVR_TIMEOUT;
 
@@ -305,7 +305,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_h
 		goto fail_free_mbox;
 
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_fabric_reg_login;
-	mbox->context2 = ndlp;
+	mbox->context2 = lpfc_nlp_get(ndlp);
 
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT | MBX_STOP_IOCB);
 	if (rc == MBX_NOT_FINISHED)
@@ -314,6 +314,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_h
 	return 0;
 
  fail_issue_reg_login:
+	lpfc_nlp_put(ndlp);
 	mp = (struct lpfc_dmabuf *) mbox->context1;
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
@@ -369,7 +370,7 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_hb
 			mempool_free(mbox, phba->mbox_mem_pool);
 			goto fail;
 		}
-		mempool_free(ndlp, phba->nlp_mem_pool);
+		lpfc_nlp_put(ndlp);
 
 		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, PT2PT_RemoteID);
 		if (!ndlp) {
@@ -392,7 +393,7 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_hb
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 	} else {
 		/* This side will wait for the PLOGI */
-		mempool_free( ndlp, phba->nlp_mem_pool);
+		lpfc_nlp_put(ndlp);
 	}
 
 	spin_lock_irq(phba->host->host_lock);
@@ -407,8 +408,8 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_hb
 }
 
 static void
-lpfc_cmpl_els_flogi(struct lpfc_hba * phba,
-		    struct lpfc_iocbq * cmdiocb, struct lpfc_iocbq * rspiocb)
+lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		    struct lpfc_iocbq *rspiocb)
 {
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_nodelist *ndlp = cmdiocb->context1;
@@ -418,7 +419,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba * ph
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(phba)) {
-		lpfc_nlp_remove(phba, ndlp);
+		lpfc_nlp_put(ndlp);
 		goto out;
 	}
 
@@ -433,13 +434,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba * ph
 		phba->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
 		spin_unlock_irq(phba->host->host_lock);
 
-		/* If private loop, then allow max outstandting els to be
+		/* If private loop, then allow max outstanding els to be
 		 * LPFC_MAX_DISC_THREADS (32). Scanning in the case of no
 		 * alpa map would take too long otherwise.
 		 */
 		if (phba->alpa_map[0] == 0) {
-			phba->cfg_discovery_threads =
-			    LPFC_MAX_DISC_THREADS;
+			phba->cfg_discovery_threads = LPFC_MAX_DISC_THREADS;
 		}
 
 		/* FLOGI failure */
@@ -484,7 +484,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba * ph
 	}
 
 flogifail:
-	lpfc_nlp_remove(phba, ndlp);
+	lpfc_nlp_put(ndlp);
 
 	if (irsp->ulpStatus != IOSTAT_LOCAL_REJECT ||
 	    (irsp->un.ulpWord[4] != IOERR_SLI_ABORTED &&
@@ -608,7 +608,7 @@ lpfc_initial_flogi(struct lpfc_hba * phb
 		lpfc_dequeue_node(phba, ndlp);
 	}
 	if (lpfc_issue_els_flogi(phba, ndlp, 0)) {
-		mempool_free( ndlp, phba->nlp_mem_pool);
+		lpfc_nlp_put(ndlp);
 	}
 	return 1;
 }
@@ -1334,7 +1334,7 @@ lpfc_issue_els_scr(struct lpfc_hba * phb
 	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
 						ndlp->nlp_DID, ELS_CMD_SCR);
 	if (!elsiocb) {
-		mempool_free( ndlp, phba->nlp_mem_pool);
+		lpfc_nlp_put(ndlp);
 		return 1;
 	}
 
@@ -1353,12 +1353,12 @@ lpfc_issue_els_scr(struct lpfc_hba * phb
 	spin_lock_irq(phba->host->host_lock);
 	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
 		spin_unlock_irq(phba->host->host_lock);
-		mempool_free( ndlp, phba->nlp_mem_pool);
+		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
 	spin_unlock_irq(phba->host->host_lock);
-	mempool_free( ndlp, phba->nlp_mem_pool);
+	lpfc_nlp_put(ndlp);
 	return 0;
 }
 
@@ -1387,7 +1387,7 @@ lpfc_issue_els_farpr(struct lpfc_hba * p
 	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, ndlp,
 						ndlp->nlp_DID, ELS_CMD_RNID);
 	if (!elsiocb) {
-		mempool_free( ndlp, phba->nlp_mem_pool);
+		lpfc_nlp_put(ndlp);
 		return 1;
 	}
 
@@ -1420,12 +1420,12 @@ lpfc_issue_els_farpr(struct lpfc_hba * p
 	spin_lock_irq(phba->host->host_lock);
 	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
 		spin_unlock_irq(phba->host->host_lock);
-		mempool_free( ndlp, phba->nlp_mem_pool);
+		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
 	spin_unlock_irq(phba->host->host_lock);
-	mempool_free( ndlp, phba->nlp_mem_pool);
+	lpfc_nlp_put(ndlp);
 	return 0;
 }
 
@@ -1590,7 +1590,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 		cmd = *elscmd++;
 	}
 
-	if(ndlp)
+	if (ndlp)
 		did = ndlp->nlp_DID;
 	else {
 		/* We should only hit this case for retrying PLOGI */
@@ -1768,10 +1768,14 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 }
 
 int
-lpfc_els_free_iocb(struct lpfc_hba * phba, struct lpfc_iocbq * elsiocb)
+lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 {
 	struct lpfc_dmabuf *buf_ptr, *buf_ptr1;
 
+	if (elsiocb->context1) {
+		lpfc_nlp_put(elsiocb->context1);
+		elsiocb->context1 = NULL;
+	}
 	/* context2  = cmd,  context2->next = rsp, context3 = bpl */
 	if (elsiocb->context2) {
 		buf_ptr1 = (struct lpfc_dmabuf *) elsiocb->context2;
@@ -1828,8 +1832,8 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 }
 
 static void
-lpfc_cmpl_els_acc(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
-		  struct lpfc_iocbq * rspiocb)
+lpfc_cmpl_els_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		  struct lpfc_iocbq *rspiocb)
 {
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
@@ -1844,14 +1848,14 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 

 	/* Check to see if link went down during discovery */
-	if ((lpfc_els_chk_latt(phba)) || !ndlp) {
+	if (lpfc_els_chk_latt(phba) || !ndlp) {
 		if (mbox) {
 			mp = (struct lpfc_dmabuf *) mbox->context1;
 			if (mp) {
 				lpfc_mbuf_free(phba, mp->virt, mp->phys);
 				kfree(mp);
 			}
-			mempool_free( mbox, phba->mbox_mem_pool);
+			mempool_free(mbox, phba->mbox_mem_pool);
 		}
 		goto out;
 	}
@@ -1871,7 +1875,7 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 		    && (ndlp->nlp_flag & NLP_ACC_REGLOGIN)) {
 			lpfc_unreg_rpi(phba, ndlp);
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
-			mbox->context2 = ndlp;
+			mbox->context2 = lpfc_nlp_get(ndlp);
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			lpfc_nlp_set_state(phba, ndlp, NLP_STE_REG_LOGIN_ISSUE);
 			if (lpfc_sli_issue_mbox(phba, mbox,
@@ -1879,6 +1883,7 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 			    != MBX_NOT_FINISHED) {
 				goto out;
 			}
+			lpfc_nlp_put(ndlp);
 			/* NOTE: we should have messages for unsuccessful
 			   reglogin */
 		} else {
@@ -1983,8 +1988,10 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 		return 1;
 	}
 
-	if (newnode)
+	if (newnode) {
+		lpfc_nlp_put(ndlp);
 		elsiocb->context1 = NULL;
+	}
 
 	/* Xmit ELS ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
@@ -2201,9 +2208,8 @@ lpfc_els_rsp_prli_acc(struct lpfc_hba *p
 }
 
 static int
-lpfc_els_rsp_rnid_acc(struct lpfc_hba * phba,
-		      uint8_t format,
-		      struct lpfc_iocbq * oldiocb, struct lpfc_nodelist * ndlp)
+lpfc_els_rsp_rnid_acc(struct lpfc_hba *phba, uint8_t format,
+		      struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp)
 {
 	RNID *rn;
 	IOCB_t *icmd;
@@ -2270,6 +2276,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_hba * 
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_acc;
+	lpfc_nlp_put(ndlp);
 	elsiocb->context1 = NULL;  /* Don't need ndlp for cmpl,
 				    * it could be freed */
 
@@ -2447,7 +2454,7 @@ lpfc_rscn_payload_check(struct lpfc_hba 
 }
 
 static int
-lpfc_rscn_recovery_check(struct lpfc_hba * phba)
+lpfc_rscn_recovery_check(struct lpfc_hba *phba)
 {
 	struct lpfc_nodelist *ndlp = NULL, *next_ndlp;
 	struct list_head *listp;
@@ -2703,7 +2710,7 @@ lpfc_els_rcv_flogi(struct lpfc_hba * phb
 				(phba, mbox, (MBX_NOWAIT | MBX_STOP_IOCB));
 			lpfc_set_loopback_flag(phba);
 			if (rc == MBX_NOT_FINISHED) {
-				mempool_free( mbox, phba->mbox_mem_pool);
+				mempool_free(mbox, phba->mbox_mem_pool);
 			}
 			return 1;
 		} else if (rc > 0) {	/* greater than */
@@ -2768,8 +2775,8 @@ lpfc_els_rcv_rnid(struct lpfc_hba * phba
 }
 
 static int
-lpfc_els_rcv_lirr(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
-		 struct lpfc_nodelist * ndlp)
+lpfc_els_rcv_lirr(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		 struct lpfc_nodelist *ndlp)
 {
 	struct ls_rjt stat;
 
@@ -2783,7 +2790,7 @@ lpfc_els_rcv_lirr(struct lpfc_hba * phba
 }
 
 static void
-lpfc_els_rsp_rps_acc(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
+lpfc_els_rsp_rps_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
@@ -2806,14 +2813,15 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba * p
 	pmb->context2 = NULL;
 
 	if (mb->mbxStatus) {
-		mempool_free( pmb, phba->mbox_mem_pool);
+		mempool_free(pmb, phba->mbox_mem_pool);
 		return;
 	}
 
 	cmdsize = sizeof(RPS_RSP) + sizeof(uint32_t);
-	mempool_free( pmb, phba->mbox_mem_pool);
+	mempool_free(pmb, phba->mbox_mem_pool);
 	elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, lpfc_max_els_tries, ndlp,
 						ndlp->nlp_DID, ELS_CMD_ACC);
+	lpfc_nlp_put(ndlp);
 	if (!elsiocb)
 		return;
 
@@ -2890,13 +2898,14 @@ lpfc_els_rcv_rps(struct lpfc_hba * phba,
 			lpfc_read_lnk_stat(phba, mbox);
 			mbox->context1 =
 			    (void *)((unsigned long)cmdiocb->iocb.ulpContext);
-			mbox->context2 = ndlp;
+			mbox->context2 = lpfc_nlp_get(ndlp);
 			mbox->mbox_cmpl = lpfc_els_rsp_rps_acc;
 			if (lpfc_sli_issue_mbox (phba, mbox,
 			    (MBX_NOWAIT | MBX_STOP_IOCB)) != MBX_NOT_FINISHED) {
 				/* Mbox completion will send ELS Response */
 				return 0;
 			}
+			lpfc_nlp_put(ndlp);
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
 	}
@@ -3281,14 +3290,13 @@ lpfc_els_timeout_handler(struct lpfc_hba
 }
 
 void
-lpfc_els_flush_cmd(struct lpfc_hba * phba)
+lpfc_els_flush_cmd(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
-	struct lpfc_sli_ring *pring;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	IOCB_t *cmd = NULL;
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
 	spin_lock_irq(phba->host->host_lock);
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txq, list) {
 		cmd = &piocb->iocb;
@@ -3298,12 +3306,11 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 		}
 
 		/* Do not flush out the QUE_RING and ABORT/CLOSE iocbs */
-		if ((cmd->ulpCommand == CMD_QUE_RING_BUF_CN) ||
-		    (cmd->ulpCommand == CMD_QUE_RING_BUF64_CN) ||
-		    (cmd->ulpCommand == CMD_CLOSE_XRI_CN) ||
-		    (cmd->ulpCommand == CMD_ABORT_XRI_CN)) {
+		if (cmd->ulpCommand == CMD_QUE_RING_BUF_CN ||
+		    cmd->ulpCommand == CMD_QUE_RING_BUF64_CN ||
+		    cmd->ulpCommand == CMD_CLOSE_XRI_CN ||
+		    cmd->ulpCommand == CMD_ABORT_XRI_CN)
 			continue;
-		}
 
 		list_move_tail(&piocb->list, &completions);
 		pring->txq_cnt--;
@@ -3422,7 +3429,9 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	}
 
 	phba->fc_stat.elsRcvFrame++;
-	elsiocb->context1 = ndlp;
+	if (elsiocb->context1)
+		lpfc_nlp_put(elsiocb->context1);
+	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	elsiocb->context2 = mp;
 
 	if ((cmd & ELS_CMD_MASK) == ELS_CMD_RSCN) {
@@ -3553,6 +3562,8 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 		lpfc_els_rsp_reject(phba, stat.un.lsRjtError, elsiocb, ndlp);
 	}
 
+	lpfc_nlp_put(elsiocb->context1);
+	elsiocb->context1 = NULL;
 	if (elsiocb->context2) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:42.000000000 -0400
@@ -158,6 +158,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 	else {
 		rdata->pnode = NULL;
 		ndlp->rport = NULL;
+		lpfc_nlp_put(ndlp);
+		put_device(&rport->dev);
 	}
 
 	return;
@@ -960,6 +962,7 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba 
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free( pmb, phba->mbox_mem_pool);
+	lpfc_nlp_put(ndlp);
 
 	return;
 }
@@ -986,11 +989,14 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	ndlp = (struct lpfc_nodelist *) pmb->context2;
 	mp = (struct lpfc_dmabuf *) (pmb->context1);
 
+	pmb->context1 = NULL;
+	pmb->context2 = NULL;
+
 	if (mb->mbxStatus) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
-		mempool_free( pmb, phba->mbox_mem_pool);
-		mempool_free( ndlp, phba->nlp_mem_pool);
+		mempool_free(pmb, phba->mbox_mem_pool);
+		lpfc_nlp_put(ndlp);
 
 		/* FLOGI failed, so just use loop map to make discovery list */
 		lpfc_disc_list_loopmap(phba);
@@ -1000,12 +1006,12 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		return;
 	}
 
-	pmb->context1 = NULL;
-
 	ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(phba, ndlp, NLP_STE_UNMAPPED_NODE);
 
+	lpfc_nlp_put(ndlp);	/* Drop the reference from the mbox */
+
 	if (phba->hba_state == LPFC_FABRIC_CFG_LINK) {
 		/* This NPort has been assigned an NPort_ID by the fabric as a
 		 * result of the completed fabric login.  Issue a State Change
@@ -1027,7 +1033,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 				lpfc_disc_start(phba);
 				lpfc_mbuf_free(phba, mp->virt, mp->phys);
 				kfree(mp);
-				mempool_free( pmb, phba->mbox_mem_pool);
+				mempool_free(pmb, phba->mbox_mem_pool);
 				return;
 			} else {
 				lpfc_nlp_init(phba, ndlp, NameServer_DID);
@@ -1050,7 +1056,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
-	mempool_free( pmb, phba->mbox_mem_pool);
+	mempool_free(pmb, phba->mbox_mem_pool);
 	return;
 }
 
@@ -1075,6 +1081,7 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 	mp = (struct lpfc_dmabuf *) (pmb->context1);
 
 	if (mb->mbxStatus) {
+		lpfc_nlp_put(ndlp);
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
 		mempool_free(pmb, phba->mbox_mem_pool);
@@ -1110,6 +1117,7 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 		lpfc_disc_start(phba);
 	}
 
+	lpfc_nlp_put(ndlp);
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free( pmb, phba->mbox_mem_pool);
@@ -1118,8 +1126,7 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 }
 
 static void
-lpfc_register_remote_port(struct lpfc_hba * phba,
-			    struct lpfc_nodelist * ndlp)
+lpfc_register_remote_port(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	struct fc_rport *rport;
 	struct lpfc_rport_data *rdata;
@@ -1131,8 +1138,19 @@ lpfc_register_remote_port(struct lpfc_hb
 	rport_ids.port_id = ndlp->nlp_DID;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
+	/*
+	 * We leave our node pointer in rport->dd_data when we unregister a
+	 * FCP target port.  But fc_remote_port_add zeros the space to which
+	 * rport->dd_data points.  So, if we're reusing a previously
+	 * registered port, drop the reference that we took the last time we
+	 * registered the port.
+	 */
+	if (ndlp->rport && ndlp->rport->dd_data &&
+	    *(struct lpfc_rport_data **) ndlp->rport->dd_data) {
+		lpfc_nlp_put(ndlp);
+	}
 	ndlp->rport = rport = fc_remote_port_add(phba->host, 0, &rport_ids);
-	if (!rport) {
+	if (!rport || !get_device(&rport->dev)) {
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
 			   "Warning: fc_remote_port_add failed\n");
 		return;
@@ -1142,7 +1160,7 @@ lpfc_register_remote_port(struct lpfc_hb
 	rport->maxframe_size = ndlp->nlp_maxframe;
 	rport->supported_classes = ndlp->nlp_class_sup;
 	rdata = rport->dd_data;
-	rdata->pnode = ndlp;
+	rdata->pnode = lpfc_nlp_get(ndlp);
 
 	if (ndlp->nlp_type & NLP_FCP_TARGET)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
@@ -1162,8 +1180,7 @@ lpfc_register_remote_port(struct lpfc_hb
 }
 
 static void
-lpfc_unregister_remote_port(struct lpfc_hba * phba,
-			    struct lpfc_nodelist * ndlp)
+lpfc_unregister_remote_port(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	struct fc_rport *rport = ndlp->rport;
 	struct lpfc_rport_data *rdata = rport->dd_data;
@@ -1171,6 +1188,8 @@ lpfc_unregister_remote_port(struct lpfc_
 	if (rport->scsi_target_id == -1) {
 		ndlp->rport = NULL;
 		rdata->pnode = NULL;
+		lpfc_nlp_put(ndlp);
+		put_device(&rport->dev);
 	}
 
 	fc_remote_port_delete(rport);
@@ -1416,7 +1435,7 @@ lpfc_drop_node(struct lpfc_hba *phba, st
 		lpfc_nlp_counters(phba, ndlp->nlp_state, -1);
 	lpfc_delink_node(phba, ndlp);
 	spin_unlock_irq(phba->host->host_lock);
-	lpfc_nlp_remove(phba, ndlp);
+	lpfc_nlp_put(ndlp);
 }
 
 /*
@@ -1654,6 +1673,7 @@ lpfc_freenode(struct lpfc_hba * phba, st
 			}
 			list_del(&mb->list);
 			mempool_free(mb, phba->mbox_mem_pool);
+			lpfc_nlp_put(ndlp);
 		}
 	}
 	spin_unlock_irq(phba->host->host_lock);
@@ -1679,8 +1699,8 @@ lpfc_freenode(struct lpfc_hba * phba, st
  * If we are in the middle of using the nlp in the discovery state
  * machine, defer the free till we reach the end of the state machine.
  */
-int
-lpfc_nlp_remove(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
+static void
+lpfc_nlp_remove(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_rport_data *rdata;
 
@@ -1688,22 +1708,14 @@ lpfc_nlp_remove(struct lpfc_hba * phba, 
 		lpfc_cancel_retry_delay_tmo(phba, ndlp);
 	}
 
-	if (ndlp->nlp_disc_refcnt) {
-		spin_lock_irq(phba->host->host_lock);
-		ndlp->nlp_flag |= NLP_DELAY_REMOVE;
-		spin_unlock_irq(phba->host->host_lock);
-	} else {
-		lpfc_freenode(phba, ndlp);
-
-		if ((ndlp->rport) && !(phba->fc_flag & FC_UNLOADING)) {
-			rdata = ndlp->rport->dd_data;
-			rdata->pnode = NULL;
-			ndlp->rport = NULL;
-		}
+	lpfc_freenode(phba, ndlp);
 
-		mempool_free( ndlp, phba->nlp_mem_pool);
+	if ((ndlp->rport) && !(phba->fc_flag & FC_UNLOADING)) {
+		put_device(&ndlp->rport->dev);
+		rdata = ndlp->rport->dd_data;
+		rdata->pnode = NULL;
+		ndlp->rport = NULL;
 	}
-	return 0;
 }
 
 static int
@@ -2069,14 +2081,14 @@ lpfc_disc_flush_list(struct lpfc_hba * p
 		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_plogi_list,
 					nlp_listp) {
 			lpfc_free_tx(phba, ndlp);
-			lpfc_nlp_remove(phba, ndlp);
+			lpfc_nlp_put(ndlp);
 		}
 	}
 	if (phba->fc_adisc_cnt) {
 		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_adisc_list,
 					nlp_listp) {
 			lpfc_free_tx(phba, ndlp);
-			lpfc_nlp_remove(phba, ndlp);
+			lpfc_nlp_put(ndlp);
 		}
 	}
 	return;
@@ -2195,7 +2207,7 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 		/* Next look for NameServer ndlp */
 		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, NameServer_DID);
 		if (ndlp)
-			lpfc_nlp_remove(phba, ndlp);
+			lpfc_nlp_put(ndlp);
 		/* Start discovery */
 		lpfc_disc_start(phba);
 		break;
@@ -2373,9 +2385,11 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 		mod_timer(&phba->fc_fdmitmo, jiffies + HZ * 60);
 	}
 
+				/* Mailbox took a reference to the node */
+	lpfc_nlp_put(ndlp);
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
-	mempool_free( pmb, phba->mbox_mem_pool);
+	mempool_free(pmb, phba->mbox_mem_pool);
 
 	return;
 }
@@ -2460,8 +2474,7 @@ lpfc_findnode_wwpn(struct lpfc_hba * phb
 }
 
 void
-lpfc_nlp_init(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp,
-		 uint32_t did)
+lpfc_nlp_init(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp, uint32_t did)
 {
 	memset(ndlp, 0, sizeof (struct lpfc_nodelist));
 	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
@@ -2471,5 +2484,29 @@ lpfc_nlp_init(struct lpfc_hba * phba, st
 	ndlp->nlp_DID = did;
 	ndlp->nlp_phba = phba;
 	ndlp->nlp_sid = NLP_NO_SID;
+	kref_init(&ndlp->kref);
 	return;
 }
+
+void
+lpfc_nlp_release(struct kref *kref)
+{
+	struct lpfc_nodelist *ndlp = container_of(kref, struct lpfc_nodelist,
+						  kref);
+	lpfc_nlp_remove(ndlp->nlp_phba, ndlp);
+	mempool_free(ndlp, ndlp->nlp_phba->nlp_mem_pool);
+}
+
+struct lpfc_nodelist *
+lpfc_nlp_get(struct lpfc_nodelist *ndlp)
+{
+	if (ndlp)
+		kref_get(&ndlp->kref);
+	return ndlp;
+}
+
+int
+lpfc_nlp_put(struct lpfc_nodelist *ndlp)
+{
+	return ndlp ? kref_put(&ndlp->kref, lpfc_nlp_release) : 0;
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:42.000000000 -0400
@@ -1187,12 +1187,12 @@ lpfc_cleanup(struct lpfc_hba * phba)
 	lpfc_can_disctmo(phba);
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nlpunmap_list,
 				nlp_listp) {
-		lpfc_nlp_remove(phba, ndlp);
+		lpfc_nlp_put(ndlp);
 	}
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nlpmap_list,
 				 nlp_listp) {
-		lpfc_nlp_remove(phba, ndlp);
+		lpfc_nlp_put(ndlp);
 	}
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_unused_list,
@@ -1202,27 +1202,27 @@ lpfc_cleanup(struct lpfc_hba * phba)
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_plogi_list,
 				nlp_listp) {
-		lpfc_nlp_remove(phba, ndlp);
+		lpfc_nlp_put(ndlp);
 	}
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_adisc_list,
 				nlp_listp) {
-		lpfc_nlp_remove(phba, ndlp);
+		lpfc_nlp_put(ndlp);
 	}
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_reglogin_list,
 				nlp_listp) {
-		lpfc_nlp_remove(phba, ndlp);
+		lpfc_nlp_put(ndlp);
 	}
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_prli_list,
 				nlp_listp) {
-		lpfc_nlp_remove(phba, ndlp);
+		lpfc_nlp_put(ndlp);
 	}
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
 				nlp_listp) {
-		lpfc_nlp_remove(phba, ndlp);
+		lpfc_nlp_put(ndlp);
 	}
 
 	INIT_LIST_HEAD(&phba->fc_nlpmap_list);
@@ -1510,7 +1510,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	INIT_LIST_HEAD(&phba->fc_prli_list);
 	INIT_LIST_HEAD(&phba->fc_npr_list);
 
-
 	pci_set_master(pdev);
 	retval = pci_set_mwi(pdev);
 	if (retval)
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-04-24 11:12:42.000000000 -0400
@@ -353,7 +353,10 @@ lpfc_rcv_plogi(struct lpfc_hba * phba,
 	 * queue this mbox command to be processed later.
 	 */
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
-	mbox->context2  = ndlp;
+	/*
+	 * mbox->context2 = lpfc_nlp_get(ndlp) deferred until mailbox
+	 * command issued in lpfc_cmpl_els_acc().
+	 */
 	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
 
 	/*
@@ -773,13 +776,14 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 		default:
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 		}
-		mbox->context2 = ndlp;
+		mbox->context2 = lpfc_nlp_get(ndlp);
 		if (lpfc_sli_issue_mbox(phba, mbox,
 					(MBX_NOWAIT | MBX_STOP_IOCB))
 		    != MBX_NOT_FINISHED) {
 			lpfc_nlp_set_state(phba, ndlp, NLP_STE_REG_LOGIN_ISSUE);
 			return ndlp->nlp_state;
 		}
+		lpfc_nlp_put(ndlp);
 		mp = (struct lpfc_dmabuf *)mbox->context1;
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
@@ -1920,7 +1924,7 @@ lpfc_disc_state_machine(struct lpfc_hba 
 	uint32_t(*func) (struct lpfc_hba *, struct lpfc_nodelist *, void *,
 			 uint32_t);
 
-	ndlp->nlp_disc_refcnt++;
+	lpfc_nlp_get(ndlp);
 	cur_state = ndlp->nlp_state;
 
 	/* DSM in event <evt> on NPort <nlp_DID> in state <cur_state> */
@@ -1943,18 +1947,7 @@ lpfc_disc_state_machine(struct lpfc_hba 
 		       phba->brd_no,
 		       rc, ndlp->nlp_DID, ndlp->nlp_flag);
 
-	ndlp->nlp_disc_refcnt--;
+	lpfc_nlp_put(ndlp);
 
-	/* Check to see if ndlp removal is deferred */
-	if ((ndlp->nlp_disc_refcnt == 0)
-	    && (ndlp->nlp_flag & NLP_DELAY_REMOVE)) {
-		spin_lock_irq(phba->host->host_lock);
-		ndlp->nlp_flag &= ~NLP_DELAY_REMOVE;
-		spin_unlock_irq(phba->host->host_lock);
-		lpfc_nlp_remove(phba, ndlp);
-		return NLP_STE_FREED_NODE;
-	}
-	if (rc == NLP_STE_FREED_NODE)
-		return NLP_STE_FREED_NODE;
 	return rc;
 }


