From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 5/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:06:54 +0900 (JST)
Message-ID: <20050222.160654.78772649.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:46606 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262226AbVBVHG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:06:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/nsp32.c	2005-02-22 08:23:09.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/nsp32.c	2005-02-22 06:17:02.000000000 +0900
@@ -1,8 +1,8 @@
 /*
  * NinjaSCSI-32Bi Cardbus, NinjaSCSI-32UDE PCI/CardBus SCSI driver
- * Copyright (C) 2001, 2002, 2003
- *      YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
- *      GOTO Masanori <gotom@debian.or.jp>, <gotom@debian.org>
+ * Copyright (C) 2001, 2002, 2003, 2004, 2005
+ *      YOKOTA Hiroshi <yokota{at}netlab.is.tsukuba.ac.jp>
+ *      GOTO Masanori <gotom{at}debian.or.jp>, <gotom{at}debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,23 +21,27 @@
  *        Remove obsolete error handler nsp32_reset.
  *        Some clean up.
  *   1.2: PowerPC (big endian) support.
+ *   1.3: Use kernel thread.
+ *   1.3.1: Remove kernel thread. Becase kernel thread is not so useful
+ *          on this driver.
  */
 
-#include <linux/version.h>
-#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
 #include <linux/kernel.h>
+#include <linux/major.h>
+#include <linux/module.h>
+#include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/timer.h>
-#include <linux/ioport.h>
-#include <linux/major.h>
-#include <linux/blkdev.h>
-#include <linux/interrupt.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/ctype.h>
+#include <linux/version.h>
 
 #include <asm/dma.h>
 #include <asm/system.h>
@@ -49,7 +53,10 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
+# include <linux/moduleparam.h>
+#else
 # include <linux/blk.h>
 #endif
 
@@ -59,31 +66,38 @@
 /***********************************************************************
  * Module parameters
  */
-static int       trans_mode = 0;	/* default: BIOS */
-MODULE_PARM     (trans_mode, "i");
-MODULE_PARM_DESC(trans_mode, "transfer mode (0: BIOS(default) 1: Async 2: Ultra20M");
+MODULE_DESCRIPTION("Workbit NinjaSCSI-32Bi/UDE CardBus/PCI SCSI host bus adapter module");
+MODULE_AUTHOR("YOKOTA Hiroshi <yokota{at}netlab.is.tsukuba.ac.jp>, GOTO Masanori <gotom{at}debian.or.jp>");
+MODULE_SUPPORTED_DEVICE("sd,sr,sg,st");
+MODULE_LICENSE("GPL");
+
+static int       trans_mode = 0;	 /* default: BIOS */
+module_param    (trans_mode, int, 0444); /* -r--r--r--    */
+MODULE_PARM_DESC(trans_mode, "transfer mode (0: BIOS(default) 1: Async 2: Ultra20M)");
 #define ASYNC_MODE    1
 #define ULTRA20M_MODE 2
 
-static int       auto_param = 0;	/* default: ON */
-MODULE_PARM     (auto_param, "i");
+static int       auto_param = 0;	 /* default: ON */
+module_param    (auto_param, int, 0644); /* -rw-r--r--  */
 MODULE_PARM_DESC(auto_param, "AutoParameter mode (0: ON(default) 1: OFF)");
 
-static int       disc_priv  = 1;	/* default: OFF */
-MODULE_PARM     (disc_priv,  "i");
+static int       disc_priv  = 1;	 /* default: OFF */
+module_param    (disc_priv,  int, 0644); /* -rw-r--r--   */
 MODULE_PARM_DESC(disc_priv,  "disconnection privilege mode (0: ON 1: OFF(default))");
 
-MODULE_AUTHOR("YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, GOTO Masanori <gotom@debian.or.jp>");
-MODULE_DESCRIPTION("Workbit NinjaSCSI-32Bi/UDE CardBus/PCI SCSI host bus adapter module");
-MODULE_LICENSE("GPL");
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
+MODULE_PARM(trans_mode, "i");
+MODULE_PARM(disc_priv,  "i");
+MODULE_PARM(auto_param, "i");
+#endif
 
-static const char *nsp32_release_version = "1.2";
+static const char * const nsp32_release_version = "1.3";
 
 
 /****************************************************************************
  * Supported hardware
  */
-static struct pci_device_id nsp32_pci_table[] __devinitdata = {
+static const struct pci_device_id nsp32_pci_table[] __devinitdata = {
 	{
 		.vendor      = PCI_VENDOR_ID_IODATA,
 		.device      = PCI_DEVICE_ID_NINJASCSI_32BI_CBSC_II,
@@ -140,6 +154,13 @@
 		.subdevice   = PCI_ANY_ID,
 		.driver_data = MODEL_PCI_MELCO,
 	},
+	{
+		.vendor      = PCI_VENDOR_ID_WORKBIT,
+		.device      = PCI_DEVICE_ID_NINJASCSI_32PCGA_DVD51,
+		.subvendor   = PCI_ANY_ID,
+		.subdevice   = PCI_ANY_ID,
+		.driver_data = MODEL_SONY,
+	},
 	{0,0,},
 };
 MODULE_DEVICE_TABLE(pci, nsp32_pci_table);
@@ -152,7 +173,7 @@
  *
  * Note: This period/ackwidth speed table must be in descending order.
  */
-static nsp32_sync_table nsp32_sync_table_40M[] = {
+const static nsp32_sync_table nsp32_sync_table_40M[] = {
      /* {PNo, AW,   SP,   EP, SREQ smpl}  Speed(MB/s) Period AckWidth */
 	{0x1,  0, 0x0c, 0x0c, SMPL_40M},  /*  20.0 :  50ns,  25ns */
 	{0x2,  0, 0x0d, 0x18, SMPL_40M},  /*  13.3 :  75ns,  25ns */
@@ -163,9 +184,15 @@
 	{0x7,  3, 0x32, 0x32, SMPL_20M},  /*   5.0 : 200ns, 100ns */
 	{0x8,  3, 0x33, 0x38, SMPL_10M},  /*   4.4 : 225ns, 100ns */
 	{0x9,  3, 0x39, 0x3e, SMPL_10M},  /*   4.0 : 250ns, 100ns */
+	{0xa,  3, 0x3f, 0x44, SMPL_10M},  /*   3.64: 275ns, 100ns */
+	{0xb,  3, 0x45, 0x4b, SMPL_10M},  /*   3.33: 300ns, 100ns */
+	{0xc,  3, 0x4c, 0x53, SMPL_10M},  /*   3.01: 325ns, 100ns */
+	{0xd,  3, 0x54, 0x57, SMPL_10M},  /*   2.86: 350ns, 100ns */
+	{0xe,  3, 0x58, 0x5d, SMPL_10M},  /*   2.67: 375ns, 100ns */
+	{0xf,  3, 0x5e, 0x64, SMPL_10M},  /*   2.5 : 400ns, 100ns */
 };
 
-static nsp32_sync_table nsp32_sync_table_20M[] = {
+const static nsp32_sync_table nsp32_sync_table_20M[] = {
 	{0x1,  0, 0x19, 0x19, SMPL_40M},  /* 10.0 : 100ns,  50ns */
 	{0x2,  0, 0x1a, 0x25, SMPL_20M},  /*  6.7 : 150ns,  50ns */
 	{0x3,  1, 0x26, 0x32, SMPL_20M},  /*  5.0 : 200ns, 100ns */
@@ -175,9 +202,15 @@
 	{0x7,  3, 0x58, 0x64, SMPL_10M},  /*  2.5 : 400ns, 200ns */
 	{0x8,  3, 0x65, 0x70, SMPL_10M},  /*  2.2 : 450ns, 200ns */
 	{0x9,  3, 0x71, 0x7d, SMPL_10M},  /*  2.0 : 500ns, 200ns */
+	{0xa,  3, 0x7e, 0x89, SMPL_10M},  /*  1.82: 550ns, 200ns */
+	{0xb,  3, 0x8a, 0x95, SMPL_10M},  /*  1.67: 550ns, 200ns */
+	{0xc,  3, 0x96, 0xa2, SMPL_10M},  /*  1.54: 550ns, 200ns */
+	{0xd,  3, 0xa3, 0xae, SMPL_10M},  /*  1.43: 550ns, 200ns */
+	{0xe,  3, 0xaf, 0xbb, SMPL_10M},  /*  1.33: 550ns, 200ns */
+	{0xf,  3, 0xbc, 0xc8, SMPL_10M},  /*  1.25: 550ns, 200ns */
 };
 
-static nsp32_sync_table nsp32_sync_table_pci[] = {
+const static nsp32_sync_table nsp32_sync_table_pci[] = {
 	{0x1,  0, 0x0c, 0x0f, SMPL_40M},  /* 16.6 :  60ns,  30ns */
 	{0x2,  0, 0x10, 0x16, SMPL_40M},  /* 11.1 :  90ns,  30ns */
 	{0x3,  1, 0x17, 0x1e, SMPL_20M},  /*  8.3 : 120ns,  60ns */
@@ -187,6 +220,12 @@
 	{0x7,  3, 0x35, 0x3c, SMPL_10M},  /*  4.2 : 240ns, 120ns */
 	{0x8,  3, 0x3d, 0x43, SMPL_10M},  /*  3.7 : 270ns, 120ns */
 	{0x9,  3, 0x44, 0x4b, SMPL_10M},  /*  3.3 : 300ns, 120ns */
+	{0xa,  3, 0x4c, 0x53, SMPL_10M},  /*  3.0 : 330ns, 120ns */
+	{0xb,  3, 0x54, 0x59, SMPL_10M},  /*  2.8 : 360ns, 120ns */
+	{0xc,  3, 0x5a, 0x60, SMPL_10M},  /*  2.6 : 390ns, 120ns */
+	{0xd,  3, 0x61, 0x68, SMPL_10M},  /*  2.4 : 420ns, 120ns */
+	{0xe,  3, 0x69, 0x71, SMPL_10M},  /*  2.2 : 450ns, 120ns */
+	{0xf,  3, 0x72, 0x77, SMPL_10M},  /*  2.1 : 480ns, 120ns */
 };
 
 /*
@@ -200,59 +239,59 @@
 
 /* struct Scsi_Host_Template */
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-static int         nsp32_proc_info   (struct Scsi_Host *, char *, char **, off_t, int, int);
+static int	   nsp32_proc_info   (struct Scsi_Host *, char *, char **, off_t, int, int);
 #else
-static int         nsp32_proc_info   (char *, char **, off_t, int, int, int);
+static int	   nsp32_proc_info   (char *, char **, off_t, int, int, int);
 #endif
 
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-static int         nsp32_detect      (struct pci_dev *pdev);
+static int	   nsp32_detect	     (struct pci_dev *pdev);
 #else
-static int         nsp32_detect      (Scsi_Host_Template *);
+static int	   nsp32_detect	     (Scsi_Host_Template *);
 #endif
-static int         nsp32_queuecommand(struct scsi_cmnd *,
-		void (*done)(struct scsi_cmnd *));
-static const char *nsp32_info        (struct Scsi_Host *);
-static int         nsp32_release     (struct Scsi_Host *);
+static int	   nsp32_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static const char *nsp32_info	     (struct Scsi_Host *);
+static int	   nsp32_release     (struct Scsi_Host *);
 
 /* SCSI error handler */
-static int         nsp32_eh_abort     (struct scsi_cmnd *);
-static int         nsp32_eh_bus_reset (struct scsi_cmnd *);
-static int         nsp32_eh_host_reset(struct scsi_cmnd *);
+static int	   nsp32_eh_abort     (struct scsi_cmnd *);
+static int	   nsp32_eh_bus_reset (struct scsi_cmnd *);
+static int	   nsp32_eh_host_reset(struct scsi_cmnd *);
 
 /* generate SCSI message */
-static void nsp32_build_identify(struct scsi_cmnd *);
-static void nsp32_build_nop     (struct scsi_cmnd *);
-static void nsp32_build_reject  (struct scsi_cmnd *);
-static void nsp32_build_sdtr    (struct scsi_cmnd *, unsigned char, unsigned char);
+static void nsp32_build_identify(const struct scsi_cmnd *);
+static void nsp32_build_nop	(const struct scsi_cmnd *);
+static void nsp32_build_reject	(const struct scsi_cmnd *);
+static void nsp32_build_sdtr	(const struct scsi_cmnd *, unsigned char, unsigned char);
 
 /* SCSI message handler */
 static int  nsp32_busfree_occur(struct scsi_cmnd *, unsigned short);
 static void nsp32_msgout_occur (struct scsi_cmnd *);
 static void nsp32_msgin_occur  (struct scsi_cmnd *, unsigned long, unsigned short);
 
-static int  nsp32_setup_sg_table    (struct scsi_cmnd *);
-static int  nsp32_selection_autopara(struct scsi_cmnd *);
-static int  nsp32_selection_autoscsi(struct scsi_cmnd *);
-static void nsp32_scsi_done         (struct scsi_cmnd *);
-static int  nsp32_arbitration       (struct scsi_cmnd *, unsigned int);
-static int  nsp32_reselection       (struct scsi_cmnd *, unsigned char);
-static void nsp32_adjust_busfree    (struct scsi_cmnd *, unsigned int);
-static void nsp32_restart_autoscsi  (struct scsi_cmnd *, unsigned short);
+static int	     nsp32_setup_sg_table    (struct scsi_cmnd *);
+static unsigned long nsp32_msgout_register   (const struct scsi_cmnd *);
+static int	     nsp32_selection_autopara(struct scsi_cmnd *);
+static int	     nsp32_selection_autoscsi(struct scsi_cmnd *);
+static void	     nsp32_scsi_done	     (struct scsi_cmnd *);
+static int	     nsp32_arbitration	     (struct scsi_cmnd *);
+static int	     nsp32_reselection	     (struct scsi_cmnd *, unsigned char);
+static void	     nsp32_adjust_busfree    (struct scsi_cmnd *, unsigned int);
+static void	     nsp32_restart_autoscsi  (struct scsi_cmnd *, unsigned short);
 
 /* SCSI SDTR */
-static void nsp32_analyze_sdtr       (struct scsi_cmnd *);
-static int  nsp32_search_period_entry(nsp32_hw_data *, nsp32_target *, unsigned char);
-static void nsp32_set_async          (nsp32_hw_data *, nsp32_target *);
-static void nsp32_set_max_sync       (nsp32_hw_data *, nsp32_target *, unsigned char *, unsigned char *);
-static void nsp32_set_sync_entry     (nsp32_hw_data *, nsp32_target *, int, unsigned char);
+static void nsp32_analyze_sdtr	     (const struct scsi_cmnd *);
+static int  nsp32_search_period_entry(const nsp32_hw_data *, nsp32_target *, unsigned char);
+static void nsp32_set_async	     (const nsp32_hw_data *, nsp32_target *);
+static void nsp32_set_max_sync	     (const nsp32_hw_data *, nsp32_target *, unsigned char *, unsigned char *);
+static void nsp32_set_sync_entry     (const nsp32_hw_data *, nsp32_target *, int, unsigned char);
 
 /* SCSI bus status handler */
-static void nsp32_wait_req    (nsp32_hw_data *, int);
-static void nsp32_wait_sack   (nsp32_hw_data *, int);
-static void nsp32_sack_assert (nsp32_hw_data *);
-static void nsp32_sack_negate (nsp32_hw_data *);
-static void nsp32_do_bus_reset(nsp32_hw_data *);
+static void nsp32_wait_req    (const nsp32_hw_data *, int);
+static void nsp32_wait_sack   (const nsp32_hw_data *, int);
+static void nsp32_sack_assert (const nsp32_hw_data *);
+static void nsp32_sack_negate (const nsp32_hw_data *);
+static void nsp32_do_bus_reset(      nsp32_hw_data *);
 
 /* hardware interrupt handler */
 static irqreturn_t do_nsp32_isr(int, void *, struct pt_regs *);
@@ -261,21 +300,21 @@
 static int  nsp32hw_init(nsp32_hw_data *);
 
 /* EEPROM handler */
-static        int  nsp32_getprom_param (nsp32_hw_data *);
-static        int  nsp32_getprom_at24  (nsp32_hw_data *);
-static        int  nsp32_getprom_c16   (nsp32_hw_data *);
-static        void nsp32_prom_start    (nsp32_hw_data *);
-static        void nsp32_prom_stop     (nsp32_hw_data *);
-static        int  nsp32_prom_read     (nsp32_hw_data *, int);
-static        int  nsp32_prom_read_bit (nsp32_hw_data *);
-static        void nsp32_prom_write_bit(nsp32_hw_data *, int);
-static        void nsp32_prom_set      (nsp32_hw_data *, int, int);
-static        int  nsp32_prom_get      (nsp32_hw_data *, int);
+static int  nsp32_getprom_param (      nsp32_hw_data *);
+static int  nsp32_getprom_at24  (      nsp32_hw_data *);
+static int  nsp32_getprom_c16   (      nsp32_hw_data *);
+static void nsp32_prom_start    (const nsp32_hw_data *);
+static void nsp32_prom_stop     (const nsp32_hw_data *);
+static int  nsp32_prom_read     (const nsp32_hw_data *, int);
+static int  nsp32_prom_read_bit (const nsp32_hw_data *);
+static void nsp32_prom_write_bit(const nsp32_hw_data *, int);
+static void nsp32_prom_set      (const nsp32_hw_data *, int, int);
+static int  nsp32_prom_get      (const nsp32_hw_data *, int);
 
 /* debug/warning/info message */
-static void nsp32_message (const char *, int, char *, char *, ...);
+static void nsp32_message (const char *, int, const char *, const char *, ...);
 #ifdef NSP32_DEBUG
-static void nsp32_dmessage(const char *, int, int,    char *, ...);
+static void nsp32_dmessage(const char *, int, int, const char *, ...);
 #endif
 
 /*
@@ -293,19 +332,20 @@
 	.cmd_per_lun			= 1,
 	.this_id			= NSP32_HOST_SCSIID,
 	.use_clustering			= DISABLE_CLUSTERING,
-	.eh_abort_handler       	= nsp32_eh_abort,
+	.eh_abort_handler		= nsp32_eh_abort,
 /*	.eh_device_reset_handler	= NULL, */
 	.eh_bus_reset_handler		= nsp32_eh_bus_reset,
 	.eh_host_reset_handler		= nsp32_eh_host_reset,
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,74))
 	.detect				= nsp32_detect,
 	.release			= nsp32_release,
-#endif
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,2))
-	.use_new_eh_code        	= 1,
+	.use_new_eh_code		= 1,
 #else
 /*	.highmem_io			= 1, */
 #endif
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,0))
+	.module				= THIS_MODULE,
+#endif
 };
 
 #include "nsp32_io.h"
