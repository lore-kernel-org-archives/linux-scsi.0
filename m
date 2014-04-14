From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: esp_scsi QTAG in FAS216
Date: Mon, 14 Apr 2014 20:51:16 +1200
Message-ID: <529ac1e986ffc7a0c361a7f758e0abc3@gmail.com>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com>	<CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com>	<CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com> <20140413.221414.853080853067673824.davem@davemloft.net> <534B6C9E.3070307@aalto.fi>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: multipart/mixed; boundary=Apple-Mail-2-398965476
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <534B6C9E.3070307@aalto.fi>
Sender: linux-m68k-owner@vger.kernel.org
To: Tuomas Vainikka <tuomas.vainikka@aalto.fi>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, David Miller <davem@davemloft.net>, geert@linux-m68k.org, jongk@linux-m68k.org
List-Id: linux-scsi@vger.kernel.org


--Apple-Mail-2-398965476
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hi Tuomas,

>>> My preference would be to set this one (named ESP_CONFIG3_TBMS). Your
>>> opinion, Dave?
>> As seems to be agreed upon here, the SCSI2 bit in the CONFIG2 register
>> (ESP_CONFIG2_SCSI2ENAB) is only for when the chip is used in target
>> mode.  So it is not relevant for our discussion because this driver is
>> for initiator mode operation only.
>>
>> But some pieces of documentation seem like they might not agree on
>> this point.
>>
>> With respect to bit 3 in the config3 register, it can take on one of
>> two meaning depending upon chip revision.  As per  
>> ESP_CONFIG3_{TMS,FCLK}
>> it either controls fast SCSI clocking, or it enabled 3 byte message
>> recognition.
>>
>> But oddly in the NCR53CX docs:
>>
>> 	http://www.ibiblio.org/pub/historic-linux/early-ports/Sparc/NCR/ 
>> NCR53C9X.txt
>>
>> it speaks as if ESP_CONFIG3_TMS and ESP_CONFIG3_TENB are merely finer
>> grained versions of config2 register setting ESP_CONFIG2_SCSI2ENAB,
>> which enables both features.
>>
>> Again I looked at the FreeBSD driver and for all chips after plain
>> esp100, they set ESP_CONFIG2_SCSI2ENAB.
>>
>> Can we try testing the following patch?
>>
>> ====================
>> esp_scsi: Set SCSI2 bit in config2 register.
>>
>> This should allow proper recognition of 3 byte reselection
>> on all esp100a and later chips.
>>
>> Reported-by: Kars de Jong <jongk@linux-m68k.org>
>> Reported-by: Michael Schmitz <schmitzmic@gmail.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
>> index 55548dc..16f69e0 100644
>> --- a/drivers/scsi/esp_scsi.c
>> +++ b/drivers/scsi/esp_scsi.c
>> @@ -2160,7 +2160,7 @@ static void esp_get_revision(struct esp *esp)
>>   		 */
>>   		esp->rev = ESP100;
>>   	} else {
>> -		esp->config2 = 0;
>> +		esp->config2 = ESP_CONFIG2_SCSI2ENAB;
>>   		esp_set_all_config3(esp, 5);
>>   		esp->prev_cfg3 = 5;
>>   		esp_write8(esp->config2, ESP_CFG2);
>> @@ -2187,8 +2187,6 @@ static void esp_get_revision(struct esp *esp)
>>   			} else {
>>   				esp->rev = ESP236;
>>   			}
>> -			esp->config2 = 0;
>> -			esp_write8(esp->config2, ESP_CFG2);
>>   		}
>>   	}
>>   }
>
> I'll test these out soon.
>
> Michael, where can I pull the latest version of zorro_esp?
>

Not sure my patch had ever made it into Geert's m68k-queue - except for  
the patch in my previous mail, my zorro_esp.c is still the same as I  
got from you in October last year. The project has been on the back  
burner for too long ...

I'll look into setting up pull access to my repository. zorro_esp.c as  
of today attached for now.

Cheers,

	Michael



  
--Apple-Mail-2-398965476
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name="zorro_esp.c"
Content-Disposition: attachment;
	filename=zorro_esp.c

