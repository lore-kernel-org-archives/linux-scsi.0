From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/11] lpfc 8.3.37: Fixed no-context ABTS failed with BA_RJT
Date: Thu, 3 Jan 2013 15:43:37 -0500
Message-ID: <1357245817.2628.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:50082 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3ACUtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:49:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed no-context ABTS received on unsolicited receive queue failed with BA_RJT


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    8 +--
 lpfc_bsg.c  |   51 ++++++++++++++++++--
 lpfc_crtn.h |    4 -
 lpfc_ct.c   |   37 ++++----------
 lpfc_sli.c  |  151 ++++++++++++++++++++++++++++++++++++++++--------------------
 5 files changed, 168 insertions(+), 83 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2013-01-02 13:13:05.884087717 -0500
@@ -955,9 +955,9 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba
 		spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			evt_dat->immed_dat = phba->ctx_idx;
-			phba->ctx_idx = (phba->ctx_idx + 1) % 64;
+			phba->ctx_idx = (phba->ctx_idx + 1) % LPFC_CT_CTX_MAX;
 			/* Provide warning for over-run of the ct_ctx array */
-			if (phba->ct_ctx[evt_dat->immed_dat].flags &
+			if (phba->ct_ctx[evt_dat->immed_dat].valid ==
 			    UNSOL_VALID)
 				lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
 						"2717 CT context array entry "
@@ -973,7 +973,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba
 				piocbq->iocb.unsli3.rcvsli3.ox_id;
 			phba->ct_ctx[evt_dat->immed_dat].SID =
 				piocbq->iocb.un.rcvels.remoteID;
-			phba->ct_ctx[evt_dat->immed_dat].flags = UNSOL_VALID;
+			phba->ct_ctx[evt_dat->immed_dat].valid = UNSOL_VALID;
 		} else
 			evt_dat->immed_dat = piocbq->iocb.ulpContext;
 
@@ -1013,6 +1013,47 @@ error_ct_unsol_exit:
 }
 
 /**
+ * lpfc_bsg_ct_unsol_abort - handler ct abort to management plane
+ * @phba: Pointer to HBA context object.
+ * @dmabuf: pointer to a dmabuf that describes the FC sequence
+ *
+ * This function handles abort to the CT command toward management plane
+ * for SLI4 port.
+ *
+ * If the pending context of a CT command to management plane present, clears
+ * such context and returns 1 for handled; otherwise, it returns 0 indicating
+ * no context exists.
+ **/
+int
+lpfc_bsg_ct_unsol_abort(struct lpfc_hba *phba, struct hbq_dmabuf *dmabuf)
+{
+	struct fc_frame_header fc_hdr;
+	struct fc_frame_header *fc_hdr_ptr = &fc_hdr;
+	int ctx_idx, handled = 0;
+	uint16_t oxid, rxid;
+	uint32_t sid;
+
+	memcpy(fc_hdr_ptr, dmabuf->hbuf.virt, sizeof(struct fc_frame_header));
+	sid = sli4_sid_from_fc_hdr(fc_hdr_ptr);
+	oxid = be16_to_cpu(fc_hdr_ptr->fh_ox_id);
+	rxid = be16_to_cpu(fc_hdr_ptr->fh_rx_id);
+
+	for (ctx_idx = 0; ctx_idx < LPFC_CT_CTX_MAX; ctx_idx++) {
+		if (phba->ct_ctx[ctx_idx].valid != UNSOL_VALID)
+			continue;
+		if (phba->ct_ctx[ctx_idx].rxid != rxid)
+			continue;
+		if (phba->ct_ctx[ctx_idx].oxid != oxid)
+			continue;
+		if (phba->ct_ctx[ctx_idx].SID != sid)
+			continue;
+		phba->ct_ctx[ctx_idx].valid = UNSOL_INVALID;
+		handled = 1;
+	}
+	return handled;
+}
+
+/**
  * lpfc_bsg_hba_set_event - process a SET_EVENT bsg vendor command
  * @job: SET_EVENT fc_bsg_job
  **/
