Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD7DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 03:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiF3Dd0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 23:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiF3DdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 23:33:17 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC47E0E3;
        Wed, 29 Jun 2022 20:33:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m14so15876534plg.5;
        Wed, 29 Jun 2022 20:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MRxqh69+G3XJkqsaT4DDt44PFEyLEpwiBKn/lZMq/q4=;
        b=AR+8qbf4mKrX/BbLwB9s4N6vlDgAWMKQWhAOmidOuktqZ7rg4+wSsgF8nDQgviPZaa
         A0hPgNBDPjUDJeQZDFuKOuQekTeW/meBAejH+cyAvwE7h8safjR966YEicOagvyO8pQ1
         O5P5FenfYcWL+l+y09EP9GloW6pcAiQAkxgRGDdeXpm5+K8ItIehYdvfsSyyfT+Poac1
         ansWo1gsnTPYgVQdpFvQcuTLii259x3+q55iMqPJuih/U9Odqa7qO0++rBvP4/5kbfy0
         B/l+oJdcRHSXuTqEz1+AX3TOlrbewzZfTwMWTpsVVWerNwmz7x8Lr/TJujPXFiAyFxQU
         XDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MRxqh69+G3XJkqsaT4DDt44PFEyLEpwiBKn/lZMq/q4=;
        b=8Eb4Lb35wBm0wW85qwDvi0PfeLLo2ULyPTucUoVTB9hFjJjj8C93ag0AWBrCisuhvs
         UrC0UDJAAfiDSDpaiJXnew/t+K3v8/icfeNCgNNDtdtPlALXbiYZnLtUrcStm2iw8irx
         arnK9SYaz0Jltxp8KhpLejv3Zf2ZdCFVXosdGg+h+Ta7VI+1LVKidPYIkob4eUCMhVe+
         1yWe9ZgUExQwtifV4MFOU6FDVRDlLhRMbwXN74ic2zqwNGDD5vsTIGAPXriYAkF7xqNU
         CC+Ec3E2Ll+4ahmv8xDbaXEZiuVEed7pi5LkgvDb8THR++qn4K0Bn+WP+UiRbr6uqG/Z
         LBXg==
X-Gm-Message-State: AJIora9UyI4T3IkzeQYDW8TdQl42ic1Rih07eBkT5W3pka4z4EUNRZUN
        JZqFokSulLaxQbnK0EPd0B4=
X-Google-Smtp-Source: AGRyM1sOZw7L2TETv1MvWzj32Gh7kaEWjHTzqXsIwDmzlP7d2oH0GhLz063d5/uktTAlARvXktlJlg==
X-Received: by 2002:a17:90a:f48a:b0:1ed:5ec:f890 with SMTP id bx10-20020a17090af48a00b001ed05ecf890mr9484550pjb.40.1656559990142;
        Wed, 29 Jun 2022 20:33:10 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902784b00b00168b113f222sm12297852pln.173.2022.06.29.20.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 20:33:09 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 2BDFC360333; Thu, 30 Jun 2022 15:33:06 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v2 2/3] scsi - a2091.c: convert m68k WD33C93 drivers to DMA API
Date:   Thu, 30 Jun 2022 15:33:01 +1200
Message-Id: <20220630033302.3183-3-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630033302.3183-1-schmitzmic@gmail.com>
References: <20220630033302.3183-1-schmitzmic@gmail.com>
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
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

--

Changes from v1:

Arnd Bergmann:
- reorder mapping and bounce buffer copy
---
 drivers/scsi/a2091.c | 63 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index cf703a1ecdda..74312400468b 100644
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
@@ -64,8 +83,21 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 			return 1;
 		}
 
-		/* get the physical address of the bounce buffer */
-		addr = virt_to_bus(wh->dma_bounce_buffer);
+		if (!dir_in) {
+			/* copy to bounce buffer for a write */
+			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
+			       scsi_pointer->this_residual);
+		}
+
+		/* will flush/invalidate cache for us */
+		addr = dma_map_single(hdata->dev, wh->dma_bounce_buffer,
+				      wh->dma_bounce_len, DMA_DIR(dir_in));
+		/* can't map buffer; use PIO */
+		if (dma_mapping_error(hdata->dev, addr)) {
+			dev_warn(hdata->dev, "cannot map bounce buffer %p\n",
+				 wh->dma_bounce_buffer);
+			return 1;
+		}
 
 		/* the bounce buffer may not be in the first 16M of physmem */
 		if (addr & A2091_XFER_MASK) {
@@ -76,11 +108,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 			return 1;
 		}
 
-		if (!dir_in) {
-			/* copy to bounce buffer for a write */
-			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
-			       scsi_pointer->this_residual);
-		}
+		scsi_pointer->dma_handle = addr;
 	}
 
 	/* setup dma direction */
@@ -95,13 +123,8 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
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
+
 	/* start DMA */
 	regs->ST_DMA = 1;
 
@@ -142,6 +165,10 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	/* restore the CONTROL bits (minus the direction flag) */
 	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 
+	dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+			 scsi_pointer->this_residual,
+			 DMA_DIR(wh->dma_dir));
+
 	/* copy from a bounce buffer, if necessary */
 	if (status && wh->dma_bounce_buffer) {
 		if (wh->dma_dir)
@@ -178,6 +205,11 @@ static int a2091_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 	wd33c93_regs wdregs;
 	struct a2091_hostdata *hdata;
 
+	if (dma_set_mask_and_coherent(&z->dev, DMA_BIT_MASK(24))) {
+		dev_warn(&z->dev, "cannot use 24 bit DMA\n");
+		return -ENODEV;
+	}
+
 	if (!request_mem_region(z->resource.start, 256, "wd33c93"))
 		return -EBUSY;
 
@@ -198,6 +230,7 @@ static int a2091_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 	wdregs.SCMD = &regs->SCMD;
 
 	hdata = shost_priv(instance);
+	hdata->dev = &z->dev;
 	hdata->wh.no_sync = 0xff;
 	hdata->wh.fast = 0;
 	hdata->wh.dma_mode = CTRL_DMA;
-- 
2.17.1

