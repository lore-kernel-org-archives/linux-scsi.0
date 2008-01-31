From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH] SUN3X_ESP: converted to esp_scsi.c
Date: Fri,  1 Feb 2008 00:13:34 +0100 (CET)
Message-ID: <20080131231334.1D492C3288@solo.franken.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:40816 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbYAaXNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 18:13:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

Converted sun3x_esp driver to use esp_scsi.c

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

 drivers/scsi/Kconfig     |    1 +
 drivers/scsi/Makefile    |    2 +-
 drivers/scsi/sun3x_esp.c |  546 ++++++++++++++++++++--------------------------
 3 files changed, 237 insertions(+), 312 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 14fc7f3..fa86f34 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1779,6 +1779,7 @@ config SUN3_SCSI
 config SUN3X_ESP
 	bool "Sun3x ESP SCSI"
 	depends on SUN3X && SCSI=y
+	select SCSI_SPI_ATTRS
 	help
 	  The ESP was an on-board SCSI controller used on Sun 3/80
 	  machines.  Say Y here to compile in support for it.
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 93e1428..999327d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -118,7 +118,7 @@ obj-$(CONFIG_SCSI_3W_9XXX)	+= 3w-9xxx.o
 obj-$(CONFIG_SCSI_PPA)		+= ppa.o
 obj-$(CONFIG_SCSI_IMM)		+= imm.o
 obj-$(CONFIG_JAZZ_ESP)		+= esp_scsi.o	jazz_esp.o
-obj-$(CONFIG_SUN3X_ESP)		+= NCR53C9x.o	sun3x_esp.o
+obj-$(CONFIG_SUN3X_ESP)		+= esp_scsi.o	sun3x_esp.o
 obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
 obj-$(CONFIG_SCSI_SNI_53C710)	+= 53c700.o sni_53c710.o
 obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 1bc4190..06152c7 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -1,392 +1,316 @@
-/* sun3x_esp.c:  EnhancedScsiProcessor Sun3x SCSI driver code.
+/* sun3x_esp.c: ESP front-end for Sun3x systems.
  *
- * (C) 1999 Thomas Bogendoerfer (tsbogend@alpha.franken.de)
- *
- * Based on David S. Miller's esp driver
+ * Copyright (C) 2007,2008 Thomas Bogendoerfer (tsbogend@alpha.franken.de)
  */
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/blkdev.h>
-#include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 
-#include "scsi.h"
-#include <scsi/scsi_host.h>
-#include "NCR53C9x.h"
-
 #include <asm/sun3x.h>
+#include <asm/io.h>
+#include <asm/dma.h>
 #include <asm/dvma.h>