/* zorrro_esp.c: ESP front-end for Amiga ZORRO SCSI systems.
 *
 * Copyright (C) 1996 Jesper Skov (jskov@cygnus.co.uk)
 *
 * Copyright (C) 2011 Michael Schmitz (schmitz@debian.org) for 
 *               migration to ESP SCSI core
 */
/*
 * ZORRO bus code from:
 */
/*
 * Detection routine for the NCR53c710 based Amiga SCSI Controllers for Linux.
 *		Amiga MacroSystemUS WarpEngine SCSI controller.
 *		Amiga Technologies/DKB A4091 SCSI controller.
 *
 * Written 1997 by Alan Hourihane <alanh@fairlite.demon.co.uk>
 * plus modifications of the 53c7xx.c driver to support the Amiga.
 *
 * Rewritten to use 53c700.c by Kars de Jong <jongk@linux-m68k.org>
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/ratelimit.h>
#include <linux/dma-mapping.h>
#include <linux/scatterlist.h>
#include <linux/delay.h>
#include <linux/zorro.h>
#include <linux/slab.h>


#include <asm/page.h>
#include <asm/pgtable.h>
#include <asm/cacheflush.h>
#include <asm/amigahw.h>
#include <asm/amigaints.h>

#include <scsi/scsi_host.h>
#include <scsi/scsi_transport_spi.h>
#include <scsi/scsi_device.h>
#include <scsi/scsi_tcq.h>

#include "esp_scsi.h"

MODULE_AUTHOR("Michael Schmitz <schmitz@debian.org>");
MODULE_DESCRIPTION("Amiga Zorro NCR5C9x (ESP) driver");
MODULE_LICENSE("GPL");

#define DMA_WRITE 0x80000000

static struct zorro_driver_data {
	const char *name;
	unsigned long offset;
	unsigned long dma_offset;
	int absolute;
	int zorro3;	/* offset is absolute address */
} zorro_esp_driver_data[] = {
	{ .name = "CyberStormI", .offset = 0xf400, .dma_offset = 0xf800, .absolute = 0, .zorro3 = 0 },
	{ .name = "CyberStormII", .offset = 0x1ff03, .dma_offset = 0x1ff43, .absolute = 0, .zorro3 = 0 },
	{ .name = "Blizzard 2060", .offset = 0x1ff00, .dma_offset = 0x1ffe0, .absolute = 0, .zorro3 = 0 },
	{ .name = "Blizzard 1230", .offset = 0x8000, .dma_offset = 0x10000, .absolute = 0, .zorro3 = 0 },
	{ .name = "Blizzard 1230II", .offset = 0x10000, .dma_offset = 0x10021, .absolute = 0, .zorro3 = 0 },
	{ .name = "Fastlane", .offset = 0x1000001, .dma_offset = 0x1000041, .absolute = 0, .zorro3 = 1 },
	{ 0 }
};

static struct zorro_device_id zorro_esp_zorro_tbl[] = {
	{
		.id = ZORRO_PROD_PHASE5_BLIZZARD_1220_CYBERSTORM,
		.driver_data = (unsigned long)&zorro_esp_driver_data[0],
	},
	{
		.id = ZORRO_PROD_PHASE5_BLIZZARD_1230_II_FASTLANE_Z3_CYBERSCSI_CYBERSTORM060,
		.driver_data = (unsigned long)&zorro_esp_driver_data[0],
	},
	{
		.id = ZORRO_PROD_PHASE5_CYBERSTORM_MK_II,
		.driver_data = (unsigned long)&zorro_esp_driver_data[1],
	},
	{
		.id = ZORRO_PROD_PHASE5_BLIZZARD_2060,
		.driver_data = (unsigned long)&zorro_esp_driver_data[2],
	},
	{
		.id = ZORRO_PROD_PHASE5_BLIZZARD_1230_IV_1260,
		.driver_data = (unsigned long)&zorro_esp_driver_data[3],
	},
	{
		.id = ZORRO_PROD_PHASE5_BLIZZARD_1230_II_FASTLANE_Z3_CYBERSCSI_CYBERSTORM060,
		.driver_data = (unsigned long)&zorro_esp_driver_data[4],
	},
	{ 0 }
};
MODULE_DEVICE_TABLE(zorro, zorro_esp_zorro_tbl);

