From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 05/18] scsi_dh_alua: improved logging
Date: Tue, 01 Dec 2015 10:28:56 +0100
Message-ID: <1448962136.3103.4.camel@suse.com>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
	 <1448961418-29013-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbbLAJ25 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:28:57 -0500
In-Reply-To: <1448961418-29013-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, 2015-12-01 at 10:16 +0100, Hannes Reinecke wrote:
> Issue different logging messages if ALUA is not supported
> or the TPGS setting is invalid.
>=20
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 10 ++++++++--
> =C2=A01 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 9b3b2f7..c63f304 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -310,12 +310,18 @@ static int alua_check_tpgs(struct scsi_device *=
sdev,
> struct alua_dh_data *h)
> =C2=A0		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> =C2=A0		break;
> -	default:
> -		h->tpgs =3D TPGS_MODE_NONE;
> +	case TPGS_MODE_NONE:
> =C2=A0		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> =C2=A0		err =3D SCSI_DH_DEV_UNSUPP;
> =C2=A0		break;
> +	default:
> +		sdev_printk(KERN_INFO, sdev,
> +			=C2=A0=C2=A0=C2=A0=C2=A0"%s: unsupported TPGS setting %d\n",
> +			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, h->tpgs);
> +		h->tpgs =3D TPGS_MODE_NONE;
> +		err =3D SCSI_DH_DEV_UNSUPP;
> +		break;
> =C2=A0	}
> =C2=A0
> =C2=A0	return err;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
