From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [RFC PATCH 1/6] isci: initialization
Date: Fri, 04 Mar 2011 17:35:31 -0600
Message-ID: <1299281731.7041.431.camel@mulgrave.site>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
	 <20110207003440.27040.22825.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759850Ab1CDXfm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2011 18:35:42 -0500
In-Reply-To: <20110207003440.27040.22825.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Sun, 2011-02-06 at 16:34 -0800, Dan Williams wrote:
> Driver and controller initialization.

Firstly, there's a lot of docbook abuse in here:


> +/**
> + * isci_isr() - This function is the interrupt service routine for the
> + *    controller. It schedules the tasklet and returns.
> + * @vec: This parameter specifies the interrupt vector.
> + * @data: This parameter specifies the ISCI host object.
> + *
> + * IRQ_HANDLED if out interrupt otherwise, IRQ_NONE

Unless Randy has fixed it, docbook headers don't allow continuation
lines like this.  Then it's <function_name> - <short description> and
<function_name> shouldn't have braces.

Secondly, could you pass this through lindent; stuff like this:


> +		status = scic_controller_get_handler_methods(
> +			SCIC_MSIX_INTERRUPT_TYPE,
> +			SCI_MSIX_DOUBLE_VECTOR,
> +			handlers
> +			);

and


> +	if (!(scu_index >= 0
> +	      && scu_index < SCI_MAX_CONTROLLERS
> +	      && oem_params != NULL)) {

Keeps leaping out at me.

The headers also need to be standard too:


> +#if !defined(_SCI_HOST_H_)
> +#define _SCI_HOST_H_


should be

#ifdef _SCI_HOST_H
#define _SCI_HOST_H


> +static void isci_host_build_mde(
> +	struct sci_physical_memory_descriptor *mde_struct,
> +	struct coherent_memory_info *mdl_struct)
> +{
> +	unsigned long address = 0;
> +	dma_addr_t dma_addr = 0;
> +
> +	address = (unsigned long)mdl_struct->vaddr;
> +	dma_addr = mdl_struct->dma_handle;
> +
> +	/* to satisfy the alignment. */
> +	if ((address % mde_struct->constant_memory_alignment) != 0) {
> +		int align_offset
> +			= (mde_struct->constant_memory_alignment
> +			   - (address % mde_struct->constant_memory_alignment));
> +		address += align_offset;
> +		dma_addr += align_offset;
> +	}
> +
> +	mde_struct->virtual_address = (void *)address;
> +	mde_struct->physical_address = dma_addr;
> +	mdl_struct->mde = mde_struct;
> +}

This is a weird function.  Why not just do ALIGN(x,
mde_struct->constant_memory_alignment) and further, why not do it in
isci_host_alloc_mdl_struct()?


> +#if defined(CONFIG_PBG_HBA_A0)
> +int isci_si_rev = ISCI_SI_REVA0;
> +#elif defined(CONFIG_PBG_HBA_A2)
> +int isci_si_rev = ISCI_SI_REVA2;
> +#else
> +int isci_si_rev = ISCI_SI_REVB0;
> +#endif

There aren't any config entries for PGB_HBA_X as far as I can see ... is
this just some sort of remnant?


> +static struct isci_host *isci_host_by_id(struct pci_dev *pdev, int id)
> +{
> +	struct isci_host *h;
> +
> +	for_each_isci_host(h, pdev)
> +		if (h->id == id)
> +			return h;
> +	return NULL;
> +}

How many hosts per PCI can their actually be?  Because all this list
based stuff looks a bit heavyweight, and if it's only up to 8 or so, a
fixed size list would be far easier.


> +	for (i = 0; i < num_msix; i++) {
> +		int id = i / SCI_NUM_MSI_X_INT;
> +		struct msix_entry *msix = &pci_info->msix_entries[i];
> +		struct isci_host *isci_host = isci_host_by_id(pdev, id);
> +
> +		BUG_ON(!isci_host);
> +
> +		/* @todo: need to handle error case. */
> +		err = devm_request_irq(&pdev->dev, msix->vector, isci_isr, 0,
> +				       DRV_NAME"-msix", isci_host);
> +		if (!err)
> +			continue;
> +
> +		dev_info(&pdev->dev, "msix setup failed falling back to intx\n");
> +		while (i--) {
> +			id = i / SCI_NUM_MSI_X_INT;
> +			isci_host = isci_host_by_id(pdev, id);
> +			msix = &pci_info->msix_entries[i];
> +			devm_free_irq(&pdev->dev, msix->vector, isci_host);
> +		}
> +		pci_disable_msix(pdev);
> +		goto intx;
> +	}

This is really non-standard error handling.  We usually do the
initialisations inline and the error cleanup out of line with a goto.
Having both in a for loop, with an unwind while causes a double take.


> +#ifdef ISCI_SLAVE_ALLOC
> +extern int ISCI_SLAVE_ALLOC(struct scsi_device *scsi_dev);
> +#endif /* ISCI_SLAVE_ALLOC */
> +
> +#ifdef ISCI_SLAVE_DESTROY
> +extern void ISCI_SLAVE_DESTROY(struct scsi_device *scsi_dev);
> +#endif  /* ISCI_SLAVE_DESTROY */

This is just left over debuuging, right?


> +#include <asm/string.h>

Should be <linux/string.h>


> +struct isci_host {
> +	struct scic_sds_controller *core_controller;
> +	struct scic_controller_handler_methods scic_irq_handlers[SCI_NUM_MSI_X_INT];
> +	union scic_oem_parameters oem_parameters;
> +
> +	int id; /* unique within a given pci device */
> +	struct isci_timer_list timer_list_struct;
> +	void *core_ctrl_memory;
> +	struct dma_pool *dma_pool;
> +	unsigned int dma_pool_alloc_size;
> +	struct isci_phy phys[SCI_MAX_PHYS];
> +
> +	/* isci_ports and sas_ports are implicitly parallel to the
> +	 * ports maintained by the core
> +	 */
> +	struct isci_port isci_ports[SCI_MAX_PORTS];
> +	struct asd_sas_port sas_ports[SCI_MAX_PORTS];
> +	struct sas_ha_struct sas_ha;
> +
> +	int can_queue;
> +	spinlock_t queue_lock;
> +	spinlock_t state_lock;
> +
> +	struct pci_dev *pdev;
> +	u8 sas_addr[SAS_ADDR_SIZE];
> +
> +	enum isci_status status;
> +	struct Scsi_Host *shost;
> +	struct tasklet_struct completion_tasklet;
> +	struct list_head mdl_struct_list;
> +	struct list_head requests_to_complete;
> +	struct list_head requests_to_abort;
> +	struct completion stop_complete;
> +	struct completion start_complete;
> +	spinlock_t scic_lock;
> +	struct isci_host *next;
> +};

The locking in this whole driver is a bit on the heavy side
(particularly when I look at the further patches for the device).  But
basically, I've no idea from this layout what any of these are
protecting.


> +	/* @todo: use both MSI-X interrupts, and don't do indirect
> +	 * calls to the handlers just register direct calls
> +	 */
> +	if (isci_host->pdev->msix_enabled) {
> +		status = scic_controller_get_handler_methods(
> +			SCIC_MSIX_INTERRUPT_TYPE,
> +			SCI_MSIX_DOUBLE_VECTOR,
> +			handlers
> +			);

Agree wholeheartedly with the comment.  The indirect function calling
looks a complete mess.  One question, though:  where is
scic_controller_get_handler_methods() defined?  I can't find it in any
of the six patches.

I also wonder about the tasklet processing stuff ... wouldn't threaded
interrupts be simpler?

James


