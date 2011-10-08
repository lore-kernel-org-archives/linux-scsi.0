From: "Robin H. Johnson" <robbat2@gentoo.org>
Subject: [PATCH] mv_sas: OCZ RevoDrive3/zDrive R4 support (completely untested)
Date: Fri,  7 Oct 2011 17:00:26 -0700
Message-ID: <1318032026-21913-1-git-send-email-robbat2@gentoo.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Robin H. Johnson" <robbat2@gentoo.org>
List-Id: linux-scsi@vger.kernel.org

From: "Robin H. Johnson" <robbat2@gentoo.org>

NOT FOR COMMIT USE; TESTING ONLY; NO WARRANTY; DANGER!

A friend recently bought a OCZ RevoDrive3 and was surprised by the lack
of Linux support. I glanced at the Windows driver .inf file for the
device, as well as the Windows driver for the zDrive R4, it looks like
rebranded mvsas (mostly based on earlier versions of the Windows driver
that include PCI IDs already found in the mvsas code).

I constructed this patch for my friend to test, completely blind.
I haven't heard back from him at all yet, but I thought that the wider
community might find it useful for testing as well. I think it _should_
work, just need to figure out what the correct chip variant is.

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
---
 drivers/scsi/mvsas/mv_init.c |   10 ++++++++++
 include/linux/pci_ids.h      |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 4e9af66..babb4a1 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -723,6 +723,16 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 		.class_mask	= 0,
 		.driver_data	= chip_9485,
 	},
+	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3/zDriveR4, 120GB */
+	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
+	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
+	{ PCI_VDEVICE(OCZ, 0x1041), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
+	{ PCI_VDEVICE(OCZ, 0x1042), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
+	{ PCI_VDEVICE(OCZ, 0x1043), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
+	{ PCI_VDEVICE(OCZ, 0x1044), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
+	{ PCI_VDEVICE(OCZ, 0x1080), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
+	{ PCI_VDEVICE(OCZ, 0x1083), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
+	{ PCI_VDEVICE(OCZ, 0x1084), chip_9485}, /* OCZ RevoDrive3/zDriveR4, ??? */
 
 	{ }	/* terminate list */
 };
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ae96bbe..3fe46e9 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2868,3 +2868,5 @@
 
 #define PCI_VENDOR_ID_XEN		0x5853
 #define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
+
+#define PCI_VENDOR_ID_OCZ		0x1b85
-- 
1.7.7
