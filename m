Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4C8C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 03:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiF3DdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 23:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiF3DdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 23:33:17 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3546310541;
        Wed, 29 Jun 2022 20:33:11 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 136so11788815pfy.10;
        Wed, 29 Jun 2022 20:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LD9+LKe3uS0Sb8A9xgYkUVoA3AVOOFQp9Gn9fGnfF/k=;
        b=QnaqhU/fYGHEzzbOIPM8oBRiB3tAbEc/baWflW1vTUGBtpiMhXLeCyfsLExK4WL5Mt
         39qRkiUAff9wEKw0tKTvUnkjzz2JiDakw8+iTi/ReL0+reNxogjyCTlJ//QwfVEUagR3
         jVKaTbiD84IAxTI6NBgd61iDXl/QNy+O/gr5E9N/99j/OQWoTo+ajfwE76rdt+9R6aT3
         BVti6inxERl0MaBsp9jNOkjvV0Gxs1mfOEf7yweRT7yV6gbl1iAmE3Q51UNcT8VtBCcA
         Ftu+Xs6LsNtd1WCFP95ktAF6B61OoIhgDjrToJ2VtxOx9eqczuMjv9P+cIVVVI9gH0CO
         WRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LD9+LKe3uS0Sb8A9xgYkUVoA3AVOOFQp9Gn9fGnfF/k=;
        b=E6PHppiF3gEbubppBPuerA4+NSHISGi1Hf/DRW0tj1EBnwcYXwG+mXYHAYeKqmd5ws
         rgxEN/VAXWDZgTESNWoyS0cmQz5OIUDSe+TtpvnqrfZWg8lZMyOberrMEDa0yWYlu5ER
         PxnMVQCghDrBnYcdCaKvHIG0TZp2M7km+O7hJL/5FKIHHMzBEp57VBX/38U7fJmcxVtX
         ytO7JpoYDjEP+alOoGxbRyq+4s7PDbKRTzQDslcAB80gdIOPzb1CISQU17TYH4W/16zk
         oRrRNeb2+hyyWySVQVUHuw8sqBUn/UZa4TYaUdBoD+4nCDhx6gPYJBYUUzkVrsnceQ0x
         c/AA==
X-Gm-Message-State: AJIora/9OFwJqTi1noPSpwl3wBZGsiqOSgnUNmtflnwdaxohFZLOXbKT
        fZHOGYugEbjakB1v2BGHVRw=
X-Google-Smtp-Source: AGRyM1v7BW2A1s0vPAc1EU41PaoaKmcVZC2nGmfRVZXc4HeOzkQ7+qzlskrEx1EFeMhbM5P5jZuHnw==
X-Received: by 2002:a63:6984:0:b0:40d:9ebe:5733 with SMTP id e126-20020a636984000000b0040d9ebe5733mr5841296pgc.170.1656559990657;
        Wed, 29 Jun 2022 20:33:10 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id y11-20020a170902d64b00b0016782c55790sm12162761plh.232.2022.06.29.20.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 20:33:10 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id E46503603FB; Thu, 30 Jun 2022 15:33:06 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v2 3/3] scsi - gvp11.c: convert m68k WD33C93 drivers to DMA API
Date:   Thu, 30 Jun 2022 15:33:02 +1200
Message-Id: <20220630033302.3183-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630033302.3183-1-schmitzmic@gmail.com>
References: <20220630033302.3183-1-schmitzmic@gmail.com>
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
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

--

Changes from v1:

Arnd Bergmann:
- reorder bounce buffer copy and dma mapping
---
 drivers/scsi/gvp11.c | 95 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 77 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 2f6c56aabe1d..e8b7a09eb8c7 100644
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
@@ -87,10 +107,32 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 			wh->dma_buffer_pool = BUF_CHIP_ALLOCED;
 		}
 
-		/* check if the address of the bounce buffer is OK */
-		addr = virt_to_bus(wh->dma_bounce_buffer);
+		if (!dir_in) {
+			/* copy to bounce buffer for a write */
+			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
+			       scsi_pointer->this_residual);
+		}
+
+		if (wh->dma_buffer_pool == BUF_SCSI_ALLOCED) {
+		/* will flush/invalidate cache for us */
+			addr = dma_map_single(hdata->dev,
+					      wh->dma_bounce_buffer,
+					      wh->dma_bounce_len,
+					      DMA_DIR(dir_in));
+			/* can't map buffer; use PIO */
+			if (dma_mapping_error(hdata->dev, addr)) {
+				dev_warn(hdata->dev,
+					 "cannot map bounce buffer %p\n",
+					 wh->dma_bounce_buffer);
+				return 1;
+			}
+		}
 
 		if (addr & wh->dma_xfer_mask) {
+			/* drop useless mapping */
+			dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+					 scsi_pointer->this_residual,
+					 DMA_DIR(dir_in));
 			/* fall back to Chip RAM if address out of range */
 			if (wh->dma_buffer_pool == BUF_SCSI_ALLOCED) {
 				kfree(wh->dma_bounce_buffer);
@@ -108,15 +150,19 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 				return 1;
 			}
 
-			addr = virt_to_bus(wh->dma_bounce_buffer);
+			if (!dir_in) {
+				/* copy to bounce buffer for a write */
+				memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
+				       scsi_pointer->this_residual);
+			}
+			/* chip RAM can be mapped to phys. address directly */
+			addr = virt_to_phys(wh->dma_bounce_buffer);
+			/* no need to flush/invalidate cache */
 			wh->dma_buffer_pool = BUF_CHIP_ALLOCED;
 		}
+		/* finally, have OK mapping (punted for PIO else) */
+		scsi_pointer->dma_handle = addr;
 
-		if (!dir_in) {
-			/* copy to bounce buffer for a write */
-			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
-			       scsi_pointer->this_residual);
-		}
 	}
 
 	/* setup dma direction */
@@ -129,13 +175,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
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
 
 	bank_mask = (~wh->dma_xfer_mask >> 18) & 0x01c0;
 	if (bank_mask)
@@ -161,6 +201,11 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	/* remove write bit from CONTROL bits */
 	regs->CNTR = GVP11_DMAC_INT_ENABLE;
 
+	if (wh->dma_buffer_pool == BUF_SCSI_ALLOCED)
+		dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
+				 scsi_pointer->this_residual,
+				 DMA_DIR(wh->dma_dir));
+
 	/* copy from a bounce buffer, if necessary */
 	if (status && wh->dma_bounce_buffer) {
 		if (wh->dma_dir && SCpnt)
@@ -287,6 +332,13 @@ static int gvp11_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 
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
@@ -327,9 +379,16 @@ static int gvp11_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
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