@@ -315,8 +355,8 @@
  */
 #ifndef NSP32_DEBUG
 # define NSP32_DEBUG_MASK	      0x000000
-# define nsp32_msg(type, args...)     nsp32_message ("", 0, (type), args)
-# define nsp32_dbg(mask, args...)     /* */
+# define nsp32_msg(type, args...)     nsp32_message(NULL, 0, (type), args)
+# define nsp32_dbg(mask, args...)     do {} while(0)
 #else
 # define NSP32_DEBUG_MASK	      0xffffff
 # define nsp32_msg(type, args...) \
@@ -343,11 +383,13 @@
 #define NSP32_DEBUG_TARGETFLAG		BIT(15)
 #define NSP32_DEBUG_PROC		BIT(16)
 #define NSP32_DEBUG_INIT		BIT(17)
+#define NSP32_DEBUG_THREAD		BIT(19)
 #define NSP32_SPECIAL_PRINT_REGISTER	BIT(20)
 
 #define NSP32_DEBUG_BUF_LEN		100
 
-static void nsp32_message(const char *func, int line, char *type, char *fmt, ...)
+__attribute__((format(printf, 4, 5)))
+static void nsp32_message(const char *func, int line, const char *type, const char *fmt, ...)
 {
 	va_list args;
 	char buf[NSP32_DEBUG_BUF_LEN];
@@ -364,7 +406,8 @@
 }
 
 #ifdef NSP32_DEBUG
-static void nsp32_dmessage(const char *func, int line, int mask, char *fmt, ...)
+__attribute__((format(printf, 4, 5)))
+static void nsp32_dmessage(const char *func, int line, int mask, const char *fmt, ...)
 {
 	va_list args;
 	char buf[NSP32_DEBUG_BUF_LEN];
@@ -382,23 +425,23 @@
 #ifdef NSP32_DEBUG
 # include "nsp32_debug.c"
 #else
-# define show_command(arg)   /* */
-# define show_busphase(arg)  /* */
-# define show_autophase(arg) /* */
+# define show_command(arg)   do {} while(0)
+# define show_busphase(arg)  do {} while(0)
+# define show_autophase(arg) do {} while(0)
 #endif
 
 /*
  * IDENTIFY Message
  */
-static void nsp32_build_identify(struct scsi_cmnd *SCpnt)
+static void nsp32_build_identify(const struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int pos             = data->msgout_len;
-	int mode            = FALSE;
+	int pos		    = data->msgout_len;
+	int mode	    = FALSE;
 
 	/* XXX: Auto DiscPriv detection is progressing... */
 	if (disc_priv == 0) {
-		/* mode = TRUE; */
+		mode = TRUE;
 	}
 
 	data->msgoutbuf[pos] = IDENTIFY(mode, SCpnt->device->lun); pos++;
@@ -409,18 +452,18 @@
 /*
  * SDTR Message Routine
  */
-static void nsp32_build_sdtr(struct scsi_cmnd    *SCpnt,
+static void nsp32_build_sdtr(const struct scsi_cmnd    *SCpnt,
 			     unsigned char period,
 			     unsigned char offset)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int pos             = data->msgout_len;
+	int pos		    = data->msgout_len;
 
 	data->msgoutbuf[pos] = EXTENDED_MESSAGE;  pos++;
 	data->msgoutbuf[pos] = EXTENDED_SDTR_LEN; pos++;
-	data->msgoutbuf[pos] = EXTENDED_SDTR;     pos++;
-	data->msgoutbuf[pos] = period;            pos++;
-	data->msgoutbuf[pos] = offset;            pos++;
+	data->msgoutbuf[pos] = EXTENDED_SDTR;	  pos++;
+	data->msgoutbuf[pos] = period;		  pos++;
+	data->msgoutbuf[pos] = offset;		  pos++;
 
 	data->msgout_len = pos;
 }
@@ -428,10 +471,10 @@
 /*
  * No Operation Message
  */
-static void nsp32_build_nop(struct scsi_cmnd *SCpnt)
+static void nsp32_build_nop(const struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int            pos  = data->msgout_len;
+	int	       pos  = data->msgout_len;
 
 	if (pos != 0) {
 		nsp32_msg(KERN_WARNING,
@@ -446,33 +489,73 @@
 /*
  * Reject Message
  */
-static void nsp32_build_reject(struct scsi_cmnd *SCpnt)
+static void nsp32_build_reject(const struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int            pos  = data->msgout_len;
+	int	       pos  = data->msgout_len;
 
 	data->msgoutbuf[pos] = MESSAGE_REJECT; pos++;
 	data->msgout_len = pos;
 }
-	
+
 /*
- * timer
+ * Start hardware timer
  */
 #if 0
-static void nsp32_start_timer(struct scsi_cmnd *SCpnt, int time)
+static void nsp32_start_timer(const struct scsi_cmnd *SCpnt, int time)
 {
-	unsigned int base = SCpnt->host->io_port;
+	const unsigned int base = SCpnt->host->io_port;
 
 	nsp32_dbg(NSP32_DEBUG_INTR, "timer=%d", time);
 
 	if (time & (~TIMER_CNT_MASK)) {
-		nsp32_dbg(NSP32_DEBUG_INTR, "timer set overflow");
+		nsp32_dbg(NSP32_DEBUG_INTR, "timer value overflow");
 	}
 
 	nsp32_write2(base, TIMER_SET, time & TIMER_CNT_MASK);
 }
 #endif
 
+/*
+ * Generate msgout register value based on the number of messages.
+ */
+static unsigned long nsp32_msgout_register(const struct scsi_cmnd *SCpnt)
+{
+	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
+	unsigned long  msgout;
+	int	       i;
+
+	/*
+	 * message out
+	 *
+	 * Note: If the range of msgout_len is 1 - 3, fill scsi_msgout.
+	 *       over 3 messages needs another routine.
+	 */
+	if (data->msgout_len > 0 && data->msgout_len <= 3) {
+		msgout = 0;
+		for (i = 0; i < data->msgout_len; i++) {
+			/*
+			 * msgout register layout:
+			 *  bit: 31-24 23-16 15-08 07 06-02  01-00
+			 *       MSG#2 MSG#1 MSG#0 MV <void> len
+			 *
+			 * the sending order of the message is:
+			 *  len = 3: MSG#0 -> MSG#1 -> MSG#2
+			 *  len = 2:          MSG#1 -> MSG#2
+			 *  len = 1:                   MSG#2
+			 */
+			msgout >>= 8;
+			msgout |= ((unsigned int)(data->msgoutbuf[i]) << 24);
+		}
+		msgout |= MSGOUT_VALID;	/* Message out Valid */
+		msgout |= data->msgout_len; /* len */
+	} else {
+		/* data->msgout_len > 3 || data->msgout_len <= 0*/
+		msgout = 0;
+	}
+
+	return msgout;
+}
 
 /*
  * set SCSI command and other parameter to asic, and start selection phase
@@ -480,14 +563,14 @@
 static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data  *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int	base    = SCpnt->device->host->io_port;
-	unsigned int	host_id = SCpnt->device->host->this_id;
-	unsigned char	target  = SCpnt->device->id;
+	const unsigned int	base    = SCpnt->device->host->io_port;
+	const unsigned int	host_id = SCpnt->device->host->this_id;
+	const unsigned char	target  = SCpnt->device->id;
 	nsp32_autoparam *param  = data->autoparam;
 	unsigned char	phase;
 	int		i, ret;
-	unsigned int	msgout;
-	u16_le	        s;
+	unsigned long	msgout_reg;
+	unsigned short	transfer_reg;
 
 	nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "in");
 
@@ -504,33 +587,15 @@
 
 	/*
 	 * message out
-	 *
-	 * Note: If the range of msgout_len is 1 - 3, fill scsi_msgout.
-	 *       over 3 messages needs another routine.
 	 */
 	if (data->msgout_len == 0) {
 		nsp32_msg(KERN_ERR, "SCSI MsgOut without any message!");
 		SCpnt->result = DID_ERROR << 16;
 		return FALSE;
-	} else if (data->msgout_len > 0 && data->msgout_len <= 3) {
-		msgout = 0;
-		for (i = 0; i < data->msgout_len; i++) {
-			/*
-			 * the sending order of the message is:
-			 *  MCNT 3: MSG#0 -> MSG#1 -> MSG#2
-			 *  MCNT 2:          MSG#1 -> MSG#2
-			 *  MCNT 1:                   MSG#2    
-			 */
-			msgout >>= 8;
-			msgout |= ((unsigned int)(data->msgoutbuf[i]) << 24);
-		}
-		msgout |= MV_VALID;	/* MV valid */
-		msgout |= (unsigned int)data->msgout_len; /* len */
-	} else {
-		/* data->msgout_len > 3 */
-		msgout = 0;
 	}
 
+	msgout_reg = nsp32_msgout_register(SCpnt);
+
 	// nsp_dbg(NSP32_DEBUG_AUTOSCSI, "sel time out=0x%x\n", nsp32_read2(base, SEL_TIME_OUT));
 	// nsp32_write2(base, SEL_TIME_OUT,   SEL_TIMEOUT_TIME);
 
@@ -545,7 +610,7 @@
 	}
 
 	/* outgoing messages */
-	param->msgout = cpu_to_le32(msgout);
+	param->msgout = cpu_to_le32(msgout_reg);
 
 	/* syncreg, ackwidth, target id, SREQ sampling rate */
 	param->syncreg    = data->cur_target->syncreg;
@@ -553,38 +618,38 @@
 	param->target_id  = BIT(host_id) | BIT(target);
 	param->sample_reg = data->cur_target->sample_reg;
 
-	// nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "sample rate=0x%x\n", data->cur_target->sample_reg);
+	// nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "sample reg=0x%x\n", data->cur_target->sample_reg);
 
 	/* command control */
 	param->command_control = cpu_to_le16(CLEAR_CDB_FIFO_POINTER |
-					     AUTOSCSI_START         |
+					     AUTOSCSI_START	    |
 					     AUTO_MSGIN_00_OR_04    |
-					     AUTO_MSGIN_02          |
-					     AUTO_ATN               );
+					     AUTO_MSGIN_02	    |
+					     AUTO_ATN		    );
 
 
 	/* transfer control */
-	s = 0;
+	transfer_reg = 0;
 	switch (data->trans_method) {
 	case NSP32_TRANSFER_BUSMASTER:
-		s |= BM_START;
+		transfer_reg |= BM_START;
 		break;
 	case NSP32_TRANSFER_MMIO:
-		s |= CB_MMIO_MODE;
+		transfer_reg |= CB_MMIO_MODE;
 		break;
 	case NSP32_TRANSFER_PIO:
-		s |= CB_IO_MODE;
+		transfer_reg |= CB_IO_MODE;
 		break;
 	default:
-		nsp32_msg(KERN_ERR, "unknown trans_method");
+		nsp32_msg(KERN_ERR, "unknown transfer mode");
 		break;
 	}
 	/*
 	 * OR-ed BLIEND_MODE, FIFO intr is decreased, instead of PCI bus waits.
 	 * For bus master transfer, it's taken off.
 	 */
-	s |= (TRANSFER_GO | ALL_COUNTER_CLR);
-	param->transfer_control = cpu_to_le16(s);
+	transfer_reg |= (TRANSFER_GO | ALL_COUNTER_CLR);
+	param->transfer_control = cpu_to_le16(transfer_reg);
 
 	/* sg table addr */
 	param->sgt_pointer = cpu_to_le32(data->cur_lunt->sglun_paddr);
@@ -592,14 +657,14 @@
 	/*
 	 * transfer parameter to ASIC
 	 */
-	nsp32_write4(base, SGT_ADR,         data->auto_paddr);
+	nsp32_write4(base, SGT_ADR,	    data->auto_paddr);
 	nsp32_write2(base, COMMAND_CONTROL, CLEAR_CDB_FIFO_POINTER |
-		                            AUTO_PARAMETER         );
+					    AUTO_PARAMETER	   );
 
 	/*
 	 * Check arbitration
 	 */
-	ret = nsp32_arbitration(SCpnt, base);
+	ret = nsp32_arbitration(SCpnt);
 
 	return ret;
 }
@@ -611,13 +676,13 @@
 static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data  *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int	base    = SCpnt->device->host->io_port;
-	unsigned int	host_id = SCpnt->device->host->this_id;
-	unsigned char	target  = SCpnt->device->id;
+	const unsigned int  base    = SCpnt->device->host->io_port;
+	const unsigned int  host_id = SCpnt->device->host->this_id;
+	const unsigned char target  = SCpnt->device->id;
 	unsigned char	phase;
 	int		status;
-	unsigned short	command	= 0;
-	unsigned int	msgout  = 0;
+	unsigned short	command;
+	unsigned long   msgout;
 	unsigned short	execph;
 	int		i;
 
@@ -632,12 +697,13 @@
 	 * check bus line
 	 */
 	phase = nsp32_read1(base, SCSI_BUS_MONITOR);
-	if(((phase & BUSMON_BSY) == 1) || (phase & BUSMON_SEL) == 1) {
+	if((phase & BUSMON_BSY) ||
+	   (phase & BUSMON_SEL)  ) {
 		nsp32_msg(KERN_WARNING, "bus busy");
 		SCpnt->result = DID_BUS_BUSY << 16;
-		status = 1;
+		status = FALSE;
 		goto out;
-        }
+	}
 
 	/*
 	 * clear execph
@@ -654,7 +720,7 @@
 	 */
 	for (i = 0; i < SCpnt->cmd_len; i++) {
 		nsp32_write1(base, COMMAND_DATA, SCpnt->cmnd[i]);
-        }
+	}
 	nsp32_dbg(NSP32_DEBUG_CDB_CONTENTS, "CDB[0]=[0x%x]", SCpnt->cmnd[0]);
 
 	/*
@@ -664,35 +730,17 @@
 
 	/*
 	 * set SCSI MSGOUT REG
-	 *
-	 * Note: If the range of msgout_len is 1 - 3, fill scsi_msgout.
-	 *       over 3 messages needs another routine.
 	 */
 	if (data->msgout_len == 0) {
 		nsp32_msg(KERN_ERR, "SCSI MsgOut without any message!");
 		SCpnt->result = DID_ERROR << 16;
-		status = 1;
+		status = FALSE;
 		goto out;
-	} else if (data->msgout_len > 0 && data->msgout_len <= 3) {
-		msgout = 0;
-		for (i = 0; i < data->msgout_len; i++) {
-			/*
-			 * the sending order of the message is:
-			 *  MCNT 3: MSG#0 -> MSG#1 -> MSG#2
-			 *  MCNT 2:          MSG#1 -> MSG#2
-			 *  MCNT 1:                   MSG#2    
-			 */
-			msgout >>= 8;
-			msgout |= ((unsigned int)(data->msgoutbuf[i]) << 24);
-		}
-		msgout |= MV_VALID;	/* MV valid */
-		msgout |= (unsigned int)data->msgout_len; /* len */
-		nsp32_write4(base, SCSI_MSG_OUT, msgout);
-	} else {
-		/* data->msgout_len > 3 */
-		nsp32_write4(base, SCSI_MSG_OUT, 0);
 	}
 
