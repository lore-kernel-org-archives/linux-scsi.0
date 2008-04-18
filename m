From: akpm@linux-foundation.org
Subject: [patch 01/10] scsi: fix platform driver hotplug/coldplug
Date: Fri, 18 Apr 2008 13:57:19 -0700
Message-ID: <200804182057.m3IKvKO6015354@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759201AbYDRU5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 16:57:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, kay.sievers@vrfy.org, dbrownell@users.sourceforge.net

=46rom: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias
is prefixed with "platform:". Add MODULE_ALIAS() to the hotpluggable
SCSI platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
[akpm@linux-foundation.org: fix sgiwd93.c]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/jazz_esp.c   |    4 ++++
 drivers/scsi/sgiwd93.c    |    4 +++-
 drivers/scsi/sni_53c710.c |    2 ++
 drivers/scsi/sun3x_esp.c  |    2 ++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/jazz_esp.c~scsi-fix-platform-driver-hotplug-cold=
plug drivers/scsi/jazz_esp.c
--- a/drivers/scsi/jazz_esp.c~scsi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/scsi/jazz_esp.c
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
diff -puN drivers/scsi/sgiwd93.c~scsi-fix-platform-driver-hotplug-coldp=
lug drivers/scsi/sgiwd93.c
--- a/drivers/scsi/sgiwd93.c~scsi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/scsi/sgiwd93.c
@@ -313,7 +313,8 @@ static struct platform_driver sgiwd93_dr
 	.probe  =3D sgiwd93_probe,
 	.remove =3D __devexit_p(sgiwd93_remove),
 	.driver =3D {
-		.name   =3D "sgiwd93"
+		.name   =3D "sgiwd93",
+		.owner	=3D THIS_MODULE,
 	}
 };
=20
@@ -333,3 +334,4 @@ module_exit(sgiwd93_module_exit);
 MODULE_DESCRIPTION("SGI WD33C93 driver");
 MODULE_AUTHOR("Ralf Baechle <ralf@linux-mips.org>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sgiwd93");
diff -puN drivers/scsi/sni_53c710.c~scsi-fix-platform-driver-hotplug-co=
ldplug drivers/scsi/sni_53c710.c
--- a/drivers/scsi/sni_53c710.c~scsi-fix-platform-driver-hotplug-coldpl=
ug
+++ a/drivers/scsi/sni_53c710.c
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
diff -puN drivers/scsi/sun3x_esp.c~scsi-fix-platform-driver-hotplug-col=
dplug drivers/scsi/sun3x_esp.c
--- a/drivers/scsi/sun3x_esp.c~scsi-fix-platform-driver-hotplug-coldplu=
g
+++ a/drivers/scsi/sun3x_esp.c
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
_
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
