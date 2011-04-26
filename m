From: yxlraid@gmail.com
Subject: [PATCH 1/2] [PATCH] [SCSI] mvsas: add support for Marvell 88SE9445/88SE9485
Date: Tue, 26 Apr 2011 06:34:01 -0700
Message-ID: <1303824841-6196-1-git-send-email-yxlraid@gmail.com>
References: <mvsas-support-new-device-id>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mvsas-support-new-device-id>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com, root <root@localhost.marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: root <root@localhost.marvell.com>

This is support for Marvell 88SE9445/88SE9485 SAS/SATA HBA, which
is based on Marvell 88SE9480.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_defs.h |    2 ++
 drivers/scsi/mvsas/mv_init.c |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 1849da1..880613f 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -34,6 +34,8 @@ enum chip_flavors {
 	chip_6485,
 	chip_9480,
 	chip_9180,
+	chip_9445,
+	chip_9485,
 	chip_1300,
 	chip_1320
 };
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 938d045..0123c6b 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -32,6 +32,8 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_6485] =	{ 1, 8, 0x800, 33, 32, 10, &mvs_64xx_dispatch, },
 	[chip_9180] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 	[chip_9480] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
+	[chip_9445] =	{ 1, 4, 0x800, 17, 64, 11, &mvs_94xx_dispatch, },
+	[chip_9485] =	{ 2, 4, 0x800, 17, 64, 11, &mvs_94xx_dispatch, },
 	[chip_1300] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 };
@@ -670,6 +672,24 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 	{ PCI_VDEVICE(TTI, 0x2740), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2744), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2760), chip_9480 },
+	{
+		.vendor		= 0x1b4b,
+		.device		= 0x9445,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x9480,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9445,
+	},
+	{
+		.vendor		= 0x1b4b,
+		.device		= 0x9485,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x9480,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9485,
+	},
 
 	{ }	/* terminate list */
 };
-- 
1.7.4.4
