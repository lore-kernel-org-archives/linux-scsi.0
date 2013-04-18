From: James Smart <james.smart@emulex.com>
Subject: [PATCH 12/22] lpfc 8.3.39: Fixed BlockGuard to take advantage of
 rdprotect/wrprotect info when available
Date: Wed, 17 Apr 2013 20:18:07 -0400
Message-ID: <1366244287.1513.13.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24323 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935849Ab3DRASJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:18:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed BlockGuard to take advantage of rdprotect/wrprotect info when available


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h   |    1 
 lpfc_scsi.c |  181 ++++++++++++++++++++++++++++++++++++++----------------------
 2 files changed, 116 insertions(+), 66 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2013-04-15 18:26:43.651041272 -0400
@@ -1667,6 +1667,7 @@ enum lpfc_protgrp_type {
 #define	BG_OP_IN_CSUM_OUT_CSUM		0x5
 #define	BG_OP_IN_CRC_OUT_CSUM		0x6
 #define	BG_OP_IN_CSUM_OUT_CRC		0x7
+#define	BG_OP_RAW_MODE			0x8
 
 struct lpfc_pde5 {
 	uint32_t word0;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:40.587041201 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:43.653041272 -0400
@@ -68,6 +68,10 @@ struct scsi_dif_tuple {
 	__be32 ref_tag;         /* Target LBA or indirect LBA */
 };
 
+#if !defined(SCSI_PROT_GUARD_CHECK) || !defined(SCSI_PROT_REF_CHECK)
+#define scsi_prot_flagged(sc, flg)	sc
+#endif
+
 static void
 lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
 static void
@@ -2066,9 +2070,21 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 	bf_set(pde6_type, pde6, LPFC_PDE6_DESCRIPTOR);
 	bf_set(pde6_optx, pde6, txop);
 	bf_set(pde6_oprx, pde6, rxop);
+
+	/*
+	 * We only need to check the data on READs, for WRITEs
+	 * protection data is automatically generated, not checked.
+	 */
 	if (datadir == DMA_FROM_DEVICE) {
-		bf_set(pde6_ce, pde6, checking);
-		bf_set(pde6_re, pde6, checking);
+		if (scsi_prot_flagged(sc, SCSI_PROT_GUARD_CHECK))
+			bf_set(pde6_ce, pde6, checking);
+		else
+			bf_set(pde6_ce, pde6, 0);
+
+		if (scsi_prot_flagged(sc, SCSI_PROT_REF_CHECK))
+			bf_set(pde6_re, pde6, checking);
+		else
+			bf_set(pde6_re, pde6, 0);
 	}
 	bf_set(pde6_ai, pde6, 1);
 	bf_set(pde6_ae, pde6, 0);
@@ -2221,8 +2237,17 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		bf_set(pde6_type, pde6, LPFC_PDE6_DESCRIPTOR);
 		bf_set(pde6_optx, pde6, txop);
 		bf_set(pde6_oprx, pde6, rxop);
-		bf_set(pde6_ce, pde6, checking);
-		bf_set(pde6_re, pde6, checking);
+
+		if (scsi_prot_flagged(sc, SCSI_PROT_GUARD_CHECK))
+			bf_set(pde6_ce, pde6, checking);
+		else
+			bf_set(pde6_ce, pde6, 0);
+
+		if (scsi_prot_flagged(sc, SCSI_PROT_REF_CHECK))
+			bf_set(pde6_re, pde6, checking);
+		else
+			bf_set(pde6_re, pde6, 0);
+
 		bf_set(pde6_ai, pde6, 1);
 		bf_set(pde6_ae, pde6, 0);
 		bf_set(pde6_apptagval, pde6, 0);
@@ -2385,7 +2410,6 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba,
 	struct sli4_sge_diseed *diseed = NULL;
 	dma_addr_t physaddr;
 	int i = 0, num_sge = 0, status;
-	int datadir = sc->sc_data_direction;
 	uint32_t reftag;
 	unsigned blksize;
 	uint8_t txop, rxop;
@@ -2423,13 +2447,26 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba,
 	diseed->ref_tag = cpu_to_le32(reftag);
 	diseed->ref_tag_tran = diseed->ref_tag;
 
+	/*
+	 * We only need to check the data on READs, for WRITEs
+	 * protection data is automatically generated, not checked.
+	 */
+	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
+		if (scsi_prot_flagged(sc, SCSI_PROT_GUARD_CHECK))
+			bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
+		else
+			bf_set(lpfc_sli4_sge_dif_ce, diseed, 0);
+
+		if (scsi_prot_flagged(sc, SCSI_PROT_REF_CHECK))
+			bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
+		else
+			bf_set(lpfc_sli4_sge_dif_re, diseed, 0);
+	}
+
 	/* setup DISEED with the rest of the info */
 	bf_set(lpfc_sli4_sge_dif_optx, diseed, txop);
 	bf_set(lpfc_sli4_sge_dif_oprx, diseed, rxop);
-	if (datadir == DMA_FROM_DEVICE) {
-		bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
-		bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
-	}
+
 	bf_set(lpfc_sli4_sge_dif_ai, diseed, 1);
 	bf_set(lpfc_sli4_sge_dif_me, diseed, 0);
 
@@ -2571,11 +2608,34 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *
 		diseed->ref_tag = cpu_to_le32(reftag);
 		diseed->ref_tag_tran = diseed->ref_tag;
 
+		if (scsi_prot_flagged(sc, SCSI_PROT_GUARD_CHECK)) {
+			bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
+
+		} else {
+			bf_set(lpfc_sli4_sge_dif_ce, diseed, 0);
+			/*
+			 * When in this mode, the hardware will replace
+			 * the guard tag from the host with a
+			 * newly generated good CRC for the wire.
+			 * Switch to raw mode here to avoid this
+			 * behavior. What the host sends gets put on the wire.
+			 */
+			if (txop == BG_OP_IN_CRC_OUT_CRC) {
+				txop = BG_OP_RAW_MODE;
+				rxop = BG_OP_RAW_MODE;
+			}
+		}
+
+
+		if (scsi_prot_flagged(sc, SCSI_PROT_REF_CHECK))
+			bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
+		else
+			bf_set(lpfc_sli4_sge_dif_re, diseed, 0);
+
 		/* setup DISEED with the rest of the info */
 		bf_set(lpfc_sli4_sge_dif_optx, diseed, txop);
 		bf_set(lpfc_sli4_sge_dif_oprx, diseed, rxop);
-		bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
-		bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
+
 		bf_set(lpfc_sli4_sge_dif_ai, diseed, 1);
 		bf_set(lpfc_sli4_sge_dif_me, diseed, 0);
 
@@ -2739,6 +2799,47 @@ lpfc_prot_group_type(struct lpfc_hba *ph
 }
 
 /**
+ * lpfc_bg_scsi_adjust_dl - Adjust SCSI data length for BlockGuard
+ * @phba: The Hba for which this call is being executed.
+ * @lpfc_cmd: The scsi buffer which is going to be adjusted.
+ *
+ * Adjust the data length to account for how much data
+ * is actually on the wire.
+ *
+ * returns the adjusted data length
+ **/
+static int
+lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
+		       struct lpfc_scsi_buf *lpfc_cmd)
+{
+	struct scsi_cmnd *sc = lpfc_cmd->pCmd;
+	int fcpdl;
+
+	fcpdl = scsi_bufflen(sc);
+
+	/* Check if there is protection data on the wire */
+	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
+		/* Read */
+		if (scsi_get_prot_op(sc) ==  SCSI_PROT_READ_INSERT)
+			return fcpdl;
+
+	} else {
+		/* Write */
+		if (scsi_get_prot_op(sc) ==  SCSI_PROT_WRITE_STRIP)
+			return fcpdl;
+	}
+
+	/*
+	 * If we are in DIF Type 1 mode every data block has a 8 byte
+	 * DIF (trailer) attached to it. Must ajust FCP data length.
+	 */
+	if (scsi_prot_flagged(sc, SCSI_PROT_TRANSFER_PI))
+		fcpdl += (fcpdl / lpfc_cmd_blksize(sc)) * 8;
+
+	return fcpdl;
+}
+
+/**
  * lpfc_bg_scsi_prep_dma_buf_s3 - DMA mapping for scsi buffer to SLI3 IF spec
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be prep'ed.
@@ -2758,8 +2859,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc
 	uint32_t num_bde = 0;
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
-	int diflen, fcpdl;
-	unsigned blksize;
+	int fcpdl;
 
 	/*
 	 * Start the lpfc command prep by bumping the bpl beyond fcp_cmnd
@@ -2856,18 +2956,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc
 	iocb_cmd->ulpBdeCount = 1;
 	iocb_cmd->ulpLe = 1;
 
-	fcpdl = scsi_bufflen(scsi_cmnd);
-
-	if (scsi_get_prot_type(scsi_cmnd) == SCSI_PROT_DIF_TYPE1) {
-		/*
-		 * We are in DIF Type 1 mode
-		 * Every data block has a 8 byte DIF (trailer)
-		 * attached to it.  Must ajust FCP data length
-		 */
-		blksize = lpfc_cmd_blksize(scsi_cmnd);
-		diflen = (fcpdl / blksize) * 8;
-		fcpdl += diflen;
-	}
+	fcpdl = lpfc_bg_scsi_adjust_dl(phba, lpfc_cmd);
 	fcp_cmnd->fcpDl = be32_to_cpu(fcpdl);
 
 	/*
@@ -2982,7 +3071,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba,
 			chk_guard = 1;
 		guard_type = scsi_host_get_guard(cmd->device->host);
 
-		start_ref_tag = scsi_get_lba(cmd);
+		start_ref_tag = (uint32_t)scsi_get_lba(cmd); /* Truncate LBA */
 		start_app_tag = src->app_tag;
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
 		len = sgpe->length;
