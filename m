From: Axel Lin <axel.lin@gmail.com>
Subject: [PATCH] scsi: convert drivers/scsi/* to use module_platform_driver()
Date: Sat, 26 Nov 2011 21:52:07 +0800
Message-ID: <1322315527.15832.1.camel@phoenix>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55960 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1KZNwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Nov 2011 08:52:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Finn Thain <fthain@telegraphics.com.au>, "David S. Miller" <davem@davemloft.net>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

This patch converts the drivers in drivers/scsi/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/scsi/jazz_esp.c   |   17 ++---------------
 drivers/scsi/mac_esp.c    |   13 +------------
 drivers/scsi/qlogicpti.c  |   13 +------------
 drivers/scsi/sgiwd93.c    |   13 +------------
 drivers/scsi/sni_53c710.c |   13 +------------
 drivers/scsi/sun3x_esp.c  |   13 +------------
 drivers/scsi/sun_esp.c    |   13 +------------
 7 files changed, 8 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 08e26d4..5c999ac 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -218,9 +218,6 @@ static int __devexit esp_jazz_remove(struct platform_device *dev)
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:jazz_esp");
-
 static struct platform_driver esp_jazz_driver = {
 	.probe		= esp_jazz_probe,
 	.remove		= __devexit_p(esp_jazz_remove),
@@ -230,20 +227,10 @@ static struct platform_driver esp_jazz_driver = {
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
+MODULE_ALIAS("platform:jazz_esp");
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 4ceeace..1246c63 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -622,21 +622,10 @@ static struct platform_driver esp_mac_driver = {
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
index e40dc1c..c2b19a4 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1474,21 +1474,10 @@ static struct platform_driver qpti_sbus_driver = {
 	.remove		= __devexit_p(qpti_sbus_remove),
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
index 3a9d85c..c8b0b53 100644
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
index 9acc2b2..8317752 100644
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
index 0621037..a7f93a2 100644
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
index 676fe9a..a53f5cf 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -642,20 +642,9 @@ static struct platform_driver esp_sbus_driver = {
 	.remove		= __devexit_p(esp_sbus_remove),
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
1.7.5.4



