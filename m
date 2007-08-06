From: Matthew Wilcox <matthew@wil.cx>
Subject: An MCA ESP driver
Date: Mon, 6 Aug 2007 17:24:58 -0600
Message-ID: <20070806232458.GC9732@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43715 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764220AbXHFXZA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 19:25:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is about 90% complete.  I need to implement:

drivers/scsi/mca_53c9x.c:191: error: 'mca_esp_reset_dma' undeclared here (not in a function)
drivers/scsi/mca_53c9x.c:192: error: 'mca_esp_dma_drain' undeclared here (not in a function)
drivers/scsi/mca_53c9x.c:193: error: 'mca_esp_dma_invalidate' undeclared here (not in a function)
drivers/scsi/mca_53c9x.c:195: error: 'mca_esp_dma_error' undeclared here (not in a function)

I thought I'd post what I have so far.  If you compare it to the
mca_53c9x driver currently in-tree, you'll see that davem's new core is
much nicer.  I had to make one tiny change to the esp driver core:

diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 856e38b..fc8437d 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -514,11 +514,14 @@ struct esp {
 
 	struct completion	*eh_reset;
 
-	struct sbus_dma		*dma;
+	union {
+		struct sbus_dma	*sbus_dma;
+		unsigned int	x86_dma;
+	};
 };
 
 /* A front-end driver for the ESP chip should do the following in
- * it's device probe routine:
+ * its device probe routine:
  * 1) Allocate the host and private area using scsi_host_alloc()
  *    with size 'sizeof(struct esp)'.  The first argument to
  *    scsi_host_alloc() should be &scsi_esp_template.

(er, I suppose I need to touch up the sun_esp driver to match the name
change).

Anyway, the new driver:

/* mca_53c9x.c: Driver for the SCSI adapter found on NCR 35xx
 *  (and maybe some other) Microchannel machines
 *
 * Code taken mostly from Cyberstorm SCSI drivers
 *   Copyright (C) 1996 Jesper Skov (jskov@cygnus.co.uk)
 *
 * Hacked to work with the NCR MCA stuff by Tymm Twillman (tymm@computer.org)
 *
 * The CyberStorm SCSI driver (and this driver) is based on David S. Miller's
 *   ESP driver  * for the Sparc computers.
 *
 * Special thanks to Ken Stewart at Symbios (LSI) for helping with info on
 *  the 86C01.  I was on the brink of going ga-ga...
 *
 * Also thanks to Jesper Skov for helping me with info on how the Amiga
 *  does things...
 */

/*
 * Info on the 86C01 MCA interface chip at the bottom, if you care enough to
 *  look.
 */

#include <linux/delay.h>
#include <linux/interrupt.h>
#include <linux/kernel.h>
#include <linux/mca.h>
#include <linux/types.h>
#include <linux/string.h>
#include <linux/slab.h>
#include <linux/blkdev.h>
#include <linux/proc_fs.h>

#include <asm/dma.h>
#include <asm/mca_dma.h>

#include <scsi/scsi_host.h>
#include "scsi.h"
#include "esp_scsi.h"

/* Tell the 86C01 to stop sending interrupts */
static void mca_esp_disable_irq(struct esp *esp)
{
	u8 mode_enable = ioread8(esp->dma_regs + 2);
	iowrite8(mode_enable & ~0x40, esp->dma_regs + 2);
}

/* Tell the 86C01 to give us interrupts */
static void mca_esp_enable_irq(struct esp *esp)
{
	u8 mode_enable = ioread8(esp->dma_regs + 2);
	iowrite8(mode_enable | 0x40, esp->dma_regs + 2);
}

/*
 * We keep the structure that is used to access the registers on the 53c9x
 *  here.
 */

static struct ESP_regs eregs;

/************************************************************* DMA Functions */
static int dma_bytes_sent(struct esp *esp, int fifo_count)
{
	/* Ask the 53c9x.  It knows. */

	return fifo_count;
}

