From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] scsi: Use module_platform_driver
Date: Wed, 8 Jul 2015 10:17:28 +0530
Message-ID: <20150708044728.GA11024@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34352 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbGHEre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 00:47:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Use module_platform_driver for drivers whose init and exit functions
only register and unregister, respectively.

A simplified version of the Coccinelle semantic patch that performs
this transformation is as follows:

@a@
identifier f, x;
@@
-static f(...) { return platform_driver_register(&x); }

@b depends on a@
identifier e, a.x;
@@
-static e(...) { platform_driver_unregister(&x); }

@c depends on a && b@
identifier a.f;
declarer name module_init;
@@
-module_init(f);

@d depends on a && b && c@
identifier b.e, a.x;
declarer name module_exit;
declarer name module_platform_driver;
@@
-module_exit(e);
+module_platform_driver(x);

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/scsi/jazz_esp.c   | 14 +-------------
 drivers/scsi/mac_esp.c    | 14 +-------------
 drivers/scsi/qlogicpti.c  | 14 +-------------
 drivers/scsi/sni_53c710.c | 14 +-------------
 drivers/scsi/sun3x_esp.c  | 14 +-------------
 drivers/scsi/sun_esp.c    | 14 +-------------
 6 files changed, 6 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 9aaa74e..003c455 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -229,20 +229,8 @@ static struct platform_driver esp_jazz_driver = {
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
-
 MODULE_DESCRIPTION("JAZZ ESP SCSI driver");
 MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(jazz_esp_init);
-module_exit(jazz_esp_exit);
+module_platform_driver(esp_jazz_driver);
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 14c0334..30906ae 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -620,21 +620,9 @@ static struct platform_driver esp_mac_driver = {
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
-
 MODULE_DESCRIPTION("Mac ESP SCSI driver");
 MODULE_AUTHOR("Finn Thain <fthain@telegraphics.com.au>");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_MODULE_NAME);
-
-module_init(mac_esp_init);
-module_exit(mac_esp_exit);
+module_platform_driver(esp_mac_driver);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 676385f..a63c6ea 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1460,21 +1460,9 @@ static struct platform_driver qpti_sbus_driver = {
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
-
 MODULE_DESCRIPTION("QlogicISP SBUS driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("2.1");
 MODULE_FIRMWARE("qlogic/isp1000.bin");
-
-module_init(qpti_init);
-module_exit(qpti_exit);
+module_platform_driver(qpti_sbus_driver);
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 7627807..eb74dbb 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -139,16 +139,4 @@ static struct platform_driver snirm710_driver = {
 		.name	= "snirm_53c710",
 	},
 };
-
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
index e26e81d..c1214bf 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -298,21 +298,9 @@ static struct platform_driver esp_sun3x_driver = {
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
-
 MODULE_DESCRIPTION("Sun3x ESP SCSI driver");
 MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sun3x_esp_init);
-module_exit(sun3x_esp_exit);
+module_platform_driver(esp_sun3x_driver);
 MODULE_ALIAS("platform:sun3x_esp");
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 7b6d4c2..ecbe4c2 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -639,20 +639,8 @@ static struct platform_driver esp_sbus_driver = {
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
-
 MODULE_DESCRIPTION("Sun ESP SCSI driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sunesp_init);
-module_exit(sunesp_exit);
+module_platform_driver(esp_sbus_driver);
-- 
1.9.1

