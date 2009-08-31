From: Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Mon, 31 Aug 2009 10:26:11 -0700
Message-ID: <1251739571.16169.17.camel@ank32.eng.vmware.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <200908280803.52025.eike-kernel@sf-tec.de>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56902 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbZHaR0J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Aug 2009 13:26:09 -0400
In-Reply-To: <200908280803.52025.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Maxime Austruy <maustruy@vmware.com>

Hi Eike,

Thanks a lot for taking a look. Please find my replies inline.

On Thu, 2009-08-27 at 23:03 -0700, Rolf Eike Beer wrote: 
> Alok Kataria wrote:
> > Greetings to all,
> >
> > Please find below a patch which adds support for the VMware
> > paravirtualized SCSI device (PVSCSI).
> 
> > +static const struct pci_device_id pvscsi_pci_tbl[] = {
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_PVSCSI) },
> > +	{ 0 }
> > +};
> 
> This can be written shorter as PCI_VDEVICE(VMWARE, 0x07C0). Putting the device 
> id into the header doesn't get any benefit I see, it just makes harder to 
> collect the pieces together.
Done, I have kept the device id too, for readability.

> It's used only here AFAICT so just write it down 
> here and be done with it. The vendor id might be better places in 
> include/linux/pci_ids.h.
> 
Yes will move it to the header file, right now the VMware vendor id is
also being used by the x86 paravirt-vmi code, will delay that cleanup
till the patch is in mainline, to avoid putting dependency on multiple
trees.

