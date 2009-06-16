From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: differentiate pci-x and pci-e based adapters
Date: Tue, 16 Jun 2009 15:13:43 -0700
Message-ID: <4A381917.9000309@linux.vnet.ibm.com>
References: <20090616220853.799518360@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:60930 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbZFPWNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 18:13:47 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5GMA3uh005112
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 16:10:03 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5GMDn2d223858
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 16:13:49 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5GMDntB029746
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 16:13:49 -0600
Received: from [9.47.17.47] (wboyer.beaverton.ibm.com [9.47.17.47])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id n5GMDm4D029662
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 16:13:49 -0600
In-Reply-To: <20090616220853.799518360@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

MSI has only been tested on and known to work with PCI-E based adapters.  This
patch adds a field to struct ipr_chip_t to indicate which type of interrupt to
use based on what is known about the chip.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   29 +++++++++++++++--------------
 drivers/scsi/ipr.h |    4 ++++
 2 files changed, 19 insertions(+), 14 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2009-06-15 16:36:36.000000000 -0700
+++ b/drivers/scsi/ipr.c	2009-06-15 16:36:44.000000000 -0700
@@ -131,13 +131,13 @@
 };

 static const struct ipr_chip_t ipr_chip[] = {
-	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, &ipr_chip_cfg[1] },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, &ipr_chip_cfg[1] }
+	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE, IPR_USE_LSI, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, IPR_USE_LSI, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN, IPR_USE_LSI, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, IPR_USE_LSI, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E, IPR_USE_MSI, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, IPR_USE_LSI, &ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, IPR_USE_LSI, &ipr_chip_cfg[1] }
 };

 static int ipr_max_bus_speeds [] = {
@@ -7398,21 +7398,21 @@
 }

 /**
- * ipr_get_chip_cfg - Find adapter chip configuration
+ * ipr_get_chip_info - Find adapter chip information
  * @dev_id:		PCI device id struct
  *
  * Return value:
- * 	ptr to chip config on success / NULL on failure
+ * 	ptr to chip information on success / NULL on failure
  **/
-static const struct ipr_chip_cfg_t * __devinit
-ipr_get_chip_cfg(const struct pci_device_id *dev_id)
+static const struct ipr_chip_t * __devinit
+ipr_get_chip_info(const struct pci_device_id *dev_id)
 {
 	int i;

 	for (i = 0; i < ARRAY_SIZE(ipr_chip); i++)
 		if (ipr_chip[i].vendor == dev_id->vendor &&
 		    ipr_chip[i].device == dev_id->device)
-			return ipr_chip[i].cfg;
+			return &ipr_chip[i];
 	return NULL;
 }

@@ -7539,7 +7539,8 @@
 	ata_host_init(&ioa_cfg->ata_host, &pdev->dev,
 		      sata_port_info.flags, &ipr_sata_ops);

-	ioa_cfg->chip_cfg = ipr_get_chip_cfg(dev_id);
+	ioa_cfg->ipr_chip = ipr_get_chip_info(dev_id);
+	ioa_cfg->chip_cfg = ioa_cfg->ipr_chip->cfg;

 	if (!ioa_cfg->chip_cfg) {
 		dev_err(&pdev->dev, "Unknown adapter chipset 0x%04X 0x%04X\n",
@@ -7598,7 +7599,7 @@
 	}

 	/* Enable MSI style interrupts if they are supported. */
-	if (!(rc = pci_enable_msi(pdev))) {
+	if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI && !pci_enable_msi(pdev)) {
 		rc = ipr_test_msi(ioa_cfg, pdev);
 		if (rc == -EOPNOTSUPP)
 			pci_disable_msi(pdev);
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2009-06-15 16:35:43.000000000 -0700
+++ b/drivers/scsi/ipr.h	2009-06-15 16:36:44.000000000 -0700
@@ -1025,6 +1025,9 @@
 struct ipr_chip_t {
 	u16 vendor;
 	u16 device;
+	u16 intr_type;
+#define IPR_USE_LSI			0x00
+#define IPR_USE_MSI			0x01
 	const struct ipr_chip_cfg_t *cfg;
 };

@@ -1160,6 +1163,7 @@

 	unsigned int transop_timeout;
 	const struct ipr_chip_cfg_t *chip_cfg;
+	const struct ipr_chip_t *ipr_chip;

 	void __iomem *hdw_dma_regs;	/* iomapped PCI memory space */
 	unsigned long hdw_dma_regs_pci;	/* raw PCI memory space */

