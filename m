From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Fri, 28 Aug 2009 08:03:45 +0200
Message-ID: <200908280803.52025.eike-kernel@sf-tec.de>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3717920.ZMyIxS8oHG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751944AbZH1GE7@vger.kernel.org>
In-Reply-To: <1251415060.16297.58.camel@ank32.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akataria@vmware.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>
List-Id: linux-scsi@vger.kernel.org

--nextPart3717920.ZMyIxS8oHG
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Alok Kataria wrote:
> Greetings to all,
>
> Please find below a patch which adds support for the VMware
> paravirtualized SCSI device (PVSCSI).

> +static const struct pci_device_id pvscsi_pci_tbl[] =3D {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_PVSCSI) },
> +	{ 0 }
> +};

This can be written shorter as PCI_VDEVICE(VMWARE, 0x07C0). Putting the dev=
ice=20
id into the header doesn't get any benefit I see, it just makes harder to=20
collect the pieces together. It's used only here AFAICT so just write it do=
wn=20
here and be done with it. The vendor id might be better places in=20
include/linux/pci_ids.h.

> +static struct pvscsi_ctx *
> +pvscsi_acquire_context(struct pvscsi_adapter *adapter, struct scsi_cmnd
> *cmd) +{
> +	struct pvscsi_ctx *ctx;
> +
> +	if (list_empty(&adapter->cmd_pool))
> +		return NULL;
> +
> +	ctx =3D list_entry(adapter->cmd_pool.next, struct pvscsi_ctx, list);

list_first_entry(&adapter->cmd_pool, struct pvscsi_ctx, list);

> +/*
> + * Map a pvscsi_ctx struct to a context ID field value; we map to a simp=
le
> + * non-zero integer.
> + */
> +static u64 pvscsi_map_context(const struct pvscsi_adapter *adapter,
> +			      const struct pvscsi_ctx *ctx)
> +{
> +	return ctx - adapter->cmd_map + 1;
> +}

Is this guaranteed to always be !=3D0? Maybe add a BUG_ON or WARN_ON here? =
And=20
if it is guaranteed please add a short comment to say /how/ this works, as=
=20
just from the first look this is at least suspicious.

> +static void pvscsi_write_cmd_desc(const struct pvscsi_adapter *adapter,
> +				  u32 cmd, const void *desc, size_t len)
> +{
> +	const u32 *ptr =3D desc;
> +	unsigned i;
> +
> +	len /=3D sizeof(u32);

How about sizeof(*ptr)? This would just remove the "magic" knowledge about =
the=20
size.

> +static int pvscsi_setup_msg_workqueue(struct pvscsi_adapter *adapter)
> +{
> +	char name[32];
> +
> +	if (!pvscsi_use_msg)
> +		return 0;
> +
> +	pvscsi_reg_write(adapter, PVSCSI_REG_OFFSET_COMMAND,
> +			 PVSCSI_CMD_SETUP_MSG_RING);
> +
> +	if (pvscsi_reg_read(adapter, PVSCSI_REG_OFFSET_COMMAND_STATUS) =3D=3D -=
1)
> +		return 0;
> +
> +	snprintf(name, sizeof name, "pvscsi_wq_%u", adapter->host->host_no);

sizeof(name)

> +	adapter->workqueue =3D create_singlethread_workqueue(name);
> +	if (!adapter->workqueue) {
> +		printk(KERN_ERR "pvscsi: failed to create work queue\n");
> +		return 0;
> +	}
> +	INIT_WORK(&adapter->work, pvscsi_msg_workqueue_handler);
> +
> +	return 1;
> +}
> +
> +static irqreturn_t pvscsi_isr(int irq, void *devp)
> +{
> +	struct pvscsi_adapter *adapter =3D devp;
> +	int handled;
> +
> +	if (adapter->use_msi || adapter->use_msix)
> +		handled =3D true;
> +	else {
> +		u32 val =3D pvscsi_read_intr_status(adapter);
> +		handled =3D (val & PVSCSI_INTR_ALL_SUPPORTED) !=3D 0;
> +		if (handled)
> +			pvscsi_write_intr_status(devp, val);
> +	}
> +
> +	if (handled) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&adapter->hw_lock, flags);
> +
> +		pvscsi_process_completion_ring(adapter);
> +		if (adapter->use_msg && pvscsi_msg_pending(adapter))
> +			queue_work(adapter->workqueue, &adapter->work);
> +
> +		spin_unlock_irqrestore(&adapter->hw_lock, flags);
> +	}
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
> +static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
> +{
> +	struct pvscsi_ctx *ctx =3D adapter->cmd_map;
> +	unsigned i;
> +
> +	for (i =3D 0; i < adapter->req_depth; ++i, ++ctx)
> +		pci_free_consistent(adapter->dev, PAGE_SIZE, ctx->sgl,
> +				    ctx->sglPA);
> +}
> +
> +static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter, int
> *irq) +{
> +#ifdef CONFIG_PCI_MSI
> +	struct msix_entry entry =3D { 0, PVSCSI_VECTOR_COMPLETION };
> +	int ret;
> +
> +	ret =3D pci_enable_msix(adapter->dev, &entry, 1);
> +	if (ret)
> +		return ret;
> +
> +	*irq =3D entry.vector;
> +
> +	return 0;
> +#else
> +	return -1;
> +#endif
> +}

