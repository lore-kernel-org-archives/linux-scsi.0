From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 14/18] scsi_dh_alua: simplify sense code handling
Date: Tue, 24 Nov 2015 13:17:16 +0100
Message-ID: <1448367436.2877.23.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbbKXMRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:17:18 -0500
In-Reply-To: <1447081703-110552-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Most sense code is already handled in the generic
> code, so we shouldn't be adding special cases here.
> However, when doing so we need to check for
> unit attention whenever we're sending an internal
> command.
>=20
> Reviewed-by: Ewan Milne <emilne@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 45 +++++++++++----=
-----
> ----------
> =C2=A01 file changed, 17 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index c9751c9..abf05b4 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -85,7 +85,6 @@ struct alua_dh_data {
> =C2=A0#define ALUA_POLICY_SWITCH_ALL		1
> =C2=A0
> =C2=A0static char print_alua_state(int);
> -static int alua_check_sense(struct scsi_device *, struct
> scsi_sense_hdr *);
> =C2=A0
> =C2=A0static int realloc_buffer(struct alua_dh_data *h, unsigned len)
> =C2=A0{
> @@ -189,8 +188,13 @@ static void stpg_endio(struct request *req, int
> error)
> =C2=A0
> =C2=A0	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> =C2=A0				=C2=A0&sense_hdr)) {
> -		err =3D alua_check_sense(h->sdev, &sense_hdr);
> -		if (err =3D=3D ADD_TO_MLQUEUE) {
> +		if (sense_hdr.sense_key =3D=3D NOT_READY &&
> +		=C2=A0=C2=A0=C2=A0=C2=A0sense_hdr.asc =3D=3D 0x04 && sense_hdr.asc=
q =3D=3D 0x0a)
> {
> +			/* ALUA state transition already in progress
> */
> +			err =3D SCSI_DH_OK;
> +			goto done;
> +		}
> +		if (sense_hdr.sense_key =3D=3D UNIT_ATTENTION) {
> =C2=A0			err =3D SCSI_DH_RETRY;
> =C2=A0			goto done;
> =C2=A0		}
> @@ -399,28 +403,6 @@ static int alua_check_sense(struct scsi_device
> *sdev,
> =C2=A0			=C2=A0* LUN Not Accessible - ALUA state
> transition
> =C2=A0			=C2=A0*/
> =C2=A0			return ADD_TO_MLQUEUE;
> -		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D
> 0x0b)
> -			/*
> -			=C2=A0* LUN Not Accessible -- Target port in
> standby state
> -			=C2=A0*/
> -			return SUCCESS;
> -		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D
> 0x0c)
> -			/*
> -			=C2=A0* LUN Not Accessible -- Target port in
> unavailable state
> -			=C2=A0*/
> -			return SUCCESS;
> -		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D
> 0x12)
> -			/*
> -			=C2=A0* LUN Not Ready -- Offline
> -			=C2=A0*/
> -			return SUCCESS;
> -		if (sdev->allow_restart &&
> -		=C2=A0=C2=A0=C2=A0=C2=A0sense_hdr->asc =3D=3D 0x04 && sense_hdr->a=
scq =3D=3D
> 0x02)
> -			/*
> -			=C2=A0* if the device is not started, we need to
> wake
> -			=C2=A0* the error handler to start the motor
> -			=C2=A0*/
> -			return FAILED;
> =C2=A0		break;
> =C2=A0	case UNIT_ATTENTION:
> =C2=A0		if (sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D
> 0x00)
> @@ -517,9 +499,16 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0			h->flags |=3D ALUA_RTPG_EXT_HDR_UNSUPP;
> =C2=A0			goto retry;
> =C2=A0		}
> -
> -		err =3D alua_check_sense(sdev, &sense_hdr);
> -		if (err =3D=3D ADD_TO_MLQUEUE && time_before(jiffies,
> expiry)) {
> +		/*
> +		=C2=A0* Retry on ALUA state transition or if any
> +		=C2=A0* UNIT ATTENTION occurred.
> +		=C2=A0*/
> +		if (sense_hdr.sense_key =3D=3D NOT_READY &&
> +		=C2=A0=C2=A0=C2=A0=C2=A0sense_hdr.asc =3D=3D 0x04 && sense_hdr.asc=
q =3D=3D 0x0a)
> +			err =3D SCSI_DH_RETRY;
> +		else if (sense_hdr.sense_key =3D=3D UNIT_ATTENTION)
> +			err =3D SCSI_DH_RETRY;
> +		if (err =3D=3D SCSI_DH_RETRY && time_before(jiffies,
> expiry)) {
> =C2=A0			sdev_printk(KERN_ERR, sdev, "%s: rtpg
> retry\n",
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> =C2=A0			scsi_print_sense_hdr(sdev, ALUA_DH_NAME,
> &sense_hdr);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
