From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 9/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:11:58 +0900 (JST)
Message-ID: <20050222.161158.59718314.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:53006 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262231AbVBVHMB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:12:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/pcmcia/nsp_cs.c	2005-02-22 08:23:09.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/pcmcia/nsp_cs.c	2005-01-29 11:43:01.000000000 +0900
@@ -1,8 +1,9 @@
 /*======================================================================
 
-    NinjaSCSI-3 / NinjaSCSI-32Bi PCMCIA SCSI host adapter card driver
-      By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
+    NinjaSCSI-3R / NinjaSCSI-32Bi PCMCIA SCSI host adapter card driver
+      By: YOKOTA Hiroshi <yokota{at}netlab.is.tsukuba.ac.jp>
 
+    Ver.3.0   Use kernel thread
     Ver.2.8   Support 32bit MMIO mode
               Support Synchronous Data Transfer Request (SDTR) mode
     Ver.2.0   Support 32bit PIO mode
@@ -25,31 +26,39 @@
 
 ***********************************************************************/
 
-/* $Id: nsp_cs.c,v 1.23 2003/08/18 11:09:19 elca Exp $ */
+/* $Id: nsp_cs.c,v 1.44 2005/01/04 11:44:29 elca Exp $ */
 
-#include <linux/version.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/major.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
+#include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/timer.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/major.h>
-#include <linux/blkdev.h>
-#include <linux/stat.h>
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
+# include <linux/moduleparam.h>
+#else
+# include <linux/blk.h>
+#endif
 
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/semaphore.h>
 
 #include <../drivers/scsi/scsi.h>
-#include <scsi/scsi_host.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_host.h>
 
 #include <pcmcia/version.h>
 #include <pcmcia/cs_types.h>
@@ -60,38 +69,41 @@
 
 #include "nsp_cs.h"
 
-MODULE_AUTHOR("YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>");
-MODULE_DESCRIPTION("WorkBit NinjaSCSI-3 / NinjaSCSI-32Bi(16bit) PCMCIA SCSI host adapter module $Revision: 1.23 $");
+MODULE_DESCRIPTION("WorkBit NinjaSCSI-3 / NinjaSCSI-32Bi(16bit) PCMCIA SCSI host adapter module $Revision: 1.44 $");
+MODULE_AUTHOR("YOKOTA Hiroshi <yokota{at}netlab.is.tsukuba.ac.jp>");
 MODULE_SUPPORTED_DEVICE("sd,sr,sg,st");
-#ifdef MODULE_LICENSE
 MODULE_LICENSE("GPL");
-#endif
 
 #include "nsp_io.h"
 
 /*====================================================================*/
 /* Parameters that can be set with 'insmod' */
 
-static unsigned int irq_mask = 0xffff;
-MODULE_PARM     (irq_mask, "i");
+static unsigned int irq_mask = 0xffff;  /* default: auto detect from all lines */
+module_param    (irq_mask, uint, 0444); /* -r--r--r-- */
 MODULE_PARM_DESC(irq_mask, "IRQ mask bits (default: 0xffff)");
 
-static int       irq_list[4] = { -1 };
-MODULE_PARM     (irq_list, "1-4i");
-MODULE_PARM_DESC(irq_list, "Use specified IRQ number. (default: auto select)");
+static int      irq_list[4] = { -1 };  /* default: auto */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
+static int      irq_list_count;
+#endif
+module_param_array(irq_list, int, _nsp_ptr irq_list_count, 0444); /* -r--r--r-- */
+MODULE_PARM_DESC  (irq_list, "Use specified IRQ number. (default: auto select)");
 
-static int       nsp_burst_mode = BURST_MEM32;
-MODULE_PARM     (nsp_burst_mode, "i");
+static int      nsp_burst_mode = BURST_MEM32; /* default: memory mapped IO, 32 bit mode */
+module_param    (nsp_burst_mode, int, 0444);   /* -r--r--r-- */
 MODULE_PARM_DESC(nsp_burst_mode, "Burst transfer mode (0=io8, 1=io32, 2=mem32(default))");
 
-/* Release IO ports after configuration? */
-static int       free_ports = 0;
-MODULE_PARM     (free_ports, "i");
-MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0 (=no))");
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
+MODULE_PARM(irq_mask,       "i"   );
+MODULE_PARM(irq_list,       "1-4i");
+MODULE_PARM(nsp_burst_mode, "i"   );
+#endif
 
 /* /usr/src/linux/drivers/scsi/hosts.h */
 static Scsi_Host_Template nsp_driver_template = {
-	.proc_name	         = "nsp_cs",
+	.proc_name		 = "nsp_cs",
 	.proc_info		 = nsp_proc_info,
 	.name			 = "WorkBit NinjaSCSI-3/32Bi(16bit)",
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
@@ -113,22 +125,29 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,2))
 	.use_new_eh_code	 = 1,
 #endif
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,0))
+	.module			 = THIS_MODULE,
+#endif
 };
 
 static dev_link_t *dev_list = NULL;
-static dev_info_t dev_info  = {"nsp_cs"};
+static dev_info_t dev_info  = "nsp_cs";
 
 static nsp_hw_data nsp_data_base; /* attach <-> detect glue */
 
 
 
-/*
+/******************************************************************
  * debug, error print
  */
+#ifdef NSP_DEBUG
+# include "nsp_debug.c"
+#endif	/* NSP_DEBUG */
+
 #ifndef NSP_DEBUG
 # define NSP_DEBUG_MASK		0x000000
-# define nsp_msg(type, args...) nsp_cs_message("", 0, (type), args)
-# define nsp_dbg(mask, args...) /* */
+# define nsp_msg(type, args...) nsp_cs_message(NULL, 0, (type), args)
+# define nsp_dbg(mask, args...) do {} while(0)
 #else
 # define NSP_DEBUG_MASK		0xffffff
 # define nsp_msg(type, args...) \
@@ -155,12 +174,14 @@
 #define NSP_DEBUG_TARGETFLAG		BIT(15)
 #define NSP_DEBUG_PROC			BIT(16)
 #define NSP_DEBUG_INIT			BIT(17)
-#define NSP_DEBUG_DATA_IO      		BIT(18)
+#define NSP_DEBUG_DATA_IO		BIT(18)
+#define NSP_DEBUG_THREAD		BIT(19)
 #define NSP_SPECIAL_PRINT_REGISTER	BIT(20)
 
 #define NSP_DEBUG_BUF_LEN		150
 
-static void nsp_cs_message(const char *func, int line, char *type, char *fmt, ...)
+__attribute__((format(printf, 4, 5)))
+static void nsp_cs_message(const char *func, int line, const char *type, const char *fmt, ...)
 {
 	va_list args;
 	char buf[NSP_DEBUG_BUF_LEN];
@@ -177,7 +198,8 @@
 }
 
 #ifdef NSP_DEBUG
-static void nsp_cs_dmessage(const char *func, int line, int mask, char *fmt, ...)
+__attribute__((format(printf, 4, 5)))
+static void nsp_cs_dmessage(const char *func, int line, int mask, const char *fmt, ...)
 {
 	va_list args;
 	char buf[NSP_DEBUG_BUF_LEN];
@@ -198,7 +220,7 @@
  * Clenaup parameters and call done() functions.
  * You must be set SCpnt->result before call this function.
  */
-static void nsp_scsi_done(Scsi_Cmnd *SCpnt)
+static void nsp_scsi_done(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
@@ -207,49 +229,51 @@
 	SCpnt->scsi_done(SCpnt);
 }
 
-static int nsp_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+static int nsp_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 #ifdef NSP_DEBUG
-	/*unsigned int host_id = SCpnt->device->host->this_id;*/
-	/*unsigned int base    = SCpnt->device->host->io_port;*/
-	unsigned char target = SCpnt->device->id;
+	/*const unsigned int host_id = SCpnt->device->host->this_id;*/
+	/*const unsigned int base    = SCpnt->device->host->io_port;*/
+	const unsigned char target = SCpnt->device->id;
 #endif
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
-	nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "SCpnt=0x%p target=%d lun=%d buff=0x%p bufflen=%d use_sg=%d",
-		   SCpnt, target, SCpnt->device->lun, SCpnt->request_buffer, SCpnt->request_bufflen, SCpnt->use_sg);
+	nsp_dbg(NSP_DEBUG_QUEUECOMMAND,
+		"SCpnt=0x%p target=%d lun=%d buff=0x%p bufflen=%d use_sg=%d",
+		SCpnt, target, SCpnt->device->lun,
+		SCpnt->request_buffer, SCpnt->request_bufflen,
+		SCpnt->use_sg);
 	//nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "before CurrentSC=0x%p", data->CurrentSC);
 
