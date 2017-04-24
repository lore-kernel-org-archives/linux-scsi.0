From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Mon, 24 Apr 2017 08:28:48 -0700
Message-ID: <20170424152848.GA21855@infradead.org>
References: <20170421211302.2667649-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47229 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971487AbdDXP2t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 11:28:49 -0400
Content-Disposition: inline
In-Reply-To: <20170421211302.2667649-1-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, Bart.VanAssche@sandisk.com

On Fri, Apr 21, 2017 at 02:13:02PM -0700, Song Liu wrote:
> When a device is deleted through sysfs handle "delete", the code
> locks shost->scan_mutex. If multiple devices are deleted at the
> same time, these deletes will be handled in series.
> 
> On the other hand, some devices do long latency IO during deletion,
> for example, sd_shutdown() may do sync cache and/or start_stop.
> It is not necessary for these commands to run in series.
> 
> To reduce latency of parallel "delete" requests, this patch reduces
> the protection of scan_mutex. The only function with Scsi_Host
> called in __scsi_remove_device() is the optional slave_destroy().
> Therefore, the protection of scan_mutex is only necessary for this
> function.

And I don't think it makes sense for slave_destroy either.  Please
	do a quick audit of the instances and drop the lock for it, too.

> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 82dfe07..e7a9e28 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -610,7 +610,7 @@ static int scsi_sdev_check_buf_bit(const char *buf)
>  			return 1;
>  		else if (buf[0] == '0')
>  			return 0;
> -		else 
> +		else
>  			return -EINVAL;

Also the patch has a few odd whitespace changes like this.  Please
remove those before reposting.
