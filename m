Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D17BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 03:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiF2DK5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 23:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiF2DK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 23:10:56 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70901A80D;
        Tue, 28 Jun 2022 20:10:55 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x138so11112034pfc.3;
        Tue, 28 Jun 2022 20:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A/ikJJq41Sa7RmyRhS6UjTJSwH1KB0sH75JFtZjXRlM=;
        b=bZ4k49vQbJgCltNXUA6iH51N4Kdm9tJgLEgc5SeF2xFsQIvyUooWTt4fsp2Ts1FeAO
         PBX2I8phcAMvxItATQqy9Nug5WsCUE9fIF87noyZQYj8Rkcr+VoDW7M8ghfl13KrVaEQ
         w+I87IVHoLerkSClA4fpnzx2AuJWwymUJ3cCLn3jIwXu9H7cOWHehQs+aExPQdM2zQU/
         7r8rFnVakUm90XFGgnxBglj9Id3B7ngSpL4CBwEl4sXp25OwCD7hR7NKRYoC4BBjzLIT
         a/yqr/ARzxtBJ2ugVZuBifU2bnG/wWJubHHp1BdZGJXQyRZ+QuqBLsOBr4qfcuz0ARK5
         Sj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A/ikJJq41Sa7RmyRhS6UjTJSwH1KB0sH75JFtZjXRlM=;
        b=7Ua3Q60J3f1nU92SMp/Ixfw+0t7dv0A9Czxzj6KJZtXwO9SylGWpy8mBIfyd0P1IPX
         xx9dk/Thr1vLKMYwj/pHx6VV1/9yzUU0NGX+WOlFR0xpZj8Xb4ZgE2o7tA4VUP0+40u4
         X4ryWn43RfrUjSFLP8BQEO1MwUmpncpYaytYyCc6XeYm2b8+zf4bjm529E1zUBX2W0uL
         /4dTnR5KAdKtFhL4k1FKn4F+SCofzYkIhZEdK1a5RpmycYFNK9mulIStkGEmIFF0e6ER
         r7UK0mbLb1Mntz4AhGpG/zc4+kyRnUp1C3p9+ZNcxvij0bZaEGef9yFgDm4awGAcFF0P
         +LwQ==
X-Gm-Message-State: AJIora/Si8/Xn6mVg/vxrZ3qu3ws1XoIqB/v+gzKKNptR/LvgQqOF0um
        rDmP46toAaf74iR0VrFgZcDPqUTaEhQgwA==
X-Google-Smtp-Source: AGRyM1vYPSGJ2bnmTPvDSdrRndpbeAXvmv1IzOXXuPp+idCQ1NdVEVV+94mojDvvIAuGrffiv6x4Yw==
X-Received: by 2002:a05:6a00:c91:b0:525:84b6:9a37 with SMTP id a17-20020a056a000c9100b0052584b69a37mr7900131pfv.47.1656472255175;
        Tue, 28 Jun 2022 20:10:55 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id m14-20020a17090a414e00b001eca01f4860sm697558pjg.12.2022.06.28.20.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:10:54 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 90F29360330; Wed, 29 Jun 2022 13:16:41 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v1 1/3] scsi - a3000.c: convert m68k WD33C93 drivers to DMA API
Date:   Wed, 29 Jun 2022 13:16:36 +1200
Message-Id: <20220629011638.21783-2-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220629011638.21783-1-schmitzmic@gmail.com>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use dma_map_single() for a3000 driver (leave bounce buffer
logic unchanged).

Use dma_set_mask_and_coherent() to avoid explicit cache
flushes.

Incorporates review comments by ArndB:
- drop bounce buffer handling - non-cacheline aligned
  buffers ought not to happen.

Compile-tested only.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/a3000.c | 60 ++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index dd161885eed1..0e2e0d69118b 100644
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
@@ -49,37 +53,40 @@ static irqreturn_t a3000_intr(int irq, void *data)
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
+	 * MSch 20220629 - only wrong alignment tested, skip bounce
+	 * buffer set-up and just do PIO here. Buffers not aligned
+	 * to cachelines ought to not happen anymore.
 	 */
 	if (addr & A3000_XFER_MASK) {
-		wh->dma_bounce_len = (scsi_pointer->this_residual + 511) & ~0x1ff;
-		wh->dma_bounce_buffer = kmalloc(wh->dma_bounce_len,
-						GFP_KERNEL);
-
-		/* can't allocate memory; use PIO */
-		if (!wh->dma_bounce_buffer) {
-			wh->dma_bounce_len = 0;
-			return 1;
-		}
-
-		if (!dir_in) {
-			/* copy to bounce buffer for a write */
-			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
-			       scsi_pointer->this_residual);
-		}
-
-		addr = virt_to_bus(wh->dma_bounce_buffer);
+		WARN_ONCE(1, "Invalid alignment for DMA!");
+		/* drop useless mapping */
+		dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+				 scsi_pointer->this_residual,
+				 DMA_DIR(dir_in));
+		scsi_pointer->dma_handle = (dma_addr_t) NULL;
+		return 1;
 	}
 
 	/* setup dma direction */
@@ -94,13 +101,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	/* setup DMA *physical* address */
 	regs->ACR = addr;
 
-	if (dir_in) {
-		/* invalidate any cache */
-		cache_clear(addr, scsi_pointer->this_residual);
-	} else {
-		/* push any dirty cache */
-		cache_push(addr, scsi_pointer->this_residual);
-	}
+	/* no more cache flush here - coherent DMA setup used */
 
 	/* start DMA */
 	mb();			/* make sure setup is completed */
@@ -166,6 +167,9 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 			wh->dma_bounce_len = 0;
 		}
 	}
+	dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+			 scsi_pointer->this_residual,
+			 DMA_DIR(wh->dma_dir));
 }
 
 static struct scsi_host_template amiga_a3000_scsi_template = {
@@ -193,6 +197,11 @@ static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
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
@@ -216,6 +225,7 @@ static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
 	wdregs.SCMD = &regs->SCMD;
 
 	hdata = shost_priv(instance);
+	hdata->dev = &pdev->dev;
 	hdata->wh.no_sync = 0xff;
 	hdata->wh.fast = 0;
 	hdata->wh.dma_mode = CTRL_DMA;
-- 
2.17.1

