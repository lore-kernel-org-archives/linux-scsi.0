From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update dec_esp with changes from mips CVS
Date: Wed, 19 Jan 2005 12:46:29 +0100
Message-ID: <20050119114629.GC11133@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59092 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261698AbVASLqq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 06:46:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Changes are from Maciej W. Rozycki and not nicely splitup because it's
the changes to make it work with 2.6 again.  Cosmetic changes by me
to avoid obsolete typedefs.


--- 1.14/drivers/scsi/dec_esp.c	2004-08-27 12:34:15 +02:00
+++ edited/drivers/scsi/dec_esp.c	2005-01-16 11:49:14 +01:00
@@ -17,6 +17,8 @@
  *            data.
  * 20001005	- Initialization fixes for 2.4.0-test9
  * 			  Florian Lohoff <flo@rfc822.org>
+ *
+ *	Copyright (C) 2002, 2003  Maciej W. Rozycki
  */
 
 #include <linux/kernel.h>
@@ -26,59 +28,52 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
+#include <linux/spinlock.h>
 #include <linux/stat.h>
 
-#include "scsi.h"
-#include <scsi/scsi_host.h>
-#include "NCR53C9x.h"
-
-#include <asm/irq.h>
-#include <asm/jazz.h>
-#include <asm/jazzdma.h>
 #include <asm/dma.h>
-
+#include <asm/irq.h>
 #include <asm/pgtable.h>
+#include <asm/system.h>
 
-#include <asm/dec/tc.h>
 #include <asm/dec/interrupts.h>
+#include <asm/dec/ioasic.h>
 #include <asm/dec/ioasic_addrs.h>
 #include <asm/dec/ioasic_ints.h>
 #include <asm/dec/machtype.h>
+#include <asm/dec/tc.h>
 
 #define DEC_SCSI_SREG 0
 #define DEC_SCSI_DMAREG 0x40000
 #define DEC_SCSI_SRAM 0x80000
 #define DEC_SCSI_DIAG 0xC0000
 
-/*
- * Once upon a time the pmaz code used to be working but
- * it hasn't been maintained for quite some time.
- * It isn't working anymore but I'll leave here as a
- * starting point. #define this an be prepared for tons
- * of warnings and errors :)
- */
+#include "scsi.h"
+#include <scsi/scsi_host.h>
+#include "NCR53C9x.h"
+
 static int  dma_bytes_sent(struct NCR_ESP *esp, int fifo_count);
 static void dma_drain(struct NCR_ESP *esp);
-static int  dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd * sp);
+static int  dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp);
 static void dma_dump_state(struct NCR_ESP *esp);
-static void dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int length);
-static void dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int length);
+static void dma_init_read(struct NCR_ESP *esp, u32 vaddress, int length);
+static void dma_init_write(struct NCR_ESP *esp, u32 vaddress, int length);
 static void dma_ints_off(struct NCR_ESP *esp);
 static void dma_ints_on(struct NCR_ESP *esp);
 static int  dma_irq_p(struct NCR_ESP *esp);
 static int  dma_ports_p(struct NCR_ESP *esp);
-static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write);
-static void dma_mmu_get_scsi_one(struct NCR_ESP *esp, Scsi_Cmnd * sp);
-static void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, Scsi_Cmnd * sp);
-static void dma_advance_sg(Scsi_Cmnd * sp);
+static void dma_setup(struct NCR_ESP *esp, u32 addr, int count, int write);
+static void dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd * sp);
+static void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd * sp);
+static void dma_advance_sg(struct scsi_cmnd * sp);
 
 static void pmaz_dma_drain(struct NCR_ESP *esp);
-static void pmaz_dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int length);
-static void pmaz_dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int length);
+static void pmaz_dma_init_read(struct NCR_ESP *esp, u32 vaddress, int length);
+static void pmaz_dma_init_write(struct NCR_ESP *esp, u32 vaddress, int length);
 static void pmaz_dma_ints_off(struct NCR_ESP *esp);
 static void pmaz_dma_ints_on(struct NCR_ESP *esp);
