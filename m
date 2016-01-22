From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi_dh_rdac: always retry MODE SELECT on command lock
 violation
Date: Fri, 22 Jan 2016 15:48:18 +0100
Message-ID: <20160122144818.GA5963@c203.arch.suse.de>
References: <1453473761-54777-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbcAVOsY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 09:48:24 -0500
Content-Disposition: inline
In-Reply-To: <1453473761-54777-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Fri, Jan 22, 2016 at 03:42:41PM +0100, Hannes Reinecke wrote:
> If MODE SELECT returns with sense '05/91/36' (command lock violation)
> it should always be retried without counting the number of retries.
> During an HBA upgrade or similar circumstances one might see a flood
> of MODE SELECT command from various HBAs, which will easily trigger
> the sense code and exceed the retry count.
>=20
> References: bsc#956949

Without the bugzilla refrence

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_rdac.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scs=
i/device_handler/scsi_dh_rdac.c
> index 3613581..93880ed 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -562,7 +562,7 @@ static int mode_select_handle_sense(struct scsi_d=
evice *sdev,
>  			/*
>  			 * Command Lock contention
>  			 */
> -			err =3D SCSI_DH_RETRY;
> +			err =3D SCSI_DH_IMM_RETRY;
>  		break;
>  	default:
>  		break;
> @@ -612,6 +612,8 @@ retry:
>  		err =3D mode_select_handle_sense(sdev, h->sense);
>  		if (err =3D=3D SCSI_DH_RETRY && retry_cnt--)
>  			goto retry;
> +		if (err =3D=3D SCSI_DH_IMM_RETRY)
> +			goto retry;
>  	}
>  	if (err =3D=3D SCSI_DH_OK) {
>  		h->state =3D RDAC_STATE_ACTIVE;
> --=20
> 1.8.5.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
