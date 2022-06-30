Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64553CCA47C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 03:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiF3DdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 23:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiF3DdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 23:33:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D229FA1A9;
        Wed, 29 Jun 2022 20:33:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id dw10-20020a17090b094a00b001ed00a16eb4so1458117pjb.2;
        Wed, 29 Jun 2022 20:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vOJrtNX7zV+BQMnayEjDmdMhZC7vvHeg4mWPXofA1A4=;
        b=KPTBiih0VvlVzBOyAk/yJOzsDKgIeN4oRf3i8bEfe9y6+flywbOQLwAwaJaNjq1z2e
         wrrrt/I9cQ68VgHvwzVOtaHAPHYz/H+TrQk2nYHG89GYPCde8TbNd4j6h2IuRLMnM83t
         a+9aKiJ28Kj0ZMzcKo+c8ZIDIfhpEckfVNb0q5TP26FZygz5RPqEolUjRJH1CFdd66dW
         vhQ56+i2auaT+4/JXNM3Pe/DsuLWDPSGiPCR24QZ5RPSa9rvZDkGRwQdWQwtnnV62e37
         syYfv6ZQkk2yU3wFQ8mfxCz5u9Qz+pVma7AHPhHB+lpnxnLyfzJBYZPfYjH3cO0+BIqf
         n6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vOJrtNX7zV+BQMnayEjDmdMhZC7vvHeg4mWPXofA1A4=;
        b=vvVAmyiM6v/5yv05kJuYB+ofyGzK5uJ2FqPro7vNzFJn8urLtpO6FtKFy/8njMnS4B
         TYOO3r/tcrWMimwE5C0F7NEtyNUERPG7RRTiaWNdaLWPlx/xswOOarILjufa4qg/YNR0
         pQwa68oA52RYdhsRS6QYQWXHa+N+2is4O8XwNPo2th4HwlhxvHWpkT8mRrNMSk0TswV0
         ZUjrsRdl47NcsRvk7GfG+Tn5+0RZRgRaee8JDxYibep+6B0qFzhhU3ppfa0oebgjp/ep
         2kSYM+beqndoI9mJU/Yq5kzJLMFciBtwmKG3sCWJCBENp/1LAAm25WhGDKNt6IqAirab
         RN4A==
X-Gm-Message-State: AJIora/tNmLIADVldPEuD8b5qTADXivjQ9Iiv+6uqzvyxiU/axqHiTQG
        gDyTIvYq4T7vqYIwoCoECcY=
X-Google-Smtp-Source: AGRyM1syC4mVcx509djcmKUhU8+XkZFZX/Cl0PRSAnRnk8SFdBLmN7kRR9zgO9GMXsQ1svnYyoRtVw==
X-Received: by 2002:a17:90b:3e86:b0:1ec:fc46:9e05 with SMTP id rj6-20020a17090b3e8600b001ecfc469e05mr7781278pjb.0.1656559989248;
        Wed, 29 Jun 2022 20:33:09 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id h15-20020a170902680f00b00161e50e2245sm12090526plk.178.2022.06.29.20.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 20:33:08 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 730C5360332; Thu, 30 Jun 2022 15:33:05 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v2 1/3] scsi - a3000.c: convert m68k WD33C93 drivers to DMA API
Date:   Thu, 30 Jun 2022 15:33:00 +1200
Message-Id: <20220630033302.3183-2-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630033302.3183-1-schmitzmic@gmail.com>
References: <20220630033302.3183-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use dma_map_single() for a3000 driver (leave bounce buffer
logic unchanged).

Use dma_set_mask_and_coherent() to avoid explicit cache
flushes.

Compile-tested only.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

--

Changes from v1:

- restore bounce buffer allocation (dropped in v1)

Arnd Bergmann:
- reorder dma mapping and bounce buffer copy
---
 drivers/scsi/a3000.c | 53 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index dd161885eed1..2c5cb1a02e86 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 
 #include <asm/page.h>
@@ -25,8 +26,11 @@
 struct a3000_hostdata {
 	struct WD33C93_hostdata wh;
 	struct a3000_scsiregs *regs;
+	struct device *dev;
 };
 
+#define DMA_DIR(d)   ((d == DATA_OUT_DIR) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)
+
 static irqreturn_t a3000_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
