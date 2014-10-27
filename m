From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 04/36] ncr5380: Remove unused macros
Date: Mon, 27 Oct 2014 16:26:11 +1100
Message-ID: <20141027052608.115425018@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48297 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaJ0Kbf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 06:31:35 -0400
Content-Disposition: inline; filename=ncr5380-remove-unused-macros
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org

Some macros are never evaluated (i.e. FOO, USLEEP, SCSI2 and USE_WRAPPER;
and in some drivers, NCR5380_intr and NCR5380_proc_info). DRIVER_SETUP
serves no purpose anymore. Remove these macro definitions.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/NCR5380.c    |    2 +-
 drivers/scsi/arm/oak.c    |    1 -
 drivers/scsi/atari_scsi.h |    1 -
 drivers/scsi/g_NCR5380.c  |    5 -----
 drivers/scsi/g_NCR5380.h  |    1 -
 drivers/scsi/mac_scsi.c   |    3 ---
 drivers/scsi/pas16.c      |    5 -----
 drivers/scsi/sun3_scsi.c  |   15 ---------------
 drivers/scsi/sun3_scsi.h  |    1 -
 drivers/scsi/t128.c       |    5 -----
 10 files changed, 1 insertion(+), 38 deletions(-)

Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:07.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:09.000000000 +1100
@@ -55,7 +55,6 @@
 #include "NCR5380.h"
 
 #define RESET_BOOT
-#define DRIVER_SETUP
 
 extern void via_scsi_clear(void);
 
