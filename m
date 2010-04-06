From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/7] lpfc 8.3.12: T10-PI/DIF changes
Date: Tue, 6 Apr 2010 14:49:53 -0400
Message-ID: <1270579813.19178.24.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15710 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757539Ab0DFSud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 14:50:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update driver for change in T10-PI interface on adapter
- Remove Profiles.
- Add new SLI Opcodes.
- Add new PDE structures used for BlockGuard.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h   |  173 +++++++++++++++++++++++++++---------------------------------
 lpfc_scsi.c |  147 ++++++++++++++++++++++++++++++++++----------------
 2 files changed, 179 insertions(+), 141 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-04-06 12:56:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-04-06 12:57:42.000000000 -0400
@@ -1500,7 +1500,6 @@ typedef struct {		/* FireFly BIU registe
 #define MBXERR_BAD_RCV_LENGTH       14
 #define MBXERR_DMA_ERROR            15
 #define MBXERR_ERROR                16
-#define MBXERR_UNKNOWN_CMD          18
 #define MBXERR_LINK_DOWN            0x33
 #define MBX_NOT_FINISHED           255
 
@@ -1566,94 +1565,82 @@ enum lpfc_protgrp_type {
 };
 
 /* PDE Descriptors */
-#define LPFC_PDE1_DESCRIPTOR		0x81
-#define LPFC_PDE2_DESCRIPTOR		0x82
-#define LPFC_PDE3_DESCRIPTOR		0x83
-
-/* BlockGuard Profiles */
-enum lpfc_bg_prof_codes {
-	LPFC_PROF_INVALID,
-	LPFC_PROF_A1	= 128,	/* Full Protection			      */
-	LPFC_PROF_A2,		/* Disabled Protection Checks:A2~A4           */
-	LPFC_PROF_A3,
-	LPFC_PROF_A4,
-	LPFC_PROF_B1,		/* Embedded DIFs: B1~B3	                      */
-	LPFC_PROF_B2,
-	LPFC_PROF_B3,
-	LPFC_PROF_C1,		/* Separate DIFs: C1~C3                       */
-	LPFC_PROF_C2,
-	LPFC_PROF_C3,
-	LPFC_PROF_D1,		/* Full Protection                            */
-	LPFC_PROF_D2,		/* Partial Protection & Check Disabling       */
-	LPFC_PROF_D3,
-	LPFC_PROF_E1,		/* E1~E4:out - check-only, in - update apptag */
-	LPFC_PROF_E2,
-	LPFC_PROF_E3,
-	LPFC_PROF_E4,
-	LPFC_PROF_F1,		/* Full Translation - F1 Prot Descriptor      */
-				/* F1 Translation BDE                         */
-	LPFC_PROF_ANT1,		/* TCP checksum, DIF inline with data buffers */
-	LPFC_PROF_AST1,		/* TCP checksum, DIF split from data buffer   */
-	LPFC_PROF_ANT2,
-	LPFC_PROF_AST2
-};
-
-/* BlockGuard error-control defines */
-#define BG_EC_STOP_ERR			0x00
-#define BG_EC_CONT_ERR			0x01
-#define BG_EC_IGN_UNINIT_STOP_ERR	0x10
-#define BG_EC_IGN_UNINIT_CONT_ERR	0x11
-
-/* PDE (Protection Descriptor Entry) word 0 bit masks and shifts */
-#define PDE_DESC_TYPE_MASK		0xff000000
-#define PDE_DESC_TYPE_SHIFT		24
-#define PDE_BG_PROFILE_MASK		0x00ff0000
-#define PDE_BG_PROFILE_SHIFT		16
-#define PDE_BLOCK_LEN_MASK		0x0000fffc
-#define PDE_BLOCK_LEN_SHIFT		2
-#define PDE_ERR_CTRL_MASK		0x00000003
-#define PDE_ERR_CTRL_SHIFT		0
-/* PDE word 1 bit masks and shifts */
-#define PDE_APPTAG_MASK_MASK		0xffff0000
-#define PDE_APPTAG_MASK_SHIFT		16
-#define PDE_APPTAG_VAL_MASK		0x0000ffff
-#define PDE_APPTAG_VAL_SHIFT		0
-struct lpfc_pde {
-	uint32_t parms;     /* bitfields of descriptor, prof, len, and ec */
-	uint32_t apptag;    /* bitfields of app tag maskand app tag value */
-	uint32_t reftag;    /* reference tag occupying all 32 bits        */
-};
-
-/* inline function to set fields in parms of PDE */
-static inline void
-lpfc_pde_set_bg_parms(struct lpfc_pde *p, u8 desc, u8 prof, u16 len, u8 ec)
-{
-	uint32_t *wp = &p->parms;
-
-	/* spec indicates that adapter appends two 0's to length field */
-	len = len >> 2;
-
-	*wp &= 0;
-	*wp |= ((desc << PDE_DESC_TYPE_SHIFT) & PDE_DESC_TYPE_MASK);
-	*wp |= ((prof << PDE_BG_PROFILE_SHIFT) & PDE_BG_PROFILE_MASK);
-	*wp |= ((len << PDE_BLOCK_LEN_SHIFT) & PDE_BLOCK_LEN_MASK);
-	*wp |= ((ec << PDE_ERR_CTRL_SHIFT) & PDE_ERR_CTRL_MASK);
-	*wp = le32_to_cpu(*wp);
-}
-
-/* inline function to set apptag and reftag fields of PDE */
-static inline void
-lpfc_pde_set_dif_parms(struct lpfc_pde *p, u16 apptagmask, u16 apptagval,
-		u32 reftag)
-{
-	uint32_t *wp = &p->apptag;
-	*wp &= 0;
-	*wp |= ((apptagmask << PDE_APPTAG_MASK_SHIFT) & PDE_APPTAG_MASK_MASK);
-	*wp |= ((apptagval << PDE_APPTAG_VAL_SHIFT) & PDE_APPTAG_VAL_MASK);
-	*wp = le32_to_cpu(*wp);
-	wp = &p->reftag;
-	*wp = le32_to_cpu(reftag);
-}
+#define LPFC_PDE5_DESCRIPTOR		0x85
+#define LPFC_PDE6_DESCRIPTOR		0x86
+#define LPFC_PDE7_DESCRIPTOR		0x87
+
+/* BlockGuard Opcodes */
+#define BG_OP_IN_NODIF_OUT_CRC		0x0
+#define	BG_OP_IN_CRC_OUT_NODIF		0x1
+#define	BG_OP_IN_NODIF_OUT_CSUM		0x2
+#define	BG_OP_IN_CSUM_OUT_NODIF		0x3
+#define	BG_OP_IN_CRC_OUT_CRC		0x4
+#define	BG_OP_IN_CSUM_OUT_CSUM		0x5
+#define	BG_OP_IN_CRC_OUT_CSUM		0x6
+#define	BG_OP_IN_CSUM_OUT_CRC		0x7
+
+struct lpfc_pde5 {
+	uint32_t word0;
+#define pde5_type_SHIFT		24
+#define pde5_type_MASK		0x000000ff
+#define pde5_type_WORD		word0
+#define pde5_rsvd0_SHIFT	0
+#define pde5_rsvd0_MASK		0x00ffffff
+#define pde5_rsvd0_WORD		word0
+	uint32_t reftag;	/* Reference Tag Value			*/
+	uint32_t reftagtr;	/* Reference Tag Translation Value 	*/
+};
+
+struct lpfc_pde6 {
+	uint32_t word0;
+#define pde6_type_SHIFT		24
+#define pde6_type_MASK		0x000000ff
+#define pde6_type_WORD		word0
+#define pde6_rsvd0_SHIFT	0
+#define pde6_rsvd0_MASK		0x00ffffff
+#define pde6_rsvd0_WORD		word0
+	uint32_t word1;
+#define pde6_rsvd1_SHIFT	26
+#define pde6_rsvd1_MASK		0x0000003f
+#define pde6_rsvd1_WORD		word1
+#define pde6_na_SHIFT		25
+#define pde6_na_MASK		0x00000001
+#define pde6_na_WORD		word1
+#define pde6_rsvd2_SHIFT	16
+#define pde6_rsvd2_MASK		0x000001FF
+#define pde6_rsvd2_WORD		word1
+#define pde6_apptagtr_SHIFT	0
+#define pde6_apptagtr_MASK	0x0000ffff
+#define pde6_apptagtr_WORD	word1
+	uint32_t word2;
+#define pde6_optx_SHIFT		28
+#define pde6_optx_MASK		0x0000000f
+#define pde6_optx_WORD		word2
+#define pde6_oprx_SHIFT		24
+#define pde6_oprx_MASK		0x0000000f
+#define pde6_oprx_WORD		word2
+#define pde6_nr_SHIFT		23
+#define pde6_nr_MASK		0x00000001
+#define pde6_nr_WORD		word2
+#define pde6_ce_SHIFT		22
+#define pde6_ce_MASK		0x00000001
+#define pde6_ce_WORD		word2
+#define pde6_re_SHIFT		21
+#define pde6_re_MASK		0x00000001
+#define pde6_re_WORD		word2
+#define pde6_ae_SHIFT		20
+#define pde6_ae_MASK		0x00000001
+#define pde6_ae_WORD		word2
+#define pde6_ai_SHIFT		19
+#define pde6_ai_MASK		0x00000001
+#define pde6_ai_WORD		word2
+#define pde6_bs_SHIFT		16
+#define pde6_bs_MASK		0x00000007
+#define pde6_bs_WORD		word2
+#define pde6_apptagval_SHIFT	0
+#define pde6_apptagval_MASK	0x0000ffff
+#define pde6_apptagval_WORD	word2
+};
 

 /* Structure for MB Command LOAD_SM and DOWN_LOAD */
@@ -2488,8 +2475,8 @@ typedef struct {
 #define  DMP_VPORT_REGION_SIZE	 0x200
 #define  DMP_MBOX_OFFSET_WORD	 0x5
 
-#define  DMP_REGION_23	 	 0x17   /* fcoe param  and port state region */
-#define  DMP_RGN23_SIZE	 	 0x400
+#define  DMP_REGION_23		 0x17   /* fcoe param  and port state region */
+#define  DMP_RGN23_SIZE		 0x400
 
 #define  WAKE_UP_PARMS_REGION_ID    4
 #define  WAKE_UP_PARMS_WORD_SIZE   15
@@ -2504,9 +2491,9 @@ struct vport_rec {
 #define VPORT_INFO_REV 0x1
 #define MAX_STATIC_VPORT_COUNT 16
 struct static_vport_info {
-	uint32_t 		signature;
+	uint32_t		signature;
 	uint32_t		rev;
-	struct vport_rec 	vport_list[MAX_STATIC_VPORT_COUNT];
+	struct vport_rec	vport_list[MAX_STATIC_VPORT_COUNT];
 	uint32_t		resvd[66];
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-04-06 12:42:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-04-06 12:57:42.000000000 -0400
@@ -1140,37 +1140,47 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hb
 }
 
 /*
- * Given a scsi cmnd, determine the BlockGuard profile to be used
- * with the cmd
+ * Given a scsi cmnd, determine the BlockGuard opcodes to be used with it
+ * @sc: The SCSI command to examine
+ * @txopt: (out) BlockGuard operation for transmitted data
+ * @rxopt: (out) BlockGuard operation for received data
+ *
+ * Returns: zero on success; non-zero if tx and/or rx op cannot be determined
+ *
  */
 static int
-lpfc_sc_to_sli_prof(struct lpfc_hba *phba, struct scsi_cmnd *sc)
+lpfc_sc_to_bg_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
+		uint8_t *txop, uint8_t *rxop)
 {
 	uint8_t guard_type = scsi_host_get_guard(sc->device->host);
-	uint8_t ret_prof = LPFC_PROF_INVALID;
+	uint8_t ret = 0;
 
 	if (guard_type == SHOST_DIX_GUARD_IP) {
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
-			ret_prof = LPFC_PROF_AST2;
+			*txop = BG_OP_IN_CSUM_OUT_NODIF;
+			*rxop = BG_OP_IN_NODIF_OUT_CSUM;
 			break;
 
 		case SCSI_PROT_READ_STRIP:
 		case SCSI_PROT_WRITE_INSERT:
-			ret_prof = LPFC_PROF_A1;
+			*txop = BG_OP_IN_NODIF_OUT_CRC;
+			*rxop = BG_OP_IN_CRC_OUT_NODIF;
 			break;
 
 		case SCSI_PROT_READ_PASS:
 		case SCSI_PROT_WRITE_PASS:
-			ret_prof = LPFC_PROF_AST1;
+			*txop = BG_OP_IN_CSUM_OUT_CRC;
+			*rxop = BG_OP_IN_CRC_OUT_CSUM;
 			break;
 
 		case SCSI_PROT_NORMAL:
 		default:
 			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-				"9063 BLKGRD:Bad op/guard:%d/%d combination\n",
+				"9063 BLKGRD: Bad op/guard:%d/%d combination\n",
 					scsi_get_prot_op(sc), guard_type);
+			ret = 1;
 			break;
 
 		}
@@ -1178,12 +1188,14 @@ lpfc_sc_to_sli_prof(struct lpfc_hba *phb
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_STRIP:
 		case SCSI_PROT_WRITE_INSERT:
-			ret_prof = LPFC_PROF_A1;
+			*txop = BG_OP_IN_NODIF_OUT_CRC;
+			*rxop = BG_OP_IN_CRC_OUT_NODIF;
 			break;
 
 		case SCSI_PROT_READ_PASS:
 		case SCSI_PROT_WRITE_PASS:
-			ret_prof = LPFC_PROF_C1;
+			*txop = BG_OP_IN_CRC_OUT_CRC;
+			*rxop = BG_OP_IN_CRC_OUT_CRC;
 			break;
 
 		case SCSI_PROT_READ_INSERT:
@@ -1193,6 +1205,7 @@ lpfc_sc_to_sli_prof(struct lpfc_hba *phb
 			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
 				"9075 BLKGRD: Bad op/guard:%d/%d combination\n",
 					scsi_get_prot_op(sc), guard_type);
+			ret = 1;
 			break;
 		}
 	} else {
@@ -1200,7 +1213,7 @@ lpfc_sc_to_sli_prof(struct lpfc_hba *phb
 		BUG();
 	}
 
-	return ret_prof;
+	return ret;
 }
 
 struct scsi_dif_tuple {
@@ -1265,7 +1278,9 @@ lpfc_get_cmd_dif_parms(struct scsi_cmnd 
  * The buffer list consists of just one protection group described
  * below:
  *                                +-------------------------+
- *   start of prot group  -->     |          PDE_1          |
+ *   start of prot group  -->     |          PDE_5          |
+ *                                +-------------------------+
+ *                                |          PDE_6          |
  *                                +-------------------------+
  *                                |         Data BDE        |
  *                                +-------------------------+
@@ -1283,30 +1298,49 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 		struct ulp_bde64 *bpl, int datasegcnt)
 {
 	struct scatterlist *sgde = NULL; /* s/g data entry */
-	struct lpfc_pde *pde1 = NULL;
+	struct lpfc_pde5 *pde5 = NULL;
+	struct lpfc_pde6 *pde6 = NULL;
 	dma_addr_t physaddr;
-	int i = 0, num_bde = 0;
+	int i = 0, num_bde = 0, status;
 	int datadir = sc->sc_data_direction;
-	int prof = LPFC_PROF_INVALID;
 	unsigned blksize;
 	uint32_t reftag;
 	uint16_t apptagmask, apptagval;
+	uint8_t txop, rxop;
 
-	pde1 = (struct lpfc_pde *) bpl;
-	prof = lpfc_sc_to_sli_prof(phba, sc);
-
-	if (prof == LPFC_PROF_INVALID)
+	status  = lpfc_sc_to_bg_opcodes(phba, sc, &txop, &rxop);
+	if (status)
 		goto out;
 
-	/* extract some info from the scsi command for PDE1*/
+	/* extract some info from the scsi command for pde*/
 	blksize = lpfc_cmd_blksize(sc);
 	lpfc_get_cmd_dif_parms(sc, &apptagmask, &apptagval, &reftag);
 
-	/* setup PDE1 with what we have */
-	lpfc_pde_set_bg_parms(pde1, LPFC_PDE1_DESCRIPTOR, prof, blksize,
-			BG_EC_STOP_ERR);
-	lpfc_pde_set_dif_parms(pde1, apptagmask, apptagval, reftag);
+	/* setup PDE5 with what we have */
+	pde5 = (struct lpfc_pde5 *) bpl;
+	memset(pde5, 0, sizeof(struct lpfc_pde5));
+	bf_set(pde5_type, pde5, LPFC_PDE5_DESCRIPTOR);
+	pde5->reftag = reftag;
+
+	/* advance bpl and increment bde count */
+	num_bde++;
+	bpl++;
+	pde6 = (struct lpfc_pde6 *) bpl;
+
+	/* setup PDE6 with the rest of the info */
+	memset(pde6, 0, sizeof(struct lpfc_pde6));
+	bf_set(pde6_type, pde6, LPFC_PDE6_DESCRIPTOR);
+	bf_set(pde6_optx, pde6, txop);
+	bf_set(pde6_oprx, pde6, rxop);
+	if (datadir == DMA_FROM_DEVICE) {
+		bf_set(pde6_ce, pde6, 1);
+		bf_set(pde6_re, pde6, 1);
+		bf_set(pde6_ae, pde6, 1);
+	}
+	bf_set(pde6_ai, pde6, 1);
+	bf_set(pde6_apptagval, pde6, apptagval);
 
+	/* advance bpl and increment bde count */
 	num_bde++;
 	bpl++;
 
@@ -1341,15 +1375,17 @@ out:
  * The buffer list for this type consists of one or more of the
  * protection groups described below:
  *                                    +-------------------------+
- *   start of first prot group  -->   |          PDE_1          |
+ *   start of first prot group  -->   |          PDE_5          |
  *                                    +-------------------------+
- *                                    |      PDE_3 (Prot BDE)   |
+ *                                    |          PDE_6          |
+ *                                    +-------------------------+
+ *                                    |      PDE_7 (Prot BDE)   |
  *                                    +-------------------------+
  *                                    |        Data BDE         |
  *                                    +-------------------------+
  *                                    |more Data BDE's ... (opt)|
  *                                    +-------------------------+
- *   start of new  prot group  -->    |          PDE_1          |
+ *   start of new  prot group  -->    |          PDE_5          |
  *                                    +-------------------------+
  *                                    |          ...            |
  *                                    +-------------------------+
@@ -1368,19 +1404,21 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 {
 	struct scatterlist *sgde = NULL; /* s/g data entry */
 	struct scatterlist *sgpe = NULL; /* s/g prot entry */
-	struct lpfc_pde *pde1 = NULL;
+	struct lpfc_pde5 *pde5 = NULL;
+	struct lpfc_pde6 *pde6 = NULL;
 	struct ulp_bde64 *prot_bde = NULL;
 	dma_addr_t dataphysaddr, protphysaddr;
 	unsigned short curr_data = 0, curr_prot = 0;
 	unsigned int split_offset, protgroup_len;
 	unsigned int protgrp_blks, protgrp_bytes;
 	unsigned int remainder, subtotal;
-	int prof = LPFC_PROF_INVALID;
+	int status;
 	int datadir = sc->sc_data_direction;
 	unsigned char pgdone = 0, alldone = 0;
 	unsigned blksize;
 	uint32_t reftag;
 	uint16_t apptagmask, apptagval;
+	uint8_t txop, rxop;
 	int num_bde = 0;
 
 	sgpe = scsi_prot_sglist(sc);
@@ -1393,31 +1431,47 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		return 0;
 	}
 
-	prof = lpfc_sc_to_sli_prof(phba, sc);
-	if (prof == LPFC_PROF_INVALID)
+	status = lpfc_sc_to_bg_opcodes(phba, sc, &txop, &rxop);
+	if (status)
 		goto out;
 
-	/* extract some info from the scsi command for PDE1*/
+	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
 	lpfc_get_cmd_dif_parms(sc, &apptagmask, &apptagval, &reftag);
 
 	split_offset = 0;
 	do {
-		/* setup the first PDE_1 */
-		pde1 = (struct lpfc_pde *) bpl;
+		/* setup PDE5 with what we have */
+		pde5 = (struct lpfc_pde5 *) bpl;
+		memset(pde5, 0, sizeof(struct lpfc_pde5));
+		bf_set(pde5_type, pde5, LPFC_PDE5_DESCRIPTOR);
+		pde5->reftag = reftag;
+
+		/* advance bpl and increment bde count */
+		num_bde++;
+		bpl++;
+		pde6 = (struct lpfc_pde6 *) bpl;
 
-		lpfc_pde_set_bg_parms(pde1, LPFC_PDE1_DESCRIPTOR, prof, blksize,
-				BG_EC_STOP_ERR);
-		lpfc_pde_set_dif_parms(pde1, apptagmask, apptagval, reftag);
+		/* setup PDE6 with the rest of the info */
+		memset(pde6, 0, sizeof(struct lpfc_pde6));
+		bf_set(pde6_type, pde6, LPFC_PDE6_DESCRIPTOR);
+		bf_set(pde6_optx, pde6, txop);
+		bf_set(pde6_oprx, pde6, rxop);
+		bf_set(pde6_ce, pde6, 1);
+		bf_set(pde6_re, pde6, 1);
+		bf_set(pde6_ae, pde6, 1);
+		bf_set(pde6_ai, pde6, 1);
+		bf_set(pde6_apptagval, pde6, apptagval);
 
+		/* advance bpl and increment bde count */
 		num_bde++;
 		bpl++;
 
 		/* setup the first BDE that points to protection buffer */
 		prot_bde = (struct ulp_bde64 *) bpl;
 		protphysaddr = sg_dma_address(sgpe);
-		prot_bde->addrLow = le32_to_cpu(putPaddrLow(protphysaddr));
-		prot_bde->addrHigh = le32_to_cpu(putPaddrHigh(protphysaddr));
+		prot_bde->addrHigh = le32_to_cpu(putPaddrLow(protphysaddr));
+		prot_bde->addrLow = le32_to_cpu(putPaddrHigh(protphysaddr));
 		protgroup_len = sg_dma_len(sgpe);
 

@@ -1428,10 +1482,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		protgrp_bytes = protgrp_blks * blksize;
 
 		prot_bde->tus.f.bdeSize = protgroup_len;
-		if (datadir == DMA_TO_DEVICE)
-			prot_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-		else
-			prot_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64I;
+		prot_bde->tus.f.bdeFlags = LPFC_PDE7_DESCRIPTOR;
 		prot_bde->tus.w = le32_to_cpu(bpl->tus.w);
 
 		curr_prot++;
@@ -1483,6 +1534,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 
 			/* Move to the next s/g segment if possible */
 			sgde = sg_next(sgde);
+
 		}
 
 		/* are we done ? */
@@ -1505,7 +1557,6 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 
 out:
 
-
 	return num_bde;
 }
 /*
@@ -1827,8 +1878,8 @@ out:
  * field of @lpfc_cmd for device with SLI-4 interface spec.
  *
  * Return codes:
- * 	1 - Error
- * 	0 - Success
+ *	1 - Error
+ *	0 - Success
  **/
 static int
 lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
@@ -1936,8 +1987,8 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
  * lpfc_hba struct.
  *
  * Return codes:
- * 	1 - Error
- * 	0 - Success
+ *	1 - Error
+ *	0 - Success
  **/
 static inline int
 lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)


