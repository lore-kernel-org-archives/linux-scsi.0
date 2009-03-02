From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH]scsi_dh_rdac: Retry mode select for NO_SENSE, ABORTED_COMMAND,
 UNIT_ATTENTION, NOT_READY(02/04/01)
Date: Mon, 02 Mar 2009 16:44:07 +0100
Message-ID: <49ABFEC7.7080509@suse.de>
References: <0D1E8821739E724A86F4D16902CE275C140E25C334@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:48052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbZCBPoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2009 10:44:11 -0500
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C140E25C334@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sekharan@us.ibm.com" <sekharan@us.ibm.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

Hi Vijay,

Chauhan, Vijay wrote:
> This patch is to add retry for mode select if mode select command is =
returned with sense key NO_SENSE,=20
> ABORTED_COMMAND, UNIT_ATTENTION or NOT_READY(02/04/01). This patch re=
organise the sense from=20
> if-else to switch-case format in scsi_dh_rdac.c for better maintainab=
ility.
>=20
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> ---
>=20
> --- linux-2.6.29-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	=
2009-02-24 12:08:43.000000000 +0530
> +++ linux-2.6.29-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-=
02-28 18:18:41.000000000 +0530
> @@ -449,28 +449,40 @@ static int mode_select_handle_sense(stru
>  				    unsigned char *sensebuf)
>  {
>  	struct scsi_sense_hdr sense_hdr;
> -	int sense, err =3D SCSI_DH_IO, ret;
> +	int err =3D SCSI_DH_IO, ret;
> =20
>  	ret =3D scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sens=
e_hdr);
>  	if (!ret)
>  		goto done;
> =20
>  	err =3D SCSI_DH_OK;
> -	sense =3D (sense_hdr.sense_key << 16) | (sense_hdr.asc << 8) |
> -			sense_hdr.ascq;
> -	/* If it is retryable failure, submit the c9 inquiry again */
> -	if (sense =3D=3D 0x59136 || sense =3D=3D 0x68b02 || sense =3D=3D 0x=
b8b02 ||
> -			    sense =3D=3D 0x62900) {
> -		/* 0x59136    - Command lock contention
> -		 * 0x[6b]8b02 - Quiesense in progress or achieved
> -		 * 0x62900    - Power On, Reset, or Bus Device Reset
> -		 */
> +
> +	switch (sense_hdr.sense_key) {
> +	case NO_SENSE:
> +	case ABORTED_COMMAND:
> +	case UNIT_ATTENTION:
> +		err =3D SCSI_DH_RETRY;
> +		break;
> +	case NOT_READY:
> +		if (sense_hdr.asc =3D=3D 0x04 && sense_hdr.ascq =3D=3D 0x01)
> +			/* LUN Not Ready and is in the Process
> +			 * of becoming ready
> +			 */
> +		err =3D SCSI_DH_RETRY;
Missing indentation.

What about the other 'in progress' ASC/ASQ codes (ie 04/04 - 04/09) ?
Can they safely be ignored as the array will not issue them?

> +		break;
> +	case ILLEGAL_REQUEST:
> +		if (sense_hdr.asc =3D=3D 0x91 && sense_hdr.ascq =3D=3D 0x36)
> +			/*
> +			 * Command Lock contention
> +			 */
>  		err =3D SCSI_DH_RETRY;
Again, missing indentation.

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