@@ -113,7 +112,6 @@ static __inline__ void macscsi_write(str
  */
 
 static int __init mac_scsi_setup(char *str) {
-#ifdef DRIVER_SETUP	
 	int ints[7];
 	
 	(void)get_options( str, ARRAY_SIZE(ints), ints);
@@ -166,7 +164,6 @@ static int __init mac_scsi_setup(char *s
 	}
 #endif /* SUPPORT_TAGS */
 	
-#endif /* DRIVER_SETUP */
 	return 1;
 }
 
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:07.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:09.000000000 +1100
@@ -43,10 +43,6 @@
  * Options :
  *
  * PARITY - enable parity checking.  Not supported.
- *
- * SCSI2 - enable support for SCSI-II tagged queueing.  Untested.
- *
- * USLEEP - enable support for devices that don't disconnect.  Untested.
  */
 
 #define AUTOSENSE
@@ -79,18 +75,7 @@
 
 extern int sun3_map_test(unsigned long, char *);
 
-#define USE_WRAPPER
 /*#define RESET_BOOT */
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
 /* #define SUPPORT_TAGS */
 
 #ifdef SUN3_SCSI_VME
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-10-27 16:18:00.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2014-10-27 16:25:09.000000000 +1100
@@ -649,7 +649,7 @@ NCR5380_print_options(struct Scsi_Host *
 	       " UNSAFE "
 #endif
 	    );
-	printk(" USLEEP, USLEEP_POLL=%d USLEEP_SLEEP=%d", USLEEP_POLL, USLEEP_SLEEP);
+	printk(" USLEEP_POLL=%d USLEEP_SLEEP=%d", USLEEP_POLL, USLEEP_SLEEP);
 	printk(" generic release=%d", NCR5380_PUBLIC_RELEASE);
 	if (((struct NCR5380_hostdata *) instance->hostdata)->flags & FLAG_NCR53C400) {
 		printk(" ncr53c400 release=%d", NCR53C400_PUBLIC_RELEASE);
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-10-27 16:25:08.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2014-10-27 16:25:09.000000000 +1100
@@ -1,6 +1,5 @@
 #define AUTOSENSE
 #define PSEUDO_DMA
-#define FOO
 #define UNSAFE  /* Not unsafe for PAS16 -- use it */
 #define PDEBUG 0
 
@@ -52,8 +51,6 @@
  * increase compared to polled I/O.
  *
  * PARITY - enable parity checking.  Not supported.
- * 
- * SCSI2 - enable support for SCSI-II tagged queueing.  Untested.
  *
  * UNSAFE - leave interrupts enabled during pseudo-DMA transfers.  This
  *	    parameter comes from the NCR5380 code.  It is NOT unsafe with
@@ -63,8 +60,6 @@
  *	    want to use UNSAFE you can try defining LIMIT_TRANSFERSIZE or
  *	    twiddle with the transfer size in the high level code.
  *
- * USLEEP - enable support for devices that don't disconnect.  Untested.
- *
  * The card is detected and initialized in one of several ways : 
  * 1.  Autoprobe (default) - There are many different models of
  *     the Pro Audio Spectrum/Studio 16, and I only have one of
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-10-27 16:18:00.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2014-10-27 16:25:09.000000000 +1100
@@ -44,10 +44,6 @@
  *
  * PARITY - enable parity checking.  Not supported.
  *
- * SCSI2 - enable support for SCSI-II tagged queueing.  Untested.
- *
- * USLEEP - enable support for devices that don't disconnect.  Untested.
- *
  * The card is detected and initialized in one of several ways : 
  * 1.  With command line overrides - NCR5380=port,irq may be 
  *     used on the LILO command line to override the defaults.
@@ -79,7 +75,6 @@
  */
 
 /* settings for DTC3181E card with only Mustek scanner attached */
-#define USLEEP
 #define USLEEP_POLL	1
 #define USLEEP_SLEEP	20
 #define USLEEP_WAITLONG	500
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2014-10-27 16:18:00.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2014-10-27 16:25:09.000000000 +1100
@@ -29,7 +29,6 @@
 
 #define NCR5380_read(reg)		readb(_base + ((reg) << 2))
 #define NCR5380_write(reg, value)	writeb(value, _base + ((reg) << 2))
-#define NCR5380_intr			oakscsi_intr
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_show_info		oakscsi_show_info
 #define NCR5380_write_info		oakscsi_write_info
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2014-10-27 16:18:00.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2014-10-27 16:25:09.000000000 +1100
@@ -118,7 +118,6 @@ static const char* generic_NCR5380_info(
 #define NCR5380_bus_reset generic_NCR5380_bus_reset
 #define NCR5380_pread generic_NCR5380_pread
 #define NCR5380_pwrite generic_NCR5380_pwrite
-#define NCR5380_proc_info notyet_generic_proc_info
 
 #define BOARD_NCR5380	0
 #define BOARD_NCR53C400	1
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-10-27 16:25:08.000000000 +1100
+++ linux/drivers/scsi/t128.c	2014-10-27 16:25:09.000000000 +1100
@@ -47,17 +47,12 @@
  * increase compared to polled I/O.
  *
  * PARITY - enable parity checking.  Not supported.
- * 
- * SCSI2 - enable support for SCSI-II tagged queueing.  Untested.
- *
  *
  * UNSAFE - leave interrupts enabled during pseudo-DMA transfers.  You
  *          only really want to use this if you're having a problem with
  *          dropped characters during high speed communications, and even
  *          then, you're going to be better off twiddling with transfersize.
  *
- * USLEEP - enable support for devices that don't disconnect.  Untested.
- *
  * The card is detected and initialized in one of several ways : 
  * 1.  Autoprobe (default) - since the board is memory mapped, 
  *     a BIOS signature is scanned for to locate the registers.
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-10-27 16:25:07.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.h	2014-10-27 16:25:09.000000000 +1100
@@ -89,7 +89,6 @@ static int sun3scsi_release (struct Scsi
 #define NCR5380_read(reg) sun3scsi_read(reg)
 #define NCR5380_write(reg, value) sun3scsi_write(reg, value)
 
-#define NCR5380_intr sun3scsi_intr
 #define NCR5380_queue_command sun3scsi_queue_command
 #define NCR5380_bus_reset sun3scsi_bus_reset
 #define NCR5380_abort sun3scsi_abort
Index: linux/drivers/scsi/atari_scsi.h
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.h	2014-10-27 16:18:00.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.h	2014-10-27 16:25:09.000000000 +1100
@@ -44,7 +44,6 @@
 #define NCR5380_read(reg)		  atari_scsi_reg_read( reg )
 #define NCR5380_write(reg, value) atari_scsi_reg_write( reg, value )
 
-#define NCR5380_intr atari_scsi_intr
 #define NCR5380_queue_command atari_scsi_queue_command
 #define NCR5380_abort atari_scsi_abort
 #define NCR5380_show_info atari_scsi_show_info


