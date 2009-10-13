From: Alok Kataria <akataria@vmware.com>
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
Date: Tue, 13 Oct 2009 14:28:14 -0700
Message-ID: <1255469294.12792.93.camel@ank32.eng.vmware.com>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
	 <1254789028.15233.54.camel@ank32.eng.vmware.com>
	 <20091013053726.GE17547@sequoia.sous-sol.org>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934386AbZJMV2y@vger.kernel.org>
In-Reply-To: <20091013053726.GE17547@sequoia.sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Brian King <brking@linux.vnet.ibm.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Robert Love <robert.w.love@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>, "virtualization@lists.linux-foundataion.org" <virtualization@lists.linux-foundataion.org>
List-Id: linux-scsi@vger.kernel.org

Hi Chris,

Thanks for taking a look. 

On Mon, 2009-10-12 at 22:37 -0700, Chris Wright wrote:
> mostly just nits
> 
> * Alok Kataria (akataria@vmware.com) wrote:
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> 
> shouldn't be needed
> 
> > +#include <linux/types.h>
> 
> shouldn't be needed

Removed.
> 
> > +#include <linux/interrupt.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/pci.h>
> > +
> > +#include <scsi/scsi.h>
> > +#include <scsi/scsi_host.h>
> > +#include <scsi/scsi_cmnd.h>
> > +#include <scsi/scsi_device.h>
> > +
> > +#include "vmw_pvscsi.h"
> > +
> > +#define PVSCSI_LINUX_DRIVER_DESC "VMware PVSCSI driver"
> > +
> > +MODULE_DESCRIPTION(PVSCSI_LINUX_DRIVER_DESC);
> > +MODULE_AUTHOR("VMware, Inc.");
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION(PVSCSI_DRIVER_VERSION_STRING);
> > +
> > +#define PVSCSI_DEFAULT_NUM_PAGES_PER_RING    8
> > +#define PVSCSI_DEFAULT_NUM_PAGES_MSG_RING    1
> > +#define PVSCSI_DEFAULT_QUEUE_DEPTH           64
> > +#define SGL_SIZE                             PAGE_SIZE
> > +
> > +#define pvscsi_dev(adapter) (&(adapter->dev->dev))
> 
> easy to make it static inline and get some type checking for free

Done.

> 
> > +
> > +static struct pvscsi_ctx *
> > +pvscsi_acquire_context(struct pvscsi_adapter *adapter, struct scsi_cmnd *cmd)
> > +{
> > +     struct pvscsi_ctx *ctx;
> > +
> > +     if (list_empty(&adapter->cmd_pool))
> > +             return NULL;
> > +
> > +     ctx = list_first_entry(&adapter->cmd_pool, struct pvscsi_ctx, list);
> > +     ctx->cmd = cmd;
> > +     list_del(&ctx->list);
> > +
> > +     return ctx;
> > +}
> > +
> > +static void pvscsi_release_context(struct pvscsi_adapter *adapter,
> > +                                struct pvscsi_ctx *ctx)
> > +{
> > +     ctx->cmd = NULL;
> > +     list_add(&ctx->list, &adapter->cmd_pool);
> > +}
> 
> These list manipulations are protected by hw_lock?  Looks like all cases
> are covered.
> 

Yep. 

> <snip>
> > +/*
> > + * Allocate scatter gather lists.
> > + *
> > + * These are statically allocated.  Trying to be clever was not worth it.
> > + *
> > + * Dynamic allocation can fail, and we can't go deeep into the memory
> > + * allocator, since we're a SCSI driver, and trying too hard to allocate
> > + * memory might generate disk I/O.  We also don't want to fail disk I/O
> > + * in that case because we can't get an allocation - the I/O could be
> > + * trying to swap out data to free memory.  Since that is pathological,
> > + * just use a statically allocated scatter list.
> > + *
> > + */
> > +static int __devinit pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
> > +{
> > +     struct pvscsi_ctx *ctx;
> > +     int i;
> > +
> > +     ctx = adapter->cmd_map;
> > +     BUILD_BUG_ON(sizeof(struct pvscsi_sg_list) > SGL_SIZE);
> > +
> > +     for (i = 0; i < adapter->req_depth; ++i, ++ctx) {
> > +             ctx->sgl = kmalloc(SGL_SIZE, GFP_KERNEL);
> > +             ctx->sglPA = 0;
> > +             BUG_ON(!IS_ALIGNED(((unsigned long)ctx->sgl), PAGE_SIZE));
> 
> Why not simply allocate a page?  Seems different allocator or debugging
> options could trigger this.

Done.

> > +
> > +static int __devinit pvscsi_probe(struct pci_dev *pdev,
> > +                               const struct pci_device_id *id)
> > +{
> > +     struct pvscsi_adapter *adapter;
> > +     struct Scsi_Host *host;
> > +     unsigned int i;
> > +     int error;
> > +
> > +     error = -ENODEV;
> > +
> > +     if (pci_enable_device(pdev))
> > +             return error;
> 
> looks mmio only, pci_enable_device_mem()

We have a IOBAR as well though the driver doesn't use it.
Hence, I will skip this change since it is more future proof this way.
> 
> > +
> > +     if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0 &&
> > +         pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
> > +             printk(KERN_INFO "vmw_pvscsi: using 64bit dma\n");
> > +     } else if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) == 0 &&
> > +                pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) == 0) {
> > +             printk(KERN_INFO "vmw_pvscsi: using 32bit dma\n");
> > +     } else {
> > +             printk(KERN_ERR "vmw_pvscsi: failed to set DMA mask\n");
> > +             goto out_disable_device;
> > +     }
> > +
> > +     pvscsi_template.can_queue =
> > +             min(PVSCSI_MAX_NUM_PAGES_REQ_RING, pvscsi_ring_pages) *
> > +             PVSCSI_MAX_NUM_REQ_ENTRIES_PER_PAGE;
> > +     pvscsi_template.cmd_per_lun =
> > +             min(pvscsi_template.can_queue, pvscsi_cmd_per_lun);
> 
> When/how are these tunables used?  Are they still useful?

