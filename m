Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5528CCA479
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 07:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiGMHtz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 03:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbiGMHte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 03:49:34 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04CA6275;
        Wed, 13 Jul 2022 00:49:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8so9495889pjo.5;
        Wed, 13 Jul 2022 00:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=CrQsD7k2TGNgMpuMXvFQ6UJMpTWk7vqzcPn/bAxF6gM=;
        b=qujboVQv/GAXjx8T4a1mPg35RSjntq/W7Kk59w68Rf66kihbKNrAgGb6LdEeylGlqM
         jVOq6xzNLqZpyrCCRzmBN/gdEC30y1vqeG8Ow98FMUsssOh4VOTFPTyd749YSh6Hemk6
         b+o2n2TisuDoJwH9h+2MB08bzPce43qpMbbTUojh5OCTJmiSbjXSa538YVeAMfIjAGXh
         In3K90FhOtyJaR54UKtzbeFHAiJRnHjsUeoAeXLxl4Vkw5pBNYk9tuVod/PSp74kL49L
         9dNho8WKcwhu3dAwJUz99L3aFgbQ59/3S2xdi5ir8Drts1L2xC7gSwclyM9x39ysJ7PJ
         rfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CrQsD7k2TGNgMpuMXvFQ6UJMpTWk7vqzcPn/bAxF6gM=;
        b=yqC/bWxhKpe/WCsPJ0lAOIE4zedL/TbmuS0dIklVLPY4qUO3mTptc9Ta/CjV9oBQDr
         ZCV0iO9qtX+ddj2+dzmv6BDh6+5/nxNxM1cisj8jj9sDwLXtGujCp1JdSOGOOF/QhdEG
         YxvNFglkA5pOBSvsKP0LtxKvC+bt9+Czt58aRX5wRQHq2bGkXQbiZbPCQRFSRdzsr53p
         etukfcPbVg6SGWvsBUX8R5b4XtHZwjCYTEYU9q/8P74FHPUVG4tUIvaoI5rFwWDMuxij
         3XpadzFqFUi5nJL8vWTKDXNdSPQhXGf6p5UcL+oo002Efy7Bbj6XMEEKADlvq6T+sCcn
         mc0w==
X-Gm-Message-State: AJIora+Qr1dWFiC03dduzOfvKfSQnCfGkKhGDiFKiTXEE4cpyVDDwgAm
        ereo4dsB8NlpFa4JUPdGQL3OG//8q/w=
X-Google-Smtp-Source: AGRyM1ssVKpBfS/TmLe3l/dcTqoOvy80xaFXUvZf0au5gj4E8amKjhwBvqMNPOReGzC7GFXJzxssvQ==
X-Received: by 2002:a17:902:f708:b0:153:839f:bf2c with SMTP id h8-20020a170902f70800b00153839fbf2cmr1950221plo.113.1657698563483;
        Wed, 13 Jul 2022 00:49:23 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id d1-20020aa797a1000000b005259578e8fcsm8094979pfq.181.2022.07.13.00.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 00:49:23 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id EDDA536031B; Wed, 13 Jul 2022 19:49:19 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH] scsi - gvp11.c: fix DMA mask calculation error
Date:   Wed, 13 Jul 2022 19:49:13 +1200
Message-Id: <20220713074913.7873-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DMA masks given in the Zorro ID table don't contain the 2 byte
alignment quirk seen in the GVP11_XFER_MASK macro from gvp11.h
so no need to account for that.

DMA masks passed to dma_set_mask_and_coherent() must be 64 bit,
add the missing cast in the TO_DMA_MASK macro used to convert
driver DMA masks to DMA API masks.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Fixes: f4a09e5a3a36 ("scsi - gvp11.c: convert m68k WD33C93 drivers to DMA API")
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/gvp11.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index e8b7a09eb8c7..7d56a236a011 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -30,7 +30,7 @@ struct gvp11_hostdata {
 };
 
 #define DMA_DIR(d)   ((d == DATA_OUT_DIR) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)
-#define TO_DMA_MASK(m)	((~(m & 0xfffffff0))-1)
+#define TO_DMA_MASK(m)	(~((unsigned long long)m & 0xffffffff))
 
 static irqreturn_t gvp11_intr(int irq, void *data)
 {
@@ -334,7 +334,7 @@ static int gvp11_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 
 	if (dma_set_mask_and_coherent(&z->dev,
 		TO_DMA_MASK(default_dma_xfer_mask))) {
-		dev_warn(&z->dev, "cannot use DMA mask %x\n",
+		dev_warn(&z->dev, "cannot use DMA mask %llx\n",
 			 TO_DMA_MASK(default_dma_xfer_mask));
 		return -ENODEV;
 	}
@@ -383,7 +383,7 @@ static int gvp11_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 		hdata->wh.dma_xfer_mask = gvp11_xfer_mask;
 		if (dma_set_mask_and_coherent(&z->dev,
 			TO_DMA_MASK(gvp11_xfer_mask))) {
-			dev_warn(&z->dev, "cannot use DMA mask %x\n",
+			dev_warn(&z->dev, "cannot use DMA mask %llx\n",
 				 TO_DMA_MASK(gvp11_xfer_mask));
 			error = -ENODEV;
 			goto fail_check_or_alloc;
-- 
2.17.1

