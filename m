From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] sd: fix an error return in probe()
Date: Tue, 14 Apr 2015 17:28:58 +0300
Message-ID: <20150414142858.GH10964@mwanda>
References: <20150119144112.GB19086@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26474 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbbDNO3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2015 10:29:25 -0400
Content-Disposition: inline
In-Reply-To: <20150119144112.GB19086@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

I almost accidentally sent this one again.  I still think it's correct.

regards,
dan carpenter

On Mon, Jan 19, 2015 at 05:41:12PM +0300, Dan Carpenter wrote:
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
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
