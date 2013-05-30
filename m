From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 2/5] scsi: sun: use module_platform_driver() and platform_{set,get}_drvdata
Date: Thu, 30 May 2013 20:09:43 +0800
Message-ID: <1369915786-2660-3-git-send-email-wangkefeng.wang@huawei.com>
References: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:36439 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3E3MKt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 May 2013 08:10:49 -0400
In-Reply-To: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guohanjun@huawei.com, Kefeng Wang <wangkefeng.wang@huawei.com>

Use helper macro and wrapper functions to simpily code. Meanwhile,
remove unnecessary drvdata set to null due to commint 0998d0631
(device-core: Ensure drvdata = NULL when no driver is bound).

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/scsi/sun_esp.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index f2e6845..b7361a6 100644
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
 
@@ -640,20 +638,9 @@ static struct platform_driver esp_sbus_driver = {
 	.remove		= esp_sbus_remove,
 };
 
-static int __init sunesp_init(void)
-{
-	return platform_driver_register(&esp_sbus_driver);
-}
-
-static void __exit sunesp_exit(void)
-{
-	platform_driver_unregister(&esp_sbus_driver);
-}
+module_platform_driver(esp_sbus_driver);
 
 MODULE_DESCRIPTION("Sun ESP SCSI driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sunesp_init);
-module_exit(sunesp_exit);
-- 
1.8.2.1


