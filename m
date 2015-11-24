From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 08/18] scsi_dh_alua: return standard SCSI return codes
 in submit_rtpg
Date: Tue, 24 Nov 2015 13:16:27 +0100
Message-ID: <1448367387.2877.17.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbbKXMQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:16:28 -0500
In-Reply-To: <1447081703-110552-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Fixup submit_rtpg() to always return a standard SCSI return code.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 33 +++++++++++++++=
-----
> ----------
> =C2=A01 file changed, 17 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index b817963..50fe87c 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -138,11 +138,13 @@ static unsigned submit_rtpg(struct scsi_device
> *sdev, struct alua_dh_data *h,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0bool rtpg_ext_hdr_req)
> =C2=A0{
> =C2=A0	struct request *rq;
> -	int err =3D SCSI_DH_RES_TEMP_UNAVAIL;
> +	int err =3D 0;
> =C2=A0
> =C2=A0	rq =3D get_alua_req(sdev, h->buff, h->bufflen, READ);
> -	if (!rq)
> +	if (!rq) {
> +		err =3D DRIVER_BUSY << 24;
> =C2=A0		goto done;
> +	}
> =C2=A0
> =C2=A0	/* Prepare the command. */
> =C2=A0	rq->cmd[0] =3D MAINTENANCE_IN;
> @@ -160,13 +162,9 @@ static unsigned submit_rtpg(struct scsi_device
> *sdev, struct alua_dh_data *h,
> =C2=A0	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> =C2=A0	rq->sense_len =3D 0;
> =C2=A0
> -	err =3D blk_execute_rq(rq->q, NULL, rq, 1);
> -	if (err =3D=3D -EIO) {
> -		sdev_printk(KERN_INFO, sdev,
> -			=C2=A0=C2=A0=C2=A0=C2=A0"%s: rtpg failed with %x\n",
> -			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, rq->errors);
> -		err =3D SCSI_DH_IO;
> -	}
> +	blk_execute_rq(rq->q, NULL, rq, 1);
> +	if (rq->errors)
> +		err =3D rq->errors;
> =C2=A0	blk_put_request(rq);
> =C2=A0done:
> =C2=A0	return err;
> @@ -493,7 +491,7 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0	struct scsi_sense_hdr sense_hdr;
> =C2=A0	int len, k, off, valid_states =3D 0;
> =C2=A0	unsigned char *ucp;
> -	unsigned err;
> +	unsigned err, retval;
> =C2=A0	bool rtpg_ext_hdr_req =3D 1;
> =C2=A0	unsigned long expiry, interval =3D 0;
> =C2=A0	unsigned int tpg_desc_tbl_off;
> @@ -505,12 +503,17 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0		expiry =3D round_jiffies_up(jiffies + h-
> >transition_tmo * HZ);
> =C2=A0
> =C2=A0 retry:
> -	err =3D submit_rtpg(sdev, h, rtpg_ext_hdr_req);
> -
> -	if (err =3D=3D SCSI_DH_IO) {
> +	retval =3D submit_rtpg(sdev, h, rtpg_ext_hdr_req);
> +	if (retval) {
> =C2=A0		if (!scsi_normalize_sense(h->sense,
> SCSI_SENSE_BUFFERSIZE,
> -					=C2=A0=C2=A0&sense_hdr))
> +					=C2=A0=C2=A0&sense_hdr)) {
> +			sdev_printk(KERN_INFO, sdev,
> +				=C2=A0=C2=A0=C2=A0=C2=A0"%s: rtpg failed, result %d\n",
> +				=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, retval);
> +			if (driver_byte(retval) =3D=3D DRIVER_BUSY)
> +				return SCSI_DH_DEV_TEMP_BUSY;
> =C2=A0			return SCSI_DH_IO;
> +		}
> =C2=A0
> =C2=A0		/*
> =C2=A0		=C2=A0* submit_rtpg() has failed on existing arrays
> @@ -539,8 +542,6 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0		scsi_print_sense_hdr(sdev, ALUA_DH_NAME,
> &sense_hdr);
> =C2=A0		return SCSI_DH_IO;
> =C2=A0	}
> -	if (err !=3D SCSI_DH_OK)
> -		return err;
> =C2=A0
> =C2=A0	len =3D (h->buff[0] << 24) + (h->buff[1] << 16) +
> =C2=A0		(h->buff[2] << 8) + h->buff[3] + 4;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
