From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH 1/2] Introduce scsi_get_vpd_buf()
Date: Mon, 28 Aug 2017 06:02:25 +0000
Message-ID: <AT5PR84MB0308133ADD53211EA4D28088FD9E0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170825203601.23612-1-bart.vanassche@wdc.com>
 <20170825203601.23612-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hpe.com ([15.241.140.75]:55888 "EHLO
        g4t3426.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdH1GDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Aug 2017 02:03:40 -0400
In-Reply-To: <20170825203601.23612-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>

> -----Original Message-----
> From: Bart Van Assche [mailto:bart.vanassche@wdc.com]
> Sent: Saturday, August 26, 2017 6:36 AM
> To: Martin K . Petersen <martin.petersen@oracle.com>; James E . J .
> Bottomley <jejb@linux.vnet.ibm.com>
> Cc: linux-scsi@vger.kernel.org; Bart Van Assche <bart.vanassche@wdc.com>;
> Christoph Hellwig <hch@lst.de>; Hannes Reinecke <hare@suse.de>;
> Johannes Thumshirn <jthumshirn@suse.de>; Seymour, Shane M
> <shane.seymour@hpe.com>
> Subject: [PATCH 1/2] Introduce scsi_get_vpd_buf()
> 
> This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Shane M Seymour <shane.seymour@hpe.com>
> ---
>  drivers/scsi/scsi.c | 96 +++++++++++++++++++++++++--------------------------
> --
>  1 file changed, 45 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3d38c6d463b8..775f609f89e2 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -411,6 +411,41 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8
> page, unsigned char *buf,
>  }
>  EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
> 
> +/**
> + * scsi_get_vpd_buf - Get Vital Product Data from a SCSI device
> + * @sdev: The device to ask
> + * @page: Which Vital Product Data to return
> + * @len: Upon success, the VPD length will be stored in *@len.
> + *
> + * Returns %NULL upon failure.
> + */
> +static unsigned char *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page,
> +				       int *len)
> +{
> +	unsigned char *vpd_buf;
> +	int vpd_len = SCSI_VPD_PG_LEN, result;
> +
> +retry_pg:
> +	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
> +	if (!vpd_buf)
> +		return NULL;
> +
> +	result = scsi_vpd_inquiry(sdev, vpd_buf, page, vpd_len);
> +	if (result < 0) {
> +		kfree(vpd_buf);
> +		return NULL;
> +	}
> +	if (result > vpd_len) {
> +		vpd_len = result;
> +		kfree(vpd_buf);
> +		goto retry_pg;
> +	}
> +
> +	*len = result;
> +
> +	return vpd_buf;
> +}
> +
>  /**
>   * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
>   * @sdev: The device to ask
> @@ -422,8 +457,8 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
>   */
>  void scsi_attach_vpd(struct scsi_device *sdev)
>  {
> -	int result, i;
> -	int vpd_len = SCSI_VPD_PG_LEN;
> +	int i;
> +	int vpd_len;
>  	int pg80_supported = 0;
>  	int pg83_supported = 0;
>  	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
> @@ -431,51 +466,25 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>  	if (!scsi_device_supports_vpd(sdev))
>  		return;
> 
> -retry_pg0:
> -	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
> +	/* Ask for all the pages supported by this device */
> +	vpd_buf = scsi_get_vpd_buf(sdev, 0, &vpd_len);
>  	if (!vpd_buf)
>  		return;
> 
> -	/* Ask for all the pages supported by this device */
> -	result = scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
> -	if (result < 0) {
> -		kfree(vpd_buf);
> -		return;
> -	}
> -	if (result > vpd_len) {
> -		vpd_len = result;
> -		kfree(vpd_buf);
> -		goto retry_pg0;
> -	}
> -
> -	for (i = 4; i < result; i++) {
> +	for (i = 4; i < vpd_len; i++) {
>  		if (vpd_buf[i] == 0x80)
>  			pg80_supported = 1;
>  		if (vpd_buf[i] == 0x83)
>  			pg83_supported = 1;
>  	}
>  	kfree(vpd_buf);
> -	vpd_len = SCSI_VPD_PG_LEN;
> 
>  	if (pg80_supported) {
> -retry_pg80:
> -		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
> -		if (!vpd_buf)
> -			return;
> -
> -		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
> -		if (result < 0) {
> -			kfree(vpd_buf);
> -			return;
> -		}
> -		if (result > vpd_len) {
> -			vpd_len = result;
> -			kfree(vpd_buf);
> -			goto retry_pg80;
> -		}
> +		vpd_buf = scsi_get_vpd_buf(sdev, 0x80, &vpd_len);
> +
>  		mutex_lock(&sdev->inquiry_mutex);
>  		orig_vpd_buf = sdev->vpd_pg80;
> -		sdev->vpd_pg80_len = result;
> +		sdev->vpd_pg80_len = vpd_len;
>  		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
>  		mutex_unlock(&sdev->inquiry_mutex);
>  		synchronize_rcu();
> @@ -483,28 +492,13 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>  			kfree(orig_vpd_buf);
>  			orig_vpd_buf = NULL;
>  		}
> -		vpd_len = SCSI_VPD_PG_LEN;
>  	}
> 
>  	if (pg83_supported) {
> -retry_pg83:
> -		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
> -		if (!vpd_buf)
> -			return;
> -
> -		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x83, vpd_len);
> -		if (result < 0) {
> -			kfree(vpd_buf);
> -			return;
> -		}
> -		if (result > vpd_len) {
> -			vpd_len = result;
> -			kfree(vpd_buf);
> -			goto retry_pg83;
> -		}
> +		vpd_buf = scsi_get_vpd_buf(sdev, 0x83, &vpd_len);
>  		mutex_lock(&sdev->inquiry_mutex);
>  		orig_vpd_buf = sdev->vpd_pg83;
> -		sdev->vpd_pg83_len = result;
> +		sdev->vpd_pg83_len = vpd_len;
>  		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
>  		mutex_unlock(&sdev->inquiry_mutex);
>  		synchronize_rcu();
> --
> 2.14.1
