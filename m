From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi dh alua: fix group id masking
Date: Thu, 05 Feb 2009 14:56:32 +0100
Message-ID: <498AF010.9040500@suse.de>
References: <12333564114078-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZBEN4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2009 08:56:34 -0500
In-Reply-To: <12333564114078-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Ilgu Hong <ilgu.hong@promise.com>

Hi Mike,

michaelc@cs.wisc.edu wrote:
> From: Ilgu Hong <ilgu.hong@promise.com>
>=20
>=20
> The buf[i] is a byte but we are only asking 4 bits off the
> group_id. This patch has us take off a byte.
>=20
> Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>=20
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index e356b43..5096b0b 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -247,8 +247,8 @@ static unsigned submit_stpg(struct scsi_device *s=
dev, struct alua_dh_data *h)
>  	/* Prepare the data buffer */
>  	memset(h->buff, 0, stpg_len);
>  	h->buff[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
> -	h->buff[6] =3D (h->group_id >> 8) & 0x0f;
> -	h->buff[7] =3D h->group_id & 0x0f;
> +	h->buff[6] =3D (h->group_id >> 8) & 0xff;
> +	h->buff[7] =3D h->group_id & 0xff;
> =20
>  	rq =3D get_alua_req(sdev, h->buff, stpg_len, WRITE);
>  	if (!rq)
Correct.

Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
