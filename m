From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 18/22] ncr5380: Remove DONT_USE_INTR and AUTOPROBE_IRQ macros
Date: Mon, 14 Mar 2016 15:27:18 +1100
Message-ID: <20160314042705.346693900@telegraphics.com.au>
References: <20160314042700.596192247@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-DONT_USE_INTR-and-AUTOPROBE_IRQ-macros
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c   |   12 +-----------
 drivers/scsi/NCR5380.h   |    4 ----
 drivers/scsi/arm/oak.c   |    2 --
 drivers/scsi/dmx3191d.c  |    2 --
 drivers/scsi/dtc.c       |   12 +++---------
 drivers/scsi/g_NCR5380.c |    2 --
 drivers/scsi/pas16.c     |    1 -
 drivers/scsi/t128.c      |    1 -
 8 files changed, 4 insertions(+), 32 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-14 15:26:51.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-14 15:26:52.000000000 +1100
@@ -106,9 +106,6 @@
  * DIFFERENTIAL - if defined, NCR53c81 chips will use external differential
  * transceivers.
  *
- * DONT_USE_INTR - if defined, never use interrupts, even if we probe or
- * override-configure an IRQ.
- *
  * PSEUDO_DMA - if defined, PSEUDO DMA is used during the data transfer phases.
  *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
@@ -464,9 +461,6 @@ static void prepare_info(struct Scsi_Hos
 	         hostdata->flags & FLAG_DMA_FIXUP     ? "DMA_FIXUP "     : "",
 	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
 	         hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
-#ifdef AUTOPROBE_IRQ
-	         "AUTOPROBE_IRQ "
-#endif
 #ifdef DIFFERENTIAL
 	         "DIFFERENTIAL "
 #endif
@@ -919,8 +913,6 @@ static void NCR5380_dma_complete(struct
 	}
 }
 
-#ifndef DONT_USE_INTR
-
 /**
  * NCR5380_intr - generic NCR5380 irq handler
  * @irq: interrupt number
@@ -955,7 +947,7 @@ static void NCR5380_dma_complete(struct
  * the Busy Monitor interrupt is enabled together with DMA Mode.
  */
 
-static irqreturn_t NCR5380_intr(int irq, void *dev_id)
+static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
 {
 	struct Scsi_Host *instance = dev_id;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
@@ -1024,8 +1016,6 @@ static irqreturn_t NCR5380_intr(int irq,
 	return IRQ_RETVAL(handled);
 }
 
-#endif
-
 /*
  * Function : int NCR5380_select(struct Scsi_Host *instance,
  * struct scsi_cmnd *cmd)
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-03-14 15:26:48.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-03-14 15:26:52.000000000 +1100
@@ -282,16 +282,12 @@ static void NCR5380_print(struct Scsi_Ho
 #define NCR5380_dprint_phase(flg, arg) do {} while (0)
 #endif
 
-#if defined(AUTOPROBE_IRQ)
 static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
-#endif
 static int NCR5380_init(struct Scsi_Host *instance, int flags);
 static int NCR5380_maybe_reset_bus(struct Scsi_Host *);
 static void NCR5380_exit(struct Scsi_Host *instance);
 static void NCR5380_information_transfer(struct Scsi_Host *instance);
-#ifndef DONT_USE_INTR
 static irqreturn_t NCR5380_intr(int irq, void *dev_id);
-#endif
 static void NCR5380_main(struct work_struct *work);
 static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-03-14 15:26:39.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-03-14 15:26:52.000000000 +1100
@@ -14,8 +14,6 @@
 
 #include <scsi/scsi_host.h>
 
-#define DONT_USE_INTR
-
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
 
 #define NCR5380_read(reg) \
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-03-14 15:26:49.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-03-14 15:26:52.000000000 +1100
@@ -34,8 +34,6 @@
  * Definitions for the generic 5380 driver.
  */
 
-#define DONT_USE_INTR
-
 #define NCR5380_read(reg)		inb(instance->io_port + reg)
 #define NCR5380_write(reg, value)	outb(value, instance->io_port + reg)
 
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-03-14 15:26:39.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-03-14 15:26:52.000000000 +1100
@@ -1,5 +1,3 @@
-#define DONT_USE_INTR
-
 /*
  * DTC 3180/3280 driver, by
  *	Ray Van Tassle	rayvt@comm.mot.com
@@ -53,7 +51,6 @@
 #include <scsi/scsi_host.h>
 
 #include "dtc.h"
-#define AUTOPROBE_IRQ
 #include "NCR5380.h"
 
 /*
@@ -243,9 +240,10 @@ found:
 		if (instance->irq == 255)
 			instance->irq = NO_IRQ;
 
-#ifndef DONT_USE_INTR
 		/* With interrupts enabled, it will sometimes hang when doing heavy
 		 * reads. So better not enable them until I finger it out. */
+		instance->irq = NO_IRQ;
+
 		if (instance->irq != NO_IRQ)
 			if (request_irq(instance->irq, dtc_intr, 0,
 					"dtc", instance)) {
@@ -257,11 +255,7 @@ found:
 			printk(KERN_WARNING "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
 			printk(KERN_WARNING "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
 		}
-#else
-		if (instance->irq != NO_IRQ)
-			printk(KERN_WARNING "scsi%d : interrupts not used. Might as well not jumper it.\n", instance->host_no);
-		instance->irq = NO_IRQ;
-#endif
+
 		dprintk(NDEBUG_INIT, "scsi%d : irq = %d\n",
 		        instance->host_no, instance->irq);
 
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-03-14 15:26:39.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-03-14 15:26:52.000000000 +1100
@@ -56,8 +56,6 @@
  *     
  */
 
-#define AUTOPROBE_IRQ
-
 #include <asm/io.h>
 #include <linux/blkdev.h>
 #include <linux/module.h>
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-03-14 15:26:39.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-03-14 15:26:52.000000000 +1100
@@ -75,7 +75,6 @@
 
 #include <scsi/scsi_host.h>
 #include "pas16.h"
-#define AUTOPROBE_IRQ
 #include "NCR5380.h"
 
 
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-03-14 15:26:39.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-03-14 15:26:52.000000000 +1100
@@ -74,7 +74,6 @@
 
 #include <scsi/scsi_host.h>
 #include "t128.h"
-#define AUTOPROBE_IRQ
 #include "NCR5380.h"
 
 static struct override {