-static void pmaz_dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write);
-static void pmaz_dma_mmu_get_scsi_one(struct NCR_ESP *esp, Scsi_Cmnd * sp);
+static void pmaz_dma_setup(struct NCR_ESP *esp, u32 addr, int count, int write);
+static void pmaz_dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd * sp);
 
 #define TC_ESP_RAM_SIZE 0x20000
 #define ESP_TGT_DMA_SIZE ((TC_ESP_RAM_SIZE/7) & ~(sizeof(int)-1))
@@ -88,7 +83,7 @@
 #define TC_ESP_DMAR_WRITE 0x80000000
 #define TC_ESP_DMA_ADDR(x) ((unsigned)(x) & TC_ESP_DMAR_MASK)
 
-__u32 esp_virt_buffer;
+u32 esp_virt_buffer;
 int scsi_current_length;
 
 volatile unsigned char cmd_buffer[16];
@@ -98,16 +93,11 @@
 				 * via PIO.
 				 */
 
-volatile unsigned long *scsi_dma_ptr;
-volatile unsigned long *scsi_next_ptr;
-volatile unsigned long *scsi_scr;
-volatile unsigned long *ioasic_ssr;
-volatile unsigned long *scsi_sdr0;
-volatile unsigned long *scsi_sdr1;
+static irqreturn_t scsi_dma_merr_int(int, void *, struct pt_regs *);
+static irqreturn_t scsi_dma_err_int(int, void *, struct pt_regs *);
+static irqreturn_t scsi_dma_int(int, void *, struct pt_regs *);
 
