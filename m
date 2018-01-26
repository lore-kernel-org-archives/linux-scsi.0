From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 09/13] lpfc: Add embedded data pointers for enhanced performance
Date: Fri, 26 Jan 2018 11:31:09 -0800
Message-ID: <20180126193113.29610-10-jsmart2021@gmail.com>
References: <20180126193113.29610-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36357 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753108AbeAZTbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:31:37 -0500
Received: by mail-qt0-f194.google.com with SMTP id z11so4061556qtm.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:31:37 -0800 (PST)
In-Reply-To: <20180126193113.29610-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The current driver isn't taking advantage of a performance hint whereby
the initial data buffer descriptor can be placed in the WQE as well as
the SGL.

Add the logic to detect support for the feature and to use it when
supported.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h       |  2 ++
 drivers/scsi/lpfc/lpfc_hw4.h   |  3 +++
 drivers/scsi/lpfc/lpfc_init.c  | 21 +++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvme.c  | 18 ++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.c | 24 ++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_scsi.c  |  8 ++++++--
 drivers/scsi/lpfc/lpfc_sli.c   | 25 +++++++++++++++++++++----
 7 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 7aad4a717f13..9136a59b1c5b 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -840,6 +840,8 @@ struct lpfc_hba {
 #define LPFC_ENABLE_FCP  1
 #define LPFC_ENABLE_NVME 2
 #define LPFC_ENABLE_BOTH 3
+	uint32_t nvme_embed_pbde;
+	uint32_t fcp_embed_pbde;
 	uint32_t io_channel_irqs;	/* number of irqs for io channels */
 	struct nvmet_fc_target_port *targetport;
 	lpfc_vpd_t vpd;		/* vital product data */
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index be8227dfa086..ed5e870c58c3 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4226,6 +4226,9 @@ struct wqe_common {
 #define wqe_irsp_SHIFT        4
 #define wqe_irsp_MASK         0x00000001
 #define wqe_irsp_WORD         word11
+#define wqe_pbde_SHIFT        5
+#define wqe_pbde_MASK         0x00000001
+#define wqe_pbde_WORD         word11
 #define wqe_sup_SHIFT         6
 #define wqe_sup_MASK          0x00000001
 #define wqe_sup_WORD          word11
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0e05f802bfaa..b04fd30e9de0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10605,6 +10605,19 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->cfg_enable_fc4_type = LPFC_ENABLE_FCP;
 	}
 
+	/* Only embed PBDE for if_type 6 */
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	    LPFC_SLI_INTF_IF_TYPE_6) {
+		phba->fcp_embed_pbde = 1;
+		phba->nvme_embed_pbde = 1;
+	}
+
+	/* PBDE support requires xib be set */
+	if (!bf_get(cfg_xib, mbx_sli4_parameters)) {
+		phba->fcp_embed_pbde = 0;
+		phba->nvme_embed_pbde = 0;
+	}
+
 	/*
 	 * To support Suppress Response feature we must satisfy 3 conditions.
 	 * lpfc_suppress_rsp module parameter must be set (default).
@@ -10636,6 +10649,14 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	else
 		phba->fcp_embed_io = 0;
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_NVME,
+			"6422 XIB %d: FCP %d %d "
+			"NVME %d %d %d\n",
+			bf_get(cfg_xib, mbx_sli4_parameters),
+			phba->fcp_embed_pbde, phba->fcp_embed_io,
+			phba->nvme_support, phba->nvme_embed_pbde,
+			phba->cfg_suppress_rsp);
+
 	if ((bf_get(cfg_cqpsize, mbx_sli4_parameters) & LPFC_CQ_16K_PAGE_SZ) &&
 	    (bf_get(cfg_wqpsize, mbx_sli4_parameters) & LPFC_WQ_16K_PAGE_SZ) &&
 	    (sli4_params->wqsize & LPFC_WQ_SZ128_SUPPORT))
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 527e63c1f1ac..63e2d64da68f 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1167,6 +1167,7 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 	struct sli4_sge *sgl = lpfc_ncmd->nvme_sgl;
 	struct scatterlist *data_sg;
 	struct sli4_sge *first_data_sgl;
+	struct ulp_bde64 *bde;
 	dma_addr_t physaddr;
 	uint32_t num_bde = 0;
 	uint32_t dma_len;
@@ -1234,7 +1235,24 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 			data_sg = sg_next(data_sg);
 			sgl++;
 		}
+		if (phba->nvme_embed_pbde) {
+			/* Use PBDE support for first SGL only, offset == 0 */
+			/* Words 13-15 */
+			bde = (struct ulp_bde64 *)
+				&wqe->words[13];
+			bde->addrLow = first_data_sgl->addr_lo;
+			bde->addrHigh = first_data_sgl->addr_hi;
+			bde->tus.f.bdeSize =
+				le32_to_cpu(first_data_sgl->sge_len);
+			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+			bde->tus.w = cpu_to_le32(bde->tus.w);
+			bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
+		} else
+			bf_set(wqe_pbde, &wqe->generic.wqe_com, 0);
+
 	} else {
+		bf_set(wqe_pbde, &wqe->generic.wqe_com, 0);
+
 		/* For this clause to be valid, the payload_length
 		 * and sg_cnt must zero.
 		 */
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index a332a6638b1b..f025933397cf 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2150,9 +2150,11 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	struct lpfc_iocbq *nvmewqe;
 	struct scatterlist *sgel;
 	union lpfc_wqe128 *wqe;
+	struct ulp_bde64 *bde;
 	uint32_t *txrdy;
 	dma_addr_t physaddr;
 	int i, cnt;
+	int do_pbde;
 	int xc = 1;
 
 	if (!lpfc_is_link_up(phba)) {
@@ -2243,6 +2245,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		/* Word 7 */
 		bf_set(wqe_pu, &wqe->fcp_tsend.wqe_com, 1);
 		bf_set(wqe_cmnd, &wqe->fcp_tsend.wqe_com, CMD_FCP_TSEND64_WQE);
+		do_pbde = 0;
 
 		/* Word 8 */
 		wqe->fcp_tsend.wqe_com.abort_tag = nvmewqe->iotag;
@@ -2355,6 +2358,10 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		bf_set(wqe_ar, &wqe->fcp_treceive.wqe_com, 0);
 		bf_set(wqe_cmnd, &wqe->fcp_treceive.wqe_com,
 		       CMD_FCP_TRECEIVE64_WQE);
+		if (phba->nvme_embed_pbde)
+			do_pbde = 1;
+		else
+			do_pbde = 0;
 
 		/* Word 8 */
 		wqe->fcp_treceive.wqe_com.abort_tag = nvmewqe->iotag;
@@ -2438,6 +2445,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		bf_set(wqe_pu, &wqe->fcp_trsp.wqe_com, 0);
 		bf_set(wqe_ag, &wqe->fcp_trsp.wqe_com, 1);
 		bf_set(wqe_cmnd, &wqe->fcp_trsp.wqe_com, CMD_FCP_TRSP64_WQE);
+		do_pbde = 0;
 
 		/* Word 8 */
 		wqe->fcp_trsp.wqe_com.abort_tag = nvmewqe->iotag;
@@ -2508,9 +2516,25 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 			bf_set(lpfc_sli4_sge_last, sgl, 1);
 		sgl->word2 = cpu_to_le32(sgl->word2);
 		sgl->sge_len = cpu_to_le32(cnt);
+		if (do_pbde && (i == 0)) {
+			bde = (struct ulp_bde64 *)&wqe->words[13];
+			memset(bde, 0, sizeof(struct ulp_bde64));
+			/* Words 13-15  (PBDE)*/
+			bde->addrLow = sgl->addr_lo;
+			bde->addrHigh = sgl->addr_hi;
+			bde->tus.f.bdeSize =
+				le32_to_cpu(sgl->sge_len);
+			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+			bde->tus.w = cpu_to_le32(bde->tus.w);
+		}
 		sgl++;
 		ctxp->offset += cnt;
 	}
+
+	if (do_pbde)
+		bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
+	else
+		bf_set(wqe_pbde, &wqe->generic.wqe_com, 0);
 	ctxp->state = LPFC_NVMET_STE_DATA;
 	ctxp->entry_cnt++;
 	return nvmewqe;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c595046a521b..fb81e8a8fb1c 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3304,8 +3304,12 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 			dma_offset += dma_len;
 			sgl++;
 		}
