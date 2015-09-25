From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] Scsi: a100u2w.c: Use module_pci_driver
Date: Fri, 25 Sep 2015 17:33:17 +0200
Message-ID: <5605693D.9030006@suse.de>
References: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
 <1443193731-12587-4-git-send-email-shraddha.6596@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbbIYPdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 11:33:21 -0400
In-Reply-To: <1443193731-12587-4-git-send-email-shraddha.6596@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shraddha Barke <shraddha.6596@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org

On 09/25/2015 05:08 PM, Shraddha Barke wrote:
> Use module_pci_driver for drivers whose init and exit functions
> only register and unregister respectively
>=20
> Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
> ---
>  drivers/scsi/a100u2w.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
> index 8086bd0..5ef776c 100644
> --- a/drivers/scsi/a100u2w.c
> +++ b/drivers/scsi/a100u2w.c
> @@ -1222,19 +1222,7 @@ static struct pci_driver inia100_pci_driver =3D=
 {
>  	.remove		=3D inia100_remove_one,
>  };
> =20
> -static int __init inia100_init(void)
> -{
> -	return pci_register_driver(&inia100_pci_driver);
> -}
> -
> -static void __exit inia100_exit(void)
> -{
> -	pci_unregister_driver(&inia100_pci_driver);
> -}
> -
>  MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
>  MODULE_AUTHOR("Initio Corporation");
>  MODULE_LICENSE("Dual BSD/GPL");
> -
> -module_init(inia100_init);
> -module_exit(inia100_exit);
> +module_pci_driver(inia100_pci_driver);
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
