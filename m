From: "Ballabio, Dario" <dario.ballabio@emc.com>
Subject: RE: [Bugfix 3/3] eata: Enhance eata driver to support PCI device
 hot-removal
Date: Mon, 14 Sep 2015 04:31:06 -0400
Message-ID: <EB35ED741F0E024A8A7C30A8B22D7DA61FAF5D3D98@MX27A.corp.emc.com>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
 <1442200140-30808-4-git-send-email-jiang.liu@linux.intel.com>
 <55F6837A.5020807@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <55F6837A.5020807@suse.de>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Agreed, It does not make sense to have  this driver converted to a hot =
plug api.

Cheers,



***************************************
Ph.D. Dario Ballabio
Principal Field Support Specialist, EMC EMEA=20
Mobile phone: +393487978851



-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Monday, September 14, 2015 10:21 AM
To: Jiang Liu; Thomas Gleixner; Bjorn Helgaas; Arthur Marsh; Ballabio, =
Dario; James E.J. Bottomley
Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; linux-scsi=
@vger.kernel.org; x86@kernel.org
Subject: Re: [Bugfix 3/3] eata: Enhance eata driver to support PCI devi=
ce hot-removal

On 09/14/2015 05:08 AM, Jiang Liu wrote:
> Due to having no hardware for testing, this is just a sample code to=20
> support PCI device hot-removal. It just passing compilation, no any=20
> tests.
>=20
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/scsi/eata.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>=20
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c index=20
> b92e6856f909..f3bd7cbf260e 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -1474,6 +1474,21 @@ static unsigned int port_probe(unsigned long=20
> port_base,  #ifdef CONFIG_PCI  static int eata2x_pci_device_count;
> =20
> +/* TODO: need help here to shutdown the scsi host and release=20
> +resources */ static void port_remove(unsigned int id, resource_size_=
t port_base,
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
>  static int eata2x_pci_probe(struct pci_dev *dev, const struct=20
> pci_device_id *id)  {
>  	int i, ret =3D -ENXIO;
> @@ -1521,6 +1536,16 @@ out_error:
>  	return ret;
>  }
> =20
> +static void eata2x_pci_remove(struct pci_dev *pdev) {
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
Welll ... if you don't have hardware (and I strongly hope you refer to =
'hardware able to do hotplugging', not 'hardware for the eata driver'
=2E..) why add the code at all?
Chances are no-one will ever need eata PCI hotplug; SCSI parallel typic=
ally isn't very good at hotplugging, so throwing in PCI hotplug will on=
ly confuse matters more.
Plus due to the sheer mechanics involved here I find it very unlikely a=
nyone will be using it in real life.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