static int dma_can_transfer(struct esp *esp, Scsi_Cmnd *sp)
{
	/*
	 * The MCA dma channels can only do up to 128K bytes at a time.
         *  (16 bit mode)
	 */

	unsigned long sz = sp->SCp.this_residual;
	if(sz > 0x20000)
		sz = 0x20000;
	return sz;
}

#if 0
static void dma_dump_state(struct esp *esp)
{
	/*
	 * Doesn't quite match up to the other drivers, but we do what we
	 *  can.
	 */

	ESPLOG(("esp%d: dma channel <%d>\n", esp->esp_id, esp->x86_dma));
	ESPLOG(("bytes left to dma: %d\n", mca_get_dma_residue(esp->x86_dma)));
}

/*
 * These will not play nicely with other disk controllers that try to use the
 *  disk active LED... but what can you do?  Don't answer that.
 *
 * Stolen shamelessly from ibmmca.c -- IBM Microchannel SCSI adapter driver
 */

#define PS2_SYS_CTR	0x92

static void dma_led_on(struct esp *esp)
{
	outb(inb(PS2_SYS_CTR) | 0xc0, PS2_SYS_CTR);
}

static void dma_led_off(struct esp *esp)
{
	outb(inb(PS2_SYS_CTR) & 0x3f, PS2_SYS_CTR);
}

/*
 * Check to see if interrupts are enabled on the 'C01 (in case abort
 *  is entered multiple times, so we only do the abort once)
 */
static int dma_ports_p(struct esp *esp)
{
	return (ioread8(esp->dma_regs + 2) & 0x40) ? 1 : 0;
}

#endif

static void mca_esp_write8(struct esp *esp, u8 val, unsigned long reg)
{
	iowrite8(val, esp->regs + reg);
}

static u8 mca_esp_read8(struct esp *esp, unsigned long reg)
{
	return ioread8(esp->regs + reg);
}

static dma_addr_t mca_esp_map_single(struct esp *esp, void *buf, size_t sz,
					int dir)
{
	return dma_map_single(esp->dev, buf, sz, dir);
}

static int mca_esp_map_sg(struct esp *esp, struct scatterlist *sg, int num_sg,
					int dir)
{
	return dma_map_sg(esp->dev, sg, num_sg, dir);
}

static void mca_esp_unmap_single(struct esp *esp, dma_addr_t addr, size_t sz,
					int dir)
{
	dma_unmap_single(esp->dev, addr, sz, dir);
}

static void mca_esp_unmap_sg(struct esp *esp, struct scatterlist *sg,
					int num_sg, int dir)
{
	dma_unmap_sg(esp->dev, sg, num_sg, dir);
}

static int mca_esp_irq_pending(struct esp *esp)
{
	u8 status = ioread8(esp->dma_regs + 0xc);
	return status & 1;
}

#define mca_esp_dma_flags MCA_DMA_MODE_XFER | MCA_DMA_MODE_16 | MCA_DMA_MODE_IO

static void mca_esp_send_dma_cmd(struct esp *esp, u32 dma_addr, u32 esp_count,
				 u32 dma_count, int write, u8 cmd)
{
	mca_disable_dma(esp->x86_dma);
	mca_set_dma_mode(esp->x86_dma, mca_esp_dma_flags | (write ?
						MCA_DMA_MODE_WRITE : 0));
	mca_set_dma_addr(esp->x86_dma, dma_addr);
	mca_set_dma_count(esp->x86_dma, dma_count);
	mca_enable_dma(esp->x86_dma);

	mca_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
	mca_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);

	scsi_esp_cmd(esp, cmd);
}

static const struct esp_driver_ops mca_esp_ops = {
	.esp_write8	= mca_esp_write8,
	.esp_read8	= mca_esp_read8,
	.map_single	= mca_esp_map_single,
	.map_sg		= mca_esp_map_sg,
	.unmap_single	= mca_esp_unmap_single,
	.unmap_sg	= mca_esp_unmap_sg,
	.irq_pending	= mca_esp_irq_pending,
	.reset_dma	= mca_esp_reset_dma,
	.dma_drain	= mca_esp_dma_drain,
	.dma_invalidate	= mca_esp_dma_invalidate,
	.send_dma_cmd	= mca_esp_send_dma_cmd,
	.dma_error	= mca_esp_dma_error,
};

