From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Some parisc updates for SCSI
Date: Thu, 6 Mar 2003 15:40:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030306154048.D1549@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from willy by www.linux.org.uk with local (Exim 3.33 #5)
	id 18qxUG-0008UN-00
	for linux-scsi@vger.kernel.org; Thu, 06 Mar 2003 15:40:48 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The config stanza for SCSI_ZALON was in the wrong place, so move it.
Make SCSI_NCR53C8XX conflict with SCSI_ZALON.
Give ncr53c8xx and sym53c8xx names
Fill in detach and release methods unconditionally.
Call pci_set_master() in sym53c8xx.
Both these drivers need interrupt.h, not sched.h

diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/Kconfig parisc-2.5/drivers/scsi/Kconfig
--- linus-2.5/drivers/scsi/Kconfig	Thu Mar  6 06:19:56 2003
+++ parisc-2.5/drivers/scsi/Kconfig	Thu Mar  6 07:02:07 2003
@@ -946,16 +946,6 @@ config SCSI_SYM53C8XX_2
 	  Please read <file:drivers/scsi/sym53c8xx_2/Documentation.txt> for more
 	  information.
 
-config SCSI_ZALON
-	tristate "Zalon SCSI support"
-	depends on GSC && SCSI
-	help
-	  The Zalon is a GSC/HSC bus interface chip that sits between the
-	  PA-RISC processor and the NCR 53c720 SCSI controller on C100,
-	  C110, J200, J210 and some D, K & R-class machines.  It's also
-	  used on the add-in Bluefish, Barracuda & Shrike SCSI cards.
-	  Say Y here if you have one of these machines or cards.
-
 config SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
 	int "DMA addressing mode"
 	depends on SCSI_SYM53C8XX_2
@@ -1010,9 +1000,19 @@ config SCSI_SYM53C8XX_IOMAPPED
 	  If you say Y here, the driver will preferently use normal IO rather than 
 	  memory mapped IO.
 
+config SCSI_ZALON
+	tristate "Zalon SCSI support"
+	depends on GSC && SCSI
+	help
+	  The Zalon is a GSC/HSC bus interface chip that sits between the
+	  PA-RISC processor and the NCR 53c720 SCSI controller on C100,
+	  C110, J200, J210 and some D, K & R-class machines.  It's also
+	  used on the add-in Bluefish, Barracuda & Shrike SCSI cards.
+	  Say Y here if you have one of these machines or cards.
+
 config SCSI_NCR53C8XX
 	tristate "NCR53C8XX SCSI support"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && SCSI
+	depends on PCI && SCSI_SYM53C8XX_2!=y && SCSI_ZALON!=y && SCSI
 	---help---
 	  This is the BSD ncr driver adapted to Linux for the NCR53C8XX family
 	  of PCI-SCSI controllers.  This driver supports parity checking,
diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/ncr53c8xx.c parisc-2.5/drivers/scsi/ncr53c8xx.c
--- linus-2.5/drivers/scsi/ncr53c8xx.c	Thu Mar  6 06:20:04 2003
+++ parisc-2.5/drivers/scsi/ncr53c8xx.c	Thu Mar  6 07:02:17 2003
@@ -5024,7 +5024,6 @@ static int ncr_abort_command (ncb_p np, 
 **==========================================================
 */
 
-#ifdef MODULE
 static int ncr_detach(ncb_p np)
 {
 	ccb_p cp;
@@ -5160,7 +5159,6 @@ static int ncr_detach(ncb_p np)
 
 	return 1;
 }
-#endif
 
 /*==========================================================
 **
@@ -8935,7 +8933,6 @@ out:
 }
 
 
-#ifdef MODULE
 int ncr53c8xx_release(struct Scsi_Host *host)
 {
 #ifdef DEBUG_NCR53C8XX
@@ -8945,7 +8942,6 @@ printk("ncr53c8xx : release\n");
 
      return 1;
 }
-#endif
 
 
 /*
diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/ncr53c8xx.h parisc-2.5/drivers/scsi/ncr53c8xx.h
--- linus-2.5/drivers/scsi/ncr53c8xx.h	Sun Jan  5 11:02:24 2003
+++ parisc-2.5/drivers/scsi/ncr53c8xx.h	Mon Feb 17 20:02:10 2003
@@ -60,17 +60,12 @@ const char *ncr53c8xx_info(struct Scsi_H
 int ncr53c8xx_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 int ncr53c8xx_reset(Scsi_Cmnd *, unsigned int);
 int ncr53c8xx_slave_configure(Scsi_Device *);
-
-#ifdef MODULE
 int ncr53c8xx_release(struct Scsi_Host *);
-#else
-#define ncr53c8xx_release NULL
-#endif
 
 
 #if	LINUX_VERSION_CODE >= LinuxVersionCode(2,1,75)
 
-#define NCR53C8XX {     .name           = "",			\
+#define NCR53C8XX {     .name           = "ncr53c8xx",		\
 			.detect         = ncr53c8xx_detect,	\
 			.release        = ncr53c8xx_release,	\
 			.info           = ncr53c8xx_info, 	\
diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/sym53c8xx.c parisc-2.5/drivers/scsi/sym53c8xx.c
--- linus-2.5/drivers/scsi/sym53c8xx.c	Thu Mar  6 06:20:08 2003
+++ parisc-2.5/drivers/scsi/sym53c8xx.c	Thu Mar  6 07:02:24 2003
@@ -112,8 +112,8 @@
 #include <asm/spinlock.h>
 #endif
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
 #include <linux/string.h>
@@ -7214,7 +7244,6 @@ static int ncr_abort_command (ncb_p np, 
 **==========================================================
 */
 
-#ifdef MODULE
 static int ncr_detach(ncb_p np)
 {
 	int i;
@@ -7260,7 +7289,6 @@ static int ncr_detach(ncb_p np)
 
 	return 1;
 }
-#endif
 
 /*==========================================================
 **
@@ -12958,6 +12986,7 @@ if (sym53c8xx)
 		}
 		if (i != count)	/* Ignore this device if we already have it */
 			continue;
+		pci_set_master(pcidev);
 		devp = &devtbl[count];
 		devp->host_id = driver_setup.host_id;
 		devp->attach_done = 0;
@@ -13798,7 +13827,6 @@ out:
 }
 
 
-#ifdef MODULE
 int sym53c8xx_release(struct Scsi_Host *host)
 {
 #ifdef DEBUG_SYM53C8XX
@@ -13808,7 +13836,6 @@ printk("sym53c8xx : release\n");
 
      return 1;
 }
-#endif
 
 
 /*
diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/sym53c8xx.h parisc-2.5/drivers/scsi/sym53c8xx.h
--- linus-2.5/drivers/scsi/sym53c8xx.h	Sun Jan  5 11:02:29 2003
+++ parisc-2.5/drivers/scsi/sym53c8xx.h	Mon Feb 17 20:02:12 2003
@@ -75,17 +75,11 @@ const char *sym53c8xx_info(struct Scsi_H
 int sym53c8xx_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 int sym53c8xx_reset(Scsi_Cmnd *, unsigned int);
 int sym53c8xx_slave_configure(Scsi_Device *);
-
-#ifdef MODULE
 int sym53c8xx_release(struct Scsi_Host *);
-#else
-#define sym53c8xx_release NULL
-#endif
-
 
 #if	LINUX_VERSION_CODE >= LinuxVersionCode(2,1,75)
 
-#define SYM53C8XX {     .name           = "",			\
+#define SYM53C8XX {     .name           = "sym53c8xx",		\
 			.detect         = sym53c8xx_detect,	\
 			.release        = sym53c8xx_release,	\
 			.info           = sym53c8xx_info, 	\
diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/zalon.c parisc-2.5/drivers/scsi/zalon.c
--- linus-2.5/drivers/scsi/zalon.c	Sat Jan 11 14:40:42 2003
+++ parisc-2.5/drivers/scsi/zalon.c	Mon Feb 17 20:02:12 2003
@@ -151,7 +151,6 @@ int zalon7xx_detect(Scsi_Host_Template *
 	return (hosts_used != 0);
 }
 
-#ifdef MODULE
 extern int ncr53c8xx_release(struct Scsi_Host *host);
 
 int zalon7xx_release(struct Scsi_Host *host)
@@ -160,4 +159,3 @@ int zalon7xx_release(struct Scsi_Host *h
 	unregister_parisc_driver(&zalon_driver);
 	return 1;
 }
-#endif
diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/zalon.h parisc-2.5/drivers/scsi/zalon.h
--- linus-2.5/drivers/scsi/zalon.h	Sat Jan 11 14:40:42 2003
+++ parisc-2.5/drivers/scsi/zalon.h	Mon Feb 17 20:02:12 2003
@@ -15,12 +15,7 @@ extern struct proc_dir_entry proc_scsi_z
 int zalon7xx_detect(Scsi_Host_Template *tpnt);
 const char *ncr53c8xx_info(struct Scsi_Host *host);
 int ncr53c8xx_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-
-#ifdef MODULE
 int zalon7xx_release(struct Scsi_Host *);
-#else
-#define zalon7xx_release NULL
-#endif
 
 #define GSC_SCSI_ZALON_OFFSET 0x800
 

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
