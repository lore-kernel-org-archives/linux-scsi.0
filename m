Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D08C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 16:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhLNQgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 11:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbhLNQgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 11:36:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CACC061574
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 08:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=PIYwx1U48EUuSAusJV9isHjqwmE4M0iFyBGbuvwo+2g=; b=W4AHgNCaKuYX0FNvogchUCuCO2
        /nDljBvUag6uov4JcHAQQ6BSOjym3PqoIjNrA64Z4GmUPEBCwD3tWgLMuGhDYHXmIOcoQYhZv9yKf
        lPibNZZPbo2xFwMqKbkhsXb47Wk2haJ663fyUaOT4d9SseqZEVIcSIfn1pqnrkFB0NptqPWOA0IhB
        TR7p8iT7lLjDHO/6Q8DP3zOyo9H6zs8nLKnKvZjho60CGFd2eQfU1XSkyoYXRVFsBWROVOEFgqbel
        JYXE/pcXw2D2Y987dXQsj0Js+ir0nw/KC3ZXX2RW3Q0xb/vXcOm2/BouMjZZUQ5xAOskRkshCa9rE
        pSMxQoRQ==;
Received: from [2001:4bb8:180:a1c8:188d:f635:617b:3373] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxAmd-00Dt8p-Ct; Tue, 14 Dec 2021 16:36:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     james.smart@broadcom.com, ram.vegesna@broadcom.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] efct: don't pass GFP_DMA to dma_alloc_coherent
Date:   Tue, 14 Dec 2021 17:36:05 +0100
Message-Id: <20211214163605.416288-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dma_alloc_coherent ignores the zone specifiers, so this is pointless and
confusing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/elx/efct/efct_driver.c |  2 +-
 drivers/scsi/elx/efct/efct_hw.c     | 10 +++++-----
 drivers/scsi/elx/efct/efct_io.c     |  2 +-
 drivers/scsi/elx/libefc/efc_cmds.c  |  4 ++--
 drivers/scsi/elx/libefc/efc_els.c   |  4 ++--
 drivers/scsi/elx/libefc_sli/sli4.c  | 14 +++++++-------
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index b2b61bc45f127..ae62fc3c9ee36 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -261,7 +261,7 @@ efct_firmware_write(struct efct *efct, const u8 *buf, size_t buf_len,
 
 	dma.size = FW_WRITE_BUFSIZE;
 	dma.virt = dma_alloc_coherent(&efct->pci->dev,
-				      dma.size, &dma.phys, GFP_DMA);
+				      dma.size, &dma.phys, GFP_KERNEL);
 	if (!dma.virt)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index ba8256b4c7824..d4bb37960a3cf 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -516,7 +516,7 @@ efct_hw_setup_io(struct efct_hw *hw)
 		dma = &hw->xfer_rdy;
 		dma->size = sizeof(struct fcp_txrdy) * hw->config.n_io;
 		dma->virt = dma_alloc_coherent(&efct->pci->dev,
-					       dma->size, &dma->phys, GFP_DMA);
+					       dma->size, &dma->phys, GFP_KERNEL);
 		if (!dma->virt)
 			return -ENOMEM;
 	}
