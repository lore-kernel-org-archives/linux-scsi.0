From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ipr: Remove usage of pci driver data
Date: Tue, 23 Jan 2007 11:25:23 -0600
Message-ID: <17727.1836823367$1169573224@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58612 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965156AbXAWR0s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 12:26:48 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0NHQhg9022087
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 12:26:44 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0NHPPm4089358
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 12:25:27 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0NHPPj8016745
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 12:25:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brazilnut@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Since ipr handles dynamic ids, it must handle driver_data
not being set, so remove the current usage of driver_data
so it can be used for other things in future patches.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   63 +++++++++++------------------------
 1 files changed, 20 insertions(+), 43 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_driver_data_fixup drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_driver_data_fixup	2007-01-18 17:08:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-01-18 17:08:05.000000000 -0600
@@ -7166,9 +7166,6 @@ ipr_get_chip_cfg(const struct pci_device
 {
 	int i;
 
-	if (dev_id->driver_data)
-		return (const struct ipr_chip_cfg_t *)dev_id->driver_data;
-
 	for (i = 0; i < ARRAY_SIZE(ipr_chip); i++)
 		if (ipr_chip[i].vendor == dev_id->vendor &&
 		    ipr_chip[i].device == dev_id->device)
@@ -7517,65 +7514,45 @@ static void ipr_shutdown(struct pci_dev 
 
 static struct pci_device_id ipr_pci_table[] __devinitdata = {
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5702,
-		0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5702, 0, 0, 0 },
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5703,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5703, 0, 0, 0 },
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573D,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573D, 0, 0, 0 },
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573E,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573E, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571B,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571B, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572E,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572E, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571A,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575B,
-		0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575B, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B8,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B8, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780,
-		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571E,
-		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571E, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571F,
-		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571F, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F,
-		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F, 0, 0, 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
_
