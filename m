From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] [SCSI] Look up and store NAA if VPD page 0x83 is
 present
Date: Tue, 03 Jun 2014 11:13:52 +0200
Message-ID: <538D91D0.3050005@redhat.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>	<1401335565-29865-6-git-send-email-martin.petersen@oracle.com>	<538CE5B5.7030407@redhat.com> <yq11tv67qp3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaFCJN7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 05:13:59 -0400
In-Reply-To: <yq11tv67qp3.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

Il 03/06/2014 03:00, Martin K. Petersen ha scritto:
>>>>>> "Paolo" == Paolo Bonzini <pbonzini@redhat.com> writes:
>
>>> + sdev_printk(KERN_ERR, sdev,
>>> + "%s: VPD page 0x83 NAA descriptor not found\n", __func__);
>>> +
>>> + return;
>
> Paolo> I suspect this error will be relatively common.
>
> You're right. But we would like to see it for devices that actually
> implement copy offload. So I suggest the following tweak...
>
>
> [SCSI] Look up and store NAA if VPD page 0x83 is present
>
> Copy offloading requires us to know the NAA descriptor for both source
> target device. This descriptor is mandatory in the Device Identification
> VPD page. Locate this descriptor in the returned VPD data so we don't
> have to do lookups for every copy command.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 88d46fe6bf98..190dca4a8494 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1024,6 +1024,62 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
>  EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
>
>  /**
> + * scsi_lookup_naa - Lookup NAA descriptor in VPD page 0x83
> + * @sdev: The device to ask
> + *
> + * Copy offloading requires us to know the NAA descriptor for both
> + * source and target device. This descriptor is mandatory in the Device
> + * Identification VPD page. Locate this descriptor in the returned VPD
> + * data so we don't have to do lookups for every copy command.
> + */
> +static void scsi_lookup_naa(struct scsi_device *sdev)
> +{
> +	unsigned char *buf = sdev->vpd_pg83;
> +	unsigned int len = sdev->vpd_pg83_len;
> +
> +	if (buf[1] != 0x83 || get_unaligned_be16(&buf[2]) == 0) {
> +		sdev_printk(KERN_ERR, sdev,
> +			    "%s: VPD page 0x83 contains no descriptors\n",
> +			    __func__);
> +		return;
> +	}
> +
> +	buf += 4;
> +	len -= 4;
> +
> +	do {
> +		unsigned int desig_len = buf[3] + 4;
> +
> +		/* Binary code set */
> +		if ((buf[0] & 0xf) != 1)
> +			goto skip;
> +
> +		/* Target association */
> +		if ((buf[1] >> 4) & 0x3)
> +			goto skip;
> +
> +		/* NAA designator */
> +		if ((buf[1] & 0xf) != 0x3)
> +			goto skip;
> +
> +		sdev->naa = buf;
> +		sdev->naa_len = desig_len;
> +
> +		return;
> +
> +skip:
> +		buf += desig_len;
> +		len -= desig_len;
> +
> +	} while (len > 0);
> +
> +	sdev_printk(KERN_ERR, sdev,
> +		    "%s: VPD page 0x83 NAA descriptor not found\n", __func__);
> +
> +	return;
> +}
> +
> +/**
>   * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
>   * @sdev: The device to ask
>   *
> @@ -1107,6 +1163,10 @@ retry_pg83:
>  		}
>  		sdev->vpd_pg83_len = result;
>  		sdev->vpd_pg83 = vpd_buf;
> +
> +		/* Lookup NAA if 3PC set in INQUIRY response */
> +		if (sdev->inquiry_len >= 6 && sdev->inquiry[5] & (1 << 3))
> +			scsi_lookup_naa(sdev);
>  	}
>  }
>
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 5853c913d2b0..67bb70012802 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -119,6 +119,8 @@ struct scsi_device {
>  	unsigned char *vpd_pg83;
>  	int vpd_pg80_len;
>  	unsigned char *vpd_pg80;
> +	unsigned char naa_len;
> +	unsigned char *naa;
>  	unsigned char current_tag;	/* current tag */
>  	struct scsi_target      *sdev_target;   /* used only for single_lun */
>
>

