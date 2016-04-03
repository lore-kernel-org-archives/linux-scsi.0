From: Leonid Moiseichuk <leonid.moiseichuk@gmail.com>
Subject: [PATCH] [SCSI] mvsas: generalize Marvell 88SE9485 declaration
Date: Sun,  3 Apr 2016 09:53:38 +0300
Message-ID: <1459666418-8996-1-git-send-email-leonid.moiseichuk@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:38391 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbcDCG7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2016 02:59:20 -0400
Received: from home.ru (a88-112-190-76.elisa-laajakaista.fi [88.112.190.76])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 0AAEA234022
	for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2016 09:53:44 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yuxiangl@marvell.com, James.Bottomley@suse.de
Cc: debian-kernel@lists.debian.org, linux-scsi@vger.kernel.org, Leonid Moiseichuk <leonid.moiseichuk@gmail.com>

In case of specifying any subvendor has sense to use generic subdevice
and switch to PCI_VDEVICE() macro.

My ASUS P9A-I/C2550/SAS/4L publishes 1b4b:9485 as vendor-specific 1043:8635
and it prevents initialization of mvsas.

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

