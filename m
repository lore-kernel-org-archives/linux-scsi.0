From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include structure
Date: Tue, 18 Mar 2014 11:28:22 +1100
Message-ID: <20140318002822.372705594@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This patch series addresses several issues with NCR5380 drivers:

1. The complex network of #include directives.

2. Three inconsistent implementations of the core driver all attempting
   to share the same macro definitions in NCR5380.h.

3. Broken debugging code.

In the past these issues have led to compiler warnings and ugly hacks to
fix build failures.

This patch series fixes the debugging code by reducing the divergence
between the various core driver implementations.

The final two patches in the series further reduce divergence by refactoring
sun3_scsi.c and sun3_scsi_vme.c so that they follow the same structure as
the other NCR5380 drivers.

By the end of this patch series over 800 net lines of code have been
removed. This is mostly duplicated code that's easily eliminated once the
debugging code is made consistent (and some dead code is removed).

Better uniformity and less duplication should assist future work such as
modernization and trivial clean-up.

To make code review easier I've tried to keep these patches succinct and
free of extraneous changes. Though I did run checkpatch.pl, I've ignored
whitespace issues in existing code. I will send separate patches for
whitespace clean-up of NCR5380 drivers.

All NCR5380 drivers have been compile-tested with this patch series:
  arm/cumana_1.c
  arm/oak.c
  atari_scsi.c
  dmx3191d.c
  dtc.c
  g_NCR5380.c
  g_NCR5380_mmio.c
  mac_scsi.c
  pas16.c
  sun3_scsi.c
  sun3_scsi_vme.c
  t128.c

I've successfully regression tested this patch series using mac_scsi on a 
PowerBook 180. The debugging macros are now usable again.

-- 



Message-Id: <20140318002822.672824275@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:23 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 01/12] scsi/NCR5380: remove unused BOARD_NORMAL and BOARD_NCR53C400
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-BOARD-macros

BOARD_NORMAL is completely unused and BOARD_NCR53C400 is used only by
g_NCR5380 internally. Remove the unused definitions.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/arm/cumana_1.c |    3 ---
 drivers/scsi/arm/oak.c      |    3 ---
 drivers/scsi/mac_scsi.h     |    3 ---
 drivers/scsi/sun3_scsi.h    |    3 ---
 4 files changed, 12 deletions(-)

Index: linux-m68k/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux-m68k.orig/drivers/scsi/arm/cumana_1.c	2014-03-17 23:49:31.000000000 +1100
+++ linux-m68k/drivers/scsi/arm/cumana_1.c	2014-03-18 00:18:20.000000000 +1100
@@ -36,9 +36,6 @@
 	void __iomem *base;		\
 	void __iomem *dma
 
-#define BOARD_NORMAL	0
-#define BOARD_NCR53C400	1
-
 #include "../NCR5380.h"
 
 void cumanascsi_setup(char *str, int *ints)
Index: linux-m68k/drivers/scsi/arm/oak.c
===================================================================
--- linux-m68k.orig/drivers/scsi/arm/oak.c	2014-03-17 23:49:31.000000000 +1100
+++ linux-m68k/drivers/scsi/arm/oak.c	2014-03-18 00:18:20.000000000 +1100
@@ -37,9 +37,6 @@
 #define NCR5380_implementation_fields	\
 	void __iomem *base
 
-#define BOARD_NORMAL	0
-#define BOARD_NCR53C400	1
-
 #include "../NCR5380.h"
 
 #undef START_DMA_INITIATOR_RECEIVE_REG
Index: linux-m68k/drivers/scsi/mac_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.h	2014-03-17 23:49:31.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.h	2014-03-18 00:18:20.000000000 +1100
@@ -75,9 +75,6 @@
 #define NCR5380_show_info macscsi_show_info
 #define NCR5380_write_info macscsi_write_info
 
