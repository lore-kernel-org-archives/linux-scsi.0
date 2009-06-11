From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller
Date: Thu, 11 Jun 2009 13:47:49 +0200
Message-ID: <200906111348.02029.eike-kernel@sf-tec.de>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7380776.hLyUHJ7Qom";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:52067 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbZFKLsJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2009 07:48:09 -0400
In-Reply-To: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, gregkh@suse.de

--nextPart7380776.hLyUHJ7Qom
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Anil Ravindranath wrote:
> Hi,
>
> This patch adds a driver to support PMC-Sierra 6Gb/s SAS RAID controller.
> This patch is created against scsi-misc-2.6.git.

> +module_param_named(debug, pmcraid_debug, uint, (S_IRUGO | S_IWUSR));
> +MODULE_PARM_DESC(debug,
> +		 "Enable driver verbose message logging. Set 1  to enable."
> +		 "(default: 0)");

I would say that "1" would enable this is rather obvious. And since this is=
=20
only 0 or 1 better use bool instead of uint.


> +static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
> +{
> +	struct pmcraid_resource_entry *temp, *res =3D NULL;
> +	struct pmcraid_instance *pinstance;
> +	u8 target, bus, lun;
> +	unsigned long lock_flags;
> +	int rc =3D -ENXIO;
> +
> +	pinstance =3D (struct pmcraid_instance *)scsi_dev->host->hostdata;

hostdata is void* AFAIR so there is no need to cast. It's C, there is no ne=
ed=20
to cast to or from void* anywhere if the other thing is a pointer.

> +static int pmcraid_slave_configure(struct scsi_device *sdev)
> +{
> +	struct pmcraid_resource_entry *res =3D NULL;
> +
> +	res =3D sdev->hostdata;

No need to initialize res to NULL.

> +static u32 pmcraid_read_interrupts(struct pmcraid_instance *pinstance)
> +{
> +
> +	return ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
> +}

Extra newline.

> +/**
> + * pmcraid_disable_interrupts - Masks and clears all specified interrupts
> + *
> + * @pinstance: pointer to per adapter instance structure
> + * @intr: interrupts to disable
> + *
> + * Return Value
> + *	 None
> + */

Well, that's rather obvious if it's a void function, isn't it? ;)


> +static int __devinit pmcraid_probe(
> +	struct pci_dev *pdev,
> +	const struct pci_device_id *dev_id
> +)
> +{
> +	struct pmcraid_instance *pinstance;
> +	struct Scsi_Host *host;
> +	void __iomem *mapped_pci_addr;
> +	int rc =3D PCIBIOS_SUCCESSFUL;
> +
> +	if (pmcraid_adapter_count >=3D PMCRAID_MAX_ADAPTERS) {
> +		pmcraid_err
> +			("maximum number(%d) of supported adapters reached\n",
> +			 pmcraid_adapter_count);
> +		return -ENOMEM;
> +	}
> +
> +	pmcraid_adapter_count++;

This counter may need a lock, else you might get into trouble.

> +	rc =3D pci_enable_device(pdev);

Well, I ask it every time, but nevertheless: why not use devres for your=20
driver? It will make error handling in _probe as well as the _release stuff=
=20
much easier.

> +	if (rc) {
> +		dev_err(&pdev->dev, "Cannot enable adapter\n");
> +		pmcraid_adapter_count--;
> +		goto out;
> +	}

Just "return rc" here. This goto into the middle of the function just for a=
=20
return is IMHO hard to read.

> +	dev_info(&pdev->dev,
> +		"Found IOA(%x:%x) on PCI bus %d slot %d with IRQ: %d\n",
> +		 pdev->vendor, pdev->device, pdev->bus->number,
> +		 PCI_SLOT(pdev->bus->number), pdev->irq);

The IRQ and stuff is printed by request_irq() or such anyway. If you have=20
enabled MSI the IRQ is a different one anyway.

> +	/* zero out entire instance structure */
> +	pinstance =3D (struct pmcraid_instance *)host->hostdata;
> +	memset(pinstance, 0, sizeof(struct pmcraid_instance));

memset(pinstance, 0, sizeof(*pinstance));

> +	/* Schedule worker thread to handle CCN and take care of adding and
> +	 * removing devices to OS
> +	 */
> +	schedule_work(&pinstance->worker_q);
> +
> +out:
> +	return rc;
> +
> +out_remove_host:
> +	scsi_remove_host(host);
> +
> +out_release_bufs:
> +	pmcraid_release_buffers(pinstance);
> +
> +out_unregister_isr:
> +	pmcraid_kill_tasklets(pinstance);
> +	pmcraid_unregister_interrupt_handler(pinstance);
> +
> +out_scsi_host_put:
> +	scsi_host_put(host);
> +
> +cleanup_nomem:
> +	iounmap(mapped_pci_addr);
> +
> +out_release_regions:
> +	pci_release_regions(pdev);
> +
> +out_disable_device:
> +	pmcraid_adapter_count--;
> +	pci_set_drvdata(pdev, NULL);
> +	pci_disable_device(pdev);
> +	rc =3D -ENODEV;
> +	goto out;
> +}

Just "return rc" here. And maybe it's a good idea to just keep the previous=
 rc=20
so you will see it was ENOMEM or whatever.

> +/* PMC PCI vendor ID and device ID values */
> +#define PCI_VENDOR_ID_PMC			0x11F8
> +#define PCI_DEVICE_ID_PMC_MAXRAID		0x5220
> +#define PCI_DEVICE_ID_PMC_0x8010		0x8010

You could just use the 0x8010 directly at the only place this constant is=20
referenced.

> +#define IOARCB_LENGTH_CODE(n)         (((n)-3)/8 + (((n)-3)%8 > 0))

Oh, wow. I needed to throw this into a for loop to understand what you are=
=20
doing here. Try DIV_ROUND_CLOSEST(n, 8) from include/kernel.h which does ri=
ght=20
the same.

> +/* macros to help in debugging */
> +#define pmcraid_err(...)  \
> +	printk(KERN_ERR "MaxRAID: "__VA_ARGS__)
> +
> +#define pmcraid_info(...) \
> +	if (pmcraid_debug) \
> +		printk(KERN_INFO "MaxRAID: "__VA_ARGS__)

Those should probably be rewritten to use pr_err() and pr_debug(). Or bette=
r=20
use dev_dbg() and dev_info() directly.

> +/*
> + * pmcraid_adapter_id - structure defining the adapter id used by LLD
> + */
> +union pmcraid_adapter_id {
> +	struct {
> +		u32 slot_no:8;

Why not use u8?

> +		u32 bus_number:24;
> +	} y;

Greetings,

Eike

--nextPart7380776.hLyUHJ7Qom
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkow7vEACgkQXKSJPmm5/E5oaQCfSQH8iD+FjAAKf0oACMjxTzDH
VhQAnjN1VgKSS8i9ZTHCUqHg19GbPfte
=MhFv
-----END PGP SIGNATURE-----

--nextPart7380776.hLyUHJ7Qom--