struct blz1230_dma_registers {
        volatile unsigned char dma_addr;        /* DMA address      [0x0000] */
        unsigned char dmapad2[0x7fff];
        volatile unsigned char dma_latch;       /* DMA latch        [0x8000] */
};

struct blz2060_dma_registers {
	volatile unsigned char dma_led_ctrl;	/* DMA led control   [0x000] */
	unsigned char dmapad1[0x0f];
	volatile unsigned char dma_addr0; 	/* DMA address (MSB) [0x010] */
	unsigned char dmapad2[0x03];
	volatile unsigned char dma_addr1; 	/* DMA address       [0x014] */
	unsigned char dmapad3[0x03];
	volatile unsigned char dma_addr2; 	/* DMA address       [0x018] */
	unsigned char dmapad4[0x03];
	volatile unsigned char dma_addr3; 	/* DMA address (LSB) [0x01c] */
};

/* DMA control bits */
#define BLZ2060_DMA_LED    0x02		/* HD led control 1 = off */

/*
 * m68k always assumes readl/writel operate on little endian
 * mmio space; this is wrong at least for Sun3x, so we
 * need to workaround this until a proper way is found
 */
#if 0
#define dma_read32(REG) \
	readl(esp->dma_regs + (REG))
#define dma_write32(VAL, REG) \
	writel((VAL), esp->dma_regs + (REG))
#else
#define dma_read32(REG) \
	*(volatile u32 *)(esp->dma_regs + (REG))
#define dma_write32(VAL, REG) \
	do { *(volatile u32 *)(esp->dma_regs + (REG)) = (VAL); } while (0)
#endif

/*
 * On all implementations except for the Oktagon, padding between ESP 
 * registers is three bytes.
 * On Oktagon, it is one byte - use a different accessor there. 
 *
 * Oktagon currently unsupported!
 */

static void zorro_esp_write8(struct esp *esp, u8 val, unsigned long reg)
{
	writeb(val, esp->regs + (reg * 4UL));
}

static u8 zorro_esp_read8(struct esp *esp, unsigned long reg)
{
	return readb(esp->regs + (reg * 4UL));
}

static dma_addr_t zorro_esp_map_single(struct esp *esp, void *buf,
				      size_t sz, int dir)
{
	return dma_map_single(esp->dev, buf, sz, dir);
}

static int zorro_esp_map_sg(struct esp *esp, struct scatterlist *sg,
				  int num_sg, int dir)
{
	return dma_map_sg(esp->dev, sg, num_sg, dir);
}

static void zorro_esp_unmap_single(struct esp *esp, dma_addr_t addr,
				  size_t sz, int dir)
{
	dma_unmap_single(esp->dev, addr, sz, dir);
}

static void zorro_esp_unmap_sg(struct esp *esp, struct scatterlist *sg,
			      int num_sg, int dir)
{
	dma_unmap_sg(esp->dev, sg, num_sg, dir);
}

static int zorro_esp_irq_pending(struct esp *esp)
{
	/* check ESP status register; DMA has no status reg. */

	if ( zorro_esp_read8(esp,ESP_STATUS) & ESP_STAT_INTR )
		return 1;

	return 0;
}

static void zorro_esp_reset_dma(struct esp *esp)
{
	/* nothing to do here */
}

static void zorro_esp_dma_drain(struct esp *esp)
{
	/* nothing to do here */
}

static void zorro_esp_dma_invalidate(struct esp *esp)
{
	/* nothing to do here */
}

