From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/6] lpfc 8.3.19: Added support for ELS RRQ command
Date: Sat, 20 Nov 2010 23:11:55 -0500
Message-ID: <1290312715.32645.13.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23292 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752552Ab0KUEOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Nov 2010 23:14:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Added support for ELS RRQ command

- Add new routine lpfc_set_rrq_active() to track XRI qualifier state.
- Add new module parameter lpfc_enable_rrq to control RRQ operation.
- Add logic to ELS RRQ completion handler and xri qualifier timeout
  to clear XRI qualifier state.
- Use OX_ID from XRI_ABORTED_CQE for RRQ payload.
- Tie abort and XRI_ABORTED_CQE andler to RRQ generation.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    7 -
 lpfc_attr.c    |    9 +
 lpfc_crtn.h    |   12 +
 lpfc_disc.h    |   17 ++
 lpfc_els.c     |  232 +++++++++++++++++++++++++++++++++
 lpfc_hbadisc.c |    4 
 lpfc_hw.h      |   18 ++
 lpfc_init.c    |   34 ++++
 lpfc_mem.c     |   10 +
 lpfc_scsi.c    |   82 ++++++++++-
 lpfc_sli.c     |  396 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 lpfc_sli.h     |    1 
 lpfc_sli4.h    |    1 
 13 files changed, 803 insertions(+), 20 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-11-19 16:11:02.000000000 -0500
@@ -1977,6 +1977,13 @@ lpfc_param_show(enable_npiv);
 lpfc_param_init(enable_npiv, 1, 0, 1);
 static DEVICE_ATTR(lpfc_enable_npiv, S_IRUGO, lpfc_enable_npiv_show, NULL);
 
