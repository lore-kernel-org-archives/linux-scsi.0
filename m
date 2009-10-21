From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] Add new driver for LSI 3ware 9750
Date: Wed, 21 Oct 2009 17:27:27 +0200
Message-ID: <200910211727.34165.eike-kernel@sf-tec.de>
References: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1704932.Fe2k6izlcY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:41589 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZJUP1j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 11:27:39 -0400
In-Reply-To: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

--nextPart1704932.Fe2k6izlcY
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

adam radford wrote:

> +static int use_msi =3D 0;

Static variables are automatically 0.

> +/* This function will look up an AEN severity string */
> +static char *twl_aen_severity_lookup(unsigned char severity_code)
> +{
> +	char *retval =3D NULL;
> +
> +	if ((severity_code < (unsigned char) TW_AEN_SEVERITY_ERROR) ||
> +	    (severity_code > (unsigned char) TW_AEN_SEVERITY_DEBUG))
> +		goto out;
> +
> +	retval =3D twl_aen_severity_table[severity_code];
> +out:
> +	return retval;
> +} /* End twl_aen_severity_lookup() */

I would find it more readable with direct "return NULL" and without the got=
o.

> +/* This function will read the aen queue from the isr */
> +static int twl_aen_read_queue(TW_Device_Extension *tw_dev, int request_i=
d)
> +{
> +	char cdb[TW_MAX_CDB_LEN];
> +	TW_SG_Entry_ISO sglist[1];
> +	TW_Command_Full *full_command_packet;
> +	int retval =3D 1;
> +
> +	full_command_packet =3D tw_dev->command_packet_virt[request_id];
> +	memset(full_command_packet, 0, sizeof(TW_Command_Full));

sizeof(*full_command_packet)

> +	/* Initialize cdb */
> +	memset(&cdb, 0, TW_MAX_CDB_LEN);

memset(...,sizeof(cdb))

> +	cdb[0] =3D REQUEST_SENSE; /* opcode */
> +	cdb[4] =3D TW_ALLOCATION_LENGTH; /* allocation length */
> +
> +	/* Initialize sglist */
> +	memset(&sglist, 0, sizeof(TW_SG_Entry_ISO));

sizeof(sglist)

In all cases you will always get the correct size even if you change the=20
variable to another type or the array to another length. This happens also =
in=20
a bunch of other places.

> +/* This function will assign an available request id */
> +static void twl_get_request_id(TW_Device_Extension *tw_dev, int
>  *request_id) +{
> +	*request_id =3D tw_dev->free_queue[tw_dev->free_head];
> +	tw_dev->free_head =3D (tw_dev->free_head + 1) % TW_Q_LENGTH;
> +	tw_dev->state[*request_id] =3D TW_S_STARTED;
> +} /* End twl_get_request_id() */

Why not simply return the request id instead of being a void function and=20
taking that as pointer?

> +/* This function will poll for a response */
> +static int twl_poll_response(TW_Device_Extension *tw_dev, int
> request_id, int seconds)
> +{
> +	unsigned long before;
> +	dma_addr_t mfa;
> +	u32 regh, regl;
> +	u32 response;
> +	int retval =3D 1;
> +	int found =3D 0;
> +
> +	before =3D jiffies;
> +
> +	while (!found) {
> +		if (sizeof(dma_addr_t) > 4) {
> +			regh =3D readl(TWL_HOBQPH_REG_ADDR(tw_dev));
> +			regl =3D readl(TWL_HOBQPL_REG_ADDR(tw_dev));
> +			mfa =3D ((u64)regh << 32) | regl;
> +		} else
> +			mfa =3D readl(TWL_HOBQPL_REG_ADDR(tw_dev));
> +
> +		response =3D (u32)mfa;

Reading regh is useless here. And if you need to read it for protocol reaso=
ns=20
at the end it's at least useless to put it into mfa, simply reading=20
TWL_HOBQPL_REG_ADDR(tw_dev) into response should be enough.

> +static int twl_initialize_device_extension(TW_Device_Extension *tw_dev)

Device extension? Don't call anything IRP ;) Bah, I was so lucky that I had=
=20
forgotten that pain for a while ;)

> +{
> +	int i, retval =3D 1;
> +
> +	/* Initialize command packet buffers */
> +	if (twl_allocate_memory(tw_dev, sizeof(TW_Command_Full), 0)) {
> +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x9, "Command packet memory
> allocation failed");
> +		goto out;
> +	}

Your gotos here don't do anything useful as there is no error handling at t=
he=20
destination so you could simply do "return something" here as that would al=
low=20
anyone to spot what's going on without scrolling. Also you should return so=
me=20
useful return code (like ENOMEM here) instead of just "1" as that could eas=
e=20
debugging.

> +/* This funciton returns unit geometry in cylinders/heads/sectors */
> +static int twl_scsi_biosparam(struct scsi_device *sdev, struct
> block_device *bdev, sector_t capacity, int geom[])
> +{
> +	int heads, sectors, cylinders;
> +	TW_Device_Extension *tw_dev;
> +
> +	tw_dev =3D (TW_Device_Extension *)sdev->host->hostdata;
> +
> +	if (capacity >=3D 0x200000) {
> +		heads =3D 255;
> +		sectors =3D 63;
> +		cylinders =3D sector_div(capacity, heads * sectors);
> +	} else {
> +		heads =3D 64;
> +		sectors =3D 32;
> +		cylinders =3D sector_div(capacity, heads * sectors);
> +	}

The calculation of cylinders is both the same, you could move it out of the=
 if=20
or just directly assign the result to geom[2].

> +/* This function will probe and initialize a card */
> +static int __devinit twl_probe(struct pci_dev *pdev, const struct
> pci_device_id *dev_id)
> +{
> +	struct Scsi_Host *host =3D NULL;
> +	TW_Device_Extension *tw_dev;
> +	resource_size_t mem_addr, mem_len;
> +	int retval =3D -ENODEV;
> +	int *ptr_phycount, phycount=3D0;
> +
> +	retval =3D pci_enable_device(pdev);
> +	if (retval) {
> +		TW_PRINTK(host, TW_DRIVER, 0x17, "Failed to enable pci device");
> +		goto out_disable_device;
> +	}

You may want to look at devres (see Documentation/driver-model/devres.txt) =
as=20
that could make you the live a bit easier. It would care both for error=20
handling here as well for device release.

> +	pci_set_master(pdev);
> +	pci_try_set_mwi(pdev);
> +
> +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
> +	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
> +		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
> +		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
> +			TW_PRINTK(host, TW_DRIVER, 0x18, "Failed to set dma mask");
> +			retval =3D -ENODEV;
> +			goto out_disable_device;
> +		}
> +
> +	host =3D scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
> +	if (!host) {
> +		TW_PRINTK(host, TW_DRIVER, 0x19, "Failed to allocate memory for
> device extension");
> +		retval =3D -ENOMEM;
> +		goto out_disable_device;
> +	}
> +	tw_dev =3D (TW_Device_Extension *)host->hostdata;

tw_dev =3D shost_priv(host);

> +	/* Save values to device extension */
> +	tw_dev->host =3D host;
> +	tw_dev->tw_pci_dev =3D pdev;
> +
> +	if (twl_initialize_device_extension(tw_dev)) {
> +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Failed to initialize
> device extension");
> +		goto out_free_device_extension;
> +	}
> +
> +	/* Request IO regions */
> +	retval =3D pci_request_regions(pdev, "3w-sas");
> +	if (retval) {
> +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1b, "Failed to get mem region");
> +		goto out_free_device_extension;
> +	}
> +
> +	/* Use region 1 */
> +	mem_addr =3D pci_resource_start(pdev, 1);
> +	mem_len =3D pci_resource_len(pdev, 1);
> +
> +	/* Save base address */
> +	tw_dev->base_addr =3D ioremap(mem_addr, mem_len);

tw_dev->base_addr =3D pci_iomap(pdev, 1, 0);

> +	if (!tw_dev->base_addr) {
> +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to ioremap");
> +		goto out_release_mem_region;
> +	}
> +
> +	/* Disable interrupts on the card */
> +	TWL_MASK_INTERRUPTS(tw_dev);
> +
> +	/* Initialize the card */
> +	if (twl_reset_sequence(tw_dev, 0)) {
> +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Controller reset failed
> during probe");
> +		goto out_iounmap;
> +	}
> +
> +	/* Set host specific parameters */
> +	host->max_id =3D TW_MAX_UNITS;
> +	host->max_cmd_len =3D TW_MAX_CDB_LEN;
> +	host->max_lun =3D TW_MAX_LUNS;
> +	host->max_channel =3D 0;
> +
> +	/* Register the card with the kernel SCSI layer */
> +	retval =3D scsi_add_host(host, &pdev->dev);
> +	if (retval) {
> +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1e, "scsi add host failed");
> +		goto out_iounmap;
> +	}
> +
> +	pci_set_drvdata(pdev, host);
> +
> +	printk(KERN_WARNING "3w-sas: scsi%d: Found an LSI 3ware %s
> Controller at 0x%llx, IRQ: %d.\n",
> +	       host->host_no,
> +	       (char *)twl_get_param(tw_dev, 1, TW_VERSION_TABLE,
> +				     TW_PARAM_MODEL, TW_PARAM_MODEL_LENGTH),
> +	       (u64)mem_addr, pdev->irq);
> +
> +	ptr_phycount =3D twl_get_param(tw_dev, 2, TW_PARAM_PHY_SUMMARY_TABLE,
> +				     TW_PARAM_PHYCOUNT, TW_PARAM_PHYCOUNT_LENGTH);
> +	if (ptr_phycount)
> +		phycount =3D le32_to_cpu(*(int *)ptr_phycount);
> +
> +	printk(KERN_WARNING "3w-sas: scsi%d: Firmware %s, BIOS %s, Phys: %d.\n",
> +	       host->host_no,
> +	       (char *)twl_get_param(tw_dev, 1, TW_VERSION_TABLE,
> +				     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
> +	       (char *)twl_get_param(tw_dev, 2, TW_VERSION_TABLE,
> +				     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
> +	       phycount);
> +
> +	/* Try to enable MSI */
> +	if (use_msi && !pci_enable_msi(pdev))
> +		set_bit(TW_USING_MSI, &tw_dev->flags);
> +
> +	/* Now setup the interrupt handler */
> +	retval =3D request_irq(pdev->irq, twl_interrupt, IRQF_SHARED, "3w-sas",
>  tw_dev); +	if (retval) {
> +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1f, "Error requesting IRQ");
> +		goto out_remove_host;
> +	}

If you're using MSI you should not pass IRQF_SHARED here.

> +/* PCI Devices supported by this driver */
> +static struct pci_device_id twl_pci_tbl[] __devinitdata =3D {
> +	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9750,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{ }
> +};

PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9750)

> +MODULE_DEVICE_TABLE(pci, twl_pci_tbl);
> +
> +/* pci_driver initializer */
> +static struct pci_driver twl_driver =3D {
> +	.name		=3D "3w-sas",

You probably should put that string in some constant and use it all over th=
e=20
place.

> +/* This function is called on driver initialization */
> +static int __init twl_init(void)
> +{
> +	printk(KERN_WARNING "LSI 3ware SAS/SATA-RAID Controller device
> driver for Linux v%s.\n", TW_DRIVER_VERSION);

Ehm, no, that is no warning.

> +	return pci_register_driver(&twl_driver);
> +} /* End twl_init() */

> +/* AEN severity table */
> +static char *twl_aen_severity_table[] =3D
> +{
> +	"None", "ERROR", "WARNING", "INFO", "DEBUG", (char*) 0
> +};

NULL instead of (char*) 0

> +/* Register access macros */
> +#define TWL_STATUS_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_STATUS)
> +#define TWL_HOBQPL_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HOBQPL)
> +#define TWL_HOBQPH_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HOBQPH)
> +#define TWL_HOBDB_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HOBDB)
> +#define TWL_HOBDBC_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HOBDBC)
> +#define TWL_HIMASK_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HIMASK)
> +#define TWL_HISTAT_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HISTAT)
> +#define TWL_HIBQPH_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HIBQPH)
> +#define TWL_HIBQPL_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HIBQPL)
> +#define TWL_HIBDB_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_HIBDB)
> +#define TWL_SCRPD3_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
> + TWL_SCRPD3)

You can add to a void pointer, this is equivalent. So you might not need to=
=20
cast here at all.

> +/* Macros */
> +#define TW_PRINTK(h,a,b,c) { \
> +if (h) \
> +printk(KERN_WARNING "3w-sas: scsi%d: ERROR: (0x%02X:0x%04X):
> %s.\n",h->host_no,a,b,c); \

shost_printk

> +else \
> +printk(KERN_WARNING "3w-sas: ERROR: (0x%02X:0x%04X): %s.\n",a,b,c); \

pr_warning

> +}

Also I don't see a point where you don't pass a host to that makro at all.

HTH

Eike

--nextPart1704932.Fe2k6izlcY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkrfKGYACgkQXKSJPmm5/E5MpACfeQp1OEzvR11qvov8SI5zUhbY
8GgAn1HNAaTeuOY/ew9gy2fvAKzcsGOg
=znfY
-----END PGP SIGNATURE-----

--nextPart1704932.Fe2k6izlcY--