#ifdef ZORRO_ESP_PIO_CMD
static void zorro_esp_send_pio_cmd(struct esp *esp, u32 esp_count,
					int write, u8 cmd)
{
	/*
	NOTE that this function is only for esp->command_block!
	*/

	u32 i, j;
	u32 fbytes = 0;

	if (esp_count > 16) {
		printk( "zorro_esp: PIO: Too many bytes for command block transfer!\n" );
		return;
	}

	cmd &= ~(ESP_CMD_DMA);

        if (write) {
                scsi_esp_cmd(esp, cmd);

		j = 0;
		while (1) {
			i = 0;
			fbytes = 0;
	                while (!fbytes) {
				fbytes = zorro_esp_read8(esp, ESP_FFLAGS) & ESP_FF_FBYTES;
				i++;
				if ( i > 1000000 ) break;
				udelay(1);
			}

			if (!fbytes) break;

			while (fbytes) {
				esp->command_block[j++] = zorro_esp_read8(esp, ESP_FDATA);
				fbytes--;
			}

			if ( j == esp_count ) break;

			i = 0;
	                while (!zorro_esp_irq_pending(esp)) {
				i++;
				if ( i > 1000000 ) break;
				udelay(1);
			}

			if ( i > 1000000 ) {
				printk( "zorro_esp: PIO: IRQ TIMEOUT!\n" );
				break;
				}

                        scsi_esp_cmd(esp, ESP_CMD_TI);
		}

	} else {
		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
		fbytes = esp_count;
		for (i=0;i<fbytes;i++) zorro_esp_write8(esp, esp->command_block[i], ESP_FDATA);
                scsi_esp_cmd(esp, cmd);
	}

	if ( j != esp_count )
		printk( "zorro_esp: PIO: %d bytes transferred out of %d expected.\n" );

}
#endif /* ZORRO_ESP_PIO_CMD */

// Blizzard 1230/60 SCSI-IV DMA

static void zorro_esp_send_blz1230_dma_cmd(struct esp *esp, u32 addr,
			u32 esp_count, u32 dma_count, int write, u8 cmd)
{
	struct blz1230_dma_registers *dregs = (struct blz1230_dma_registers *) (esp->dma_regs);

#ifdef ZORRO_ESP_PIO_CMD
	if (addr == esp->command_block_dma) {
		zorro_esp_send_pio_cmd(esp, esp_count, write, cmd);
		return;
		}
#endif
	BUG_ON(!(cmd & ESP_CMD_DMA));

	if (write)
		cache_clear(addr, esp_count);
	else
		cache_push(addr, esp_count);

	addr >>= 1;
	if (write)
		addr &= ~(DMA_WRITE);
	else
		addr |= DMA_WRITE;

	dregs->dma_latch = (addr >> 24) & 0xff;
	dregs->dma_addr = (addr >> 24) & 0xff;
	dregs->dma_addr = (addr >> 16) & 0xff;
	dregs->dma_addr = (addr >>  8) & 0xff;
	dregs->dma_addr = (addr      ) & 0xff;

	scsi_esp_cmd(esp, ESP_CMD_DMA);
	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
//	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);

	scsi_esp_cmd(esp, cmd);
}

// Blizzard 2060 DMA

static void zorro_esp_send_blz2060_dma_cmd(struct esp *esp, u32 addr,
			u32 esp_count, u32 dma_count, int write, u8 cmd)
{
	struct blz2060_dma_registers *dregs = (struct blz2060_dma_registers *) (esp->dma_regs);

#ifdef ZORRO_ESP_PIO_CMD
	if (addr == esp->command_block_dma) {
		zorro_esp_send_pio_cmd(esp, esp_count, write, cmd);
		return;
		}
#endif
	BUG_ON(!(cmd & ESP_CMD_DMA));

	if (write)
		cache_clear(addr, esp_count);
	else
		cache_push(addr, esp_count);

	addr >>= 1;
	if (write)
		addr &= ~(DMA_WRITE);
	else
		addr |= DMA_WRITE;

	dregs->dma_addr3 = (addr      ) & 0xff;
	dregs->dma_addr2 = (addr >>  8) & 0xff;
	dregs->dma_addr1 = (addr >> 16) & 0xff;
	dregs->dma_addr0 = (addr >> 24) & 0xff;

	scsi_esp_cmd(esp, ESP_CMD_DMA);
	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
//	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);

	scsi_esp_cmd(esp, cmd);
}

