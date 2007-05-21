From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: [PATCH] jazz_esp converted to use esp_core
Date: Mon, 21 May 2007 23:02:24 +0200
Message-ID: <20070521210224.GA24573@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:46579 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbXEUWZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2007 18:25:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, davem@davemloft.net

Hi,

after chasing and fixing two jazz platform bugs and one MIPS dma mappin=
g
bug, I finally succeeded in using the Dave's new esp_core (great work,
thank you Dave). Below is the patch.

Thomas.

Use new SCCI_ESP_CORE for JAZZ SCSS host adapter driver

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d28c14e..62d62ab 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1532,6 +1532,7 @@ source "drivers/scsi/arm/Kconfig"
 config JAZZ_ESP
 	bool "MIPS JAZZ FAS216 SCSI support"
 	depends on MACH_JAZZ && SCSI
+	select SCSI_ESP_CORE
 	help
 	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
 	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 51e884f..b348600 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -121,7 +121,7 @@ obj-$(CONFIG_BLK_DEV_3W_XXXX_RAID) +=3D 3w-xxxx.o
 obj-$(CONFIG_SCSI_3W_9XXX)	+=3D 3w-9xxx.o
 obj-$(CONFIG_SCSI_PPA)		+=3D ppa.o
 obj-$(CONFIG_SCSI_IMM)		+=3D imm.o
-obj-$(CONFIG_JAZZ_ESP)		+=3D NCR53C9x.o	jazz_esp.o
+obj-$(CONFIG_JAZZ_ESP)		+=3D jazz_esp.o
 obj-$(CONFIG_SUN3X_ESP)		+=3D NCR53C9x.o	sun3x_esp.o
 obj-$(CONFIG_SCSI_FCAL)		+=3D fcal.o
 obj-$(CONFIG_SCSI_LASI700)	+=3D 53c700.o lasi700.o
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 19dd4b9..18f7d4e 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -1,307 +1,277 @@
-/*
- * jazz_esp.c: Driver for SCSI chip on Mips Magnum Boards (JAZZ archit=
ecture)
+/* jazz_esp.c: ESP front-end for MIPS JAZZ systems.
  *
- * Copyright (C) 1997 Thomas Bogendoerfer (tsbogend@alpha.franken.de)
- *
- * jazz_esp is based on David S. Miller's ESP driver and cyber_esp
+ * Copyright (C) 2007 Thomas Bogend=F6rfer (tsbogend@alpha.frankende)
  */
=20
-#include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
 #include <linux/types.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/blkdev.h>
-#include <linux/proc_fs.h>
-#include <linux/stat.h>
-
-#include "scsi.h"
-#include <scsi/scsi_host.h>
-#include "NCR53C9x.h"
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
=20
 #include <asm/irq.h>
+#include <asm/io.h>
+#include <asm/dma.h>
+
 #include <asm/jazz.h>
 #include <asm/jazzdma.h>