-		/* setup the performance hint (first data BDE) if enabled */
-		if (phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) {
+		/*
+		 * Setup the first Payload BDE. For FCoE we just key off
+		 * Performance Hints, for FC we utilize fcp_embed_pbde.
+		 */
+		if ((phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) ||
+		    phba->fcp_embed_pbde) {
 			bde = (struct ulp_bde64 *)
 					&(iocb_cmd->unsli3.sli3Words[5]);
 			bde->addrLow = first_data_sgl->addr_lo;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 01691a5351bd..3b92dfb2ee33 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6963,10 +6963,15 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0378 No support for fcpi mode.\n");
 		ftr_rsp++;
 	}
-	if (bf_get(lpfc_mbx_rq_ftr_rsp_perfh, &mqe->un.req_ftrs))
-		phba->sli3_options |= LPFC_SLI4_PERFH_ENABLED;
-	else
-		phba->sli3_options &= ~LPFC_SLI4_PERFH_ENABLED;
+
+	/* Performance Hints are ONLY for FCoE */
+	if (phba->hba_flag & HBA_FCOE_MODE) {
+		if (bf_get(lpfc_mbx_rq_ftr_rsp_perfh, &mqe->un.req_ftrs))
+			phba->sli3_options |= LPFC_SLI4_PERFH_ENABLED;
+		else
+			phba->sli3_options &= ~LPFC_SLI4_PERFH_ENABLED;
+	}
+
 	/*
 	 * If the port cannot support the host's requested features
 	 * then turn off the global config parameters to disable the
@@ -9068,6 +9073,12 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		}
 		/* Note, word 10 is already initialized to 0 */
 
+		/* Don't set PBDE for Perf hints, just fcp_embed_pbde */
+		if (phba->fcp_embed_pbde)
+			bf_set(wqe_pbde, &wqe->fcp_iwrite.wqe_com, 1);
+		else
+			bf_set(wqe_pbde, &wqe->fcp_iwrite.wqe_com, 0);
+
 		if (phba->fcp_embed_io) {
 			struct lpfc_scsi_buf *lpfc_cmd;
 			struct sli4_sge *sgl;
@@ -9127,6 +9138,12 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		}
 		/* Note, word 10 is already initialized to 0 */
 
+		/* Don't set PBDE for Perf hints, just fcp_embed_pbde */
+		if (phba->fcp_embed_pbde)
+			bf_set(wqe_pbde, &wqe->fcp_iread.wqe_com, 1);
+		else
+			bf_set(wqe_pbde, &wqe->fcp_iread.wqe_com, 0);
+
 		if (phba->fcp_embed_io) {
 			struct lpfc_scsi_buf *lpfc_cmd;
 			struct sli4_sge *sgl;
-- 
2.13.1
