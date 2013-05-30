From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/5] scsi: jazz: use module_platform_driver() and platform_{set,get}_drvdata
Date: Thu, 30 May 2013 20:09:42 +0800
Message-ID: <1369915786-2660-2-git-send-email-wangkefeng.wang@huawei.com>
References: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guohanjun@huawei.com, Kefeng Wang <wangkefeng.wang@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Use helper macro and wrapper functions to simpily code.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/scsi/jazz_esp.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 69efbf1..08fa257 100644
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
@@ -230,20 +230,9 @@ static struct platform_driver esp_jazz_driver = {
 	},
 };
 
-static int __init jazz_esp_init(void)
-{
-	return platform_driver_register(&esp_jazz_driver);
-}
-
-static void __exit jazz_esp_exit(void)
-{
-	platform_driver_unregister(&esp_jazz_driver);
-}
+module_platform_driver(esp_jazz_driver);
 
 MODULE_DESCRIPTION("JAZZ ESP SCSI driver");
 MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(jazz_esp_init);
-module_exit(jazz_esp_exit);
-- 
1.8.2.1