-#include <asm/dma.h>
=20
-#include <asm/pgtable.h>
-
-static int  dma_bytes_sent(struct NCR_ESP *esp, int fifo_count);
-static int  dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp=
);
-static void dma_dump_state(struct NCR_ESP *esp);
-static void dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int len=
gth);
-static void dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int le=
ngth);
-static void dma_ints_off(struct NCR_ESP *esp);
-static void dma_ints_on(struct NCR_ESP *esp);
-static int  dma_irq_p(struct NCR_ESP *esp);
-static int  dma_ports_p(struct NCR_ESP *esp);
-static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int =
write);
-static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, struct scsi_cmn=
d *sp);
-static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, struct scsi_cmn=
d *sp);
-static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, struct scsi=
_cmnd *sp);
-static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, struct scsi=
_cmnd *sp);
-static void dma_advance_sg (struct scsi_cmnd *sp);
-static void dma_led_off(struct NCR_ESP *);
-static void dma_led_on(struct NCR_ESP *);
-
-
-static volatile unsigned char cmd_buffer[16];
-				/* This is where all commands are put
-				 * before they are trasfered to the ESP chip
-				 * via PIO.
-				 */
-
-static int jazz_esp_release(struct Scsi_Host *shost)
-{
-	if (shost->irq)
-		free_irq(shost->irq, NULL);
-	if (shost->dma_channel !=3D 0xff)
-		free_dma(shost->dma_channel);
-	if (shost->io_port && shost->n_io_port)
-		release_region(shost->io_port, shost->n_io_port);
-	scsi_unregister(shost);
-	return 0;
-}
+#include <scsi/scsi_host.h>
=20
-/***************************************************************** Det=
ection */
-static int jazz_esp_detect(struct scsi_host_template *tpnt)
-{
-    struct NCR_ESP *esp;
-    struct ConfigDev *esp_dev;
-
-    /*
-     * first assumption it is there:-)
-     */
-    if (1) {
-	esp_dev =3D NULL;
-	esp =3D esp_allocate(tpnt, esp_dev, 0);
-=09
-	/* Do command transfer with programmed I/O */
-	esp->do_pio_cmds =3D 1;
-=09
-	/* Required functions */
-	esp->dma_bytes_sent =3D &dma_bytes_sent;
-	esp->dma_can_transfer =3D &dma_can_transfer;
-	esp->dma_dump_state =3D &dma_dump_state;
-	esp->dma_init_read =3D &dma_init_read;
-	esp->dma_init_write =3D &dma_init_write;
-	esp->dma_ints_off =3D &dma_ints_off;
-	esp->dma_ints_on =3D &dma_ints_on;
-	esp->dma_irq_p =3D &dma_irq_p;
-	esp->dma_ports_p =3D &dma_ports_p;
-	esp->dma_setup =3D &dma_setup;
-
-	/* Optional functions */
-	esp->dma_barrier =3D NULL;
-	esp->dma_drain =3D NULL;
-	esp->dma_invalidate =3D NULL;
-	esp->dma_irq_entry =3D NULL;
-	esp->dma_irq_exit =3D NULL;
-	esp->dma_poll =3D NULL;
-	esp->dma_reset =3D NULL;
-	esp->dma_led_off =3D &dma_led_off;
-	esp->dma_led_on =3D &dma_led_on;
-=09
-	/* virtual DMA functions */
-	esp->dma_mmu_get_scsi_one =3D &dma_mmu_get_scsi_one;
-	esp->dma_mmu_get_scsi_sgl =3D &dma_mmu_get_scsi_sgl;
-	esp->dma_mmu_release_scsi_one =3D &dma_mmu_release_scsi_one;
-	esp->dma_mmu_release_scsi_sgl =3D &dma_mmu_release_scsi_sgl;
-	esp->dma_advance_sg =3D &dma_advance_sg;
+#include "esp_scsi.h"
=20
+#define DRV_MODULE_NAME		"jazz_esp"
+#define PFX DRV_MODULE_NAME	": "
+#define DRV_VERSION		"1.000"
+#define DRV_MODULE_RELDATE	"May 19, 2007"
=20
-	/* SCSI chip speed */
-	esp->cfreq =3D 40000000;
+static int __devinit esp_jazz_map_regs(struct esp *esp)
+{
+	struct platform_device *pdev =3D esp->dev;
+	struct resource *res;
=20
-	/*=20
-	 * we don't give the address of DMA channel, but the number
-	 * of DMA channel, so we can use the jazz DMA functions
-	 *=20
-	 */
-	esp->dregs =3D (void *) JAZZ_SCSI_DMA;
+	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
 =09
-	/* ESP register base */
-	esp->eregs =3D (struct ESP_regs *)(JAZZ_SCSI_BASE);
+	esp->regs =3D (void __iomem *)res->start;
+	if (!esp->regs)
+		return -ENOMEM;
 =09
-	/* Set the command buffer */
-	esp->esp_command =3D (volatile unsigned char *)cmd_buffer;
+	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res)
+		return -ENODEV;
 =09
-	/* get virtual dma address for command buffer */
-	esp->esp_command_dvma =3D vdma_alloc(CPHYSADDR(cmd_buffer), sizeof (c=
md_buffer));
-=09
-	esp->irq =3D JAZZ_SCSI_IRQ;
-	request_irq(JAZZ_SCSI_IRQ, esp_intr, IRQF_DISABLED, "JAZZ SCSI",
-	            esp->ehost);
-
-	/*
-	 * FIXME, look if the scsi id is available from NVRAM
-	 */
-	esp->scsi_id =3D 7;
-	=09
-	/* Check for differential SCSI-bus */
-	/* What is this stuff? */
-	esp->diff =3D 0;
+	esp->dma_regs =3D (void __iomem *)res->start;
=20
-	esp_initialize(esp);
-=09
-	printk("ESP: Total of %d ESP hosts found, %d actually in use.\n", nes=
ps,esps_in_use);
-	esps_running =3D esps_in_use;
-	return esps_in_use;
-    }
-    return 0;
+	return 0;
 }