@@ -3398,45 +3487,6 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
 }
 
 /**
- * lpfc_bg_scsi_adjust_dl - Adjust SCSI data length for BlockGuard
- * @phba: The Hba for which this call is being executed.
- * @lpfc_cmd: The scsi buffer which is going to be adjusted.
- *
- * Adjust the data length to account for how much data
- * is actually on the wire.
- *
- * returns the adjusted data length
- **/
-static int
-lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
-		struct lpfc_scsi_buf *lpfc_cmd)
-{
-	struct scsi_cmnd *sc = lpfc_cmd->pCmd;
-	int diflen, fcpdl;
-	unsigned blksize;
-
-	fcpdl = scsi_bufflen(sc);
-
-	/* Check if there is protection data on the wire */
-	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
-		/* Read */
-		if (scsi_get_prot_op(sc) ==  SCSI_PROT_READ_INSERT)
-			return fcpdl;
-
-	} else {
-		/* Write */
-		if (scsi_get_prot_op(sc) ==  SCSI_PROT_WRITE_STRIP)
-			return fcpdl;
-	}
-
-	/* If protection data on the wire, adjust the count accordingly */
-	blksize = lpfc_cmd_blksize(sc);
-	diflen = (fcpdl / blksize) * 8;
-	fcpdl += diflen;
-	return fcpdl;
-}
-
-/**
  * lpfc_bg_scsi_prep_dma_buf_s4 - DMA mapping for scsi buffer to SLI4 IF spec
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
@@ -3564,7 +3614,6 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc
 	}
 
 	fcpdl = lpfc_bg_scsi_adjust_dl(phba, lpfc_cmd);
-
 	fcp_cmnd->fcpDl = be32_to_cpu(fcpdl);
 
 	/*