/*
 * IO port base is given in the pos 2 register, like so:
 *
 *  Bits 3  2  1       IO base
 * ----------------------------
 *       0  0  0       <disabled>
 *       0  0  1       0x0240
 *       0  1  0       0x0340
 *       0  1  1       0x0400
 *       1  0  0       0x0420
 *       1  0  1       0x3240
 *       1  1  0       0x8240
 *       1  1  1       0xA240
 */
static const short __devinitdata mca_esp_ports[] = {
	0x0000, 0x0240, 0x0340, 0x0400, 0x0420, 0x3240, 0x8240, 0xA240
};

static int __devinit mca_esp_probe(struct device *dev)
{
	struct mca_device *mdev = to_mca_device(dev);
	struct Scsi_Host *shost;
	struct esp *esp;
	unsigned short io_port;
	int err;

	shost = scsi_host_alloc(&scsi_esp_template, sizeof(struct esp));

	err = -ENOMEM;
	if (!shost)
		goto fail;

	shost->max_id = 8;
	esp = shost_priv(shost);

	esp->host = shost;
	esp->dev = dev;
	esp->ops = &mca_esp_ops;

	if (mdev->pos[2] & 0x80)
		esp->flags |= ESP_FLAG_WIDE_CAPABLE;

	err = -ENODEV;
	io_port = mca_esp_ports[(mdev->pos[2] & 0x0E) >> 1];
	if (io_port == 0) {
        	printk("Adapter is disabled.\n");
		goto free_shost;
	}

	err = -EBUSY;
	if (request_region(io_port, 32, "NCR 53c9x SCSI")) {
		printk("Resources in use\n");
		goto free_shost;
	}

	esp->dma_regs = ioport_map(io_port, 32);
	esp->regs = esp->dma_regs + 0x10;

	err = -ENOMEM;
	esp->command_block = dma_alloc_coherent(dev, 16,
				&esp->command_block_dma, GFP_KERNEL);
	if (!esp->command_block) {
		printk("Could not alloc DMA memory\n");
		goto release_region;
	}

	shost->irq = ((mdev->pos[2] & 0x30) >> 3) + 3;

	err = request_irq(shost->irq, scsi_esp_intr, IRQF_SHARED,
			  "NCR 53c9x SCSI", esp);
	if (err) {
		printk("Unable to request IRQ %d.\n", shost->irq);
		goto free_dma_mem;
	}

	esp->x86_dma = mdev->pos[3] & 7;

	err = request_dma(esp->x86_dma, "NCR 53c9x SCSI");
	if (err) {
		printk("Unable to request DMA channel %d.\n", esp->x86_dma);
		goto free_irq;
	}

	shost->this_id = esp->scsi_id = ((mdev->pos[4] & 0xC0) >> 6) + 4;
	esp->scsi_id_mask = 1 << esp->scsi_id;

	/* SCSI chip speed */

	esp->cfreq = 25000000;

	/*
	 * 86C01 handles DMA, IO mode, from address (base + 0x0a)
	 */

	mca_disable_dma(esp->x86_dma);
	mca_set_dma_io(esp->x86_dma, io_port + 0x0a);
	mca_enable_dma(esp->x86_dma);

	mca_esp_enable_irq(esp);

	dev_set_drvdata(dev, shost);

	err = scsi_esp_register(esp, dev);
	if (err) {
		printk("ESP register failed\n");
		goto free_dma;
	}

      	printk("Adapter found in slot %2d: io port 0x%x irq %d "
		"dma channel %d\n", mdev->slot, io_port, shost->irq,
		esp->x86_dma);

	return 0;

 free_dma:
	free_dma(esp->x86_dma);
 free_irq:
	free_irq(shost->irq, scsi_esp_intr);
 free_dma_mem:
	dma_free_coherent(dev, 16, esp->command_block, esp->command_block_dma);
 release_region:
	release_region(io_port, 32);
 free_shost:
	scsi_host_put(shost);
 fail:
	return err;
}

