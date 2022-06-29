Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1D8C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 03:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiF2DLH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 23:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiF2DK6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 23:10:58 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC33025C70;
        Tue, 28 Jun 2022 20:10:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x20so7212863plx.6;
        Tue, 28 Jun 2022 20:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dJAtxvkZd2WYMWMHFKqN/VDP7wgyyYMbpnChf5/5H20=;
        b=XqjyL5jYmHy8hwuAGOjzG3o+h8uezKsf0b5ad4bjh5Q8FSKJSFNDTQGTwa8FH8aZuz
         dikIw44LDwQlM29RSAHOk7ZG54bRkS1N9b+ygctjRN3A5lYFDmFf5IAk7ZrgHC2V5Kqd
         w5nuAD4ndt2gFQ19gmNwbpvEaDHm4CIiWH51pHGS7kyChIEeXUpCbJQhEjT5Kx59bIeL
         HjbdnTq1GoXoqTm+2zPLtHibMGKAQSRr4EhThiylDezZOqkUOH9PXG3mtG0kRFv6yVum
         lF6WuHngV89jeGYTxYiradG8HmtqC1VAcFgooBEWRuaF73fr3r8iq/eXQiFTCS2WEu1C
         zGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dJAtxvkZd2WYMWMHFKqN/VDP7wgyyYMbpnChf5/5H20=;
        b=4TDTqYH39duVmPL6cc6umFgavn4/8rNkEvhSOIT3X6R67EJLa6IGiX+QI+0u4y3apq
         ELSsVxyWdlDyzZAV1J5gXf9W6XZO7Rvs/wXgjWELJqegDpTRHuAlIsrYjGRYJ7PZMaUG
         wAS0daYvb1u2lIDmT9QRx3QTCR2c1eRIrZkAUtfWPYsOwuzMfmvEe3lqV12kO34sCPFS
         gs903voOmunX9mzw/NMw1vvQOIqCSEDrUFvaoNGnDLaY3QlFlIpNmgeOx0nnXOqkxDtT
         VKGIWHxqAjVD8uHPd2fEyKOvvvmCY4rwePp+HO9wp7H3fyWoJFPNKUwJBaa/8NlD2e2G
         s7Rg==
X-Gm-Message-State: AJIora+pV9zhrwD/l6gd8V6UFwZGfHyX5yHvtR6Yx3dFTQKErGxlfiuX
        bz60xp7xBzWy+4j7afeLRj7hq8MQ9NQ07g==
X-Google-Smtp-Source: AGRyM1tPxCkbBSiE6aCv0nv9a3L9b1ggtWe0f9LP4VxjcGf1gqPWN0hNw7e2QMjrX1yVlNiFxae/yA==
X-Received: by 2002:a17:90a:6fc5:b0:1ec:87db:b9f6 with SMTP id e63-20020a17090a6fc500b001ec87dbb9f6mr1378614pjk.104.1656472256276;
        Tue, 28 Jun 2022 20:10:56 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902a38f00b0016b8b5b0aa0sm2942508pla.86.2022.06.28.20.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:10:54 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 0AA10360332; Wed, 29 Jun 2022 13:16:43 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v1 3/3] scsi - gvp11.c: convert m68k WD33C93 drivers to DMA API
Date:   Wed, 29 Jun 2022 13:16:38 +1200
Message-Id: <20220629011638.21783-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220629011638.21783-1-schmitzmic@gmail.com>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use dma_map_single() for gvp11 driver (leave bounce buffer
logic unchanged).

Use dma_set_mask_and_coherent() to avoid explicit cache
flushes.

Compile-tested only.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/gvp11.c | 78 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 2f6c56aabe1d..a793323e008f 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -26,8 +26,12 @@
 struct gvp11_hostdata {
 	struct WD33C93_hostdata wh;
 	struct gvp11_scsiregs *regs;
+	struct device *dev;
 };
 
+#define DMA_DIR(d)   ((d == DATA_OUT_DIR) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)
+#define TO_DMA_MASK(m)	((~(m & 0xfffffff0))-1)
+
 static irqreturn_t gvp11_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
@@ -54,17 +58,33 @@ void gvp11_setup(char *str, int *ints)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct scsi_pointer *scsi_pointer = WD33C93_scsi_pointer(cmd);
+	unsigned long len = scsi_pointer->this_residual;
 	struct Scsi_Host *instance = cmd->device->host;
 	struct gvp11_hostdata *hdata = shost_priv(instance);
 	struct WD33C93_hostdata *wh = &hdata->wh;
 	struct gvp11_scsiregs *regs = hdata->regs;
 	unsigned short cntr = GVP11_DMAC_INT_ENABLE;
-	unsigned long addr = virt_to_bus(scsi_pointer->ptr);
+	dma_addr_t addr;
 	int bank_mask;
 	static int scsi_alloc_out_of_range = 0;
 
