Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D27C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 07:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiGLH6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbiGLH6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 03:58:47 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D204A3B3;
        Tue, 12 Jul 2022 00:58:41 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 73so6860828pgb.10;
        Tue, 12 Jul 2022 00:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KsiErWWdRW3Hk14U/AhfcSq+a/LkvR4Yk5HQLw394/o=;
        b=REiuhOYm/SL8aaddOgNyKke7UBpYUUtnidsbOGMBPgt5XveGcY7yWkYSzsdRsoIB4y
         2CPhpzt1B69iTcQVKvjO/U0jLDagvfpEd6VQu+peve0F1GzbrdJN7CnKqzWlfm9fTnIx
         MwXAnWDdwNmgaQ2hNwGZrJKKJLHvWwNyMp12FkvX6u3TWAvuaMBmqQhKqcAFB0REcUDD
         r8cN9eXCX07kSKKc/xpozgd7REFU2az3qPIxvJ6va5w0+Fuekc7XaNdQJl79DS3WgbII
         CiAo/kMyXjHxB/mB4lbBLBbbl90n27lGMP6EIFy4DHoWa4f3/bmuw84lkY90+p3FOi3U
         LF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KsiErWWdRW3Hk14U/AhfcSq+a/LkvR4Yk5HQLw394/o=;
        b=SgA+E4ArBBuxP4I3TSlE+9H6RmQUlP+oKXdNCHERgOF7b/8fVg6TIt/i5XMLOSndWH
         sy8n6Epr1HaOnLUioTswn7j05w5GJ9ZhgL4W6F0+AkfE/6HQLN9JAJAEo7M44FrYrY5O
         lG8HtVJDwzarzqkuRYP8ogvcMXIQCbWc0Iqf92hQEhfWFcsAjmHISlOPWEfGPJ0jAsE5
         /9+f703D842GPC2oeczF7sXZ0YPCsiWYDdky4Jr3Fc4um+22ssU31klYxJ91ITLLisLq
         rAoFtnSKTKUtYFZC7CRPszGti6fwHGrsU0eujUqF6JIjAYKiDwif/nkIhHyyy5jJz7TT
         7QSg==
X-Gm-Message-State: AJIora/rrqhx/Zqq9/DjljT5WRB29Du90Ix17cmCKzjH/gLxGYSdFl4U
        +nUjkbLSRNTKoXqb6ba7Yro=
X-Google-Smtp-Source: AGRyM1u571TcaLXfgri+YldABCVGiVF3l6orO7eVRXRGPuiSjJpsKtFhdT+M7faB5YdgP7k53kQSVg==
X-Received: by 2002:a05:6a00:b54:b0:52a:d3d1:f63f with SMTP id p20-20020a056a000b5400b0052ad3d1f63fmr8211527pfo.26.1657612721294;
        Tue, 12 Jul 2022 00:58:41 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id n6-20020a622706000000b00528c22fbb45sm6236203pfn.141.2022.07.12.00.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:58:41 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 859A8360403; Tue, 12 Jul 2022 19:58:37 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v2 5/5] scsi - convert mvme147.c driver to DMA API
Date:   Tue, 12 Jul 2022 19:58:32 +1200
Message-Id: <20220712075832.23793-6-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712075832.23793-1-schmitzmic@gmail.com>
References: <20220712075832.23793-1-schmitzmic@gmail.com>
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
- change patch index from 3 to 4 (due to insertion of m68k kmap patch)
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