=20
-/************************************************************* DMA Fun=
ctions */
-static int dma_bytes_sent(struct NCR_ESP *esp, int fifo_count)
+static int __devinit esp_jazz_map_command_block(struct esp *esp)
 {
-    return fifo_count;
+	esp->command_block =3D dma_alloc_coherent(esp->dev, 16,
+						&esp->command_block_dma,
+						GFP_KERNEL);
+	if (!esp->command_block)
+		return -ENOMEM;
+	return 0;
 }
=20
-static int dma_can_transfer(struct NCR_ESP *esp, struct scsi_cmnd *sp)
+static int __devinit esp_jazz_register_irq(struct esp *esp)
 {
-    /*
-     * maximum DMA size is 1MB
-     */
-    unsigned long sz =3D sp->SCp.this_residual;
-    if(sz > 0x100000)
-	sz =3D 0x100000;
-    return sz;
+	struct Scsi_Host *host =3D esp->host;
+	struct platform_device *pdev =3D esp->dev;
+
+	host->irq =3D platform_get_irq(pdev, 0);
+	return request_irq(host->irq, scsi_esp_intr, IRQF_SHARED, "ESP", esp)=
;
 }
=20
-static void dma_dump_state(struct NCR_ESP *esp)
+static void __devinit esp_jazz_get_props(struct esp *esp)
 {
-   =20
-    ESPLOG(("esp%d: dma -- enable <%08x> residue <%08x\n",
-	    esp->esp_id, vdma_get_enable((int)esp->dregs), vdma_get_residue((=
int)esp->dregs)));
+	esp->scsi_id =3D 7;
+	esp->host->this_id =3D esp->scsi_id;
+	esp->scsi_id_mask =3D (1 << esp->scsi_id);
+	esp->cfreq =3D 40000000;
 }
=20
-static void dma_init_read(struct NCR_ESP *esp, __u32 vaddress, int len=
gth)
+static void jazz_esp_write8(struct esp *esp, u8 val, unsigned long reg=
)
 {
-    dma_cache_wback_inv ((unsigned long)phys_to_virt(vdma_log2phys(vad=
dress)), length);
-    vdma_disable ((int)esp->dregs);
-    vdma_set_mode ((int)esp->dregs, DMA_MODE_READ);
-    vdma_set_addr ((int)esp->dregs, vaddress);
-    vdma_set_count ((int)esp->dregs, length);
-    vdma_enable ((int)esp->dregs);
+	*(volatile u8 *)(esp->regs + reg) =3D val;
 }
=20
-static void dma_init_write(struct NCR_ESP *esp, __u32 vaddress, int le=
ngth)
+static u8 jazz_esp_read8(struct esp *esp, unsigned long reg)
 {
-    dma_cache_wback_inv ((unsigned long)phys_to_virt(vdma_log2phys(vad=
dress)), length);   =20
-    vdma_disable ((int)esp->dregs);   =20
-    vdma_set_mode ((int)esp->dregs, DMA_MODE_WRITE);
-    vdma_set_addr ((int)esp->dregs, vaddress);
-    vdma_set_count ((int)esp->dregs, length);
-    vdma_enable ((int)esp->dregs);   =20
+	return *(volatile u8 *)(esp->regs + reg);
 }
=20
-static void dma_ints_off(struct NCR_ESP *esp)
+static dma_addr_t jazz_esp_map_single(struct esp *esp, void *buf,
+				      size_t sz, int dir)
 {
-    disable_irq(esp->irq);
+	return dma_map_single(esp->dev, buf, sz, dir);
 }
=20
-static void dma_ints_on(struct NCR_ESP *esp)
+static int jazz_esp_map_sg(struct esp *esp, struct scatterlist *sg,
+				  int num_sg, int dir)
 {
-    enable_irq(esp->irq);
+	return dma_map_sg(esp->dev, sg, num_sg, dir);
 }
=20
-static int dma_irq_p(struct NCR_ESP *esp)
+static void jazz_esp_unmap_single(struct esp *esp, dma_addr_t addr,
+				  size_t sz, int dir)
 {
-    return (esp_read(esp->eregs->esp_status) & ESP_STAT_INTR);
+	dma_unmap_single(esp->dev, addr, sz, dir);
 }
