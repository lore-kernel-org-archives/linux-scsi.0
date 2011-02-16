From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6] lpfc 8.3.21: RRQ Implementation fixes
Date: Wed, 16 Feb 2011 12:39:35 -0500
Message-ID: <1297877976.1492.21.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:7544 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753721Ab1BPRjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2011 12:39:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

RRQ Implementation fixes

- Added checks to prevent a call to findnode_did in clr_active_rrq
- Added the del_sync_timer call for the rrq_tmr to the stop_hba_timers routine.
- Added a check in __lpfc_set_active_rrq for the driver unloading to prevent
  adding an rrq when the driver is being removed.
- Add code to scsi_iocb_cmpl to check for the remote stop and add the rrq.
- Added the same check to els retry.
- Added code to compare the source did in the els rrq to the vports did and
  chose the right exchange ID.
- Initialize the start_cmd pointer to indicate when we have looped through
  all of the scsi buffers.
- Remove the need for the lock around the clearing of the active bit in the
  rrq.
- Added code to clean the els and fcp xri aborted list and remove the all of
  the RRQs for a deleted vport.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h    |    2 
 lpfc_els.c     |   52 +++++++++++++--
 lpfc_hbadisc.c |    6 +
 lpfc_init.c    |   13 ++-
 lpfc_scsi.c    |   77 ++++++++++++++++------
 lpfc_sli.c     |  191 ++++++++++++++++++++++++++-------------------------------
 lpfc_sli4.h    |    2 
 7 files changed, 205 insertions(+), 138 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-02-16 11:23:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-02-16 11:25:15.000000000 -0500
@@ -423,6 +423,6 @@ int lpfc_send_rrq(struct lpfc_hba *, str
 int lpfc_set_rrq_active(struct lpfc_hba *, struct lpfc_nodelist *,
 	uint16_t, uint16_t, uint16_t);
 void lpfc_cleanup_wt_rrqs(struct lpfc_hba *);
-void lpfc_cleanup_vports_rrqs(struct lpfc_vport *);
+void lpfc_cleanup_vports_rrqs(struct lpfc_vport *, struct lpfc_nodelist *);
 struct lpfc_node_rrq *lpfc_get_active_rrq(struct lpfc_vport *, uint16_t,
 	uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-02-16 11:23:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-02-16 11:25:15.000000000 -0500
@@ -2816,9 +2816,17 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 
 	switch (irsp->ulpStatus) {
 	case IOSTAT_FCP_RSP_ERROR:
+		break;
 	case IOSTAT_REMOTE_STOP:
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			/* This IO was aborted by the target, we don't
+			 * know the rxid and because we did not send the
+			 * ABTS we cannot generate and RRQ.
+			 */
+			lpfc_set_rrq_active(phba, ndlp,
+					 cmdiocb->sli4_xritag, 0, 0);
+		}
 		break;
-
 	case IOSTAT_LOCAL_REJECT:
 		switch ((irsp->un.ulpWord[4] & 0xff)) {
 		case IOERR_LOOP_OPEN_FAILURE:
@@ -4014,28 +4022,34 @@ lpfc_els_clear_rrq(struct lpfc_vport *vp
 	uint8_t *pcmd;
 	struct RRQ *rrq;
 	uint16_t rxid;
+	uint16_t xri;
 	struct lpfc_node_rrq *prrq;
 
 
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) iocb->context2)->virt);
 	pcmd += sizeof(uint32_t);
 	rrq = (struct RRQ *)pcmd;
-	rxid = bf_get(rrq_oxid, rrq);
+	rrq->rrq_exchg = be32_to_cpu(rrq->rrq_exchg);
+	rxid = be16_to_cpu(bf_get(rrq_rxid, rrq));
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			"2883 Clear RRQ for SID:x%x OXID:x%x RXID:x%x"
 			" x%x x%x\n",
-			bf_get(rrq_did, rrq),
-			bf_get(rrq_oxid, rrq),
+			be32_to_cpu(bf_get(rrq_did, rrq)),
+			be16_to_cpu(bf_get(rrq_oxid, rrq)),
 			rxid,
 			iocb->iotag, iocb->iocb.ulpContext);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"Clear RRQ:  did:x%x flg:x%x exchg:x%.08x",
 		ndlp->nlp_DID, ndlp->nlp_flag, rrq->rrq_exchg);
