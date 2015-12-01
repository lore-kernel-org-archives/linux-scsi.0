From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 03/18] scsi_dh_alua: Disable ALUA handling for non-disk
 devices
Date: Tue, 01 Dec 2015 10:25:57 +0100
Message-ID: <1448961957.3103.3.camel@suse.com>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
	 <1448961418-29013-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769AbbLAJZ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:25:59 -0500
In-Reply-To: <1448961418-29013-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, 2015-12-01 at 10:16 +0100, Hannes Reinecke wrote:
> Non-disk devices might support ALUA, but the firmware
> implementation is untested and frequently broken.
> As we're don't actually need it disable ALUA support
> for non-disk device for now.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++++++++++
> =C2=A01 file changed, 12 insertions(+)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index cc2773b..7d01ef0 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -320,6 +320,18 @@ static int alua_check_tpgs(struct scsi_device *s=
dev,
> struct alua_dh_data *h)
> =C2=A0{
> =C2=A0	int err =3D SCSI_DH_OK;
> =C2=A0
> +	/*
> +	=C2=A0* ALUA support for non-disk devices is fraught with
> +	=C2=A0* difficulties, so disable it for now.
> +	=C2=A0*/
> +	if (sdev->type !=3D TYPE_DISK) {
> +		h->tpgs =3D TPGS_MODE_NONE;
> +		sdev_printk(KERN_INFO, sdev,
> +			=C2=A0=C2=A0=C2=A0=C2=A0"%s: disable for non-disk devices\n",
> +			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> +		return SCSI_DH_DEV_UNSUPP;
> +	}
> +
> =C2=A0	h->tpgs =3D scsi_device_tpgs(sdev);
> =C2=A0	switch (h->tpgs) {
> =C2=A0	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