You don't need those #ifdef's here. If CONFIG_PCI_MSI is not defined=20
pci_enable_msix() is a static inline that always returns -1 (see=20
include/linux/pci.h).

> +static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
> +{
> +	if (adapter->irq) {
> +		free_irq(adapter->irq, adapter);
> +		adapter->irq =3D 0;
> +	}
> +#ifdef CONFIG_PCI_MSI
> +	if (adapter->use_msi) {
> +		pci_disable_msi(adapter->dev);
> +		adapter->use_msi =3D 0;
> +	}
> +
> +	if (adapter->use_msix) {
> +		pci_disable_msix(adapter->dev);
> +		adapter->use_msix =3D 0;
> +	}
> +#endif
> +}

Those can go away then too, I think.

> +static int __devinit pvscsi_probe(struct pci_dev *pdev,
> +				  const struct pci_device_id *id)
> +{
> +	struct pvscsi_adapter *adapter;
> +	struct Scsi_Host *host;
> +	unsigned long base, i;
> +	int error;
> +
> +	error =3D -ENODEV;
> +
> +	if (pci_enable_device(pdev))
> +		return error;

As always I suggest having a look on devres (see Documentation/driver-
model/devres.txt) which could simplify your error handling here and your=20
release function a lot. You only need to make sure it doesn't hurt if all t=
he=20
PCI resources are freed after the scsi ones as you would end up cleaning th=
e=20
scsi ones by hand and afterwards devres would throw all it handles (which w=
ill=20
probably be most of your PCI stuff) away itself.

> +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) =3D=3D 0 &&
> +	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) =3D=3D 0) {
> +		printk(KERN_INFO "pvscsi: using 64bit dma\n");
> +	} else if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) =3D=3D 0 &&
> +		   pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) =3D=3D 0) {
> +		printk(KERN_INFO "pvscsi: using 32bit dma\n");
> +	} else {
> +		printk(KERN_ERR "pvscsi: failed to set DMA mask\n");
> +		goto out_disable_device;
> +	}
> +
> +	pvscsi_template.can_queue =3D
> +		min(PVSCSI_MAX_NUM_PAGES_REQ_RING, pvscsi_ring_pages) *
> +		PVSCSI_MAX_NUM_REQ_ENTRIES_PER_PAGE;
> +	pvscsi_template.cmd_per_lun =3D
> +		min(pvscsi_template.can_queue, pvscsi_cmd_per_lun);
> +	host =3D scsi_host_alloc(&pvscsi_template, sizeof(struct pvscsi_adapter=
));
> +	if (!host) {
> +		printk(KERN_ERR "pvscsi: failed to allocate host\n");
> +		goto out_disable_device;
> +	}
> +
> +	adapter =3D shost_priv(host);
> +	memset(adapter, 0, sizeof *adapter);

