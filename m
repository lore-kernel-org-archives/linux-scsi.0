From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [patch] sd: fix an error return in probe()
Date: Thu, 16 Apr 2015 14:23:28 +0200
Message-ID: <552FA9C0.7020109@redhat.com>
References: <20150119144112.GB19086@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbbDPMXb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2015 08:23:31 -0400
In-Reply-To: <20150119144112.GB19086@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 01/19/2015 03:41 PM, Dan Carpenter wrote:
> If device_add() fails then it should return the error code but instead
> the current code returns success.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ebf35cb6..75a0b55 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3019,7 +3019,8 @@ static int sd_probe(struct device *dev)
>  	sdkp->dev.class = &sd_disk_class;
>  	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
>  
> -	if (device_add(&sdkp->dev))
> +	error = device_add(&sdkp->dev);
> +	if (error)
>  		goto out_free_index;
>  
>  	get_device(dev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

