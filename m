From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/7] bnx2fc: Fix FCP RSP residual parsing.
Date: Wed, 21 Oct 2015 12:23:28 +0200
Message-ID: <562767A0.7090107@suse.de>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com> <1445283641-7358-5-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbbJUKXa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2015 06:23:30 -0400
In-Reply-To: <1445283641-7358-5-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 10/19/2015 09:40 PM, Chad Dupuis wrote:
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bn=
x2fc_io.c
> index 5d6a81b..877a79a 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1759,7 +1759,10 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc=
_cmd *io_req,
>  	int fcp_rsp_len =3D 0;
> =20
>  	io_req->fcp_status =3D FC_GOOD;
> -	io_req->fcp_resid =3D fcp_rsp->fcp_resid;
> +	io_req->fcp_resid =3D 0;
> +	if (rsp_flags & (FCOE_FCP_RSP_FLAGS_FCP_RESID_OVER |
> +	    FCOE_FCP_RSP_FLAGS_FCP_RESID_UNDER))
> +		io_req->fcp_resid =3D fcp_rsp->fcp_resid;
> =20
>  	io_req->scsi_comp_flags =3D rsp_flags;
>  	CMD_SCSI_STATUS(sc_cmd) =3D io_req->cdb_status =3D
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
