From: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Subject: [PATCH 1/1] megaraid_{mbox,mm} : remove PCI Id overlaping between
	 megaraid_legacy and megaraid_{mbox,mm}
Date: Thu, 17 Nov 2005 13:17:25 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662C42@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5EBA3.297817A0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:54992 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932457AbVKQSRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 13:17:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'Daniel Drake' <dsd@gentoo.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Christoph Hellwig' <hch@infradead.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5EBA3.297817A0
Content-Type: text/plain

Hi,

This patch will fix the PCI ID overlaping issue between megaraid_legacy and
megaraid_{mm,mbox}.
The patch created against James's linux/kernel/git/jejb/scsi-misc-2.6.git/
tree.
Please review it and any comments would be appreciated.

Thank you,

Signed-off by : Seokmann Ju <seokmann.ju@enginio.com> 
---
diff -Naur old/Documentation/scsi/ChangeLog.megaraid
new/Documentation/scsi/ChangeLog.megaraid
--- old/Documentation/scsi/ChangeLog.megaraid	2005-11-14
14:21:52.060855080 -0500
+++ new/Documentation/scsi/ChangeLog.megaraid	2005-11-14
14:21:03.078301560 -0500
@@ -1,3 +1,38 @@
+Release Date	: Fri Nov 11 12:27:22 EST 2005 - Seokmann Ju <sju@lsil.com>
+Current Version : 2.20.4.7 (scsi module), 2.20.2.6 (cmm module)
+Older Version	: 2.20.4.6 (scsi module), 2.20.2.6 (cmm module)
+
+1.	Sorted out PCI IDs to remove megaraid support overlaps.
+	Based on the patch from Daniel, sorted out PCI IDs along with
+	charactor node name change from 'megadev' to 'megadev_legacy' to
avoid
+	conflict.
+	---
+	Hopefully we'll be getting the build restriction zapped much sooner,

+	but we should also be thinking about totally removing the hardware 
+	support overlap in the megaraid drivers.
+
+	This patch pencils in a date of Feb 06 for this, and performs some 
+	printk abuse in hope that existing legacy users might pick up on
what's
+	going on.
+
+	Signed-off-by: Daniel Drake <dsd@gentoo.org>
+	---
+
+2.	Fixed a issue: megaraid always fails to reset handler.
+	---
+	I found that the megaraid driver always fails to reset the
+	adapter with the following message:
+		megaraid: resetting the host...
+		megaraid mbox: reset sequence completed successfully
+		megaraid: fast sync command timed out
+		megaraid: reservation reset failed
+	when the "Cluster mode" of the adapter BIOS is enabled.
+	So, whenever the reset occurs, the adapter goes to
+	offline and just become unavailable.
+
+	Jun'ichi Nomura [mailto:jnomura@mtc.biglobe.ne.jp]
+	---
+
 Release Date	: Mon Mar 07 12:27:22 EST 2005 - Seokmann Ju <sju@lsil.com>
 Current Version : 2.20.4.6 (scsi module), 2.20.2.6 (cmm module)
 Older Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)
diff -Naur old/drivers/scsi/megaraid/Kconfig.megaraid
new/drivers/scsi/megaraid/Kconfig.megaraid
--- old/drivers/scsi/megaraid/Kconfig.megaraid	2005-11-14
13:44:06.602257136 -0500
+++ new/drivers/scsi/megaraid/Kconfig.megaraid	2005-11-14
14:11:35.811539216 -0500
@@ -64,7 +64,6 @@
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid_mbox
 
-if MEGARAID_NEWGEN=n
 config MEGARAID_LEGACY
 	tristate "LSI Logic Legacy MegaRAID Driver"
 	depends on PCI && SCSI
@@ -75,7 +74,6 @@
 
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid
-endif
 
 config MEGARAID_SAS
 	tristate "LSI Logic MegaRAID SAS RAID Module"
