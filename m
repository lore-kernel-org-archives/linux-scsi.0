From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] scsierror: fix indentation and braces disagreement - add braces
Date: Fri, 31 Oct 2008 09:03:23 +0100
Message-ID: <20081031080322.GC31673@kernel.dk>
References: <Pine.LNX.4.64.0810301259000.7072@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:40737 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYJaIEg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2008 04:04:36 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810301259000.7072@wrl-59.cs.helsinki.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: James.Bottomley@HansenPartnership.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Anderson <andmike@linux.vnet.ibm.com>

On Thu, Oct 30 2008, Ilpo J=E4rvinen wrote:
>=20
> ...and the list of recent breakage goes on and on, this time
> it's 242f9dcb8ba6f (block: unify request timeout handling)
> which broke it.
>=20
> Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
> Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/scsi/scsi_error.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 94ed262..a6b107c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -136,7 +136,7 @@ enum blk_eh_timer_return scsi_times_out(struct re=
quest *req)
>  	else
>  		eh_timed_out =3D NULL;
>=20
> -	if (eh_timed_out)
> +	if (eh_timed_out) {
>  		rtn =3D eh_timed_out(scmd);
>  		switch (rtn) {
>  		case BLK_EH_NOT_HANDLED:
> @@ -144,6 +144,7 @@ enum blk_eh_timer_return scsi_times_out(struct re=
quest *req)
>  		default:
>  			return rtn;
>  		}
> +	}
>=20
>  	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
>  		scmd->result |=3D DID_TIME_OUT << 16;
> --
> 1.5.2.2

James, will you queue this up? The missing braces are harmless as it
stands, but the patch is correct :-)

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