-#include <asm/irq.h>
-
-static void dma_barrier(struct NCR_ESP *esp);
-static int  dma_bytes_sent(struct NCR_ESP *esp, int fifo_count);
-static int  dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_drain(struct NCR_ESP *esp);
-static void dma_invalidate(struct NCR_ESP *esp);
-static void dma_dump_state(struct NCR_ESP *esp);
-static void dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int length);
-static void dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int length);
-static void dma_ints_off(struct NCR_ESP *esp);
-static void dma_ints_on(struct NCR_ESP *esp);
-static int  dma_irq_p(struct NCR_ESP *esp);
-static void dma_poll(struct NCR_ESP *esp, unsigned char *vaddr);
-static int  dma_ports_p(struct NCR_ESP *esp);
-static void dma_reset(struct NCR_ESP *esp);
-static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write);
-static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp);
-static void dma_advance_sg (Scsi_Cmnd *sp);
-
-/* Detecting ESP chips on the machine.  This is the simple and easy
- * version.
- */
-int sun3x_esp_detect(struct scsi_host_template *tpnt)
-{
-	struct NCR_ESP *esp;
-	struct ConfigDev *esp_dev;
-
-	esp_dev = 0;
-	esp = esp_allocate(tpnt, esp_dev, 0);
-
-	/* Do command transfer with DMA */
-	esp->do_pio_cmds = 0;
-
-	/* Required functions */
-	esp->dma_bytes_sent = &dma_bytes_sent;
-	esp->dma_can_transfer = &dma_can_transfer;
-	esp->dma_dump_state = &dma_dump_state;
-	esp->dma_init_read = &dma_init_read;
-	esp->dma_init_write = &dma_init_write;
-	esp->dma_ints_off = &dma_ints_off;
-	esp->dma_ints_on = &dma_ints_on;
-	esp->dma_irq_p = &dma_irq_p;
-	esp->dma_ports_p = &dma_ports_p;
-	esp->dma_setup = &dma_setup;
-
-	/* Optional functions */
-	esp->dma_barrier = &dma_barrier;
-	esp->dma_invalidate = &dma_invalidate;
-	esp->dma_drain = &dma_drain;
-	esp->dma_irq_entry = 0;
-	esp->dma_irq_exit = 0;
-	esp->dma_led_on = 0;
-	esp->dma_led_off = 0;
-	esp->dma_poll = &dma_poll;
-	esp->dma_reset = &dma_reset;
-
-        /* virtual DMA functions */
-        esp->dma_mmu_get_scsi_one = &dma_mmu_get_scsi_one;
-        esp->dma_mmu_get_scsi_sgl = &dma_mmu_get_scsi_sgl;
-        esp->dma_mmu_release_scsi_one = &dma_mmu_release_scsi_one;
-        esp->dma_mmu_release_scsi_sgl = &dma_mmu_release_scsi_sgl;
-        esp->dma_advance_sg = &dma_advance_sg;
-	    
-	/* SCSI chip speed */
-	esp->cfreq = 20000000;
-	esp->eregs = (struct ESP_regs *)(SUN3X_ESP_BASE);
-	esp->dregs = (void *)SUN3X_ESP_DMA;
 
-	esp->esp_command = (volatile unsigned char *)dvma_malloc(DVMA_PAGE_SIZE);
-	esp->esp_command_dvma = dvma_vtob((unsigned long)esp->esp_command);
-
-	esp->irq = 2;
-	if (request_irq(esp->irq, esp_intr, IRQF_DISABLED,
-			"SUN3X SCSI", esp->ehost)) {
-		esp_deallocate(esp);
-		return 0;
-	}
+/* DMA controller reg offsets */
+#define DMA_CSR		0x00UL	/* rw  DMA control/status register    0x00   */
+#define DMA_ADDR        0x04UL	/* rw  DMA transfer address register  0x04   */
+#define DMA_COUNT       0x08UL	/* rw  DMA transfer count register    0x08   */
+#define DMA_TEST        0x0cUL	/* rw  DMA test/debug register        0x0c   */
 
-	esp->scsi_id = 7;
-	esp->diff = 0;
+#include <scsi/scsi_host.h>
 
-	esp_initialize(esp);
+#include "esp_scsi.h"
 
- 	/* for reasons beyond my knowledge (and which should likely be fixed)
- 	   sync mode doesn't work on a 3/80 at 5mhz.  but it does at 4. */
- 	esp->sync_defp = 0x3f;
+#define DRV_MODULE_NAME		"sun3x_esp"
+#define PFX DRV_MODULE_NAME	": "
+#define DRV_VERSION		"1.000"
+#define DRV_MODULE_RELDATE	"Nov 1, 2007"
 
-	printk("ESP: Total of %d ESP hosts found, %d actually in use.\n", nesps,
-	       esps_in_use);
-	esps_running = esps_in_use;
-	return esps_in_use;
+/*
+ * m68k always assumes readl/writel operate on little endian
+ * mmio space; this is wrong at least for Sun3x, so we
+ * need to workaround this until a proper way is found
+ */
+#if 0
+#define dma_read32(REG) \
+	readl(esp->dma_regs + (REG))
+#define dma_write32(VAL, REG) \
+	writel((VAL), esp->dma_regs + (REG))
+#else
+#define dma_read32(REG) \
+	*(volatile u32 *)(esp->dma_regs + (REG))
+#define dma_write32(VAL, REG) \
+	do { *(volatile u32 *)(esp->dma_regs + (REG)) = (VAL); } while (0)
+#endif
+
+static void sun3x_esp_write8(struct esp *esp, u8 val, unsigned long reg)
+{
+	writeb(val, esp->regs + (reg * 4UL));
 }
 
-static void dma_do_drain(struct NCR_ESP *esp)
+static u8 sun3x_esp_read8(struct esp *esp, unsigned long reg)
 {
- 	struct sparc_dma_registers *dregs =
- 		(struct sparc_dma_registers *) esp->dregs;
- 	
- 	int count = 500000;
- 
- 	while((dregs->cond_reg & DMA_PEND_READ) && (--count > 0)) 
- 		udelay(1);
- 
- 	if(!count) {
- 		printk("%s:%d timeout CSR %08lx\n", __FILE__, __LINE__, dregs->cond_reg);
- 	}
- 
- 	dregs->cond_reg |= DMA_FIFO_STDRAIN;
- 	
- 	count = 500000;
- 
- 	while((dregs->cond_reg & DMA_FIFO_ISDRAIN) && (--count > 0)) 
- 		udelay(1);
- 
- 	if(!count) {
- 		printk("%s:%d timeout CSR %08lx\n", __FILE__, __LINE__, dregs->cond_reg);
- 	}
- 
+	return readb(esp->regs + (reg * 4UL));
 }
- 
-static void dma_barrier(struct NCR_ESP *esp)
+
+static dma_addr_t sun3x_esp_map_single(struct esp *esp, void *buf,
+				      size_t sz, int dir)
 {
-  	struct sparc_dma_registers *dregs =
-  		(struct sparc_dma_registers *) esp->dregs;
- 	int count = 500000;
-  
- 	while((dregs->cond_reg & DMA_PEND_READ) && (--count > 0))
-  		udelay(1);
- 
- 	if(!count) {
- 		printk("%s:%d timeout CSR %08lx\n", __FILE__, __LINE__, dregs->cond_reg);
- 	}
- 
-  	dregs->cond_reg &= ~(DMA_ENABLE);
+	return dma_map_single(esp->dev, buf, sz, dir);
 }
 
-/* This uses various DMA csr fields and the fifo flags count value to
- * determine how many bytes were successfully sent/received by the ESP.
- */
-static int dma_bytes_sent(struct NCR_ESP *esp, int fifo_count)
+static int sun3x_esp_map_sg(struct esp *esp, struct scatterlist *sg,
+				  int num_sg, int dir)
 {
-	struct sparc_dma_registers *dregs = 
-		(struct sparc_dma_registers *) esp->dregs;
-
-	int rval = dregs->st_addr - esp->esp_command_dvma;
-
-	return rval - fifo_count;
+	return dma_map_sg(esp->dev, sg, num_sg, dir);
 }
 
-static int dma_can_transfer(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void sun3x_esp_unmap_single(struct esp *esp, dma_addr_t addr,
+				  size_t sz, int dir)
 {
-	return sp->SCp.this_residual;
+	dma_unmap_single(esp->dev, addr, sz, dir);
 }
 
-static void dma_drain(struct NCR_ESP *esp)
+static void sun3x_esp_unmap_sg(struct esp *esp, struct scatterlist *sg,
+			      int num_sg, int dir)
 {
-	struct sparc_dma_registers *dregs =
-		(struct sparc_dma_registers *) esp->dregs;
-	int count = 500000;
-
-	if(dregs->cond_reg & DMA_FIFO_ISDRAIN) {
-		dregs->cond_reg |= DMA_FIFO_STDRAIN;
-		while((dregs->cond_reg & DMA_FIFO_ISDRAIN) && (--count > 0))
-			udelay(1);
-		if(!count) {
-			printk("%s:%d timeout CSR %08lx\n", __FILE__, __LINE__, dregs->cond_reg);
-		}
-
-	}
+	dma_unmap_sg(esp->dev, sg, num_sg, dir);
 }
 
-static void dma_invalidate(struct NCR_ESP *esp)
+static int sun3x_esp_irq_pending(struct esp *esp)
 {
-	struct sparc_dma_registers *dregs =
-		(struct sparc_dma_registers *) esp->dregs;
-
-	__u32 tmp;
-	int count = 500000;
-
-	while(((tmp = dregs->cond_reg) & DMA_PEND_READ) && (--count > 0)) 
-		udelay(1);
+	if (dma_read32(DMA_CSR) & (DMA_HNDL_INTR | DMA_HNDL_ERROR))
+		return 1;
+	return 0;
+}
 
-	if(!count) {
-		printk("%s:%d timeout CSR %08lx\n", __FILE__, __LINE__, dregs->cond_reg);
-	}
+static void sun3x_esp_reset_dma(struct esp *esp)
+{
+	u32 val;
 
-	dregs->cond_reg = tmp | DMA_FIFO_INV;
-	dregs->cond_reg &= ~DMA_FIFO_INV;
+	val = dma_read32(DMA_CSR);
+	dma_write32(val | DMA_RST_SCSI, DMA_CSR);
+	dma_write32(val & ~DMA_RST_SCSI, DMA_CSR);
 
+	/* Enable interrupts.  */
+	val = dma_read32(DMA_CSR);
+	dma_write32(val | DMA_INT_ENAB, DMA_CSR);
 }
 
-static void dma_dump_state(struct NCR_ESP *esp)
+static void sun3x_esp_dma_drain(struct esp *esp)
 {
-	struct sparc_dma_registers *dregs =
-		(struct sparc_dma_registers *) esp->dregs;
+	u32 csr;
+	int lim;
 
-	ESPLOG(("esp%d: dma -- cond_reg<%08lx> addr<%08lx>\n",
-		esp->esp_id, dregs->cond_reg, dregs->st_addr));
-}
+	csr = dma_read32(DMA_CSR);
+	if (!(csr & DMA_FIFO_ISDRAIN))
+		return;
 
-static void dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int length)
-{
-	struct sparc_dma_registers *dregs = 
-		(struct sparc_dma_registers *) esp->dregs;
+	dma_write32(csr | DMA_FIFO_STDRAIN, DMA_CSR);
 
-	dregs->st_addr = vaddress;
-	dregs->cond_reg |= (DMA_ST_WRITE | DMA_ENABLE);
+	lim = 1000;
+	while (dma_read32(DMA_CSR) & DMA_FIFO_ISDRAIN) {
+		if (--lim == 0) {
+			printk(KERN_ALERT PFX "esp%d: DMA will not drain!\n",
+			       esp->host->unique_id);
+			break;
+		}
+		udelay(1);
+	}
 }
 
-static void dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int length)
+static void sun3x_esp_dma_invalidate(struct esp *esp)
 {
-	struct sparc_dma_registers *dregs = 
-		(struct sparc_dma_registers *) esp->dregs;
-
-	/* Set up the DMA counters */
+	u32 val;
+	int lim;
+
+	lim = 1000;
+	while ((val = dma_read32(DMA_CSR)) & DMA_PEND_READ) {
+		if (--lim == 0) {
+			printk(KERN_ALERT PFX "esp%d: DMA will not "
+			       "invalidate!\n", esp->host->unique_id);
+			break;
+		}
+		udelay(1);
+	}
 
-	dregs->st_addr = vaddress;
-	dregs->cond_reg = ((dregs->cond_reg & ~(DMA_ST_WRITE)) | DMA_ENABLE);
+	val &= ~(DMA_ENABLE | DMA_ST_WRITE | DMA_BCNT_ENAB);
+	val |= DMA_FIFO_INV;
+	dma_write32(val, DMA_CSR);
+	val &= ~DMA_FIFO_INV;
+	dma_write32(val, DMA_CSR);
 }
 