@@ -1318,7 +1359,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 	icmd->ulpClass = CLASS3;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		/* Do not issue unsol response if oxid not marked as valid */
-		if (!(phba->ct_ctx[tag].flags & UNSOL_VALID)) {
+		if (phba->ct_ctx[tag].valid != UNSOL_VALID) {
 			rc = IOCB_ERROR;
 			goto issue_ct_rsp_exit;
 		}
@@ -1352,7 +1393,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 				phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
 
 		/* The exchange is done, mark the entry as invalid */
-		phba->ct_ctx[tag].flags &= ~UNSOL_VALID;
+		phba->ct_ctx[tag].valid = UNSOL_INVALID;
 	} else
 		icmd->ulpContext = (ushort) tag;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2012-12-12 13:32:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2013-01-02 13:13:05.889087716 -0500
@@ -164,8 +164,7 @@ void lpfc_hb_timeout_handler(struct lpfc
 
 void lpfc_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			 struct lpfc_iocbq *);
-void lpfc_sli4_ct_abort_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
-				    struct lpfc_iocbq *);
+int lpfc_ct_handle_unsol_abort(struct lpfc_hba *, struct hbq_dmabuf *);
 int lpfc_ns_cmd(struct lpfc_vport *, int, uint8_t, uint32_t);
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int);
 void lpfc_fdmi_tmo(unsigned long);
@@ -427,6 +426,7 @@ int lpfc_bsg_request(struct fc_bsg_job *
 int lpfc_bsg_timeout(struct fc_bsg_job *);
 int lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_iocbq *);
+int lpfc_bsg_ct_unsol_abort(struct lpfc_hba *, struct hbq_dmabuf *);
 void __lpfc_sli_ringtx_put(struct lpfc_hba *, struct lpfc_sli_ring *,
 	struct lpfc_iocbq *);
 struct lpfc_iocbq *lpfc_sli_ringtx_get(struct lpfc_hba *,
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2012-12-12 13:32:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2013-01-02 13:13:05.937087718 -0500
@@ -164,37 +164,24 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 }
 
 /**
- * lpfc_sli4_ct_abort_unsol_event - Default handle for sli4 unsol abort
+ * lpfc_ct_handle_unsol_abort - ct upper level protocol abort handler
  * @phba: Pointer to HBA context object.
- * @pring: Pointer to the driver internal I/O ring.
- * @piocbq: Pointer to the IOCBQ.
+ * @dmabuf: pointer to a dmabuf that describes the FC sequence
  *
- * This function serves as the default handler for the sli4 unsolicited
- * abort event. It shall be invoked when there is no application interface
- * registered unsolicited abort handler. This handler does nothing but
- * just simply releases the dma buffer used by the unsol abort event.
+ * This function serves as the upper level protocol abort handler for CT
+ * protocol.
+ *
+ * Return 1 if abort has been handled, 0 otherwise.
  **/
-void
-lpfc_sli4_ct_abort_unsol_event(struct lpfc_hba *phba,
-			       struct lpfc_sli_ring *pring,
-			       struct lpfc_iocbq *piocbq)
+int
+lpfc_ct_handle_unsol_abort(struct lpfc_hba *phba, struct hbq_dmabuf *dmabuf)
 {
-	IOCB_t *icmd = &piocbq->iocb;
-	struct lpfc_dmabuf *bdeBuf;
-	uint32_t size;
+	int handled;
 
-	/* Forward abort event to any process registered to receive ct event */
-	if (lpfc_bsg_ct_unsol_event(phba, pring, piocbq) == 0)
-		return;
+	/* CT upper level goes through BSG */
+	handled = lpfc_bsg_ct_unsol_abort(phba, dmabuf);
 
-	/* If there is no BDE associated with IOCB, there is nothing to do */
-	if (icmd->ulpBdeCount == 0)
-		return;
-	bdeBuf = piocbq->context2;
-	piocbq->context2 = NULL;
-	size  = icmd->un.cont64[0].tus.f.bdeSize;
-	lpfc_ct_unsol_buffer(phba, piocbq, bdeBuf, size);
-	lpfc_in_buf_free(phba, bdeBuf);
+	return handled;
 }
 
 static void
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-12-12 13:32:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2013-01-02 13:13:05.939087718 -0500
@@ -466,11 +466,13 @@ enum intr_type_t {
 	MSIX,
 };
 
