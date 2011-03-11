From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/6] lpfc 8.3.22: FC Discovery fixes
Date: Fri, 11 Mar 2011 16:06:29 -0500
Message-ID: <1299877602.31589.19.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23191 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755160Ab1CKVG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2011 16:06:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FC Discovery fixes
- In lpfc_sli4_bpl2sgl byte swapping the SGL in word2.
- In lpfc_sli4_iocb2wqe byteswap the data for CMD_GEN_REQUEST64_CR type WQE.
- In lpfc_sli4_seq_abort_acc do not set the oxid into the iocb's xritag field.
- In lpfc_sli4_seq_abort_acc check the return value of lpfc_sli_issue_iocb.
- Inprove messages in this area.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h  |    2 -
 lpfc_hw4.h |   12 ++++++-
 lpfc_sli.c |   99 ++++++++++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 81 insertions(+), 32 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-03-11 14:57:53.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-03-11 14:58:45.000000000 -0500
@@ -215,7 +215,7 @@ struct lpfc_sli4_flags {
 #define lpfc_fip_flag_WORD word0
 };
 
-struct sli4_bls_acc {
+struct sli4_bls_rsp {
 	uint32_t word0_rsvd;      /* Word0 must be reserved */
 	uint32_t word1;
 #define lpfc_abts_orig_SHIFT      0
@@ -231,6 +231,16 @@ struct sli4_bls_acc {
 #define lpfc_abts_oxid_MASK       0x0000FFFF
 #define lpfc_abts_oxid_WORD       word2
 	uint32_t word3;
+#define lpfc_vndr_code_SHIFT	0
+#define lpfc_vndr_code_MASK	0x000000FF
+#define lpfc_vndr_code_WORD	word3
+#define lpfc_rsn_expln_SHIFT	8
+#define lpfc_rsn_expln_MASK	0x000000FF
+#define lpfc_rsn_expln_WORD	word3
+#define lpfc_rsn_code_SHIFT	16
+#define lpfc_rsn_code_MASK	0x000000FF
+#define lpfc_rsn_code_WORD	word3
+
 	uint32_t word4;
 	uint32_t word5_rsvd;	/* Word5 must be reserved */
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2011-03-11 14:58:21.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2011-03-11 14:58:45.000000000 -0500
@@ -3632,7 +3632,7 @@ typedef struct _IOCB {	/* IOCB structure
 		ASYNCSTAT_FIELDS asyncstat; /* async_status iocb */
 		QUE_XRI64_CX_FIELDS quexri64cx; /* que_xri64_cx fields */
 		struct rcv_seq64 rcvseq64;	/* RCV_SEQ64 and RCV_CONT64 */
-		struct sli4_bls_acc bls_acc; /* UNSOL ABTS BLS_ACC params */
+		struct sli4_bls_rsp bls_rsp; /* UNSOL ABTS BLS_RSP params */
 		uint32_t ulpWord[IOCB_WORD_SZ - 2];	/* generic 6 'words' */
 	} un;
 	union {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-03-11 14:58:21.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-03-11 14:58:45.000000000 -0500
@@ -6311,7 +6311,6 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 				bf_set(lpfc_sli4_sge_last, sgl, 1);
 			else
 				bf_set(lpfc_sli4_sge_last, sgl, 0);
-			sgl->word2 = cpu_to_le32(sgl->word2);
 			/* swap the size field back to the cpu so we
 			 * can assign it to the sgl.
 			 */
@@ -6331,6 +6330,7 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 				bf_set(lpfc_sli4_sge_offset, sgl, offset);
 				offset += bde.tus.f.bdeSize;
 			}
+			sgl->word2 = cpu_to_le32(sgl->word2);
 			bpl++;
 			sgl++;
 		}
@@ -6576,9 +6576,9 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		numBdes = iocbq->iocb.un.genreq64.bdl.bdeSize /
 			sizeof(struct ulp_bde64);
 		for (i = 0; i < numBdes; i++) {
-			if (bpl[i].tus.f.bdeFlags != BUFF_TYPE_BDE_64)
-				break;
 			bde.tus.w = le32_to_cpu(bpl[i].tus.w);
+			if (bde.tus.f.bdeFlags != BUFF_TYPE_BDE_64)
+				break;
 			xmit_len += bde.tus.f.bdeSize;
 		}
 		/* word3 iocb=IO_TAG wqe=request_payload_len */
@@ -6668,15 +6668,15 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		xritag = 0;
 	break;
 	case CMD_XMIT_BLS_RSP64_CX:
-		/* As BLS ABTS-ACC WQE is very different from other WQEs,
+		/* As BLS ABTS RSP WQE is very different from other WQEs,
 		 * we re-construct this WQE here based on information in
 		 * iocbq from scratch.
 		 */
 		memset(wqe, 0, sizeof(union lpfc_wqe));
 		/* OX_ID is invariable to who sent ABTS to CT exchange */
 		bf_set(xmit_bls_rsp64_oxid, &wqe->xmit_bls_rsp,
-		       bf_get(lpfc_abts_oxid, &iocbq->iocb.un.bls_acc));
-		if (bf_get(lpfc_abts_orig, &iocbq->iocb.un.bls_acc) ==
+		       bf_get(lpfc_abts_oxid, &iocbq->iocb.un.bls_rsp));
+		if (bf_get(lpfc_abts_orig, &iocbq->iocb.un.bls_rsp) ==
 		    LPFC_ABTS_UNSOL_INT) {
 			/* ABTS sent by initiator to CT exchange, the
 			 * RX_ID field will be filled with the newly
@@ -6690,7 +6690,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 			 * RX_ID from ABTS.
 			 */
 			bf_set(xmit_bls_rsp64_rxid, &wqe->xmit_bls_rsp,
-			       bf_get(lpfc_abts_rxid, &iocbq->iocb.un.bls_acc));
+			       bf_get(lpfc_abts_rxid, &iocbq->iocb.un.bls_rsp));
 		}
 		bf_set(xmit_bls_rsp64_seqcnthi, &wqe->xmit_bls_rsp, 0xffff);
 		bf_set(wqe_xmit_bls_pt, &wqe->xmit_bls_rsp.wqe_dest, 0x1);
@@ -6701,6 +6701,15 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		       LPFC_WQE_LENLOC_NONE);
 		/* Overwrite the pre-set comnd type with OTHER_COMMAND */
 		command_type = OTHER_COMMAND;
