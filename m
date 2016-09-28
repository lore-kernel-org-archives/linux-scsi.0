From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 3/3] g_NCR5380: Stop using scsi_module.c
Date: Thu, 29 Sep 2016 08:57:59 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609290842060.22268@nippy.intranet>
References: <1475002825-18132-1-git-send-email-linux@rainbow-software.org> <1475002825-18132-4-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475002825-18132-4-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Acked-by: Finn Thain <fthain@telegraphics.com.au>

On Tue, 27 Sep 2016, Ondrej Zary wrote:

> Convert g_NCR5380 to use scsi_add_host instead of scsi_module.c
> Use pnp_driver and isa_driver to manage cards.
> 
> In order to support multiple cards, new module parameter format is
> introduced. The old parameters are kept for compatibility.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  Documentation/scsi/g_NCR5380.txt |   24 ++-
>  drivers/scsi/g_NCR5380.c         |  335 ++++++++++++++++++++++----------------
>  drivers/scsi/g_NCR5380.h         |    8 -
>  3 files changed, 215 insertions(+), 152 deletions(-)
> 
> diff --git a/Documentation/scsi/g_NCR5380.txt b/Documentation/scsi/g_NCR5380.txt
> index 843cbae..e2c1879 100644
> --- a/Documentation/scsi/g_NCR5380.txt
> +++ b/Documentation/scsi/g_NCR5380.txt
> @@ -28,6 +28,16 @@ time. More info to come in the future.
>  This driver works as a module.
>  When included as a module, parameters can be passed on the insmod/modprobe
>  command line:
> +  irq=xx[,...]	the interrupt(s)
> +  base=xx[,...]	the port or base address(es) (for port or memory mapped, resp.)
> +  card=xx[,...]	card type(s):
> +		0 = NCR5380,
> +		1 = NCR53C400,
> +		2 = NCR53C400A,
> +		3 = Domex Technology Corp 3181E (DTC3181E)
> +		4 = Hewlett Packard C2502
> +
> +These old-style parameters can support only one card:
>    ncr_irq=xx   the interrupt
>    ncr_addr=xx  the port or base address (for port or memory
>                 mapped, resp.)
> @@ -36,11 +46,19 @@ command line:
>    ncr_53c400a=1 to set up for a NCR53C400A board
>    dtc_3181e=1  to set up for a Domex Technology Corp 3181E board
>    hp_c2502=1   to set up for a Hewlett Packard C2502 board
> +
>  e.g.
> -modprobe g_NCR5380 ncr_irq=5 ncr_addr=0x350 ncr_5380=1
> +OLD: modprobe g_NCR5380 ncr_irq=5 ncr_addr=0x350 ncr_5380=1
> +NEW: modprobe g_NCR5380 irq=5 base=0x350 card=0
>    for a port mapped NCR5380 board or
> -modprobe g_NCR5380 ncr_irq=255 ncr_addr=0xc8000 ncr_53c400=1
> -  for a memory mapped NCR53C400 board with interrupts disabled.
> +
> +OLD: modprobe g_NCR5380 ncr_irq=255 ncr_addr=0xc8000 ncr_53c400=1
> +NEW: modprobe g_NCR5380 irq=255 base=0xc8000 card=1
> +  for a memory mapped NCR53C400 board with interrupts disabled or
> +
> +NEW: modprobe g_NCR5380 irq=0,7 base=0x240,0x300 card=3,4
> +  for two cards: DTC3181 (in non-PnP mode) at 0x240 with no IRQ
> +             and HP C2502 at 0x300 with IRQ 7
>  
>  (255 should be specified for no or DMA interrupt, 254 to autoprobe for an 
>       IRQ line if overridden on the command line.)
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 5162de6..cbf0103 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -30,24 +30,41 @@
>  #include "NCR5380.h"
>  #include <linux/init.h>
>  #include <linux/ioport.h>
> -#include <linux/isapnp.h>
> +#include <linux/isa.h>
> +#include <linux/pnp.h>
>  #include <linux/interrupt.h>
>  
> +#define MAX_CARDS 8
> +
> +/* old-style parameters for compatibility */
>  static int ncr_irq;
> -static int ncr_dma;
>  static int ncr_addr;
>  static int ncr_5380;
>  static int ncr_53c400;
>  static int ncr_53c400a;
>  static int dtc_3181e;
>  static int hp_c2502;
> +module_param(ncr_irq, int, 0);
> +module_param(ncr_addr, int, 0);
> +module_param(ncr_5380, int, 0);
> +module_param(ncr_53c400, int, 0);
> +module_param(ncr_53c400a, int, 0);
> +module_param(dtc_3181e, int, 0);
> +module_param(hp_c2502, int, 0);
> +
> +static int irq[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
> +module_param_array(irq, int, NULL, 0);
> +MODULE_PARM_DESC(irq, "IRQ number(s)");
>  
> -static struct card {
> -	NCR5380_map_type NCR5380_map_name;
> -	int irq;
> -	int dma;
> -	int board;		/* Use NCR53c400, Ricoh, etc. extensions ? */
> -} card;
> +static int base[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
> +module_param_array(base, int, NULL, 0);
> +MODULE_PARM_DESC(base, "base address(es)");
> +
> +static int card[] = { -1, -1, -1, -1, -1, -1, -1, -1 };
> +module_param_array(card, int, NULL, 0);
> +MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC3181E, 4=HP C2502)");
> +
> +MODULE_LICENSE("GPL");
>  
>  #ifndef SCSI_G_NCR5380_MEM
>  /*
> @@ -73,17 +90,8 @@ static void magic_configure(int idx, u8 irq, u8 magic[])
>  }
>  #endif
>  
> -/**
> - * 	generic_NCR5380_detect	-	look for NCR5380 controllers
> - *	@tpnt: the scsi template
> - *
> - *	Scan for the present of NCR5380, NCR53C400, NCR53C400A, DTC3181E
> - *	and DTC436(ISAPnP) controllers.
> - *
> - *	Locks: none
> - */
> -
> -static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> +static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
> +			struct device *pdev, int base, int irq, int board)
>  {
>  	unsigned int *ports;
>  	u8 *magic = NULL;
> @@ -92,80 +100,29 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  	int port_idx = -1;
>  	unsigned long region_size;
>  #endif
> -	static unsigned int __initdata ncr_53c400a_ports[] = {
> +	static unsigned int ncr_53c400a_ports[] = {
>  		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
>  	};
> -	static unsigned int __initdata dtc_3181e_ports[] = {
> +	static unsigned int dtc_3181e_ports[] = {
>  		0x220, 0x240, 0x280, 0x2a0, 0x2c0, 0x300, 0x320, 0x340, 0
>  	};
> -	static u8 ncr_53c400a_magic[] __initdata = {	/* 53C400A & DTC436 */
> +	static u8 ncr_53c400a_magic[] = {	/* 53C400A & DTC436 */
>  		0x59, 0xb9, 0xc5, 0xae, 0xa6
>  	};
> -	static u8 hp_c2502_magic[] __initdata = {	/* HP C2502 */
> +	static u8 hp_c2502_magic[] = {	/* HP C2502 */
>  		0x0f, 0x22, 0xf0, 0x20, 0x80
>  	};
> -	int flags;
> +	int flags, ret;
>  	struct Scsi_Host *instance;
>  	struct NCR5380_hostdata *hostdata;
>  #ifdef SCSI_G_NCR5380_MEM
> -	unsigned long base;
>  	void __iomem *iomem;
>  	resource_size_t iomem_size;
>  #endif
>  
> -	if (ncr_irq)
> -		card.irq = ncr_irq;
> -	if (ncr_dma)
> -		card.dma = ncr_dma;
> -	if (ncr_addr)
> -		card.NCR5380_map_name = (NCR5380_map_type) ncr_addr;
> -	if (ncr_5380)
> -		card.board = BOARD_NCR5380;
> -	else if (ncr_53c400)
> -		card.board = BOARD_NCR53C400;
> -	else if (ncr_53c400a)
> -		card.board = BOARD_NCR53C400A;
> -	else if (dtc_3181e)
> -		card.board = BOARD_DTC3181E;
> -	else if (hp_c2502)
> -		card.board = BOARD_HP_C2502;
> -#ifndef SCSI_G_NCR5380_MEM
> -	if (isapnp_present()) {
> -		struct pnp_dev *dev = NULL;
> -		while ((dev = pnp_find_dev(NULL, ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e), dev))) {
> -			if (pnp_device_attach(dev) < 0)
> -				continue;
> -			if (pnp_activate_dev(dev) < 0) {
> -				printk(KERN_ERR "dtc436e probe: activate failed\n");
> -				pnp_device_detach(dev);
> -				continue;
> -			}
> -			if (!pnp_port_valid(dev, 0)) {
> -				printk(KERN_ERR "dtc436e probe: no valid port\n");
> -				pnp_device_detach(dev);
> -				continue;
> -			}
> -			if (pnp_irq_valid(dev, 0))
> -				card.irq = pnp_irq(dev, 0);
> -			else
> -				card.irq = NO_IRQ;
> -			if (pnp_dma_valid(dev, 0))
> -				card.dma = pnp_dma(dev, 0);
> -			else
> -				card.dma = DMA_NONE;
> -			card.NCR5380_map_name = (NCR5380_map_type) pnp_port_start(dev, 0);
> -			card.board = BOARD_DTC3181E;
> -			break;
> -		}
> -	}
> -#endif
> -
> -	if (!(card.NCR5380_map_name))
> -		return 0;
> -
>  	ports = NULL;
>  	flags = 0;
> -	switch (card.board) {
> +	switch (board) {
>  	case BOARD_NCR5380:
>  		flags = FLAG_NO_PSEUDO_DMA | FLAG_DMA_FIXUP;
>  		break;
> @@ -191,17 +148,20 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  		magic_configure(-1, 0, magic);
>  
>  		region_size = 16;
> -
> -		if (card.NCR5380_map_name != PORT_AUTO)
> +		if (base)
>  			for (i = 0; ports[i]; i++) {
> -				if (!request_region(ports[i], region_size, "ncr53c80"))
> -					continue;
> -				if (card.NCR5380_map_name == ports[i])
> +				if (base == ports[i]) {	/* index found */
> +					if (!request_region(ports[i],
> +							    region_size,
> +							    "ncr53c80"))
> +						return -EBUSY;
>  					break;
> -				release_region(ports[i], region_size);
> -		} else
> +				}
> +			}
> +		else
>  			for (i = 0; ports[i]; i++) {
> -				if (!request_region(ports[i], region_size, "ncr53c80"))
> +				if (!request_region(ports[i], region_size,
> +						    "ncr53c80"))
>  					continue;
>  				if (inb(ports[i]) == 0xff)
>  					break;
> @@ -211,39 +171,41 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  			/* At this point we have our region reserved */
>  			magic_configure(i, 0, magic); /* no IRQ yet */
>  			outb(0xc0, ports[i] + 9);
> -			if (inb(ports[i] + 9) != 0x80)
> -				return 0;
> -			card.NCR5380_map_name = ports[i];
> +			if (inb(ports[i] + 9) != 0x80) {
> +				ret = -ENODEV;
> +				goto out_release;
> +			}
> +			base = ports[i];
>  			port_idx = i;
>  		} else
> -			return 0;
> +			return -EINVAL;
>  	}
>  	else
>  	{
> -		/* Not a 53C400A style setup - just grab */
> +		/* NCR5380 - no configuration, just grab */
>  		region_size = 8;
> -		if (!request_region(card.NCR5380_map_name,
> -		                    region_size, "ncr5380"))
> -			return 0;
> +		if (!base || !request_region(base, region_size, "ncr5380"))
> +			return -EBUSY;
>  	}
>  #else
> -	base = card.NCR5380_map_name;
>  	iomem_size = NCR53C400_region_size;
>  	if (!request_mem_region(base, iomem_size, "ncr5380"))
> -		return 0;
> +		return -EBUSY;
>  	iomem = ioremap(base, iomem_size);
>  	if (!iomem) {
>  		release_mem_region(base, iomem_size);
> -		return 0;
> +		return -ENOMEM;
>  	}
>  #endif
> -	instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
> -	if (instance == NULL)
> +	instance = scsi_host_alloc(tpnt, sizeof(struct NCR5380_hostdata));
> +	if (instance == NULL) {
> +		ret = -ENOMEM;
>  		goto out_release;
> +	}
>  	hostdata = shost_priv(instance);
>  
>  #ifndef SCSI_G_NCR5380_MEM
> -	instance->io_port = card.NCR5380_map_name;
> +	instance->io_port = base;
>  	instance->n_io_port = region_size;
>  	hostdata->io_width = 1; /* 8-bit PDMA by default */
>  
> @@ -251,7 +213,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  	 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
>  	 * the base address.
>  	 */
> -	switch (card.board) {
> +	switch (board) {
>  	case BOARD_NCR53C400:
>  		instance->io_port += 8;
>  		hostdata->c400_ctl_status = 0;
> @@ -269,10 +231,10 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  		break;
>  	}
>  #else
> -	instance->base = card.NCR5380_map_name;
> +	instance->base = base;
>  	hostdata->iomem = iomem;
>  	hostdata->iomem_size = iomem_size;
> -	switch (card.board) {
> +	switch (board) {
>  	case BOARD_NCR53C400:
>  		hostdata->c400_ctl_status = 0x100;
>  		hostdata->c400_blk_cnt = 0x101;
> @@ -282,14 +244,16 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  	case BOARD_NCR53C400A:
>  	case BOARD_HP_C2502:
>  		pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
> +		ret = -EINVAL;
>  		goto out_unregister;
>  	}
>  #endif
>  
> -	if (NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP))
> +	ret = NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP);
> +	if (ret)
>  		goto out_unregister;
>  
> -	switch (card.board) {
> +	switch (board) {
>  	case BOARD_NCR53C400:
>  	case BOARD_DTC3181E:
>  	case BOARD_NCR53C400A:
> @@ -299,8 +263,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  
>  	NCR5380_maybe_reset_bus(instance);
>  
> -	if (card.irq != IRQ_AUTO)
> -		instance->irq = card.irq;
> +	if (irq != IRQ_AUTO)
> +		instance->irq = irq;
>  	else
>  		instance->irq = NCR5380_probe_irq(instance, 0xffff);
>  
> @@ -311,7 +275,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  	if (instance->irq != NO_IRQ) {
>  #ifndef SCSI_G_NCR5380_MEM
>  		/* set IRQ for HP C2502 */
> -		if (card.board == BOARD_HP_C2502)
> +		if (board == BOARD_HP_C2502)
>  			magic_configure(port_idx, instance->irq, magic);
>  #endif
>  		if (request_irq(instance->irq, generic_NCR5380_intr,
> @@ -326,31 +290,32 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  		printk(KERN_INFO "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
>  	}
>  
> -	return 1;
> +	ret = scsi_add_host(instance, pdev);
> +	if (ret)
> +		goto out_free_irq;
> +	scsi_scan_host(instance);
> +	dev_set_drvdata(pdev, instance);
> +	return 0;
>  
> +out_free_irq:
> +	if (instance->irq != NO_IRQ)
> +		free_irq(instance->irq, instance);
> +	NCR5380_exit(instance);
>  out_unregister:
> -	scsi_unregister(instance);
> +	scsi_host_put(instance);
>  out_release:
>  #ifndef SCSI_G_NCR5380_MEM
> -	release_region(card.NCR5380_map_name, region_size);
> +	release_region(base, region_size);
>  #else
>  	iounmap(iomem);
>  	release_mem_region(base, iomem_size);
>  #endif
> -	return 0;
> +	return ret;
>  }
>  
> -/**
> - *	generic_NCR5380_release_resources	-	free resources
> - *	@instance: host adapter to clean up 
> - *
> - *	Free the generic interface resources from this adapter.
> - *
> - *	Locks: none
> - */
> - 
> -static int generic_NCR5380_release_resources(struct Scsi_Host *instance)
> +static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
>  {
> +	scsi_remove_host(instance);
>  	if (instance->irq != NO_IRQ)
>  		free_irq(instance->irq, instance);
>  	NCR5380_exit(instance);
> @@ -364,7 +329,7 @@ static int generic_NCR5380_release_resources(struct Scsi_Host *instance)
>  		release_mem_region(instance->base, hostdata->iomem_size);
>  	}
>  #endif
> -	return 0;
> +	scsi_host_put(instance);
>  }
>  
>  /**
> @@ -554,10 +519,9 @@ static int generic_NCR5380_dma_xfer_len(struct Scsi_Host *instance,
>  #include "NCR5380.c"
>  
>  static struct scsi_host_template driver_template = {
> +	.module			= THIS_MODULE,
>  	.proc_name		= DRV_MODULE_NAME,
>  	.name			= "Generic NCR5380/NCR53C400 SCSI",
> -	.detect			= generic_NCR5380_detect,
> -	.release		= generic_NCR5380_release_resources,
>  	.info			= generic_NCR5380_info,
>  	.queuecommand		= generic_NCR5380_queue_command,
>  	.eh_abort_handler	= generic_NCR5380_abort,
> @@ -571,26 +535,115 @@ static struct scsi_host_template driver_template = {
>  	.max_sectors		= 128,
>  };
>  
> -#include "scsi_module.c"
>  
> -module_param(ncr_irq, int, 0);
> -module_param(ncr_dma, int, 0);
> -module_param(ncr_addr, int, 0);
> -module_param(ncr_5380, int, 0);
> -module_param(ncr_53c400, int, 0);
> -module_param(ncr_53c400a, int, 0);
> -module_param(dtc_3181e, int, 0);
> -module_param(hp_c2502, int, 0);
> -MODULE_LICENSE("GPL");
> +static int generic_NCR5380_isa_match(struct device *pdev, unsigned int ndev)
> +{
> +	int ret = generic_NCR5380_init_one(&driver_template, pdev, base[ndev],
> +					  irq[ndev], card[ndev]);
> +	if (ret) {
> +		if (base[ndev])
> +			printk(KERN_WARNING "Card not found at address 0x%03x\n",
> +			       base[ndev]);
> +		return 0;
> +	}
>  
> -#if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
> -static struct isapnp_device_id id_table[] = {
> -	{
> -	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
> -	 ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e),
> -	 0},
> -	{0}
> +	return 1;
> +}
> +
> +static int generic_NCR5380_isa_remove(struct device *pdev,
> +				   unsigned int ndev)
> +{
> +	generic_NCR5380_release_resources(dev_get_drvdata(pdev));
> +	dev_set_drvdata(pdev, NULL);
> +	return 0;
> +}
> +
> +static struct isa_driver generic_NCR5380_isa_driver = {
> +	.match		= generic_NCR5380_isa_match,
> +	.remove		= generic_NCR5380_isa_remove,
> +	.driver		= {
> +		.name	= DRV_MODULE_NAME
> +	},
> +};
> +
> +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> +static struct pnp_device_id generic_NCR5380_pnp_ids[] = {
> +	{ .id = "DTC436e", .driver_data = BOARD_DTC3181E },
> +	{ .id = "" }
> +};
> +MODULE_DEVICE_TABLE(pnp, generic_NCR5380_pnp_ids);
> +
> +static int generic_NCR5380_pnp_probe(struct pnp_dev *pdev,
> +			       const struct pnp_device_id *id)
> +{
> +	int base, irq;
> +
> +	if (pnp_activate_dev(pdev) < 0)
> +		return -EBUSY;
> +
> +	base = pnp_port_start(pdev, 0);
> +	irq = pnp_irq(pdev, 0);
> +
> +	return generic_NCR5380_init_one(&driver_template, &pdev->dev, base, irq,
> +				       id->driver_data);
> +}
> +
> +static void generic_NCR5380_pnp_remove(struct pnp_dev *pdev)
> +{
> +	generic_NCR5380_release_resources(pnp_get_drvdata(pdev));
> +	pnp_set_drvdata(pdev, NULL);
> +}
> +
> +static struct pnp_driver generic_NCR5380_pnp_driver = {
> +	.name		= DRV_MODULE_NAME,
> +	.id_table	= generic_NCR5380_pnp_ids,
> +	.probe		= generic_NCR5380_pnp_probe,
> +	.remove		= generic_NCR5380_pnp_remove,
>  };
> +#endif /* !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP) */
>  
> -MODULE_DEVICE_TABLE(isapnp, id_table);
> +static int pnp_registered, isa_registered;
> +
> +static int __init generic_NCR5380_init(void)
> +{
> +	int ret = 0;
> +
> +	/* compatibility with old-style parameters */
> +	if (irq[0] == 0 && base[0] == 0 && card[0] == -1) {
> +		irq[0] = ncr_irq;
> +		base[0] = ncr_addr;
> +		if (ncr_5380)
> +			card[0] = BOARD_NCR5380;
> +		if (ncr_53c400)
> +			card[0] = BOARD_NCR53C400;
> +		if (ncr_53c400a)
> +			card[0] = BOARD_NCR53C400A;
> +		if (dtc_3181e)
> +			card[0] = BOARD_DTC3181E;
> +		if (hp_c2502)
> +			card[0] = BOARD_HP_C2502;
> +	}
> +
> +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> +	if (!pnp_register_driver(&generic_NCR5380_pnp_driver))
> +		pnp_registered = 1;
>  #endif
> +	ret = isa_register_driver(&generic_NCR5380_isa_driver, MAX_CARDS);
> +	if (!ret)
> +		isa_registered = 1;
> +
> +	return (pnp_registered || isa_registered) ? 0 : ret;
> +}
> +
> +static void __exit generic_NCR5380_exit(void)
> +{
> +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> +	if (pnp_registered)
> +		pnp_unregister_driver(&generic_NCR5380_pnp_driver);
> +#endif
> +	if (isa_registered)
> +		isa_unregister_driver(&generic_NCR5380_isa_driver);
> +}
> +
> +module_init(generic_NCR5380_init);
> +module_exit(generic_NCR5380_exit);
> diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
> index 5951774..b175b92 100644
> --- a/drivers/scsi/g_NCR5380.h
> +++ b/drivers/scsi/g_NCR5380.h
> @@ -14,15 +14,9 @@
>  #ifndef GENERIC_NCR5380_H
>  #define GENERIC_NCR5380_H
>  
> -#define __STRVAL(x) #x
> -#define STRVAL(x) __STRVAL(x)
> -
>  #ifndef SCSI_G_NCR5380_MEM
>  #define DRV_MODULE_NAME "g_NCR5380"
>  
> -#define NCR5380_map_type int
> -#define NCR5380_map_name port
> -
>  #define NCR5380_read(reg) \
>  	inb(instance->io_port + (reg))
>  #define NCR5380_write(reg, value) \
> @@ -38,8 +32,6 @@
>  /* therefore SCSI_G_NCR5380_MEM */
>  #define DRV_MODULE_NAME "g_NCR5380_mmio"
>  
> -#define NCR5380_map_type unsigned long
> -#define NCR5380_map_name base
>  #define NCR53C400_mem_base 0x3880
>  #define NCR53C400_host_buffer 0x3900
>  #define NCR53C400_region_size 0x3a00
> 
