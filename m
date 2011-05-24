From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/8] lpfc 8.3.24: Add resource extent support
Date: Tue, 24 May 2011 11:44:12 -0400
Message-ID: <1306251853.948.0.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23166 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750962Ab1EXPok (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2011 11:44:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch adds support for hardware that returns resource ids via
extents rather than contiguous ranges.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    3 
 lpfc_bsg.c       |    6 
 lpfc_crtn.h      |    6 
 lpfc_ct.c        |    2 
 lpfc_els.c       |   28 -
 lpfc_hbadisc.c   |   32 -
 lpfc_hw.h        |    2 
 lpfc_hw4.h       |  207 +++++--
 lpfc_init.c      |  127 +++-
 lpfc_mbox.c      |  166 ++++-
 lpfc_mem.c       |   13 
 lpfc_nportdisc.c |   17 
 lpfc_scsi.c      |   53 +
 lpfc_sli.c       | 1525 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 lpfc_sli.h       |    1 
 lpfc_sli4.h      |   27 
 lpfc_vport.c     |    2 
 17 files changed, 1939 insertions(+), 278 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2011-05-20 19:54:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2011-05-23 17:05:08.000000000 -0400
@@ -332,6 +332,8 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 	cmd->ulpLe = 1;
 	cmd->ulpClass = CLASS3;
 	cmd->ulpContext = ndlp->nlp_rpi;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		cmd->ulpContext = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
 	cmd->ulpOwner = OWN_CHIP;
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->context3 = bmp;
@@ -1336,6 +1338,10 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 		}
 
 		icmd->un.ulpWord[3] = ndlp->nlp_rpi;
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			icmd->ulpContext =
+				phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+
 		/* The exchange is done, mark the entry as invalid */
 		phba->ct_ctx[tag].flags &= ~UNSOL_VALID;
 	} else
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-23 17:02:32.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-23 17:05:08.000000000 -0400
@@ -55,6 +55,8 @@ void lpfc_request_features(struct lpfc_h
 void lpfc_supported_pages(struct lpfcMboxq *);
 void lpfc_pc_sli4_params(struct lpfcMboxq *);
 int lpfc_pc_sli4_params_get(struct lpfc_hba *, LPFC_MBOXQ_t *);
+int lpfc_sli4_mbox_rsrc_extent(struct lpfc_hba *, struct lpfcMboxq *,
+			   uint16_t, uint16_t, bool);
 int lpfc_get_sli4_parameters(struct lpfc_hba *, LPFC_MBOXQ_t *);
 struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
 void lpfc_cleanup_rcv_buffers(struct lpfc_vport *);
@@ -366,6 +368,10 @@ extern void lpfc_debugfs_slow_ring_trc(s
 	uint32_t, uint32_t);
 extern struct lpfc_hbq_init *lpfc_hbq_defs[];
 
+/* SLI4 if_type 2 externs. */
+int lpfc_sli4_alloc_resource_identifiers(struct lpfc_hba *);
+int lpfc_sli4_dealloc_resource_identifiers(struct lpfc_hba *);
+
 /* externs BlockGuard */
 extern char *_dump_buf_data;
 extern unsigned long _dump_buf_data_order;
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2011-05-23 17:05:08.000000000 -0400
@@ -352,6 +352,8 @@ lpfc_gen_req(struct lpfc_vport *vport, s
 	icmd->ulpLe = 1;
 	icmd->ulpClass = CLASS3;
 	icmd->ulpContext = ndlp->nlp_rpi;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		icmd->ulpContext = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
 
 	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
 		/* For GEN_REQUEST64_CR, use the RPI */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-05-20 19:54:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-05-23 17:05:08.000000000 -0400
@@ -250,7 +250,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		icmd->un.elsreq64.myID = vport->fc_myDID;
 
 		/* For ELS_REQUEST64_CR, use the VPI by default */
-		icmd->ulpContext = vport->vpi + phba->vpi_base;
+		icmd->ulpContext = phba->vpi_ids[vport->vpi];
 		icmd->ulpCt_h = 0;
 		/* The CT field must be 0=INVALID_RPI for the ECHO cmd */
 		if (elscmd == ELS_CMD_ECHO)
@@ -454,6 +454,7 @@ lpfc_issue_reg_vfi(struct lpfc_vport *vp
 		rc = -ENOMEM;
 		goto fail_free_dmabuf;
 	}
+
 	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq) {
 		rc = -ENOMEM;
@@ -6585,6 +6586,26 @@ lpfc_find_vport_by_vpid(struct lpfc_hba 
 {
 	struct lpfc_vport *vport;
 	unsigned long flags;
+	int i;
+
+	/* The physical ports are always vpi 0 - translate is unnecessary. */
+	if (vpi > 0) {
+		/*
+		 * Translate the physical vpi to the logical vpi.  The
+		 * vport stores the logical vpi.
+		 */
+		for (i = 0; i < phba->max_vpi; i++) {
+			if (vpi == phba->vpi_ids[i])
+				break;
+		}
+
+		if (i >= phba->max_vpi) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
+					 "2936 Could not find Vport mapped "
+					 "to vpi %d\n", vpi);
+			return NULL;
+		}
+	}
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	list_for_each_entry(vport, &phba->port_list, listentry) {
@@ -6641,8 +6662,9 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 			vport = phba->pport;
 		else
 			vport = lpfc_find_vport_by_vpid(phba,
-				icmd->unsli3.rcvsli3.vpi - phba->vpi_base);
+						icmd->unsli3.rcvsli3.vpi);
 	}
+
 	/* If there are no BDEs associated
 	 * with this IOCB, there is nothing to do.
 	 */
@@ -7222,7 +7244,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
 		elsiocb->iocb.ulpCt_h = (SLI4_CT_VPI >> 1) & 1;
 		elsiocb->iocb.ulpCt_l = SLI4_CT_VPI & 1 ;
 		/* Set the ulpContext to the vpi */
-		elsiocb->iocb.ulpContext = vport->vpi + phba->vpi_base;
+		elsiocb->iocb.ulpContext = phba->vpi_ids[vport->vpi];
 	} else {
 		/* For FDISC, Let FDISC rsp set the NPortID for this VPI */
 		icmd->ulpCt_h = 1;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-05-23 17:01:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2011-05-23 17:05:08.000000000 -0400
@@ -780,6 +780,9 @@ struct lpfc_hba {
 	uint16_t vpi_base;
 	uint16_t vfi_base;
 	unsigned long *vpi_bmask;	/* vpi allocation table */
+	uint16_t *vpi_ids;
+	uint16_t vpi_count;
+	struct list_head lpfc_vpi_blk_list;
 
 	/* Data structure used by fabric iocb scheduler */
 	struct list_head fabric_iocb_list;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-05-23 16:51:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-05-23 17:05:08.000000000 -0400
@@ -881,7 +881,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	/* Clean up any firmware default rpi's */
 	mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mb) {
-		lpfc_unreg_did(phba, 0xffff, 0xffffffff, mb);
+		lpfc_unreg_did(phba, 0xffff, LPFC_UNREG_ALL_DFLT_RPIS, mb);
 		mb->vport = vport;
 		mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		if (lpfc_sli_issue_mbox(phba, mb, MBX_NOWAIT)
@@ -3421,7 +3421,8 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		return;
 	}
 
-	ndlp->nlp_rpi = mb->un.varWords[0];
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
@@ -3495,7 +3496,8 @@ out:
 		return;
 	}
 
-	ndlp->nlp_rpi = mb->un.varWords[0];
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
@@ -3582,7 +3584,6 @@ lpfc_register_remote_port(struct lpfc_vp
 	if (ndlp->nlp_type & NLP_FCP_INITIATOR)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
 
-
 	if (rport_ids.roles !=  FC_RPORT_ROLE_UNKNOWN)
 		fc_remote_port_rolechg(rport, rport_ids.roles);
 
@@ -4097,11 +4098,16 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 	struct lpfc_hba *phba = vport->phba;
 	LPFC_MBOXQ_t    *mbox;
 	int rc;
+	uint16_t rpi;
 
 	if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (mbox) {
-			lpfc_unreg_login(phba, vport->vpi, ndlp->nlp_rpi, mbox);
+			/* SLI4 ports require the physical rpi value. */
+			rpi = ndlp->nlp_rpi;
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				rpi = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+			lpfc_unreg_login(phba, vport->vpi, rpi, mbox);
 			mbox->vport = vport;
 			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
@@ -4170,7 +4176,8 @@ lpfc_unreg_all_rpis(struct lpfc_vport *v
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mbox) {
-		lpfc_unreg_login(phba, vport->vpi, 0xffff, mbox);
+		lpfc_unreg_login(phba, vport->vpi, LPFC_UNREG_ALL_RPIS_VPORT,
+				 mbox);
 		mbox->vport = vport;
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->context1 = NULL;
@@ -4194,7 +4201,8 @@ lpfc_unreg_default_rpis(struct lpfc_vpor
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mbox) {
-		lpfc_unreg_did(phba, vport->vpi, 0xffffffff, mbox);
+		lpfc_unreg_did(phba, vport->vpi, LPFC_UNREG_ALL_DFLT_RPIS,
+			       mbox);
 		mbox->vport = vport;
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->context1 = NULL;
@@ -4644,10 +4652,7 @@ lpfc_disc_start(struct lpfc_vport *vport
 	if (num_sent)
 		return;
 
-	/*
-	 * For SLI3, cmpl_reg_vpi will set port_state to READY, and
-	 * continue discovery.
-	 */
+	/* Register the VPI for SLI3, NON-NPIV only. */
 	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 	    !(vport->fc_flag & FC_PT2PT) &&
 	    !(vport->fc_flag & FC_RSCN_MODE) &&
@@ -4934,7 +4939,7 @@ restart_disc:
 		if (phba->sli_rev < LPFC_SLI_REV4) {
 			if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
 				lpfc_issue_reg_vpi(phba, vport);
-			else  {	/* NPIV Not enabled */
+			else  {
 				lpfc_issue_clear_la(phba, vport);
 				vport->port_state = LPFC_VPORT_READY;
 			}
@@ -5060,7 +5065,8 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 	pmb->context1 = NULL;
 	pmb->context2 = NULL;
 
-	ndlp->nlp_rpi = mb->un.varWords[0];
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 17:02:32.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 17:05:08.000000000 -0400
@@ -229,9 +229,26 @@ struct ulp_bde64 {
 
 struct lpfc_sli4_flags {
 	uint32_t word0;
-#define lpfc_fip_flag_SHIFT 0
-#define lpfc_fip_flag_MASK 0x00000001
-#define lpfc_fip_flag_WORD word0
+#define lpfc_idx_rsrc_rdy_SHIFT		0
+#define lpfc_idx_rsrc_rdy_MASK		0x00000001
+#define lpfc_idx_rsrc_rdy_WORD		word0
+#define LPFC_IDX_RSRC_RDY 		1
+#define lpfc_xri_rsrc_rdy_SHIFT		1
+#define lpfc_xri_rsrc_rdy_MASK		0x00000001
+#define lpfc_xri_rsrc_rdy_WORD		word0
+#define LPFC_XRI_RSRC_RDY		1
+#define lpfc_rpi_rsrc_rdy_SHIFT		2
+#define lpfc_rpi_rsrc_rdy_MASK		0x00000001
+#define lpfc_rpi_rsrc_rdy_WORD		word0
+#define LPFC_RPI_RSRC_RDY		1
+#define lpfc_vpi_rsrc_rdy_SHIFT		3
+#define lpfc_vpi_rsrc_rdy_MASK		0x00000001
+#define lpfc_vpi_rsrc_rdy_WORD		word0
+#define LPFC_VPI_RSRC_RDY		1
+#define lpfc_vfi_rsrc_rdy_SHIFT		4
+#define lpfc_vfi_rsrc_rdy_MASK		0x00000001
+#define lpfc_vfi_rsrc_rdy_WORD		word0
+#define LPFC_VFI_RSRC_RDY		1
 };
 
 struct sli4_bls_rsp {
@@ -791,12 +808,22 @@ union lpfc_sli4_cfg_shdr {
 	} response;
 };
 
-/* Mailbox structures */
+/* Mailbox Header structures.
+ * struct mbox_header is defined for first generation SLI4_CFG mailbox
+ * calls deployed for BE-based ports.
+ *
+ * struct sli4_mbox_header is defined for second generation SLI4
+ * ports that don't deploy the SLI4_CFG mechanism.
+ */
 struct mbox_header {
 	struct lpfc_sli4_cfg_mhdr cfg_mhdr;
 	union  lpfc_sli4_cfg_shdr cfg_shdr;
 };
 
+#define LPFC_EXTENT_LOCAL		0
+#define LPFC_TIMEOUT_DEFAULT		0
+#define LPFC_EXTENT_VERSION_DEFAULT	0
+
 /* Subsystem Definitions */
 #define LPFC_MBOX_SUBSYSTEM_COMMON	0x1
 #define LPFC_MBOX_SUBSYSTEM_FCOE	0xC
@@ -819,6 +846,10 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_QUERY_FW_CFG		0x3A
 #define LPFC_MBOX_OPCODE_FUNCTION_RESET		0x3D
 #define LPFC_MBOX_OPCODE_MQ_CREATE_EXT		0x5A
+#define LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO	0x9A
+#define LPFC_MBOX_OPCODE_GET_ALLOC_RSRC_EXTENT	0x9B
+#define LPFC_MBOX_OPCODE_ALLOC_RSRC_EXTENT	0x9C
+#define LPFC_MBOX_OPCODE_DEALLOC_RSRC_EXTENT	0x9D
 #define LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG    0xA0
 #define LPFC_MBOX_OPCODE_GET_PROFILE_CONFIG	0xA4
 #define LPFC_MBOX_OPCODE_WRITE_OBJECT		0xAC
@@ -1238,6 +1269,110 @@ struct lpfc_mbx_mq_destroy {
 	} u;
 };
 
+/* Start Gen 2 SLI4 Mailbox definitions: */
+
+/* Define allocate-ready Gen 2 SLI4 FCoE Resource Extent Types. */
+#define LPFC_RSC_TYPE_FCOE_VFI	0x20
+#define LPFC_RSC_TYPE_FCOE_VPI	0x21
+#define LPFC_RSC_TYPE_FCOE_RPI	0x22
+#define LPFC_RSC_TYPE_FCOE_XRI	0x23
+
+struct lpfc_mbx_get_rsrc_extent_info {
+	struct mbox_header header;
+	union {
+		struct {
+			uint32_t word4;
+#define lpfc_mbx_get_rsrc_extent_info_type_SHIFT	0
+#define lpfc_mbx_get_rsrc_extent_info_type_MASK		0x0000FFFF
+#define lpfc_mbx_get_rsrc_extent_info_type_WORD		word4
+		} req;
+		struct {
+			uint32_t word4;
+#define lpfc_mbx_get_rsrc_extent_info_cnt_SHIFT		0
+#define lpfc_mbx_get_rsrc_extent_info_cnt_MASK		0x0000FFFF
+#define lpfc_mbx_get_rsrc_extent_info_cnt_WORD		word4
+#define lpfc_mbx_get_rsrc_extent_info_size_SHIFT	16
+#define lpfc_mbx_get_rsrc_extent_info_size_MASK		0x0000FFFF
+#define lpfc_mbx_get_rsrc_extent_info_size_WORD		word4
+		} rsp;
+	} u;
+};
+
+struct lpfc_id_range {
+	uint32_t word5;
+#define lpfc_mbx_rsrc_id_word4_0_SHIFT	0
+#define lpfc_mbx_rsrc_id_word4_0_MASK	0x0000FFFF
+#define lpfc_mbx_rsrc_id_word4_0_WORD	word5
+#define lpfc_mbx_rsrc_id_word4_1_SHIFT	16
+#define lpfc_mbx_rsrc_id_word4_1_MASK	0x0000FFFF
+#define lpfc_mbx_rsrc_id_word4_1_WORD	word5
+};
+
+/*
+ * struct lpfc_mbx_alloc_rsrc_extents:
+ * A mbox is generically 256 bytes long. An SLI4_CONFIG mailbox requires
+ * 6 words of header + 4 words of shared subcommand header +
+ * 1 words of Extent-Opcode-specific header = 11 words or 44 bytes total.
+ *
+ * An embedded version of SLI4_CONFIG therefore has 256 - 44 = 212 bytes
+ * for extents payload.
+ *
+ * 212/2 (bytes per extent) = 106 extents.
+ * 106/2 (extents per word) = 53 words.
+ * lpfc_id_range id is statically size to 53.
+ *
+ * This mailbox definition is used for ALLOC or GET_ALLOCATED
+ * extent ranges.  For ALLOC, the type and cnt are required.
+ * For GET_ALLOCATED, only the type is required.
+ */
+struct lpfc_mbx_alloc_rsrc_extents {
+	struct mbox_header header;
+	union {
+		struct {
+			uint32_t word4;
+#define lpfc_mbx_alloc_rsrc_extents_type_SHIFT	0
+#define lpfc_mbx_alloc_rsrc_extents_type_MASK	0x0000FFFF
+#define lpfc_mbx_alloc_rsrc_extents_type_WORD	word4
+#define lpfc_mbx_alloc_rsrc_extents_cnt_SHIFT	16
+#define lpfc_mbx_alloc_rsrc_extents_cnt_MASK	0x0000FFFF
+#define lpfc_mbx_alloc_rsrc_extents_cnt_WORD	word4
+		} req;
+		struct {
+			uint32_t word4;
+#define lpfc_mbx_rsrc_cnt_SHIFT	0
+#define lpfc_mbx_rsrc_cnt_MASK	0x0000FFFF
+#define lpfc_mbx_rsrc_cnt_WORD	word4
+			struct lpfc_id_range id[53];
+		} rsp;
+	} u;
+};
+
+/*
+ * This is the non-embedded version of ALLOC or GET RSRC_EXTENTS. Word4 in this
+ * structure shares the same SHIFT/MASK/WORD defines provided in the
+ * mbx_alloc_rsrc_extents and mbx_get_alloc_rsrc_extents, word4, provided in
+ * the structures defined above.  This non-embedded structure provides for the
+ * maximum number of extents supported by the port.
+ */
+struct lpfc_mbx_nembed_rsrc_extent {
+	union  lpfc_sli4_cfg_shdr cfg_shdr;
+	uint32_t word4;
+	struct lpfc_id_range id;
+};
+
+struct lpfc_mbx_dealloc_rsrc_extents {
+	struct mbox_header header;
+	struct {
+		uint32_t word4;
+#define lpfc_mbx_dealloc_rsrc_extents_type_SHIFT	0
+#define lpfc_mbx_dealloc_rsrc_extents_type_MASK		0x0000FFFF
+#define lpfc_mbx_dealloc_rsrc_extents_type_WORD		word4
+	} req;
+
+};
+
+/* Start SLI4 FCoE specific mbox structures. */
+
 struct lpfc_mbx_post_hdr_tmpl {
 	struct mbox_header header;
 	uint32_t word10;
@@ -1801,61 +1936,31 @@ struct lpfc_mbx_read_rev {
 
 struct lpfc_mbx_read_config {
 	uint32_t word1;
-#define lpfc_mbx_rd_conf_max_bbc_SHIFT		0
-#define lpfc_mbx_rd_conf_max_bbc_MASK		0x000000FF
-#define lpfc_mbx_rd_conf_max_bbc_WORD		word1
-#define lpfc_mbx_rd_conf_init_bbc_SHIFT		8
-#define lpfc_mbx_rd_conf_init_bbc_MASK		0x000000FF
-#define lpfc_mbx_rd_conf_init_bbc_WORD		word1
-	uint32_t word2;
-#define lpfc_mbx_rd_conf_nport_did_SHIFT	0
-#define lpfc_mbx_rd_conf_nport_did_MASK		0x00FFFFFF
-#define lpfc_mbx_rd_conf_nport_did_WORD		word2
+#define lpfc_mbx_rd_conf_extnts_inuse_SHIFT	31
+#define lpfc_mbx_rd_conf_extnts_inuse_MASK	0x00000001
+#define lpfc_mbx_rd_conf_extnts_inuse_WORD	word1
+	uint32_t word2;
 #define lpfc_mbx_rd_conf_topology_SHIFT		24
 #define lpfc_mbx_rd_conf_topology_MASK		0x000000FF
 #define lpfc_mbx_rd_conf_topology_WORD		word2
-	uint32_t word3;
-#define lpfc_mbx_rd_conf_ao_SHIFT		0
-#define lpfc_mbx_rd_conf_ao_MASK		0x00000001
-#define lpfc_mbx_rd_conf_ao_WORD		word3
-#define lpfc_mbx_rd_conf_bb_scn_SHIFT		8
-#define lpfc_mbx_rd_conf_bb_scn_MASK		0x0000000F
-#define lpfc_mbx_rd_conf_bb_scn_WORD		word3
-#define lpfc_mbx_rd_conf_cbb_scn_SHIFT		12
-#define lpfc_mbx_rd_conf_cbb_scn_MASK		0x0000000F
-#define lpfc_mbx_rd_conf_cbb_scn_WORD		word3
-#define lpfc_mbx_rd_conf_mc_SHIFT		29
-#define lpfc_mbx_rd_conf_mc_MASK		0x00000001
-#define lpfc_mbx_rd_conf_mc_WORD		word3
+	uint32_t rsvd_3;
 	uint32_t word4;
 #define lpfc_mbx_rd_conf_e_d_tov_SHIFT		0
 #define lpfc_mbx_rd_conf_e_d_tov_MASK		0x0000FFFF
 #define lpfc_mbx_rd_conf_e_d_tov_WORD		word4
-	uint32_t word5;
-#define lpfc_mbx_rd_conf_lp_tov_SHIFT		0
-#define lpfc_mbx_rd_conf_lp_tov_MASK		0x0000FFFF
-#define lpfc_mbx_rd_conf_lp_tov_WORD		word5
+	uint32_t rsvd_5;
 	uint32_t word6;
 #define lpfc_mbx_rd_conf_r_a_tov_SHIFT		0
 #define lpfc_mbx_rd_conf_r_a_tov_MASK		0x0000FFFF
 #define lpfc_mbx_rd_conf_r_a_tov_WORD		word6
-	uint32_t word7;
-#define lpfc_mbx_rd_conf_r_t_tov_SHIFT		0
-#define lpfc_mbx_rd_conf_r_t_tov_MASK		0x000000FF
-#define lpfc_mbx_rd_conf_r_t_tov_WORD		word7
-	uint32_t word8;
-#define lpfc_mbx_rd_conf_al_tov_SHIFT		0
-#define lpfc_mbx_rd_conf_al_tov_MASK		0x0000000F
-#define lpfc_mbx_rd_conf_al_tov_WORD		word8
+	uint32_t rsvd_7;
+	uint32_t rsvd_8;
 	uint32_t word9;
 #define lpfc_mbx_rd_conf_lmt_SHIFT		0
 #define lpfc_mbx_rd_conf_lmt_MASK		0x0000FFFF
 #define lpfc_mbx_rd_conf_lmt_WORD		word9
-	uint32_t word10;
-#define lpfc_mbx_rd_conf_max_alpa_SHIFT		0
-#define lpfc_mbx_rd_conf_max_alpa_MASK		0x000000FF
-#define lpfc_mbx_rd_conf_max_alpa_WORD		word10
-	uint32_t word11_rsvd;
+	uint32_t rsvd_10;
+	uint32_t rsvd_11;
 	uint32_t word12;
 #define lpfc_mbx_rd_conf_xri_base_SHIFT		0
 #define lpfc_mbx_rd_conf_xri_base_MASK		0x0000FFFF
@@ -1885,9 +1990,6 @@ struct lpfc_mbx_read_config {
 #define lpfc_mbx_rd_conf_vfi_count_MASK         0x0000FFFF
 #define lpfc_mbx_rd_conf_vfi_count_WORD         word15
 	uint32_t word16;
-#define lpfc_mbx_rd_conf_fcfi_base_SHIFT	0
-#define lpfc_mbx_rd_conf_fcfi_base_MASK		0x0000FFFF
-#define lpfc_mbx_rd_conf_fcfi_base_WORD		word16
 #define lpfc_mbx_rd_conf_fcfi_count_SHIFT	16
 #define lpfc_mbx_rd_conf_fcfi_count_MASK	0x0000FFFF
 #define lpfc_mbx_rd_conf_fcfi_count_WORD	word16
@@ -2197,6 +2299,12 @@ struct lpfc_sli4_parameters {
 #define cfg_fcoe_SHIFT				0
 #define cfg_fcoe_MASK				0x00000001
 #define cfg_fcoe_WORD				word12
+#define cfg_ext_SHIFT				1
+#define cfg_ext_MASK				0x00000001
+#define cfg_ext_WORD				word12
+#define cfg_hdrr_SHIFT				2
+#define cfg_hdrr_MASK				0x00000001
+#define cfg_hdrr_WORD				word12
 #define cfg_phwq_SHIFT				15
 #define cfg_phwq_MASK				0x00000001
 #define cfg_phwq_WORD				word12
@@ -2431,6 +2539,9 @@ struct lpfc_mqe {
 		struct lpfc_mbx_cq_destroy cq_destroy;
 		struct lpfc_mbx_wq_destroy wq_destroy;
 		struct lpfc_mbx_rq_destroy rq_destroy;
+		struct lpfc_mbx_get_rsrc_extent_info rsrc_extent_info;
+		struct lpfc_mbx_alloc_rsrc_extents alloc_rsrc_extents;
+		struct lpfc_mbx_dealloc_rsrc_extents dealloc_rsrc_extents;
 		struct lpfc_mbx_post_sgl_pages post_sgl_pages;
 		struct lpfc_mbx_nembed_cmd nembed_cmd;
 		struct lpfc_mbx_read_rev read_rev;
@@ -2651,7 +2762,7 @@ struct lpfc_bmbx_create {
 #define SGL_ALIGN_SZ 64
 #define SGL_PAGE_SIZE 4096
 /* align SGL addr on a size boundary - adjust address up */
-#define NO_XRI  ((uint16_t)-1)
+#define NO_XRI  0xffff
 
 struct wqe_common {
 	uint32_t word6;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2011-05-23 17:01:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2011-05-23 17:05:08.000000000 -0400
@@ -64,6 +64,8 @@
 #define SLI3_IOCB_CMD_SIZE	128
 #define SLI3_IOCB_RSP_SIZE	64
 
+#define LPFC_UNREG_ALL_RPIS_VPORT	0xffff
+#define LPFC_UNREG_ALL_DFLT_RPIS	0xffffffff
 
 /* vendor ID used in SCSI netlink calls */
 #define LPFC_NL_VENDOR_ID (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX)
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 17:02:32.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 17:05:08.000000000 -0400
@@ -212,7 +212,6 @@ lpfc_config_port_prep(struct lpfc_hba *p
 	lpfc_vpd_data = kmalloc(DMP_VPD_SIZE, GFP_KERNEL);
 	if (!lpfc_vpd_data)
 		goto out_free_mbox;
-
 	do {
 		lpfc_dump_mem(phba, pmb, offset, DMP_REGION_VPD);
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
@@ -603,7 +602,6 @@ lpfc_config_port_post(struct lpfc_hba *p
 			/* Clear all pending interrupts */
 			writel(0xffffffff, phba->HAregaddr);
 			readl(phba->HAregaddr); /* flush */
-
 			phba->link_state = LPFC_HBA_ERROR;
 			if (rc != MBX_BUSY)
 				mempool_free(pmb, phba->mbox_mem_pool);
@@ -2690,6 +2688,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 		kfree(io);
 		phba->total_iocbq_bufs--;
 	}
+
 	spin_unlock_irq(&phba->hbalock);
 	return 0;
 }
@@ -3646,6 +3645,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
 			"2718 Clear Virtual Link Received for VPI 0x%x"
 			" tag 0x%x\n", acqe_fip->index, acqe_fip->event_tag);
+
 		vport = lpfc_find_vport_by_vpid(phba,
 				acqe_fip->index - phba->vpi_base);
 		ndlp = lpfc_sli4_perform_vport_cvl(vport);
@@ -4319,7 +4319,7 @@ lpfc_sli4_driver_resource_setup(struct l
 	spin_lock_init(&phba->sli4_hba.abts_sgl_list_lock);
 
 	/*
-	 * Initialize dirver internal slow-path work queues
+	 * Initialize driver internal slow-path work queues
 	 */
 
 	/* Driver internel slow-path CQ Event pool */
@@ -4335,6 +4335,12 @@ lpfc_sli4_driver_resource_setup(struct l
 	/* Receive queue CQ Event work queue list */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_unsol_work_queue);
 
+	/* Initialize extent block lists. */
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_rpi_blk_list);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_xri_blk_list);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_vfi_blk_list);
+	INIT_LIST_HEAD(&phba->lpfc_vpi_blk_list);
+
 	/* Initialize the driver internal SLI layer lists. */
 	lpfc_sli_setup(phba);
 	lpfc_sli_queue_setup(phba);
@@ -4409,9 +4415,19 @@ lpfc_sli4_driver_resource_setup(struct l
 	}
 	/*
 	 * Get sli4 parameters that override parameters from Port capabilities.
-	 * If this call fails it is not a critical error so continue loading.
+	 * If this call fails, it isn't critical unless the SLI4 parameters come
+	 * back in conflict.
 	 */
-	lpfc_get_sli4_parameters(phba, mboxq);
+	rc = lpfc_get_sli4_parameters(phba, mboxq);
+	if (rc) {
+		if (phba->sli4_hba.extents_in_use &&
+		    phba->sli4_hba.rpi_hdrs_in_use) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2999 Unsupported SLI4 Parameters "
+				"Extents and RPI headers enabled.\n");
+			goto out_free_bsmbx;
+		}
+	}
 	mempool_free(mboxq, phba->mbox_mem_pool);
 	/* Create all the SLI4 queues */
 	rc = lpfc_sli4_queue_create(phba);
@@ -4436,7 +4452,6 @@ lpfc_sli4_driver_resource_setup(struct l
 				"1430 Failed to initialize sgl list.\n");
 		goto out_free_sgl_list;
 	}
-
 	rc = lpfc_sli4_init_rpi_hdrs(phba);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -4555,6 +4570,9 @@ lpfc_sli4_driver_resource_unset(struct l
 	lpfc_sli4_cq_event_release_all(phba);
 	lpfc_sli4_cq_event_pool_destroy(phba);
 
+	/* Release resource identifiers. */
+	lpfc_sli4_dealloc_resource_identifiers(phba);
+
 	/* Free the bsmbx region. */
 	lpfc_destroy_bootstrap_mbox(phba);
 
@@ -4755,6 +4773,7 @@ lpfc_init_iocb_list(struct lpfc_hba *phb
 				"Unloading driver.\n", __func__);
 			goto out_free_iocbq;
 		}
+		iocbq_entry->sli4_lxritag = NO_XRI;
 		iocbq_entry->sli4_xritag = NO_XRI;
 
 		spin_lock_irq(&phba->hbalock);
@@ -4852,7 +4871,7 @@ lpfc_init_sgl_list(struct lpfc_hba *phba
 
 	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-				"2400 lpfc_init_sgl_list els %d.\n",
+				"2400 ELS XRI count %d.\n",
 				els_xri_cnt);
 	/* Initialize and populate the sglq list per host/VF. */
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_sgl_list);
@@ -4885,7 +4904,6 @@ lpfc_init_sgl_list(struct lpfc_hba *phba
 	phba->sli4_hba.scsi_xri_max =
 			phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
 	phba->sli4_hba.scsi_xri_cnt = 0;
-
 	phba->sli4_hba.lpfc_scsi_psb_array =
 			kzalloc((sizeof(struct lpfc_scsi_buf *) *
 			phba->sli4_hba.scsi_xri_max), GFP_KERNEL);
@@ -4908,13 +4926,6 @@ lpfc_init_sgl_list(struct lpfc_hba *phba
 			goto out_free_mem;
 		}
 
-		sglq_entry->sli4_xritag = lpfc_sli4_next_xritag(phba);
-		if (sglq_entry->sli4_xritag == NO_XRI) {
-			kfree(sglq_entry);
-			printk(KERN_ERR "%s: failed to allocate XRI.\n"
-				"Unloading driver.\n", __func__);
-			goto out_free_mem;
-		}
 		sglq_entry->buff_type = GEN_BUFF_TYPE;
 		sglq_entry->virt = lpfc_mbuf_alloc(phba, 0, &sglq_entry->phys);
 		if (sglq_entry->virt == NULL) {
@@ -4963,24 +4974,20 @@ int
 lpfc_sli4_init_rpi_hdrs(struct lpfc_hba *phba)
 {
 	int rc = 0;
-	int longs;
-	uint16_t rpi_count;
 	struct lpfc_rpi_hdr *rpi_hdr;
 
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_rpi_hdr_list);
-
 	/*
-	 * Provision an rpi bitmask range for discovery. The total count
-	 * is the difference between max and base + 1.
+	 * If the SLI4 port supports extents, posting the rpi header isn't
+	 * required.  Set the expected maximum count and let the actual value
+	 * get set when extents are fully allocated.
 	 */
-	rpi_count = phba->sli4_hba.max_cfg_param.rpi_base +
-		    phba->sli4_hba.max_cfg_param.max_rpi - 1;
-
-	longs = ((rpi_count) + BITS_PER_LONG - 1) / BITS_PER_LONG;
-	phba->sli4_hba.rpi_bmask = kzalloc(longs * sizeof(unsigned long),
-					   GFP_KERNEL);
-	if (!phba->sli4_hba.rpi_bmask)
-		return -ENOMEM;
+	if (!phba->sli4_hba.rpi_hdrs_in_use) {
+		phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
+		return rc;
+	}
+	if (phba->sli4_hba.extents_in_use)
+		return -EIO;
 
 	rpi_hdr = lpfc_sli4_create_rpi_hdr(phba);
 	if (!rpi_hdr) {
@@ -5014,11 +5021,28 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba
 	struct lpfc_rpi_hdr *rpi_hdr;
 	uint32_t rpi_count;
 
+	/*
+	 * If the SLI4 port supports extents, posting the rpi header isn't
+	 * required.  Set the expected maximum count and let the actual value
+	 * get set when extents are fully allocated.
+	 */
+	if (!phba->sli4_hba.rpi_hdrs_in_use)
+		return NULL;
+	if (phba->sli4_hba.extents_in_use)
+		return NULL;
+
+	/* The limit on the logical index is just the max_rpi count. */
 	rpi_limit = phba->sli4_hba.max_cfg_param.rpi_base +
-		    phba->sli4_hba.max_cfg_param.max_rpi - 1;
+	phba->sli4_hba.max_cfg_param.max_rpi - 1;
 
 	spin_lock_irq(&phba->hbalock);
-	curr_rpi_range = phba->sli4_hba.next_rpi;
+	/*
+	 * Establish the starting RPI in this header block.  The starting
+	 * rpi is normalized to a zero base because the physical rpi is
+	 * port based.
+	 */
+	curr_rpi_range = phba->sli4_hba.next_rpi -
+		phba->sli4_hba.max_cfg_param.rpi_base;
 	spin_unlock_irq(&phba->hbalock);
 
 	/*
@@ -5031,6 +5055,8 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba
 	else
 		rpi_count = LPFC_RPI_HDR_COUNT;
 
+	if (!rpi_count)
+		return NULL;
 	/*
 	 * First allocate the protocol header region for the port.  The
 	 * port expects a 4KB DMA-mapped memory region that is 4K aligned.
@@ -5063,12 +5089,14 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba
 	rpi_hdr->len = LPFC_HDR_TEMPLATE_SIZE;
 	rpi_hdr->page_count = 1;
 	spin_lock_irq(&phba->hbalock);
-	rpi_hdr->start_rpi = phba->sli4_hba.next_rpi;
+
+	/* The rpi_hdr stores the logical index only. */
+	rpi_hdr->start_rpi = curr_rpi_range;
 	list_add_tail(&rpi_hdr->list, &phba->sli4_hba.lpfc_rpi_hdr_list);
 
 	/*
-	 * The next_rpi stores the next module-64 rpi value to post
-	 * in any subsequent rpi memory region postings.
+	 * The next_rpi stores the next logical module-64 rpi value used
+	 * to post physical rpis in subsequent rpi postings.
 	 */
 	phba->sli4_hba.next_rpi += rpi_count;
 	spin_unlock_irq(&phba->hbalock);
@@ -5087,15 +5115,18 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to remove all memory resources allocated
- * to support rpis. This routine presumes the caller has released all
- * rpis consumed by fabric or port logins and is prepared to have
- * the header pages removed.
+ * to support rpis for SLI4 ports not supporting extents. This routine
+ * presumes the caller has released all rpis consumed by fabric or port
+ * logins and is prepared to have the header pages removed.
  **/
 void
 lpfc_sli4_remove_rpi_hdrs(struct lpfc_hba *phba)
 {
 	struct lpfc_rpi_hdr *rpi_hdr, *next_rpi_hdr;
 
+	if (!phba->sli4_hba.rpi_hdrs_in_use)
+		goto exit;
+
 	list_for_each_entry_safe(rpi_hdr, next_rpi_hdr,
 				 &phba->sli4_hba.lpfc_rpi_hdr_list, list) {
 		list_del(&rpi_hdr->list);
@@ -5104,7 +5135,9 @@ lpfc_sli4_remove_rpi_hdrs(struct lpfc_hb
 		kfree(rpi_hdr->dmabuf);
 		kfree(rpi_hdr);
 	}
-	phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.rpi_base;
+ exit:
+	/* There are no rpis available to the port now. */
+	phba->sli4_hba.next_rpi = 0;
 }
 
 /**
@@ -5873,6 +5906,8 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 		rc = -EIO;
 	} else {
 		rd_config = &pmb->u.mqe.un.rd_config;
+		phba->sli4_hba.extents_in_use =
+			bf_get(lpfc_mbx_rd_conf_extnts_inuse, rd_config);
 		phba->sli4_hba.max_cfg_param.max_xri =
 			bf_get(lpfc_mbx_rd_conf_xri_count, rd_config);
 		phba->sli4_hba.max_cfg_param.xri_base =
@@ -5891,8 +5926,6 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 			bf_get(lpfc_mbx_rd_conf_vfi_base, rd_config);
 		phba->sli4_hba.max_cfg_param.max_fcfi =
 			bf_get(lpfc_mbx_rd_conf_fcfi_count, rd_config);
-		phba->sli4_hba.max_cfg_param.fcfi_base =
-			bf_get(lpfc_mbx_rd_conf_fcfi_base, rd_config);
 		phba->sli4_hba.max_cfg_param.max_eq =
 			bf_get(lpfc_mbx_rd_conf_eq_count, rd_config);
 		phba->sli4_hba.max_cfg_param.max_rq =
@@ -5910,11 +5943,13 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 				(phba->sli4_hba.max_cfg_param.max_vpi - 1) : 0;
 		phba->max_vports = phba->max_vpi;
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-				"2003 cfg params XRI(B:%d M:%d), "
+				"2003 cfg params Extents? %d "
+				"XRI(B:%d M:%d), "
 				"VPI(B:%d M:%d) "
 				"VFI(B:%d M:%d) "
 				"RPI(B:%d M:%d) "
-				"FCFI(B:%d M:%d)\n",
+				"FCFI(Count:%d)\n",
+				phba->sli4_hba.extents_in_use,
 				phba->sli4_hba.max_cfg_param.xri_base,
 				phba->sli4_hba.max_cfg_param.max_xri,
 				phba->sli4_hba.max_cfg_param.vpi_base,
@@ -5923,7 +5958,6 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 				phba->sli4_hba.max_cfg_param.max_vfi,
 				phba->sli4_hba.max_cfg_param.rpi_base,
 				phba->sli4_hba.max_cfg_param.max_rpi,
-				phba->sli4_hba.max_cfg_param.fcfi_base,
 				phba->sli4_hba.max_cfg_param.max_fcfi);
 	}
 
@@ -8104,6 +8138,13 @@ lpfc_get_sli4_parameters(struct lpfc_hba
 	int length;
 	struct lpfc_sli4_parameters *mbx_sli4_parameters;
 
+	/*
+	 * By default, the driver assumes the SLI4 port requires RPI
+	 * header postings.  The SLI4_PARAM response will correct this
+	 * assumption.
+	 */
+	phba->sli4_hba.rpi_hdrs_in_use = 1;
+
 	/* Read the port's SLI4 Config Parameters */
 	length = (sizeof(struct lpfc_mbx_get_sli4_parameters) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
@@ -8140,6 +8181,8 @@ lpfc_get_sli4_parameters(struct lpfc_hba
 					    mbx_sli4_parameters);
 	sli4_params->sgl_pp_align = bf_get(cfg_sgl_pp_align,
 					   mbx_sli4_parameters);
+	phba->sli4_hba.extents_in_use = bf_get(cfg_ext, mbx_sli4_parameters);
+	phba->sli4_hba.rpi_hdrs_in_use = bf_get(cfg_hdrr, mbx_sli4_parameters);
 
 	/* Make sure that sge_supp_len can be handled by the driver */
 	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2011-05-20 19:54:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2011-05-23 17:05:08.000000000 -0400
@@ -610,7 +610,8 @@ lpfc_read_sparam(struct lpfc_hba *phba, 
 	mb->un.varRdSparm.un.sp64.tus.f.bdeSize = sizeof (struct serv_parm);
 	mb->un.varRdSparm.un.sp64.addrHigh = putPaddrHigh(mp->phys);
 	mb->un.varRdSparm.un.sp64.addrLow = putPaddrLow(mp->phys);
-	mb->un.varRdSparm.vpi = vpi + phba->vpi_base;
+	if (phba->sli_rev >= LPFC_SLI_REV3)
+		mb->un.varRdSparm.vpi = phba->vpi_ids[vpi];
 
 	/* save address for completion */
 	pmb->context1 = mp;
@@ -643,9 +644,10 @@ lpfc_unreg_did(struct lpfc_hba * phba, u
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->un.varUnregDID.did = did;
-	if (vpi != 0xffff)
-		vpi += phba->vpi_base;
 	mb->un.varUnregDID.vpi = vpi;
+	if ((vpi != 0xffff) &&
+	    (phba->sli_rev == LPFC_SLI_REV4))
+		mb->un.varUnregDID.vpi = phba->vpi_ids[vpi];
 
 	mb->mbxCommand = MBX_UNREG_D_ID;
 	mb->mbxOwner = OWN_HOST;
@@ -738,12 +740,10 @@ lpfc_reg_rpi(struct lpfc_hba *phba, uint
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	mb->un.varRegLogin.rpi = 0;
-	if (phba->sli_rev == LPFC_SLI_REV4) {
-		mb->un.varRegLogin.rpi = rpi;
-		if (mb->un.varRegLogin.rpi == LPFC_RPI_ALLOC_ERROR)
-			return 1;
-	}
-	mb->un.varRegLogin.vpi = vpi + phba->vpi_base;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		mb->un.varRegLogin.rpi = phba->sli4_hba.rpi_ids[rpi];
+	if (phba->sli_rev >= LPFC_SLI_REV3)
+		mb->un.varRegLogin.vpi = phba->vpi_ids[vpi];
 	mb->un.varRegLogin.did = did;
 	mb->mbxOwner = OWN_HOST;
 	/* Get a buffer to hold NPorts Service Parameters */
@@ -757,7 +757,7 @@ lpfc_reg_rpi(struct lpfc_hba *phba, uint
 		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
 				"0302 REG_LOGIN: no buffers, VPI:%d DID:x%x, "
 				"rpi x%x\n", vpi, did, rpi);
-		return (1);
+		return 1;
 	}
 	INIT_LIST_HEAD(&mp->list);
 	sparam = mp->virt;
@@ -773,7 +773,7 @@ lpfc_reg_rpi(struct lpfc_hba *phba, uint
 	mb->un.varRegLogin.un.sp64.addrHigh = putPaddrHigh(mp->phys);
 	mb->un.varRegLogin.un.sp64.addrLow = putPaddrLow(mp->phys);
 
-	return (0);
+	return 0;
 }
 
 /**
@@ -789,6 +789,9 @@ lpfc_reg_rpi(struct lpfc_hba *phba, uint
  *
  * This routine prepares the mailbox command for unregistering remote port
  * login.
+ *
+ * For SLI4 ports, the rpi passed to this function must be the physical
+ * rpi value, not the logical index.
  **/
 void
 lpfc_unreg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t rpi,
@@ -799,9 +802,10 @@ lpfc_unreg_login(struct lpfc_hba *phba, 
 	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
-	mb->un.varUnregLogin.rpi = (uint16_t) rpi;
+	mb->un.varUnregLogin.rpi = rpi;
 	mb->un.varUnregLogin.rsvd1 = 0;
-	mb->un.varUnregLogin.vpi = vpi + phba->vpi_base;
+	if (phba->sli_rev >= LPFC_SLI_REV3)
+		mb->un.varUnregLogin.vpi = phba->vpi_ids[vpi];
 
 	mb->mbxCommand = MBX_UNREG_LOGIN;
 	mb->mbxOwner = OWN_HOST;
@@ -825,9 +829,16 @@ lpfc_sli4_unreg_all_rpis(struct lpfc_vpo
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mbox) {
-		lpfc_unreg_login(phba, vport->vpi,
-			vport->vpi + phba->vpi_base, mbox);
-		mbox->u.mb.un.varUnregLogin.rsvd1 = 0x4000 ;
+		/*
+		 * For SLI4 functions, the rpi field is overloaded for
+		 * the vport context unreg all.  This routine passes
+		 * 0 for the rpi field in lpfc_unreg_login for compatibility
+		 * with SLI3 and then overrides the rpi field with the
+		 * expected value for SLI4.
+		 */
+		lpfc_unreg_login(phba, vport->vpi, phba->vpi_ids[vport->vpi],
+				 mbox);
+		mbox->u.mb.un.varUnregLogin.rsvd1 = 0x4000;
 		mbox->vport = vport;
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->context1 = NULL;
@@ -865,9 +876,13 @@ lpfc_reg_vpi(struct lpfc_vport *vport, L
 	if ((phba->sli_rev == LPFC_SLI_REV4) &&
 		!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI))
 		mb->un.varRegVpi.upd = 1;
-	mb->un.varRegVpi.vpi = vport->vpi + vport->phba->vpi_base;
+
+	mb->un.varRegVpi.vpi = phba->vpi_ids[vport->vpi];
 	mb->un.varRegVpi.sid = vport->fc_myDID;
-	mb->un.varRegVpi.vfi = vport->vfi + vport->phba->vfi_base;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		mb->un.varRegVpi.vfi = phba->sli4_hba.vfi_ids[vport->vfi];
+	else
+		mb->un.varRegVpi.vfi = vport->vfi + vport->phba->vfi_base;
 	memcpy(mb->un.varRegVpi.wwn, &vport->fc_portname,
 	       sizeof(struct lpfc_name));
 	mb->un.varRegVpi.wwn[0] = cpu_to_le32(mb->un.varRegVpi.wwn[0]);
@@ -901,10 +916,10 @@ lpfc_unreg_vpi(struct lpfc_hba *phba, ui
 	MAILBOX_t *mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
-	if (phba->sli_rev < LPFC_SLI_REV4)
-		mb->un.varUnregVpi.vpi = vpi + phba->vpi_base;
-	else
-		mb->un.varUnregVpi.sli4_vpi = vpi + phba->vpi_base;
+	if (phba->sli_rev == LPFC_SLI_REV3)
+		mb->un.varUnregVpi.vpi = phba->vpi_ids[vpi];
+	else if (phba->sli_rev >= LPFC_SLI_REV4)
+		mb->un.varUnregVpi.sli4_vpi = phba->vpi_ids[vpi];
 
 	mb->mbxCommand = MBX_UNREG_VPI;
 	mb->mbxOwner = OWN_HOST;
@@ -1735,12 +1750,12 @@ lpfc_sli4_config(struct lpfc_hba *phba, 
 		return length;
 	}
 
-	/* Setup for the none-embedded mbox command */
+	/* Setup for the non-embedded mbox command */
 	pcount = (SLI4_PAGE_ALIGN(length))/SLI4_PAGE_SIZE;
 	pcount = (pcount > LPFC_SLI4_MBX_SGE_MAX_PAGES) ?
 				LPFC_SLI4_MBX_SGE_MAX_PAGES : pcount;
 	/* Allocate record for keeping SGE virtual addresses */
-	mbox->sge_array = kmalloc(sizeof(struct lpfc_mbx_nembed_sge_virt),
+	mbox->sge_array = kzalloc(sizeof(struct lpfc_mbx_nembed_sge_virt),
 				  GFP_KERNEL);
 	if (!mbox->sge_array) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
@@ -1790,12 +1805,87 @@ lpfc_sli4_config(struct lpfc_hba *phba, 
 	/* The sub-header is in DMA memory, which needs endian converstion */
 	if (cfg_shdr)
 		lpfc_sli_pcimem_bcopy(cfg_shdr, cfg_shdr,
-			      sizeof(union  lpfc_sli4_cfg_shdr));
-
+				      sizeof(union  lpfc_sli4_cfg_shdr));
 	return alloc_len;
 }
 
 /**
+ * lpfc_sli4_mbox_rsrc_extent - Initialize the opcode resource extent.
+ * @phba: pointer to lpfc hba data structure.
+ * @mbox: pointer to an allocated lpfc mbox resource.
+ * @exts_count: the number of extents, if required, to allocate.
+ * @rsrc_type: the resource extent type.
+ * @emb: true if LPFC_SLI4_MBX_EMBED. false if LPFC_SLI4_MBX_NEMBED.
+ *
+ * This routine completes the subcommand header for SLI4 resource extent
+ * mailbox commands.  It is called after lpfc_sli4_config.  The caller must
+ * pass an allocated mailbox and the attributes required to initialize the
+ * mailbox correctly.
+ *
+ * Return: the actual length of the mbox command allocated.
+ **/
+int
+lpfc_sli4_mbox_rsrc_extent(struct lpfc_hba *phba, struct lpfcMboxq *mbox,
+			   uint16_t exts_count, uint16_t rsrc_type, bool emb)
+{
+	uint8_t opcode = 0;
+	struct lpfc_mbx_nembed_rsrc_extent *n_rsrc_extnt = NULL;
+	void *virtaddr = NULL;
+
+	/* Set up SLI4 ioctl command header fields */
+	if (emb == LPFC_SLI4_MBX_NEMBED) {
+		/* Get the first SGE entry from the non-embedded DMA memory */
+		virtaddr = mbox->sge_array->addr[0];
+		if (virtaddr == NULL)
+			return 1;
+		n_rsrc_extnt = (struct lpfc_mbx_nembed_rsrc_extent *) virtaddr;
+	}
+
+	/*
+	 * The resource type is common to all extent Opcodes and resides in the
+	 * same position.
+	 */
+	if (emb == LPFC_SLI4_MBX_EMBED)
+		bf_set(lpfc_mbx_alloc_rsrc_extents_type,
+		       &mbox->u.mqe.un.alloc_rsrc_extents.u.req,
+		       rsrc_type);
+	else {
+		/* This is DMA data.  Byteswap is required. */
+		bf_set(lpfc_mbx_alloc_rsrc_extents_type,
+		       n_rsrc_extnt, rsrc_type);
+		lpfc_sli_pcimem_bcopy(&n_rsrc_extnt->word4,
+				      &n_rsrc_extnt->word4,
+				      sizeof(uint32_t));
+	}
+
+	/* Complete the initialization for the particular Opcode. */
+	opcode = lpfc_sli4_mbox_opcode_get(phba, mbox);
+	switch (opcode) {
+	case LPFC_MBOX_OPCODE_ALLOC_RSRC_EXTENT:
+		if (emb == LPFC_SLI4_MBX_EMBED)
+			bf_set(lpfc_mbx_alloc_rsrc_extents_cnt,
+			       &mbox->u.mqe.un.alloc_rsrc_extents.u.req,
+			       exts_count);
+		else
+			bf_set(lpfc_mbx_alloc_rsrc_extents_cnt,
+			       n_rsrc_extnt, exts_count);
+		break;
+	case LPFC_MBOX_OPCODE_GET_ALLOC_RSRC_EXTENT:
+	case LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO:
+	case LPFC_MBOX_OPCODE_DEALLOC_RSRC_EXTENT:
+		/* Initialization is complete.*/
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"2929 Resource Extent Opcode x%x is "
+				"unsupported\n", opcode);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
  * lpfc_sli4_mbox_opcode_get - Get the opcode from a sli4 mailbox command
  * @phba: pointer to lpfc hba data structure.
  * @mbox: pointer to lpfc mbox command.
@@ -1939,9 +2029,12 @@ lpfc_init_vfi(struct lpfcMboxq *mbox, st
 	bf_set(lpfc_init_vfi_vr, init_vfi, 1);
 	bf_set(lpfc_init_vfi_vt, init_vfi, 1);
 	bf_set(lpfc_init_vfi_vp, init_vfi, 1);
-	bf_set(lpfc_init_vfi_vfi, init_vfi, vport->vfi + vport->phba->vfi_base);
-	bf_set(lpfc_init_vpi_vpi, init_vfi, vport->vpi + vport->phba->vpi_base);
-	bf_set(lpfc_init_vfi_fcfi, init_vfi, vport->phba->fcf.fcfi);
+	bf_set(lpfc_init_vfi_vfi, init_vfi,
+	       vport->phba->sli4_hba.vfi_ids[vport->vfi]);
+	bf_set(lpfc_init_vpi_vpi, init_vfi,
+	       vport->phba->vpi_ids[vport->vpi]);
+	bf_set(lpfc_init_vfi_fcfi, init_vfi,
+	       vport->phba->fcf.fcfi);
 }
 
 /**
@@ -1964,9 +2057,10 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, str
 	reg_vfi = &mbox->u.mqe.un.reg_vfi;
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_REG_VFI);
 	bf_set(lpfc_reg_vfi_vp, reg_vfi, 1);
-	bf_set(lpfc_reg_vfi_vfi, reg_vfi, vport->vfi + vport->phba->vfi_base);
+	bf_set(lpfc_reg_vfi_vfi, reg_vfi,
+	       vport->phba->sli4_hba.vfi_ids[vport->vfi]);
 	bf_set(lpfc_reg_vfi_fcfi, reg_vfi, vport->phba->fcf.fcfi);
-	bf_set(lpfc_reg_vfi_vpi, reg_vfi, vport->vpi + vport->phba->vpi_base);
+	bf_set(lpfc_reg_vfi_vpi, reg_vfi, vport->phba->vpi_ids[vport->vpi]);
 	memcpy(reg_vfi->wwn, &vport->fc_portname, sizeof(struct lpfc_name));
 	reg_vfi->wwn[0] = cpu_to_le32(reg_vfi->wwn[0]);
 	reg_vfi->wwn[1] = cpu_to_le32(reg_vfi->wwn[1]);
@@ -1997,9 +2091,9 @@ lpfc_init_vpi(struct lpfc_hba *phba, str
 	memset(mbox, 0, sizeof(*mbox));
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_INIT_VPI);
 	bf_set(lpfc_init_vpi_vpi, &mbox->u.mqe.un.init_vpi,
-	       vpi + phba->vpi_base);
+	       phba->vpi_ids[vpi]);
 	bf_set(lpfc_init_vpi_vfi, &mbox->u.mqe.un.init_vpi,
-	       phba->pport->vfi + phba->vfi_base);
+	       phba->sli4_hba.vfi_ids[phba->pport->vfi]);
 }
 
 /**
@@ -2019,7 +2113,7 @@ lpfc_unreg_vfi(struct lpfcMboxq *mbox, s
 	memset(mbox, 0, sizeof(*mbox));
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_UNREG_VFI);
 	bf_set(lpfc_unreg_vfi_vfi, &mbox->u.mqe.un.unreg_vfi,
-	       vport->vfi + vport->phba->vfi_base);
+	       vport->phba->sli4_hba.vfi_ids[vport->vfi]);
 }
 
 /**
@@ -2131,12 +2225,14 @@ lpfc_unreg_fcfi(struct lpfcMboxq *mbox, 
 void
 lpfc_resume_rpi(struct lpfcMboxq *mbox, struct lpfc_nodelist *ndlp)
 {
+	struct lpfc_hba *phba = ndlp->phba;
 	struct lpfc_mbx_resume_rpi *resume_rpi;
 
 	memset(mbox, 0, sizeof(*mbox));
 	resume_rpi = &mbox->u.mqe.un.resume_rpi;
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_RESUME_RPI);
-	bf_set(lpfc_resume_rpi_index, resume_rpi, ndlp->nlp_rpi);
+	bf_set(lpfc_resume_rpi_index, resume_rpi,
+	       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
 	bf_set(lpfc_resume_rpi_ii, resume_rpi, RESUME_INDEX_RPI);
 	resume_rpi->event_tag = ndlp->phba->fc_eventTag;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2011-05-23 17:05:08.000000000 -0400
@@ -62,7 +62,6 @@ int
 lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 {
 	struct lpfc_dma_pool *pool = &phba->lpfc_mbuf_safety_pool;
-	int longs;
 	int i;
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
@@ -138,17 +137,8 @@ lpfc_mem_alloc(struct lpfc_hba *phba, in
 		phba->lpfc_hrb_pool = NULL;
 		phba->lpfc_drb_pool = NULL;
 	}
-	/* vpi zero is reserved for the physical port so add 1 to max */
-	longs = ((phba->max_vpi + 1) + BITS_PER_LONG - 1) / BITS_PER_LONG;
-	phba->vpi_bmask = kzalloc(longs * sizeof(unsigned long), GFP_KERNEL);
-	if (!phba->vpi_bmask)
-		goto fail_free_dbq_pool;
 
 	return 0;
-
- fail_free_dbq_pool:
-	pci_pool_destroy(phba->lpfc_drb_pool);
-	phba->lpfc_drb_pool = NULL;
  fail_free_hrb_pool:
 	pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
@@ -191,9 +181,6 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	int i;
 	struct lpfc_dma_pool *pool = &phba->lpfc_mbuf_safety_pool;
 
-	/* Free VPI bitmask memory */
-	kfree(phba->vpi_bmask);
-
 	/* Free HBQ pools */
 	lpfc_sli_hbqbuf_free_all(phba);
 	if (phba->lpfc_drb_pool)
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2011-05-23 16:51:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2011-05-23 17:05:08.000000000 -0400
@@ -652,6 +652,7 @@ lpfc_disc_set_adisc(struct lpfc_vport *v
 	lpfc_unreg_rpi(vport, ndlp);
 	return 0;
 }
+
 /**
  * lpfc_release_rpi - Release a RPI by issuing unreg_login mailbox cmd.
  * @phba : Pointer to lpfc_hba structure.
@@ -1394,8 +1395,11 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 	if (mb->mbxStatus) {
 		/* RegLogin failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
-				"0246 RegLogin failed Data: x%x x%x x%x\n",
-				did, mb->mbxStatus, vport->port_state);
+				"0246 RegLogin failed Data: x%x x%x x%x x%x "
+				 "x%x\n",
+				 did, mb->mbxStatus, vport->port_state,
+				 mb->un.varRegLogin.vpi,
+				 mb->un.varRegLogin.rpi);
 		/*
 		 * If RegLogin failed due to lack of HBA resources do not
 		 * retry discovery.
@@ -1419,7 +1423,10 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 		return ndlp->nlp_state;
 	}
 
-	ndlp->nlp_rpi = mb->un.varWords[0];
+	/* SLI4 ports have preallocated logical rpis. */
+	if (vport->phba->sli_rev < LPFC_SLI_REV4)
+		ndlp->nlp_rpi = mb->un.varWords[0];
+
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 
 	/* Only if we are not a fabric nport do we issue PRLI */
@@ -2020,7 +2027,9 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_
 	MAILBOX_t    *mb = &pmb->u.mb;
 
 	if (!mb->mbxStatus) {
-		ndlp->nlp_rpi = mb->un.varWords[0];
+		/* SLI4 ports have preallocated logical rpis. */
+		if (vport->phba->sli_rev < LPFC_SLI_REV4)
+			ndlp->nlp_rpi = mb->un.varWords[0];
 		ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	} else {
 		if (ndlp->nlp_flag & NLP_NODEV_REMOVE) {
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2011-05-23 16:51:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-05-23 17:05:08.000000000 -0400
@@ -743,7 +743,14 @@ lpfc_sli4_repost_scsi_sgl_list(struct lp
 		if (bcnt == 0)
 			continue;
 		/* Now, post the SCSI buffer list sgls as a block */
-		status = lpfc_sli4_post_scsi_sgl_block(phba, &sblist, bcnt);
+		if (!phba->sli4_hba.extents_in_use)
+			status = lpfc_sli4_post_scsi_sgl_block(phba,
+							&sblist,
+							bcnt);
+		else
+			status = lpfc_sli4_post_scsi_sgl_blk_ext(phba,
+							&sblist,
+							bcnt);
 		/* Reset SCSI buffer count for next round of posting */
 		bcnt = 0;
 		while (!list_empty(&sblist)) {
@@ -787,7 +794,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 	dma_addr_t pdma_phys_fcp_cmd;
 	dma_addr_t pdma_phys_fcp_rsp;
 	dma_addr_t pdma_phys_bpl, pdma_phys_bpl1;
-	uint16_t iotag, last_xritag = NO_XRI;
+	uint16_t iotag, last_xritag = NO_XRI, lxri = 0;
 	int status = 0, index;
 	int bcnt;
 	int non_sequential_xri = 0;
@@ -823,13 +830,15 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 			break;
 		}
 
-		psb->cur_iocbq.sli4_xritag = lpfc_sli4_next_xritag(phba);
-		if (psb->cur_iocbq.sli4_xritag == NO_XRI) {
+		lxri = lpfc_sli4_next_xritag(phba);
+		if (lxri == NO_XRI) {
 			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
 			      psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
 		}
+		psb->cur_iocbq.sli4_lxritag = lxri;
+		psb->cur_iocbq.sli4_xritag = phba->sli4_hba.xri_ids[lxri];
 		if (last_xritag != NO_XRI
 			&& psb->cur_iocbq.sli4_xritag != (last_xritag+1)) {
 			non_sequential_xri = 1;
@@ -916,7 +925,21 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 		}
 	}
 	if (bcnt) {
-		status = lpfc_sli4_post_scsi_sgl_block(phba, &sblist, bcnt);
+		if (!phba->sli4_hba.extents_in_use)
+			status = lpfc_sli4_post_scsi_sgl_block(phba,
+								&sblist,
+								bcnt);
+		else
+			status = lpfc_sli4_post_scsi_sgl_blk_ext(phba,
+								&sblist,
+								bcnt);
+
+		if (status) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"3021 SCSI SGL post error %d\n",
+					status);
+			bcnt = 0;
+		}
 		/* Reset SCSI buffer count for next round of posting */
 		while (!list_empty(&sblist)) {
 			list_remove_head(&sblist, psb, struct lpfc_scsi_buf,
@@ -2797,6 +2820,9 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	 * of the scsi_cmnd request_buffer
 	 */
 	piocbq->iocb.ulpContext = pnode->nlp_rpi;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		piocbq->iocb.ulpContext =
+		  phba->sli4_hba.rpi_ids[pnode->nlp_rpi];
 	if (pnode->nlp_fcp_info & NLP_FCP_2_DEVICE)
 		piocbq->iocb.ulpFCP2Rcvy = 1;
 	else
@@ -2810,7 +2836,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 }
 
 /**
- * lpfc_scsi_prep_task_mgmt_cmnd - Convert SLI3 scsi TM cmd to FCP info unit
+ * lpfc_scsi_prep_task_mgmt_cmd - Convert SLI3 scsi TM cmd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
  * @lun: Logical unit number.
@@ -2854,6 +2880,10 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_fcpcmd_to_iocb(piocb->unsli3.fcp_ext.icd, fcp_cmnd);
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
 	piocb->ulpContext = ndlp->nlp_rpi;
+	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
+		piocb->ulpContext =
+		  vport->phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+	}
 	if (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
 		piocb->ulpFCP2Rcvy = 1;
 	}
@@ -3408,9 +3438,10 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			 "0702 Issue %s to TGT %d LUN %d "
-			 "rpi x%x nlp_flag x%x\n",
+			 "rpi x%x nlp_flag x%x Data: x%x x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd), tgt_id, lun_id,
-			 pnode->nlp_rpi, pnode->nlp_flag);
+			 pnode->nlp_rpi, pnode->nlp_flag, iocbq->sli4_xritag,
+			 iocbq->iocb_flag);
 
 	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
@@ -3422,10 +3453,12 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 			ret = FAILED;
 		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0727 TMF %s to TGT %d LUN %d failed (%d, %d)\n",
+			 "0727 TMF %s to TGT %d LUN %d failed (%d, %d) "
+			 "iocb_flag x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd),
 			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
-			 iocbqrsp->iocb.un.ulpWord[4]);
+			 iocbqrsp->iocb.un.ulpWord[4],
+			 iocbq->iocb_flag);
 	} else if (status == IOCB_BUSY)
 		ret = FAILED;
 	else
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-05-23 17:01:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-05-23 17:05:08.000000000 -0400
@@ -310,7 +310,6 @@ struct lpfc_max_cfg_param {
 	uint16_t vfi_base;
 	uint16_t vfi_used;
 	uint16_t max_fcfi;
-	uint16_t fcfi_base;
 	uint16_t fcfi_used;
 	uint16_t max_eq;
 	uint16_t max_rq;
@@ -449,10 +448,13 @@ struct lpfc_sli4_hba {
 	uint32_t intr_enable;
 	struct lpfc_bmbx bmbx;
 	struct lpfc_max_cfg_param max_cfg_param;
+	uint16_t extents_in_use; /* must allocate resource extents. */
+	uint16_t rpi_hdrs_in_use; /* must post rpi hdrs if set. */
 	uint16_t next_xri; /* last_xri - max_cfg_param.xri_base = used */
 	uint16_t next_rpi;
 	uint16_t scsi_xri_max;
 	uint16_t scsi_xri_cnt;
+	uint16_t scsi_xri_start;
 	struct list_head lpfc_free_sgl_list;
 	struct list_head lpfc_sgl_list;
 	struct lpfc_sglq **lpfc_els_sgl_array;
@@ -463,7 +465,17 @@ struct lpfc_sli4_hba {
 	struct lpfc_sglq **lpfc_sglq_active_list;
 	struct list_head lpfc_rpi_hdr_list;
 	unsigned long *rpi_bmask;
+	uint16_t *rpi_ids;
 	uint16_t rpi_count;
+	struct list_head lpfc_rpi_blk_list;
+	unsigned long *xri_bmask;
+	uint16_t *xri_ids;
+	uint16_t xri_count;
+	struct list_head lpfc_xri_blk_list;
+	unsigned long *vfi_bmask;
+	uint16_t *vfi_ids;
+	uint16_t vfi_count;
+	struct list_head lpfc_vfi_blk_list;
 	struct lpfc_sli4_flags sli4_flags;
 	struct list_head sp_queue_event;
 	struct list_head sp_cqe_event_pool;
@@ -496,6 +508,7 @@ struct lpfc_sglq {
 	enum lpfc_sgl_state state;
 	struct lpfc_nodelist *ndlp; /* ndlp associated with IO */
 	uint16_t iotag;         /* pre-assigned IO tag */
+	uint16_t sli4_lxritag;  /* logical pre-assigned xri. */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
 	struct sli4_sge *sgl;	/* pre-assigned SGL */
 	void *virt;		/* virtual address. */
@@ -510,6 +523,13 @@ struct lpfc_rpi_hdr {
 	uint32_t start_rpi;
 };
 
+struct lpfc_rsrc_blks {
+	struct list_head list;
+	uint16_t rsrc_start;
+	uint16_t rsrc_size;
+	uint16_t rsrc_used;
+};
+
 /*
  * SLI4 specific function prototypes
  */
@@ -549,8 +569,11 @@ int lpfc_sli4_post_sgl(struct lpfc_hba *
 int lpfc_sli4_repost_scsi_sgl_list(struct lpfc_hba *);
 uint16_t lpfc_sli4_next_xritag(struct lpfc_hba *);
 int lpfc_sli4_post_async_mbox(struct lpfc_hba *);
-int lpfc_sli4_post_sgl_list(struct lpfc_hba *phba);
+int lpfc_sli4_post_els_sgl_list(struct lpfc_hba *phba);
+int lpfc_sli4_post_els_sgl_list_ext(struct lpfc_hba *phba);
 int lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *, struct list_head *, int);
+int lpfc_sli4_post_scsi_sgl_blk_ext(struct lpfc_hba *, struct list_head *,
+				    int);
 struct lpfc_cq_event *__lpfc_sli4_cq_event_alloc(struct lpfc_hba *);
 struct lpfc_cq_event *lpfc_sli4_cq_event_alloc(struct lpfc_hba *);
 void __lpfc_sli4_cq_event_release(struct lpfc_hba *, struct lpfc_cq_event *);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-05-23 17:02:32.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-05-23 17:05:08.000000000 -0400
@@ -459,7 +459,6 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *ph
 	struct lpfc_iocbq * iocbq = NULL;
 
 	list_remove_head(lpfc_iocb_list, iocbq, struct lpfc_iocbq, list);
-
 	if (iocbq)
 		phba->iocb_cnt++;
 	if (phba->iocb_cnt > phba->iocb_max)
@@ -482,13 +481,10 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *ph
 static struct lpfc_sglq *
 __lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
 {
-	uint16_t adj_xri;
 	struct lpfc_sglq *sglq;
-	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
-	if (adj_xri > phba->sli4_hba.max_cfg_param.max_xri)
-		return NULL;
-	sglq = phba->sli4_hba.lpfc_sglq_active_list[adj_xri];
-	phba->sli4_hba.lpfc_sglq_active_list[adj_xri] = NULL;
+
+	sglq = phba->sli4_hba.lpfc_sglq_active_list[xritag];
+	phba->sli4_hba.lpfc_sglq_active_list[xritag] = NULL;
 	return sglq;
 }
 
@@ -507,12 +503,9 @@ __lpfc_clear_active_sglq(struct lpfc_hba
 struct lpfc_sglq *
 __lpfc_get_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
 {
-	uint16_t adj_xri;
 	struct lpfc_sglq *sglq;
-	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
-	if (adj_xri > phba->sli4_hba.max_cfg_param.max_xri)
-		return NULL;
-	sglq =  phba->sli4_hba.lpfc_sglq_active_list[adj_xri];
+
+	sglq =  phba->sli4_hba.lpfc_sglq_active_list[xritag];
 	return sglq;
 }
 
@@ -535,7 +528,6 @@ static int
 __lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 		uint16_t xritag, uint16_t rxid, uint16_t send_rrq)
 {
-	uint16_t adj_xri;
 	struct lpfc_node_rrq *rrq;
 	int empty;
 	uint32_t did = 0;
@@ -556,21 +548,19 @@ __lpfc_set_rrq_active(struct lpfc_hba *p
 	/*
 	 * set the active bit even if there is no mem available.
 	 */
-	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
-
 	if (NLP_CHK_FREE_REQ(ndlp))
 		goto out;
 
 	if (ndlp->vport && (ndlp->vport->load_flag & FC_UNLOADING))
 		goto out;
 
-	if (test_and_set_bit(adj_xri, ndlp->active_rrqs.xri_bitmap))
+	if (test_and_set_bit(xritag, ndlp->active_rrqs.xri_bitmap))
 		goto out;
 
 	rrq = mempool_alloc(phba->rrq_pool, GFP_KERNEL);
 	if (rrq) {
 		rrq->send_rrq = send_rrq;
-		rrq->xritag = xritag;
+		rrq->xritag = phba->sli4_hba.xri_ids[xritag];
 		rrq->rrq_stop_time = jiffies + HZ * (phba->fc_ratov + 1);
 		rrq->ndlp = ndlp;
 		rrq->nlp_DID = ndlp->nlp_DID;
@@ -606,7 +596,6 @@ lpfc_clr_rrq_active(struct lpfc_hba *phb
 		    uint16_t xritag,
 		    struct lpfc_node_rrq *rrq)
 {
-	uint16_t adj_xri;
 	struct lpfc_nodelist *ndlp = NULL;
 
 	if ((rrq->vport) && NLP_CHK_NODE_ACT(rrq->ndlp))
@@ -622,8 +611,7 @@ lpfc_clr_rrq_active(struct lpfc_hba *phb
 	if (!ndlp)
 		goto out;
 
-	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
-	if (test_and_clear_bit(adj_xri, ndlp->active_rrqs.xri_bitmap)) {
+	if (test_and_clear_bit(xritag, ndlp->active_rrqs.xri_bitmap)) {
 		rrq->send_rrq = 0;
 		rrq->xritag = 0;
 		rrq->rrq_stop_time = 0;
@@ -799,12 +787,9 @@ int
 lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 			uint16_t  xritag)
 {
-	uint16_t adj_xri;
-
-	adj_xri = xritag - phba->sli4_hba.max_cfg_param.xri_base;
 	if (!ndlp)
 		return 0;
-	if (test_bit(adj_xri, ndlp->active_rrqs.xri_bitmap))
+	if (test_bit(xritag, ndlp->active_rrqs.xri_bitmap))
 			return 1;
 	else
 		return 0;
@@ -844,7 +829,7 @@ lpfc_set_rrq_active(struct lpfc_hba *phb
  * @piocb: Pointer to the iocbq.
  *
  * This function is called with hbalock held. This function
- * Gets a new driver sglq object from the sglq list. If the
+ * gets a new driver sglq object from the sglq list. If the
  * list is not empty then it is successful, it returns pointer to the newly
  * allocated sglq object else it returns NULL.
  **/
@@ -854,7 +839,6 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 	struct list_head *lpfc_sgl_list = &phba->sli4_hba.lpfc_sgl_list;
 	struct lpfc_sglq *sglq = NULL;
 	struct lpfc_sglq *start_sglq = NULL;
-	uint16_t adj_xri;
 	struct lpfc_scsi_buf *lpfc_cmd;
 	struct lpfc_nodelist *ndlp;
 	int found = 0;
@@ -873,8 +857,6 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 	while (!found) {
 		if (!sglq)
 			return NULL;
-		adj_xri = sglq->sli4_xritag -
-				phba->sli4_hba.max_cfg_param.xri_base;
 		if (lpfc_test_rrq_active(phba, ndlp, sglq->sli4_xritag)) {
 			/* This xri has an rrq outstanding for this DID.
 			 * put it back in the list and get another xri.
@@ -891,7 +873,7 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 		}
 		sglq->ndlp = ndlp;
 		found = 1;
-		phba->sli4_hba.lpfc_sglq_active_list[adj_xri] = sglq;
+		phba->sli4_hba.lpfc_sglq_active_list[sglq->sli4_lxritag] = sglq;
 		sglq->state = SGL_ALLOCATED;
 	}
 	return sglq;
@@ -947,7 +929,8 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 	if (iocbq->sli4_xritag == NO_XRI)
 		sglq = NULL;
 	else
-		sglq = __lpfc_clear_active_sglq(phba, iocbq->sli4_xritag);
+		sglq = __lpfc_clear_active_sglq(phba, iocbq->sli4_lxritag);
+
 	if (sglq)  {
 		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
 			(sglq->state != SGL_XRI_ABORTED)) {
@@ -974,6 +957,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 	 * Clean all volatile data fields, preserve iotag and node struct.
 	 */
 	memset((char *)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
+	iocbq->sli4_lxritag = NO_XRI;
 	iocbq->sli4_xritag = NO_XRI;
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
@@ -2116,7 +2100,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 	    pmb->u.mb.mbxCommand == MBX_REG_LOGIN64 &&
 	    !pmb->u.mb.mbxStatus) {
 		rpi = pmb->u.mb.un.varWords[0];
-		vpi = pmb->u.mb.un.varRegLogin.vpi - phba->vpi_base;
+		vpi = pmb->u.mb.un.varRegLogin.vpi;
 		lpfc_unreg_login(phba, vpi, rpi, pmb);
 		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
@@ -4323,6 +4307,7 @@ lpfc_sli_config_port(struct lpfc_hba *ph
 			continue;
 		} else if (rc)
 			break;
+
 		phba->link_state = LPFC_INIT_MBX_CMDS;
 		lpfc_config_port(phba, pmb);
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
@@ -4426,7 +4411,8 @@ int
 lpfc_sli_hba_setup(struct lpfc_hba *phba)
 {
 	uint32_t rc;
-	int  mode = 3;
+	int  mode = 3, i;
+	int longs;
 
 	switch (lpfc_sli_mode) {
 	case 2:
@@ -4496,6 +4482,35 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 	if (rc)
 		goto lpfc_sli_hba_setup_error;
 
+	/* Initialize VPIs. */
+	if (phba->sli_rev == LPFC_SLI_REV3) {
+		/*
+		 * The VPI bitmask and physical ID array are allocated
+		 * and initialized once only - at driver load.  A port
+		 * reset doesn't need to reinitialize this memory.
+		 */
+		if ((phba->vpi_bmask == NULL) && (phba->vpi_ids == NULL)) {
+			longs = (phba->max_vpi + BITS_PER_LONG) / BITS_PER_LONG;
+			phba->vpi_bmask = kzalloc(longs * sizeof(unsigned long),
+						  GFP_KERNEL);
+			if (!phba->vpi_bmask) {
+				rc = -ENOMEM;
+				goto lpfc_sli_hba_setup_error;
+			}
+
+			phba->vpi_ids = kzalloc(
+					(phba->max_vpi+1) * sizeof(uint16_t),
+					GFP_KERNEL);
+			if (!phba->vpi_ids) {
+				kfree(phba->vpi_bmask);
+				rc = -ENOMEM;
+				goto lpfc_sli_hba_setup_error;
+			}
+			for (i = 0; i < phba->max_vpi; i++)
+				phba->vpi_ids[i] = i;
+		}
+	}
+
 	/* Init HBQs */
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		rc = lpfc_sli_hbq_setup(phba);
@@ -4694,6 +4709,803 @@ lpfc_sli4_arm_cqeq_intr(struct lpfc_hba 
 }
 
 /**
+ * lpfc_sli4_get_avail_extnt_rsrc - Get available resource extent count.
+ * @phba: Pointer to HBA context object.
+ * @type: The resource extent type.
+ *
+ * This function allocates all SLI4 resource identifiers.
+ **/
+static int
+lpfc_sli4_get_avail_extnt_rsrc(struct lpfc_hba *phba, uint16_t type,
+			       uint16_t *extnt_count, uint16_t *extnt_size)
+{
+	int rc = 0;
+	uint32_t length;
+	uint32_t mbox_tmo;
+	struct lpfc_mbx_get_rsrc_extent_info *rsrc_info;
+	LPFC_MBOXQ_t *mbox;
+
+	mbox = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	/* Find out how many extents are available for this resource type */
+	length = (sizeof(struct lpfc_mbx_get_rsrc_extent_info) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO,
+			 length, LPFC_SLI4_MBX_EMBED);
+
+	/* Send an extents count of 0 - the GET doesn't use it. */
+	rc = lpfc_sli4_mbox_rsrc_extent(phba, mbox, 0, type,
+					LPFC_SLI4_MBX_EMBED);
+	if (unlikely(rc)) {
+		rc = -EIO;
+		goto err_exit;
+	}
+
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
+	if (unlikely(rc)) {
+		rc = -EIO;
+		goto err_exit;
+	}
+
+	rsrc_info = &mbox->u.mqe.un.rsrc_extent_info;
+	if (bf_get(lpfc_mbox_hdr_status,
+		   &rsrc_info->header.cfg_shdr.response)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
+				"2930 Failed to get resource extents "
+				"Status 0x%x Add'l Status 0x%x\n",
+				bf_get(lpfc_mbox_hdr_status,
+				       &rsrc_info->header.cfg_shdr.response),
+				bf_get(lpfc_mbox_hdr_add_status,
+				       &rsrc_info->header.cfg_shdr.response));
+		rc = -EIO;
+		goto err_exit;
+	}
+
+	*extnt_count = bf_get(lpfc_mbx_get_rsrc_extent_info_cnt,
+			      &rsrc_info->u.rsp);
+	*extnt_size = bf_get(lpfc_mbx_get_rsrc_extent_info_size,
+			     &rsrc_info->u.rsp);
+ err_exit:
+	mempool_free(mbox, phba->mbox_mem_pool);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_chk_avail_extnt_rsrc - Check for available SLI4 resource extents.
+ * @phba: Pointer to HBA context object.
+ * @type: The extent type to check.
+ *
+ * This function reads the current available extents from the port and checks
+ * if the extent count or extent size has changed since the last access.
+ * Callers use this routine post port reset to understand if there is a
+ * extent reprovisioning requirement.
+ *
+ * Returns:
+ *   -Error: error indicates problem.
+ *   1: Extent count or size has changed.
+ *   0: No changes.
+ **/
+static int
+lpfc_sli4_chk_avail_extnt_rsrc(struct lpfc_hba *phba, uint16_t type)
+{
+	uint16_t curr_ext_cnt, rsrc_ext_cnt;
+	uint16_t size_diff, rsrc_ext_size;
+	int rc = 0;
+	struct lpfc_rsrc_blks *rsrc_entry;
+	struct list_head *rsrc_blk_list = NULL;
+
+	size_diff = 0;
+	curr_ext_cnt = 0;
+	rc = lpfc_sli4_get_avail_extnt_rsrc(phba, type,
+					    &rsrc_ext_cnt,
+					    &rsrc_ext_size);
+	if (unlikely(rc))
+		return -EIO;
+
+	switch (type) {
+	case LPFC_RSC_TYPE_FCOE_RPI:
+		rsrc_blk_list = &phba->sli4_hba.lpfc_rpi_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_VPI:
+		rsrc_blk_list = &phba->lpfc_vpi_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_XRI:
+		rsrc_blk_list = &phba->sli4_hba.lpfc_xri_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_VFI:
+		rsrc_blk_list = &phba->sli4_hba.lpfc_vfi_blk_list;
+		break;
+	default:
+		break;
+	}
+
+	list_for_each_entry(rsrc_entry, rsrc_blk_list, list) {
+		curr_ext_cnt++;
+		if (rsrc_entry->rsrc_size != rsrc_ext_size)
+			size_diff++;
+	}
+
+	if (curr_ext_cnt != rsrc_ext_cnt || size_diff != 0)
+		rc = 1;
+
+	return rc;
+}
+
+/**
+ * lpfc_sli4_cfg_post_extnts -
+ * @phba: Pointer to HBA context object.
+ * @extnt_cnt - number of available extents.
+ * @type - the extent type (rpi, xri, vfi, vpi).
+ * @emb - buffer to hold either MBX_EMBED or MBX_NEMBED operation.
+ * @mbox - pointer to the caller's allocated mailbox structure.
+ *
+ * This function executes the extents allocation request.  It also
+ * takes care of the amount of memory needed to allocate or get the
+ * allocated extents. It is the caller's responsibility to evaluate
+ * the response.
+ *
+ * Returns:
+ *   -Error:  Error value describes the condition found.
+ *   0: if successful
+ **/
+static int
+lpfc_sli4_cfg_post_extnts(struct lpfc_hba *phba, uint16_t *extnt_cnt,
+			  uint16_t type, bool *emb, LPFC_MBOXQ_t *mbox)
+{
+	int rc = 0;
+	uint32_t req_len;
+	uint32_t emb_len;
+	uint32_t alloc_len, mbox_tmo;
+
+	/* Calculate the total requested length of the dma memory */
+	req_len = *extnt_cnt * sizeof(uint16_t);
+
+	/*
+	 * Calculate the size of an embedded mailbox.  The uint32_t
+	 * accounts for extents-specific word.
+	 */
+	emb_len = sizeof(MAILBOX_t) - sizeof(struct mbox_header) -
+		sizeof(uint32_t);
+
+	/*
+	 * Presume the allocation and response will fit into an embedded
+	 * mailbox.  If not true, reconfigure to a non-embedded mailbox.
+	 */
+	*emb = LPFC_SLI4_MBX_EMBED;
+	if (req_len > emb_len) {
+		req_len = *extnt_cnt * sizeof(uint16_t) +
+			sizeof(union lpfc_sli4_cfg_shdr) +
+			sizeof(uint32_t);
+		*emb = LPFC_SLI4_MBX_NEMBED;
+	}
+
+	alloc_len = lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+				     LPFC_MBOX_OPCODE_ALLOC_RSRC_EXTENT,
+				     req_len, *emb);
+	if (alloc_len < req_len) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"9000 Allocated DMA memory size (x%x) is "
+			"less than the requested DMA memory "
+			"size (x%x)\n", alloc_len, req_len);
+		return -ENOMEM;
+	}
+	rc = lpfc_sli4_mbox_rsrc_extent(phba, mbox, *extnt_cnt, type, *emb);
+	if (unlikely(rc))
+		return -EIO;
+
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
+
+	if (unlikely(rc))
+		rc = -EIO;
+	return rc;
+}
+
+/**
+ * lpfc_sli4_alloc_extent - Allocate an SLI4 resource extent.
+ * @phba: Pointer to HBA context object.
+ * @type:  The resource extent type to allocate.
+ *
+ * This function allocates the number of elements for the specified
+ * resource type.
+ **/
+static int
+lpfc_sli4_alloc_extent(struct lpfc_hba *phba, uint16_t type)
+{
+	bool emb = false;
+	uint16_t rsrc_id_cnt, rsrc_cnt, rsrc_size;
+	uint16_t rsrc_id, rsrc_start, j, k;
+	uint16_t *ids;
+	int i, rc;
+	unsigned long longs;
+	unsigned long *bmask;
+	struct lpfc_rsrc_blks *rsrc_blks;
+	LPFC_MBOXQ_t *mbox;
+	uint32_t length;
+	struct lpfc_id_range *id_array = NULL;
+	void *virtaddr = NULL;
+	struct lpfc_mbx_nembed_rsrc_extent *n_rsrc;
+	struct lpfc_mbx_alloc_rsrc_extents *rsrc_ext;
+	struct list_head *ext_blk_list;
+
+	rc = lpfc_sli4_get_avail_extnt_rsrc(phba, type,
+					    &rsrc_cnt,
+					    &rsrc_size);
+	if (unlikely(rc))
+		return -EIO;
+
+	if ((rsrc_cnt == 0) || (rsrc_size == 0)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
+			"3009 No available Resource Extents "
+			"for resource type 0x%x: Count: 0x%x, "
+			"Size 0x%x\n", type, rsrc_cnt,
+			rsrc_size);
+		return -ENOMEM;
+	}
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_INIT,
+			"2903 Available Resource Extents "
+			"for resource type 0x%x: Count: 0x%x, "
+			"Size 0x%x\n", type, rsrc_cnt,
+			rsrc_size);
+
+	mbox = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	rc = lpfc_sli4_cfg_post_extnts(phba, &rsrc_cnt, type, &emb, mbox);
+	if (unlikely(rc)) {
+		rc = -EIO;
+		goto err_exit;
+	}
+
+	/*
+	 * Figure out where the response is located.  Then get local pointers
+	 * to the response data.  The port does not guarantee to respond to
+	 * all extents counts request so update the local variable with the
+	 * allocated count from the port.
+	 */
+	if (emb == LPFC_SLI4_MBX_EMBED) {
+		rsrc_ext = &mbox->u.mqe.un.alloc_rsrc_extents;
+		id_array = &rsrc_ext->u.rsp.id[0];
+		rsrc_cnt = bf_get(lpfc_mbx_rsrc_cnt, &rsrc_ext->u.rsp);
+	} else {
+		virtaddr = mbox->sge_array->addr[0];
+		n_rsrc = (struct lpfc_mbx_nembed_rsrc_extent *) virtaddr;
+		rsrc_cnt = bf_get(lpfc_mbx_rsrc_cnt, n_rsrc);
+		id_array = &n_rsrc->id;
+	}
+
+	longs = ((rsrc_cnt * rsrc_size) + BITS_PER_LONG - 1) / BITS_PER_LONG;
+	rsrc_id_cnt = rsrc_cnt * rsrc_size;
+
+	/*
+	 * Based on the resource size and count, correct the base and max
+	 * resource values.
+	 */
+	length = sizeof(struct lpfc_rsrc_blks);
+	switch (type) {
+	case LPFC_RSC_TYPE_FCOE_RPI:
+		phba->sli4_hba.rpi_bmask = kzalloc(longs *
+						   sizeof(unsigned long),
+						   GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.rpi_bmask)) {
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+		phba->sli4_hba.rpi_ids = kzalloc(rsrc_id_cnt *
+						 sizeof(uint16_t),
+						 GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.rpi_ids)) {
+			kfree(phba->sli4_hba.rpi_bmask);
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+
+		/*
+		 * The next_rpi was initialized with the maximum available
+		 * count but the port may allocate a smaller number.  Catch
+		 * that case and update the next_rpi.
+		 */
+		phba->sli4_hba.next_rpi = rsrc_id_cnt;
+
+		/* Initialize local ptrs for common extent processing later. */
+		bmask = phba->sli4_hba.rpi_bmask;
+		ids = phba->sli4_hba.rpi_ids;
+		ext_blk_list = &phba->sli4_hba.lpfc_rpi_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_VPI:
+		phba->vpi_bmask = kzalloc(longs *
+					  sizeof(unsigned long),
+					  GFP_KERNEL);
+		if (unlikely(!phba->vpi_bmask)) {
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+		phba->vpi_ids = kzalloc(rsrc_id_cnt *
+					 sizeof(uint16_t),
+					 GFP_KERNEL);
+		if (unlikely(!phba->vpi_ids)) {
+			kfree(phba->vpi_bmask);
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+
+		/* Initialize local ptrs for common extent processing later. */
+		bmask = phba->vpi_bmask;
+		ids = phba->vpi_ids;
+		ext_blk_list = &phba->lpfc_vpi_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_XRI:
+		phba->sli4_hba.xri_bmask = kzalloc(longs *
+						   sizeof(unsigned long),
+						   GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.xri_bmask)) {
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+		phba->sli4_hba.xri_ids = kzalloc(rsrc_id_cnt *
+						 sizeof(uint16_t),
+						 GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.xri_ids)) {
+			kfree(phba->sli4_hba.xri_bmask);
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+
+		/* Initialize local ptrs for common extent processing later. */
+		bmask = phba->sli4_hba.xri_bmask;
+		ids = phba->sli4_hba.xri_ids;
+		ext_blk_list = &phba->sli4_hba.lpfc_xri_blk_list;
+		break;
+	case LPFC_RSC_TYPE_FCOE_VFI:
+		phba->sli4_hba.vfi_bmask = kzalloc(longs *
+						   sizeof(unsigned long),
+						   GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.vfi_bmask)) {
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+		phba->sli4_hba.vfi_ids = kzalloc(rsrc_id_cnt *
+						 sizeof(uint16_t),
+						 GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.vfi_ids)) {
+			kfree(phba->sli4_hba.vfi_bmask);
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+
+		/* Initialize local ptrs for common extent processing later. */
+		bmask = phba->sli4_hba.vfi_bmask;
+		ids = phba->sli4_hba.vfi_ids;
+		ext_blk_list = &phba->sli4_hba.lpfc_vfi_blk_list;
+		break;
+	default:
+		/* Unsupported Opcode.  Fail call. */
+		id_array = NULL;
+		bmask = NULL;
+		ids = NULL;
+		ext_blk_list = NULL;
+		goto err_exit;
+	}
+
+	/*
+	 * Complete initializing the extent configuration with the
+	 * allocated ids assigned to this function.  The bitmask serves
+	 * as an index into the array and manages the available ids.  The
+	 * array just stores the ids communicated to the port via the wqes.
+	 */
+	for (i = 0, j = 0, k = 0; i < rsrc_cnt; i++) {
+		if ((i % 2) == 0)
+			rsrc_id = bf_get(lpfc_mbx_rsrc_id_word4_0,
+					 &id_array[k]);
+		else
+			rsrc_id = bf_get(lpfc_mbx_rsrc_id_word4_1,
+					 &id_array[k]);
+
+		rsrc_blks = kzalloc(length, GFP_KERNEL);
+		if (unlikely(!rsrc_blks)) {
+			rc = -ENOMEM;
+			kfree(bmask);
+			kfree(ids);
+			goto err_exit;
+		}
+		rsrc_blks->rsrc_start = rsrc_id;
+		rsrc_blks->rsrc_size = rsrc_size;
+		list_add_tail(&rsrc_blks->list, ext_blk_list);
+		rsrc_start = rsrc_id;
+		if ((type == LPFC_RSC_TYPE_FCOE_XRI) && (j == 0))
+			phba->sli4_hba.scsi_xri_start = rsrc_start +
+				lpfc_sli4_get_els_iocb_cnt(phba);
+
+		while (rsrc_id < (rsrc_start + rsrc_size)) {
+			ids[j] = rsrc_id;
+			rsrc_id++;
+			j++;
+		}
+		/* Entire word processed.  Get next word.*/
+		if ((i % 2) == 1)
+			k++;
+	}
+ err_exit:
+	lpfc_sli4_mbox_cmd_free(phba, mbox);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_dealloc_extent - Deallocate an SLI4 resource extent.
+ * @phba: Pointer to HBA context object.
+ * @type: the extent's type.
+ *
+ * This function deallocates all extents of a particular resource type.
+ * SLI4 does not allow for deallocating a particular extent range.  It
+ * is the caller's responsibility to release all kernel memory resources.
+ **/
+static int
+lpfc_sli4_dealloc_extent(struct lpfc_hba *phba, uint16_t type)
+{
+	int rc;
+	uint32_t length, mbox_tmo = 0;
+	LPFC_MBOXQ_t *mbox;
+	struct lpfc_mbx_dealloc_rsrc_extents *dealloc_rsrc;
+	struct lpfc_rsrc_blks *rsrc_blk, *rsrc_blk_next;
+
+	mbox = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	/*
+	 * This function sends an embedded mailbox because it only sends the
+	 * the resource type.  All extents of this type are released by the
+	 * port.
+	 */
+	length = (sizeof(struct lpfc_mbx_dealloc_rsrc_extents) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_DEALLOC_RSRC_EXTENT,
+			 length, LPFC_SLI4_MBX_EMBED);
+
+	/* Send an extents count of 0 - the dealloc doesn't use it. */
+	rc = lpfc_sli4_mbox_rsrc_extent(phba, mbox, 0, type,
+					LPFC_SLI4_MBX_EMBED);
+	if (unlikely(rc)) {
+		rc = -EIO;
+		goto out_free_mbox;
+	}
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox_tmo);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
+	if (unlikely(rc)) {
+		rc = -EIO;
+		goto out_free_mbox;
+	}
+
+	dealloc_rsrc = &mbox->u.mqe.un.dealloc_rsrc_extents;
+	if (bf_get(lpfc_mbox_hdr_status,
+		   &dealloc_rsrc->header.cfg_shdr.response)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
+				"2919 Failed to release resource extents "
+				"for type %d - Status 0x%x Add'l Status 0x%x. "
+				"Resource memory not released.\n",
+				type,
+				bf_get(lpfc_mbox_hdr_status,
+				    &dealloc_rsrc->header.cfg_shdr.response),
+				bf_get(lpfc_mbox_hdr_add_status,
+				    &dealloc_rsrc->header.cfg_shdr.response));
+		rc = -EIO;
+		goto out_free_mbox;
+	}
+
+	/* Release kernel memory resources for the specific type. */
+	switch (type) {
+	case LPFC_RSC_TYPE_FCOE_VPI:
+		kfree(phba->vpi_bmask);
+		kfree(phba->vpi_ids);
+		bf_set(lpfc_vpi_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
+		list_for_each_entry_safe(rsrc_blk, rsrc_blk_next,
+				    &phba->lpfc_vpi_blk_list, list) {
+			list_del_init(&rsrc_blk->list);
+			kfree(rsrc_blk);
+		}
+		break;
+	case LPFC_RSC_TYPE_FCOE_XRI:
+		kfree(phba->sli4_hba.xri_bmask);
+		kfree(phba->sli4_hba.xri_ids);
+		bf_set(lpfc_xri_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
+		list_for_each_entry_safe(rsrc_blk, rsrc_blk_next,
+				    &phba->sli4_hba.lpfc_xri_blk_list, list) {
+			list_del_init(&rsrc_blk->list);
+			kfree(rsrc_blk);
+		}
+		break;
+	case LPFC_RSC_TYPE_FCOE_VFI:
+		kfree(phba->sli4_hba.vfi_bmask);
+		kfree(phba->sli4_hba.vfi_ids);
+		bf_set(lpfc_vfi_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
+		list_for_each_entry_safe(rsrc_blk, rsrc_blk_next,
+				    &phba->sli4_hba.lpfc_vfi_blk_list, list) {
+			list_del_init(&rsrc_blk->list);
+			kfree(rsrc_blk);
+		}
+		break;
+	case LPFC_RSC_TYPE_FCOE_RPI:
+		/* RPI bitmask and physical id array are cleaned up earlier. */
+		list_for_each_entry_safe(rsrc_blk, rsrc_blk_next,
+				    &phba->sli4_hba.lpfc_rpi_blk_list, list) {
+			list_del_init(&rsrc_blk->list);
+			kfree(rsrc_blk);
+		}
+		break;
+	default:
+		break;
+	}
+
+	bf_set(lpfc_idx_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
+
+ out_free_mbox:
+	mempool_free(mbox, phba->mbox_mem_pool);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_alloc_resource_identifiers - Allocate all SLI4 resource extents.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function allocates all SLI4 resource identifiers.
+ **/
+int
+lpfc_sli4_alloc_resource_identifiers(struct lpfc_hba *phba)
+{
+	int i, rc, error = 0;
+	uint16_t count, base;
+	unsigned long longs;
+
+	if (phba->sli4_hba.extents_in_use) {
+		/*
+		 * The port supports resource extents. The XRI, VPI, VFI, RPI
+		 * resource extent count must be read and allocated before
+		 * provisioning the resource id arrays.
+		 */
+		if (bf_get(lpfc_idx_rsrc_rdy, &phba->sli4_hba.sli4_flags) ==
+		    LPFC_IDX_RSRC_RDY) {
+			/*
+			 * Extent-based resources are set - the driver could
+			 * be in a port reset. Figure out if any corrective
+			 * actions need to be taken.
+			 */
+			rc = lpfc_sli4_chk_avail_extnt_rsrc(phba,
+						 LPFC_RSC_TYPE_FCOE_VFI);
+			if (rc != 0)
+				error++;
+			rc = lpfc_sli4_chk_avail_extnt_rsrc(phba,
+						 LPFC_RSC_TYPE_FCOE_VPI);
+			if (rc != 0)
+				error++;
+			rc = lpfc_sli4_chk_avail_extnt_rsrc(phba,
+						 LPFC_RSC_TYPE_FCOE_XRI);
+			if (rc != 0)
+				error++;
+			rc = lpfc_sli4_chk_avail_extnt_rsrc(phba,
+						 LPFC_RSC_TYPE_FCOE_RPI);
+			if (rc != 0)
+				error++;
+
+			/*
+			 * It's possible that the number of resources
+			 * provided to this port instance changed between
+			 * resets.  Detect this condition and reallocate
+			 * resources.  Otherwise, there is no action.
+			 */
+			if (error) {
+				lpfc_printf_log(phba, KERN_INFO,
+						LOG_MBOX | LOG_INIT,
+						"2931 Detected extent resource "
+						"change.  Reallocating all "
+						"extents.\n");
+				rc = lpfc_sli4_dealloc_extent(phba,
+						 LPFC_RSC_TYPE_FCOE_VFI);
+				rc = lpfc_sli4_dealloc_extent(phba,
+						 LPFC_RSC_TYPE_FCOE_VPI);
+				rc = lpfc_sli4_dealloc_extent(phba,
+						 LPFC_RSC_TYPE_FCOE_XRI);
+				rc = lpfc_sli4_dealloc_extent(phba,
+						 LPFC_RSC_TYPE_FCOE_RPI);
+			} else
+				return 0;
+		}
+
+		rc = lpfc_sli4_alloc_extent(phba, LPFC_RSC_TYPE_FCOE_VFI);
+		if (unlikely(rc))
+			goto err_exit;
+
+		rc = lpfc_sli4_alloc_extent(phba, LPFC_RSC_TYPE_FCOE_VPI);
+		if (unlikely(rc))
+			goto err_exit;
+
+		rc = lpfc_sli4_alloc_extent(phba, LPFC_RSC_TYPE_FCOE_RPI);
+		if (unlikely(rc))
+			goto err_exit;
+
+		rc = lpfc_sli4_alloc_extent(phba, LPFC_RSC_TYPE_FCOE_XRI);
+		if (unlikely(rc))
+			goto err_exit;
+		bf_set(lpfc_idx_rsrc_rdy, &phba->sli4_hba.sli4_flags,
+		       LPFC_IDX_RSRC_RDY);
+		return rc;
+	} else {
+		/*
+		 * The port does not support resource extents.  The XRI, VPI,
+		 * VFI, RPI resource ids were determined from READ_CONFIG.
+		 * Just allocate the bitmasks and provision the resource id
+		 * arrays.  If a port reset is active, the resources don't
+		 * need any action - just exit.
+		 */
+		if (bf_get(lpfc_idx_rsrc_rdy, &phba->sli4_hba.sli4_flags) ==
+		    LPFC_IDX_RSRC_RDY)
+			return 0;
+
+		/* RPIs. */
+		count = phba->sli4_hba.max_cfg_param.max_rpi;
+		base = phba->sli4_hba.max_cfg_param.rpi_base;
+		longs = (count + BITS_PER_LONG - 1) / BITS_PER_LONG;
+		phba->sli4_hba.rpi_bmask = kzalloc(longs *
+						   sizeof(unsigned long),
+						   GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.rpi_bmask)) {
+			rc = -ENOMEM;
+			goto err_exit;
+		}
+		phba->sli4_hba.rpi_ids = kzalloc(count *
+						 sizeof(uint16_t),
+						 GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.rpi_ids)) {
+			rc = -ENOMEM;
+			goto free_rpi_bmask;
+		}
+
+		for (i = 0; i < count; i++)
+			phba->sli4_hba.rpi_ids[i] = base + i;
+
+		/* VPIs. */
+		count = phba->sli4_hba.max_cfg_param.max_vpi;
+		base = phba->sli4_hba.max_cfg_param.vpi_base;
+		longs = (count + BITS_PER_LONG - 1) / BITS_PER_LONG;
+		phba->vpi_bmask = kzalloc(longs *
+					  sizeof(unsigned long),
+					  GFP_KERNEL);
+		if (unlikely(!phba->vpi_bmask)) {
+			rc = -ENOMEM;
+			goto free_rpi_ids;
+		}
+		phba->vpi_ids = kzalloc(count *
+					sizeof(uint16_t),
+					GFP_KERNEL);
+		if (unlikely(!phba->vpi_ids)) {
+			rc = -ENOMEM;
+			goto free_vpi_bmask;
+		}
+
+		for (i = 0; i < count; i++)
+			phba->vpi_ids[i] = base + i;
+
+		/* XRIs. */
+		count = phba->sli4_hba.max_cfg_param.max_xri;
+		base = phba->sli4_hba.max_cfg_param.xri_base;
+		longs = (count + BITS_PER_LONG - 1) / BITS_PER_LONG;
+		phba->sli4_hba.xri_bmask = kzalloc(longs *
+						   sizeof(unsigned long),
+						   GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.xri_bmask)) {
+			rc = -ENOMEM;
+			goto free_vpi_ids;
+		}
+		phba->sli4_hba.xri_ids = kzalloc(count *
+						 sizeof(uint16_t),
+						 GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.xri_ids)) {
+			rc = -ENOMEM;
+			goto free_xri_bmask;
+		}
+
+		for (i = 0; i < count; i++)
+			phba->sli4_hba.xri_ids[i] = base + i;
+
+		/* VFIs. */
+		count = phba->sli4_hba.max_cfg_param.max_vfi;
+		base = phba->sli4_hba.max_cfg_param.vfi_base;
+		longs = (count + BITS_PER_LONG - 1) / BITS_PER_LONG;
+		phba->sli4_hba.vfi_bmask = kzalloc(longs *
+						   sizeof(unsigned long),
+						   GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.vfi_bmask)) {
+			rc = -ENOMEM;
+			goto free_xri_ids;
+		}
+		phba->sli4_hba.vfi_ids = kzalloc(count *
+						 sizeof(uint16_t),
+						 GFP_KERNEL);
+		if (unlikely(!phba->sli4_hba.vfi_ids)) {
+			rc = -ENOMEM;
+			goto free_vfi_bmask;
+		}
+
+		for (i = 0; i < count; i++)
+			phba->sli4_hba.vfi_ids[i] = base + i;
+
+		/*
+		 * Mark all resources ready.  An HBA reset doesn't need
+		 * to reset the initialization.
+		 */
+		bf_set(lpfc_idx_rsrc_rdy, &phba->sli4_hba.sli4_flags,
+		       LPFC_IDX_RSRC_RDY);
+		return 0;
+	}
+
+ free_vfi_bmask:
+	kfree(phba->sli4_hba.vfi_bmask);
+ free_xri_ids:
+	kfree(phba->sli4_hba.xri_ids);
+ free_xri_bmask:
+	kfree(phba->sli4_hba.xri_bmask);
+ free_vpi_ids:
+	kfree(phba->vpi_ids);
+ free_vpi_bmask:
+	kfree(phba->vpi_bmask);
+ free_rpi_ids:
+	kfree(phba->sli4_hba.rpi_ids);
+ free_rpi_bmask:
+	kfree(phba->sli4_hba.rpi_bmask);
+ err_exit:
+	return rc;
+}
+
+/**
+ * lpfc_sli4_dealloc_resource_identifiers - Deallocate all SLI4 resource extents.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function allocates the number of elements for the specified
+ * resource type.
+ **/
+int
+lpfc_sli4_dealloc_resource_identifiers(struct lpfc_hba *phba)
+{
+	if (phba->sli4_hba.extents_in_use) {
+		lpfc_sli4_dealloc_extent(phba, LPFC_RSC_TYPE_FCOE_VPI);
+		lpfc_sli4_dealloc_extent(phba, LPFC_RSC_TYPE_FCOE_RPI);
+		lpfc_sli4_dealloc_extent(phba, LPFC_RSC_TYPE_FCOE_XRI);
+		lpfc_sli4_dealloc_extent(phba, LPFC_RSC_TYPE_FCOE_VFI);
+	} else {
+		kfree(phba->vpi_bmask);
+		kfree(phba->vpi_ids);
+		bf_set(lpfc_vpi_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
+		kfree(phba->sli4_hba.xri_bmask);
+		kfree(phba->sli4_hba.xri_ids);
+		bf_set(lpfc_xri_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
+		kfree(phba->sli4_hba.vfi_bmask);
+		kfree(phba->sli4_hba.vfi_ids);
+		bf_set(lpfc_vfi_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
+		bf_set(lpfc_idx_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
+	}
+
+	return 0;
+}
+
+/**
  * lpfc_sli4_hba_setup - SLI4 device intialization PCI function
  * @phba: Pointer to HBA context object.
  *
@@ -4715,10 +5527,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_dmabuf *mp;
 
-	/*
-	 * TODO:  Why does this routine execute these task in a different
-	 * order from probe?
-	 */
 	/* Perform a PCI function reset to start from clean */
 	rc = lpfc_pci_function_reset(phba);
 	if (unlikely(rc))
@@ -4880,6 +5688,18 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	phba->sli3_options |= (LPFC_SLI3_NPIV_ENABLED | LPFC_SLI3_HBQ_ENABLED);
 	spin_unlock_irq(&phba->hbalock);
 
+	/*
+	 * Allocate all resources (xri,rpi,vpi,vfi) now.  Subsequent
+	 * calls depends on these resources to complete port setup.
+	 */
+	rc = lpfc_sli4_alloc_resource_identifiers(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"2920 Failed to alloc Resource IDs "
+				"rc = x%x\n", rc);
+		goto out_free_mbox;
+	}
+
 	/* Read the port's service parameters. */
 	rc = lpfc_read_sparam(phba, mboxq, vport->vpi);
 	if (rc) {
@@ -4919,20 +5739,31 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
 	fc_host_port_name(shost) = wwn_to_u64(vport->fc_portname.u.wwn);
 
-	/* Register SGL pool to the device using non-embedded mailbox command */
-	rc = lpfc_sli4_post_sgl_list(phba);
-	if (unlikely(rc)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"0582 Error %d during sgl post operation\n",
-					rc);
-		rc = -ENODEV;
-		goto out_free_mbox;
+	/* Register SGL pool to the device using non-embedded mailbox command */
+	if (!phba->sli4_hba.extents_in_use) {
+		rc = lpfc_sli4_post_els_sgl_list(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"0582 Error %d during els sgl post "
+					"operation\n", rc);
+			rc = -ENODEV;
+			goto out_free_mbox;
+		}
+	} else {
+		rc = lpfc_sli4_post_els_sgl_list_ext(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"2560 Error %d during els sgl post "
+					"operation\n", rc);
+			rc = -ENODEV;
+			goto out_free_mbox;
+		}
 	}
 
 	/* Register SCSI SGL pool to the device */
 	rc = lpfc_sli4_repost_scsi_sgl_list(phba);
 	if (unlikely(rc)) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 				"0383 Error %d during scsi sgl post "
 				"operation\n", rc);
 		/* Some Scsi buffers were moved to the abort scsi list */
@@ -6479,7 +7310,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 			els_id = ((iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK)
 					>> LPFC_FIP_ELS_ID_SHIFT);
 		}
-		bf_set(wqe_temp_rpi, &wqe->els_req.wqe_com, ndlp->nlp_rpi);
+		bf_set(wqe_temp_rpi, &wqe->els_req.wqe_com,
+		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
 		bf_set(wqe_els_id, &wqe->els_req.wqe_com, els_id);
 		bf_set(wqe_dbde, &wqe->els_req.wqe_com, 1);
 		bf_set(wqe_iod, &wqe->els_req.wqe_com, LPFC_WQE_IOD_READ);
@@ -6628,14 +7460,15 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		       iocbq->iocb.ulpContext);
 		if (!iocbq->iocb.ulpCt_h && iocbq->iocb.ulpCt_l)
 			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
-			       iocbq->vport->vpi + phba->vpi_base);
+			       phba->vpi_ids[iocbq->vport->vpi]);
 		bf_set(wqe_dbde, &wqe->xmit_els_rsp.wqe_com, 1);
 		bf_set(wqe_iod, &wqe->xmit_els_rsp.wqe_com, LPFC_WQE_IOD_WRITE);
 		bf_set(wqe_qosd, &wqe->xmit_els_rsp.wqe_com, 1);
 		bf_set(wqe_lenloc, &wqe->xmit_els_rsp.wqe_com,
 		       LPFC_WQE_LENLOC_WORD3);
 		bf_set(wqe_ebde_cnt, &wqe->xmit_els_rsp.wqe_com, 0);
-		bf_set(wqe_rsp_temp_rpi, &wqe->xmit_els_rsp, ndlp->nlp_rpi);
+		bf_set(wqe_rsp_temp_rpi, &wqe->xmit_els_rsp,
+		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
 		command_type = OTHER_COMMAND;
 	break;
 	case CMD_CLOSE_XRI_CN:
@@ -6734,6 +7567,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		return IOCB_ERROR;
 	break;
 	}
+
 	bf_set(wqe_xri_tag, &wqe->generic.wqe_com, xritag);
 	bf_set(wqe_reqtag, &wqe->generic.wqe_com, iocbq->iotag);
 	wqe->generic.wqe_com.abort_tag = abort_tag;
@@ -6781,7 +7615,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 					return IOCB_BUSY;
 				}
 			} else {
-			sglq = __lpfc_sli_get_sglq(phba, piocb);
+				sglq = __lpfc_sli_get_sglq(phba, piocb);
 				if (!sglq) {
 					if (!(flag & SLI_IOCB_RET_IOCB)) {
 						__lpfc_sli_ringtx_put(phba,
@@ -6794,11 +7628,11 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 			}
 		}
 	} else if (piocb->iocb_flag &  LPFC_IO_FCP) {
-		sglq = NULL; /* These IO's already have an XRI and
-			      * a mapped sgl.
-			      */
+		/* These IO's already have an XRI and a mapped sgl. */
+		sglq = NULL;
 	} else {
-		/* This is a continuation of a commandi,(CX) so this
+		/*
+		 * This is a continuation of a commandi,(CX) so this
 		 * sglq is on the active list
 		 */
 		sglq = __lpfc_get_active_sglq(phba, piocb->sli4_xritag);
@@ -6807,8 +7641,8 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 	}
 
 	if (sglq) {
+		piocb->sli4_lxritag = sglq->sli4_lxritag;
 		piocb->sli4_xritag = sglq->sli4_xritag;
-
 		if (NO_XRI == lpfc_sli4_bpl2sgl(phba, piocb, sglq))
 			return IOCB_ERROR;
 	}
@@ -11456,6 +12290,7 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba
 	LPFC_MBOXQ_t *mbox;
 	int rc;
 	uint32_t shdr_status, shdr_add_status;
+	uint32_t mbox_tmo;
 	union lpfc_sli4_cfg_shdr *shdr;
 
 	if (xritag == NO_XRI) {
@@ -11489,8 +12324,10 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba
 				cpu_to_le32(putPaddrHigh(pdma_phys_addr1));
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
 	/* The IOCTL status is embedded in the mailbox subheader. */
 	shdr = (union lpfc_sli4_cfg_shdr *) &post_sgl_pages->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
@@ -11508,6 +12345,76 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba
 }
 
 /**
+ * lpfc_sli4_init_rpi_hdrs - Post the rpi header memory region to the port
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to post rpi header templates to the
+ * port for those SLI4 ports that do not support extents.  This routine
+ * posts a PAGE_SIZE memory region to the port to hold up to
+ * PAGE_SIZE modulo 64 rpi context headers.  This is an initialization routine
+ * and should be called only when interrupts are disabled.
+ *
+ * Return codes
+ * 	0 - successful
+ * 	-ERROR - otherwise.
+ **/
+uint16_t
+lpfc_sli4_alloc_xri(struct lpfc_hba *phba)
+{
+	unsigned long xri;
+
+	/*
+	 * Fetch the next logical xri.  Because this index is logical,
+	 * the driver starts at 0 each time.
+	 */
+	spin_lock_irq(&phba->hbalock);
+	xri = find_next_zero_bit(phba->sli4_hba.xri_bmask,
+				 phba->sli4_hba.max_cfg_param.max_xri, 0);
+	if (xri >= phba->sli4_hba.max_cfg_param.max_xri) {
+		spin_unlock_irq(&phba->hbalock);
+		return NO_XRI;
+	} else {
+		set_bit(xri, phba->sli4_hba.xri_bmask);
+		phba->sli4_hba.max_cfg_param.xri_used++;
+		phba->sli4_hba.xri_count++;
+	}
+
+	spin_unlock_irq(&phba->hbalock);
+	return xri;
+}
+
+/**
+ * lpfc_sli4_free_xri - Release an xri for reuse.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release an xri to the pool of
+ * available rpis maintained by the driver.
+ **/
+void
+__lpfc_sli4_free_xri(struct lpfc_hba *phba, int xri)
+{
+	if (test_and_clear_bit(xri, phba->sli4_hba.xri_bmask)) {
+		phba->sli4_hba.xri_count--;
+		phba->sli4_hba.max_cfg_param.xri_used--;
+	}
+}
+
+/**
+ * lpfc_sli4_free_xri - Release an xri for reuse.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release an xri to the pool of
+ * available rpis maintained by the driver.
+ **/
+void
+lpfc_sli4_free_xri(struct lpfc_hba *phba, int xri)
+{
+	spin_lock_irq(&phba->hbalock);
+	__lpfc_sli4_free_xri(phba, xri);
+	spin_unlock_irq(&phba->hbalock);
+}
+
+/**
  * lpfc_sli4_next_xritag - Get an xritag for the io
  * @phba: Pointer to HBA context object.
  *
@@ -11520,30 +12427,23 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba
 uint16_t
 lpfc_sli4_next_xritag(struct lpfc_hba *phba)
 {
-	uint16_t xritag;
+	uint16_t xri_index;
 
-	spin_lock_irq(&phba->hbalock);
-	xritag = phba->sli4_hba.next_xri;
-	if ((xritag != (uint16_t) -1) && xritag <
-		(phba->sli4_hba.max_cfg_param.max_xri
-			+ phba->sli4_hba.max_cfg_param.xri_base)) {
-		phba->sli4_hba.next_xri++;
-		phba->sli4_hba.max_cfg_param.xri_used++;
-		spin_unlock_irq(&phba->hbalock);
-		return xritag;
-	}
-	spin_unlock_irq(&phba->hbalock);
-	lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+	xri_index = lpfc_sli4_alloc_xri(phba);
+	if (xri_index != NO_XRI)
+		return xri_index;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"2004 Failed to allocate XRI.last XRITAG is %d"
 			" Max XRI is %d, Used XRI is %d\n",
-			phba->sli4_hba.next_xri,
+			xri_index,
 			phba->sli4_hba.max_cfg_param.max_xri,
 			phba->sli4_hba.max_cfg_param.xri_used);
-	return -1;
+	return NO_XRI;
 }
 
 /**
- * lpfc_sli4_post_sgl_list - post a block of sgl list to the firmware.
+ * lpfc_sli4_post_els_sgl_list - post a block of ELS sgls to the port.
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to post a block of driver's sgl pages to the
@@ -11552,7 +12452,7 @@ lpfc_sli4_next_xritag(struct lpfc_hba *p
  * stopped.
  **/
 int
-lpfc_sli4_post_sgl_list(struct lpfc_hba *phba)
+lpfc_sli4_post_els_sgl_list(struct lpfc_hba *phba)
 {
 	struct lpfc_sglq *sglq_entry;
 	struct lpfc_mbx_post_uembed_sgl_page1 *sgl;
@@ -11561,7 +12461,7 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba 
 	LPFC_MBOXQ_t *mbox;
 	uint32_t reqlen, alloclen, pg_pairs;
 	uint32_t mbox_tmo;
-	uint16_t xritag_start = 0;
+	uint16_t xritag_start = 0, lxri = 0;
 	int els_xri_cnt, rc = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
@@ -11578,11 +12478,8 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba 
 		return -ENOMEM;
 	}
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2560 Failed to allocate mbox cmd memory\n");
+	if (!mbox)
 		return -ENOMEM;
-	}
 
 	/* Allocate DMA memory and set up the non-embedded mailbox command */
 	alloclen = lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -11597,15 +12494,30 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba 
 		lpfc_sli4_mbox_cmd_free(phba, mbox);
 		return -ENOMEM;
 	}
-	/* Get the first SGE entry from the non-embedded DMA memory */
-	viraddr = mbox->sge_array->addr[0];
-
 	/* Set up the SGL pages in the non-embedded DMA pages */
+	viraddr = mbox->sge_array->addr[0];
 	sgl = (struct lpfc_mbx_post_uembed_sgl_page1 *)viraddr;
 	sgl_pg_pairs = &sgl->sgl_pg_pairs;
 
 	for (pg_pairs = 0; pg_pairs < els_xri_cnt; pg_pairs++) {
 		sglq_entry = phba->sli4_hba.lpfc_els_sgl_array[pg_pairs];
+
+		/*
+		 * Assign the sglq a physical xri only if the driver has not
+		 * initialized those resources.  A port reset only needs
+		 * the sglq's posted.
+		 */
+		if (bf_get(lpfc_xri_rsrc_rdy, &phba->sli4_hba.sli4_flags) !=
+		    LPFC_XRI_RSRC_RDY) {
+			lxri = lpfc_sli4_next_xritag(phba);
+			if (lxri == NO_XRI) {
+				lpfc_sli4_mbox_cmd_free(phba, mbox);
+				return -ENOMEM;
+			}
+			sglq_entry->sli4_lxritag = lxri;
+			sglq_entry->sli4_xritag = phba->sli4_hba.xri_ids[lxri];
+		}
+
 		/* Set up the sge entry */
 		sgl_pg_pairs->sgl_pg0_addr_lo =
 				cpu_to_le32(putPaddrLow(sglq_entry->phys));
@@ -11615,16 +12527,17 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba 
 				cpu_to_le32(putPaddrLow(0));
 		sgl_pg_pairs->sgl_pg1_addr_hi =
 				cpu_to_le32(putPaddrHigh(0));
+
 		/* Keep the first xritag on the list */
 		if (pg_pairs == 0)
 			xritag_start = sglq_entry->sli4_xritag;
 		sgl_pg_pairs++;
 	}
+
+	/* Complete initialization and perform endian conversion. */
 	bf_set(lpfc_post_sgl_pages_xri, sgl, xritag_start);
 	bf_set(lpfc_post_sgl_pages_xricnt, sgl, els_xri_cnt);
-	/* Perform endian conversion if necessary */
 	sgl->word0 = cpu_to_le32(sgl->word0);
-
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
@@ -11643,6 +12556,181 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba 
 				shdr_status, shdr_add_status, rc);
 		rc = -ENXIO;
 	}
+
+	if (rc == 0)
+		bf_set(lpfc_xri_rsrc_rdy, &phba->sli4_hba.sli4_flags,
+		       LPFC_XRI_RSRC_RDY);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_post_els_sgl_list_ext - post a block of ELS sgls to the port.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to post a block of driver's sgl pages to the
+ * HBA using non-embedded mailbox command. No Lock is held. This routine
+ * is only called when the driver is loading and after all IO has been
+ * stopped.
+ **/
+int
+lpfc_sli4_post_els_sgl_list_ext(struct lpfc_hba *phba)
+{
+	struct lpfc_sglq *sglq_entry;
+	struct lpfc_mbx_post_uembed_sgl_page1 *sgl;
+	struct sgl_page_pairs *sgl_pg_pairs;
+	void *viraddr;
+	LPFC_MBOXQ_t *mbox;
+	uint32_t reqlen, alloclen, index;
+	uint32_t mbox_tmo;
+	uint16_t rsrc_start, rsrc_size, els_xri_cnt;
+	uint16_t xritag_start = 0, lxri = 0;
+	struct lpfc_rsrc_blks *rsrc_blk;
+	int cnt, ttl_cnt, rc = 0;
+	int loop_cnt;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	/* The number of sgls to be posted */
+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
+
+	reqlen = els_xri_cnt * sizeof(struct sgl_page_pairs) +
+		 sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
+	if (reqlen > SLI4_PAGE_SIZE) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2989 Block sgl registration required DMA "
+				"size (%d) great than a page\n", reqlen);
+		return -ENOMEM;
+	}
+
+	cnt = 0;
+	ttl_cnt = 0;
+	list_for_each_entry(rsrc_blk, &phba->sli4_hba.lpfc_xri_blk_list,
+			    list) {
+		rsrc_start = rsrc_blk->rsrc_start;
+		rsrc_size = rsrc_blk->rsrc_size;
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"3014 Working ELS Extent start %d, cnt %d\n",
+				rsrc_start, rsrc_size);
+
+		loop_cnt=min(els_xri_cnt, rsrc_size);
+		if (ttl_cnt + loop_cnt >= els_xri_cnt) {
+			loop_cnt = els_xri_cnt - ttl_cnt;
+			ttl_cnt = els_xri_cnt;
+		}
+
+		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!mbox)
+			return -ENOMEM;
+		/*
+		 * Allocate DMA memory and set up the non-embedded mailbox
+		 * command.
+		 */
+		alloclen = lpfc_sli4_config(phba, mbox,
+					LPFC_MBOX_SUBSYSTEM_FCOE,
+					LPFC_MBOX_OPCODE_FCOE_POST_SGL_PAGES,
+					reqlen, LPFC_SLI4_MBX_NEMBED);
+		if (alloclen < reqlen) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2987 Allocated DMA memory size (%d) "
+					"is less than the requested DMA memory "
+					"size (%d)\n", alloclen, reqlen);
+			lpfc_sli4_mbox_cmd_free(phba, mbox);
+			return -ENOMEM;
+		}
+
+		/* Set up the SGL pages in the non-embedded DMA pages */
+		viraddr = mbox->sge_array->addr[0];
+		sgl = (struct lpfc_mbx_post_uembed_sgl_page1 *)viraddr;
+		sgl_pg_pairs = &sgl->sgl_pg_pairs;
+
+		/*
+		 * The starting resource may not begin at zero. Control
+		 * the loop variants via the block resource parameters,
+		 * but handle the sge pointers with a zero-based index
+		 * that doesn't get reset per loop pass.
+		 */
+		for (index = rsrc_start;
+		     index < rsrc_start + loop_cnt;
+		     index++) {
+			sglq_entry = phba->sli4_hba.lpfc_els_sgl_array[cnt];
+
+			/*
+			 * Assign the sglq a physical xri only if the driver
+			 * has not initialized those resources.  A port reset
+			 * only needs the sglq's posted.
+			 */
+			if (bf_get(lpfc_xri_rsrc_rdy,
+				   &phba->sli4_hba.sli4_flags) !=
+				   LPFC_XRI_RSRC_RDY) {
+				lxri = lpfc_sli4_next_xritag(phba);
+				if (lxri == NO_XRI) {
+					lpfc_sli4_mbox_cmd_free(phba, mbox);
+					rc = -ENOMEM;
+					goto err_exit;
+				}
+				sglq_entry->sli4_lxritag = lxri;
+				sglq_entry->sli4_xritag =
+						phba->sli4_hba.xri_ids[lxri];
+			}
+
+			/* Set up the sge entry */
+			sgl_pg_pairs->sgl_pg0_addr_lo =
+				cpu_to_le32(putPaddrLow(sglq_entry->phys));
+			sgl_pg_pairs->sgl_pg0_addr_hi =
+				cpu_to_le32(putPaddrHigh(sglq_entry->phys));
+			sgl_pg_pairs->sgl_pg1_addr_lo =
+				cpu_to_le32(putPaddrLow(0));
+			sgl_pg_pairs->sgl_pg1_addr_hi =
+				cpu_to_le32(putPaddrHigh(0));
+
+			/* Track the starting physical XRI for the mailbox. */
+			if (index == rsrc_start)
+				xritag_start = sglq_entry->sli4_xritag;
+			sgl_pg_pairs++;
+			cnt++;
+		}
+
+		/* Complete initialization and perform endian conversion. */
+		rsrc_blk->rsrc_used += loop_cnt;
+		bf_set(lpfc_post_sgl_pages_xri, sgl, xritag_start);
+		bf_set(lpfc_post_sgl_pages_xricnt, sgl, loop_cnt);
+		sgl->word0 = cpu_to_le32(sgl->word0);
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"3015 Post ELS Extent SGL, start %d, "
+				"cnt %d, used %d\n",
+				xritag_start, loop_cnt, rsrc_blk->rsrc_used);
+		if (!phba->sli4_hba.intr_enable)
+			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+		else {
+			mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+			rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+		}
+		shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
+		shdr_status = bf_get(lpfc_mbox_hdr_status,
+				     &shdr->response);
+		shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+					 &shdr->response);
+		if (rc != MBX_TIMEOUT)
+			lpfc_sli4_mbox_cmd_free(phba, mbox);
+		if (shdr_status || shdr_add_status || rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"2988 POST_SGL_BLOCK mailbox "
+					"command failed status x%x "
+					"add_status x%x mbx status x%x\n",
+					shdr_status, shdr_add_status, rc);
+			rc = -ENXIO;
+			goto err_exit;
+		}
+		if (ttl_cnt >= els_xri_cnt)
+			break;
+	}
+
+ err_exit:
+	if (rc == 0)
+		bf_set(lpfc_xri_rsrc_rdy, &phba->sli4_hba.sli4_flags,
+		       LPFC_XRI_RSRC_RDY);
 	return rc;
 }
 
@@ -11703,6 +12791,7 @@ lpfc_sli4_post_scsi_sgl_block(struct lpf
 		lpfc_sli4_mbox_cmd_free(phba, mbox);
 		return -ENOMEM;
 	}
+
 	/* Get the first SGE entry from the non-embedded DMA memory */
 	viraddr = mbox->sge_array->addr[0];
 
@@ -11758,6 +12847,169 @@ lpfc_sli4_post_scsi_sgl_block(struct lpf
 }
 
 /**
+ * lpfc_sli4_post_scsi_sgl_blk_ext - post a block of scsi sgls to the port.
+ * @phba: pointer to lpfc hba data structure.
+ * @sblist: pointer to scsi buffer list.
+ * @count: number of scsi buffers on the list.
+ *
+ * This routine is invoked to post a block of @count scsi sgl pages from a
+ * SCSI buffer list @sblist to the HBA using non-embedded mailbox command.
+ * No Lock is held.
+ *
+ **/
+int
+lpfc_sli4_post_scsi_sgl_blk_ext(struct lpfc_hba *phba, struct list_head *sblist,
+				int cnt)
+{
+	struct lpfc_scsi_buf *psb = NULL;
+	struct lpfc_mbx_post_uembed_sgl_page1 *sgl;
+	struct sgl_page_pairs *sgl_pg_pairs;
+	void *viraddr;
+	LPFC_MBOXQ_t *mbox;
+	uint32_t reqlen, alloclen, pg_pairs;
+	uint32_t mbox_tmo;
+	uint16_t xri_start = 0, scsi_xri_start;
+	uint16_t rsrc_range;
+	int rc = 0, avail_cnt;
+	uint32_t shdr_status, shdr_add_status;
+	dma_addr_t pdma_phys_bpl1;
+	union lpfc_sli4_cfg_shdr *shdr;
+	struct lpfc_rsrc_blks *rsrc_blk;
+	uint32_t xri_cnt = 0;
+
+	/* Calculate the total requested length of the dma memory */
+	reqlen = cnt * sizeof(struct sgl_page_pairs) +
+		 sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
+	if (reqlen > SLI4_PAGE_SIZE) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2932 Block sgl registration required DMA "
+				"size (%d) great than a page\n", reqlen);
+		return -ENOMEM;
+	}
+
+	/*
+	 * The use of extents requires the driver to post the sgl headers
+	 * in multiple postings to meet the contiguous resource assignment.
+	 */
+	psb = list_prepare_entry(psb, sblist, list);
+	scsi_xri_start = phba->sli4_hba.scsi_xri_start;
+	list_for_each_entry(rsrc_blk, &phba->sli4_hba.lpfc_xri_blk_list,
+			    list) {
+		rsrc_range = rsrc_blk->rsrc_start + rsrc_blk->rsrc_size;
+		if (rsrc_range < scsi_xri_start)
+			continue;
+		else if (rsrc_blk->rsrc_used >= rsrc_blk->rsrc_size)
+			continue;
+		else
+			avail_cnt = rsrc_blk->rsrc_size - rsrc_blk->rsrc_used;
+
+		reqlen = (avail_cnt * sizeof(struct sgl_page_pairs)) +
+			sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
+		/*
+		 * Allocate DMA memory and set up the non-embedded mailbox
+		 * command. The mbox is used to post an SGL page per loop
+		 * but the DMA memory has a use-once semantic so the mailbox
+		 * is used and freed per loop pass.
+		 */
+		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!mbox) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2933 Failed to allocate mbox cmd "
+					"memory\n");
+			return -ENOMEM;
+		}
+		alloclen = lpfc_sli4_config(phba, mbox,
+					LPFC_MBOX_SUBSYSTEM_FCOE,
+					LPFC_MBOX_OPCODE_FCOE_POST_SGL_PAGES,
+					reqlen,
+					LPFC_SLI4_MBX_NEMBED);
+		if (alloclen < reqlen) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2934 Allocated DMA memory size (%d) "
+					"is less than the requested DMA memory "
+					"size (%d)\n", alloclen, reqlen);
+			lpfc_sli4_mbox_cmd_free(phba, mbox);
+			return -ENOMEM;
+		}
+
+		/* Get the first SGE entry from the non-embedded DMA memory */
+		viraddr = mbox->sge_array->addr[0];
+
+		/* Set up the SGL pages in the non-embedded DMA pages */
+		sgl = (struct lpfc_mbx_post_uembed_sgl_page1 *)viraddr;
+		sgl_pg_pairs = &sgl->sgl_pg_pairs;
+
+		/* pg_pairs tracks posted SGEs per loop iteration. */
+		pg_pairs = 0;
+		list_for_each_entry_continue(psb, sblist, list) {
+			/* Set up the sge entry */
+			sgl_pg_pairs->sgl_pg0_addr_lo =
+				cpu_to_le32(putPaddrLow(psb->dma_phys_bpl));
+			sgl_pg_pairs->sgl_pg0_addr_hi =
+				cpu_to_le32(putPaddrHigh(psb->dma_phys_bpl));
+			if (phba->cfg_sg_dma_buf_size > SGL_PAGE_SIZE)
+				pdma_phys_bpl1 = psb->dma_phys_bpl +
+					SGL_PAGE_SIZE;
+			else
+				pdma_phys_bpl1 = 0;
+			sgl_pg_pairs->sgl_pg1_addr_lo =
+				cpu_to_le32(putPaddrLow(pdma_phys_bpl1));
+			sgl_pg_pairs->sgl_pg1_addr_hi =
+				cpu_to_le32(putPaddrHigh(pdma_phys_bpl1));
+			/* Keep the first xri for this extent. */
+			if (pg_pairs == 0)
+				xri_start = psb->cur_iocbq.sli4_xritag;
+			sgl_pg_pairs++;
+			pg_pairs++;
+			xri_cnt++;
+
+			/*
+			 * Track two exit conditions - the loop has constructed
+			 * all of the caller's SGE pairs or all available
+			 * resource IDs in this extent are consumed.
+			 */
+			if ((xri_cnt == cnt) || (pg_pairs >= avail_cnt))
+				break;
+		}
+		rsrc_blk->rsrc_used += pg_pairs;
+		bf_set(lpfc_post_sgl_pages_xri, sgl, xri_start);
+		bf_set(lpfc_post_sgl_pages_xricnt, sgl, pg_pairs);
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"3016 Post SCSI Extent SGL, start %d, cnt %d "
+				"blk use %d\n",
+				xri_start, pg_pairs, rsrc_blk->rsrc_used);
+		/* Perform endian conversion if necessary */
+		sgl->word0 = cpu_to_le32(sgl->word0);
+		if (!phba->sli4_hba.intr_enable)
+			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+		else {
+			mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+			rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+		}
+		shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
+		shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+		shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+					 &shdr->response);
+		if (rc != MBX_TIMEOUT)
+			lpfc_sli4_mbox_cmd_free(phba, mbox);
+		if (shdr_status || shdr_add_status || rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"2935 POST_SGL_BLOCK mailbox command "
+					"failed status x%x add_status x%x "
+					"mbx status x%x\n",
+					shdr_status, shdr_add_status, rc);
+			return -ENXIO;
+		}
+
+		/* Post only what is requested. */
+		if (xri_cnt >= cnt)
+			break;
+	}
+	return rc;
+}
+
+/**
  * lpfc_fc_frame_check - Check that this frame is a valid frame to handle
  * @phba: pointer to lpfc_hba struct that the frame was received on
  * @fc_hdr: A pointer to the FC Header data (In Big Endian Format)
@@ -12147,6 +13399,28 @@ lpfc_sli4_seq_abort_rsp_cmpl(struct lpfc
 }
 
 /**
+ * lpfc_sli4_xri_inrange - check xri is in range of xris owned by driver.
+ * @phba: Pointer to HBA context object.
+ * @xri: xri id in transaction.
+ *
+ * This function validates the xri maps to the known range of XRIs allocated an
+ * used by the driver.
+ **/
+static uint16_t
+lpfc_sli4_xri_inrange(struct lpfc_hba *phba,
+		      uint16_t xri)
+{
+	int i;
+
+	for (i = 0; i < phba->sli4_hba.max_cfg_param.max_xri; i++) {
+		if (xri == phba->sli4_hba.xri_ids[i])
+			return i;
+	}
+	return NO_XRI;
+}
+
+
+/**
  * lpfc_sli4_seq_abort_rsp - bls rsp to sequence abort
  * @phba: Pointer to HBA context object.
  * @fc_hdr: pointer to a FC frame header.
@@ -12179,9 +13453,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba 
 				"SID:x%x\n", oxid, sid);
 		return;
 	}
-	if (rxid >= phba->sli4_hba.max_cfg_param.xri_base
-		&& rxid <= (phba->sli4_hba.max_cfg_param.max_xri
-		+ phba->sli4_hba.max_cfg_param.xri_base))
+	if (lpfc_sli4_xri_inrange(phba, rxid))
 		lpfc_set_rrq_active(phba, ndlp, rxid, oxid, 0);
 
 	/* Allocate buffer for rsp iocb */
@@ -12204,12 +13476,13 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba 
 	icmd->ulpBdeCount = 0;
 	icmd->ulpLe = 1;
 	icmd->ulpClass = CLASS3;
-	icmd->ulpContext = ndlp->nlp_rpi;
+	icmd->ulpContext = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
 	ctiocb->context1 = ndlp;
 
 	ctiocb->iocb_cmpl = NULL;
 	ctiocb->vport = phba->pport;
 	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
+	ctiocb->sli4_lxritag = NO_XRI;
 	ctiocb->sli4_xritag = NO_XRI;
 
 	/* If the oxid maps to the FCP XRI range or if it is out of range,
@@ -12390,8 +13663,8 @@ lpfc_prep_seq(struct lpfc_vport *vport, 
 		first_iocbq->iocb.ulpStatus = IOSTAT_SUCCESS;
 		first_iocbq->iocb.ulpCommand = CMD_IOCB_RCV_SEQ64_CX;
 		first_iocbq->iocb.ulpContext = be16_to_cpu(fc_hdr->fh_ox_id);
-		first_iocbq->iocb.unsli3.rcvsli3.vpi =
-					vport->vpi + vport->phba->vpi_base;
+		/* iocbq is prepped for internal consumption.  Logical vpi. */
+		first_iocbq->iocb.unsli3.rcvsli3.vpi = vport->vpi;
 		/* put the first buffer into the first IOCBq */
 		first_iocbq->context2 = &seq_dmabuf->dbuf;
 		first_iocbq->context3 = NULL;
@@ -12471,7 +13744,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vp
 				      &phba->sli.ring[LPFC_ELS_RING],
 				      iocbq, fc_hdr->fh_r_ctl,
 				      fc_hdr->fh_type))
-		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2540 Ring %d handler: unexpected Rctl "
 				"x%x Type x%x received\n",
 				LPFC_ELS_RING,
@@ -12568,9 +13841,24 @@ lpfc_sli4_post_all_rpi_hdrs(struct lpfc_
 {
 	struct lpfc_rpi_hdr *rpi_page;
 	uint32_t rc = 0;
+	uint16_t lrpi = 0;
+
+	/* SLI4 ports that support extents do not require RPI headers. */
+	if (!phba->sli4_hba.rpi_hdrs_in_use)
+		goto exit;
+	if (phba->sli4_hba.extents_in_use)
+		return -EIO;
 
-	/* Post all rpi memory regions to the port. */
 	list_for_each_entry(rpi_page, &phba->sli4_hba.lpfc_rpi_hdr_list, list) {
+		/*
+		 * Assign the rpi headers a physical rpi only if the driver
+		 * has not initialized those resources.  A port reset only
+		 * needs the headers posted.
+		 */
+		if (bf_get(lpfc_rpi_rsrc_rdy, &phba->sli4_hba.sli4_flags) !=
+		    LPFC_RPI_RSRC_RDY)
+			rpi_page->start_rpi = phba->sli4_hba.rpi_ids[lrpi];
+
 		rc = lpfc_sli4_post_rpi_hdr(phba, rpi_page);
 		if (rc != MBX_SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -12581,6 +13869,9 @@ lpfc_sli4_post_all_rpi_hdrs(struct lpfc_
 		}
 	}
 
+ exit:
+	bf_set(lpfc_rpi_rsrc_rdy, &phba->sli4_hba.sli4_flags,
+	       LPFC_RPI_RSRC_RDY);
 	return rc;
 }
 
@@ -12604,10 +13895,15 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *
 	LPFC_MBOXQ_t *mboxq;
 	struct lpfc_mbx_post_hdr_tmpl *hdr_tmpl;
 	uint32_t rc = 0;
-	uint32_t mbox_tmo;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 
+	/* SLI4 ports that support extents do not require RPI headers. */
+	if (!phba->sli4_hba.rpi_hdrs_in_use)
+		return rc;
+	if (phba->sli4_hba.extents_in_use)
+		return -EIO;
+
 	/* The port is notified of the header region via a mailbox command. */
 	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq) {
@@ -12619,16 +13915,19 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *
 
 	/* Post all rpi memory regions to the port. */
 	hdr_tmpl = &mboxq->u.mqe.un.hdr_tmpl;
-	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
 	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
 			 LPFC_MBOX_OPCODE_FCOE_POST_HDR_TEMPLATE,
 			 sizeof(struct lpfc_mbx_post_hdr_tmpl) -
 			 sizeof(struct lpfc_sli4_cfg_mhdr),
 			 LPFC_SLI4_MBX_EMBED);
-	bf_set(lpfc_mbx_post_hdr_tmpl_page_cnt,
-	       hdr_tmpl, rpi_page->page_count);
+
+
+	/* Post the physical rpi to the port for this rpi header. */
 	bf_set(lpfc_mbx_post_hdr_tmpl_rpi_offset, hdr_tmpl,
 	       rpi_page->start_rpi);
+	bf_set(lpfc_mbx_post_hdr_tmpl_page_cnt,
+	       hdr_tmpl, rpi_page->page_count);
+
 	hdr_tmpl->rpi_paddr_lo = putPaddrLow(rpi_page->dmabuf->phys);
 	hdr_tmpl->rpi_paddr_hi = putPaddrHigh(rpi_page->dmabuf->phys);
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
@@ -12663,22 +13962,21 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *
 int
 lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
 {
-	int rpi;
-	uint16_t max_rpi, rpi_base, rpi_limit;
-	uint16_t rpi_remaining;
+	unsigned long rpi;
+	uint16_t max_rpi, rpi_limit;
+	uint16_t rpi_remaining, lrpi = 0;
 	struct lpfc_rpi_hdr *rpi_hdr;
 
 	max_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
-	rpi_base = phba->sli4_hba.max_cfg_param.rpi_base;
 	rpi_limit = phba->sli4_hba.next_rpi;
 
 	/*
-	 * The valid rpi range is not guaranteed to be zero-based.  Start
-	 * the search at the rpi_base as reported by the port.
+	 * Fetch the next logical rpi.  Because this index is logical,
+	 * the  driver starts at 0 each time.
 	 */
 	spin_lock_irq(&phba->hbalock);
-	rpi = find_next_zero_bit(phba->sli4_hba.rpi_bmask, rpi_limit, rpi_base);
-	if (rpi >= rpi_limit || rpi < rpi_base)
+	rpi = find_next_zero_bit(phba->sli4_hba.rpi_bmask, rpi_limit, 0);
+	if (rpi >= rpi_limit)
 		rpi = LPFC_RPI_ALLOC_ERROR;
 	else {
 		set_bit(rpi, phba->sli4_hba.rpi_bmask);
@@ -12688,7 +13986,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 
 	/*
 	 * Don't try to allocate more rpi header regions if the device limit
-	 * on available rpis max has been exhausted.
+	 * has been exhausted.
 	 */
 	if ((rpi == LPFC_RPI_ALLOC_ERROR) &&
 	    (phba->sli4_hba.rpi_count >= max_rpi)) {
@@ -12697,13 +13995,21 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 	}
 
 	/*
+	 * RPI header postings are not required for SLI4 ports capable of
+	 * extents.
+	 */
+	if (!phba->sli4_hba.rpi_hdrs_in_use) {
+		spin_unlock_irq(&phba->hbalock);
+		return rpi;
+	}
+
+	/*
 	 * If the driver is running low on rpi resources, allocate another
 	 * page now.  Note that the next_rpi value is used because
 	 * it represents how many are actually in use whereas max_rpi notes
 	 * how many are supported max by the device.
 	 */
-	rpi_remaining = phba->sli4_hba.next_rpi - rpi_base -
-		phba->sli4_hba.rpi_count;
+	rpi_remaining = phba->sli4_hba.next_rpi - phba->sli4_hba.rpi_count;
 	spin_unlock_irq(&phba->hbalock);
 	if (rpi_remaining < LPFC_RPI_LOW_WATER_MARK) {
 		rpi_hdr = lpfc_sli4_create_rpi_hdr(phba);
@@ -12712,6 +14018,8 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 					"2002 Error Could not grow rpi "
 					"count\n");
 		} else {
+			lrpi = rpi_hdr->start_rpi;
+			rpi_hdr->start_rpi = phba->sli4_hba.rpi_ids[lrpi];
 			lpfc_sli4_post_rpi_hdr(phba, rpi_hdr);
 		}
 	}
@@ -12761,6 +14069,8 @@ void
 lpfc_sli4_remove_rpis(struct lpfc_hba *phba)
 {
 	kfree(phba->sli4_hba.rpi_bmask);
+	kfree(phba->sli4_hba.rpi_ids);
+	bf_set(lpfc_rpi_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
 }
 
 /**
@@ -13744,7 +15054,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 				 * never happen
 				 */
 				sglq = __lpfc_clear_active_sglq(phba,
-						 sglq->sli4_xritag);
+						 sglq->sli4_lxritag);
 				spin_unlock_irqrestore(&phba->hbalock, iflags);
 				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"2823 txq empty and txq_cnt is %d\n ",
@@ -13756,6 +15066,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 		/* The xri and iocb resources secured,
 		 * attempt to issue request
 		 */
+		piocbq->sli4_lxritag = sglq->sli4_lxritag;
 		piocbq->sli4_xritag = sglq->sli4_xritag;
 		if (NO_XRI == lpfc_sli4_bpl2sgl(phba, piocbq, sglq))
 			fail_msg = "to convert bpl to sgl";
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2011-05-23 17:05:08.000000000 -0400
@@ -52,6 +52,7 @@ struct lpfc_iocbq {
 	struct list_head clist;
 	struct list_head dlist;
 	uint16_t iotag;         /* pre-assigned IO tag */
+	uint16_t sli4_lxritag;  /* logical pre-assigned XRI. */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
 	struct lpfc_cq_event cq_event;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2011-05-23 17:05:08.000000000 -0400
@@ -83,7 +83,7 @@ inline void lpfc_vport_set_state(struct 
 static int
 lpfc_alloc_vpi(struct lpfc_hba *phba)
 {
-	int  vpi;
+	unsigned long vpi;
 
 	spin_lock_irq(&phba->hbalock);
 	/* Start at bit 1 because vpi zero is reserved for the physical port */