+#define LPFC_CT_CTX_MAX		64
 struct unsol_rcv_ct_ctx {
 	uint32_t ctxt_id;
 	uint32_t SID;
-	uint32_t flags;
-#define UNSOL_VALID	0x00000001
+	uint32_t valid;
+#define UNSOL_INVALID		0
+#define UNSOL_VALID		1
 	uint16_t oxid;
 	uint16_t rxid;
 };
@@ -938,7 +940,7 @@ struct lpfc_hba {
 
 	spinlock_t ct_ev_lock; /* synchronize access to ct_ev_waiters */
 	struct list_head ct_ev_waiters;
-	struct unsol_rcv_ct_ctx ct_ctx[64];
+	struct unsol_rcv_ct_ctx ct_ctx[LPFC_CT_CTX_MAX];
 	uint32_t ctx_idx;
 
 	uint8_t menlo_flag;	/* menlo generic flags */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-12-12 13:32:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-01-02 13:13:05.944087718 -0500
@@ -8855,12 +8855,6 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 			pring->prt[3].type = FC_TYPE_CT;
 			pring->prt[3].lpfc_sli_rcv_unsol_event =
 			    lpfc_ct_unsol_event;
-			/* abort unsolicited sequence */
-			pring->prt[4].profile = 0;	/* Mask 4 */
-			pring->prt[4].rctl = FC_RCTL_BA_ABTS;
-			pring->prt[4].type = FC_TYPE_BLS;
-			pring->prt[4].lpfc_sli_rcv_unsol_event =
-			    lpfc_sli4_ct_abort_unsol_event;
 			break;
 		}
 		totiocbsize += (pring->sli.sli3.numCiocb *
@@ -14063,6 +14057,40 @@ lpfc_sli4_abort_partial_seq(struct lpfc_
 }
 
 /**
+ * lpfc_sli4_abort_ulp_seq - Abort assembled unsol sequence from ulp
+ * @vport: pointer to a vitural port
+ * @dmabuf: pointer to a dmabuf that describes the FC sequence
+ *
+ * This function tries to abort from the assembed sequence from upper level
+ * protocol, described by the information from basic abbort @dmabuf. It
+ * checks to see whether such pending context exists at upper level protocol.
+ * If so, it shall clean up the pending context.
+ *
+ * Return
+ * true  -- if there is matching pending context of the sequence cleaned
+ *          at ulp;
+ * false -- if there is no matching pending context of the sequence present
+ *          at ulp.
+ **/
+static bool
+lpfc_sli4_abort_ulp_seq(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
+{
+	struct lpfc_hba *phba = vport->phba;
+	int handled;
+
+	/* Accepting abort at ulp with SLI4 only */
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		return false;
+
+	/* Register all caring upper level protocols to attend abort */
+	handled = lpfc_ct_handle_unsol_abort(phba, dmabuf);
+	if (handled)
+		return true;
+
+	return false;
+}
+
+/**
  * lpfc_sli4_seq_abort_rsp_cmpl - BLS ABORT RSP seq abort iocb complete handler
  * @phba: Pointer to HBA context object.
  * @cmd_iocbq: pointer to the command iocbq structure.
@@ -14077,8 +14105,14 @@ lpfc_sli4_seq_abort_rsp_cmpl(struct lpfc
 			     struct lpfc_iocbq *cmd_iocbq,
 			     struct lpfc_iocbq *rsp_iocbq)
 {
-	if (cmd_iocbq)
+	struct lpfc_nodelist *ndlp;
+
+	if (cmd_iocbq) {
+		ndlp = (struct lpfc_nodelist *)cmd_iocbq->context1;
+		lpfc_nlp_put(ndlp);
+		lpfc_nlp_not_used(ndlp);
 		lpfc_sli_release_iocbq(phba, cmd_iocbq);
+	}
 
 	/* Failure means BLS ABORT RSP did not get delivered to remote node*/
 	if (rsp_iocbq && rsp_iocbq->iocb.ulpStatus)
@@ -14118,9 +14152,10 @@ lpfc_sli4_xri_inrange(struct lpfc_hba *p
  * event after aborting the sequence handling.
  **/
 static void
-lpfc_sli4_seq_abort_rsp(struct lpfc_hba *phba,
-			struct fc_frame_header *fc_hdr)
+lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
+			struct fc_frame_header *fc_hdr, bool aborted)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *ctiocb = NULL;
 	struct lpfc_nodelist *ndlp;
 	uint16_t oxid, rxid, xri, lxri;
@@ -14135,12 +14170,27 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba
 	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
 	rxid = be16_to_cpu(fc_hdr->fh_rx_id);
 
-	ndlp = lpfc_findnode_did(phba->pport, sid);
+	ndlp = lpfc_findnode_did(vport, sid);
 	if (!ndlp) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
-				"1268 Find ndlp returned NULL for oxid:x%x "
-				"SID:x%x\n", oxid, sid);
-		return;
+		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		if (!ndlp) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+					 "1268 Failed to allocate ndlp for "
+					 "oxid:x%x SID:x%x\n", oxid, sid);
+			return;
+		}
+		lpfc_nlp_init(vport, ndlp, sid);
+		/* Put ndlp onto pport node list */
+		lpfc_enqueue_node(vport, ndlp);
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		/* re-setup ndlp without removing from node list */
+		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
+		if (!ndlp) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+					 "3275 Failed to active ndlp found "
+					 "for oxid:x%x SID:x%x\n", oxid, sid);
+			return;
+		}
 	}
 
 	/* Allocate buffer for rsp iocb */
