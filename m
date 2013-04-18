From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/22] lpfc 8.3.39: Fix driver issues with large
 lpfc_sg_seg_cnt values
Date: Wed, 17 Apr 2013 20:16:05 -0400
Message-ID: <1366244165.1513.6.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24293 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827Ab3DRAQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:16:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix driver issues with large lpfc_sg_seg_cnt values


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    3 +++
 lpfc_init.c |   31 +++++++++++++------------------
 2 files changed, 16 insertions(+), 18 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2013-04-15 18:26:26.904040890 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2013-04-15 18:26:31.051040984 -0400
@@ -48,6 +48,9 @@ struct lpfc_sli2_slim;
 		downloads using bsg */
 #define LPFC_DEFAULT_PROT_SG_SEG_CNT 4096 /* sg protection elements count */
 #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
+#define LPFC_MAX_SGL_SEG_CNT	512	/* SGL element count per scsi cmnd */
+#define LPFC_MAX_BPL_SEG_CNT	4096	/* BPL element count per scsi cmnd */
+
 #define LPFC_MAX_SGE_SIZE       0x80000000 /* Maximum data allowed in a SGE */
 #define LPFC_MAX_PROT_SG_SEG_CNT 4096	/* prot sg element count per scsi cmd*/
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:24.220040829 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:31.068040984 -0400
@@ -4739,7 +4739,7 @@ lpfc_sli_driver_resource_setup(struct lp
 			((phba->cfg_sg_seg_cnt + 2) * sizeof(struct ulp_bde64));
 
 	if (phba->cfg_enable_bg) {
-		phba->cfg_sg_seg_cnt = LPFC_MAX_SG_SEG_CNT;
+		phba->cfg_sg_seg_cnt = LPFC_MAX_BPL_SEG_CNT;
 		phba->cfg_sg_dma_buf_size +=
 			phba->cfg_prot_sg_seg_cnt * sizeof(struct ulp_bde64);
 	}
@@ -4817,7 +4817,7 @@ lpfc_sli4_driver_resource_setup(struct l
 	int rc, i, hbq_count, buf_size, dma_buf_size, max_buf_size;
 	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
 	struct lpfc_mqe *mqe;
-	int longs, sli_family;
+	int longs;
 	int sges_per_segment;
 
 	/* Before proceed, wait for POST done and device ready */
@@ -4901,6 +4901,17 @@ lpfc_sli4_driver_resource_setup(struct l
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
+
+	/*
+	 * It doesn't matter what family our adapter is in, we are
+	 * limited to 2 Pages, 512 SGEs, for our SGL.
+	 * There are going to be 2 reserved SGEs: 1 FCP cmnd + 1 FCP rsp
+	 */
+	max_buf_size = (2 * SLI4_PAGE_SIZE);
+	if (phba->cfg_sg_seg_cnt > LPFC_MAX_SGL_SEG_CNT - 2)
+		phba->cfg_sg_seg_cnt = LPFC_MAX_SGL_SEG_CNT - 2;
+	max_buf_size += (sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
+
 	/*
 	 * Since the sg_tablesize is module parameter, the sg_dma_buf_size
 	 * used to create the sg_dma_buf_pool must be dynamically calculated.
@@ -4912,22 +4923,6 @@ lpfc_sli4_driver_resource_setup(struct l
 		    (((phba->cfg_sg_seg_cnt * sges_per_segment) + 2) *
 		    sizeof(struct sli4_sge)));
 
-	sli_family = bf_get(lpfc_sli_intf_sli_family, &phba->sli4_hba.sli_intf);
-	max_buf_size = LPFC_SLI4_MAX_BUF_SIZE;
-	switch (sli_family) {
-	case LPFC_SLI_INTF_FAMILY_BE2:
-	case LPFC_SLI_INTF_FAMILY_BE3:
-		/* There is a single hint for BE - 2 pages per BPL. */
-		if (bf_get(lpfc_sli_intf_sli_hint1, &phba->sli4_hba.sli_intf) ==
-		    LPFC_SLI_INTF_SLI_HINT1_1)
-			max_buf_size = LPFC_SLI4_FL1_MAX_BUF_SIZE;
-		break;
-	case LPFC_SLI_INTF_FAMILY_LNCR_A0:
-	case LPFC_SLI_INTF_FAMILY_LNCR_B0:
-	default:
-		break;
-	}
-
 	for (dma_buf_size = LPFC_SLI4_MIN_BUF_SIZE;
 	     dma_buf_size < max_buf_size && buf_size > dma_buf_size;
 	     dma_buf_size = dma_buf_size << 1)



