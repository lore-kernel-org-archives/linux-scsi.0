From: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Subject: [PATCH 1/1] megaraid_legacy: removed PCI ID overlap from the driv
	er
Date: Thu, 17 Nov 2005 13:13:31 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662C41@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29904 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932457AbVKQSO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 13:14:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Daniel Drake' <dsd@gentoo.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>

Hi,

This patch fixes 
	- PCI ID overlap issue 
	- node name changed to 'megaraid_legacy'
I hope this patch addresses concerns brought by Daniel Drake.
The patch created against James's linux/kernel/git/jejb/scsi-misc-2.6.git/
tree.
Please review it and any comments would be appreciated.

Thank you,

Signed-off by : Seokmann Ju <seokmann.ju@enginio.com>
---
diff -Naur old/drivers/scsi/megaraid.c new/drivers/scsi/megaraid.c
--- old/drivers/scsi/megaraid.c	2005-11-14 14:00:55.380899472 -0500
+++ new/drivers/scsi/megaraid.c	2005-11-14 14:08:01.496120112 -0500
@@ -2,7 +2,7 @@
  *
  *			Linux MegaRAID device driver
  *
- * Copyright ? 2002  LSI Logic Corporation.
+ * Copyright (c) 2002  LSI Logic Corporation.
  *
  *	   This program is free software; you can redistribute it and/or
  *	   modify it under the terms of the GNU General Public License
@@ -17,7 +17,8 @@
  * Copyright (c) 2003  Christoph Hellwig  <hch@lst.de>
  *	  - new-style, hotplug-aware pci probing and scsi registration
  *
- * Version : v2.00.3 (Feb 19, 2003) - Atul Mukker <Atul.Mukker@lsil.com>
+ * Version : v2.00.4 Mon Nov 14 14:02:43 EST 2005 - Seokmann Ju
+ * 						<Seokmann.Ju@lsil.com>
  *
  * Description: Linux device driver for LSI Logic MegaRAID controller
  *
@@ -51,10 +52,10 @@
 
 #include "megaraid.h"
 
-#define MEGARAID_MODULE_VERSION "2.00.3"
+#define MEGARAID_MODULE_VERSION "2.00.4"
 
-MODULE_AUTHOR ("LSI Logic Corporation");
-MODULE_DESCRIPTION ("LSI Logic MegaRAID driver");
+MODULE_AUTHOR ("sju@lsil.com");
+MODULE_DESCRIPTION ("LSI Logic MegaRAID legacy driver");
 MODULE_LICENSE ("GPL");
 MODULE_VERSION(MEGARAID_MODULE_VERSION);
 
@@ -4553,7 +4554,7 @@
 static struct scsi_host_template megaraid_template = {
 	.module				= THIS_MODULE,
 	.name				= "MegaRAID",
-	.proc_name			= "megaraid",
+	.proc_name			= "megaraid_legacy",
 	.info				= megaraid_info,
 	.queuecommand			= megaraid_queue,	
 	.bios_param			= megaraid_biosparam,
@@ -5038,22 +5039,12 @@
 }
 
 static struct pci_device_id megaraid_pci_tbl[] = {
-	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DISCOVERY,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_PERC4_DI,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
-	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_PERC4_QC_VERDE,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, megaraid_pci_tbl);
@@ -5096,7 +5087,7 @@
 	 * First argument (major) to register_chrdev implies a dynamic
 	 * major number allocation.
 	 */
-	major = register_chrdev(0, "megadev", &megadev_fops);
+	major = register_chrdev(0, "megadev_legacy", &megadev_fops);
 	if (!major) {
 		printk(KERN_WARNING
 				"megaraid: failed to register char
device\n");
@@ -5110,7 +5101,7 @@
 	/*
 	 * Unregister the character device interface to the driver.
 	 */
-	unregister_chrdev(major, "megadev");
+	unregister_chrdev(major, "megadev_legacy");
 
 	pci_unregister_driver(&megaraid_pci_driver);
 
diff -Naur old/drivers/scsi/megaraid.h new/drivers/scsi/megaraid.h
--- old/drivers/scsi/megaraid.h	2005-11-14 14:00:55.382899168 -0500
+++ new/drivers/scsi/megaraid.h	2005-11-14 14:07:57.693698168 -0500
@@ -5,7 +5,7 @@
 
 
 #define MEGARAID_VERSION	\
-	"v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)\n"
+	"v2.00.4 (Release Date: Mon Nov 14 14:07:35 EST 2005)\n"
 
 /*
  * Driver features - change the values to enable or disable features in the
@@ -73,10 +73,6 @@
 #define PCI_DEVICE_ID_AMI_MEGARAID3	0x1960
 #endif
 
-#define PCI_DEVICE_ID_DISCOVERY		0x000E
-#define PCI_DEVICE_ID_PERC4_DI		0x000F
-#define PCI_DEVICE_ID_PERC4_QC_VERDE	0x0407
-
 /* Sub-System Vendor IDs */
 #define	AMI_SUBSYS_VID			0x101E
 #define DELL_SUBSYS_VID			0x1028
---
