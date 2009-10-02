From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 1/6] lpfc 8.3.5: MIsc patch set part 1
Date: Fri, 2 Oct 2009 15:16:39 -0400
Message-ID: <1254510999.32739.17.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63971 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbZJBT6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 15:58:51 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n92JwtIq026928
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 12:58:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


This patch includes the following fixes:
- Fixed panic during HBA reset.
- Fixed FCoE event tag passed in resume_rpi.
- Fix out of order ELS commands
- Fixed discovery issues found during VLAN testing.
- Fix UNREG_VPI failure on extended link pull
- Fixed crash while processing unsolicited FC frames.
- Clear retry count in the delayed ELS handler
- Fixed discovery failure during quick link bounce.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    3 
 lpfc_attr.c    |   11 +-
 lpfc_crtn.h    |    2 
 lpfc_els.c     |    1 
 lpfc_hbadisc.c |   67 ++++++++++---
 lpfc_init.c    |   51 +--------
 lpfc_sli.c     |  293 +++++++++++++++++++++++++++++----------------------------
 lpfc_sli.h     |   21 ++--
 lpfc_sli4.h    |   13 --
 9 files changed, 242 insertions(+), 220 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-10-01 17:20:05.000000000 -0400
@@ -3815,7 +3815,11 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	hs->invalid_crc_count -= lso->invalid_crc_count;
 	hs->error_frames -= lso->error_frames;
 