+	addr = dma_map_single(hdata->dev, scsi_pointer->ptr,
+			      len, DMA_DIR(dir_in));
+	if (dma_mapping_error(hdata->dev, addr)) {
+		dev_warn(hdata->dev, "cannot map SCSI data block %p\n",
+			 scsi_pointer->ptr);
+		return 1;
+	}
+	scsi_pointer->dma_handle = addr;
+
 	/* use bounce buffer if the physical address is bad */
 	if (addr & wh->dma_xfer_mask) {
+		/* drop useless mapping */
+		dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+				 scsi_pointer->this_residual,
+				 DMA_DIR(dir_in));
+		scsi_pointer->dma_handle = (dma_addr_t) NULL;
+
 		wh->dma_bounce_len = (scsi_pointer->this_residual + 511) & ~0x1ff;
 
 		if (!scsi_alloc_out_of_range) {
@@ -87,10 +107,21 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 			wh->dma_buffer_pool = BUF_CHIP_ALLOCED;
 		}
 
-		/* check if the address of the bounce buffer is OK */
-		addr = virt_to_bus(wh->dma_bounce_buffer);
+		/* may flush/invalidate cache for us */
+		addr = dma_map_single(hdata->dev, wh->dma_bounce_buffer,
+				      wh->dma_bounce_len, DMA_DIR(dir_in));
+		/* can't map buffer; use PIO */
+		if (dma_mapping_error(hdata->dev, addr)) {
+			dev_warn(hdata->dev, "cannot map bounce buffer %p\n",
+				 wh->dma_bounce_buffer);
+			return 1;
+		}
 
 		if (addr & wh->dma_xfer_mask) {
+			/* drop useless mapping */
+			dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+					 scsi_pointer->this_residual,
+					 DMA_DIR(dir_in));
 			/* fall back to Chip RAM if address out of range */
 			if (wh->dma_buffer_pool == BUF_SCSI_ALLOCED) {
 				kfree(wh->dma_bounce_buffer);
@@ -108,9 +139,19 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 				return 1;
 			}
 
-			addr = virt_to_bus(wh->dma_bounce_buffer);
+			/* may flush/invalidate cache for us */
+			addr = dma_map_single(hdata->dev, wh->dma_bounce_buffer,
+					      wh->dma_bounce_len, DMA_DIR(dir_in));
+			/* can't map buffer; use PIO */
+			if (dma_mapping_error(hdata->dev, addr)) {
+				dev_warn(hdata->dev, "cannot map bounce buffer %p\n",
+					 wh->dma_bounce_buffer);
+				return 1;
+			}
 			wh->dma_buffer_pool = BUF_CHIP_ALLOCED;
 		}
+		/* finally, have OK mapping (punted for PIO else) */
+		scsi_pointer->dma_handle = addr;
 
 		if (!dir_in) {
 			/* copy to bounce buffer for a write */
@@ -129,13 +170,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	/* setup DMA *physical* address */
 	regs->ACR = addr;
 
-	if (dir_in) {
-		/* invalidate any cache */
-		cache_clear(addr, scsi_pointer->this_residual);
-	} else {
-		/* push any dirty cache */
-		cache_push(addr, scsi_pointer->this_residual);
-	}
+	/* no more cache flush here - using coherent memory! */
 
 	bank_mask = (~wh->dma_xfer_mask >> 18) & 0x01c0;
 	if (bank_mask)
@@ -175,6 +210,9 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		wh->dma_bounce_buffer = NULL;
 		wh->dma_bounce_len = 0;
 	}
+	dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+			 scsi_pointer->this_residual,
+			 DMA_DIR(wh->dma_dir));
 }
 
 static struct scsi_host_template gvp11_scsi_template = {
@@ -287,6 +325,13 @@ static int gvp11_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 
 	default_dma_xfer_mask = ent->driver_data;
 
+	if (dma_set_mask_and_coherent(&z->dev,
+		TO_DMA_MASK(default_dma_xfer_mask))) {
+		dev_warn(&z->dev, "cannot use DMA mask %x\n",
+			 TO_DMA_MASK(default_dma_xfer_mask));
+		return -ENODEV;
+	}
+
 	/*
 	 * Rumors state that some GVP ram boards use the same product
 	 * code as the SCSI controllers. Therefore if the board-size
@@ -327,9 +372,16 @@ static int gvp11_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 	wdregs.SCMD = &regs->SCMD;
 
 	hdata = shost_priv(instance);
-	if (gvp11_xfer_mask)
+	if (gvp11_xfer_mask) {
 		hdata->wh.dma_xfer_mask = gvp11_xfer_mask;
-	else
+		if (dma_set_mask_and_coherent(&z->dev,
+			TO_DMA_MASK(gvp11_xfer_mask))) {
+			dev_warn(&z->dev, "cannot use DMA mask %x\n",
+				 TO_DMA_MASK(gvp11_xfer_mask));
+			error = -ENODEV;
+			goto fail_check_or_alloc;
+		}
+	} else
 		hdata->wh.dma_xfer_mask = default_dma_xfer_mask;
 
 	hdata->wh.no_sync = 0xff;
-- 
2.17.1