-static void scsi_dma_int(int, void *, struct pt_regs *);
-
-int dec_esp_detect(Scsi_Host_Template * tpnt);
+static int dec_esp_detect(struct scsi_host_template * tpnt);
 
 static int dec_esp_release(struct Scsi_Host *shost)
 {
@@ -119,9 +109,9 @@
 	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "dec_esp",
-	.proc_info		= &esp_proc_info,
+	.proc_info		= esp_proc_info,
 	.name			= "NCR53C94",
 	.detect			= dec_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
@@ -142,7 +132,7 @@
 #include "scsi_module.c"
 
 /***************************************************************** Detection */
-int dec_esp_detect(Scsi_Host_Template * tpnt)
+static int dec_esp_detect(Scsi_Host_Template * tpnt)
 {
 	struct NCR_ESP *esp;
 	struct ConfigDev *esp_dev;
@@ -152,17 +142,10 @@
 	if (IOASIC) {
 		esp_dev = 0;
 		esp = esp_allocate(tpnt, (void *) esp_dev);
-	
-		scsi_dma_ptr = (unsigned long *) (system_base + IOCTL + SCSI_DMA_P);
-		scsi_next_ptr = (unsigned long *) (system_base + IOCTL + SCSI_DMA_BP);
-		scsi_scr = (unsigned long *) (system_base + IOCTL + SCSI_SCR);
-		ioasic_ssr = (unsigned long *) (system_base + IOCTL + SSR);
-		scsi_sdr0 = (unsigned long *) (system_base + IOCTL + SCSI_SDR0);
-		scsi_sdr1 = (unsigned long *) (system_base + IOCTL + SCSI_SDR1);
 
 		/* Do command transfer with programmed I/O */
 		esp->do_pio_cmds = 1;
-	
+
 		/* Required functions */
 		esp->dma_bytes_sent = &dma_bytes_sent;
 		esp->dma_can_transfer = &dma_can_transfer;
@@ -185,7 +168,7 @@
 		esp->dma_reset = 0;
 		esp->dma_led_off = 0;
 		esp->dma_led_on = 0;
-		
+
 		/* virtual DMA functions */
 		esp->dma_mmu_get_scsi_one = &dma_mmu_get_scsi_one;
 		esp->dma_mmu_get_scsi_sgl = &dma_mmu_get_scsi_sgl;
@@ -197,38 +180,42 @@
 		/* SCSI chip speed */
 		esp->cfreq = 25000000;
 
-		/*
-		 * we don't give the address of DMA channel, but the number
-		 * of DMA channel, so we can use the jazz DMA functions
-		 *
-		 */
-		esp->dregs = JAZZ_SCSI_DMA;
-	
+		esp->dregs = 0;
+
 		/* ESP register base */
-		esp->eregs = (struct ESP_regs *) (system_base + SCSI);
-	
+		esp->eregs = (struct ESP_regs *) (system_base + IOASIC_SCSI);
+
 		/* Set the command buffer */
 		esp->esp_command = (volatile unsigned char *) cmd_buffer;
-	
+
 		/* get virtual dma address for command buffer */
-		esp->esp_command_dvma = (__u32) KSEG1ADDR((volatile unsigned char *) cmd_buffer);
-	
-		esp->irq = SCSI_INT;
+		esp->esp_command_dvma = virt_to_phys(cmd_buffer);
+
+		esp->irq = dec_interrupt[DEC_IRQ_ASC];
 
 		esp->scsi_id = 7;
-		
+
 		/* Check for differential SCSI-bus */
 		esp->diff = 0;
 
 		esp_initialize(esp);
 
-		if (request_irq(esp->irq, esp_intr, SA_INTERRUPT, 
-				"NCR 53C94 SCSI", esp->ehost))
+		if (request_irq(esp->irq, esp_intr, SA_INTERRUPT,
+				"ncr53c94", esp->ehost))
 			goto err_dealloc;
-		if (request_irq(SCSI_DMA_INT, scsi_dma_int, SA_INTERRUPT, 
-				"JUNKIO SCSI DMA", esp->ehost))
+		if (request_irq(dec_interrupt[DEC_IRQ_ASC_MERR],
+				scsi_dma_merr_int, SA_INTERRUPT,
+				"ncr53c94 error", esp->ehost))
 			goto err_free_irq;
- 			
+		if (request_irq(dec_interrupt[DEC_IRQ_ASC_ERR],
+				scsi_dma_err_int, SA_INTERRUPT,
+				"ncr53c94 overrun", esp->ehost))
+			goto err_free_irq_merr;
+		if (request_irq(dec_interrupt[DEC_IRQ_ASC_DMA],
+				scsi_dma_int, SA_INTERRUPT,
+				"ncr53c94 dma", esp->ehost))
+			goto err_free_irq_err;
+
 	}
 
 	if (TURBOCHANNEL) {
@@ -241,7 +228,7 @@
 			mem_start = get_tc_base_addr(slot);
 
 			/* Store base addr into esp struct */
-			esp->slot = mem_start;
+			esp->slot = PHYSADDR(mem_start);
 
 			esp->dregs = 0;
 			esp->eregs = (struct ESP_regs *) (mem_start + DEC_SCSI_SREG);
@@ -251,7 +238,7 @@
 			esp->esp_command = (volatile unsigned char *) pmaz_cmd_buffer;
 
 			/* get virtual dma address for command buffer */
-			esp->esp_command_dvma = (__u32) KSEG0ADDR((volatile unsigned char *) pmaz_cmd_buffer);
+			esp->esp_command_dvma = virt_to_phys(pmaz_cmd_buffer);
 
 			esp->cfreq = get_tc_speed();
 
@@ -286,7 +273,7 @@
 			esp->dma_mmu_release_scsi_sgl = 0;
 			esp->dma_advance_sg = 0;
 
- 			if (request_irq(esp->irq, esp_intr, SA_INTERRUPT, 
+ 			if (request_irq(esp->irq, esp_intr, SA_INTERRUPT,
  					 "PMAZ_AA", esp->ehost)) {
  				esp_deallocate(esp);
  				release_tc_card(slot);
@@ -305,231 +292,259 @@
 	}
 	return 0;
 
- err_free_irq:
+err_free_irq_err:
+	free_irq(dec_interrupt[DEC_IRQ_ASC_ERR], scsi_dma_err_int);
+err_free_irq_merr:
+	free_irq(dec_interrupt[DEC_IRQ_ASC_MERR], scsi_dma_merr_int);
+err_free_irq:
 	free_irq(esp->irq, esp_intr);
- err_dealloc:
+err_dealloc:
 	esp_deallocate(esp);
 	return 0;
 }
 
 /************************************************************* DMA Functions */
-static void scsi_dma_int(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t scsi_dma_merr_int(int irq, void *dev_id, struct pt_regs *regs)
 {
-	extern volatile unsigned int *isr;
-	unsigned int dummy;
+	printk("Got unexpected SCSI DMA Interrupt! < ");
+	printk("SCSI_DMA_MEMRDERR ");
+	printk(">\n");
 
-	if (*isr & SCSI_PTR_LOADED) {
-		/* next page */
-		*scsi_next_ptr = ((*scsi_dma_ptr + PAGE_SIZE) & PAGE_MASK) << 3;
-		*isr &= ~SCSI_PTR_LOADED;
-	} else {
-		if (*isr & SCSI_PAGOVRRUN)
-			*isr &= ~SCSI_PAGOVRRUN;
-		if (*isr & SCSI_DMA_MEMRDERR) {
-			printk("Got unexpected SCSI DMA Interrupt! < ");
-			printk("SCSI_DMA_MEMRDERR ");
-		printk(">\n");
-			*isr &= ~SCSI_DMA_MEMRDERR;
-		}
-	}
+	return IRQ_HANDLED;
+}
 
-	/*
-	 * This routine will only work on IOASIC machines
-	 * so we can avoid an indirect function call here
-	 * and flush the writeback buffer the fast way
-	 */
-	dummy = *isr;
-	dummy = *isr;
+static irqreturn_t scsi_dma_err_int(int irq, void *dev_id, struct pt_regs *regs)
+{
+	/* empty */
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t scsi_dma_int(int irq, void *dev_id, struct pt_regs *regs)
+{
+	u32 scsi_next_ptr;
+
+	scsi_next_ptr = ioasic_read(IO_REG_SCSI_DMA_P);
+
+	/* next page */
+	scsi_next_ptr = (((scsi_next_ptr >> 3) + PAGE_SIZE) & PAGE_MASK) << 3;
+	ioasic_write(IO_REG_SCSI_DMA_BP, scsi_next_ptr);
+	fast_iob();
+
+	return IRQ_HANDLED;
 }
 
 static int dma_bytes_sent(struct NCR_ESP *esp, int fifo_count)
 {
-    return fifo_count;
+	return fifo_count;
 }
 
 static void dma_drain(struct NCR_ESP *esp)
 {
-	unsigned long nw = *scsi_scr;
-	unsigned short *p = (unsigned short *)KSEG1ADDR((*scsi_dma_ptr) >> 3);
+	u32 nw, data0, data1, scsi_data_ptr;
+	u16 *p;
+
+	nw = ioasic_read(IO_REG_SCSI_SCR);
 
-    /*
+	/*
 	 * Is there something in the dma buffers left?
-     */
+	 */
 	if (nw) {
+		scsi_data_ptr = ioasic_read(IO_REG_SCSI_DMA_P) >> 3;
+		p = phys_to_virt(scsi_data_ptr);
 		switch (nw) {
 		case 1:
-			*p = (unsigned short) *scsi_sdr0;
+			data0 = ioasic_read(IO_REG_SCSI_SDR0);
+			p[0] = data0 & 0xffff;
 			break;
 		case 2:
-			*p++ = (unsigned short) (*scsi_sdr0);
-			*p = (unsigned short) ((*scsi_sdr0) >> 16);
+			data0 = ioasic_read(IO_REG_SCSI_SDR0);
+			p[0] = data0 & 0xffff;
+			p[1] = (data0 >> 16) & 0xffff;
 			break;
 		case 3:
-			*p++ = (unsigned short) (*scsi_sdr0);
-			*p++ = (unsigned short) ((*scsi_sdr0) >> 16);
-			*p = (unsigned short) (*scsi_sdr1);
+			data0 = ioasic_read(IO_REG_SCSI_SDR0);
+			data1 = ioasic_read(IO_REG_SCSI_SDR1);
+			p[0] = data0 & 0xffff;
+			p[1] = (data0 >> 16) & 0xffff;
+			p[2] = data1 & 0xffff;
 			break;
 		default:
-			printk("Strange: %d words in dma buffer left\n", (int) nw);
+			printk("Strange: %d words in dma buffer left\n", nw);
 			break;
 		}
 	}
 }
 
-static int dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd * sp)
+static int dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd * sp)
 {
 	return sp->SCp.this_residual;
 }
 
 static void dma_dump_state(struct NCR_ESP *esp)
 {
-/*
-    ESPLOG(("esp%d: dma -- enable <%08x> residue <%08x\n",
-	    esp->esp_id, vdma_get_enable((int)esp->dregs), vdma_get_resdiue((int)esp->dregs)));
- */
 }
 
-static void dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int length)
+static void dma_init_read(struct NCR_ESP *esp, u32 vaddress, int length)
 {
-	extern volatile unsigned int *isr;
-	unsigned int dummy;
+	u32 scsi_next_ptr, ioasic_ssr;
+	unsigned long flags;
 
 	if (vaddress & 3)
-		panic("dec_efs.c: unable to handle partial word transfers, yet...");
+		panic("dec_esp.c: unable to handle partial word transfers, yet...");
 
 	dma_cache_wback_inv((unsigned long) phys_to_virt(vaddress), length);
 
-	*ioasic_ssr &= ~SCSI_DMA_EN;
-	*scsi_scr = 0;
-	*scsi_dma_ptr = vaddress << 3;
+	spin_lock_irqsave(&ioasic_ssr_lock, flags);
+
+	fast_mb();
+	ioasic_ssr = ioasic_read(IO_REG_SSR);
+
+	ioasic_ssr &= ~IO_SSR_SCSI_DMA_EN;
+	ioasic_write(IO_REG_SSR, ioasic_ssr);
+
+	fast_wmb();
+	ioasic_write(IO_REG_SCSI_SCR, 0);
+	ioasic_write(IO_REG_SCSI_DMA_P, vaddress << 3);
 
 	/* prepare for next page */
-	*scsi_next_ptr = ((vaddress + PAGE_SIZE) & PAGE_MASK) << 3;
-	*ioasic_ssr |= (SCSI_DMA_DIR | SCSI_DMA_EN);
+	scsi_next_ptr = ((vaddress + PAGE_SIZE) & PAGE_MASK) << 3;
+	ioasic_write(IO_REG_SCSI_DMA_BP, scsi_next_ptr);
 
-	/*
-	 * see above
-	 */
-	dummy = *isr;
-	dummy = *isr;
+	ioasic_ssr |= (IO_SSR_SCSI_DMA_DIR | IO_SSR_SCSI_DMA_EN);
+	fast_wmb();
+	ioasic_write(IO_REG_SSR, ioasic_ssr);
+
+	fast_iob();
+	spin_unlock_irqrestore(&ioasic_ssr_lock, flags);
 }
 
-static void dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int length)
+static void dma_init_write(struct NCR_ESP *esp, u32 vaddress, int length)
 {
-	extern volatile unsigned int *isr;
-	unsigned int dummy;
+	u32 scsi_next_ptr, ioasic_ssr;
+	unsigned long flags;
 
 	if (vaddress & 3)
-		panic("dec_efs.c: unable to handle partial word transfers, yet...");
+		panic("dec_esp.c: unable to handle partial word transfers, yet...");
 
 	dma_cache_wback_inv((unsigned long) phys_to_virt(vaddress), length);
 
-	*ioasic_ssr &= ~(SCSI_DMA_DIR | SCSI_DMA_EN);
-	*scsi_scr = 0;
-	*scsi_dma_ptr = vaddress << 3;
+	spin_lock_irqsave(&ioasic_ssr_lock, flags);
+
+	fast_mb();
+	ioasic_ssr = ioasic_read(IO_REG_SSR);
+
+	ioasic_ssr &= ~(IO_SSR_SCSI_DMA_DIR | IO_SSR_SCSI_DMA_EN);
+	ioasic_write(IO_REG_SSR, ioasic_ssr);
+
+	fast_wmb();
+	ioasic_write(IO_REG_SCSI_SCR, 0);
+	ioasic_write(IO_REG_SCSI_DMA_P, vaddress << 3);
 
 	/* prepare for next page */
-	*scsi_next_ptr = ((vaddress + PAGE_SIZE) & PAGE_MASK) << 3;
-	*ioasic_ssr |= SCSI_DMA_EN;
+	scsi_next_ptr = ((vaddress + PAGE_SIZE) & PAGE_MASK) << 3;
+	ioasic_write(IO_REG_SCSI_DMA_BP, scsi_next_ptr);
 
-	/*
-	 * see above
-	 */
-	dummy = *isr;
-	dummy = *isr;
+	ioasic_ssr |= IO_SSR_SCSI_DMA_EN;
+	fast_wmb();
+	ioasic_write(IO_REG_SSR, ioasic_ssr);
+
+	fast_iob();
+	spin_unlock_irqrestore(&ioasic_ssr_lock, flags);
 }
 
 static void dma_ints_off(struct NCR_ESP *esp)
 {
-	disable_irq(SCSI_DMA_INT);
+	disable_irq(dec_interrupt[DEC_IRQ_ASC_DMA]);
 }
 
 static void dma_ints_on(struct NCR_ESP *esp)
 {
-	enable_irq(SCSI_DMA_INT);
+	enable_irq(dec_interrupt[DEC_IRQ_ASC_DMA]);
 }
 
 static int dma_irq_p(struct NCR_ESP *esp)
 {
-    return (esp->eregs->esp_status & ESP_STAT_INTR);
+	return (esp->eregs->esp_status & ESP_STAT_INTR);
 }
 
 static int dma_ports_p(struct NCR_ESP *esp)
 {
-/*
- * FIXME: what's this good for?
- */
+	/*
+	 * FIXME: what's this good for?
+	 */
 	return 1;
 }
 
-static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write)
+static void dma_setup(struct NCR_ESP *esp, u32 addr, int count, int write)
 {
-    /*
-     * On the Sparc, DMA_ST_WRITE means "move data from device to memory"
-     * so when (write) is true, it actually means READ!
-     */
-	if (write) {
-	dma_init_read(esp, addr, count);
-    } else {
-	dma_init_write(esp, addr, count);
-    }
+	/*
+	 * DMA_ST_WRITE means "move data from device to memory"
+	 * so when (write) is true, it actually means READ!
+	 */
+	if (write)
+		dma_init_read(esp, addr, count);
+	else
+		dma_init_write(esp, addr, count);
 }
 
-/*
- * These aren't used yet
- */
-static void dma_mmu_get_scsi_one(struct NCR_ESP *esp, Scsi_Cmnd * sp)
+static void dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd * sp)
 {
-	sp->SCp.ptr = (char *)PHYSADDR(sp->SCp.buffer);
+	sp->SCp.ptr = (char *)virt_to_phys(sp->request_buffer);
 }
 
