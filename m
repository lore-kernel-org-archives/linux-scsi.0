From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/7] lpfc 8.3.18: Add new WQE support
Date: Fri, 22 Oct 2010 11:07:09 -0400
Message-ID: <1287760044.11844.24.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56069 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756270Ab0JVPHv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 11:07:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add new WQE fields as defined by new SLI interface to support new hardware.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    9 +-
 lpfc_hw4.h |  167 ++++++++++++++++++--------------------------
 lpfc_sli.c |  228 ++++++++++++++++++++++++++++++++-----------------------------
 3 files changed, 197 insertions(+), 207 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-10-21 22:39:01.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-10-21 22:39:44.000000000 -0400
@@ -177,15 +177,18 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		 (elscmd == ELS_CMD_LOGO)))
 		switch (elscmd) {
 		case ELS_CMD_FLOGI:
-		elsiocb->iocb_flag |= ((ELS_ID_FLOGI << LPFC_FIP_ELS_ID_SHIFT)
+		elsiocb->iocb_flag |=
+			((LPFC_ELS_ID_FLOGI << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		case ELS_CMD_FDISC:
-		elsiocb->iocb_flag |= ((ELS_ID_FDISC << LPFC_FIP_ELS_ID_SHIFT)
+		elsiocb->iocb_flag |=
+			((LPFC_ELS_ID_FDISC << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		case ELS_CMD_LOGO:
-		elsiocb->iocb_flag |= ((ELS_ID_LOGO << LPFC_FIP_ELS_ID_SHIFT)
+		elsiocb->iocb_flag |=
+			((LPFC_ELS_ID_LOGO << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-10-21 22:39:44.000000000 -0400
@@ -424,79 +424,6 @@ struct lpfc_rcqe {
 #define FCOE_SOFn3	0x36
 };
 
-struct lpfc_wqe_generic{
-	struct ulp_bde64 bde;
-	uint32_t word3;
-	uint32_t word4;
-	uint32_t word5;
-	uint32_t word6;
-#define lpfc_wqe_gen_context_SHIFT	16
-#define lpfc_wqe_gen_context_MASK	0x0000FFFF
-#define lpfc_wqe_gen_context_WORD	word6
-#define lpfc_wqe_gen_xri_SHIFT		0
-#define lpfc_wqe_gen_xri_MASK		0x0000FFFF
-#define lpfc_wqe_gen_xri_WORD		word6
-	uint32_t word7;
-#define lpfc_wqe_gen_lnk_SHIFT		23
-#define lpfc_wqe_gen_lnk_MASK		0x00000001
-#define lpfc_wqe_gen_lnk_WORD		word7
-#define lpfc_wqe_gen_erp_SHIFT		22
-#define lpfc_wqe_gen_erp_MASK		0x00000001
-#define lpfc_wqe_gen_erp_WORD		word7
-#define lpfc_wqe_gen_pu_SHIFT		20
-#define lpfc_wqe_gen_pu_MASK		0x00000003
-#define lpfc_wqe_gen_pu_WORD		word7
-#define lpfc_wqe_gen_class_SHIFT	16
-#define lpfc_wqe_gen_class_MASK		0x00000007
-#define lpfc_wqe_gen_class_WORD		word7
-#define lpfc_wqe_gen_command_SHIFT	8
-#define lpfc_wqe_gen_command_MASK	0x000000FF
-#define lpfc_wqe_gen_command_WORD	word7
-#define lpfc_wqe_gen_status_SHIFT	4
-#define lpfc_wqe_gen_status_MASK	0x0000000F
-#define lpfc_wqe_gen_status_WORD	word7
-#define lpfc_wqe_gen_ct_SHIFT		2
-#define lpfc_wqe_gen_ct_MASK		0x00000003
-#define lpfc_wqe_gen_ct_WORD		word7
-	uint32_t abort_tag;
-	uint32_t word9;
-#define lpfc_wqe_gen_request_tag_SHIFT	0
-#define lpfc_wqe_gen_request_tag_MASK	0x0000FFFF
-#define lpfc_wqe_gen_request_tag_WORD	word9
-	uint32_t word10;
-#define lpfc_wqe_gen_ccp_SHIFT		24
-#define lpfc_wqe_gen_ccp_MASK		0x000000FF
-#define lpfc_wqe_gen_ccp_WORD		word10
-#define lpfc_wqe_gen_ccpe_SHIFT		23
-#define lpfc_wqe_gen_ccpe_MASK		0x00000001
-#define lpfc_wqe_gen_ccpe_WORD		word10
-#define lpfc_wqe_gen_pv_SHIFT		19
-#define lpfc_wqe_gen_pv_MASK		0x00000001
-#define lpfc_wqe_gen_pv_WORD		word10
-#define lpfc_wqe_gen_pri_SHIFT		16
-#define lpfc_wqe_gen_pri_MASK		0x00000007
-#define lpfc_wqe_gen_pri_WORD		word10
-	uint32_t word11;
-#define lpfc_wqe_gen_cq_id_SHIFT	16
-#define lpfc_wqe_gen_cq_id_MASK		0x0000FFFF
-#define lpfc_wqe_gen_cq_id_WORD		word11
-#define LPFC_WQE_CQ_ID_DEFAULT	0xffff
-#define lpfc_wqe_gen_wqec_SHIFT		7
-#define lpfc_wqe_gen_wqec_MASK		0x00000001
-#define lpfc_wqe_gen_wqec_WORD		word11
-#define ELS_ID_FLOGI 3
-#define ELS_ID_FDISC 2
-#define ELS_ID_LOGO  1
-#define ELS_ID_DEFAULT 0
-#define lpfc_wqe_gen_els_id_SHIFT	4
-#define lpfc_wqe_gen_els_id_MASK	0x00000003
-#define lpfc_wqe_gen_els_id_WORD	word11
-#define lpfc_wqe_gen_cmd_type_SHIFT	0
-#define lpfc_wqe_gen_cmd_type_MASK	0x0000000F
-#define lpfc_wqe_gen_cmd_type_WORD	word11
-	uint32_t payload[4];
-};
-
 struct lpfc_rqe {
 	uint32_t address_hi;
 	uint32_t address_lo;
@@ -2279,9 +2206,36 @@ struct wqe_common {
 #define wqe_reqtag_MASK       0x0000FFFF
 #define wqe_reqtag_WORD       word9
 #define wqe_rcvoxid_SHIFT     16
-#define wqe_rcvoxid_MASK       0x0000FFFF
-#define wqe_rcvoxid_WORD       word9
+#define wqe_rcvoxid_MASK      0x0000FFFF
+#define wqe_rcvoxid_WORD      word9
 	uint32_t word10;
+#define wqe_ebde_cnt_SHIFT    0
+#define wqe_ebde_cnt_MASK     0x00000007
+#define wqe_ebde_cnt_WORD     word10
+#define wqe_lenloc_SHIFT      7
+#define wqe_lenloc_MASK       0x00000003
+#define wqe_lenloc_WORD       word10
+#define LPFC_WQE_LENLOC_NONE		0
+#define LPFC_WQE_LENLOC_WORD3	1
+#define LPFC_WQE_LENLOC_WORD12	2
+#define LPFC_WQE_LENLOC_WORD4	3
+#define wqe_qosd_SHIFT        9
+#define wqe_qosd_MASK         0x00000001
+#define wqe_qosd_WORD         word10
+#define wqe_xbl_SHIFT         11
+#define wqe_xbl_MASK          0x00000001
+#define wqe_xbl_WORD          word10
+#define wqe_iod_SHIFT         13
+#define wqe_iod_MASK          0x00000001
+#define wqe_iod_WORD          word10
+#define LPFC_WQE_IOD_WRITE	0
+#define LPFC_WQE_IOD_READ	1
+#define wqe_dbde_SHIFT        14
+#define wqe_dbde_MASK         0x00000001
+#define wqe_dbde_WORD         word10
+#define wqe_wqes_SHIFT        15
+#define wqe_wqes_MASK         0x00000001
+#define wqe_wqes_WORD         word10
 #define wqe_pri_SHIFT         16
 #define wqe_pri_MASK          0x00000007
 #define wqe_pri_WORD          word10
@@ -2295,18 +2249,26 @@ struct wqe_common {
 #define wqe_ccpe_MASK         0x00000001
 #define wqe_ccpe_WORD         word10
 #define wqe_ccp_SHIFT         24
-#define wqe_ccp_MASK         0x000000ff
-#define wqe_ccp_WORD         word10
+#define wqe_ccp_MASK          0x000000ff
+#define wqe_ccp_WORD          word10
 	uint32_t word11;
-#define wqe_cmd_type_SHIFT  0
-#define wqe_cmd_type_MASK   0x0000000f
-#define wqe_cmd_type_WORD   word11
-#define wqe_wqec_SHIFT      7
-#define wqe_wqec_MASK       0x00000001
-#define wqe_wqec_WORD       word11
-#define wqe_cqid_SHIFT      16
-#define wqe_cqid_MASK       0x0000ffff
-#define wqe_cqid_WORD       word11
+#define wqe_cmd_type_SHIFT    0
+#define wqe_cmd_type_MASK     0x0000000f
+#define wqe_cmd_type_WORD     word11
+#define wqe_els_id_SHIFT      4
+#define wqe_els_id_MASK       0x00000003
+#define wqe_els_id_WORD       word11
+#define LPFC_ELS_ID_FLOGI	3
+#define LPFC_ELS_ID_FDISC	2
+#define LPFC_ELS_ID_LOGO	1
+#define LPFC_ELS_ID_DEFAULT	0
+#define wqe_wqec_SHIFT        7
+#define wqe_wqec_MASK         0x00000001
+#define wqe_wqec_WORD         word11
+#define wqe_cqid_SHIFT        16
+#define wqe_cqid_MASK         0x0000ffff
+#define wqe_cqid_WORD         word11
+#define LPFC_WQE_CQ_ID_DEFAULT	0xffff
 };
 
 struct wqe_did {
@@ -2325,6 +2287,15 @@ struct wqe_did {
 #define wqe_xmit_bls_xo_WORD          word5
 };
 
+struct lpfc_wqe_generic{
+	struct ulp_bde64 bde;
+	uint32_t word3;
+	uint32_t word4;
+	uint32_t word5;
+	struct wqe_common wqe_com;
+	uint32_t payload[4];
+};
+
 struct els_request64_wqe {
 	struct ulp_bde64 bde;
 	uint32_t payload_len;
@@ -2356,9 +2327,9 @@ struct els_request64_wqe {
 
 struct xmit_els_rsp64_wqe {
 	struct ulp_bde64 bde;
-	uint32_t rsvd3;
+	uint32_t response_payload_len;
 	uint32_t rsvd4;
-	struct wqe_did	wqe_dest;
+	struct wqe_did wqe_dest;
 	struct wqe_common wqe_com; /* words 6-11 */
 	uint32_t rsvd_12_15[4];
 };
@@ -2427,7 +2398,7 @@ struct wqe_rctl_dfctl {
 
 struct xmit_seq64_wqe {
 	struct ulp_bde64 bde;
-	uint32_t paylaod_offset;
+	uint32_t rsvd3;
 	uint32_t relative_offset;
 	struct wqe_rctl_dfctl wge_ctl;
 	struct wqe_common wqe_com; /* words 6-11 */
@@ -2437,7 +2408,7 @@ struct xmit_seq64_wqe {
 };
 struct xmit_bcast64_wqe {
 	struct ulp_bde64 bde;
-	uint32_t paylaod_len;
+	uint32_t seq_payload_len;
 	uint32_t rsvd4;
 	struct wqe_rctl_dfctl wge_ctl; /* word 5 */
 	struct wqe_common wqe_com;     /* words 6-11 */
@@ -2446,8 +2417,8 @@ struct xmit_bcast64_wqe {
 
 struct gen_req64_wqe {
 	struct ulp_bde64 bde;
-	uint32_t command_len;
-	uint32_t payload_len;
+	uint32_t request_payload_len;
+	uint32_t relative_offset;
 	struct wqe_rctl_dfctl wge_ctl; /* word 5 */
 	struct wqe_common wqe_com;     /* words 6-11 */
 	uint32_t rsvd_12_15[4];
@@ -2480,7 +2451,7 @@ struct abort_cmd_wqe {
 
 struct fcp_iwrite64_wqe {
 	struct ulp_bde64 bde;
-	uint32_t payload_len;
+	uint32_t payload_offset_len;
 	uint32_t total_xfer_len;
 	uint32_t initial_xfer_len;
 	struct wqe_common wqe_com;     /* words 6-11 */
@@ -2489,7 +2460,7 @@ struct fcp_iwrite64_wqe {
 
 struct fcp_iread64_wqe {
 	struct ulp_bde64 bde;
-	uint32_t payload_len;          /* word 3 */
+	uint32_t payload_offset_len;   /* word 3 */
 	uint32_t total_xfer_len;       /* word 4 */
 	uint32_t rsrvd5;               /* word 5 */
 	struct wqe_common wqe_com;     /* words 6-11 */
@@ -2497,10 +2468,12 @@ struct fcp_iread64_wqe {
 };
 
 struct fcp_icmnd64_wqe {
-	struct ulp_bde64 bde;	 /* words 0-2 */
-	uint32_t rsrvd[3];             /* words 3-5 */
+	struct ulp_bde64 bde;          /* words 0-2 */
+	uint32_t rsrvd3;               /* word 3 */
+	uint32_t rsrvd4;               /* word 4 */
+	uint32_t rsrvd5;               /* word 5 */
 	struct wqe_common wqe_com;     /* words 6-11 */
-	uint32_t rsvd_12_15[4];         /* word 12-15 */
+	uint32_t rsvd_12_15[4];        /* word 12-15 */
 };
 

diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-10-21 22:39:01.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-10-21 22:39:44.000000000 -0400
@@ -95,7 +95,7 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, u
 		return -ENOMEM;
 	/* set consumption flag every once in a while */
 	if (!((q->host_index + 1) % LPFC_RELEASE_NOTIFICATION_INTERVAL))
-		bf_set(lpfc_wqe_gen_wqec, &wqe->generic, 1);
+		bf_set(wqe_wqec, &wqe->generic.wqe_com, 1);
 
 	lpfc_sli_pcimem_bcopy(wqe, temp_wqe, q->entry_size);
 
@@ -5965,7 +5965,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	uint16_t abrt_iotag;
 	struct lpfc_iocbq *abrtiocbq;
 	struct ulp_bde64 *bpl = NULL;
-	uint32_t els_id = ELS_ID_DEFAULT;
+	uint32_t els_id = LPFC_ELS_ID_DEFAULT;
 	int numBdes, i;
 	struct ulp_bde64 bde;
 
@@ -5982,7 +5982,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	memcpy(wqe, &iocbq->iocb, sizeof(union lpfc_wqe));
 	abort_tag = (uint32_t) iocbq->iotag;
 	xritag = iocbq->sli4_xritag;
-	wqe->words[7] = 0; /* The ct field has moved so reset */
+	wqe->generic.wqe_com.word7 = 0; /* The ct field has moved so reset */
 	/* words0-2 bpl convert bde */
 	if (iocbq->iocb.un.genreq64.bdl.bdeFlags == BUFF_TYPE_BLP_64) {
 		numBdes = iocbq->iocb.un.genreq64.bdl.bdeSize /
@@ -6033,109 +6033,117 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		 * contains the FCFI and remote N_Port_ID is
 		 * in word 5.
 		 */
-
 		ct = ((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l);
-		bf_set(lpfc_wqe_gen_context, &wqe->generic,
-				iocbq->iocb.ulpContext);
-
-		bf_set(lpfc_wqe_gen_ct, &wqe->generic, ct);
-		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
+		bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+		       iocbq->iocb.ulpContext);
+		bf_set(wqe_ct, &wqe->els_req.wqe_com, ct);
+		bf_set(wqe_pu, &wqe->els_req.wqe_com, 0);
 		/* CCP CCPE PV PRI in word10 were set in the memcpy */
-
 		if (command_type == ELS_COMMAND_FIP) {
 			els_id = ((iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK)
 					>> LPFC_FIP_ELS_ID_SHIFT);
 		}
-		bf_set(lpfc_wqe_gen_els_id, &wqe->generic, els_id);
-
+		bf_set(wqe_els_id, &wqe->els_req.wqe_com, els_id);
+		bf_set(wqe_dbde, &wqe->els_req.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->els_req.wqe_com, LPFC_WQE_IOD_READ);
+		bf_set(wqe_qosd, &wqe->els_req.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->els_req.wqe_com, LPFC_WQE_LENLOC_NONE);
+		bf_set(wqe_ebde_cnt, &wqe->els_req.wqe_com, 0);
 	break;
 	case CMD_XMIT_SEQUENCE64_CX:
-		bf_set(lpfc_wqe_gen_context, &wqe->generic,
-					iocbq->iocb.un.ulpWord[3]);
-		wqe->generic.word3 = 0;
-		bf_set(wqe_rcvoxid, &wqe->generic, iocbq->iocb.ulpContext);
+		bf_set(wqe_ctxt_tag, &wqe->xmit_sequence.wqe_com,
+		       iocbq->iocb.un.ulpWord[3]);
+		bf_set(wqe_rcvoxid, &wqe->xmit_sequence.wqe_com,
+		       iocbq->iocb.ulpContext);
 		/* The entire sequence is transmitted for this IOCB */
 		xmit_len = total_len;
 		cmnd = CMD_XMIT_SEQUENCE64_CR;
 	case CMD_XMIT_SEQUENCE64_CR:
-		/* word3 iocb=io_tag32 wqe=payload_offset */
-		/* payload offset used for multilpe outstanding
-		 * sequences on the same exchange
-		 */
-		wqe->words[3] = 0;
+		/* word3 iocb=io_tag32 wqe=reserved */
+		wqe->xmit_sequence.rsvd3 = 0;
 		/* word4 relative_offset memcpy */
 		/* word5 r_ctl/df_ctl memcpy */
-		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
+		bf_set(wqe_pu, &wqe->xmit_sequence.wqe_com, 0);
+		bf_set(wqe_dbde, &wqe->xmit_sequence.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->xmit_sequence.wqe_com,
+		       LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_lenloc, &wqe->xmit_sequence.wqe_com,
+		       LPFC_WQE_LENLOC_WORD12);
+		bf_set(wqe_ebde_cnt, &wqe->xmit_sequence.wqe_com, 0);
 		wqe->xmit_sequence.xmit_len = xmit_len;
 		command_type = OTHER_COMMAND;
 	break;
 	case CMD_XMIT_BCAST64_CN:
-		/* word3 iocb=iotag32 wqe=payload_len */
-		wqe->words[3] = 0; /* no definition for this in wqe */
+		/* word3 iocb=iotag32 wqe=seq_payload_len */
+		wqe->xmit_bcast64.seq_payload_len = xmit_len;
 		/* word4 iocb=rsvd wqe=rsvd */
 		/* word5 iocb=rctl/type/df_ctl wqe=rctl/type/df_ctl memcpy */
 		/* word6 iocb=ctxt_tag/io_tag wqe=ctxt_tag/xri */
-		bf_set(lpfc_wqe_gen_ct, &wqe->generic,
+		bf_set(wqe_ct, &wqe->xmit_bcast64.wqe_com,
 			((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l));
+		bf_set(wqe_dbde, &wqe->xmit_bcast64.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->xmit_bcast64.wqe_com, LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_lenloc, &wqe->xmit_bcast64.wqe_com,
+		       LPFC_WQE_LENLOC_WORD3);
+		bf_set(wqe_ebde_cnt, &wqe->xmit_bcast64.wqe_com, 0);
 	break;
 	case CMD_FCP_IWRITE64_CR:
 		command_type = FCP_COMMAND_DATA_OUT;
-		/* The struct for wqe fcp_iwrite has 3 fields that are somewhat
-		 * confusing.
-		 * word3 is payload_len: byte offset to the sgl entry for the
-		 * fcp_command.
-		 * word4 is total xfer len, same as the IOCB->ulpParameter.
-		 * word5 is initial xfer len 0 = wait for xfer-ready
-		 */
-
-		/* Always wait for xfer-ready before sending data */
-		wqe->fcp_iwrite.initial_xfer_len = 0;
-		/* word 4 (xfer length) should have been set on the memcpy */
-
-	/* allow write to fall through to read */
+		/* word3 iocb=iotag wqe=payload_offset_len */
+		/* Add the FCP_CMD and FCP_RSP sizes to get the offset */
+		wqe->fcp_iwrite.payload_offset_len =
+			xmit_len + sizeof(struct fcp_rsp);
+		/* word4 iocb=parameter wqe=total_xfer_length memcpy */
+		/* word5 iocb=initial_xfer_len wqe=initial_xfer_len memcpy */
+		bf_set(wqe_erp, &wqe->fcp_iwrite.wqe_com,
+		       iocbq->iocb.ulpFCP2Rcvy);
+		bf_set(wqe_lnk, &wqe->fcp_iwrite.wqe_com, iocbq->iocb.ulpXS);
+		/* Always open the exchange */
+		bf_set(wqe_xc, &wqe->fcp_iwrite.wqe_com, 0);
+		bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_lenloc, &wqe->fcp_iwrite.wqe_com,
+		       LPFC_WQE_LENLOC_WORD4);
+		bf_set(wqe_ebde_cnt, &wqe->fcp_iwrite.wqe_com, 0);
+		bf_set(wqe_pu, &wqe->fcp_iwrite.wqe_com, iocbq->iocb.ulpPU);
+	break;
 	case CMD_FCP_IREAD64_CR:
-		/* FCP_CMD is always the 1st sgl entry */
-		wqe->fcp_iread.payload_len =
+		/* word3 iocb=iotag wqe=payload_offset_len */
+		/* Add the FCP_CMD and FCP_RSP sizes to get the offset */
+		wqe->fcp_iread.payload_offset_len =
 			xmit_len + sizeof(struct fcp_rsp);
-
-		/* word 4 (xfer length) should have been set on the memcpy */
-
-		bf_set(lpfc_wqe_gen_erp, &wqe->generic,
-			iocbq->iocb.ulpFCP2Rcvy);
-		bf_set(lpfc_wqe_gen_lnk, &wqe->generic, iocbq->iocb.ulpXS);
-		/* The XC bit and the XS bit are similar. The driver never
-		 * tracked whether or not the exchange was previouslly open.
-		 * XC = Exchange create, 0 is create. 1 is already open.
-		 * XS = link cmd: 1 do not close the exchange after command.
-		 * XS = 0 close exchange when command completes.
-		 * The only time we would not set the XC bit is when the XS bit
-		 * is set and we are sending our 2nd or greater command on
-		 * this exchange.
-		 */
+		/* word4 iocb=parameter wqe=total_xfer_length memcpy */
+		/* word5 iocb=initial_xfer_len wqe=initial_xfer_len memcpy */
+		bf_set(wqe_erp, &wqe->fcp_iread.wqe_com,
+		       iocbq->iocb.ulpFCP2Rcvy);
+		bf_set(wqe_lnk, &wqe->fcp_iread.wqe_com, iocbq->iocb.ulpXS);
 		/* Always open the exchange */
 		bf_set(wqe_xc, &wqe->fcp_iread.wqe_com, 0);
-
-		wqe->words[10] &= 0xffff0000; /* zero out ebde count */
-		bf_set(lpfc_wqe_gen_pu, &wqe->generic, iocbq->iocb.ulpPU);
-		break;
+		bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->fcp_iread.wqe_com, LPFC_WQE_IOD_READ);
+		bf_set(wqe_lenloc, &wqe->fcp_iread.wqe_com,
+		       LPFC_WQE_LENLOC_WORD4);
+		bf_set(wqe_ebde_cnt, &wqe->fcp_iread.wqe_com, 0);
+		bf_set(wqe_pu, &wqe->fcp_iread.wqe_com, iocbq->iocb.ulpPU);
+	break;
 	case CMD_FCP_ICMND64_CR:
+		/* word3 iocb=IO_TAG wqe=reserved */
+		wqe->fcp_icmd.rsrvd3 = 0;
+		bf_set(wqe_pu, &wqe->fcp_icmd.wqe_com, 0);
 		/* Always open the exchange */
-		bf_set(wqe_xc, &wqe->fcp_iread.wqe_com, 0);
-
-		wqe->words[4] = 0;
-		wqe->words[10] &= 0xffff0000; /* zero out ebde count */
-		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
+		bf_set(wqe_xc, &wqe->fcp_icmd.wqe_com, 0);
+		bf_set(wqe_dbde, &wqe->fcp_icmd.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->fcp_icmd.wqe_com, LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_qosd, &wqe->fcp_icmd.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->fcp_icmd.wqe_com,
+		       LPFC_WQE_LENLOC_NONE);
+		bf_set(wqe_ebde_cnt, &wqe->fcp_icmd.wqe_com, 0);
 	break;
 	case CMD_GEN_REQUEST64_CR:
-		/* word3 command length is described as byte offset to the
-		 * rsp_data. Would always be 16, sizeof(struct sli4_sge)
-		 * sgl[0] = cmnd
-		 * sgl[1] = rsp.
-		 *
-		 */
-		wqe->gen_req.command_len = xmit_len;
-		/* Word4 parameter  copied in the memcpy */
-		/* Word5 [rctl, type, df_ctl, la] copied in memcpy */
+		/* word3 iocb=IO_TAG wqe=request_payload_len */
+		wqe->gen_req.request_payload_len = xmit_len;
+		/* word4 iocb=parameter wqe=relative_offset memcpy */
+		/* word5 [rctl, type, df_ctl, la] copied in memcpy */
 		/* word6 context tag copied in memcpy */
 		if (iocbq->iocb.ulpCt_h  || iocbq->iocb.ulpCt_l) {
 			ct = ((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l);
@@ -6144,31 +6152,39 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 				ct, iocbq->iocb.ulpCommand);
 			return IOCB_ERROR;
 		}
-		bf_set(lpfc_wqe_gen_ct, &wqe->generic, 0);
-		bf_set(wqe_tmo, &wqe->gen_req.wqe_com,
-			iocbq->iocb.ulpTimeout);
-
-		bf_set(lpfc_wqe_gen_pu, &wqe->generic, iocbq->iocb.ulpPU);
+		bf_set(wqe_ct, &wqe->gen_req.wqe_com, 0);
+		bf_set(wqe_tmo, &wqe->gen_req.wqe_com, iocbq->iocb.ulpTimeout);
+		bf_set(wqe_pu, &wqe->gen_req.wqe_com, iocbq->iocb.ulpPU);
+		bf_set(wqe_dbde, &wqe->gen_req.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->gen_req.wqe_com, LPFC_WQE_IOD_READ);
+		bf_set(wqe_qosd, &wqe->gen_req.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->gen_req.wqe_com, LPFC_WQE_LENLOC_NONE);
+		bf_set(wqe_ebde_cnt, &wqe->gen_req.wqe_com, 0);
 		command_type = OTHER_COMMAND;
 	break;
 	case CMD_XMIT_ELS_RSP64_CX:
 		/* words0-2 BDE memcpy */
-		/* word3 iocb=iotag32 wqe=rsvd */
-		wqe->words[3] = 0;
+		/* word3 iocb=iotag32 wqe=response_payload_len */
+		wqe->xmit_els_rsp.response_payload_len = xmit_len;
 		/* word4 iocb=did wge=rsvd. */
-		wqe->words[4] = 0;
+		wqe->xmit_els_rsp.rsvd4 = 0;
 		/* word5 iocb=rsvd wge=did */
 		bf_set(wqe_els_did, &wqe->xmit_els_rsp.wqe_dest,
 			 iocbq->iocb.un.elsreq64.remoteID);
-
-		bf_set(lpfc_wqe_gen_ct, &wqe->generic,
-			((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l));
-
-		bf_set(lpfc_wqe_gen_pu, &wqe->generic, iocbq->iocb.ulpPU);
-		bf_set(wqe_rcvoxid, &wqe->generic, iocbq->iocb.ulpContext);
+		bf_set(wqe_ct, &wqe->xmit_els_rsp.wqe_com,
+		       ((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l));
+		bf_set(wqe_pu, &wqe->xmit_els_rsp.wqe_com, iocbq->iocb.ulpPU);
+		bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+		       iocbq->iocb.ulpContext);
 		if (!iocbq->iocb.ulpCt_h && iocbq->iocb.ulpCt_l)
-			bf_set(lpfc_wqe_gen_context, &wqe->generic,
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
 			       iocbq->vport->vpi + phba->vpi_base);
+		bf_set(wqe_dbde, &wqe->xmit_els_rsp.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->xmit_els_rsp.wqe_com, LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_qosd, &wqe->xmit_els_rsp.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->xmit_els_rsp.wqe_com,
+		       LPFC_WQE_LENLOC_WORD3);
+		bf_set(wqe_ebde_cnt, &wqe->xmit_els_rsp.wqe_com, 0);
 		command_type = OTHER_COMMAND;
 	break;
 	case CMD_CLOSE_XRI_CN:
@@ -6193,15 +6209,19 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		else
 			bf_set(abort_cmd_ia, &wqe->abort_cmd, 0);
 		bf_set(abort_cmd_criteria, &wqe->abort_cmd, T_XRI_TAG);
-		wqe->words[5] = 0;
-		bf_set(lpfc_wqe_gen_ct, &wqe->generic,
+		/* word5 iocb=CONTEXT_TAG|IO_TAG wqe=reserved */
+		wqe->abort_cmd.rsrvd5 = 0;
+		bf_set(wqe_ct, &wqe->abort_cmd.wqe_com,
 			((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l));
 		abort_tag = iocbq->iocb.un.acxri.abortIoTag;
 		/*
 		 * The abort handler will send us CMD_ABORT_XRI_CN or
 		 * CMD_CLOSE_XRI_CN and the fw only accepts CMD_ABORT_XRI_CX
 		 */
-		bf_set(lpfc_wqe_gen_command, &wqe->generic, CMD_ABORT_XRI_CX);
+		bf_set(wqe_cmnd, &wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
+		bf_set(wqe_qosd, &wqe->abort_cmd.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->abort_cmd.wqe_com,
+		       LPFC_WQE_LENLOC_NONE);
 		cmnd = CMD_ABORT_XRI_CX;
 		command_type = OTHER_COMMAND;
 		xritag = 0;
@@ -6235,18 +6255,14 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_xmit_bls_pt, &wqe->xmit_bls_rsp.wqe_dest, 0x1);
 		bf_set(wqe_ctxt_tag, &wqe->xmit_bls_rsp.wqe_com,
 		       iocbq->iocb.ulpContext);
+		bf_set(wqe_qosd, &wqe->xmit_bls_rsp.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->xmit_bls_rsp.wqe_com,
+		       LPFC_WQE_LENLOC_NONE);
 		/* Overwrite the pre-set comnd type with OTHER_COMMAND */
 		command_type = OTHER_COMMAND;
 	break;
 	case CMD_XRI_ABORTED_CX:
 	case CMD_CREATE_XRI_CR: /* Do we expect to use this? */
-		/* words0-2 are all 0's no bde */
-		/* word3 and word4 are rsvrd */
-		wqe->words[3] = 0;
-		wqe->words[4] = 0;
-		/* word5 iocb=rsvd wge=did */
-		/* There is no remote port id in the IOCB? */
-		/* Let this fall through and fail */
 	case CMD_IOCB_FCP_IBIDIR64_CR: /* bidirectional xfer */
 	case CMD_FCP_TSEND64_CX: /* Target mode send xfer-ready */
 	case CMD_FCP_TRSP64_CX: /* Target mode rcv */
@@ -6257,16 +6273,14 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 				iocbq->iocb.ulpCommand);
 		return IOCB_ERROR;
 	break;
-
 	}
-	bf_set(lpfc_wqe_gen_xri, &wqe->generic, xritag);
-	bf_set(lpfc_wqe_gen_request_tag, &wqe->generic, iocbq->iotag);
-	wqe->generic.abort_tag = abort_tag;
-	bf_set(lpfc_wqe_gen_cmd_type, &wqe->generic, command_type);
-	bf_set(lpfc_wqe_gen_command, &wqe->generic, cmnd);
-	bf_set(lpfc_wqe_gen_class, &wqe->generic, iocbq->iocb.ulpClass);
-	bf_set(lpfc_wqe_gen_cq_id, &wqe->generic, LPFC_WQE_CQ_ID_DEFAULT);
-
+	bf_set(wqe_xri_tag, &wqe->generic.wqe_com, xritag);
+	bf_set(wqe_reqtag, &wqe->generic.wqe_com, iocbq->iotag);
+	wqe->generic.wqe_com.abort_tag = abort_tag;
+	bf_set(wqe_cmd_type, &wqe->generic.wqe_com, command_type);
+	bf_set(wqe_cmnd, &wqe->generic.wqe_com, cmnd);
+	bf_set(wqe_class, &wqe->generic.wqe_com, iocbq->iocb.ulpClass);
+	bf_set(wqe_cqid, &wqe->generic.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
 	return 0;
 }
 