diff -Naur old/drivers/scsi/megaraid/megaraid_mbox.c
new/drivers/scsi/megaraid/megaraid_mbox.c
--- old/drivers/scsi/megaraid/megaraid_mbox.c	2005-11-14
13:44:06.604256832 -0500
+++ new/drivers/scsi/megaraid/megaraid_mbox.c	2005-11-14
14:19:05.309205184 -0500
@@ -10,12 +10,13 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_mbox.c
- * Version	: v2.20.4.6 (Mar 07 2005)
+ * Version	: v2.20.4.7 (Nov 14 2005)
  *
  * Authors:
  * 	Atul Mukker		<Atul.Mukker@lsil.com>
  * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsil.com>
  * 	Manoj Jose		<Manoj.Jose@lsil.com>
+ * 	Seokmann Ju		<Seokmann.Ju@lsil.com>
  *
  * List of supported controllers
  *
@@ -136,7 +137,7 @@
 
 
 
-MODULE_AUTHOR("LSI Logic Corporation");
+MODULE_AUTHOR("sju@lsil.com");
 MODULE_DESCRIPTION("LSI Logic MegaRAID Mailbox Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGARAID_VERSION);
@@ -278,68 +279,14 @@
 	{
 		PCI_VENDOR_ID_AMI,
 		PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_VENDOR_ID_DELL,
-		PCI_SUBSYS_ID_PERC3_QC,
-	},
-	{
-		PCI_VENDOR_ID_AMI,
-		PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_VENDOR_ID_DELL,
-		PCI_SUBSYS_ID_PERC3_DC,
-	},
-	{
-		PCI_VENDOR_ID_AMI,
-		PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_VENDOR_ID_DELL,
-		PCI_SUBSYS_ID_PERC3_SC,
-	},
-	{
-		PCI_VENDOR_ID_AMI,
-		PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_VENDOR_ID_AMI,
-		PCI_SUBSYS_ID_PERC3_SC,
-	},
-	{
-		PCI_VENDOR_ID_AMI,
-		PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_VENDOR_ID_AMI,
-		PCI_SUBSYS_ID_PERC3_DC,
-	},
-	{
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_DEVICE_ID_MEGARAID_SCSI_320_0,
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_SUBSYS_ID_MEGARAID_SCSI_320_0,
-	},
-	{
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_DEVICE_ID_MEGARAID_SCSI_320_1,
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_SUBSYS_ID_MEGARAID_SCSI_320_1,
-	},
-	{
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_DEVICE_ID_MEGARAID_SCSI_320_2,
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_SUBSYS_ID_MEGARAID_SCSI_320_2,
-	},
-	{
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_DEVICE_ID_MEGARAID_I4_133_RAID,
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_SUBSYS_ID_MEGARAID_I4_133_RAID,
-	},
-	{
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_DEVICE_ID_MEGARAID_SATA_150_4,
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_SUBSYS_ID_MEGARAID_SATA_150_4,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
 	},
 	{
 		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_DEVICE_ID_MEGARAID_SATA_150_6,
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_SUBSYS_ID_MEGARAID_SATA_150_6,
+		PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
 	},
 	{
 		PCI_VENDOR_ID_LSI_LOGIC,
@@ -347,18 +294,6 @@
 		PCI_ANY_ID,
 		PCI_ANY_ID,
 	},
-	{
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_DEVICE_ID_INTEL_RAID_SRCS16,
-		PCI_VENDOR_ID_INTEL,
-		PCI_SUBSYS_ID_INTEL_RAID_SRCS16,
-	},
-	{
-		PCI_VENDOR_ID_LSI_LOGIC,
-		PCI_DEVICE_ID_INTEL_RAID_SRCU41L_LAKE_SHETEK,
-		PCI_VENDOR_ID_INTEL,
-		PCI_SUBSYS_ID_INTEL_RAID_SRCU41L_LAKE_SHETEK,
-	},
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, pci_id_table_g);
@@ -2985,6 +2920,7 @@
 
 	for (i = 0; i < 0xFFFFF; i++) {
 		if (mbox->numstatus != 0xFF) break;
+		rmb();
 	}
 
 	if (i == 0xFFFFF) {
diff -Naur old/drivers/scsi/megaraid/megaraid_mbox.h
new/drivers/scsi/megaraid/megaraid_mbox.h
--- old/drivers/scsi/megaraid/megaraid_mbox.h	2005-11-14
13:44:06.604256832 -0500
+++ new/drivers/scsi/megaraid/megaraid_mbox.h	2005-11-14
14:18:54.123905608 -0500
@@ -21,8 +21,8 @@
 #include "megaraid_ioctl.h"
 
 
-#define MEGARAID_VERSION	"2.20.4.6"
-#define MEGARAID_EXT_VERSION	"(Release Date: Mon Mar 07 12:27:22 EST
2005)"
+#define MEGARAID_VERSION	"2.20.4.7"
+#define MEGARAID_EXT_VERSION	"(Release Date: Mon Nov 14 12:27:22 EST
2005)"
 
 
 /*
---


------_=_NextPart_000_01C5EBA3.297817A0
Content-Type: application/octet-stream;
	name="megaraid_mbox_for_git_2.6_scsi_misc.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="megaraid_mbox_for_git_2.6_scsi_misc.patch"

diff -Naur old/Documentation/scsi/ChangeLog.megaraid =
new/Documentation/scsi/ChangeLog.megaraid=0A=
--- old/Documentation/scsi/ChangeLog.megaraid	2005-11-14 =
14:21:52.060855080 -0500=0A=
+++ new/Documentation/scsi/ChangeLog.megaraid	2005-11-14 =
14:21:03.078301560 -0500=0A=
@@ -1,3 +1,38 @@=0A=
+Release Date	: Fri Nov 11 12:27:22 EST 2005 - Seokmann Ju =
<sju@lsil.com>=0A=
+Current Version : 2.20.4.7 (scsi module), 2.20.2.6 (cmm module)=0A=
+Older Version	: 2.20.4.6 (scsi module), 2.20.2.6 (cmm module)=0A=
+=0A=
+1.	Sorted out PCI IDs to remove megaraid support overlaps.=0A=
+	Based on the patch from Daniel, sorted out PCI IDs along with=0A=
+	charactor node name change from 'megadev' to 'megadev_legacy' to =
avoid=0A=
+	conflict.=0A=
+	---=0A=
+	Hopefully we'll be getting the build restriction zapped much sooner, =
=0A=
+	but we should also be thinking about totally removing the hardware =
=0A=
+	support overlap in the megaraid drivers.=0A=
+=0A=
+	This patch pencils in a date of Feb 06 for this, and performs some =
=0A=
+	printk abuse in hope that existing legacy users might pick up on =
what's=0A=
+	going on.=0A=
+=0A=
+	Signed-off-by: Daniel Drake <dsd@gentoo.org>=0A=
+	---=0A=
+=0A=
+2.	Fixed a issue: megaraid always fails to reset handler.=0A=
+	---=0A=
+	I found that the megaraid driver always fails to reset the=0A=
+	adapter with the following message:=0A=
+		megaraid: resetting the host...=0A=
+		megaraid mbox: reset sequence completed successfully=0A=
+		megaraid: fast sync command timed out=0A=
+		megaraid: reservation reset failed=0A=
+	when the "Cluster mode" of the adapter BIOS is enabled.=0A=
+	So, whenever the reset occurs, the adapter goes to=0A=
+	offline and just become unavailable.=0A=
+=0A=
+	Jun'ichi Nomura [mailto:jnomura@mtc.biglobe.ne.jp]=0A=
+	---=0A=
+=0A=
 Release Date	: Mon Mar 07 12:27:22 EST 2005 - Seokmann Ju =
<sju@lsil.com>=0A=
 Current Version : 2.20.4.6 (scsi module), 2.20.2.6 (cmm module)=0A=
 Older Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)=0A=
diff -Naur old/drivers/scsi/megaraid/Kconfig.megaraid =
new/drivers/scsi/megaraid/Kconfig.megaraid=0A=
--- old/drivers/scsi/megaraid/Kconfig.megaraid	2005-11-14 =
13:44:06.602257136 -0500=0A=
+++ new/drivers/scsi/megaraid/Kconfig.megaraid	2005-11-14 =
14:11:35.811539216 -0500=0A=
@@ -64,7 +64,6 @@=0A=
 	To compile this driver as a module, choose M here: the=0A=
 	module will be called megaraid_mbox=0A=
 =0A=
-if MEGARAID_NEWGEN=3Dn=0A=
 config MEGARAID_LEGACY=0A=
 	tristate "LSI Logic Legacy MegaRAID Driver"=0A=
 	depends on PCI && SCSI=0A=
@@ -75,7 +74,6 @@=0A=
 =0A=
 	To compile this driver as a module, choose M here: the=0A=
 	module will be called megaraid=0A=
-endif=0A=
 =0A=
 config MEGARAID_SAS=0A=
 	tristate "LSI Logic MegaRAID SAS RAID Module"=0A=
diff -Naur old/drivers/scsi/megaraid/megaraid_mbox.c =
new/drivers/scsi/megaraid/megaraid_mbox.c=0A=
--- old/drivers/scsi/megaraid/megaraid_mbox.c	2005-11-14 =
13:44:06.604256832 -0500=0A=
+++ new/drivers/scsi/megaraid/megaraid_mbox.c	2005-11-14 =
14:19:05.309205184 -0500=0A=
@@ -10,12 +10,13 @@=0A=
  *	   2 of the License, or (at your option) any later version.=0A=
  *=0A=
  * FILE		: megaraid_mbox.c=0A=
- * Version	: v2.20.4.6 (Mar 07 2005)=0A=
+ * Version	: v2.20.4.7 (Nov 14 2005)=0A=
  *=0A=
  * Authors:=0A=
  * 	Atul Mukker		<Atul.Mukker@lsil.com>=0A=
  * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsil.com>=0A=
  * 	Manoj Jose		<Manoj.Jose@lsil.com>=0A=
+ * 	Seokmann Ju		<Seokmann.Ju@lsil.com>=0A=
  *=0A=
  * List of supported controllers=0A=
  *=0A=
@@ -136,7 +137,7 @@=0A=
 =0A=
 =0A=
 =0A=
-MODULE_AUTHOR("LSI Logic Corporation");=0A=
+MODULE_AUTHOR("sju@lsil.com");=0A=
 MODULE_DESCRIPTION("LSI Logic MegaRAID Mailbox Driver");=0A=
 MODULE_LICENSE("GPL");=0A=
 MODULE_VERSION(MEGARAID_VERSION);=0A=
@@ -278,68 +279,14 @@=0A=
 	{=0A=
 		PCI_VENDOR_ID_AMI,=0A=
 		PCI_DEVICE_ID_AMI_MEGARAID3,=0A=
-		PCI_VENDOR_ID_DELL,=0A=
-		PCI_SUBSYS_ID_PERC3_QC,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_AMI,=0A=
-		PCI_DEVICE_ID_AMI_MEGARAID3,=0A=
-		PCI_VENDOR_ID_DELL,=0A=
-		PCI_SUBSYS_ID_PERC3_DC,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_AMI,=0A=
-		PCI_DEVICE_ID_AMI_MEGARAID3,=0A=
-		PCI_VENDOR_ID_DELL,=0A=
-		PCI_SUBSYS_ID_PERC3_SC,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_AMI,=0A=
-		PCI_DEVICE_ID_AMI_MEGARAID3,=0A=
-		PCI_VENDOR_ID_AMI,=0A=
-		PCI_SUBSYS_ID_PERC3_SC,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_AMI,=0A=
-		PCI_DEVICE_ID_AMI_MEGARAID3,=0A=
-		PCI_VENDOR_ID_AMI,=0A=
-		PCI_SUBSYS_ID_PERC3_DC,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_DEVICE_ID_MEGARAID_SCSI_320_0,=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_SUBSYS_ID_MEGARAID_SCSI_320_0,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_DEVICE_ID_MEGARAID_SCSI_320_1,=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_SUBSYS_ID_MEGARAID_SCSI_320_1,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_DEVICE_ID_MEGARAID_SCSI_320_2,=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_SUBSYS_ID_MEGARAID_SCSI_320_2,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_DEVICE_ID_MEGARAID_I4_133_RAID,=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_SUBSYS_ID_MEGARAID_I4_133_RAID,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_DEVICE_ID_MEGARAID_SATA_150_4,=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_SUBSYS_ID_MEGARAID_SATA_150_4,=0A=
+		PCI_ANY_ID,=0A=
+		PCI_ANY_ID,=0A=
 	},=0A=
 	{=0A=
 		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_DEVICE_ID_MEGARAID_SATA_150_6,=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_SUBSYS_ID_MEGARAID_SATA_150_6,=0A=
+		PCI_DEVICE_ID_AMI_MEGARAID3,=0A=
+		PCI_ANY_ID,=0A=
+		PCI_ANY_ID,=0A=
 	},=0A=
 	{=0A=
 		PCI_VENDOR_ID_LSI_LOGIC,=0A=
@@ -347,18 +294,6 @@=0A=
 		PCI_ANY_ID,=0A=
 		PCI_ANY_ID,=0A=
 	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_DEVICE_ID_INTEL_RAID_SRCS16,=0A=
-		PCI_VENDOR_ID_INTEL,=0A=
-		PCI_SUBSYS_ID_INTEL_RAID_SRCS16,=0A=
-	},=0A=
-	{=0A=
-		PCI_VENDOR_ID_LSI_LOGIC,=0A=
-		PCI_DEVICE_ID_INTEL_RAID_SRCU41L_LAKE_SHETEK,=0A=
-		PCI_VENDOR_ID_INTEL,=0A=
-		PCI_SUBSYS_ID_INTEL_RAID_SRCU41L_LAKE_SHETEK,=0A=
-	},=0A=
 	{0}	/* Terminating entry */=0A=
 };=0A=
 MODULE_DEVICE_TABLE(pci, pci_id_table_g);=0A=