-#define BOARD_NORMAL	0
-#define BOARD_NCR53C400	1
-
 #endif /* ndef HOSTS_C */
 #endif /* ndef ASM */
 #endif /* MAC_NCR5380_H */
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-17 23:49:31.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:20.000000000 +1100
@@ -108,9 +108,6 @@ static int sun3scsi_release (struct Scsi
 #define NCR5380_dma_read_setup(instance, data, count) sun3scsi_dma_setup(data, count, 0)
 #define NCR5380_dma_residual sun3scsi_dma_residual
 
-#define BOARD_NORMAL	0
-#define BOARD_NCR53C400	1
-
 /* additional registers - mainly DMA control regs */
 /* these start at regbase + 8 -- directly after the NCR regs */
 struct sun3_dma_regs {

Message-Id: <20140318002822.972436118@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:24 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 02/12] scsi/NCR5380: remove redundant HOSTS_C macro tests
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-HOSTS_C-macro

HOSTS_C is always undefined. There is no hosts.c anymore.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/g_NCR5380.h |    3 ---
 drivers/scsi/mac_scsi.h  |    3 ---
 drivers/scsi/pas16.h     |    3 ---
 drivers/scsi/sun3_scsi.h |    3 ---
 drivers/scsi/t128.h      |    3 ---
 5 files changed, 15 deletions(-)

Index: linux-m68k/drivers/scsi/g_NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/g_NCR5380.h	2014-03-17 23:49:30.000000000 +1100
+++ linux-m68k/drivers/scsi/g_NCR5380.h	2014-03-18 00:18:30.000000000 +1100
@@ -58,8 +58,6 @@ static const char* generic_NCR5380_info(
 #define CAN_QUEUE 16
 #endif
 
-#ifndef HOSTS_C
-
 #define __STRVAL(x) #x
 #define STRVAL(x) __STRVAL(x)
 
@@ -131,7 +129,6 @@ static const char* generic_NCR5380_info(
 #define BOARD_NCR53C400A 2
 #define BOARD_DTC3181E	3
 
-#endif /* else def HOSTS_C */
 #endif /* ndef ASM */
 #endif /* GENERIC_NCR5380_H */
 
Index: linux-m68k/drivers/scsi/mac_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.h	2014-03-18 00:18:20.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.h	2014-03-18 00:18:30.000000000 +1100
@@ -51,8 +51,6 @@
 
 #include <scsi/scsicam.h>
 
-#ifndef HOSTS_C
-
 #define NCR5380_implementation_fields \
     int port, ctrl
 
@@ -75,7 +73,6 @@
 #define NCR5380_show_info macscsi_show_info
 #define NCR5380_write_info macscsi_write_info
 
-#endif /* ndef HOSTS_C */
 #endif /* ndef ASM */
 #endif /* MAC_NCR5380_H */
 
Index: linux-m68k/drivers/scsi/pas16.h
===================================================================
--- linux-m68k.orig/drivers/scsi/pas16.h	2014-03-17 23:49:30.000000000 +1100
+++ linux-m68k/drivers/scsi/pas16.h	2014-03-18 00:18:30.000000000 +1100
@@ -129,8 +129,6 @@ static int pas16_bus_reset(Scsi_Cmnd *);
 #define CAN_QUEUE 32 
 #endif
 
-#ifndef HOSTS_C
-
 #define NCR5380_implementation_fields \
     volatile unsigned short io_port
 
@@ -171,6 +169,5 @@ static int pas16_bus_reset(Scsi_Cmnd *);
    
 #define PAS16_IRQS 0xd4a8 
 
-#endif /* else def HOSTS_C */
 #endif /* ndef ASM */
 #endif /* PAS16_H */
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:20.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:30.000000000 +1100
@@ -82,8 +82,6 @@ static int sun3scsi_release (struct Scsi
 #define SUN3_SCSI_NAME "Sun3 NCR5380 SCSI"
 #endif
 
-#ifndef HOSTS_C
-
 #define NCR5380_implementation_fields \
     int port, ctrl
 
@@ -371,6 +369,5 @@ struct sun3_udc_regs {
 
 
 
-#endif /* ndef HOSTS_C */
 #endif /* SUN3_NCR5380_H */
 
Index: linux-m68k/drivers/scsi/t128.h
===================================================================
--- linux-m68k.orig/drivers/scsi/t128.h	2014-03-17 23:49:30.000000000 +1100
+++ linux-m68k/drivers/scsi/t128.h	2014-03-18 00:18:30.000000000 +1100
@@ -107,8 +107,6 @@ static int t128_bus_reset(struct scsi_cm
 #define CAN_QUEUE 32
 #endif
 
-#ifndef HOSTS_C
-
 #define NCR5380_implementation_fields \
     void __iomem *base
 
@@ -148,6 +146,5 @@ static int t128_bus_reset(struct scsi_cm
 
 #define T128_IRQS 0xc4a8
 
-#endif /* else def HOSTS_C */
 #endif /* ndef ASM */
 #endif /* T128_H */

Message-Id: <20140318002823.262441572@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:25 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 03/12] scsi/NCR5380: remove old CVS keywords
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-remove-cvs-keywords

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c   |    2 --
 drivers/scsi/NCR5380.h   |    4 ----
 drivers/scsi/g_NCR5380.c |    4 ----
 drivers/scsi/g_NCR5380.h |    4 ----
 drivers/scsi/mac_scsi.c  |    4 ----
 drivers/scsi/mac_scsi.h  |    4 ----
 drivers/scsi/sun3_scsi.c |    4 ----
 drivers/scsi/sun3_scsi.h |    4 ----
 drivers/scsi/t128.c      |    4 ----
 drivers/scsi/t128.h      |    4 ----
 10 files changed, 38 deletions(-)

Index: linux-m68k/drivers/scsi/NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.c	2014-03-18 00:18:32.000000000 +1100
@@ -27,8 +27,6 @@
  */
 
 /*
- * $Log: NCR5380.c,v $
-
  * Revision 1.10 1998/9/2	Alan Cox
  *				(alan@lxorguk.ukuu.org.uk)
  * Fixed up the timer lockups reported so far. Things still suck. Looking 
Index: linux-m68k/drivers/scsi/NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.h	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.h	2014-03-18 00:18:32.000000000 +1100
@@ -21,10 +21,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: NCR5380.h,v $
- */
-
 #ifndef NCR5380_H
 #define NCR5380_H
 
Index: linux-m68k/drivers/scsi/g_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/g_NCR5380.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/g_NCR5380.c	2014-03-18 00:18:32.000000000 +1100
@@ -78,10 +78,6 @@
  *     
  */
 
-/*
- * $Log: generic_NCR5380.c,v $
- */
-
 /* settings for DTC3181E card with only Mustek scanner attached */
 #define USLEEP
 #define USLEEP_POLL	1
Index: linux-m68k/drivers/scsi/g_NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/g_NCR5380.h	2014-03-18 00:18:30.000000000 +1100
+++ linux-m68k/drivers/scsi/g_NCR5380.h	2014-03-18 00:18:32.000000000 +1100
@@ -25,10 +25,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: generic_NCR5380.h,v $
- */
-
 #ifndef GENERIC_NCR5380_H
 #define GENERIC_NCR5380_H
 
Index: linux-m68k/drivers/scsi/mac_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.c	2014-03-18 00:18:32.000000000 +1100
@@ -25,10 +25,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: mac_NCR5380.c,v $
- */
-
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/ctype.h>
Index: linux-m68k/drivers/scsi/mac_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.h	2014-03-18 00:18:30.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.h	2014-03-18 00:18:32.000000000 +1100
@@ -22,10 +22,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: cumana_NCR5380.h,v $
- */
-
 #ifndef MAC_NCR5380_H
 #define MAC_NCR5380_H
 
Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:32.000000000 +1100
@@ -45,10 +45,6 @@
  * USLEEP - enable support for devices that don't disconnect.  Untested.
  */
 
-/*
- * $Log: sun3_NCR5380.c,v $
- */
-
 #define AUTOSENSE
 
 #include <linux/types.h>
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:30.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:32.000000000 +1100
@@ -29,10 +29,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: cumana_NCR5380.h,v $
- */
-
 #ifndef SUN3_NCR5380_H
 #define SUN3_NCR5380_H
 
Index: linux-m68k/drivers/scsi/t128.c
===================================================================
--- linux-m68k.orig/drivers/scsi/t128.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/t128.c	2014-03-18 00:18:32.000000000 +1100
@@ -102,10 +102,6 @@
  * 15 9-11
  */
  
-/*
- * $Log: t128.c,v $
- */
-
 #include <linux/signal.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
Index: linux-m68k/drivers/scsi/t128.h
===================================================================
--- linux-m68k.orig/drivers/scsi/t128.h	2014-03-18 00:18:30.000000000 +1100
+++ linux-m68k/drivers/scsi/t128.h	2014-03-18 00:18:32.000000000 +1100
@@ -34,10 +34,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: t128.h,v $
- */
-
 #ifndef T128_H
 #define T128_H
 

Message-Id: <20140318002823.552448493@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:26 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 04/12] scsi/NCR5380: use NCR5380_dprint() instead of NCR5380_print()
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-debug-macros-sun3-NCR5380_print

Only the NCR5380_dprint() macro should invoke the NCR5380_print() function.
That's why NCR5380.c only defines the function #if NDEBUG. Use the standard
macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/sun3_scsi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:32.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:33.000000000 +1100
@@ -79,8 +79,6 @@
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
 
-static void NCR5380_print(struct Scsi_Host *instance);
-
 /* #define OLDDMA */
 
 #define USE_WRAPPER
@@ -463,7 +461,7 @@ static unsigned long sun3scsi_dma_setup(
 		printk("scsi%d: fifo_mismatch %04x not %04x\n",
 		       default_instance->host_no, dregs->fifo_count,
 		       (unsigned int) count);
-		NCR5380_print(default_instance);
+		NCR5380_dprint(NDEBUG_DMA, default_instance);
 	}
 
 	/* setup udc */

Message-Id: <20140318002823.852457174@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:27 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 05/12] scsi/NCR5380: fix build failures when debugging is enabled
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-debug-macros-build-failures

The change from cmd->target to cmd->device->id was apparently the purpose of
commit a7f251228390e87d86c5e3846f99a455517fdd8e in
kernel/git/tglx/history.git but some instances have been missed.

Also fix the "NDEBUG_LAST_WRITE_SENT" and "NDEBUG_ALL" typo's.

Also fix some format strings (%ul becomes %lu) that caused compiler warnings.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c      |   14 +++++++-------
 drivers/scsi/sun3_NCR5380.c |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-m68k/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_NCR5380.c	2014-03-17 23:49:27.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:34.000000000 +1100
@@ -1049,7 +1049,7 @@ static void NCR5380_main (struct work_st
 		     */
 		    MAIN_PRINTK("scsi%d: main(): command for target %d "
 				"lun %d removed from issue_queue\n",
-				HOSTNO, tmp->target, tmp->lun);
+				HOSTNO, tmp->device->id, tmp->device->lun);
 		    /* 
 		     * REQUEST SENSE commands are issued without tagged
 		     * queueing, even on SCSI-II devices because the 
@@ -2587,7 +2587,7 @@ static void NCR5380_reselect (struct Scs
     
     hostdata->connected = tmp;
     RSL_PRINTK("scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
-	       HOSTNO, tmp->target, tmp->lun, tmp->tag);
+	       HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
 }
 
 
Index: linux-m68k/drivers/scsi/NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.c	2014-03-18 00:18:32.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.c	2014-03-18 00:18:34.000000000 +1100
@@ -1046,7 +1046,7 @@ static void NCR5380_main(struct work_str
 			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
 			{
 				if (prev != tmp)
-					dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->target, hostdata->busy[tmp->target], tmp->lun));
+					dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun));
 				/*  When we find one, remove it from the issue queue. */
 				if (!(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))) {
 					if (prev) {
@@ -1064,7 +1064,7 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying. 
 					 */
-					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, ("scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->target, tmp->lun));
+					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, ("scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun));
 	
 					/*
 					 * A successful selection is defined as one that 
@@ -2028,7 +2028,7 @@ static int NCR5380_transfer_dma(struct S
 					hostdata->flags &= ~FLAG_CHECK_LAST_BYTE_SENT;
 					if (NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT) {
 						hostdata->flags |= FLAG_HAS_LAST_BYTE_SENT;
-						dprintk(NDEBUG_LAST_WRITE_SENT, ("scsi%d : last bit sent works\n", instance->host_no));
+						dprintk(NDEBUG_LAST_BYTE_SENT, ("scsi%d : last byte sent works\n", instance->host_no));
 					}
 				}
 			} else {
@@ -2454,7 +2454,7 @@ static void NCR5380_information_transfer
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (!cmd->device->disconnect && should_disconnect(cmd->cmnd[0])) {
 					NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-					dprintk(NDEBUG_USLEEP, ("scsi%d : issued command, sleeping until %ul\n", instance->host_no, hostdata->time_expires));
+					dprintk(NDEBUG_USLEEP, ("scsi%d : issued command, sleeping until %lu\n", instance->host_no, hostdata->time_expires));
 					return;
 				}
 				break;
@@ -2466,7 +2466,7 @@ static void NCR5380_information_transfer
 				break;
 			default:
 				printk("scsi%d : unknown phase\n", instance->host_no);
-				NCR5380_dprint(NDEBUG_ALL, instance);
+				NCR5380_dprint(NDEBUG_ANY, instance);
 			}	/* switch(phase) */
 		}		/* if (tmp * SR_REQ) */
 		else {
@@ -2474,7 +2474,7 @@ static void NCR5380_information_transfer
 			 */
 			if (!cmd->device->disconnect && time_after_eq(jiffies, poll_time)) {
 				NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-				dprintk(NDEBUG_USLEEP, ("scsi%d : poll timed out, sleeping until %ul\n", instance->host_no, hostdata->time_expires));
+				dprintk(NDEBUG_USLEEP, ("scsi%d : poll timed out, sleeping until %lu\n", instance->host_no, hostdata->time_expires));
 				return;
 			}
 		}
@@ -2595,7 +2595,7 @@ static void NCR5380_reselect(struct Scsi
 		do_abort(instance);
 	} else {
 		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, ("scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->target, tmp->lun, tmp->tag));
+		dprintk(NDEBUG_RESELECTION, ("scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag));
 	}
 }
 

Message-Id: <20140318002824.142437764@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:28 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 06/12] scsi/NCR5380: fix dprintk macro usage and definition
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-debug-macros-dprintk-params

There are three implementations of the core NCR5380 driver and three sets
of debugging macro definitions. And all three implementations use the
NCR5380.h header as well.

Two of the definitions of the dprintk macro accept a variable argument list
whereas the third does not. Standardize on the variable argument list.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |  126 ++++++++++++++++++++++++-------------------------
 drivers/scsi/NCR5380.h |    6 +-
 2 files changed, 66 insertions(+), 66 deletions(-)

Index: linux-m68k/drivers/scsi/NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.c	2014-03-18 00:18:34.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.c	2014-03-18 00:18:34.000000000 +1100
@@ -1003,7 +1003,7 @@ static int NCR5380_queue_command_lck(Scs
 		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
-	dprintk(NDEBUG_QUEUES, ("scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail"));
+	dprintk(NDEBUG_QUEUES, "scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
 	/* Run the coroutine if it isn't already running. */
 	/* Kick off command processing */
@@ -1038,7 +1038,7 @@ static void NCR5380_main(struct work_str
 		/* Lock held here */
 		done = 1;
 		if (!hostdata->connected && !hostdata->selecting) {
-			dprintk(NDEBUG_MAIN, ("scsi%d : not connected\n", instance->host_no));
+			dprintk(NDEBUG_MAIN, "scsi%d : not connected\n", instance->host_no);
 			/*
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
@@ -1046,7 +1046,7 @@ static void NCR5380_main(struct work_str
 			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
 			{
 				if (prev != tmp)
-					dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun));
+					dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
 				/*  When we find one, remove it from the issue queue. */
 				if (!(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))) {
 					if (prev) {
@@ -1064,7 +1064,7 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying. 
 					 */
-					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, ("scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun));
+					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun);
 	
 					/*
 					 * A successful selection is defined as one that 
@@ -1093,7 +1093,7 @@ static void NCR5380_main(struct work_str
 						tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 						hostdata->issue_queue = tmp;
 						done = 0;
-						dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, ("scsi%d : main(): select() failed, returned to issue_queue\n", instance->host_no));
+						dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main(): select() failed, returned to issue_queue\n", instance->host_no);
 					}
 					/* lock held here still */
 				}	/* if target/lun is not busy */
@@ -1123,9 +1123,9 @@ static void NCR5380_main(struct work_str
 #endif
 		    && (!hostdata->time_expires || time_before_eq(hostdata->time_expires, jiffies))
 		    ) {
-			dprintk(NDEBUG_MAIN, ("scsi%d : main() : performing information transfer\n", instance->host_no));
+			dprintk(NDEBUG_MAIN, "scsi%d : main() : performing information transfer\n", instance->host_no);
 			NCR5380_information_transfer(instance);
-			dprintk(NDEBUG_MAIN, ("scsi%d : main() : done set false\n", instance->host_no));
+			dprintk(NDEBUG_MAIN, "scsi%d : main() : done set false\n", instance->host_no);
 			done = 0;
 		} else
 			break;
@@ -1157,8 +1157,8 @@ static irqreturn_t NCR5380_intr(int dumm
 	unsigned char basr;
 	unsigned long flags;
 
-	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n",
-		instance->irq));
+	dprintk(NDEBUG_INTR, "scsi : NCR5380 irq %d triggered\n",
+		instance->irq);
 
 	do {
 		done = 1;
@@ -1171,14 +1171,14 @@ static irqreturn_t NCR5380_intr(int dumm
 			NCR5380_dprint(NDEBUG_INTR, instance);
 			if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
 				done = 0;
-				dprintk(NDEBUG_INTR, ("scsi%d : SEL interrupt\n", instance->host_no));
+				dprintk(NDEBUG_INTR, "scsi%d : SEL interrupt\n", instance->host_no);
 				NCR5380_reselect(instance);
 				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 			} else if (basr & BASR_PARITY_ERROR) {
-				dprintk(NDEBUG_INTR, ("scsi%d : PARITY interrupt\n", instance->host_no));
+				dprintk(NDEBUG_INTR, "scsi%d : PARITY interrupt\n", instance->host_no);
 				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 			} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-				dprintk(NDEBUG_INTR, ("scsi%d : RESET interrupt\n", instance->host_no));
+				dprintk(NDEBUG_INTR, "scsi%d : RESET interrupt\n", instance->host_no);
 				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 			} else {
 #if defined(REAL_DMA)
@@ -1208,7 +1208,7 @@ static irqreturn_t NCR5380_intr(int dumm
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 				}
 #else
-				dprintk(NDEBUG_INTR, ("scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG)));
+				dprintk(NDEBUG_INTR, "scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
 				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 #endif
 			}
@@ -1302,7 +1302,7 @@ static int NCR5380_select(struct Scsi_Ho
 	hostdata->restart_select = 0;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-	dprintk(NDEBUG_ARBITRATION, ("scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id));
+	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id);
 
 	/* 
 	 * Set the phase bits to 0, otherwise the NCR5380 won't drive the 
@@ -1331,7 +1331,7 @@ static int NCR5380_select(struct Scsi_Ho
 		goto failed;
 	}
 
-	dprintk(NDEBUG_ARBITRATION, ("scsi%d : arbitration complete\n", instance->host_no));
+	dprintk(NDEBUG_ARBITRATION, "scsi%d : arbitration complete\n", instance->host_no);
 
 	/* 
 	 * The arbitration delay is 2.2us, but this is a minimum and there is 
@@ -1345,7 +1345,7 @@ static int NCR5380_select(struct Scsi_Ho
 	/* Check for lost arbitration */
 	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) || (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) || (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
-		dprintk(NDEBUG_ARBITRATION, ("scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no));
+		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no);
 		goto failed;
 	}
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_SEL);
@@ -1358,7 +1358,7 @@ static int NCR5380_select(struct Scsi_Ho
 	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		dprintk(NDEBUG_ARBITRATION, ("scsi%d : lost arbitration, deasserting ICR_ASSERT_SEL\n", instance->host_no));
+		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting ICR_ASSERT_SEL\n", instance->host_no);
 		goto failed;
 	}
 	/* 
@@ -1368,7 +1368,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	udelay(2);
 
-	dprintk(NDEBUG_ARBITRATION, ("scsi%d : won arbitration\n", instance->host_no));
+	dprintk(NDEBUG_ARBITRATION, "scsi%d : won arbitration\n", instance->host_no);
 
 	/* 
 	 * Now that we have won arbitration, start Selection process, asserting 
@@ -1420,7 +1420,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	udelay(1);
 
-	dprintk(NDEBUG_SELECTION, ("scsi%d : selecting target %d\n", instance->host_no, scmd_id(cmd)));
+	dprintk(NDEBUG_SELECTION, "scsi%d : selecting target %d\n", instance->host_no, scmd_id(cmd));
 
 	/* 
 	 * The SCSI specification calls for a 250 ms timeout for the actual 
@@ -1485,7 +1485,7 @@ part2:
 		collect_stats(hostdata, cmd);
 		cmd->scsi_done(cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		dprintk(NDEBUG_SELECTION, ("scsi%d : target did not respond within 250ms\n", instance->host_no));
+		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 250ms\n", instance->host_no);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return 0;
 	}
@@ -1518,7 +1518,7 @@ part2:
 		goto failed;
 	}
 
-	dprintk(NDEBUG_SELECTION, ("scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id));
+	dprintk(NDEBUG_SELECTION, "scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id);
 	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
 
 	len = 1;
@@ -1528,7 +1528,7 @@ part2:
 	data = tmp;
 	phase = PHASE_MSGOUT;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
-	dprintk(NDEBUG_SELECTION, ("scsi%d : nexus established.\n", instance->host_no));
+	dprintk(NDEBUG_SELECTION, "scsi%d : nexus established.\n", instance->host_no);
 	/* XXX need to handle errors here */
 	hostdata->connected = cmd;
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
@@ -1581,9 +1581,9 @@ static int NCR5380_transfer_pio(struct S
 	NCR5380_setup(instance);
 
 	if (!(p & SR_IO))
-		dprintk(NDEBUG_PIO, ("scsi%d : pio write %d bytes\n", instance->host_no, c));
+		dprintk(NDEBUG_PIO, "scsi%d : pio write %d bytes\n", instance->host_no, c);
 	else
-		dprintk(NDEBUG_PIO, ("scsi%d : pio read %d bytes\n", instance->host_no, c));
+		dprintk(NDEBUG_PIO, "scsi%d : pio read %d bytes\n", instance->host_no, c);
 
 	/* 
 	 * The NCR5380 chip will only drive the SCSI bus when the 
@@ -1618,11 +1618,11 @@ static int NCR5380_transfer_pio(struct S
 			break;
 		}
 
-		dprintk(NDEBUG_HANDSHAKE, ("scsi%d : REQ detected\n", instance->host_no));
+		dprintk(NDEBUG_HANDSHAKE, "scsi%d : REQ detected\n", instance->host_no);
 
 		/* Check for phase mismatch */
 		if ((tmp & PHASE_MASK) != p) {
-			dprintk(NDEBUG_HANDSHAKE, ("scsi%d : phase mismatch\n", instance->host_no));
+			dprintk(NDEBUG_HANDSHAKE, "scsi%d : phase mismatch\n", instance->host_no);
 			NCR5380_dprint_phase(NDEBUG_HANDSHAKE, instance);
 			break;
 		}
@@ -1658,7 +1658,7 @@ static int NCR5380_transfer_pio(struct S
 
 		/* FIXME - if this fails bus reset ?? */
 		NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 5*HZ);
-		dprintk(NDEBUG_HANDSHAKE, ("scsi%d : req false, handshake complete\n", instance->host_no));
+		dprintk(NDEBUG_HANDSHAKE, "scsi%d : req false, handshake complete\n", instance->host_no);
 
 /*
  * We have several special cases to consider during REQ/ACK handshaking : 
@@ -1679,7 +1679,7 @@ static int NCR5380_transfer_pio(struct S
 		}
 	} while (--c);
 
-	dprintk(NDEBUG_PIO, ("scsi%d : residual %d\n", instance->host_no, c));
+	dprintk(NDEBUG_PIO, "scsi%d : residual %d\n", instance->host_no, c);
 
 	*count = c;
 	*data = d;
@@ -1826,7 +1826,7 @@ static int NCR5380_transfer_dma(struct S
 		c -= 2;
 	}
 #endif
-	dprintk(NDEBUG_DMA, ("scsi%d : initializing DMA channel %d for %s, %d bytes %s %0x\n", instance->host_no, instance->dma_channel, (p & SR_IO) ? "reading" : "writing", c, (p & SR_IO) ? "to" : "from", (unsigned) d));
+	dprintk(NDEBUG_DMA, "scsi%d : initializing DMA channel %d for %s, %d bytes %s %0x\n", instance->host_no, instance->dma_channel, (p & SR_IO) ? "reading" : "writing", c, (p & SR_IO) ? "to" : "from", (unsigned) d);
 	hostdata->dma_len = (p & SR_IO) ? NCR5380_dma_read_setup(instance, d, c) : NCR5380_dma_write_setup(instance, d, c);
 #endif
 
@@ -1855,7 +1855,7 @@ static int NCR5380_transfer_dma(struct S
 		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE);
 #endif				/* def REAL_DMA */
 
-	dprintk(NDEBUG_DMA, ("scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG)));
+	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
 
 	/* 
 	 *	On the PAS16 at least I/O recovery delays are not needed here.
@@ -1932,7 +1932,7 @@ static int NCR5380_transfer_dma(struct S
 		}
 	}
 
-	dprintk(NDEBUG_DMA, ("scsi%d : polled DMA transfer complete, basr 0x%X, sr 0x%X\n", instance->host_no, tmp, NCR5380_read(STATUS_REG)));
+	dprintk(NDEBUG_DMA, "scsi%d : polled DMA transfer complete, basr 0x%X, sr 0x%X\n", instance->host_no, tmp, NCR5380_read(STATUS_REG));
 
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -1946,7 +1946,7 @@ static int NCR5380_transfer_dma(struct S
 #ifdef READ_OVERRUNS
 	if (*phase == p && (p & SR_IO) && residue == 0) {
 		if (overrun) {
-			dprintk(NDEBUG_DMA, ("Got an input overrun, using saved byte\n"));
+			dprintk(NDEBUG_DMA, "Got an input overrun, using saved byte\n");
 			**data = saved_data;
 			*data += 1;
 			*count -= 1;
@@ -1955,13 +1955,13 @@ static int NCR5380_transfer_dma(struct S
 			printk("No overrun??\n");
 			cnt = toPIO = 2;
 		}
-		dprintk(NDEBUG_DMA, ("Doing %d-byte PIO to 0x%X\n", cnt, *data));
+		dprintk(NDEBUG_DMA, "Doing %d-byte PIO to 0x%X\n", cnt, *data);
 		NCR5380_transfer_pio(instance, phase, &cnt, data);
 		*count -= toPIO - cnt;
 	}
 #endif
 
-	dprintk(NDEBUG_DMA, ("Return with data ptr = 0x%X, count %d, last 0x%X, next 0x%X\n", *data, *count, *(*data + *count - 1), *(*data + *count)));
+	dprintk(NDEBUG_DMA, "Return with data ptr = 0x%X, count %d, last 0x%X, next 0x%X\n", *data, *count, *(*data + *count - 1), *(*data + *count));
 	return 0;
 
 #elif defined(REAL_DMA)
@@ -2011,7 +2011,7 @@ static int NCR5380_transfer_dma(struct S
 		foo = NCR5380_pwrite(instance, d, c);
 #else
 		int timeout;
-		dprintk(NDEBUG_C400_PWRITE, ("About to pwrite %d bytes\n", c));
+		dprintk(NDEBUG_C400_PWRITE, "About to pwrite %d bytes\n", c);
 		if (!(foo = NCR5380_pwrite(instance, d, c))) {
 			/*
 			 * Wait for the last byte to be sent.  If REQ is being asserted for 
@@ -2022,19 +2022,19 @@ static int NCR5380_transfer_dma(struct S
 				while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) && (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH));
 
 				if (!timeout)
-					dprintk(NDEBUG_LAST_BYTE_SENT, ("scsi%d : timed out on last byte\n", instance->host_no));
+					dprintk(NDEBUG_LAST_BYTE_SENT, "scsi%d : timed out on last byte\n", instance->host_no);
 
 				if (hostdata->flags & FLAG_CHECK_LAST_BYTE_SENT) {
 					hostdata->flags &= ~FLAG_CHECK_LAST_BYTE_SENT;
 					if (NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT) {
 						hostdata->flags |= FLAG_HAS_LAST_BYTE_SENT;
-						dprintk(NDEBUG_LAST_BYTE_SENT, ("scsi%d : last byte sent works\n", instance->host_no));
+						dprintk(NDEBUG_LAST_BYTE_SENT, "scsi%d : last byte sent works\n", instance->host_no);
 					}
 				}
 			} else {
-				dprintk(NDEBUG_C400_PWRITE, ("Waiting for LASTBYTE\n"));
+				dprintk(NDEBUG_C400_PWRITE, "Waiting for LASTBYTE\n");
 				while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT));
-				dprintk(NDEBUG_C400_PWRITE, ("Got LASTBYTE\n"));
+				dprintk(NDEBUG_C400_PWRITE, "Got LASTBYTE\n");
 			}
 		}
 #endif
@@ -2043,9 +2043,9 @@ static int NCR5380_transfer_dma(struct S
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	if ((!(p & SR_IO)) && (hostdata->flags & FLAG_NCR53C400)) {
-		dprintk(NDEBUG_C400_PWRITE, ("53C400w: Checking for IRQ\n"));
+		dprintk(NDEBUG_C400_PWRITE, "53C400w: Checking for IRQ\n");
 		if (NCR5380_read(BUS_AND_STATUS_REG) & BASR_IRQ) {
-			dprintk(NDEBUG_C400_PWRITE, ("53C400w:    got it, reading reset interrupt reg\n"));
+			dprintk(NDEBUG_C400_PWRITE, "53C400w:    got it, reading reset interrupt reg\n");
 			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		} else {
 			printk("53C400w:    IRQ NOT THERE!\n");
@@ -2137,7 +2137,7 @@ static void NCR5380_information_transfer
 					--cmd->SCp.buffers_residual;
 					cmd->SCp.this_residual = cmd->SCp.buffer->length;
 					cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
-					dprintk(NDEBUG_INFORMATION, ("scsi%d : %d bytes and %d buffers left\n", instance->host_no, cmd->SCp.this_residual, cmd->SCp.buffers_residual));
+					dprintk(NDEBUG_INFORMATION, "scsi%d : %d bytes and %d buffers left\n", instance->host_no, cmd->SCp.this_residual, cmd->SCp.buffers_residual);
 				}
 				/*
 				 * The preferred transfer method is going to be 
@@ -2217,7 +2217,7 @@ static void NCR5380_information_transfer
 				case LINKED_FLG_CMD_COMPLETE:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					/* 
 					 * Sanity check : A linked command should only terminate with
 					 * one of these messages if there are more linked commands
@@ -2233,7 +2233,7 @@ static void NCR5380_information_transfer
 					/* The next command is still part of this process */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, ("scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %d linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					collect_stats(hostdata, cmd);
 					cmd->scsi_done(cmd);
 					cmd = hostdata->connected;
@@ -2245,7 +2245,7 @@ static void NCR5380_information_transfer
 					sink = 1;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					hostdata->connected = NULL;
-					dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d, lun %d completed\n", instance->host_no, cmd->device->id, cmd->device->lun));
+					dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d, lun %d completed\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 
 					/* 
@@ -2279,13 +2279,13 @@ static void NCR5380_information_transfer
 					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						dprintk(NDEBUG_AUTOSENSE, ("scsi%d : performing request sense\n", instance->host_no));
+						dprintk(NDEBUG_AUTOSENSE, "scsi%d : performing request sense\n", instance->host_no);
 
 						LIST(cmd, hostdata->issue_queue);
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->issue_queue;
 						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
-						dprintk(NDEBUG_QUEUES, ("scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no));
+						dprintk(NDEBUG_QUEUES, "scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no);
 					} else
 #endif				/* def AUTOSENSE */
 					{
@@ -2325,7 +2325,7 @@ static void NCR5380_information_transfer
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
-						dprintk(NDEBUG_QUEUES, ("scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun));
+						dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d lun %d was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun);
 						/* 
 						 * Restore phase bits to 0 so an interrupted selection, 
 						 * arbitration can resume.
@@ -2371,14 +2371,14 @@ static void NCR5380_information_transfer
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_EXTENDED, ("scsi%d : receiving extended message\n", instance->host_no));
+					dprintk(NDEBUG_EXTENDED, "scsi%d : receiving extended message\n", instance->host_no);
 
 					len = 2;
 					data = extended_msg + 1;
 					phase = PHASE_MSGIN;
 					NCR5380_transfer_pio(instance, &phase, &len, &data);
 
-					dprintk(NDEBUG_EXTENDED, ("scsi%d : length=%d, code=0x%02x\n", instance->host_no, (int) extended_msg[1], (int) extended_msg[2]));
+					dprintk(NDEBUG_EXTENDED, "scsi%d : length=%d, code=0x%02x\n", instance->host_no, (int) extended_msg[1], (int) extended_msg[2]);
 
 					if (!len && extended_msg[1] <= (sizeof(extended_msg) - 1)) {
 						/* Accept third byte by clearing ACK */
@@ -2388,7 +2388,7 @@ static void NCR5380_information_transfer
 						phase = PHASE_MSGIN;
 
 						NCR5380_transfer_pio(instance, &phase, &len, &data);
-						dprintk(NDEBUG_EXTENDED, ("scsi%d : message received, residual %d\n", instance->host_no, len));
+						dprintk(NDEBUG_EXTENDED, "scsi%d : message received, residual %d\n", instance->host_no, len);
 
 						switch (extended_msg[2]) {
 						case EXTENDED_SDTR:
@@ -2454,7 +2454,7 @@ static void NCR5380_information_transfer
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (!cmd->device->disconnect && should_disconnect(cmd->cmnd[0])) {
 					NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-					dprintk(NDEBUG_USLEEP, ("scsi%d : issued command, sleeping until %lu\n", instance->host_no, hostdata->time_expires));
+					dprintk(NDEBUG_USLEEP, "scsi%d : issued command, sleeping until %lu\n", instance->host_no, hostdata->time_expires);
 					return;
 				}
 				break;
@@ -2474,7 +2474,7 @@ static void NCR5380_information_transfer
 			 */
 			if (!cmd->device->disconnect && time_after_eq(jiffies, poll_time)) {
 				NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-				dprintk(NDEBUG_USLEEP, ("scsi%d : poll timed out, sleeping until %lu\n", instance->host_no, hostdata->time_expires));
+				dprintk(NDEBUG_USLEEP, "scsi%d : poll timed out, sleeping until %lu\n", instance->host_no, hostdata->time_expires);
 				return;
 			}
 		}
@@ -2515,7 +2515,7 @@ static void NCR5380_reselect(struct Scsi
 	hostdata->restart_select = 1;
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
-	dprintk(NDEBUG_SELECTION, ("scsi%d : reselect\n", instance->host_no));
+	dprintk(NDEBUG_SELECTION, "scsi%d : reselect\n", instance->host_no);
 
 	/* 
 	 * At this point, we have detected that our SCSI ID is on the bus,
@@ -2595,7 +2595,7 @@ static void NCR5380_reselect(struct Scsi
 		do_abort(instance);
 	} else {
 		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, ("scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag));
+		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag);
 	}
 }
 
@@ -2680,8 +2680,8 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
 
 	NCR5380_setup(instance);
 
-	dprintk(NDEBUG_ABORT, ("scsi%d : abort called\n", instance->host_no));
-	dprintk(NDEBUG_ABORT, ("        basr 0x%X, sr 0x%X\n", NCR5380_read(BUS_AND_STATUS_REG), NCR5380_read(STATUS_REG)));
+	dprintk(NDEBUG_ABORT, "scsi%d : abort called\n", instance->host_no);
+	dprintk(NDEBUG_ABORT, "        basr 0x%X, sr 0x%X\n", NCR5380_read(BUS_AND_STATUS_REG), NCR5380_read(STATUS_REG));
 
 #if 0
 /*
@@ -2691,7 +2691,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  */
 
 	if (hostdata->connected == cmd) {
-		dprintk(NDEBUG_ABORT, ("scsi%d : aborting connected command\n", instance->host_no));
+		dprintk(NDEBUG_ABORT, "scsi%d : aborting connected command\n", instance->host_no);
 		hostdata->aborted = 1;
 /*
  * We should perform BSY checking, and make sure we haven't slipped
@@ -2719,14 +2719,14 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  *          from the issue queue.
  */
  
-	dprintk(NDEBUG_ABORT, ("scsi%d : abort going into loop.\n", instance->host_no));
+	dprintk(NDEBUG_ABORT, "scsi%d : abort going into loop.\n", instance->host_no);
 	for (prev = (Scsi_Cmnd **) & (hostdata->issue_queue), tmp = (Scsi_Cmnd *) hostdata->issue_queue; tmp; prev = (Scsi_Cmnd **) & (tmp->host_scribble), tmp = (Scsi_Cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
 			REMOVE(5, *prev, tmp, tmp->host_scribble);
 			(*prev) = (Scsi_Cmnd *) tmp->host_scribble;
 			tmp->host_scribble = NULL;
 			tmp->result = DID_ABORT << 16;
-			dprintk(NDEBUG_ABORT, ("scsi%d : abort removed command from issue queue.\n", instance->host_no));
+			dprintk(NDEBUG_ABORT, "scsi%d : abort removed command from issue queue.\n", instance->host_no);
 			tmp->scsi_done(tmp);
 			return SUCCESS;
 		}
@@ -2748,7 +2748,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  */
 
 	if (hostdata->connected) {
-		dprintk(NDEBUG_ABORT, ("scsi%d : abort failed, command connected.\n", instance->host_no));
+		dprintk(NDEBUG_ABORT, "scsi%d : abort failed, command connected.\n", instance->host_no);
 		return FAILED;
 	}
 /*
@@ -2778,11 +2778,11 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
 
 	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue; tmp; tmp = (Scsi_Cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
-			dprintk(NDEBUG_ABORT, ("scsi%d : aborting disconnected command.\n", instance->host_no));
+			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
 
 			if (NCR5380_select(instance, cmd, (int) cmd->tag))
 				return FAILED;
-			dprintk(NDEBUG_ABORT, ("scsi%d : nexus reestablished.\n", instance->host_no));
+			dprintk(NDEBUG_ABORT, "scsi%d : nexus reestablished.\n", instance->host_no);
 
 			do_abort(instance);
 
Index: linux-m68k/drivers/scsi/NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.h	2014-03-18 00:18:32.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.h	2014-03-18 00:18:34.000000000 +1100
@@ -288,9 +288,9 @@ struct NCR5380_hostdata {
 
 #ifdef __KERNEL__
 
-#define dprintk(a,b)			do {} while(0)
-#define NCR5380_dprint(a,b)		do {} while(0)
-#define NCR5380_dprint_phase(a,b)	do {} while(0)
+#define dprintk(flg, fmt, args...)     do {} while (0)
+#define NCR5380_dprint(flg, arg)       do {} while (0)
+#define NCR5380_dprint_phase(flg, arg) do {} while (0)
 
 #if defined(AUTOPROBE_IRQ)
 static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);

Message-Id: <20140318002824.442444700@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:29 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 07/12] scsi/NCR5380: adopt NCR5380_dprint() and NCR5380_dprint_phase()
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-debug-macros-substitute-NCRPRINT

All NCR5380 drivers already include the NCR5380.h header. Better to
adopt those macros rather than have three variations on them.

Moreover, the macros in NCR5380.h are preferable anyway: the atari_NCR5380
and sun3_NCR5380 versions are inflexible. For example, they can't accomodate
NCR5380_dprint(NDEBUG_MAIN | NDEBUG_QUEUES, ...)

Replace the NCR_PRINT* macros from atari_NCR5380.h and sun3_NCR5380.h with
the equivalent macros from NCR5380.h.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |   22 +++++++++++-----------
 drivers/scsi/sun3_NCR5380.c  |   22 +++++++++++-----------
 2 files changed, 22 insertions(+), 22 deletions(-)

Index: linux-m68k/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_NCR5380.c	2014-03-17 23:49:25.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_NCR5380.c	2014-03-18 00:18:35.000000000 +1100
@@ -739,8 +739,8 @@ static void NCR5380_print_status(struct
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
 
-	NCR_PRINT(NDEBUG_ANY);
-	NCR_PRINT_PHASE(NDEBUG_ANY);
+	NCR5380_dprint(NDEBUG_ANY, instance);
+	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
@@ -1268,7 +1268,7 @@ static irqreturn_t NCR5380_intr(int irq,
 	INT_PRINTK("scsi%d: BASR=%02x\n", HOSTNO, basr);
 	/* dispatch to appropriate routine if found and done=0 */
 	if (basr & BASR_IRQ) {
-		NCR_PRINT(NDEBUG_INTR);
+		NCR5380_dprint(NDEBUG_INTR, instance);
 		if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 			done = 0;
 			ENABLE_IRQ();
@@ -1396,7 +1396,7 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned long flags;
 
 	hostdata->restart_select = 0;
-	NCR_PRINT(NDEBUG_ARBITRATION);
+	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	ARB_PRINTK("scsi%d: starting arbitration, id = %d\n", HOSTNO,
 		   instance->this_id);
 
@@ -1617,7 +1617,7 @@ static int NCR5380_select(struct Scsi_Ho
 			printk(KERN_ERR "scsi%d: weirdness\n", HOSTNO);
 			if (hostdata->restart_select)
 				printk(KERN_NOTICE "\trestart select\n");
-			NCR_PRINT(NDEBUG_ANY);
+			NCR5380_dprint(NDEBUG_ANY, instance);
 			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 			return -1;
 		}
@@ -1742,7 +1742,7 @@ static int NCR5380_transfer_pio(struct S
 		/* Check for phase mismatch */
 		if ((tmp & PHASE_MASK) != p) {
 			PIO_PRINTK("scsi%d: phase mismatch\n", HOSTNO);
-			NCR_PRINT_PHASE(NDEBUG_PIO);
+			NCR5380_dprint_phase(NDEBUG_PIO, instance);
 			break;
 		}
 
@@ -1764,18 +1764,18 @@ static int NCR5380_transfer_pio(struct S
 		if (!(p & SR_IO)) {
 			if (!((p & SR_MSG) && c > 1)) {
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA);
-				NCR_PRINT(NDEBUG_PIO);
+				NCR5380_dprint(NDEBUG_PIO, instance);
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
 					      ICR_ASSERT_DATA | ICR_ASSERT_ACK);
 			} else {
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
 					      ICR_ASSERT_DATA | ICR_ASSERT_ATN);
-				NCR_PRINT(NDEBUG_PIO);
+				NCR5380_dprint(NDEBUG_PIO, instance);
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
 					      ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 			}
 		} else {
-			NCR_PRINT(NDEBUG_PIO);
+			NCR5380_dprint(NDEBUG_PIO, instance);
 			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
 		}
 
@@ -1997,7 +1997,7 @@ static void NCR5380_information_transfer
 			phase = (tmp & PHASE_MASK);
 			if (phase != old_phase) {
 				old_phase = phase;
-				NCR_PRINT_PHASE(NDEBUG_INFORMATION);
+				NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
 			}
 
 			if (sink && (phase != PHASE_MSGOUT)) {
@@ -2451,7 +2451,7 @@ static void NCR5380_information_transfer
 				break;
 			default:
 				printk("scsi%d: unknown phase\n", HOSTNO);
-				NCR_PRINT(NDEBUG_ANY);
+				NCR5380_dprint(NDEBUG_ANY, instance);
 			} /* switch(phase) */
 		} /* if (tmp * SR_REQ) */
 	} /* while (1) */
Index: linux-m68k/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:34.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:35.000000000 +1100
@@ -681,8 +681,8 @@ static void NCR5380_print_status(struct
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
 
-	NCR_PRINT(NDEBUG_ANY);
-	NCR_PRINT_PHASE(NDEBUG_ANY);
+	NCR5380_dprint(NDEBUG_ANY, instance);
+	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
@@ -1196,7 +1196,7 @@ static irqreturn_t NCR5380_intr (int irq
     INT_PRINTK("scsi%d: BASR=%02x\n", HOSTNO, basr);
     /* dispatch to appropriate routine if found and done=0 */
     if (basr & BASR_IRQ) {
-	NCR_PRINT(NDEBUG_INTR);
+	NCR5380_dprint(NDEBUG_INTR, instance);
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 	    done = 0;
 //	    ENABLE_IRQ();
@@ -1338,7 +1338,7 @@ static int NCR5380_select(struct Scsi_Ho
     unsigned long flags;
 
     hostdata->restart_select = 0;
-    NCR_PRINT(NDEBUG_ARBITRATION);
+    NCR5380_dprint(NDEBUG_ARBITRATION, instance);
     ARB_PRINTK("scsi%d: starting arbitration, id = %d\n", HOSTNO,
 	       instance->this_id);
 
@@ -1559,7 +1559,7 @@ static int NCR5380_select(struct Scsi_Ho
 	    printk(KERN_ERR "scsi%d: weirdness\n", HOSTNO);
 	    if (hostdata->restart_select)
 		printk(KERN_NOTICE "\trestart select\n");
-	    NCR_PRINT(NDEBUG_ANY);
+	    NCR5380_dprint(NDEBUG_ANY, instance);
 	    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 	    return -1;
 	}
@@ -1685,7 +1685,7 @@ static int NCR5380_transfer_pio( struct
 	/* Check for phase mismatch */	
 	if ((tmp & PHASE_MASK) != p) {
 	    PIO_PRINTK("scsi%d: phase mismatch\n", HOSTNO);
-	    NCR_PRINT_PHASE(NDEBUG_PIO);
+	    NCR5380_dprint_phase(NDEBUG_PIO, instance);
 	    break;
 	}
 
@@ -1708,18 +1708,18 @@ static int NCR5380_transfer_pio( struct
 	    if (!((p & SR_MSG) && c > 1)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | 
 		    ICR_ASSERT_DATA);
-		NCR_PRINT(NDEBUG_PIO);
+		NCR5380_dprint(NDEBUG_PIO, instance);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | 
 			ICR_ASSERT_DATA | ICR_ASSERT_ACK);
 	    } else {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
 		    ICR_ASSERT_DATA | ICR_ASSERT_ATN);
-		NCR_PRINT(NDEBUG_PIO);
+		NCR5380_dprint(NDEBUG_PIO, instance);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | 
 		    ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 	    }
 	} else {
-	    NCR_PRINT(NDEBUG_PIO);
+	    NCR5380_dprint(NDEBUG_PIO, instance);
 	    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
 	}
 
@@ -1931,7 +1931,7 @@ static void NCR5380_information_transfer
 	    phase = (tmp & PHASE_MASK); 
  	    if (phase != old_phase) {
 		old_phase = phase;
-		NCR_PRINT_PHASE(NDEBUG_INFORMATION);
+		NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
 	    }
 
 	    if(phase == PHASE_CMDOUT) {
@@ -2416,7 +2416,7 @@ static void NCR5380_information_transfer
 		break;
 	    default:
 		printk("scsi%d: unknown phase\n", HOSTNO);
-		NCR_PRINT(NDEBUG_ANY);
+		NCR5380_dprint(NDEBUG_ANY, instance);
 	    } /* switch(phase) */
 	} /* if (tmp * SR_REQ) */ 
     } /* while (1) */

Message-Id: <20140318002824.732440934@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:30 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 08/12] scsi/NCR5380: adopt dprintk()
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-debug-macros-substitute-X_PRINTK

All NCR5380 drivers already include the NCR5380.h header. Better to
adopt those macros rather than have three variations on them.

Moreover, the macros in NCR5380.h are preferable because the atari_NCR5380
and sun3_NCR5380 versions are inflexible. For example, they can't accomodate
dprintk(NDEBUG_MAIN | NDEBUG_QUEUES, ...)

Replace the *_PRINTK macros from atari_NCR5380.h and sun3_NCR5380.h with
the equivalent macros from NCR5380.h.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |  130 +++++++++++++++++++++----------------------
 drivers/scsi/atari_scsi.c    |   16 ++---
 drivers/scsi/sun3_NCR5380.c  |  122 ++++++++++++++++++++--------------------
 3 files changed, 134 insertions(+), 134 deletions(-)

Index: linux-m68k/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_NCR5380.c	2014-03-18 00:18:35.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_NCR5380.c	2014-03-18 00:18:36.000000000 +1100
@@ -370,7 +370,7 @@ static int is_lun_busy(Scsi_Cmnd *cmd, i
 		return 0;
 	if (TagAlloc[cmd->device->id][cmd->device->lun].nr_allocated >=
 	    TagAlloc[cmd->device->id][cmd->device->lun].queue_size) {
-		TAG_PRINTK("scsi%d: target %d lun %d: no free tags\n",
+		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d: no free tags\n",
 			   H_NO(cmd), cmd->device->id, cmd->device->lun);
 		return 1;
 	}
@@ -394,7 +394,7 @@ static void cmd_get_tag(Scsi_Cmnd *cmd,
 	    !setup_use_tagged_queuing || !cmd->device->tagged_supported) {
 		cmd->tag = TAG_NONE;
 		hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
-		TAG_PRINTK("scsi%d: target %d lun %d now allocated by untagged "
+		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d now allocated by untagged "
 			   "command\n", H_NO(cmd), cmd->device->id, cmd->device->lun);
 	} else {
 		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
@@ -402,7 +402,7 @@ static void cmd_get_tag(Scsi_Cmnd *cmd,
 		cmd->tag = find_first_zero_bit(ta->allocated, MAX_TAGS);
 		set_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated++;
-		TAG_PRINTK("scsi%d: using tag %d for target %d lun %d "
+		dprintk(NDEBUG_TAGS, "scsi%d: using tag %d for target %d lun %d "
 			   "(now %d tags in use)\n",
 			   H_NO(cmd), cmd->tag, cmd->device->id,
 			   cmd->device->lun, ta->nr_allocated);
@@ -420,7 +420,7 @@ static void cmd_free_tag(Scsi_Cmnd *cmd)
 
 	if (cmd->tag == TAG_NONE) {
 		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
-		TAG_PRINTK("scsi%d: target %d lun %d untagged cmd finished\n",
+		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d untagged cmd finished\n",
 			   H_NO(cmd), cmd->device->id, cmd->device->lun);
 	} else if (cmd->tag >= MAX_TAGS) {
 		printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
@@ -429,7 +429,7 @@ static void cmd_free_tag(Scsi_Cmnd *cmd)
 		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
 		clear_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated--;
-		TAG_PRINTK("scsi%d: freed tag %d for target %d lun %d\n",
+		dprintk(NDEBUG_TAGS, "scsi%d: freed tag %d for target %d lun %d\n",
 			   H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun);
 	}
 }
@@ -478,7 +478,7 @@ static void merge_contiguous_buffers(Scs
 	for (endaddr = virt_to_phys(cmd->SCp.ptr + cmd->SCp.this_residual - 1) + 1;
 	     cmd->SCp.buffers_residual &&
 	     virt_to_phys(sg_virt(&cmd->SCp.buffer[1])) == endaddr;) {
-		MER_PRINTK("VTOP(%p) == %08lx -> merging\n",
+		dprintk(NDEBUG_MERGING, "VTOP(%p) == %08lx -> merging\n",
 			   page_address(sg_page(&cmd->SCp.buffer[1])), endaddr);
 #if (NDEBUG & NDEBUG_MERGING)
 		++cnt;
@@ -490,7 +490,7 @@ static void merge_contiguous_buffers(Scs
 	}
 #if (NDEBUG & NDEBUG_MERGING)
 	if (oldlen != cmd->SCp.this_residual)
-		MER_PRINTK("merged %d buffers from %p, new length %08x\n",
+		dprintk(NDEBUG_MERGING, "merged %d buffers from %p, new length %08x\n",
 			   cnt, cmd->SCp.ptr, cmd->SCp.this_residual);
 #endif
 }
@@ -676,7 +676,7 @@ static inline void NCR5380_all_init(void
 {
 	static int done = 0;
 	if (!done) {
-		INI_PRINTK("scsi : NCR5380_all_init()\n");
+		dprintk(NDEBUG_INIT, "scsi : NCR5380_all_init()\n");
 		done = 1;
 	}
 }
@@ -984,7 +984,7 @@ static int NCR5380_queue_command_lck(Scs
 	}
 	local_irq_restore(flags);
 
-	QU_PRINTK("scsi%d: command added to %s of queue\n", H_NO(cmd),
+	dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H_NO(cmd),
 		  (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
 	/* If queue_command() is called from an interrupt (real one or bottom
@@ -1054,7 +1054,7 @@ static void NCR5380_main(struct work_str
 		done = 1;
 
 		if (!hostdata->connected) {
-			MAIN_PRINTK("scsi%d: not connected\n", HOSTNO);
+			dprintk(NDEBUG_MAIN, "scsi%d: not connected\n", HOSTNO);
 			/*
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
@@ -1107,7 +1107,7 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying.
 					 */
-					MAIN_PRINTK("scsi%d: main(): command for target %d "
+					dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
 						    "lun %d removed from issue_queue\n",
 						    HOSTNO, tmp->device->id, tmp->device->lun);
 					/*
@@ -1140,7 +1140,7 @@ static void NCR5380_main(struct work_str
 #endif
 						falcon_dont_release--;
 						local_irq_restore(flags);
-						MAIN_PRINTK("scsi%d: main(): select() failed, "
+						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
 						if (hostdata->connected)
 							break;
@@ -1155,10 +1155,10 @@ static void NCR5380_main(struct work_str
 #endif
 		    ) {
 			local_irq_restore(flags);
-			MAIN_PRINTK("scsi%d: main: performing information transfer\n",
+			dprintk(NDEBUG_MAIN, "scsi%d: main: performing information transfer\n",
 				    HOSTNO);
 			NCR5380_information_transfer(instance);
-			MAIN_PRINTK("scsi%d: main: done set false\n", HOSTNO);
+			dprintk(NDEBUG_MAIN, "scsi%d: main: done set false\n", HOSTNO);
 			done = 0;
 		}
 	} while (!done);
@@ -1204,12 +1204,12 @@ static void NCR5380_dma_complete(struct
 			    (BASR_PHASE_MATCH|BASR_ACK)) {
 				saved_data = NCR5380_read(INPUT_DATA_REG);
 				overrun = 1;
-				DMA_PRINTK("scsi%d: read overrun handled\n", HOSTNO);
+				dprintk(NDEBUG_DMA, "scsi%d: read overrun handled\n", HOSTNO);
 			}
 		}
 	}
 
-	DMA_PRINTK("scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
+	dprintk(NDEBUG_DMA, "scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
 		   HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
 		   NCR5380_read(STATUS_REG));
 
@@ -1229,13 +1229,13 @@ static void NCR5380_dma_complete(struct
 		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) == p && (p & SR_IO)) {
 			cnt = toPIO = atari_read_overruns;
 			if (overrun) {
-				DMA_PRINTK("Got an input overrun, using saved byte\n");
+				dprintk(NDEBUG_DMA, "Got an input overrun, using saved byte\n");
 				*(*data)++ = saved_data;
 				(*count)--;
 				cnt--;
 				toPIO--;
 			}
-			DMA_PRINTK("Doing %d-byte PIO to 0x%08lx\n", cnt, (long)*data);
+			dprintk(NDEBUG_DMA, "Doing %d-byte PIO to 0x%08lx\n", cnt, (long)*data);
 			NCR5380_transfer_pio(instance, &p, &cnt, data);
 			*count -= toPIO - cnt;
 		}
@@ -1261,25 +1261,25 @@ static irqreturn_t NCR5380_intr(int irq,
 	int done = 1, handled = 0;
 	unsigned char basr;
 
-	INT_PRINTK("scsi%d: NCR5380 irq triggered\n", HOSTNO);
+	dprintk(NDEBUG_INTR, "scsi%d: NCR5380 irq triggered\n", HOSTNO);
 
 	/* Look for pending interrupts */
 	basr = NCR5380_read(BUS_AND_STATUS_REG);
-	INT_PRINTK("scsi%d: BASR=%02x\n", HOSTNO, basr);
+	dprintk(NDEBUG_INTR, "scsi%d: BASR=%02x\n", HOSTNO, basr);
 	/* dispatch to appropriate routine if found and done=0 */
 	if (basr & BASR_IRQ) {
 		NCR5380_dprint(NDEBUG_INTR, instance);
 		if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 			done = 0;
 			ENABLE_IRQ();
-			INT_PRINTK("scsi%d: SEL interrupt\n", HOSTNO);
+			dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
 			NCR5380_reselect(instance);
 			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		} else if (basr & BASR_PARITY_ERROR) {
-			INT_PRINTK("scsi%d: PARITY interrupt\n", HOSTNO);
+			dprintk(NDEBUG_INTR, "scsi%d: PARITY interrupt\n", HOSTNO);
 			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-			INT_PRINTK("scsi%d: RESET interrupt\n", HOSTNO);
+			dprintk(NDEBUG_INTR, "scsi%d: RESET interrupt\n", HOSTNO);
 			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		} else {
 			/*
@@ -1298,7 +1298,7 @@ static irqreturn_t NCR5380_intr(int irq,
 			    ((basr & BASR_END_DMA_TRANSFER) ||
 			     !(basr & BASR_PHASE_MATCH))) {
 
-				INT_PRINTK("scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
+				dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
 				NCR5380_dma_complete( instance );
 				done = 0;
 				ENABLE_IRQ();
@@ -1323,7 +1323,7 @@ static irqreturn_t NCR5380_intr(int irq,
 	}
 
 	if (!done) {
-		INT_PRINTK("scsi%d: in int routine, calling main\n", HOSTNO);
+		dprintk(NDEBUG_INTR, "scsi%d: in int routine, calling main\n", HOSTNO);
 		/* Put a call to NCR5380_main() on the queue... */
 		queue_main();
 	}
@@ -1397,7 +1397,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	hostdata->restart_select = 0;
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-	ARB_PRINTK("scsi%d: starting arbitration, id = %d\n", HOSTNO,
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
 		   instance->this_id);
 
 	/*
@@ -1442,7 +1442,7 @@ static int NCR5380_select(struct Scsi_Ho
 		;
 #endif
 
-	ARB_PRINTK("scsi%d: arbitration complete\n", HOSTNO);
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: arbitration complete\n", HOSTNO);
 
 	if (hostdata->connected) {
 		NCR5380_write(MODE_REG, MR_BASE);
@@ -1463,7 +1463,7 @@ static int NCR5380_select(struct Scsi_Ho
 	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
 	    hostdata->connected) {
 		NCR5380_write(MODE_REG, MR_BASE);
-		ARB_PRINTK("scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
+		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
 			   HOSTNO);
 		return -1;
 	}
@@ -1478,7 +1478,7 @@ static int NCR5380_select(struct Scsi_Ho
 	    hostdata->connected) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		ARB_PRINTK("scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
+		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
 			   HOSTNO);
 		return -1;
 	}
@@ -1501,7 +1501,7 @@ static int NCR5380_select(struct Scsi_Ho
 		return -1;
 	}
 
-	ARB_PRINTK("scsi%d: won arbitration\n", HOSTNO);
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: won arbitration\n", HOSTNO);
 
 	/*
 	 * Now that we have won arbitration, start Selection process, asserting
@@ -1561,7 +1561,7 @@ static int NCR5380_select(struct Scsi_Ho
 
 	udelay(1);
 
-	SEL_PRINTK("scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
+	dprintk(NDEBUG_SELECTION, "scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
 
 	/*
 	 * The SCSI specification calls for a 250 ms timeout for the actual
@@ -1630,7 +1630,7 @@ static int NCR5380_select(struct Scsi_Ho
 #endif
 		cmd->scsi_done(cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		SEL_PRINTK("scsi%d: target did not respond within 250ms\n", HOSTNO);
+		dprintk(NDEBUG_SELECTION, "scsi%d: target did not respond within 250ms\n", HOSTNO);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return 0;
 	}
@@ -1656,7 +1656,7 @@ static int NCR5380_select(struct Scsi_Ho
 	while (!(NCR5380_read(STATUS_REG) & SR_REQ))
 		;
 
-	SEL_PRINTK("scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
+	dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
 		   HOSTNO, cmd->device->id);
 	tmp[0] = IDENTIFY(1, cmd->device->lun);
 
@@ -1676,7 +1676,7 @@ static int NCR5380_select(struct Scsi_Ho
 	data = tmp;
 	phase = PHASE_MSGOUT;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
-	SEL_PRINTK("scsi%d: nexus established.\n", HOSTNO);
+	dprintk(NDEBUG_SELECTION, "scsi%d: nexus established.\n", HOSTNO);
 	/* XXX need to handle errors here */
 	hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
@@ -1737,11 +1737,11 @@ static int NCR5380_transfer_pio(struct S
 		while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ))
 			;
 
-		HSH_PRINTK("scsi%d: REQ detected\n", HOSTNO);
+		dprintk(NDEBUG_HANDSHAKE, "scsi%d: REQ detected\n", HOSTNO);
 
 		/* Check for phase mismatch */
 		if ((tmp & PHASE_MASK) != p) {
-			PIO_PRINTK("scsi%d: phase mismatch\n", HOSTNO);
+			dprintk(NDEBUG_PIO, "scsi%d: phase mismatch\n", HOSTNO);
 			NCR5380_dprint_phase(NDEBUG_PIO, instance);
 			break;
 		}
@@ -1782,7 +1782,7 @@ static int NCR5380_transfer_pio(struct S
 		while (NCR5380_read(STATUS_REG) & SR_REQ)
 			;
 
-		HSH_PRINTK("scsi%d: req false, handshake complete\n", HOSTNO);
+		dprintk(NDEBUG_HANDSHAKE, "scsi%d: req false, handshake complete\n", HOSTNO);
 
 		/*
 		 * We have several special cases to consider during REQ/ACK handshaking :
@@ -1803,7 +1803,7 @@ static int NCR5380_transfer_pio(struct S
 		}
 	} while (--c);
 
-	PIO_PRINTK("scsi%d: residual %d\n", HOSTNO, c);
+	dprintk(NDEBUG_PIO, "scsi%d: residual %d\n", HOSTNO, c);
 
 	*count = c;
 	*data = d;
@@ -1917,7 +1917,7 @@ static int NCR5380_transfer_dma(struct S
 	if (atari_read_overruns && (p & SR_IO))
 		c -= atari_read_overruns;
 
-	DMA_PRINTK("scsi%d: initializing DMA for %s, %d bytes %s %p\n",
+	dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %p\n",
 		   HOSTNO, (p & SR_IO) ? "reading" : "writing",
 		   c, (p & SR_IO) ? "to" : "from", d);
 
@@ -2039,7 +2039,7 @@ static void NCR5380_information_transfer
 					 * they are at contiguous physical addresses.
 					 */
 					merge_contiguous_buffers(cmd);
-					INF_PRINTK("scsi%d: %d bytes and %d buffers left\n",
+					dprintk(NDEBUG_INFORMATION, "scsi%d: %d bytes and %d buffers left\n",
 						   HOSTNO, cmd->SCp.this_residual,
 						   cmd->SCp.buffers_residual);
 				}
@@ -2123,7 +2123,7 @@ static void NCR5380_information_transfer
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-					LNK_PRINTK("scsi%d: target %d lun %d linked command "
+					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked command "
 						   "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
 					/* Enable reselect interrupts */
@@ -2148,7 +2148,7 @@ static void NCR5380_information_transfer
 					 * and don't free it! */
 					cmd->next_link->tag = cmd->tag;
 					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					LNK_PRINTK("scsi%d: target %d lun %d linked request "
+					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked request "
 						   "done, calling scsi_done().\n",
 						   HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef NCR5380_STATS
@@ -2165,7 +2165,7 @@ static void NCR5380_information_transfer
 					/* ++guenther: possible race with Falcon locking */
 					falcon_dont_release++;
 					hostdata->connected = NULL;
-					QU_PRINTK("scsi%d: command for target %d, lun %d "
+					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
@@ -2179,7 +2179,7 @@ static void NCR5380_information_transfer
 						/* ++Andreas: the mid level code knows about
 						   QUEUE_FULL now. */
 						TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
-						TAG_PRINTK("scsi%d: target %d lun %d returned "
+						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d returned "
 							   "QUEUE_FULL after %d commands\n",
 							   HOSTNO, cmd->device->id, cmd->device->lun,
 							   ta->nr_allocated);
@@ -2224,14 +2224,14 @@ static void NCR5380_information_transfer
 					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						ASEN_PRINTK("scsi%d: performing request sense\n", HOSTNO);
+						dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n", HOSTNO);
 
 						local_irq_save(flags);
 						LIST(cmd,hostdata->issue_queue);
 						SET_NEXT(cmd, hostdata->issue_queue);
 						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
 						local_irq_restore(flags);
-						QU_PRINTK("scsi%d: REQUEST SENSE added to head of "
+						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 							  "issue queue\n", H_NO(cmd));
 					} else
 #endif /* def AUTOSENSE */
@@ -2277,7 +2277,7 @@ static void NCR5380_information_transfer
 						cmd->device->tagged_supported = 0;
 						hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 						cmd->tag = TAG_NONE;
-						TAG_PRINTK("scsi%d: target %d lun %d rejected "
+						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d rejected "
 							   "QUEUE_TAG message; tagged queuing "
 							   "disabled\n",
 							   HOSTNO, cmd->device->id, cmd->device->lun);
@@ -2294,7 +2294,7 @@ static void NCR5380_information_transfer
 					hostdata->connected = NULL;
 					hostdata->disconnected_queue = cmd;
 					local_irq_restore(flags);
-					QU_PRINTK("scsi%d: command for target %d lun %d was "
+					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %d was "
 						  "moved from connected to the "
 						  "disconnected_queue\n", HOSTNO,
 						  cmd->device->id, cmd->device->lun);
@@ -2344,13 +2344,13 @@ static void NCR5380_information_transfer
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-					EXT_PRINTK("scsi%d: receiving extended message\n", HOSTNO);
+					dprintk(NDEBUG_EXTENDED, "scsi%d: receiving extended message\n", HOSTNO);
 
 					len = 2;
 					data = extended_msg + 1;
 					phase = PHASE_MSGIN;
 					NCR5380_transfer_pio(instance, &phase, &len, &data);
-					EXT_PRINTK("scsi%d: length=%d, code=0x%02x\n", HOSTNO,
+					dprintk(NDEBUG_EXTENDED, "scsi%d: length=%d, code=0x%02x\n", HOSTNO,
 						   (int)extended_msg[1], (int)extended_msg[2]);
 
 					if (!len && extended_msg[1] <=
@@ -2362,7 +2362,7 @@ static void NCR5380_information_transfer
 						phase = PHASE_MSGIN;
 
 						NCR5380_transfer_pio(instance, &phase, &len, &data);
-						EXT_PRINTK("scsi%d: message received, residual %d\n",
+						dprintk(NDEBUG_EXTENDED, "scsi%d: message received, residual %d\n",
 							   HOSTNO, len);
 
 						switch (extended_msg[2]) {
@@ -2493,7 +2493,7 @@ static void NCR5380_reselect(struct Scsi
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
 
-	RSL_PRINTK("scsi%d: reselect\n", HOSTNO);
+	dprintk(NDEBUG_RESELECTION, "scsi%d: reselect\n", HOSTNO);
 
 	/*
 	 * At this point, we have detected that our SCSI ID is on the bus,
@@ -2544,7 +2544,7 @@ static void NCR5380_reselect(struct Scsi
 		if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
 		    msg[1] == SIMPLE_QUEUE_TAG)
 			tag = msg[2];
-		TAG_PRINTK("scsi%d: target mask %02x, lun %d sent tag %d at "
+		dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d at "
 			   "reselection\n", HOSTNO, target_mask, lun, tag);
 	}
 #endif
@@ -2598,7 +2598,7 @@ static void NCR5380_reselect(struct Scsi
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	hostdata->connected = tmp;
-	RSL_PRINTK("scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
+	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
 		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
 	falcon_dont_release--;
 }
@@ -2640,7 +2640,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 		printk(KERN_ERR "scsi%d: !!BINGO!! Falcon has no lock in NCR5380_abort\n",
 		       HOSTNO);
 
-	ABRT_PRINTK("scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
+	dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
 		    NCR5380_read(BUS_AND_STATUS_REG),
 		    NCR5380_read(STATUS_REG));
 
@@ -2653,7 +2653,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 
 	if (hostdata->connected == cmd) {
 
-		ABRT_PRINTK("scsi%d: aborting connected command\n", HOSTNO);
+		dprintk(NDEBUG_ABORT, "scsi%d: aborting connected command\n", HOSTNO);
 		/*
 		 * We should perform BSY checking, and make sure we haven't slipped
 		 * into BUS FREE.
@@ -2705,7 +2705,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 			SET_NEXT(tmp, NULL);
 			tmp->result = DID_ABORT << 16;
 			local_irq_restore(flags);
-			ABRT_PRINTK("scsi%d: abort removed command from issue queue.\n",
+			dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue queue.\n",
 				    HOSTNO);
 			/* Tagged queuing note: no tag to free here, hasn't been assigned
 			 * yet... */
@@ -2728,7 +2728,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 
 	if (hostdata->connected) {
 		local_irq_restore(flags);
-		ABRT_PRINTK("scsi%d: abort failed, command connected.\n", HOSTNO);
+		dprintk(NDEBUG_ABORT, "scsi%d: abort failed, command connected.\n", HOSTNO);
 		return SCSI_ABORT_SNOOZE;
 	}
 
@@ -2761,12 +2761,12 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	     tmp = NEXT(tmp)) {
 		if (cmd == tmp) {
 			local_irq_restore(flags);
-			ABRT_PRINTK("scsi%d: aborting disconnected command.\n", HOSTNO);
+			dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n", HOSTNO);
 
 			if (NCR5380_select(instance, cmd, (int)cmd->tag))
 				return SCSI_ABORT_BUSY;
 
-			ABRT_PRINTK("scsi%d: nexus reestablished.\n", HOSTNO);
+			dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
 
 			do_abort(instance);
 
@@ -2890,7 +2890,7 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 	 */
 
 	if ((cmd = connected)) {
-		ABRT_PRINTK("scsi%d: reset aborted a connected command\n", H_NO(cmd));
+		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
 		cmd->result = (cmd->result & 0xffff) | (DID_RESET << 16);
 		cmd->scsi_done(cmd);
 	}
@@ -2902,7 +2902,7 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 		cmd->scsi_done(cmd);
 	}
 	if (i > 0)
-		ABRT_PRINTK("scsi: reset aborted %d disconnected command(s)\n", i);
+		dprintk(NDEBUG_ABORT, "scsi: reset aborted %d disconnected command(s)\n", i);
 
 	/* The Falcon lock should be released after a reset...
 	 */
@@ -2942,11 +2942,11 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 	 */
 
 	if (hostdata->issue_queue)
-		ABRT_PRINTK("scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
+		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
 	if (hostdata->connected)
-		ABRT_PRINTK("scsi%d: reset aborted a connected command\n", H_NO(cmd));
+		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
 	if (hostdata->disconnected_queue)
-		ABRT_PRINTK("scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
+		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
 
 	local_irq_save(flags);
 	hostdata->issue_queue = NULL;
Index: linux-m68k/drivers/scsi/atari_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_scsi.c	2014-03-17 23:49:24.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_scsi.c	2014-03-18 00:18:36.000000000 +1100
@@ -313,7 +313,7 @@ static irqreturn_t scsi_tt_intr(int irq,
 
 	dma_stat = tt_scsi_dma.dma_ctrl;
 
-	INT_PRINTK("scsi%d: NCR5380 interrupt, DMA status = %02x\n",
+	dprintk(NDEBUG_INTR, "scsi%d: NCR5380 interrupt, DMA status = %02x\n",
 		   atari_scsi_host->host_no, dma_stat & 0xff);
 
 	/* Look if it was the DMA that has interrupted: First possibility
@@ -339,7 +339,7 @@ static irqreturn_t scsi_tt_intr(int irq,
 	if ((dma_stat & 0x02) && !(dma_stat & 0x40)) {
 		atari_dma_residual = HOSTDATA_DMALEN - (SCSI_DMA_READ_P(dma_addr) - atari_dma_startaddr);
 
-		DMA_PRINTK("SCSI DMA: There are %ld residual bytes.\n",
+		dprintk(NDEBUG_DMA, "SCSI DMA: There are %ld residual bytes.\n",
 			   atari_dma_residual);
 
 		if ((signed int)atari_dma_residual < 0)
@@ -370,7 +370,7 @@ static irqreturn_t scsi_tt_intr(int irq,
 			 * other command.  These shouldn't disconnect anyway.
 			 */
 			if (atari_dma_residual & 0x1ff) {
-				DMA_PRINTK("SCSI DMA: DMA bug corrected, "
+				dprintk(NDEBUG_DMA, "SCSI DMA: DMA bug corrected, "
 					   "difference %ld bytes\n",
 					   512 - (atari_dma_residual & 0x1ff));
 				atari_dma_residual = (atari_dma_residual + 511) & ~0x1ff;
@@ -437,7 +437,7 @@ static irqreturn_t scsi_falcon_intr(int
 			       "ST-DMA fifo\n", transferred & 15);
 
 		atari_dma_residual = HOSTDATA_DMALEN - transferred;
-		DMA_PRINTK("SCSI DMA: There are %ld residual bytes.\n",
+		dprintk(NDEBUG_DMA, "SCSI DMA: There are %ld residual bytes.\n",
 			   atari_dma_residual);
 	} else
 		atari_dma_residual = 0;
@@ -473,11 +473,11 @@ static void atari_scsi_fetch_restbytes(v
 		/* there are 'nr' bytes left for the last long address
 		   before the DMA pointer */
 		phys_dst ^= nr;
-		DMA_PRINTK("SCSI DMA: there are %d rest bytes for phys addr 0x%08lx",
+		dprintk(NDEBUG_DMA, "SCSI DMA: there are %d rest bytes for phys addr 0x%08lx",
 			   nr, phys_dst);
 		/* The content of the DMA pointer is a physical address!  */
 		dst = phys_to_virt(phys_dst);
-		DMA_PRINTK(" = virt addr %p\n", dst);
+		dprintk(NDEBUG_DMA, " = virt addr %p\n", dst);
 		for (src = (char *)&tt_scsi_dma.dma_restdata; nr != 0; --nr)
 			*dst++ = *src++;
 	}
@@ -877,7 +877,7 @@ static unsigned long atari_scsi_dma_setu
 {
 	unsigned long addr = virt_to_phys(data);
 
-	DMA_PRINTK("scsi%d: setting up dma, data = %p, phys = %lx, count = %ld, "
+	dprintk(NDEBUG_DMA, "scsi%d: setting up dma, data = %p, phys = %lx, count = %ld, "
 		   "dir = %d\n", instance->host_no, data, addr, count, dir);
 
 	if (!IS_A_TT() && !STRAM_ADDR(addr)) {
@@ -1057,7 +1057,7 @@ static unsigned long atari_dma_xfer_len(
 		possible_len = limit;
 
 	if (possible_len != wanted_len)
-		DMA_PRINTK("Sorry, must cut DMA transfer size to %ld bytes "
+		dprintk(NDEBUG_DMA, "Sorry, must cut DMA transfer size to %ld bytes "
 			   "instead of %ld\n", possible_len, wanted_len);
 
 	return possible_len;
Index: linux-m68k/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:35.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:36.000000000 +1100
@@ -364,7 +364,7 @@ static int is_lun_busy(struct scsi_cmnd
 	return( 0 );
     if (TagAlloc[cmd->device->id][cmd->device->lun].nr_allocated >=
 	TagAlloc[cmd->device->id][cmd->device->lun].queue_size ) {
-	TAG_PRINTK( "scsi%d: target %d lun %d: no free tags\n",
+	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d: no free tags\n",
 		    H_NO(cmd), cmd->device->id, cmd->device->lun );
 	return( 1 );
     }
@@ -388,7 +388,7 @@ static void cmd_get_tag(struct scsi_cmnd
 	!setup_use_tagged_queuing || !cmd->device->tagged_supported) {
 	cmd->tag = TAG_NONE;
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
-	TAG_PRINTK( "scsi%d: target %d lun %d now allocated by untagged "
+	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d now allocated by untagged "
 		    "command\n", H_NO(cmd), cmd->device->id, cmd->device->lun );
     }
     else {
@@ -397,7 +397,7 @@ static void cmd_get_tag(struct scsi_cmnd
 	cmd->tag = find_first_zero_bit( &ta->allocated, MAX_TAGS );
 	set_bit( cmd->tag, &ta->allocated );
 	ta->nr_allocated++;
-	TAG_PRINTK( "scsi%d: using tag %d for target %d lun %d "
+	dprintk(NDEBUG_TAGS,  "scsi%d: using tag %d for target %d lun %d "
 		    "(now %d tags in use)\n",
 		    H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun,
 		    ta->nr_allocated );
@@ -415,7 +415,7 @@ static void cmd_free_tag(struct scsi_cmn
 
     if (cmd->tag == TAG_NONE) {
 	hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
-	TAG_PRINTK( "scsi%d: target %d lun %d untagged cmd finished\n",
+	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d untagged cmd finished\n",
 		    H_NO(cmd), cmd->device->id, cmd->device->lun );
     }
     else if (cmd->tag >= MAX_TAGS) {
@@ -426,7 +426,7 @@ static void cmd_free_tag(struct scsi_cmn
 	TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
 	clear_bit( cmd->tag, &ta->allocated );
 	ta->nr_allocated--;
-	TAG_PRINTK( "scsi%d: freed tag %d for target %d lun %d\n",
+	dprintk(NDEBUG_TAGS,  "scsi%d: freed tag %d for target %d lun %d\n",
 		    H_NO(cmd), cmd->tag, cmd->device->id, cmd->device->lun );
     }
 }
@@ -618,7 +618,7 @@ static inline void NCR5380_all_init (voi
 {
     static int done = 0;
     if (!done) {
-	INI_PRINTK("scsi : NCR5380_all_init()\n");
+	dprintk(NDEBUG_INIT, "scsi : NCR5380_all_init()\n");
 	done = 1;
     }
 }
@@ -928,7 +928,7 @@ static int NCR5380_queue_command_lck(str
 
     local_irq_restore(flags);
 
-    QU_PRINTK("scsi%d: command added to %s of queue\n", H_NO(cmd),
+    dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H_NO(cmd),
 	      (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
     /* If queue_command() is called from an interrupt (real one or bottom
@@ -998,7 +998,7 @@ static void NCR5380_main (struct work_st
 	done = 1;
 	
 	if (!hostdata->connected) {
-	    MAIN_PRINTK( "scsi%d: not connected\n", HOSTNO );
+	    dprintk(NDEBUG_MAIN,  "scsi%d: not connected\n", HOSTNO );
 	    /*
 	     * Search through the issue_queue for a command destined
 	     * for a target that's not busy.
@@ -1047,7 +1047,7 @@ static void NCR5380_main (struct work_st
 		     * On failure, we must add the command back to the
 		     *   issue queue so we can keep trying.	
 		     */
-		    MAIN_PRINTK("scsi%d: main(): command for target %d "
+		    dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
 				"lun %d removed from issue_queue\n",
 				HOSTNO, tmp->device->id, tmp->device->lun);
 		    /* 
@@ -1076,7 +1076,7 @@ static void NCR5380_main (struct work_st
 			cmd_free_tag( tmp );
 #endif
 			local_irq_restore(flags);
-			MAIN_PRINTK("scsi%d: main(): select() failed, "
+			dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 				    "returned to issue_queue\n", HOSTNO);
 			if (hostdata->connected)
 			    break;
@@ -1090,10 +1090,10 @@ static void NCR5380_main (struct work_st
 #endif
 	    ) {
 	    local_irq_restore(flags);
-	    MAIN_PRINTK("scsi%d: main: performing information transfer\n",
+	    dprintk(NDEBUG_MAIN, "scsi%d: main: performing information transfer\n",
 			HOSTNO);
 	    NCR5380_information_transfer(instance);
-	    MAIN_PRINTK("scsi%d: main: done set false\n", HOSTNO);
+	    dprintk(NDEBUG_MAIN, "scsi%d: main: done set false\n", HOSTNO);
 	    done = 0;
 	}
     } while (!done);
@@ -1130,7 +1130,7 @@ static void NCR5380_dma_complete( struct
 	return;
     }
 
-    DMA_PRINTK("scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
+    dprintk(NDEBUG_DMA, "scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
 	       HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
 	       NCR5380_read(STATUS_REG));
 
@@ -1189,27 +1189,27 @@ static irqreturn_t NCR5380_intr (int irq
     int done = 1, handled = 0;
     unsigned char basr;
 
-    INT_PRINTK("scsi%d: NCR5380 irq triggered\n", HOSTNO);
+    dprintk(NDEBUG_INTR, "scsi%d: NCR5380 irq triggered\n", HOSTNO);
 
     /* Look for pending interrupts */
     basr = NCR5380_read(BUS_AND_STATUS_REG);
-    INT_PRINTK("scsi%d: BASR=%02x\n", HOSTNO, basr);
+    dprintk(NDEBUG_INTR, "scsi%d: BASR=%02x\n", HOSTNO, basr);
     /* dispatch to appropriate routine if found and done=0 */
     if (basr & BASR_IRQ) {
 	NCR5380_dprint(NDEBUG_INTR, instance);
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 	    done = 0;
 //	    ENABLE_IRQ();
-	    INT_PRINTK("scsi%d: SEL interrupt\n", HOSTNO);
+	    dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
 	    NCR5380_reselect(instance);
 	    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	}
 	else if (basr & BASR_PARITY_ERROR) {
-	    INT_PRINTK("scsi%d: PARITY interrupt\n", HOSTNO);
+	    dprintk(NDEBUG_INTR, "scsi%d: PARITY interrupt\n", HOSTNO);
 	    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	}
 	else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-	    INT_PRINTK("scsi%d: RESET interrupt\n", HOSTNO);
+	    dprintk(NDEBUG_INTR, "scsi%d: RESET interrupt\n", HOSTNO);
 	    (void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	}
 	else {
@@ -1229,7 +1229,7 @@ static irqreturn_t NCR5380_intr (int irq
 		((basr & BASR_END_DMA_TRANSFER) || 
 		 !(basr & BASR_PHASE_MATCH))) {
 		    
-		INT_PRINTK("scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
+		dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
 		NCR5380_dma_complete( instance );
 		done = 0;
 //		ENABLE_IRQ();
@@ -1238,7 +1238,7 @@ static irqreturn_t NCR5380_intr (int irq
 	    {
 /* MS: Ignore unknown phase mismatch interrupts (caused by EOP interrupt) */
 		if (basr & BASR_PHASE_MATCH)
-		   INT_PRINTK("scsi%d: unknown interrupt, "
+		   dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt, "
 			   "BASR 0x%x, MR 0x%x, SR 0x%x\n",
 			   HOSTNO, basr, NCR5380_read(MODE_REG),
 			   NCR5380_read(STATUS_REG));
@@ -1262,7 +1262,7 @@ static irqreturn_t NCR5380_intr (int irq
     }
     
     if (!done) {
-	INT_PRINTK("scsi%d: in int routine, calling main\n", HOSTNO);
+	dprintk(NDEBUG_INTR, "scsi%d: in int routine, calling main\n", HOSTNO);
 	/* Put a call to NCR5380_main() on the queue... */
 	queue_main();
     }
@@ -1339,7 +1339,7 @@ static int NCR5380_select(struct Scsi_Ho
 
     hostdata->restart_select = 0;
     NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-    ARB_PRINTK("scsi%d: starting arbitration, id = %d\n", HOSTNO,
+    dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
 	       instance->this_id);
 
     /* 
@@ -1385,7 +1385,7 @@ static int NCR5380_select(struct Scsi_Ho
 	 && !hostdata->connected);
 #endif
 
-    ARB_PRINTK("scsi%d: arbitration complete\n", HOSTNO);
+    dprintk(NDEBUG_ARBITRATION, "scsi%d: arbitration complete\n", HOSTNO);
 
     if (hostdata->connected) {
 	NCR5380_write(MODE_REG, MR_BASE); 
@@ -1406,7 +1406,7 @@ static int NCR5380_select(struct Scsi_Ho
 	(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
 	hostdata->connected) {
 	NCR5380_write(MODE_REG, MR_BASE); 
-	ARB_PRINTK("scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
 		   HOSTNO);
 	return -1;
     }
@@ -1421,7 +1421,7 @@ static int NCR5380_select(struct Scsi_Ho
 	hostdata->connected) {
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	ARB_PRINTK("scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
+	dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
 		   HOSTNO);
 	return -1;
     }
@@ -1444,7 +1444,7 @@ static int NCR5380_select(struct Scsi_Ho
 	return -1;
     }
 
-    ARB_PRINTK("scsi%d: won arbitration\n", HOSTNO);
+    dprintk(NDEBUG_ARBITRATION, "scsi%d: won arbitration\n", HOSTNO);
 
     /* 
      * Now that we have won arbitration, start Selection process, asserting 
@@ -1504,7 +1504,7 @@ static int NCR5380_select(struct Scsi_Ho
 
     udelay(1);
 
-    SEL_PRINTK("scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
+    dprintk(NDEBUG_SELECTION, "scsi%d: selecting target %d\n", HOSTNO, cmd->device->id);
 
     /* 
      * The SCSI specification calls for a 250 ms timeout for the actual 
@@ -1572,7 +1572,7 @@ static int NCR5380_select(struct Scsi_Ho
 #endif
 	cmd->scsi_done(cmd);
 	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-	SEL_PRINTK("scsi%d: target did not respond within 250ms\n", HOSTNO);
+	dprintk(NDEBUG_SELECTION, "scsi%d: target did not respond within 250ms\n", HOSTNO);
 	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 	return 0;
     } 
@@ -1597,7 +1597,7 @@ static int NCR5380_select(struct Scsi_Ho
     /* Wait for start of REQ/ACK handshake */
     while (!(NCR5380_read(STATUS_REG) & SR_REQ));
 
-    SEL_PRINTK("scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
+    dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
 	       HOSTNO, cmd->device->id);
     tmp[0] = IDENTIFY(1, cmd->device->lun);
 
@@ -1617,7 +1617,7 @@ static int NCR5380_select(struct Scsi_Ho
     data = tmp;
     phase = PHASE_MSGOUT;
     NCR5380_transfer_pio(instance, &phase, &len, &data);
-    SEL_PRINTK("scsi%d: nexus established.\n", HOSTNO);
+    dprintk(NDEBUG_SELECTION, "scsi%d: nexus established.\n", HOSTNO);
     /* XXX need to handle errors here */
     hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
@@ -1680,11 +1680,11 @@ static int NCR5380_transfer_pio( struct
 	 */
 	while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ));
 
-	HSH_PRINTK("scsi%d: REQ detected\n", HOSTNO);
+	dprintk(NDEBUG_HANDSHAKE, "scsi%d: REQ detected\n", HOSTNO);
 
 	/* Check for phase mismatch */	
 	if ((tmp & PHASE_MASK) != p) {
-	    PIO_PRINTK("scsi%d: phase mismatch\n", HOSTNO);
+	    dprintk(NDEBUG_PIO, "scsi%d: phase mismatch\n", HOSTNO);
 	    NCR5380_dprint_phase(NDEBUG_PIO, instance);
 	    break;
 	}
@@ -1725,7 +1725,7 @@ static int NCR5380_transfer_pio( struct
 
 	while (NCR5380_read(STATUS_REG) & SR_REQ);
 
-	HSH_PRINTK("scsi%d: req false, handshake complete\n", HOSTNO);
+	dprintk(NDEBUG_HANDSHAKE, "scsi%d: req false, handshake complete\n", HOSTNO);
 
 /*
  * We have several special cases to consider during REQ/ACK handshaking : 
@@ -1746,7 +1746,7 @@ static int NCR5380_transfer_pio( struct
 	} 
     } while (--c);
 
-    PIO_PRINTK("scsi%d: residual %d\n", HOSTNO, c);
+    dprintk(NDEBUG_PIO, "scsi%d: residual %d\n", HOSTNO, c);
 
     *count = c;
     *data = d;
@@ -1854,7 +1854,7 @@ static int NCR5380_transfer_dma( struct
     }
     hostdata->dma_len = c;
 
-    DMA_PRINTK("scsi%d: initializing DMA for %s, %d bytes %s %p\n",
+    dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %p\n",
 	       HOSTNO, (p & SR_IO) ? "reading" : "writing",
 	       c, (p & SR_IO) ? "to" : "from", *data);
 
@@ -1996,7 +1996,7 @@ static void NCR5380_information_transfer
 		    --cmd->SCp.buffers_residual;
 		    cmd->SCp.this_residual = cmd->SCp.buffer->length;
 		    cmd->SCp.ptr = SGADDR(cmd->SCp.buffer);
-		    INF_PRINTK("scsi%d: %d bytes and %d buffers left\n",
+		    dprintk(NDEBUG_INFORMATION, "scsi%d: %d bytes and %d buffers left\n",
 			       HOSTNO, cmd->SCp.this_residual,
 			       cmd->SCp.buffers_residual);
 		}
@@ -2088,7 +2088,7 @@ static void NCR5380_information_transfer
 		    /* Accept message by clearing ACK */
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		    
-		    LNK_PRINTK("scsi%d: target %d lun %d linked command "
+		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked command "
 			       "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
 		    /* Enable reselect interrupts */
@@ -2113,7 +2113,7 @@ static void NCR5380_information_transfer
 		     * and don't free it! */
 		    cmd->next_link->tag = cmd->tag;
 		    cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8); 
-		    LNK_PRINTK("scsi%d: target %d lun %d linked request "
+		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %d linked request "
 			       "done, calling scsi_done().\n",
 			       HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef NCR5380_STATS
@@ -2128,7 +2128,7 @@ static void NCR5380_information_transfer
 		    /* Accept message by clearing ACK */
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		    hostdata->connected = NULL;
-		    QU_PRINTK("scsi%d: command for target %d, lun %d "
+		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
 			      "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef SUPPORT_TAGS
 		    cmd_free_tag( cmd );
@@ -2142,7 +2142,7 @@ static void NCR5380_information_transfer
 			/* ++Andreas: the mid level code knows about
 			   QUEUE_FULL now. */
 			TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
-			TAG_PRINTK("scsi%d: target %d lun %d returned "
+			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d returned "
 				   "QUEUE_FULL after %d commands\n",
 				   HOSTNO, cmd->device->id, cmd->device->lun,
 				   ta->nr_allocated);
@@ -2186,7 +2186,7 @@ static void NCR5380_information_transfer
 		    if ((cmd->cmnd[0] != REQUEST_SENSE) && 
 			(status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 			scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
-			ASEN_PRINTK("scsi%d: performing request sense\n",
+			dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n",
 				    HOSTNO);
 			/* this is initialized from initialize_SCp 
 			cmd->SCp.buffer = NULL;
@@ -2198,7 +2198,7 @@ static void NCR5380_information_transfer
 			SET_NEXT(cmd, hostdata->issue_queue);
 		        hostdata->issue_queue = (struct scsi_cmnd *) cmd;
 		        local_irq_restore(flags);
-			QU_PRINTK("scsi%d: REQUEST SENSE added to head of "
+			dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 				  "issue queue\n", H_NO(cmd));
 		   } else
 #endif /* def AUTOSENSE */
@@ -2238,7 +2238,7 @@ static void NCR5380_information_transfer
 			cmd->device->tagged_supported = 0;
 			hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 			cmd->tag = TAG_NONE;
-			TAG_PRINTK("scsi%d: target %d lun %d rejected "
+			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d rejected "
 				   "QUEUE_TAG message; tagged queuing "
 				   "disabled\n",
 				   HOSTNO, cmd->device->id, cmd->device->lun);
@@ -2255,7 +2255,7 @@ static void NCR5380_information_transfer
 		    hostdata->connected = NULL;
 		    hostdata->disconnected_queue = cmd;
 		    local_irq_restore(flags);
-		    QU_PRINTK("scsi%d: command for target %d lun %d was "
+		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %d was "
 			      "moved from connected to the "
 			      "disconnected_queue\n", HOSTNO, 
 			      cmd->device->id, cmd->device->lun);
@@ -2308,13 +2308,13 @@ static void NCR5380_information_transfer
 		    /* Accept first byte by clearing ACK */
 		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-		    EXT_PRINTK("scsi%d: receiving extended message\n", HOSTNO);
+		    dprintk(NDEBUG_EXTENDED, "scsi%d: receiving extended message\n", HOSTNO);
 
 		    len = 2;
 		    data = extended_msg + 1;
 		    phase = PHASE_MSGIN;
 		    NCR5380_transfer_pio(instance, &phase, &len, &data);
-		    EXT_PRINTK("scsi%d: length=%d, code=0x%02x\n", HOSTNO,
+		    dprintk(NDEBUG_EXTENDED, "scsi%d: length=%d, code=0x%02x\n", HOSTNO,
 			       (int)extended_msg[1], (int)extended_msg[2]);
 
 		    if (!len && extended_msg[1] <= 
@@ -2326,7 +2326,7 @@ static void NCR5380_information_transfer
 			phase = PHASE_MSGIN;
 
 			NCR5380_transfer_pio(instance, &phase, &len, &data);
-			EXT_PRINTK("scsi%d: message received, residual %d\n",
+			dprintk(NDEBUG_EXTENDED, "scsi%d: message received, residual %d\n",
 				   HOSTNO, len);
 
 			switch (extended_msg[2]) {
@@ -2458,7 +2458,7 @@ static void NCR5380_reselect (struct Scs
 
     target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
 
-    RSL_PRINTK("scsi%d: reselect\n", HOSTNO);
+    dprintk(NDEBUG_RESELECTION, "scsi%d: reselect\n", HOSTNO);
 
     /* 
      * At this point, we have detected that our SCSI ID is on the bus,
@@ -2580,13 +2580,13 @@ static void NCR5380_reselect (struct Scs
 	if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
 	    msg[1] == SIMPLE_QUEUE_TAG)
 	    tag = msg[2];
-	TAG_PRINTK("scsi%d: target mask %02x, lun %d sent tag %d at "
+	dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d at "
 		   "reselection\n", HOSTNO, target_mask, lun, tag);
     }
 #endif
     
     hostdata->connected = tmp;
-    RSL_PRINTK("scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
+    dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
 	       HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
 }
 
@@ -2622,7 +2622,7 @@ static int NCR5380_abort(struct scsi_cmn
 
     local_irq_save(flags);
     
-    ABRT_PRINTK("scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
+    dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
 		NCR5380_read(BUS_AND_STATUS_REG),
 		NCR5380_read(STATUS_REG));
 
@@ -2635,7 +2635,7 @@ static int NCR5380_abort(struct scsi_cmn
 
     if (hostdata->connected == cmd) {
 
-	ABRT_PRINTK("scsi%d: aborting connected command\n", HOSTNO);
+	dprintk(NDEBUG_ABORT, "scsi%d: aborting connected command\n", HOSTNO);
 /*
  * We should perform BSY checking, and make sure we haven't slipped
  * into BUS FREE.
@@ -2686,7 +2686,7 @@ static int NCR5380_abort(struct scsi_cmn
 	    SET_NEXT(tmp, NULL);
 	    tmp->result = DID_ABORT << 16;
 	    local_irq_restore(flags);
-	    ABRT_PRINTK("scsi%d: abort removed command from issue queue.\n",
+	    dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue queue.\n",
 			HOSTNO);
 	    /* Tagged queuing note: no tag to free here, hasn't been assigned
 	     * yet... */
@@ -2707,7 +2707,7 @@ static int NCR5380_abort(struct scsi_cmn
 
     if (hostdata->connected) {
 	local_irq_restore(flags);
-	ABRT_PRINTK("scsi%d: abort failed, command connected.\n", HOSTNO);
+	dprintk(NDEBUG_ABORT, "scsi%d: abort failed, command connected.\n", HOSTNO);
         return SCSI_ABORT_SNOOZE;
     }
 
@@ -2740,12 +2740,12 @@ static int NCR5380_abort(struct scsi_cmn
 	 tmp = NEXT(tmp)) 
         if (cmd == tmp) {
             local_irq_restore(flags);
-	    ABRT_PRINTK("scsi%d: aborting disconnected command.\n", HOSTNO);
+	    dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n", HOSTNO);
   
             if (NCR5380_select (instance, cmd, (int) cmd->tag)) 
 		return SCSI_ABORT_BUSY;
 
-	    ABRT_PRINTK("scsi%d: nexus reestablished.\n", HOSTNO);
+	    dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
 
 	    do_abort (instance);
 
@@ -2857,7 +2857,7 @@ static int NCR5380_bus_reset(struct scsi
      */
 
     if ((cmd = connected)) {
-	ABRT_PRINTK("scsi%d: reset aborted a connected command\n", H_NO(cmd));
+	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
 	cmd->result = (cmd->result & 0xffff) | (DID_RESET << 16);
 	cmd->scsi_done( cmd );
     }
@@ -2869,7 +2869,7 @@ static int NCR5380_bus_reset(struct scsi
 	cmd->scsi_done( cmd );
     }
     if (i > 0)
-	ABRT_PRINTK("scsi: reset aborted %d disconnected command(s)\n", i);
+	dprintk(NDEBUG_ABORT, "scsi: reset aborted %d disconnected command(s)\n", i);
 
 
     /* since all commands have been explicitly terminated, we need to tell
@@ -2903,11 +2903,11 @@ static int NCR5380_bus_reset(struct scsi
      */
 
     if (hostdata->issue_queue)
-	ABRT_PRINTK("scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
+	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
     if (hostdata->connected) 
-	ABRT_PRINTK("scsi%d: reset aborted a connected command\n", H_NO(cmd));
+	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
     if (hostdata->disconnected_queue)
-	ABRT_PRINTK("scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
+	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
 
     local_irq_save(flags);
     hostdata->issue_queue = NULL;

Message-Id: <20140318002825.032459393@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:31 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 09/12] scsi/NCR5380: fix and standardize NDEBUG macros
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-debug-macros-fix-NDEBUG

All three NCR5380 core driver implementations share the same NCR5380.h
header file so they need to agree on certain macro definitions.

The flag bit used by the NDEBUG_MERGING macro in atari_NCR5380 and
sun3_NCR5380 collides with the bit used by NDEBUG_LISTS.

Moreover, NDEBUG_ABORT appears in NCR5380.c so it should be defined in
NCR5380.h rather than in each of the many drivers using that core.

An undefined NDEBUG_ABORT macro caused compiler errors and led to dodgy
workarounds in the core driver that can now be removed.
(See commits f566a576bca09de85bf477fc0ab2c8c96405b77b and
185a7a1cd79b9891e3c17abdb103ba1c98d6ca7a.)

Move all of the NDEBUG_ABORT, NDEBUG_TAGS and NDEBUG_MERGING macro
definitions into NCR5380.h where all the other NDEBUG macros live.

Also, incorrect "#ifdef NDEBUG" becomes "#if NDEBUG" to fix the warning:
drivers/scsi/mac_scsi.c: At top level:
drivers/scsi/NCR5380.c:418: warning: 'NCR5380_print' defined but not used
drivers/scsi/NCR5380.c:459: warning: 'NCR5380_print_phase' defined but not used

The debugging code is now enabled when NDEBUG != 0.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |    7 -------
 drivers/scsi/NCR5380.h       |   22 ++++++++++++++++++----
 drivers/scsi/atari_NCR5380.c |   10 ----------
 drivers/scsi/atari_scsi.c    |    6 ------
 drivers/scsi/dtc.c           |    2 --
 drivers/scsi/mac_scsi.c      |    6 ------
 drivers/scsi/sun3_NCR5380.c  |    8 +-------
 drivers/scsi/sun3_scsi.c     |    6 ------
 drivers/scsi/sun3_scsi_vme.c |    6 ------
 9 files changed, 19 insertions(+), 54 deletions(-)

Index: linux-m68k/drivers/scsi/NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.h	2014-03-18 00:18:34.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.h	2014-03-18 00:18:36.000000000 +1100
@@ -56,6 +56,9 @@
 #define NDEBUG_C400_PREAD	0x100000
 #define NDEBUG_C400_PWRITE	0x200000
 #define NDEBUG_LISTS		0x400000
+#define NDEBUG_ABORT		0x800000
+#define NDEBUG_TAGS		0x1000000
+#define NDEBUG_MERGING		0x2000000
 
 #define NDEBUG_ANY		0xFFFFFFFFUL
 
@@ -288,9 +291,24 @@ struct NCR5380_hostdata {
 
 #ifdef __KERNEL__
 
+#ifndef NDEBUG
+#define NDEBUG (0)
+#endif
+
+#if NDEBUG
+#define dprintk(flg, fmt, args...) \
+	do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## args); } while (0)
+#define NCR5380_dprint(flg, arg) \
+	do { if ((NDEBUG) & (flg)) NCR5380_print(arg); } while (0)
+#define NCR5380_dprint_phase(flg, arg) \
+	do { if ((NDEBUG) & (flg)) NCR5380_print_phase(arg); } while (0)
+static void NCR5380_print_phase(struct Scsi_Host *instance);
+static void NCR5380_print(struct Scsi_Host *instance);
+#else
 #define dprintk(flg, fmt, args...)     do {} while (0)
 #define NCR5380_dprint(flg, arg)       do {} while (0)
 #define NCR5380_dprint_phase(flg, arg) do {} while (0)
+#endif
 
 #if defined(AUTOPROBE_IRQ)
 static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
@@ -303,10 +321,6 @@ static irqreturn_t NCR5380_intr(int irq,
 #endif
 static void NCR5380_main(struct work_struct *work);
 static void __maybe_unused NCR5380_print_options(struct Scsi_Host *instance);
-#ifdef NDEBUG
-static void NCR5380_print_phase(struct Scsi_Host *instance);
-static void NCR5380_print(struct Scsi_Host *instance);
-#endif
 static int NCR5380_abort(Scsi_Cmnd * cmd);
 static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
 static int NCR5380_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
Index: linux-m68k/drivers/scsi/atari_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_scsi.c	2014-03-18 00:18:36.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_scsi.c	2014-03-18 00:18:36.000000000 +1100
@@ -67,12 +67,6 @@
 
 #include <linux/module.h>
 
-#define NDEBUG (0)
-
-#define NDEBUG_ABORT		0x00100000
-#define NDEBUG_TAGS		0x00200000
-#define NDEBUG_MERGING		0x00400000
-
 #define AUTOSENSE
 /* For the Atari version, use only polled IO or REAL_DMA */
 #define	REAL_DMA
Index: linux-m68k/drivers/scsi/NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.c	2014-03-18 00:18:34.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.c	2014-03-18 00:18:36.000000000 +1100
@@ -87,13 +87,6 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_transport_spi.h>
 
-#ifndef NDEBUG
-#define NDEBUG 0
-#endif
-#ifndef NDEBUG_ABORT
-#define NDEBUG_ABORT 0
-#endif
-
 #if (NDEBUG & NDEBUG_LISTS)
 #define LIST(x,y) {printk("LINE:%d   Adding %p to %p\n", __LINE__, (void*)(x), (void*)(y)); if ((x)==(y)) udelay(5); }
 #define REMOVE(w,x,y,z) {printk("LINE:%d   Removing: %p->%p  %p->%p \n", __LINE__, (void*)(w), (void*)(x), (void*)(y), (void*)(z)); if ((x)==(y)) udelay(5); }
Index: linux-m68k/drivers/scsi/sun3_scsi_vme.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi_vme.c	2014-03-17 23:49:23.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi_vme.c	2014-03-18 00:18:36.000000000 +1100
@@ -38,12 +38,6 @@
 /* dma on! */
 #define REAL_DMA
 
-#define NDEBUG 0
-
-#define NDEBUG_ABORT		0x00100000
-#define NDEBUG_TAGS		0x00200000
-#define NDEBUG_MERGING		0x00400000
-
 #include "scsi.h"
 #include "initio.h"
 #include <scsi/scsi_host.h>
Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:33.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:36.000000000 +1100
@@ -65,12 +65,6 @@
 #include <asm/idprom.h>
 #include <asm/machines.h>
 
-#define NDEBUG 0
-
-#define NDEBUG_ABORT		0x00100000
-#define NDEBUG_TAGS		0x00200000
-#define NDEBUG_MERGING		0x00400000
-
 /* dma on! */
 #define REAL_DMA
 
Index: linux-m68k/drivers/scsi/mac_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.c	2014-03-18 00:18:32.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.c	2014-03-18 00:18:36.000000000 +1100
@@ -54,12 +54,6 @@
 
 #include "NCR5380.h"
 
-#if 0
-#define NDEBUG (NDEBUG_INTR | NDEBUG_PSEUDO_DMA | NDEBUG_ARBITRATION | NDEBUG_SELECTION | NDEBUG_RESELECTION)
-#else
-#define NDEBUG (NDEBUG_ABORT)
-#endif
-
 #define RESET_BOOT
 #define DRIVER_SETUP
 
Index: linux-m68k/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:36.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_NCR5380.c	2014-03-18 00:18:36.000000000 +1100
@@ -484,7 +484,7 @@ static __inline__ void initialize_SCp(st
 
 #include <linux/delay.h>
 
-#if 1
+#if NDEBUG
 static struct {
     unsigned char mask;
     const char * name;} 
@@ -572,12 +572,6 @@ static void NCR5380_print_phase(struct S
     }
 }
 
-#else /* !NDEBUG */
-
-/* dummies... */
-__inline__ void NCR5380_print(struct Scsi_Host *instance) { };
-__inline__ void NCR5380_print_phase(struct Scsi_Host *instance) { };
-
 #endif
 
 /*
Index: linux-m68k/drivers/scsi/dtc.c
===================================================================
--- linux-m68k.orig/drivers/scsi/dtc.c	2014-03-17 23:49:23.000000000 +1100
+++ linux-m68k/drivers/scsi/dtc.c	2014-03-18 00:18:36.000000000 +1100
@@ -3,8 +3,6 @@
 #define PSEUDO_DMA
 #define DONT_USE_INTR
 #define UNSAFE			/* Leave interrupts enabled during pseudo-dma I/O */
-#define xNDEBUG (NDEBUG_INTR+NDEBUG_RESELECTION+\
-		 NDEBUG_SELECTION+NDEBUG_ARBITRATION)
 #define DMA_WORKS_RIGHT
 
 
Index: linux-m68k/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_NCR5380.c	2014-03-18 00:18:36.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_NCR5380.c	2014-03-18 00:18:36.000000000 +1100
@@ -626,16 +626,6 @@ static void NCR5380_print_phase(struct S
 	}
 }
 
-#else /* !NDEBUG */
-
-/* dummies... */
-static inline void NCR5380_print(struct Scsi_Host *instance)
-{
-};
-static inline void NCR5380_print_phase(struct Scsi_Host *instance)
-{
-};
-
 #endif
 
 /*

Message-Id: <20140318002825.322447666@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:32 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 10/12] scsi/NCR5380: remove unused macro definitions
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-debug-macros-remove-X_PRINTK-NCRPRINT

Remove the unused (and divergent) debugging macro definitions from
the sun3_NCR5380 and atari_NCR5380 drivers. These drivers have been
converted to use the common macros in NCR5380.h.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_scsi.h |   93 -----------------------
 drivers/scsi/sun3_scsi.h  |  181 ----------------------------------------------
 2 files changed, 274 deletions(-)

Index: linux-m68k/drivers/scsi/atari_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_scsi.h	2014-03-17 23:49:22.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_scsi.h	2014-03-18 00:18:37.000000000 +1100
@@ -80,99 +80,6 @@
 #define SCSI_RESET_HOST_RESET 0x200
 #define SCSI_RESET_ACTION   0xff
 
-/* Debugging printk definitions:
- *
- *  ARB  -> arbitration
- *  ASEN -> auto-sense
- *  DMA  -> DMA
- *  HSH  -> PIO handshake
- *  INF  -> information transfer
- *  INI  -> initialization
- *  INT  -> interrupt
- *  LNK  -> linked commands
- *  MAIN -> NCR5380_main() control flow
- *  NDAT -> no data-out phase
- *  NWR  -> no write commands
- *  PIO  -> PIO transfers
- *  PDMA -> pseudo DMA (unused on Atari)
- *  QU   -> queues
- *  RSL  -> reselections
- *  SEL  -> selections
- *  USL  -> usleep cpde (unused on Atari)
- *  LBS  -> last byte sent (unused on Atari)
- *  RSS  -> restarting of selections
- *  EXT  -> extended messages
- *  ABRT -> aborting and resetting
- *  TAG  -> queue tag handling
- *  MER  -> merging of consec. buffers
- *
- */
-
-#define dprint(flg, format...)			\
-({						\
-	if (NDEBUG & (flg))			\
-		printk(KERN_DEBUG format);	\
-})
-
-#define ARB_PRINTK(format, args...) \
-	dprint(NDEBUG_ARBITRATION, format , ## args)
-#define ASEN_PRINTK(format, args...) \
-	dprint(NDEBUG_AUTOSENSE, format , ## args)
-#define DMA_PRINTK(format, args...) \
-	dprint(NDEBUG_DMA, format , ## args)
-#define HSH_PRINTK(format, args...) \
-	dprint(NDEBUG_HANDSHAKE, format , ## args)
-#define INF_PRINTK(format, args...) \
-	dprint(NDEBUG_INFORMATION, format , ## args)
-#define INI_PRINTK(format, args...) \
-	dprint(NDEBUG_INIT, format , ## args)
-#define INT_PRINTK(format, args...) \
-	dprint(NDEBUG_INTR, format , ## args)
-#define LNK_PRINTK(format, args...) \
-	dprint(NDEBUG_LINKED, format , ## args)
-#define MAIN_PRINTK(format, args...) \
-	dprint(NDEBUG_MAIN, format , ## args)
-#define NDAT_PRINTK(format, args...) \
-	dprint(NDEBUG_NO_DATAOUT, format , ## args)
-#define NWR_PRINTK(format, args...) \
-	dprint(NDEBUG_NO_WRITE, format , ## args)
-#define PIO_PRINTK(format, args...) \
-	dprint(NDEBUG_PIO, format , ## args)
-#define PDMA_PRINTK(format, args...) \
-	dprint(NDEBUG_PSEUDO_DMA, format , ## args)
-#define QU_PRINTK(format, args...) \
-	dprint(NDEBUG_QUEUES, format , ## args)
-#define RSL_PRINTK(format, args...) \
-	dprint(NDEBUG_RESELECTION, format , ## args)
-#define SEL_PRINTK(format, args...) \
-	dprint(NDEBUG_SELECTION, format , ## args)
-#define USL_PRINTK(format, args...) \
-	dprint(NDEBUG_USLEEP, format , ## args)
-#define LBS_PRINTK(format, args...) \
-	dprint(NDEBUG_LAST_BYTE_SENT, format , ## args)
-#define RSS_PRINTK(format, args...) \
-	dprint(NDEBUG_RESTART_SELECT, format , ## args)
-#define EXT_PRINTK(format, args...) \
-	dprint(NDEBUG_EXTENDED, format , ## args)
-#define ABRT_PRINTK(format, args...) \
-	dprint(NDEBUG_ABORT, format , ## args)
-#define TAG_PRINTK(format, args...) \
-	dprint(NDEBUG_TAGS, format , ## args)
-#define MER_PRINTK(format, args...) \
-	dprint(NDEBUG_MERGING, format , ## args)
-
-/* conditional macros for NCR5380_print_{,phase,status} */
-
-#define NCR_PRINT(mask)	\
-	((NDEBUG & (mask)) ? NCR5380_print(instance) : (void)0)
-
-#define NCR_PRINT_PHASE(mask) \
-	((NDEBUG & (mask)) ? NCR5380_print_phase(instance) : (void)0)
-
-#define NCR_PRINT_STATUS(mask) \
-	((NDEBUG & (mask)) ? NCR5380_print_status(instance) : (void)0)
-
-
 #endif /* ndef ASM */
 #endif /* ATARI_SCSI_H */
 
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:32.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:37.000000000 +1100
@@ -182,188 +182,7 @@ struct sun3_udc_regs {
 
 #define VME_DATA24 0x3d00
 
-// debugging printk's, taken from atari_scsi.h 
-/* Debugging printk definitions:
- *
- *  ARB  -> arbitration
- *  ASEN -> auto-sense
- *  DMA  -> DMA
- *  HSH  -> PIO handshake
- *  INF  -> information transfer
- *  INI  -> initialization
- *  INT  -> interrupt
- *  LNK  -> linked commands
- *  MAIN -> NCR5380_main() control flow
- *  NDAT -> no data-out phase
- *  NWR  -> no write commands
- *  PIO  -> PIO transfers
- *  PDMA -> pseudo DMA (unused on Atari)
- *  QU   -> queues
- *  RSL  -> reselections
- *  SEL  -> selections
- *  USL  -> usleep cpde (unused on Atari)
- *  LBS  -> last byte sent (unused on Atari)
- *  RSS  -> restarting of selections
- *  EXT  -> extended messages
- *  ABRT -> aborting and resetting
- *  TAG  -> queue tag handling
- *  MER  -> merging of consec. buffers
- *
- */
-
 #include "NCR5380.h"
 
-#if NDEBUG & NDEBUG_ARBITRATION
-#define ARB_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define ARB_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_AUTOSENSE
-#define ASEN_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define ASEN_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_DMA
-#define DMA_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define DMA_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_HANDSHAKE
-#define HSH_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define HSH_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_INFORMATION
-#define INF_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define INF_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_INIT
-#define INI_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define INI_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_INTR
-#define INT_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define INT_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_LINKED
-#define LNK_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define LNK_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_MAIN
-#define MAIN_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define MAIN_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_NO_DATAOUT
-#define NDAT_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define NDAT_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_NO_WRITE
-#define NWR_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define NWR_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_PIO
-#define PIO_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define PIO_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_PSEUDO_DMA
-#define PDMA_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define PDMA_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_QUEUES
-#define QU_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define QU_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_RESELECTION
-#define RSL_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define RSL_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_SELECTION
-#define SEL_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define SEL_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_USLEEP
-#define USL_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define USL_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_LAST_BYTE_SENT
-#define LBS_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define LBS_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_RESTART_SELECT
-#define RSS_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define RSS_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_EXTENDED
-#define EXT_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define EXT_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_ABORT
-#define ABRT_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define ABRT_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_TAGS
-#define TAG_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define TAG_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_MERGING
-#define MER_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define MER_PRINTK(format, args...)
-#endif
-
-/* conditional macros for NCR5380_print_{,phase,status} */
-
-#define NCR_PRINT(mask)	\
-	((NDEBUG & (mask)) ? NCR5380_print(instance) : (void)0)
-
-#define NCR_PRINT_PHASE(mask) \
-	((NDEBUG & (mask)) ? NCR5380_print_phase(instance) : (void)0)
-
-#define NCR_PRINT_STATUS(mask) \
-	((NDEBUG & (mask)) ? NCR5380_print_status(instance) : (void)0)
-
-
-
 #endif /* SUN3_NCR5380_H */
 

Message-Id: <20140318002825.622446081@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:33 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 11/12] scsi/NCR5380: reduce depth of sun3_scsi nested includes
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-sun3-includes

Move the #include "NCR5380.h" out of the sun3_scsi.h header file and into
the driver .c files, like all the other NCR5380 drivers in the tree.

This improves uniformity and reduces the depth of nested includes. The
sequence of #include's, #define's and #if's no longer does my head in.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Here's a graph showing the present #include structure.


      sun3_scsi_vme.c  ----->  sun3_scsi.h  ----->  NCR5380.h

              |                    ^
              '--------------------|----.
                                   |    |
                  .----------------'    |
                  |                     v

          sun3_scsi.c  ----->  sun3_NCR5380.c


And here's the situation at the end of this patch series, after moving the
#includes with this patch, and merging sun3_scsi.c and sun3_scsi_vme with
the next patch.


                           sun3_scsi.h

                               ^
                               |
                               |

    sun3_scsi_vme.c  ----->  sun3_scsi.c  ----->  sun3_NCR5380.c

                                   |
                                   |
                                   v

                               NCR5380.h


The final structure (see the next patch) of sun3_scsi_vme mirrors that of
g_NCR5380_mmio.c, and the final structure of sun3_scsi mirrors that of all
the other NCR5380 drivers.

BTW, both sun3_scsi.c and sun3_scsi_vme.c also #include "initio.h"
but I've sent a separate patch to address this.

---
 drivers/scsi/sun3_scsi.c     |    1 +
 drivers/scsi/sun3_scsi.h     |    8 +++-----
 drivers/scsi/sun3_scsi_vme.c |    1 +
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:36.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:38.000000000 +1100
@@ -72,6 +72,7 @@
 #include "initio.h"
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
+#include "NCR5380.h"
 
 /* #define OLDDMA */
 
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:37.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:38.000000000 +1100
@@ -29,8 +29,8 @@
  * 1+ (800) 334-5454
  */
 
-#ifndef SUN3_NCR5380_H
-#define SUN3_NCR5380_H
+#ifndef SUN3_SCSI_H
+#define SUN3_SCSI_H
 
 #define SUN3SCSI_PUBLIC_RELEASE 1
 
@@ -182,7 +182,5 @@ struct sun3_udc_regs {
 
 #define VME_DATA24 0x3d00
 
-#include "NCR5380.h"
-
-#endif /* SUN3_NCR5380_H */
+#endif /* SUN3_SCSI_H */
 
Index: linux-m68k/drivers/scsi/sun3_scsi_vme.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi_vme.c	2014-03-18 00:18:36.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi_vme.c	2014-03-18 00:18:38.000000000 +1100
@@ -42,6 +42,7 @@
 #include "initio.h"
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
+#include "NCR5380.h"
 
 extern int sun3_map_test(unsigned long, char *);
 

Message-Id: <20140318002825.912462570@telegraphics.com.au>
User-Agent: quilt/0.50-1
Date: Tue, 18 Mar 2014 11:28:34 +1100
From: Finn Thain <fthain@telegraphics.com.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
  <linux-scsi@vger.kernel.org>
Cc: Sam Creasey <sammy@sammy.net>,
 Russell King <linux@arm.linux.org.uk>,
 Michael Schmitz <schmitz@debian.org>,
  <linux-kernel@vger.kernel.org>,
  <linux-arm-kernel@lists.infradead.org>,
  <linux-m68k@vger.kernel.org>
Subject: [PATCH 12/12] scsi/NCR5380: merge sun3_scsi_vme.c into sun3_scsi.c
References: <20140318002822.372705594@telegraphics.com.au>
Content-Disposition: inline; filename=ncr5380-sun3-vme-merge

The sun3 drivers suffer from a whole bunch of duplicated code. Fix this
by following the g_NCR5380_mmio example. (Notionally, sun3_scsi relates to
sun3_scsi_vme in the same way that g_NCR5380 relates to g_NCR5380_mmio.)

Dead code is also removed: we now have working debug macros so
SUN3_SCSI_DEBUG is undesirable. Dead code within #ifdef OLD_DMA is also
dropped, consistent with sun3_scsi_vme.c.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/sun3_scsi.c     |  222 ++++++++++++----
 drivers/scsi/sun3_scsi_vme.c |  583 -------------------------------------------
 2 files changed, 171 insertions(+), 634 deletions(-)

Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:38.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:39.000000000 +1100
@@ -3,6 +3,10 @@
  *
  * Sun3 DMA routines added by Sam Creasey (sammy@sammy.net)
  *
+ * VME support added by Sam Creasey
+ *
+ * TODO: modify this driver to support multiple Sun3 SCSI VME boards
+ *
  * Adapted from mac_scsinew.c:
  */
 /*
@@ -74,7 +78,7 @@
 #include "sun3_scsi.h"
 #include "NCR5380.h"
 
-/* #define OLDDMA */
+extern int sun3_map_test(unsigned long, char *);
 
 #define USE_WRAPPER
 /*#define RESET_BOOT */
@@ -90,7 +94,11 @@
 
 /* #define SUPPORT_TAGS */
 
+#ifdef SUN3_SCSI_VME
+#define ENABLE_IRQ()
+#else
 #define	ENABLE_IRQ()	enable_irq( IRQ_SUN3_SCSI ); 
+#endif
 
 
 static irqreturn_t scsi_sun3_intr(int irq, void *dummy);
@@ -125,10 +133,9 @@ static struct scsi_cmnd *sun3_dma_setup_
 
 static volatile unsigned char *sun3_scsi_regp;
 static volatile struct sun3_dma_regs *dregs;
-#ifdef OLDDMA
-static unsigned char *dmabuf = NULL; /* dma memory buffer */
-#endif
+#ifndef SUN3_SCSI_VME
 static struct sun3_udc_regs *udc_regs = NULL;
+#endif
 static unsigned char *sun3_dma_orig_addr = NULL;
 static unsigned long sun3_dma_orig_count = 0;
 static int sun3_dma_active = 0;
@@ -148,6 +155,7 @@ static inline void sun3scsi_write(int re
 	sun3_scsi_regp[reg] = value;
 }
 
+#ifndef SUN3_SCSI_VME
 /* dma controller register access functions */
 
 static inline unsigned short sun3_udc_read(unsigned char reg)
@@ -169,6 +177,7 @@ static inline void sun3_udc_write(unsign
 	dregs->udc_data = val;
 	udelay(SUN3_DMA_DELAY);
 }
+#endif
 
 /*
  * XXX: status debug
@@ -187,17 +196,32 @@ static struct Scsi_Host *default_instanc
  *
  */
  
-int __init sun3scsi_detect(struct scsi_host_template * tpnt)
+static int __init sun3scsi_detect(struct scsi_host_template * tpnt)
 {
-	unsigned long ioaddr;
+	unsigned long ioaddr, irq;
 	static int called = 0;
 	struct Scsi_Host *instance;
+#ifdef SUN3_SCSI_VME
+	int i;
+	unsigned long addrs[3] = { IOBASE_SUN3_VMESCSI,
+				   IOBASE_SUN3_VMESCSI + 0x4000,
+				   0 };
+	unsigned long vecs[3] = { SUN3_VEC_VMESCSI0,
+				  SUN3_VEC_VMESCSI1,
+				  0 };
+#endif
 
 	/* check that this machine has an onboard 5380 */
 	switch(idprom->id_machtype) {
+#ifdef SUN3_SCSI_VME
+	case SM_SUN3|SM_3_160:
+	case SM_SUN3|SM_3_260:
+		break;
+#else
 	case SM_SUN3|SM_3_50:
 	case SM_SUN3|SM_3_60:
 		break;
+#endif
 
 	default:
 		return 0;
@@ -206,7 +230,11 @@ int __init sun3scsi_detect(struct scsi_h
 	if(called)
 		return 0;
 
+#ifdef SUN3_SCSI_VME
+	tpnt->proc_name = "Sun3 5380 VME SCSI";
+#else
 	tpnt->proc_name = "Sun3 5380 SCSI";
+#endif
 
 	/* setup variables */
 	tpnt->can_queue =
@@ -223,6 +251,38 @@ int __init sun3scsi_detect(struct scsi_h
 		tpnt->this_id = 7;
 	}
 
+#ifdef SUN3_SCSI_VME
+	ioaddr = 0;
+	for(i = 0; addrs[i] != 0; i++) {
+		unsigned char x;
+
+		ioaddr = (unsigned long)sun3_ioremap(addrs[i], PAGE_SIZE,
+						     SUN3_PAGE_TYPE_VME16);
+		irq = vecs[i];
+		sun3_scsi_regp = (unsigned char *)ioaddr;
+
+		dregs = (struct sun3_dma_regs *)(((unsigned char *)ioaddr) + 8);
+
+		if(sun3_map_test((unsigned long)dregs, &x)) {
+			unsigned short oldcsr;
+
+			oldcsr = dregs->csr;
+			dregs->csr = 0;
+			udelay(SUN3_DMA_DELAY);
+			if(dregs->csr == 0x1400)
+				break;
+
+			dregs->csr = oldcsr;
+		}
+
+		iounmap((void *)ioaddr);
+		ioaddr = 0;
+	}
+
+	if(!ioaddr)
+		return 0;
+#else
+	irq = IRQ_SUN3_SCSI;
 	ioaddr = (unsigned long)ioremap(IOBASE_SUN3_SCSI, PAGE_SIZE);
 	sun3_scsi_regp = (unsigned char *)ioaddr;
 
@@ -233,11 +293,6 @@ int __init sun3scsi_detect(struct scsi_h
 	     printk("SUN3 Scsi couldn't allocate DVMA memory!\n");
 	     return 0;
 	}
-#ifdef OLDDMA
-	if((dmabuf = dvma_malloc_align(SUN3_DVMA_BUFSIZE, 0x10000)) == NULL) {
-	     printk("SUN3 Scsi couldn't allocate DVMA memory!\n");
-	     return 0;
-	}
 #endif
 #ifdef SUPPORT_TAGS
 	if (setup_use_tagged_queuing < 0)
@@ -251,7 +306,7 @@ int __init sun3scsi_detect(struct scsi_h
 	default_instance = instance;
 
         instance->io_port = (unsigned long) ioaddr;
-	instance->irq = IRQ_SUN3_SCSI;
+	instance->irq = irq;
 
 	NCR5380_init(instance, 0);
 
@@ -272,7 +327,8 @@ int __init sun3scsi_detect(struct scsi_h
 #endif
 	}
 	
-	printk("scsi%d: Sun3 5380 at port %lX irq", instance->host_no, instance->io_port);
+	pr_info("scsi%d: %s at port %lX irq", instance->host_no,
+	        tpnt->proc_name, instance->io_port);
 	if (instance->irq == SCSI_IRQ_NONE)
 		printk ("s disabled");
 	else
@@ -289,6 +345,15 @@ int __init sun3scsi_detect(struct scsi_h
 	dregs->csr = CSR_SCSI | CSR_FIFO | CSR_INTR;
 	udelay(SUN3_DMA_DELAY);
 	dregs->fifo_count = 0;
+#ifdef SUN3_SCSI_VME
+	dregs->fifo_count_hi = 0;
+	dregs->dma_addr_hi = 0;
+	dregs->dma_addr_lo = 0;
+	dregs->dma_count_hi = 0;
+	dregs->dma_count_lo = 0;
+
+	dregs->ivect = VME_DATA24 | (instance->irq & 0xff);
+#endif
 
 	called = 1;
 
@@ -356,7 +421,7 @@ static void sun3_scsi_reset_boot(struct
 }
 #endif
 
-const char * sun3scsi_info (struct Scsi_Host *spnt) {
+static const char * sun3scsi_info (struct Scsi_Host *spnt) {
     return "";
 }
 
@@ -368,6 +433,10 @@ static irqreturn_t scsi_sun3_intr(int ir
 	unsigned short csr = dregs->csr;
 	int handled = 0;
 
+#ifdef SUN3_SCSI_VME
+	dregs->csr &= ~CSR_DMA_ENABLE;
+#endif
+
 	if(csr & ~CSR_GOOD) {
 		if(csr & CSR_DMA_BUSERR) {
 			printk("scsi%d: bus error in dma\n", default_instance->host_no);
@@ -411,31 +480,28 @@ void sun3_sun3_debug (void)
 /* sun3scsi_dma_setup() -- initialize the dma controller for a read/write */
 static unsigned long sun3scsi_dma_setup(void *data, unsigned long count, int write_flag)
 {
-#ifdef OLDDMA
-	if(write_flag) 
-		memcpy(dmabuf, data, count);
-	else {
-		sun3_dma_orig_addr = data;
-		sun3_dma_orig_count = count;
-	}
-#else
 	void *addr;
 
 	if(sun3_dma_orig_addr != NULL)
 		dvma_unmap(sun3_dma_orig_addr);
 
-//	addr = sun3_dvma_page((unsigned long)data, (unsigned long)dmabuf);
+#ifdef SUN3_SCSI_VME
+	addr = (void *)dvma_map_vme((unsigned long) data, count);
+#else
 	addr = (void *)dvma_map((unsigned long) data, count);
+#endif
 		
 	sun3_dma_orig_addr = addr;
 	sun3_dma_orig_count = count;
-#endif
+
+#ifndef SUN3_SCSI_VME
 	dregs->fifo_count = 0;
 	sun3_udc_write(UDC_RESET, UDC_CSR);
 	
 	/* reset fifo */
 	dregs->csr &= ~CSR_FIFO;
 	dregs->csr |= CSR_FIFO;
+#endif
 	
 	/* set direction */
 	if(write_flag)
@@ -443,6 +509,17 @@ static unsigned long sun3scsi_dma_setup(
 	else
 		dregs->csr &= ~CSR_SEND;
 	
+#ifdef SUN3_SCSI_VME
+	dregs->csr |= CSR_PACK_ENABLE;
+
+	dregs->dma_addr_hi = ((unsigned long)addr >> 16);
+	dregs->dma_addr_lo = ((unsigned long)addr & 0xffff);
+
+	dregs->dma_count_hi = 0;
+	dregs->dma_count_lo = 0;
+	dregs->fifo_count_hi = 0;
+	dregs->fifo_count = 0;
+#else
 	/* byte count for fifo */
 	dregs->fifo_count = count;
 
@@ -460,13 +537,8 @@ static unsigned long sun3scsi_dma_setup(
 	}
 
 	/* setup udc */
-#ifdef OLDDMA
-	udc_regs->addr_hi = ((dvma_vtob(dmabuf) & 0xff0000) >> 8);
-	udc_regs->addr_lo = (dvma_vtob(dmabuf) & 0xffff);
-#else
 	udc_regs->addr_hi = (((unsigned long)(addr) & 0xff0000) >> 8);
 	udc_regs->addr_lo = ((unsigned long)(addr) & 0xffff);
-#endif
 	udc_regs->count = count/2; /* count in words */
 	udc_regs->mode_hi = UDC_MODE_HIWORD;
 	if(write_flag) {
@@ -490,11 +562,13 @@ static unsigned long sun3scsi_dma_setup(
 
 	/* interrupt enable */
 	sun3_udc_write(UDC_INT_ENABLE, UDC_CSR);
+#endif
 	
        	return count;
 
 }
 
+#ifndef SUN3_SCSI_VME
 static inline unsigned long sun3scsi_dma_count(struct Scsi_Host *instance)
 {
 	unsigned short resid;
@@ -507,6 +581,7 @@ static inline unsigned long sun3scsi_dma
 
 	return (unsigned long) resid;
 }
+#endif
 
 static inline unsigned long sun3scsi_dma_residual(struct Scsi_Host *instance)
 {
@@ -525,8 +600,23 @@ static inline unsigned long sun3scsi_dma
 
 static inline int sun3scsi_dma_start(unsigned long count, unsigned char *data)
 {
+#ifdef SUN3_SCSI_VME
+	unsigned short csr;
+
+	csr = dregs->csr;
 
+	dregs->dma_count_hi = (sun3_dma_orig_count >> 16);
+	dregs->dma_count_lo = (sun3_dma_orig_count & 0xffff);
+
+	dregs->fifo_count_hi = (sun3_dma_orig_count >> 16);
+	dregs->fifo_count = (sun3_dma_orig_count & 0xffff);
+
+/*	if(!(csr & CSR_DMA_ENABLE))
+ *		dregs->csr |= CSR_DMA_ENABLE;
+ */
+#else
     sun3_udc_write(UDC_CHN_START, UDC_CSR);
+#endif
     
     return 0;
 }
@@ -534,12 +624,46 @@ static inline int sun3scsi_dma_start(uns
 /* clean up after our dma is done */
 static int sun3scsi_dma_finish(int write_flag)
 {
-	unsigned short count;
+	unsigned short __maybe_unused count;
 	unsigned short fifo;
 	int ret = 0;
 	
 	sun3_dma_active = 0;
-#if 1
+
+#ifdef SUN3_SCSI_VME
+	dregs->csr &= ~CSR_DMA_ENABLE;
+
+	fifo = dregs->fifo_count;
+	if(write_flag) {
+		if((fifo > 0) && (fifo < sun3_dma_orig_count))
+			fifo++;
+	}
+
+	last_residual = fifo;
+	/* empty bytes from the fifo which didn't make it */
+	if((!write_flag) && (dregs->csr & CSR_LEFT)) {
+		unsigned char *vaddr;
+
+		vaddr = (unsigned char *)dvma_vmetov(sun3_dma_orig_addr);
+
+		vaddr += (sun3_dma_orig_count - fifo);
+		vaddr--;
+
+		switch(dregs->csr & CSR_LEFT) {
+		case CSR_LEFT_3:
+			*vaddr = (dregs->bpack_lo & 0xff00) >> 8;
+			vaddr--;
+
+		case CSR_LEFT_2:
+			*vaddr = (dregs->bpack_hi & 0x00ff);
+			vaddr--;
+
+		case CSR_LEFT_1:
+			*vaddr = (dregs->bpack_hi & 0xff00) >> 8;
+			break;
+		}
+	}
+#else
 	// check to empty the fifo on a read
 	if(!write_flag) {
 		int tmo = 20000; /* .2 sec */
@@ -555,28 +679,8 @@ static int sun3scsi_dma_finish(int write
 			udelay(10);
 		}
 	}
-		
-#endif
 
 	count = sun3scsi_dma_count(default_instance);
-#ifdef OLDDMA
-
-	/* if we've finished a read, copy out the data we read */
- 	if(sun3_dma_orig_addr) {
-		/* check for residual bytes after dma end */
-		if(count && (NCR5380_read(BUS_AND_STATUS_REG) &
-			     (BASR_PHASE_MATCH | BASR_ACK))) {
-			printk("scsi%d: sun3_scsi_finish: read overrun baby... ", default_instance->host_no);
-			printk("basr now %02x\n", NCR5380_read(BUS_AND_STATUS_REG));
-			ret = count;
-		}
-		
-		/* copy in what we dma'd no matter what */
-		memcpy(sun3_dma_orig_addr, dmabuf, sun3_dma_orig_count);
-		sun3_dma_orig_addr = NULL;
-
-	}
-#else
 
 	fifo = dregs->fifo_count;
 	last_residual = fifo;
@@ -594,10 +698,23 @@ static int sun3scsi_dma_finish(int write
 		vaddr[-2] = (data & 0xff00) >> 8;
 		vaddr[-1] = (data & 0xff);
 	}
+#endif
 
 	dvma_unmap(sun3_dma_orig_addr);
 	sun3_dma_orig_addr = NULL;
-#endif
+
+#ifdef SUN3_SCSI_VME
+	dregs->dma_addr_hi = 0;
+	dregs->dma_addr_lo = 0;
+	dregs->dma_count_hi = 0;
+	dregs->dma_count_lo = 0;
+
+	dregs->fifo_count = 0;
+	dregs->fifo_count_hi = 0;
+
+	dregs->csr &= ~CSR_SEND;
+/*	dregs->csr |= CSR_DMA_ENABLE; */
+#else
 	sun3_udc_write(UDC_RESET, UDC_CSR);
 	dregs->fifo_count = 0;
 	dregs->csr &= ~CSR_SEND;
@@ -605,6 +722,7 @@ static int sun3scsi_dma_finish(int write
 	/* reset fifo */
 	dregs->csr &= ~CSR_FIFO;
 	dregs->csr |= CSR_FIFO;
+#endif
 	
 	sun3_dma_setup_done = NULL;
 
Index: linux-m68k/drivers/scsi/sun3_scsi_vme.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi_vme.c	2014-03-18 00:18:38.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi_vme.c	2014-03-18 00:18:39.000000000 +1100
@@ -1,584 +1,3 @@
- /*
- * Sun3 SCSI stuff by Erik Verbruggen (erik@bigmama.xtdnet.nl)
- *
- * Sun3 DMA routines added by Sam Creasey (sammy@sammy.net)
- *
- * VME support added by Sam Creasey
- *
- * Adapted from sun3_scsi.c -- see there for other headers
- *
- * TODO: modify this driver to support multiple Sun3 SCSI VME boards
- *
- */
-
-#define AUTOSENSE
-
-#include <linux/types.h>
-#include <linux/stddef.h>
-#include <linux/ctype.h>
-#include <linux/delay.h>
-
-#include <linux/module.h>
-#include <linux/signal.h>
-#include <linux/ioport.h>
-#include <linux/init.h>
-#include <linux/blkdev.h>
-
-#include <asm/io.h>
-
-#include <asm/sun3ints.h>
-#include <asm/dvma.h>
-#include <asm/idprom.h>
-#include <asm/machines.h>
-
 #define SUN3_SCSI_VME
 
-#undef SUN3_SCSI_DEBUG
-
-/* dma on! */
-#define REAL_DMA
-
-#include "scsi.h"
-#include "initio.h"
-#include <scsi/scsi_host.h>
-#include "sun3_scsi.h"
-#include "NCR5380.h"
-
-extern int sun3_map_test(unsigned long, char *);
-
-#define USE_WRAPPER
-/*#define RESET_BOOT */
-#define DRIVER_SETUP
-
-/*
- * BUG can be used to trigger a strange code-size related hang on 2.1 kernels
- */
-#ifdef BUG
-#undef RESET_BOOT
-#undef DRIVER_SETUP
-#endif
-
-/* #define SUPPORT_TAGS */
-
-//#define	ENABLE_IRQ()	enable_irq( SUN3_VEC_VMESCSI0 ); 
-#define ENABLE_IRQ()
-
-
-static irqreturn_t scsi_sun3_intr(int irq, void *dummy);
-static inline unsigned char sun3scsi_read(int reg);
-static inline void sun3scsi_write(int reg, int value);
-
-static int setup_can_queue = -1;
-module_param(setup_can_queue, int, 0);
-static int setup_cmd_per_lun = -1;
-module_param(setup_cmd_per_lun, int, 0);
-static int setup_sg_tablesize = -1;
-module_param(setup_sg_tablesize, int, 0);
-#ifdef SUPPORT_TAGS
-static int setup_use_tagged_queuing = -1;
-module_param(setup_use_tagged_queuing, int, 0);
-#endif
-static int setup_hostid = -1;
-module_param(setup_hostid, int, 0);
-
-static struct scsi_cmnd *sun3_dma_setup_done = NULL;
-
-#define	AFTER_RESET_DELAY	(HZ/2)
-
-/* ms to wait after hitting dma regs */
-#define SUN3_DMA_DELAY 10
-
-/* dvma buffer to allocate -- 32k should hopefully be more than sufficient */
-#define SUN3_DVMA_BUFSIZE 0xe000
-
-/* minimum number of bytes to do dma on */
-#define SUN3_DMA_MINSIZE 128
-
-static volatile unsigned char *sun3_scsi_regp;
-static volatile struct sun3_dma_regs *dregs;
-#ifdef OLDDMA
-static unsigned char *dmabuf = NULL; /* dma memory buffer */
-#endif
-static unsigned char *sun3_dma_orig_addr = NULL;
-static unsigned long sun3_dma_orig_count = 0;
-static int sun3_dma_active = 0;
-static unsigned long last_residual = 0;
-
-/*
- * NCR 5380 register access functions
- */
-
-static inline unsigned char sun3scsi_read(int reg)
-{
-	return( sun3_scsi_regp[reg] );
-}
-
-static inline void sun3scsi_write(int reg, int value)
-{
-	sun3_scsi_regp[reg] = value;
-}
-
-/*
- * XXX: status debug
- */
-static struct Scsi_Host *default_instance;
-
-/*
- * Function : int sun3scsi_detect(struct scsi_host_template * tpnt)
- *
- * Purpose : initializes mac NCR5380 driver based on the
- *	command line / compile time port and irq definitions.
- *
- * Inputs : tpnt - template for this SCSI adapter.
- *
- * Returns : 1 if a host adapter was found, 0 if not.
- *
- */
- 
-static int __init sun3scsi_detect(struct scsi_host_template * tpnt)
-{
-	unsigned long ioaddr, irq = 0;
-	static int called = 0;
-	struct Scsi_Host *instance;
-	int i;
-	unsigned long addrs[3] = { IOBASE_SUN3_VMESCSI, 
-				   IOBASE_SUN3_VMESCSI + 0x4000,
-				   0 };
-	unsigned long vecs[3] = { SUN3_VEC_VMESCSI0,
-				  SUN3_VEC_VMESCSI1,
-				  0 };
-	/* check that this machine has an onboard 5380 */
-	switch(idprom->id_machtype) {
-	case SM_SUN3|SM_3_160:
-	case SM_SUN3|SM_3_260:
-		break;
-
-	default:
-		return 0;
-	}
-
-	if(called)
-		return 0;
-
-	tpnt->proc_name = "Sun3 5380 VME SCSI";
-
-	/* setup variables */
-	tpnt->can_queue =
-		(setup_can_queue > 0) ? setup_can_queue : CAN_QUEUE;
-	tpnt->cmd_per_lun =
-		(setup_cmd_per_lun > 0) ? setup_cmd_per_lun : CMD_PER_LUN;
-	tpnt->sg_tablesize = 
-		(setup_sg_tablesize >= 0) ? setup_sg_tablesize : SG_TABLESIZE;
-	
-	if (setup_hostid >= 0)
-		tpnt->this_id = setup_hostid;
-	else {
-		/* use 7 as default */
-		tpnt->this_id = 7;
-	}
-	
-	ioaddr = 0;
-	for(i = 0; addrs[i] != 0; i++) {
-		unsigned char x;
-		
-		ioaddr = (unsigned long)sun3_ioremap(addrs[i], PAGE_SIZE,
-						     SUN3_PAGE_TYPE_VME16);
-		irq = vecs[i];
-		sun3_scsi_regp = (unsigned char *)ioaddr;
-		
-		dregs = (struct sun3_dma_regs *)(((unsigned char *)ioaddr) + 8);
-		
-		if(sun3_map_test((unsigned long)dregs, &x)) {
-			unsigned short oldcsr;
-
-			oldcsr = dregs->csr;
-			dregs->csr = 0;
-			udelay(SUN3_DMA_DELAY);
-			if(dregs->csr == 0x1400)
-				break;
-			
-			dregs->csr = oldcsr;
-		}
-
-		iounmap((void *)ioaddr);
-		ioaddr = 0;
-	}
-
-	if(!ioaddr)
-		return 0;
-	
-#ifdef SUPPORT_TAGS
-	if (setup_use_tagged_queuing < 0)
-		setup_use_tagged_queuing = USE_TAGGED_QUEUING;
-#endif
-
-	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-	if(instance == NULL)
-		return 0;
-		
-	default_instance = instance;
-
-        instance->io_port = (unsigned long) ioaddr;
-	instance->irq = irq;
-
-	NCR5380_init(instance, 0);
-
-	instance->n_io_port = 32;
-
-        ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
-
-	if (request_irq(instance->irq, scsi_sun3_intr,
-			0, "Sun3SCSI-5380VME", instance)) {
-#ifndef REAL_DMA
-		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
-		       instance->host_no, instance->irq);
-		instance->irq = SCSI_IRQ_NONE;
-#else
-		printk("scsi%d: IRQ%d not free, bailing out\n",
-		       instance->host_no, instance->irq);
-		return 0;
-#endif
-	}
-
-	printk("scsi%d: Sun3 5380 VME at port %lX irq", instance->host_no, instance->io_port);
-	if (instance->irq == SCSI_IRQ_NONE)
-		printk ("s disabled");
-	else
-		printk (" %d", instance->irq);
-	printk(" options CAN_QUEUE=%d CMD_PER_LUN=%d release=%d",
-	       instance->can_queue, instance->cmd_per_lun,
-	       SUN3SCSI_PUBLIC_RELEASE);
-	printk("\nscsi%d:", instance->host_no);
-	NCR5380_print_options(instance);
-	printk("\n");
-
-	dregs->csr = 0;
-	udelay(SUN3_DMA_DELAY);
-	dregs->csr = CSR_SCSI | CSR_FIFO | CSR_INTR;
-	udelay(SUN3_DMA_DELAY);
-	dregs->fifo_count = 0;
-	dregs->fifo_count_hi = 0;
-	dregs->dma_addr_hi = 0;
-	dregs->dma_addr_lo = 0;
-	dregs->dma_count_hi = 0;
-	dregs->dma_count_lo = 0;
-
-	dregs->ivect = VME_DATA24 | (instance->irq & 0xff);
-
-	called = 1;
-
-#ifdef RESET_BOOT
-	sun3_scsi_reset_boot(instance);
-#endif
-
-	return 1;
-}
-
-int sun3scsi_release (struct Scsi_Host *shpnt)
-{
-	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq(shpnt->irq, shpnt);
-
-	iounmap((void *)sun3_scsi_regp);
-
-	NCR5380_exit(shpnt);
-	return 0;
-}
-
-#ifdef RESET_BOOT
-/*
- * Our 'bus reset on boot' function
- */
-
-static void sun3_scsi_reset_boot(struct Scsi_Host *instance)
-{
-	unsigned long end;
-
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
-	
-	/*
-	 * Do a SCSI reset to clean up the bus during initialization. No
-	 * messing with the queues, interrupts, or locks necessary here.
-	 */
-
-	printk( "Sun3 SCSI: resetting the SCSI bus..." );
-
-	/* switch off SCSI IRQ - catch an interrupt without IRQ bit set else */
-//       	sun3_disable_irq( IRQ_SUN3_SCSI );
-
-	/* get in phase */
-	NCR5380_write( TARGET_COMMAND_REG,
-		      PHASE_SR_TO_TCR( NCR5380_read(STATUS_REG) ));
-
-	/* assert RST */
-	NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST );
-
-	/* The min. reset hold time is 25us, so 40us should be enough */
-	udelay( 50 );
-
-	/* reset RST and interrupt */
-	NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE );
-	NCR5380_read( RESET_PARITY_INTERRUPT_REG );
-
-	for( end = jiffies + AFTER_RESET_DELAY; time_before(jiffies, end); )
-		barrier();
-
-	/* switch on SCSI IRQ again */
-//       	sun3_enable_irq( IRQ_SUN3_SCSI );
-
-	printk( " done\n" );
-}
-#endif
-
-static const char * sun3scsi_info (struct Scsi_Host *spnt) {
-    return "";
-}
-
-// safe bits for the CSR
-#define CSR_GOOD 0x060f
-
-static irqreturn_t scsi_sun3_intr(int irq, void *dummy)
-{
-	unsigned short csr = dregs->csr;
-	int handled = 0;
-
-	dregs->csr &= ~CSR_DMA_ENABLE;
-
-
-#ifdef SUN3_SCSI_DEBUG
-	printk("scsi_intr csr %x\n", csr);
-#endif
-
-	if(csr & ~CSR_GOOD) {
-		if(csr & CSR_DMA_BUSERR) {
-			printk("scsi%d: bus error in dma\n", default_instance->host_no);
-#ifdef SUN3_SCSI_DEBUG
-			printk("scsi: residual %x count %x addr %p dmaaddr %x\n", 
-			       dregs->fifo_count,
-			       dregs->dma_count_lo | (dregs->dma_count_hi << 16),
-			       sun3_dma_orig_addr,
-			       dregs->dma_addr_lo | (dregs->dma_addr_hi << 16));
-#endif
-		}
-
-		if(csr & CSR_DMA_CONFLICT) {
-			printk("scsi%d: dma conflict\n", default_instance->host_no);
-		}
-		handled = 1;
-	}
-
-	if(csr & (CSR_SDB_INT | CSR_DMA_INT)) {
-		NCR5380_intr(irq, dummy);
-		handled = 1;
-	}
-
-	return IRQ_RETVAL(handled);
-}
-
-/*
- * Debug stuff - to be called on NMI, or sysrq key. Use at your own risk; 
- * reentering NCR5380_print_status seems to have ugly side effects
- */
-
-/* this doesn't seem to get used at all -- sam */
-#if 0
-void sun3_sun3_debug (void)
-{
-	unsigned long flags;
-	NCR5380_local_declare();
-
-	if (default_instance) {
-			local_irq_save(flags);
-			NCR5380_print_status(default_instance);
-			local_irq_restore(flags);
-	}
-}
-#endif
-
-
-/* sun3scsi_dma_setup() -- initialize the dma controller for a read/write */
-static unsigned long sun3scsi_dma_setup(void *data, unsigned long count, int write_flag)
-{
-	void *addr;
-
-	if(sun3_dma_orig_addr != NULL)
-		dvma_unmap(sun3_dma_orig_addr);
-
-//	addr = sun3_dvma_page((unsigned long)data, (unsigned long)dmabuf);
-	addr = (void *)dvma_map_vme((unsigned long) data, count);
-		
-	sun3_dma_orig_addr = addr;
-	sun3_dma_orig_count = count;
-	
-#ifdef SUN3_SCSI_DEBUG
-	printk("scsi: dma_setup addr %p count %x\n", addr, count);
-#endif
-
-//	dregs->fifo_count = 0;
-#if 0	
-	/* reset fifo */
-	dregs->csr &= ~CSR_FIFO;
-	dregs->csr |= CSR_FIFO;
-#endif	
-	/* set direction */
-	if(write_flag)
-		dregs->csr |= CSR_SEND;
-	else
-		dregs->csr &= ~CSR_SEND;
-	
-	/* reset fifo */
-//	dregs->csr &= ~CSR_FIFO;
-//	dregs->csr |= CSR_FIFO;
-
-	dregs->csr |= CSR_PACK_ENABLE;
-
-	dregs->dma_addr_hi = ((unsigned long)addr >> 16);
-	dregs->dma_addr_lo = ((unsigned long)addr & 0xffff);
-	
-	dregs->dma_count_hi = 0;
-	dregs->dma_count_lo = 0;
-	dregs->fifo_count_hi = 0;
-	dregs->fifo_count = 0;
-		
-#ifdef SUN3_SCSI_DEBUG
-	printk("scsi: dma_setup done csr %x\n", dregs->csr);
-#endif
-       	return count;
-
-}
-
-static inline unsigned long sun3scsi_dma_residual(struct Scsi_Host *instance)
-{
-	return last_residual;
-}
-
-static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted,
-						  struct scsi_cmnd *cmd,
-						  int write_flag)
-{
-	if (cmd->request->cmd_type == REQ_TYPE_FS)
- 		return wanted;
-	else
-		return 0;
-}
-
-static int sun3scsi_dma_start(unsigned long count, char *data)
-{
-	
-	unsigned short csr;
-
-	csr = dregs->csr;
-#ifdef SUN3_SCSI_DEBUG
-	printk("scsi: dma_start data %p count %x csr %x fifo %x\n", data, count, csr, dregs->fifo_count);
-#endif
-	
-	dregs->dma_count_hi = (sun3_dma_orig_count >> 16);
-	dregs->dma_count_lo = (sun3_dma_orig_count & 0xffff);
-
-	dregs->fifo_count_hi = (sun3_dma_orig_count >> 16);
-	dregs->fifo_count = (sun3_dma_orig_count & 0xffff);
-
-//	if(!(csr & CSR_DMA_ENABLE))
-//		dregs->csr |= CSR_DMA_ENABLE;
-
-	return 0;
-}
-
-/* clean up after our dma is done */
-static int sun3scsi_dma_finish(int write_flag)
-{
-	unsigned short fifo;
-	int ret = 0;
-	
-	sun3_dma_active = 0;
-
-	dregs->csr &= ~CSR_DMA_ENABLE;
-	
-	fifo = dregs->fifo_count;
-	if(write_flag) {
-		if((fifo > 0) && (fifo < sun3_dma_orig_count))
-			fifo++;
-	}
-
-	last_residual = fifo;
-#ifdef SUN3_SCSI_DEBUG
-	printk("scsi: residual %x total %x\n", fifo, sun3_dma_orig_count);
-#endif
-	/* empty bytes from the fifo which didn't make it */
-	if((!write_flag) && (dregs->csr & CSR_LEFT)) {
-		unsigned char *vaddr;
-
-#ifdef SUN3_SCSI_DEBUG
-		printk("scsi: got left over bytes\n");
-#endif
-
-		vaddr = (unsigned char *)dvma_vmetov(sun3_dma_orig_addr);
-		
-		vaddr += (sun3_dma_orig_count - fifo);
-		vaddr--;
-		
-		switch(dregs->csr & CSR_LEFT) {
-		case CSR_LEFT_3:
-			*vaddr = (dregs->bpack_lo & 0xff00) >> 8;
-			vaddr--;
-			
-		case CSR_LEFT_2:
-			*vaddr = (dregs->bpack_hi & 0x00ff);
-			vaddr--;
-			
-		case CSR_LEFT_1:
-			*vaddr = (dregs->bpack_hi & 0xff00) >> 8;
-			break;
-		}
-		
-		
-	}
-
-	dvma_unmap(sun3_dma_orig_addr);
-	sun3_dma_orig_addr = NULL;
-
-	dregs->dma_addr_hi = 0;
-	dregs->dma_addr_lo = 0;
-	dregs->dma_count_hi = 0;
-	dregs->dma_count_lo = 0;
-
-	dregs->fifo_count = 0;
-	dregs->fifo_count_hi = 0;
-
-	dregs->csr &= ~CSR_SEND;
-	
-//	dregs->csr |= CSR_DMA_ENABLE;
-	
-#if 0
-	/* reset fifo */
-	dregs->csr &= ~CSR_FIFO;
-	dregs->csr |= CSR_FIFO;
-#endif	
-	sun3_dma_setup_done = NULL;
-
-	return ret;
-
-}
-
-#include "sun3_NCR5380.c"
-
-static struct scsi_host_template driver_template = {
-	.name			= SUN3_SCSI_NAME,
-	.detect			= sun3scsi_detect,
-	.release		= sun3scsi_release,
-	.info			= sun3scsi_info,
-	.queuecommand		= sun3scsi_queue_command,
-	.eh_abort_handler      	= sun3scsi_abort,
-	.eh_bus_reset_handler  	= sun3scsi_bus_reset,
-	.can_queue		= CAN_QUEUE,
-	.this_id		= 7,
-	.sg_tablesize		= SG_TABLESIZE,
-	.cmd_per_lun		= CMD_PER_LUN,
-	.use_clustering		= DISABLE_CLUSTERING
-};
-
-
-#include "scsi_module.c"
-
-MODULE_LICENSE("GPL");
+#include "sun3_scsi.c"
