From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 03/12] ipr: Add new PCI-E IDs to device table
Date: Thu, 29 Mar 2007 12:42:53 -0500
Message-ID: <200703291742.l2THgsfL024066@d03av03.boulder.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:45976 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934306AbXC2Rm4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 13:42:56 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THgurU022330
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:42:56 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THguif206042
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:42:56 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THgtv4024130
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:42:55 -0600
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Adds support for some new PCI-E ipr adapters.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   10 ++++++++++
 linux-2.6-bjking1/drivers/scsi/ipr.h |    5 +++++
 2 files changed, 15 insertions(+)

diff -puN drivers/scsi/ipr.h~ipr_pcie_slot_adapters drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_pcie_slot_adapters	2007-03-26 09:00:35.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-03-26 09:00:35.000000000 -0500
@@ -55,6 +55,7 @@
 #define IPR_NUM_BASE_CMD_BLKS				100
 
 #define PCI_DEVICE_ID_IBM_OBSIDIAN_E	0x0339
+#define PCI_DEVICE_ID_IBM_SCAMP_E		0x034A
 
 #define IPR_SUBS_DEV_ID_2780	0x0264
 #define IPR_SUBS_DEV_ID_5702	0x0266
@@ -69,8 +70,12 @@
 #define IPR_SUBS_DEV_ID_572A	0x02C1
 #define IPR_SUBS_DEV_ID_572B	0x02C2
 #define IPR_SUBS_DEV_ID_572F	0x02C3
+#define IPR_SUBS_DEV_ID_574D	0x030B
+#define IPR_SUBS_DEV_ID_574E	0x030A
 #define IPR_SUBS_DEV_ID_575B	0x030D
 #define IPR_SUBS_DEV_ID_575C	0x0338
+#define IPR_SUBS_DEV_ID_575D	0x033E
+#define IPR_SUBS_DEV_ID_57B3	0x033A
 #define IPR_SUBS_DEV_ID_57B7	0x0360
 #define IPR_SUBS_DEV_ID_57B8	0x02C2
 
diff -puN drivers/scsi/ipr.c~ipr_pcie_slot_adapters drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_pcie_slot_adapters	2007-03-26 09:00:35.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-26 09:02:19.000000000 -0500
@@ -7558,6 +7558,13 @@ static struct pci_device_id ipr_pci_tabl
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0,
 	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574E, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575D, 0, 0,
+	      IPR_USE_LONG_TRANSOP_TIMEOUT },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B3, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0,
 	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
@@ -7570,6 +7577,9 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F, 0, 0,
 		IPR_USE_LONG_TRANSOP_TIMEOUT },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SCAMP_E,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574D, 0, 0,
+		IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
_
