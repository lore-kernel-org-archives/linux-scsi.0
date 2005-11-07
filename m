From: Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] Schedule removal of megaraid hardware support overlap
Date: Mon, 07 Nov 2005 14:08:37 +0000
Message-ID: <436F5FE5.7030707@gentoo.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD30D@exa-atlanta> <1131369754.3316.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020703060800070105050703"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta07-winn.ispmail.ntl.com ([81.103.221.47]:10967 "EHLO
	mta07-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S932451AbVKGOIl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 09:08:41 -0500
In-Reply-To: <1131369754.3316.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>, 'Christoph Hellwig' <hch@infradead.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@engenio.com>

This is a multi-part message in MIME format.
--------------020703060800070105050703
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hopefully we'll be getting the build restriction zapped much sooner, but we 
should also be thinking about totally removing the hardware support overlap in 
the megaraid drivers.

This patch pencils in a date of Feb 06 for this, and performs some printk 
abuse in hope that existing legacy users might pick up on what's going on.

Signed-off-by: Daniel Drake <dsd@gentoo.org>


--------------020703060800070105050703
Content-Type: text/x-patch;
 name="megaraid-schedule-overlap-removal.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="megaraid-schedule-overlap-removal.patch"

--- linux-2.6.14/Documentation/feature-removal-schedule.txt.orig	2005-11-07 13:38:27.000000000 +0000
+++ linux-2.6.14/Documentation/feature-removal-schedule.txt	2005-11-07 13:48:40.000000000 +0000
@@ -95,3 +95,19 @@ Why:	This interface has been obsoleted b
 	to link against API-compatible library on top of libnfnetlink_queue 
 	instead of the current 'libipq'.
 Who:	Harald Welte <laforge@netfilter.org>
+
+---------------------------
+
+What:	Hardware support in the legacy SCSI megaraid driver
+When:	February 2006
+Why:	The legacy megaraid driver has a large hardware support overlap with
+	the "newgen" driver. For this reason, you cannot build the legacy
+	driver alongside the new driver, making it impossible for a
+	one-size-fits-all kernel to support the whole range of megaraid
+	hardware. To resolve this, support for the overlapping hardware will
+	be dropped from the legacy driver and the build restriction will be
+	dropped. During the interim period, legacy driver users with affected
+	hardware will recieve a large warning in 'dmesg' notifying them that
+	they should change.
+Who:	Daniel Drake <dsd@gentoo.org>
+
--- linux-2.6.14/drivers/scsi/megaraid.c.orig	2005-11-07 13:25:48.000000000 +0000
+++ linux-2.6.14/drivers/scsi/megaraid.c	2005-11-07 13:46:50.000000000 +0000
@@ -51,6 +51,15 @@
 
 #include "megaraid.h"
 
+/*
+ * Some of the hardware supported by this driver overlaps with hardware
+ * supported by the "newgen" megaraid driver.
+ * Support for the overlapping hardware may be dropped from _this_ driver in
+ * the near future. If you get a printk warning about this, you probably want
+ * to change.
+ */
+#define DRIVER_DEPRECATED 0x1
+
 #define MEGARAID_MODULE_VERSION "2.00.3"
 
 MODULE_AUTHOR ("LSI Logic Corporation");
@@ -4786,6 +4795,23 @@ megaraid_probe_one(struct pci_dev *pdev,
 		}
 	}
 
+	/*
+	 * Warn affected users that support for their hardware is going away
+	 */
+	if (id->driver_data & DRIVER_DEPRECATED) {
+		printk(KERN_WARNING "megaraid: ******    WARNING    ******\n");
+		printk(KERN_WARNING "megaraid: Your megaraid card is supported "
+			"by both the legacy and the newgen\n");
+		printk(KERN_WARNING "megaraid: megaraid driver, and you are "
+			"currently using the legacy driver.\n");
+		printk(KERN_WARNING "megaraid: Support for your card will be "
+			"dropped from the legacy driver in\n");
+		printk(KERN_WARNING "megaraid: the near future, so you should "
+			"switch over to the newgen driver as\n");
+		printk(KERN_WARNING "megaraid: soon as you can.\n");
+		printk(KERN_WARNING "megaraid: ******    WARNING    ******");
+	}
+
 	if (mega_is_bios_enabled(adapter))
 		mega_hbas[hba_count].is_bios_enabled = 1;
 	mega_hbas[hba_count].hostdata_addr = adapter;
@@ -5045,21 +5071,21 @@ megaraid_shutdown(struct pci_dev *pdev)
 
 static struct pci_device_id megaraid_pci_tbl[] = {
 	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DISCOVERY,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, DRIVER_DEPRECATED},
 	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_PERC4_DI,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT | DRIVER_DEPRECATED},
 	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_PERC4_QC_VERDE,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT | DRIVER_DEPRECATED},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, DRIVER_DEPRECATED},
 	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, DRIVER_DEPRECATED},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, megaraid_pci_tbl);

--------------020703060800070105050703--