+int lpfc_enable_rrq;
+module_param(lpfc_enable_rrq, int, 0);
+MODULE_PARM_DESC(lpfc_enable_rrq, "Enable RRQ functionality");
+lpfc_param_show(enable_rrq);
+lpfc_param_init(enable_rrq, 0, 0, 1);
+static DEVICE_ATTR(lpfc_enable_rrq, S_IRUGO, lpfc_enable_rrq_show, NULL);
+
 /*
 # lpfc_suppress_link_up:  Bring link up at initialization
 #            0x0  = bring link up (issue MBX_INIT_LINK)
@@ -3394,6 +3401,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_fdmi_on,
 	&dev_attr_lpfc_max_luns,
 	&dev_attr_lpfc_enable_npiv,
+	&dev_attr_lpfc_enable_rrq,
 	&dev_attr_nport_evt_cnt,
 	&dev_attr_board_mode,
 	&dev_attr_max_vpi,
@@ -4610,6 +4618,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_link_speed_init(phba, lpfc_link_speed);
 	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
 	lpfc_enable_npiv_init(phba, lpfc_enable_npiv);
+	lpfc_enable_rrq_init(phba, lpfc_enable_rrq);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
 	lpfc_fcp_wq_count_init(phba, lpfc_fcp_wq_count);
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-11-19 16:11:02.000000000 -0500
@@ -416,5 +416,13 @@ struct lpfc_iocbq *lpfc_sli_ringtx_get(s
 int __lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 	struct lpfc_iocbq *, uint32_t);
 uint32_t lpfc_drain_txq(struct lpfc_hba *);
-
-
+void lpfc_clr_rrq_active(struct lpfc_hba *, uint16_t, struct lpfc_node_rrq *);
+int lpfc_test_rrq_active(struct lpfc_hba *, struct lpfc_nodelist *, uint16_t);
+void lpfc_handle_rrq_active(struct lpfc_hba *);
+int lpfc_send_rrq(struct lpfc_hba *, struct lpfc_node_rrq *);
+int lpfc_set_rrq_active(struct lpfc_hba *, struct lpfc_nodelist *,
+	uint16_t, uint16_t, uint16_t);
+void lpfc_cleanup_wt_rrqs(struct lpfc_hba *);
+void lpfc_cleanup_vports_rrqs(struct lpfc_vport *);
+struct lpfc_node_rrq *lpfc_get_active_rrq(struct lpfc_vport *, uint16_t,
+	uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2010-11-19 16:11:02.000000000 -0500
@@ -68,6 +68,12 @@ struct lpfc_fast_path_event {
 	} un;
 };
 
+#define LPFC_SLI4_MAX_XRI	1024	/* Used to make the ndlp's xri_bitmap */
+#define XRI_BITMAP_ULONGS (LPFC_SLI4_MAX_XRI / BITS_PER_LONG)
+struct lpfc_node_rrqs {
+	unsigned long xri_bitmap[XRI_BITMAP_ULONGS];
+};
+
 struct lpfc_nodelist {
 	struct list_head nlp_listp;
 	struct lpfc_name nlp_portname;
@@ -110,8 +116,19 @@ struct lpfc_nodelist {
 	atomic_t cmd_pending;
 	uint32_t cmd_qdepth;
 	unsigned long last_change_time;
+	struct lpfc_node_rrqs active_rrqs;
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 };
+struct lpfc_node_rrq {
+	struct list_head list;
+	uint16_t xritag;
+	uint16_t send_rrq;
+	uint16_t rxid;
+	uint32_t         nlp_DID;		/* FC D_ID of entry */
+	struct lpfc_vport *vport;
+	struct lpfc_nodelist *ndlp;
+	unsigned long rrq_stop_time;
+};
 
 /* Defines for nlp_flag (uint32) */
 #define NLP_IGNR_REG_CMPL  0x00000001 /* Rcvd rscn before we cmpl reg login */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-11-19 16:11:02.000000000 -0500
@@ -1290,6 +1290,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	uint32_t rc, keepDID = 0;
 	int  put_node;
 	int  put_rport;
+	struct lpfc_node_rrqs rrq;
 
 	/* Fabric nodes can have the same WWPN so we don't bother searching
 	 * by WWPN.  Just return the ndlp that was given to us.
@@ -1307,6 +1308,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 
 	if (new_ndlp == ndlp && NLP_CHK_NODE_ACT(new_ndlp))
 		return ndlp;
+	memset(&rrq.xri_bitmap, 0, sizeof(new_ndlp->active_rrqs.xri_bitmap));
 
 	if (!new_ndlp) {
 		rc = memcmp(&ndlp->nlp_portname, name,
@@ -1327,12 +1329,25 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 		if (!new_ndlp)
 			return ndlp;
 		keepDID = new_ndlp->nlp_DID;
-	} else
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			memcpy(&rrq.xri_bitmap,
+				&new_ndlp->active_rrqs.xri_bitmap,
+				sizeof(new_ndlp->active_rrqs.xri_bitmap));
+	} else {
 		keepDID = new_ndlp->nlp_DID;
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			memcpy(&rrq.xri_bitmap,
+				&new_ndlp->active_rrqs.xri_bitmap,
+				sizeof(new_ndlp->active_rrqs.xri_bitmap));
+	}
 
 	lpfc_unreg_rpi(vport, new_ndlp);
 	new_ndlp->nlp_DID = ndlp->nlp_DID;
 	new_ndlp->nlp_prev_state = ndlp->nlp_prev_state;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		memcpy(new_ndlp->active_rrqs.xri_bitmap,
+			&ndlp->active_rrqs.xri_bitmap,
+			sizeof(ndlp->active_rrqs.xri_bitmap));
 
 	if (ndlp->nlp_flag & NLP_NPR_2B_DISC)
 		new_ndlp->nlp_flag |= NLP_NPR_2B_DISC;
@@ -1371,12 +1386,20 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 
 		/* Two ndlps cannot have the same did on the nodelist */
 		ndlp->nlp_DID = keepDID;
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			memcpy(&ndlp->active_rrqs.xri_bitmap,
+				&rrq.xri_bitmap,
+				sizeof(ndlp->active_rrqs.xri_bitmap));
 		lpfc_drop_node(vport, ndlp);
 	}
 	else {
 		lpfc_unreg_rpi(vport, ndlp);
 		/* Two ndlps cannot have the same did */
 		ndlp->nlp_DID = keepDID;
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			memcpy(&ndlp->active_rrqs.xri_bitmap,
+				&rrq.xri_bitmap,
+				sizeof(ndlp->active_rrqs.xri_bitmap));
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		/* Since we are swapping the ndlp passed in with the new one
 		 * and the did has already been swapped, copy over the
@@ -1437,6 +1460,73 @@ lpfc_end_rscn(struct lpfc_vport *vport)
 }
 
 /**
+ * lpfc_cmpl_els_rrq - Completion handled for els RRQs.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ * This routine will call the clear rrq function to free the rrq and
+ * clear the xri's bit in the ndlp's xri_bitmap. If the ndlp does not
+ * exist then the clear_rrq is still called because the rrq needs to
+ * be freed.
+ **/
+
+static void
+lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		    struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	IOCB_t *irsp;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_node_rrq *rrq;
+
+	/* we pass cmdiocb to state machine which needs rspiocb as well */
+	rrq = cmdiocb->context_un.rrq;
+	cmdiocb->context_un.rsp_iocb = rspiocb;
+
+	irsp = &rspiocb->iocb;
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
+		"RRQ cmpl:      status:x%x/x%x did:x%x",
+		irsp->ulpStatus, irsp->un.ulpWord[4],
+		irsp->un.elsreq64.remoteID);
+
+	ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) || ndlp != rrq->ndlp) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "2882 RRQ completes to NPort x%x "
+				 "with no ndlp. Data: x%x x%x x%x\n",
+				 irsp->un.elsreq64.remoteID,
+				 irsp->ulpStatus, irsp->un.ulpWord[4],
+				 irsp->ulpIoTag);
+		goto out;
+	}
+
+	/* rrq completes to NPort <nlp_DID> */
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "2880 RRQ completes to NPort x%x "
+			 "Data: x%x x%x x%x x%x x%x\n",
+			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
+			 irsp->ulpTimeout, rrq->xritag, rrq->rxid);
+
+	if (irsp->ulpStatus) {
+		/* Check for retry */
+		/* RRQ failed Don't print the vport to vport rjts */
+		if (irsp->ulpStatus != IOSTAT_LS_RJT ||
+			(((irsp->un.ulpWord[4]) >> 16 != LSRJT_INVALID_CMD) &&
+			((irsp->un.ulpWord[4]) >> 16 != LSRJT_UNABLE_TPC)) ||
+			(phba)->pport->cfg_log_verbose & LOG_ELS)
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "2881 RRQ failure DID:%06X Status:x%x/x%x\n",
+				 ndlp->nlp_DID, irsp->ulpStatus,
+				 irsp->un.ulpWord[4]);
+	}
+out:
+	if (rrq)
+		lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
+	lpfc_els_free_iocb(phba, cmdiocb);
+	return;
+}
+/**
  * lpfc_cmpl_els_plogi - Completion callback function for plogi
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
@@ -3913,6 +4003,47 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport 
 }
 
 /**
+ * lpfc_els_clear_rrq - Clear the rq that this rrq describes.
+ * @vport: pointer to a virtual N_Port data structure.
+ * @iocb: pointer to the lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * Return
+ **/
+static void
+lpfc_els_clear_rrq(struct lpfc_vport *vport,
+      struct lpfc_iocbq *iocb, struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_hba  *phba = vport->phba;
+	uint8_t *pcmd;
+	struct RRQ *rrq;
+	uint16_t rxid;
+	struct lpfc_node_rrq *prrq;
+
+
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) iocb->context2)->virt);
+	pcmd += sizeof(uint32_t);
+	rrq = (struct RRQ *)pcmd;
+	rxid = bf_get(rrq_oxid, rrq);
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			"2883 Clear RRQ for SID:x%x OXID:x%x RXID:x%x"
+			" x%x x%x\n",
+			bf_get(rrq_did, rrq),
+			bf_get(rrq_oxid, rrq),
+			rxid,
+			iocb->iotag, iocb->iocb.ulpContext);
+
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
+		"Clear RRQ:  did:x%x flg:x%x exchg:x%.08x",
+		ndlp->nlp_DID, ndlp->nlp_flag, rrq->rrq_exchg);
+	prrq = lpfc_get_active_rrq(vport, rxid, ndlp->nlp_DID);
+	if (prrq)
+		lpfc_clr_rrq_active(phba, rxid, prrq);
+	return;
+}
+
+/**
  * lpfc_els_rsp_echo_acc - Issue echo acc response
  * @vport: pointer to a virtual N_Port data structure.
  * @data: pointer to echo data to return in the accept.
@@ -4801,6 +4932,8 @@ lpfc_els_rcv_rrq(struct lpfc_vport *vpor
 		 struct lpfc_nodelist *ndlp)
 {
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
+	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+		lpfc_els_clear_rrq(vport, cmdiocb, ndlp);
 }
 
 /**
@@ -5203,6 +5336,97 @@ reject_out:
 	return 0;
 }
 
+/* lpfc_issue_els_rrq - Process an unsolicited rps iocb
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @did: DID of the target.
+ * @rrq: Pointer to the rrq struct.
+ *
+ * Build a ELS RRQ command and send it to the target. If the issue_iocb is
+ * Successful the the completion handler will clear the RRQ.
+ *
+ * Return codes
+ *   0 - Successfully sent rrq els iocb.
+ *   1 - Failed to send rrq els iocb.
+ **/
+static int
+lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
+			uint32_t did, struct lpfc_node_rrq *rrq)
+{
+	struct lpfc_hba  *phba = vport->phba;
+	struct RRQ *els_rrq;
+	IOCB_t *icmd;
+	struct lpfc_iocbq *elsiocb;
+	uint8_t *pcmd;
+	uint16_t cmdsize;
+	int ret;
+
+
+	if (ndlp != rrq->ndlp)
+		ndlp = rrq->ndlp;
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		return 1;
+
+	/* If ndlp is not NULL, we will bump the reference count on it */
+	cmdsize = (sizeof(uint32_t) + sizeof(struct RRQ));
+	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, 0, ndlp, did,
+				     ELS_CMD_RRQ);
+	if (!elsiocb)
+		return 1;
+
+	icmd = &elsiocb->iocb;
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+
+	/* For RRQ request, remainder of payload is Exchange IDs */
+	*((uint32_t *) (pcmd)) = ELS_CMD_RRQ;
+	pcmd += sizeof(uint32_t);
+	els_rrq = (struct RRQ *) pcmd;
+
+	bf_set(rrq_oxid, els_rrq, rrq->xritag);
+	bf_set(rrq_rxid, els_rrq, rrq->rxid);
+	bf_set(rrq_did, els_rrq, vport->fc_myDID);
+	els_rrq->rrq = cpu_to_be32(els_rrq->rrq);
+	els_rrq->rrq_exchg = cpu_to_be32(els_rrq->rrq_exchg);
+
+
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
+		"Issue RRQ:     did:x%x",
+		did, rrq->xritag, rrq->rxid);
+	elsiocb->context_un.rrq = rrq;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rrq;
+	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
+
+	if (ret == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
+	return 0;
+}
+
+/**
+ * lpfc_send_rrq - Sends ELS RRQ if needed.
+ * @phba: pointer to lpfc hba data structure.
+ * @rrq: pointer to the active rrq.
+ *
+ * This routine will call the lpfc_issue_els_rrq if the rrq is
+ * still active for the xri. If this function returns a failure then
+ * the caller needs to clean up the RRQ by calling lpfc_clr_active_rrq.
+ *
+ * Returns 0 Success.
+ *         1 Failure.
+ **/
+int
+lpfc_send_rrq(struct lpfc_hba *phba, struct lpfc_node_rrq *rrq)
+{
+	struct lpfc_nodelist *ndlp = lpfc_findnode_did(rrq->vport,
+							rrq->nlp_DID);
+	if (lpfc_test_rrq_active(phba, ndlp, rrq->xritag))
+		return lpfc_issue_els_rrq(rrq->vport, ndlp,
+					 rrq->nlp_DID, rrq);
+	else
+		return 1;
+}
+
 /**
  * lpfc_els_rsp_rpl_acc - Issue an accept rpl els command
  * @vport: pointer to a host virtual N_Port data structure.
@@ -7373,8 +7597,11 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hb
 			  struct sli4_wcqe_xri_aborted *axri)
 {
 	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
+	uint16_t rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
+
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
 	unsigned long iflag = 0;
+	struct lpfc_nodelist *ndlp;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
@@ -7383,11 +7610,14 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hb
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->sli4_xritag == xri) {
 			list_del(&sglq_entry->list);
+			ndlp = sglq_entry->ndlp;
+			sglq_entry->ndlp = NULL;
 			list_add_tail(&sglq_entry->list,
 				&phba->sli4_hba.lpfc_sgl_list);
 			sglq_entry->state = SGL_FREED;
 			spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			lpfc_set_rrq_active(phba, ndlp, xri, rxid, 1);
 
 			/* Check if TXQ queue needs to be serviced */
 			if (pring->txq_cnt)
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-11-19 16:11:02.000000000 -0500
@@ -486,7 +486,7 @@ struct lpfc_hba {
 	int (*lpfc_new_scsi_buf)
 		(struct lpfc_vport *, int);
 	struct lpfc_scsi_buf * (*lpfc_get_scsi_buf)
-		(struct lpfc_hba *);
+		(struct lpfc_hba *, struct lpfc_nodelist *);
 	int (*lpfc_scsi_prep_dma_buf)
 		(struct lpfc_hba *, struct lpfc_scsi_buf *);
 	void (*lpfc_scsi_unprep_dma_buf)
@@ -574,6 +574,7 @@ struct lpfc_hba {
 #define HBA_FIP_SUPPORT		0x800 /* FIP support in HBA */
 #define HBA_AER_ENABLED		0x1000 /* AER enabled with HBA */
 #define HBA_DEVLOSS_TMO         0x2000 /* HBA in devloss timeout */
+#define HBA_RRQ_ACTIVE		0x4000 /* process the rrq active list */
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
@@ -623,6 +624,7 @@ struct lpfc_hba {
 	/* HBA Config Parameters */
 	uint32_t cfg_ack0;
 	uint32_t cfg_enable_npiv;
+	uint32_t cfg_enable_rrq;
 	uint32_t cfg_topology;
 	uint32_t cfg_link_speed;
 	uint32_t cfg_cr_delay;
@@ -733,6 +735,7 @@ struct lpfc_hba {
 	uint32_t total_scsi_bufs;
 	struct list_head lpfc_iocb_list;
 	uint32_t total_iocbq_bufs;
+	struct list_head active_rrq_list;
 	spinlock_t hbalock;
 
 	/* pci_mem_pools */
@@ -745,6 +748,7 @@ struct lpfc_hba {
 
 	mempool_t *mbox_mem_pool;
 	mempool_t *nlp_mem_pool;
+	mempool_t *rrq_pool;
 
 	struct fc_host_statistics link_stats;
 	enum intr_type_t intr_type;
@@ -801,6 +805,7 @@ struct lpfc_hba {
 	unsigned long skipped_hb;
 	struct timer_list hb_tmofunc;
 	uint8_t hb_outstanding;
+	struct timer_list rrq_tmr;
 	enum hba_temp_state over_temp_state;
 	/* ndlp reference management */
 	spinlock_t ndlp_lock;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-11-19 16:11:02.000000000 -0500
@@ -607,6 +607,8 @@ lpfc_work_done(struct lpfc_hba *phba)
 
 	/* Process SLI4 events */
 	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC) {
+		if (phba->hba_flag & HBA_RRQ_ACTIVE)
+			lpfc_handle_rrq_active(phba);
 		if (phba->hba_flag & FCP_XRI_ABORT_EVENT)
 			lpfc_sli4_fcp_xri_abort_event_proc(phba);
 		if (phba->hba_flag & ELS_XRI_ABORT_EVENT)
@@ -966,6 +968,7 @@ lpfc_linkup(struct lpfc_hba *phba)
 	struct lpfc_vport **vports;
 	int i;
 
+	lpfc_cleanup_wt_rrqs(phba);
 	phba->link_state = LPFC_LINK_UP;
 
 	/* Unblock fabric iocbs if they are blocked */
@@ -3161,6 +3164,7 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba 
 	spin_unlock_irq(shost->host_lock);
 	vport->unreg_vpi_cmpl = VPORT_OK;
 	mempool_free(pmb, phba->mbox_mem_pool);
+	lpfc_cleanup_vports_rrqs(vport);
 	/*
 	 * This shost reference might have been taken at the beginning of
 	 * lpfc_vport_delete()
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-11-19 16:11:02.000000000 -0500
@@ -880,6 +880,24 @@ struct  RLS_RSP {		/* Structure is in Bi
 	uint32_t crcCnt;
 };
 
+struct RRQ {			/* Structure is in Big Endian format */
+	uint32_t rrq;
+#define rrq_rsvd_SHIFT		24
+#define rrq_rsvd_MASK		0x000000ff
+#define rrq_rsvd_WORD		rrq
+#define rrq_did_SHIFT		0
+#define rrq_did_MASK		0x00ffffff
+#define rrq_did_WORD		rrq
+	uint32_t rrq_exchg;
+#define rrq_oxid_SHIFT		16
+#define rrq_oxid_MASK		0xffff
+#define rrq_oxid_WORD		rrq_exchg
+#define rrq_rxid_SHIFT		0
+#define rrq_rxid_MASK		0xffff
+#define rrq_rxid_WORD		rrq_exchg
+};
+
+
 struct RTV_RSP {		/* Structure is in Big Endian format */
 	uint32_t ratov;
 	uint32_t edtov;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-11-19 16:11:02.000000000 -0500
@@ -930,6 +930,35 @@ lpfc_hb_timeout(unsigned long ptr)
 }
 
 /**
+ * lpfc_rrq_timeout - The RRQ-timer timeout handler
+ * @ptr: unsigned long holds the pointer to lpfc hba data structure.
+ *
+ * This is the RRQ-timer timeout handler registered to the lpfc driver. When
+ * this timer fires, a RRQ timeout event shall be posted to the lpfc driver
+ * work-port-events bitmap and the worker thread is notified. This timeout
+ * event will be used by the worker thread to invoke the actual timeout
+ * handler routine, lpfc_rrq_handler. Any periodical operations will
+ * be performed in the timeout handler and the RRQ timeout event bit shall
+ * be cleared by the worker thread after it has taken the event bitmap out.
+ **/
+static void
+lpfc_rrq_timeout(unsigned long ptr)
+{
+	struct lpfc_hba *phba;
+	uint32_t tmo_posted;
+	unsigned long iflag;
+
+	phba = (struct lpfc_hba *)ptr;
+	spin_lock_irqsave(&phba->pport->work_port_lock, iflag);
+	tmo_posted = phba->hba_flag & HBA_RRQ_ACTIVE;
+	if (!tmo_posted)
+		phba->hba_flag |= HBA_RRQ_ACTIVE;
+	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflag);
+	if (!tmo_posted)
+		lpfc_worker_wake_up(phba);
+}
+
+/**
  * lpfc_hb_mbox_cmpl - The lpfc heart-beat mailbox command callback function
  * @phba: pointer to lpfc hba data structure.
  * @pmboxq: pointer to the driver internal queue element for mailbox command.
@@ -3990,6 +4019,9 @@ lpfc_sli4_driver_resource_setup(struct l
 	init_timer(&phba->hb_tmofunc);
 	phba->hb_tmofunc.function = lpfc_hb_timeout;
 	phba->hb_tmofunc.data = (unsigned long)phba;
+	init_timer(&phba->rrq_tmr);
+	phba->rrq_tmr.function = lpfc_rrq_timeout;
+	phba->rrq_tmr.data = (unsigned long)phba;
 
 	psli = &phba->sli;
 	/* MBOX heartbeat timer */
@@ -8192,6 +8224,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 		goto out_unset_driver_resource_s4;
 	}
 
+	INIT_LIST_HEAD(&phba->active_rrq_list);
+
 	/* Set up common device driver resources */
 	error = lpfc_setup_driver_resource_phase2(phba);
 	if (error) {
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2010-11-19 16:11:02.000000000 -0500
@@ -113,11 +113,16 @@ lpfc_mem_alloc(struct lpfc_hba *phba, in
 		goto fail_free_mbox_pool;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
+		phba->rrq_pool =
+			mempool_create_kmalloc_pool(LPFC_MEM_POOL_SIZE,
+						sizeof(struct lpfc_node_rrq));
+		if (!phba->rrq_pool)
+			goto fail_free_nlp_mem_pool;
 		phba->lpfc_hrb_pool = pci_pool_create("lpfc_hrb_pool",
 					      phba->pcidev,
 					      LPFC_HDR_BUF_SIZE, align, 0);
 		if (!phba->lpfc_hrb_pool)
-			goto fail_free_nlp_mem_pool;
+			goto fail_free_rrq_mem_pool;
 
 		phba->lpfc_drb_pool = pci_pool_create("lpfc_drb_pool",
 					      phba->pcidev,
@@ -147,6 +152,9 @@ lpfc_mem_alloc(struct lpfc_hba *phba, in
  fail_free_hrb_pool:
 	pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
+ fail_free_rrq_mem_pool:
+	mempool_destroy(phba->rrq_pool);
+	phba->rrq_pool = NULL;
  fail_free_nlp_mem_pool:
 	mempool_destroy(phba->nlp_mem_pool);
 	phba->nlp_mem_pool = NULL;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-11-19 16:11:02.000000000 -0500
@@ -621,10 +621,13 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hb
 			  struct sli4_wcqe_xri_aborted *axri)
 {
 	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
+	uint16_t rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
 	struct lpfc_scsi_buf *psb, *next_psb;
 	unsigned long iflag = 0;
 	struct lpfc_iocbq *iocbq;
 	int i;
+	struct lpfc_nodelist *ndlp;
+	int rrq_empty = 0;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
@@ -637,8 +640,14 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hb
 			psb->status = IOSTAT_SUCCESS;
 			spin_unlock(
 				&phba->sli4_hba.abts_scsi_buf_list_lock);
+			ndlp = psb->rdata->pnode;
+			rrq_empty = list_empty(&phba->active_rrq_list);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			if (ndlp)
+				lpfc_set_rrq_active(phba, ndlp, xri, rxid, 1);
 			lpfc_release_scsi_buf_s4(phba, psb);
+			if (rrq_empty)
+				lpfc_worker_wake_up(phba);
 			return;
 		}
 	}
@@ -914,7 +923,7 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_get_scsi_buf - Get a scsi buffer from lpfc_scsi_buf_list of the HBA
+ * lpfc_get_scsi_buf_s3 - Get a scsi buffer from lpfc_scsi_buf_list of the HBA
  * @phba: The HBA for which this call is being executed.
  *
  * This routine removes a scsi buffer from head of @phba lpfc_scsi_buf_list list
@@ -925,7 +934,7 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
  *   Pointer to lpfc_scsi_buf - Success
  **/
 static struct lpfc_scsi_buf*
-lpfc_get_scsi_buf(struct lpfc_hba * phba)
+lpfc_get_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	struct  lpfc_scsi_buf * lpfc_cmd = NULL;
 	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
@@ -941,6 +950,67 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba
 	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
 	return  lpfc_cmd;
 }
+/**
+ * lpfc_get_scsi_buf_s4 - Get a scsi buffer from lpfc_scsi_buf_list of the HBA
+ * @phba: The HBA for which this call is being executed.
+ *
+ * This routine removes a scsi buffer from head of @phba lpfc_scsi_buf_list list
+ * and returns to caller.
+ *
+ * Return codes:
+ *   NULL - Error
+ *   Pointer to lpfc_scsi_buf - Success
+ **/
+static struct lpfc_scsi_buf*
+lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+{
+	struct  lpfc_scsi_buf *lpfc_cmd = NULL;
+	struct  lpfc_scsi_buf *start_lpfc_cmd = NULL;
+	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
+	unsigned long iflag = 0;
+	int found = 0;
+
+	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
+	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
+	while (!found && lpfc_cmd) {
+		if (lpfc_test_rrq_active(phba, ndlp,
+					 lpfc_cmd->cur_iocbq.sli4_xritag)) {
+			lpfc_release_scsi_buf_s4(phba, lpfc_cmd);
+			spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
+			list_remove_head(scsi_buf_list, lpfc_cmd,
+					 struct lpfc_scsi_buf, list);
+			spin_unlock_irqrestore(&phba->scsi_buf_list_lock,
+						 iflag);
+			if (lpfc_cmd == start_lpfc_cmd) {
+				lpfc_cmd = NULL;
+				break;
+			} else
+				continue;
+		}
+		found = 1;
+		lpfc_cmd->seg_cnt = 0;
+		lpfc_cmd->nonsg_phys = 0;
+		lpfc_cmd->prot_seg_cnt = 0;
+	}
+	return  lpfc_cmd;
+}
+/**
+ * lpfc_get_scsi_buf - Get a scsi buffer from lpfc_scsi_buf_list of the HBA
+ * @phba: The HBA for which this call is being executed.
+ *
+ * This routine removes a scsi buffer from head of @phba lpfc_scsi_buf_list list
+ * and returns to caller.
+ *
+ * Return codes:
+ *   NULL - Error
+ *   Pointer to lpfc_scsi_buf - Success
+ **/
+static struct lpfc_scsi_buf*
+lpfc_get_scsi_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+{
+	return  phba->lpfc_get_scsi_buf(phba, ndlp);
+}
 
 /**
  * lpfc_release_scsi_buf - Return a scsi buffer back to hba scsi buf list
@@ -2744,18 +2814,19 @@ lpfc_scsi_api_table_setup(struct lpfc_hb
 
 	phba->lpfc_scsi_unprep_dma_buf = lpfc_scsi_unprep_dma_buf;
 	phba->lpfc_scsi_prep_cmnd = lpfc_scsi_prep_cmnd;
-	phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf;
 
 	switch (dev_grp) {
 	case LPFC_PCI_DEV_LP:
 		phba->lpfc_new_scsi_buf = lpfc_new_scsi_buf_s3;
 		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s3;
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s3;
+		phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf_s3;
 		break;
 	case LPFC_PCI_DEV_OC:
 		phba->lpfc_new_scsi_buf = lpfc_new_scsi_buf_s4;
 		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s4;
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s4;
+		phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf_s4;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -2764,7 +2835,6 @@ lpfc_scsi_api_table_setup(struct lpfc_hb
 		return -ENODEV;
 		break;
 	}
-	phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf;
 	phba->lpfc_rampdown_queue_depth = lpfc_rampdown_queue_depth;
 	phba->lpfc_scsi_cmd_iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
 	return 0;
@@ -2940,7 +3010,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
 		goto out_host_busy;
 
-	lpfc_cmd = lpfc_get_scsi_buf(phba);
+	lpfc_cmd = lpfc_get_scsi_buf(phba, ndlp);
 	if (lpfc_cmd == NULL) {
 		lpfc_rampdown_queue_depth(phba);
 
@@ -3237,7 +3307,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 		return FAILED;
 
-	lpfc_cmd = lpfc_get_scsi_buf(phba);
+	lpfc_cmd = lpfc_get_scsi_buf(phba, rdata->pnode);
 	if (lpfc_cmd == NULL)
 		return FAILED;
 	lpfc_cmd->timeout = 60;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-11-19 16:11:02.000000000 -0500
@@ -466,6 +466,7 @@ struct lpfc_sglq {
 	struct list_head clist;
 	enum lpfc_sge_type buff_type; /* is this a scsi sgl */
 	enum lpfc_sgl_state state;
+	struct lpfc_nodelist *ndlp; /* ndlp associated with IO */
 	uint16_t iotag;         /* pre-assigned IO tag */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
 	struct sli4_sge *sgl;	/* pre-assigned SGL */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-11-19 16:10:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-11-19 16:11:02.000000000 -0500
@@ -513,8 +513,344 @@ __lpfc_get_active_sglq(struct lpfc_hba *
 }
 
 /**
+ * __lpfc_set_rrq_active - set RRQ active bit in the ndlp's xri_bitmap.
+ * @phba: Pointer to HBA context object.
+ * @ndlp: nodelist pointer for this target.
+ * @xritag: xri used in this exchange.
+ * @rxid: Remote Exchange ID.
+ * @send_rrq: Flag used to determine if we should send rrq els cmd.
+ *
+ * This function is called with hbalock held.
+ * The active bit is set in the ndlp's active rrq xri_bitmap. Allocates an
+ * rrq struct and adds it to the active_rrq_list.
+ *
+ * returns  0 for rrq slot for this xri
+ *         < 0  Were not able to get rrq mem or invalid parameter.
+ **/
+static int
+__lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
+		uint16_t xritag, uint16_t rxid, uint16_t send_rrq)
+{
+	uint16_t adj_xri;
+	struct lpfc_node_rrq *rrq;
+	int empty;
+
+	/*
+	 * set the active bit even if there is no mem available.
+	 */
+	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
+	if (!ndlp)
+		return -EINVAL;
+	if (test_and_set_bit(adj_xri, ndlp->active_rrqs.xri_bitmap))
+		return -EINVAL;
+	rrq = mempool_alloc(phba->rrq_pool, GFP_KERNEL);
+	if (rrq) {
+		rrq->send_rrq = send_rrq;
+		rrq->xritag = xritag;
+		rrq->rrq_stop_time = jiffies + HZ * (phba->fc_ratov + 1);
+		rrq->ndlp = ndlp;
+		rrq->nlp_DID = ndlp->nlp_DID;
+		rrq->vport = ndlp->vport;
+		rrq->rxid = rxid;
+		empty = list_empty(&phba->active_rrq_list);
+		if (phba->cfg_enable_rrq && send_rrq)
+			/*
+			 * We need the xri before we can add this to the
+			 * phba active rrq list.
+			 */
+			rrq->send_rrq = send_rrq;
+		else
+			rrq->send_rrq = 0;
+		list_add_tail(&rrq->list, &phba->active_rrq_list);
+		if (!(phba->hba_flag & HBA_RRQ_ACTIVE)) {
+			phba->hba_flag |= HBA_RRQ_ACTIVE;
+			if (empty)
+				lpfc_worker_wake_up(phba);
+		}
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+/**
+ * __lpfc_clr_rrq_active - Clears RRQ active bit in xri_bitmap.
+ * @phba: Pointer to HBA context object.
+ * @xritag: xri used in this exchange.
+ * @rrq: The RRQ to be cleared.
+ *
+ * This function is called with hbalock held. This function
+ **/
+static void
+__lpfc_clr_rrq_active(struct lpfc_hba *phba,
+			uint16_t xritag,
+			struct lpfc_node_rrq *rrq)
+{
+	uint16_t adj_xri;
+	struct lpfc_nodelist *ndlp;
+
+	ndlp = lpfc_findnode_did(rrq->vport, rrq->nlp_DID);
+
+	/* The target DID could have been swapped (cable swap)
+	 * we should use the ndlp from the findnode if it is
+	 * available.
+	 */
+	if (!ndlp)
+		ndlp = rrq->ndlp;
+
+	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
+	if (test_and_clear_bit(adj_xri, ndlp->active_rrqs.xri_bitmap)) {
+		rrq->send_rrq = 0;
+		rrq->xritag = 0;
+		rrq->rrq_stop_time = 0;
+	}
+	mempool_free(rrq, phba->rrq_pool);
+}
+
+/**
+ * lpfc_handle_rrq_active - Checks if RRQ has waithed RATOV.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called with hbalock held. This function
+ * Checks if stop_time (ratov from setting rrq active) has
+ * been reached, if it has and the send_rrq flag is set then
+ * it will call lpfc_send_rrq. If the send_rrq flag is not set
+ * then it will just call the routine to clear the rrq and
+ * free the rrq resource.
+ * The timer is set to the next rrq that is going to expire before
+ * leaving the routine.
+ *
+ **/
+void
+lpfc_handle_rrq_active(struct lpfc_hba *phba)
+{
+	struct lpfc_node_rrq *rrq;
+	struct lpfc_node_rrq *nextrrq;
+	unsigned long next_time;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	phba->hba_flag &= ~HBA_RRQ_ACTIVE;
+	next_time = jiffies + HZ * (phba->fc_ratov + 1);
+	list_for_each_entry_safe(rrq, nextrrq,
+			&phba->active_rrq_list, list) {
+		if (time_after(jiffies, rrq->rrq_stop_time)) {
+			list_del(&rrq->list);
+			if (!rrq->send_rrq)
+				/* this call will free the rrq */
+				__lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
+			else {
+			/* if we send the rrq then the completion handler
+			 *  will clear the bit in the xribitmap.
+			 */
+				spin_unlock_irqrestore(&phba->hbalock, iflags);
+				if (lpfc_send_rrq(phba, rrq)) {
+					lpfc_clr_rrq_active(phba, rrq->xritag,
+								 rrq);
+				}
+				spin_lock_irqsave(&phba->hbalock, iflags);
+			}
+		} else if  (time_before(rrq->rrq_stop_time, next_time))
+			next_time = rrq->rrq_stop_time;
+	}
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	if (!list_empty(&phba->active_rrq_list))
+		mod_timer(&phba->rrq_tmr, next_time);
+}
+
+/**
+ * lpfc_get_active_rrq - Get the active RRQ for this exchange.
+ * @vport: Pointer to vport context object.
+ * @xri: The xri used in the exchange.
+ * @did: The targets DID for this exchange.
+ *
+ * returns NULL = rrq not found in the phba->active_rrq_list.
+ *         rrq = rrq for this xri and target.
+ **/
+struct lpfc_node_rrq *
+lpfc_get_active_rrq(struct lpfc_vport *vport, uint16_t xri, uint32_t did)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_node_rrq *rrq;
+	struct lpfc_node_rrq *nextrrq;
+	unsigned long iflags;
+
+	if (phba->sli_rev != LPFC_SLI_REV4)
+		return NULL;
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list) {
+		if (rrq->vport == vport && rrq->xritag == xri &&
+				rrq->nlp_DID == did){
+			list_del(&rrq->list);
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			return rrq;
+		}
+	}
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return NULL;
+}
+
+/**
+ * lpfc_cleanup_vports_rrqs - Remove and clear the active RRQ for this vport.
+ * @vport: Pointer to vport context object.
+ *
+ * Remove all active RRQs for this vport from the phba->active_rrq_list and
+ * clear the rrq.
+ **/
+void
+lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport)
+
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_node_rrq *rrq;
+	struct lpfc_node_rrq *nextrrq;
+	unsigned long iflags;
+
+	if (phba->sli_rev != LPFC_SLI_REV4)
+		return;
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list) {
+		if (rrq->vport == vport) {
+			list_del(&rrq->list);
+			__lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
+		}
+	}
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+}
+
+/**
+ * lpfc_cleanup_wt_rrqs - Remove all rrq's from the active list.
+ * @phba: Pointer to HBA context object.
+ *
+ * Remove all rrqs from the phba->active_rrq_list and free them by
+ * calling __lpfc_clr_active_rrq
+ *
+ **/
+void
+lpfc_cleanup_wt_rrqs(struct lpfc_hba *phba)
+{
+	struct lpfc_node_rrq *rrq;
+	struct lpfc_node_rrq *nextrrq;
+	unsigned long next_time;
+	unsigned long iflags;
+
+	if (phba->sli_rev != LPFC_SLI_REV4)
+		return;
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	phba->hba_flag &= ~HBA_RRQ_ACTIVE;
+	next_time = jiffies + HZ * (phba->fc_ratov * 2);
+	list_for_each_entry_safe(rrq, nextrrq, &phba->active_rrq_list, list) {
+		list_del(&rrq->list);
+		__lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
+	}
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	if (!list_empty(&phba->active_rrq_list))
+		mod_timer(&phba->rrq_tmr, next_time);
+}
+
+
+/**
+ * __lpfc_test_rrq_active - Test RRQ bit in xri_bitmap.
+ * @phba: Pointer to HBA context object.
+ * @ndlp: Targets nodelist pointer for this exchange.
+ * @xritag the xri in the bitmap to test.
+ *
+ * This function is called with hbalock held. This function
+ * returns 0 = rrq not active for this xri
+ *         1 = rrq is valid for this xri.
+ **/
+static int
+__lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
+			uint16_t  xritag)
+{
+	uint16_t adj_xri;
+
+	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
+	if (!ndlp)
+		return 0;
+	if (test_bit(adj_xri, ndlp->active_rrqs.xri_bitmap))
+			return 1;
+	else
+		return 0;
+}
+
+/**
+ * lpfc_set_rrq_active - set RRQ active bit in xri_bitmap.
+ * @phba: Pointer to HBA context object.
+ * @ndlp: nodelist pointer for this target.
+ * @xritag: xri used in this exchange.
+ * @rxid: Remote Exchange ID.
+ * @send_rrq: Flag used to determine if we should send rrq els cmd.
+ *
+ * This function takes the hbalock.
+ * The active bit is always set in the active rrq xri_bitmap even
+ * if there is no slot avaiable for the other rrq information.
+ *
+ * returns 0 rrq actived for this xri
+ *         < 0 No memory or invalid ndlp.
+ **/
+int
+lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
+			uint16_t xritag, uint16_t rxid, uint16_t send_rrq)
+{
+	int ret;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	ret = __lpfc_set_rrq_active(phba, ndlp, xritag, rxid, send_rrq);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return ret;
+}
+
+/**
+ * lpfc_clr_rrq_active - Clears RRQ active bit in xri_bitmap.
+ * @phba: Pointer to HBA context object.
+ * @xritag: xri used in this exchange.
+ * @rrq: The RRQ to be cleared.
+ *
+ * This function is takes the hbalock.
+ **/
+void
+lpfc_clr_rrq_active(struct lpfc_hba *phba,
+			uint16_t xritag,
+			struct lpfc_node_rrq *rrq)
+{
+	unsigned long iflags;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	__lpfc_clr_rrq_active(phba, xritag, rrq);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return;
+}
+
+
+
+/**
+ * lpfc_test_rrq_active - Test RRQ bit in xri_bitmap.
+ * @phba: Pointer to HBA context object.
+ * @ndlp: Targets nodelist pointer for this exchange.
+ * @xritag the xri in the bitmap to test.
+ *
+ * This function takes the hbalock.
+ * returns 0 = rrq not active for this xri
+ *         1 = rrq is valid for this xri.
+ **/
+int
+lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
+			uint16_t  xritag)
+{
+	int ret;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	ret = __lpfc_test_rrq_active(phba, ndlp, xritag);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return ret;
+}
+
+/**
  * __lpfc_sli_get_sglq - Allocates an iocb object from sgl pool
  * @phba: Pointer to HBA context object.
+ * @piocb: Pointer to the iocbq.
  *
  * This function is called with hbalock held. This function
  * Gets a new driver sglq object from the sglq list. If the
@@ -522,17 +858,53 @@ __lpfc_get_active_sglq(struct lpfc_hba *
  * allocated sglq object else it returns NULL.
  **/
 static struct lpfc_sglq *