@@ -2985,6 +2920,7 @@=0A=
 =0A=
 	for (i =3D 0; i < 0xFFFFF; i++) {=0A=
 		if (mbox->numstatus !=3D 0xFF) break;=0A=
+		rmb();=0A=
 	}=0A=
 =0A=
 	if (i =3D=3D 0xFFFFF) {=0A=
diff -Naur old/drivers/scsi/megaraid/megaraid_mbox.h =
new/drivers/scsi/megaraid/megaraid_mbox.h=0A=
--- old/drivers/scsi/megaraid/megaraid_mbox.h	2005-11-14 =
13:44:06.604256832 -0500=0A=
+++ new/drivers/scsi/megaraid/megaraid_mbox.h	2005-11-14 =
14:18:54.123905608 -0500=0A=
@@ -21,8 +21,8 @@=0A=
 #include "megaraid_ioctl.h"=0A=
 =0A=
 =0A=
-#define MEGARAID_VERSION	"2.20.4.6"=0A=
-#define MEGARAID_EXT_VERSION	"(Release Date: Mon Mar 07 12:27:22 EST =
2005)"=0A=
+#define MEGARAID_VERSION	"2.20.4.7"=0A=
+#define MEGARAID_EXT_VERSION	"(Release Date: Mon Nov 14 12:27:22 EST =
2005)"=0A=
 =0A=
 =0A=
 /*=0A=

------_=_NextPart_000_01C5EBA3.297817A0--
