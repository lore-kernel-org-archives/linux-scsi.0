From: Juerg Billeter <juerg@paldo.org>
Subject: [PATCH] Hotplug support for BusLogic scsi controller
Date: Fri, 08 Apr 2005 18:22:57 +0200
Message-ID: <1112977377.8880.24.camel@juerg-p4.bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from paldo.org ([213.202.245.43]:29599 "EHLO buildd1.paldo.org")
	by vger.kernel.org with ESMTP id S262866AbVDHQW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2005 12:22:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnz@dandelion.com
Cc: linux-scsi@vger.kernel.org

Hi

This patch adds hotplug support to the driver for BusLogic scsi
controllers. It's required to boot from a BusLogic controller when using
modular kernels with hotplug-based initramfs.

Regards,

Juerg

--
Signed-off-by: Juerg Billeter <juerg@paldo.org>

--- linux-2.6.10/drivers/scsi/BusLogic.c.orig	2004-12-25 11:15:23.612408071 +0100
+++ linux-2.6.10/drivers/scsi/BusLogic.c	2004-12-25 11:17:51.639882495 +0100
@@ -79,6 +79,15 @@
 static struct BusLogic_DriverOptions BusLogic_DriverOptions[BusLogic_MaxHostAdapters];
 
 
+static struct pci_device_id buslogic_pci_tbl[] = {
+	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER, PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC, PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT, PCI_ANY_ID, PCI_ANY_ID, },
+	{ }			/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, buslogic_pci_tbl);
+
+
 /*
   BusLogic can be assigned a string by insmod.
 */


