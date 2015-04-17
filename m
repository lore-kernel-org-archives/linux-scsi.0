From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 10/43] hpsa: do not ignore return value of hpsa_register_scsi
Date: Fri, 17 Apr 2015 15:05:53 +0200
Message-ID: <55310531.5060500@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134735.30238.9294.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbbDQNFz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:05:55 -0400
In-Reply-To: <20150416134735.30238.9294.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:47 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>=20
> add error handling for failure when registering with SCSI subsystem.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 037b549..292b8bd 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7427,7 +7427,9 @@ reinit_after_soft_reset:
>  	h->access.set_intr_mask(h, HPSA_INTR_ON);
> =20
>  	hpsa_hba_inquiry(h);
> -	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
> +	rc =3D hpsa_register_scsi(h); /* hook ourselves into SCSI subsystem=
 */
> +	if (rc)
> +		goto clean4;
> =20
>  	/* Monitor the controller for firmware lockups */
>  	h->heartbeat_sample_interval =3D HEARTBEAT_SAMPLE_INTERVAL;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