static int zorro_esp_dma_error(struct esp *esp)
{
	/* nothing to do here - there seems to be no way to check for DMA errors */
	return 0;
}

static struct esp_driver_ops zorro_esp_ops = {
	.esp_write8	=	zorro_esp_write8,
	.esp_read8	=	zorro_esp_read8,
	.map_single	=	zorro_esp_map_single,
	.map_sg		=	zorro_esp_map_sg,
	.unmap_single	=	zorro_esp_unmap_single,
	.unmap_sg	=	zorro_esp_unmap_sg,
	.irq_pending	=	zorro_esp_irq_pending,
	.reset_dma	=	zorro_esp_reset_dma,
	.dma_drain	=	zorro_esp_dma_drain,
	.dma_invalidate	=	zorro_esp_dma_invalidate,
	.send_dma_cmd	=	zorro_esp_send_blz2060_dma_cmd,
	.dma_error	=	zorro_esp_dma_error,
};

static int zorro_esp_slave_configure(struct scsi_device *dev)
{
	/*
	 This function is used instead of the original
	 esp_scsi.c: esp_slave_configure() to hardwire
	 TCQ off until someone finds out where things
	 go wrong.
	*/

	struct esp *esp = shost_priv(dev->host);
	struct esp_target_data *tp = &esp->target[dev->id];

	scsi_deactivate_tcq(dev, dev->host->cmd_per_lun);
        tp->flags |= ESP_TGT_DISCONNECT;

        if (!spi_initial_dv(dev->sdev_target))
                spi_dv_device(dev);

        return 0;
}

