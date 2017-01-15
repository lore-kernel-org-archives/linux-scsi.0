From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 3/6] ncr5380: Reduce #include files
Date: Sun, 15 Jan 2017 18:50:57 -0500 (EST)
Message-ID: <858f2995e908fb896df016fa6747e871c4b8a953.1484523085.git.fthain@telegraphics.com.au>
References: <cover.1484523085.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1484523085.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The NCR5380 wrapper drivers don't export symbols or declarations and
don't actually need separate header files. Most of these header files
were removed already; only sun3_scsi.h and g_NCR5380.h remain.

Move the remaining definitions to the corresponding .c files to improve
readability and proximity. The #defines which influence the #included
core driver are no longer mixed up with unrelated #defines and #includes.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c |  45 ++++++++++++++++++++-
 drivers/scsi/g_NCR5380.h |  56 --------------------------
 drivers/scsi/sun3_scsi.c |  80 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sun3_scsi.h | 102 -----------------------------------------------
 4 files changed, 122 insertions(+), 161 deletions(-)
 delete mode 100644 drivers/scsi/g_NCR5380.h
 delete mode 100644 drivers/scsi/sun3_scsi.h

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 6f9665d..67c8dac 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -26,14 +26,55 @@
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <scsi/scsi_host.h>
-#include "g_NCR5380.h"
-#include "NCR5380.h"
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/isa.h>
 #include <linux/pnp.h>
 #include <linux/interrupt.h>
 
+/* Definitions for the core NCR5380 driver. */
+
+#define NCR5380_read(reg) \
+	ioread8(hostdata->io + hostdata->offset + (reg))
+#define NCR5380_write(reg, value) \
+	iowrite8(value, hostdata->io + hostdata->offset + (reg))
+
+#define NCR5380_implementation_fields \
+	int offset; \
+	int c400_ctl_status; \
+	int c400_blk_cnt; \
+	int c400_host_buf; \
+	int io_width
+
+#define NCR5380_dma_xfer_len            generic_NCR5380_dma_xfer_len
+#define NCR5380_dma_recv_setup          generic_NCR5380_pread
+#define NCR5380_dma_send_setup          generic_NCR5380_pwrite
+#define NCR5380_dma_residual            NCR5380_dma_residual_none
+
+#define NCR5380_intr                    generic_NCR5380_intr
+#define NCR5380_queue_command           generic_NCR5380_queue_command
+#define NCR5380_abort                   generic_NCR5380_abort
+#define NCR5380_bus_reset               generic_NCR5380_bus_reset
+#define NCR5380_info                    generic_NCR5380_info
+
+#define NCR5380_io_delay(x)             udelay(x)
+
+#include "NCR5380.h"
+
+#define DRV_MODULE_NAME "g_NCR5380"
+
+#define NCR53C400_mem_base 0x3880
+#define NCR53C400_host_buffer 0x3900
+#define NCR53C400_region_size 0x3a00
+
+#define BOARD_NCR5380 0
+#define BOARD_NCR53C400 1
+#define BOARD_NCR53C400A 2
+#define BOARD_DTC3181E 3
+#define BOARD_HP_C2502 4
+
+#define IRQ_AUTO 254
+
 #define MAX_CARDS 8
 
 /* old-style parameters for compatibility */
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
deleted file mode 100644
index 81b22d9..0000000
--- a/drivers/scsi/g_NCR5380.h
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Generic Generic NCR5380 driver defines
- *
- * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *      +1 (303) 440-4894
- *
- * NCR53C400 extensions (c) 1994,1995,1996, Kevin Lentin
- *    K.Lentin@cs.monash.edu.au
- */
-
-#ifndef GENERIC_NCR5380_H
-#define GENERIC_NCR5380_H
-
-#define DRV_MODULE_NAME "g_NCR5380"
-
-#define NCR5380_read(reg) \
-	ioread8(hostdata->io + hostdata->offset + (reg))
-#define NCR5380_write(reg, value) \
-	iowrite8(value, hostdata->io + hostdata->offset + (reg))
-
-#define NCR5380_implementation_fields \
-	int offset; \
-	int c400_ctl_status; \
-	int c400_blk_cnt; \
-	int c400_host_buf; \
-	int io_width;
-
-#define NCR53C400_mem_base 0x3880
-#define NCR53C400_host_buffer 0x3900
-#define NCR53C400_region_size 0x3a00
-
-#define NCR5380_dma_xfer_len		generic_NCR5380_dma_xfer_len
-#define NCR5380_dma_recv_setup		generic_NCR5380_pread
-#define NCR5380_dma_send_setup		generic_NCR5380_pwrite
-#define NCR5380_dma_residual		NCR5380_dma_residual_none
-
-#define NCR5380_intr generic_NCR5380_intr
-#define NCR5380_queue_command generic_NCR5380_queue_command
-#define NCR5380_abort generic_NCR5380_abort
-#define NCR5380_bus_reset generic_NCR5380_bus_reset
-#define NCR5380_info generic_NCR5380_info
-
-#define NCR5380_io_delay(x)		udelay(x)
-
-#define BOARD_NCR5380	0
-#define BOARD_NCR53C400	1
-#define BOARD_NCR53C400A 2
-#define BOARD_DTC3181E	3
-#define BOARD_HP_C2502	4
-
-#define IRQ_AUTO	254
-
-#endif /* GENERIC_NCR5380_H */
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 166f466..14cebaf 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -34,7 +34,6 @@
 #include <asm/dvma.h>
 
 #include <scsi/scsi_host.h>
