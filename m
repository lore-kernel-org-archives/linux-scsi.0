From: Pascal Terjan <pterjan@mandriva.com>
Subject: [PATCH] allow building both megaraid and megraid_mbox
Date: Sat, 13 Aug 2005 14:03:01 +0200
Message-ID: <1123934582.8173.29.camel@plop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ijTvXuFyCg4/Qn9Vy99j"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ryu.zarb.org ([212.85.153.228]:5086 "EHLO ryu.zarb.org")
	by vger.kernel.org with ESMTP id S932147AbVHMMDF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Aug 2005 08:03:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by ryu.zarb.org (Postfix) with ESMTP id 65EFA607E52
	for <linux-scsi@vger.kernel.org>; Sat, 13 Aug 2005 14:03:03 +0200 (CEST)
Received: from ryu.zarb.org ([127.0.0.1])
 by localhost (ryu.zarb.org [127.0.0.1]) (amavisd-new, port 10025) with ESMTP
 id 17877-09 for <linux-scsi@vger.kernel.org>;
 Sat, 13 Aug 2005 14:03:02 +0200 (CEST)
Received: from [192.168.0.2] (cmoi.fasmz.org [82.231.206.15])
	by ryu.zarb.org (Postfix) with ESMTP id 8E14A600D7A
	for <linux-scsi@vger.kernel.org>; Sat, 13 Aug 2005 14:03:02 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-ijTvXuFyCg4/Qn9Vy99j
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,
here is a small patch that allow building both drivers by removing the
devices supported by the new driver from the id_table of the old driver
when you want both.
It is usefull for distributions wanting to keep supporting legacy
hardware.

What's you opinion about that problem and the fix ?

Thanks in advance,
Pascal

--=-ijTvXuFyCg4/Qn9Vy99j
Content-Disposition: attachment; filename=megaraid-common_ids.patch
Content-Type: text/x-patch; name=megaraid-common_ids.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -30,6 +30,7 @@
  *
  */
 
+#include <linux/config.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
@@ -5014,22 +5015,26 @@ megaraid_shutdown(struct pci_dev *pdev)
 }
 
 static struct pci_device_id megaraid_pci_tbl[] = {
+#if !defined(CONFIG_MEGARAID_MAILBOX) && !defined(CONFIG_MEGARAID_MAILBOX_MODULE)
+	/* If the new Megaraid driver is built, only support the adapters
+	 * it doesn't support itself */
 	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DISCOVERY,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_PERC4_DI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
 	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_PERC4_QC_VERDE,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
+	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+#endif
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
diff --git a/drivers/scsi/megaraid/Kconfig.megaraid b/drivers/scsi/megaraid/Kconfig.megaraid
--- a/drivers/scsi/megaraid/Kconfig.megaraid
+++ b/drivers/scsi/megaraid/Kconfig.megaraid
@@ -64,7 +64,6 @@ config MEGARAID_MAILBOX
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid_mbox
 
-if MEGARAID_NEWGEN=n
 config MEGARAID_LEGACY
 	tristate "LSI Logic Legacy MegaRAID Driver"
 	depends on PCI && SCSI
@@ -75,4 +74,3 @@ config MEGARAID_LEGACY
 
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid
-endif

--=-ijTvXuFyCg4/Qn9Vy99j--

