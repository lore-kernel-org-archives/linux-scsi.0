From: Leonid Moiseichuk <leonid.moiseichuk@gmail.com>
Subject: [PATCH v2] mvsas: Generalize Marvell 9485 in pci_device_id
Date: Thu,  7 Apr 2016 20:06:07 +0300
Message-ID: <1460048767-5112-1-git-send-email-leonid.moiseichuk@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:38868 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbcDGSaE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 14:30:04 -0400
Received: from home.ru (a88-112-190-76.elisa-laajakaista.fi [88.112.190.76])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 6C0E24007
	for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2016 21:30:01 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, yuxiangl@marvell.com
Cc: Wilfried.Weissmann@gmx.at, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Leonid Moiseichuk <leonid.moiseichuk@gmail.com>

For generic subvendor has sense to use generic subdevice.
If subdevice ID not equal to 0x9480/0x9485 mvsas will be not activated.

Tested on ASUS P9A-I/C2550/SAS/4L which uses vendor-specific 1043:8635.

Signed-off-by: Leonid Moiseichuk <leonid.moiseichuk@gmail.com>
---
 drivers/scsi/mvsas/mv_init.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index c7c250519c4b..a6a4f09df0be 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -704,24 +704,7 @@ static struct pci_device_id mvs_pci_table[] = {
 		.class_mask	= 0,
 		.driver_data	= chip_9445,
 	},
-	{
-		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
-		.device		= 0x9485,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= 0x9480,
-		.class		= 0,
-		.class_mask	= 0,
-		.driver_data	= chip_9485,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
-		.device		= 0x9485,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= 0x9485,
-		.class		= 0,
-		.class_mask	= 0,
-		.driver_data	= chip_9485,
-	},
+	{ PCI_VDEVICE(MARVELL_EXT, 0x9485), chip_9485 },
 	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
 	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
 	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-- 
2.8.0.rc3

