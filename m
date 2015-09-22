From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 16/23] scsi: Add scsi_vpd_lun_id()
Date: Tue, 22 Sep 2015 15:17:55 -0400
Message-ID: <1442949475.4132.43.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-17-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124AbbIVTR5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 15:17:57 -0400
In-Reply-To: <1440679281-13234-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Add a function scsi_vpd_lun_id() to return a unique device
> identifcation based on the designation descriptors of
> VPD page 0x83.
> 
> As devices might implement several descriptors the order
> of preference is:
> - NAA IEE Registered Extended
> - EUI-64 based 16-byte
> - EUI-64 based 12-byte
> - NAA IEEE Registered
> - NAA IEEE Extended
> A SCSI name string descriptor is preferred to all of them
> if the identification is longer than 16 bytes.
> 
> The returned unique device identification will be formatted
> as a SCSI Name string to avoid clashes between different
> designator types.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_lib.c    | 121 +++++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_device.h |   1 +
>  2 files changed, 122 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2a864b8..48d6ff6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3145,3 +3145,124 @@ void sdev_enable_disk_events(struct scsi_device *sdev)
>  	atomic_dec(&sdev->disk_events_disable_depth);
>  }
>  EXPORT_SYMBOL(sdev_enable_disk_events);
> +
> +/*
> + * scsi_vpd_lun_id - return a unique device identification
> + * @sdev: SCSI device
> + * @id:   buffer for the identification
> + * @id_len:  length of the buffer
> + *
> + * Copies a unique device identification into @id based
> + * on the information in the VPD page 0x83 of the device.
> + * The string will be formatted as a SCSI name string.
> + *
> + * Returns the length of the identification or error on failure.
> + */
> +int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
> +{
> +	u8 cur_id_type = 0xff;
> +	u8 cur_id_size = 0;
> +	unsigned char *d, *cur_id_str;
> +	int id_size = -EAGAIN;
> +
> +	/*
> +	 * Look for the correct descriptor.
> +	 * Order of preference for lun descriptor:
> +	 * - SCSI name string
> +	 * - NAA IEEE Registered Extended
> +	 * - EUI-64 based 16-byte
> +	 * - EUI-64 based 12-byte
> +	 * - NAA IEEE Registered
> +	 * - NAA IEEE Extended
> +	 * as longer descriptors reduce the likelyhood
> +	 * of identification clashes.
> +	 */
> +
> +	/* The id string must be at least 20 bytes + terminating NULL byte */
> +	if (id_len < 21)
> +		return -EINVAL;
> +
> +	memset(id, 0, id_len);
> +	d = sdev->vpd_pg83 + 4;
> +	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
> +		/* Skip designators not referring to the LUN */
> +		if ((d[1] & 0x30) != 0x00)
> +			goto next_desig;
> +
> +		switch (d[1] & 0xf) {
> +		case 0x2:
> +			/* EUI-64 */
> +			if (cur_id_size > d[3])
> +				break;
> +			/* Prefer NAA IEEE Registered Extended */
> +			if (cur_id_type == 0x3 &&
> +			    cur_id_size == d[3])
> +				break;
> +			cur_id_size = d[3];
> +			cur_id_str = d + 4;
> +			cur_id_type = d[1] & 0xf;
> +			switch (cur_id_size) {
> +			case 8:
> +				id_size = snprintf(id, id_len,
> +						   "eui.%8phN",
> +						   cur_id_str);
> +				break;
> +			case 12:
> +				id_size = snprintf(id, id_len,
> +						   "eui.%12phN",
> +						   cur_id_str);
> +				break;
> +			case 16:
> +				id_size = snprintf(id, id_len,
> +						   "eui.%16phN",
> +						   cur_id_str);
> +				break;
> +			default:
> +				cur_id_size = 0;
> +				break;
> +			}
> +			break;
> +		case 0x3:
> +			/* NAA */
> +			if (cur_id_size > d[3])
> +				break;
> +			cur_id_size = d[3];
> +			cur_id_str = d + 4;
> +			cur_id_type = d[1] & 0xf;
> +			switch (cur_id_size) {
> +			case 8:
> +				id_size = snprintf(id, id_len,
> +						   "naa.%8phN",
> +						   cur_id_str);
> +				break;
> +			case 16:
> +				id_size = snprintf(id, id_len,
> +						   "naa.%16phN",
> +						   cur_id_str);
> +				break;
> +			default:
> +				cur_id_size = 0;
> +				break;
> +			}
> +			break;
> +		case 0x8:
> +			/* SCSI name string */
> +			if (cur_id_size + 4 > d[3])
> +				break;
> +			cur_id_size = d[3];
> +			cur_id_str = d + 4;
> +			cur_id_type = d[1] & 0xf;
> +			if (cur_id_size >= id_len)
> +				cur_id_size = id_len - 1;
> +			memcpy(id, cur_id_str, cur_id_size);
> +			break;
> +		default:
> +			break;
> +		}
> +next_desig:
> +		d += d[3] + 4;
> +	}
> +
> +	return id_size;
> +}
> +EXPORT_SYMBOL(scsi_vpd_lun_id);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index b6b1dc4..595a9be 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -413,6 +413,7 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
>  }
>  extern void sdev_disable_disk_events(struct scsi_device *sdev);
>  extern void sdev_enable_disk_events(struct scsi_device *sdev);
> +extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
>  
>  #ifdef CONFIG_PM
>  extern int scsi_autopm_get_device(struct scsi_device *);

scsi_vpd_lun_id() is an exported function, but does not check if sdev->vpd_pg83 != NULL
(i.e. no VPD 83 info), and we will crash if it is NULL.  Also, why return -EAGAIN?
What will be different next time?  Maybe a different errno would be better, like
-ENOENT or -ENODATA, I'm not sure.

In the SCSI name string case, if the name has to be truncated to fit the supplied buffer,
scsi_vpd_lun_id() does not ensure that the last byte is zero, it relies on the caller to
have done this, (which alua_check_vpd() does not do).  I'm not sure if we should truncate
the SCSI name string here or return an error here, as a truncated name will likely not
be unique.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>