sizeof(*adapter)

> +	adapter->dev  =3D pdev;
> +	adapter->host =3D host;
> +
> +	spin_lock_init(&adapter->hw_lock);
> +
> +	host->max_channel =3D 0;
> +	host->max_id      =3D 16;
> +	host->max_lun     =3D 1;
> +
> +	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &adapter->rev);

That's in pdev->revision anyway, isn't it?

> +	if (pci_request_regions(pdev, "pvscsi")) {
> +		printk(KERN_ERR "pvscsi: pci memory selection failed\n");
> +		goto out_free_host;
> +	}
> +
> +	base =3D 0;
> +	for (i =3D 0; i < DEVICE_COUNT_RESOURCE; i++) {
> +		if ((pci_resource_flags(pdev, i) & PCI_BASE_ADDRESS_SPACE_IO))
> +			continue;
> +
> +		if (pci_resource_len(pdev, i) <
> +					PVSCSI_MEM_SPACE_NUM_PAGES * PAGE_SIZE)
> +			continue;
> +
> +		base =3D pci_resource_start(pdev, i);
> +		break;
> +	}
> +
> +	if (base =3D=3D 0) {
> +		printk(KERN_ERR "pvscsi: adapter has no suitable MMIO region\n");
> +		goto out_release_resources;
> +	}
> +
> +	adapter->mmioBase =3D ioremap(base, PVSCSI_MEM_SPACE_SIZE);

You are mapping this here with a (probably) different size than the one you=
=20
checked above. Also pci_iomap() could simplify that as you don't have to ge=
t=20
the base address and only need to tell it the bar number.

> +	if (!adapter->mmioBase) {
> +		printk(KERN_ERR "pvscsi: can't ioremap 0x%lx\n", base);
> +		goto out_release_resources;
> +	}
> +
> +	pci_set_master(pdev);
> +	pci_set_drvdata(pdev, host);
> +
> +	ll_adapter_reset(adapter);
> +
> +	adapter->use_msg =3D pvscsi_setup_msg_workqueue(adapter);
> +
> +	error =3D pvscsi_allocate_rings(adapter);
> +	if (error) {
> +		printk(KERN_ERR "pvscsi: unable to allocate ring memory\n");
> +		goto out_release_resources;
> +	}
> +
> +	/*
> +	 * From this point on we should reset the adapter if anything goes
> +	 * wrong.
> +	 */
> +	pvscsi_setup_all_rings(adapter);
> +
> +	adapter->cmd_map =3D kmalloc(adapter->req_depth *
> +				   sizeof(struct pvscsi_ctx), GFP_KERNEL);

kcalloc(), this will do overflow checking and also clear the memory for you.


> +	printk(KERN_INFO "VMware PVSCSI rev %d on bus:%u slot:%u func:%u host
> #%u\n", +	       adapter->rev, pdev->bus->number, PCI_SLOT(pdev->devfn),
> +	       PCI_FUNC(pdev->devfn), host->host_no);

dev_info(&pdev->dev, ..), this should also give you the PCI=20
domain/bus/slot/function information for free.

> +static int __init pvscsi_init(void)
> +{
> +	printk(KERN_DEBUG "%s - version %s\n",
> +	       PVSCSI_LINUX_DRIVER_DESC, PVSCSI_DRIVER_VERSION_STRING);

pr_debug()

HTH & HAND

Eike

--nextPart3717920.ZMyIxS8oHG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqXc0cACgkQXKSJPmm5/E4jDQCfQpZVkUf2qTuhe/WyKRqK2BFU
T/MAnjOJlZCn9iGIZyX4KlUeBwvJ8oii
=UjJP
-----END PGP SIGNATURE-----

--nextPart3717920.ZMyIxS8oHG--
