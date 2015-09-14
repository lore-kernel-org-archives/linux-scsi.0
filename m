From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Bugfix 3/3] eata: Enhance eata driver to support PCI device
 hot-removal
Date: Mon, 14 Sep 2015 10:21:14 +0200
Message-ID: <55F6837A.5020807@suse.de>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
 <1442200140-30808-4-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442200140-30808-4-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/14/2015 05:08 AM, Jiang Liu wrote:
> Due to having no hardware for testing, this is just a sample code
> to support PCI device hot-removal. It just passing compilation,
> no any tests.
>=20
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/scsi/eata.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>=20
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index b92e6856f909..f3bd7cbf260e 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -1474,6 +1474,21 @@ static unsigned int port_probe(unsigned long p=
ort_base,
>  #ifdef CONFIG_PCI
>  static int eata2x_pci_device_count;
> =20
> +/* TODO: need help here to shutdown the scsi host and release resour=
ces */
> +static void port_remove(unsigned int id, resource_size_t port_base,
> +			struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *shost =3D sh[id];
> +
> +	/* TODO: stop scsi device */
> +	scsi_unregister(shost);
> +	/* TODO: clean up resources allocated by port_detect() */
> +	clear_bit(id, eata_board_bitmap);
> +	free_irq(shost->irq, &sha[id]);
> +	release_region(port_base, REGION_SIZE);
> +	ida_simple_remove(&eata_ida, id);
> +}
> +
>  static int eata2x_pci_probe(struct pci_dev *dev, const struct pci_de=
vice_id *id)
>  {
>  	int i, ret =3D -ENXIO;
> @@ -1521,6 +1536,16 @@ out_error:
>  	return ret;
>  }
> =20
> +static void eata2x_pci_remove(struct pci_dev *pdev)
> +{
> +	int id =3D (int)(long)dev_get_drvdata(&pdev->dev);
> +	resource_size_t port_base;
> +
> +	port_base =3D pci_resource_start(pdev, 0) + PCI_BASE_ADDRESS_0;
> +	port_remove(id, port_base, pdev);
> +	pci_disable_device(pdev);
> +}
> +
>  static struct pci_device_id eata2x_tbl[] =3D {
>  	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_SCSI << 8, PCI_ANY_ID) },
>  	{ },
> @@ -1531,6 +1556,7 @@ static struct pci_driver eata2x_pci_driver =3D =
{
>  	.name		=3D "eata",
>  	.id_table	=3D eata2x_tbl,
>  	.probe		=3D eata2x_pci_probe,
> +	.remove		=3D eata2x_pci_remove,
>  };
> =20
>  static int eata2x_probe_pci_devices(struct scsi_host_template *tpnt)
>=20
Welll ... if you don't have hardware (and I strongly hope you refer to
'hardware able to do hotplugging', not 'hardware for the eata driver'
=2E..) why add the code at all?
Chances are no-one will ever need eata PCI hotplug; SCSI parallel
typically isn't very good at hotplugging, so throwing in PCI hotplug
will only confuse matters more.
Plus due to the sheer mechanics involved here I find it very unlikely
anyone will be using it in real life.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
