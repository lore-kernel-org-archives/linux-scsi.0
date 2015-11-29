From: Ondrej Zary <linux@rainbow-software.org>
Subject: [RFC PATCH 74/71] ncr5380: Enable PDMA for NCR53C400A
Date: Sun, 29 Nov 2015 10:39:40 +0100
Message-ID: <1448789980-30094-2-git-send-email-linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083455.331768508@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add I/O register mapping for NCR53C400A and enable PDMA mode to
improve performance and fix non-working IRQ.

Tested with HP C2502 (and user-space enabler).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index ce444da..c3abe48 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -324,7 +324,10 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 #endif
 			break;
 		case BOARD_NCR53C400A:
+			flags = FLAG_NO_DMA_FIXUP;
+#ifndef PSEUDO_DMA
 			flags = FLAG_NO_PSEUDO_DMA;
+#endif
 			ports = ncr_53c400a_ports;
 			break;
 		case BOARD_DTC3181E:
@@ -412,6 +415,11 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 			hostdata->c400_blk_cnt = 1;
 			hostdata->c400_host_buf = 4;
 		}
+		if (overrides[current_override].board == BOARD_NCR53C400A) {
+			hostdata->c400_ctl_status = 9;
+			hostdata->c400_blk_cnt = 10;
+			hostdata->c400_host_buf = 8;
+		}
 #else
 		instance->base = overrides[current_override].NCR5380_map_name;
 		hostdata->iomem = iomem;
@@ -425,7 +433,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 		if (NCR5380_init(instance, flags))
 			goto out_unregister;
 
-		if (overrides[current_override].board == BOARD_NCR53C400)
+		if (overrides[current_override].board == BOARD_NCR53C400 ||
+		    overrides[current_override].board == BOARD_NCR53C400A)
 			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 
 		NCR5380_maybe_reset_bus(instance);
-- 
Ondrej Zary
