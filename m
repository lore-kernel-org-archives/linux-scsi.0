From: "Robin H. Johnson" <robbat2@gentoo.org>
Subject: [PATCH] mv_sas: OCZ RevoDrive3 & zDrive R4 support
Date: Sat,  8 Oct 2011 20:47:04 -0700
Message-ID: <1318132024-12426-1-git-send-email-robbat2@gentoo.org>
References: <1318032026-21913-1-git-send-email-robbat2@gentoo.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1318032026-21913-1-git-send-email-robbat2@gentoo.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: "Robin H. Johnson" <robbat2@gentoo.org>
List-Id: linux-scsi@vger.kernel.org

From: "Robin H. Johnson" <robbat2@gentoo.org>

In the OCZ RevoDrive3/zDrive R4 series, the "OCZ SuperScale Storage
Controller" with "Virtualized Controller Architecture 2.0" really seems
to be a Marvell 88SE9485 part, with OCZ firmware/BIOS.

Developed and tested on OCZ RevoDrive3 120GB [PCI 1b85:1021]

Should work on:
- OCZ RevoDrive3 (2x SandForce 2281)
- OCZ RevoDrive3 X2 (4x SandForce 2281)
- OCZ zDrive R4 CM84 (4x SandForce 2281)
- OCZ zDrive R4 CM88 (8x SandForce 2281)
- OCZ zDrive R4 RM84 (4x SandForce 2582)
- OCZ zDrive R4 RM88 (8x SandForce 2582)

All of this because a friend recently bought a OCZ RevoDrive3 and was
bitten by the lack of Linux support.

Notes from testing:
-------------------
- SMART works.
- VPD Device Identification is "OCZ-REVODRIVE3"
- Thin provisioning/TRIM seems to be implemented as WRITE SAME UNMAP,
  with deterministic (non-zero) read after TRIM, but I'm not sure if it
  works 100% in my testing.
- Some of the tuning in the firmware seems to ensure much better
  performance when in a RAID0 setup than using the two devices
  seperately.

I have not tested booting from the SSD, because all of this was
developed and tested remotely from the actual hardware.

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
Thanks-To: Gordon Pritchard <gordp@sfu.ca>
---
 drivers/scsi/mvsas/mv_init.c |   10 ++++++++++
 include/linux/pci_ids.h      |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

 Tested and cleaned up now :-). Please apply.

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 4e9af66..b88315a 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -723,6 +723,16 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 		.class_mask	= 0,
 		.driver_data	= chip_9485,
 	},
+	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
+	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1041), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1042), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1043), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1044), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1080), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1083), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1084), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
 
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