+	msgout = nsp32_msgout_register(SCpnt);
+	nsp32_write4(base, SCSI_MSG_OUT, msgout);
+
 	/*
 	 * set selection timeout(= 250ms)
 	 */
@@ -700,7 +748,7 @@
 
 	/*
 	 * set SREQ hazard killer sampling rate
-	 * 
+	 *
 	 * TODO: sample_rate (BASE+0F) is 0 when internal clock = 40MHz.
 	 *      check other internal clock!
 	 */
@@ -723,10 +771,10 @@
 	nsp32_write1(base, ACK_WIDTH, data->cur_target->ackwidth);
 
 	nsp32_dbg(NSP32_DEBUG_AUTOSCSI,
-		  "syncreg=0x%x, ackwidth=0x%x, sgtpaddr=0x%x, id=0x%x",
+		  "syncreg=0x%x, ackwidth=0x%x, sgtpaddr=0x%lx, id=0x%x",
 		  nsp32_read1(base, SYNC_REG), nsp32_read1(base, ACK_WIDTH),
 		  nsp32_read4(base, SGT_ADR), nsp32_read1(base, SCSI_OUT_LATCH_TARGET_ID));
-	nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "msgout_len=%d, msgout=0x%x",
+	nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "msgout_len=%d, msgout=0x%lx",
 		  data->msgout_len, msgout);
 
 	/*
@@ -737,16 +785,24 @@
 	/*
 	 * set TRANSFER CONTROL REG
 	 */
-	command = 0;
-	command |= (TRANSFER_GO | ALL_COUNTER_CLR);
-	if (data->trans_method & NSP32_TRANSFER_BUSMASTER) {
+	command = (TRANSFER_GO | ALL_COUNTER_CLR);
+	switch (data->trans_method) {
+	case NSP32_TRANSFER_BUSMASTER:
 		if (SCpnt->request_bufflen > 0) {
 			command |= BM_START;
 		}
-	} else if (data->trans_method & NSP32_TRANSFER_MMIO) {
+		break;
+	case NSP32_TRANSFER_MMIO:
 		command |= CB_MMIO_MODE;
-	} else if (data->trans_method & NSP32_TRANSFER_PIO) {
+		break;
+	case NSP32_TRANSFER_PIO:
 		command |= CB_IO_MODE;
+		break;
+	default:
+		nsp32_msg(KERN_ERR, "unknown transfer mode");
+		status = FALSE;
+		goto out;
+		break;
 	}
 	nsp32_write2(base, TRANSFER_CONTROL, command);
 
@@ -763,7 +819,7 @@
 	/*
 	 * Check arbitration
 	 */
-	status = nsp32_arbitration(SCpnt, base);
+	status = nsp32_arbitration(SCpnt);
 
  out:
 	/*
@@ -777,23 +833,25 @@
 
 /*
  * Arbitration Status Check
- *	
+ *
  * Note: Arbitration counter is waited during ARBIT_GO is not lifting.
- *	 Using udelay(1) consumes CPU time and system time, but 
+ *	 Using udelay(1) consumes CPU time and system time, but
  *	 arbitration delay time is defined minimal 2.4us in SCSI
  *	 specification, thus udelay works as coarse grained wait timer.
  */
-static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
+static int nsp32_arbitration(struct scsi_cmnd *SCpnt)
 {
-	unsigned char arbit;
+	const unsigned int  base   = SCpnt->device->host->io_port;
 	int	      status = TRUE;
 	int	      time   = 0;
+	unsigned char arbit;
 
 	do {
+		udelay(1);
 		arbit = nsp32_read1(base, ARBIT_STATUS);
 		time++;
 	} while ((arbit & (ARBIT_WIN | ARBIT_FAIL)) == 0 &&
-		 (time <= ARBIT_TIMEOUT_TIME));
+		 (time <= ARBIT_TIMEOUT_COUNT));
 
 	nsp32_dbg(NSP32_DEBUG_AUTOSCSI,
 		  "arbit: 0x%x, delay time: %d", arbit, time);
@@ -814,7 +872,7 @@
 		nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "arbit timeout");
 		SCpnt->result = DID_NO_CONNECT << 16;
 		status = FALSE;
-        }
+	}
 
 	/*
 	 * clear Arbit
@@ -835,8 +893,8 @@
 static int nsp32_reselection(struct scsi_cmnd *SCpnt, unsigned char newlun)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int   host_id = SCpnt->device->host->this_id;
-	unsigned int   base    = SCpnt->device->host->io_port;
+	const unsigned int   host_id = SCpnt->device->host->this_id;
+	const unsigned int   base    = SCpnt->device->host->io_port;
 	unsigned char  tmpid, newid;
 
 	nsp32_dbg(NSP32_DEBUG_RESELECTION, "enter");
@@ -848,7 +906,7 @@
 	tmpid &= (~BIT(host_id));
 	newid = 0;
 	while (tmpid) {
-		if (tmpid & 1) {
+		if (tmpid & BIT(0)) {
 			break;
 		}
 		tmpid >>= 1;
@@ -889,10 +947,10 @@
 static int nsp32_setup_sg_table(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	struct scatterlist   *sgl;
-	nsp32_sgtable *sgt = data->cur_lunt->sglun->sgt;
+	nsp32_sgtable *sgt  = data->cur_lunt->sglun->sgt;
+	struct scatterlist *sgl;
 	int num, i;
-	u32_le l;
+	u32 l;
 
 	if (SCpnt->request_bufflen == 0) {
 		return TRUE;
@@ -917,11 +975,11 @@
 
 			if (le32_to_cpu(sgt[i].len) > 0x10000) {
 				nsp32_msg(KERN_ERR,
-					"can't transfer over 64KB at a time, size=0x%lx", le32_to_cpu(sgt[i].len));
+					"can't transfer over 64KB at a time, size=0x%x", le32_to_cpu(sgt[i].len));
 				return FALSE;
 			}
 			nsp32_dbg(NSP32_DEBUG_SGLIST,
-				  "num 0x%x : addr 0x%lx len 0x%lx",
+				  "num 0x%x : addr 0x%x len 0x%x",
 				  i,
 				  le32_to_cpu(sgt[i].addr),
 				  le32_to_cpu(sgt[i].len ));
@@ -932,19 +990,21 @@
 		sgt[num-1].len = cpu_to_le32(l | SGTEND);
 
 	} else {
-		SCpnt->SCp.have_data_in	= pci_map_single(data->Pci,
-			SCpnt->request_buffer, SCpnt->request_bufflen,
-			SCpnt->sc_data_direction);
+		SCpnt->SCp.have_data_in	=
+			pci_map_single(data->Pci,
+				       SCpnt->request_buffer,
+				       SCpnt->request_bufflen,
+				       SCpnt->sc_data_direction);
 
 		sgt[0].addr = cpu_to_le32(SCpnt->SCp.have_data_in);
 		sgt[0].len  = cpu_to_le32(SCpnt->request_bufflen | SGTEND); /* set end mark */
 
 		if (SCpnt->request_bufflen > 0x10000) {
 			nsp32_msg(KERN_ERR,
-				  "can't transfer over 64KB at a time, size=0x%lx", SCpnt->request_bufflen);
+				  "can't transfer over 64KB at a time, size=0x%x", SCpnt->request_bufflen);
 			return FALSE;
 		}
