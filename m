From: weiping zhang <zhangweiping@didichuxing.com>
Subject: Re: [PATCH] scsi: sd: add check for changing allow_restart
Date: Sat, 7 Oct 2017 16:47:39 +0800
Message-ID: <20171007084739.GB6035@source.didichuxing.com>
References: <20170927165313.GA36250@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 22.17.110.36.static.bjtelecom.net ([36.110.17.22]:11945 "EHLO
        BJEXCAS002.didichuxing.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750763AbdJGIrq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Oct 2017 04:47:46 -0400
Content-Disposition: inline
In-Reply-To: <20170927165313.GA36250@localhost.didichuxing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

On Thu, Sep 28, 2017 at 12:53:18AM +0800, weiping zhang wrote:
> /sys/class/scsi_disk/0:2:0:0/allow_restart can be changed to 0 unexpectly by
> writing invalid string, like following:
> 
> echo asdf > /sys/class/scsi_disk/0:2:0:0/allow_restart
> 
> Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
> ---
>  drivers/scsi/sd.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3ef2214..d18639f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -253,6 +253,7 @@ static ssize_t
>  allow_restart_store(struct device *dev, struct device_attribute *attr,
>  		    const char *buf, size_t count)
>  {
> +	int err, v;
>  	struct scsi_disk *sdkp = to_scsi_disk(dev);
>  	struct scsi_device *sdp = sdkp->device;
>  
> @@ -262,7 +263,11 @@ allow_restart_store(struct device *dev, struct device_attribute *attr,
>  	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
>  		return -EINVAL;
>  
> -	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
> +	err = kstrtoint(buf, 10, &v);
> +	if (err || (v != 0 && v != 1))
> +		return -EINVAL;
> +
> +	sdp->allow_restart = v;
>  
>  	return count;
>  }
> -- 
> 2.9.4
> 
Hello Martin,

Ping
