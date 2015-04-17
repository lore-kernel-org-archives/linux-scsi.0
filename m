From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 19/43] hpsa: add ioaccel sg chaining for the ioaccel2
 path
Date: Fri, 17 Apr 2015 15:14:17 +0200
Message-ID: <55310729.1040304@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134827.30238.67380.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbbDQNOT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:14:19 -0400
In-Reply-To: <20150416134827.30238.67380.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:48 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>=20
> Increase the request size for ioaccel2 path.
>=20
> The error, if any, returned by hpsa_allocate_ioaccel2_sg_chain_blocks
> to hpsa_alloc_ioaccel2_cmd_and_bft should be returned upstream rather
> than assumed to be -ENOMEM.
>=20
> This differs slightly from hpsa_alloc_ioaccel1_cmd_and_bft,
> which does not call another hpsa_allocate function and only
> has -ENOMEM to return from some kmalloc calls.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |  125 +++++++++++++++++++++++++++++++++++++++++=
++++++----
>  drivers/scsi/hpsa.h |    1=20
>  2 files changed, 116 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index c9c42e9..1839761 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1704,6 +1704,46 @@ static void hpsa_slave_destroy(struct scsi_dev=
ice *sdev)
>  	/* nothing to do. */
>  }
> =20
> +static void hpsa_free_ioaccel2_sg_chain_blocks(struct ctlr_info *h)
> +{
> +	int i;
> +
> +	if (!h->ioaccel2_cmd_sg_list)
> +		return;
> +	for (i =3D 0; i < h->nr_cmds; i++) {
> +		kfree(h->ioaccel2_cmd_sg_list[i]);
> +		h->ioaccel2_cmd_sg_list[i] =3D NULL;
> +	}
> +	kfree(h->ioaccel2_cmd_sg_list);
> +	h->ioaccel2_cmd_sg_list =3D NULL;
> +}
> +
> +static int hpsa_allocate_ioaccel2_sg_chain_blocks(struct ctlr_info *=
h)
> +{
> +	int i;
> +
> +	if (h->chainsize <=3D 0)
> +		return 0;
> +
> +	h->ioaccel2_cmd_sg_list =3D
> +		kzalloc(sizeof(*h->ioaccel2_cmd_sg_list) * h->nr_cmds,
> +					GFP_KERNEL);
> +	if (!h->ioaccel2_cmd_sg_list)
> +		return -ENOMEM;
> +	for (i =3D 0; i < h->nr_cmds; i++) {
> +		h->ioaccel2_cmd_sg_list[i] =3D
> +			kmalloc(sizeof(*h->ioaccel2_cmd_sg_list[i]) *
> +					h->maxsgentries, GFP_KERNEL);
> +		if (!h->ioaccel2_cmd_sg_list[i])
> +			goto clean;
> +	}
> +	return 0;
> +
> +clean:
> +	hpsa_free_ioaccel2_sg_chain_blocks(h);
> +	return -ENOMEM;
> +}
> +
>  static void hpsa_free_sg_chain_blocks(struct ctlr_info *h)
>  {
>  	int i;
Any reason why you didn't use mempools here?

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
