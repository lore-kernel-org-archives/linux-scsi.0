From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 4/5] megaraid: remove unnecessary #defines
Date: Mon, 27 Jun 2011 13:04:19 -0500
Message-ID: <1309197859-16924-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48492 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1F0SEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 14:04:24 -0400
Received: by pwj7 with SMTP id 7so3094660pwj.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 11:04:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: linux-scsi@vger.kernel.org

Remove PCI vendor and subvendor IDs, as they are already defined in
pci_ids.h.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/scsi/megaraid.c |    4 ++--
 drivers/scsi/megaraid.h |   35 -----------------------------------
 2 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 5c17764..a3ab794 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -307,7 +307,7 @@ mega_query_adapter(adapter_t *adapter)
 
 
 	/* use HP firmware and bios version encoding */
-	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
+	if (adapter->product_info.subsysvid == PCI_VENDOR_ID_HP) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
 			 adapter->product_info.fw_version[1] >> 8,
@@ -4713,7 +4713,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * support, since this firmware cannot handle 64 bit
 	 * addressing
 	 */
-	if ((subsysvid == HP_SUBSYS_VID) &&
+	if ((subsysvid == PCI_VENDOR_ID_HP) &&
 	    ((subsysid == 0x60E7) || (subsysid == 0x60E8))) {
 		/*
 		 * which firmware
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 9a7897f..4fb2adf 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -45,45 +45,10 @@
 
 #define MAX_DEV_TYPE	32
 
-#ifndef PCI_VENDOR_ID_LSI_LOGIC
-#define PCI_VENDOR_ID_LSI_LOGIC		0x1000
-#endif
-
-#ifndef PCI_VENDOR_ID_AMI
-#define PCI_VENDOR_ID_AMI		0x101E
-#endif
-
-#ifndef PCI_VENDOR_ID_DELL
-#define PCI_VENDOR_ID_DELL		0x1028
-#endif
-
-#ifndef PCI_VENDOR_ID_INTEL
-#define PCI_VENDOR_ID_INTEL		0x8086
-#endif
-
-#ifndef PCI_DEVICE_ID_AMI_MEGARAID
-#define PCI_DEVICE_ID_AMI_MEGARAID	0x9010
-#endif
-
-#ifndef PCI_DEVICE_ID_AMI_MEGARAID2
-#define PCI_DEVICE_ID_AMI_MEGARAID2	0x9060
-#endif
-
-#ifndef PCI_DEVICE_ID_AMI_MEGARAID3
-#define PCI_DEVICE_ID_AMI_MEGARAID3	0x1960
-#endif
-
 #define PCI_DEVICE_ID_DISCOVERY		0x000E
 #define PCI_DEVICE_ID_PERC4_DI		0x000F
 #define PCI_DEVICE_ID_PERC4_QC_VERDE	0x0407
 
-/* Sub-System Vendor IDs */
-#define	AMI_SUBSYS_VID			0x101E
-#define DELL_SUBSYS_VID			0x1028
-#define	HP_SUBSYS_VID			0x103C
-#define LSI_SUBSYS_VID			0x1000
-#define INTEL_SUBSYS_VID		0x8086
-
 #define HBA_SIGNATURE	      		0x3344
 #define HBA_SIGNATURE_471	  	0xCCCC
 #define HBA_SIGNATURE_64BIT		0x0299
-- 
1.7.5.4