static int mca_esp_remove(struct device *dev)
{
	struct Scsi_Host *shost = dev_get_drvdata(dev);
	struct esp *esp = shost_priv(shost);

	scsi_remove_host(shost);
	scsi_esp_unregister(esp);
	mca_esp_disable_irq(esp);
	free_irq(shost->irq, scsi_esp_intr);
	free_dma(esp->x86_dma);

	scsi_host_put(shost);
	return 0;
}

/*
 * Supposedly there were some cards put together with the 'c9x and 86c01.
 * If they have different ID's from the ones on the 3500 series machines,
 * you can add them here and hopefully things will work out.
 */
static const short mca_esp_id_table[] = { 0x7F4C, 0 };

static struct mca_driver mca_esp_driver = {
	.id_table	= mca_esp_id_table,
	.driver = {
		.name	= "mca_esp",
		.probe	= mca_esp_probe,
		.remove	= __devexit_p(mca_esp_remove),
	},
};

static int __init mca_esp_init(void)
{
	return mca_register_driver(&mca_esp_driver);
}

static void __exit mca_esp_exit(void)
{
	mca_unregister_driver(&mca_esp_driver);
}

module_init(mca_esp_init);
module_exit(mca_esp_exit);

/*
 * OK, here's the goods I promised.  The NCR 86C01 is an MCA interface chip
 *  that handles enabling/diabling IRQ, dma interfacing, IO port selection
 *  and other fun stuff.  It takes up 16 addresses, and the chip it is
 *  connnected to gets the following 16.  Registers are as follows:
 *
 * Offsets 0-1 : Card ID
 *
 * Offset    2 : Mode enable register --
 *                Bit    7 : Data Word width (1 = 16, 0 = 8)
 *		  Bit    6 : IRQ enable (1 = enabled)
 *                Bits 5,4 : IRQ select
 *                              0  0 : IRQ 3
 *			        0  1 : IRQ 5
 * 				1  0 : IRQ 7
 *  				1  1 : IRQ 9
 *                Bits 3-1 : Base Address
 *                           0  0  0 : <disabled>
 * 			     0  0  1 : 0x0240
 *    			     0  1  0 : 0x0340
 *     			     0  1  1 : 0x0400
 * 			     1  0  0 : 0x0420
 * 			     1  0  1 : 0x3240
 * 			     1  1  0 : 0x8240
 * 			     1  1  1 : 0xA240
 *		  Bit    0 : Card enable (1 = enabled)
 *
 * Offset    3 : DMA control register --
 *                Bit    7 : DMA enable (1 = enabled)
 *                Bits 6,5 : Preemt Count Select (transfers to complete after
 *                            'C01 has been preempted on MCA bus)
 *                              0  0 : 0
 *                              0  1 : 1
 *                              1  0 : 3
 *                              1  1 : 7
 *  (all these wacky numbers; I'm sure there's a reason somewhere)
 *                Bit    4 : Fairness enable (1 = fair bus priority)
 *                Bits 3-0 : Arbitration level (0-15 consecutive)
 *
 * Offset    4 : General purpose register
 *                Bits 7-3 : User definable (here, 7,6 are SCSI ID)
 *                Bits 2-0 : reserved
 *
 * Offset   10 : DMA decode register (used for IO based DMA; also can do
 *                PIO through this port)
 *
 * Offset   12 : Status
 *                Bits 7-2 : reserved
 *                Bit    1 : DMA pending (1 = pending)
 *                Bit    0 : IRQ pending (0 = pending)
 *
 * Exciting, huh?
 *
 */

----- End forwarded message -----

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
