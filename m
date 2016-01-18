From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 8/9] aacraid: Fix character device re-initialization
Date: Mon, 18 Jan 2016 12:58:08 +0100
Message-ID: <20160118115808.GK2742@c203.arch.suse.de>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452842182-684-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbcARL6L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 06:58:11 -0500
Content-Disposition: inline
In-Reply-To: <1452842182-684-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, thenzl@redhat.com, shane.seymour@hpe.com, David.Carroll@pmcs.com

On Thu, Jan 14, 2016 at 11:16:21PM -0800, Raghava Aditya Renukunta wrot=
e:
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
> Changes in V2:
> Added macros to track character device state
>=20
> Changes in V3:
> None
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
> ---
>  drivers/scsi/aacraid/aacraid.h |  7 +++++++
>  drivers/scsi/aacraid/linit.c   | 21 ++++++++++++++-------
>  2 files changed, 21 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index 3473668..4b669ef 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -94,6 +94,13 @@ enum {
>  #define aac_phys_to_logical(x)  ((x)+1)
>  #define aac_logical_to_phys(x)  ((x)?(x)-1:0)
> =20
> +/*
> + * These macros are for keeping track of
> + * character device state.
> + */
> +#define AAC_CHARDEV_UNREGISTERED	(-1)
> +#define AAC_CHARDEV_NEEDS_REINIT	(-2)
> +
>  /* #define AAC_DETAILED_STATUS_INFO */
> =20
>  struct diskparm
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 27b3fcd..057c07c 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -80,7 +80,7 @@ MODULE_VERSION(AAC_DRIVER_FULL_VERSION);
> =20
>  static DEFINE_MUTEX(aac_mutex);
>  static LIST_HEAD(aac_devices);
> -static int aac_cfg_major =3D -1;
> +static int aac_cfg_major =3D AAC_CHARDEV_UNREGISTERED;
>  char aac_driver_version[] =3D AAC_DRIVER_FULL_VERSION;
> =20
>  /*
> @@ -1125,6 +1125,13 @@ static void __aac_shutdown(struct aac_dev * aa=
c)
>  	else if (aac->max_msix > 1)
>  		pci_disable_msix(aac->pdev);
>  }
> +static void aac_init_char(void)
> +{
> +	aac_cfg_major =3D register_chrdev(0, "aac", &aac_cfg_fops);
> +	if (aac_cfg_major < 0) {
> +		pr_err("aacraid: unable to register \"aac\" device.\n");
> +	}
> +}
> =20
>  static int aac_probe_one(struct pci_dev *pdev, const struct pci_devi=
ce_id *id)
>  {
> @@ -1182,6 +1189,9 @@ static int aac_probe_one(struct pci_dev *pdev, =
const struct pci_device_id *id)
>  	shost->max_cmd_len =3D 16;
>  	shost->use_cmd_list =3D 1;
> =20
> +	if (aac_cfg_major =3D=3D AAC_CHARDEV_NEEDS_REINIT)
> +		aac_init_char();
> +
>  	aac =3D (struct aac_dev *)shost->hostdata;
>  	aac->base_start =3D pci_resource_start(pdev, 0);
>  	aac->scsi_host_ptr =3D shost;
> @@ -1519,7 +1529,7 @@ static void aac_remove_one(struct pci_dev *pdev=
)
>  	pci_disable_device(pdev);
>  	if (list_empty(&aac_devices)) {
>  		unregister_chrdev(aac_cfg_major, "aac");
> -		aac_cfg_major =3D -1;
> +		aac_cfg_major =3D AAC_CHARDEV_NEEDS_REINIT;
>  	}
>  }
> =20
> @@ -1681,11 +1691,8 @@ static int __init aac_init(void)
>  	if (error < 0)
>  		return error;
> =20
> -	aac_cfg_major =3D register_chrdev( 0, "aac", &aac_cfg_fops);
> -	if (aac_cfg_major < 0) {
> -		printk(KERN_WARNING
> -			"aacraid: unable to register \"aac\" device.\n");
> -	}
> +	aac_init_char();
> +
> =20
>  	return 0;
>  }
> --=20
> 1.9.1
>=20

Looks good

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
