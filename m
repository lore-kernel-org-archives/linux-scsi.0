From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mpt fusion: Power Management fixes for MPT SAS PCI-E
	controllers
Date: Mon, 11 Feb 2008 16:54:03 -0600
Message-ID: <1202770443.3122.81.camel@localhost.localdomain>
References: <20080211130629.GA31393@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39009 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244AbYBKWyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 17:54:10 -0500
In-Reply-To: <20080211130629.GA31393@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com, djwong@us.ibm.com

On Mon, 2008-02-11 at 18:36 +0530, Prakash, Sathya wrote:
> This patch was submitted as [PATCH 2/3] yesterday, since it did not reach the
> list due to CC errors sending this again. 
> It is regenerated against new git tree.
> 
> The system power state changes like hibernation and standby are not happening 
> properly with 106XE controllers, this patch modifies the driver to free 
> resources and allocate resources in power management entry points and to enable
>  MSI interrupts for SAS controllers

I really wish you hadn't done this.  Both MSI and suspend/resume are
somewhat bug inducing at the moment.  If you combine both the msi
default change and suspend/resume changes in a single patch, you'll make
it very hard for us to tell which is causing the problem by simple
bisection.

> Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> ---
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index bfda731..b3b80bf 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1429,6 +1429,100 @@ mpt_get_product_name(u16 vendor, u16 device, u8 revision, char *prod_name)
>  		sprintf(prod_name, "%s", product_str);
>  }
>  
> +/**
> + *	mpt_mapresources - map in memory mapped io
> + *	@ioc: Pointer to pointer to IOC adapter
> + *
> + **/
> +static int
> +mpt_mapresources(MPT_ADAPTER *ioc)
> +{
> +	u8		__iomem *mem;
> +	int		 ii;
> +	unsigned long	 mem_phys;
> +	unsigned long	 port;
> +	u32		 msize;
> +	u32		 psize;
> +	u8		 revision;
> +	int		 r = -ENODEV;
> +	struct pci_dev *pdev;
> +
> +	pdev = ioc->pcidev;
> +	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
> +	if (pci_enable_device_mem(pdev)) {
> +		printk(MYIOC_s_ERR_FMT "pci_enable_device_mem() "
> +		    "failed\n", ioc->name);
> +		return r;
> +	}
> +	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
> +		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
> +		    "MEM failed\n", ioc->name);
> +		return r;
> +	}

I can't help noticing that any failure after this point leaves the
driver with the selected regions requested, meaning it can never be
attached again.

> +	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
> +
> +	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)
> +	    && !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
> +		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
> +		    ": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
> +		    ioc->name));
> +	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
> +	    && !pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
> +		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
> +		    ": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
> +		    ioc->name));
> +	} else {
> +		printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
> +		    ioc->name, pci_name(pdev));
> +		return r;
> +	}
> +
> +	mem_phys = msize = 0;
> +	port = psize = 0;
> +	for (ii = 0; ii < DEVICE_COUNT_RESOURCE; ii++) {
> +		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {
> +			if (psize)
> +				continue;
> +			/* Get I/O space! */
> +			port = pci_resource_start(pdev, ii);
> +			psize = pci_resource_len(pdev, ii);
> +		} else {
> +			if (msize)
> +				continue;
> +			/* Get memmap */
> +			mem_phys = pci_resource_start(pdev, ii);
> +			msize = pci_resource_len(pdev, ii);
> +		}
> +	}
> +	ioc->mem_size = msize;
> +
> +	mem = NULL;
> +	/* Get logical ptr for PciMem0 space */
> +	/*mem = ioremap(mem_phys, msize);*/
> +	mem = ioremap(mem_phys, msize);
> +	if (mem == NULL) {
> +		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map adapter"
> +			" memory!\n", ioc->name);
> +		return -EINVAL;
> +	}
> +	ioc->memmap = mem;
> +	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n",
> +	    ioc->name, mem, mem_phys));
> +
> +	ioc->mem_phys = mem_phys;
> +	ioc->chip = (SYSIF_REGS __iomem *)mem;
> +
> +	/* Save Port IO values in case we need to do downloadboot */
> +	{
> +		u8 *pmem = (u8 *)port;
> +		ioc->pio_mem_phys = port;
> +		ioc->pio_chip = (SYSIF_REGS __iomem *)pmem;
> +	}

