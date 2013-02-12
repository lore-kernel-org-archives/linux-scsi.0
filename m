From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 02/15] pm80xx: Added vendor and device ids for SPCv/ve controllers
Date: Tue, 12 Feb 2013 04:27:30 -0800
Message-ID: <511A3532.1090402@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:53476 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933056Ab3BLM0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:26:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From edeb2b4b89ff6c7ddbb73366a2b4f6a86815d8eb Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 12:15:28 +0530
Subject: [PATCH 02/15] pm80xx: Added vendor and device ids for
SPCv/SPCve controllers

Updated of pci id table  with device, vendor, subdevice and subvendor
ids for 8081, 8088, 8089 SAS/SATA controllers

Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_init.c |   42
++++++++++++++++++++++++++++++++----
 1 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c
b/drivers/scsi/pm8001/pm8001_init.c
index 3d5e522..1d883e9 100755
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1,5 +1,5 @@
 /*
- * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver
+ * PMC-Sierra PM8001/8081/8088/8089 SAS/SATA based host adapters driver
  *
  * Copyright (c) 2008-2009 USI Co., Ltd.
  * All rights reserved.
@@ -843,14 +843,45 @@ err_out_enable:
 	return rc;
 }

+/* update of pci device, vendor id and driver data with
+ * unique value for each of the controller
+ */
 static struct pci_device_id pm8001_pci_table[] = {
-	{
-		PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001
-	},
+	{ PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001 },
 	{
 		PCI_DEVICE(0x117c, 0x0042),
 		.driver_data = chip_8001
 	},
+	/* Support for SPC/SPCv/SPCve controllers */
+	{ PCI_VDEVICE(ADAPTEC2, 0x8001), chip_8001 },
+	{ PCI_VDEVICE(PMC_Sierra, 0x8008), chip_8008 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x8008), chip_8008 },
+	{ PCI_VDEVICE(PMC_Sierra, 0x8018), chip_8018 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x8018), chip_8018 },
+	{ PCI_VDEVICE(PMC_Sierra, 0x8009), chip_8009 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x8009), chip_8009 },
+	{ PCI_VDEVICE(PMC_Sierra, 0x8019), chip_8019 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x8019), chip_8019 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8081,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0400, 0, 0, chip_8001 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8081,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0800, 0, 0, chip_8001 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8088,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0008, 0, 0, chip_8008 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8088,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0800, 0, 0, chip_8008 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0008, 0, 0, chip_8009 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0800, 0, 0, chip_8009 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8088,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8018 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8088,
+		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8018 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8019 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
+		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8019 },
 	{} /* terminate list */
 };

@@ -902,7 +933,8 @@ module_init(pm8001_init);
 module_exit(pm8001_exit);

 MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");
-MODULE_DESCRIPTION("PMC-Sierra PM8001 SAS/SATA controller driver");
+MODULE_DESCRIPTION(
+		"PMC-Sierra PM8001/8081/8088/8089 SAS/SATA controller driver");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pm8001_pci_table);
-- 
1.7.1

