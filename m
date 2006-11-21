From: Brian King <brking@us.ibm.com>
Subject: [PATCH 03/10] ipr: PCI IDs for new SAS adapters
Date: Tue, 21 Nov 2006 10:28:10 -0600
Message-ID: <200611211628.kALGSBor021063@d01av02.pok.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:62433 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1031076AbWKUQ3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:29:31 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGTSit023761
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:29:28 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGSCP9296690
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:12 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGSBEP021093
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:11 -0500
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Adds PCI IDs for some new ipr SAS adapters.

---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   18 +++++++++++++++++-
 linux-2.6-bjking1/drivers/scsi/ipr.h |    6 ++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~ipr_aux_cache_pci_ids drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_aux_cache_pci_ids	2006-11-15 15:43:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2006-11-15 15:43:05.000000000 -0600
@@ -54,6 +54,8 @@
  */
 #define IPR_NUM_BASE_CMD_BLKS				100
 
+#define PCI_DEVICE_ID_IBM_OBSIDIAN_E	0x0339
+
 #define IPR_SUBS_DEV_ID_2780	0x0264
 #define IPR_SUBS_DEV_ID_5702	0x0266
 #define IPR_SUBS_DEV_ID_5703	0x0278
@@ -66,7 +68,11 @@
 #define IPR_SUBS_DEV_ID_571F	0x02D5
 #define IPR_SUBS_DEV_ID_572A	0x02C1
 #define IPR_SUBS_DEV_ID_572B	0x02C2
+#define IPR_SUBS_DEV_ID_572F	0x02C3
 #define IPR_SUBS_DEV_ID_575B	0x030D
+#define IPR_SUBS_DEV_ID_575C	0x0338
+#define IPR_SUBS_DEV_ID_57B7	0x0360
+#define IPR_SUBS_DEV_ID_57B8	0x02C2
 
 #define IPR_NAME				"ipr"
 
diff -puN drivers/scsi/ipr.c~ipr_aux_cache_pci_ids drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_aux_cache_pci_ids	2006-11-15 15:43:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-11-15 15:43:05.000000000 -0600
@@ -98,7 +98,7 @@ static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
 static const struct ipr_chip_cfg_t ipr_chip_cfg[] = {
-	{ /* Gemstone, Citrine, and Obsidian */
+	{ /* Gemstone, Citrine, Obsidian, and Obsidian-E */
 		.mailbox = 0x0042C,
 		.cache_line_size = 0x20,
 		{
@@ -135,6 +135,7 @@ static const struct ipr_chip_t ipr_chip[
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, &ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN, &ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E, &ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, &ipr_chip_cfg[1] },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, &ipr_chip_cfg[1] }
 };
@@ -7363,12 +7364,24 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B8,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780,
 		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
@@ -7378,6 +7391,9 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571F,
 		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F,
+		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
_
