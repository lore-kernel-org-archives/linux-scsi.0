From: brking@us.ibm.com
Subject: [PATCH 06/15] ipr: Support dynamic IDs
Date: Mon, 21 Feb 2005 15:09:03 -0600
Message-ID: <200502212109.j1LL94ZP001513@d03av03.boulder.ibm.com>
Received: from e34.co.us.ibm.com ([32.97.110.132]:9139 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262120AbVBUVJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:05 -0500
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.195.12])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1LL95MN351680
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:05 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay03.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL95UK120082
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:05 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL948t001528
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Fixes ipr to handle dynamic pci ids by searching for the adapter
chipset in the probe routine if driver_data is NULL.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |   37 +++++++++++++++++++++++-
 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |    6 +++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_pci_table_fixup3 drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_pci_table_fixup3	2005-02-21 13:12:08.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:12:08.000000000 -0600
@@ -125,6 +125,13 @@ static const struct ipr_chip_cfg_t ipr_c
 	},
 };
 
+static const struct ipr_chip_t ipr_chip[] = {
+	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, &ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, &ipr_chip_cfg[1] }
+};
+
 static int ipr_max_bus_speeds [] = {
 	IPR_80MBs_SCSI_RATE, IPR_U160_SCSI_RATE, IPR_U320_SCSI_RATE
 };
@@ -5668,6 +5675,28 @@ static void __devinit ipr_init_ioa_cfg(s
 }
 
 /**
+ * ipr_get_chip_cfg - Find adapter chip configuration
+ * @dev_id:		PCI device id struct
+ *
+ * Return value:
+ * 	ptr to chip config on success / NULL on failure
+ **/
+static const struct ipr_chip_cfg_t * __devinit
+ipr_get_chip_cfg(const struct pci_device_id *dev_id)
+{
+	int i;
+
+	if (dev_id->driver_data)
+		return (const struct ipr_chip_cfg_t *)dev_id->driver_data;
+
+	for (i = 0; i < ARRAY_SIZE(ipr_chip); i++)
+		if (ipr_chip[i].vendor == dev_id->vendor &&
+		    ipr_chip[i].device == dev_id->device)
+			return ipr_chip[i].cfg;
+	return NULL;
+}
+
+/**
  * ipr_probe_ioa - Allocates memory and does first stage of initialization
  * @pdev:		PCI device struct
  * @dev_id:		PCI device id struct
@@ -5704,7 +5733,13 @@ static int __devinit ipr_probe_ioa(struc
 	ioa_cfg = (struct ipr_ioa_cfg *)host->hostdata;
 	memset(ioa_cfg, 0, sizeof(struct ipr_ioa_cfg));
 
-	ioa_cfg->chip_cfg = (const struct ipr_chip_cfg_t *)dev_id->driver_data;
+	ioa_cfg->chip_cfg = ipr_get_chip_cfg(dev_id);
+
+	if (!ioa_cfg->chip_cfg) {
+		dev_err(&pdev->dev, "Unknown adapter chipset 0x%04X 0x%04X\n",
+			dev_id->vendor, dev_id->device);
+		goto out_scsi_host_put;
+	}
 
 	ipr_regs_pci = pci_resource_start(pdev, 0);
 
diff -puN drivers/scsi/ipr.h~ipr_pci_table_fixup3 drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_pci_table_fixup3	2005-02-21 13:12:08.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:12:08.000000000 -0600
@@ -782,6 +782,12 @@ struct ipr_chip_cfg_t {
 	struct ipr_interrupt_offsets regs;
 };
 
+struct ipr_chip_t {
+	u16 vendor;
+	u16 device;
+	const struct ipr_chip_cfg_t *cfg;
+};
+
 enum ipr_shutdown_type {
 	IPR_SHUTDOWN_NORMAL = 0x00,
 	IPR_SHUTDOWN_PREPARE_FOR_NORMAL = 0x40,
_
