From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 4/5] scsi: sun3x: use module_platform_driver() and platform_{set,get}_drvdata
Date: Thu, 30 May 2013 20:09:45 +0800
Message-ID: <1369915786-2660-5-git-send-email-wangkefeng.wang@huawei.com>
References: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:16025 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3E3MMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 May 2013 08:12:50 -0400
In-Reply-To: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guohanjun@huawei.com, Kefeng Wang <wangkefeng.wang@huawei.com>

Use helper macro and wrapper functions to simpily code.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/scsi/sun3x_esp.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 534eb96..4c9a2b4 100644
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
 
@@ -299,21 +299,11 @@ static struct platform_driver esp_sun3x_driver = {
 	},
 };
 
-static int __init sun3x_esp_init(void)
-{
-	return platform_driver_register(&esp_sun3x_driver);
-}
-
-static void __exit sun3x_esp_exit(void)
-{
-	platform_driver_unregister(&esp_sun3x_driver);
-}
+module_platform_driver(esp_sun3x_driver);
 
 MODULE_DESCRIPTION("Sun3x ESP SCSI driver");
 MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
-module_init(sun3x_esp_init);
-module_exit(sun3x_esp_exit);
 MODULE_ALIAS("platform:sun3x_esp");
-- 
1.8.2.1


