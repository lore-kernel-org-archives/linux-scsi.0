From: brking@us.ibm.com
Subject: [PATCH 03/15] ipr: New adapter support
Date: Mon, 21 Feb 2005 15:08:43 -0600
Message-ID: <200502212108.j1LL8hu0013855@d01av04.pok.ibm.com>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:16060 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262120AbVBUVIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:08:45 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8iMN024187
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:44 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL8iew059122
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:44 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8idD013879
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Add support for some new adapters.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |   17 +++++++++++++----
 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |    5 ++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_new_adapters drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_new_adapters	2005-02-21 13:10:34.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:10:34.000000000 -0600
@@ -70,9 +70,12 @@
 #define IPR_SUBS_DEV_ID_2780	0x0264
 #define IPR_SUBS_DEV_ID_5702	0x0266
 #define IPR_SUBS_DEV_ID_5703	0x0278
-#define IPR_SUBS_DEV_ID_572E  0x02D3
+#define IPR_SUBS_DEV_ID_572E  0x028D
+#define IPR_SUBS_DEV_ID_573E  0x02D3
 #define IPR_SUBS_DEV_ID_573D  0x02D4
+#define IPR_SUBS_DEV_ID_571A	0x02C0
 #define IPR_SUBS_DEV_ID_571B	0x02BE
+#define IPR_SUBS_DEV_ID_571E  0x02BF
 
 #define IPR_NAME				"ipr"
 
diff -puN drivers/scsi/ipr.c~ipr_new_adapters drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_new_adapters	2005-02-21 13:10:34.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:10:34.000000000 -0600
@@ -108,7 +108,7 @@ static const struct ipr_chip_cfg_t ipr_c
 			.clr_uproc_interrupt_reg = 0x00218
 		}
 	},
-	{ /* Snipe */
+	{ /* Snipe and Scamp */
 		.mailbox = 0x0052C,
 		.cache_line_size = 0x20,
 		{
@@ -5990,20 +5990,29 @@ static struct pci_device_id ipr_pci_tabl
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5702,
 		0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572E,
-		0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5703,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573D,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573E,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571B,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572E,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571A,
+	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780,
 		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571E,
+		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
_