-	if (phba->fc_topology == TOPOLOGY_LOOP) {
+	if (phba->hba_flag & HBA_FCOE_SUPPORT) {
+		hs->lip_count = -1;
+		hs->nos_count = (phba->link_events >> 1);
+		hs->nos_count -= lso->link_events;
+	} else if (phba->fc_topology == TOPOLOGY_LOOP) {
 		hs->lip_count = (phba->fc_eventTag >> 1);
 		hs->lip_count -= lso->link_events;
 		hs->nos_count = -1;
@@ -3906,7 +3910,10 @@ lpfc_reset_stats(struct Scsi_Host *shost
 	lso->invalid_tx_word_count = pmb->un.varRdLnk.invalidXmitWord;
 	lso->invalid_crc_count = pmb->un.varRdLnk.crcCnt;
 	lso->error_frames = pmb->un.varRdLnk.crcCnt;
-	lso->link_events = (phba->fc_eventTag >> 1);
+	if (phba->hba_flag & HBA_FCOE_SUPPORT)
+		lso->link_events = (phba->link_events >> 1);
+	else
+		lso->link_events = (phba->fc_eventTag >> 1);
 
 	psli->stats_start = get_seconds();
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2009-10-01 17:20:05.000000000 -0400
@@ -235,7 +235,7 @@ void lpfc_sli_mbox_sys_shutdown(struct l
 int lpfc_sli_check_eratt(struct lpfc_hba *);
 void lpfc_sli_handle_slow_ring_event(struct lpfc_hba *,
 				    struct lpfc_sli_ring *, uint32_t);
-int lpfc_sli4_handle_received_buffer(struct lpfc_hba *);
+void lpfc_sli4_handle_received_buffer(struct lpfc_hba *, struct hbq_dmabuf *);
 void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 			struct lpfc_iocbq *, uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-10-01 17:20:05.000000000 -0400
@@ -2452,6 +2452,7 @@ lpfc_els_retry_delay_handler(struct lpfc
 	 */
 	del_timer_sync(&ndlp->nlp_delayfunc);
 	retry = ndlp->nlp_retry;
+	ndlp->nlp_retry = 0;
 
 	switch (cmd) {
 	case ELS_CMD_FLOGI:
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2009-10-01 17:20:05.000000000 -0400
@@ -109,7 +109,7 @@ struct hbq_dmabuf {
 	struct lpfc_dmabuf dbuf;
 	uint32_t size;
 	uint32_t tag;
-	struct lpfc_rcqe rcqe;
+	struct lpfc_cq_event cq_event;
 };
 
 /* Priority bit.  Set value to exceed low water mark in lpfc_mem. */
@@ -551,6 +551,7 @@ struct lpfc_hba {
 	uint8_t fc_linkspeed;	/* Link speed after last READ_LA */
 
 	uint32_t fc_eventTag;	/* event tag for link attention */
+	uint32_t link_events;
 
 	/* These fields used to be binfo */
 	uint32_t fc_pref_DID;	/* preferred D_ID */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-10-01 17:20:05.000000000 -0400
@@ -525,8 +525,6 @@ lpfc_work_done(struct lpfc_hba *phba)
 			spin_unlock_irq(&phba->hbalock);
 			lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
 		}
-		if (phba->hba_flag & HBA_RECEIVE_BUFFER)
-			lpfc_sli4_handle_received_buffer(phba);
 	}
 
 	vports = lpfc_create_vport_work_array(phba);
@@ -568,8 +566,9 @@ lpfc_work_done(struct lpfc_hba *phba)
 	pring = &phba->sli.ring[LPFC_ELS_RING];
 	status = (ha_copy & (HA_RXMASK  << (4*LPFC_ELS_RING)));
 	status >>= (4*LPFC_ELS_RING);
-	if ((status & HA_RXMASK)
-		|| (pring->flag & LPFC_DEFERRED_RING_EVENT)) {
+	if ((status & HA_RXMASK) ||
+	    (pring->flag & LPFC_DEFERRED_RING_EVENT) ||
+	    (phba->hba_flag & HBA_RECEIVE_BUFFER)) {
 		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
 			/* Set the lpfc data pending flag */
@@ -688,7 +687,8 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 			lpfc_unreg_rpi(vport, ndlp);
 
 		/* Leave Fabric nodes alone on link down */
-		if (!remove && ndlp->nlp_type & NLP_FABRIC)
+		if ((phba->sli_rev < LPFC_SLI_REV4) &&
+		    (!remove && ndlp->nlp_type & NLP_FABRIC))
 			continue;
 		rc = lpfc_disc_state_machine(vport, ndlp, NULL,
 					     remove
@@ -1015,10 +1015,10 @@ lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *
 		mempool_free(mboxq, phba->mbox_mem_pool);
 		return;
 	}
+	phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
+	phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 	if (vport->port_state != LPFC_FLOGI) {
 		spin_lock_irqsave(&phba->hbalock, flags);
-		phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
-		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_initial_flogi(vport);
 	}
@@ -1199,6 +1199,7 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 
 	/* If the FCF is not availabe do nothing. */
 	if (!(phba->fcf.fcf_flag & FCF_AVAILABLE)) {
+		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
@@ -1216,15 +1217,23 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 
 	fcf_mbxq = mempool_alloc(phba->mbox_mem_pool,
 		GFP_KERNEL);
-	if (!fcf_mbxq)
+	if (!fcf_mbxq) {
+		spin_lock_irqsave(&phba->hbalock, flags);
+		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
+	}
 
 	lpfc_reg_fcfi(phba, fcf_mbxq);
 	fcf_mbxq->vport = phba->pport;
 	fcf_mbxq->mbox_cmpl = lpfc_mbx_cmpl_reg_fcfi;
 	rc = lpfc_sli_issue_mbox(phba, fcf_mbxq, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		spin_lock_irqsave(&phba->hbalock, flags);
+		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		mempool_free(fcf_mbxq, phba->mbox_mem_pool);
+	}
 
 	return;
 }
@@ -1253,6 +1262,20 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 			uint16_t *vlan_id)
 {
 	struct lpfc_fcf_conn_entry *conn_entry;
+	int i, j, fcf_vlan_id = 0;
+
+	/* Find the lowest VLAN id in the FCF record */
+	for (i = 0; i < 512; i++) {
+		if (new_fcf_record->vlan_bitmap[i]) {
+			fcf_vlan_id = i * 8;
+			j = 0;
+			while (!((new_fcf_record->vlan_bitmap[i] >> j) & 1)) {
+				j++;
+				fcf_vlan_id++;
+			}
+			break;
+		}
+	}
 
 	/* If FCF not available return 0 */
 	if (!bf_get(lpfc_fcf_record_fcf_avail, new_fcf_record) ||
@@ -1286,7 +1309,11 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 		if (*addr_mode & LPFC_FCF_FPMA)
 			*addr_mode = LPFC_FCF_FPMA;
 
-		*vlan_id = 0xFFFF;
+		/* If FCF record report a vlan id use that vlan id */
+		if (fcf_vlan_id)
+			*vlan_id = fcf_vlan_id;
+		else
+			*vlan_id = 0xFFFF;
 		return 1;
 	}
 
@@ -1384,8 +1411,15 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 			(*addr_mode & LPFC_FCF_FPMA))
 				*addr_mode = LPFC_FCF_FPMA;
 
+		/* If matching connect list has a vlan id, use it */
 		if (conn_entry->conn_rec.flags & FCFCNCT_VLAN_VALID)
 			*vlan_id = conn_entry->conn_rec.vlan_tag;
+		/*
+		 * If no vlan id is specified in connect list, use the vlan id
+		 * in the FCF record
+		 */
+		else if (fcf_vlan_id)
+			*vlan_id = fcf_vlan_id;
 		else
 			*vlan_id = 0xFFFF;
 
@@ -1423,6 +1457,12 @@ lpfc_check_pending_fcoe_event(struct lpf
 
 	if (phba->link_state >= LPFC_LINK_UP)
 		lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
+	else
+		/*
+		 * Do not continue FCF discovery and clear FCF_DISC_INPROGRESS
+		 * flag
+		 */
+		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 
 	if (unreg_fcf) {
 		spin_lock_irq(&phba->hbalock);
@@ -2085,6 +2125,7 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 	else
 		phba->sli.sli_flag &= ~LPFC_MENLO_MAINT;
 
+	phba->link_events++;
 	if (la->attType == AT_LINK_UP && (!la->mm)) {
 		phba->fc_stat.LinkUp++;
 		if (phba->link_flag & LS_LOOPBACK_MODE) {
@@ -4409,6 +4450,8 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 	if (lpfc_fcf_inuse(phba))
 		return;
 
+	/* At this point, all discovery is aborted */
+	phba->pport->port_state = LPFC_VPORT_UNKNOWN;
 
 	/* Unregister VPIs */
 	vports = lpfc_create_vport_work_array(phba);
@@ -4512,8 +4555,10 @@ lpfc_read_fcf_conn_tbl(struct lpfc_hba *
 
 	/* Free the current connect table */
 	list_for_each_entry_safe(conn_entry, next_conn_entry,
-		&phba->fcf_conn_rec_list, list)
+		&phba->fcf_conn_rec_list, list) {
+		list_del_init(&conn_entry->list);
 		kfree(conn_entry);
+	}
 
 	conn_hdr = (struct lpfc_fcf_conn_hdr *) buff;
 	record_count = conn_hdr->length * sizeof(uint32_t)/
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:20:05.000000000 -0400
@@ -2919,6 +2919,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 	uint8_t event_type = bf_get(lpfc_acqe_fcoe_event_type, acqe_fcoe);
 	int rc;
 
+	phba->fc_eventTag = acqe_fcoe->event_tag;
 	phba->fcoe_eventtag = acqe_fcoe->event_tag;
 	switch (event_type) {
 	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
@@ -2990,6 +2991,7 @@ static void
 lpfc_sli4_async_dcbx_evt(struct lpfc_hba *phba,
 			 struct lpfc_acqe_dcbx *acqe_dcbx)
 {
+	phba->fc_eventTag = acqe_dcbx->event_tag;
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0290 The SLI4 DCBX asynchronous event is not "
 			"handled yet\n");
@@ -3594,8 +3596,10 @@ lpfc_sli4_driver_resource_unset(struct l
 
 	/* Free the current connect table */
 	list_for_each_entry_safe(conn_entry, next_conn_entry,
-		&phba->fcf_conn_rec_list, list)
+		&phba->fcf_conn_rec_list, list) {
+		list_del_init(&conn_entry->list);
 		kfree(conn_entry);
+	}
 
 	return;
 }
@@ -5058,15 +5062,6 @@ lpfc_sli4_queue_create(struct lpfc_hba *
 	}
 	phba->sli4_hba.els_cq = qdesc;
 
-	/* Create slow-path Unsolicited Receive Complete Queue */
-	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
-				      phba->sli4_hba.cq_ecount);
-	if (!qdesc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0502 Failed allocate slow-path USOL RX CQ\n");
-		goto out_free_els_cq;
-	}
-	phba->sli4_hba.rxq_cq = qdesc;
 
 	/* Create fast-path FCP Completion Queue(s), one-to-one with EQs */
 	phba->sli4_hba.fcp_cq = kzalloc((sizeof(struct lpfc_queue *) *
@@ -5075,7 +5070,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2577 Failed allocate memory for fast-path "
 				"CQ record array\n");
-		goto out_free_rxq_cq;
+		goto out_free_els_cq;
 	}
 	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_eq_count; fcp_cqidx++) {
 		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
@@ -5188,9 +5183,6 @@ out_free_fcp_cq:
 		phba->sli4_hba.fcp_cq[fcp_cqidx] = NULL;
 	}
 	kfree(phba->sli4_hba.fcp_cq);
-out_free_rxq_cq:
-	lpfc_sli4_queue_free(phba->sli4_hba.rxq_cq);
-	phba->sli4_hba.rxq_cq = NULL;
 out_free_els_cq:
 	lpfc_sli4_queue_free(phba->sli4_hba.els_cq);
 	phba->sli4_hba.els_cq = NULL;
@@ -5247,10 +5239,6 @@ lpfc_sli4_queue_destroy(struct lpfc_hba 
 	lpfc_sli4_queue_free(phba->sli4_hba.dat_rq);
 	phba->sli4_hba.dat_rq = NULL;
 
-	/* Release unsolicited receive complete queue */
-	lpfc_sli4_queue_free(phba->sli4_hba.rxq_cq);
-	phba->sli4_hba.rxq_cq = NULL;
-
 	/* Release ELS complete queue */
 	lpfc_sli4_queue_free(phba->sli4_hba.els_cq);
 	phba->sli4_hba.els_cq = NULL;
@@ -5383,25 +5371,6 @@ lpfc_sli4_queue_setup(struct lpfc_hba *p
 			phba->sli4_hba.els_cq->queue_id,
 			phba->sli4_hba.sp_eq->queue_id);
 
-	/* Set up slow-path Unsolicited Receive Complete Queue */
-	if (!phba->sli4_hba.rxq_cq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0532 USOL RX CQ not allocated\n");
-		goto out_destroy_els_cq;
-	}
-	rc = lpfc_cq_create(phba, phba->sli4_hba.rxq_cq, phba->sli4_hba.sp_eq,
-			    LPFC_RCQ, LPFC_USOL);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0533 Failed setup of slow-path USOL RX CQ: "
-				"rc = 0x%x\n", rc);
-		goto out_destroy_els_cq;
-	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2587 USL CQ setup: cq-id=%d, parent eq-id=%d\n",
-			phba->sli4_hba.rxq_cq->queue_id,
-			phba->sli4_hba.sp_eq->queue_id);
-
 	/* Set up fast-path FCP Response Complete Queue */
 	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_eq_count; fcp_cqidx++) {
 		if (!phba->sli4_hba.fcp_cq[fcp_cqidx]) {
@@ -5507,7 +5476,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *p
 		goto out_destroy_fcp_wq;
 	}
 	rc = lpfc_rq_create(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq,
-			    phba->sli4_hba.rxq_cq, LPFC_USOL);
+			    phba->sli4_hba.els_cq, LPFC_USOL);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0541 Failed setup of Receive Queue: "
@@ -5519,7 +5488,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *p
 			"parent cq-id=%d\n",
 			phba->sli4_hba.hdr_rq->queue_id,
 			phba->sli4_hba.dat_rq->queue_id,
-			phba->sli4_hba.rxq_cq->queue_id);
+			phba->sli4_hba.els_cq->queue_id);
 	return 0;
 
 out_destroy_fcp_wq:
@@ -5531,8 +5500,6 @@ out_destroy_mbx_wq:
 out_destroy_fcp_cq:
 	for (--fcp_cqidx; fcp_cqidx >= 0; fcp_cqidx--)
 		lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_cqidx]);
-	lpfc_cq_destroy(phba, phba->sli4_hba.rxq_cq);
-out_destroy_els_cq:
 	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
 out_destroy_mbx_cq:
 	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
@@ -5574,8 +5541,6 @@ lpfc_sli4_queue_unset(struct lpfc_hba *p
 	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
 	/* Unset ELS complete queue */
 	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
-	/* Unset unsolicited receive complete queue */
-	lpfc_cq_destroy(phba, phba->sli4_hba.rxq_cq);
 	/* Unset FCP response complete queue */
 	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++)
 		lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_qidx]);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2009-10-01 17:20:05.000000000 -0400