-		nsp32_dbg(NSP32_DEBUG_SGLIST, "single : addr 0x%lx len=0x%lx",
+		nsp32_dbg(NSP32_DEBUG_SGLIST, "single : addr 0x%x len=0x%x",
 			  le32_to_cpu(sgt[0].addr),
 			  le32_to_cpu(sgt[0].len ));
 	}
@@ -961,41 +1021,42 @@
 
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
 		  "enter. target: 0x%x LUN: 0x%x cmnd: 0x%x cmndlen: 0x%x "
-		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
+		  "use_sg: 0x%x reqbuf: 0x%p reqlen: 0x%x",
 		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
 		  SCpnt->use_sg, SCpnt->request_buffer, SCpnt->request_bufflen);
 
 	if (data->CurrentSC != NULL) {
-		nsp32_msg(KERN_ERR, "Currentsc != NULL. Cancel this command request");
+		nsp32_msg(KERN_ERR, "CurrentSC != NULL or worker is still active. Cancel this command request");
 		data->CurrentSC = NULL;
-		SCpnt->result   = DID_NO_CONNECT << 16;
+		SCpnt->result   = DID_BAD_TARGET << 16;
 		done(SCpnt);
-		return 0;
+
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* check target ID is not same as this initiator ID */
 	if (SCpnt->device->id == SCpnt->device->host->this_id) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "terget==host???");
 		SCpnt->result = DID_BAD_TARGET << 16;
-		done(SCpnt);
-		return 0;
+		nsp32_scsi_done(SCpnt);
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
 	/* check target LUN is allowable value */
 	if (SCpnt->device->lun >= MAX_LUN) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
 		SCpnt->result = DID_BAD_TARGET << 16;
-		done(SCpnt);
-		return 0;
+		nsp32_scsi_done(SCpnt);
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
 	show_command(SCpnt);
 
 	SCpnt->scsi_done     = done;
-	data->CurrentSC      = SCpnt;
-	SCpnt->SCp.Status    = CHECK_CONDITION;
-	SCpnt->SCp.Message   = 0;
-	SCpnt->resid         = SCpnt->request_bufflen;
+	data->CurrentSC	     = SCpnt;
+	SCpnt->SCp.Status    = SAM_STAT_GOOD;
+	SCpnt->SCp.Message   = COMMAND_COMPLETE;
+	SCpnt->resid	     = SCpnt->request_bufflen;
 
 	SCpnt->SCp.ptr		    = (char *) SCpnt->request_buffer;
 	SCpnt->SCp.this_residual    = SCpnt->request_bufflen;
@@ -1018,13 +1079,13 @@
 		nsp32_msg(KERN_ERR, "SGT fail");
 		SCpnt->result = DID_ERROR << 16;
 		nsp32_scsi_done(SCpnt);
-		return 0;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* Build IDENTIFY */
 	nsp32_build_identify(SCpnt);
 
-	/* 
+	/*
 	 * If target is the first time to transfer after the reset
 	 * (target don't have SDTR_DONE and SDTR_INITIATOR), sync
 	 * message SDTR is needed to do synchronous transfer.
@@ -1078,6 +1139,7 @@
 		  SCpnt->device->id, target->sync_flag, target->syncreg,
 		  target->ackwidth);
 
+	/* start selection phase */
 	/* Selection */
 	if (auto_param == 0) {
 		ret = nsp32_selection_autopara(SCpnt);
@@ -1088,6 +1150,7 @@
 	if (ret != TRUE) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "selection fail");
 		nsp32_scsi_done(SCpnt);
+		return 0; //SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
 	return 0;
@@ -1096,7 +1159,7 @@
 /* initialize asic */
 static int nsp32hw_init(nsp32_hw_data *data)
 {
-	unsigned int   base = data->BaseAddress;
+	const unsigned int   base = data->BaseAddress;
 	unsigned short irq_stat;
 	unsigned long  lc_reg;
 	unsigned char  power;
@@ -1107,9 +1170,9 @@
 		nsp32_index_write2(base, CFG_LATE_CACHE, lc_reg & 0xffff);
 	}
 
-	nsp32_write2(base, IRQ_CONTROL,        IRQ_CONTROL_ALL_IRQ_MASK);
+	nsp32_write2(base, IRQ_CONTROL,	       IRQ_CONTROL_ALL_IRQ_MASK);
 	nsp32_write2(base, TRANSFER_CONTROL,   0);
