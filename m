From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 26/36] sun3_scsi: Move macro definitions
Date: Mon, 27 Oct 2014 16:26:33 +1100
Message-ID: <20141027052613.395688590@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48356 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaJ0KcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 06:32:08 -0400
Content-Disposition: inline; filename=sun3_scsi-move-macro-definitions
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

The #defines in sun3_scsi.h are intended to influence subsequent #includes
in sun3_scsi.c. IMHO, that's too convoluted.

Move sun3_scsi.h macro definitions to sun3_scsi.c, consistent with other
NCR5380 drivers.

Omit the unused NCR5380_local_declare() and NCR5380_setup() macros.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/sun3_scsi.c |   45 ++++++++++++++++++++++++++++++++-------------
 drivers/scsi/sun3_scsi.h |   25 -------------------------
 2 files changed, 32 insertions(+), 38 deletions(-)

Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:50.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:51.000000000 +1100
@@ -33,18 +33,42 @@
 #include <asm/io.h>
 #include <asm/dvma.h>
 
-/* dma on! */
-#define REAL_DMA
-
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
-#include "NCR5380.h"
 
-extern int sun3_map_test(unsigned long, char *);
+/* Definitions for the core NCR5380 driver. */
 
-/*#define RESET_BOOT */
+#define REAL_DMA
+#define RESET_RUN_DONE
 /* #define SUPPORT_TAGS */
 
+/* #define MAX_TAGS                     32 */
+
+#define NCR5380_implementation_fields   /* none */
+
+#define NCR5380_read(reg)               sun3scsi_read(reg)
+#define NCR5380_write(reg, value)       sun3scsi_write(reg, value)
+
+#define NCR5380_queue_command           sun3scsi_queue_command
+#define NCR5380_bus_reset               sun3scsi_bus_reset
+#define NCR5380_abort                   sun3scsi_abort
+#define NCR5380_show_info               sun3scsi_show_info
+#define NCR5380_info                    sun3scsi_info
+
+#define NCR5380_dma_read_setup(instance, data, count) \
+        sun3scsi_dma_setup(data, count, 0)
+#define NCR5380_dma_write_setup(instance, data, count) \
+        sun3scsi_dma_setup(data, count, 1)
+#define NCR5380_dma_residual(instance) \
+        sun3scsi_dma_residual(instance)
+#define NCR5380_dma_xfer_len(instance, cmd, phase) \
+        sun3scsi_dma_xfer_len(cmd->SCp.this_residual, cmd, !((phase) & SR_IO))
+
+#include "NCR5380.h"
+
+
+extern int sun3_map_test(unsigned long, char *);
+
 #ifdef SUN3_SCSI_VME
 #define ENABLE_IRQ()
 #else
@@ -65,9 +89,7 @@ module_param(setup_use_tagged_queuing, i
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
 
-static struct scsi_cmnd *sun3_dma_setup_done = NULL;
-
-#define	RESET_RUN_DONE
+/* #define RESET_BOOT */
 
 #define	AFTER_RESET_DELAY	(HZ/2)
 
@@ -80,6 +102,7 @@ static struct scsi_cmnd *sun3_dma_setup_
 /* minimum number of bytes to do dma on */
 #define SUN3_DMA_MINSIZE 128
 
+static struct scsi_cmnd *sun3_dma_setup_done;
 static unsigned char *sun3_scsi_regp;
 static volatile struct sun3_dma_regs *dregs;
 static struct sun3_udc_regs *udc_regs;
@@ -131,9 +154,6 @@ static inline void sun3_udc_write(unsign
 static void sun3_scsi_reset_boot(struct Scsi_Host *instance)
 {
 	unsigned long end;
-
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
 	
 	/*
 	 * Do a SCSI reset to clean up the bus during initialization. No
@@ -210,7 +230,6 @@ static irqreturn_t scsi_sun3_intr(int ir
 void sun3_sun3_debug (void)
 {
 	unsigned long flags;
-	NCR5380_local_declare();
 
 	if (default_instance) {
 			local_irq_save(flags);
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-10-27 16:25:50.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.h	2014-10-27 16:25:51.000000000 +1100
@@ -18,31 +18,6 @@
 #ifndef SUN3_SCSI_H
 #define SUN3_SCSI_H
 
-#define MAX_TAGS 32
-
-#define NCR5380_implementation_fields /* none */
-
-#define NCR5380_local_declare() \
-        struct Scsi_Host *_instance
-
-#define NCR5380_setup(instance) \
-        _instance = instance
-
-#define NCR5380_read(reg) sun3scsi_read(reg)
-#define NCR5380_write(reg, value) sun3scsi_write(reg, value)
-
-#define NCR5380_queue_command sun3scsi_queue_command
-#define NCR5380_bus_reset sun3scsi_bus_reset
-#define NCR5380_abort sun3scsi_abort
-#define NCR5380_show_info sun3scsi_show_info
-#define NCR5380_info sun3scsi_info
-#define NCR5380_dma_xfer_len(i, cmd, phase) \
-        sun3scsi_dma_xfer_len(cmd->SCp.this_residual,cmd,((phase) & SR_IO) ? 0 : 1)
-
-#define NCR5380_dma_write_setup(instance, data, count) sun3scsi_dma_setup(data, count, 1)
-#define NCR5380_dma_read_setup(instance, data, count) sun3scsi_dma_setup(data, count, 0)
-#define NCR5380_dma_residual sun3scsi_dma_residual
-
 /* additional registers - mainly DMA control regs */
 /* these start at regbase + 8 -- directly after the NCR regs */
 struct sun3_dma_regs {