@@ -14164,7 +14214,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba
 	icmd->ulpLe = 1;
 	icmd->ulpClass = CLASS3;
 	icmd->ulpContext = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
-	ctiocb->context1 = ndlp;
+	ctiocb->context1 = lpfc_nlp_get(ndlp);
 
 	ctiocb->iocb_cmpl = NULL;
 	ctiocb->vport = phba->pport;
@@ -14183,14 +14233,24 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba
 	if (lxri != NO_XRI)
 		lpfc_set_rrq_active(phba, ndlp, lxri,
 			(xri == oxid) ? rxid : oxid, 0);
-	/* If the oxid maps to the FCP XRI range or if it is out of range,
-	 * send a BLS_RJT.  The driver no longer has that exchange.
-	 * Override the IOCB for a BA_RJT.
+	/* For BA_ABTS from exchange responder, if the logical xri with
+	 * the oxid maps to the FCP XRI range, the port no longer has
+	 * that exchange context, send a BLS_RJT. Override the IOCB for
+	 * a BA_RJT.
 	 */
-	if (xri > (phba->sli4_hba.max_cfg_param.max_xri +
-		    phba->sli4_hba.max_cfg_param.xri_base) ||
-	    xri > (lpfc_sli4_get_els_iocb_cnt(phba) +
-		    phba->sli4_hba.max_cfg_param.xri_base)) {
+	if ((fctl & FC_FC_EX_CTX) &&
+	    (lxri > lpfc_sli4_get_els_iocb_cnt(phba))) {
+		icmd->un.xseq64.w5.hcsw.Rctl = FC_RCTL_BA_RJT;
+		bf_set(lpfc_vndr_code, &icmd->un.bls_rsp, 0);
+		bf_set(lpfc_rsn_expln, &icmd->un.bls_rsp, FC_BA_RJT_INV_XID);
+		bf_set(lpfc_rsn_code, &icmd->un.bls_rsp, FC_BA_RJT_UNABLE);
+	}
+
+	/* If BA_ABTS failed to abort a partially assembled receive sequence,
+	 * the driver no longer has that exchange, send a BLS_RJT. Override
+	 * the IOCB for a BA_RJT.
+	 */
+	if (aborted == false) {
 		icmd->un.xseq64.w5.hcsw.Rctl = FC_RCTL_BA_RJT;
 		bf_set(lpfc_vndr_code, &icmd->un.bls_rsp, 0);
 		bf_set(lpfc_rsn_expln, &icmd->un.bls_rsp, FC_BA_RJT_INV_XID);
@@ -14214,17 +14274,19 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba
 	bf_set(lpfc_abts_oxid, &icmd->un.bls_rsp, oxid);
 
 	/* Xmit CT abts response on exchange <xid> */
-	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"1200 Send BLS cmd x%x on oxid x%x Data: x%x\n",
-			icmd->un.xseq64.w5.hcsw.Rctl, oxid, phba->link_state);
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "1200 Send BLS cmd x%x on oxid x%x Data: x%x\n",
+			 icmd->un.xseq64.w5.hcsw.Rctl, oxid, phba->link_state);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, ctiocb, 0);
 	if (rc == IOCB_ERROR) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
