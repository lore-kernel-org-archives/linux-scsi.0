From: willy@parisc-linux.org (Matthew Wilcox)
Subject: [PATCH] [1/5] Misc Lasi 700 fixes
Date: Fri, 18 Mar 2005 20:56:21 -0700 (MST)
Message-ID: <20050319035621.6B4EC496108@palinux.hppa>
Received: from palinux.external.hp.com ([192.25.206.14]:49299 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S262045AbVCSD4Y
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 22:56:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Misc Lasi 700 fixes

 - Use the DMA_32BIT_MASK constants when calling dma_set_mask()

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>
Signed-off-by: Matthew Wilcox <willy@parisc-linux.org>

 - ioremap fixes

Signed-off-by: Matthew Wilcox <willy@parisc-linux.org>

diff -urpNX dontdiff linus-2.6/drivers/scsi/lasi700.c parisc-2.6/drivers/scsi/lasi700.c
--- linus-2.6/drivers/scsi/lasi700.c	2005-03-18 06:21:11.324519230 -0700
+++ parisc-2.6/drivers/scsi/lasi700.c	2005-03-18 06:03:01.000000000 -0700
@@ -111,8 +111,8 @@ lasi700_probe(struct parisc_device *dev)
 	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
 
 	hostdata->dev = &dev->dev;
-	dma_set_mask(&dev->dev, 0xffffffffUL);
-	hostdata->base = base;
+	dma_set_mask(&dev->dev, DMA_32BIT_MASK);
+	hostdata->base = ioremap(base, 0x100);
 	hostdata->differential = 0;
 
 	if (dev->id.sversion == LASI_700_SVERSION) {
@@ -138,6 +138,7 @@ lasi700_probe(struct parisc_device *dev)
 	return 0;
 
  out_kfree:
+	iounmap(hostdata->base);
 	kfree(hostdata);
 	return -ENODEV;
 }
@@ -152,6 +153,7 @@ lasi700_driver_remove(struct parisc_devi
 	scsi_remove_host(host);
 	NCR_700_release(host);
 	free_irq(host->irq, host);
+	iounmap(hostdata->base);
 	kfree(hostdata);
 
 	return 0;