-static void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, Scsi_Cmnd * sp)
+static void dma_mmu_get_scsi_sgl(struct NCR_ESP *esp, struct scsi_cmnd * sp)
 {
-    int sz = sp->SCp.buffers_residual;
-    struct mmu_sglist *sg = (struct mmu_sglist *) sp->SCp.buffer;
+	int sz = sp->SCp.buffers_residual;
+	struct scatterlist *sg = sp->SCp.buffer;
 
-    while (sz >= 0) {
-		sg[sz].dvma_addr = PHYSADDR(sg[sz].addr);
-	sz--;
-    }
-	sp->SCp.ptr = (char *) ((unsigned long) sp->SCp.buffer->dvma_address);
+	while (sz >= 0) {
+		sg[sz].dma_address = page_to_phys(sg[sz].page) + sg[sz].offset;
+		sz--;
+	}
+	sp->SCp.ptr = (char *)(sp->SCp.buffer->dma_address);
 }
 
-static void dma_advance_sg(Scsi_Cmnd * sp)
+static void dma_advance_sg(struct scsi_cmnd * sp)
 {
-	sp->SCp.ptr = (char *) ((unsigned long) sp->SCp.buffer->dvma_address);
+	sp->SCp.ptr = (char *)(sp->SCp.buffer->dma_address);
 }
 
 static void pmaz_dma_drain(struct NCR_ESP *esp)
 {
-	memcpy((void *) (KSEG0ADDR(esp_virt_buffer)),
-		(void *) ( esp->slot + DEC_SCSI_SRAM + ESP_TGT_DMA_SIZE),
+	memcpy(phys_to_virt(esp_virt_buffer),
+		(void *)KSEG1ADDR(esp->slot + DEC_SCSI_SRAM + ESP_TGT_DMA_SIZE),
 		scsi_current_length);
 }
 
-static void pmaz_dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int length)
+static void pmaz_dma_init_read(struct NCR_ESP *esp, u32 vaddress, int length)
 {
-	volatile int *dmareg = (volatile int *) (esp->slot + DEC_SCSI_DMAREG);
+	volatile u32 *dmareg =
+		(volatile u32 *)KSEG1ADDR(esp->slot + DEC_SCSI_DMAREG);
 
 	if (length > ESP_TGT_DMA_SIZE)
 		length = ESP_TGT_DMA_SIZE;
 
-	*dmareg = TC_ESP_DMA_ADDR(esp->slot + DEC_SCSI_SRAM + ESP_TGT_DMA_SIZE);
+	*dmareg = TC_ESP_DMA_ADDR(ESP_TGT_DMA_SIZE);
+
+	iob();
 
 	esp_virt_buffer = vaddress;
 	scsi_current_length = length;
 }
 