@@ -110,18 +110,6 @@ struct lpfc_queue {
 	union sli4_qe qe[1];	/* array to index entries (must be last) */
 };
 
-struct lpfc_cq_event {
-	struct list_head list;
-	union {
-		struct lpfc_mcqe		mcqe_cmpl;
-		struct lpfc_acqe_link		acqe_link;
-		struct lpfc_acqe_fcoe		acqe_fcoe;
-		struct lpfc_acqe_dcbx		acqe_dcbx;
-		struct lpfc_rcqe		rcqe_cmpl;
-		struct sli4_wcqe_xri_aborted	wcqe_axri;
-	} cqe;
-};
-
 struct lpfc_sli4_link {
 	uint8_t speed;
 	uint8_t duplex;
@@ -325,7 +313,6 @@ struct lpfc_sli4_hba {
 	struct lpfc_queue **fcp_cq;/* Fast-path FCP compl queue */
 	struct lpfc_queue *mbx_cq; /* Slow-path mailbox complete queue */
 	struct lpfc_queue *els_cq; /* Slow-path ELS response complete queue */
-	struct lpfc_queue *rxq_cq; /* Slow-path unsolicited complete queue */
 
 	/* Setup information for various queue parameters */
 	int eq_esize;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:20:05.000000000 -0400
@@ -3018,16 +3018,31 @@ lpfc_sli_handle_slow_ring_event_s4(struc
 				   struct lpfc_sli_ring *pring, uint32_t mask)
 {
 	struct lpfc_iocbq *irspiocbq;
+	struct hbq_dmabuf *dmabuf;
+	struct lpfc_cq_event *cq_event;
 	unsigned long iflag;
 
 	while (!list_empty(&phba->sli4_hba.sp_rspiocb_work_queue)) {
 		/* Get the response iocb from the head of work queue */
 		spin_lock_irqsave(&phba->hbalock, iflag);
 		list_remove_head(&phba->sli4_hba.sp_rspiocb_work_queue,
-				 irspiocbq, struct lpfc_iocbq, list);
+				 cq_event, struct lpfc_cq_event, list);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
-		/* Process the response iocb */
-		lpfc_sli_sp_handle_rspiocb(phba, pring, irspiocbq);
+
+		switch (bf_get(lpfc_wcqe_c_code, &cq_event->cqe.wcqe_cmpl)) {
+		case CQE_CODE_COMPL_WQE:
+			irspiocbq = container_of(cq_event, struct lpfc_iocbq,
+						 cq_event);
+			lpfc_sli_sp_handle_rspiocb(phba, pring, irspiocbq);
+			break;
+		case CQE_CODE_RECEIVE:
+			dmabuf = container_of(cq_event, struct hbq_dmabuf,
+					      cq_event);
+			lpfc_sli4_handle_received_buffer(phba, dmabuf);
+			break;
+		default:
+			break;
+		}
 	}
 }
 
@@ -3416,6 +3431,7 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 
 	/* perform board reset */
 	phba->fc_eventTag = 0;
+	phba->link_events = 0;
 	phba->pport->fc_myDID = 0;
 	phba->pport->fc_prevDID = 0;
 
@@ -3476,6 +3492,7 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 
 	/* perform board reset */
 	phba->fc_eventTag = 0;
+	phba->link_events = 0;
 	phba->pport->fc_myDID = 0;
 	phba->pport->fc_prevDID = 0;
 
@@ -3495,7 +3512,6 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 	list_del_init(&phba->sli4_hba.dat_rq->list);
 	list_del_init(&phba->sli4_hba.mbx_cq->list);
 	list_del_init(&phba->sli4_hba.els_cq->list);
-	list_del_init(&phba->sli4_hba.rxq_cq->list);
 	for (qindx = 0; qindx < phba->cfg_fcp_wq_count; qindx++)
 		list_del_init(&phba->sli4_hba.fcp_wq[qindx]->list);
 	for (qindx = 0; qindx < phba->cfg_fcp_eq_count; qindx++)
@@ -4243,7 +4259,6 @@ lpfc_sli4_arm_cqeq_intr(struct lpfc_hba 
 
 	lpfc_sli4_cq_release(phba->sli4_hba.mbx_cq, LPFC_QUEUE_REARM);
 	lpfc_sli4_cq_release(phba->sli4_hba.els_cq, LPFC_QUEUE_REARM);
-	lpfc_sli4_cq_release(phba->sli4_hba.rxq_cq, LPFC_QUEUE_REARM);
 	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++)
 		lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[fcp_eqidx],
 				     LPFC_QUEUE_REARM);