-	prrq = lpfc_get_active_rrq(vport, rxid, ndlp->nlp_DID);
+	if (vport->fc_myDID == be32_to_cpu(bf_get(rrq_did, rrq)))
+		xri = be16_to_cpu(bf_get(rrq_oxid, rrq));
+	else
+		xri = rxid;
+	prrq = lpfc_get_active_rrq(vport, xri, ndlp->nlp_DID);
 	if (prrq)
-		lpfc_clr_rrq_active(phba, rxid, prrq);
+		lpfc_clr_rrq_active(phba, xri, prrq);
 	return;
 }
 
@@ -7583,6 +7597,32 @@ void lpfc_fabric_abort_hba(struct lpfc_h
 }
 
 /**
+ * lpfc_sli4_vport_delete_els_xri_aborted -Remove all ndlp references for vport
+ * @vport: pointer to lpfc vport data structure.
+ *
+ * This routine is invoked by the vport cleanup for deletions and the cleanup
+ * for an ndlp on removal.
+ **/
+void
+lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
+	unsigned long iflag = 0;
+
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	list_for_each_entry_safe(sglq_entry, sglq_next,
+			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
+		if (sglq_entry->ndlp && sglq_entry->ndlp->vport == vport)
+			sglq_entry->ndlp = NULL;
+	}
+	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	return;
+}
+
+/**
  * lpfc_sli4_els_xri_aborted - Slow-path process of els xri abort
  * @phba: pointer to lpfc hba data structure.
  * @axri: pointer to the els xri abort wcqe structure.
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-02-16 11:23:50.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-02-16 11:25:15.000000000 -0500
@@ -3160,7 +3160,7 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba 
 	spin_unlock_irq(shost->host_lock);
 	vport->unreg_vpi_cmpl = VPORT_OK;
 	mempool_free(pmb, phba->mbox_mem_pool);
-	lpfc_cleanup_vports_rrqs(vport);
+	lpfc_cleanup_vports_rrqs(vport, NULL);
 	/*
 	 * This shost reference might have been taken at the beginning of
 	 * lpfc_vport_delete()
@@ -3900,6 +3900,8 @@ lpfc_drop_node(struct lpfc_vport *vport,
 	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 		return;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
+	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+		lpfc_cleanup_vports_rrqs(vport, ndlp);
 	lpfc_nlp_put(ndlp);
 	return;
 }
@@ -4289,7 +4291,7 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 
 	list_del_init(&ndlp->els_retry_evt.evt_listp);
 	list_del_init(&ndlp->dev_loss_evt.evt_listp);
-
+	lpfc_cleanup_vports_rrqs(vport, ndlp);
 	lpfc_unreg_rpi(vport, ndlp);
 
 	return 0;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-02-16 11:23:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-02-16 11:25:15.000000000 -0500
@@ -945,17 +945,13 @@ static void
 lpfc_rrq_timeout(unsigned long ptr)
 {
 	struct lpfc_hba *phba;
-	uint32_t tmo_posted;
 	unsigned long iflag;
 
 	phba = (struct lpfc_hba *)ptr;
 	spin_lock_irqsave(&phba->pport->work_port_lock, iflag);
-	tmo_posted = phba->hba_flag & HBA_RRQ_ACTIVE;
-	if (!tmo_posted)
-		phba->hba_flag |= HBA_RRQ_ACTIVE;
+	phba->hba_flag |= HBA_RRQ_ACTIVE;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflag);
-	if (!tmo_posted)
-		lpfc_worker_wake_up(phba);
+	lpfc_worker_wake_up(phba);
 }
 
 /**
@@ -2280,6 +2276,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		/* Wait for any activity on ndlps to settle */
 		msleep(10);
 	}
