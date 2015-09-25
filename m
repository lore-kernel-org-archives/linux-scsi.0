From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] Scsi: am53c974.c: Use module_pci_driver
Date: Fri, 25 Sep 2015 17:31:41 +0200
Message-ID: <560568DD.3090408@suse.de>
References: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663AbbIYPbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 11:31:47 -0400
In-Reply-To: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
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
>  drivers/scsi/am53c974.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
> index beea30e..0234b38 100644
> --- a/drivers/scsi/am53c974.c
> +++ b/drivers/scsi/am53c974.c
> @@ -556,16 +556,6 @@ static struct pci_driver am53c974_driver =3D {
>  	.remove         =3D pci_esp_remove_one,
>  };
> =20
> -static int __init am53c974_module_init(void)
> -{
> -	return pci_register_driver(&am53c974_driver);
> -}
> -
> -static void __exit am53c974_module_exit(void)
> -{
> -	pci_unregister_driver(&am53c974_driver);
> -}
> -
>  MODULE_DESCRIPTION("AM53C974 SCSI driver");
>  MODULE_AUTHOR("Hannes Reinecke <hare@suse.de>");
>  MODULE_LICENSE("GPL");
> @@ -577,6 +567,4 @@ MODULE_PARM_DESC(am53c974_debug, "Enable debuggin=
g");
> =20
>  module_param(am53c974_fenab, bool, 0444);
>  MODULE_PARM_DESC(am53c974_fenab, "Enable 24-bit DMA transfer sizes")=
;
> -
> -module_init(am53c974_module_init);
> -module_exit(am53c974_module_exit);
> +module_pci_driver(am53c974_driver);
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
