Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A9644E038
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988592; cv=none; b=qxJpXu+hnM0dObMTI/I8sewlRfjtgoFb44FaCTbOhsDUL7ZbNDCYoIcFBFbFF65FzeL2ujz5rERaouN+ejNNUtCLldJLnPPDWHP/9Ys1Rq1zNwUQLBY1vcmyDRZ6LW0a2DxOpCtuCRYMxgyHkJtRwaoARjG5w4RsGbijXOY9eTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988592; c=relaxed/simple;
	bh=U7NM1x7MulRJwe8NkgjHIx4LE0uc7Fjg8i3+45Hilj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HHO3/kZcskl0caecGGoGrNeTFzxquhhESlnSIhaH7sLhJgQjAYtaudfGX2um1vFa7yGanHs0dZiru8ZXRXjK1BiH5oDCzfltE83F9INL6yv06h0ey9oZj/O6B+ib8grMxbVPWQv8+VzQFJMxCJcmcNqqEmwIEYHaoh1J/ZdM+U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QepepsEX; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QepepsEX"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89fc4147f2eso62871286d6.3
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988590; x=1775593390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZlk30zoXFjCQckaiahYmir+Ri0WXXwqZIZR7wUJH2k=;
        b=QepepsEXjLmNNOZLDo5Bh09VSHH2AufOIUxbzj6Q8GuMr3St6krqoE33IyBbdYyQrF
         GP5FgyozQUVjXv+ypcCqfLViWTa4ML0qJaxVP43KRgOtC4xJU3y3rCe12epv1Hx0Gdgn
         DsxGUulb8/SEljN/oNW42O908HOiaGrT8h3tieL3/Uq9eSQYEliOw+lWo3PTJS5s0dE7
         RfPiGQm/Fbs3CqAXEa7I+fnMtuV/c1XX+9fxvsnYG07IQXkvPKOlvgCoC79eZqvPszjC
         UbChs8Tfw+Aswt263q+Fa/GFAG/zHSg58yZ4xrbHmr27i9rXxD2+w874O79l+e5/8NdX
         UldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988590; x=1775593390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wZlk30zoXFjCQckaiahYmir+Ri0WXXwqZIZR7wUJH2k=;
        b=RvIiTv0TNF5xD0/I+q/HQNa8P3gvcR9su29sexiVVw++8Y10JaMZp7XYG8KzwRh18d
         tzhMa+OWHeBcM7wkpLQMvyDYUck+WyjTJyd92IEmbQlx2aAQvrvTPv9MI2l9TERkYOrC
         GVWk7zTSfabt7R0hK8V9lul6uT/nxmsPk2zjIkDZhCQahrEFA5sAbtVOtvvMOANKxeO3
         rC62tDIB728n8aHDJ9dhEmPmFaifnbku3YtCTFk6kUQR8w6AIalyLlHpuD8pQuwqErTj
         FHD9c5D4/tL4oOl8/kQ82zPzgvY1cNljCED7dwM3UtPM5gPlpsluqyjauDN5fPvMQZr5
         cltA==
X-Gm-Message-State: AOJu0Yw3dZzU1Q2ZYoQzNewnRICkW44u1OKLJR8o0tu3/CWgeBAnJGhV
	pyzHaGnaNVf0hm0bp7/opTD547+OCKKS1gkTOzsfcQ4PcES/9zyXoqRV/WMLjg==
