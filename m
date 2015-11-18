From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 04/71] ncr5380: Remove more pointless macros
Date: Wed, 18 Nov 2015 19:34:59 +1100
Message-ID: <20151118083456.362586813@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-pointless-macros
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ASM macro is never defined. rtrc in pas16.c is not used.
NCR5380_map_config, do_NCR5380_intr, do_t128_intr and do_pas16_intr
are unused. NCR_NOT_SET harms readability. Remove them.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.h   |    3 ---
 drivers/scsi/g_NCR5380.c |   29 ++++++++++++++---------------
 drivers/scsi/g_NCR5380.h |    5 -----
 drivers/scsi/pas16.c     |   16 ----------------
 drivers/scsi/pas16.h     |    5 -----
 drivers/scsi/t128.h      |    4 ----
 6 files changed, 14 insertions(+), 48 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-11-18 19:25:56.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-11-18 19:33:04.000000000 +1100
@@ -244,8 +244,6 @@
 #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
 #define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
 
-#ifndef ASM
-
 #ifdef SUPPORT_TAGS
 struct tag_alloc {
 	DECLARE_BITMAP(allocated, MAX_TAGS);
@@ -443,5 +441,4 @@ static __inline__ int NCR5380_pc_dma_res
 #endif				/* defined(i386) || defined(__alpha__) */
 #endif				/* defined(REAL_DMA)  */
 #endif				/* __KERNEL__ */
-#endif				/* ndef ASM */
 #endif				/* NCR5380_H */
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-11-18 19:32:59.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:04.000000000 +1100
@@ -82,14 +82,13 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
-#define NCR_NOT_SET 0
-static int ncr_irq = NCR_NOT_SET;
-static int ncr_dma = NCR_NOT_SET;
-static int ncr_addr = NCR_NOT_SET;
-static int ncr_5380 = NCR_NOT_SET;
-static int ncr_53c400 = NCR_NOT_SET;
-static int ncr_53c400a = NCR_NOT_SET;
-static int dtc_3181e = NCR_NOT_SET;
+static int ncr_irq;
+static int ncr_dma;
+static int ncr_addr;
+static int ncr_5380;
+static int ncr_53c400;
+static int ncr_53c400a;
+static int dtc_3181e;
 
 static struct override {
 	NCR5380_map_type NCR5380_map_name;
@@ -271,19 +270,19 @@ static int __init generic_NCR5380_detect
 	void __iomem *iomem;
 #endif
 
-	if (ncr_irq != NCR_NOT_SET)
+	if (ncr_irq)
 		overrides[0].irq = ncr_irq;
-	if (ncr_dma != NCR_NOT_SET)
+	if (ncr_dma)
 		overrides[0].dma = ncr_dma;
-	if (ncr_addr != NCR_NOT_SET)
+	if (ncr_addr)
 		overrides[0].NCR5380_map_name = (NCR5380_map_type) ncr_addr;
-	if (ncr_5380 != NCR_NOT_SET)
+	if (ncr_5380)
 		overrides[0].board = BOARD_NCR5380;
-	else if (ncr_53c400 != NCR_NOT_SET)
+	else if (ncr_53c400)
 		overrides[0].board = BOARD_NCR53C400;
-	else if (ncr_53c400a != NCR_NOT_SET)
+	else if (ncr_53c400a)
 		overrides[0].board = BOARD_NCR53C400A;
-	else if (dtc_3181e != NCR_NOT_SET)
+	else if (dtc_3181e)
 		overrides[0].board = BOARD_DTC3181E;
 #ifndef SCSI_G_NCR5380_MEM
 	if (!current_override && isapnp_present()) {
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2015-11-18 19:25:56.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2015-11-18 19:33:04.000000000 +1100
@@ -21,8 +21,6 @@
 #define NCR5380_BIOSPARAM NULL
 #endif
 
-#ifndef ASM
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
@@ -36,7 +34,6 @@
 
 #ifndef SCSI_G_NCR5380_MEM
 
-#define NCR5380_map_config port
 #define NCR5380_map_type int
 #define NCR5380_map_name port
 #define NCR5380_instance_name io_port
@@ -64,7 +61,6 @@
 #else 
 /* therefore SCSI_G_NCR5380_MEM */
 
-#define NCR5380_map_config memory
 #define NCR5380_map_type unsigned long
 #define NCR5380_map_name base
 #define NCR5380_instance_name base
@@ -103,6 +99,5 @@
 #define BOARD_NCR53C400A 2
 #define BOARD_DTC3181E	3
 
-#endif /* ndef ASM */
 #endif /* GENERIC_NCR5380_H */
 
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2015-11-18 19:33:02.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2015-11-18 19:33:04.000000000 +1100
@@ -145,22 +145,6 @@ static const unsigned short  pas16_offse
 		    * START_DMA_INITIATOR_RECEIVE_REG wo
 		    */
     };
-/*----------------------------------------------------------------*/
-/* the following will set the monitor border color (useful to find
- where something crashed or gets stuck at */
-/* 1 = blue
- 2 = green
- 3 = cyan
- 4 = red
- 5 = magenta
- 6 = yellow
- 7 = white
-*/
-#if 1
-#define rtrc(i) {inb(0x3da); outb(0x31, 0x3c0); outb((i), 0x3c0);}
-#else
-#define rtrc(i) {}
-#endif
 
 
 /*
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2015-11-18 19:33:02.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2015-11-18 19:33:04.000000000 +1100
@@ -95,9 +95,6 @@
 #define OPERATION_MODE_1 0xec03
 #define IO_CONFIG_3 0xf002
 
-
-#ifndef ASM
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
@@ -121,7 +118,6 @@
 #define NCR5380_write(reg, value) ( outb((value),PAS16_io_port(reg)) )
 
 #define NCR5380_intr pas16_intr
-#define do_NCR5380_intr do_pas16_intr
 #define NCR5380_queue_command pas16_queue_command
 #define NCR5380_abort pas16_abort
 #define NCR5380_bus_reset pas16_bus_reset
@@ -134,5 +130,4 @@
    
 #define PAS16_IRQS 0xd4a8 
 
-#endif /* ndef ASM */
 #endif /* PAS16_H */
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2015-11-18 19:33:02.000000000 +1100
+++ linux/drivers/scsi/t128.h	2015-11-18 19:33:04.000000000 +1100
@@ -67,8 +67,6 @@
 
 #define T_DATA_REG_OFFSET	0x1e00	/* rw 512 bytes long */
 
-#ifndef ASM
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
@@ -92,7 +90,6 @@
 #define NCR5380_write(reg, value) writeb((value),(T128_address(reg)))
 
 #define NCR5380_intr t128_intr
-#define do_NCR5380_intr do_t128_intr
 #define NCR5380_queue_command t128_queue_command
 #define NCR5380_abort t128_abort
 #define NCR5380_bus_reset t128_bus_reset
@@ -105,5 +102,4 @@
 
 #define T128_IRQS 0xc4a8
 
-#endif /* ndef ASM */
 #endif /* T128_H */