+	lpfc_cleanup_vports_rrqs(vport, NULL);
 }
 
 /**
@@ -2355,6 +2352,10 @@ lpfc_stop_hba_timers(struct lpfc_hba *ph
 	del_timer_sync(&phba->fabric_block_timer);
 	del_timer_sync(&phba->eratt_poll);
 	del_timer_sync(&phba->hb_tmofunc);
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		del_timer_sync(&phba->rrq_tmr);
+		phba->hba_flag &= ~HBA_RRQ_ACTIVE;
+	}
 	phba->hb_outstanding = 0;
 
 	switch (phba->pci_dev_grp) {
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2011-02-16 11:23:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-02-16 11:25:15.000000000 -0500
@@ -609,6 +609,32 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *
 }
 
 /**
+ * lpfc_sli4_vport_delete_fcp_xri_aborted -Remove all ndlp references for vport
+ * @vport: pointer to lpfc vport data structure.
+ *
+ * This routine is invoked by the vport cleanup for deletions and the cleanup
+ * for an ndlp on removal.
+ **/
+void
+lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_scsi_buf *psb, *next_psb;
+	unsigned long iflag = 0;
+
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	list_for_each_entry_safe(psb, next_psb,
+				&phba->sli4_hba.lpfc_abts_scsi_buf_list, list) {
+		if (psb->rdata && psb->rdata->pnode
+			&& psb->rdata->pnode->vport == vport)
+			psb->rdata = NULL;;
+	}
+	spin_unlock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+}
+
+/**
  * lpfc_sli4_fcp_xri_aborted - Fast-path process of fcp xri abort
  * @phba: pointer to lpfc hba data structure.
  * @axri: pointer to the fcp xri abort wcqe structure.
@@ -640,7 +666,11 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hb
 			psb->status = IOSTAT_SUCCESS;
 			spin_unlock(
 				&phba->sli4_hba.abts_scsi_buf_list_lock);
-			ndlp = psb->rdata->pnode;
+			if (psb->rdata && psb->rdata->pnode)
+				ndlp = psb->rdata->pnode;
+			else
+				ndlp = NULL;
+
 			rrq_empty = list_empty(&phba->active_rrq_list);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			if (ndlp)
@@ -964,36 +994,29 @@ lpfc_get_scsi_buf_s3(struct lpfc_hba *ph
 static struct lpfc_scsi_buf*
 lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
-	struct  lpfc_scsi_buf *lpfc_cmd = NULL;
-	struct  lpfc_scsi_buf *start_lpfc_cmd = NULL;
-	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
+	struct lpfc_scsi_buf *lpfc_cmd ;
 	unsigned long iflag = 0;
 	int found = 0;
 
 	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
-	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
-	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
-	while (!found && lpfc_cmd) {
+	list_for_each_entry(lpfc_cmd, &phba->lpfc_scsi_buf_list,
+							list) {
 		if (lpfc_test_rrq_active(phba, ndlp,
-					 lpfc_cmd->cur_iocbq.sli4_xritag)) {
-			lpfc_release_scsi_buf_s4(phba, lpfc_cmd);
-			spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
-			list_remove_head(scsi_buf_list, lpfc_cmd,
-					 struct lpfc_scsi_buf, list);
-			spin_unlock_irqrestore(&phba->scsi_buf_list_lock,
-						 iflag);
-			if (lpfc_cmd == start_lpfc_cmd) {
-				lpfc_cmd = NULL;
-				break;
-			} else
-				continue;
-		}
+					 lpfc_cmd->cur_iocbq.sli4_xritag))
+			continue;
+		list_del(&lpfc_cmd->list);
 		found = 1;
 		lpfc_cmd->seg_cnt = 0;
 		lpfc_cmd->nonsg_phys = 0;
 		lpfc_cmd->prot_seg_cnt = 0;
+		break;
 	}
-	return  lpfc_cmd;
+	spin_unlock_irqrestore(&phba->scsi_buf_list_lock,
+						 iflag);
+	if (!found)
+		return NULL;
+	else
+		return  lpfc_cmd;
 }
 /**
  * lpfc_get_scsi_buf - Get a scsi buffer from lpfc_scsi_buf_list of the HBA
@@ -2484,6 +2507,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			lpfc_worker_wake_up(phba);
 			break;
 		case IOSTAT_LOCAL_REJECT:
+		case IOSTAT_REMOTE_STOP:
 			if (lpfc_cmd->result == IOERR_INVALID_RPI ||
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
@@ -2510,6 +2534,17 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 							"on unprotected cmd\n");
 				}
 			}
+			if ((lpfc_cmd->status == IOSTAT_REMOTE_STOP)
+				&& (phba->sli_rev == LPFC_SLI_REV4)
+				&& (pnode && NLP_CHK_NODE_ACT(pnode))) {
+				/* This IO was aborted by the target, we don't
+				 * know the rxid and because we did not send the
+				 * ABTS we cannot generate and RRQ.
+				 */
+				lpfc_set_rrq_active(phba, pnode,
+						lpfc_cmd->cur_iocbq.sli4_xritag,
+						0, 0);
+			}
 
 		/* else: fall through */
 		default:
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-02-16 11:23:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-02-16 11:25:15.000000000 -0500
@@ -566,6 +566,8 @@ void lpfc_sli4_fcp_xri_aborted(struct lp
 			       struct sli4_wcqe_xri_aborted *);
 void lpfc_sli4_els_xri_aborted(struct lpfc_hba *,
 			       struct sli4_wcqe_xri_aborted *);
