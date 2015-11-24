From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 06/18] scsi_dh_alua: sanitze sense code handling
Date: Tue, 24 Nov 2015 13:16:07 +0100
Message-ID: <1448367367.2877.15.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbbKXMQI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:16:08 -0500
In-Reply-To: <1447081703-110552-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> The only check for a valid sense code is calling
> scsi_normalize_sense()
> and check the return value. So drop the pointless checks and rely on
> scsi_normalize_sense() to figure out if the sense code is valid.
> With that we can also remove the 'senselen' field.
>=20
> Reviewed-by: Bart van Assche <bvanassche@sandisk.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 18 +++++++--------=
---
> =C2=A01 file changed, 7 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index c63f304..240a5dc 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -73,7 +73,6 @@ struct alua_dh_data {
> =C2=A0	int			bufflen;
> =C2=A0	unsigned char		transition_tmo;
> =C2=A0	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
> -	int			senselen;
> =C2=A0	struct scsi_device	*sdev;
> =C2=A0	activate_complete	callback_fn;
> =C2=A0	void			*callback_data;
> @@ -158,14 +157,13 @@ static unsigned submit_rtpg(struct scsi_device
> *sdev, struct alua_dh_data *h,
> =C2=A0
> =C2=A0	rq->sense =3D h->sense;
> =C2=A0	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> -	rq->sense_len =3D h->senselen =3D 0;
> +	rq->sense_len =3D 0;
> =C2=A0
> =C2=A0	err =3D blk_execute_rq(rq->q, NULL, rq, 1);
> =C2=A0	if (err =3D=3D -EIO) {
> =C2=A0		sdev_printk(KERN_INFO, sdev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0"%s: rtpg failed with %x\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, rq->errors);
> -		h->senselen =3D rq->sense_len;
> =C2=A0		err =3D SCSI_DH_IO;
> =C2=A0	}
> =C2=A0	blk_put_request(rq);
> @@ -194,9 +192,8 @@ static void stpg_endio(struct request *req, int
> error)
> =C2=A0		goto done;
> =C2=A0	}
> =C2=A0
> -	if (req->sense_len > 0) {
> -		err =3D scsi_normalize_sense(h->sense,
> SCSI_SENSE_BUFFERSIZE,
> -					=C2=A0=C2=A0=C2=A0&sense_hdr);
> +	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> +				=C2=A0&sense_hdr)) {
> =C2=A0		if (!err) {
> =C2=A0			err =3D SCSI_DH_IO;
> =C2=A0			goto done;
> @@ -265,7 +262,7 @@ static unsigned submit_stpg(struct alua_dh_data
> *h)
> =C2=A0
> =C2=A0	rq->sense =3D h->sense;
> =C2=A0	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> -	rq->sense_len =3D h->senselen =3D 0;
> +	rq->sense_len =3D 0;
> =C2=A0	rq->end_io_data =3D h;
> =C2=A0
> =C2=A0	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
> @@ -514,10 +511,9 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0 retry:
> =C2=A0	err =3D submit_rtpg(sdev, h, rtpg_ext_hdr_req);
> =C2=A0
> -	if (err =3D=3D SCSI_DH_IO && h->senselen > 0) {
> -		err =3D scsi_normalize_sense(h->sense,
> SCSI_SENSE_BUFFERSIZE,
> -					=C2=A0=C2=A0=C2=A0&sense_hdr);
> -		if (!err)
> +	if (err =3D=3D SCSI_DH_IO) {
> +		if (!scsi_normalize_sense(h->sense,
> SCSI_SENSE_BUFFERSIZE,
> +					=C2=A0=C2=A0&sense_hdr))
> =C2=A0			return SCSI_DH_IO;
> =C2=A0
> =C2=A0		/*

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