@@ -49,20 +53,38 @@ static irqreturn_t a3000_intr(int irq, void *data)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct scsi_pointer *scsi_pointer = WD33C93_scsi_pointer(cmd);
+	unsigned long len = scsi_pointer->this_residual;
 	struct Scsi_Host *instance = cmd->device->host;
 	struct a3000_hostdata *hdata = shost_priv(instance);
 	struct WD33C93_hostdata *wh = &hdata->wh;
 	struct a3000_scsiregs *regs = hdata->regs;
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
-	unsigned long addr = virt_to_bus(scsi_pointer->ptr);
+	dma_addr_t addr;
+
+	addr = dma_map_single(hdata->dev, scsi_pointer->ptr,
+			      len, DMA_DIR(dir_in));
+	if (dma_mapping_error(hdata->dev, addr)) {
+		dev_warn(hdata->dev, "cannot map SCSI data block %p\n",
+			 scsi_pointer->ptr);
+		return 1;
+	}
+	scsi_pointer->dma_handle = addr;
 
 	/*
 	 * if the physical address has the wrong alignment, or if
 	 * physical address is bad, or if it is a write and at the
 	 * end of a physical memory chunk, then allocate a bounce
 	 * buffer
+	 * MSch 20220629 - only wrong alignment tested - bounce
+	 * buffer returned by kmalloc is guaranteed to be aligned
 	 */
 	if (addr & A3000_XFER_MASK) {
+		WARN_ONCE(1, "Invalid alignment for DMA!");
+		/* drop useless mapping */
+		dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+				 scsi_pointer->this_residual,
+				 DMA_DIR(dir_in));
+
 		wh->dma_bounce_len = (scsi_pointer->this_residual + 511) & ~0x1ff;
 		wh->dma_bounce_buffer = kmalloc(wh->dma_bounce_len,
 						GFP_KERNEL);
@@ -70,6 +92,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		/* can't allocate memory; use PIO */
 		if (!wh->dma_bounce_buffer) {
 			wh->dma_bounce_len = 0;
+			scsi_pointer->dma_handle = (dma_addr_t) NULL;
 			return 1;
 		}
 
@@ -79,7 +102,15 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 			       scsi_pointer->this_residual);
 		}
 
-		addr = virt_to_bus(wh->dma_bounce_buffer);
+		addr = dma_map_single(hdata->dev, scsi_pointer->ptr,
+				      len, DMA_DIR(dir_in));
+		if (dma_mapping_error(hdata->dev, addr)) {
+			dev_warn(hdata->dev,
+				 "cannot map SCSI data block %p\n",
+				 scsi_pointer->ptr);
+			return 1;
+		}
+		scsi_pointer->dma_handle = addr;
 	}
 
 	/* setup dma direction */
@@ -94,13 +125,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	/* setup DMA *physical* address */
 	regs->ACR = addr;
 
-	if (dir_in) {
-		/* invalidate any cache */
-		cache_clear(addr, scsi_pointer->this_residual);
-	} else {
-		/* push any dirty cache */
-		cache_push(addr, scsi_pointer->this_residual);
-	}
+	/* no more cache flush here - dma_map_single() takes care */
 
 	/* start DMA */
 	mb();			/* make sure setup is completed */
@@ -151,6 +176,10 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 	mb();			/* make sure CNTR is updated before next IO */
 
+	dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+			 scsi_pointer->this_residual,
+			 DMA_DIR(wh->dma_dir));
+
 	/* copy from a bounce buffer, if necessary */
 	if (status && wh->dma_bounce_buffer) {
 		if (SCpnt) {
@@ -193,6 +222,11 @@ static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
 	wd33c93_regs wdregs;
 	struct a3000_hostdata *hdata;
 
+	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+		dev_warn(&pdev->dev, "cannot use 32 bit DMA\n");
+		return -ENODEV;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
@@ -216,6 +250,7 @@ static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
 	wdregs.SCMD = &regs->SCMD;
 
 	hdata = shost_priv(instance);
+	hdata->dev = &pdev->dev;
 	hdata->wh.no_sync = 0xff;
 	hdata->wh.fast = 0;
 	hdata->wh.dma_mode = CTRL_DMA;
-- 
2.17.1

