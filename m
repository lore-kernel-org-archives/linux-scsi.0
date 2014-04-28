From: Jan Kasprzak <kas@fi.muni.cz>
Subject: PATCH: mvsas: add support for Supermicro AOC-SAS2LP-MV8
Date: Mon, 28 Apr 2014 16:52:01 +0200
Message-ID: <20140428145201.GG29712@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com
List-Id: linux-scsi@vger.kernel.org

Add support for the AOC-SAS2LP-MV8 SAS-2 controller from SuperMicro.
This controller has subdevice id 0x9485 instead of 0x9480, and apparently
this simple patch is the only thing needed to make it work.

# lspci -vn
[...]
03:00.0 0104: 1b4b:9485 (rev 03)
	Subsystem: 1b4b:9485
	Flags: bus master, fast devsel, latency 0, IRQ 24
	Memory at feba0000 (64-bit, non-prefetchable) [size=128K]
	Memory at febc0000 (64-bit, non-prefetchable) [size=256K]
	Expansion ROM at feb90000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Kernel driver in use: mvsas
	Kernel modules: mvsas

Signed-off-by: Jan Kasprzak <kas@fi.muni.cz>

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5ff978b..eacee48 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -728,6 +728,15 @@ static struct pci_device_id mvs_pci_table[] = {
 		.class_mask	= 0,
 		.driver_data	= chip_9485,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
+		.device		= 0x9485,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x9485,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9485,
+	},
 	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
 	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
 	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| New GPG 4096R/A45477D5 - see http://www.fi.muni.cz/~kas/pgp-rollover.txt |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
  There's clearly a balance between "octopus merges are fine" and "Christ,
  that's not an octopus, that's a Cthulhu merge".         --Linus Torvalds
