From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v3 4/4] [SCSI] sd: change to auto suspend mode
Date: Wed, 23 May 2012 10:43:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205231029520.1566-100000@iolanthe.rowland.org>
References: <1337671292-15583-5-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51742 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755000Ab2EWOnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2012 10:43:31 -0400
In-Reply-To: <1337671292-15583-5-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 22 May 2012, Lin Ming wrote:

> Uses block layer runtime pm helper functions in scsi_runtime_suspend/resume.
> Remove scsi_autopm_* from sd open/release/remove path.

Sorry I didn't have time to get to this yesterday...

> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c

> @@ -171,9 +183,10 @@ static int scsi_runtime_idle(struct device *dev)
>  
>  	/* Insert hooks here for targets, hosts, and transport classes */
>  
> -	if (scsi_is_sdev_device(dev))
> -		err = pm_schedule_suspend(dev, 100);
> -	else
> +	if (scsi_is_sdev_device(dev)) {
> +		pm_runtime_mark_last_busy(dev);
> +		err = pm_request_autosuspend(dev);

This really should be pm_runtime_autosuspend(dev).  In practice there's
very little difference; it's mostly a matter of style.

> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c

> @@ -2631,7 +2624,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>  
>  	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>  		  sdp->removable ? "removable " : "");
> -	scsi_autopm_put_device(sdp);
> +	pm_runtime_put_sync_autosuspend(&sdp->sdev_gendev);

This should be left the way it was.  scsi_autopm_put_device() does 
pm_runtime_put_sync(), which will call scsi_runtime_idle(), which will 
now call pm_runtime_autosuspend().

>  	put_device(&sdkp->dev);
>  }
>  
> @@ -2755,7 +2748,6 @@ static int sd_remove(struct device *dev)
>  	struct scsi_disk *sdkp;
>  
>  	sdkp = dev_get_drvdata(dev);
> -	scsi_autopm_get_device(sdkp->device);

This line should be kept as is.  The SCSI core uses the incremented 
usage count to prevent driverless devices from being runtime-suspended.

Alan Stern


