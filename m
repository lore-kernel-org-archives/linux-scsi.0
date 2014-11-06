From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch] scsi: missing braces in scsi_extd_sense_format()
Date: Thu, 06 Nov 2014 07:53:20 +0100
Message-ID: <545B1AE0.9000407@suse.de>
References: <20141105203837.GA26314@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFGxW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 01:53:22 -0500
In-Reply-To: <20141105203837.GA26314@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 11/05/2014 09:38 PM, Dan Carpenter wrote:
> There were missing curly braces so we always return the first
> additional2[] string.
>=20
> Fixes: 7046d2fa6dbd ('scsi: use sdev as argument for sense code print=
ing')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index a1a7fca..0cf43f6 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1282,9 +1282,10 @@ scsi_extd_sense_format(unsigned char asc, unsi=
gned char ascq, const char **fmt)
>  	for (i =3D 0; additional2[i].fmt; i++) {
>  		if (additional2[i].code1 =3D=3D asc &&
>  		    ascq >=3D additional2[i].code2_min &&
> -		    ascq <=3D additional2[i].code2_max)
> +		    ascq <=3D additional2[i].code2_max) {
>  			*fmt =3D additional2[i].fmt;
>  			return additional2[i].str;
> +		}
>  	}
>  #endif
>  	return NULL;
>=20
D'oh.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
