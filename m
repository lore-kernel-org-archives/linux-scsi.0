From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] Scsi: dmx3191d.c: Use module_pci_driver
Date: Fri, 25 Sep 2015 17:32:13 +0200
Message-ID: <560568FD.1050602@suse.de>
References: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
 <1443193731-12587-2-git-send-email-shraddha.6596@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbbIYPcR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 11:32:17 -0400
In-Reply-To: <1443193731-12587-2-git-send-email-shraddha.6596@gmail.com>
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
>  drivers/scsi/dmx3191d.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
> index 3e08812..2913fc7 100644
> --- a/drivers/scsi/dmx3191d.c
> +++ b/drivers/scsi/dmx3191d.c
> @@ -143,19 +143,7 @@ static struct pci_driver dmx3191d_pci_driver =3D=
 {
>  	.probe		=3D dmx3191d_probe_one,
>  	.remove		=3D dmx3191d_remove_one,
>  };
> -
> -static int __init dmx3191d_init(void)
> -{
> -	return pci_register_driver(&dmx3191d_pci_driver);
> -}
> -
> -static void __exit dmx3191d_exit(void)
> -{
> -	pci_unregister_driver(&dmx3191d_pci_driver);
> -}
> -
> -module_init(dmx3191d_init);
> -module_exit(dmx3191d_exit);
> +module_pci_driver(dmx3191d_pci_driver);
> =20
>  MODULE_AUTHOR("Massimo Piccioni <dafastidio@libero.it>");
>  MODULE_DESCRIPTION("Domex DMX3191D SCSI driver");
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