static int zorro_esp_init_one(struct zorro_dev *z,
				       const struct zorro_device_id *ent)
{
	struct scsi_host_template *tpnt = &scsi_esp_template;
	struct Scsi_Host *host;
	struct esp *esp;
	struct zorro_driver_data *zdd;
	unsigned long board, ioaddr, dmaaddr;
	int err = -ENOMEM;

	board = zorro_resource_start(z);
	zdd = (struct zorro_driver_data *)ent->driver_data;

	printk( "zorro_esp: %s found at address 0x%lx.\n", zdd->name, board );

	if (zdd->absolute) {
		ioaddr  = zdd->offset;
		dmaaddr = zdd->dma_offset;
	} else {
		ioaddr  = board + zdd->offset;
		dmaaddr = board + zdd->dma_offset;
	}

	if (!zorro_request_device(z, zdd->name)) {
		printk(KERN_ERR "zorro_esp: cannot reserve region 0x%lx, abort\n",
		       board);
		return -EBUSY;
	}

	host = scsi_host_alloc(tpnt, sizeof(struct esp));

	if (!host) {
		printk(KERN_ERR "zorro_esp: No host detected; "
				"board configuration problem?\n");
		goto out_free;
	}

	host->base		= ioaddr;
        host->this_id		= 7;

	esp			= shost_priv(host);
	esp->host		= host;
	esp->dev		= &z->dev;

	esp->scsi_id		= host->this_id;
	esp->scsi_id_mask	= (1 << esp->scsi_id);

	/* Switch to the correct the DMA routine and clock frequency. */
	switch ( ent->id ) {
	case ZORRO_PROD_PHASE5_BLIZZARD_2060: {
		zorro_esp_ops.send_dma_cmd = zorro_esp_send_blz2060_dma_cmd;
		esp->cfreq = 40000000;
		break;
		}
	case ZORRO_PROD_PHASE5_BLIZZARD_1230_IV_1260: {
		zorro_esp_ops.send_dma_cmd = zorro_esp_send_blz1230_dma_cmd;
		esp->cfreq = 40000000;
		break;
		}
	default: {
		/* Oh noes */
		printk(KERN_ERR "zorro_esp: Unsupported board!\n");
		goto fail_free_host;
		break;
		}
	}

	esp->ops = &zorro_esp_ops;

	if (ioaddr > 0xffffff)
		esp->regs = ioremap_nocache(ioaddr, 0x20);
	else
		esp->regs = (void __iomem *)ZTWO_VADDR(ioaddr);

	if (!esp->regs)
		goto fail_free_host;

	/* Let's check whether a Blizzard 12x0 really has SCSI */
	if ((ent->id == ZORRO_PROD_PHASE5_BLIZZARD_1230_IV_1260) ||
	   (ent->id == ZORRO_PROD_PHASE5_BLIZZARD_1230_II_FASTLANE_Z3_CYBERSCSI_CYBERSTORM060)) {
		zorro_esp_write8(esp, (ESP_CONFIG1_PENABLE | 7), ESP_CFG1);
		if ( zorro_esp_read8(esp, ESP_CFG1) != (ESP_CONFIG1_PENABLE | 7) )
			goto fail_free_host;
	}

	if (ioaddr > 0xffffff) {
		// I guess the Fastlane Z3 will be the only one to catch this?
		// Here's a placeholder for now...
		if ( ent->id == ZORRO_PROD_PHASE5_BLIZZARD_1230_IV_1260 )
			esp->dma_regs = ioremap_nocache( dmaaddr, sizeof(struct blz1230_dma_registers) );
	} else
		esp->dma_regs = (void __iomem *)ZTWO_VADDR(dmaaddr);

	if (!esp->dma_regs)
		goto fail_unmap_regs;

	esp->command_block = dma_alloc_coherent(esp->dev, 16,
						&esp->command_block_dma,
						GFP_KERNEL);

	if (!esp->command_block)
		goto fail_unmap_dma_regs;

	host->irq = IRQ_AMIGA_PORTS;
	err = request_irq(host->irq, scsi_esp_intr, IRQF_SHARED,
			  "Amiga Zorro ESP", esp);
	if (err < 0)
		goto fail_free_command_block;

//	esp->flags = ESP_FLAG_DISABLE_SYNC;

	/* register the chip */
	err = scsi_esp_register(esp, &z->dev);
	if (err)
		goto fail_free_irq;

	esp->config2 = ESP_CONFIG2_SCSI2ENAB;
	zorro_esp_write8(esp, esp->config2, ESP_CFG2);


	zorro_set_drvdata(z, host);

	return 0;

fail_free_irq:
	free_irq(host->irq, esp);

fail_free_command_block:
	dma_free_coherent(esp->dev, 16,
			  esp->command_block,
			  esp->command_block_dma);

fail_unmap_dma_regs:
	if (ioaddr > 0xffffff)
		iounmap(esp->dma_regs);

fail_unmap_regs:
	if (ioaddr > 0xffffff)
		iounmap(esp->regs);

fail_free_host:
	scsi_host_put(host);

out_free:
	zorro_release_device(z);

	return -ENODEV;
}

static void zorro_esp_remove_one(struct zorro_dev *z)
{
	struct Scsi_Host *host = zorro_get_drvdata(z);
	struct esp *esp	= shost_priv(host);

	scsi_esp_unregister(esp);

	/* Disable interrupts. Perhaps use disable_irq instead ... */

	free_irq(host->irq, esp);
	dma_free_coherent(esp->dev, 16,
			  esp->command_block,
			  esp->command_block_dma);

	if ( host->base > 0xffffff ) {
		iounmap(esp->dma_regs);
		iounmap(esp->regs);
		}

	scsi_host_put(host);

	zorro_release_device(z);
}

static struct zorro_driver zorro_esp_driver = {
	.name	  = "zorro_esp-scsi",
	.id_table = zorro_esp_zorro_tbl,
	.probe	  = zorro_esp_init_one,
	.remove	  = zorro_esp_remove_one,
};

static int __init zorro_esp_scsi_init(void)
{
	return zorro_register_driver(&zorro_esp_driver);
}

static void __exit zorro_esp_scsi_exit(void)
{
	zorro_unregister_driver(&zorro_esp_driver);
}

module_init(zorro_esp_scsi_init);
module_exit(zorro_esp_scsi_exit);

--Apple-Mail-2-398965476
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed



--Apple-Mail-2-398965476--
