From: Christoph Hellwig <hch@lst.de>
Subject: [hch@lst.de: [PATCH] drop dead 2.0 compat code in CENSORED
Date: Mon, 21 Apr 2003 12:04:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421120422.A24975@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:64525 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263804AbTDUJwU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 05:52:20 -0400
Received: (from hch@localhost)
	by verein.lst.de (8.11.6/8.11.6) id h3LA4NZ24990
	for linux-scsi@vger.kernel.org; Mon, 21 Apr 2003 12:04:23 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Argg, vger is driving me nuts!

----- Forwarded message from Christoph Hellwig <hch@lst.de> -----

Date: Mon, 21 Apr 2003 12:01:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] drop dead 2.0 compat code in aic7xxx/79xx
To: gibbs@scsiguy.com
Cc: linux-scsi@vger.kernel.org

There's some 2.0-compat stuff in the aic drivers, but the most
fundamental parts (old error handling, old PCI code) are missing.

Drop the dead bits.


--- 1.29/drivers/scsi/aic7xxx/aic79xx_osm.c	Tue Mar 25 19:12:23 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c	Sun Apr 20 23:21:18 2003
@@ -67,12 +67,10 @@
 #include <linux/unistd.h>
 static int errno;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,0)
 /*
  * Lock protecting manipulation of the ahd softc list.
  */
 spinlock_t ahd_list_spinlock;
-#endif
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)
 struct proc_dir_entry proc_scsi_aic79xx = {
===== drivers/scsi/aic7xxx/aic79xx_osm.h 1.22 vs edited =====
--- 1.22/drivers/scsi/aic7xxx/aic79xx_osm.h	Tue Mar 25 19:12:23 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.h	Sun Apr 20 23:21:18 2003
@@ -283,7 +283,7 @@
 /***************************** SMP support ************************************/
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,17)
 #include <linux/spinlock.h>
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
+#else
 #include <linux/smp.h>
 #endif
 
@@ -532,9 +532,7 @@
 	TAILQ_HEAD(, ahd_linux_device) device_runq;
 	struct ahd_completeq	 completeq;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
 	spinlock_t		 spin_lock;
-#endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	struct tasklet_struct	 runq_tasklet;
 #endif
@@ -730,7 +728,6 @@
 static __inline void ahd_list_lock(unsigned long *flags);
 static __inline void ahd_list_unlock(unsigned long *flags);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
 static __inline void
 ahd_lockinit(struct ahd_softc *ahd)
 {
@@ -818,63 +815,6 @@
 	spin_unlock_irqrestore(&ahd_list_spinlock, *flags);
 }
 
-#else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,1,0) */
-
-ahd_lockinit(struct ahd_softc *ahd)
-{
-}
-
-static __inline void
-ahd_lock(struct ahd_softc *ahd, unsigned long *flags)
-{
-	save_flags(*flags);
-	cli();
-}
-
-static __inline void
-ahd_unlock(struct ahd_softc *ahd, unsigned long *flags)
-{
-	restore_flags(*flags);
-}
-
-ahd_done_lockinit(struct ahd_softc *ahd)
-{
-}
-
-static __inline void
-ahd_done_lock(struct ahd_softc *ahd, unsigned long *flags)
-{
-	/*
-	 * The done lock is always held while
-	 * the ahd lock is held so blocking
-	 * interrupts again would have no effect.
-	 */
-}
-
-static __inline void
-ahd_done_unlock(struct ahd_softc *ahd, unsigned long *flags)
-{
-}
-
-static __inline void
-ahd_list_lockinit()
-{
-}
-
-static __inline void
-ahd_list_lock(unsigned long *flags)
-{
-	save_flags(*flags);
-	cli();
-}
-
-static __inline void
-ahd_list_unlock(unsigned long *flags)
-{
-	restore_flags(*flags);
-}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,1,0) */
-
 /******************************* PCI Definitions ******************************/
 /*
  * PCIM_xxx: mask to locate subfield in register
@@ -945,15 +885,6 @@
 			    ahd_power_state new_state);
 
 /******************************* PCI Routines *********************************/