-	nsp32_write4(base, BM_CNT,             0);
+	nsp32_write4(base, BM_CNT,	       0);
 	nsp32_write2(base, SCSI_EXECUTE_PHASE, 0);
 
 	do {
@@ -1121,15 +1184,19 @@
 	 * Fill FIFO_FULL_SHLD, FIFO_EMPTY_SHLD. Below parameter is
 	 *  designated by specification.
 	 */
-	if ((data->trans_method & NSP32_TRANSFER_PIO) ||
-	    (data->trans_method & NSP32_TRANSFER_MMIO)) {
+	switch (data->trans_method) {
+	case NSP32_TRANSFER_PIO:
+	case NSP32_TRANSFER_MMIO:
 		nsp32_index_write1(base, FIFO_FULL_SHLD_COUNT,  0x40);
 		nsp32_index_write1(base, FIFO_EMPTY_SHLD_COUNT, 0x40);
-	} else if (data->trans_method & NSP32_TRANSFER_BUSMASTER) {
+		break;
+	case NSP32_TRANSFER_BUSMASTER:
 		nsp32_index_write1(base, FIFO_FULL_SHLD_COUNT,  0x10);
 		nsp32_index_write1(base, FIFO_EMPTY_SHLD_COUNT, 0x60);
-	} else {
+		break;
+	default:
 		nsp32_dbg(NSP32_DEBUG_INIT, "unknown transfer mode");
+		break;
 	}
 
 	nsp32_dbg(NSP32_DEBUG_INIT, "full 0x%x emp 0x%x",
@@ -1142,7 +1209,7 @@
 
 	/*
 	 * initialize MISC_WRRD register
-	 * 
+	 *
 	 * Note: Designated parameters is obeyed as following:
 	 *	MISC_SCSI_DIRECTION_DETECTOR_SELECT: It must be set.
 	 *	MISC_MASTER_TERMINATION_SELECT:      It must be set.
@@ -1157,10 +1224,10 @@
 	 */
 	nsp32_index_write2(base, MISC_WR,
 			   (SCSI_DIRECTION_DETECTOR_SELECT |
-			    DELAYED_BMSTART                |
-			    MASTER_TERMINATION_SELECT      |
-			    BMREQ_NEGATE_TIMING_SEL        |
-			    AUTOSEL_TIMING_SEL             |
+			    DELAYED_BMSTART		   |
+			    MASTER_TERMINATION_SELECT	   |
+			    BMREQ_NEGATE_TIMING_SEL	   |
+			    AUTOSEL_TIMING_SEL		   |
 			    BMSTOP_CHANGE2_NONDATA_PHASE));
 
 	nsp32_index_write1(base, TERM_PWR_CONTROL, 0);
@@ -1181,15 +1248,15 @@
 	 * enable to select designated IRQ (except for
 	 * IRQSELECT_SERR, IRQSELECT_PERR, IRQSELECT_BMCNTERR)
 	 */
-	nsp32_index_write2(base, IRQ_SELECT, IRQSELECT_TIMER_IRQ         |
-			                     IRQSELECT_SCSIRESET_IRQ     |
-			                     IRQSELECT_FIFO_SHLD_IRQ     |
-			                     IRQSELECT_RESELECT_IRQ      |
-			                     IRQSELECT_PHASE_CHANGE_IRQ  |
-			                     IRQSELECT_AUTO_SCSI_SEQ_IRQ |
-			                  //   IRQSELECT_BMCNTERR_IRQ      |
-			                     IRQSELECT_TARGET_ABORT_IRQ  |
-			                     IRQSELECT_MASTER_ABORT_IRQ );
+	nsp32_index_write2(base, IRQ_SELECT, IRQSELECT_TIMER_IRQ	 |
+					     IRQSELECT_SCSIRESET_IRQ	 |
+					     IRQSELECT_FIFO_SHLD_IRQ	 |
+					     IRQSELECT_RESELECT_IRQ	 |
+					     IRQSELECT_PHASE_CHANGE_IRQ	 |
+					     IRQSELECT_AUTO_SCSI_SEQ_IRQ |
+					  //   IRQSELECT_BMCNTERR_IRQ	   |
+					     IRQSELECT_TARGET_ABORT_IRQ	 |
+					     IRQSELECT_MASTER_ABORT_IRQ );
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
 	/* PCI LED off */
@@ -1204,26 +1271,21 @@
 static irqreturn_t do_nsp32_isr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	nsp32_hw_data *data = dev_id;
-	unsigned int base = data->BaseAddress;
-	struct scsi_cmnd *SCpnt = data->CurrentSC;
+	const unsigned int base   = data->BaseAddress;
+	struct scsi_cmnd    *SCpnt = data->CurrentSC;
 	unsigned short auto_stat, irq_stat, trans_stat;
 	unsigned char busmon, busphase;
 	unsigned long flags;
 	int ret;
 	int handled = 0;
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-	struct Scsi_Host *host = data->Host;
-	spin_lock_irqsave(host->host_lock, flags);
-#else
-	spin_lock_irqsave(&io_request_lock, flags);
-#endif
+	spin_lock_irqsave(HOST_LOCK, flags);
 
 	/*
 	 * IRQ check, then enable IRQ mask
 	 */
 	irq_stat = nsp32_read2(base, IRQ_STATUS);
-	nsp32_dbg(NSP32_DEBUG_INTR, 
+	nsp32_dbg(NSP32_DEBUG_INTR,
 		  "enter IRQ: %d, IRQstatus: 0x%x", irq, irq_stat);
 	/* is this interrupt comes from Ninja asic? */
 	if ((irq_stat & IRQSTATUS_ANY_IRQ) == 0) {
@@ -1315,7 +1377,7 @@
 		if ((auto_stat & DATA_IN_PHASE) &&
 		    (SCpnt->resid > 0) &&
 		    ((nsp32_read2(base, FIFO_REST_CNT) & FIFO_REST_MASK) != 0)) {
-			printk( "auto+fifo\n");
+			nsp32_dbg(NSP32_DEBUG_INTR, "auto+fifo\n");
 			//nsp32_pio_read(SCpnt);
 		}
 
@@ -1325,18 +1387,30 @@
 				  "Data in/out phase processed");
 
 			/* read BMCNT, SGT pointer addr */
-			nsp32_dbg(NSP32_DEBUG_INTR, "BMCNT=0x%lx", 
-				    nsp32_read4(base, BM_CNT));
-			nsp32_dbg(NSP32_DEBUG_INTR, "addr=0x%lx", 
-				    nsp32_read4(base, SGT_ADR));
-			nsp32_dbg(NSP32_DEBUG_INTR, "SACK=0x%lx", 
-				    nsp32_read4(base, SACK_CNT));
-			nsp32_dbg(NSP32_DEBUG_INTR, "SSACK=0x%lx", 
-				    nsp32_read4(base, SAVED_SACK_CNT));
+			nsp32_dbg(NSP32_DEBUG_INTR, "BMCNT=0x%lx",
+				  nsp32_read4(base, BM_CNT));
+			nsp32_dbg(NSP32_DEBUG_INTR, "addr=0x%lx",
+				  nsp32_read4(base, SGT_ADR));
+			nsp32_dbg(NSP32_DEBUG_INTR, "SACK=0x%lx",
+				  nsp32_read4(base, SACK_CNT));
+			nsp32_dbg(NSP32_DEBUG_INTR, "SSACK=0x%lx",
+				  nsp32_read4(base, SAVED_SACK_CNT));
 
 			SCpnt->resid = 0; /* all data transfered! */
 		}
 
+		if (auto_stat & STATUS_PHASE) {
+			/*
+			 * Read CSB and substitute CSB for SCpnt->result
+			 * to save status phase stutas byte.
+			 * scsi error handler checks host_byte (DID_*:
+			 * low level driver to indicate status), then checks
+			 * status_byte (SCSI status byte).
+			 */
+			SCpnt->result = SCpnt->SCp.Status =
+				nsp32_read1(base, SCSI_CSB_IN);
+		}
+
 		/*
 		 * MsgIn Occur
 		 */
@@ -1361,20 +1435,9 @@
 			}
 		}
 
-		if (auto_stat & STATUS_PHASE) {
-			/*
-			 * Read CSB and substitute CSB for SCpnt->result
-			 * to save status phase stutas byte.
-			 * scsi error handler checks host_byte (DID_*:
-			 * low level driver to indicate status), then checks 
-			 * status_byte (SCSI status byte).
-			 */
-			SCpnt->result =	(int)nsp32_read1(base, SCSI_CSB_IN);
-		}
-
 		if (auto_stat & ILLEGAL_PHASE) {
 			/* Illegal phase is detected. SACK is not back. */
-			nsp32_msg(KERN_WARNING, 
+			nsp32_msg(KERN_WARNING,
 				  "AUTO SCSI ILLEGAL PHASE OCCUR!!!!");
 
 			/* TODO: currently we don't have any action... bus reset? */
@@ -1481,11 +1544,7 @@
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
  out2:
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-	spin_unlock_irqrestore(host->host_lock, flags);
-#else
-	spin_unlock_irqrestore(&io_request_lock, flags);
-#endif
+	spin_unlock_irqrestore(HOST_LOCK, flags);
 
 	nsp32_dbg(NSP32_DEBUG_INTR, "exit");
 
@@ -1501,38 +1560,38 @@
 		} \
 	} while(0)
 static int nsp32_proc_info(
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	struct Scsi_Host *host,
 #endif
-	char             *buffer,
-	char            **start,
-	off_t             offset,
-	int               length,
-#if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
-	int               hostno,
-#endif
-	int               inout)
-{
-	char             *pos = buffer;
-	int               thislength;
-	unsigned long     flags;
-	nsp32_hw_data    *data;
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
-	int               hostno;
+	char		 *buffer,
+	char		**start,
+	off_t		  offset,
+	int		  length,
+#if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
+	int		  hostno,
+#endif
+	int		  inout)
+{
+	char		 *pos = buffer;
+	int		  thislength;
+	unsigned long	  flags;
+	nsp32_hw_data	 *data;
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
+	int		  hostno;
 #else
 	struct Scsi_Host *host;
 #endif
-	unsigned int      base;
-	unsigned char     mode_reg;
-	int               id, speed;
-	long              model;
+	unsigned int	  base;
+	unsigned char	  mode_reg;
+	int		  id;
+	long		  model;
 
 	/* Write is not supported, just return. */
 	if (inout == TRUE) {
 		return -EINVAL;
 	}
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	hostno = host->host_no;
 #else
 	/* search this HBA host */
@@ -1545,19 +1604,19 @@
 	base = host->io_port;
 
 	SPRINTF("NinjaSCSI-32 status\n\n");
-	SPRINTF("Driver version:        %s, $Revision: 1.33 $\n", nsp32_release_version);
+	SPRINTF("Driver version:        %s, $Revision: 1.66 $\n", nsp32_release_version);
 	SPRINTF("SCSI host No.:         %d\n",		hostno);
 	SPRINTF("IRQ:                   %d\n",		host->irq);
 	SPRINTF("IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
 	SPRINTF("MMIO(virtual address): 0x%lx-0x%lx\n",	host->base, host->base + data->MmioLength - 1);
 	SPRINTF("sg_tablesize:          %d\n",		host->sg_tablesize);
-	SPRINTF("Chip revision:         0x%x\n",       	(nsp32_read2(base, INDEX_REG) >> 8) & 0xff);
+	SPRINTF("Chip revision:         0x%x\n",	(nsp32_read2(base, INDEX_REG) >> 8) & 0xff);
 
 	mode_reg = nsp32_index_read1(base, CHIP_MODE);
 	model    = data->pci_devid->driver_data;
 
 #ifdef CONFIG_PM
-	SPRINTF("Power Management:      %s\n",          (mode_reg & OPTF) ? "yes" : "no");
+	SPRINTF("Power Management:	%s\n",		(mode_reg & OPTF) ? "yes" : "no");
 #endif
 	SPRINTF("OEM:                   %ld, %s\n",     (mode_reg & (OEM0|OEM1)), nsp32_model[model]);
 
@@ -1567,9 +1626,9 @@
 
 
 	SPRINTF("SDTR status\n");
-	for (id = 0; id < ARRAY_SIZE(data->target); id++) {
+	for(id = 0; id < ARRAY_SIZE(data->target); id++) {
 
-                SPRINTF("id %d: ", id);
+		SPRINTF("id %d: ", id);
 
 		if (id == host->this_id) {
 			SPRINTF("----- NinjaSCSI-32 host adapter\n");
@@ -1577,7 +1636,7 @@
 		}
 
 		if (data->target[id].sync_flag == SDTR_DONE) {
-			if (data->target[id].period == 0            &&
+			if (data->target[id].period == 0	    &&
 			    data->target[id].offset == ASYNC_OFFSET ) {
 				SPRINTF("async");
 			} else {
@@ -1588,6 +1647,7 @@
 		}
 
 		if (data->target[id].period != 0) {
+			int speed;
 
 			speed = 1000000 / (data->target[id].period * 4);
 
@@ -1604,9 +1664,9 @@
 	thislength = pos - (buffer + offset);
 
 	if(thislength < 0) {
-		*start = NULL;
-                return 0;
-        }
+		*start = 0;
+		return 0;
+	}
 
 
 	thislength = min(thislength, length);
@@ -1625,7 +1685,7 @@
 static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int   base = SCpnt->device->host->io_port;
+	const unsigned int   base = SCpnt->device->host->io_port;
 
 	/*
 	 * unmap pci
@@ -1636,11 +1696,11 @@
 
 	if (SCpnt->use_sg) {
 		pci_unmap_sg(data->Pci,
-			     (struct scatterlist *)SCpnt->buffer,
+			     SCpnt->buffer,
 			     SCpnt->use_sg, SCpnt->sc_data_direction);
 	} else {
 		pci_unmap_single(data->Pci,
-				 (u32)SCpnt->SCp.have_data_in,
+				 SCpnt->SCp.have_data_in,
 				 SCpnt->request_bufflen,
 				 SCpnt->sc_data_direction);
 	}
@@ -1650,7 +1710,7 @@
 	 * clear TRANSFERCONTROL_BM_START
 	 */
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
-	nsp32_write4(base, BM_CNT,           0);
+	nsp32_write4(base, BM_CNT,	     0);
 
 	/*
 	 * call scsi_done
@@ -1661,9 +1721,9 @@
 	 * reset parameters
 	 */
 	data->cur_lunt->SCpnt = NULL;
-	data->cur_lunt        = NULL;
+	data->cur_lunt	      = NULL;
 	data->cur_target      = NULL;
-	data->CurrentSC      = NULL;
+	data->CurrentSC	      = NULL;
 }
 
 
@@ -1680,12 +1740,12 @@
 static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int base   = SCpnt->device->host->io_port;
+	const unsigned int   base = SCpnt->device->host->io_port;
 
 	nsp32_dbg(NSP32_DEBUG_BUSFREE, "enter execph=0x%x", execph);
 	show_autophase(execph);
 
-	nsp32_write4(base, BM_CNT,           0);
+	nsp32_write4(base, BM_CNT,	     0);
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
 
 	/*
@@ -1693,7 +1753,7 @@
 	 *
 	 * VALID:
 	 *   Save Data Pointer is received. Adjust pointer.
-	 *   
+	 *
 	 * NO-VALID:
 	 *   SCSI-3 says if Save Data Pointer is not received, then we restart
 	 *   processing and we can't adjust any SCSI data pointer in next data
@@ -1706,7 +1766,7 @@
 		 * Check sack_cnt/saved_sack_cnt, then adjust sg table if
 		 * needed.
 		 */
-		if (!(execph & MSGIN_00_VALID) && 
+		if (!(execph & MSGIN_00_VALID) &&
 		    ((execph & DATA_IN_PHASE) || (execph & DATA_OUT_PHASE))) {
 			unsigned int sacklen, s_sacklen;
 
@@ -1749,7 +1809,7 @@
 		 * no processing.
 		 */
 	}
-	
+
 	if (execph & MSGIN_03_VALID) {
 		/* MsgIn03 was valid to be processed. No need processing. */
 	}
@@ -1771,7 +1831,7 @@
 		 * negotiating.
 		 */
 		if (execph & (MSGIN_00_VALID | MSGIN_04_VALID)) {
-			/* 
+			/*
 			 * If valid message is received, then
 			 * negotiation is succeeded.
 			 */
@@ -1799,20 +1859,20 @@
 
 		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
 		SCpnt->SCp.Message = 0;
-		nsp32_dbg(NSP32_DEBUG_BUSFREE, 
+		nsp32_dbg(NSP32_DEBUG_BUSFREE,
 			  "normal end stat=0x%x resid=0x%x\n",
 			  SCpnt->SCp.Status, SCpnt->resid);
-		SCpnt->result = (DID_OK             << 16) |
-			        (SCpnt->SCp.Message <<  8) |
-			        (SCpnt->SCp.Status  <<  0);
+		SCpnt->result = (DID_OK		    << 16) |
+				(SCpnt->SCp.Message <<	8) |
+				(SCpnt->SCp.Status  <<	0);
 		nsp32_scsi_done(SCpnt);
 		/* All operation is done */
 		return TRUE;
 	} else if (execph & MSGIN_04_VALID) {
 		/* MsgIn 04: Disconnect */
-		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
+		//SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
 		SCpnt->SCp.Message = 4;
-		
+
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
 		return TRUE;
 	} else {
@@ -1821,7 +1881,7 @@
 
 		/* DID_ERROR? */
 		//SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Message << 8) | (SCpnt->SCp.Status << 0);
-		SCpnt->result = DID_ERROR << 16;
+		SCpnt->result = (DID_ERROR << 16) | (SCpnt->SCp.Status << 0);
 		nsp32_scsi_done(SCpnt);
 		return TRUE;
 	}
@@ -1838,20 +1898,20 @@
 static void nsp32_adjust_busfree(struct scsi_cmnd *SCpnt, unsigned int s_sacklen)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int                   old_entry = data->cur_entry;
-	int                   new_entry;
-	int                   sg_num = data->cur_lunt->sg_num;
-	nsp32_sgtable *sgt    = data->cur_lunt->sglun->sgt;
-	unsigned int          restlen, sentlen;
-	u32_le                len, addr;
+	int		      old_entry = data->cur_entry;
+	int		      new_entry;
+	int		      sg_num = data->cur_lunt->sg_num;
+	nsp32_sgtable	     *sgt    = data->cur_lunt->sglun->sgt;
+	unsigned int	      restlen, sentlen;
+	u32		      len, addr;
 
 	nsp32_dbg(NSP32_DEBUG_SGLIST, "old resid=0x%x", SCpnt->resid);
 
 	/* adjust saved SACK count with 4 byte start address boundary */
-	s_sacklen -= le32_to_cpu(sgt[old_entry].addr) & 3;
+	s_sacklen -= le32_to_cpu(sgt[old_entry].addr) & (BIT(1)|BIT(0));
 
 	/*
-	 * calculate new_entry from sack count and each sgt[].len 
+	 * calculate new_entry from sack count and each sgt[].len
 	 * calculate the byte which is intent to send
 	 */
 	sentlen = 0;
@@ -1869,7 +1929,7 @@
 
 	if (sentlen == s_sacklen) {
 		/* XXX: confirm it's ok or not */
-		/* In this case, it's ok because we are at 
+		/* In this case, it's ok because we are at
 		   the head element of the sg. restlen is correctly calculated. */
 	}
 
@@ -1885,7 +1945,7 @@
 
 	/* set cur_entry with new_entry */
 	data->cur_entry = new_entry;
- 
+
 	return;
 
  last:
@@ -1911,11 +1971,11 @@
 static void nsp32_msgout_occur(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int base   = SCpnt->device->host->io_port;
+	const unsigned int base   = SCpnt->device->host->io_port;
 	//unsigned short command;
 	long new_sgtp;
 	int i;
-	
+
 	nsp32_dbg(NSP32_DEBUG_MSGOUTOCCUR,
 		  "enter: msgout_len: 0x%x", data->msgout_len);
 
@@ -1928,11 +1988,11 @@
 	}
 
 	/*
-	 * Set SGTP ADDR current entry for restarting AUTOSCSI, 
+	 * Set SGTP ADDR current entry for restarting AUTOSCSI,
 	 * because SGTP is incremented next point.
 	 * There is few statement in the specification...
 	 */
- 	new_sgtp = data->cur_lunt->sglun_paddr + 
+	new_sgtp = data->cur_lunt->sglun_paddr +
 		   (data->cur_lunt->cur_entry * sizeof(nsp32_sgtable));
 
 	/*
@@ -1956,11 +2016,11 @@
 			//command = (AUTO_MSGIN_00_OR_04 | AUTO_MSGIN_02);
 			//nsp32_restart_autoscsi(SCpnt, command);
 			nsp32_write2(base, COMMAND_CONTROL,
-					 (CLEAR_CDB_FIFO_POINTER |
-					  AUTO_COMMAND_PHASE     |
-					  AUTOSCSI_RESTART       |
-					  AUTO_MSGIN_00_OR_04    |
-					  AUTO_MSGIN_02          ));
+				     (CLEAR_CDB_FIFO_POINTER |
+				      AUTO_COMMAND_PHASE     |
+				      AUTOSCSI_RESTART	     |
+				      AUTO_MSGIN_00_OR_04    |
+				      AUTO_MSGIN_02	     ));
 		}
 		/*
 		 * Write data with SACK, then wait sack is
@@ -1987,7 +2047,7 @@
 static void nsp32_restart_autoscsi(struct scsi_cmnd *SCpnt, unsigned short command)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int   base = data->BaseAddress;
+	const unsigned int   base     = SCpnt->device->host->io_port;
 	unsigned short transfer = 0;
 
 	nsp32_dbg(NSP32_DEBUG_RESTART, "enter");
@@ -2020,16 +2080,22 @@
 	/*
 	 * set TRANSFER CONTROL REG
 	 */
-	transfer = 0;
-	transfer |= (TRANSFER_GO | ALL_COUNTER_CLR);
-	if (data->trans_method & NSP32_TRANSFER_BUSMASTER) {
+	transfer = (TRANSFER_GO | ALL_COUNTER_CLR);
+	switch (data->trans_method) {
+	case NSP32_TRANSFER_BUSMASTER:
 		if (SCpnt->request_bufflen > 0) {
 			transfer |= BM_START;
 		}
-	} else if (data->trans_method & NSP32_TRANSFER_MMIO) {
+		break;
+	case NSP32_TRANSFER_MMIO:
 		transfer |= CB_MMIO_MODE;
-	} else if (data->trans_method & NSP32_TRANSFER_PIO) {
+		break;
+	case NSP32_TRANSFER_PIO:
 		transfer |= CB_IO_MODE;
+		break;
+	default:
+		nsp32_msg(KERN_ERR, "unknown transfer mode");
+		break;
 	}
 	nsp32_write2(base, TRANSFER_CONTROL, transfer);
 
@@ -2055,14 +2121,14 @@
 			      unsigned short execph)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int   base = SCpnt->device->host->io_port;
+	const unsigned int   base = SCpnt->device->host->io_port;
 	unsigned char  msg;
 	unsigned char  msgtype;
 	unsigned char  newlun;
-	unsigned short command  = 0;
-	int            msgclear = TRUE;
-	long           new_sgtp;
-	int            ret;
+	unsigned short command	= 0;
+	int	       msgclear = TRUE;
+	long	       new_sgtp;
+	int	       ret;
 
 	/*
 	 * read first message
@@ -2088,7 +2154,7 @@
 	/*
 	 * processing IDENTIFY
 	 */
-	if (msgtype & 0x80) {
+	if (msgtype & BIT(7)) {
 		if (!(irq_status & IRQSTATUS_RESELECT_OCCUER)) {
 			/* Invalid (non reselect) phase */
 			goto reject;
@@ -2102,7 +2168,7 @@
 			goto reject;
 		}
 	}
-	
+
 	/*
 	 * processing messages except for IDENTIFY
 	 *
@@ -2118,10 +2184,10 @@
 		 * These messages should not be occurred.
 		 * They should be processed on AutoSCSI sequencer.
 		 */
-		nsp32_msg(KERN_WARNING, 
+		nsp32_msg(KERN_WARNING,
 			   "unexpected message of AutoSCSI MsgIn: 0x%x", msg);
 		break;
-		
+
 	case RESTORE_POINTERS:
 		/*
 		 * AutoMsgIn03 is disabled, and HBA gets this message.
@@ -2147,7 +2213,7 @@
 		/*
 		 * set new sg pointer
 		 */
-		new_sgtp = data->cur_lunt->sglun_paddr + 
+		new_sgtp = data->cur_lunt->sglun_paddr +
 			(data->cur_lunt->cur_entry * sizeof(nsp32_sgtable));
 		nsp32_write4(base, SGT_ADR, new_sgtp);
 
@@ -2158,13 +2224,13 @@
 		 * These messages should not be occurred.
 		 * They should be processed on AutoSCSI sequencer.
 		 */
-		nsp32_msg (KERN_WARNING, 
+		nsp32_msg (KERN_WARNING,
 			   "unexpected message of AutoSCSI MsgIn: SAVE_POINTERS");
-		
+
 		break;
-		
+
 	case MESSAGE_REJECT:
-		/* If previous message_out is sending SDTR, and get 
+		/* If previous message_out is sending SDTR, and get
 		   message_reject from target, SDTR negotiation is failed */
 		if (data->cur_target->sync_flag &
 				(SDTR_INITIATOR | SDTR_TARGET)) {
@@ -2183,7 +2249,7 @@
 	case LINKED_CMD_COMPLETE:
 	case LINKED_FLG_CMD_COMPLETE:
 		/* queue tag is not supported currently */
-		nsp32_msg (KERN_WARNING, 
+		nsp32_msg (KERN_WARNING,
 			   "unsupported message: 0x%x", msgtype);
 		break;
 
@@ -2236,7 +2302,7 @@
 		}
 
 		/*
-		 * Reach here means regular length of each type of 
+		 * Reach here means regular length of each type of
 		 * extended messages.
 		 */
 		switch (data->msginbuf[2]) {
@@ -2271,12 +2337,12 @@
 			goto reject; /* not implemented yet */
 
 			break;
-			
+
 		default:
 			goto reject;
 		}
 		break;
-		
+
 	default:
 		goto reject;
 	}
@@ -2288,11 +2354,11 @@
 		/*
 		 * If restarting AutoSCSI, but there are some message to out
 		 * (msgout_len > 0), set AutoATN, and set SCSIMSGOUT as 0
-		 * (MV_VALID = 0). When commandcontrol is written with
+		 * (MSGOUT_VALID = 0). When commandcontrol is written with
 		 * AutoSCSI restart, at the same time MsgOutOccur should be
 		 * happened (however, such situation is really possible...?).
 		 */
-		if (data->msgout_len > 0) {	
+		if (data->msgout_len > 0) {
 			nsp32_write4(base, SCSI_MSG_OUT, 0);
 			command |= AUTO_ATN;
 		}
@@ -2334,7 +2400,7 @@
 	return;
 
  reject:
-	nsp32_msg(KERN_WARNING, 
+	nsp32_msg(KERN_WARNING,
 		  "invalid or unsupported MessageIn, rejected. "
 		  "current msg: 0x%x (len: 0x%x), processing msg: 0x%x",
 		  msg, data->msgin_len, msgtype);
@@ -2345,17 +2411,17 @@
 }
 
 /*
- * 
+ *
  */
-static void nsp32_analyze_sdtr(struct scsi_cmnd *SCpnt)
+static void nsp32_analyze_sdtr(const struct scsi_cmnd *SCpnt)
 {
-	nsp32_hw_data   *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	nsp32_target     *target     = data->cur_target;
-	nsp32_sync_table *synct;
-	unsigned char     get_period = data->msginbuf[3];
-	unsigned char     get_offset = data->msginbuf[4];
-	int               entry;
-	int               syncnum;
+	nsp32_hw_data	 *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
+	nsp32_target	 *target     = data->cur_target;
+	const nsp32_sync_table *synct;
+	unsigned char	  get_period = data->msginbuf[3];
+	unsigned char	  get_offset = data->msginbuf[4];
+	int		  entry;
+	int		  syncnum;
 
 	nsp32_dbg(NSP32_DEBUG_MSGINOCCUR, "enter");
 
@@ -2366,30 +2432,30 @@
 	 * If this inititor sent the SDTR message, then target responds SDTR,
 	 * initiator SYNCREG, ACKWIDTH from SDTR parameter.
 	 * Messages are not appropriate, then send back reject message.
-	 * If initiator did not send the SDTR, but target sends SDTR, 
+	 * If initiator did not send the SDTR, but target sends SDTR,
 	 * initiator calculator the appropriate parameter and send back SDTR.
-	 */	
+	 */
 	if (target->sync_flag & SDTR_INITIATOR) {
 		/*
 		 * Initiator sent SDTR, the target responds and
 		 * send back negotiation SDTR.
 		 */
 		nsp32_dbg(NSP32_DEBUG_MSGINOCCUR, "target responds SDTR");
-	
+
 		target->sync_flag &= ~SDTR_INITIATOR;
 		target->sync_flag |= SDTR_DONE;
 
 		/*
 		 * offset:
 		 */
-		if (get_offset > SYNC_OFFSET) {
+		if (get_offset > MAX_OFFSET) {
 			/*
 			 * Negotiation is failed, the target send back
 			 * unexpected offset value.
 			 */
 			goto reject;
 		}
-		
+
 		if (get_offset == ASYNC_OFFSET) {
 			/*
 			 * Negotiation is succeeded, the target want
@@ -2420,7 +2486,7 @@
 
 		if (entry < 0) {
 			/*
-			 * Target want to use long period which is not 
+			 * Target want to use long period which is not
 			 * acceptable NinjaSCSI-32Bi/UDE.
 			 */
 			goto reject;
@@ -2433,13 +2499,13 @@
 	} else {
 		/* Target send SDTR to initiator. */
 		nsp32_dbg(NSP32_DEBUG_MSGINOCCUR, "target send SDTR");
-	
+
 		target->sync_flag |= SDTR_INITIATOR;
 
 		/* offset: */
-		if (get_offset > SYNC_OFFSET) {
-			/* send back as SYNC_OFFSET */
-			get_offset = SYNC_OFFSET;
+		if (get_offset > MAX_OFFSET) {
+			/* send back as MAX_OFFSET */
+			get_offset = MAX_OFFSET;
 		}
 
 		/* period: */
@@ -2482,7 +2548,7 @@
  * Search config entry number matched in sync_table from given
  * target and speed period value. If failed to search, return negative value.
  */
-static int nsp32_search_period_entry(nsp32_hw_data *data,
+static int nsp32_search_period_entry(const nsp32_hw_data *data,
 				     nsp32_target  *target,
 				     unsigned char  period)
 {
@@ -2515,9 +2581,9 @@
 /*
  * target <-> initiator use ASYNC transfer
  */
-static void nsp32_set_async(nsp32_hw_data *data, nsp32_target *target)
+static void nsp32_set_async(const nsp32_hw_data *data, nsp32_target *target)
 {
-	unsigned char period = data->synct[target->limit_entry].period_num;
+	const unsigned char period = data->synct[target->limit_entry].period_num;
 
 	target->offset     = ASYNC_OFFSET;
 	target->period     = 0;
@@ -2532,7 +2598,7 @@
 /*
  * target <-> initiator use maximum SYNC transfer
  */
-static void nsp32_set_max_sync(nsp32_hw_data *data,
+static void nsp32_set_max_sync(const nsp32_hw_data *data,
 			       nsp32_target  *target,
 			       unsigned char *period,
 			       unsigned char *offset)
@@ -2542,7 +2608,7 @@
 	period_num = data->synct[target->limit_entry].period_num;
 	*period    = data->synct[target->limit_entry].start_period;
 	ackwidth   = data->synct[target->limit_entry].ackwidth;
-	*offset    = SYNC_OFFSET;
+	*offset    = MAX_OFFSET;
 
 	target->syncreg    = TO_SYNCREG(period_num, *offset);
 	target->ackwidth   = ackwidth;
@@ -2554,10 +2620,10 @@
 /*
  * target <-> initiator use entry number speed
  */
-static void nsp32_set_sync_entry(nsp32_hw_data *data,
+static void nsp32_set_sync_entry(const nsp32_hw_data *data,
 				 nsp32_target  *target,
-				 int            entry,
-				 unsigned char  offset)
+				 int		entry,
+				 unsigned char	offset)
 {
 	unsigned char period, ackwidth, sample_rate;
 
@@ -2583,11 +2649,11 @@
  *     SCSI REQ becomes negation in order to negate SCSI ACK signal for
  *     REQ-ACK handshake.
  */
-static void nsp32_wait_req(nsp32_hw_data *data, int state)
+static void nsp32_wait_req(const nsp32_hw_data *data, int state)
 {
-	unsigned int  base      = data->BaseAddress;
-	int           wait_time = 0;
-	unsigned char bus, req_bit;
+	const unsigned int  base      = data->BaseAddress;
+	int		    wait_time = 0;
+	unsigned char	    req_bit;
 
 	if (!((state == ASSERT) || (state == NEGATE))) {
 		nsp32_msg(KERN_ERR, "unknown state designation");
@@ -2596,15 +2662,16 @@
 	req_bit = (state == ASSERT ? BUSMON_REQ : 0);
 
 	do {
+		unsigned char bus;
 		bus = nsp32_read1(base, SCSI_BUS_MONITOR);
 		if ((bus & BUSMON_REQ) == req_bit) {
-			nsp32_dbg(NSP32_DEBUG_WAIT, 
+			nsp32_dbg(NSP32_DEBUG_WAIT,
 				  "wait_time: %d", wait_time);
 			return;
 		}
 		udelay(1);
 		wait_time++;
-	} while (wait_time < REQSACK_TIMEOUT_TIME);
+	} while (wait_time < REQSACK_TIMEOUT_COUNT);
 
 	nsp32_msg(KERN_WARNING, "wait REQ timeout, req_bit: 0x%x", req_bit);
 }
@@ -2612,11 +2679,11 @@
 /*
  * It waits until SCSI SACK becomes assertion or negation state.
  */
-static void nsp32_wait_sack(nsp32_hw_data *data, int state)
+static void nsp32_wait_sack(const nsp32_hw_data *data, int state)
 {
-	unsigned int  base      = data->BaseAddress;
-	int           wait_time = 0;
-	unsigned char bus, ack_bit;
+	const unsigned int  base      = data->BaseAddress;
+	int		    wait_time = 0;
+	unsigned char	    ack_bit;
 
 	if (!((state == ASSERT) || (state == NEGATE))) {
 		nsp32_msg(KERN_ERR, "unknown state designation");
@@ -2625,6 +2692,7 @@
 	ack_bit = (state == ASSERT ? BUSMON_ACK : 0);
 
 	do {
+		unsigned char bus;
 		bus = nsp32_read1(base, SCSI_BUS_MONITOR);
 		if ((bus & BUSMON_ACK) == ack_bit) {
 			nsp32_dbg(NSP32_DEBUG_WAIT,
@@ -2633,7 +2701,7 @@
 		}
 		udelay(1);
 		wait_time++;
-	} while (wait_time < REQSACK_TIMEOUT_TIME);
+	} while (wait_time < REQSACK_TIMEOUT_COUNT);
 
 	nsp32_msg(KERN_WARNING, "wait SACK timeout, ack_bit: 0x%x", ack_bit);
 }
@@ -2643,9 +2711,9 @@
  *
  * Note: SCSI ACK assertion needs with ACKENB=1, AUTODIRECTION=1.
  */
-static void nsp32_sack_assert(nsp32_hw_data *data)
+static void nsp32_sack_assert(const nsp32_hw_data *data)
 {
-	unsigned int  base = data->BaseAddress;
+	const unsigned int  base = data->BaseAddress;
 	unsigned char busctrl;
 
 	busctrl  = nsp32_read1(base, SCSI_BUS_CONTROL);
@@ -2656,9 +2724,9 @@
 /*
  * negate SCSI ACK
  */
-static void nsp32_sack_negate(nsp32_hw_data *data)
+static void nsp32_sack_negate(const nsp32_hw_data *data)
 {
-	unsigned int  base = data->BaseAddress;
+	const unsigned int  base = data->BaseAddress;
 	unsigned char busctrl;
 
 	busctrl  = nsp32_read1(base, SCSI_BUS_CONTROL);
@@ -2688,10 +2756,10 @@
 #endif
 {
 	struct Scsi_Host *host;	/* registered host structure */
-	struct resource  *res;
-	nsp32_hw_data    *data;
-	int               ret;
-	int               i, j;
+	struct resource	 *res;
+	nsp32_hw_data	 *data;
+	int		  ret, eeprom_ret;
+	int		  n_target, n_lun, i;
 
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "enter");
 
@@ -2713,7 +2781,7 @@
 	 */
 	data = (nsp32_hw_data *)host->hostdata;
 
-	memcpy(data, &nsp32_data_base, sizeof(nsp32_hw_data));
+	*data = nsp32_data_base;
 
 	host->irq       = data->IrqNumber;
 	host->io_port   = data->BaseAddress;
@@ -2777,9 +2845,9 @@
 	 */
 
 	/*
-	 * setup DMA 
+	 * setup DMA
 	 */
-	if (pci_set_dma_mask(PCIDEV, 0xffffffffUL) != 0) {
+	if (pci_set_dma_mask(PCIDEV, DMA_32BIT_MASK) != 0) {
 		nsp32_msg (KERN_ERR, "failed to set PCI DMA mask");
 		goto scsi_unregister;
 	}
@@ -2803,20 +2871,20 @@
 		goto free_autoparam;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(data->lunt); i++) {
-		for (j = 0; j < ARRAY_SIZE(data->lunt[0]); j++) {
-			int offset = i * ARRAY_SIZE(data->lunt[0]) + j;
-			nsp32_lunt tmp = {
+	for (n_target = 0; n_target < ARRAY_SIZE(data->lunt); n_target++) {
+		for (n_lun = 0; n_lun < ARRAY_SIZE(data->lunt[0]); n_lun++) {
+			const int offset = n_target * ARRAY_SIZE(data->lunt[0]) + n_lun;
+			const nsp32_lunt tmp = {
 				.SCpnt       = NULL,
 				.save_datp   = 0,
 				.msgin03     = FALSE,
 				.sg_num      = 0,
 				.cur_entry   = 0,
 				.sglun       = &(data->sg_list[offset]),
-				.sglun_paddr = data->sg_paddr + (offset * sizeof(nsp32_sglun)),
+				.sglun_paddr = data->sg_paddr + ARRAY_OFFSET(nsp32_sglun, offset),
 			};
 
-			data->lunt[i][j] = tmp;
+			data->lunt[n_target][n_lun] = tmp;
 		}
 	}
 
@@ -2827,15 +2895,15 @@
 		nsp32_target *target = &(data->target[i]);
 
 		target->limit_entry  = 0;
-		target->sync_flag    = 0;
+		target->sync_flag    = SDTR_NONE;
 		nsp32_set_async(data, target);
 	}
 
 	/*
 	 * EEPROM check
 	 */
-	ret = nsp32_getprom_param(data);
-	if (ret == FALSE) {
+	eeprom_ret = nsp32_getprom_param(data);
+	if (eeprom_ret == FALSE) {
 		data->resettime = 3;	/* default 3 */
 	}
 
@@ -2866,7 +2934,13 @@
 	 *     this driver set SDTR safely later, and we can control all SCSI
 	 *     device transfer mode.
 	 */
-	nsp32_do_bus_reset(data);
+	/* Hotplug device (like CardBus card) dose not need bus reset.
+	 * Because some SCSI device dose not answer for SCSI inquiry command
+	 * when bus resetting.
+	 */
+	if (eeprom_ret != FALSE) {
+		nsp32_do_bus_reset(data);
+	}
 
 	ret = request_irq(host->irq, do_nsp32_isr,
 			  SA_SHIRQ | SA_SAMPLE_RANDOM, "nsp32", data);
@@ -2876,16 +2950,16 @@
 		goto free_sg_list;
 	}
 
-        /*
+	/*
          * PCI IO register
          */
 	res = request_region(host->io_port, host->n_io_port, "nsp32");
 	if (res == NULL) {
-		nsp32_msg(KERN_ERR, 
-			  "I/O region 0x%lx+0x%lx is already used",
+		nsp32_msg(KERN_ERR,
+			  "I/O region 0x%x+0x%x is already used",
 			  data->BaseAddress, data->NumAddress);
 		goto free_irq;
-        }
+	}
 
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	scsi_add_host (host, &PCIDEV->dev);
@@ -2904,7 +2978,7 @@
  free_autoparam:
 	pci_free_consistent(PCIDEV, sizeof(nsp32_autoparam),
 			    data->autoparam, data->auto_paddr);
-	
+
  scsi_unregister:
 	scsi_host_put(host);
 
@@ -2937,7 +3011,7 @@
 		release_region(host->io_port, host->n_io_port);
 	}
 
-	if (data->MmioAddress) {
+	if (data->MmioAddress != 0) {
 		iounmap(data->MmioAddress);
 	}
 
@@ -2958,7 +3032,7 @@
 static int nsp32_eh_abort(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int   base = SCpnt->device->host->io_port;
+	const unsigned int base = SCpnt->device->host->io_port;
 
 	nsp32_msg(KERN_WARNING, "abort");
 
@@ -2969,12 +3043,12 @@
 
 	if (data->cur_target->sync_flag & (SDTR_INITIATOR | SDTR_TARGET)) {
 		/* reset SDTR negotiation */
-		data->cur_target->sync_flag = 0;
+		data->cur_target->sync_flag = SDTR_NONE;
 		nsp32_set_async(data, data->cur_target);
 	}
 
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
-	nsp32_write2(base, BM_CNT,           0);
+	nsp32_write2(base, BM_CNT,	     0);
 
 	SCpnt->result = DID_ABORT << 16;
 	nsp32_scsi_done(SCpnt);
@@ -2986,10 +3060,10 @@
 static int nsp32_eh_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int   base = SCpnt->device->host->io_port;
+	const unsigned int base = SCpnt->device->host->io_port;
 
-	nsp32_msg(KERN_INFO, "Bus Reset");	
-	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
+	nsp32_msg(KERN_INFO, "Bus Reset");
+	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%p", SCpnt);
 
 	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
 	nsp32_do_bus_reset(data);
@@ -3000,20 +3074,19 @@
 
 static void nsp32_do_bus_reset(nsp32_hw_data *data)
 {
-	unsigned int   base = data->BaseAddress;
-	unsigned short intrdat;
+	const unsigned int base = data->BaseAddress;
 	int i;
 
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "in");
 
 	/*
 	 * stop all transfer
-	 * clear TRANSFERCONTROL_BM_START
+	 * clear TRANSFER_CONTROL, BM_CNT
 	 * clear counter
 	 */
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
-	nsp32_write4(base, BM_CNT,           0);
-	nsp32_write4(base, CLR_COUNTER,      CLRCOUNTER_ALLMASK);
+	nsp32_write4(base, BM_CNT,	     0);
+	nsp32_write4(base, CLR_COUNTER,	     CLRCOUNTER_ALLMASK);
 
 	/*
 	 * fall back to asynchronous transfer mode
@@ -3022,7 +3095,7 @@
 	for (i = 0; i < ARRAY_SIZE(data->target); i++) {
 		nsp32_target *target = &data->target[i];
 
-		target->sync_flag = 0;
+		target->sync_flag = SDTR_NONE;
 		nsp32_set_async(data, target);
 	}
 
@@ -3030,24 +3103,25 @@
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
+	mdelay(RESET_HOLD_TIME);
 	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
 	for(i = 0; i < 5; i++) {
+		unsigned short intrdat;
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
 		nsp32_dbg(NSP32_DEBUG_BUSRESET, "irq:1: 0x%x", intrdat);
-        }
+	}
 
 	data->CurrentSC = NULL;
 }
 
 static int nsp32_eh_host_reset(struct scsi_cmnd *SCpnt)
 {
-	struct Scsi_Host *host = SCpnt->device->host;
-	unsigned int      base = SCpnt->device->host->io_port;
-	nsp32_hw_data    *data = (nsp32_hw_data *)host->hostdata;
+	struct Scsi_Host  *host = SCpnt->device->host;
+	const unsigned int base = SCpnt->device->host->io_port;
+	nsp32_hw_data     *data = (nsp32_hw_data *)host->hostdata;
 
-	nsp32_msg(KERN_INFO, "Host Reset");	
-	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
+	nsp32_msg(KERN_INFO, "Host Reset");
+	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%p", SCpnt);
 
 	nsp32hw_init(data);
 	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
@@ -3060,6 +3134,8 @@
 
 /**************************************************************************
  * EEPROM handler
+ *
+ * get SDTR parameter from EEPROM.
  */
 
 /*
@@ -3067,9 +3143,14 @@
  */
 static int nsp32_getprom_param(nsp32_hw_data *data)
 {
-	int vendor = data->pci_devid->vendor;
-	int device = data->pci_devid->device;
-	int ret, val, i;
+	const int vendor = data->pci_devid->vendor;
+	const int device = data->pci_devid->device;
+	int ret;
+#ifdef NSP32_DEBUG
+	int i;
+#define NSP32_DEBUG_PROM_BUF_SIZE 0x20
+	unsigned char buf[NSP32_DEBUG_PROM_BUF_SIZE];
+#endif
 
 	/*
 	 * EEPROM checking.
@@ -3102,28 +3183,31 @@
 		ret = FALSE;
 	}
 
+#ifdef NSP32_DEBUG
 	/* for debug : SPROM data full checking */
-	for (i = 0; i <= 0x1f; i++) {
-		val = nsp32_prom_read(data, i);
-		nsp32_dbg(NSP32_DEBUG_EEPROM,
-			  "rom address 0x%x : 0x%x", i, val);
+	nsp32_dbg(NSP32_DEBUG_EEPROM, "rom dump");
+	for (i = 0; i < sizeof(buf); i++) {
+		buf[i] = nsp32_prom_read(data, i);
 	}
+	nsp32_byte_dump(buf, 0, sizeof(buf));
+#endif
 
 	return ret;
 }
+#undef NSP32_DEBUG_PROM_BUF_SIZE
 
 
 /*
  * AT24C01A (Logitec: LHA-600S), AT24C02 (Melco Buffalo: IFC-USLP) data map:
  *
  *   ROMADDR
- *   0x00 - 0x06 :  Device Synchronous Transfer Period (SCSI ID 0 - 6) 
+ *   0x00 - 0x06 :  Device Synchronous Transfer Period (SCSI ID 0 - 6)
  *			Value 0x0: ASYNC, 0x0c: Ultra-20M, 0x19: Fast-10M
  *   0x07        :  HBA Synchronous Transfer Period
  *			Value 0: AutoSync, 1: Manual Setting
  *   0x08 - 0x0f :  Not Used? (0x0)
  *   0x10        :  Bus Termination
- * 			Value 0: Auto[ON], 1: ON, 2: OFF
+ *			Value 0: Auto[ON], 1: ON, 2: OFF
  *   0x11        :  Not Used? (0)
  *   0x12        :  Bus Reset Delay Time (0x03)
  *   0x13        :  Bootable CD Support
@@ -3131,7 +3215,7 @@
  *   0x14        :  Device Scan
  *			Bit   7  6  5  4  3  2  1  0
  *			      |  <----------------->
- * 			      |    SCSI ID: Value 0: Skip, 1: YES
+ *			      |    SCSI ID: Value 0: Skip, 1: YES
  *			      |->  Value 0: ALL scan,  Value 1: Manual
  *   0x15 - 0x1b :  Not Used? (0)
  *   0x1c        :  Constant? (0x01) (clock div?)
@@ -3142,10 +3226,10 @@
  */
 static int nsp32_getprom_at24(nsp32_hw_data *data)
 {
-	int           ret, i;
-	int           auto_sync;
+	int	      tmp, i;
+	int	      auto_sync;
 	nsp32_target *target;
-	int           entry;
+	int	      entry;
 
 	/*
 	 * Reset time which is designated by EEPROM.
@@ -3167,8 +3251,8 @@
 	 *	only ignored. If auto_sync is 0 (auto), then transfer speed is
 	 *	forced as ULTRA-20M.
 	 */
-	ret = nsp32_prom_read(data, 0x07);
-	switch (ret) {
+	tmp = nsp32_prom_read(data, 0x07);
+	switch (tmp) {
 	case 0:
 		auto_sync = TRUE;
 		break;
@@ -3193,8 +3277,8 @@
 		if (auto_sync == TRUE) {
 			target->limit_entry = 0;   /* set as ULTRA20M */
 		} else {
-			ret   = nsp32_prom_read(data, i);
-			entry = nsp32_search_period_entry(data, target, ret);
+			tmp   = nsp32_prom_read(data, i);
+			entry = nsp32_search_period_entry(data, target, tmp);
 			if (entry < 0) {
 				/* search failed... set maximum speed */
 				entry = 0;
@@ -3211,7 +3295,7 @@
  * C16 110 (I-O Data: SC-NBD) data map:
  *
  *   ROMADDR
- *   0x00 - 0x06 :  Device Synchronous Transfer Period (SCSI ID 0 - 6) 
+ *   0x00 - 0x06 :  Device Synchronous Transfer Period (SCSI ID 0 - 6)
  *			Value 0x0: 20MB/S, 0x1: 10MB/S, 0x2: 5MB/S, 0x3: ASYNC
  *   0x07        :  0 (HBA Synchronous Transfer Period: Auto Sync)
  *   0x08 - 0x0f :  Not Used? (0x0)
@@ -3219,7 +3303,7 @@
  *			Value 0: PIO, 1: Busmater
  *   0x11        :  Bus Reset Delay Time (0x00-0x20)
  *   0x12        :  Bus Termination
- * 			Value 0: Disable, 1: Enable
+ *			Value 0: Disable, 1: Enable
  *   0x13 - 0x19 :  Disconnection
  *			Value 0: Disable, 1: Enable
  *   0x1a - 0x7c :  Not Used? (0)
@@ -3229,9 +3313,9 @@
  */
 static int nsp32_getprom_c16(nsp32_hw_data *data)
 {
-	int           ret, i;
+	int	      ret, i;
 	nsp32_target *target;
-	int           entry, val;
+	int	      entry, val;
 
 	/*
 	 * Reset time which is designated by EEPROM.
@@ -3264,7 +3348,7 @@
 			break;
 		}
 		entry = nsp32_search_period_entry(data, target, val);
-		if (entry < 0 || trans_mode == ULTRA20M_MODE) {
+		if ((entry < 0) || (trans_mode == ULTRA20M_MODE)) {
 			/* search failed... set maximum speed */
 			entry = 0;
 		}
@@ -3278,7 +3362,7 @@
 /*
  * Atmel AT24C01A (drived in 5V) serial EEPROM routines
  */
-static int nsp32_prom_read(nsp32_hw_data *data, int romaddr)
+static int nsp32_prom_read(const nsp32_hw_data *data, int romaddr)
 {
 	int i, val;
 
@@ -3294,7 +3378,7 @@
 	nsp32_prom_write_bit(data, 0);	/* A1: 0 (GND) */
 	nsp32_prom_write_bit(data, 0);	/* A0: 0 (GND) */
 
-	/* R/W: W for dummy write */
+	/* R/W: Write mode for dummy write */
 	nsp32_prom_write_bit(data, 0);
 
 	/* ack */
@@ -3302,7 +3386,7 @@
 
 	/* word address */
 	for (i = 7; i >= 0; i--) {
-		nsp32_prom_write_bit(data, ((romaddr >> i) & 1));
+		nsp32_prom_write_bit(data, ((romaddr >> i) & BIT(0)));
 	}
 
 	/* ack */
@@ -3320,7 +3404,7 @@
 	nsp32_prom_write_bit(data, 0);	/* A1: 0 (GND) */
 	nsp32_prom_write_bit(data, 0);	/* A0: 0 (GND) */
 
-	/* R/W: R */
+	/* R/W: Read mode */
 	nsp32_prom_write_bit(data, 1);
 
 	/* ack */
@@ -3329,9 +3413,13 @@
 	/* data... */
 	val = 0;
 	for (i = 7; i >= 0; i--) {
-		val += (nsp32_prom_read_bit(data) << i);
+		if (nsp32_prom_read_bit(data)) {
+			val |= BIT(i); /* bit=1 */
+		} else {
+			/* do nothing:    bit=0 */
+		}
 	}
-	
+
 	/* no ack */
 	nsp32_prom_write_bit(data, 1);
 
@@ -3341,10 +3429,55 @@
 	return val;
 }
 
-static void nsp32_prom_set(nsp32_hw_data *data, int bit, int val)
+static void nsp32_prom_start (const nsp32_hw_data *data)
+{
+	/* start condition */
+	nsp32_prom_set(data, SROM_CLOCK,  1);
+	nsp32_prom_set(data, SROM_DATA,   1);
+	nsp32_prom_set(data, SROM_ENABLE, 1); /* output mode */
+	nsp32_prom_set(data, SROM_DATA,   0); /* keeping SROM_CLOCK=1 and transiting
+					       * SROM_DATA 1->0 is start condition */
+	nsp32_prom_set(data, SROM_CLOCK,  0);
+}
+
+static void nsp32_prom_stop (const nsp32_hw_data *data)
+{
+	/* stop condition */
+	nsp32_prom_set(data, SROM_CLOCK,  1);
+	nsp32_prom_set(data, SROM_DATA,   0);
+	nsp32_prom_set(data, SROM_ENABLE, 1);	/* output mode */
+	nsp32_prom_set(data, SROM_DATA,   1);
+	nsp32_prom_set(data, SROM_CLOCK,  0);
+}
+
+static void nsp32_prom_write_bit(const nsp32_hw_data *data, int val)
+{
+	/* write */
+	nsp32_prom_set(data, SROM_DATA,  val);
+	nsp32_prom_set(data, SROM_CLOCK,   1);
+	nsp32_prom_set(data, SROM_CLOCK,   0);
+}
+
+static int nsp32_prom_read_bit(const nsp32_hw_data *data)
+{
+	int val;
+
+	/* read */
+	nsp32_prom_set(data, SROM_ENABLE, 0);	/* input mode */
+	nsp32_prom_set(data, SROM_CLOCK,  1);
+
+	val = nsp32_prom_get(data, SROM_DATA);
+
+	nsp32_prom_set(data, SROM_CLOCK,  0);
+	nsp32_prom_set(data, SROM_ENABLE, 1);	/* output mode */
+
+	return val;
+}
+
+static void nsp32_prom_set(const nsp32_hw_data *data, int bit, int val)
 {
-	int base = data->BaseAddress;
-	int tmp;
+	const unsigned int  base = data->BaseAddress;
+	unsigned char tmp;
 
 	tmp = nsp32_index_read1(base, SERIAL_ROM_CTL);
 
@@ -3359,17 +3492,17 @@
 	udelay(10);
 }
 
-static int nsp32_prom_get(nsp32_hw_data *data, int bit)
+static int nsp32_prom_get(const nsp32_hw_data *data, int bit)
 {
-	int base = data->BaseAddress;
-	int tmp, ret;
+	const unsigned int base = data->BaseAddress;
+	unsigned char tmp;
+	int ret;
 
-	if (bit != SDA) {
+	if (bit != SROM_DATA) {
 		nsp32_msg(KERN_ERR, "return value is not appropriate");
 		return 0;
 	}
 
-
 	tmp = nsp32_index_read1(base, SERIAL_ROM_CTL) & bit;
 
 	if (tmp == 0) {
@@ -3383,65 +3516,22 @@
 	return ret;
 }
 
-static void nsp32_prom_start (nsp32_hw_data *data)
-{
-	/* start condition */
-	nsp32_prom_set(data, SCL, 1);
-	nsp32_prom_set(data, SDA, 1);
-	nsp32_prom_set(data, ENA, 1);	/* output mode */
-	nsp32_prom_set(data, SDA, 0);	/* keeping SCL=1 and transiting
-					 * SDA 1->0 is start condition */
-	nsp32_prom_set(data, SCL, 0);
-}
-
-static void nsp32_prom_stop (nsp32_hw_data *data)
-{
-	/* stop condition */
-	nsp32_prom_set(data, SCL, 1);
-	nsp32_prom_set(data, SDA, 0);
-	nsp32_prom_set(data, ENA, 1);	/* output mode */
-	nsp32_prom_set(data, SDA, 1);
-	nsp32_prom_set(data, SCL, 0);
-}
-
-static void nsp32_prom_write_bit(nsp32_hw_data *data, int val)
-{
-	/* write */
-	nsp32_prom_set(data, SDA, val);
-	nsp32_prom_set(data, SCL, 1  );
-	nsp32_prom_set(data, SCL, 0  );
-}
-
-static int nsp32_prom_read_bit(nsp32_hw_data *data)
-{
-	int val;
-
-	/* read */
-	nsp32_prom_set(data, ENA, 0);	/* input mode */
-	nsp32_prom_set(data, SCL, 1);
-
-	val = nsp32_prom_get(data, SDA);
-
-	nsp32_prom_set(data, SCL, 0);
-	nsp32_prom_set(data, ENA, 1);	/* output mode */
-
-	return val;
-}
-
 
 /**************************************************************************
  * Power Management
  */
 #ifdef CONFIG_PM
-
 /* Device suspended */
 static int nsp32_suspend(struct pci_dev *pdev, u32 state)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	const struct Scsi_Host *host = pci_get_drvdata(pdev);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10))
+	nsp32_hw_data	       *data = (nsp32_hw_data *)host->hostdata;
+#endif
 
-	nsp32_msg(KERN_INFO, "pci-suspend: pdev=0x%p, state=%ld, slot=%s, host=0x%p", pdev, state, pci_name(pdev), host);
+	nsp32_msg(KERN_INFO, "pci-suspend: pdev=0x%p, state=%d, slot=%s, host=0x%p", pdev, state, pci_name(pdev), host);
 
-	pci_save_state     (pdev);
+	nsp_pci_save_state (pdev, data->PciState);
 	pci_disable_device (pdev);
 	pci_set_power_state(pdev, state);
 
@@ -3451,15 +3541,15 @@
 /* Device woken up */
 static int nsp32_resume(struct pci_dev *pdev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	nsp32_hw_data    *data = (nsp32_hw_data *)host->hostdata;
-	unsigned short    reg;
+	const struct Scsi_Host *host = pci_get_drvdata(pdev);
+	nsp32_hw_data	       *data = (nsp32_hw_data *)host->hostdata;
+	unsigned short		reg;
 
 	nsp32_msg(KERN_INFO, "pci-resume: pdev=0x%p, slot=%s, host=0x%p", pdev, pci_name(pdev), host);
 
 	pci_set_power_state(pdev, 0);
 	pci_enable_wake    (pdev, 0, 0);
-	pci_restore_state  (pdev);
+	nsp_pci_restore_state(pdev, data->PciState);
 
 	reg = nsp32_read2(data->BaseAddress, INDEX_REG);
 
@@ -3477,16 +3567,6 @@
 
 	return 0;
 }
-
-/* Enable wake event */
-static int nsp32_enable_wake(struct pci_dev *pdev, u32 state, int enable)
-{
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-
-	nsp32_msg(KERN_INFO, "pci-enable_wake: stub, pdev=0x%p, enable=%d, slot=%s, host=0x%p", pdev, enable, pci_name(pdev), host);
-
-	return 0;
-}
 #endif
 
 /************************************************************************
@@ -3494,23 +3574,23 @@
  */
 static int __devinit nsp32_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int ret;
 	nsp32_hw_data *data = &nsp32_data_base;
+	int ret;
 
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "enter");
 
-        ret = pci_enable_device(pdev);
+	ret = pci_enable_device(pdev);
 	if (ret) {
 		nsp32_msg(KERN_ERR, "failed to enable pci device");
 		return ret;
 	}
 
-	data->Pci         = pdev;
-	data->pci_devid   = id;
-	data->IrqNumber   = pdev->irq;
+	data->Pci	  = pdev;
+	data->pci_devid	  = id;
+	data->IrqNumber	  = pdev->irq;
 	data->BaseAddress = pci_resource_start(pdev, 0);
 	data->NumAddress  = pci_resource_len  (pdev, 0);
-	data->MmioAddress = ioremap_nocache(pci_resource_start(pdev, 1),
+	data->MmioAddress = ioremap_nocache   (pci_resource_start(pdev, 1),
 					       pci_resource_len  (pdev, 1));
 	data->MmioLength  = pci_resource_len  (pdev, 1);
 
@@ -3522,7 +3602,7 @@
 	ret = scsi_register_host(&nsp32_template);
 #endif
 
-	nsp32_msg(KERN_INFO, "irq: %i mmio: %p+0x%lx slot: %s model: %s",
+	nsp32_msg(KERN_INFO, "irq: %i mmio: 0x%p+0x%lx slot: %s model: %s",
 		  pdev->irq,
 		  data->MmioAddress, data->MmioLength,
 		  pci_name(pdev),
@@ -3538,36 +3618,33 @@
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 #endif
-
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "enter");
 
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-        scsi_remove_host(host);
-
-	nsp32_release(host);
-
-	scsi_host_put(host);
+	if (host != NULL) {
+		scsi_remove_host(host);
+		nsp32_release(host);
+		scsi_host_put(host);
+	}
 #else
-	scsi_unregister_host(&nsp32_template);	
+	scsi_unregister_host(&nsp32_template);
 #endif
 }
 
-
-
 static struct pci_driver nsp32_driver = {
 	.name		= "nsp32",
 	.id_table	= nsp32_pci_table,
 	.probe		= nsp32_probe,
 	.remove		= __devexit_p(nsp32_remove),
 #ifdef CONFIG_PM
-	.suspend	= nsp32_suspend, 
-	.resume		= nsp32_resume, 
-	.enable_wake    = nsp32_enable_wake,
+	.suspend	= nsp32_suspend,
+	.resume		= nsp32_resume,
 #endif
 };
 
+
 /*********************************************************************
- * Moule entry point
+ * Module entry point
  */
 static int __init init_nsp32(void) {
 	nsp32_msg(KERN_INFO, "loading...");
