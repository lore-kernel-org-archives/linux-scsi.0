From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 15/29] ncr5380: Remove *_RELEASE macros
Date: Thu, 02 Oct 2014 16:56:43 +1000
Message-ID: <20141002065631.866173651@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-RELEASE-macros
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

The *_RELEASE macros don't tell me anything. In some cases the version in
the macro contradicts the version in the comments. Anyway, the Linux kernel
version is sufficient information. Remove these macros to improve readability.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   18 ------------------
 drivers/scsi/NCR5380.h       |    5 -----
 drivers/scsi/arm/cumana_1.c  |    2 --
 drivers/scsi/arm/oak.c       |    2 --
 drivers/scsi/atari_NCR5380.c |    4 ----
 drivers/scsi/dtc.c           |    5 -----
 drivers/scsi/dtc.h           |    2 --
 drivers/scsi/g_NCR5380.c     |    2 --
 drivers/scsi/g_NCR5380.h     |    5 -----
 drivers/scsi/mac_scsi.c      |    2 --
 drivers/scsi/mac_scsi.h      |    4 ----
 drivers/scsi/pas16.h         |    2 --
 drivers/scsi/sun3_NCR5380.c  |    4 ----
 drivers/scsi/sun3_scsi.c     |    2 --
 drivers/scsi/sun3_scsi.h     |    4 ----
 drivers/scsi/t128.c          |    2 --
 drivers/scsi/t128.h          |    4 ----
 17 files changed, 69 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-10-02 16:56:09.000000000 +1000
+++ linux/drivers/scsi/NCR5380.c	2014-10-02 16:56:11.000000000 +1000
@@ -11,8 +11,6 @@
  *      drew@colorado.edu
  *      +1 (303) 666-5836
  *
- * DISTRIBUTION RELEASE 6. 
- *
  * For more information, please consult 
  *
  * NCR 5380 Family
@@ -736,22 +734,6 @@ static int __maybe_unused NCR5380_show_i
 
 	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
-	SPRINTF("NCR5380 core release=%d.   ", NCR5380_PUBLIC_RELEASE);
-	if (((struct NCR5380_hostdata *) instance->hostdata)->flags & FLAG_NCR53C400)
-		SPRINTF("ncr53c400 release=%d.  ", NCR53C400_PUBLIC_RELEASE);
-#ifdef DTC_PUBLIC_RELEASE
-	SPRINTF("DTC 3180/3280 release %d", DTC_PUBLIC_RELEASE);
-#endif
-#ifdef T128_PUBLIC_RELEASE
-	SPRINTF("T128 release %d", T128_PUBLIC_RELEASE);
-#endif
-#ifdef GENERIC_NCR5380_PUBLIC_RELEASE
-	SPRINTF("Generic5380 release %d", GENERIC_NCR5380_PUBLIC_RELEASE);
-#endif
-#ifdef PAS16_PUBLIC_RELEASE
-	SPRINTF("PAS16 release=%d", PAS16_PUBLIC_RELEASE);
-#endif
-
 #ifdef PSEUDO_DMA
 	SPRINTF("Highwater I/O busy spin counts: write %d, read %d\n",
 	        hostdata->spin_max_w, hostdata->spin_max_r);
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-02 16:56:11.000000000 +1000
@@ -11,8 +11,6 @@
  *	drew@colorado.edu
  *	+1 (303) 666-5836
  *
- * DISTRIBUTION RELEASE 6.
- *
  * For more information, please consult
  *
  * NCR 5380 Family
