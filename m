From: Mark Haverkamp <markh@osdl.org>
Subject: Re: Possible use of uninitialized variable in sd.c
Date: Fri, 25 Feb 2005 13:26:50 -0800
Message-ID: <1109366810.5014.15.camel@markh1.pdx.osdl.net>
References: <20050225210629.GA23018@excalibur.research.wombat.ie>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:17818 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261451AbVBYV0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 16:26:54 -0500
In-Reply-To: <20050225210629.GA23018@excalibur.research.wombat.ie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kenn Humborg <kenn@linux.ie>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2005-02-25 at 21:06 +0000, Kenn Humborg wrote:
> In drivers/scsi/sd.c:sd_probe:
> 
>         int index;
> ...
>         spin_lock(&sd_index_lock);
>         error = idr_get_new(&sd_index_idr, NULL, &index);
>         spin_unlock(&sd_index_lock);
> 
>         if (index >= SD_MAX_DISKS)
>                 error = -EBUSY;
>         if (error)
>                 goto out_put;
> 
> Note that if idr_get_new() fails, index remains uninitialized.  If it
> happens to be >= SD_MAX_DISKS, the error returned from idr_get_new will
> be clobbered.  Patch initializes index to zero.

I wonder if it wouldn't be better to just check the error return before
the index value.

> 
> Signed-off-by: Kenn Humborg <kenn@linux.ie>
> 
> 
> --- src/drivers/scsi/sd.c-2.6.10	2005-02-25 21:02:17.035529833 +0000
> +++ src/drivers/scsi/sd.c	2005-02-25 21:03:09.057517937 +0000
> @@ -1409,7 +1409,7 @@
>  	struct scsi_device *sdp = to_scsi_device(dev);
>  	struct scsi_disk *sdkp;
>  	struct gendisk *gd;
> -	u32 index;
> +	u32 index = 0;
>  	int error;
>  
>  	error = -ENODEV;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Mark Haverkamp <markh@osdl.org>