-static void dma_ints_off(struct NCR_ESP *esp)
+static void sun3x_esp_send_dma_cmd(struct esp *esp, u32 addr, u32 esp_count,
+				  u32 dma_count, int write, u8 cmd)
 {
-	DMA_INTSOFF((struct sparc_dma_registers *) esp->dregs);
+	u32 csr;
+
+	BUG_ON(!(cmd & ESP_CMD_DMA));
+
+	sun3x_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
+	sun3x_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
+	csr = dma_read32(DMA_CSR);
+	csr |= DMA_ENABLE;
+	if (write)
+		csr |= DMA_ST_WRITE;
+	else
+		csr &= ~DMA_ST_WRITE;
+	dma_write32(csr, DMA_CSR);
+	dma_write32(addr, DMA_ADDR);
+
+	scsi_esp_cmd(esp, cmd);
 }
 
-static void dma_ints_on(struct NCR_ESP *esp)
+static int sun3x_esp_dma_error(struct esp *esp)
 {
-	DMA_INTSON((struct sparc_dma_registers *) esp->dregs);
-}
+	u32 csr = dma_read32(DMA_CSR);
 
-static int dma_irq_p(struct NCR_ESP *esp)
-{
-	return DMA_IRQ_P((struct sparc_dma_registers *) esp->dregs);
+	if (csr & DMA_HNDL_ERROR)
+		return 1;
+
+	return 0;
 }
 