=20
-static int dma_ports_p(struct NCR_ESP *esp)
+static void jazz_esp_unmap_sg(struct esp *esp, struct scatterlist *sg,
+			      int num_sg, int dir)
 {
-    int enable =3D vdma_get_enable((int)esp->dregs);
-   =20
-    return (enable & R4030_CHNL_ENABLE);
+	dma_unmap_sg(esp->dev, sg, num_sg, dir);
 }
=20
-static void dma_setup(struct NCR_ESP *esp, __u32 addr, int count, int =
write)
+static int jazz_esp_irq_pending(struct esp *esp)
 {
-    /*=20
-     * On the Sparc, DMA_ST_WRITE means "move data from device to memo=
ry"
-     * so when (write) is true, it actually means READ!
-     */
-    if(write){
-	dma_init_read(esp, addr, count);
-    } else {
-	dma_init_write(esp, addr, count);
-    }
+	if (jazz_esp_read8(esp, ESP_STATUS) & ESP_STAT_INTR)
+		return 1;
+	return 0;
 }
=20
-static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, struct scsi_cmn=
d *sp)
+static void jazz_esp_reset_dma(struct esp *esp)
 {
-    sp->SCp.have_data_in =3D vdma_alloc(CPHYSADDR(sp->SCp.buffer), sp-=
>SCp.this_residual);
-    sp->SCp.ptr =3D (char *)((unsigned long)sp->SCp.have_data_in);
+	vdma_disable ((int)esp->dma_regs);
 }
=20
-static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, struct scsi_cmn=
d *sp)
+static void jazz_esp_dma_drain(struct esp *esp)
 {
-    int sz =3D sp->SCp.buffers_residual;
-    struct scatterlist *sg =3D (struct scatterlist *) sp->SCp.buffer;
-   =20
-    while (sz >=3D 0) {
-	sg[sz].dma_address =3D vdma_alloc(CPHYSADDR(page_address(sg[sz].page)=
 + sg[sz].offset), sg[sz].length);
-	sz--;
-    }
-    sp->SCp.ptr=3D(char *)(sp->SCp.buffer->dma_address);
-}   =20
-
-static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, struct scsi=
_cmnd *sp)
+	/* nothing to do */
+}
+
+static void jazz_esp_dma_invalidate(struct esp *esp)
 {
-    vdma_free(sp->SCp.have_data_in);
+	vdma_disable ((int)esp->dma_regs);
 }
=20
-static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, struct scsi=
_cmnd *sp)
+static void jazz_esp_send_dma_cmd(struct esp *esp, u32 addr, u32 esp_c=
ount,
+				  u32 dma_count, int write, u8 cmd)
 {
-    int sz =3D sp->use_sg - 1;
-    struct scatterlist *sg =3D (struct scatterlist *)sp->request_buffe=
r;
-		=09
-    while(sz >=3D 0) {
-	vdma_free(sg[sz].dma_address);
-	sz--;
-    }
+	BUG_ON(!(cmd & ESP_CMD_DMA));
+
+	jazz_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
+	jazz_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
+	vdma_disable ((int)esp->dma_regs);
+	if (write)
+		vdma_set_mode ((int)esp->dma_regs, DMA_MODE_READ);
+	else
+		vdma_set_mode ((int)esp->dma_regs, DMA_MODE_WRITE);
+
+	vdma_set_addr ((int)esp->dma_regs, addr);
+	vdma_set_count ((int)esp->dma_regs, dma_count);
+	vdma_enable ((int)esp->dma_regs);
+=09
+	scsi_esp_cmd(esp, cmd);
 }
=20
-static void dma_advance_sg (struct scsi_cmnd *sp)
+static int jazz_esp_dma_error(struct esp *esp)
 {
-    sp->SCp.ptr =3D (char *)(sp->SCp.buffer->dma_address);
+	u32 enable =3D vdma_get_enable((int)esp->dma_regs);
+
+	if (enable & (R4030_MEM_INTR|R4030_ADDR_INTR))
+		return 1;
+
+	return 0;
 }