-static void pmaz_dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int length)
+static void pmaz_dma_init_write(struct NCR_ESP *esp, u32 vaddress, int length)
 {
-	volatile int *dmareg = (volatile int *) ( esp->slot + DEC_SCSI_DMAREG );
+	volatile u32 *dmareg =
+		(volatile u32 *)KSEG1ADDR(esp->slot + DEC_SCSI_DMAREG);
 
-	memcpy((void *)(esp->slot + DEC_SCSI_SRAM + ESP_TGT_DMA_SIZE),
-	       (void *)KSEG0ADDR(vaddress), length);
+	memcpy((void *)KSEG1ADDR(esp->slot + DEC_SCSI_SRAM + ESP_TGT_DMA_SIZE),
+	       phys_to_virt(vaddress), length);
 
-	*dmareg = TC_ESP_DMAR_WRITE | 
-		TC_ESP_DMA_ADDR(esp->slot + DEC_SCSI_SRAM + ESP_TGT_DMA_SIZE);
+	wmb();
+	*dmareg = TC_ESP_DMAR_WRITE | TC_ESP_DMA_ADDR(ESP_TGT_DMA_SIZE);
 
+	iob();
 }
 
 static void pmaz_dma_ints_off(struct NCR_ESP *esp)
@@ -540,20 +555,19 @@
 {
 }
 
-static void pmaz_dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write)
+static void pmaz_dma_setup(struct NCR_ESP *esp, u32 addr, int count, int write)
 {
 	/*
-	 * On the Sparc, DMA_ST_WRITE means "move data from device to memory"
+	 * DMA_ST_WRITE means "move data from device to memory"
 	 * so when (write) is true, it actually means READ!
 	 */
-	if (write) {
+	if (write)
 		pmaz_dma_init_read(esp, addr, count);
-	} else {
+	else
 		pmaz_dma_init_write(esp, addr, count);
-	}
 }
 
-static void pmaz_dma_mmu_get_scsi_one(struct NCR_ESP *esp, Scsi_Cmnd * sp)
+static void pmaz_dma_mmu_get_scsi_one(struct NCR_ESP *esp, struct scsi_cmnd * sp)
 {
-	sp->SCp.ptr = (char *)KSEG0ADDR((sp->request_buffer));
+	sp->SCp.ptr = (char *)virt_to_phys(sp->request_buffer);
 }
===== drivers/scsi/jazz_esp.c 1.12 vs edited =====
