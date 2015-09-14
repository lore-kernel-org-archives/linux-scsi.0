From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Bugfix 2/3] eata: Implement PCI driver to manage eata PCI
 devices
Date: Mon, 14 Sep 2015 10:17:35 +0200
Message-ID: <55F6829F.8090707@suse.de>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
 <1442200140-30808-3-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1442200140-30808-3-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/14/2015 05:08 AM, Jiang Liu wrote:
> Previously the eata driver just grabs and accesses eata PCI devices
> without implementing a PCI device driver, that causes troubles with
> latest IRQ related
>=20
> Commit 991de2e59090 ("PCI, x86: Implement pcibios_alloc_irq() and
> pcibios_free_irq()") changes the way to allocate PCI legacy IRQ
> for PCI devices on x86 platforms. Instead of allocating PCI legacy
> IRQs when pcibios_enable_device() gets called, now pcibios_alloc_irq(=
)
> will be called by pci_device_probe() to allocate PCI legacy IRQs
> when binding PCI drivers to PCI devices.
>=20
> But the eata driver directly accesses PCI devices without implementin=
g
> corresponding PCI drivers, so pcibios_alloc_irq() won't be called for
> those PCI devices and wrong IRQ number may be used to manage the PCI
> device.
>=20
> This patch implements a PCI device driver to manage eata PCI devices,
> so eata driver could properly cooperate with the PCI core. It also
> provides headroom for PCI hotplug with eata driver.
>=20
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/scsi/eata.c |  170 ++++++++++++++++++++++-------------------=
----------
>  1 file changed, 74 insertions(+), 96 deletions(-)
>=20
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index b45d3b532b70..b92e6856f909 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -850,10 +850,6 @@ static unsigned long io_port[] =3D {
>  	/* First ISA */
>  	0x1f0,
> =20
> -	/* Space for MAX_PCI ports possibly reported by PCI_BIOS */
> -	SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP,
> -	SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP, SKIP,
> -
>  	/* MAX_EISA ports */
>  	0x1c88, 0x2c88, 0x3c88, 0x4c88, 0x5c88, 0x6c88, 0x7c88, 0x8c88,
>  	0x9c88, 0xac88, 0xbc88, 0xcc88, 0xdc88, 0xec88, 0xfc88,
> @@ -1024,60 +1020,13 @@ static int read_pio(unsigned long iobase, ush=
ort * start, ushort * end)
>  	return 0;
>  }
> =20
> -static struct pci_dev *get_pci_dev(unsigned long port_base)
> -{
> -#if defined(CONFIG_PCI)
> -	unsigned int addr;
> -	struct pci_dev *dev =3D NULL;
> -
> -	while ((dev =3D pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev))) {
> -		addr =3D pci_resource_start(dev, 0);
> -
> -#if defined(DEBUG_PCI_DETECT)
> -		printk("%s: get_pci_dev, bus %d, devfn 0x%x, addr 0x%x.\n",
> -		       driver_name, dev->bus->number, dev->devfn, addr);
> -#endif
> -
> -		/* we are in so much trouble for a pci hotplug system with this dr=
iver
> -		 * anyway, so doing this at least lets people unload the driver an=
d not
> -		 * cause memory problems, but in general this is a bad thing to do=
 (this
> -		 * driver needs to be converted to the proper PCI api someday... *=
/
> -		pci_dev_put(dev);
> -		if (addr + PCI_BASE_ADDRESS_0 =3D=3D port_base)
> -			return dev;
> -	}
> -#endif				/* end CONFIG_PCI */
> -	return NULL;
> -}
> -
> -static void enable_pci_ports(void)
> -{
> -#if defined(CONFIG_PCI)
> -	struct pci_dev *dev =3D NULL;
> -
> -	while ((dev =3D pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev))) {
> -#if defined(DEBUG_PCI_DETECT)
> -		printk("%s: enable_pci_ports, bus %d, devfn 0x%x.\n",
> -		       driver_name, dev->bus->number, dev->devfn);
> -#endif
> -
> -		if (pci_enable_device(dev))
> -			printk
> -			    ("%s: warning, pci_enable_device failed, bus %d devfn 0x%x.\n=
",
> -			     driver_name, dev->bus->number, dev->devfn);
> -	}
> -
> -#endif				/* end CONFIG_PCI */
> -}
> -
>  static int port_detect(unsigned long port_base, unsigned int j,
> -		struct scsi_host_template *tpnt)
> +		       struct scsi_host_template *tpnt, struct pci_dev *pdev)
>  {
>  	unsigned char irq, dma_channel, subversion, i, is_pci =3D 0;
>  	unsigned char protocol_rev;
>  	struct eata_info info;
>  	char *bus_type, dma_name[16];
> -	struct pci_dev *pdev;
>  	/* Allowed DMA channels for ISA (0 indicates reserved) */
>  	unsigned char dma_channel_table[4] =3D { 5, 6, 7, 0 };
>  	struct Scsi_Host *shost;
> @@ -1199,15 +1148,8 @@ static int port_detect(unsigned long port_base=
, unsigned int j,
>  		    ("%s: warning, LEVEL triggering is suggested for IRQ %u.\n",
>  		     name, irq);
> =20
> -	if (is_pci) {
> -		pdev =3D get_pci_dev(port_base);
> -		if (!pdev)
> -			printk
> -			    ("%s: warning, failed to get pci_dev structure.\n",
> -			     name);
> -	} else
> -		pdev =3D NULL;
> -
> +	if (is_pci && !pdev)
> +		printk("%s: warning, failed to get pci_dev structure.\n", name);
>  	if (pdev && (irq !=3D pdev->irq)) {
>  		printk("%s: IRQ %u mapped to IO-APIC IRQ %u.\n", name, irq,
>  		       pdev->irq);
> @@ -1510,14 +1452,17 @@ static int option_setup(char *str)
>  }
> =20
>  static unsigned int port_probe(unsigned long port_base,
> -			       struct scsi_host_template *tpnt)
> +			       struct scsi_host_template *tpnt,
> +			       struct pci_dev *pdev)
>  {
>  	int id;
> =20
>  	id =3D ida_simple_get(&eata_ida, 0, MAX_BOARDS, GFP_KERNEL);
>  	if (id >=3D 0) {
>  		set_bit(id, eata_board_bitmap);
> -		if (port_detect(port_base, id, tpnt))
> +		if (pdev)
> +			dev_set_drvdata(&pdev->dev, (void *)(long)id);
> +		if (port_detect(port_base, id, tpnt, pdev))
>  			return id;
>  		clear_bit(id, eata_board_bitmap);
>  		ida_simple_remove(&eata_ida, id);
> @@ -1526,42 +1471,81 @@ static unsigned int port_probe(unsigned long =
port_base,
>  	return -1;
>  }
> =20
> -static void add_pci_ports(void)
> -{
> -#if defined(CONFIG_PCI)
> -	unsigned int addr, k;
> -	struct pci_dev *dev =3D NULL;
> -
> -	for (k =3D 0; k < MAX_PCI; k++) {
> +#ifdef CONFIG_PCI
> +static int eata2x_pci_device_count;
> =20
> -		if (!(dev =3D pci_get_class(PCI_CLASS_STORAGE_SCSI << 8, dev)))
> -			break;
> +static int eata2x_pci_probe(struct pci_dev *dev, const struct pci_de=
vice_id *id)
> +{
> +	int i, ret =3D -ENXIO;
> +	resource_size_t addr;
> +	unsigned long port_base;
> +	struct scsi_host_template *tpnt =3D (void *)id->driver_data;
> =20
> -		if (pci_enable_device(dev)) {
> +	if (pci_enable_device(dev)) {
>  #if defined(DEBUG_PCI_DETECT)
> -			printk
> -			    ("%s: detect, bus %d, devfn 0x%x, pci_enable_device failed.\n=
",
> -			     driver_name, dev->bus->number, dev->devfn);
> +		pr_warn("%s: detect, bus %d, devfn 0x%x, pci_enable_device failed.=
\n",
> +			driver_name, dev->bus->number, dev->devfn);
>  #endif
> +		goto out_error;
> +	}
> =20
> -			continue;
> -		}
> -
> -		addr =3D pci_resource_start(dev, 0);
> -
> +	addr =3D pci_resource_start(dev, 0);
> +	port_base =3D addr + PCI_BASE_ADDRESS_0;
>  #if defined(DEBUG_PCI_DETECT)
> -		printk("%s: detect, seq. %d, bus %d, devfn 0x%x, addr 0x%x.\n",
> -		       driver_name, k, dev->bus->number, dev->devfn, addr);
> +	printk("%s: detect, bus %d, devfn 0x%x, addr 0x%x.\n",
> +	       driver_name, dev->bus->number, dev->devfn, (unsigned int)add=
r);
>  #endif
> =20
> -		/* Order addresses according to rev_scan value */
> -		io_port[MAX_INT_PARAM + (rev_scan ? (MAX_PCI - k) : (1 + k))] =3D
> -		    addr + PCI_BASE_ADDRESS_0;
> +	if (setup_done) {
> +		/*
> +		 * Handle kernel or module parameter
> +		 * . probe board if its port is specified by user
> +		 * . otherwise ignore the board
> +		 */
> +		for (i =3D 1; i < MAX_INT_PARAM; i++)
> +			if (io_port[i] =3D=3D port_base) {
> +				io_port[i] =3D SKIP;
> +				break;
> +			}
> +		if (i >=3D MAX_INT_PARAM)
> +			goto out_disable_device;
> +	}
Hmm. I must admit I don't like the 'setup_done' thingie. As the driver
is now converted to a 'real' PCI device we should be using driver-core
mechanisms to avoid driver binding, not the prefabricated 'setup_done'
variable.
Can't we just do away with it completely?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