@@ -8351,8 +8366,7 @@ lpfc_sli4_iocb_param_transfer(struct lpf
 
 	memcpy((char *)pIocbIn + offset, (char *)pIocbOut + offset,
 	       sizeof(struct lpfc_iocbq) - offset);
-	memset(&pIocbIn->sli4_info, 0,
-	       sizeof(struct lpfc_sli4_rspiocb_info));
+	pIocbIn->cq_event.cqe.wcqe_cmpl = *wcqe;
 	/* Map WCQE parameters into irspiocb parameters */
 	pIocbIn->iocb.ulpStatus = bf_get(lpfc_wcqe_c_status, wcqe);
 	if (pIocbOut->iocb_flag & LPFC_IO_FCP)
@@ -8364,16 +8378,6 @@ lpfc_sli4_iocb_param_transfer(struct lpf
 			pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
 	else
 		pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
-	/* Load in additional WCQE parameters */
-	pIocbIn->sli4_info.hw_status = bf_get(lpfc_wcqe_c_hw_status, wcqe);
-	pIocbIn->sli4_info.bfield = 0;
-	if (bf_get(lpfc_wcqe_c_xb, wcqe))
-		pIocbIn->sli4_info.bfield |= LPFC_XB;
-	if (bf_get(lpfc_wcqe_c_pv, wcqe)) {
-		pIocbIn->sli4_info.bfield |= LPFC_PV;
-		pIocbIn->sli4_info.priority =
-					bf_get(lpfc_wcqe_c_priority, wcqe);
-	}
 }
 
 /**
@@ -8598,7 +8602,8 @@ lpfc_sli4_sp_handle_els_wcqe(struct lpfc
 
 	/* Add the irspiocb to the response IOCB work list */
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	list_add_tail(&irspiocbq->list, &phba->sli4_hba.sp_rspiocb_work_queue);
+	list_add_tail(&irspiocbq->cq_event.list,
+		      &phba->sli4_hba.sp_rspiocb_work_queue);
 	/* Indicate ELS ring attention */
 	phba->work_ha |= (HA_R0ATT << (4*LPFC_ELS_RING));
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
@@ -8690,52 +8695,6 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struc
 }
 
 /**
- * lpfc_sli4_sp_handle_wcqe - Process a work-queue completion queue entry
- * @phba: Pointer to HBA context object.
- * @cq: Pointer to the completion queue.
- * @wcqe: Pointer to a completion queue entry.
- *
- * This routine process a slow-path work-queue completion queue entry.
- *
- * Return: true if work posted to worker thread, otherwise false.
- **/
-static bool
-lpfc_sli4_sp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
-			 struct lpfc_cqe *cqe)
-{
-	struct lpfc_wcqe_complete wcqe;
-	bool workposted = false;
-
-	/* Copy the work queue CQE and convert endian order if needed */
-	lpfc_sli_pcimem_bcopy(cqe, &wcqe, sizeof(struct lpfc_cqe));
-
-	/* Check and process for different type of WCQE and dispatch */
-	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
-	case CQE_CODE_COMPL_WQE:
-		/* Process the WQ complete event */
-		workposted = lpfc_sli4_sp_handle_els_wcqe(phba,
-					(struct lpfc_wcqe_complete *)&wcqe);
-		break;
-	case CQE_CODE_RELEASE_WQE:
-		/* Process the WQ release event */
-		lpfc_sli4_sp_handle_rel_wcqe(phba,
-					(struct lpfc_wcqe_release *)&wcqe);
-		break;
-	case CQE_CODE_XRI_ABORTED:
-		/* Process the WQ XRI abort event */
-		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
-					(struct sli4_wcqe_xri_aborted *)&wcqe);
-		break;
-	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0388 Not a valid WCQE code: x%x\n",
-				bf_get(lpfc_wcqe_c_code, &wcqe));
-		break;
-	}
-	return workposted;
-}
-
-/**
  * lpfc_sli4_sp_handle_rcqe - Process a receive-queue completion queue entry
  * @phba: Pointer to HBA context object.
  * @rcqe: Pointer to receive-queue completion queue entry.
@@ -8745,9 +8704,8 @@ lpfc_sli4_sp_handle_wcqe(struct lpfc_hba
  * Return: true if work posted to worker thread, otherwise false.
  **/
 static bool
-lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_cqe *cqe)
+lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 {
-	struct lpfc_rcqe rcqe;
 	bool workposted = false;
 	struct lpfc_queue *hrq = phba->sli4_hba.hdr_rq;
 	struct lpfc_queue *drq = phba->sli4_hba.dat_rq;
@@ -8755,15 +8713,13 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 	uint32_t status;
 	unsigned long iflags;
 
-	/* Copy the receive queue CQE and convert endian order if needed */
-	lpfc_sli_pcimem_bcopy(cqe, &rcqe, sizeof(struct lpfc_rcqe));
 	lpfc_sli4_rq_release(hrq, drq);
-	if (bf_get(lpfc_rcqe_code, &rcqe) != CQE_CODE_RECEIVE)
+	if (bf_get(lpfc_rcqe_code, rcqe) != CQE_CODE_RECEIVE)
 		goto out;
-	if (bf_get(lpfc_rcqe_rq_id, &rcqe) != hrq->queue_id)
+	if (bf_get(lpfc_rcqe_rq_id, rcqe) != hrq->queue_id)
 		goto out;
 
-	status = bf_get(lpfc_rcqe_status, &rcqe);
+	status = bf_get(lpfc_rcqe_status, rcqe);
 	switch (status) {
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -8775,9 +8731,10 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			goto out;
 		}
-		memcpy(&dma_buf->rcqe, &rcqe, sizeof(rcqe));
+		memcpy(&dma_buf->cq_event.cqe.rcqe_cmpl, rcqe, sizeof(*rcqe));
 		/* save off the frame for the word thread to process */
-		list_add_tail(&dma_buf->dbuf.list, &phba->rb_pend_list);
+		list_add_tail(&dma_buf->cq_event.list,
+			      &phba->sli4_hba.sp_rspiocb_work_queue);
 		/* Frame received */
 		phba->hba_flag |= HBA_RECEIVE_BUFFER;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
@@ -8798,6 +8755,58 @@ out:
 }
 
 /**
+ * lpfc_sli4_sp_handle_cqe - Process a slow path completion queue entry
+ * @phba: Pointer to HBA context object.
+ * @cq: Pointer to the completion queue.
+ * @wcqe: Pointer to a completion queue entry.
+ *
+ * This routine process a slow-path work-queue or recieve queue completion queue
+ * entry.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_sp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+			 struct lpfc_cqe *cqe)
+{
+	struct lpfc_wcqe_complete wcqe;
+	bool workposted = false;
+
+	/* Copy the work queue CQE and convert endian order if needed */
+	lpfc_sli_pcimem_bcopy(cqe, &wcqe, sizeof(struct lpfc_cqe));
+
+	/* Check and process for different type of WCQE and dispatch */
+	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
+	case CQE_CODE_COMPL_WQE:
+		/* Process the WQ complete event */
+		workposted = lpfc_sli4_sp_handle_els_wcqe(phba,
+					(struct lpfc_wcqe_complete *)&wcqe);
+		break;
+	case CQE_CODE_RELEASE_WQE:
+		/* Process the WQ release event */
+		lpfc_sli4_sp_handle_rel_wcqe(phba,
+					(struct lpfc_wcqe_release *)&wcqe);
+		break;
+	case CQE_CODE_XRI_ABORTED:
+		/* Process the WQ XRI abort event */
+		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
+					(struct sli4_wcqe_xri_aborted *)&wcqe);
+		break;
+	case CQE_CODE_RECEIVE:
+		/* Process the RQ event */
+		workposted = lpfc_sli4_sp_handle_rcqe(phba,
+					(struct lpfc_rcqe *)&wcqe);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0388 Not a valid WCQE code: x%x\n",
+				bf_get(lpfc_wcqe_c_code, &wcqe));
+		break;
+	}
+	return workposted;
+}
+
+/**
  * lpfc_sli4_sp_handle_eqe - Process a slow-path event queue entry
  * @phba: Pointer to HBA context object.
  * @eqe: Pointer to fast-path event queue entry.
@@ -8858,14 +8867,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba 
 		break;
 	case LPFC_WCQ:
 		while ((cqe = lpfc_sli4_cq_get(cq))) {
-			workposted |= lpfc_sli4_sp_handle_wcqe(phba, cq, cqe);
-			if (!(++ecount % LPFC_GET_QE_REL_INT))
-				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
-		}
-		break;
-	case LPFC_RCQ:
-		while ((cqe = lpfc_sli4_cq_get(cq))) {
-			workposted |= lpfc_sli4_sp_handle_rcqe(phba, cqe);
+			workposted |= lpfc_sli4_sp_handle_cqe(phba, cq, cqe);
 			if (!(++ecount % LPFC_GET_QE_REL_INT))
 				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 		}
@@ -10823,6 +10825,7 @@ lpfc_fc_frame_add(struct lpfc_vport *vpo
 	struct hbq_dmabuf *seq_dmabuf = NULL;
 	struct hbq_dmabuf *temp_dmabuf = NULL;
 
+	INIT_LIST_HEAD(&dmabuf->dbuf.list);
 	new_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
 	/* Use the hdr_buf to find the sequence that this frame belongs to */
 	list_for_each_entry(h_buf, &vport->rcv_buffer_list, list) {
@@ -10845,7 +10848,9 @@ lpfc_fc_frame_add(struct lpfc_vport *vpo
 	}
 	temp_hdr = seq_dmabuf->hbuf.virt;
 	if (new_hdr->fh_seq_cnt < temp_hdr->fh_seq_cnt) {
-		list_add(&seq_dmabuf->dbuf.list, &dmabuf->dbuf.list);
+		list_del_init(&seq_dmabuf->hbuf.list);
+		list_add_tail(&dmabuf->hbuf.list, &vport->rcv_buffer_list);
+		list_add_tail(&dmabuf->dbuf.list, &seq_dmabuf->dbuf.list);
 		return dmabuf;
 	}
 	/* find the correct place in the sequence to insert this frame */
@@ -10957,7 +10962,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, 
 							LPFC_DATA_BUF_SIZE;
 		first_iocbq->iocb.un.rcvels.remoteID = sid;
 		first_iocbq->iocb.unsli3.rcvsli3.acc_len +=
-				bf_get(lpfc_rcqe_length, &seq_dmabuf->rcqe);
+				bf_get(lpfc_rcqe_length,
+				       &seq_dmabuf->cq_event.cqe.rcqe_cmpl);
 	}
 	iocbq = first_iocbq;
 	/*
@@ -10975,7 +10981,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, 
 			iocbq->iocb.unsli3.rcvsli3.bde2.tus.f.bdeSize =
 							LPFC_DATA_BUF_SIZE;
 			first_iocbq->iocb.unsli3.rcvsli3.acc_len +=
-				bf_get(lpfc_rcqe_length, &seq_dmabuf->rcqe);
+				bf_get(lpfc_rcqe_length,
+				       &seq_dmabuf->cq_event.cqe.rcqe_cmpl);
 		} else {
 			iocbq = lpfc_sli_get_iocbq(vport->phba);
 			if (!iocbq) {
@@ -10994,7 +11001,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, 
 			iocbq->iocb.un.cont64[0].tus.f.bdeSize =
 							LPFC_DATA_BUF_SIZE;
 			first_iocbq->iocb.unsli3.rcvsli3.acc_len +=
-				bf_get(lpfc_rcqe_length, &seq_dmabuf->rcqe);
+				bf_get(lpfc_rcqe_length,
+				       &seq_dmabuf->cq_event.cqe.rcqe_cmpl);
 			iocbq->iocb.un.rcvels.remoteID = sid;
 			list_add_tail(&iocbq->list, &first_iocbq->list);
 		}
@@ -11014,11 +11022,11 @@ lpfc_prep_seq(struct lpfc_vport *vport, 
  * Worker thread calls lpfc_sli4_handle_received_buffer, which will call the
  * appropriate receive function when the final frame in a sequence is received.
  **/