X-Gm-Gg: ATEYQzy0OzlSCEO7tobYix58tK9vF7phS/dNUe27PAzevfOWfamsfkyah7x8ERVWjWb
	YdxhO/Ocf0L7dJ+8Gp+LUAOf+uKseVcctNxzyqQT2d9cveme1uhMSeyYT1RIOrtY/SYb0gwrUlf
	BpKhntkx2d2m2Fik1BxukVh03nyHtSRxjWWA9qgxdVg0QBjjtNLWSMKNg1l0HmjH0VeSoGAC8ha
	mwHZEIWltBRpnOmd5455jUDENlQVLQzvXWg6E8D5bgJFg8Hdej/GsbP94LVBpzBIzArSxic5xKw
	5Fq/nkaB84HTRVmVjZoqLsMB7ZDpSvQM2IwzgbZyLo8jUMKyl9s1vgk+TNgkmZwO1KQgfmhPWTw
	Fb2CGMilftlXmckEYCdM0m4b1GhS6vDIr+fzzisCwEAuTZXMkiWGVThCBvBnEJMkifaUWO3NGlc
	NHdPOet957IFEgMC4cyEhrpWZ6S6aht4audKR1qpwgLMryDszvOf4HyIFTX06jHRyh2RHf9OHcx
	LLqe+CTkdgb0qgSaMzXY8AJnLk0q4moU5sZsJKp9Mc=
X-Received: by 2002:a05:6214:5f02:b0:89c:4985:83e3 with SMTP id 6a1803df08f44-8a43ab43b79mr17909086d6.49.1774988589697;
        Tue, 31 Mar 2026 13:23:09 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:09 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/10] lpfc: Remove deprecated PBDE feature
Date: Tue, 31 Mar 2026 13:59:23 -0700
Message-Id: <20260331205928.119833-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