-#include "sun3_scsi.h"
 
 /* minimum number of bytes to do dma on */
 #define DMA_MIN_SIZE                    129
@@ -58,6 +57,85 @@
 
 #include "NCR5380.h"
 
+/* dma regs start at regbase + 8, directly after the NCR regs */
+struct sun3_dma_regs {
+	unsigned short dma_addr_hi; /* vme only */
+	unsigned short dma_addr_lo; /* vme only */
+	unsigned short dma_count_hi; /* vme only */
+	unsigned short dma_count_lo; /* vme only */
+	unsigned short udc_data; /* udc dma data reg (obio only) */
+	unsigned short udc_addr; /* uda dma addr reg (obio only) */
+	unsigned short fifo_data; /* fifo data reg,
+	                           * holds extra byte on odd dma reads
+	                           */
+	unsigned short fifo_count;
+	unsigned short csr; /* control/status reg */
+	unsigned short bpack_hi; /* vme only */
+	unsigned short bpack_lo; /* vme only */
+	unsigned short ivect; /* vme only */
+	unsigned short fifo_count_hi; /* vme only */
+};
+
+/* ucd chip specific regs - live in dvma space */
+struct sun3_udc_regs {
+	unsigned short rsel; /* select regs to load */
+	unsigned short addr_hi; /* high word of addr */
+	unsigned short addr_lo; /* low word */
+	unsigned short count; /* words to be xfer'd */
+	unsigned short mode_hi; /* high word of channel mode */
+	unsigned short mode_lo; /* low word of channel mode */
+};
+
+/* addresses of the udc registers */
+#define UDC_MODE 0x38
+#define UDC_CSR 0x2e /* command/status */
+#define UDC_CHN_HI 0x26 /* chain high word */
+#define UDC_CHN_LO 0x22 /* chain lo word */
+#define UDC_CURA_HI 0x1a /* cur reg A high */
+#define UDC_CURA_LO 0x0a /* cur reg A low */
+#define UDC_CURB_HI 0x12 /* cur reg B high */
+#define UDC_CURB_LO 0x02 /* cur reg B low */
+#define UDC_MODE_HI 0x56 /* mode reg high */
+#define UDC_MODE_LO 0x52 /* mode reg low */
+#define UDC_COUNT 0x32 /* words to xfer */
+
+/* some udc commands */
+#define UDC_RESET 0
+#define UDC_CHN_START 0xa0 /* start chain */
+#define UDC_INT_ENABLE 0x32 /* channel 1 int on */
+
+/* udc mode words */
+#define UDC_MODE_HIWORD 0x40
+#define UDC_MODE_LSEND 0xc2
+#define UDC_MODE_LRECV 0xd2
+
+/* udc reg selections */
+#define UDC_RSEL_SEND 0x282
+#define UDC_RSEL_RECV 0x182
+
+/* bits in csr reg */
+#define CSR_DMA_ACTIVE 0x8000
+#define CSR_DMA_CONFLICT 0x4000
+#define CSR_DMA_BUSERR 0x2000
+
+#define CSR_FIFO_EMPTY 0x400 /* fifo flushed? */
+#define CSR_SDB_INT 0x200 /* sbc interrupt pending */
+#define CSR_DMA_INT 0x100 /* dma interrupt pending */
+
+#define CSR_LEFT 0xc0
+#define CSR_LEFT_3 0xc0
+#define CSR_LEFT_2 0x80
+#define CSR_LEFT_1 0x40
+#define CSR_PACK_ENABLE 0x20
+
+#define CSR_DMA_ENABLE 0x10
+
+#define CSR_SEND 0x8 /* 1 = send  0 = recv */
+#define CSR_FIFO 0x2 /* reset fifo */
+#define CSR_INTR 0x4 /* interrupt enable */
+#define CSR_SCSI 0x1
+
+#define VME_DATA24 0x3d00
 
 extern int sun3_map_test(unsigned long, char *);
 
