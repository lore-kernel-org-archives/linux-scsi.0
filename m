Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD99C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 02:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiGMC4R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 22:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiGMC4K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 22:56:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085CFB1C1;
        Tue, 12 Jul 2022 19:56:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v7so7025962pfb.0;
        Tue, 12 Jul 2022 19:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8kSolpFpfll2jRagRjitUaLZvrjSNiOy/OAh9cabmLo=;
        b=PBvqEbSNQmE/cQ+HqYKJX35P5gIKbXyXKjovZLeJ8W43luZ0TwvcrzLR9J0/lPumGu
         30sc5/KcF9IwFNGrpXpDFAM/JtgCN4XgV8cxtvhFPhgC5LMKfkJ2XvTgqhjzIZtzoGRM
         FU6vLRHwqGpnm+AUsCgz9431MrzyAgsBnEp+yTzJywGnJ7+/Utv9Z/LFba5xPy/uB+bo
         Ahq+djXwMWhIGA3j1kxAJZP6nzIZfojeYgTzKHA34oAnfhEFVLYIZ7AWwBbBkVoaxfbr
         uWnOlKVpfG6HjcQVd+NqrcwyHaerrFyXrew9BMVe/VH6Unoy6xE4JRhT5964vzyJXUUD
         tugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8kSolpFpfll2jRagRjitUaLZvrjSNiOy/OAh9cabmLo=;
        b=fA+1B7PtJffRaadfTnEcKgUz73GF1QUVFhwNXAsVTdz+9EMshDAFiR8jt5tnvavLV2
         NN+fOv9gpJWbxNEyC0RhWBzuCjR/H0AElweLMkA8IPqdf5/NI+H0GlKxcK1JKeMM8KLb
         NXBsQ/T25+0v5tsw/pT4gSOc7xT+C4wvcPGzEOYKXQ38XQJ50Ko38Ddpk/o1+M6HjCOk
         0IggzQ1xKyWsHd1CXJcq243D6PI35rGSMnDqGRD2Wi/etFccEL3G457u2lOiyTQRUk4n
         6KytFSXPOMwTYiqn0/AAfZCfL4YGCMKuGh46SGqWAkLqyVO4fsb9ityZYChI7hcN2FMU
         Vc9Q==
X-Gm-Message-State: AJIora+DyHuExS84mFLobkw/43S++NVTc+iGt1fqujSy/Bz2EGnfxYMg
        6Nj1huIRoOgLeGlElqQX/IYNgjZUXjc=
X-Google-Smtp-Source: AGRyM1vG9sPsFZDL9gXPOpK97+LxIIpjDxOBSqncO+NKnPzJyPaaX5AKitxbpwPtgH+rB7XD9srwEQ==
X-Received: by 2002:a63:82c6:0:b0:416:1717:4add with SMTP id w189-20020a6382c6000000b0041617174addmr1167648pgd.472.1657680968545;
        Tue, 12 Jul 2022 19:56:08 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id h29-20020aa79f5d000000b005289521b656sm7837407pfr.92.2022.07.12.19.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 19:56:08 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 0782F3603FB; Wed, 13 Jul 2022 14:56:04 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v3 4/5] scsi - convert mvme147.c driver to platform device
Date:   Wed, 13 Jul 2022 14:56:00 +1200
Message-Id: <20220713025601.22584-5-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220713025601.22584-1-schmitzmic@gmail.com>
References: <20220713025601.22584-1-schmitzmic@gmail.com>
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

- change patch index from 3 to 4 (due to insertion of m68k kmap patch)

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

