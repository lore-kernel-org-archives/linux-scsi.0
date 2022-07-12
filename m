Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430CACCA483
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 07:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiGLH6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiGLH6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 03:58:43 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45624391;
        Tue, 12 Jul 2022 00:58:40 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so10641494pjn.0;
        Tue, 12 Jul 2022 00:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QcZZ4ub4WwN95qjSoiSBbijtRxPDIIjCgWyTOxMJML4=;
        b=I97z6+j9/lUoZj5t0yWMuu9L5dGZG5KKpXOUfRndDCKSTSHaapwNcJkldvJXe+x9LB
         buOCRJgQI/Zugkaz44TMZ2/iYrnurG+BP9S8S1f4fHIpe4/rCk7B8YGsiE6EvlJ1fOka
         5BJAKyPLXfpjGI0xSnYmh0rVBdr1m3cmSl9w37OkY5pzwpKUPp8RlOtk+lxAPSsZqnA6
         1JzfXkqFg0MUaPN6HM833p3F2pFXVaTQR7NCLrTuGW5yFOjfZ7nRnauLYGdVN2oF9mvo
         bkWR4GXNU+TNjy/UV5tCuxul/xycvaBZQPCEx+WFn/Onc5zgfNeVVxElnvjKIfENYqbJ
         DBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QcZZ4ub4WwN95qjSoiSBbijtRxPDIIjCgWyTOxMJML4=;
        b=ElUaTm38WhAwWhbXeUBQjLN5Et76QCHqUqIDLaGXvz5TjPEozHqlBfnSGaodDnDCKi
         s+K1nbbo7gClLSE9hjfryy+qMT0NBHUjFjXZc169gnGRWWLDXb+vhvCZ5pHfHpHAmQnV
         oWA64lOsk1bMRuTWjxC1RBu1nZuRWtc3GX4xh3ipWQQQMsYoIAFFqbAHvhgcidky9Ilz
         oYgQz1W7Rdnvn9fDcNKFbvOLOPw/SVokf0V0cAZrBu7atGevcaButZIVG+iJBHa/YHug
         9IaQyXwOFReXEemCeHBC4aQKsqwq2UJ5eQGT6jttpoSp31KQspq2pGyWXPKK1vnQ4way
         1f7Q==
X-Gm-Message-State: AJIora92GTfvzFu1zeEFfKRMZzUzTGotTo8DW5rjgJa5KH1LJxcABHfS
        vlPg0AiWsuSCp4//Hs6Ycy4=
X-Google-Smtp-Source: AGRyM1ukLMtz9Ne++6ILvS2RzmFS6FcCOxWAIFQ/RR0OfmbJZvsfoLQNDcynP1mevFcf3jBLTnZJ5A==
X-Received: by 2002:a17:90a:f3c8:b0:1ef:7976:a6d8 with SMTP id ha8-20020a17090af3c800b001ef7976a6d8mr2857087pjb.198.1657612720326;
        Tue, 12 Jul 2022 00:58:40 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id jj9-20020a170903048900b0016be4d78792sm6076738plb.257.2022.07.12.00.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:58:40 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id E73243603FB; Tue, 12 Jul 2022 19:58:36 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v2 4/5] scsi - convert mvme147.c driver to platform device
Date:   Tue, 12 Jul 2022 19:58:31 +1200
Message-Id: <20220712075832.23793-5-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712075832.23793-1-schmitzmic@gmail.com>
References: <20220712075832.23793-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the mvme147.c driver to a platform device driver.
This is required for conversion of the driver to the DMA API.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

--

Changes from v1:

- change patch index from 3 to 3 (due to insertion of m68k kmap patch)

Arnd Bergmann:
- use devm_platform_ioremap_resource() for wd33c93 base address
---
 drivers/scsi/mvme147.c | 89 +++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index 472fa043094f..ea8afeec8e56 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -85,40 +86,52 @@ static struct scsi_host_template mvme147_host_template = {
 	.cmd_size		= sizeof(struct scsi_pointer),
 };
 
-static struct Scsi_Host *mvme147_shost;
-
-static int __init mvme147_init(void)
+static int __init mvme147_scsi_probe(struct platform_device *pdev)
 {
+	struct resource *mres, *ires;
+	struct Scsi_Host *mvme147_inst;
 	wd33c93_regs regs;
 	struct WD33C93_hostdata *hdata;
+	void __iomem *base;
 	int error = -ENOMEM;
 
-	if (!MACH_IS_MVME147)
-		return 0;
+	mres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mres)
+		return -ENODEV;
+
+	ires = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!ires)
+		return -ENODEV;
+
+	if (!request_mem_region(mres->start, resource_size(mres), "wd33c93"))
+		return -EBUSY;
 