-/*
- * We need to use the bios32.h routines if we are kernel version 2.1.92 or less.
- */
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,1,92)
-#if defined(__sparc_v9__) || defined(__powerpc__)
-#error "PPC and Sparc platforms are only supported under 2.1.92 and above"
-#endif
-#include <linux/bios32.h>
-#endif
 
 int			 ahd_linux_pci_init(void);
 void			 ahd_linux_pci_exit(void);
--- 1.28/drivers/scsi/aic7xxx/aic7xxx_osm.c	Sun Apr 20 17:14:29 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	Sun Apr 20 23:21:18 2003
@@ -146,12 +146,10 @@
 #include <linux/unistd.h>
 static int errno;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,0)
 /*
  * Lock protecting manipulation of the ahc softc list.
  */
 spinlock_t ahc_list_spinlock;
-#endif
 
 /*
  * To generate the correct addresses for the controller to issue
===== drivers/scsi/aic7xxx/aic7xxx_osm.h 1.35 vs edited =====
--- 1.35/drivers/scsi/aic7xxx/aic7xxx_osm.h	Sun Apr 20 17:14:29 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	Sun Apr 20 23:21:18 2003
@@ -295,7 +295,7 @@
 /***************************** SMP support ************************************/
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,17)
 #include <linux/spinlock.h>
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
+#else
 #include <linux/smp.h>
 #endif
 
@@ -538,9 +538,7 @@
 	TAILQ_HEAD(, ahc_linux_device) device_runq;
 	struct ahc_completeq	 completeq;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
 	spinlock_t		 spin_lock;
-#endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	struct tasklet_struct	 runq_tasklet;
 #endif
@@ -699,7 +697,6 @@
 static __inline void ahc_list_lock(unsigned long *flags);
 static __inline void ahc_list_unlock(unsigned long *flags);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
 static __inline void
 ahc_lockinit(struct ahc_softc *ahc)
 {
@@ -785,65 +782,6 @@
 	spin_unlock_irqrestore(&ahc_list_spinlock, *flags);
 }
 
-#else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,1,93) */
-
-static __inline void
-ahc_lockinit(struct ahc_softc *ahc)
-{
-}
-
-static __inline void
-ahc_lock(struct ahc_softc *ahc, unsigned long *flags)
-{
-	save_flags(*flags);
-	cli();
-}
-
-static __inline void
-ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
-{
-	restore_flags(*flags);
-}
-
-static __inline void
-ahc_done_lockinit(struct ahc_softc *ahc)
-{
-}
-
-static __inline void
-ahc_done_lock(struct ahc_softc *ahc, unsigned long *flags)
-{
-	/*
-	 * The done lock is always held while
-	 * the ahc lock is held so blocking
-	 * interrupts again would have no effect.
-	 */
-}
-
-static __inline void
-ahc_done_unlock(struct ahc_softc *ahc, unsigned long *flags)
-{
-}
-
-static __inline void
-ahc_list_lockinit()
-{
-}
-
-static __inline void
-ahc_list_lock(unsigned long *flags)
-{
-	save_flags(*flags);
-	cli();
-}
-
-static __inline void
-ahc_list_unlock(unsigned long *flags)
-{
-	restore_flags(*flags);
-}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,1,0) */
-
 /******************************* PCI Definitions ******************************/
 /*
  * PCIM_xxx: mask to locate subfield in register
@@ -902,15 +840,6 @@
 int			 aic7770_map_int(struct ahc_softc *ahc, u_int irq);
 
 /******************************* PCI Routines *********************************/
-/*
- * We need to use the bios32.h routines if we are kernel version 2.1.92 or less.
- */
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,1,92)
-#if defined(__sparc_v9__) || defined(__powerpc__)
-#error "PPC and Sparc platforms are only supported under 2.1.92 and above"
-#endif
-#include <linux/bios32.h>
-#endif
 
 int			 ahc_linux_pci_init(void);
 void			 ahc_linux_pci_exit(void);

----- End forwarded message -----
