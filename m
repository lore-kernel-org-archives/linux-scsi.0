Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A64CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01EA32089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPG+DH7Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503005AbfJRVTL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46610 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502466AbfJRVTL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id q5so4597744pfg.13
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PWePyu3jDzuZFkepSgwGeYcC56ZhwucM0rHR8ngLa4s=;
        b=PPG+DH7QWPeVltGAcQt2Cw8V8sTMJWKUCzjx5GVyBYVioLH/Va1GHQAQXDvDg50dg/
         UTVJGLQABCmzanyrP5f1ehDLIXVO2ycRrq1Oo4RzQMSkwnfvGSh7cjL8jbDWQkPy1c1/
         JshisXBMOMvLn8NlWnFZUaKLrdPARQkJo4sTLvBGjMkN+lvIEWoIeRO1+KcOzNHjQqzW
         tT4tX7jgwW8CH7ij0mjjwrscHweSLDtbKzG/MD/OWhNxRzX7dMrmVztbHzIRcHwAcwop
         LLyqjoLGp5tL0C2OS5+xBtF4wCa0XhdEl+pGntQBrloZOubiStbkU0enQHkUgqc1Xoqy
         3fKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PWePyu3jDzuZFkepSgwGeYcC56ZhwucM0rHR8ngLa4s=;
        b=hkpaQ1caL/fRT+/jioGlT2zt/9jc3SrWQbcZo9L983WJdnOXfq+fGdvtyr38SHi1zl
         f4ju2dugXmCApBMQBK59NIEPhT6i6Ng+iTSUByXb4UNhtmk+MBrY5gUg1lu7w4A6WxRl
         cq0GbSvBX/2j+GnJ/1KnOImRO9VNA9ys5IZPR6Ehg/mWbyPRsxOHy/1r83+gYc3I9tIl
         dYPYn5HAmy1KVY2U+0Wtt7jqHTC9wlLQUjPJUgjbncTafpd+uNwJOaDhYSJSVMKCMpF0
         6bCBTmOdrl0ePdMNlxW6S0EN2/j3Lg84Pz7UDBeKOaX4D2Ng+8N7gAWulDkyfQtXtLVW
         9KQQ==
X-Gm-Message-State: APjAAAWVhQ7v5773bgarv6tmCiCEKMuvBuU3f2qDwfnDXu+leTCElyvZ
        QkuC7l32FtfVLZE2jPq/Pycd4OaH
X-Google-Smtp-Source: APXvYqzo2BILqW+X3RX3DvR9PRSYOhnPkRMVNgs2NcUb63gun76TLZpNXOxmlwA0EOJbYCcmHcrcmg==
X-Received: by 2002:a65:464b:: with SMTP id k11mr12495296pgr.263.1571433548948;
        Fri, 18 Oct 2019 14:19:08 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:08 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/16] lpfc: Remove lock contention target write path
Date:   Fri, 18 Oct 2019 14:18:25 -0700
Message-Id: <20191018211832.7917-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Lower IOps performance with write operations. Perf tool shows
lock contention in dma_pool_alloc and dma_pool_free related to
the txrdy_payload_pool.

The allocations are for dma buffers for XFER_RDY's, which actually
are not needed for the FCP_TRECEIVE command as the command contents
are used by the adapter to generate the IU.

Remove the allocations and the associated buffer pool.
Rather than leaving NULLs in buffer pointer locations, set command
and sgl to indicate skipped SGLE indexes.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h       |  1 -
 drivers/scsi/lpfc/lpfc_init.c  | 16 ++++-----------
 drivers/scsi/lpfc/lpfc_mem.c   |  3 ---
 drivers/scsi/lpfc/lpfc_nvmet.c | 46 +++++++++---------------------------------
 drivers/scsi/lpfc/lpfc_nvmet.h |  2 --
 5 files changed, 14 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 291335e16806..dabb5eac5fed 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -989,7 +989,6 @@ struct lpfc_hba {
 	struct dma_pool *lpfc_drb_pool; /* data receive buffer pool */
 	struct dma_pool *lpfc_nvmet_drb_pool; /* data receive buffer pool */
 	struct dma_pool *lpfc_hbq_pool;	/* SLI3 hbq buffer pool */
-	struct dma_pool *txrdy_payload_pool;
 	struct dma_pool *lpfc_cmd_rsp_buf_pool;
 	struct lpfc_dma_pool lpfc_mbuf_safety_pool;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1d14aa22f973..8292b66e4b07 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7556,18 +7556,10 @@ lpfc_create_shost(struct lpfc_hba *phba)
 
 	if (phba->nvmet_support) {
 		/* Only 1 vport (pport) will support NVME target */
-		if (phba->txrdy_payload_pool == NULL) {
-			phba->txrdy_payload_pool = dma_pool_create(
-				"txrdy_pool", &phba->pcidev->dev,
-				TXRDY_PAYLOAD_LEN, 16, 0);
-			if (phba->txrdy_payload_pool) {
-				phba->targetport = NULL;
-				phba->cfg_enable_fc4_type = LPFC_ENABLE_NVME;
-				lpfc_printf_log(phba, KERN_INFO,
-						LOG_INIT | LOG_NVME_DISC,
-						"6076 NVME Target Found\n");
-			}
-		}
+		phba->targetport = NULL;
+		phba->cfg_enable_fc4_type = LPFC_ENABLE_NVME;
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT | LOG_NVME_DISC,
+				"6076 NVME Target Found\n");
 	}
 
 	lpfc_debugfs_initialize(vport);
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index ae09bb863497..7082279e4c01 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -230,9 +230,6 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	dma_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
 
