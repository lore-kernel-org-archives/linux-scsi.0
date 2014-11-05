From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] osst: call scsi_set_medium_removal directly
Date: Wed, 05 Nov 2014 15:14:16 +0100
Message-ID: <545A30B8.2060301@suse.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de> <1414661229-15199-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaKEOOR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2014 09:14:17 -0500
In-Reply-To: <1414661229-15199-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On 10/30/2014 10:27 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/osst.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
> index b6d63d6..8c38464 100644
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -3327,19 +3327,18 @@ static int osst_write_frame(struct osst_tape =
* STp, struct osst_request ** aSRpn
>  /* Lock or unlock the drive door. Don't use when struct osst_request=
 allocated. */
>  static int do_door_lock(struct osst_tape * STp, int do_lock)
>  {
> -	int retval, cmd;
> +	int retval;
> =20
> -	cmd =3D do_lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK;
>  #if DEBUG
>  	printk(OSST_DEB_MSG "%s:D: %socking drive door.\n", tape_name(STp),=
 do_lock ? "L" : "Unl");
>  #endif
> -	retval =3D scsi_ioctl(STp->device, cmd, NULL);
> -	if (!retval) {
> +
> +	retval =3D scsi_set_medium_removal(STp->device,
> +			do_lock ? SCSI_REMOVAL_PREVENT : SCSI_REMOVAL_ALLOW);
> +	if (!retval)
>  		STp->door_locked =3D do_lock ? ST_LOCKED_EXPLICIT : ST_UNLOCKED;
> -	}
> -	else {
> +	else
>  		STp->door_locked =3D ST_LOCK_FAILS;
> -	}
>  	return retval;
>  }
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