@@ -739,7 +737,6 @@ static void NCR5380_print_status(struct
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
-	printk("\nNCR5380 core release=%d.\n", NCR5380_PUBLIC_RELEASE);
 	local_irq_save(flags);
 	printk("NCR5380: coroutine is%s running.\n",
 		main_running ? "" : "n't");
@@ -783,7 +780,6 @@ static int __maybe_unused NCR5380_show_i
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
-	seq_printf(m, "NCR5380 core release=%d.\n", NCR5380_PUBLIC_RELEASE);
 	local_irq_save(flags);
 	seq_printf(m, "NCR5380: coroutine is%s running.\n",
 		main_running ? "" : "n't");
Index: linux/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-10-02 16:56:11.000000000 +1000
@@ -13,8 +13,6 @@
  * 	drew@colorado.edu
  *	+1 (303) 666-5836
  *
- * DISTRIBUTION RELEASE 6. 
- *
  * For more information, please consult 
  *
  * NCR 5380 Family
@@ -685,7 +683,6 @@ static void NCR5380_print_status(struct
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
-	printk("\nNCR5380 core release=%d.\n", NCR5380_PUBLIC_RELEASE);
 	local_irq_save(flags);
 	printk("NCR5380: coroutine is%s running.\n",
 		main_running ? "" : "n't");
@@ -729,7 +726,6 @@ static int __maybe_unused NCR5380_show_i
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
-	seq_printf(m, "NCR5380 core release=%d.\n", NCR5380_PUBLIC_RELEASE);
 	local_irq_save(flags);
 	seq_printf(m, "NCR5380: coroutine is%s running.\n",
 		main_running ? "" : "n't");
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-10-02 16:56:09.000000000 +1000
+++ linux/drivers/scsi/NCR5380.h	2014-10-02 16:56:11.000000000 +1000
@@ -7,8 +7,6 @@
  * 	drew@colorado.edu
  *      +1 (303) 666-5836
  *
- * DISTRIBUTION RELEASE 7
- *
  * For more information, please consult 
  *
  * NCR 5380 Family
@@ -27,9 +25,6 @@
 #include <linux/interrupt.h>
 #include <scsi/scsi_eh.h>
 
-#define NCR5380_PUBLIC_RELEASE 7
-#define NCR53C400_PUBLIC_RELEASE 2
-
 #define NDEBUG_ARBITRATION	0x1
 #define NDEBUG_AUTOSENSE	0x2
 #define NDEBUG_DMA		0x4
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/arm/cumana_1.c	2014-10-02 16:56:11.000000000 +1000
@@ -20,8 +20,6 @@
 
 #define PSEUDO_DMA
 
-#define CUMANASCSI_PUBLIC_RELEASE 1
-
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
 #define NCR5380_local_declare()		struct Scsi_Host *_instance
 #define NCR5380_setup(instance)		_instance = instance
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2014-10-02 16:56:09.000000000 +1000
+++ linux/drivers/scsi/arm/oak.c	2014-10-02 16:56:11.000000000 +1000
@@ -18,8 +18,6 @@
 #include <scsi/scsi_host.h>
 
 /*#define PSEUDO_DMA*/
-
-#define OAKSCSI_PUBLIC_RELEASE 1
 #define DONT_USE_INTR
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-10-02 16:56:09.000000000 +1000
+++ linux/drivers/scsi/dtc.c	2014-10-02 16:56:11.000000000 +1000
@@ -17,8 +17,6 @@
  *	(Unix and Linux consulting and custom programming)
  *	drew@colorado.edu
  *      +1 (303) 440-4894
- *
- * DISTRIBUTION RELEASE 1.
  */
 
 /*
@@ -66,9 +64,6 @@
 #define AUTOPROBE_IRQ
 #include "NCR5380.h"
 
-
-#define DTC_PUBLIC_RELEASE 2
-
 /*
  * The DTC3180 & 3280 boards are memory mapped.
  * 
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/g_NCR5380.h	2014-10-02 16:56:11.000000000 +1000
@@ -9,16 +9,11 @@
  *
  * NCR53C400 extensions (c) 1994,1995,1996, Kevin Lentin
  *    K.Lentin@cs.monash.edu.au
- *
- * ALPHA RELEASE 1. 
  */
 
 #ifndef GENERIC_NCR5380_H
 #define GENERIC_NCR5380_H
 
-
-#define GENERIC_NCR5380_PUBLIC_RELEASE 1
-
 #ifdef NCR53C400
 #define BIOSPARAM
 #define NCR5380_BIOSPARAM generic_NCR5380_biosparam
Index: linux/drivers/scsi/mac_scsi.h
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.h	2014-10-02 16:56:10.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.h	2014-10-02 16:56:11.000000000 +1000
@@ -6,15 +6,11 @@
  *	(Unix and Linux consulting and custom programming)
  *	drew@colorado.edu
  *      +1 (303) 440-4894
- *
- * ALPHA RELEASE 1.
  */
 
 #ifndef MAC_NCR5380_H
 #define MAC_NCR5380_H
 
-#define MACSCSI_PUBLIC_RELEASE 2
-
 #ifndef ASM
 
 #include <scsi/scsicam.h>
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/pas16.h	2014-10-02 16:56:11.000000000 +1000
@@ -24,8 +24,6 @@
 #ifndef PAS16_H
 #define PAS16_H
 
-#define PAS16_PUBLIC_RELEASE 3
-
 #define PDEBUG_INIT	0x1
 #define PDEBUG_TRANSFER 0x2
 
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-10-02 16:56:10.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.h	2014-10-02 16:56:11.000000000 +1000
@@ -13,15 +13,11 @@
  *	(Unix and Linux consulting and custom programming)
  *	drew@colorado.edu
  *      +1 (303) 440-4894
- *
- * ALPHA RELEASE 1.
  */
 
 #ifndef SUN3_SCSI_H
 #define SUN3_SCSI_H
 
-#define SUN3SCSI_PUBLIC_RELEASE 1
-
 /*
  * Int: level 2 autovector
  * IO: type 1, base 0x00140000, 5 bits phys space: A<4..0>
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/t128.h	2014-10-02 16:56:11.000000000 +1000
@@ -8,8 +8,6 @@
  *	drew@colorado.edu
  *      +1 (303) 440-4894
  *
- * DISTRIBUTION RELEASE 3.
- *
  * For more information, please consult
  *
  * Trantor Systems, Ltd.
@@ -25,8 +23,6 @@
 #ifndef T128_H
 #define T128_H
 
-#define T128_PUBLIC_RELEASE 3
-
 #define TDEBUG		0
 #define TDEBUG_INIT	0x1
 #define TDEBUG_TRANSFER 0x2
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/dtc.h	2014-10-02 16:56:11.000000000 +1000
@@ -5,8 +5,6 @@
  *	(Unix and Linux consulting and custom programming)
  *	drew@colorado.edu
  *      +1 (303) 440-4894
- *
- * DISTRIBUTION RELEASE 2. 
  */
 
 #ifndef DTC3280_H
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/g_NCR5380.c	2014-10-02 16:56:11.000000000 +1000
@@ -18,8 +18,6 @@
  *
  * Added ISAPNP support for DTC436 adapters,
  * Thomas Sailer, sailer@ife.ee.ethz.ch
- *
- * ALPHA RELEASE 1. 
  */
 
 /* 
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-02 16:56:10.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.c	2014-10-02 16:56:11.000000000 +1000
@@ -9,8 +9,6 @@
  * Generic Generic NCR5380 driver
  *
  * Copyright 1995, Russell King
- *
- * ALPHA RELEASE 1.
  */
 
 #include <linux/types.h>
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-02 16:56:10.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-02 16:56:11.000000000 +1000
@@ -20,8 +20,6 @@
  * Generic Generic NCR5380 driver
  *
  * Copyright 1995, Russell King
- *
- * ALPHA RELEASE 1.
  */
 
 #include <linux/types.h>
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/t128.c	2014-10-02 16:56:11.000000000 +1000
@@ -11,8 +11,6 @@
  *	drew@colorado.edu
  *      +1 (303) 440-4894
  *
- * DISTRIBUTION RELEASE 3.
- *
  * For more information, please consult 
  *
  * Trantor Systems, Ltd.
