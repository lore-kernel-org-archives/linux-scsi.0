From: Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] [SCSI] use module_platform_driver()
Date: Wed,  9 Apr 2014 09:26:11 +0200
Message-ID: <1397028371-30709-1-git-send-email-christophjaeger@linux.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:60184 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaDIH0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 03:26:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Jaeger <christophjaeger@linux.com>

Eliminate a bunch of boilerplate code by using module_platform_driver().

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/scsi/jazz_esp.c   | 13 +------------
 drivers/scsi/mac_esp.c    | 13 +------------
 drivers/scsi/qlogicpti.c  | 13 +------------
 drivers/scsi/sgiwd93.c    | 13 +------------
 drivers/scsi/sni_53c710.c | 13 +------------
 drivers/scsi/sun3x_esp.c  | 13 +------------
 drivers/scsi/sun_esp.c    | 13 +------------
 7 files changed, 7 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 69efbf1..80f66c9 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
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
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 994fc5c..d7d2d6b 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -621,21 +621,10 @@ static struct platform_driver esp_mac_driver = {
 	},
 };
 
-static int __init mac_esp_init(void)
-{
-	return platform_driver_register(&esp_mac_driver);
-}
-
-static void __exit mac_esp_exit(void)
-{
-	platform_driver_unregister(&esp_mac_driver);
-}
+module_platform_driver(esp_mac_driver);
 
 MODULE_DESCRIPTION("Mac ESP SCSI driver");
 MODULE_AUTHOR("Finn Thain <fthain@telegraphics.com.au>");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_MODULE_NAME);
-
-module_init(mac_esp_init);
-module_exit(mac_esp_exit);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 6d48d30..b7643e6 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1462,21 +1462,10 @@ static struct platform_driver qpti_sbus_driver = {
 	.remove		= qpti_sbus_remove,
 };
 
-static int __init qpti_init(void)
-{
-	return platform_driver_register(&qpti_sbus_driver);
-}
-
-static void __exit qpti_exit(void)
-{
-	platform_driver_unregister(&qpti_sbus_driver);
-}
+module_platform_driver(qpti_sbus_driver);
 
 MODULE_DESCRIPTION("QlogicISP SBUS driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("2.1");
 MODULE_FIRMWARE("qlogic/isp1000.bin");
-
-module_init(qpti_init);
-module_exit(qpti_exit);
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index a464d95..11307be 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -319,18 +319,7 @@ static struct platform_driver sgiwd93_driver = {
 	}
 };
 
-static int __init sgiwd93_module_init(void)
-{
-	return platform_driver_register(&sgiwd93_driver);
-}
-
-static void __exit sgiwd93_module_exit(void)
-{
-	return platform_driver_unregister(&sgiwd93_driver);
-}
-
-module_init(sgiwd93_module_init);
-module_exit(sgiwd93_module_exit);
+module_platform_driver(sgiwd93_driver);
 
 MODULE_DESCRIPTION("SGI WD33C93 driver");
 MODULE_AUTHOR("Ralf Baechle <ralf@linux-mips.org>");
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 52d54e7..5528bae 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -141,15 +141,4 @@ static struct platform_driver snirm710_driver = {
 	},
 };
 
-static int __init snirm710_init(void)
-{
-	return platform_driver_register(&snirm710_driver);
-}
-
-static void __exit snirm710_exit(void)
-{
-	platform_driver_unregister(&snirm710_driver);
-}
-
-module_init(snirm710_init);
-module_exit(snirm710_exit);
+module_platform_driver(snirm710_driver);
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 534eb96..438da93 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -299,21 +299,10 @@ static struct platform_driver esp_sun3x_driver = {
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
-
-module_init(sun3x_esp_init);
-module_exit(sun3x_esp_exit);
 MODULE_ALIAS("platform:sun3x_esp");
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index f2e6845..d8ece284 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -640,20 +640,9 @@ static struct platform_driver esp_sbus_driver = {
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
1.9.0

