From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 09/12] scsi/NCR5380: fix and standardize NDEBUG macros
Date: Tue, 18 Mar 2014 11:42:21 +1100
Message-ID: <20140318004215.292486266@telegraphics.com.au>
References: <20140318004212.612472697@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-debug-macros-fix-NDEBUG
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
