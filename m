From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller
Date: Sat, 13 Jun 2009 01:50:44 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0906130115440.24868@rslab159.pmc-sierra.bc.ca>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca> <200906111348.02029.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37605 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbZFMJcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2009 05:32:05 -0400
In-Reply-To: <200906111348.02029.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, anil_ravindranath@pmc-sierra.com, gregkh@suse.de

Please see my responses below...

On Thu, 11 Jun 2009, Rolf Eike Beer wrote:

> Anil Ravindranath wrote:
> > Hi,
> >
> > This patch adds a driver to support PMC-Sierra 6Gb/s SAS RAID controller.
> > This patch is created against scsi-misc-2.6.git.
> 
> > +module_param_named(debug, pmcraid_debug, uint, (S_IRUGO | S_IWUSR));
> > +MODULE_PARM_DESC(debug,
> > +		 "Enable driver verbose message logging. Set 1  to enable."
> > +		 "(default: 0)");
> 
> I would say that "1" would enable this is rather obvious. And since this is 
> only 0 or 1 better use bool instead of uint.
> 
This can be changed to bool as well. But in future if we want to add more 
than two values, hence we kept int for now.

> 
> > +static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
> > +{
> > +	struct pmcraid_resource_entry *temp, *res = NULL;
> > +	struct pmcraid_instance *pinstance;
> > +	u8 target, bus, lun;
> > +	unsigned long lock_flags;
> > +	int rc = -ENXIO;
> > +
> > +	pinstance = (struct pmcraid_instance *)scsi_dev->host->hostdata;
> 
> hostdata is void* AFAIR so there is no need to cast. It's C, there is no need 
> to cast to or from void* anywhere if the other thing is a pointer.
> 

Will use shost_priv() here.

> > +static int pmcraid_slave_configure(struct scsi_device *sdev)
> > +{
> > +	struct pmcraid_resource_entry *res = NULL;
> > +
> > +	res = sdev->hostdata;
> 
> No need to initialize res to NULL.
> 
Agreed. Remove initalize to NULL here.

> > +static u32 pmcraid_read_interrupts(struct pmcraid_instance *pinstance)
> > +{
> > +
> > +	return ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
> > +}
> 
> Extra newline.
> 

Will remove extra newline

> > +/**
> > + * pmcraid_disable_interrupts - Masks and clears all specified interrupts
> > + *
> > + * @pinstance: pointer to per adapter instance structure
> > + * @intr: interrupts to disable
> > + *
> > + * Return Value
> > + *	 None
> > + */
> 
> Well, that's rather obvious if it's a void function, isn't it? ;)
> 

Followed commenting convention. Can remove return value. no problem.

> 
> > +static int __devinit pmcraid_probe(
> > +	struct pci_dev *pdev,
> > +	const struct pci_device_id *dev_id
> > +)
> > +{
> > +	struct pmcraid_instance *pinstance;
> > +	struct Scsi_Host *host;
> > +	void __iomem *mapped_pci_addr;
> > +	int rc = PCIBIOS_SUCCESSFUL;
> > +
> > +	if (pmcraid_adapter_count >= PMCRAID_MAX_ADAPTERS) {
> > +		pmcraid_err
> > +			("maximum number(%d) of supported adapters reached\n",
> > +			 pmcraid_adapter_count);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	pmcraid_adapter_count++;
> 
> This counter may need a lock, else you might get into trouble.
> 

I am not sure if we need lock here as we will hit probe serially for every 
controller found.
That said, we will change it to atomic.

> > +	rc = pci_enable_device(pdev);
> 
> Well, I ask it every time, but nevertheless: why not use devres for your 
> driver? It will make error handling in _probe as well as the _release stuff 
> much easier.
>

If we choose devres approach, we will have to make make changes 
accordingly. For now can we stick to pci functions.

> > +	if (rc) {
> > +		dev_err(&pdev->dev, "Cannot enable adapter\n");
> > +		pmcraid_adapter_count--;
> > +		goto out;
> > +	}
> 
> Just "return rc" here. This goto into the middle of the function just for a 
> return is IMHO hard to read.
> 

Will be done.

> > +	dev_info(&pdev->dev,
> > +		"Found IOA(%x:%x) on PCI bus %d slot %d with IRQ: %d\n",
> > +		 pdev->vendor, pdev->device, pdev->bus->number,
> > +		 PCI_SLOT(pdev->bus->number), pdev->irq);
> 

Removed extra pci printing info.

> The IRQ and stuff is printed by request_irq() or such anyway. If you have 
> enabled MSI the IRQ is a different one anyway.
> 
> > +	/* zero out entire instance structure */
> > +	pinstance = (struct pmcraid_instance *)host->hostdata;
> > +	memset(pinstance, 0, sizeof(struct pmcraid_instance));
> 
> memset(pinstance, 0, sizeof(*pinstance));
> 

Done.

> > +	/* Schedule worker thread to handle CCN and take care of adding and
> > +	 * removing devices to OS
> > +	 */
> > +	schedule_work(&pinstance->worker_q);
> > +
> > +out:
> > +	return rc;
> > +
> > +out_remove_host:
> > +	scsi_remove_host(host);
> > +
> > +out_release_bufs:
> > +	pmcraid_release_buffers(pinstance);
> > +
> > +out_unregister_isr:
> > +	pmcraid_kill_tasklets(pinstance);
> > +	pmcraid_unregister_interrupt_handler(pinstance);
> > +
> > +out_scsi_host_put:
> > +	scsi_host_put(host);
> > +
> > +cleanup_nomem:
> > +	iounmap(mapped_pci_addr);
> > +
> > +out_release_regions:
> > +	pci_release_regions(pdev);
> > +
> > +out_disable_device:
> > +	pmcraid_adapter_count--;
> > +	pci_set_drvdata(pdev, NULL);
> > +	pci_disable_device(pdev);
> > +	rc = -ENODEV;
> > +	goto out;
> > +}
> 
> Just "return rc" here. And maybe it's a good idea to just keep the previous rc 
> so you will see it was ENOMEM or whatever.
> 
Will remove goto out and add return -ENODEV if probe fails.

> > +/* PMC PCI vendor ID and device ID values */
> > +#define PCI_VENDOR_ID_PMC			0x11F8
> > +#define PCI_DEVICE_ID_PMC_MAXRAID		0x5220
> > +#define PCI_DEVICE_ID_PMC_0x8010		0x8010
> 
> You could just use the 0x8010 directly at the only place this constant is 
> referenced.
> 

This will be changed once we add device_ids in pci_ids.h

> > +#define IOARCB_LENGTH_CODE(n)         (((n)-3)/8 + (((n)-3)%8 > 0))
> 
> Oh, wow. I needed to throw this into a for loop to understand what you are 
> doing here. Try DIV_ROUND_CLOSEST(n, 8) from include/kernel.h which does right 
> the same.
> 

Done.

> > +/* macros to help in debugging */
> > +#define pmcraid_err(...)  \
> > +	printk(KERN_ERR "MaxRAID: "__VA_ARGS__)
> > +
> > +#define pmcraid_info(...) \
> > +	if (pmcraid_debug) \
> > +		printk(KERN_INFO "MaxRAID: "__VA_ARGS__)
> 
> Those should probably be rewritten to use pr_err() and pr_debug(). Or better 
> use dev_dbg() and dev_info() directly.
> 
I guess we cannot use dev_ functions as we want to print even when dev is 
not initialized. Yes we can use pr_ functions but we want to control
printing by our print/debug flags.

> > +/*
> > + * pmcraid_adapter_id - structure defining the adapter id used by LLD
> > + */
> > +union pmcraid_adapter_id {
> > +	struct {
> > +		u32 slot_no:8;
> 
> Why not use u8?
> 

PMC-sierra managament applications expect this to be an integer.

> > +		u32 bus_number:24;
> > +	} y;
> 
> Greetings,
> 
> Eike
> 
