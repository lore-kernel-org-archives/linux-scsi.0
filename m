From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 11/13] lpfc: Work around NVME cmd iu SGL type
Date: Tue, 13 Feb 2018 11:34:55 -0800
Message-ID: <20180213193457.21206-12-jsmart2021@gmail.com>
References: <20180213193457.21206-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:42785 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965564AbeBMTfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 14:35:46 -0500
Received: by mail-qt0-f193.google.com with SMTP id l9so4693480qtj.9
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2018 11:35:46 -0800 (PST)
In-Reply-To: <20180213193457.21206-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The hardware offload for NVME commands was created when the
FC-NVME standard was setting SGL Descriptor Type to SGL Data
Block Descriptor (0h) and SGL Descriptor Sub Type to Address (0h).

A late change in NVMe-over-Fabrics obsoleted these values, creating
a transport SGL descriptor type with new values to go into these
fields.

For initial hardware support, in order to be compliant to the spec,
use host-supplied cmd IU buffers instead of the adapter generated
values. Later hardware will correct this.

Add a module parameter to override this offload disablement if looking
for lowest latency. This is reasonable as nothing in FC-NVME uses
the SQE SGL values.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v3:
  msg 6422 combined on 1 line
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 14 ++++++++++++
 drivers/scsi/lpfc/lpfc_hw4.h  |  1 +
 drivers/scsi/lpfc/lpfc_init.c |  4 ++--
 drivers/scsi/lpfc/lpfc_nvme.c | 51 ++++++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli.c  | 15 +++++++++++++
 6 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 9136a59b1c5b..6c0d351c0d0d 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -782,6 +782,7 @@ struct lpfc_hba {
 	uint32_t cfg_fcp_io_channel;
 	uint32_t cfg_suppress_rsp;
 	uint32_t cfg_nvme_oas;
+	uint32_t cfg_nvme_embed_cmd;
 	uint32_t cfg_nvme_io_channel;
 	uint32_t cfg_nvmet_mrq;
 	uint32_t cfg_enable_nvmet;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index bbed20a39b25..5afa85ade6f8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5042,6 +5042,18 @@ LPFC_ATTR_RW(nvme_oas, 0, 0, 1,
 	     "Use OAS bit on NVME IOs");
 
 /*
+ * lpfc_nvme_embed_cmd: Use the oas bit when sending NVME/NVMET IOs
+ *
+ *      0  = Put NVME Command in SGL
+ *      1  = Embed NVME Command in WQE (unless G7)
+ *      2 =  Embed NVME Command in WQE (force)
+ *
+ * Value range is [0,2]. Default value is 1.
+ */
+LPFC_ATTR_RW(nvme_embed_cmd, 1, 0, 2,
+	     "Embed NVME Command in WQE");
+
+/*
  * lpfc_fcp_io_channel: Set the number of FCP IO channels the driver
  * will advertise it supports to the SCSI layer. This also will map to
  * the number of WQs the driver will create.
@@ -5286,6 +5298,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_task_mgmt_tmo,
 	&dev_attr_lpfc_use_msi,
 	&dev_attr_lpfc_nvme_oas,
+	&dev_attr_lpfc_nvme_embed_cmd,
 	&dev_attr_lpfc_auto_imax,
 	&dev_attr_lpfc_fcp_imax,
 	&dev_attr_lpfc_fcp_cpu_map,
@@ -6310,6 +6323,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_enable_SmartSAN_init(phba, lpfc_enable_SmartSAN);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
 	lpfc_nvme_oas_init(phba, lpfc_nvme_oas);
+	lpfc_nvme_embed_cmd_init(phba, lpfc_nvme_embed_cmd);
 	lpfc_auto_imax_init(phba, lpfc_auto_imax);
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
 	lpfc_fcp_cpu_map_init(phba, lpfc_fcp_cpu_map);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index ed5e870c58c3..37c547b4bc78 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2678,6 +2678,7 @@ struct lpfc_mbx_read_rev {
 #define lpfc_mbx_rd_rev_vpd_MASK		0x00000001
 #define lpfc_mbx_rd_rev_vpd_WORD		word1
 	uint32_t first_hw_rev;
+#define LPFC_G7_ASIC_1				0xd
 	uint32_t second_hw_rev;
 	uint32_t word4_rsvd;
 	uint32_t third_hw_rev;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f8af3adee21a..476caeac201d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10652,11 +10652,11 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->fcp_embed_io = 0;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_NVME,
-			"6422 XIB %d: FCP %d %d NVME %d %d %d\n",
+			"6422 XIB %d: FCP %d %d NVME %d %d %d %d\n",
 			bf_get(cfg_xib, mbx_sli4_parameters),
 			phba->fcp_embed_pbde, phba->fcp_embed_io,
 			phba->nvme_support, phba->nvme_embed_pbde,
-			phba->cfg_suppress_rsp);
+			phba->cfg_nvme_embed_cmd, phba->cfg_suppress_rsp);
 
 	if ((bf_get(cfg_cqpsize, mbx_sli4_parameters) & LPFC_CQ_16K_PAGE_SZ) &&
 	    (bf_get(cfg_wqpsize, mbx_sli4_parameters) & LPFC_WQ_16K_PAGE_SZ) &&
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index c75958daf799..6ea6cc372647 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -617,11 +617,21 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 		       struct lpfc_nvme_buf *lpfc_ncmd,
 		       struct nvmefc_fcp_req *nCmd)
 {
+	struct lpfc_hba  *phba = vport->phba;
 	struct sli4_sge *sgl;
 	union lpfc_wqe128 *wqe;
 	uint32_t *wptr, *dptr;
 
 	/*
+	 * Get a local pointer to the built-in wqe and correct
+	 * the cmd size to match NVME's 96 bytes and fix
+	 * the dma address.
+	 */
+
+	/* 128 byte wqe support here */
+	wqe = (union lpfc_wqe128 *)&lpfc_ncmd->cur_iocbq.wqe;
+
+	/*
 	 * Adjust the FCP_CMD and FCP_RSP DMA data and sge_len to
 	 * match NVME.  NVME sends 96 bytes. Also, use the
 	 * nvme commands command and response dma addresses
@@ -630,6 +640,25 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 	 */
 	sgl = lpfc_ncmd->nvme_sgl;
 	sgl->sge_len = cpu_to_le32(nCmd->cmdlen);
+	if (phba->cfg_nvme_embed_cmd) {
+		sgl->addr_hi = 0;
+		sgl->addr_lo = 0;
+
+		/* Word 0-2 - NVME CMND IU (embedded payload) */
+		wqe->generic.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_IMMED;
+		wqe->generic.bde.tus.f.bdeSize = 56;
+		wqe->generic.bde.addrHigh = 0;
+		wqe->generic.bde.addrLow =  64;  /* Word 16 */
+	} else {
+		sgl->addr_hi = cpu_to_le32(putPaddrHigh(nCmd->cmddma));
+		sgl->addr_lo = cpu_to_le32(putPaddrLow(nCmd->cmddma));
+
+		/* Word 0-2 - NVME CMND IU Inline BDE */
+		wqe->generic.bde.tus.f.bdeFlags =  BUFF_TYPE_BDE_64;
+		wqe->generic.bde.tus.f.bdeSize = nCmd->cmdlen;
+		wqe->generic.bde.addrHigh = sgl->addr_hi;
+		wqe->generic.bde.addrLow =  sgl->addr_lo;
+	}
 
 	sgl++;
 
@@ -644,27 +673,19 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 	sgl->word2 = cpu_to_le32(sgl->word2);
 	sgl->sge_len = cpu_to_le32(nCmd->rsplen);
 
-	/*
-	 * Get a local pointer to the built-in wqe and correct
-	 * the cmd size to match NVME's 96 bytes and fix
-	 * the dma address.
-	 */
-
-	/* 128 byte wqe support here */
-	wqe = (union lpfc_wqe128 *)&lpfc_ncmd->cur_iocbq.wqe;
-
-	/* Word 0-2 - NVME CMND IU (embedded payload) */
-	wqe->generic.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_IMMED;
-	wqe->generic.bde.tus.f.bdeSize = 56;
-	wqe->generic.bde.addrHigh = 0;
-	wqe->generic.bde.addrLow =  64;  /* Word 16 */
-
 	/* Word 3 */
 	bf_set(payload_offset_len, &wqe->fcp_icmd,
 	       (nCmd->rsplen + nCmd->cmdlen));
 
 	/* Word 10 */
 	bf_set(wqe_nvme, &wqe->fcp_icmd.wqe_com, 1);
+
+	if (!phba->cfg_nvme_embed_cmd) {
+		bf_set(wqe_dbde, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_wqes, &wqe->fcp_icmd.wqe_com, 0);
+		return;
+	}
+	bf_set(wqe_dbde, &wqe->generic.wqe_com, 0);
 	bf_set(wqe_wqes, &wqe->fcp_icmd.wqe_com, 1);
 
 	/*
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8cffe52e00af..bb6e11793e36 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6885,6 +6885,18 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	/* Save information as VPD data */
 	phba->vpd.rev.biuRev = mqe->un.read_rev.first_hw_rev;
 	phba->vpd.rev.smRev = mqe->un.read_rev.second_hw_rev;
+
+	/*
+	 * This is because first G7 ASIC doesn't support the standard
+	 * 0x5a NVME cmd descriptor type/subtype
+	 */
+	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+			LPFC_SLI_INTF_IF_TYPE_6) &&
+	    (phba->vpd.rev.biuRev == LPFC_G7_ASIC_1) &&
+	    (phba->vpd.rev.smRev == 0) &&
+	    (phba->cfg_nvme_embed_cmd == 1))
+		phba->cfg_nvme_embed_cmd = 0;
+
 	phba->vpd.rev.endecRev = mqe->un.read_rev.third_hw_rev;
 	phba->vpd.rev.fcphHigh = bf_get(lpfc_mbx_rd_rev_fcph_high,
 					 &mqe->un.read_rev);
@@ -9101,6 +9113,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 			wqe128->generic.bde.addrLow =  88;  /* Word 22 */
 
 			bf_set(wqe_wqes, &wqe128->fcp_iwrite.wqe_com, 1);
+			bf_set(wqe_dbde, &wqe128->fcp_iwrite.wqe_com, 0);
 
 			/* Word 22-29  FCP CMND Payload */
 			ptr = &wqe128->words[22];
@@ -9166,6 +9179,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 			wqe128->generic.bde.addrLow =  88;  /* Word 22 */
 
 			bf_set(wqe_wqes, &wqe128->fcp_iread.wqe_com, 1);
+			bf_set(wqe_dbde, &wqe128->fcp_iread.wqe_com, 0);
 
 			/* Word 22-29  FCP CMND Payload */
 			ptr = &wqe128->words[22];
@@ -9224,6 +9238,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 			wqe128->generic.bde.addrLow =  88;  /* Word 22 */
 
 			bf_set(wqe_wqes, &wqe128->fcp_icmd.wqe_com, 1);
+			bf_set(wqe_dbde, &wqe128->fcp_icmd.wqe_com, 0);
 
 			/* Word 22-29  FCP CMND Payload */
 			ptr = &wqe128->words[22];
-- 
2.13.1