diff --git a/drivers/scsi/sun3_scsi.h b/drivers/scsi/sun3_scsi.h
deleted file mode 100644
index d22745f..0000000
--- a/drivers/scsi/sun3_scsi.h
+++ /dev/null
@@ -1,102 +0,0 @@
-/*
- * Sun3 SCSI stuff by Erik Verbruggen (erik@bigmama.xtdnet.nl)
- *
- * Sun3 DMA additions by Sam Creasey (sammy@sammy.net)
- *
- * Adapted from mac_scsinew.h:
- */
-/*
- * Cumana Generic NCR5380 driver defines
- *
- * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *      +1 (303) 440-4894
- */
-
-#ifndef SUN3_SCSI_H
-#define SUN3_SCSI_H
-
-/* additional registers - mainly DMA control regs */
-/* these start at regbase + 8 -- directly after the NCR regs */
-struct sun3_dma_regs {
-	unsigned short dma_addr_hi; /* vme only */
-	unsigned short dma_addr_lo; /* vme only */
-	unsigned short dma_count_hi; /* vme only */
-	unsigned short dma_count_lo; /* vme only */
-	unsigned short udc_data; /* udc dma data reg (obio only) */
-	unsigned short udc_addr; /* uda dma addr reg (obio only) */
-	unsigned short fifo_data; /* fifo data reg, holds extra byte on
-				     odd dma reads */
-	unsigned short fifo_count; 
-	unsigned short csr; /* control/status reg */
-	unsigned short bpack_hi; /* vme only */
-	unsigned short bpack_lo; /* vme only */
-	unsigned short ivect; /* vme only */
-	unsigned short fifo_count_hi; /* vme only */
-};
-
-/* ucd chip specific regs - live in dvma space */
-struct sun3_udc_regs {
-     unsigned short rsel; /* select regs to load */
-     unsigned short addr_hi; /* high word of addr */
-     unsigned short addr_lo; /* low word */
-     unsigned short count; /* words to be xfer'd */
-     unsigned short mode_hi; /* high word of channel mode */
-     unsigned short mode_lo; /* low word of channel mode */
-};
-
-/* addresses of the udc registers */
-#define UDC_MODE 0x38 
-#define UDC_CSR 0x2e /* command/status */
-#define UDC_CHN_HI 0x26 /* chain high word */
-#define UDC_CHN_LO 0x22 /* chain lo word */
-#define UDC_CURA_HI 0x1a /* cur reg A high */
-#define UDC_CURA_LO 0x0a /* cur reg A low */
-#define UDC_CURB_HI 0x12 /* cur reg B high */
-#define UDC_CURB_LO 0x02 /* cur reg B low */
-#define UDC_MODE_HI 0x56 /* mode reg high */
-#define UDC_MODE_LO 0x52 /* mode reg low */
-#define UDC_COUNT 0x32 /* words to xfer */
-
-/* some udc commands */
-#define UDC_RESET 0
-#define UDC_CHN_START 0xa0 /* start chain */
-#define UDC_INT_ENABLE 0x32 /* channel 1 int on */
-
-/* udc mode words */
-#define UDC_MODE_HIWORD 0x40
-#define UDC_MODE_LSEND 0xc2
-#define UDC_MODE_LRECV 0xd2
-
-/* udc reg selections */
-#define UDC_RSEL_SEND 0x282
-#define UDC_RSEL_RECV 0x182
-
-/* bits in csr reg */
-#define CSR_DMA_ACTIVE 0x8000
-#define CSR_DMA_CONFLICT 0x4000
-#define CSR_DMA_BUSERR 0x2000
-
-#define CSR_FIFO_EMPTY 0x400 /* fifo flushed? */
-#define CSR_SDB_INT 0x200 /* sbc interrupt pending */
-#define CSR_DMA_INT 0x100 /* dma interrupt pending */
-
-#define CSR_LEFT 0xc0
-#define CSR_LEFT_3 0xc0
-#define CSR_LEFT_2 0x80
-#define CSR_LEFT_1 0x40
-#define CSR_PACK_ENABLE 0x20
-
-#define CSR_DMA_ENABLE 0x10
-
-#define CSR_SEND 0x8 /* 1 = send  0 = recv */
-#define CSR_FIFO 0x2 /* reset fifo */
-#define CSR_INTR 0x4 /* interrupt enable */
-#define CSR_SCSI 0x1 
-
-#define VME_DATA24 0x3d00
-
-#endif /* SUN3_SCSI_H */
-
-- 
2.10.2
