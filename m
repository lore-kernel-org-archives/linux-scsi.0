From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Remove check for SAS expander when querying bay/enclosure
 IDs.
Date: Tue, 14 Jul 2015 13:23:35 +0200
Message-ID: <55A4F137.8010100@suse.de>
References: <1436797653-9822-1-git-send-email-jordan_hargrave@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436797653-9822-1-git-send-email-jordan_hargrave@dell.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jordan Hargrave <jharg93@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@odin.com, jordan_hargrave@dell.com
List-Id: linux-scsi@vger.kernel.org

On 07/13/2015 04:27 PM, Jordan Hargrave wrote:
> Dell Server backplanes can report bay/enclosure IDs without an
> expander present.  This patch allows the bay/enclosure IDs to be
> propagaged to sysfs.we
>=20
> Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
> ---
>  drivers/scsi/scsi_transport_sas.c | 10 ----------
>  1 file changed, 10 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_tr=
ansport_sas.c
> index 9a05819..30d26e3 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1222,13 +1222,6 @@ show_sas_rphy_enclosure_identifier(struct devi=
ce *dev,
>  	u64 identifier;
>  	int error;
> =20
> -	/*
> -	 * Only devices behind an expander are supported, because the
> -	 * enclosure identifier is a SMP feature.
> -	 */
> -	if (scsi_is_sas_phy_local(phy))
> -		return -EINVAL;
> -
>  	error =3D i->f->get_enclosure_identifier(rphy, &identifier);
>  	if (error)
>  		return error;
> @@ -1248,9 +1241,6 @@ show_sas_rphy_bay_identifier(struct device *dev=
,
>  	struct sas_internal *i =3D to_sas_internal(shost->transportt);
>  	int val;
> =20
> -	if (scsi_is_sas_phy_local(phy))
> -		return -EINVAL;
> -
>  	val =3D i->f->get_bay_identifier(rphy);
>  	if (val < 0)
>  		return val;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