-	mvme147_shost = scsi_host_alloc(&mvme147_host_template,
+	mvme147_inst = scsi_host_alloc(&mvme147_host_template,
 			sizeof(struct WD33C93_hostdata));
-	if (!mvme147_shost)
+	if (!mvme147_inst)
 		goto err_out;
-	mvme147_shost->base = 0xfffe4000;
-	mvme147_shost->irq = MVME147_IRQ_SCSI_PORT;
 
-	regs.SASR = (volatile unsigned char *)0xfffe4000;
-	regs.SCMD = (volatile unsigned char *)0xfffe4001;
+	base = devm_platform_ioremap_resource(pdev, 0);
 
-	hdata = shost_priv(mvme147_shost);
+	mvme147_inst->base = (unsigned int) base;
+	mvme147_inst->irq = ires->start;
+
+	regs.SASR = (volatile unsigned char *)base;
+	regs.SCMD = (volatile unsigned char *)(base+1);
+
+	hdata = shost_priv(mvme147_inst);
 	hdata->no_sync = 0xff;
 	hdata->fast = 0;
 	hdata->dma_mode = CTRL_DMA;
 
-	wd33c93_init(mvme147_shost, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
+	wd33c93_init(mvme147_inst, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
 
-	error = request_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr, 0,
-			"MVME147 SCSI PORT", mvme147_shost);
+	error = request_irq(ires->start, mvme147_intr, 0,
+			"MVME147 SCSI PORT", mvme147_inst);
 	if (error)
 		goto err_unregister;
-	error = request_irq(MVME147_IRQ_SCSI_DMA, mvme147_intr, 0,
-			"MVME147 SCSI DMA", mvme147_shost);
+	error = request_irq(ires->start+1, mvme147_intr, 0,
+			"MVME147 SCSI DMA", mvme147_inst);
 	if (error)
 		goto err_free_irq;
 #if 0	/* Disabled; causes problems booting */
@@ -133,30 +146,50 @@ static int __init mvme147_init(void)
 	m147_pcc->dma_cntrl = 0x00;	/* ensure DMA is stopped */
 	m147_pcc->dma_intr = 0x89;	/* Ack and enable ints */
 
-	error = scsi_add_host(mvme147_shost, NULL);
+	error = scsi_add_host(mvme147_inst, &pdev->dev);
 	if (error)
 		goto err_free_irq;
-	scsi_scan_host(mvme147_shost);
+
+	platform_set_drvdata(pdev, mvme147_inst);
+
+	scsi_scan_host(mvme147_inst);
 	return 0;
 
 err_free_irq:
-	free_irq(MVME147_IRQ_SCSI_PORT, mvme147_shost);
+	free_irq(ires->start, mvme147_inst);
 err_unregister:
-	scsi_host_put(mvme147_shost);
+	scsi_host_put(mvme147_inst);
 err_out:
 	return error;
 }
 
-static void __exit mvme147_exit(void)
+static int __exit mvme147_scsi_remove(struct platform_device *pdev)
 {
-	scsi_remove_host(mvme147_shost);
+	struct Scsi_Host *mvme147_inst = platform_get_drvdata(pdev);
+	struct resource *mres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *ires = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	scsi_remove_host(mvme147_inst);
 
 	/* XXX Make sure DMA is stopped! */
-	free_irq(MVME147_IRQ_SCSI_PORT, mvme147_shost);
-	free_irq(MVME147_IRQ_SCSI_DMA, mvme147_shost);
+	free_irq(ires->start, mvme147_inst);
+	free_irq(ires->start+1, mvme147_inst);
 
-	scsi_host_put(mvme147_shost);
+	iounmap((void __iomem *)mvme147_inst->base);
+	scsi_host_put(mvme147_inst);
+	release_mem_region(mres->start, resource_size(mres));
+	return 0;
 }
 
-module_init(mvme147_init);
-module_exit(mvme147_exit);
+static struct platform_driver mvme147_scsi_driver = {
+	.remove = __exit_p(mvme147_scsi_remove),
+	.driver   = {
+		.name	= "mvme147-scsi",
+	},
+};
+
+module_platform_driver_probe(mvme147_scsi_driver, mvme147_scsi_probe);
+
+MODULE_DESCRIPTION("MVME147 built-in SCSI");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:mvme147-scsi");
-- 
2.17.1

