Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F305FCCA47B
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiGIAKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiGIAKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:10:31 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D577CB45;
        Fri,  8 Jul 2022 17:10:28 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id r1so85543plo.10;
        Fri, 08 Jul 2022 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9ULivGPT7hmqeNxcKMPRUFSX3KZmis0fdluyTBOTsWs=;
        b=YCFPYOBgwKKExSXr6X3TeGB17Nq4yWdSznIm9MQXTjXJIz7sxg6fM7uQhO6/aCIHbc
         j+Jk6h5UOV0DLEbnTkbnkxLhuidDDIwCnfpjgwhlxYZG7bbU5C8Zj1ktZ6CFEGLmVluU
         TqvOwQUencW1B5zAQrgoNun7FUEN0FwUXLeK8OSj1R4in0/BYyxM4fAz+JSAfu3kE/KH
         uZAgF4D4dXTsKb66b5z45m70xvg/Gy/waHfgE4gHMAoR794UliKn9Hl3DlnCVIHsp7oV
         PjbP4zruIEDg+Xb9ekVCWhdTd+oWw8ndrmfoa6cE3WI3sQUHiGccyy2Rhq3VqQClQokZ
         cIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9ULivGPT7hmqeNxcKMPRUFSX3KZmis0fdluyTBOTsWs=;
        b=mmggTzR36HnMRDXGHWXUUcwUJZeLr1ZAD+OpCS6elWd6a/YKXjT2dmac0KsNC7+4lK
         yPtWBey4q5dvvqZwHPwHoGyAMNbz1I81hxUcpf1VYxtK8ren3FZul9/AvNpsjCt1+IY9
         qJAIslcprN/IcpsLQ/870pjOB5g/in0uMFq5moOwPj/8n8a8imEr5UE1jwOVPr5BuyJV
         mdYGsnDmWAu1lGUL8JLDH+5Eks0apAIQZ4osZfA6Q32LpWXuzFgFFqBsE3yksuMC91CP
         zM8/IFE0MEefMfi94rPiaFd0Dy+dRjrD/D5qCqCDLa6XDUNus5Jy9ZSAD/2QUgcBPfKr
         sB/w==
X-Gm-Message-State: AJIora/3qOoh0r60iMM8A3avPpybyuvHYC2S7+dHc8CnhWl917kmg+6D
        oqHNZxv9iOSRZqKB3X6EMPs=
X-Google-Smtp-Source: AGRyM1uaprUB93915oK6sLdVf2PqUYRBd2Yd34JJG5ahp7uTuy0V2X/siKN9XW7Be0DF/dEMcHwycw==
X-Received: by 2002:a17:902:f54e:b0:16a:75a9:9a39 with SMTP id h14-20020a170902f54e00b0016a75a99a39mr6161963plf.70.1657325427588;
        Fri, 08 Jul 2022 17:10:27 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id b4-20020a1709027e0400b0016b81679c2asm93579plm.214.2022.07.08.17.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 17:10:27 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id B003A3603F6; Sat,  9 Jul 2022 12:10:23 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
Date:   Sat,  9 Jul 2022 12:10:18 +1200
Message-Id: <20220709001019.11149-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220709001019.11149-1-schmitzmic@gmail.com>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the mvme147_scsi driver to a platform device driver.
This is required for conversion of the driver to the DMA API.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/mvme147.c | 86 ++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index 472fa043094f..aa6476c3e70c 100644
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
@@ -85,40 +86,50 @@ static struct scsi_host_template mvme147_host_template = {
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
 
-	hdata = shost_priv(mvme147_shost);
+	mvme147_inst->base = mres->start;
+	mvme147_inst->irq = ires->start;
+
+	regs.SASR = (volatile unsigned char *)mres->start;
+	regs.SCMD = (volatile unsigned char *)(mres->start)+0x1;
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
@@ -133,30 +144,49 @@ static int __init mvme147_init(void)
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

