Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58409C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 03:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiF2DLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 23:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiF2DK6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 23:10:58 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4711A80D;
        Tue, 28 Jun 2022 20:10:57 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 65so13758024pfw.11;
        Tue, 28 Jun 2022 20:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t1+E2APwaN49w4WUjMso01bm3l0X4lKOX1QB208lxbQ=;
        b=BaTjuiuWo9lwT3iUiy3igT7yXOiZHFpw4juQ8xVOM1qeZVHq/33VHhYv0qcMIUG3qo
         o3jCAR9lryLtggPF7i0DNuWlhF37/3HAJIeV2bGiGMoxx+4QtSwCYr2q2pA99oI3218A
         ObK6/z6v0RfpW+tWb9ZSNUOLeHsHmNx2p7g0gSAMLLjSaVzuXshPUlDkDwXPr0gsfRBp
         aWYfKpAhVTKePkSK93QPPPEO6blaPKzrOSwf1xDJdkOvefiBsIoScxtn/q1XTphye06S
         YGWggaOwI1dVtmgy4s9j3vhzf6654oID3nEYqQzHN3OAFSH8n2CNpQZx/YWl7uZYo3P2
         +7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t1+E2APwaN49w4WUjMso01bm3l0X4lKOX1QB208lxbQ=;
        b=Y4PIbQP9S69GHxhNjAbcwIahUPUNU/4vHv5eFke11YuTfp1GGMLw5g0uyqgc7DKdj3
         sxRc+cYm/M8elwHLSeBvkQkM696UZ6a0jgL4SBrGGwHeiic4mYB+jOmdk1Xlm8/VX8H0
         hIX/UR7lkCQ1CulNUgdy9DozzNh1mTs9Ra5bIWPz+lmxGsvSBD2nzi1nrmKmf0ABgz76
         J9s4xTPIRg7pKEmLoDsLLFyOxMI/3DrifuWynvHFyLW0gyI337AxRmLowqU7+KkJ531Y
         iwYOOk+68RMgDqFB3D1ImVcWqBlZTzAki2FPnMHMBx/tT040MioZhfgcRpWgDTO+HDag
         LW3g==
X-Gm-Message-State: AJIora9MJh0bl6+JS12ZnQr53Nj+D+ygo7UwiGR/7P9z/iYfrF6xiNk7
        tmPSK4IV0BA2Y7GCrqzpbvfNKl46QY9GWA==
X-Google-Smtp-Source: AGRyM1szLt8yuidCa+sCeWnEwITld8d7m1R3xpmywFV+QOa9WyqQ9gHt3DLDUa8HMr43lK63ceXQLA==
X-Received: by 2002:a65:6044:0:b0:3fc:674:8f5a with SMTP id a4-20020a656044000000b003fc06748f5amr1074632pgp.436.1656472256628;
        Tue, 28 Jun 2022 20:10:56 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id u34-20020a056a0009a200b005190eea6c37sm10335336pfg.157.2022.06.28.20.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:10:54 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 57C39360331; Wed, 29 Jun 2022 13:16:42 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v1 2/3] scsi - a2091.c: convert m68k WD33C93 drivers to DMA API
Date:   Wed, 29 Jun 2022 13:16:37 +1200
Message-Id: <20220629011638.21783-3-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220629011638.21783-1-schmitzmic@gmail.com>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use dma_map_single() for a2091 driver (leave bounce buffer
logic unchanged).

Use dma_set_mask_and_coherent() to avoid explicit cache
flushes.

Compile-tested only.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/a2091.c | 53 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index cf703a1ecdda..2338c75c34ed 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -24,8 +24,11 @@
 struct a2091_hostdata {
 	struct WD33C93_hostdata wh;
 	struct a2091_scsiregs *regs;
+	struct device *dev;
 };
 
+#define DMA_DIR(d)   ((d == DATA_OUT_DIR) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)
+
 static irqreturn_t a2091_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
@@ -45,15 +48,31 @@ static irqreturn_t a2091_intr(int irq, void *data)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct scsi_pointer *scsi_pointer = WD33C93_scsi_pointer(cmd);
+	unsigned long len = scsi_pointer->this_residual;
 	struct Scsi_Host *instance = cmd->device->host;
 	struct a2091_hostdata *hdata = shost_priv(instance);
 	struct WD33C93_hostdata *wh = &hdata->wh;
 	struct a2091_scsiregs *regs = hdata->regs;
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
 
 	/* don't allow DMA if the physical address is bad */
 	if (addr & A2091_XFER_MASK) {
+		/* drop useless mapping */
+		dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+				 scsi_pointer->this_residual,
+				 DMA_DIR(dir_in));
+		scsi_pointer->dma_handle = (dma_addr_t) NULL;
+
 		wh->dma_bounce_len = (scsi_pointer->this_residual + 511) & ~0x1ff;
 		wh->dma_bounce_buffer = kmalloc(wh->dma_bounce_len,
 						GFP_KERNEL);
@@ -64,9 +83,6 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 			return 1;
 		}
 
-		/* get the physical address of the bounce buffer */
-		addr = virt_to_bus(wh->dma_bounce_buffer);
-
 		/* the bounce buffer may not be in the first 16M of physmem */
 		if (addr & A2091_XFER_MASK) {
 			/* we could use chipmem... maybe later */
@@ -81,6 +97,17 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
 			       scsi_pointer->this_residual);
 		}
+
+		/* may flush/invalidate cache for us */
+		addr = dma_map_single(hdata->dev, wh->dma_bounce_buffer,
+				      wh->dma_bounce_len, DMA_DIR(dir_in));
+		/* can't map buffer; use PIO */
+		if (dma_mapping_error(hdata->dev, addr)) {
+			dev_warn(hdata->dev, "cannot map bounce buffer %p\n",
+				 wh->dma_bounce_buffer);
+			return 1;
+		}
+		scsi_pointer->dma_handle = addr;
 	}
 
 	/* setup dma direction */
@@ -95,13 +122,8 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	/* setup DMA *physical* address */
 	regs->ACR = addr;
 
-	if (dir_in) {
-		/* invalidate any cache */
-		cache_clear(addr, scsi_pointer->this_residual);
-	} else {
-		/* push any dirty cache */
-		cache_push(addr, scsi_pointer->this_residual);
-	}
+	/* no more cache flush here - using coherent DMA alloc */
+
 	/* start DMA */
 	regs->ST_DMA = 1;
 
@@ -151,6 +173,9 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		wh->dma_bounce_buffer = NULL;
 		wh->dma_bounce_len = 0;
 	}
+	dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+			 scsi_pointer->this_residual,
+			 DMA_DIR(wh->dma_dir));
 }
 
 static struct scsi_host_template a2091_scsi_template = {
@@ -178,6 +203,11 @@ static int a2091_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 	wd33c93_regs wdregs;
 	struct a2091_hostdata *hdata;
 
+	if (dma_set_mask_and_coherent(&z->dev, DMA_BIT_MASK(24))) {
+		dev_warn(&z->dev, "cannot use 24 bit DMA\n");
+		return -ENODEV;
+	}
+
 	if (!request_mem_region(z->resource.start, 256, "wd33c93"))
 		return -EBUSY;
 
@@ -198,6 +228,7 @@ static int a2091_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 	wdregs.SCMD = &regs->SCMD;
 
 	hdata = shost_priv(instance);
+	hdata->dev = &z->dev;
 	hdata->wh.no_sync = 0xff;
 	hdata->wh.fast = 0;
 	hdata->wh.dma_mode = CTRL_DMA;
-- 
2.17.1

