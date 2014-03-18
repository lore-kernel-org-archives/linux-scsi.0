From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 12/12] scsi/NCR5380: merge sun3_scsi_vme.c into sun3_scsi.c
Date: Tue, 18 Mar 2014 11:42:24 +1100
Message-ID: <20140318004216.172443207@telegraphics.com.au>
References: <20140318004212.612472697@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-sun3-vme-merge
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
