From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] Scsi: dc395x.c: Use module_pci_driver
Date: Fri, 25 Sep 2015 17:32:49 +0200
Message-ID: <56056921.3040608@suse.de>
References: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
 <1443193731-12587-3-git-send-email-shraddha.6596@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbbIYPcx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 11:32:53 -0400
In-Reply-To: <1443193731-12587-3-git-send-email-shraddha.6596@gmail.com>
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
>  drivers/scsi/dc395x.c | 25 +------------------------
>  1 file changed, 1 insertion(+), 24 deletions(-)
>=20
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 5ee7f44..a0a6eaf 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -4870,30 +4870,7 @@ static struct pci_driver dc395x_driver =3D {
>  	.probe          =3D dc395x_init_one,
>  	.remove         =3D dc395x_remove_one,
>  };
> -
> -
> -/**
> - * dc395x_module_init - Module initialization function
> - *
> - * Used by both module and built-in driver to initialise this driver=
=2E
> - **/
> -static int __init dc395x_module_init(void)
> -{
> -	return pci_register_driver(&dc395x_driver);
> -}
> -
> -
> -/**
> - * dc395x_module_exit - Module cleanup function.
> - **/
> -static void __exit dc395x_module_exit(void)
> -{
> -	pci_unregister_driver(&dc395x_driver);
> -}
> -
> -
> -module_init(dc395x_module_init);
> -module_exit(dc395x_module_exit);
> +module_pci_driver(dc395x_driver);
> =20
>  MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
>  MODULE_DESCRIPTION("SCSI host adapter driver for Tekram TRM-S1040 ba=
sed adapters: Tekram DC395 and DC315 series");
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
