From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Always pass result and sense on request completion
Date: Thu, 10 Dec 2009 10:49:11 +0100
Message-ID: <4B20C417.4020201@suse.de>
References: <20091119122454.71A7D3A174@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60695 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759031AbZLJJtF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 04:49:05 -0500
In-Reply-To: <20091119122454.71A7D3A174@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

Hi James,

would you mind commenting on this patch?
We really need this if we ever want to be able to do proper error code
handling from multipath.

Hannes Reinecke wrote:
> Currently we're passing the SCSI result and sense
> code only for BLK_PC commands. However, some
> instances up the stack might be interested
> in them, too. So we can as well pass the
> result and a possible sense code with every
> request.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_lib.c |   28 ++++++++++++----------------
>  1 files changed, 12 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index cc0a06f..10aa084 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -722,23 +722,19 @@ void scsi_io_completion(struct scsi_cmnd *cmd, =
unsigned int good_bytes)
>  			sense_deferred =3D scsi_sense_is_deferred(&sshdr);
>  	}
> =20
> -	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
> -		req->errors =3D result;
> -		if (result) {
> -			if (sense_valid && req->sense) {
> -				/*
> -				 * SG_IO wants current and deferred errors
> -				 */
> -				int len =3D 8 + cmd->sense_buffer[7];
> +	req->errors =3D result;
> +	if (sense_valid && req->sense) {
> +		int len =3D 8 + cmd->sense_buffer[7];
> +
> +		if (len > SCSI_SENSE_BUFFERSIZE)
> +			len =3D SCSI_SENSE_BUFFERSIZE;
> +		memcpy(req->sense, cmd->sense_buffer,  len);
> +		req->sense_len =3D len;
> +	}
> =20
> -				if (len > SCSI_SENSE_BUFFERSIZE)
> -					len =3D SCSI_SENSE_BUFFERSIZE;
> -				memcpy(req->sense, cmd->sense_buffer,  len);
> -				req->sense_len =3D len;
> -			}
> -			if (!sense_deferred)
> -				error =3D -EIO;
> -		}
> +	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
> +		if ((result) && (!sense_deferred))
> +			error =3D -EIO;
> =20
>  		req->resid_len =3D scsi_get_resid(cmd);
> =20

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