Why on earth are you doing this; just do

ioc->pio_chip = SYSIF_REGS __iomem *)port;

port is an unsigned long, so it can be promoted to a pointer.

> +	return 0;
> +}
> +
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /**
>   *	mpt_attach - Install a PCI intelligent MPT adapter.
> @@ -1451,13 +1545,6 @@ int
>  mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	MPT_ADAPTER	*ioc;
> -	u8		__iomem *mem;
> -	u8		__iomem *pmem;
> -	unsigned long	 mem_phys;
> -	unsigned long	 port;
> -	u32		 msize;
> -	u32		 psize;
> -	int		 ii;
>  	u8		 cb_idx;
>  	int		 r = -ENODEV;
>  	u8		 revision;
> @@ -1467,52 +1554,33 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  	struct proc_dir_entry *dent, *ent;
>  #endif
>  
> -	if (mpt_debug_level)
> -		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
> -
>  	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
>  	if (ioc == NULL) {
>  		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
>  		return -ENOMEM;
>  	}
> -	ioc->debug_level = mpt_debug_level;
> +
>  	ioc->id = mpt_ids++;
>  	sprintf(ioc->name, "ioc%d", ioc->id);
> +	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
> +
> +	/*
> +	 * set initial debug level
> +	 * (refer to mptdebug.h)
> +	 */
> +	ioc->debug_level = mpt_debug_level;
> +	if (mpt_debug_level)
> +		printk(KERN_INFO "mpt_debug_level=%xh\n", mpt_debug_level);
>  
> -	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
> -	if (pci_enable_device_mem(pdev)) {
> -		kfree(ioc);
> -		printk(MYIOC_s_ERR_FMT "pci_enable_device_mem() "
> -		       "failed\n", ioc->name);
> -		return r;
> -	}
> -	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
> -		kfree(ioc);
> -		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
> -		       "MEM failed\n", ioc->name);
> -		return r;
> -	}
>  
>  	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": mpt_adapter_install\n", ioc->name));
>  
> -	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
> -		dprintk(ioc, printk(MYIOC_s_INFO_FMT
> -			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n", ioc->name));
> -	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
> -		printk(MYIOC_s_WARN_FMT ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n",
> -		    ioc->name);
> +	ioc->pcidev = pdev;
> +	if (mpt_mapresources(ioc)) {
>  		kfree(ioc);
>  		return r;
>  	}
>  
> -	if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
> -		dprintk(ioc, printk(MYIOC_s_INFO_FMT
> -			": Using 64 bit consistent mask\n", ioc->name));
> -	} else {
> -		dprintk(ioc, printk(MYIOC_s_INFO_FMT
> -			": Not using 64 bit consistent mask\n", ioc->name));
> -	}
> -
>  	ioc->alloc_total = sizeof(MPT_ADAPTER);
>  	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
>  	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
> @@ -1550,48 +1618,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  	/* Find lookup slot. */
>  	INIT_LIST_HEAD(&ioc->list);
>  
> -	mem_phys = msize = 0;
> -	port = psize = 0;
> -	for (ii=0; ii < DEVICE_COUNT_RESOURCE; ii++) {
> -		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {
> -			if (psize)
> -				continue;
> -			/* Get I/O space! */
> -			port = pci_resource_start(pdev, ii);
> -			psize = pci_resource_len(pdev,ii);
> -		} else {
> -			if (msize)
> -				continue;
> -			/* Get memmap */
> -			mem_phys = pci_resource_start(pdev, ii);
> -			msize = pci_resource_len(pdev,ii);
> -		}
> -	}
> -	ioc->mem_size = msize;
> -
> -	mem = NULL;
> -	/* Get logical ptr for PciMem0 space */
> -	/*mem = ioremap(mem_phys, msize);*/
> -	mem = ioremap(mem_phys, msize);
> -	if (mem == NULL) {
> -		printk(MYIOC_s_ERR_FMT "Unable to map adapter memory!\n", ioc->name);
> -		kfree(ioc);
> -		return -EINVAL;
> -	}
> -	ioc->memmap = mem;
> -	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n", ioc->name, mem, mem_phys));
> -
>  	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
>  	    ioc->name, &ioc->facts, &ioc->pfacts[0]));
>  
> -	ioc->mem_phys = mem_phys;
> -	ioc->chip = (SYSIF_REGS __iomem *)mem;
> -
> -	/* Save Port IO values in case we need to do downloadboot */
> -	ioc->pio_mem_phys = port;
> -	pmem = (u8 __iomem *)port;
> -	ioc->pio_chip = (SYSIF_REGS __iomem *)pmem;
> -
>  	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
>  	mpt_get_product_name(pdev->vendor, pdev->device, revision, ioc->prod_name);
>  
> @@ -1652,6 +1681,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  	case MPI_MANUFACTPAGE_DEVID_SAS1064:
>  	case MPI_MANUFACTPAGE_DEVID_SAS1068:
>  		ioc->errata_flag_1064 = 1;
> +		ioc->bus_type = SAS;
> +		break;

