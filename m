From: brking@us.ibm.com
Subject: [PATCH 23/26] ipr: New PCI Ids
Date: Tue, 01 Nov 2005 17:02:42 -0600
Message-ID: <200511012302.jA1N2hdR026969@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:25567 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751418AbVKAXCo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:02:44 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N2iSk028300
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:44 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N2ibn089084
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:44 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N2hxi026995
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Adds support for some new ipr adapters

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   22 +++++++++++++++++++++-
 linux-2.6-bjking1/drivers/scsi/ipr.h |    4 ++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~ipr_sas_pci_ids drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_sas_pci_ids	2005-11-01 16:08:18.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-11-01 16:08:18.000000000 -0600
@@ -61,6 +61,10 @@
 #define IPR_SUBS_DEV_ID_571A	0x02C0
 #define IPR_SUBS_DEV_ID_571B	0x02BE
 #define IPR_SUBS_DEV_ID_571E  0x02BF
+#define IPR_SUBS_DEV_ID_571F	0x02D5
+#define IPR_SUBS_DEV_ID_572A	0x02C1
+#define IPR_SUBS_DEV_ID_572B	0x02C2
+#define IPR_SUBS_DEV_ID_575B	0x030D
 
 #define IPR_NAME				"ipr"
 
diff -puN drivers/scsi/ipr.c~ipr_sas_pci_ids drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sas_pci_ids	2005-11-01 16:08:18.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-11-01 16:08:18.000000000 -0600
@@ -98,7 +98,7 @@ static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
 static const struct ipr_chip_cfg_t ipr_chip_cfg[] = {
-	{ /* Gemstone and Citrine */
+	{ /* Gemstone, Citrine, and Obsidian */
 		.mailbox = 0x0042C,
 		.cache_line_size = 0x20,
 		{
@@ -133,6 +133,8 @@ static const struct ipr_chip_cfg_t ipr_c
 static const struct ipr_chip_t ipr_chip[] = {
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE, &ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, &ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, &ipr_chip_cfg[1] },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, &ipr_chip_cfg[1] }
 };
@@ -6554,12 +6556,30 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571A,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575B,
+		0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780,
 		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571E,
 		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571F,
+		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
_
