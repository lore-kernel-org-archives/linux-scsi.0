From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 33/43] hpsa: cleanup for init_one step 2 in kdump
Date: Fri, 17 Apr 2015 15:29:19 +0200
Message-ID: <55310AAF.1030000@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134941.30238.68476.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbbDQN3W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:29:22 -0400
In-Reply-To: <20150416134941.30238.68476.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>=20
> In hpsa_undo_allocations_after_kdump_soft_reset,
> the things allocated in hpsa_init_one step 2 -
> h->resubmit_wq and h->lockup_detected  need to
> be freed, in the right order.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index dc8299c..99fd4d3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7395,6 +7395,16 @@ static void hpsa_undo_allocations_after_kdump_=
soft_reset(struct ctlr_info *h)
>  	hpsa_free_cmd_pool(h);			/* init_one 5 */
>  	hpsa_free_irqs(h);			/* init_one 4 */
>  	hpsa_free_pci_init(h);			/* init_one 3 */
> +	free_percpu(h->lockup_detected);	/* init_one 2 */
> +	h->lockup_detected =3D NULL;		/* init_one 2 */
> +	if (h->resubmit_wq) {
> +		destroy_workqueue(h->resubmit_wq);	/* init_one 1 */
> +		h->resubmit_wq =3D NULL;
> +	}
> +	if (h->rescan_ctlr_wq) {
> +		destroy_workqueue(h->rescan_ctlr_wq);
> +		h->rescan_ctlr_wq =3D NULL;
> +	}
>  	kfree(h);				/* init_one 1 */
>  }
> =20
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
