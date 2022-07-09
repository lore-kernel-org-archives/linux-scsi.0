Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B09BCCA481
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiGIAKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiGIAKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:10:32 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D800B7CB50;
        Fri,  8 Jul 2022 17:10:29 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g4so283862pgc.1;
        Fri, 08 Jul 2022 17:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ufXk8FbbGAqNsL++C+ffXL+0StpdtfyJkwi67F2ahYw=;
        b=Rq/GFAsLj8kSzJYEU2j8mS+M5B69zt5z8Zctz9L0pLE4sGqBuvhOLlcEWjcf3SKmqQ
         PoGuBOdmF/Ap+eM6yTangUVgJRwm8FPV7n0509PdAt/rkhHihqttz7IJz3pN/lUi/w+X
         nk2qE/8EBwLndEYcEJUKK0pboHEnKBodFAP42f0+9FPeP2xGBAxwcUKZRsZF4Yeqa8//
         UwxQ34ndwTFaq0pLtwm/srAYwSTpAPkbHDsULSdDj6j840j/XEuTA89xAW6VR5VJUS1U
         roiFFbDUx4sHckbVgAEYPnTs2BRlSnVZHY6haLowGMJoS3brLxQ6slpPX5zqh0nO1meB
         X6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ufXk8FbbGAqNsL++C+ffXL+0StpdtfyJkwi67F2ahYw=;
        b=Ec4SJUXyM2PzNTkrHnywrpX6RXHTpq1fBCgjL7Memz92RA4j+uA8FqKS/jNrHK85AE
         kVWJJ2ZxkdFKxQ/5HyctrhnwdLht7cRq4iQdXM9i8eEeHDeaU8wtuRlJQxcUzBbUtXw5
         BlCqD42IJ4mSmyXfA67ntwdxcuJnWMvIAtuYs77Ldg/w4p9O80ao7Lt+n0/yTWl7OECV
         ZLsRAQ4ic0U8ajehSnlWqzwfQJ7CFEUHu+w80gdwSfvPPJpk5q1kYKQ22HFea+wsPWZT
         +t/loJ2IPwQrYahR0kukj2g6FE8Z1Mooo987H99Ohj9E1wnH4GsnPCgzOVQLMG+By5mY
         JpZg==
X-Gm-Message-State: AJIora/ouj4s4T+e4ATwzwRV83TmY7dw9dq0nNwuBfJvAfdXDb27q9ET
        hjQFRlNIWIRetebOgu9M590utaUMfq8=
X-Google-Smtp-Source: AGRyM1tCDgyLLNh5+7wuKqZxI7GFhu6lVWZpMqphcumkOhPn5wiEtChcUN+PVc0rhtIyJhx4ieAXIg==
X-Received: by 2002:a05:6a02:113:b0:412:a7c0:da8e with SMTP id bg19-20020a056a02011300b00412a7c0da8emr5646066pgb.113.1657325428257;
        Fri, 08 Jul 2022 17:10:28 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id e25-20020aa79819000000b00528d580cb45sm157054pfl.127.2022.07.08.17.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 17:10:27 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id B1FDD3603FB; Sat,  9 Jul 2022 12:10:24 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v1 4/4] scsi - convert mvme147_scsi driver to DMA API
Date:   Sat,  9 Jul 2022 12:10:19 +1200
Message-Id: <20220709001019.11149-5-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220709001019.11149-1-schmitzmic@gmail.com>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert mvme147_scsi to DMA API to eliminate one of the last
usages of virt_to_bus().

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/mvme147.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index aa6476c3e70c..6ffd15f08629 100644
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
@@ -94,6 +104,11 @@ static int __init mvme147_scsi_probe(struct platform_device *pdev)
 	struct WD33C93_hostdata *hdata;
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