> > +static struct pvscsi_ctx *
> > +pvscsi_acquire_context(struct pvscsi_adapter *adapter, struct scsi_cmnd
> > *cmd) +{
> > +	struct pvscsi_ctx *ctx;
> > +
> > +	if (list_empty(&adapter->cmd_pool))
> > +		return NULL;
> > +
> > +	ctx = list_entry(adapter->cmd_pool.next, struct pvscsi_ctx, list);
> 
> list_first_entry(&adapter->cmd_pool, struct pvscsi_ctx, list);
Done. 
> 
> > +/*
> > + * Map a pvscsi_ctx struct to a context ID field value; we map to a simple
> > + * non-zero integer.
> > + */
> > +static u64 pvscsi_map_context(const struct pvscsi_adapter *adapter,
> > +			      const struct pvscsi_ctx *ctx)
> > +{
> > +	return ctx - adapter->cmd_map + 1;
> > +}
> 
> Is this guaranteed to always be !=0? Maybe add a BUG_ON or WARN_ON here? And 
> if it is guaranteed please add a short comment to say /how/ this works, as 
> just from the first look this is at least suspicious.

ctx always points to an entry in the adapter->cmd_map array. So the
return value can never be less than 1. Will add a comment. 
> 
> > +static void pvscsi_write_cmd_desc(const struct pvscsi_adapter *adapter,
> > +				  u32 cmd, const void *desc, size_t len)
> > +{
> > +	const u32 *ptr = desc;
> > +	unsigned i;
> > +
> > +	len /= sizeof(u32);
> 
> How about sizeof(*ptr)? This would just remove the "magic" knowledge about the 
> size.
> 
Yep, done. 
> > +static int pvscsi_setup_msg_workqueue(struct pvscsi_adapter *adapter)
> > +{
> > +	char name[32];
> > +
> > +	if (!pvscsi_use_msg)
> > +		return 0;
> > +
> > +	pvscsi_reg_write(adapter, PVSCSI_REG_OFFSET_COMMAND,
> > +			 PVSCSI_CMD_SETUP_MSG_RING);
> > +
> > +	if (pvscsi_reg_read(adapter, PVSCSI_REG_OFFSET_COMMAND_STATUS) == -1)
> > +		return 0;
> > +
> > +	snprintf(name, sizeof name, "pvscsi_wq_%u", adapter->host->host_no);
> 
> sizeof(name)
Yep, have put parenthesis for all sizeof usage's.

> 
> > +	adapter->workqueue = create_singlethread_workqueue(name);
> > +	if (!adapter->workqueue) {
> > +		printk(KERN_ERR "pvscsi: failed to create work queue\n");
> > +		return 0;
> > +	}
> > +	INIT_WORK(&adapter->work, pvscsi_msg_workqueue_handler);
> > +
> > +	return 1;
> > +}
> > +
> > +static irqreturn_t pvscsi_isr(int irq, void *devp)
> > +{
> > +	struct pvscsi_adapter *adapter = devp;
> > +	int handled;
> > +
> > +	if (adapter->use_msi || adapter->use_msix)
> > +		handled = true;
> > +	else {
> > +		u32 val = pvscsi_read_intr_status(adapter);
> > +		handled = (val & PVSCSI_INTR_ALL_SUPPORTED) != 0;
> > +		if (handled)
> > +			pvscsi_write_intr_status(devp, val);
> > +	}
> > +
> > +	if (handled) {
> > +		unsigned long flags;
> > +
> > +		spin_lock_irqsave(&adapter->hw_lock, flags);
> > +
> > +		pvscsi_process_completion_ring(adapter);
> > +		if (adapter->use_msg && pvscsi_msg_pending(adapter))
> > +			queue_work(adapter->workqueue, &adapter->work);
> > +
> > +		spin_unlock_irqrestore(&adapter->hw_lock, flags);
> > +	}
> > +
> > +	return IRQ_RETVAL(handled);
> > +}
> > +
> > +static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
> > +{
> > +	struct pvscsi_ctx *ctx = adapter->cmd_map;
> > +	unsigned i;
> > +
> > +	for (i = 0; i < adapter->req_depth; ++i, ++ctx)
> > +		pci_free_consistent(adapter->dev, PAGE_SIZE, ctx->sgl,
> > +				    ctx->sglPA);
> > +}
> > +
> > +static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter, int
> > *irq) +{
> > +#ifdef CONFIG_PCI_MSI
> > +	struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
> > +	int ret;
> > +
> > +	ret = pci_enable_msix(adapter->dev, &entry, 1);
> > +	if (ret)
> > +		return ret;
> > +
> > +	*irq = entry.vector;
> > +
> > +	return 0;
> > +#else
> > +	return -1;
> > +#endif
> > +}
> 
> You don't need those #ifdef's here. If CONFIG_PCI_MSI is not defined 
> pci_enable_msix() is a static inline that always returns -1 (see 
> include/linux/pci.h).

True, removed. 
> 
> > +static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
> > +{
> > +	if (adapter->irq) {
> > +		free_irq(adapter->irq, adapter);
> > +		adapter->irq = 0;
> > +	}
> > +#ifdef CONFIG_PCI_MSI
> > +	if (adapter->use_msi) {
> > +		pci_disable_msi(adapter->dev);
> > +		adapter->use_msi = 0;
> > +	}
> > +
> > +	if (adapter->use_msix) {
> > +		pci_disable_msix(adapter->dev);
> > +		adapter->use_msix = 0;
> > +	}
> > +#endif
> > +}
> 
> Those can go away then too, I think.
Yep. 
> 
> > +static int __devinit pvscsi_probe(struct pci_dev *pdev,
> > +				  const struct pci_device_id *id)
> > +{
> > +	struct pvscsi_adapter *adapter;
> > +	struct Scsi_Host *host;
> > +	unsigned long base, i;
> > +	int error;
> > +
> > +	error = -ENODEV;
> > +
> > +	if (pci_enable_device(pdev))
> > +		return error;
> 
> As always I suggest having a look on devres (see Documentation/driver-
> model/devres.txt) which could simplify your error handling here and your 
> release function a lot. You only need to make sure it doesn't hurt if all the 
> PCI resources are freed after the scsi ones as you would end up cleaning the 
> scsi ones by hand and afterwards devres would throw all it handles (which will 
> probably be most of your PCI stuff) away itself.
> 
I took a quick look, but would prefer not to change this right now. Will
do this as a incremental change later. Hope that is fine.

> > +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0 &&
> > +	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
> > +		printk(KERN_INFO "pvscsi: using 64bit dma\n");
> > +	} else if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) == 0 &&
> > +		   pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) == 0) {
> > +		printk(KERN_INFO "pvscsi: using 32bit dma\n");
> > +	} else {
> > +		printk(KERN_ERR "pvscsi: failed to set DMA mask\n");
> > +		goto out_disable_device;
> > +	}
> > +
> > +	pvscsi_template.can_queue =
> > +		min(PVSCSI_MAX_NUM_PAGES_REQ_RING, pvscsi_ring_pages) *
> > +		PVSCSI_MAX_NUM_REQ_ENTRIES_PER_PAGE;
> > +	pvscsi_template.cmd_per_lun =
> > +		min(pvscsi_template.can_queue, pvscsi_cmd_per_lun);
> > +	host = scsi_host_alloc(&pvscsi_template, sizeof(struct pvscsi_adapter));
> > +	if (!host) {
> > +		printk(KERN_ERR "pvscsi: failed to allocate host\n");
> > +		goto out_disable_device;
> > +	}
> > +
> > +	adapter = shost_priv(host);
> > +	memset(adapter, 0, sizeof *adapter);
> 
> sizeof(*adapter)
> 
> > +	adapter->dev  = pdev;
> > +	adapter->host = host;
> > +
> > +	spin_lock_init(&adapter->hw_lock);
> > +
> > +	host->max_channel = 0;
> > +	host->max_id      = 16;
> > +	host->max_lun     = 1;
> > +
> > +	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &adapter->rev);
> 
> That's in pdev->revision anyway, isn't it?

