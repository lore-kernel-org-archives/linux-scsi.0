From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 32/43] hpsa: skip free_irq calls if irqs are not allocated
Date: Fri, 17 Apr 2015 15:29:00 +0200
Message-ID: <55310A9C.4080505@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134936.30238.72827.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbbDQN3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:29:02 -0400
In-Reply-To: <20150416134936.30238.72827.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>=20
> If try_soft_reset fails to re-allocate irqs, the error exit
> starts with free_irq calls, which generate kernel WARN
> messages since they were already freed a few lines earlier.
>=20
> Jump to the next exit label to skip the free_irq calls.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 8aeef06..dc8299c 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7773,7 +7773,12 @@ reinit_after_soft_reset:
>  		if (rc) {
>  			dev_warn(&h->pdev->dev,
>  				"Failed to request_irq after soft reset.\n");
> -			goto clean4;
> +			/*
> +			 * clean4 starts with free_irqs, but that was just
> +			 * done. Then, request_irqs_failed, so there is
> +			 * nothing to free. So, goto the next label.
> +			 */
> +			goto clean3;
>  		}
> =20
>  		rc =3D hpsa_kdump_soft_reset(h);
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
