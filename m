From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 07/18] scsi_dh_alua: use standard logging functions
Date: Tue, 24 Nov 2015 13:16:16 +0100
Message-ID: <1448367376.2877.16.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbbKXMQR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:16:17 -0500
In-Reply-To: <1447081703-110552-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Use standard logging functions instead of hand-crafted ones.
>=20
> Reviewed-by: Bart Van Assche <bvanassche@sandisk.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 27 +++++++++++++--=
-----
> -------
> =C2=A01 file changed, 13 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 240a5dc..b817963 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -23,6 +23,7 @@
> =C2=A0#include <linux/delay.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <scsi/scsi.h>
> +#include <scsi/scsi_dbg.h>
> =C2=A0#include <scsi/scsi_eh.h>
> =C2=A0#include <scsi/scsi_dh.h>
> =C2=A0
> @@ -194,19 +195,14 @@ static void stpg_endio(struct request *req, int
> error)
> =C2=A0
> =C2=A0	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> =C2=A0				=C2=A0&sense_hdr)) {
> -		if (!err) {
> -			err =3D SCSI_DH_IO;
> -			goto done;
> -		}
> =C2=A0		err =3D alua_check_sense(h->sdev, &sense_hdr);
> =C2=A0		if (err =3D=3D ADD_TO_MLQUEUE) {
> =C2=A0			err =3D SCSI_DH_RETRY;
> =C2=A0			goto done;
> =C2=A0		}
> -		sdev_printk(KERN_INFO, h->sdev,
> -			=C2=A0=C2=A0=C2=A0=C2=A0"%s: stpg sense code: %02x/%02x/%02x\n",
> -			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, sense_hdr.sense_key,
> -			=C2=A0=C2=A0=C2=A0=C2=A0sense_hdr.asc, sense_hdr.ascq);
> +		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
> +			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> +		scsi_print_sense_hdr(h->sdev, ALUA_DH_NAME,
> &sense_hdr);
> =C2=A0		err =3D SCSI_DH_IO;
> =C2=A0	} else if (error)
> =C2=A0		err =3D SCSI_DH_IO;
> @@ -532,13 +528,16 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0		}
> =C2=A0
> =C2=A0		err =3D alua_check_sense(sdev, &sense_hdr);
> -		if (err =3D=3D ADD_TO_MLQUEUE && time_before(jiffies,
> expiry))
> +		if (err =3D=3D ADD_TO_MLQUEUE && time_before(jiffies,
> expiry)) {
> +			sdev_printk(KERN_ERR, sdev, "%s: rtpg
> retry\n",
> +				=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> +			scsi_print_sense_hdr(sdev, ALUA_DH_NAME,
> &sense_hdr);
> =C2=A0			goto retry;
> -		sdev_printk(KERN_INFO, sdev,
> -			=C2=A0=C2=A0=C2=A0=C2=A0"%s: rtpg sense code %02x/%02x/%02x\n",
> -			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, sense_hdr.sense_key,
> -			=C2=A0=C2=A0=C2=A0=C2=A0sense_hdr.asc, sense_hdr.ascq);
> -		err =3D SCSI_DH_IO;
> +		}
> +		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
> +			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> +		scsi_print_sense_hdr(sdev, ALUA_DH_NAME,
> &sense_hdr);
> +		return SCSI_DH_IO;
> =C2=A0	}
> =C2=A0	if (err !=3D SCSI_DH_OK)
> =C2=A0		return err;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