-	SCpnt->scsi_done	= done;
+	SCpnt->scsi_done = done;
 
-	if (data->CurrentSC != NULL) {
-		nsp_msg(KERN_DEBUG, "CurrentSC!=NULL this can't be happen");
+	if (data->CurrentSC     != NULL) {
+		nsp_msg(KERN_WARNING, "CurrentSC!=NULL this can't be happen");
 		SCpnt->result   = DID_BAD_TARGET << 16;
 		nsp_scsi_done(SCpnt);
-		return 0;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-#if 0
-	/* XXX: pcmcia-cs generates SCSI command with "scsi_info" utility.
-	        This makes kernel crash when suspending... */
-	if (data->ScsiInfo->stop != 0) {
-		nsp_msg(KERN_INFO, "suspending device. reject command.");
-		SCpnt->result  = DID_BAD_TARGET << 16;
+	/* check target ID is not same as this initiator ID */
+	if (SCpnt->device->id == SCpnt->device->host->this_id) {
+		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "terget==host???");
+		SCpnt->result = DID_BAD_TARGET << 16;
 		nsp_scsi_done(SCpnt);
-		return SCSI_MLQUEUE_HOST_BUSY;
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
-#endif
 
 	show_command(SCpnt);
 
 	data->CurrentSC		= SCpnt;
 
-	SCpnt->SCp.Status	= CHECK_CONDITION;
-	SCpnt->SCp.Message	= 0;
+	/*--------------------------------
+	 * fill suitable values to SCpnt */
+	SCpnt->SCp.Status	= SAM_STAT_CHECK_CONDITION;
+	SCpnt->SCp.Message	= COMMAND_COMPLETE;
 	SCpnt->SCp.have_data_in = IO_UNKNOWN;
 	SCpnt->SCp.sent_command = 0;
 	SCpnt->SCp.phase	= PH_UNDETERMINED;
-	SCpnt->resid	        = SCpnt->request_bufflen;
+	SCpnt->resid		= SCpnt->request_bufflen;
 
 	/* setup scratch area
 	   SCp.ptr		: buffer pointer
@@ -259,7 +283,7 @@
 	   SCp.phase		: current state of the command */
 	if (SCpnt->use_sg) {
 		SCpnt->SCp.buffer	    = (struct scatterlist *) SCpnt->request_buffer;
-		SCpnt->SCp.ptr		    = BUFFER_ADDR;
+		SCpnt->SCp.ptr		    = SG_ADDRESS(SCpnt->SCp.buffer);
 		SCpnt->SCp.this_residual    = SCpnt->SCp.buffer->length;
 		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
 	} else {
@@ -269,27 +293,28 @@
 		SCpnt->SCp.buffers_residual = 0;
 	}
 
+	/* start selection phase */
 	if (nsphw_start_selection(SCpnt) == FALSE) {
 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
 		SCpnt->result   = DID_BUS_BUSY << 16;
 		nsp_scsi_done(SCpnt);
-		return 0;
+		return 0; //SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
-
-	//nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "out");
 #ifdef NSP_DEBUG
 	data->CmdId++;
 #endif
+
+	//nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "out");
 	return 0;
 }
 
 /*
  * setup PIO FIFO transfer mode and enable/disable to data out
  */
-static void nsp_setup_fifo(nsp_hw_data *data, int enabled)
+static void nsp_setup_fifo(const nsp_hw_data *data, int enabled)
 {
-	unsigned int  base = data->BaseAddress;
+	const unsigned int  base = data->BaseAddress;
 	unsigned char transfer_mode_reg;
 
 	//nsp_dbg(NSP_DEBUG_DATA_IO, "enabled=%d", enabled);
@@ -307,9 +332,10 @@
 
 static void nsphw_init_sync(nsp_hw_data *data)
 {
-	sync_data tmp_sync = { .SyncNegotiation = SYNC_NOT_YET,
-			       .SyncPeriod      = 0,
-			       .SyncOffset      = 0
+	const sync_data tmp_sync = {
+		.SyncNegotiation = SYNC_NOT_YET,
+		.SyncPeriod      = 0,
+		.SyncOffset      = 0
 	};
 	int i;
 
@@ -324,7 +350,7 @@
  */
 static int nsphw_init(nsp_hw_data *data)
 {
-	unsigned int base     = data->BaseAddress;
+	const unsigned int base = data->BaseAddress;
 
 	nsp_dbg(NSP_DEBUG_INIT, "in base=0x%x", base);
 
@@ -335,11 +361,15 @@
 
 	nsphw_init_sync(data);
 
+
 	/* block all interrupts */
-	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALLMASK);
+	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALL_CLEAR_AND_MASK);
+
+	nsp_write(base,	      IFSELECT,	    0);
+	data->ChipRev = nsp_read(base, FIFOSTATUS);
 
 	/* setup SCSI interface */
-	nsp_write(base,	      IFSELECT,	    IF_IFSEL);
+	nsp_write(base,	      IFSELECT,	    IF_REGSEL);
 
 	nsp_index_write(base, SCSIIRQMODE,  0);
 
@@ -370,7 +400,7 @@
 	nsp_index_write(base, SCSIIRQMODE,  SCSI_PHASE_CHANGE_EI |
 					    RESELECT_EI		 |
 					    SCSI_RESET_IRQ_EI	 );
-	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALLCLEAR);
+	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALL_CLEAR);
 
 	nsp_setup_fifo(data, FALSE);
 
@@ -380,11 +410,11 @@
 /*
  * Start selection phase
  */
-static int nsphw_start_selection(Scsi_Cmnd *SCpnt)
+static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
 {
-	unsigned int  host_id	 = SCpnt->device->host->this_id;
-	unsigned int  base	 = SCpnt->device->host->io_port;
-	unsigned char target	 = SCpnt->device->id;
+	const unsigned int  host_id = SCpnt->device->host->this_id;
+	const unsigned int  base    = SCpnt->device->host->io_port;
+	const unsigned char target  = SCpnt->device->id;
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	int	      time_out;
 	unsigned char phase, arbit;
@@ -393,7 +423,7 @@
 
 	phase = nsp_index_read(base, SCSIBUSMON);
 	if(phase != BUSMON_BUS_FREE) {
-		//nsp_dbg(NSP_DEBUG_RESELECTION, "bus busy");
+		nsp_msg(KERN_INFO, "bus busy, target=%d", target);
 		return FALSE;
 	}
 
@@ -407,7 +437,7 @@
 		/* XXX: what a stupid chip! */
 		arbit = nsp_index_read(base, ARBITSTATUS);
 		//nsp_dbg(NSP_DEBUG_RESELECTION, "arbit=%d, wait_count=%d", arbit, wait_count);
-		udelay(1); /* hold 1.2us */
+		udelay(2); /* hold 1.2us */
 	} while((arbit & (ARBIT_WIN | ARBIT_FAIL)) == 0 &&
 		(time_out-- != 0));
 
@@ -426,7 +456,7 @@
 	udelay(2); /* wait >1.2us */
 	nsp_index_write(base, SCSIBUSCTRL,   SCSI_SEL | SCSI_BSY | SCSI_DATAOUT_ENB | SCSI_ATN);
 	nsp_index_write(base, SETARBIT,	     ARBIT_FLAG_CLEAR);
-	/*udelay(1);*/ /* wait >90ns */
+	udelay(1); /* wait >90ns */
 	nsp_index_write(base, SCSIBUSCTRL,   SCSI_SEL            | SCSI_DATAOUT_ENB | SCSI_ATN);
 
 	/* check selection timeout */
@@ -436,38 +466,67 @@
 	return TRUE;
 }
 
+/***********************************************************************
+ * Period/AckWidth speed conversion table
+ *
+ * Note: This period/ackwidth speed table must be in descending order.
+ ***********************************************************************/
 struct nsp_sync_table {
-	unsigned int min_period;
-	unsigned int max_period;
-	unsigned int chip_period;
-	unsigned int ack_width;
+	const unsigned int chip_period;
+	const unsigned int ack_width;
+	const unsigned int min_period;
+	const unsigned int max_period;
 };
 
-static struct nsp_sync_table nsp_sync_table_40M[] = {
-	{0x0c, 0x0c, 0x1, 0},	/* 20MB	  50ns*/
-	{0x19, 0x19, 0x3, 1},	/* 10MB	 100ns*/ 
-	{0x1a, 0x25, 0x5, 2},	/* 7.5MB 150ns*/ 
-	{0x26, 0x32, 0x7, 3},	/* 5MB	 200ns*/
-	{   0,    0,   0, 0},
+const static struct nsp_sync_table nsp_sync_table_40M[] = {
+     /* {PNo, AW,   SP,   EP}  Speed(MB/s) Period AckWidth */
+	{0x1,  0, 0x0c, 0x0c},  /*  20.0 :  50ns,  25ns */
+	{0x2,  0, 0x0d, 0x18},  /*  13.3 :  75ns,  25ns */
+	{0x3,  1, 0x19, 0x19},  /*  10.0 : 100ns,  50ns */
+	{0x4,  1, 0x1a, 0x1f},  /*   8.0 : 125ns,  50ns */
+	{0x5,  2, 0x20, 0x25},  /*   7.5 : 150ns,  75ns */
+	{0x6,  2, 0x26, 0x31},  /*   5.71: 175ns,  75ns */
+	{0x7,  3, 0x32, 0x32},  /*   5.0 : 200ns, 100ns */
+	{0x8,  3, 0x33, 0x38},  /*   4.44: 225ns, 100ns */
+	{0x9,  3, 0x39, 0x3e},  /*   4.0 : 250ns, 100ns */
+	{0xa,  3, 0x3f, 0x44},  /*   3.64: 275ns, 100ns */
+	{0xb,  3, 0x45, 0x4b},  /*   3.33: 300ns, 100ns */
+	{0xc,  3, 0x4c, 0x53},  /*   3.01: 325ns, 100ns */
+	{0xd,  3, 0x54, 0x57},  /*   2.86: 350ns, 100ns */
+	{0xe,  3, 0x58, 0x5d},  /*   2.67: 375ns, 100ns */
+	{0xf,  3, 0x5e, 0x64},  /*   2.5 : 400ns, 100ns */
+	{0,0,0,0},
 };
 
-static struct nsp_sync_table nsp_sync_table_20M[] = {
-	{0x19, 0x19, 0x1, 0},	/* 10MB	 100ns*/ 
-	{0x1a, 0x25, 0x2, 0},	/* 7.5MB 150ns*/ 
-	{0x26, 0x32, 0x3, 1},	/* 5MB	 200ns*/
-	{   0,    0,   0, 0},
+const static struct nsp_sync_table nsp_sync_table_20M[] = {
+	{0x1,  0, 0x19, 0x19},  /* 10.0 : 100ns,  50ns */
+	{0x2,  0, 0x1a, 0x25},  /*  6.7 : 150ns,  50ns */
+	{0x3,  1, 0x26, 0x32},  /*  5.0 : 200ns, 100ns */
+	{0x4,  1, 0x33, 0x3e},  /*  4.0 : 250ns, 100ns */
+	{0x5,  2, 0x3f, 0x4b},  /*  3.3 : 300ns, 150ns */
+	{0x6,  2, 0x4c, 0x57},  /*  2.8 : 350ns, 150ns */
+	{0x7,  3, 0x58, 0x64},  /*  2.5 : 400ns, 200ns */
+	{0x8,  3, 0x65, 0x70},  /*  2.2 : 450ns, 200ns */
+	{0x9,  3, 0x71, 0x7d},  /*  2.0 : 500ns, 200ns */
+	{0xa,  3, 0x7e, 0x89},  /*  1.82: 550ns, 200ns */
+	{0xb,  3, 0x8a, 0x95},  /*  1.67: 550ns, 200ns */
+	{0xc,  3, 0x96, 0xa2},  /*  1.54: 550ns, 200ns */
+	{0xd,  3, 0xa3, 0xae},  /*  1.43: 550ns, 200ns */
+	{0xe,  3, 0xaf, 0xbb},  /*  1.33: 550ns, 200ns */
+	{0xf,  3, 0xbc, 0xc8},  /*  1.25: 550ns, 200ns */
+	{0,0,0,0},
 };
 
 /*
  * setup synchronous data transfer mode
  */
-static int nsp_analyze_sdtr(Scsi_Cmnd *SCpnt)
+static int nsp_analyze_sdtr(const struct scsi_cmnd *SCpnt)
 {
-	unsigned char	       target = SCpnt->device->id;
-//	unsigned char	       lun    = SCpnt->device->lun;
+	const unsigned char    target = SCpnt->device->id;
+//	const unsigned char    lun    = SCpnt->device->lun;
 	nsp_hw_data           *data   = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	sync_data	      *sync   = &(data->Sync[target]);
-	struct nsp_sync_table *sync_table;
+	const struct nsp_sync_table *sync_table;
 	unsigned int	       period, offset;
 	int		       i;
 
@@ -479,10 +538,19 @@
 
 	nsp_dbg(NSP_DEBUG_SYNC, "period=0x%x, offset=0x%x", period, offset);
 
-	if ((data->ScsiClockDiv & (BIT(0)|BIT(1))) == CLOCK_20M) {
+	switch (data->ScsiClockDiv) {
+	case CLOCK_20M:
+	case CLOCK_40M:
 		sync_table = nsp_sync_table_20M;
-	} else {
+		break;
+	case (CLOCK_40M | FAST_20):
 		sync_table = nsp_sync_table_40M;
+		break;
+	default:
+		nsp_msg(KERN_WARNING,
+			"Invalid clock div is selected, set 20M.");
+		sync_table = nsp_sync_table_20M;
+		break;
 	}
 
 	for ( i = 0; sync_table->max_period != 0; i++, sync_table++) {
@@ -519,9 +587,9 @@
 /*
  * start ninja hardware timer
  */
-static void nsp_start_timer(Scsi_Cmnd *SCpnt, int time)
+static void nsp_start_timer(const struct scsi_cmnd *SCpnt, int time)
 {
-	unsigned int base = SCpnt->device->host->io_port;
+	const unsigned int base = SCpnt->device->host->io_port;
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
 	//nsp_dbg(NSP_DEBUG_INTR, "in SCpnt=0x%p, time=%d", SCpnt, time);
@@ -532,9 +600,9 @@
 /*
  * wait for bus phase change
  */
-static int nsp_negate_signal(Scsi_Cmnd *SCpnt, unsigned char mask, char *str)
+static int nsp_negate_signal(const struct scsi_cmnd *SCpnt, unsigned char mask, char *str)
 {
-	unsigned int  base = SCpnt->device->host->io_port;
+	const unsigned int  base = SCpnt->device->host->io_port;
 	unsigned char reg;
 	int	      time_out;
 
@@ -559,18 +627,19 @@
 /*
  * expect Ninja Irq
  */
-static int nsp_expect_signal(Scsi_Cmnd	   *SCpnt,
+static int nsp_expect_signal(const struct scsi_cmnd	   *SCpnt,
 			     unsigned char  current_phase,
 			     unsigned char  mask)
 {
-	unsigned int  base	 = SCpnt->device->host->io_port;
-	int	      time_out;
-	unsigned char phase, i_src;
+	const unsigned int  base = SCpnt->device->host->io_port;
+	int	            time_out;
 
 	//nsp_dbg(NSP_DEBUG_INTR, "current_phase=0x%x, mask=0x%x", current_phase, mask);
 
 	time_out = 100;
 	do {
+		unsigned char phase, i_src;
+
 		phase = nsp_index_read(base, SCSIBUSMON);
 		if (phase == 0xff) {
 			//nsp_dbg(NSP_DEBUG_INTR, "ret -1");
@@ -592,49 +661,9 @@
 }
 
 /*
- * transfer SCSI message
- */
-static int nsp_xfer(Scsi_Cmnd *SCpnt, int phase)
-{
-	unsigned int  base = SCpnt->device->host->io_port;
-	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
-	char	     *buf  = data->MsgBuffer;
-	int	      len  = min(MSGBUF_SIZE, data->MsgLen);
-	int	      ptr;
-	int	      ret;
-
-	//nsp_dbg(NSP_DEBUG_DATA_IO, "in");
-	for (ptr = 0; len > 0; len--, ptr++) {
-
-		ret = nsp_expect_signal(SCpnt, phase, BUSMON_REQ);
-		if (ret <= 0) {
-			nsp_dbg(NSP_DEBUG_DATA_IO, "xfer quit");
-			return 0;
-		}
-
-		/* if last byte, negate ATN */
-		if (len == 1 && SCpnt->SCp.phase == PH_MSG_OUT) {
-			nsp_index_write(base, SCSIBUSCTRL, AUTODIRECTION | ACKENB);
-		}
-
-		/* read & write message */
-		if (phase & BUSMON_IO) {
-			nsp_dbg(NSP_DEBUG_DATA_IO, "read msg");
-			buf[ptr] = nsp_index_read(base, SCSIDATAWITHACK);
-		} else {
-			nsp_dbg(NSP_DEBUG_DATA_IO, "write msg");
-			nsp_index_write(base, SCSIDATAWITHACK, buf[ptr]);
-		}
-		nsp_negate_signal(SCpnt, BUSMON_ACK, "xfer<ack>");
-
-	}
-	return len;
-}
-
-/*
  * get extra SCSI data from fifo
  */
-static int nsp_dataphase_bypass(Scsi_Cmnd *SCpnt)
+static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int count;
@@ -666,10 +695,10 @@
 /*
  * accept reselection
  */
-static int nsp_reselected(Scsi_Cmnd *SCpnt)
+static int nsp_reselected(const struct scsi_cmnd *SCpnt)
 {
-	unsigned int  base    = SCpnt->device->host->io_port;
-	unsigned int  host_id = SCpnt->device->host->this_id;
+	const unsigned int  base    = SCpnt->device->host->io_port;
+	const unsigned int  host_id = SCpnt->device->host->this_id;
 	//nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	unsigned char bus_reg;
 	unsigned char id_reg, tmp;
@@ -705,9 +734,9 @@
 /*
  * count how many data transferd
  */
-static int nsp_fifo_count(Scsi_Cmnd *SCpnt)
+static int nsp_fifo_count(const struct scsi_cmnd *SCpnt)
 {
-	unsigned int base = SCpnt->device->host->io_port;
+	const unsigned int base = SCpnt->device->host->io_port;
 	unsigned int count;
 	unsigned int l, m, h, dummy;
 
@@ -732,24 +761,25 @@
 /*
  * read data in DATA IN phase
  */
-static void nsp_pio_read(Scsi_Cmnd *SCpnt)
+static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 {
-	unsigned int  base      = SCpnt->device->host->io_port;
-	unsigned long mmio_base = SCpnt->device->host->base;
+	const unsigned int  base      = SCpnt->device->host->io_port;
+	const unsigned long mmio_base = SCpnt->device->host->base;
 	nsp_hw_data  *data      = (nsp_hw_data *)SCpnt->device->host->hostdata;
-	long	      time_out;
-	int	      ocount, res;
-	unsigned char stat, fifo_stat;
+	int	      time_out;
+	int	      ocount;
 
 	ocount = data->FifoCount;
 
-	nsp_dbg(NSP_DEBUG_DATA_IO, "in SCpnt=0x%p resid=%d ocount=%d ptr=0x%p this_residual=%d buffers=0x%p nbuf=%d",
+	nsp_dbg(NSP_DEBUG_DATA_IO, "in SCpnt=0x%p resid=0x%x ocount=%d ptr=0x%p this_residual=0x%x buffers=0x%p nbuf=%d",
 		SCpnt, SCpnt->resid, ocount, SCpnt->SCp.ptr, SCpnt->SCp.this_residual, SCpnt->SCp.buffer, SCpnt->SCp.buffers_residual);
 
 	time_out = 1000;
 
 	while ((time_out-- != 0) &&
 	       (SCpnt->SCp.this_residual > 0 || SCpnt->SCp.buffers_residual > 0 ) ) {
+		unsigned char stat, fifo_stat;
+		int res;
 
 		stat = nsp_index_read(base, SCSIBUSMON);
 		stat &= BUSMON_PHASE_MASK;
@@ -794,7 +824,7 @@
 			return;
 		}
 
-		SCpnt->resid	       	 -= res;
+		SCpnt->resid		 -= res;
 		SCpnt->SCp.ptr		 += res;
 		SCpnt->SCp.this_residual -= res;
 		ocount			 += res;
@@ -806,7 +836,7 @@
 			//nsp_dbg(NSP_DEBUG_DATA_IO, "scatterlist next timeout=%d", time_out);
 			SCpnt->SCp.buffers_residual--;
 			SCpnt->SCp.buffer++;
-			SCpnt->SCp.ptr		 = BUFFER_ADDR;
+			SCpnt->SCp.ptr		 = SG_ADDRESS(SCpnt->SCp.buffer);
 			SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
 			time_out = 1000;
 
@@ -816,25 +846,24 @@
 
 	data->FifoCount = ocount;
 
-	if (time_out == 0) {
-		nsp_msg(KERN_DEBUG, "pio read timeout resid=%d this_residual=%d buffers_residual=%d",
+	if (time_out <= 0) {
+		nsp_msg(KERN_DEBUG, "pio read timeout resid=0x%x this_residual=0x%x buffers_residual=%d",
 			SCpnt->resid, SCpnt->SCp.this_residual, SCpnt->SCp.buffers_residual);
 	}
-	nsp_dbg(NSP_DEBUG_DATA_IO, "read ocount=0x%x", ocount);
+	nsp_dbg(NSP_DEBUG_DATA_IO, "read ocount=0x%x time_out=%d", ocount, time_out);
 	nsp_dbg(NSP_DEBUG_DATA_IO, "r cmd=%d resid=0x%x\n", data->CmdId, SCpnt->resid);
 }
 
 /*
  * write data in DATA OUT phase
  */
-static void nsp_pio_write(Scsi_Cmnd *SCpnt)
+static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 {
-	unsigned int  base      = SCpnt->device->host->io_port;
-	unsigned long mmio_base = SCpnt->device->host->base;
+	const unsigned int  base      = SCpnt->device->host->io_port;
+	const unsigned long mmio_base = SCpnt->device->host->base;
 	nsp_hw_data  *data      = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	int	      time_out;
-	int           ocount, res;
-	unsigned char stat;
+	int           ocount;
 
 	ocount	 = data->FifoCount;
 
@@ -845,6 +874,9 @@
 
 	while ((time_out-- != 0) &&
 	       (SCpnt->SCp.this_residual > 0 || SCpnt->SCp.buffers_residual > 0)) {
+		unsigned char stat;
+		int res;
+
 		stat = nsp_index_read(base, SCSIBUSMON);
 		stat &= BUSMON_PHASE_MASK;
 
@@ -900,7 +932,7 @@
 			//nsp_dbg(NSP_DEBUG_DATA_IO, "scatterlist next");
 			SCpnt->SCp.buffers_residual--;
 			SCpnt->SCp.buffer++;
-			SCpnt->SCp.ptr		 = BUFFER_ADDR;
+			SCpnt->SCp.ptr		 = SG_ADDRESS(SCpnt->SCp.buffer);
 			SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
 			time_out = 1000;
 		}
@@ -908,10 +940,10 @@
 
 	data->FifoCount = ocount;
 
-	if (time_out == 0) {
+	if (time_out <= 0) {
 		nsp_msg(KERN_DEBUG, "pio write timeout resid=0x%x", SCpnt->resid);
 	}
-	nsp_dbg(NSP_DEBUG_DATA_IO, "write ocount=0x%x", ocount);
+	nsp_dbg(NSP_DEBUG_DATA_IO, "write ocount=0x%x time_out=%d", ocount, time_out);
 	nsp_dbg(NSP_DEBUG_DATA_IO, "w cmd=%d resid=0x%x\n", data->CmdId, SCpnt->resid);
 }
 #undef RFIFO_CRIT
@@ -920,13 +952,13 @@
 /*
  * setup synchronous/asynchronous data transfer mode
  */
-static int nsp_nexus(Scsi_Cmnd *SCpnt)
+static int nsp_nexus(const struct scsi_cmnd *SCpnt)
 {
-	unsigned int   base   = SCpnt->device->host->io_port;
-	unsigned char  target = SCpnt->device->id;
-//	unsigned char  lun    = SCpnt->device->lun;
+	const unsigned int   base   = SCpnt->device->host->io_port;
+	const unsigned char  target = SCpnt->device->id;
+//	const unsigned char  lun    = SCpnt->device->lun;
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
-	sync_data     *sync   = &(data->Sync[target]);
+	const sync_data     *sync   = &(data->Sync[target]);
 
 	//nsp_dbg(NSP_DEBUG_DATA_IO, "in SCpnt=0x%p", SCpnt);
 
@@ -950,7 +982,7 @@
 	nsp_setup_fifo(data, TRUE);
 
 	/* clear ack counter */
- 	data->FifoCount = 0;
+	data->FifoCount = 0;
 	nsp_index_write(base, POINTERCLR, POINTER_CLEAR	    |
 					  ACK_COUNTER_CLEAR |
 					  REQ_COUNTER_CLEAR |
@@ -967,12 +999,13 @@
 {
 	unsigned int   base;
 	unsigned char  irq_status, irq_phase, phase;
-	Scsi_Cmnd     *tmpSC;
+	struct scsi_cmnd     *tmpSC;
 	unsigned char  target, lun;
 	unsigned int  *sync_neg;
 	int            i, tmp;
+	unsigned long  flags;
 	nsp_hw_data   *data;
-
+	int            handled = 0;
 
 	//nsp_dbg(NSP_DEBUG_INTR, "dev_id=0x%p", dev_id);
 	//nsp_dbg(NSP_DEBUG_INTR, "host=0x%p", ((scsi_info_t *)dev_id)->host);
@@ -981,12 +1014,14 @@
 	    ((scsi_info_t *)dev_id)->host != NULL  ) {
 		scsi_info_t *info = (scsi_info_t *)dev_id;
 
-		data = (nsp_hw_data *)info->host->hostdata;
+		data = (nsp_hw_data *)(info->host->hostdata);
 	} else {
 		nsp_dbg(NSP_DEBUG_INTR, "host data wrong");
 		return IRQ_NONE;
 	}
 
+        spin_lock_irqsave(HOST_LOCK, flags);
+
 	//nsp_dbg(NSP_DEBUG_INTR, "&nsp_data_base=0x%p, dev_id=0x%p", &nsp_data_base, dev_id);
 
 	base = data->BaseAddress;
@@ -995,14 +1030,14 @@
 	/*
 	 * interrupt check
 	 */
-	nsp_write(base, IRQCONTROL, IRQCONTROL_IRQDISABLE);
+	nsp_write(base, IRQCONTROL, IRQCONTROL_ALL_MASK);
 	irq_status = nsp_read(base, IRQSTATUS);
 	//nsp_dbg(NSP_DEBUG_INTR, "irq_status=0x%x", irq_status);
 	if ((irq_status == 0xff) || ((irq_status & IRQSTATUS_MASK) == 0)) {
-		nsp_write(base, IRQCONTROL, 0);
 		//nsp_dbg(NSP_DEBUG_INTR, "no irq/shared irq");
-		return IRQ_NONE;
+		goto out;
 	}
+	handled = 1;
 
 	/* XXX: IMPORTANT
 	 * Do not read an irq_phase register if no scsi phase interrupt.
@@ -1032,7 +1067,7 @@
 	    data->SelectionTimeOut == 0) {
 		//nsp_dbg(NSP_DEBUG_INTR, "timer start");
 		nsp_write(base, IRQCONTROL, IRQCONTROL_TIMER_CLEAR);
-		return IRQ_HANDLED;
+		goto out;
 	}
 
 	nsp_write(base, IRQCONTROL, IRQCONTROL_TIMER_CLEAR | IRQCONTROL_FIFO_CLEAR);
@@ -1051,14 +1086,14 @@
 				         ((tmpSC->SCp.Status  & 0xff) <<  0);
 			nsp_scsi_done(tmpSC);
 		}
-		return IRQ_HANDLED;
+		goto out;
 	}
 
 	if (data->CurrentSC == NULL) {
 		nsp_msg(KERN_ERR, "CurrentSC==NULL irq_status=0x%x phase=0x%x irq_phase=0x%x this can't be happen. reset everything", irq_status, phase, irq_phase);
 		nsphw_init(data);
 		nsp_bus_reset(data);
-		return IRQ_HANDLED;
+		goto out;
 	}
 
 	tmpSC    = data->CurrentSC;
@@ -1074,12 +1109,12 @@
 			nsp_dbg(NSP_DEBUG_INTR, "reselect");
 			nsp_write(base, IRQCONTROL, IRQCONTROL_RESELECT_CLEAR);
 			if (nsp_reselected(tmpSC) != FALSE) {
-				return IRQ_HANDLED;
+				goto out;
 			}
 		}
 
 		if ((irq_phase & (PHASE_CHANGE_IRQ | LATCHED_BUS_FREE)) == 0) {
-			return IRQ_HANDLED;
+			goto out;
 		}
 	}
 
@@ -1098,11 +1133,11 @@
 				tmpSC->result   = DID_TIME_OUT << 16;
 				nsp_scsi_done(tmpSC);
 
-				return IRQ_HANDLED;
+				goto out;
 			}
 			data->SelectionTimeOut += 1;
 			nsp_start_timer(tmpSC, 1000/51);
-			return IRQ_HANDLED;
+			goto out;
 		}
 
 		/* attention assert */
@@ -1112,7 +1147,7 @@
 		nsp_index_write(base, SCSIBUSCTRL, SCSI_ATN);
 		udelay(1);
 		nsp_index_write(base, SCSIBUSCTRL, SCSI_ATN | AUTODIRECTION | ACKENB);
-		return IRQ_HANDLED;
+		goto out;
 
 		break;
 
@@ -1123,12 +1158,12 @@
 
 			tmpSC->result	= DID_ABORT << 16;
 			nsp_scsi_done(tmpSC);
-			return IRQ_HANDLED;
+			goto out;
 		}
 		/* fall thru */
 	default:
 		if ((irq_status & (IRQSTATUS_SCSI | IRQSTATUS_FIFO)) == 0) {
-			return IRQ_HANDLED;
+			goto out;
 		}
 		break;
 	}
@@ -1143,19 +1178,19 @@
 	    (irq_phase & LATCHED_BUS_FREE) != 0 ) {
 		nsp_dbg(NSP_DEBUG_INTR, "normal disconnect irq_status=0x%x, phase=0x%x, irq_phase=0x%x", irq_status, phase, irq_phase);
 
-		//*sync_neg       = SYNC_NOT_YET;
+		// *sync_neg       = SYNC_NOT_YET;
 
-		if ((tmpSC->SCp.Message == MSG_COMMAND_COMPLETE)) {     /* all command complete and return status */
+		if ((tmpSC->SCp.Message == COMMAND_COMPLETE)) {     /* all command complete and return status */
 			tmpSC->result = (DID_OK		             << 16) |
 					((tmpSC->SCp.Message & 0xff) <<  8) |
 					((tmpSC->SCp.Status  & 0xff) <<  0);
 			nsp_dbg(NSP_DEBUG_INTR, "command complete result=0x%x", tmpSC->result);
 			nsp_scsi_done(tmpSC);
 
-			return IRQ_HANDLED;
+			goto out;
 		}
 
-		return IRQ_HANDLED;
+		goto out;
 	}
 
 
@@ -1164,9 +1199,9 @@
 		nsp_msg(KERN_DEBUG, "unexpected bus free. irq_status=0x%x, phase=0x%x, irq_phase=0x%x", irq_status, phase, irq_phase);
 
 		*sync_neg       = SYNC_NG;
-		tmpSC->result   = DID_ERROR << 16;
+		tmpSC->result   = (DID_ERROR << 16) | (tmpSC->SCp.Status << 0);
 		nsp_scsi_done(tmpSC);
-		return IRQ_HANDLED;
+		goto out;
 	}
 
 	switch (phase & BUSMON_PHASE_MASK) {
@@ -1174,7 +1209,7 @@
 		nsp_dbg(NSP_DEBUG_INTR, "BUSPHASE_COMMAND");
 		if ((phase & BUSMON_REQ) == 0) {
 			nsp_dbg(NSP_DEBUG_INTR, "REQ == 0");
-			return IRQ_HANDLED;
+			goto out;
 		}
 
 		tmpSC->SCp.phase = PH_COMMAND;
@@ -1229,24 +1264,19 @@
 
 		tmpSC->SCp.phase = PH_MSG_OUT;
 
-		//*sync_neg = SYNC_NOT_YET;
+		// *sync_neg = SYNC_NOT_YET;
 
-		data->MsgLen = i = 0;
-		data->MsgBuffer[i] = IDENTIFY(TRUE, lun); i++;
+		data->MsgOutLen = 0;
+		nsp_build_identify(tmpSC);
 
 		if (*sync_neg == SYNC_NOT_YET) {
 			data->Sync[target].SyncPeriod = 0;
 			data->Sync[target].SyncOffset = 0;
 
 			/**/
-			data->MsgBuffer[i] = MSG_EXTENDED; i++;
-			data->MsgBuffer[i] = 3;            i++;
-			data->MsgBuffer[i] = MSG_EXT_SDTR; i++;
-			data->MsgBuffer[i] = 0x0c;         i++;
-			data->MsgBuffer[i] = 15;           i++;
+			nsp_build_sdtr(tmpSC, 0x0c, 15);
 			/**/
 		}
-		data->MsgLen = i;
 
 		nsp_analyze_sdtr(tmpSC);
 		show_message(data);
@@ -1267,13 +1297,13 @@
 		if (*sync_neg == SYNC_NOT_YET) {
 			//nsp_dbg(NSP_DEBUG_INTR, "sync target=%d,lun=%d",target,lun);
 
-			if (data->MsgLen       >= 5            &&
-			    data->MsgBuffer[0] == MSG_EXTENDED &&
-			    data->MsgBuffer[1] == 3            &&
-			    data->MsgBuffer[2] == MSG_EXT_SDTR ) {
-				data->Sync[target].SyncPeriod = data->MsgBuffer[3];
-				data->Sync[target].SyncOffset = data->MsgBuffer[4];
-				//nsp_dbg(NSP_DEBUG_INTR, "sync ok, %d %d", data->MsgBuffer[3], data->MsgBuffer[4]);
+			if (data->MsgInLen       >= 5                &&
+			    data->MsgInBuffer[0] == EXTENDED_MESSAGE &&
+			    data->MsgInBuffer[1] == 3                &&
+			    data->MsgInBuffer[2] == EXTENDED_SDTR    ) {
+				data->Sync[target].SyncPeriod = data->MsgInBuffer[3];
+				data->Sync[target].SyncOffset = data->MsgInBuffer[4];
+				//nsp_dbg(NSP_DEBUG_INTR, "sync ok, %d %d", data->MsgInBuffer[3], data->MsgInBuffer[4]);
 				*sync_neg = SYNC_OK;
 			} else {
 				data->Sync[target].SyncPeriod = 0;
@@ -1286,15 +1316,15 @@
 
 		/* search last messeage byte */
 		tmp = -1;
-		for (i = 0; i < data->MsgLen; i++) {
-			tmp = data->MsgBuffer[i];
-			if (data->MsgBuffer[i] == MSG_EXTENDED) {
-				i += (1 + data->MsgBuffer[i+1]);
+		for (i = 0; i < data->MsgInLen; i++) {
+			tmp = data->MsgInBuffer[i];
+			if (data->MsgInBuffer[i] == EXTENDED_MESSAGE) {
+				i += (1 + data->MsgInBuffer[i+1]);
 			}
 		}
 		tmpSC->SCp.Message = tmp;
 
-		nsp_dbg(NSP_DEBUG_INTR, "message=0x%x len=%d", tmpSC->SCp.Message, data->MsgLen);
+		nsp_dbg(NSP_DEBUG_INTR, "message=0x%x len=%d", tmpSC->SCp.Message, data->MsgInLen);
 		show_message(data);
 
 		break;
@@ -1306,17 +1336,18 @@
 		break;
 	}
 
-	//nsp_dbg(NSP_DEBUG_INTR, "out");
-	return IRQ_HANDLED; 	
+	goto out;
+
 
 timer_out:
 	nsp_start_timer(tmpSC, 1000/102);
-	return IRQ_HANDLED;
+ out:
+	nsp_write(base, IRQCONTROL, 0); /* clear IRQ mask */
+        spin_unlock_irqrestore(HOST_LOCK, flags);
+	//nsp_dbg(NSP_DEBUG_INTR, "out");
+	return IRQ_RETVAL(handled);
 }
 
-#ifdef NSP_DEBUG
-#include "nsp_debug.c"
-#endif	/* NSP_DEBUG */
 
 /*----------------------------------------------------------------*/
 /* look for ninja3 card and init if found			  */
@@ -1324,7 +1355,7 @@
 static struct Scsi_Host *nsp_detect(Scsi_Host_Template *sht)
 {
 	struct Scsi_Host *host;	/* registered host structure */
-	nsp_hw_data *data_b = &nsp_data_base, *data;
+	nsp_hw_data      *data;
 
 	nsp_dbg(NSP_DEBUG_INIT, "this_id=%d", sht->this_id);
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
@@ -1334,67 +1365,71 @@
 #endif
 	if (host == NULL) {
 		nsp_dbg(NSP_DEBUG_INIT, "host failed");
-		return NULL;
+		goto err;
 	}
 
-	memcpy(host->hostdata, data_b, sizeof(nsp_hw_data));
-	data = (nsp_hw_data *)host->hostdata;
+	/* Copy global variable to driver specific area */
+	data  = (nsp_hw_data *)host->hostdata;
+	*data = nsp_data_base;
+
 	data->ScsiInfo->host = host;
 #ifdef NSP_DEBUG
 	data->CmdId = 0;
 #endif
 
-	nsp_dbg(NSP_DEBUG_INIT, "irq=%d,%d", data_b->IrqNumber, ((nsp_hw_data *)host->hostdata)->IrqNumber);
+	nsp_dbg(NSP_DEBUG_INIT, "irq base=0x%p,%d data=0x%p,%d", &nsp_data_base, (&nsp_data_base)->IrqNumber, data, data->IrqNumber);
 
-	host->unique_id	  = data->BaseAddress;
-	host->io_port	  = data->BaseAddress;
-	host->n_io_port	  = data->NumAddress;
-	host->irq	  = data->IrqNumber;
-	host->base        = data->MmioAddress;
+	host->unique_id	= data->BaseAddress;
+	host->io_port   = data->BaseAddress;
+	host->n_io_port	= data->NumAddress;
+	host->irq       = data->IrqNumber;
+	host->base      = data->MmioAddress;
 
 	spin_lock_init(&(data->Lock));
 
 	snprintf(data->nspinfo,
 		 sizeof(data->nspinfo),
-		 "NinjaSCSI-3/32Bi Driver $Revision: 1.23 $ IO:0x%04lx-0x%04lx MMIO(virt addr):0x%04lx IRQ:%02d",
+		 "NinjaSCSI-3/32Bi Driver $Revision: 1.44 $ IO:0x%04lx-0x%04lx MMIO(virt addr):0x%04lx IRQ:%02d",
 		 host->io_port, host->io_port + host->n_io_port - 1,
 		 host->base,
 		 host->irq);
-	sht->name	  = data->nspinfo;
+	sht->name = data->nspinfo;
 
 	nsp_dbg(NSP_DEBUG_INIT, "end");
 
-
 	return host; /* detect done. */
+
+
+ err:
+	return NULL;
 }
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
+/*----------------------------------------*/
+/* Compatibility functions for 2.4 kernel */
+/*----------------------------------------*/
 static int nsp_detect_old(Scsi_Host_Template *sht)
 {
 	if (nsp_detect(sht) == NULL) {
 		return 0;
 	} else {
-		//MOD_INC_USE_COUNT;
-		return 1;
+		return 1; /* detects 1 Ninja host card */
 	}
 }
 
-
-static int nsp_release_old(struct Scsi_Host *shpnt)
+static int nsp_release_old(struct Scsi_Host *host)
 {
-	//nsp_hw_data *data = (nsp_hw_data *)shpnt->hostdata;
+	//nsp_hw_data *data = (nsp_hw_data *)(host->hostdata);
 
 	/* PCMCIA Card Service dose same things below. */
 	/* So we do nothing.                           */
-	//if (shpnt->irq) {
-	//	free_irq(shpnt->irq, data->ScsiInfo);
+	//if (host->irq) {
+	//	free_irq(host->irq, data->ScsiInfo);
 	//}
-	//if (shpnt->io_port) {
-	//	release_region(shpnt->io_port, shpnt->n_io_port);
+	//if (host->io_port) {
+	//	release_region(host->io_port, host->n_io_port);
 	//}
 
-	//MOD_DEC_USE_COUNT;
-
 	return 0;
 }
 #endif
@@ -1404,7 +1439,7 @@
 /*----------------------------------------------------------------*/
 static const char *nsp_info(struct Scsi_Host *shpnt)
 {
-	nsp_hw_data *data = (nsp_hw_data *)shpnt->hostdata;
+	const nsp_hw_data *data = (nsp_hw_data *)shpnt->hostdata;
 
 	return data->nspinfo;
 }
@@ -1417,6 +1452,8 @@
 			nsp_dbg(NSP_DEBUG_PROC, "buffer=0x%p pos=0x%p length=%d %d\n", buffer, pos, length,  length - (pos - buffer));\
 		} \
 	} while(0)
+
+/* Shows Ninja host card information for user. */
 static int
 nsp_proc_info(
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
@@ -1431,16 +1468,15 @@
 #endif
 	int    inout)
 {
-	int id;
-	char *pos = buffer;
-	int thislength;
-	int speed;
-	unsigned long flags;
-	nsp_hw_data *data;
+	char             *pos = buffer;
+	int               id;
+	int               thislength;
+	unsigned long     flags;
+	nsp_hw_data      *data;
 #if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	struct Scsi_Host *host;
 #else
-	int hostno;
+	int               hostno;
 #endif
 	if (inout) {
 		return -EINVAL;
@@ -1459,7 +1495,7 @@
 
 
 	SPRINTF("NinjaSCSI status\n\n");
-	SPRINTF("Driver version:        $Revision: 1.23 $\n");
+	SPRINTF("Driver version:        $Revision: 1.44 $\n");
 	SPRINTF("SCSI host No.:         %d\n",          hostno);
 	SPRINTF("IRQ:                   %d\n",          host->irq);
 	SPRINTF("IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
@@ -1482,10 +1518,12 @@
 		break;
 	}
 	SPRINTF("\n");
+	SPRINTF("Chip ID:               %d\n", data->ChipRev >> 4);
+	SPRINTF("Chip revision:         %d\n", data->ChipRev &  0x0f);
 
 
 	spin_lock_irqsave(&(data->Lock), flags);
-	SPRINTF("CurrentSC:             0x%p\n\n",      data->CurrentSC);
+	SPRINTF("CurrentSC:             0x%p\n\n", data->CurrentSC);
 	spin_unlock_irqrestore(&(data->Lock), flags);
 
 	SPRINTF("SDTR status\n");
@@ -1514,6 +1552,7 @@
 		}
 
 		if (data->Sync[id].SyncPeriod != 0) {
+			int speed;
 			speed = 1000000 / (data->Sync[id].SyncPeriod * 4);
 
 			SPRINTF(" transfer %d.%dMB/s, offset %d",
@@ -1528,9 +1567,9 @@
 	thislength = pos - (buffer + offset);
 
 	if(thislength < 0) {
-		*start = NULL;
-                return 0;
-        }
+		*start = 0;
+		return 0;
+	}
 
 
 	thislength = min(thislength, length);
@@ -1550,7 +1589,7 @@
 }*/
 
 /*
-static int nsp_eh_abort(Scsi_Cmnd *SCpnt)
+static int nsp_eh_abort(struct scsi_cmnd *SCpnt)
 {
 	nsp_dbg(NSP_DEBUG_BUSRESET, "SCpnt=0x%p", SCpnt);
 
@@ -1558,19 +1597,21 @@
 }*/
 
 /*
-static int nsp_eh_device_reset(Scsi_Cmnd *SCpnt)
+static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt)
 {
 	nsp_dbg(NSP_DEBUG_BUSRESET, "%s: SCpnt=0x%p", SCpnt);
 
 	return FAILED;
 }*/
 
+/* Do bus reset. This function uses in low-level initialize functions. */
 static int nsp_bus_reset(nsp_hw_data *data)
 {
-	unsigned int base = data->BaseAddress;
-	int	     i;
+	const unsigned int base = data->BaseAddress;
+	int i;
 
-	nsp_write(base, IRQCONTROL, IRQCONTROL_ALLMASK);
+	nsp_msg(KERN_WARNING, "Bus reset");
+	nsp_write(base, IRQCONTROL, IRQCONTROL_ALL_CLEAR_AND_MASK);
 
 	nsp_index_write(base, SCSIBUSCTRL, SCSI_RST);
 	mdelay(100); /* 100ms */
@@ -1581,12 +1622,19 @@
 
 	nsphw_init_sync(data);
 
-	nsp_write(base, IRQCONTROL, IRQCONTROL_ALLCLEAR);
+	nsp_write(base, IRQCONTROL, IRQCONTROL_ALL_CLEAR);
+
+	if (data->CurrentSC != NULL) {
+		nsp_msg(KERN_WARNING, "clean up current scsi command.");
+		data->CurrentSC->result = DID_ERROR << 16;
+		nsp_scsi_done(data->CurrentSC);
+	}
 
 	return SUCCESS;
 }
 
-static int nsp_eh_bus_reset(Scsi_Cmnd *SCpnt)
+/* Do bus reset. This function uses in high-level SCSI driver. */
+static int nsp_eh_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
@@ -1595,11 +1643,13 @@
 	return nsp_bus_reset(data);
 }
 
-static int nsp_eh_host_reset(Scsi_Cmnd *SCpnt)
+/* Initialise Ninja host adapter. */
+static int nsp_eh_host_reset(struct scsi_cmnd *SCpnt)
 {
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
 	nsp_dbg(NSP_DEBUG_BUSRESET, "in");
+	nsp_msg(KERN_DEBUG, "host reset");
 
 	nsphw_init(data);
 
@@ -1631,9 +1681,8 @@
 	nsp_dbg(NSP_DEBUG_INIT, "in");
 
 	/* Create new SCSI device */
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	info = kcalloc(1, sizeof(*info), GFP_KERNEL);
 	if (info == NULL) { return NULL; }
-	memset(info, 0, sizeof(*info));
 	link = &info->link;
 	link->priv = info;
 	data->ScsiInfo = info;
@@ -1646,8 +1695,11 @@
 	link->io.IOAddrLines	 = 10;	/* not used */
 
 	/* Interrupt setup */
-	link->irq.Attributes	 = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
-	link->irq.IRQInfo1	 = IRQ_INFO2_VALID    | IRQ_LEVEL_ID;
+	link->irq.Attributes	 = IRQ_TYPE_EXCLUSIVE |
+		                   IRQ_HANDLE_PRESENT |
+		                   SA_SAMPLE_RANDOM   ;
+	link->irq.IRQInfo1	 = IRQ_INFO2_VALID    |
+		                   IRQ_LEVEL_ID       ;
 	if (irq_list[0] == -1) {
 		link->irq.IRQInfo2 = irq_mask;
 	} else {
@@ -1659,7 +1711,6 @@
 	/* Interrupt handler */
 	link->irq.Handler	 = &nspintr;
 	link->irq.Instance       = info;
-	link->irq.Attributes     |= (SA_SHIRQ | SA_SAMPLE_RANDOM);
 
 	/* General socket configuration */
 	link->conf.Attributes	 = CONF_ENABLE_IRQ;
@@ -1715,8 +1766,9 @@
 		return;
 	}
 
-	if (link->state & DEV_CONFIG)
+	if (link->state & DEV_CONFIG) {
 		nsp_cs_release(link);
+	}
 
 	/* Break the link with Card Services */
 	if (link->handle) {
@@ -1752,7 +1804,7 @@
 	memreq_t          map;
 	cistpl_cftable_entry_t dflt = { 0 };
 	struct Scsi_Host *host;
-	nsp_hw_data      *data = &nsp_data_base;
+	nsp_hw_data      *data_b = &nsp_data_base;
 #if !(LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
 	Scsi_Device	 *dev;
 	dev_node_t	**tail, *node;
@@ -1765,9 +1817,9 @@
 	tuple.TupleData	      = tuple_data;
 	tuple.TupleDataMax    = sizeof(tuple_data);
 	tuple.TupleOffset     = 0;
-	CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(handle, &tuple));
-	CS_CHECK(GetTupleData,	pcmcia_get_tuple_data(handle, &tuple));
-	CS_CHECK(ParseTuple,	pcmcia_parse_tuple(handle, &tuple, &parse));
+	CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(handle, &tuple        ));
+	CS_CHECK(GetTupleData,  pcmcia_get_tuple_data( handle, &tuple        ));
+	CS_CHECK(ParseTuple,    pcmcia_parse_tuple(    handle, &tuple, &parse));
 	link->conf.ConfigBase = parse.config.base;
 	link->conf.Present    = parse.config.rmask[0];
 
@@ -1783,9 +1835,10 @@
 	while (1) {
 		cistpl_cftable_entry_t *cfg = &(parse.cftable_entry);
 
-		if (pcmcia_get_tuple_data(handle, &tuple) != 0 ||
-				pcmcia_parse_tuple(handle, &tuple, &parse) != 0)
-			goto next_entry;
+		if (pcmcia_get_tuple_data(handle, &tuple        ) != 0 ||
+		    pcmcia_parse_tuple(   handle, &tuple, &parse) != 0) {
+                        goto next_entry;
+		}
 
 		if (cfg->flags & CISTPL_CFTABLE_DEFAULT) { dflt = *cfg; }
 		if (cfg->index == 0) { goto next_entry; }
@@ -1799,12 +1852,12 @@
 
 		/* Use power settings for Vcc and Vpp if present */
 		/*  Note that the CIS values need to be rescaled */
-		if (cfg->vcc.present & (1<<CISTPL_POWER_VNOM)) {
-			if (conf.Vcc != cfg->vcc.param[CISTPL_POWER_VNOM]/10000) {
+		if (cfg->vcc.present & (1 << CISTPL_POWER_VNOM)) {
+			if (conf.Vcc != cfg->vcc.param[CISTPL_POWER_VNOM] / 10000) {
 				goto next_entry;
 			}
-		} else if (dflt.vcc.present & (1<<CISTPL_POWER_VNOM)) {
-			if (conf.Vcc != dflt.vcc.param[CISTPL_POWER_VNOM]/10000) {
+		} else if (dflt.vcc.present & (1 << CISTPL_POWER_VNOM)) {
+			if (conf.Vcc != dflt.vcc.param[CISTPL_POWER_VNOM] / 10000) {
 				goto next_entry;
 			}
 		}
@@ -1836,18 +1889,19 @@
 			link->io.NumPorts1 = io->win[0].len;
 			if (io->nwin > 1) {
 				link->io.Attributes2 = link->io.Attributes1;
-				link->io.BasePort2 = io->win[1].base;
-				link->io.NumPorts2 = io->win[1].len;
+				link->io.BasePort2   = io->win[1].base;
+				link->io.NumPorts2   = io->win[1].len;
 			}
 			/* This reserves IO space but doesn't actually enable it */
-			if (pcmcia_request_io(link->handle, &link->io) != 0)
+			if (pcmcia_request_io(link->handle, &link->io) != 0) {
 				goto next_entry;
+			}
 		}
 
 		if ((cfg->mem.nwin > 0) || (dflt.mem.nwin > 0)) {
 			cistpl_mem_t *mem =
 				(cfg->mem.nwin) ? &cfg->mem : &dflt.mem;
-			req.Attributes = WIN_DATA_WIDTH_16|WIN_MEMORY_TYPE_CM;
+			req.Attributes = WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_CM;
 			req.Attributes |= WIN_ENABLE;
 			req.Base = mem->win[0].host_addr;
 			req.Size = mem->win[0].len;
@@ -1855,14 +1909,17 @@
 				req.Size = 0x1000;
 			}
 			req.AccessSpeed = 0;
-			if (pcmcia_request_window(&link->handle, &req, &link->win) != 0)
+			link->win = (window_handle_t)link->handle;
+			if (pcmcia_request_window(&link->handle, &req, &link->win) != 0) {
 				goto next_entry;
+			}
 			map.Page = 0; map.CardOffset = mem->win[0].card_addr;
-			if (pcmcia_map_mem_page(link->win, &map) != 0)
+			if (pcmcia_map_mem_page(link->win, &map) != 0) {
 				goto next_entry;
+			}
 
-			data->MmioAddress = (unsigned long)ioremap_nocache(req.Base, req.Size);
-			data->MmioLength  = req.Size;
+			data_b->MmioAddress = (unsigned long)ioremap_nocache(req.Base, req.Size);
+			data_b->MmioLength  = req.Size;
 		}
 		/* If we got this far, we're cool! */
 		break;
@@ -1881,27 +1938,20 @@
 	}
 	CS_CHECK(RequestConfiguration, pcmcia_request_configuration(handle, &link->conf));
 
-	if (free_ports) {
-		if (link->io.BasePort1) {
-			release_region(link->io.BasePort1, link->io.NumPorts1);
-		}
-		if (link->io.BasePort2) {
-			release_region(link->io.BasePort2, link->io.NumPorts2);
-		}
-	}
 
 	/* Set port and IRQ */
-	data->BaseAddress = link->io.BasePort1;
-	data->NumAddress  = link->io.NumPorts1;
-	data->IrqNumber   = link->irq.AssignedIRQ;
+	data_b->BaseAddress = link->io.BasePort1;
+	data_b->NumAddress  = link->io.NumPorts1;
+	data_b->IrqNumber   = link->irq.AssignedIRQ;
 
 	nsp_dbg(NSP_DEBUG_INIT, "I/O[0x%x+0x%x] IRQ %d",
-		data->BaseAddress, data->NumAddress, data->IrqNumber);
+		data_b->BaseAddress, data_b->NumAddress, data_b->IrqNumber);
 
-	if(nsphw_init(data) == FALSE) {
+	if(nsphw_init(data_b) == FALSE) {
 		goto cs_failed;
 	}
 
+	/* nsp_data_base is not userble after nsp_detect() is called */
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,2))
 	host = nsp_detect(&nsp_driver_template);
 #else
@@ -1919,27 +1969,26 @@
 		goto cs_failed;
 	}
 
-
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
 	scsi_add_host (host, NULL);
 	scsi_scan_host(host);
 
 	snprintf(info->node.dev_name, sizeof(info->node.dev_name), "scsi%d", host->host_no);
-	link->dev  = &info->node;
+	link->dev  = &(info->node);
 	info->host = host;
 
 #else
 	nsp_dbg(NSP_DEBUG_INIT, "GET_SCSI_INFO");
-	tail = &link->dev;
+	tail = &(link->dev);
 	info->ndev = 0;
 
 	nsp_dbg(NSP_DEBUG_INIT, "host=0x%p", host);
 
 	for (dev = host->host_queue; dev != NULL; dev = dev->next) {
-		unsigned long id;
-		id = (dev->id & 0x0f) + ((dev->lun & 0x0f) << 4) +
-			((dev->channel & 0x0f) << 8) +
-			((dev->host->host_no & 0x0f) << 12);
+		unsigned long arg[2], id;
+		kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
+		id = (arg[0] & 0x0f) + ((arg[0] >> 4) & 0xf0) +
+			((arg[0] >> 8) & 0xf00) + ((arg[0] >> 12) & 0xf000);
 		node = &info->node[info->ndev];
 		node->minor = 0;
 		switch (dev->type) {
@@ -1962,7 +2011,9 @@
 			snprintf(node->dev_name, sizeof(node->dev_name), "sg#%04lx", id);
 			break;
 		}
-		*tail = node; tail = &node->next;
+		*tail = node;
+		tail = &(node->next);
+
 		info->ndev++;
 		info->host = dev->host;
 	}
@@ -1977,23 +2028,23 @@
 	/* Finally, report what we've done */
 	printk(KERN_INFO "nsp_cs: index 0x%02x: Vcc %d.%d",
 	       link->conf.ConfigIndex,
-	       link->conf.Vcc/10, link->conf.Vcc%10);
+	       link->conf.Vcc / 10, link->conf.Vcc % 10);
 	if (link->conf.Vpp1) {
-		printk(", Vpp %d.%d", link->conf.Vpp1/10, link->conf.Vpp1%10);
+		printk(", Vpp %d.%d", link->conf.Vpp1 / 10, link->conf.Vpp1 % 10);
 	}
 	if (link->conf.Attributes & CONF_ENABLE_IRQ) {
 		printk(", irq %d", link->irq.AssignedIRQ);
 	}
 	if (link->io.NumPorts1) {
 		printk(", io 0x%04x-0x%04x", link->io.BasePort1,
-		       link->io.BasePort1+link->io.NumPorts1-1);
+		       link->io.BasePort1 + link->io.NumPorts1 - 1);
 	}
 	if (link->io.NumPorts2)
 		printk(" & 0x%04x-0x%04x", link->io.BasePort2,
-		       link->io.BasePort2+link->io.NumPorts2-1);
+		       link->io.BasePort2 + link->io.NumPorts2 - 1);
 	if (link->win)
 		printk(", mem 0x%06lx-0x%06lx", req.Base,
-		       req.Base+req.Size-1);
+		       req.Base+req.Size - 1);
 	printk("\n");
 
 	link->state &= ~DEV_CONFIG_PENDING;
@@ -2035,6 +2086,7 @@
 #else
 	scsi_unregister_host(&nsp_driver_template);
 #endif
+
 	link->dev = NULL;
 
 	if (link->win) {
@@ -2208,7 +2260,7 @@
 }
 
 
-module_init(nsp_cs_init)
-module_exit(nsp_cs_exit)
+module_init(nsp_cs_init);
+module_exit(nsp_cs_exit);
 
 /* end */
