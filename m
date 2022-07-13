Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D500CCA47F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 02:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiGMC4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 22:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiGMC4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 22:56:11 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539C54D161;
        Tue, 12 Jul 2022 19:56:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a15so10147110pjs.0;
        Tue, 12 Jul 2022 19:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+Zpq1dA4b/bWeDb/wHl+mZq9dvDvGdVdXynjpr6pFIQ=;
        b=mJSvvHc39MHXNzcKhSK8Tj0WjoObwFgFhapHI2zHtc3reyJQRvYhKD4SRI3Me2koTa
         6KBQoYG0PnXMtNmxZJWINC0OSkwSiUxCTGIax/6mGHO+BeRCIvA8uhFrMqjdSL7caBLd
         njvu9s6slLKiubbxUFF+h7ESZ6ZkjkCtKllh3+D+vdgzDuMzdMp3hAo5MU0uDoiGgJvZ
         zT4V7jy/OSavTd0r1SHQnQ+Hsta0BtjorE1M8oUu2WrfpUJV/XbhbSwXcyKu3PP4tmp5
         dRdNM8HHq7dQxAwzDpl+TDsashfXSz7m4YleKUjzYJ3oK8kX1subZ8iHq7FUdxdI/NTo
         xDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+Zpq1dA4b/bWeDb/wHl+mZq9dvDvGdVdXynjpr6pFIQ=;
        b=medJcToGnXSVsCLXBPXwisy8wZDWRwCCfRXaz8dyeEA/iQdVDxVB2U/aPL3cUnx4G2
         SWFVBOQ6qAytg11M4nrg3Zcjm55T8Es2BkYdpeBcOiqiSVkiO83Izl6/HANqeedjg2S8
         EhdQ7vTgVtD61K4wt9a0Pvn5Q5/Ix0vutgMoCoITgrifoi2rom/2Ah5Llm2qe+Af+BCL
         O18kiSjrEI8uKqHVe/S7dbxjqPxjTEypr/vEsp+tWM3q/tnB8uCnERe7FBgMlcPcPNnP
         7dBXD4AazrdES1yFtHAfpOJMit16wD/uk/nz2tPIvs0Y6DtGDYezpNHabG7pb8H8bEMj
         jhww==
X-Gm-Message-State: AJIora+nvcBwCWZXyBE7X8PoeQpNcyUhsddm8z9gnkoEt8LuoreTeulA
        qA/6bbxZS5Z7CdjPDBq4Fa8=
X-Google-Smtp-Source: AGRyM1uUGTq2NGSF5y4IZb/Y7ILIj1aqH0dn+3bOoyF7pOOKtieQCQnflnRoWKdjDgAlA55ql2emlQ==
X-Received: by 2002:a17:902:d591:b0:16b:a170:8586 with SMTP id k17-20020a170902d59100b0016ba1708586mr1037093plh.91.1657680970071;
        Tue, 12 Jul 2022 19:56:10 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id h131-20020a628389000000b00527bb6fff6csm7513375pfe.119.2022.07.12.19.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 19:56:09 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 799DC360403; Wed, 13 Jul 2022 14:56:05 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v3 5/5] scsi - convert mvme147.c driver to DMA API
Date:   Wed, 13 Jul 2022 14:56:01 +1200
Message-Id: <20220713025601.22584-6-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220713025601.22584-1-schmitzmic@gmail.com>
References: <20220713025601.22584-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert mvme147.c to DMA API to eliminate one of the last
usages of virt_to_bus().

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

--

Changes from v1:
- change patch index from 4 to 5 (due to insertion of m68k kmap patch)
---
 drivers/scsi/mvme147.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index ea8afeec8e56..166248bef6cf 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -21,6 +21,8 @@
 #include "wd33c93.h"
 #include "mvme147.h"
 
+#define DMA_DIR(d)   ((d == DATA_OUT_DIR) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)
+
 static irqreturn_t mvme147_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
@@ -35,10 +37,20 @@ static irqreturn_t mvme147_intr(int irq, void *data)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct scsi_pointer *scsi_pointer = WD33C93_scsi_pointer(cmd);
+	unsigned long len = scsi_pointer->this_residual;
 	struct Scsi_Host *instance = cmd->device->host;
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
 	unsigned char flags = 0x01;
-	unsigned long addr = virt_to_bus(scsi_pointer->ptr);
+	dma_addr_t addr;
+
+	addr = dma_map_single(instance->dma_dev, scsi_pointer->ptr,
+			      len, DMA_DIR(dir_in));
+	if (dma_mapping_error(instance->dma_dev, addr)) {
+		dev_warn(instance->dma_dev, "cannot map SCSI data block %p\n",
+			 scsi_pointer->ptr);
+		return 1;
+	}
+	scsi_pointer->dma_handle = addr;
 
 	/* setup dma direction */
 	if (!dir_in)
@@ -47,14 +59,6 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	/* remember direction */
 	hdata->dma_dir = dir_in;
 
-	if (dir_in) {
-		/* invalidate any cache */
-		cache_clear(addr, scsi_pointer->this_residual);
-	} else {
-		/* push any dirty cache */
-		cache_push(addr, scsi_pointer->this_residual);
-	}
-
 	/* start DMA */
 	m147_pcc->dma_bcr = scsi_pointer->this_residual | (1 << 24);
 	m147_pcc->dma_dadr = addr;
@@ -67,7 +71,13 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
+	struct scsi_pointer *scsi_pointer = WD33C93_scsi_pointer(SCpnt);
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
+
 	m147_pcc->dma_cntrl = 0;
+	dma_unmap_single(instance->dma_dev, scsi_pointer->dma_handle,
+			 scsi_pointer->this_residual,
+			 DMA_DIR(hdata->dma_dir));
 }
 
 static struct scsi_host_template mvme147_host_template = {
@@ -95,6 +105,11 @@ static int __init mvme147_scsi_probe(struct platform_device *pdev)
 	void __iomem *base;
 	int error = -ENOMEM;
 
+	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+		dev_warn(&pdev->dev, "cannot use 32 bit DMA\n");
+		return -ENODEV;
+	}
+
 	mres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mres)
 		return -ENODEV;
-- 
2.17.1