-static void dma_poll(struct NCR_ESP *esp, unsigned char *vaddr)
+static const struct esp_driver_ops sun3x_esp_ops = {
+	.esp_write8	=	sun3x_esp_write8,
+	.esp_read8	=	sun3x_esp_read8,
+	.map_single	=	sun3x_esp_map_single,
+	.map_sg		=	sun3x_esp_map_sg,
+	.unmap_single	=	sun3x_esp_unmap_single,
+	.unmap_sg	=	sun3x_esp_unmap_sg,
+	.irq_pending	=	sun3x_esp_irq_pending,
+	.reset_dma	=	sun3x_esp_reset_dma,
+	.dma_drain	=	sun3x_esp_dma_drain,
+	.dma_invalidate	=	sun3x_esp_dma_invalidate,
+	.send_dma_cmd	=	sun3x_esp_send_dma_cmd,
+	.dma_error	=	sun3x_esp_dma_error,
+};
+
+static int __devinit esp_sun3x_probe(struct platform_device *dev)
 {
-	int count = 50;
-	dma_do_drain(esp);
+	struct scsi_host_template *tpnt = &scsi_esp_template;
+	struct Scsi_Host *host;
+	struct esp *esp;
+	struct resource *res;
+	int err = -ENOMEM;
 
-	/* Wait till the first bits settle. */
-	while((*(volatile unsigned char *)vaddr == 0xff) && (--count > 0))
-		udelay(1);
+	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	if (!host)
+		goto fail;
 
-	if(!count) {
-//		printk("%s:%d timeout expire (data %02x)\n", __FILE__, __LINE__,
-//		       esp_read(esp->eregs->esp_fdata));
-		//mach_halt();
-		vaddr[0] = esp_read(esp->eregs->esp_fdata);
-		vaddr[1] = esp_read(esp->eregs->esp_fdata);
-	}
+	host->max_id = 8;
+	esp = shost_priv(host);
 
-}	
+	esp->host = host;
+	esp->dev = dev;
+	esp->ops = &sun3x_esp_ops;
 