The PBDE feature is no longer supported and its related fields are removed
in this patch.  There are no expected side effects with regards to existing
functionality.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h       |  4 +---
 drivers/scsi/lpfc/lpfc_attr.c  |  6 ++----
 drivers/scsi/lpfc/lpfc_hw4.h   | 17 ++--------------
 drivers/scsi/lpfc/lpfc_init.c  |  9 +--------
 drivers/scsi/lpfc/lpfc_mbox.c  |  3 +--
 drivers/scsi/lpfc/lpfc_nvme.c  | 26 ------------------------
 drivers/scsi/lpfc/lpfc_nvmet.c | 37 +++++-----------------------------
 drivers/scsi/lpfc/lpfc_scsi.c  | 34 -------------------------------
 drivers/scsi/lpfc/lpfc_sli.c   | 19 ++---------------
 9 files changed, 14 insertions(+), 141 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 49ed55db1e47..022c8b1bcc24 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -1015,7 +1015,6 @@ struct lpfc_hba {
 #define LPFC_SLI3_CRP_ENABLED		0x08
 #define LPFC_SLI3_BG_ENABLED		0x20
 #define LPFC_SLI3_DSS_ENABLED		0x40
-#define LPFC_SLI4_PERFH_ENABLED		0x80
 #define LPFC_SLI4_PHWQ_ENABLED		0x100
 	uint32_t iocb_cmd_size;
 	uint32_t iocb_rsp_size;
@@ -1188,7 +1187,6 @@ struct lpfc_hba {
 	uint32_t cfg_ras_fwlog_func;
 	uint32_t cfg_enable_bbcr;	/* Enable BB Credit Recovery */
 	uint32_t cfg_enable_dpp;	/* Enable Direct Packet Push */
-	uint32_t cfg_enable_pbde;
 	uint32_t cfg_enable_mi;
 	struct nvmet_fc_target_port *targetport;
 	lpfc_vpd_t vpd;		/* vital product data */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 53f41d68e0d8..9f7df51f893d 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1,8 +1,8 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
- * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.broadcom.com                                                *
@@ -7467,8 +7467,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 
 	phba->cfg_auto_imax = (phba->cfg_fcp_imax) ? 0 : 1;
 
-	phba->cfg_enable_pbde = 0;
-
 	/* A value of 0 means use the number of CPUs found in the system */
 	if (phba->cfg_hdw_queue == 0)
 		phba->cfg_hdw_queue = phba->sli4_hba.num_present_cpu;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index c000474c3066..0e11701b0881 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1,8 +1,8 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
- * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.broadcom.com                                                *
@@ -3062,9 +3062,6 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rq_iaar_SHIFT		9
 #define lpfc_mbx_rq_ftr_rq_iaar_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rq_iaar_WORD		word2
-#define lpfc_mbx_rq_ftr_rq_perfh_SHIFT		11
-#define lpfc_mbx_rq_ftr_rq_perfh_MASK		0x00000001
-#define lpfc_mbx_rq_ftr_rq_perfh_WORD		word2
 #define lpfc_mbx_rq_ftr_rq_mrqp_SHIFT		16
 #define lpfc_mbx_rq_ftr_rq_mrqp_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rq_mrqp_WORD		word2
@@ -3096,9 +3093,6 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rsp_ifip_SHIFT		7
 #define lpfc_mbx_rq_ftr_rsp_ifip_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rsp_ifip_WORD		word3
-#define lpfc_mbx_rq_ftr_rsp_perfh_SHIFT		11
-#define lpfc_mbx_rq_ftr_rsp_perfh_MASK		0x00000001
-#define lpfc_mbx_rq_ftr_rsp_perfh_WORD		word3
 #define lpfc_mbx_rq_ftr_rsp_mrqp_SHIFT		16
 #define lpfc_mbx_rq_ftr_rsp_mrqp_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rsp_mrqp_WORD		word3
@@ -3461,10 +3455,6 @@ struct lpfc_sli4_parameters {
 #define cfg_pvl_MASK				0x00000001
 #define cfg_pvl_WORD				word19
 
-#define cfg_pbde_SHIFT				20
-#define cfg_pbde_MASK				0x00000001
-#define cfg_pbde_WORD				word19
-
 	uint32_t word20;
 #define cfg_max_tow_xri_SHIFT			0
 #define cfg_max_tow_xri_MASK			0x0000ffff
@@ -4484,9 +4474,6 @@ struct wqe_common {
 #define wqe_irsp_SHIFT        4
 #define wqe_irsp_MASK         0x00000001
 #define wqe_irsp_WORD         word11
-#define wqe_pbde_SHIFT        5
-#define wqe_pbde_MASK         0x00000001
-#define wqe_pbde_WORD         word11
 #define wqe_sup_SHIFT         6
 #define wqe_sup_MASK          0x00000001
 #define wqe_sup_WORD          word11
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index aa3917f4756a..8e5f00e6abe0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13780,12 +13780,6 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
 		phba->cfg_sg_seg_cnt = LPFC_MAX_NVME_SEG_CNT;
 
-	/* Enable embedded Payload BDE if support is indicated */
-	if (bf_get(cfg_pbde, mbx_sli4_parameters))
-		phba->cfg_enable_pbde = 1;
-	else
-		phba->cfg_enable_pbde = 0;
-
 	/*
 	 * To support Suppress Response feature we must satisfy 3 conditions.
 	 * lpfc_suppress_rsp module parameter must be set (default).
@@ -13820,9 +13814,8 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->fcp_embed_io = 0;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_NVME,
-			"6422 XIB %d PBDE %d: FCP %d NVME %d %d %d\n",
+			"6422 XIB %d: FCP %d NVME %d %d %d\n",
 			bf_get(cfg_xib, mbx_sli4_parameters),
-			phba->cfg_enable_pbde,
 			phba->fcp_embed_io, sli4_params->nvme,
 			phba->cfg_nvme_embed_cmd, phba->cfg_suppress_rsp);
 
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index d07c2786cb12..572db7348806 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -2139,7 +2139,6 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
 
 	/* Set up host requested features. */
 	bf_set(lpfc_mbx_rq_ftr_rq_fcpi, &mboxq->u.mqe.un.req_ftrs, 1);
-	bf_set(lpfc_mbx_rq_ftr_rq_perfh, &mboxq->u.mqe.un.req_ftrs, 1);
 
 	/* Enable DIF (block guard) only if configured to do so. */
 	if (phba->cfg_enable_bg)
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 74c2820c64f3..81b8fe69f2bc 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1296,8 +1296,6 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 	/* Word 10 */
 	bf_set(wqe_xchg, &wqe->fcp_iwrite.wqe_com, LPFC_NVME_XCHG);
 
-	/* Words 13 14 15 are for PBDE support */
-
 	/* add the VMID tags as per switch response */
 	if (unlikely(lpfc_ncmd->cur_iocbq.cmd_flag & LPFC_IO_VMID)) {
 		if (phba->pport->vmid_priority_tagging) {
@@ -1335,12 +1333,9 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvmeCmd;
-	union lpfc_wqe128 *wqe = &lpfc_ncmd->cur_iocbq.wqe;
 	struct sli4_sge *sgl = lpfc_ncmd->dma_sgl;
 	struct sli4_hybrid_sgl *sgl_xtra = NULL;
 	struct scatterlist *data_sg;
-	struct sli4_sge *first_data_sgl;
-	struct ulp_bde64 *bde;
 	dma_addr_t physaddr = 0;
 	uint32_t dma_len = 0;
 	uint32_t dma_offset = 0;
@@ -1361,7 +1356,6 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 		 */
 		sgl += 2;
 
-		first_data_sgl = sgl;
 		lpfc_ncmd->seg_cnt = nCmd->sg_cnt;
 		if (lpfc_ncmd->seg_cnt > lpfc_nvme_template.max_sgl_segments) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -1464,26 +1458,6 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 
 			j++;
 		}
-
-		/* PBDE support for first data SGE only */
-		if (nseg == 1 && phba->cfg_enable_pbde) {
-			/* Words 13-15 */
-			bde = (struct ulp_bde64 *)
-				&wqe->words[13];
-			bde->addrLow = first_data_sgl->addr_lo;
-			bde->addrHigh = first_data_sgl->addr_hi;
-			bde->tus.f.bdeSize =
-				le32_to_cpu(first_data_sgl->sge_len);
-			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-			bde->tus.w = cpu_to_le32(bde->tus.w);
-
-			/* Word 11 - set PBDE bit */
-			bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
-		} else {
-			memset(&wqe->words[13], 0, (sizeof(uint32_t) * 3));
-			/* Word 11 - PBDE bit disabled by default template */
-		}
-
 	} else {
 		lpfc_ncmd->seg_cnt = 0;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index debd9317103a..72f3f6f9444d 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -118,12 +118,9 @@ lpfc_nvmet_cmd_template(void)
 	bf_set(wqe_sup, &wqe->fcp_tsend.wqe_com, 0);
 	bf_set(wqe_irsp, &wqe->fcp_tsend.wqe_com, 0);
 	bf_set(wqe_irsplen, &wqe->fcp_tsend.wqe_com, 0);
-	bf_set(wqe_pbde, &wqe->fcp_tsend.wqe_com, 0);
 
 	/* Word 12 - fcp_data_len is variable */
 
-	/* Word 13, 14, 15 - PBDE is zero */
-
 	/* TRECEIVE template */
 	wqe = &lpfc_treceive_cmd_template;
 	memset(wqe, 0, sizeof(union lpfc_wqe128));
@@ -158,18 +155,15 @@ lpfc_nvmet_cmd_template(void)
 	bf_set(wqe_lenloc, &wqe->fcp_treceive.wqe_com, LPFC_WQE_LENLOC_WORD12);
 	bf_set(wqe_xc, &wqe->fcp_tsend.wqe_com, 1);
 
-	/* Word 11 - pbde is variable */
+	/* Word 11 */
 	bf_set(wqe_cmd_type, &wqe->fcp_treceive.wqe_com, FCP_COMMAND_TRECEIVE);
 	bf_set(wqe_cqid, &wqe->fcp_treceive.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
 	bf_set(wqe_sup, &wqe->fcp_treceive.wqe_com, 0);
 	bf_set(wqe_irsp, &wqe->fcp_treceive.wqe_com, 0);
 	bf_set(wqe_irsplen, &wqe->fcp_treceive.wqe_com, 0);
-	bf_set(wqe_pbde, &wqe->fcp_treceive.wqe_com, 1);
 
 	/* Word 12 - fcp_data_len is variable */
 
-	/* Word 13, 14, 15 - PBDE is variable */
-
 	/* TRSP template */
 	wqe = &lpfc_trsp_cmd_template;
 	memset(wqe, 0, sizeof(union lpfc_wqe128));
@@ -207,7 +201,6 @@ lpfc_nvmet_cmd_template(void)
 	bf_set(wqe_sup, &wqe->fcp_trsp.wqe_com, 0);
 	bf_set(wqe_irsp, &wqe->fcp_trsp.wqe_com, 0);
 	bf_set(wqe_irsplen, &wqe->fcp_trsp.wqe_com, 0);
-	bf_set(wqe_pbde, &wqe->fcp_trsp.wqe_com, 0);
 
 	/* Word 12, 13, 14, 15 - is zero */
 }
@@ -2722,7 +2715,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	struct ulp_bde64 *bde;
 	dma_addr_t physaddr;
 	int i, cnt, nsegs;
-	bool use_pbde = false;
 	int xc = 1;
 
 	if (!lpfc_is_link_up(phba)) {
@@ -2907,15 +2899,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		if (!xc)
 			bf_set(wqe_xc, &wqe->fcp_treceive.wqe_com, 0);
 
-		/* Word 11 - check for pbde */
-		if (nsegs == 1 && phba->cfg_enable_pbde) {
-			use_pbde = true;
-			/* Word 11 - PBDE bit already preset by template */
-		} else {
-			/* Overwrite default template setting */
-			bf_set(wqe_pbde, &wqe->fcp_treceive.wqe_com, 0);
-		}
-
 		/* Word 12 */
 		wqe->fcp_tsend.fcp_data_len = rsp->transfer_length;
 
@@ -3023,19 +3006,9 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	}
 
 	bde = (struct ulp_bde64 *)&wqe->words[13];
-	if (use_pbde) {
-		/* decrement sgl ptr backwards once to first data sge */
-		sgl--;
-
-		/* Words 13-15 (PBDE) */
-		bde->addrLow = sgl->addr_lo;
-		bde->addrHigh = sgl->addr_hi;
-		bde->tus.f.bdeSize = le32_to_cpu(sgl->sge_len);
-		bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-		bde->tus.w = cpu_to_le32(bde->tus.w);
-	} else {
-		memset(bde, 0, sizeof(struct ulp_bde64));
-	}
+
+	memset(bde, 0, sizeof(struct ulp_bde64));
+
 	ctxp->state = LPFC_NVME_STE_DATA;
 	ctxp->entry_cnt++;
 	return nvmewqe;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index e9d27703bc44..f11f2c29db89 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3050,7 +3050,6 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	struct scatterlist *sgel = NULL;
 	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
 	struct sli4_sge *sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
-	struct sli4_sge *first_data_sgl;
 	struct lpfc_iocbq *pwqeq = &lpfc_cmd->cur_iocbq;
 	struct lpfc_vport *vport = phba->pport;
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
@@ -3058,7 +3057,6 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
 	int nseg, i, j;
-	struct ulp_bde64 *bde;
 	bool lsp_just_set = false;
 	struct sli4_hybrid_sgl *sgl_xtra = NULL;
 
@@ -3085,7 +3083,6 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		bf_set(lpfc_sli4_sge_last, sgl, 0);
 		sgl->word2 = cpu_to_le32(sgl->word2);
 		sgl += 1;
-		first_data_sgl = sgl;
 		lpfc_cmd->seg_cnt = nseg;
 		if (!phba->cfg_xpsgl &&
 		    lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
@@ -3185,43 +3182,12 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 			j++;
 		}
-
-		/* PBDE support for first data SGE only.
-		 * For FCoE, we key off Performance Hints.
-		 * For FC, we key off lpfc_enable_pbde.
-		 */
-		if (nseg == 1 &&
-		    ((phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) ||
-		     phba->cfg_enable_pbde)) {
-			/* Words 13-15 */
-			bde = (struct ulp_bde64 *)
-				&wqe->words[13];
-			bde->addrLow = first_data_sgl->addr_lo;
-			bde->addrHigh = first_data_sgl->addr_hi;
-			bde->tus.f.bdeSize =
-					le32_to_cpu(first_data_sgl->sge_len);
-			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-			bde->tus.w = cpu_to_le32(bde->tus.w);
-
-			/* Word 11 - set PBDE bit */
-			bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
-		} else {
-			memset(&wqe->words[13], 0, (sizeof(uint32_t) * 3));
-			/* Word 11 - PBDE bit disabled by default template */
-		}
 	} else {
 		sgl += 1;
 		/* set the last flag in the fcp_rsp map entry */
 		sgl->word2 = le32_to_cpu(sgl->word2);
 		bf_set(lpfc_sli4_sge_last, sgl, 1);
 		sgl->word2 = cpu_to_le32(sgl->word2);
-
-		if ((phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) ||
-		    phba->cfg_enable_pbde) {
-			bde = (struct ulp_bde64 *)
-				&wqe->words[13];
-			memset(bde, 0, (sizeof(uint32_t) * 3));
-		}
 	}
 
 	/*
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b32a1870eec2..41a73ffd34e1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -136,15 +136,12 @@ void lpfc_wqe_cmd_template(void)
 	bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 0);
 	bf_set(wqe_wqes, &wqe->fcp_iread.wqe_com, 1);
 
-	/* Word 11 - pbde is variable */
+	/* Word 11 */
 	bf_set(wqe_cmd_type, &wqe->fcp_iread.wqe_com, COMMAND_DATA_IN);
 	bf_set(wqe_cqid, &wqe->fcp_iread.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-	bf_set(wqe_pbde, &wqe->fcp_iread.wqe_com, 0);
 
 	/* Word 12 - is zero */
 
-	/* Word 13, 14, 15 - PBDE is variable */
-
 	/* IWRITE template */
 	wqe = &lpfc_iwrite_cmd_template;
 	memset(wqe, 0, sizeof(union lpfc_wqe128));
@@ -176,15 +173,12 @@ void lpfc_wqe_cmd_template(void)
 	bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 0);
 	bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
 
-	/* Word 11 - pbde is variable */
+	/* Word 11 */
 	bf_set(wqe_cmd_type, &wqe->fcp_iwrite.wqe_com, COMMAND_DATA_OUT);
 	bf_set(wqe_cqid, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-	bf_set(wqe_pbde, &wqe->fcp_iwrite.wqe_com, 0);
 
 	/* Word 12 - is zero */
 
-	/* Word 13, 14, 15 - PBDE is variable */
-
 	/* ICMND template */
 	wqe = &lpfc_icmnd_cmd_template;
 	memset(wqe, 0, sizeof(union lpfc_wqe128));
@@ -217,7 +211,6 @@ void lpfc_wqe_cmd_template(void)
 	/* Word 11 */
 	bf_set(wqe_cmd_type, &wqe->fcp_icmd.wqe_com, COMMAND_DATA_IN);
 	bf_set(wqe_cqid, &wqe->fcp_icmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-	bf_set(wqe_pbde, &wqe->fcp_icmd.wqe_com, 0);
 
 	/* Word 12, 13, 14, 15 - is zero */
 }
@@ -8732,14 +8725,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		ftr_rsp++;
 	}
 
-	/* Performance Hints are ONLY for FCoE */
-	if (test_bit(HBA_FCOE_MODE, &phba->hba_flag)) {
-		if (bf_get(lpfc_mbx_rq_ftr_rsp_perfh, &mqe->un.req_ftrs))
-			phba->sli3_options |= LPFC_SLI4_PERFH_ENABLED;
-		else
-			phba->sli3_options &= ~LPFC_SLI4_PERFH_ENABLED;
-	}
-
 	/*
 	 * If the port cannot support the host's requested features
 	 * then turn off the global config parameters to disable the
-- 
2.38.0

