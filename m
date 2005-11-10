From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove CONFIG_SCSI_QLOGIC_1280_1040
Date: Thu, 10 Nov 2005 11:41:59 +0100
Message-ID: <20051110104159.GA689@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:64460 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1750765AbVKJKmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 05:42:03 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

now that qlogicisp is gone there is not reason not to support the 1040
unconditionally in qla1280.

Would be nice to get this into 2.6.15 still.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/scsi/Kconfig	2005-11-06 20:09:10.000000000 +0100
+++ linux-2.6/drivers/scsi/Kconfig	2005-11-08 12:43:05.000000000 +0100
@@ -1342,14 +1342,6 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called qla1280.
 
-config SCSI_QLOGIC_1280_1040
-	bool "Qlogic QLA 1020/1040 SCSI support"
-	depends on SCSI_QLOGIC_1280 && SCSI_QLOGIC_ISP!=y
-	help
-	  Say Y here if you have a QLogic ISP1020/1040 SCSI host adapter and
-	  do not want to use the old driver.  This option enables support in
-	  the qla1280 driver for those host adapters.
-
 config SCSI_QLOGICPTI
 	tristate "PTI Qlogic, ISP Driver"
 	depends on SBUS && SCSI
Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-10-31 12:23:47.000000000 +0100
+++ linux-2.6/drivers/scsi/qla1280.c	2005-11-08 12:42:55.000000000 +0100
@@ -639,10 +639,8 @@
 static struct pci_device_id qla1280_pci_tbl[] = {
 	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP12160,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-#ifdef CONFIG_SCSI_QLOGIC_1280_1040
 	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-#endif
 	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1080,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
 	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1240,