-				"2925 Failed to issue CT ABTS RSP x%x on "
-				"xri x%x, Data x%x\n",
-				icmd->un.xseq64.w5.hcsw.Rctl, oxid,
-				phba->link_state);
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "2925 Failed to issue CT ABTS RSP x%x on "
+				 "xri x%x, Data x%x\n",
+				 icmd->un.xseq64.w5.hcsw.Rctl, oxid,
+				 phba->link_state);
+		lpfc_nlp_put(ndlp);
+		ctiocb->context1 = NULL;
 		lpfc_sli_release_iocbq(phba, ctiocb);
 	}
 }
@@ -14249,32 +14311,25 @@ lpfc_sli4_handle_unsol_abort(struct lpfc
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_frame_header fc_hdr;
 	uint32_t fctl;
-	bool abts_par;
+	bool aborted;
 
 	/* Make a copy of fc_hdr before the dmabuf being released */
 	memcpy(&fc_hdr, dmabuf->hbuf.virt, sizeof(struct fc_frame_header));
 	fctl = sli4_fctl_from_fc_hdr(&fc_hdr);
 
 	if (fctl & FC_FC_EX_CTX) {
-		/*
-		 * ABTS sent by responder to exchange, just free the buffer
-		 */
-		lpfc_in_buf_free(phba, &dmabuf->dbuf);
+		/* ABTS by responder to exchange, no cleanup needed */
+		aborted = true;
 	} else {
-		/*
-		 * ABTS sent by initiator to exchange, need to do cleanup
-		 */
-		/* Try to abort partially assembled seq */
-		abts_par = lpfc_sli4_abort_partial_seq(vport, dmabuf);
-
-		/* Send abort to ULP if partially seq abort failed */
-		if (abts_par == false)
-			lpfc_sli4_send_seq_to_ulp(vport, dmabuf);
-		else
-			lpfc_in_buf_free(phba, &dmabuf->dbuf);
+		/* ABTS by initiator to exchange, need to do cleanup */
+		aborted = lpfc_sli4_abort_partial_seq(vport, dmabuf);
+		if (aborted == false)
+			aborted = lpfc_sli4_abort_ulp_seq(vport, dmabuf);
 	}
-	/* Send basic accept (BA_ACC) to the abort requester */
-	lpfc_sli4_seq_abort_rsp(phba, &fc_hdr);
+	lpfc_in_buf_free(phba, &dmabuf->dbuf);
+
+	/* Respond with BA_ACC or BA_RJT accordingly */
+	lpfc_sli4_seq_abort_rsp(vport, &fc_hdr, aborted);
 }
 
 /**