-static int dma_ports_p(struct NCR_ESP *esp)
-{
-	return (((struct sparc_dma_registers *) esp->dregs)->cond_reg 
-			& DMA_INT_ENAB);
-}
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res && !res->start)
+		goto fail_unlink;
 
-/* Resetting various pieces of the ESP scsi driver chipset/buses. */
-static void dma_reset(struct NCR_ESP *esp)
-{
-	struct sparc_dma_registers *dregs =
-		(struct sparc_dma_registers *)esp->dregs;
+	esp->regs = ioremap_nocache(res->start, 0x20);
+	if (!esp->regs)
+		goto fail_unmap_regs;
 
-	/* Punt the DVMA into a known state. */
-	dregs->cond_reg |= DMA_RST_SCSI;
-	dregs->cond_reg &= ~(DMA_RST_SCSI);
-	DMA_INTSON(dregs);
-}
+	res = platform_get_resource(dev, IORESOURCE_MEM, 1);
+	if (!res && !res->start)
+		goto fail_unmap_regs;
 
-static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int write)
-{
-	struct sparc_dma_registers *dregs = 
-		(struct sparc_dma_registers *) esp->dregs;
-	unsigned long nreg = dregs->cond_reg;
+	esp->dma_regs = ioremap_nocache(res->start, 0x10);
 
-//	printk("dma_setup %c addr %08x cnt %08x\n",
-//	       write ? 'W' : 'R', addr, count);
+	esp->command_block = dma_alloc_coherent(esp->dev, 16,
+						&esp->command_block_dma,
+						GFP_KERNEL);
+	if (!esp->command_block)
+		goto fail_unmap_regs_dma;
 
-	dma_do_drain(esp);
+	host->irq = platform_get_irq(dev, 0);
+	err = request_irq(host->irq, scsi_esp_intr, IRQF_SHARED,
+			  "SUN3X ESP", esp);
+	if (err < 0)
+		goto fail_unmap_command_block;
 
-	if(write)
-		nreg |= DMA_ST_WRITE;
-	else {
-		nreg &= ~(DMA_ST_WRITE);
-	}
-		
-	nreg |= DMA_ENABLE;
-	dregs->cond_reg = nreg;
-	dregs->st_addr = addr;
-}
+	esp->scsi_id = 7;
+	esp->host->this_id = esp->scsi_id;
+	esp->scsi_id_mask = (1 << esp->scsi_id);
+	esp->cfreq = 20000000;
 
