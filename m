From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 4/4] sd: change to auto suspend mode
Date: Tue, 5 Feb 2013 11:51:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1302051147370.2245-100000@iolanthe.rowland.org>
References: <1360051396-3080-5-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1360051396-3080-5-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 5 Feb 2013, Aaron Lu wrote:

> From: Lin Ming <ming.m.lin@intel.com>
> 
> Uses block layer runtime pm helper functions in
> scsi_runtime_suspend/resume for devices that take advantage of it.
> 
> Remove scsi_autopm_* from sd open/release path and check_events path.

One thing is a little odd here...

> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -144,33 +144,78 @@ static int scsi_bus_restore(struct device *dev)
>  
>  #ifdef CONFIG_PM_RUNTIME
>  
> +static int sdev_blk_runtime_suspend(struct scsi_device *sdev,
> +					int (*cb)(struct device *))
> +{
> +	int err;
> +
> +	err = blk_pre_runtime_suspend(sdev->request_queue);
> +	if (err)
> +		return err;
> +	if (cb)
> +		err = cb(&sdev->sdev_gendev);
> +	blk_post_runtime_suspend(sdev->request_queue, err);
> +
> +	return err;
> +}
> +
> +static int sdev_runtime_suspend(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +	int (*cb)(struct device *) = pm ? pm->runtime_suspend : NULL;
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +
> +	if (sdev->request_queue->dev)
> +		return sdev_blk_runtime_suspend(sdev, cb);
> +	else
> +		return scsi_dev_type_suspend(dev, cb);
> +}
> +
>  static int scsi_runtime_suspend(struct device *dev)
>  {
>  	int err = 0;
> -	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  
>  	dev_dbg(dev, "scsi_runtime_suspend\n");
> -	if (scsi_is_sdev_device(dev)) {
> -		err = scsi_dev_type_suspend(dev,
> -				pm ? pm->runtime_suspend : NULL);
> -		if (err == -EAGAIN)
> -			pm_schedule_suspend(dev, jiffies_to_msecs(
> -				round_jiffies_up_relative(HZ/10)));
> -	}
> +	if (scsi_is_sdev_device(dev))
> +		err = sdev_runtime_suspend(dev);

The "if (err == -EAGAIN)" test and the call to pm_schedule_suspend seem
to have been dropped since v8 of this series.  It looks like they ought
to be moved into sdev_runtime_suspend.

Alan Stern