=20
-#define JAZZ_HDC_LED   0xe000d100 /* FIXME, find correct address */
+static const struct esp_driver_ops jazz_esp_ops =3D {
+	.esp_write8	=3D	jazz_esp_write8,
+	.esp_read8	=3D	jazz_esp_read8,
+	.map_single	=3D	jazz_esp_map_single,
+	.map_sg		=3D	jazz_esp_map_sg,
+	.unmap_single	=3D	jazz_esp_unmap_single,
+	.unmap_sg	=3D	jazz_esp_unmap_sg,
+	.irq_pending	=3D	jazz_esp_irq_pending,
+	.reset_dma	=3D	jazz_esp_reset_dma,
+	.dma_drain	=3D	jazz_esp_dma_drain,
+	.dma_invalidate	=3D	jazz_esp_dma_invalidate,
+	.send_dma_cmd	=3D	jazz_esp_send_dma_cmd,
+	.dma_error	=3D	jazz_esp_dma_error,
+};
=20
-static void dma_led_off(struct NCR_ESP *esp)
+static int __devinit esp_jazz_probe(struct platform_device *dev)
 {
-#if 0   =20
-    *(unsigned char *)JAZZ_HDC_LED =3D 0;
-#endif   =20
+	struct scsi_host_template *tpnt =3D &scsi_esp_template;
+	struct Scsi_Host *host;
+	struct esp *esp;
+	int err;
+
+	host =3D scsi_host_alloc(tpnt, sizeof(struct esp));
+
+	err =3D -ENOMEM;
+	if (!host)
+		goto fail;
+
+	host->max_id =3D 8;
+	esp =3D host_to_esp(host);
+
+	esp->host =3D host;
+	esp->dev =3D dev;
+	esp->ops =3D &jazz_esp_ops;
+
+	err =3D esp_jazz_map_regs(esp);
+	if (err < 0)
+		goto fail_unlink;
+
+	err =3D esp_jazz_map_command_block(esp);
+	if (err < 0)
+		goto fail_unmap_regs;
+
+	err =3D esp_jazz_register_irq(esp);
+	if (err < 0)
+		goto fail_unmap_command_block;
+
+	esp_jazz_get_props(esp);
+
+	dev_set_drvdata(&dev->dev, esp);
+
+	err =3D scsi_esp_register(esp, &dev->dev);
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
+fail_unmap_regs:
+fail_unlink:
+	scsi_host_put(host);
+fail:
+	return err;
 }
=20
-static void dma_led_on(struct NCR_ESP *esp)
-{   =20
-#if 0   =20
-    *(unsigned char *)JAZZ_HDC_LED =3D 1;
-#endif   =20
+static int __devexit esp_jazz_remove(struct platform_device *dev)
+{
+	struct esp *esp =3D dev_get_drvdata(&dev->dev);
+	unsigned int irq =3D esp->host->irq;
+	u32 val;
+
+	scsi_esp_unregister(esp);
+
+	free_irq(irq, esp);
+	dma_free_coherent(esp->dev, 16,
+			  esp->command_block,
+			  esp->command_block_dma);
+
+	scsi_host_put(esp->host);
+
+	return 0;
 }
=20
-static struct scsi_host_template driver_template =3D {
-	.proc_name		=3D "jazz_esp",
-	.proc_info		=3D esp_proc_info,
-	.name			=3D "ESP 100/100a/200",
-	.detect			=3D jazz_esp_detect,
-	.slave_alloc		=3D esp_slave_alloc,
-	.slave_destroy		=3D esp_slave_destroy,
-	.release		=3D jazz_esp_release,
-	.info			=3D esp_info,
-	.queuecommand		=3D esp_queue,
-	.eh_abort_handler	=3D esp_abort,
-	.eh_bus_reset_handler	=3D esp_reset,
-	.can_queue		=3D 7,
-	.this_id		=3D 7,
-	.sg_tablesize		=3D SG_ALL,
-	.cmd_per_lun		=3D 1,
-	.use_clustering		=3D DISABLE_CLUSTERING,
+static struct platform_driver esp_jazz_driver =3D {
+	.probe		=3D esp_jazz_probe,
+	.remove		=3D __devexit_p(esp_jazz_remove),
+	.driver	=3D {
+		.name	=3D "jazz_esp",
+	},
 };
-#include "scsi_module.c"
+
+static int __init jazz_esp_init(void)
+{
+	return platform_driver_register(&esp_jazz_driver);
+}
+
+static void __exit jazz_esp_exit(void)
+{
+	platform_driver_unregister(&esp_jazz_driver);
+}
+
+MODULE_DESCRIPTION("JAZZ ESP SCSI driver");
+MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(jazz_esp_init);
+module_exit(jazz_esp_exit);

--=20
Crap can work. Given enough thrust pigs will fly, but it's not necessar=
y a
good idea.                                                [ RFC1925, 2.=
3 ]
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
