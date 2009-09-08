From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: [PATCH] SCSI: Support Areca SAS/SATA HBA, ARC-1300/1320 on mvsas of  kernel version 2.6.31-rc9
Date: Tue, 8 Sep 2009 19:03:07 +0800
Message-ID: <SERVER-ARECAehBAKbi000035ec@areca.com.tw>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from areca.com.tw ([220.130.178.142]:27518 "EHLO areca.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbZIHLDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2009 07:03:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kewei@marvell.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

From: Nick Cheng<nick.cheng@areca.com.tw>

This is support for Areca SAS/SATA HBA, ARC-1300/1320, which quipped with
88SE6440/88SE9480 respectively.
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
---
drivers/scsi/mvsas/mv_defs.h |    4 ++++
drivers/scsi/mvsas/mv_init.c  |    4 ++++
2 files changed, 8 insertions(+), 0 deletions(-)
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index f8cb9de..1849da1 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -25,6 +25,8 @@
 #ifndef _MV_DEFS_H_
 #define _MV_DEFS_H_
 
+#define PCI_DEVICE_ID_ARECA_1300	0x1300
+#define PCI_DEVICE_ID_ARECA_1320	0x1320
 
 enum chip_flavors {
 	chip_6320,
@@ -32,6 +34,8 @@ enum chip_flavors {
 	chip_6485,
 	chip_9480,
 	chip_9180,
+	chip_1300,
+	chip_1320
 };
 
 /* driver compile-time configuration */
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 8646a19..c790d45 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -32,6 +32,8 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_6485] =	{ 1, 8, 0x800, 33, 32, 10, &mvs_64xx_dispatch, },
 	[chip_9180] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 	[chip_9480] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
+	[chip_1300] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
+	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 };
 
 #define SOC_SAS_NUM 2
@@ -653,6 +655,8 @@ static struct pci_device_id __devinitdata
mvs_pci_table[] = {
 	{ PCI_VDEVICE(MARVELL, 0x6485), chip_6485 },
 	{ PCI_VDEVICE(MARVELL, 0x9480), chip_9480 },
 	{ PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
+	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
+	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 
 	{ }	/* terminate list */
 };