-int
-lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba)
+void
+lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
+				 struct hbq_dmabuf *dmabuf)
 {
-	LIST_HEAD(cmplq);
-	struct hbq_dmabuf *dmabuf, *seq_dmabuf;
+	struct hbq_dmabuf *seq_dmabuf;
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_vport *vport;
 	uint32_t fcfi;
@@ -11027,54 +11035,50 @@ lpfc_sli4_handle_received_buffer(struct 
 	/* Clear hba flag and get all received buffers into the cmplq */
 	spin_lock_irq(&phba->hbalock);
 	phba->hba_flag &= ~HBA_RECEIVE_BUFFER;
-	list_splice_init(&phba->rb_pend_list, &cmplq);
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Process each received buffer */
-	while ((dmabuf = lpfc_sli_hbqbuf_get(&cmplq)) != NULL) {
-		fc_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
-		/* check to see if this a valid type of frame */
-		if (lpfc_fc_frame_check(phba, fc_hdr)) {
-			lpfc_in_buf_free(phba, &dmabuf->dbuf);
-			continue;
-		}
-		fcfi = bf_get(lpfc_rcqe_fcf_id, &dmabuf->rcqe);
-		vport = lpfc_fc_frame_to_vport(phba, fc_hdr, fcfi);
-		if (!vport) {
-			/* throw out the frame */
-			lpfc_in_buf_free(phba, &dmabuf->dbuf);
-			continue;
-		}
-		/* Link this frame */
-		seq_dmabuf = lpfc_fc_frame_add(vport, dmabuf);
-		if (!seq_dmabuf) {
-			/* unable to add frame to vport - throw it out */
-			lpfc_in_buf_free(phba, &dmabuf->dbuf);
-			continue;
-		}
-		/* If not last frame in sequence continue processing frames. */
-		if (!lpfc_seq_complete(seq_dmabuf)) {
-			/*
-			 * When saving off frames post a new one and mark this
-			 * frame to be freed when it is finished.
-			 **/
-			lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_ELS_HBQ, 1);
-			dmabuf->tag = -1;
-			continue;
-		}
-		fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
-		iocbq = lpfc_prep_seq(vport, seq_dmabuf);
-		if (!lpfc_complete_unsol_iocb(phba,
-					      &phba->sli.ring[LPFC_ELS_RING],
-					      iocbq, fc_hdr->fh_r_ctl,
-					      fc_hdr->fh_type))
-			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"2540 Ring %d handler: unexpected Rctl "
-					"x%x Type x%x received\n",
-					LPFC_ELS_RING,
-					fc_hdr->fh_r_ctl, fc_hdr->fh_type);
-	};
-	return 0;
+	fc_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+	/* check to see if this a valid type of frame */
+	if (lpfc_fc_frame_check(phba, fc_hdr)) {
+		lpfc_in_buf_free(phba, &dmabuf->dbuf);
+		return;
+	}
+	fcfi = bf_get(lpfc_rcqe_fcf_id, &dmabuf->cq_event.cqe.rcqe_cmpl);
+	vport = lpfc_fc_frame_to_vport(phba, fc_hdr, fcfi);
+	if (!vport) {
+		/* throw out the frame */
+		lpfc_in_buf_free(phba, &dmabuf->dbuf);
+		return;
+	}
+	/* Link this frame */
+	seq_dmabuf = lpfc_fc_frame_add(vport, dmabuf);
+	if (!seq_dmabuf) {
+		/* unable to add frame to vport - throw it out */
+		lpfc_in_buf_free(phba, &dmabuf->dbuf);
+		return;
+	}
+	/* If not last frame in sequence continue processing frames. */
+	if (!lpfc_seq_complete(seq_dmabuf)) {
+		/*
+		* When saving off frames post a new one and mark this
+		* frame to be freed when it is finished.
+		**/
+		lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_ELS_HBQ, 1);
+		dmabuf->tag = -1;
+		return;
+	}
+	fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
+	iocbq = lpfc_prep_seq(vport, seq_dmabuf);
+	if (!lpfc_complete_unsol_iocb(phba,
+				      &phba->sli.ring[LPFC_ELS_RING],
+				      iocbq, fc_hdr->fh_r_ctl,
+				      fc_hdr->fh_type))
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"2540 Ring %d handler: unexpected Rctl "
+				"x%x Type x%x received\n",
+				LPFC_ELS_RING,
+				fc_hdr->fh_r_ctl, fc_hdr->fh_type);
 }
 
 /**
@@ -11542,7 +11546,8 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2000 Failed to allocate mbox for "
 				"READ_FCF cmd\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto fail_fcfscan;
 	}
 
 	req_len = sizeof(struct fcf_record) +
@@ -11558,8 +11563,8 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 				"0291 Allocated DMA memory size (x%x) is "
 				"less than the requested DMA memory "
 				"size (x%x)\n", alloc_len, req_len);
-		lpfc_sli4_mbox_cmd_free(phba, mboxq);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto fail_fcfscan;
 	}
 
 	/* Get the first SGE entry from the non-embedded DMA memory. This
@@ -11571,8 +11576,8 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
 				"2527 Failed to get the non-embedded SGE "
 				"virtual address\n");
-		lpfc_sli4_mbox_cmd_free(phba, mboxq);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto fail_fcfscan;
 	}
 	virt_addr = mboxq->sge_array->addr[0];
 	read_fcf = (struct lpfc_mbx_read_fcf_tbl *)virt_addr;
@@ -11586,7 +11591,6 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 	mboxq->mbox_cmpl = lpfc_mbx_cmpl_read_fcf_record;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
-		lpfc_sli4_mbox_cmd_free(phba, mboxq);
 		error = -EIO;
 	} else {
 		spin_lock_irq(&phba->hbalock);
@@ -11594,6 +11598,15 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 		spin_unlock_irq(&phba->hbalock);
 		error = 0;
 	}
+fail_fcfscan:
+	if (error) {
+		if (mboxq)
+			lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		/* FCF scan failed, clear FCF_DISC_INPROGRESS flag */
+		spin_lock_irq(&phba->hbalock);
+		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
+		spin_unlock_irq(&phba->hbalock);
+	}
 	return error;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2009-06-29 10:31:11.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2009-10-01 17:20:05.000000000 -0400
