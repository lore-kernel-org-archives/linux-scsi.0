From: brking@us.ibm.com
Subject: [PATCH 13/16] ipr: New adapter support
Date: Wed, 04 Aug 2004 17:32:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042232.i74MWsu7187384@westrelay04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:27120 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S267473AbUHDWc4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 18:32:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


This patch adds support for 2 new ipr adapters.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    8 +++++++-
 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h |    2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~ipr_new_adapters drivers/scsi/ipr.h
--- linux-2.6.8-rc3/drivers/scsi/ipr.h~ipr_new_adapters	2004-08-04 17:17:39.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h	2004-08-04 17:17:39.000000000 -0500
@@ -75,6 +75,8 @@
 #define IPR_SUBS_DEV_ID_5703	0x0278
 #define IPR_SUBS_DEV_ID_572E  0x02D3
 #define IPR_SUBS_DEV_ID_573D  0x02D4
+#define IPR_SUBS_DEV_ID_570F	0x02BD
+#define IPR_SUBS_DEV_ID_571B	0x02BE
 
 #define IPR_NAME				"ipr"
 
diff -puN drivers/scsi/ipr.c~ipr_new_adapters drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_new_adapters	2004-08-04 17:17:39.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:39.000000000 -0500
@@ -93,7 +93,7 @@ static spinlock_t ipr_driver_lock = SPIN
 
 /* This table describes the differences between DMA controller chips */
 static const struct ipr_chip_cfg_t ipr_chip_cfg[] = {
-	{ /* Gemstone */
+	{ /* Gemstone and Citrine */
 		.mailbox = 0x0042C,
 		.cache_line_size = 0x20,
 		{
@@ -6007,9 +6007,15 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573D,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571B,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780,
 		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_570F,
+		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
_