-__lpfc_sli_get_sglq(struct lpfc_hba *phba)
+__lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 {
 	struct list_head *lpfc_sgl_list = &phba->sli4_hba.lpfc_sgl_list;
 	struct lpfc_sglq *sglq = NULL;
+	struct lpfc_sglq *start_sglq = NULL;
 	uint16_t adj_xri;
+	struct lpfc_scsi_buf *lpfc_cmd;
+	struct lpfc_nodelist *ndlp;
+	int found = 0;
+
+	if (piocbq->iocb_flag &  LPFC_IO_FCP) {
+		lpfc_cmd = (struct lpfc_scsi_buf *) piocbq->context1;
+		ndlp = lpfc_cmd->rdata->pnode;
+	} else  if (piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR)
+		ndlp = piocbq->context_un.ndlp;
+	else if (piocbq->iocb.ulpCommand == CMD_XMIT_BLS_RSP64_CX)
+		ndlp = lpfc_findnode_did(piocbq->vport,
+					piocbq->iocb.ulpContext);
+	else
+		ndlp = piocbq->context1;
+
 	list_remove_head(lpfc_sgl_list, sglq, struct lpfc_sglq, list);
-	if (!sglq)
-		return NULL;
-	adj_xri = sglq->sli4_xritag - phba->sli4_hba.max_cfg_param.xri_base;
-	phba->sli4_hba.lpfc_sglq_active_list[adj_xri] = sglq;
-	sglq->state = SGL_ALLOCATED;
+	start_sglq = sglq;
+	while (!found) {
+		if (!sglq)
+			return NULL;
+		adj_xri = sglq->sli4_xritag -
+				phba->sli4_hba.max_cfg_param.xri_base;
+		if (__lpfc_test_rrq_active(phba, ndlp, sglq->sli4_xritag)) {
+			/* This xri has an rrq outstanding for this DID.
+			 * put it back in the list and get another xri.
+			 */
+			list_add_tail(&sglq->list, lpfc_sgl_list);
+			sglq = NULL;
+			list_remove_head(lpfc_sgl_list, sglq,
+						struct lpfc_sglq, list);
+			if (sglq == start_sglq) {
+				sglq = NULL;
+				break;
+			} else
+				continue;
+		}
+		sglq->ndlp = ndlp;
+		found = 1;
+		phba->sli4_hba.lpfc_sglq_active_list[adj_xri] = sglq;
+		sglq->state = SGL_ALLOCATED;
+	}
 	return sglq;
 }
 
