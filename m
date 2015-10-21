From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/7] bnx2fc: Set ELS transfer length correctly for middle
 path commands.
Date: Wed, 21 Oct 2015 12:23:10 +0200
Message-ID: <5627678E.20309@suse.de>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com> <1445283641-7358-4-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbbJUKXM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2015 06:23:12 -0400
In-Reply-To: <1445283641-7358-4-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 10/19/2015 09:40 PM, Chad Dupuis wrote:
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_els.c |    1 +
>  drivers/scsi/bnx2fc/bnx2fc_io.c  |    8 ++++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/b=
nx2fc_els.c
> index 49d1e4d..0d0ab2e 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_els.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
> @@ -707,6 +707,7 @@ static int bnx2fc_initiate_els(struct bnx2fc_rpor=
t *tgt, unsigned int op,
>  	els_req->cb_func =3D cb_func;
>  	cb_arg->io_req =3D els_req;
>  	els_req->cb_arg =3D cb_arg;
> +	els_req->data_xfer_len =3D data_len;
> =20
>  	mp_req =3D (struct bnx2fc_mp_req *)&(els_req->mp_req);
>  	rc =3D bnx2fc_init_mp_req(els_req);
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bn=
x2fc_io.c
> index 520dabe..5d6a81b 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -623,8 +623,12 @@ int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req=
)
>  	mp_req =3D (struct bnx2fc_mp_req *)&(io_req->mp_req);
>  	memset(mp_req, 0, sizeof(struct bnx2fc_mp_req));
> =20
> -	mp_req->req_len =3D sizeof(struct fcp_cmnd);
> -	io_req->data_xfer_len =3D mp_req->req_len;
> +	if (io_req->cmd_type !=3D BNX2FC_ELS) {
> +		mp_req->req_len =3D sizeof(struct fcp_cmnd);
> +		io_req->data_xfer_len =3D mp_req->req_len;
> +	} else
> +		mp_req->req_len =3D io_req->data_xfer_len;=20
> +
>  	mp_req->req_buf =3D dma_alloc_coherent(&hba->pcidev->dev, CNIC_PAGE=
_SIZE,
>  					     &mp_req->req_buf_dma,
>  					     GFP_ATOMIC);
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
