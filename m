From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 08/78] ncr5380: Move NCR53C400-specific code
Date: Sun, 03 Jan 2016 16:05:09 +1100
Message-ID: <20160103050503.171740246@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49392 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbcACFSJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:09 -0500
Content-Disposition: inline; filename=ncr5380-remove-NCR53C400-macro
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Move board-specific code like this,
	NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
from the core driver to the board driver. Eliminate the NCR53C400 macro
from the core driver. Removal of all macros like this one will be
necessary in order to have one core driver that can support all kinds of
boards.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---

Changed since v1:
- Don't set FLAG_NO_PSEUDO_DMA when !defined(PSEUDO_DMA). It's pointless.

---
 drivers/scsi/NCR5380.c   |   18 ------------------
 drivers/scsi/g_NCR5380.c |   21 ++++++++++++++++-----
 drivers/scsi/g_NCR5380.h |    6 ++----
 3 files changed, 18 insertions(+), 27 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:03.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:06.000000000 +1100
@@ -654,9 +654,6 @@ static void prepare_info(struct Scsi_Hos
 #ifdef UNSAFE
 	         "UNSAFE "
 #endif
-#ifdef NCR53C400
-	         "NCR53C400 "
-#endif
 	         "");
 }
 
@@ -782,15 +779,6 @@ static int NCR5380_init(struct Scsi_Host
 
 	if(in_interrupt())
 		printk(KERN_ERR "NCR5380_init called with interrupts off!\n");
-	/* 
-	 * On NCR53C400 boards, NCR5380 registers are mapped 8 past 
-	 * the base address.
-	 */
-
-#ifdef NCR53C400
-	if (flags & FLAG_NCR53C400)
-		instance->io_port += NCR53C400_address_adjust;
-#endif
 
 	hostdata->aborted = 0;
 	hostdata->id_mask = 1 << instance->this_id;
@@ -824,12 +812,6 @@ static int NCR5380_init(struct Scsi_Host
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 	NCR5380_write(SELECT_ENABLE_REG, 0);
-
-#ifdef NCR53C400
-	if (hostdata->flags & FLAG_NCR53C400) {
-		NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
-	}
-#endif
 	return 0;
 }
 
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:03:03.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:03:06.000000000 +1100
@@ -64,9 +64,7 @@
 #define AUTOPROBE_IRQ
 
 #ifdef CONFIG_SCSI_GENERIC_NCR53C400
-#define NCR53C400_PSEUDO_DMA 1
 #define PSEUDO_DMA
-#define NCR53C400
 #endif
 
 #include <asm/io.h>
@@ -263,7 +261,7 @@ static int __init generic_NCR5380_detect
 	static unsigned int __initdata dtc_3181e_ports[] = {
 		0x220, 0x240, 0x280, 0x2a0, 0x2c0, 0x300, 0x320, 0x340, 0
 	};
-	int flags = 0;
+	int flags;
 	struct Scsi_Host *instance;
 #ifdef SCSI_G_NCR5380_MEM
 	unsigned long base;
@@ -324,12 +322,15 @@ static int __init generic_NCR5380_detect
 			continue;
 
 		ports = NULL;
+		flags = 0;
 		switch (overrides[current_override].board) {
 		case BOARD_NCR5380:
 			flags = FLAG_NO_PSEUDO_DMA;
 			break;
 		case BOARD_NCR53C400:
+#ifdef PSEUDO_DMA
 			flags = FLAG_NCR53C400;
+#endif
 			break;
 		case BOARD_NCR53C400A:
 			flags = FLAG_NO_PSEUDO_DMA;
@@ -415,6 +416,13 @@ static int __init generic_NCR5380_detect
 #ifndef SCSI_G_NCR5380_MEM
 		instance->io_port = overrides[current_override].NCR5380_map_name;
 		instance->n_io_port = region_size;
+
+		/*
+		 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
+		 * the base address.
+		 */
+		if (overrides[current_override].board == BOARD_NCR53C400)
+			instance->io_port += 8;
 #else
 		instance->base = overrides[current_override].NCR5380_map_name;
 		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
@@ -422,6 +430,9 @@ static int __init generic_NCR5380_detect
 
 		NCR5380_init(instance, flags);
 
+		if (overrides[current_override].board == BOARD_NCR53C400)
+			NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
+
 		NCR5380_maybe_reset_bus(instance);
 
 		if (overrides[current_override].irq != IRQ_AUTO)
@@ -506,7 +517,7 @@ generic_NCR5380_biosparam(struct scsi_de
 }
 #endif
 
-#ifdef NCR53C400_PSEUDO_DMA
+#ifdef PSEUDO_DMA
 
 /**
  *	NCR5380_pread		-	pseudo DMA read
@@ -690,7 +701,7 @@ static inline int NCR5380_pwrite(struct
 		; 	// TIMEOUT
 	return 0;
 }
-#endif				/* PSEUDO_DMA */
+#endif /* PSEUDO_DMA */
 
 /*
  *	Include the NCR5380 core code that we build our driver around	
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-01-03 16:03:02.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-01-03 16:03:06.000000000 +1100
@@ -14,7 +14,7 @@
 #ifndef GENERIC_NCR5380_H
 #define GENERIC_NCR5380_H
 
-#ifdef NCR53C400
+#ifdef CONFIG_SCSI_GENERIC_NCR53C400
 #define BIOSPARAM
 #define NCR5380_BIOSPARAM generic_NCR5380_biosparam
 #else
@@ -37,9 +37,8 @@
 #define NCR5380_map_type int
 #define NCR5380_map_name port
 #define NCR53C400_register_offset 0
-#define NCR53C400_address_adjust 8
 
-#ifdef NCR53C400
+#ifdef CONFIG_SCSI_GENERIC_NCR53C400
 #define NCR5380_region_size 16
 #else
 #define NCR5380_region_size 8
@@ -58,7 +57,6 @@
 #define NCR5380_map_type unsigned long
 #define NCR5380_map_name base
 #define NCR53C400_register_offset 0x108
-#define NCR53C400_address_adjust 0
 #define NCR53C400_mem_base 0x3880
 #define NCR53C400_host_buffer 0x3900
 #define NCR5380_region_size 0x3a00