Yep, though, its needed in pvscsi_info, so will keep this in adapter
too.

> 
> > +	if (pci_request_regions(pdev, "pvscsi")) {
> > +		printk(KERN_ERR "pvscsi: pci memory selection failed\n");
> > +		goto out_free_host;
> > +	}
> > +
> > +	base = 0;
> > +	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> > +		if ((pci_resource_flags(pdev, i) & PCI_BASE_ADDRESS_SPACE_IO))
> > +			continue;
> > +
> > +		if (pci_resource_len(pdev, i) <
> > +					PVSCSI_MEM_SPACE_NUM_PAGES * PAGE_SIZE)
> > +			continue;
> > +
> > +		base = pci_resource_start(pdev, i);
> > +		break;
> > +	}
> > +
> > +	if (base == 0) {
> > +		printk(KERN_ERR "pvscsi: adapter has no suitable MMIO region\n");
> > +		goto out_release_resources;
> > +	}
> > +
> > +	adapter->mmioBase = ioremap(base, PVSCSI_MEM_SPACE_SIZE);
> 
> You are mapping this here with a (probably) different size than the one you 
> checked above.
Actually no, PVSCSI_MEM_SPACE_SIZE is defined as
PVSCSI_MEM_SPACE_NUM_PAGES * PAGE_SIZE.

> Also pci_iomap() could simplify that as you don't have to get 
> the base address and only need to tell it the bar number.

Yeah done. 
> 
> > +	if (!adapter->mmioBase) {
> > +		printk(KERN_ERR "pvscsi: can't ioremap 0x%lx\n", base);
> > +		goto out_release_resources;
> > +	}
> > +
> > +	pci_set_master(pdev);
> > +	pci_set_drvdata(pdev, host);
> > +
> > +	ll_adapter_reset(adapter);
> > +
> > +	adapter->use_msg = pvscsi_setup_msg_workqueue(adapter);
> > +
> > +	error = pvscsi_allocate_rings(adapter);
> > +	if (error) {
> > +		printk(KERN_ERR "pvscsi: unable to allocate ring memory\n");
> > +		goto out_release_resources;
> > +	}
> > +
> > +	/*
> > +	 * From this point on we should reset the adapter if anything goes
> > +	 * wrong.
> > +	 */
> > +	pvscsi_setup_all_rings(adapter);
> > +
> > +	adapter->cmd_map = kmalloc(adapter->req_depth *
> > +				   sizeof(struct pvscsi_ctx), GFP_KERNEL);
> 
> kcalloc(), this will do overflow checking and also clear the memory for you.
Done. 
> 
> 
> > +	printk(KERN_INFO "VMware PVSCSI rev %d on bus:%u slot:%u func:%u host
> > #%u\n", +	       adapter->rev, pdev->bus->number, PCI_SLOT(pdev->devfn),
> > +	       PCI_FUNC(pdev->devfn), host->host_no);
> 
> dev_info(&pdev->dev, ..), this should also give you the PCI 
> domain/bus/slot/function information for free.
> 
Ok. 
> > +static int __init pvscsi_init(void)
> > +{
> > +	printk(KERN_DEBUG "%s - version %s\n",
> > +	       PVSCSI_LINUX_DRIVER_DESC, PVSCSI_DRIVER_VERSION_STRING);
> 
> pr_debug()
Ok.

Will send the V2 patch with all changes.
Thanks again for your comments.

Alok 
> 
> HTH & HAND
> 
> Eike

