From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] remove Scsi_Host_Template typedef
Date: Mon, 31 Oct 2005 18:31:40 +0100
Message-ID: <20051031173140.GB14182@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:21662 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964801AbVJaRbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 12:31:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Index: scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- scsi-misc-2.6.orig/Documentation/scsi/scsi_mid_low_api.txt	2005-10-29 19:20:27.000000000 +0200
+++ scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt	2005-10-29 19:24:21.000000000 +0200
@@ -346,7 +346,7 @@
 struct tags. Both can be still found in the SCSI subsystem, but
 the typedefs have been moved to a single file, scsi_typedefs.h to
 make their future removal easier, for example: 
-"typedef struct scsi_host_template Scsi_Host_Template;"
+"typedef struct scsi_cmnd Scsi_Cmnd;"
 
 Also, most C99 enhancements are encouraged to the extent they are supported
 by the relevant gcc compilers. So C99 style structure and array
Index: scsi-misc-2.6/drivers/scsi/53c7xx.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/53c7xx.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/53c7xx.c	2005-10-29 19:24:21.000000000 +0200
@@ -343,7 +343,7 @@
 /* Size of event list (per host adapter) */
 static int track_events = 0;
 static struct Scsi_Host *first_host = NULL;	/* Head of list of NCR boards */
-static Scsi_Host_Template *the_template = NULL;	
+static struct scsi_host_template *the_template = NULL;
 
 /* NCR53c710 script handling code */
 
@@ -1103,7 +1103,7 @@
 }
 
 /* 
- * Function : int ncr53c7xx_init(Scsi_Host_Template *tpnt, int board, int chip,
+ * Function : int ncr53c7xx_init(struct scsi_host_template *tpnt, int board, int chip,
  *	unsigned long base, int io_port, int irq, int dma, long long options,
  *	int clock);
  *
@@ -1118,7 +1118,7 @@
  */
 
 int 