cmd_per_lun, is a commandline parameter.

> 
> > +     host = scsi_host_alloc(&pvscsi_template, sizeof(struct pvscsi_adapter));
> > +     if (!host) {
> > +             printk(KERN_ERR "vmw_pvscsi: failed to allocate host\n");
> > +             goto out_disable_device;
> > +     }
> > +
> > +     adapter = shost_priv(host);
> > +     memset(adapter, 0, sizeof(*adapter));
> > +     adapter->dev  = pdev;
> > +     adapter->host = host;
> > +
> > +     spin_lock_init(&adapter->hw_lock);
> > +
> > +     host->max_channel = 0;
> > +     host->max_id      = 16;
> > +     host->max_lun     = 1;
> > +     host->max_cmd_len = 16;
> > +
> > +     adapter->rev = pdev->revision;
> > +
> > +     if (pci_request_regions(pdev, "vmw_pvscsi")) {
> > +             printk(KERN_ERR "vmw_pvscsi: pci memory selection failed\n");
> > +             goto out_free_host;
> > +     }
> > +
> > +     for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> > +             if ((pci_resource_flags(pdev, i) & PCI_BASE_ADDRESS_SPACE_IO))
> > +                     continue;
> > +
> > +             if (pci_resource_len(pdev, i) < PVSCSI_MEM_SPACE_SIZE)
> > +                     continue;
> > +
> > +             break;
> > +     }
> > +
> > +     if (i == DEVICE_COUNT_RESOURCE) {
> > +             printk(KERN_ERR
> > +                    "vmw_pvscsi: adapter has no suitable MMIO region\n");
> > +             goto out_release_resources;
> > +     }
> 
> Could simplify and just do pci_request_selected_regions.

this method is more future proof, that is if we decide to export some
more bars or anything of that sought. So, will keep it as is.
> 
> > +     adapter->mmioBase = pci_iomap(pdev, i, PVSCSI_MEM_SPACE_SIZE);
> > +
> > +     if (!adapter->mmioBase) {
> > +             printk(KERN_ERR
> > +                    "vmw_pvscsi: can't iomap for BAR %d memsize %lu\n",
> > +                    i, PVSCSI_MEM_SPACE_SIZE);
> > +             goto out_release_resources;
> > +     }
> > +
> > +     pci_set_master(pdev);
> > +     pci_set_drvdata(pdev, host);
> > +
> > +     ll_adapter_reset(adapter);
> > +
> > +     adapter->use_msg = pvscsi_setup_msg_workqueue(adapter);
> > +
> > +     error = pvscsi_allocate_rings(adapter);
> > +     if (error) {
> > +             printk(KERN_ERR "vmw_pvscsi: unable to allocate ring memory\n");
> > +             goto out_release_resources;
> > +     }
> > +
> > +     /*
> > +      * From this point on we should reset the adapter if anything goes
> > +      * wrong.
> > +      */
> > +     pvscsi_setup_all_rings(adapter);
> > +
> > +     adapter->cmd_map = kcalloc(adapter->req_depth,
> > +                                sizeof(struct pvscsi_ctx), GFP_KERNEL);
> > +     if (!adapter->cmd_map) {
> > +             printk(KERN_ERR "vmw_pvscsi: failed to allocate memory.\n");
> > +             error = -ENOMEM;
> > +             goto out_reset_adapter;
> > +     }
> > +
> > +     INIT_LIST_HEAD(&adapter->cmd_pool);
> > +     for (i = 0; i < adapter->req_depth; i++) {
> > +             struct pvscsi_ctx *ctx = adapter->cmd_map + i;
> > +             list_add(&ctx->list, &adapter->cmd_pool);
> > +     }
> > +
> > +     error = pvscsi_allocate_sg(adapter);
> > +     if (error) {
> > +             printk(KERN_ERR "vmw_pvscsi: unable to allocate s/g table\n");
> > +             goto out_reset_adapter;
> > +     }
> > +
> > +     if (!pvscsi_disable_msix &&
> > +         pvscsi_setup_msix(adapter, &adapter->irq) == 0) {
> > +             printk(KERN_INFO "vmw_pvscsi: using MSI-X\n");
> > +             adapter->use_msix = 1;
> > +     } else if (!pvscsi_disable_msi && pci_enable_msi(pdev) == 0) {
> > +             printk(KERN_INFO "vmw_pvscsi: using MSI\n");
> > +             adapter->use_msi = 1;
> > +             adapter->irq = pdev->irq;
> > +     } else {
> > +             printk(KERN_INFO "vmw_pvscsi: using INTx\n");
> > +             adapter->irq = pdev->irq;
> > +     }
> > +
> > +     error = request_irq(adapter->irq, pvscsi_isr, IRQF_SHARED,
> > +                         "vmw_pvscsi", adapter);
> 
> Typically IRQF_SHARED w/ INTx, not MSI and MSI-X.
> 

Done. 

Will send a V6 with all the changes. 

Thanks,
Alok
