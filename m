From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 17/18] scsi: Add scsi_vpd_tpg_id()
Date: Tue, 24 Nov 2015 13:17:44 +0100
Message-ID: <1448367464.2877.26.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-18-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbbKXMRp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:17:45 -0500
In-Reply-To: <1447081703-110552-18-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Implement scsi_vpd_tpg_id() to extract the target
> port group id and the relative port id from
> SCSI VPD page 0x83.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi_lib.c=C2=A0=C2=A0=C2=A0=C2=A0| 48
> ++++++++++++++++++++++++++++++++++++++++++++++
> =C2=A0include/scsi/scsi_device.h |=C2=A0=C2=A01 +
> =C2=A02 files changed, 49 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3cb295c..d12edc8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -23,6 +23,7 @@
> =C2=A0#include <linux/scatterlist.h>
> =C2=A0#include <linux/blk-mq.h>
> =C2=A0#include <linux/ratelimit.h>
> +#include <asm/unaligned.h>
> =C2=A0
> =C2=A0#include <scsi/scsi.h>
> =C2=A0#include <scsi/scsi_cmnd.h>
> @@ -3294,3 +3295,50 @@ next_desig:
> =C2=A0	return id_size;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(scsi_vpd_lun_id);
> +
> +/*
> + * scsi_vpd_tpg_id - return a target port group identifier
> + * @sdev: SCSI device
> + *
> + * Returns the Target Port Group identifier from the information
> + * froom VPD page 0x83 of the device.
> + *
> + * Returns the identifier or error on failure.
> + */
> +int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
> +{
> +	unsigned char *d;
> +	unsigned char __rcu *vpd_pg83;
> +	int group_id =3D -EAGAIN, rel_port =3D -1;
> +
> +	rcu_read_lock();
> +	vpd_pg83 =3D rcu_dereference(sdev->vpd_pg83);
> +	if (!vpd_pg83) {
> +		rcu_read_unlock();
> +		return -ENXIO;
> +	}
> +
> +	d =3D sdev->vpd_pg83 + 4;
> +	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
> +		switch (d[1] & 0xf) {
> +		case 0x4:
> +			/* Relative target port */
> +			rel_port =3D get_unaligned_be16(&d[6]);
> +			break;
> +		case 0x5:
> +			/* Target port group */
> +			group_id =3D get_unaligned_be16(&d[6]);
> +			break;
> +		default:
> +			break;
> +		}
> +		d +=3D d[3] + 4;
> +	}
> +	rcu_read_unlock();
> +
> +	if (group_id >=3D 0 && rel_id && rel_port !=3D -1)
> +		*rel_id =3D rel_port;
> +
> +	return group_id;
> +}
> +EXPORT_SYMBOL(scsi_vpd_tpg_id);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 4c49cfa..f63a167 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -416,6 +416,7 @@ static inline int scsi_execute_req(struct
> scsi_device *sdev,
> =C2=A0extern void sdev_disable_disk_events(struct scsi_device *sdev);
> =C2=A0extern void sdev_enable_disk_events(struct scsi_device *sdev);
> =C2=A0extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t=
);
> +extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
> =C2=A0
> =C2=A0#ifdef CONFIG_PM
> =C2=A0extern int scsi_autopm_get_device(struct scsi_device *);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
