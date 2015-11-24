From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 15/18] scsi: Add scsi_vpd_lun_id()
Date: Tue, 24 Nov 2015 13:17:23 +0100
Message-ID: <1448367443.2877.24.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-16-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbbKXMRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:17:24 -0500
In-Reply-To: <1447081703-110552-16-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Add a function scsi_vpd_lun_id() to return a unique device
> identifcation based on the designation descriptors of
> VPD page 0x83.
>=20
> As devices might implement several descriptors the order
> of preference is:
> - NAA IEE Registered Extended
> - EUI-64 based 16-byte
> - EUI-64 based 12-byte
> - NAA IEEE Registered
> - NAA IEEE Extended
> A SCSI name string descriptor is preferred to all of them
> if the identification is longer than 16 bytes.
>=20
> The returned unique device identification will be formatted
> as a SCSI Name string to avoid clashes between different
> designator types.
>=20
> Reviewed-by: Ewan Milne <emilne@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi_lib.c=C2=A0=C2=A0=C2=A0=C2=A0| 140
> +++++++++++++++++++++++++++++++++++++++++++++
> =C2=A0include/scsi/scsi_device.h |=C2=A0=C2=A0=C2=A01 +
> =C2=A02 files changed, 141 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index cbfc599..3cb295c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3154,3 +3154,143 @@ void sdev_enable_disk_events(struct
> scsi_device *sdev)
> =C2=A0	atomic_dec(&sdev->disk_events_disable_depth);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(sdev_enable_disk_events);
> +
> +/*
> + * scsi_vpd_lun_id - return a unique device identification
> + * @sdev: SCSI device
> + * @id:=C2=A0=C2=A0=C2=A0buffer for the identification
> + * @id_len:=C2=A0=C2=A0length of the buffer
> + *
> + * Copies a unique device identification into @id based
> + * on the information in the VPD page 0x83 of the device.
> + * The string will be formatted as a SCSI name string.
> + *
> + * Returns the length of the identification or error on failure.
> + * If the identifier is longer than the supplied buffer the actual
> + * identifier length is returned and the buffer is not zero-padded.
> + */
> +int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t
> id_len)
> +{
> +	u8 cur_id_type =3D 0xff;
> +	u8 cur_id_size =3D 0;
> +	unsigned char *d, *cur_id_str;
> +	unsigned char __rcu *vpd_pg83;
> +	int id_size =3D -EINVAL;
> +
> +	rcu_read_lock();
> +	vpd_pg83 =3D rcu_dereference(sdev->vpd_pg83);
> +	if (!vpd_pg83) {
> +		rcu_read_unlock();
> +		return -ENXIO;
> +	}
> +
> +	/*
> +	=C2=A0* Look for the correct descriptor.
> +	=C2=A0* Order of preference for lun descriptor:
> +	=C2=A0* - SCSI name string
> +	=C2=A0* - NAA IEEE Registered Extended
> +	=C2=A0* - EUI-64 based 16-byte
> +	=C2=A0* - EUI-64 based 12-byte
> +	=C2=A0* - NAA IEEE Registered
> +	=C2=A0* - NAA IEEE Extended
> +	=C2=A0* as longer descriptors reduce the likelyhood
> +	=C2=A0* of identification clashes.
> +	=C2=A0*/
> +
> +	/* The id string must be at least 20 bytes + terminating
> NULL byte */
> +	if (id_len < 21) {
> +		rcu_read_unlock();
> +		return -EINVAL;
> +	}
> +
> +	memset(id, 0, id_len);
> +	d =3D vpd_pg83 + 4;
> +	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
> +		/* Skip designators not referring to the LUN */
> +		if ((d[1] & 0x30) !=3D 0x00)
> +			goto next_desig;
> +
> +		switch (d[1] & 0xf) {
> +		case 0x2:
> +			/* EUI-64 */
> +			if (cur_id_size > d[3])
> +				break;
> +			/* Prefer NAA IEEE Registered Extended */
> +			if (cur_id_type =3D=3D 0x3 &&
> +			=C2=A0=C2=A0=C2=A0=C2=A0cur_id_size =3D=3D d[3])
> +				break;
> +			cur_id_size =3D d[3];
> +			cur_id_str =3D d + 4;
> +			cur_id_type =3D d[1] & 0xf;
> +			switch (cur_id_size) {
> +			case 8:
> +				id_size =3D snprintf(id, id_len,
> +						=C2=A0=C2=A0=C2=A0"eui.%8phN",
> +						=C2=A0=C2=A0=C2=A0cur_id_str);
> +				break;
> +			case 12:
> +				id_size =3D snprintf(id, id_len,
> +						=C2=A0=C2=A0=C2=A0"eui.%12phN",
> +						=C2=A0=C2=A0=C2=A0cur_id_str);
> +				break;
> +			case 16:
> +				id_size =3D snprintf(id, id_len,
> +						=C2=A0=C2=A0=C2=A0"eui.%16phN",
> +						=C2=A0=C2=A0=C2=A0cur_id_str);
> +				break;
> +			default:
> +				cur_id_size =3D 0;
> +				break;
> +			}
> +			break;
> +		case 0x3:
> +			/* NAA */
> +			if (cur_id_size > d[3])
> +				break;
> +			cur_id_size =3D d[3];
> +			cur_id_str =3D d + 4;
> +			cur_id_type =3D d[1] & 0xf;
> +			switch (cur_id_size) {
> +			case 8:
> +				id_size =3D snprintf(id, id_len,
> +						=C2=A0=C2=A0=C2=A0"naa.%8phN",
> +						=C2=A0=C2=A0=C2=A0cur_id_str);
> +				break;
> +			case 16:
> +				id_size =3D snprintf(id, id_len,
> +						=C2=A0=C2=A0=C2=A0"naa.%16phN",
> +						=C2=A0=C2=A0=C2=A0cur_id_str);
> +				break;
> +			default:
> +				cur_id_size =3D 0;
> +				break;
> +			}
> +			break;
> +		case 0x8:
> +			/* SCSI name string */
> +			if (cur_id_size + 4 > d[3])
> +				break;
> +			/* Prefer others for truncated descriptor */
> +			if (cur_id_size && d[3] > id_len)
> +				break;
> +			cur_id_size =3D id_size =3D d[3];
> +			cur_id_str =3D d + 4;
> +			cur_id_type =3D d[1] & 0xf;
> +			if (cur_id_size >=3D id_len)
> +				cur_id_size =3D id_len - 1;
> +			memcpy(id, cur_id_str, cur_id_size);
> +			/* Decrease priority for truncated
> descriptor */
> +			if (cur_id_size !=3D id_size)
> +				cur_id_size =3D 6;
> +			break;
> +		default:
> +			break;
> +		}
> +next_desig:
> +		d +=3D d[3] + 4;
> +	}
> +	rcu_read_unlock();
> +
> +	return id_size;
> +}
> +EXPORT_SYMBOL(scsi_vpd_lun_id);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index bde4077..4c49cfa 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -415,6 +415,7 @@ static inline int scsi_execute_req(struct
> scsi_device *sdev,
> =C2=A0}
> =C2=A0extern void sdev_disable_disk_events(struct scsi_device *sdev);
> =C2=A0extern void sdev_enable_disk_events(struct scsi_device *sdev);
> +extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
> =C2=A0
> =C2=A0#ifdef CONFIG_PM
> =C2=A0extern int scsi_autopm_get_device(struct scsi_device *);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