-static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp)
-{
-    sp->SCp.have_data_in = dvma_map((unsigned long)sp->SCp.buffer,
-				       sp->SCp.this_residual);
-    sp->SCp.ptr = (char *)((unsigned long)sp->SCp.have_data_in);
+	dev_set_drvdata(&dev->dev, esp);
+
+	err = scsi_esp_register(esp, &dev->dev);
+	if (err)
+		goto fail_free_irq;
+
+	return 0;
+
+fail_free_irq:
+	free_irq(host->irq, esp);
+fail_unmap_command_block:
+	dma_free_coherent(esp->dev, 16,
+			  esp->command_block,
+			  esp->command_block_dma);
+fail_unmap_regs_dma:
+	iounmap(esp->dma_regs);
+fail_unmap_regs:
+	iounmap(esp->regs);
+fail_unlink:
+	scsi_host_put(host);
+fail:
+	return err;
 }
 
-static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static int __devexit esp_sun3x_remove(struct platform_device *dev)
 {
-    int sz = sp->SCp.buffers_residual;
-    struct scatterlist *sg = sp->SCp.buffer;
-
-    while (sz >= 0) {
-	    sg[sz].dma_address = dvma_map((unsigned long)sg_virt(&sg[sz]),
-					  sg[sz].length);
-	    sz--;
-    }
-    sp->SCp.ptr=(char *)((unsigned long)sp->SCp.buffer->dma_address);
-}
+	struct esp *esp = dev_get_drvdata(&dev->dev);
+	unsigned int irq = esp->host->irq;
+	u32 val;
 
-static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, Scsi_Cmnd *sp)
-{
-    dvma_unmap((char *)sp->SCp.have_data_in);
-}
+	scsi_esp_unregister(esp);
 
-static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, Scsi_Cmnd *sp)
-{
-    int sz = sp->use_sg - 1;
-    struct scatterlist *sg = (struct scatterlist *)sp->request_buffer;
-                        
-    while(sz >= 0) {
-        dvma_unmap((char *)sg[sz].dma_address);
-        sz--;
-    }
-}
+	/* Disable interrupts.  */
+	val = dma_read32(DMA_CSR);
+	dma_write32(val & ~DMA_INT_ENAB, DMA_CSR);
 
-static void dma_advance_sg (Scsi_Cmnd *sp)
-{
-    sp->SCp.ptr = (char *)((unsigned long)sp->SCp.buffer->dma_address);
-}
+	free_irq(irq, esp);
+	dma_free_coherent(esp->dev, 16,
+			  esp->command_block,
+			  esp->command_block_dma);
 
-static int sun3x_esp_release(struct Scsi_Host *instance)
-{
-	/* this code does not support being compiled as a module */	 
-	return 1;
+	scsi_host_put(esp->host);
 
+	return 0;
 }
 
-static struct scsi_host_template driver_template = {
-	.proc_name		= "sun3x_esp",
-	.proc_info		= &esp_proc_info,
-	.name			= "Sun ESP 100/100a/200",
-	.detect			= sun3x_esp_detect,
-	.release                = sun3x_esp_release,
-	.slave_alloc		= esp_slave_alloc,
-	.slave_destroy		= esp_slave_destroy,
-	.info			= esp_info,
-	.queuecommand		= esp_queue,
-	.eh_abort_handler	= esp_abort,
-	.eh_bus_reset_handler	= esp_reset,
-	.can_queue		= 7,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
-	.use_clustering		= DISABLE_CLUSTERING,
+static struct platform_driver esp_sun3x_driver = {
+	.probe          = esp_sun3x_probe,
+	.remove         = __devexit_p(esp_sun3x_remove),
+	.driver = {
+		.name   = "sun3x_esp",
+	},
 };
 
+static int __init sun3x_esp_init(void)
+{
+	return platform_driver_register(&esp_sun3x_driver);
+}
 
-#include "scsi_module.c"
+static void __exit sun3x_esp_exit(void)
+{
+	platform_driver_unregister(&esp_sun3x_driver);
+}
 
+MODULE_DESCRIPTION("Sun3x ESP SCSI driver");
+MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(sun3x_esp_init);
+module_exit(sun3x_esp_exit);
