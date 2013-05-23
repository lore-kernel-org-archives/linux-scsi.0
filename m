From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] scsi: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:37:44 +0900
Message-ID: <002e01ce57a1$8f11e970$ad35bc50$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:37900 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab3EWKhp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 May 2013 06:37:45 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MN800DVHYTRVO80@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 23 May 2013 19:37:44 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Also, unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/jazz_esp.c   |    4 ++--
 drivers/scsi/qlogicpti.c  |    4 ++--
 drivers/scsi/sni_53c710.c |    4 ++--
 drivers/scsi/sun3x_esp.c  |    4 ++--
 drivers/scsi/sun_esp.c    |    6 ++----
 5 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 69efbf1..0063b1b 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -180,7 +180,7 @@ static int esp_jazz_probe(struct platform_device *dev)
 	esp->scsi_id_mask = (1 << esp->scsi_id);
 	esp->cfreq = 40000000;
 
-	dev_set_drvdata(&dev->dev, esp);
+	platform_set_drvdata(dev, esp);
 
 	err = scsi_esp_register(esp, &dev->dev);
 	if (err)
@@ -203,7 +203,7 @@ fail:
 
 static int esp_jazz_remove(struct platform_device *dev)
 {
-	struct esp *esp = dev_get_drvdata(&dev->dev);
+	struct esp *esp = platform_get_drvdata(dev);
 	unsigned int irq = esp->host->irq;
 
 	scsi_esp_unregister(esp);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 6d48d30..4ad93e8 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1367,7 +1367,7 @@ static int qpti_sbus_probe(struct platform_device *op)
 		goto fail_unmap_queues;
 	}
 
-	dev_set_drvdata(&op->dev, qpti);
+	platform_set_drvdata(op, qpti);
 
 	qpti_chain_add(qpti);
 
@@ -1404,7 +1404,7 @@ fail_unlink:
 
 static int qpti_sbus_remove(struct platform_device *op)
 {
-	struct qlogicpti *qpti = dev_get_drvdata(&op->dev);
+	struct qlogicpti *qpti = platform_get_drvdata(op);
 
 	qpti_chain_del(qpti);
 
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 52d54e7..4f5f3a2 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -104,7 +104,7 @@ static int snirm710_probe(struct platform_device *dev)
 		goto out_put_host;
 	}
 
-	dev_set_drvdata(&dev->dev, host);
+	platform_set_drvdata(dev, host);
 	scsi_scan_host(host);
 
 	return 0;
@@ -119,7 +119,7 @@ static int snirm710_probe(struct platform_device *dev)
 
 static int __exit snirm710_driver_remove(struct platform_device *dev)
 {
-	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
+	struct Scsi_Host *host = platform_get_drvdata(dev);
 	struct NCR_700_Host_Parameters *hostdata =
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 534eb96..2edbce3 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -244,7 +244,7 @@ static int esp_sun3x_probe(struct platform_device *dev)
 	esp->scsi_id_mask = (1 << esp->scsi_id);
 	esp->cfreq = 20000000;
 
-	dev_set_drvdata(&dev->dev, esp);
+	platform_set_drvdata(dev, esp);
 
 	err = scsi_esp_register(esp, &dev->dev);
 	if (err)
@@ -270,7 +270,7 @@ fail:
 
 static int esp_sun3x_remove(struct platform_device *dev)
 {
-	struct esp *esp = dev_get_drvdata(&dev->dev);
+	struct esp *esp = platform_get_drvdata(dev);
 	unsigned int irq = esp->host->irq;
 	u32 val;
 
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index f2e6845..db1397e 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -538,7 +538,7 @@ static int esp_sbus_probe_one(struct platform_device *op,
 		dma_write32(val & ~DMA_RST_SCSI, DMA_CSR);
 	}
 
-	dev_set_drvdata(&op->dev, esp);
+	platform_set_drvdata(op, esp);
 
 	err = scsi_esp_register(esp, &op->dev);
 	if (err)
@@ -585,7 +585,7 @@ static int esp_sbus_probe(struct platform_device *op)
 
 static int esp_sbus_remove(struct platform_device *op)
 {
-	struct esp *esp = dev_get_drvdata(&op->dev);
+	struct esp *esp = platform_get_drvdata(op);
 	struct platform_device *dma_of = esp->dma;
 	unsigned int irq = esp->host->irq;
 	bool is_hme;
@@ -611,8 +611,6 @@ static int esp_sbus_remove(struct platform_device *op)
 
 	scsi_host_put(esp->host);
 
-	dev_set_drvdata(&op->dev, NULL);
-
 	return 0;
 }
 
-- 
1.7.10.4


