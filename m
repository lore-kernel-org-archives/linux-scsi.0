From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: [PATCH] Cleanup sni_53c710
Date: Wed, 11 Jul 2007 19:09:36 +0200
Message-ID: <20070711170936.GB19910@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:42570 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262AbXGKSoZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2007 14:44:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

- base address is now a physical address; no need to convert it
- remove not needed error printk in module init function

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index a7dfb65..0a6b45b 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -84,7 +84,7 @@ static int __init snirm710_probe(struct platform_device *dev)
 
 	hostdata->dev = &dev->dev;
 	dma_set_mask(&dev->dev, DMA_32BIT_MASK);
-	hostdata->base = ioremap_nocache(CPHYSADDR(base), 0x100);
+	hostdata->base = ioremap_nocache(base, 0x100);
 	hostdata->differential = 0;
 
 	hostdata->clock = SNIRM710_CLOCK;
@@ -141,13 +141,7 @@ static struct platform_driver snirm710_driver = {
 
 static int __init snirm710_init(void)
 {
-	int err;
-
-	if ((err = platform_driver_register(&snirm710_driver))) {
-		printk(KERN_ERR "Driver registration failed\n");
-		return err;
-	}
-	return 0;
+	return platform_driver_register(&snirm710_driver);
 }
 
 static void __exit snirm710_exit(void)

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