This is a bit pointless, isn't it?  The old code just dropped through
the case to set the bus_type anyway.

>  	case MPI_MANUFACTPAGE_DEVID_SAS1064E:
>  	case MPI_MANUFACTPAGE_DEVID_SAS1068E:
> @@ -1659,6 +1690,11 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  		ioc->bus_type = SAS;
>  	}
>  
> +	if (ioc->bus_type == SAS)
> +		ioc->msi_enable = 1;
> +	else
> +		ioc->msi_enable = mpt_msi_enable;
> +

This would give no way to disable msi for a SAS chip ... You could do
better by making mpt_msi_enable initialised to -1; then if it's still -1
you set the default (0 for non-SAS, 1 for SAS) otherwise, you know the
user must have specified it, so you always take the override.

>  	if (ioc->errata_flag_1064)
>  		pci_disable_io_access(pdev);
>  
> @@ -1687,7 +1723,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  		list_del(&ioc->list);
>  		if (ioc->alt_ioc)
>  			ioc->alt_ioc->alt_ioc = NULL;
> -		iounmap(mem);
> +		iounmap(ioc->memmap);
>  		kfree(ioc);
>  		pci_set_drvdata(pdev, NULL);
>  		return r;
> @@ -1776,20 +1812,17 @@ mpt_detach(struct pci_dev *pdev)
>   *	mpt_suspend - Fusion MPT base driver suspend routine.
>   *	@pdev: Pointer to pci_dev structure
>   *	@state: new state to enter
> - */
> + **/

Actually, no; docbook tags end with */ not **/

