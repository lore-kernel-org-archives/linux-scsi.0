From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 26/29] sun3_scsi: Move macro definitions
Date: Thu, 02 Oct 2014 16:56:54 +1000
Message-ID: <20141002065634.486177354@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=sun3_scsi-move-macro-definitions
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-02 16:56:22.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-02 16:56:23.000000000 +1000
@@ -36,18 +36,42 @@
 #include <asm/idprom.h>
 #include <asm/machines.h>
 
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
@@ -68,9 +92,7 @@ module_param(setup_use_tagged_queuing, i
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
 
-static struct scsi_cmnd *sun3_dma_setup_done = NULL;
-
-#define	RESET_RUN_DONE
+/* #define RESET_BOOT */
 
 #define	AFTER_RESET_DELAY	(HZ/2)
 
@@ -83,6 +105,7 @@ static struct scsi_cmnd *sun3_dma_setup_
 /* minimum number of bytes to do dma on */
 #define SUN3_DMA_MINSIZE 128
 
+static struct scsi_cmnd *sun3_dma_setup_done;
 static unsigned char *sun3_scsi_regp;
 static volatile struct sun3_dma_regs *dregs;
 static struct sun3_udc_regs *udc_regs;
@@ -134,9 +157,6 @@ static inline void sun3_udc_write(unsign
 static void sun3_scsi_reset_boot(struct Scsi_Host *instance)
 {
 	unsigned long end;
-
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
 	
 	/*
 	 * Do a SCSI reset to clean up the bus during initialization. No
@@ -213,7 +233,6 @@ static irqreturn_t scsi_sun3_intr(int ir
 void sun3_sun3_debug (void)
 {
 	unsigned long flags;
-	NCR5380_local_declare();
 
 	if (default_instance) {
 			local_irq_save(flags);
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-10-02 16:56:22.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.h	2014-10-02 16:56:23.000000000 +1000
@@ -27,31 +27,6 @@
 
 #define IOBASE_SUN3_VMESCSI 0xff200000
 
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
