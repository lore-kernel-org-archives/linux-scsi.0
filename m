From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] aic79xx: fix misuse of static variables
Date: Mon, 31 Mar 2014 07:56:43 +0200
Message-ID: <5339039B.8070307@suse.de>
References: <1396186235-3053-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaCaF4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 01:56:45 -0400
In-Reply-To: <1396186235-3053-1-git-send-email-minipli@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, PaX Team <pageexec@freemail.hu>

On 03/30/2014 03:30 PM, Mathias Krause wrote:
> The format strings for various printk()s make use of a temporary
> variable that is declared 'static'. This is probably not intended,
> so fix those.
>=20
> Found in the PaX patch, written by the PaX Team.
>=20
> Cc: PaX Team <pageexec@freemail.hu>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>=20
> Remark: Compile tested only! I've no such hardware.
>=20
>  drivers/scsi/aic7xxx/aic79xx_pci.c |   18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xx=
x/aic79xx_pci.c
> index 14b5f8d0e7..cc9bd26f5d 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_pci.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
> @@ -827,7 +827,7 @@ ahd_pci_intr(struct ahd_softc *ahd)
>  		for (bit =3D 0; bit < 8; bit++) {
> =20
>  			if ((pci_status[i] & (0x1 << bit)) !=3D 0) {
> -				static const char *s;
> +				const char *s;
> =20
>  				s =3D pci_status_strings[bit];
>  				if (i =3D=3D 7/*TARG*/ && bit =3D=3D 3)
> @@ -887,23 +887,15 @@ ahd_pci_split_intr(struct ahd_softc *ahd, u_int=
 intstat)
> =20
>  		for (bit =3D 0; bit < 8; bit++) {
> =20
> -			if ((split_status[i] & (0x1 << bit)) !=3D 0) {
> -				static const char *s;
> -
> -				s =3D split_status_strings[bit];
> -				printk(s, ahd_name(ahd),
> +			if ((split_status[i] & (0x1 << bit)) !=3D 0)
> +				printk(split_status_strings[bit], ahd_name(ahd),
>  				       split_status_source[i]);
> -			}
> =20
>  			if (i > 1)
>  				continue;
> =20
> -			if ((sg_split_status[i] & (0x1 << bit)) !=3D 0) {
> -				static const char *s;
> -
> -				s =3D split_status_strings[bit];
> -				printk(s, ahd_name(ahd), "SG");
> -			}
> +			if ((sg_split_status[i] & (0x1 << bit)) !=3D 0)
> +				printk(split_status_strings[bit], ahd_name(ahd), "SG");
>  		}
>  	}
>  	/*
>=20
Looks good.

Acked-by: Hannes Reinecke <hare@suse.de>

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