-	dma_pool_destroy(phba->txrdy_payload_pool);
-	phba->txrdy_payload_pool = NULL;
-
 	dma_pool_destroy(phba->lpfc_hbq_pool);
 	phba->lpfc_hbq_pool = NULL;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index c9481a618b85..e3ac9059d33d 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -378,13 +378,6 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 	int cpu;
 	unsigned long iflag;
 
-	if (ctxp->txrdy) {
-		dma_pool_free(phba->txrdy_payload_pool, ctxp->txrdy,
-			      ctxp->txrdy_phys);
-		ctxp->txrdy = NULL;
-		ctxp->txrdy_phys = 0;
-	}
-
 	if (ctxp->state == LPFC_NVMET_STE_FREE) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 				"6411 NVMET free, already free IO x%x: %d %d\n",
@@ -430,7 +423,6 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 
 		ctxp = (struct lpfc_nvmet_rcv_ctx *)ctx_buf->context;
 		ctxp->wqeq = NULL;
-		ctxp->txrdy = NULL;
 		ctxp->offset = 0;
 		ctxp->phba = phba;
 		ctxp->size = size;
@@ -2327,7 +2319,6 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 				ctxp->state, ctxp->entry_cnt, ctxp->oxid);
 	}
 	ctxp->wqeq = NULL;
-	ctxp->txrdy = NULL;
 	ctxp->offset = 0;
 	ctxp->phba = phba;
 	ctxp->size = size;
@@ -2606,7 +2597,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	struct scatterlist *sgel;
 	union lpfc_wqe128 *wqe;
 	struct ulp_bde64 *bde;
-	uint32_t *txrdy;
 	dma_addr_t physaddr;
 	int i, cnt;
 	int do_pbde;
@@ -2768,23 +2758,11 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		       &lpfc_treceive_cmd_template.words[3],
 		       sizeof(uint32_t) * 9);
 
-		/* Words 0 - 2 : The first sg segment */
-		txrdy = dma_pool_alloc(phba->txrdy_payload_pool,
-				       GFP_KERNEL, &physaddr);
-		if (!txrdy) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-					"6041 Bad txrdy buffer: oxid x%x\n",
-					ctxp->oxid);
-			return NULL;
-		}
-		ctxp->txrdy = txrdy;
-		ctxp->txrdy_phys = physaddr;
-		wqe->fcp_treceive.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-		wqe->fcp_treceive.bde.tus.f.bdeSize = TXRDY_PAYLOAD_LEN;
-		wqe->fcp_treceive.bde.addrLow =
-			cpu_to_le32(putPaddrLow(physaddr));
-		wqe->fcp_treceive.bde.addrHigh =
-			cpu_to_le32(putPaddrHigh(physaddr));
+		/* Words 0 - 2 : First SGE is skipped, set invalid BDE type */
+		wqe->fcp_treceive.bde.tus.f.bdeFlags = LPFC_SGE_TYPE_SKIP;
+		wqe->fcp_treceive.bde.tus.f.bdeSize = 0;
+		wqe->fcp_treceive.bde.addrLow = 0;
+		wqe->fcp_treceive.bde.addrHigh = 0;
 
 		/* Word 4 */
 		wqe->fcp_treceive.relative_offset = ctxp->offset;
@@ -2819,17 +2797,13 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		/* Word 12 */
 		wqe->fcp_tsend.fcp_data_len = rsp->transfer_length;
 
-		/* Setup 1 TXRDY and 1 SKIP SGE */
-		txrdy[0] = 0;
-		txrdy[1] = cpu_to_be32(rsp->transfer_length);
-		txrdy[2] = 0;
-
-		sgl->addr_hi = putPaddrHigh(physaddr);
-		sgl->addr_lo = putPaddrLow(physaddr);
+		/* Setup 2 SKIP SGEs */
+		sgl->addr_hi = 0;
+		sgl->addr_lo = 0;
 		sgl->word2 = 0;
-		bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_DATA);
+		bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_SKIP);
 		sgl->word2 = cpu_to_le32(sgl->word2);
-		sgl->sge_len = cpu_to_le32(TXRDY_PAYLOAD_LEN);
+		sgl->sge_len = 0;
 		sgl++;
 		sgl->addr_hi = 0;
 		sgl->addr_lo = 0;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 8ff67deac10a..b80b1639b9a7 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -112,9 +112,7 @@ struct lpfc_nvmet_rcv_ctx {
 	struct lpfc_hba *phba;
 	struct lpfc_iocbq *wqeq;
 	struct lpfc_iocbq *abort_wqeq;
-	dma_addr_t txrdy_phys;
 	spinlock_t ctxlock; /* protect flag access */
-	uint32_t *txrdy;
 	uint32_t sid;
 	uint32_t offset;
 	uint16_t oxid;
-- 
2.13.7

