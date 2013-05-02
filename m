From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Double completion on retry
Date: Thu, 02 May 2013 10:34:59 +0200
Message-ID: <51822533.5080505@suse.de>
References: <1367483462-22576-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3EBIfB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 May 2013 04:35:01 -0400
In-Reply-To: <1367483462-22576-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>

On 05/02/2013 10:31 AM, Hannes Reinecke wrote:
> When blk_end_request() returns 'false' in scsi_end_request the
> request is invalid after blk_end_request_all(). So we must not
> return the then stale request pointer. Doing so will result
> in a potential double completion.
> And we should be calling scsi_release_buffers() before
> blk_end_request_all().
>=20
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c31187d..8dba66b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -581,9 +581,11 @@ static struct scsi_cmnd *scsi_end_request(struct=
 scsi_cmnd *cmd, int error,
>  	 */
>  	if (blk_end_request(req, error, bytes)) {
>  		/* kill remainder if no retrys */
> -		if (error && scsi_noretry_cmd(cmd))
> +		if (error && scsi_noretry_cmd(cmd)) {
> +			scsi_release_buffers(cmd);
>  			blk_end_request_all(req, error);
> -		else {
> +			cmd =3D NULL;
> +		} else {
>  			if (requeue) {
>  				/*
>  				 * Bleah.  Leftovers again.  Stick the
>=20
Bah, forget it. Patch is wrong.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