>  int
>  mpt_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>  	u32 device_state;
>  	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
>  
> -	device_state=pci_choose_state(pdev, state);
> -
> -	printk(MYIOC_s_INFO_FMT
> -	"pci-suspend: pdev=0x%p, slot=%s, Entering operating state [D%d]\n",
> -		ioc->name, pdev, pci_name(pdev), device_state);
> -
> -	pci_save_state(pdev);
> +	device_state = pci_choose_state(pdev, state);
> +	printk(MYIOC_s_INFO_FMT "pci-suspend: pdev=0x%p, slot=%s, Entering "
> +	    "operating state [D%d]\n", ioc->name, pdev, pci_name(pdev),
> +	    device_state);
>  
>  	/* put ioc into READY_STATE */
>  	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
> @@ -1804,10 +1837,14 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
>  	/* Clear any lingering interrupt */
>  	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
>  
> +	free_irq(ioc->pci_irq, ioc);
> +	if (ioc->msi_enable)
> +		pci_disable_msi(ioc->pcidev);
> +	ioc->pci_irq = -1;
> +	pci_save_state(pdev);
>  	pci_disable_device(pdev);
>  	pci_release_selected_regions(pdev, ioc->bars);
>  	pci_set_power_state(pdev, device_state);
> -
>  	return 0;
>  }
>  
> @@ -1822,48 +1859,54 @@ mpt_resume(struct pci_dev *pdev)
>  	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
>  	u32 device_state = pdev->current_state;
>  	int recovery_state;
> +	int err;
>  
> -	printk(MYIOC_s_INFO_FMT
> -	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
> -		ioc->name, pdev, pci_name(pdev), device_state);
> +	printk(MYIOC_s_INFO_FMT "pci-resume: pdev=0x%p, slot=%s, Previous "
> +	    "operating state [D%d]\n", ioc->name, pdev, pci_name(pdev),
> +	    device_state);
>  
> -	pci_set_power_state(pdev, 0);
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_enable_wake(pdev, PCI_D0, 0);
>  	pci_restore_state(pdev);
> -	if (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_FW_DOWNLOAD_BOOT) {
> -		ioc->bars = pci_select_bars(ioc->pcidev, IORESOURCE_MEM |
> -			IORESOURCE_IO);
> -		if (pci_enable_device(pdev))
> -			return 0;
> -	} else {
> -		ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
> -		if (pci_enable_device_mem(pdev))
> -			return 0;
> -	}
> -	if (pci_request_selected_regions(pdev, ioc->bars, "mpt"))
> -		return 0;
> +	ioc->pcidev = pdev;
> +	err = mpt_mapresources(ioc);
> +	if (err)
> +		return err;
>  
> -	/* enable interrupts */
> -	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
> -	ioc->active = 1;
> +	printk(MYIOC_s_INFO_FMT "pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
> +	    ioc->name, (mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
> +	    CHIPREG_READ32(&ioc->chip->Doorbell));
>  
> -	printk(MYIOC_s_INFO_FMT
> -		"pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
> -		ioc->name,
> -		(mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
> -		CHIPREG_READ32(&ioc->chip->Doorbell));
> +	/*
> +	 * Errata workaround for SAS pci express:
> +	 * Upon returning to the D0 state, the contents of the doorbell will be
> +	 * stale data, and this will incorrectly signal to the host driver that
> +	 * the firmware is ready to process mpt commands.   The workaround is
> +	 * to issue a diagnostic reset.
> +	 */
> +	if (ioc->bus_type == SAS && (pdev->device ==
> +	    MPI_MANUFACTPAGE_DEVID_SAS1068E || pdev->device ==
> +	    MPI_MANUFACTPAGE_DEVID_SAS1064E)) {
> +		if (KickStart(ioc, 1, CAN_SLEEP) < 0) {
> +			printk(MYIOC_s_WARN_FMT "pci-resume: Cannot recover\n",
> +			    ioc->name);
> +			goto out;
> +		}
> +	}
>  
>  	/* bring ioc to operational state */
> -	if ((recovery_state = mpt_do_ioc_recovery(ioc,
> -	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
> -		printk(MYIOC_s_INFO_FMT
> -			"pci-resume: Cannot recover, error:[%x]\n",
> -			ioc->name, recovery_state);
> -	} else {
> +	printk(MYIOC_s_INFO_FMT "Sending mpt_do_ioc_recovery\n", ioc->name);
> +	recovery_state = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
> +						 CAN_SLEEP);
> +	if (recovery_state != 0)
> +		printk(MYIOC_s_WARN_FMT "pci-resume: Cannot recover, "
> +		    "error:[%x]\n", ioc->name, recovery_state);
> +	else
>  		printk(MYIOC_s_INFO_FMT
> -			"pci-resume: success\n", ioc->name);
> -	}
> -
> +		    "pci-resume: success\n", ioc->name);
> + out:
>  	return 0;
> +
>  }
>  #endif
>  
> @@ -2020,15 +2063,17 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
>  	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
>  		ioc->pci_irq = -1;
>  		if (ioc->pcidev->irq) {
> -			if (mpt_msi_enable && !pci_enable_msi(ioc->pcidev))
> +			if (ioc->msi_enable && !pci_enable_msi(ioc->pcidev))
>  				printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n",
>  				    ioc->name);
> +			else
> +				ioc->msi_enable = 0;
>  			rc = request_irq(ioc->pcidev->irq, mpt_interrupt,
>  			    IRQF_SHARED, ioc->name, ioc);
>  			if (rc < 0) {
>  				printk(MYIOC_s_ERR_FMT "Unable to allocate "
>  				    "interrupt %d!\n", ioc->name, ioc->pcidev->irq);
> -				if (mpt_msi_enable)
> +				if (ioc->msi_enable)
>  					pci_disable_msi(ioc->pcidev);
>  				return -EBUSY;
>  			}
> @@ -2224,7 +2269,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
>   out:
>  	if ((ret != 0) && irq_allocated) {
>  		free_irq(ioc->pci_irq, ioc);
> -		if (mpt_msi_enable)
> +		if (ioc->msi_enable)
>  			pci_disable_msi(ioc->pcidev);
>  	}
>  	return ret;
> @@ -2406,7 +2451,7 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
>  
>  	if (ioc->pci_irq != -1) {
>  		free_irq(ioc->pci_irq, ioc);
> -		if (mpt_msi_enable)
> +		if (ioc->msi_enable)
>  			pci_disable_msi(ioc->pcidev);
>  		ioc->pci_irq = -1;
>  	}
> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> index d83ea96..52ef673 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -629,7 +629,9 @@ typedef struct _MPT_ADAPTER
>  	dma_addr_t		HostPageBuffer_dma;
>  	int			 mtrr_reg;
>  	struct pci_dev		*pcidev;	/* struct pci_dev pointer */
> -	int			bars;		/* bitmask of BAR's that must be configured */
> +	int			bars;		/* bitmask of BAR's that must
> +						    be configured */
> +	int			msi_enable;
>  	u8			__iomem *memmap;	/* mmap address */
>  	struct Scsi_Host	*sh;		/* Scsi Host pointer */
>  	SpiCfgData		spi_data;	/* Scsi config. data */
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index af1de0c..e509788 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1162,30 +1162,38 @@ mptscsih_shutdown(struct pci_dev *pdev)
>  
>  #ifdef CONFIG_PM
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> -/*
> +/**

This isn't a docbook comment, so it shouldn't have a docbook tag (unless
you want to update the comment to be a docbook conforming one).

>   *	mptscsih_suspend - Fusion MPT scsi driver suspend routine.
>   *
>   *
> - */
> + **/

And likewise, even if you update the comment to be docbook, the end tag
is */

>  int
>  mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
> +	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
> +
> +	scsi_block_requests(ioc->sh);

Is this done because of some suspend problem that causes SCSI commands
to be seen after suspension?  If so it looks like it would be global
rather than fusion specific

> +	flush_scheduled_work();
>  	mptscsih_shutdown(pdev);
>  	return mpt_suspend(pdev,state);
>  }
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> -/*
> +/**
>   *	mptscsih_resume - Fusion MPT scsi driver resume routine.
>   *
>   *
> - */
> + **/
>  int
>  mptscsih_resume(struct pci_dev *pdev)
>  {
> -	return mpt_resume(pdev);
> -}
> +	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
> +	int rc;
>  
> +	rc = mpt_resume(pdev);
> +	scsi_unblock_requests(ioc->sh);
> +	return rc;
> +}
>  #endif

James


