From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 15/25] hpsa: enhance hpsa_get_device_id
Date: Fri, 30 Oct 2015 09:08:02 +0100
Message-ID: <56332562.4000707@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220601.5323.62936.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633AbbJ3IIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:08:04 -0400
In-Reply-To: <20151028220601.5323.62936.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:06 PM, Don Brace wrote:
> use an index into vpd data for SAS/SATA drives
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index c1b053f..1361414 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3137,7 +3137,7 @@ out:
> =20
>  /* Get the device id from inquiry page 0x83 */
>  static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *sc=
si3addr,
> -	unsigned char *device_id, int buflen)
> +	unsigned char *device_id, int index, int buflen)
>  {
>  	int rc;
>  	unsigned char *buf;
> @@ -3149,8 +3149,10 @@ static int hpsa_get_device_id(struct ctlr_info=
 *h, unsigned char *scsi3addr,
>  		return -ENOMEM;
>  	rc =3D hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0x83, buf, 64)=
;
>  	if (rc =3D=3D 0)
> -		memcpy(device_id, &buf[8], buflen);
> +		memcpy(device_id, &buf[index], buflen);
> +
>  	kfree(buf);
> +
>  	return rc !=3D 0;
>  }
> =20
> @@ -3379,6 +3381,18 @@ static int hpsa_device_supports_aborts(struct =
ctlr_info *h,
>  	return rc;
>  }
> =20
> +static void sanitize_inquiry_string(unsigned char *s, int len)
> +{
> +	bool terminated =3D false;
> +
> +	for (; len > 0; (--len, ++s)) {
> +		if (*s =3D=3D 0)
> +			terminated =3D true;
> +		if (terminated || *s < 0x20 || *s > 0x7e)
> +			*s =3D ' ';
> +	}
> +}
> +
>  static int hpsa_update_device_info(struct ctlr_info *h,
>  	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
>  	unsigned char *is_OBDR_device)
I would prefer to have the function from scsi_scan.c to be exported.
Hardly a point to duplicate it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
