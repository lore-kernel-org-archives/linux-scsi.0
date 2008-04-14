From: David Brownell <david-b@pacbell.net>
Subject: [patch 2.6.25-rc9] scsi: fix platform driver hotplug/coldplug
Date: Sun, 13 Apr 2008 20:06:24 -0700
Message-ID: <200804132006.24469.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:38033 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752709AbYDNDK6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 23:10:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kay.sievers@vrfy.org, linux-scsi@vger.kernel.org

=46rom: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias
is prefixed with "platform:". Add MODULE_ALIAS() to the hotpluggable
SCSI platform drivers, to re-enable auto loading.

[ dbrownell@users.sourceforge.net: more drivers, registration fixes ]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/scsi/jazz_esp.c   |    4 ++++
 drivers/scsi/sgiwd93.c    |    2 ++
 drivers/scsi/sni_53c710.c |    2 ++
 drivers/scsi/sun3x_esp.c  |    2 ++
 4 files changed, 10 insertions(+)

--- g26.orig/drivers/scsi/jazz_esp.c	2008-04-13 19:48:19.000000000 -070=
0
+++ g26/drivers/scsi/jazz_esp.c	2008-04-13 19:48:57.000000000 -0700
@@ -217,11 +217,15 @@ static int __devexit esp_jazz_remove(str
 	return 0;
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:jazz_esp");
+
 static struct platform_driver esp_jazz_driver =3D {
 	.probe		=3D esp_jazz_probe,
 	.remove		=3D __devexit_p(esp_jazz_remove),
 	.driver	=3D {
 		.name	=3D "jazz_esp",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
--- g26.orig/drivers/scsi/sgiwd93.c	2008-04-13 19:35:17.000000000 -0700
+++ g26/drivers/scsi/sgiwd93.c	2008-04-13 19:49:16.000000000 -0700
@@ -313,6 +313,7 @@ static struct platform_driver sgiwd93_dr
 	.remove =3D __devexit_p(sgiwd93_remove),
 	.driver =3D {
 		.name   =3D "sgiwd93"
+		.owner	=3D THIS_MODULE,
 	}
 };
=20
@@ -332,3 +333,4 @@ module_exit(sgiwd93_module_exit);
 MODULE_DESCRIPTION("SGI WD33C93 driver");
 MODULE_AUTHOR("Ralf Baechle <ralf@linux-mips.org>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sgiwd93");
--- g26.orig/drivers/scsi/sni_53c710.c	2008-04-13 19:35:17.000000000 -0=
700
+++ g26/drivers/scsi/sni_53c710.c	2008-04-13 20:02:00.000000000 -0700
@@ -53,6 +53,7 @@
 MODULE_AUTHOR("Thomas Bogend=F6rfer");
 MODULE_DESCRIPTION("SNI RM 53c710 SCSI Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:snirm_53c710");
=20
 #define SNIRM710_CLOCK	32
=20
@@ -136,6 +137,7 @@ static struct platform_driver snirm710_d
 	.remove	=3D __devexit_p(snirm710_driver_remove),
 	.driver	=3D {
 		.name	=3D "snirm_53c710",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
--- g26.orig/drivers/scsi/sun3x_esp.c	2008-04-13 19:35:17.000000000 -07=
00
+++ g26/drivers/scsi/sun3x_esp.c	2008-04-13 19:50:02.000000000 -0700
@@ -294,6 +294,7 @@ static struct platform_driver esp_sun3x_
 	.remove         =3D __devexit_p(esp_sun3x_remove),
 	.driver =3D {
 		.name   =3D "sun3x_esp",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -314,3 +315,4 @@ MODULE_VERSION(DRV_VERSION);
=20
 module_init(sun3x_esp_init);
 module_exit(sun3x_esp_exit);
+MODULE_ALIAS("platform:sun3x_esp");
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
