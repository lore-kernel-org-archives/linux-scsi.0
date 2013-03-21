From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3/3] PCI, scsi, ahci: Unify usages of 0x1b4b vendor ID to use
	PCI_VENDOR_ID_MARVELL_EXT
Date: Wed, 20 Mar 2013 22:35:09 -0600
Message-ID: <20130321043509.7229.93525.stgit@amt.stowe>
References: <20130321043449.7229.81056.stgit@amt.stowe>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130321043449.7229.81056.stgit@amt.stowe>
Sender: linux-kernel-owner@vger.kernel.org
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com, greg@kroah.com, alex.williamson@redhat.com, kay@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With the 0x1b4b vendor ID #define in place, convert hard-coded ID values.
Also, unify the previous SCSI specific use of this vendor ID to the new
macro.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/ata/ahci.c           |   10 +++++-----
 drivers/scsi/mvsas/mv_init.c |    6 +++---
 drivers/scsi/mvumi.c         |    4 ++--
 drivers/scsi/mvumi.h         |    1 -
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a99112c..616952f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -413,17 +413,17 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
-	{ PCI_DEVICE(0x1b4b, 0x9123),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9123),
 	  .class = PCI_CLASS_STORAGE_SATA_AHCI,
 	  .class_mask = 0xffffff,
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
-	{ PCI_DEVICE(0x1b4b, 0x9125),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
-	{ PCI_DEVICE(0x1b4b, 0x917a),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
-	{ PCI_DEVICE(0x1b4b, 0x9192),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
-	{ PCI_DEVICE(0x1b4b, 0x91a3),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 
 	/* Promise */
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index ce90d05..7455092 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -703,7 +703,7 @@ static struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(TTI, 0x2744), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2760), chip_9480 },
 	{
-		.vendor		= 0x1b4b,
+		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
 		.device		= 0x9480,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= 0x9480,
@@ -712,7 +712,7 @@ static struct pci_device_id mvs_pci_table[] = {
 		.driver_data	= chip_9480,
 	},
 	{
-		.vendor		= 0x1b4b,
+		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
 		.device		= 0x9445,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= 0x9480,
@@ -721,7 +721,7 @@ static struct pci_device_id mvs_pci_table[] = {
 		.driver_data	= chip_9445,
 	},
 	{
-		.vendor		= 0x1b4b,
+		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
 		.device		= 0x9485,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= 0x9480,
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 4594cca..c3601b5 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -49,8 +49,8 @@ MODULE_AUTHOR("jyli@marvell.com");
 MODULE_DESCRIPTION("Marvell UMI Driver");
 
 static DEFINE_PCI_DEVICE_TABLE(mvumi_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_2, PCI_DEVICE_ID_MARVELL_MV9143) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_2, PCI_DEVICE_ID_MARVELL_MV9580) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, PCI_DEVICE_ID_MARVELL_MV9143) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, PCI_DEVICE_ID_MARVELL_MV9580) },
 	{ 0 }
 };
 
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index e360135..41f1687 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -32,7 +32,6 @@
 #define VER_BUILD		1500
 
 #define MV_DRIVER_NAME			"mvumi"
-#define PCI_VENDOR_ID_MARVELL_2		0x1b4b
 #define PCI_DEVICE_ID_MARVELL_MV9143	0x9143
 #define PCI_DEVICE_ID_MARVELL_MV9580	0x9580
 