-ncr53c7xx_init (Scsi_Host_Template *tpnt, int board, int chip,
+ncr53c7xx_init (struct scsi_host_template *tpnt, int board, int chip,
     unsigned long base, int io_port, int irq, int dma, 
     long long options, int clock)
 {
Index: scsi-misc-2.6/drivers/scsi/53c7xx.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/53c7xx.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/53c7xx.h	2005-10-29 19:24:21.000000000 +0200
@@ -1600,7 +1600,7 @@
 /* Paranoid people could use panic() here. */
 #define FATAL(host) shutdown((host));
 
-extern int ncr53c7xx_init(Scsi_Host_Template *tpnt, int board, int chip,
+extern int ncr53c7xx_init(struct scsi_host_template *tpnt, int board, int chip,
 			  unsigned long base, int io_port, int irq, int dma,
 			  long long options, int clock);
 
Index: scsi-misc-2.6/drivers/scsi/NCR53C9x.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/NCR53C9x.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/NCR53C9x.c	2005-10-29 19:24:21.000000000 +0200
@@ -529,7 +529,7 @@
 /* Allocate structure and insert basic data such as SCSI chip frequency
  * data and a pointer to the device
  */
-struct NCR_ESP* esp_allocate(Scsi_Host_Template *tpnt, void *esp_dev)
+struct NCR_ESP* esp_allocate(struct scsi_host_template *tpnt, void *esp_dev)
 {
 	struct NCR_ESP *esp, *elink;
 	struct Scsi_Host *esp_host;
Index: scsi-misc-2.6/drivers/scsi/NCR53C9x.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/NCR53C9x.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/NCR53C9x.h	2005-10-29 19:24:21.000000000 +0200
@@ -653,7 +653,7 @@
 
 /* External functions */
 extern void esp_bootup_reset(struct NCR_ESP *esp, struct ESP_regs *eregs);
-extern struct NCR_ESP *esp_allocate(Scsi_Host_Template *, void *);
+extern struct NCR_ESP *esp_allocate(struct scsi_host_template *, void *);
 extern void esp_deallocate(struct NCR_ESP *);
 extern void esp_release(void);
 extern void esp_initialize(struct NCR_ESP *);
Index: scsi-misc-2.6/drivers/scsi/NCR53c406a.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/NCR53c406a.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/NCR53c406a.c	2005-10-29 19:24:21.000000000 +0200
@@ -447,7 +447,7 @@
 }
 #endif				/* USE_PIO */
 
-static int __init NCR53c406a_detect(Scsi_Host_Template * tpnt)
+static int __init NCR53c406a_detect(struct scsi_host_template * tpnt)
 {
 	int present = 0;
 	struct Scsi_Host *shpnt = NULL;
@@ -1057,7 +1057,7 @@
  * Use SG_NONE if DMA mode is enabled!
  */
 
-static Scsi_Host_Template driver_template = 
+static struct scsi_host_template driver_template =
 {
      .proc_name         	= "NCR53c406a"		/* proc_name */,        
      .name              	= "NCR53c406a"		/* name */,             
Index: scsi-misc-2.6/drivers/scsi/a2091.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/a2091.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/a2091.c	2005-10-29 19:24:21.000000000 +0200
@@ -173,7 +173,7 @@
     }
 }
 
-int __init a2091_detect(Scsi_Host_Template *tpnt)
+int __init a2091_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     struct Scsi_Host *instance;
@@ -234,7 +234,7 @@
 
 #define HOSTS_C
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "A2901",
 	.name			= "Commodore A2091/A590 SCSI",
 	.detect			= a2091_detect,
Index: scsi-misc-2.6/drivers/scsi/a2091.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/a2091.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/a2091.h	2005-10-29 19:24:22.000000000 +0200
@@ -11,7 +11,7 @@
 
 #include <linux/types.h>
 
-int a2091_detect(Scsi_Host_Template *);
+int a2091_detect(struct scsi_host_template *);
 int a2091_release(struct Scsi_Host *);
 const char *wd33c93_info(void);
 int wd33c93_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
Index: scsi-misc-2.6/drivers/scsi/a3000.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/a3000.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/a3000.c	2005-10-29 19:24:22.000000000 +0200
@@ -168,7 +168,7 @@
     }
 }
 
-int __init a3000_detect(Scsi_Host_Template *tpnt)
+int __init a3000_detect(struct scsi_host_template *tpnt)
 {
     wd33c93_regs regs;
 
@@ -221,7 +221,7 @@
 
 #define HOSTS_C
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "A3000",
 	.name			= "Amiga 3000 built-in SCSI",
 	.detect			= a3000_detect,
Index: scsi-misc-2.6/drivers/scsi/a3000.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/a3000.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/a3000.h	2005-10-29 19:24:22.000000000 +0200
@@ -11,7 +11,7 @@
 
 #include <linux/types.h>
 
-int a3000_detect(Scsi_Host_Template *);
+int a3000_detect(struct scsi_host_template *);
 int a3000_release(struct Scsi_Host *);
 const char *wd33c93_info(void);
 int wd33c93_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
Index: scsi-misc-2.6/drivers/scsi/advansys.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/advansys.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/advansys.c	2005-10-29 19:24:22.000000000 +0200
@@ -114,7 +114,7 @@
           #include "advansys.h"
           #endif
 
-        and after "static Scsi_Host_Template builtin_scsi_hosts[] =":
+        and after "static struct scsi_host_template builtin_scsi_hosts[] =":
 
           #ifdef CONFIG_SCSI_ADVANSYS
           ADVANSYS,
@@ -160,7 +160,7 @@
            --- Driver Structures
            --- Driver Data
            --- Driver Function Prototypes
-           --- Linux 'Scsi_Host_Template' and advansys_setup() Functions
+           --- Linux 'struct scsi_host_template' and advansys_setup() Functions
            --- Loadable Driver Support
            --- Miscellaneous Driver Functions
            --- Functions Required by the Asc Library
@@ -4068,7 +4068,7 @@
 
 
 /*
- * --- Linux 'Scsi_Host_Template' and advansys_setup() Functions
+ * --- Linux 'struct scsi_host_template' and advansys_setup() Functions
  */
 
 #ifdef CONFIG_PROC_FS
Index: scsi-misc-2.6/drivers/scsi/advansys.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/advansys.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/advansys.h	2005-10-29 19:24:22.000000000 +0200
@@ -19,7 +19,7 @@
 #define _ADVANSYS_H
 
 /*
- * Scsi_Host_Template function prototypes.
+ * struct scsi_host_template function prototypes.
  */
 int advansys_detect(struct scsi_host_template *);
 int advansys_release(struct Scsi_Host *);
Index: scsi-misc-2.6/drivers/scsi/aha152x.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aha152x.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aha152x.c	2005-10-29 19:24:22.000000000 +0200
@@ -424,7 +424,7 @@
 
 static int registered_count=0;
 static struct Scsi_Host *aha152x_host[2];
-static Scsi_Host_Template aha152x_driver_template;
+static struct scsi_host_template aha152x_driver_template;
 
 /*
  * internal states of the host
@@ -3464,7 +3464,7 @@
 	return thislength < length ? thislength : length;
 }
 
-static Scsi_Host_Template aha152x_driver_template = {
+static struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
 	.proc_name			= "aha152x",
Index: scsi-misc-2.6/drivers/scsi/aha1542.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aha1542.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aha1542.c	2005-10-29 19:24:22.000000000 +0200
@@ -1023,7 +1023,7 @@
 #endif
 
 /* return non-zero on detection */
-static int __init aha1542_detect(Scsi_Host_Template * tpnt)
+static int __init aha1542_detect(struct scsi_host_template * tpnt)
 {
 	unsigned char dma_chan;
 	unsigned char irq_level;
@@ -1801,7 +1801,7 @@
 MODULE_LICENSE("GPL");
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "aha1542",
 	.name			= "Adaptec 1542",
 	.detect			= aha1542_detect,
Index: scsi-misc-2.6/drivers/scsi/aha1542.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aha1542.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aha1542.h	2005-10-29 19:24:22.000000000 +0200
@@ -131,7 +131,7 @@
 				/* REQUEST SENSE */
 };
 
-static int aha1542_detect(Scsi_Host_Template *);
+static int aha1542_detect(struct scsi_host_template *);
 static int aha1542_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int aha1542_bus_reset(Scsi_Cmnd * SCpnt);
 static int aha1542_dev_reset(Scsi_Cmnd * SCpnt);
Index: scsi-misc-2.6/drivers/scsi/aha1740.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aha1740.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aha1740.c	2005-10-29 19:24:22.000000000 +0200
@@ -570,7 +570,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template aha1740_template = {
+static struct scsi_host_template aha1740_template = {
 	.module           = THIS_MODULE,
 	.proc_name        = "aha1740",
 	.proc_info        = aha1740_proc_info,
Index: scsi-misc-2.6/drivers/scsi/ahci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ahci.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ahci.c	2005-10-29 19:24:22.000000000 +0200
@@ -196,7 +196,7 @@
 static inline int ahci_host_intr(struct ata_port *ap, struct ata_queued_cmd *qc);
 static void ahci_remove_one (struct pci_dev *pdev);
 
-static Scsi_Host_Template ahci_sht = {
+static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/aic7xxx_old.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx_old.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx_old.c	2005-10-29 19:24:22.000000000 +0200
@@ -7865,7 +7865,7 @@
  *   Register a Adaptec aic7xxx chip SCSI controller with the kernel.
  *-F*************************************************************************/
 static int
-aic7xxx_register(Scsi_Host_Template *template, struct aic7xxx_host *p,
+aic7xxx_register(struct scsi_host_template *template, struct aic7xxx_host *p,
   int reset_delay)
 {
   int i, result;
@@ -8412,7 +8412,7 @@
  *   and a pointer to a aic7xxx_host struct upon success.
  *-F*************************************************************************/
 static struct aic7xxx_host *
-aic7xxx_alloc(Scsi_Host_Template *sht, struct aic7xxx_host *temp)
+aic7xxx_alloc(struct scsi_host_template *sht, struct aic7xxx_host *temp)
 {
   struct aic7xxx_host *p = NULL;
   struct Scsi_Host *host;
@@ -8992,7 +8992,7 @@
  *       mid-level SCSI code is overhauled.
  *-F*************************************************************************/
 static int
-aic7xxx_detect(Scsi_Host_Template *template)
+aic7xxx_detect(struct scsi_host_template *template)
 {
   struct aic7xxx_host *temp_p = NULL;
   struct aic7xxx_host *current_p = NULL;
@@ -11162,7 +11162,7 @@
 MODULE_VERSION(AIC7XXX_H_VERSION);
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_info		= aic7xxx_proc_info,
 	.detect			= aic7xxx_detect,
 	.release		= aic7xxx_release,
Index: scsi-misc-2.6/drivers/scsi/amiga7xx.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/amiga7xx.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/amiga7xx.c	2005-10-29 19:24:22.000000000 +0200
@@ -30,7 +30,7 @@
 #include "amiga7xx.h"
 
 
-static int amiga7xx_register_one(Scsi_Host_Template *tpnt,
+static int amiga7xx_register_one(struct scsi_host_template *tpnt,
 				 unsigned long address)
 {
     long long options;
@@ -66,7 +66,7 @@
     { 0 }
 };
 
-static int __init amiga7xx_zorro_detect(Scsi_Host_Template *tpnt)
+static int __init amiga7xx_zorro_detect(struct scsi_host_template *tpnt)
 {
     int num = 0, i;
     struct zorro_dev *z = NULL;
@@ -90,7 +90,7 @@
 #endif /* CONFIG_ZORRO */
 
 
-int __init amiga7xx_detect(Scsi_Host_Template *tpnt)
+int __init amiga7xx_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     int num = 0;
@@ -123,7 +123,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "Amiga NCR53c710 SCSI",
 	.detect			= amiga7xx_detect,
 	.release		= amiga7xx_release,
Index: scsi-misc-2.6/drivers/scsi/amiga7xx.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/amiga7xx.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/amiga7xx.h	2005-10-29 19:24:22.000000000 +0200
@@ -2,7 +2,7 @@
 
 #include <linux/types.h>
 
-int amiga7xx_detect(Scsi_Host_Template *);
+int amiga7xx_detect(struct scsi_host_template *);
 const char *NCR53c7x0_info(void);
 int NCR53c7xx_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 int NCR53c7xx_abort(Scsi_Cmnd *);
Index: scsi-misc-2.6/drivers/scsi/arm/acornscsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/acornscsi.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/acornscsi.c	2005-10-29 19:24:22.000000000 +0200
@@ -2971,7 +2971,7 @@
     return pos;
 }
 
-static Scsi_Host_Template acornscsi_template = {
+static struct scsi_host_template acornscsi_template = {
 	.module			= THIS_MODULE,
 	.proc_info		= acornscsi_proc_info,
 	.name			= "AcornSCSI",
Index: scsi-misc-2.6/drivers/scsi/arm/arxescsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/arxescsi.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/arxescsi.c	2005-10-29 19:24:22.000000000 +0200
@@ -261,7 +261,7 @@
 	return pos;
 }
 
-static Scsi_Host_Template arxescsi_template = {
+static struct scsi_host_template arxescsi_template = {
 	.proc_info			= arxescsi_proc_info,
 	.name				= "ARXE SCSI card",
 	.info				= arxescsi_info,
Index: scsi-misc-2.6/drivers/scsi/arm/cumana_1.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/cumana_1.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/cumana_1.c	2005-10-29 19:24:22.000000000 +0200
@@ -238,7 +238,7 @@
 
 #include "../NCR5380.c"
 
-static Scsi_Host_Template cumanascsi_template = {
+static struct scsi_host_template cumanascsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Cumana 16-bit SCSI",
 	.info			= cumanascsi_info,
Index: scsi-misc-2.6/drivers/scsi/arm/cumana_2.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/cumana_2.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/cumana_2.c	2005-10-29 19:24:22.000000000 +0200
@@ -381,7 +381,7 @@
 	return pos;
 }
 
-static Scsi_Host_Template cumanascsi2_template = {
+static struct scsi_host_template cumanascsi2_template = {
 	.module				= THIS_MODULE,
 	.proc_info			= cumanascsi_2_proc_info,
 	.name				= "Cumana SCSI II",
Index: scsi-misc-2.6/drivers/scsi/arm/ecoscsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/ecoscsi.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/ecoscsi.c	2005-10-29 19:24:22.000000000 +0200
@@ -155,7 +155,7 @@
 
 #include "../NCR5380.c"
 
-static Scsi_Host_Template ecoscsi_template =  {
+static struct scsi_host_template ecoscsi_template =  {
 	.module		= THIS_MODULE,
 	.name		= "Serial Port EcoSCSI NCR5380",
 	.proc_name	= "ecoscsi",
Index: scsi-misc-2.6/drivers/scsi/arm/eesox.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/eesox.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/eesox.c	2005-10-29 19:24:22.000000000 +0200
@@ -499,7 +499,7 @@
 static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 		   eesoxscsi_show_term, eesoxscsi_store_term);
 
-static Scsi_Host_Template eesox_template = {
+static struct scsi_host_template eesox_template = {
 	.module				= THIS_MODULE,
 	.proc_info			= eesoxscsi_proc_info,
 	.name				= "EESOX SCSI",
Index: scsi-misc-2.6/drivers/scsi/arm/oak.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/oak.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/oak.c	2005-10-29 19:24:22.000000000 +0200
@@ -111,7 +111,7 @@
 
 #include "../NCR5380.c"
 
-static Scsi_Host_Template oakscsi_template = {
+static struct scsi_host_template oakscsi_template = {
 	.module			= THIS_MODULE,
 	.proc_info		= oakscsi_proc_info,
 	.name			= "Oak 16-bit SCSI",
Index: scsi-misc-2.6/drivers/scsi/arm/powertec.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/powertec.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/powertec.c	2005-10-29 19:24:22.000000000 +0200
@@ -293,7 +293,7 @@
 static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 		   powertecscsi_show_term, powertecscsi_store_term);
 
-static Scsi_Host_Template powertecscsi_template = {
+static struct scsi_host_template powertecscsi_template = {
 	.module				= THIS_MODULE,
 	.proc_info			= powertecscsi_proc_info,
 	.name				= "PowerTec SCSI",
Index: scsi-misc-2.6/drivers/scsi/ata_piix.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ata_piix.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ata_piix.c	2005-10-29 19:24:22.000000000 +0200
@@ -127,7 +127,7 @@
 	.remove			= ata_pci_remove_one,
 };
 
-static Scsi_Host_Template piix_sht = {
+static struct scsi_host_template piix_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/atari_NCR5380.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/atari_NCR5380.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/atari_NCR5380.c	2005-10-29 19:24:22.000000000 +0200
@@ -255,7 +255,7 @@
  */
 
 static struct Scsi_Host *first_instance = NULL;
-static Scsi_Host_Template *the_template = NULL;
+static struct scsi_host_template *the_template = NULL;
 
 /* Macros ease life... :-) */
 #define	SETUP_HOSTDATA(in)				\
Index: scsi-misc-2.6/drivers/scsi/atari_scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/atari_scsi.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/atari_scsi.c	2005-10-29 19:24:22.000000000 +0200
@@ -600,7 +600,7 @@
 #endif
 
 
-int atari_scsi_detect (Scsi_Host_Template *host)
+int atari_scsi_detect (struct scsi_host_template *host)
 {
 	static int called = 0;
 	struct Scsi_Host *instance;
@@ -1141,7 +1141,7 @@
 
 #include "atari_NCR5380.c"
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_info		= atari_scsi_proc_info,
 	.name			= "Atari native SCSI",
 	.detect			= atari_scsi_detect,
Index: scsi-misc-2.6/drivers/scsi/atari_scsi.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/atari_scsi.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/atari_scsi.h	2005-10-29 19:24:22.000000000 +0200
@@ -18,7 +18,7 @@
 /* (I_HAVE_OVERRUNS stuff removed) */
 
 #ifndef ASM
-int atari_scsi_detect (Scsi_Host_Template *);
+int atari_scsi_detect (struct scsi_host_template *);
 const char *atari_scsi_info (struct Scsi_Host *);
 int atari_scsi_reset (Scsi_Cmnd *, unsigned int);
 #ifdef MODULE
Index: scsi-misc-2.6/drivers/scsi/blz1230.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/blz1230.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/blz1230.c	2005-10-29 19:24:22.000000000 +0200
@@ -94,7 +94,7 @@
 				 */
 
 /***************************************************************** Detection */
-int __init blz1230_esp_detect(Scsi_Host_Template *tpnt)
+int __init blz1230_esp_detect(struct scsi_host_template *tpnt)
 {
 	struct NCR_ESP *esp;
 	struct zorro_dev *z = NULL;
@@ -328,7 +328,7 @@
 }
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-blz1230",
 	.proc_info		= esp_proc_info,
 	.name			= "Blizzard1230 SCSI IV",
Index: scsi-misc-2.6/drivers/scsi/blz2060.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/blz2060.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/blz2060.c	2005-10-29 19:24:22.000000000 +0200
@@ -90,7 +90,7 @@
 				 */
 
 /***************************************************************** Detection */
-int __init blz2060_esp_detect(Scsi_Host_Template *tpnt)
+int __init blz2060_esp_detect(struct scsi_host_template *tpnt)
 {
 	struct NCR_ESP *esp;
 	struct zorro_dev *z = NULL;
@@ -282,7 +282,7 @@
 }
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-blz2060",
 	.proc_info		= esp_proc_info,
 	.name			= "Blizzard2060 SCSI",
Index: scsi-misc-2.6/drivers/scsi/bvme6000.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/bvme6000.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/bvme6000.c	2005-10-29 19:24:22.000000000 +0200
@@ -24,7 +24,7 @@
 #include<linux/stat.h>
 
 
-int bvme6000_scsi_detect(Scsi_Host_Template *tpnt)
+int bvme6000_scsi_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     int clock;
@@ -60,7 +60,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "BVME6000 NCR53c710 SCSI",
 	.detect			= bvme6000_scsi_detect,
 	.release		= bvme6000_scsi_release,
Index: scsi-misc-2.6/drivers/scsi/bvme6000.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/bvme6000.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/bvme6000.h	2005-10-29 19:24:22.000000000 +0200
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 
-int bvme6000_scsi_detect(Scsi_Host_Template *);
+int bvme6000_scsi_detect(struct scsi_host_template *);
 const char *NCR53c7x0_info(void);
 int NCR53c7xx_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 int NCR53c7xx_abort(Scsi_Cmnd *);
Index: scsi-misc-2.6/drivers/scsi/cyberstorm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/cyberstorm.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/cyberstorm.c	2005-10-29 19:24:22.000000000 +0200
@@ -104,7 +104,7 @@
 				 */
 
 /***************************************************************** Detection */
-int __init cyber_esp_detect(Scsi_Host_Template *tpnt)
+int __init cyber_esp_detect(struct scsi_host_template *tpnt)
 {
 	struct NCR_ESP *esp;
 	struct zorro_dev *z = NULL;
@@ -353,7 +353,7 @@
 }
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-cyberstorm",
 	.proc_info		= esp_proc_info,
 	.name			= "CyberStorm SCSI",
Index: scsi-misc-2.6/drivers/scsi/cyberstormII.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/cyberstormII.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/cyberstormII.c	2005-10-29 19:24:22.000000000 +0200
@@ -81,7 +81,7 @@
 				 */
 
 /***************************************************************** Detection */
-int __init cyberII_esp_detect(Scsi_Host_Template *tpnt)
+int __init cyberII_esp_detect(struct scsi_host_template *tpnt)
 {
 	struct NCR_ESP *esp;
 	struct zorro_dev *z = NULL;
@@ -290,7 +290,7 @@
 }
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-cyberstormII",
 	.proc_info		= esp_proc_info,
 	.name			= "CyberStorm Mk II SCSI",
Index: scsi-misc-2.6/drivers/scsi/dec_esp.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/dec_esp.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/dec_esp.c	2005-10-29 19:24:22.000000000 +0200
@@ -133,7 +133,7 @@
 #include "scsi_module.c"
 
 /***************************************************************** Detection */
-static int dec_esp_detect(Scsi_Host_Template * tpnt)
+static int dec_esp_detect(struct scsi_host_template * tpnt)
 {
 	struct NCR_ESP *esp;
 	struct ConfigDev *esp_dev;
Index: scsi-misc-2.6/drivers/scsi/dpti.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/dpti.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/dpti.h	2005-10-29 19:24:22.000000000 +0200
@@ -44,7 +44,7 @@
 
 
 /*
- * Scsi_Host_Template (see hosts.h) 
+ * struct scsi_host_template (see hosts.h)
  */
 
 #define DPT_DRIVER_NAME	"Adaptec I2O RAID"
Index: scsi-misc-2.6/drivers/scsi/dtc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/dtc.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/dtc.c	2005-10-29 19:24:22.000000000 +0200
@@ -199,7 +199,7 @@
 #endif
 
 /* 
- * Function : int dtc_detect(Scsi_Host_Template * tpnt)
+ * Function : int dtc_detect(struct scsi_host_template * tpnt)
  *
  * Purpose : detects and initializes DTC 3180/3280 controllers
  *	that were autoprobed, overridden on the LILO command line, 
@@ -211,7 +211,7 @@
  *
 */
 
-static int __init dtc_detect(Scsi_Host_Template * tpnt)
+static int __init dtc_detect(struct scsi_host_template * tpnt)
 {
 	static int current_override = 0, current_base = 0;
 	struct Scsi_Host *instance;
@@ -471,7 +471,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name				= "DTC 3180/3280 ",
 	.detect				= dtc_detect,
 	.release			= dtc_release,
Index: scsi-misc-2.6/drivers/scsi/dtc.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/dtc.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/dtc.h	2005-10-29 19:24:22.000000000 +0200
@@ -35,7 +35,7 @@
 static int dtc_abort(Scsi_Cmnd *);
 static int dtc_biosparam(struct scsi_device *, struct block_device *,
 		         sector_t, int*);
-static int dtc_detect(Scsi_Host_Template *);
+static int dtc_detect(struct scsi_host_template *);
 static int dtc_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int dtc_bus_reset(Scsi_Cmnd *);
 
Index: scsi-misc-2.6/drivers/scsi/fastlane.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/fastlane.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/fastlane.c	2005-10-29 19:24:22.000000000 +0200
@@ -125,7 +125,7 @@
 }
 
 /***************************************************************** Detection */
-int __init fastlane_esp_detect(Scsi_Host_Template *tpnt)
+int __init fastlane_esp_detect(struct scsi_host_template *tpnt)
 {
 	struct NCR_ESP *esp;
 	struct zorro_dev *z = NULL;
@@ -398,7 +398,7 @@
 }
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-fastlane",
 	.proc_info		= esp_proc_info,
 	.name			= "Fastlane SCSI",
Index: scsi-misc-2.6/drivers/scsi/fcal.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/fcal.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/fcal.c	2005-10-29 19:24:22.000000000 +0200
@@ -89,7 +89,7 @@
 
 /* Detect all FC Arbitrated Loops attached to the machine.
    fc4 module has done all the work for us... */
-int __init fcal_detect(Scsi_Host_Template *tpnt)
+int __init fcal_detect(struct scsi_host_template *tpnt)
 {
 	int nfcals = 0;
 	fc_channel *fc;
@@ -297,7 +297,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "Fibre Channel Arbitrated Loop",
 	.detect			= fcal_detect,
 	.release		= fcal_release,	
Index: scsi-misc-2.6/drivers/scsi/fcal.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/fcal.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/fcal.h	2005-10-29 19:24:22.000000000 +0200
@@ -20,7 +20,7 @@
    for a particular channel */
 #define FCAL_CAN_QUEUE		512
 
-int fcal_detect(Scsi_Host_Template *);
+int fcal_detect(struct scsi_host_template *);
 int fcal_release(struct Scsi_Host *);
 int fcal_slave_configure(Scsi_Device *);
 
Index: scsi-misc-2.6/drivers/scsi/fd_mcs.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/fd_mcs.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/fd_mcs.c	2005-10-29 19:24:22.000000000 +0200
@@ -343,7 +343,7 @@
 		outb(0x01 | PARITY_MASK, TMC_Cntl_port);
 }
 
-static int fd_mcs_detect(Scsi_Host_Template * tpnt)
+static int fd_mcs_detect(struct scsi_host_template * tpnt)
 {
 	int loop;
 	struct Scsi_Host *shpnt;
@@ -1343,7 +1343,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name			= "fd_mcs",
 	.proc_info			= fd_mcs_proc_info,
 	.detect				= fd_mcs_detect,
Index: scsi-misc-2.6/drivers/scsi/g_NCR5380.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/g_NCR5380.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/g_NCR5380.c	2005-10-29 19:24:22.000000000 +0200
@@ -285,7 +285,7 @@
  *	Locks: none
  */
 
-int __init generic_NCR5380_detect(Scsi_Host_Template * tpnt)
+int __init generic_NCR5380_detect(struct scsi_host_template * tpnt)
 {
 	static int current_override = 0;
 	int count, i;
@@ -899,7 +899,7 @@
 #undef PRINTP
 #undef ANDP
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_info      	= generic_NCR5380_proc_info,
 	.name           	= "Generic NCR5380/NCR53C400 Scsi Driver",
 	.detect         	= generic_NCR5380_detect,
Index: scsi-misc-2.6/drivers/scsi/g_NCR5380.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/g_NCR5380.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/g_NCR5380.h	2005-10-29 19:24:22.000000000 +0200
@@ -45,7 +45,7 @@
 
 #ifndef ASM
 static int generic_NCR5380_abort(Scsi_Cmnd *);
-static int generic_NCR5380_detect(Scsi_Host_Template *);
+static int generic_NCR5380_detect(struct scsi_host_template *);
 static int generic_NCR5380_release_resources(struct Scsi_Host *);
 static int generic_NCR5380_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int generic_NCR5380_bus_reset(Scsi_Cmnd *);
Index: scsi-misc-2.6/drivers/scsi/gdth.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gdth.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gdth.c	2005-10-29 19:24:22.000000000 +0200
@@ -94,7 +94,7 @@
  * Bugfix free_irq()
  *
  * Revision 1.56  2001/08/09 11:19:39  achim
- * Scsi_Host_Template changes
+ * struct scsi_host_template changes
  *
  * Revision 1.55  2001/08/09 10:11:28  achim
  * Command HOST_UNFREEZE_IO before cache service init.
@@ -4153,7 +4153,7 @@
     return 1;
 }
 
-static int __init gdth_detect(Scsi_Host_Template *shtp)
+static int __init gdth_detect(struct scsi_host_template *shtp)
 {
     struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
@@ -5683,7 +5683,7 @@
     return NOTIFY_OK;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
         .proc_name              = "gdth", 
         .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
Index: scsi-misc-2.6/drivers/scsi/gvp11.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gvp11.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gvp11.c	2005-10-29 19:24:22.000000000 +0200
@@ -170,7 +170,7 @@
 
 #define CHECK_WD33C93
 
-int __init gvp11_detect(Scsi_Host_Template *tpnt)
+int __init gvp11_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     struct Scsi_Host *instance;
@@ -362,7 +362,7 @@
 
 #include "gvp11.h"
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "GVP11",
 	.name			= "GVP Series II SCSI",
 	.detect			= gvp11_detect,
Index: scsi-misc-2.6/drivers/scsi/gvp11.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gvp11.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gvp11.h	2005-10-29 19:24:22.000000000 +0200
@@ -11,7 +11,7 @@
 
 #include <linux/types.h>
 
-int gvp11_detect(Scsi_Host_Template *);
+int gvp11_detect(struct scsi_host_template *);
 int gvp11_release(struct Scsi_Host *);
 const char *wd33c93_info(void);
 int wd33c93_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
Index: scsi-misc-2.6/drivers/scsi/ibmmca.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ibmmca.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ibmmca.c	2005-10-29 19:24:22.000000000 +0200
@@ -498,7 +498,7 @@
 static int probe_display(int);
 static int probe_bus_mode(int);
 static int device_exists(int, int, int *, int *);
-static struct Scsi_Host *ibmmca_register(Scsi_Host_Template *, int, int, int, char *);
+static struct Scsi_Host *ibmmca_register(struct scsi_host_template *, int, int, int, char *);
 static int option_setup(char *);
 /* local functions needed for proc_info */
 static int ldn_access_load(int, int);
@@ -1489,7 +1489,7 @@
 	return len;
 }
 
-int ibmmca_detect(Scsi_Host_Template * scsi_template)
+int ibmmca_detect(struct scsi_host_template * scsi_template)
 {
 	struct Scsi_Host *shpnt;
 	int port, id, i, j, k, list_size, slot;
@@ -1742,7 +1742,7 @@
 	return found;		/* return the number of found SCSI hosts. Should be 1 or 0. */
 }
 
-static struct Scsi_Host *ibmmca_register(Scsi_Host_Template * scsi_template, int port, int id, int adaptertype, char *hostname)
+static struct Scsi_Host *ibmmca_register(struct scsi_host_template * scsi_template, int port, int id, int adaptertype, char *hostname)
 {
 	struct Scsi_Host *shpnt;
 	int i, j;
@@ -2500,7 +2500,7 @@
 
 __setup("ibmmcascsi=", option_setup);
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
           .proc_name      = "ibmmca",
 	  .proc_info	  = ibmmca_proc_info,
           .name           = "IBM SCSI-Subsystem",
Index: scsi-misc-2.6/drivers/scsi/ibmmca.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ibmmca.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ibmmca.h	2005-10-29 19:24:22.000000000 +0200
@@ -11,7 +11,7 @@
 /* Common forward declarations for all Linux-versions: */
 
 /* Interfaces to the midlevel Linux SCSI driver */
-static int ibmmca_detect (Scsi_Host_Template *);
+static int ibmmca_detect (struct scsi_host_template *);
 static int ibmmca_release (struct Scsi_Host *);
 static int ibmmca_queuecommand (Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
 static int ibmmca_abort (Scsi_Cmnd *);
Index: scsi-misc-2.6/drivers/scsi/in2000.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/in2000.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/in2000.c	2005-10-29 19:24:22.000000000 +0200
@@ -1899,7 +1899,7 @@
 };
 
 
-static int __init in2000_detect(Scsi_Host_Template * tpnt)
+static int __init in2000_detect(struct scsi_host_template * tpnt)
 {
 	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hostdata;
@@ -2305,7 +2305,7 @@
 MODULE_LICENSE("GPL");
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name       		= "in2000",
 	.proc_info       		= in2000_proc_info,
 	.name            		= "Always IN2000",
Index: scsi-misc-2.6/drivers/scsi/in2000.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/in2000.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/in2000.h	2005-10-29 19:24:22.000000000 +0200
@@ -395,7 +395,7 @@
 # define CLISPIN_UNLOCK(host,flags) spin_unlock_irqrestore(host->host_lock, \
 							   flags)
 
-static int in2000_detect(Scsi_Host_Template *) in2000__INIT;
+static int in2000_detect(struct scsi_host_template *) in2000__INIT;
 static int in2000_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int in2000_abort(Scsi_Cmnd *);
 static void in2000_setup(char *, int *) in2000__INIT;
Index: scsi-misc-2.6/drivers/scsi/ips.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ips.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ips.c	2005-10-29 19:24:22.000000000 +0200
@@ -247,7 +247,7 @@
 /*
  * Function prototypes
  */
-static int ips_detect(Scsi_Host_Template *);
+static int ips_detect(struct scsi_host_template *);
 static int ips_release(struct Scsi_Host *);
 static int ips_eh_abort(Scsi_Cmnd *);
 static int ips_eh_reset(Scsi_Cmnd *);
@@ -375,7 +375,7 @@
 static dma_addr_t ips_flashbusaddr;
 static long ips_FlashDataInUse;		/* CD Boot - Flash Data In Use Flag */
 static uint32_t MaxLiteCmds = 32;	/* Max Active Cmds for a Lite Adapter */
-static Scsi_Host_Template ips_driver_template = {
+static struct scsi_host_template ips_driver_template = {
 	.detect			= ips_detect,
 	.release		= ips_release,
 	.info			= ips_info,
@@ -587,7 +587,7 @@
 /*                                                                          */
 /****************************************************************************/
 static int
-ips_detect(Scsi_Host_Template * SHT)
+ips_detect(struct scsi_host_template * SHT)
 {
 	int i;
 
Index: scsi-misc-2.6/drivers/scsi/jazz_esp.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/jazz_esp.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/jazz_esp.c	2005-10-29 19:24:22.000000000 +0200
@@ -52,7 +52,7 @@
 				 * via PIO.
 				 */
 
-int jazz_esp_detect(Scsi_Host_Template *tpnt);
+int jazz_esp_detect(struct scsi_host_template *tpnt);
 static int jazz_esp_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
@@ -65,7 +65,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "jazz_esp",
 	.proc_info		= &esp_proc_info,
 	.name			= "ESP 100/100a/200",
Index: scsi-misc-2.6/drivers/scsi/mac_esp.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/mac_esp.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/mac_esp.c	2005-10-29 19:24:22.000000000 +0200
@@ -300,7 +300,7 @@
  * Model dependent ESP setup
  */
 
-int mac_esp_detect(Scsi_Host_Template * tpnt)
+int mac_esp_detect(struct scsi_host_template * tpnt)
 {
 	int quick = 0;
 	int chipnum, chipspresent = 0;
@@ -730,7 +730,7 @@
 #endif
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "mac_esp",
 	.name			= "Mac 53C9x SCSI",
 	.detect			= mac_esp_detect,
Index: scsi-misc-2.6/drivers/scsi/mac_scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/mac_scsi.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/mac_scsi.c	2005-10-29 19:24:22.000000000 +0200
@@ -222,7 +222,7 @@
 #endif
 
 /*
- * Function : int macscsi_detect(Scsi_Host_Template * tpnt)
+ * Function : int macscsi_detect(struct scsi_host_template * tpnt)
  *
  * Purpose : initializes mac NCR5380 driver based on the
  *	command line / compile time port and irq definitions.
@@ -233,7 +233,7 @@
  *
  */
  
-int macscsi_detect(Scsi_Host_Template * tpnt)
+int macscsi_detect(struct scsi_host_template * tpnt)
 {
     static int called = 0;
     int flags = 0;
@@ -581,7 +581,7 @@
 
 #include "NCR5380.c"
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name			= "Mac5380",
 	.proc_info			= macscsi_proc_info,
 	.name				= "Macintosh NCR5380 SCSI",
Index: scsi-misc-2.6/drivers/scsi/mca_53c9x.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/mca_53c9x.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/mca_53c9x.c	2005-10-29 19:24:22.000000000 +0200
@@ -103,7 +103,7 @@
 static struct ESP_regs eregs;
 
 /***************************************************************** Detection */
-static int mca_esp_detect(Scsi_Host_Template *tpnt)
+static int mca_esp_detect(struct scsi_host_template *tpnt)
 {
 	struct NCR_ESP *esp;
 	static int io_port_by_pos[] = MCA_53C9X_IO_PORTS;
@@ -444,7 +444,7 @@
 	outb(inb(PS2_SYS_CTR) & 0x3f, PS2_SYS_CTR);
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "mca_53c9x",
 	.name			= "NCR 53c9x SCSI",
 	.detect			= mca_esp_detect,
Index: scsi-misc-2.6/drivers/scsi/mvme147.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/mvme147.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/mvme147.c	2005-10-29 19:24:22.000000000 +0200
@@ -64,7 +64,7 @@
     m147_pcc->dma_cntrl = 0;
 }
 
-int mvme147_detect(Scsi_Host_Template *tpnt)
+int mvme147_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     wd33c93_regs regs;
@@ -131,7 +131,7 @@
 
 #include "mvme147.h"
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "MVME147",
 	.name			= "MVME147 built-in SCSI",
 	.detect			= mvme147_detect,
Index: scsi-misc-2.6/drivers/scsi/mvme147.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/mvme147.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/mvme147.h	2005-10-29 19:24:22.000000000 +0200
@@ -10,7 +10,7 @@
 
 #include <linux/types.h>
 
-int mvme147_detect(Scsi_Host_Template *);
+int mvme147_detect(struct scsi_host_template *);
 int mvme147_release(struct Scsi_Host *);
 const char *wd33c93_info(void);
 int wd33c93_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
Index: scsi-misc-2.6/drivers/scsi/mvme16x.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/mvme16x.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/mvme16x.c	2005-10-29 19:24:22.000000000 +0200
@@ -22,7 +22,7 @@
 #include<linux/stat.h>
 
 
-int mvme16x_scsi_detect(Scsi_Host_Template *tpnt)
+int mvme16x_scsi_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     int clock;
@@ -62,7 +62,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "MVME16x NCR53c710 SCSI",
 	.detect			= mvme16x_scsi_detect,
 	.release		= mvme16x_scsi_release,
Index: scsi-misc-2.6/drivers/scsi/mvme16x.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/mvme16x.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/mvme16x.h	2005-10-29 19:24:22.000000000 +0200
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 
-int mvme16x_scsi_detect(Scsi_Host_Template *);
+int mvme16x_scsi_detect(struct scsi_host_template *);
 const char *NCR53c7x0_info(void);
 int NCR53c7xx_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 int NCR53c7xx_abort(Scsi_Cmnd *);
Index: scsi-misc-2.6/drivers/scsi/nsp32.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/nsp32.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/nsp32.c	2005-10-29 19:24:22.000000000 +0200
@@ -198,7 +198,7 @@
 static int  __init    init_nsp32  (void);
 static void __exit    exit_nsp32  (void);
 
-/* struct Scsi_Host_Template */
+/* struct struct scsi_host_template */
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 static int         nsp32_proc_info   (struct Scsi_Host *, char *, char **, off_t, int, int);
 #else
@@ -208,7 +208,7 @@
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 static int         nsp32_detect      (struct pci_dev *pdev);
 #else
-static int         nsp32_detect      (Scsi_Host_Template *);
+static int         nsp32_detect      (struct scsi_host_template *);
 #endif
 static int         nsp32_queuecommand(struct scsi_cmnd *,
 		void (*done)(struct scsi_cmnd *));
@@ -2683,7 +2683,7 @@
 #define DETECT_OK 1
 #define DETECT_NG 0
 #define PCIDEV    (data->Pci)
-static int nsp32_detect(Scsi_Host_Template *sht)
+static int nsp32_detect(struct scsi_host_template *sht)
 #endif
 {
 	struct Scsi_Host *host;	/* registered host structure */
Index: scsi-misc-2.6/drivers/scsi/oktagon_esp.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/oktagon_esp.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/oktagon_esp.c	2005-10-29 19:24:22.000000000 +0200
@@ -114,7 +114,7 @@
 				 */
 
 /***************************************************************** Detection */
-int oktagon_esp_detect(Scsi_Host_Template *tpnt)
+int oktagon_esp_detect(struct scsi_host_template *tpnt)
 {
 	struct NCR_ESP *esp;
 	struct zorro_dev *z = NULL;
@@ -585,7 +585,7 @@
 }
 
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-oktagon",
 	.proc_info		= &esp_proc_info,
 	.name			= "BSC Oktagon SCSI",
Index: scsi-misc-2.6/drivers/scsi/pas16.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pas16.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pas16.c	2005-10-29 19:24:22.000000000 +0200
@@ -369,7 +369,7 @@
 }
 
 /* 
- * Function : int pas16_detect(Scsi_Host_Template * tpnt)
+ * Function : int pas16_detect(struct scsi_host_template * tpnt)
  *
  * Purpose : detects and initializes PAS16 controllers
  *	that were autoprobed, overridden on the LILO command line, 
@@ -381,7 +381,7 @@
  *
  */
 
-int __init pas16_detect(Scsi_Host_Template * tpnt)
+int __init pas16_detect(struct scsi_host_template * tpnt)
 {
     static int current_override = 0;
     static unsigned short current_base = 0;
@@ -615,7 +615,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name           = "Pro Audio Spectrum-16 SCSI",
 	.detect         = pas16_detect,
 	.release        = pas16_release,
Index: scsi-misc-2.6/drivers/scsi/pas16.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pas16.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pas16.h	2005-10-29 19:24:22.000000000 +0200
@@ -117,7 +117,7 @@
 static int pas16_abort(Scsi_Cmnd *);
 static int pas16_biosparam(struct scsi_device *, struct block_device *,
 			   sector_t, int*);
-static int pas16_detect(Scsi_Host_Template *);
+static int pas16_detect(struct scsi_host_template *);
 static int pas16_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int pas16_bus_reset(Scsi_Cmnd *);
 
Index: scsi-misc-2.6/drivers/scsi/pci2000.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pci2000.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pci2000.h	2005-10-29 19:24:22.000000000 +0200
@@ -187,7 +187,7 @@
 #endif
 
 // function prototypes
-int Pci2000_Detect			(Scsi_Host_Template *tpnt);
+int Pci2000_Detect			(struct scsi_host_template *tpnt);
 int Pci2000_Command			(Scsi_Cmnd *SCpnt);
 int Pci2000_QueueCommand	(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *));
 int Pci2000_Abort			(Scsi_Cmnd *SCpnt);
Index: scsi-misc-2.6/drivers/scsi/pcmcia/nsp_cs.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pcmcia/nsp_cs.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pcmcia/nsp_cs.c	2005-10-29 19:24:22.000000000 +0200
@@ -81,7 +81,7 @@
 MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0 (=no))");
 
 /* /usr/src/linux/drivers/scsi/hosts.h */
-static Scsi_Host_Template nsp_driver_template = {
+static struct scsi_host_template nsp_driver_template = {
 	.proc_name	         = "nsp_cs",
 	.proc_info		 = nsp_proc_info,
 	.name			 = "WorkBit NinjaSCSI-3/32Bi(16bit)",
@@ -1310,7 +1310,7 @@
 /*----------------------------------------------------------------*/
 /* look for ninja3 card and init if found			  */
 /*----------------------------------------------------------------*/
-static struct Scsi_Host *nsp_detect(Scsi_Host_Template *sht)
+static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht)
 {
 	struct Scsi_Host *host;	/* registered host structure */
 	nsp_hw_data *data_b = &nsp_data_base, *data;
@@ -1358,7 +1358,7 @@
 }
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static int nsp_detect_old(Scsi_Host_Template *sht)
+static int nsp_detect_old(struct scsi_host_template *sht)
 {
 	if (nsp_detect(sht) == NULL) {
 		return 0;
Index: scsi-misc-2.6/drivers/scsi/pcmcia/nsp_cs.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pcmcia/nsp_cs.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pcmcia/nsp_cs.h	2005-10-29 19:24:22.000000000 +0200
@@ -303,9 +303,9 @@
 static int         nsp_cs_event  (event_t event, int priority, event_callback_args_t *args);
 
 /* Linux SCSI subsystem specific functions */
-static struct Scsi_Host *nsp_detect     (Scsi_Host_Template *sht);
+static struct Scsi_Host *nsp_detect     (struct scsi_host_template *sht);
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static        int        nsp_detect_old (Scsi_Host_Template *sht);
+static        int        nsp_detect_old (struct scsi_host_template *sht);
 static        int        nsp_release_old(struct Scsi_Host *shpnt);
 #endif
 static const  char      *nsp_info       (struct Scsi_Host *shpnt);
@@ -345,7 +345,7 @@
 static int  nsp_xfer             (Scsi_Cmnd *SCpnt, int phase);
 static int  nsp_dataphase_bypass (Scsi_Cmnd *SCpnt);
 static int  nsp_reselected       (Scsi_Cmnd *SCpnt);
-static struct Scsi_Host *nsp_detect(Scsi_Host_Template *sht);
+static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
 
 /* Interrupt handler */
 //static irqreturn_t nspintr(int irq, void *dev_id, struct pt_regs *regs);
Index: scsi-misc-2.6/drivers/scsi/pcmcia/qlogic_stub.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pcmcia/qlogic_stub.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pcmcia/qlogic_stub.c	2005-10-29 19:24:23.000000000 +0200
@@ -72,7 +72,7 @@
 #define DEBUG(n, args...)
 #endif
 
-static Scsi_Host_Template qlogicfas_driver_template = {
+static struct scsi_host_template qlogicfas_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= qlogic_name,
 	.proc_name		= qlogic_name,
@@ -108,7 +108,7 @@
 
 static dev_info_t dev_info = "qlogic_cs";
 
-static struct Scsi_Host *qlogic_detect(Scsi_Host_Template *host,
+static struct Scsi_Host *qlogic_detect(struct scsi_host_template *host,
 				dev_link_t *link, int qbase, int qlirq)
 {
 	int qltyp;		/* type of chip */
Index: scsi-misc-2.6/drivers/scsi/pluto.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pluto.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pluto.c	2005-10-29 19:24:23.000000000 +0200
@@ -90,7 +90,7 @@
 
 /* Detect all SSAs attached to the machine.
    To be fast, do it on all online FC channels at the same time. */
-int __init pluto_detect(Scsi_Host_Template *tpnt)
+int __init pluto_detect(struct scsi_host_template *tpnt)
 {
 	int i, retry, nplutos;
 	fc_channel *fc;
@@ -339,7 +339,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "Sparc Storage Array 100/200",
 	.detect			= pluto_detect,
 	.release		= pluto_release,
Index: scsi-misc-2.6/drivers/scsi/pluto.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pluto.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pluto.h	2005-10-29 19:24:23.000000000 +0200
@@ -38,7 +38,7 @@
 /* This is the max number of outstanding SCSI commands per pluto */
 #define PLUTO_CAN_QUEUE		254
 
-int pluto_detect(Scsi_Host_Template *);
+int pluto_detect(struct scsi_host_template *);
 int pluto_release(struct Scsi_Host *);
 const char * pluto_info(struct Scsi_Host *);
 int pluto_slave_configure(Scsi_Device *);
Index: scsi-misc-2.6/drivers/scsi/psi240i.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/psi240i.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/psi240i.c	2005-10-29 19:24:23.000000000 +0200
@@ -538,7 +538,7 @@
  *	Returns:		Number of adapters found.
  *
  ****************************************************************/
-static int Psi240i_Detect (Scsi_Host_Template *tpnt)
+static int Psi240i_Detect (struct scsi_host_template *tpnt)
 	{
 	int					board;
 	int					count = 0;
@@ -669,7 +669,7 @@
 
 MODULE_LICENSE("GPL");
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "psi240i", 
 	.name			= "PSI-240I EIDE Disk Controller",
 	.detect			= Psi240i_Detect,
Index: scsi-misc-2.6/drivers/scsi/qla1280.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/qla1280.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/qla1280.c	2005-10-29 19:24:23.000000000 +0200
@@ -465,7 +465,7 @@
 	}
 	device->queue_depth = depth;
 }
-static inline struct Scsi_Host *scsi_host_alloc(Scsi_Host_Template *t, size_t s)
+static inline struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *t, size_t s)
 {
 	return scsi_register(t, s);
 }
@@ -1177,7 +1177,7 @@
 
 #if LINUX_VERSION_CODE < 0x020600
 static int
-qla1280_detect(Scsi_Host_Template *template)
+qla1280_detect(struct scsi_host_template *template)
 {
 	struct pci_device_id *id = &qla1280_pci_tbl[0];
 	struct pci_dev *pdev = NULL;
@@ -4507,7 +4507,7 @@
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 #else
-static Scsi_Host_Template qla1280_driver_template = {
+static struct scsi_host_template qla1280_driver_template = {
 	.proc_name		= "qla1280",
 	.name			= "Qlogic ISP 1280/12160",
 	.detect			= qla1280_detect,
Index: scsi-misc-2.6/drivers/scsi/qlogicfas.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/qlogicfas.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/qlogicfas.c	2005-10-29 19:24:23.000000000 +0200
@@ -47,7 +47,7 @@
  *	Look for qlogic card and init if found 
  */
  
-static struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *host,
+static struct Scsi_Host *__qlogicfas_detect(struct scsi_host_template *host,
 								int qbase,
 								int qlirq)
 {
@@ -142,7 +142,7 @@
 MODULE_PARM_DESC(iobase, "I/O address");
 MODULE_PARM_DESC(irq, "IRQ");
 
-static int __devinit qlogicfas_detect(Scsi_Host_Template *sht)
+static int __devinit qlogicfas_detect(struct scsi_host_template *sht)
 {
 	struct Scsi_Host *shost;
 	struct qlogicfas408_priv *priv;
@@ -183,7 +183,7 @@
 /*
  *	The driver template is also needed for PCMCIA
  */
-static Scsi_Host_Template qlogicfas_driver_template = {
+static struct scsi_host_template qlogicfas_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= qlogicfas_name,
 	.proc_name		= qlogicfas_name,
Index: scsi-misc-2.6/drivers/scsi/qlogicfc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/qlogicfc.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/qlogicfc.c	2005-10-29 19:24:23.000000000 +0200
@@ -711,7 +711,7 @@
 }
 
 
-static int isp2x00_detect(Scsi_Host_Template * tmpt)
+static int isp2x00_detect(struct scsi_host_template * tmpt)
 {
 	int hosts = 0;
 	unsigned long wait_time;
@@ -2210,7 +2210,7 @@
 
 MODULE_LICENSE("GPL");
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
         .detect                 = isp2x00_detect,
         .release                = isp2x00_release,
         .info                   = isp2x00_info,
Index: scsi-misc-2.6/drivers/scsi/qlogicisp.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/qlogicisp.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/qlogicisp.c	2005-10-29 19:24:23.000000000 +0200
@@ -669,7 +669,7 @@
 }
 
 
-static int isp1020_detect(Scsi_Host_Template *tmpt)
+static int isp1020_detect(struct scsi_host_template *tmpt)
 {
 	int hosts = 0;
 	struct Scsi_Host *host;
@@ -1919,7 +1919,7 @@
 
 MODULE_LICENSE("GPL");
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.detect			= isp1020_detect,
 	.release		= isp1020_release,
 	.info			= isp1020_info,	
Index: scsi-misc-2.6/drivers/scsi/sata_nv.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_nv.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_nv.c	2005-10-29 19:24:23.000000000 +0200
@@ -218,7 +218,7 @@
 	.remove			= ata_pci_remove_one,
 };
 
-static Scsi_Host_Template nv_sht = {
+static struct scsi_host_template nv_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_promise.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_promise.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_promise.c	2005-10-29 19:24:23.000000000 +0200
@@ -93,7 +93,7 @@
 static int pdc_qc_issue_prot(struct ata_queued_cmd *qc);
 
 
-static Scsi_Host_Template pdc_ata_sht = {
+static struct scsi_host_template pdc_ata_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_qstor.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_qstor.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_qstor.c	2005-10-29 19:24:23.000000000 +0200
@@ -127,7 +127,7 @@
 static void qs_irq_clear(struct ata_port *ap);
 static void qs_eng_timeout(struct ata_port *ap);
 
-static Scsi_Host_Template qs_ata_sht = {
+static struct scsi_host_template qs_ata_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_sil.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_sil.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_sil.c	2005-10-29 19:24:23.000000000 +0200
@@ -130,7 +130,7 @@
 	.remove			= ata_pci_remove_one,
 };
 
-static Scsi_Host_Template sil_sht = {
+static struct scsi_host_template sil_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_sis.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_sis.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_sis.c	2005-10-29 19:24:23.000000000 +0200
@@ -82,7 +82,7 @@
 	.remove			= ata_pci_remove_one,
 };
 
-static Scsi_Host_Template sis_sht = {
+static struct scsi_host_template sis_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_svw.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_svw.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_svw.c	2005-10-29 19:24:23.000000000 +0200
@@ -273,7 +273,7 @@
 #endif /* CONFIG_PPC_OF */
 
 
-static Scsi_Host_Template k2_sata_sht = {
+static struct scsi_host_template k2_sata_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_sx4.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_sx4.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_sx4.c	2005-10-29 19:24:23.000000000 +0200
@@ -176,7 +176,7 @@
 static int pdc20621_qc_issue_prot(struct ata_queued_cmd *qc);
 
 
-static Scsi_Host_Template pdc_sata_sht = {
+static struct scsi_host_template pdc_sata_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_uli.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_uli.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_uli.c	2005-10-29 19:24:23.000000000 +0200
@@ -70,7 +70,7 @@
 	.remove			= ata_pci_remove_one,
 };
 
-static Scsi_Host_Template uli_sht = {
+static struct scsi_host_template uli_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_via.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_via.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_via.c	2005-10-29 19:24:23.000000000 +0200
@@ -89,7 +89,7 @@
 	.remove			= ata_pci_remove_one,
 };
 
-static Scsi_Host_Template svia_sht = {
+static struct scsi_host_template svia_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_vsc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_vsc.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_vsc.c	2005-10-29 19:24:23.000000000 +0200
@@ -210,7 +210,7 @@
 }
 
 
-static Scsi_Host_Template vsc_sata_sht = {
+static struct scsi_host_template vsc_sata_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/scsi_debug.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_debug.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_debug.c	2005-10-29 19:24:23.000000000 +0200
@@ -182,7 +182,7 @@
 };
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
 
-static Scsi_Host_Template sdebug_driver_template = {
+static struct scsi_host_template sdebug_driver_template = {
 	.proc_info =		scsi_debug_proc_info,
 	.name =			"SCSI DEBUG",
 	.info =			scsi_debug_info,
Index: scsi-misc-2.6/drivers/scsi/scsi_typedefs.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_typedefs.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_typedefs.h	2005-10-29 19:24:23.000000000 +0200
@@ -1,5 +1,4 @@
 
-typedef struct scsi_host_template Scsi_Host_Template;
 typedef struct scsi_device Scsi_Device;
 typedef struct scsi_cmnd Scsi_Cmnd;
 typedef struct scsi_request Scsi_Request;
Index: scsi-misc-2.6/drivers/scsi/seagate.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/seagate.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/seagate.c	2005-10-29 19:24:23.000000000 +0200
@@ -418,7 +418,7 @@
 #define ULOOP( i ) for (clock = i*8;;)
 #define TIMEOUT (!(clock--))
 
-int __init seagate_st0x_detect (Scsi_Host_Template * tpnt)
+int __init seagate_st0x_detect (struct scsi_host_template * tpnt)
 {
 	struct Scsi_Host *instance;
 	int i, j;
@@ -1649,7 +1649,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.detect         	= seagate_st0x_detect,
 	.release        	= seagate_st0x_release,
 	.info           	= seagate_st0x_info,
Index: scsi-misc-2.6/drivers/scsi/seagate.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/seagate.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/seagate.h	2005-10-29 19:24:23.000000000 +0200
@@ -9,7 +9,7 @@
 #ifndef _SEAGATE_H
 #define SEAGATE_H
 
-static int seagate_st0x_detect(Scsi_Host_Template *);
+static int seagate_st0x_detect(struct scsi_host_template *);
 static int seagate_st0x_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 
 static int seagate_st0x_abort(Scsi_Cmnd *);
Index: scsi-misc-2.6/drivers/scsi/sgiwd93.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sgiwd93.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sgiwd93.c	2005-10-29 19:24:23.000000000 +0200
@@ -218,7 +218,7 @@
 }
 
 static struct Scsi_Host * __init sgiwd93_setup_scsi(
-	Scsi_Host_Template *SGIblows, int unit, int irq,
+	struct scsi_host_template *SGIblows, int unit, int irq,
 	struct hpc3_scsiregs *hregs, unsigned char *wdregs)
 {
 	struct ip22_hostdata *hdata;
@@ -266,7 +266,7 @@
 	return NULL;
 }
 
-int __init sgiwd93_detect(Scsi_Host_Template *SGIblows)
+int __init sgiwd93_detect(struct scsi_host_template *SGIblows)
 {
 	int found = 0;
 
@@ -325,7 +325,7 @@
  * arguments not with pointers.  So this is going to blow up beautyfully
  * on 64-bit systems with memory outside the compat address spaces.
  */
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "SGIWD93",
 	.name			= "SGI WD93",
 	.detect			= sgiwd93_detect,
Index: scsi-misc-2.6/drivers/scsi/sun3_NCR5380.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sun3_NCR5380.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sun3_NCR5380.c	2005-10-29 19:24:23.000000000 +0200
@@ -257,7 +257,7 @@
  */
 
 static struct Scsi_Host *first_instance = NULL;
-static Scsi_Host_Template *the_template = NULL;
+static struct scsi_host_template *the_template = NULL;
 
 /* Macros ease life... :-) */
 #define	SETUP_HOSTDATA(in)				\
Index: scsi-misc-2.6/drivers/scsi/sun3_scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sun3_scsi.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sun3_scsi.c	2005-10-29 19:24:23.000000000 +0200
@@ -185,7 +185,7 @@
 static struct Scsi_Host *default_instance;
 
 /*
- * Function : int sun3scsi_detect(Scsi_Host_Template * tpnt)
+ * Function : int sun3scsi_detect(struct scsi_host_template * tpnt)
  *
  * Purpose : initializes mac NCR5380 driver based on the
  *	command line / compile time port and irq definitions.
@@ -196,7 +196,7 @@
  *
  */
  
-int sun3scsi_detect(Scsi_Host_Template * tpnt)
+int sun3scsi_detect(struct scsi_host_template * tpnt)
 {
 	unsigned long ioaddr;
 	static int called = 0;
@@ -621,7 +621,7 @@
 	
 #include "sun3_NCR5380.c"
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name			= SUN3_SCSI_NAME,
 	.detect			= sun3scsi_detect,
 	.release		= sun3scsi_release,
Index: scsi-misc-2.6/drivers/scsi/sun3_scsi.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sun3_scsi.h	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sun3_scsi.h	2005-10-29 19:24:23.000000000 +0200
@@ -48,7 +48,7 @@
 #define IOBASE_SUN3_VMESCSI 0xff200000
 
 static int sun3scsi_abort (Scsi_Cmnd *);
-static int sun3scsi_detect (Scsi_Host_Template *);
+static int sun3scsi_detect (struct scsi_host_template *);
 static const char *sun3scsi_info (struct Scsi_Host *);
 static int sun3scsi_bus_reset(Scsi_Cmnd *);
 static int sun3scsi_queue_command (Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
Index: scsi-misc-2.6/drivers/scsi/sun3_scsi_vme.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sun3_scsi_vme.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sun3_scsi_vme.c	2005-10-29 19:24:23.000000000 +0200
@@ -127,7 +127,7 @@
 static struct Scsi_Host *default_instance;
 
 /*
- * Function : int sun3scsi_detect(Scsi_Host_Template * tpnt)
+ * Function : int sun3scsi_detect(struct scsi_host_template * tpnt)
  *
  * Purpose : initializes mac NCR5380 driver based on the
  *	command line / compile time port and irq definitions.
@@ -138,7 +138,7 @@
  *
  */
  
-static int sun3scsi_detect(Scsi_Host_Template * tpnt)
+static int sun3scsi_detect(struct scsi_host_template * tpnt)
 {
 	unsigned long ioaddr, irq = 0;
 	static int called = 0;
@@ -564,7 +564,7 @@
 
 #include "sun3_NCR5380.c"
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name			= SUN3_SCSI_NAME,
 	.detect			= sun3scsi_detect,
 	.release		= sun3scsi_release,
Index: scsi-misc-2.6/drivers/scsi/sun3x_esp.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sun3x_esp.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sun3x_esp.c	2005-10-29 19:24:23.000000000 +0200
@@ -47,7 +47,7 @@
 /* Detecting ESP chips on the machine.  This is the simple and easy
  * version.
  */
-int sun3x_esp_detect(Scsi_Host_Template *tpnt)
+int sun3x_esp_detect(struct scsi_host_template *tpnt)
 {
 	struct NCR_ESP *esp;
 	struct ConfigDev *esp_dev;
@@ -367,7 +367,7 @@
 
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "sun3x_esp",
 	.proc_info		= &esp_proc_info,
 	.name			= "Sun ESP 100/100a/200",
Index: scsi-misc-2.6/drivers/scsi/sym53c416.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c416.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c416.c	2005-10-29 19:24:23.000000000 +0200
@@ -633,7 +633,7 @@
 	}
 }
 
-int __init sym53c416_detect(Scsi_Host_Template *tpnt)
+int __init sym53c416_detect(struct scsi_host_template *tpnt)
 {
 	unsigned long flags;
 	struct Scsi_Host * shpnt = NULL;
@@ -849,7 +849,7 @@
 
 #endif
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name =		"sym53c416",
 	.name =			"Symbios Logic 53c416",
 	.detect =		sym53c416_detect,
Index: scsi-misc-2.6/drivers/scsi/sym53c416.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c416.h	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c416.h	2005-10-29 19:24:23.000000000 +0200
@@ -22,7 +22,7 @@
 
 #define SYM53C416_SCSI_ID 7
 
-static int sym53c416_detect(Scsi_Host_Template *);
+static int sym53c416_detect(struct scsi_host_template *);
 static const char *sym53c416_info(struct Scsi_Host *);
 static int sym53c416_release(struct Scsi_Host *);
 static int sym53c416_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
Index: scsi-misc-2.6/drivers/scsi/t128.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/t128.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/t128.c	2005-10-29 19:24:23.000000000 +0200
@@ -183,7 +183,7 @@
 }
 
 /* 
- * Function : int t128_detect(Scsi_Host_Template * tpnt)
+ * Function : int t128_detect(struct scsi_host_template * tpnt)
  *
  * Purpose : detects and initializes T128,T128F, or T228 controllers
  *	that were autoprobed, overridden on the LILO command line, 
@@ -195,7 +195,7 @@
  *
  */
 
-int __init t128_detect(Scsi_Host_Template * tpnt){
+int __init t128_detect(struct scsi_host_template * tpnt){
     static int current_override = 0, current_base = 0;
     struct Scsi_Host *instance;
     unsigned long base;
@@ -430,7 +430,7 @@
 
 #include "NCR5380.c"
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name           = "Trantor T128/T128F/T228",
 	.detect         = t128_detect,
 	.release        = t128_release,
Index: scsi-misc-2.6/drivers/scsi/t128.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/t128.h	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/t128.h	2005-10-29 19:24:23.000000000 +0200
@@ -95,7 +95,7 @@
 static int t128_abort(Scsi_Cmnd *);
 static int t128_biosparam(struct scsi_device *, struct block_device *,
 			  sector_t, int*);
-static int t128_detect(Scsi_Host_Template *);
+static int t128_detect(struct scsi_host_template *);
 static int t128_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int t128_bus_reset(Scsi_Cmnd *);
 
Index: scsi-misc-2.6/drivers/scsi/u14-34f.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/u14-34f.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/u14-34f.c	2005-10-29 19:24:23.000000000 +0200
@@ -282,7 +282,7 @@
  *  clustering is enabled. ENABLE_CLUSTERING provides a performance increase
  *  up to 50% on sequential access.
  *
- *  Since the Scsi_Host_Template structure is shared among all 14F and 34F,
+ *  Since the struct scsi_host_template structure is shared among all 14F and 34F,
  *  the last setting of use_clustering is in effect for all of these boards.
  *
  *  Here a sample configuration using two U14F boards:
Index: scsi-misc-2.6/drivers/scsi/ultrastor.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ultrastor.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ultrastor.c	2005-10-29 19:24:23.000000000 +0200
@@ -343,7 +343,7 @@
 }
 #endif
 
-static int ultrastor_14f_detect(Scsi_Host_Template * tpnt)
+static int ultrastor_14f_detect(struct scsi_host_template * tpnt)
 {
     size_t i;
     unsigned char in_byte, version_byte = 0;
@@ -525,7 +525,7 @@
     return FALSE;
 }
 
-static int ultrastor_24f_detect(Scsi_Host_Template * tpnt)
+static int ultrastor_24f_detect(struct scsi_host_template * tpnt)
 {
   int i;
   struct Scsi_Host * shpnt = NULL;
@@ -637,7 +637,7 @@
   return FALSE;
 }
 
-static int ultrastor_detect(Scsi_Host_Template * tpnt)
+static int ultrastor_detect(struct scsi_host_template * tpnt)
 {
 	tpnt->proc_name = "ultrastor";
 	return ultrastor_14f_detect(tpnt) || ultrastor_24f_detect(tpnt);
@@ -1184,7 +1184,7 @@
 
 MODULE_LICENSE("GPL");
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.name              = "UltraStor 14F/24F/34F",
 	.detect            = ultrastor_detect,
 	.release	   = ultrastor_release,
Index: scsi-misc-2.6/drivers/scsi/ultrastor.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ultrastor.h	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ultrastor.h	2005-10-29 19:24:23.000000000 +0200
@@ -13,7 +13,7 @@
 #ifndef _ULTRASTOR_H
 #define _ULTRASTOR_H
 
-static int ultrastor_detect(Scsi_Host_Template *);
+static int ultrastor_detect(struct scsi_host_template *);
 static const char *ultrastor_info(struct Scsi_Host * shpnt);
 static int ultrastor_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int ultrastor_abort(Scsi_Cmnd *);
Index: scsi-misc-2.6/drivers/usb/image/microtek.c
===================================================================
--- scsi-misc-2.6.orig/drivers/usb/image/microtek.c	2005-10-29 19:20:34.000000000 +0200
+++ scsi-misc-2.6/drivers/usb/image/microtek.c	2005-10-29 19:24:23.000000000 +0200
@@ -632,7 +632,7 @@
 	return err;
 }
 
-static Scsi_Host_Template mts_scsi_host_template = {
+static struct scsi_host_template mts_scsi_host_template = {
 	.module			= THIS_MODULE,
 	.name			= "microtekX6",
 	.proc_name		= "microtekX6",
Index: scsi-misc-2.6/include/linux/libata.h
===================================================================
--- scsi-misc-2.6.orig/include/linux/libata.h	2005-10-29 19:20:38.000000000 +0200
+++ scsi-misc-2.6/include/linux/libata.h	2005-10-29 19:24:23.000000000 +0200
@@ -203,7 +203,7 @@
 	struct list_head	node;
 	struct device 		*dev;
 	const struct ata_port_operations *port_ops;
-	Scsi_Host_Template	*sht;
+	struct scsi_host_template *sht;
 	struct ata_ioports	port[ATA_MAX_PORTS];
 	unsigned int		n_ports;
 	unsigned int		hard_port_no;
@@ -380,7 +380,7 @@
 };
 
 struct ata_port_info {
-	Scsi_Host_Template	*sht;
+	struct scsi_host_template	*sht;
 	unsigned long		host_flags;
 	unsigned long		pio_mask;
 	unsigned long		mwdma_mask;
@@ -415,7 +415,7 @@
 #endif /* CONFIG_PCI */
 extern int ata_device_add(const struct ata_probe_ent *ent);
 extern void ata_host_set_remove(struct ata_host_set *host_set);
-extern int ata_scsi_detect(Scsi_Host_Template *sht);
+extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
 extern int ata_scsi_error(struct Scsi_Host *host);
Index: scsi-misc-2.6/drivers/scsi/pdc_adma.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pdc_adma.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pdc_adma.c	2005-10-29 19:24:23.000000000 +0200
@@ -139,7 +139,7 @@
 static void adma_irq_clear(struct ata_port *ap);
 static void adma_eng_timeout(struct ata_port *ap);
 
-static Scsi_Host_Template adma_ata_sht = {
+static struct scsi_host_template adma_ata_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_mv.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_mv.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_mv.c	2005-10-29 19:24:23.000000000 +0200
@@ -270,7 +270,7 @@
 static void mv_eng_timeout(struct ata_port *ap);
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
-static Scsi_Host_Template mv_sht = {
+static struct scsi_host_template mv_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
Index: scsi-misc-2.6/drivers/scsi/sata_sil24.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_sil24.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_sil24.c	2005-10-29 19:24:23.000000000 +0200
@@ -255,7 +255,7 @@
 	.remove			= ata_pci_remove_one, /* safe? */
 };
 
-static Scsi_Host_Template sil24_sht = {
+static struct scsi_host_template sil24_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