+void lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *);
+void lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *);
 int lpfc_sli4_brdreset(struct lpfc_hba *);
 int lpfc_sli4_add_fcf_record(struct lpfc_hba *, struct fcf_record *);
 void lpfc_sli_remove_dflt_fcf(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-02-16 11:23:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-02-16 11:25:15.000000000 -0500
@@ -535,15 +535,35 @@ __lpfc_set_rrq_active(struct lpfc_hba *p
 	uint16_t adj_xri;
 	struct lpfc_node_rrq *rrq;
 	int empty;
+	uint32_t did = 0;
+
+
+	if (!ndlp)
+		return -EINVAL;
+
+	if (!phba->cfg_enable_rrq)
+		return -EINVAL;
+
+	if (phba->pport->load_flag & FC_UNLOADING) {
+		phba->hba_flag &= ~HBA_RRQ_ACTIVE;
+		goto out;
+	}
+	did = ndlp->nlp_DID;
 
 	/*
 	 * set the active bit even if there is no mem available.
 	 */
 	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
-	if (!ndlp)
-		return -EINVAL;
+
+	if (NLP_CHK_FREE_REQ(ndlp))
+		goto out;
+
+	if (ndlp->vport && (ndlp->vport->load_flag & FC_UNLOADING))
+		goto out;
+
 	if (test_and_set_bit(adj_xri, ndlp->active_rrqs.xri_bitmap))
-		return -EINVAL;
+		goto out;
+
 	rrq = mempool_alloc(phba->rrq_pool, GFP_KERNEL);
 	if (rrq) {
 		rrq->send_rrq = send_rrq;
@@ -554,14 +574,7 @@ __lpfc_set_rrq_active(struct lpfc_hba *p
 		rrq->vport = ndlp->vport;
 		rrq->rxid = rxid;
 		empty = list_empty(&phba->active_rrq_list);
-		if (phba->cfg_enable_rrq && send_rrq)
-			/*
-			 * We need the xri before we can add this to the
-			 * phba active rrq list.
-			 */
-			rrq->send_rrq = send_rrq;
-		else
-			rrq->send_rrq = 0;
+		rrq->send_rrq = send_rrq;
 		list_add_tail(&rrq->list, &phba->active_rrq_list);
 		if (!(phba->hba_flag & HBA_RRQ_ACTIVE)) {
 			phba->hba_flag |= HBA_RRQ_ACTIVE;
@@ -570,40 +583,49 @@ __lpfc_set_rrq_active(struct lpfc_hba *p
 		}
 		return 0;
 	}
-	return -ENOMEM;
+out:
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"2921 Can't set rrq active xri:0x%x rxid:0x%x"
+			" DID:0x%x Send:%d\n",
+			xritag, rxid, did, send_rrq);
+	return -EINVAL;
 }
 
 /**
- * __lpfc_clr_rrq_active - Clears RRQ active bit in xri_bitmap.
+ * lpfc_clr_rrq_active - Clears RRQ active bit in xri_bitmap.
  * @phba: Pointer to HBA context object.
  * @xritag: xri used in this exchange.
  * @rrq: The RRQ to be cleared.
  *
- * This function is called with hbalock held. This function
  **/
-static void
-__lpfc_clr_rrq_active(struct lpfc_hba *phba,
-			uint16_t xritag,
-			struct lpfc_node_rrq *rrq)
+void
+lpfc_clr_rrq_active(struct lpfc_hba *phba,
+		    uint16_t xritag,
+		    struct lpfc_node_rrq *rrq)
 {
 	uint16_t adj_xri;
-	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *ndlp = NULL;
 
-	ndlp = lpfc_findnode_did(rrq->vport, rrq->nlp_DID);
+	if ((rrq->vport) && NLP_CHK_NODE_ACT(rrq->ndlp))
+		ndlp = lpfc_findnode_did(rrq->vport, rrq->nlp_DID);
 
 	/* The target DID could have been swapped (cable swap)
 	 * we should use the ndlp from the findnode if it is
 	 * available.
 	 */
-	if (!ndlp)
+	if ((!ndlp) && rrq->ndlp)
 		ndlp = rrq->ndlp;
 
+	if (!ndlp)
+		goto out;
+
 	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
 	if (test_and_clear_bit(adj_xri, ndlp->active_rrqs.xri_bitmap)) {
 		rrq->send_rrq = 0;
 		rrq->xritag = 0;
 		rrq->rrq_stop_time = 0;
 	}
+out:
 	mempool_free(rrq, phba->rrq_pool);
 }
 
@@ -628,34 +650,34 @@ lpfc_handle_rrq_active(struct lpfc_hba *
 	struct lpfc_node_rrq *nextrrq;
 	unsigned long next_time;
 	unsigned long iflags;
+	LIST_HEAD(send_rrq);
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag &= ~HBA_RRQ_ACTIVE;
 	next_time = jiffies + HZ * (phba->fc_ratov + 1);
 	list_for_each_entry_safe(rrq, nextrrq,
-			&phba->active_rrq_list, list) {
-		if (time_after(jiffies, rrq->rrq_stop_time)) {
-			list_del(&rrq->list);
-			if (!rrq->send_rrq)
-				/* this call will free the rrq */
-				__lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
-			else {
-			/* if we send the rrq then the completion handler
-			 *  will clear the bit in the xribitmap.
-			 */
-				spin_unlock_irqrestore(&phba->hbalock, iflags);
-				if (lpfc_send_rrq(phba, rrq)) {
-					lpfc_clr_rrq_active(phba, rrq->xritag,
-								 rrq);
-				}
-				spin_lock_irqsave(&phba->hbalock, iflags);
-			}
-		} else if  (time_before(rrq->rrq_stop_time, next_time))
+				 &phba->active_rrq_list, list) {
+		if (time_after(jiffies, rrq->rrq_stop_time))
+			list_move(&rrq->list, &send_rrq);
+		else if (time_before(rrq->rrq_stop_time, next_time))
 			next_time = rrq->rrq_stop_time;
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (!list_empty(&phba->active_rrq_list))
 		mod_timer(&phba->rrq_tmr, next_time);
+	list_for_each_entry_safe(rrq, nextrrq, &send_rrq, list) {
+		list_del(&rrq->list);
+		if (!rrq->send_rrq)
+			/* this call will free the rrq */
+		lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
+		else if (lpfc_send_rrq(phba, rrq)) {
+			/* if we send the rrq then the completion handler
+			*  will clear the bit in the xribitmap.
+			*/
+			lpfc_clr_rrq_active(phba, rrq->xritag,
+					    rrq);
+		}
+	}
 }
 
 /**
@@ -693,29 +715,37 @@ lpfc_get_active_rrq(struct lpfc_vport *v
 /**
  * lpfc_cleanup_vports_rrqs - Remove and clear the active RRQ for this vport.
  * @vport: Pointer to vport context object.
- *
- * Remove all active RRQs for this vport from the phba->active_rrq_list and
- * clear the rrq.
+ * @ndlp: Pointer to the lpfc_node_list structure.
+ * If ndlp is NULL Remove all active RRQs for this vport from the
+ * phba->active_rrq_list and clear the rrq.
+ * If ndlp is not NULL then only remove rrqs for this vport & this ndlp.
  **/
 void
-lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport)
+lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_node_rrq *rrq;
 	struct lpfc_node_rrq *nextrrq;
 	unsigned long iflags;
+	LIST_HEAD(rrq_list);
 
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		return;
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list) {
-		if (rrq->vport == vport) {
-			list_del(&rrq->list);
-			__lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
-		}
+	if (!ndlp) {
+		lpfc_sli4_vport_delete_els_xri_aborted(vport);
+		lpfc_sli4_vport_delete_fcp_xri_aborted(vport);
 	}
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list)
+		if ((rrq->vport == vport) && (!ndlp  || rrq->ndlp == ndlp))
+			list_move(&rrq->list, &rrq_list);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	list_for_each_entry_safe(rrq, nextrrq, &rrq_list, list) {
+		list_del(&rrq->list);
+		lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
+	}
 }
 
 /**
@@ -733,24 +763,27 @@ lpfc_cleanup_wt_rrqs(struct lpfc_hba *ph
 	struct lpfc_node_rrq *nextrrq;
 	unsigned long next_time;
 	unsigned long iflags;
+	LIST_HEAD(rrq_list);
 
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		return;
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag &= ~HBA_RRQ_ACTIVE;
 	next_time = jiffies + HZ * (phba->fc_ratov * 2);
-	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list) {
+	list_splice_init(&phba->active_rrq_list, &rrq_list);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	list_for_each_entry_safe(rrq, nextrrq, &rrq_list, list) {
 		list_del(&rrq->list);
-		__lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
+		lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
 	}
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (!list_empty(&phba->active_rrq_list))
 		mod_timer(&phba->rrq_tmr, next_time);
 }
 
 
 /**
- * __lpfc_test_rrq_active - Test RRQ bit in xri_bitmap.
+ * lpfc_test_rrq_active - Test RRQ bit in xri_bitmap.
  * @phba: Pointer to HBA context object.
  * @ndlp: Targets nodelist pointer for this exchange.
  * @xritag the xri in the bitmap to test.
@@ -759,8 +792,8 @@ lpfc_cleanup_wt_rrqs(struct lpfc_hba *ph
  * returns 0 = rrq not active for this xri
  *         1 = rrq is valid for this xri.
  **/
