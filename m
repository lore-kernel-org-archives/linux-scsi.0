From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 74/77] ncr5380: Enable PDMA for NCR53C400A
Date: Tue, 22 Dec 2015 12:18:52 +1100
Message-ID: <20151222011758.155997471@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=74-71
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Add I/O register mapping for NCR53C400A and enable PDMA mode to
improve performance and fix non-working IRQ.

Tested with HP C2502 (and user-space enabler).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Changes to Ondrej's version:
- An 'if' statement is now a 'switch' statement.
- Throw an error if MMIO register locations are not known.

---
 drivers/scsi/g_NCR5380.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-22 12:17:28.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-22 12:17:30.000000000 +1100
@@ -323,7 +323,7 @@ static int __init generic_NCR5380_detect
 #endif
 			break;
 		case BOARD_NCR53C400A:
-			flags = FLAG_NO_PSEUDO_DMA;
+			flags = FLAG_NO_DMA_FIXUP;
 			ports = ncr_53c400a_ports;
 			break;
 		case BOARD_DTC3181E:
@@ -405,27 +405,42 @@ static int __init generic_NCR5380_detect
 		 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
 		 * the base address.
 		 */
-		if (overrides[current_override].board == BOARD_NCR53C400) {
+		switch (overrides[current_override].board) {
+		case BOARD_NCR53C400:
 			instance->io_port += 8;
 			hostdata->c400_ctl_status = 0;
 			hostdata->c400_blk_cnt = 1;
 			hostdata->c400_host_buf = 4;
+			break;
+		case BOARD_NCR53C400A:
+			hostdata->c400_ctl_status = 9;
+			hostdata->c400_blk_cnt = 10;
+			hostdata->c400_host_buf = 8;
+			break;
 		}
 #else
 		instance->base = overrides[current_override].NCR5380_map_name;
 		hostdata->iomem = iomem;
-		if (overrides[current_override].board == BOARD_NCR53C400) {
+		switch (overrides[current_override].board) {
+		case BOARD_NCR53C400:
 			hostdata->c400_ctl_status = 0x100;
 			hostdata->c400_blk_cnt = 0x101;
 			hostdata->c400_host_buf = 0x104;
+			break;
+		case BOARD_NCR53C400A:
+			pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
+			goto out_unregister;
 		}
 #endif
 
 		if (NCR5380_init(instance, flags))
 			goto out_unregister;
 
-		if (overrides[current_override].board == BOARD_NCR53C400)
+		switch (overrides[current_override].board) {
+		case BOARD_NCR53C400:
+		case BOARD_NCR53C400A:
 			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
+		}
 
 		NCR5380_maybe_reset_bus(instance);
 
