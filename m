From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 09/10] aacraid: Fix character device re-initialization
Date: Wed, 02 Dec 2015 11:13:43 +0100
Message-ID: <1449051223.3103.56.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-10-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbbLBKNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 05:13:45 -0500
In-Reply-To: <1448973589-9216-10-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

Hi Raghava,

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> During EEH PCI hotplug activity kernel unloads and loads the driver,
> causing character device to be unregistered(aac_remove_one).When the
> driver is loaded back using aac_probe_one the character device needs
> to be registered again for the AIF management tools to work.
>=20
> Fixed by adding code to register character device in aac_probe_one if
> it is unregistered in aac_remove_one.
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
> =C2=A0drivers/scsi/aacraid/linit.c | 19 +++++++++++++------
> =C2=A01 file changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 2094842..7142578 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1123,6 +1123,13 @@ static void __aac_shutdown(struct aac_dev * aa=
c)
> =C2=A0	else if (aac->max_msix > 1)
> =C2=A0		pci_disable_msix(aac->pdev);
> =C2=A0}
> +static void aac_init_char(void)
> +{
> +	aac_cfg_major =3D register_chrdev(0, "aac", &aac_cfg_fops);
> +	if (aac_cfg_major < 0) {
> +		pr_err("aacraid: unable to register \"aac\" device.\n");
> +	}
> +}
> =C2=A0
> =C2=A0static int aac_probe_one(struct pci_dev *pdev, const struct pci=
_device_id
> *id)
> =C2=A0{
> @@ -1185,6 +1192,9 @@ static int aac_probe_one(struct pci_dev *pdev, =
const
> struct pci_device_id *id)
> =C2=A0	shost->max_cmd_len =3D 16;
> =C2=A0	shost->use_cmd_list =3D 1;
> =C2=A0
> +	if (aac_cfg_major =3D=3D -2)
> +		aac_init_char();
> +
> =C2=A0	aac =3D (struct aac_dev *)shost->hostdata;
> =C2=A0	aac->base_start =3D pci_resource_start(pdev, 0);
> =C2=A0	aac->scsi_host_ptr =3D shost;
> @@ -1536,7 +1546,7 @@ static void aac_remove_one(struct pci_dev *pdev=
)
> =C2=A0	pci_disable_device(pdev);
> =C2=A0	if (list_empty(&aac_devices)) {
> =C2=A0		unregister_chrdev(aac_cfg_major, "aac");
> -		aac_cfg_major =3D -1;
> +		aac_cfg_major =3D -2;

Please add something like
#define AAC_CHARDEV_UNREGISTERED -1
#define AAC_CHARDEV_NEEDS_REINIT -2

so it's obvious what you're doing.

> =C2=A0	}
> =C2=A0}
> =C2=A0
> @@ -1697,11 +1707,8 @@ static int __init aac_init(void)
> =C2=A0	if (error < 0)
> =C2=A0		return error;
> =C2=A0
> -	aac_cfg_major =3D register_chrdev( 0, "aac", &aac_cfg_fops);
> -	if (aac_cfg_major < 0) {
> -		printk(KERN_WARNING
> -			"aacraid: unable to register \"aac\" device.\n");
> -	}
> +	aac_init_char();
> +
> =C2=A0
> =C2=A0	return 0;
> =C2=A0}

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