+		if (iocbq->iocb.un.xseq64.w5.hcsw.Rctl == FC_RCTL_BA_RJT) {
+			bf_set(xmit_bls_rsp64_rjt_vspec, &wqe->xmit_bls_rsp,
+			       bf_get(lpfc_vndr_code, &iocbq->iocb.un.bls_rsp));
+			bf_set(xmit_bls_rsp64_rjt_expc, &wqe->xmit_bls_rsp,
+			       bf_get(lpfc_rsn_expln, &iocbq->iocb.un.bls_rsp));
+			bf_set(xmit_bls_rsp64_rjt_rsnc, &wqe->xmit_bls_rsp,
+			       bf_get(lpfc_rsn_code, &iocbq->iocb.un.bls_rsp));
+		}
+
 	break;
 	case CMD_XRI_ABORTED_CX:
 	case CMD_CREATE_XRI_CR: /* Do we expect to use this? */
@@ -6749,7 +6758,8 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
-		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
+		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN ||
+		    piocb->iocb.ulpCommand == CMD_XMIT_BLS_RSP64_CX)
 			sglq = NULL;
 		else {
 			if (pring->txq_cnt) {
@@ -11740,6 +11750,7 @@ lpfc_fc_frame_check(struct lpfc_hba *phb
 	static char *rctl_names[] = FC_RCTL_NAMES_INIT;
 	char *type_names[] = FC_TYPE_NAMES_INIT;
 	struct fc_vft_header *fc_vft_hdr;
+	uint32_t *header = (uint32_t *) fc_hdr;
 
 	switch (fc_hdr->fh_r_ctl) {
 	case FC_RCTL_DD_UNCAT:		/* uncategorized information */
@@ -11788,10 +11799,15 @@ lpfc_fc_frame_check(struct lpfc_hba *phb
 	default:
 		goto drop;
 	}
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"2538 Received frame rctl:%s type:%s\n",
+			"2538 Received frame rctl:%s type:%s "
+			"Frame Data:%08x %08x %08x %08x %08x %08x\n",
 			rctl_names[fc_hdr->fh_r_ctl],
-			type_names[fc_hdr->fh_type]);
+			type_names[fc_hdr->fh_type],
+			be32_to_cpu(header[0]), be32_to_cpu(header[1]),
+			be32_to_cpu(header[2]), be32_to_cpu(header[3]),
+			be32_to_cpu(header[4]), be32_to_cpu(header[5]));
 	return 0;
 drop:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
@@ -12088,17 +12104,17 @@ lpfc_sli4_abort_partial_seq(struct lpfc_
 }
 
 /**
- * lpfc_sli4_seq_abort_acc_cmpl - Accept seq abort iocb complete handler
+ * lpfc_sli4_seq_abort_rsp_cmpl - BLS ABORT RSP seq abort iocb complete handler
  * @phba: Pointer to HBA context object.
  * @cmd_iocbq: pointer to the command iocbq structure.
  * @rsp_iocbq: pointer to the response iocbq structure.
  *
- * This function handles the sequence abort accept iocb command complete
+ * This function handles the sequence abort response iocb command complete
  * event. It properly releases the memory allocated to the sequence abort
  * accept iocb.
  **/
 static void
-lpfc_sli4_seq_abort_acc_cmpl(struct lpfc_hba *phba,
+lpfc_sli4_seq_abort_rsp_cmpl(struct lpfc_hba *phba,
 			     struct lpfc_iocbq *cmd_iocbq,
 			     struct lpfc_iocbq *rsp_iocbq)
 {
@@ -12107,15 +12123,15 @@ lpfc_sli4_seq_abort_acc_cmpl(struct lpfc
 }
 
 /**
- * lpfc_sli4_seq_abort_acc - Accept sequence abort
+ * lpfc_sli4_seq_abort_rsp - bls rsp to sequence abort
  * @phba: Pointer to HBA context object.
  * @fc_hdr: pointer to a FC frame header.
  *
- * This function sends a basic accept to a previous unsol sequence abort
+ * This function sends a basic response to a previous unsol sequence abort
  * event after aborting the sequence handling.
  **/
 static void
-lpfc_sli4_seq_abort_acc(struct lpfc_hba *phba,
+lpfc_sli4_seq_abort_rsp(struct lpfc_hba *phba,
 			struct fc_frame_header *fc_hdr)
 {
 	struct lpfc_iocbq *ctiocb = NULL;
@@ -12123,6 +12139,7 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 	uint16_t oxid, rxid;
 	uint32_t sid, fctl;
 	IOCB_t *icmd;
+	int rc;
 
 	if (!lpfc_is_link_up(phba))
 		return;
@@ -12143,7 +12160,7 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 		+ phba->sli4_hba.max_cfg_param.xri_base))
 		lpfc_set_rrq_active(phba, ndlp, rxid, oxid, 0);
 
-	/* Allocate buffer for acc iocb */
+	/* Allocate buffer for rsp iocb */
 	ctiocb = lpfc_sli_get_iocbq(phba);
 	if (!ctiocb)
 		return;
@@ -12168,32 +12185,54 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 
 	ctiocb->iocb_cmpl = NULL;
 	ctiocb->vport = phba->pport;
-	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_acc_cmpl;
+	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
+	ctiocb->sli4_xritag = NO_XRI;
+
+	/* If the oxid maps to the FCP XRI range or if it is out of range,
+	 * send a BLS_RJT.  The driver no longer has that exchange.
+	 * Override the IOCB for a BA_RJT.
+	 */
+	if (oxid > (phba->sli4_hba.max_cfg_param.max_xri +
+		    phba->sli4_hba.max_cfg_param.xri_base) ||
+	    oxid > (lpfc_sli4_get_els_iocb_cnt(phba) +
+		    phba->sli4_hba.max_cfg_param.xri_base)) {
+		icmd->un.xseq64.w5.hcsw.Rctl = FC_RCTL_BA_RJT;
+		bf_set(lpfc_vndr_code, &icmd->un.bls_rsp, 0);
+		bf_set(lpfc_rsn_expln, &icmd->un.bls_rsp, FC_BA_RJT_INV_XID);
+		bf_set(lpfc_rsn_code, &icmd->un.bls_rsp, FC_BA_RJT_UNABLE);
+	}
 
 	if (fctl & FC_FC_EX_CTX) {
 		/* ABTS sent by responder to CT exchange, construction
 		 * of BA_ACC will use OX_ID from ABTS for the XRI_TAG
 		 * field and RX_ID from ABTS for RX_ID field.
 		 */
-		bf_set(lpfc_abts_orig, &icmd->un.bls_acc, LPFC_ABTS_UNSOL_RSP);
-		bf_set(lpfc_abts_rxid, &icmd->un.bls_acc, rxid);
-		ctiocb->sli4_xritag = oxid;
+		bf_set(lpfc_abts_orig, &icmd->un.bls_rsp, LPFC_ABTS_UNSOL_RSP);
+		bf_set(lpfc_abts_rxid, &icmd->un.bls_rsp, rxid);
 	} else {
 		/* ABTS sent by initiator to CT exchange, construction
 		 * of BA_ACC will need to allocate a new XRI as for the
 		 * XRI_TAG and RX_ID fields.
 		 */
-		bf_set(lpfc_abts_orig, &icmd->un.bls_acc, LPFC_ABTS_UNSOL_INT);
-		bf_set(lpfc_abts_rxid, &icmd->un.bls_acc, NO_XRI);
-		ctiocb->sli4_xritag = NO_XRI;
+		bf_set(lpfc_abts_orig, &icmd->un.bls_rsp, LPFC_ABTS_UNSOL_INT);
+		bf_set(lpfc_abts_rxid, &icmd->un.bls_rsp, NO_XRI);
 	}
-	bf_set(lpfc_abts_oxid, &icmd->un.bls_acc, oxid);
+	bf_set(lpfc_abts_oxid, &icmd->un.bls_rsp, oxid);
 
-	/* Xmit CT abts accept on exchange <xid> */
+	/* Xmit CT abts response on exchange <xid> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"1200 Xmit CT ABTS ACC on exchange x%x Data: x%x\n",
-			CMD_XMIT_BLS_RSP64_CX, phba->link_state);
-	lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, ctiocb, 0);
+			"1200 Send BLS cmd x%x on oxid x%x Data: x%x\n",
+			icmd->un.xseq64.w5.hcsw.Rctl, oxid, phba->link_state);
+
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, ctiocb, 0);
+	if (rc == IOCB_ERROR) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
+				"2925 Failed to issue CT ABTS RSP x%x on "
+				"xri x%x, Data x%x\n",
+				icmd->un.xseq64.w5.hcsw.Rctl, oxid,
+				phba->link_state);
+		lpfc_sli_release_iocbq(phba, ctiocb);
+	}
 }
 
 /**
@@ -12241,7 +12280,7 @@ lpfc_sli4_handle_unsol_abort(struct lpfc
 			lpfc_in_buf_free(phba, &dmabuf->dbuf);
 	}
 	/* Send basic accept (BA_ACC) to the abort requester */
-	lpfc_sli4_seq_abort_acc(phba, &fc_hdr);
+	lpfc_sli4_seq_abort_rsp(phba, &fc_hdr);
 }
 
 /**