-static int
-__lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
+int
+lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 			uint16_t  xritag)
 {
 	uint16_t adj_xri;
@@ -803,52 +836,6 @@ lpfc_set_rrq_active(struct lpfc_hba *phb
 }
 
 /**
- * lpfc_clr_rrq_active - Clears RRQ active bit in xri_bitmap.
- * @phba: Pointer to HBA context object.
- * @xritag: xri used in this exchange.
- * @rrq: The RRQ to be cleared.
- *
- * This function is takes the hbalock.
- **/
-void
-lpfc_clr_rrq_active(struct lpfc_hba *phba,
-			uint16_t xritag,
-			struct lpfc_node_rrq *rrq)
-{
-	unsigned long iflags;
-
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	__lpfc_clr_rrq_active(phba, xritag, rrq);
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
-	return;
-}
-
-
-
-/**
- * lpfc_test_rrq_active - Test RRQ bit in xri_bitmap.
- * @phba: Pointer to HBA context object.
- * @ndlp: Targets nodelist pointer for this exchange.
- * @xritag the xri in the bitmap to test.
- *
- * This function takes the hbalock.
- * returns 0 = rrq not active for this xri
- *         1 = rrq is valid for this xri.
- **/
-int
-lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
-			uint16_t  xritag)
-{
-	int ret;
-	unsigned long iflags;
-
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	ret = __lpfc_test_rrq_active(phba, ndlp, xritag);
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
-	return ret;
-}
-
-/**
  * __lpfc_sli_get_sglq - Allocates an iocb object from sgl pool
  * @phba: Pointer to HBA context object.
  * @piocb: Pointer to the iocbq.
@@ -885,7 +872,7 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 			return NULL;
 		adj_xri = sglq->sli4_xritag -
 				phba->sli4_hba.max_cfg_param.xri_base;
-		if (__lpfc_test_rrq_active(phba, ndlp, sglq->sli4_xritag)) {
+		if (lpfc_test_rrq_active(phba, ndlp, sglq->sli4_xritag)) {
 			/* This xri has an rrq outstanding for this DID.
 			 * put it back in the list and get another xri.
 			 */


