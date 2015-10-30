From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 01/25] hpsa: stop zeroing reset_cmds_out and
 ioaccel_cmds_out during rescan
Date: Fri, 30 Oct 2015 08:45:44 +0100
Message-ID: <56332028.6030502@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220435.5323.57054.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbbJ3Hpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 03:45:46 -0400
In-Reply-To: <20151028220435.5323.57054.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:04 PM, Don Brace wrote:
> pulling the rug out from under the reset handler
> likewise for ioaccel_cmds_out
>=20
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 40669f8..e60c652 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3673,8 +3673,6 @@ static void hpsa_get_ioaccel_drive_info(struct =
ctlr_info *h,
>  				DRIVE_CMDS_RESERVED_FOR_FW;
>  	else
>  		dev->queue_depth =3D DRIVE_QUEUE_DEPTH; /* conservative */
> -	atomic_set(&dev->ioaccel_cmds_out, 0);
> -	atomic_set(&dev->reset_cmds_out, 0);
>  }
> =20
>  static void hpsa_get_path_info(struct hpsa_scsi_dev_t *this_device,
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
