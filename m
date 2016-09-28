From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 2/3] g_NCR5380: Reduce overrides[] from array to struct
Date: Thu, 29 Sep 2016 08:57:15 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609290841580.22268@nippy.intranet>
References: <1475002825-18132-1-git-send-email-linux@rainbow-software.org> <1475002825-18132-3-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:60666 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932571AbcI1W46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 18:56:58 -0400
In-Reply-To: <1475002825-18132-3-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Acked-by: Finn Thain <fthain@telegraphics.com.au>

On Tue, 27 Sep 2016, Ondrej Zary wrote:

> Remove compile-time card type definition GENERIC_NCR5380_OVERRIDE.
> Then remove all code iterating the overrides[] array and reduce it to
> struct card.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/scsi/g_NCR5380.c |  351 ++++++++++++++++++++++------------------------
>  1 file changed, 167 insertions(+), 184 deletions(-)
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 7e50b44e..5162de6 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -42,19 +42,12 @@ static int ncr_53c400a;
>  static int dtc_3181e;
>  static int hp_c2502;
>  
> -static struct override {
> +static struct card {
>  	NCR5380_map_type NCR5380_map_name;
>  	int irq;
>  	int dma;
>  	int board;		/* Use NCR53c400, Ricoh, etc. extensions ? */
> -} overrides
> -#ifdef GENERIC_NCR5380_OVERRIDE
> -[] __initdata = GENERIC_NCR5380_OVERRIDE;
> -#else
> -[1] __initdata = { { 0,},};
> -#endif
> -
> -#define NO_OVERRIDES ARRAY_SIZE(overrides)
> +} card;
>  
>  #ifndef SCSI_G_NCR5380_MEM
>  /*
> @@ -85,16 +78,13 @@ static void magic_configure(int idx, u8 irq, u8 magic[])
>   *	@tpnt: the scsi template
>   *
>   *	Scan for the present of NCR5380, NCR53C400, NCR53C400A, DTC3181E
> - *	and DTC436(ISAPnP) controllers. If overrides have been set we use
> - *	them.
> + *	and DTC436(ISAPnP) controllers.
>   *
>   *	Locks: none
>   */
>  
>  static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  {
> -	static int current_override;
> -	int count;
>  	unsigned int *ports;
>  	u8 *magic = NULL;
>  #ifndef SCSI_G_NCR5380_MEM
> @@ -124,28 +114,25 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  #endif
>  
>  	if (ncr_irq)
> -		overrides[0].irq = ncr_irq;
> +		card.irq = ncr_irq;
>  	if (ncr_dma)
> -		overrides[0].dma = ncr_dma;
> +		card.dma = ncr_dma;
>  	if (ncr_addr)
> -		overrides[0].NCR5380_map_name = (NCR5380_map_type) ncr_addr;
> +		card.NCR5380_map_name = (NCR5380_map_type) ncr_addr;
>  	if (ncr_5380)
> -		overrides[0].board = BOARD_NCR5380;
> +		card.board = BOARD_NCR5380;
>  	else if (ncr_53c400)
> -		overrides[0].board = BOARD_NCR53C400;
> +		card.board = BOARD_NCR53C400;
>  	else if (ncr_53c400a)
> -		overrides[0].board = BOARD_NCR53C400A;
> +		card.board = BOARD_NCR53C400A;
>  	else if (dtc_3181e)
> -		overrides[0].board = BOARD_DTC3181E;
> +		card.board = BOARD_DTC3181E;
>  	else if (hp_c2502)
> -		overrides[0].board = BOARD_HP_C2502;
> +		card.board = BOARD_HP_C2502;
>  #ifndef SCSI_G_NCR5380_MEM
> -	if (!current_override && isapnp_present()) {
> +	if (isapnp_present()) {
>  		struct pnp_dev *dev = NULL;
> -		count = 0;
>  		while ((dev = pnp_find_dev(NULL, ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e), dev))) {
> -			if (count >= NO_OVERRIDES)
> -				break;
>  			if (pnp_device_attach(dev) < 0)
>  				continue;
>  			if (pnp_activate_dev(dev) < 0) {
> @@ -159,202 +146,198 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  				continue;
>  			}
>  			if (pnp_irq_valid(dev, 0))
> -				overrides[count].irq = pnp_irq(dev, 0);
> +				card.irq = pnp_irq(dev, 0);
>  			else
> -				overrides[count].irq = NO_IRQ;
> +				card.irq = NO_IRQ;
>  			if (pnp_dma_valid(dev, 0))
> -				overrides[count].dma = pnp_dma(dev, 0);
> +				card.dma = pnp_dma(dev, 0);
>  			else
> -				overrides[count].dma = DMA_NONE;
> -			overrides[count].NCR5380_map_name = (NCR5380_map_type) pnp_port_start(dev, 0);
> -			overrides[count].board = BOARD_DTC3181E;
> -			count++;
> +				card.dma = DMA_NONE;
> +			card.NCR5380_map_name = (NCR5380_map_type) pnp_port_start(dev, 0);
> +			card.board = BOARD_DTC3181E;
> +			break;
>  		}
>  	}
>  #endif
>  
> -	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
> -		if (!(overrides[current_override].NCR5380_map_name))
> -			continue;
> +	if (!(card.NCR5380_map_name))
> +		return 0;
>  
> -		ports = NULL;
> -		flags = 0;
> -		switch (overrides[current_override].board) {
> -		case BOARD_NCR5380:
> -			flags = FLAG_NO_PSEUDO_DMA | FLAG_DMA_FIXUP;
> -			break;
> -		case BOARD_NCR53C400A:
> -			ports = ncr_53c400a_ports;
> -			magic = ncr_53c400a_magic;
> -			break;
> -		case BOARD_HP_C2502:
> -			ports = ncr_53c400a_ports;
> -			magic = hp_c2502_magic;
> -			break;
> -		case BOARD_DTC3181E:
> -			ports = dtc_3181e_ports;
> -			magic = ncr_53c400a_magic;
> -			break;
> -		}
> +	ports = NULL;
> +	flags = 0;
> +	switch (card.board) {
> +	case BOARD_NCR5380:
> +		flags = FLAG_NO_PSEUDO_DMA | FLAG_DMA_FIXUP;
> +		break;
> +	case BOARD_NCR53C400A:
> +		ports = ncr_53c400a_ports;
> +		magic = ncr_53c400a_magic;
> +		break;
> +	case BOARD_HP_C2502:
> +		ports = ncr_53c400a_ports;
> +		magic = hp_c2502_magic;
> +		break;
> +	case BOARD_DTC3181E:
> +		ports = dtc_3181e_ports;
> +		magic = ncr_53c400a_magic;
> +		break;
> +	}
>  
>  #ifndef SCSI_G_NCR5380_MEM
> -		if (ports && magic) {
> -			/* wakeup sequence for the NCR53C400A and DTC3181E */
> -
> -			/* Disable the adapter and look for a free io port */
> -			magic_configure(-1, 0, magic);
> -
> -			region_size = 16;
> -
> -			if (overrides[current_override].NCR5380_map_name != PORT_AUTO)
> -				for (i = 0; ports[i]; i++) {
> -					if (!request_region(ports[i], region_size, "ncr53c80"))
> -						continue;
> -					if (overrides[current_override].NCR5380_map_name == ports[i])
> -						break;
> -					release_region(ports[i], region_size);
> -			} else
> -				for (i = 0; ports[i]; i++) {
> -					if (!request_region(ports[i], region_size, "ncr53c80"))
> -						continue;
> -					if (inb(ports[i]) == 0xff)
> -						break;
> -					release_region(ports[i], region_size);
> -				}
> -			if (ports[i]) {
> -				/* At this point we have our region reserved */
> -				magic_configure(i, 0, magic); /* no IRQ yet */
> -				outb(0xc0, ports[i] + 9);
> -				if (inb(ports[i] + 9) != 0x80)
> +	if (ports && magic) {
> +		/* wakeup sequence for the NCR53C400A and DTC3181E */
> +
> +		/* Disable the adapter and look for a free io port */
> +		magic_configure(-1, 0, magic);
> +
> +		region_size = 16;
> +
> +		if (card.NCR5380_map_name != PORT_AUTO)
> +			for (i = 0; ports[i]; i++) {
> +				if (!request_region(ports[i], region_size, "ncr53c80"))
>  					continue;
> -				overrides[current_override].NCR5380_map_name = ports[i];
> -				port_idx = i;
> -			} else
> -				continue;
> -		}
> -		else
> -		{
> -			/* Not a 53C400A style setup - just grab */
> -			region_size = 8;
> -			if (!request_region(overrides[current_override].NCR5380_map_name,
> -			                    region_size, "ncr5380"))
> -				continue;
> -		}
> +				if (card.NCR5380_map_name == ports[i])
> +					break;
> +				release_region(ports[i], region_size);
> +		} else
> +			for (i = 0; ports[i]; i++) {
> +				if (!request_region(ports[i], region_size, "ncr53c80"))
> +					continue;
> +				if (inb(ports[i]) == 0xff)
> +					break;
> +				release_region(ports[i], region_size);
> +			}
> +		if (ports[i]) {
> +			/* At this point we have our region reserved */
> +			magic_configure(i, 0, magic); /* no IRQ yet */
> +			outb(0xc0, ports[i] + 9);
> +			if (inb(ports[i] + 9) != 0x80)
> +				return 0;
> +			card.NCR5380_map_name = ports[i];
> +			port_idx = i;
> +		} else
> +			return 0;
> +	}
> +	else
> +	{
> +		/* Not a 53C400A style setup - just grab */
> +		region_size = 8;
> +		if (!request_region(card.NCR5380_map_name,
> +		                    region_size, "ncr5380"))
> +			return 0;
> +	}
>  #else
> -		base = overrides[current_override].NCR5380_map_name;
> -		iomem_size = NCR53C400_region_size;
> -		if (!request_mem_region(base, iomem_size, "ncr5380"))
> -			continue;
> -		iomem = ioremap(base, iomem_size);
> -		if (!iomem) {
> -			release_mem_region(base, iomem_size);
> -			continue;
> -		}
> +	base = card.NCR5380_map_name;
> +	iomem_size = NCR53C400_region_size;
> +	if (!request_mem_region(base, iomem_size, "ncr5380"))
> +		return 0;
> +	iomem = ioremap(base, iomem_size);
> +	if (!iomem) {
> +		release_mem_region(base, iomem_size);
> +		return 0;
> +	}
>  #endif
> -		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
> -		if (instance == NULL)
> -			goto out_release;
> -		hostdata = shost_priv(instance);
> +	instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
> +	if (instance == NULL)
> +		goto out_release;
> +	hostdata = shost_priv(instance);
>  
>  #ifndef SCSI_G_NCR5380_MEM
> -		instance->io_port = overrides[current_override].NCR5380_map_name;
> -		instance->n_io_port = region_size;
> -		hostdata->io_width = 1; /* 8-bit PDMA by default */
> -
> -		/*
> -		 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
> -		 * the base address.
> -		 */
> -		switch (overrides[current_override].board) {
> -		case BOARD_NCR53C400:
> -			instance->io_port += 8;
> -			hostdata->c400_ctl_status = 0;
> -			hostdata->c400_blk_cnt = 1;
> -			hostdata->c400_host_buf = 4;
> -			break;
> -		case BOARD_DTC3181E:
> -			hostdata->io_width = 2;	/* 16-bit PDMA */
> -			/* fall through */
> -		case BOARD_NCR53C400A:
> -		case BOARD_HP_C2502:
> -			hostdata->c400_ctl_status = 9;
> -			hostdata->c400_blk_cnt = 10;
> -			hostdata->c400_host_buf = 8;
> -			break;
> -		}
> +	instance->io_port = card.NCR5380_map_name;
> +	instance->n_io_port = region_size;
> +	hostdata->io_width = 1; /* 8-bit PDMA by default */
> +
> +	/*
> +	 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
> +	 * the base address.
> +	 */
> +	switch (card.board) {
> +	case BOARD_NCR53C400:
> +		instance->io_port += 8;
> +		hostdata->c400_ctl_status = 0;
> +		hostdata->c400_blk_cnt = 1;
> +		hostdata->c400_host_buf = 4;
> +		break;
> +	case BOARD_DTC3181E:
> +		hostdata->io_width = 2;	/* 16-bit PDMA */
> +		/* fall through */
> +	case BOARD_NCR53C400A:
> +	case BOARD_HP_C2502:
> +		hostdata->c400_ctl_status = 9;
> +		hostdata->c400_blk_cnt = 10;
> +		hostdata->c400_host_buf = 8;
> +		break;
> +	}
>  #else
> -		instance->base = overrides[current_override].NCR5380_map_name;
> -		hostdata->iomem = iomem;
> -		hostdata->iomem_size = iomem_size;
> -		switch (overrides[current_override].board) {
> -		case BOARD_NCR53C400:
> -			hostdata->c400_ctl_status = 0x100;
> -			hostdata->c400_blk_cnt = 0x101;
> -			hostdata->c400_host_buf = 0x104;
> -			break;
> -		case BOARD_DTC3181E:
> -		case BOARD_NCR53C400A:
> -		case BOARD_HP_C2502:
> -			pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
> -			goto out_unregister;
> -		}
> +	instance->base = card.NCR5380_map_name;
> +	hostdata->iomem = iomem;
> +	hostdata->iomem_size = iomem_size;
> +	switch (card.board) {
> +	case BOARD_NCR53C400:
> +		hostdata->c400_ctl_status = 0x100;
> +		hostdata->c400_blk_cnt = 0x101;
> +		hostdata->c400_host_buf = 0x104;
> +		break;
> +	case BOARD_DTC3181E:
> +	case BOARD_NCR53C400A:
> +	case BOARD_HP_C2502:
> +		pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
> +		goto out_unregister;
> +	}
>  #endif
>  
> -		if (NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP))
> -			goto out_unregister;
> +	if (NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP))
> +		goto out_unregister;
>  
> -		switch (overrides[current_override].board) {
> -		case BOARD_NCR53C400:
> -		case BOARD_DTC3181E:
> -		case BOARD_NCR53C400A:
> -		case BOARD_HP_C2502:
> -			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
> -		}
> +	switch (card.board) {
> +	case BOARD_NCR53C400:
> +	case BOARD_DTC3181E:
> +	case BOARD_NCR53C400A:
> +	case BOARD_HP_C2502:
> +		NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
> +	}
>  
> -		NCR5380_maybe_reset_bus(instance);
> +	NCR5380_maybe_reset_bus(instance);
>  
> -		if (overrides[current_override].irq != IRQ_AUTO)
> -			instance->irq = overrides[current_override].irq;
> -		else
> -			instance->irq = NCR5380_probe_irq(instance, 0xffff);
> +	if (card.irq != IRQ_AUTO)
> +		instance->irq = card.irq;
> +	else
> +		instance->irq = NCR5380_probe_irq(instance, 0xffff);
>  
> -		/* Compatibility with documented NCR5380 kernel parameters */
> -		if (instance->irq == 255)
> -			instance->irq = NO_IRQ;
> +	/* Compatibility with documented NCR5380 kernel parameters */
> +	if (instance->irq == 255)
> +		instance->irq = NO_IRQ;
>  
> -		if (instance->irq != NO_IRQ) {
> +	if (instance->irq != NO_IRQ) {
>  #ifndef SCSI_G_NCR5380_MEM
> -			/* set IRQ for HP C2502 */
> -			if (overrides[current_override].board == BOARD_HP_C2502)
> -				magic_configure(port_idx, instance->irq, magic);
> +		/* set IRQ for HP C2502 */
> +		if (card.board == BOARD_HP_C2502)
> +			magic_configure(port_idx, instance->irq, magic);
>  #endif
> -			if (request_irq(instance->irq, generic_NCR5380_intr,
> -					0, "NCR5380", instance)) {
> -				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
> -				instance->irq = NO_IRQ;
> -			}
> -		}
> -
> -		if (instance->irq == NO_IRQ) {
> -			printk(KERN_INFO "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
> -			printk(KERN_INFO "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
> +		if (request_irq(instance->irq, generic_NCR5380_intr,
> +				0, "NCR5380", instance)) {
> +			printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
> +			instance->irq = NO_IRQ;
>  		}
> +	}
>  
> -		++current_override;
> -		++count;
> +	if (instance->irq == NO_IRQ) {
> +		printk(KERN_INFO "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
> +		printk(KERN_INFO "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
>  	}
> -	return count;
> +
> +	return 1;
>  
>  out_unregister:
>  	scsi_unregister(instance);
>  out_release:
>  #ifndef SCSI_G_NCR5380_MEM
> -	release_region(overrides[current_override].NCR5380_map_name, region_size);
> +	release_region(card.NCR5380_map_name, region_size);
>  #else
>  	iounmap(iomem);
>  	release_mem_region(base, iomem_size);
>  #endif
> -	return count;
> +	return 0;
>  }
>  
>  /**
> 