@@ -598,6 +970,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 				&phba->sli4_hba.abts_sgl_list_lock, iflag);
 		} else {
 			sglq->state = SGL_FREED;
+			sglq->ndlp = NULL;
 			list_add(&sglq->list, &phba->sli4_hba.lpfc_sgl_list);
 
 			/* Check if TXQ queue needs to be serviced */
@@ -6352,7 +6725,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 					return IOCB_BUSY;
 				}
 			} else {
-			sglq = __lpfc_sli_get_sglq(phba);
+			sglq = __lpfc_sli_get_sglq(phba, piocb);
 				if (!sglq) {
 					if (!(flag & SLI_IOCB_RET_IOCB)) {
 						__lpfc_sli_ringtx_put(phba,
@@ -11570,6 +11943,10 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 				"SID:x%x\n", oxid, sid);
 		return;
 	}
+	if (rxid >= phba->sli4_hba.max_cfg_param.xri_base
+		&& rxid <= (phba->sli4_hba.max_cfg_param.max_xri
+		+ phba->sli4_hba.max_cfg_param.xri_base))
+		lpfc_set_rrq_active(phba, ndlp, rxid, oxid, 0);
 
 	/* Allocate buffer for acc iocb */
 	ctiocb = lpfc_sli_get_iocbq(phba);
@@ -13008,12 +13385,13 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 	while (pring->txq_cnt) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
 
-		sglq = __lpfc_sli_get_sglq(phba);
+		piocbq = lpfc_sli_ringtx_get(phba, pring);
+		sglq = __lpfc_sli_get_sglq(phba, piocbq);
 		if (!sglq) {
+			__lpfc_sli_ringtx_put(phba, pring, piocbq);
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			break;
 		} else {
-			piocbq = lpfc_sli_ringtx_get(phba, pring);
 			if (!piocbq) {
 				/* The txq_cnt out of sync. This should
 				 * never happen
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2010-11-19 16:11:02.000000000 -0500
@@ -82,6 +82,7 @@ struct lpfc_iocbq {
 		struct lpfc_iocbq    *rsp_iocb;
 		struct lpfcMboxq     *mbox;
 		struct lpfc_nodelist *ndlp;
+		struct lpfc_node_rrq *rrq;
 	} context_un;
 
 	void (*fabric_iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,


