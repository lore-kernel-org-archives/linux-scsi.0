From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [patch 9/9] ipr: adds PCI ID definitions for new adapters
Date: Fri, 19 Feb 2010 13:24:38 -0800
Message-ID: <4B7F0196.9060108@linux.vnet.ibm.com>
References: <20100219210900.066268168@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44085 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab0BSVYk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 16:24:40 -0500
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e5.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o1JLB9lV026678
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 16:11:09 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o1JLOenF124550
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 16:24:40 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o1JLOdvA025076
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 19:24:39 -0200
In-Reply-To: <20100219210900.066268168@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

This patch adds the PCI ID definitions for new adapters based on the next
generation 64 bit IOA PCI interface chip.  New entries have been added to the
ipr_pci_table[] array for the adapters and to the ipr_chip[] array for the new
versions of the chip.

Older entries have been removed for cards that did not ship.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   26 +++++++++++++++++++-------
 drivers/scsi/ipr.h |   21 ++++++++++++++++-----
 2 files changed, 35 insertions(+), 12 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-02-19 13:00:51.000000000 -0800
+++ b/drivers/scsi/ipr.c	2010-02-19 13:00:58.000000000 -0800
@@ -178,7 +178,9 @@ static const struct ipr_chip_t ipr_chip[
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E, IPR_USE_MSI, IPR_SIS32, &ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[1] },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[1] }
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2, IPR_USE_MSI, IPR_SIS64, &ipr_chip_cfg[2] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2, IPR_USE_MSI, IPR_SIS64, &ipr_chip_cfg[2] }
 };

 static int ipr_max_bus_speeds [] = {
@@ -8825,9 +8827,6 @@ static struct pci_device_id ipr_pci_tabl
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574E, 0, 0,
 	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575D, 0, 0,
-	      IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B3, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0,
@@ -8842,9 +8841,22 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F, 0, 0,
 		IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SCAMP_E,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574D, 0, 0,
-		IPR_USE_LONG_TRANSOP_TIMEOUT },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B5, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574D, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B2, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B4, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B1, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C6, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575D, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57CE, 0, 0, 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-02-19 08:27:10.000000000 -0800
+++ b/drivers/scsi/ipr.h	2010-02-19 13:00:58.000000000 -0800
@@ -37,8 +37,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.4.3"
-#define IPR_DRIVER_DATE "(June 10, 2009)"
+#define IPR_DRIVER_VERSION "2.5.0"
+#define IPR_DRIVER_DATE "(February 11, 2010)"

 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
@@ -55,7 +55,9 @@
 #define IPR_NUM_BASE_CMD_BLKS				100

 #define PCI_DEVICE_ID_IBM_OBSIDIAN_E	0x0339
-#define PCI_DEVICE_ID_IBM_SCAMP_E		0x034A
+
+#define PCI_DEVICE_ID_IBM_CROC_FPGA_E2          0x033D
+#define PCI_DEVICE_ID_IBM_CROC_ASIC_E2          0x034A

 #define IPR_SUBS_DEV_ID_2780	0x0264
 #define IPR_SUBS_DEV_ID_5702	0x0266
@@ -70,15 +72,24 @@
 #define IPR_SUBS_DEV_ID_572A	0x02C1
 #define IPR_SUBS_DEV_ID_572B	0x02C2
 #define IPR_SUBS_DEV_ID_572F	0x02C3
-#define IPR_SUBS_DEV_ID_574D	0x030B
 #define IPR_SUBS_DEV_ID_574E	0x030A
 #define IPR_SUBS_DEV_ID_575B	0x030D
 #define IPR_SUBS_DEV_ID_575C	0x0338
-#define IPR_SUBS_DEV_ID_575D	0x033E
 #define IPR_SUBS_DEV_ID_57B3	0x033A
 #define IPR_SUBS_DEV_ID_57B7	0x0360
 #define IPR_SUBS_DEV_ID_57B8	0x02C2

+#define IPR_SUBS_DEV_ID_57B4    0x033B
+#define IPR_SUBS_DEV_ID_57B2    0x035F
+#define IPR_SUBS_DEV_ID_57C6    0x0357
+
+#define IPR_SUBS_DEV_ID_57B5    0x033C
+#define IPR_SUBS_DEV_ID_57CE    0x035E
+#define IPR_SUBS_DEV_ID_57B1    0x0355
+
+#define IPR_SUBS_DEV_ID_574D    0x0356
+#define IPR_SUBS_DEV_ID_575D    0x035D
+
 #define IPR_NAME				"ipr"

 /*