@@ -29,14 +29,17 @@ typedef enum _lpfc_ctx_cmd {
 	LPFC_CTX_HOST
 } lpfc_ctx_cmd;
 
-/* This structure is used to carry the needed response IOCB states */
-struct lpfc_sli4_rspiocb_info {
-	uint8_t hw_status;
-	uint8_t bfield;
-#define LPFC_XB	0x1
-#define LPFC_PV	0x2
-	uint8_t priority;
-	uint8_t reserved;
+struct lpfc_cq_event {
+	struct list_head list;
+	union {
+		struct lpfc_mcqe		mcqe_cmpl;
+		struct lpfc_acqe_link		acqe_link;
+		struct lpfc_acqe_fcoe		acqe_fcoe;
+		struct lpfc_acqe_dcbx		acqe_dcbx;
+		struct lpfc_rcqe		rcqe_cmpl;
+		struct sli4_wcqe_xri_aborted	wcqe_axri;
+		struct lpfc_wcqe_complete	wcqe_cmpl;
+	} cqe;
 };
 
 /* This structure is used to handle IOCB requests / responses */
@@ -76,7 +79,7 @@ struct lpfc_iocbq {
 			   struct lpfc_iocbq *);
 	void (*iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
-	struct lpfc_sli4_rspiocb_info sli4_info;
+	struct lpfc_cq_event cq_event;
 };
 
 #define SLI_IOCB_RET_IOCB      1	/* Return IOCB if cmd ring full */


