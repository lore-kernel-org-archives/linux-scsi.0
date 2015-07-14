From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] aic7xxx: replace kmalloc/strcpy by kstrdup
Date: Tue, 14 Jul 2015 12:07:50 +0200
Message-ID: <55A4DF76.80800@suse.de>
References: <4159f01e6450cee8093e7d6a0d979bbeab8243d0.1436858599.git.christophe.jaillet@wanadoo.fr> <1436868133-32096-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbbGNKHx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2015 06:07:53 -0400
In-Reply-To: <1436868133-32096-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On 07/14/2015 12:02 PM, Christophe JAILLET wrote:
> This replaces kmalloc + strcpy by an equivalent call to kstrdup.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> v2: remove useless curly braces
>=20
>  drivers/scsi/aic7xxx/aic79xx_osm.c | 6 ++----
>  drivers/scsi/aic7xxx/aic7xxx_osm.c | 6 ++----
>  2 files changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xx=
x/aic79xx_osm.c
> index ce96a0b..ea4086e 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1250,11 +1250,9 @@ ahd_linux_register_host(struct ahd_softc *ahd,=
 struct scsi_host_template *templa
>  	ahd_set_unit(ahd, ahd_linux_unit++);
>  	ahd_unlock(ahd, &s);
>  	sprintf(buf, "scsi%d", host->host_no);
> -	new_name =3D kmalloc(strlen(buf) + 1, GFP_ATOMIC);
> -	if (new_name !=3D NULL) {
> -		strcpy(new_name, buf);
> +	new_name =3D kstrdup(buf, GFP_ATOMIC);
> +	if (new_name !=3D NULL)
>  		ahd_set_name(ahd, new_name);
> -	}
>  	host->unique_id =3D ahd->unit;
>  	ahd_linux_initialize_scsi_bus(ahd);
>  	ahd_intr_enable(ahd, TRUE);
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xx=
x/aic7xxx_osm.c
> index a2f2c77..f0ac966 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1114,11 +1114,9 @@ ahc_linux_register_host(struct ahc_softc *ahc,=
 struct scsi_host_template *templa
>  	ahc_set_unit(ahc, ahc_linux_unit++);
>  	ahc_unlock(ahc, &s);
>  	sprintf(buf, "scsi%d", host->host_no);
> -	new_name =3D kmalloc(strlen(buf) + 1, GFP_ATOMIC);
> -	if (new_name !=3D NULL) {
> -		strcpy(new_name, buf);
> +	new_name =3D kstrdup(buf, GFP_ATOMIC);
> +	if (new_name !=3D NULL)
>  		ahc_set_name(ahc, new_name);
> -	}
>  	host->unique_id =3D ahc->unit;
>  	ahc_linux_initialize_scsi_bus(ahc);
>  	ahc_intr_enable(ahc, TRUE);
>=20
Alright, if you insist ...

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