@@ -562,7 +562,7 @@ efct_hw_setup_io(struct efct_hw *hw)
 					sizeof(struct sli4_sge);
 			dma->virt = dma_alloc_coherent(&efct->pci->dev,
 						       dma->size, &dma->phys,
-						       GFP_DMA);
+						       GFP_KERNEL);
 			if (!dma->virt) {
 				efc_log_err(hw->os, "dma_alloc fail %d\n", i);
 				memset(&io->def_sgl, 0,
@@ -618,7 +618,7 @@ efct_hw_init_prereg_io(struct efct_hw *hw)
 	memset(&req, 0, sizeof(struct efc_dma));
 	req.size = 32 + sgls_per_request * 16;
 	req.virt = dma_alloc_coherent(&efct->pci->dev, req.size, &req.phys,
-				      GFP_DMA);
+				      GFP_KERNEL);
 	if (!req.virt) {
 		kfree(sgls);
 		return -ENOMEM;
@@ -1063,7 +1063,7 @@ efct_hw_init(struct efct_hw *hw)
 	dma = &hw->loop_map;
 	dma->size = SLI4_MIN_LOOP_MAP_BYTES;
 	dma->virt = dma_alloc_coherent(&hw->os->pci->dev, dma->size, &dma->phys,
-				       GFP_DMA);
+				       GFP_KERNEL);
 	if (!dma->virt)
 		return -EIO;
 
@@ -1192,7 +1192,7 @@ efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
 		prq->dma.virt = dma_alloc_coherent(&efct->pci->dev,
 						   prq->dma.size,
 						   &prq->dma.phys,
-						   GFP_DMA);
+						   GFP_KERNEL);
 		if (!prq->dma.virt) {
 			efc_log_err(hw->os, "DMA allocation failed\n");
 			kfree(rq_buf);
diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
index 71e21655916a9..c3247b951a767 100644
--- a/drivers/scsi/elx/efct/efct_io.c
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -48,7 +48,7 @@ efct_io_pool_create(struct efct *efct, u32 num_sgl)
 		io->rspbuf.size = SCSI_RSP_BUF_LENGTH;
 		io->rspbuf.virt = dma_alloc_coherent(&efct->pci->dev,
 						     io->rspbuf.size,
-						     &io->rspbuf.phys, GFP_DMA);
+						     &io->rspbuf.phys, GFP_KERNEL);
 		if (!io->rspbuf.virt) {
 			efc_log_err(efct, "dma_alloc rspbuf failed\n");
 			efct_io_pool_free(io_pool);
diff --git a/drivers/scsi/elx/libefc/efc_cmds.c b/drivers/scsi/elx/libefc/efc_cmds.c
index f8665d48904af..da4ac8a4ce12d 100644
--- a/drivers/scsi/elx/libefc/efc_cmds.c
+++ b/drivers/scsi/elx/libefc/efc_cmds.c
@@ -179,7 +179,7 @@ efc_nport_alloc_read_sparm64(struct efc *efc, struct efc_nport *nport)
 	nport->dma.size = EFC_SPARAM_DMA_SZ;
 	nport->dma.virt = dma_alloc_coherent(&efc->pci->dev,
 					     nport->dma.size, &nport->dma.phys,
-					     GFP_DMA);
+					     GFP_KERNEL);
 	if (!nport->dma.virt) {
 		efc_log_err(efc, "Failed to allocate DMA memory\n");
 		efc_nport_free_resources(nport, EFC_EVT_NPORT_ALLOC_FAIL, data);
@@ -466,7 +466,7 @@ efc_cmd_domain_alloc(struct efc *efc, struct efc_domain *domain, u32 fcf)
 	domain->dma.size = EFC_SPARAM_DMA_SZ;
 	domain->dma.virt = dma_alloc_coherent(&efc->pci->dev,
 					      domain->dma.size,
-					      &domain->dma.phys, GFP_DMA);
+					      &domain->dma.phys, GFP_KERNEL);
 	if (!domain->dma.virt) {
 		efc_log_err(efc, "Failed to allocate DMA memory\n");
 		return -EIO;
diff --git a/drivers/scsi/elx/libefc/efc_els.c b/drivers/scsi/elx/libefc/efc_els.c
index 24db0accb256e..7bb4f9aad2c80 100644
--- a/drivers/scsi/elx/libefc/efc_els.c
+++ b/drivers/scsi/elx/libefc/efc_els.c
@@ -71,7 +71,7 @@ efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen)
 	/* now allocate DMA for request and response */
 	els->io.req.size = reqlen;
 	els->io.req.virt = dma_alloc_coherent(&efc->pci->dev, els->io.req.size,
-					      &els->io.req.phys, GFP_DMA);
+					      &els->io.req.phys, GFP_KERNEL);
 	if (!els->io.req.virt) {
 		mempool_free(els, efc->els_io_pool);
 		spin_unlock_irqrestore(&node->els_ios_lock, flags);
@@ -80,7 +80,7 @@ efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen)
 
 	els->io.rsp.size = rsplen;
 	els->io.rsp.virt = dma_alloc_coherent(&efc->pci->dev, els->io.rsp.size,
-					      &els->io.rsp.phys, GFP_DMA);
+					      &els->io.rsp.phys, GFP_KERNEL);
 	if (!els->io.rsp.virt) {
 		dma_free_coherent(&efc->pci->dev, els->io.req.size,
 				  els->io.req.virt, els->io.req.phys);
diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 907d67aeac23c..3ea57bd6fb0a0 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -445,7 +445,7 @@ sli_cmd_rq_create_v2(struct sli4 *sli4, u32 num_rqs,
 
 	dma->size = payload_size;
 	dma->virt = dma_alloc_coherent(&sli4->pci->dev, dma->size,
-				       &dma->phys, GFP_DMA);
+				       &dma->phys, GFP_KERNEL);
 	if (!dma->virt)
 		return -EIO;
 
@@ -508,7 +508,7 @@ __sli_queue_init(struct sli4 *sli4, struct sli4_queue *q, u32 qtype,
 
 	q->dma.size = size * n_entries;
 	q->dma.virt = dma_alloc_coherent(&sli4->pci->dev, q->dma.size,
-					 &q->dma.phys, GFP_DMA);
+					 &q->dma.phys, GFP_KERNEL);
 	if (!q->dma.virt) {
 		memset(&q->dma, 0, sizeof(struct efc_dma));
 		efc_log_err(sli4, "%s allocation failed\n", SLI4_QNAME[qtype]);
@@ -849,7 +849,7 @@ static int sli_cmd_cq_set_create(struct sli4 *sli4,
 
 	dma->size = payload_size;
 	dma->virt = dma_alloc_coherent(&sli4->pci->dev, dma->size,
-				       &dma->phys, GFP_DMA);
+				       &dma->phys, GFP_KERNEL);
 	if (!dma->virt)
 		return -EIO;
 
@@ -4413,7 +4413,7 @@ sli_get_ctrl_attributes(struct sli4 *sli4)
 	psize = sizeof(struct sli4_rsp_cmn_get_cntl_addl_attributes);
 	data.size = psize;
 	data.virt = dma_alloc_coherent(&sli4->pci->dev, data.size,
-				       &data.phys, GFP_DMA);
+				       &data.phys, GFP_KERNEL);
 	if (!data.virt) {
 		memset(&data, 0, sizeof(struct efc_dma));
 		efc_log_err(sli4, "Failed to allocate memory for GET_CNTL_ADDL_ATTR\n");
@@ -4653,7 +4653,7 @@ sli_setup(struct sli4 *sli4, void *os, struct pci_dev  *pdev,
 	 */
 	sli4->bmbx.size = SLI4_BMBX_SIZE + sizeof(struct sli4_mcqe);
 	sli4->bmbx.virt = dma_alloc_coherent(&pdev->dev, sli4->bmbx.size,
-					     &sli4->bmbx.phys, GFP_DMA);
+					     &sli4->bmbx.phys, GFP_KERNEL);
 	if (!sli4->bmbx.virt) {
 		memset(&sli4->bmbx, 0, sizeof(struct efc_dma));
 		efc_log_err(sli4, "bootstrap mailbox allocation failed\n");
@@ -4674,7 +4674,7 @@ sli_setup(struct sli4 *sli4, void *os, struct pci_dev  *pdev,
 	sli4->vpd_data.virt = dma_alloc_coherent(&pdev->dev,
 						 sli4->vpd_data.size,
 						 &sli4->vpd_data.phys,
-						 GFP_DMA);
+						 GFP_KERNEL);
 	if (!sli4->vpd_data.virt) {
 		memset(&sli4->vpd_data, 0, sizeof(struct efc_dma));
 		/* Note that failure isn't fatal in this specific case */
@@ -5070,7 +5070,7 @@ sli_cmd_post_hdr_templates(struct sli4 *sli4, void *buf, struct efc_dma *dma,
 		payload_dma->size = payload_size;
 		payload_dma->virt = dma_alloc_coherent(&sli4->pci->dev,
 						       payload_dma->size,
-					     &payload_dma->phys, GFP_DMA);
+					     &payload_dma->phys, GFP_KERNEL);
 		if (!payload_dma->virt) {
 			memset(payload_dma, 0, sizeof(struct efc_dma));
 			efc_log_err(sli4, "mbox payload memory allocation fail\n");
-- 
2.30.2

