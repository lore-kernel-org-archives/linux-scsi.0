From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v8 4/4] sd: change to auto suspend mode
Date: Wed, 30 Jan 2013 10:38:26 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301301032460.1709-100000@iolanthe.rowland.org>
References: <1359538494-2936-5-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1359538494-2936-5-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 30 Jan 2013, Aaron Lu wrote:

> From: Lin Ming <ming.m.lin@intel.com>
> 
> Uses block layer runtime pm helper functions in
> scsi_runtime_suspend/resume for devices that take advantage of it.
> 
> Remove scsi_autopm_* from sd open/release path and check_events path.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

A couple of very minor suggestions...

> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c

> @@ -144,18 +144,44 @@ static int scsi_bus_restore(struct device *dev)
>  
>  #ifdef CONFIG_PM_RUNTIME
>  
> +static int scsi_blk_runtime_suspend(struct device *dev)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);

For this routine and the other new ones, it may be slightly more
efficient to pass both dev and sdev as arguments (this depends on how
smart the compiler's optimizer is).  The caller already knows both of
them, after all.

> +	int err;
> +
> +	err = blk_pre_runtime_suspend(sdev->request_queue);
> +	if (err)
> +		return err;
> +	err = pm_generic_runtime_suspend(dev);
> +	blk_post_runtime_suspend(sdev->request_queue, err);
> +
> +	return err;
> +}
> +
> +static int scsi_dev_runtime_suspend(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +	int err;
> +
> +	err = scsi_dev_type_suspend(dev, pm ? pm->runtime_suspend : NULL);
> +	if (err == -EAGAIN)
> +		pm_schedule_suspend(dev, jiffies_to_msecs(
> +					round_jiffies_up_relative(HZ/10)));
> +
> +	return err;
> +}
> +
>  static int scsi_runtime_suspend(struct device *dev)
>  {
>  	int err = 0;
> -	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  
>  	dev_dbg(dev, "scsi_runtime_suspend\n");
>  	if (scsi_is_sdev_device(dev)) {
> -		err = scsi_dev_type_suspend(dev,
> -				pm ? pm->runtime_suspend : NULL);
> -		if (err == -EAGAIN)
> -			pm_schedule_suspend(dev, jiffies_to_msecs(
> -				round_jiffies_up_relative(HZ/10)));
> +		struct scsi_device *sdev = to_scsi_device(dev);

There should be a blank line between the declaration and the
executable code.

> +		if (sdev->request_queue->dev)
> +			err = scsi_blk_runtime_suspend(dev);
> +		else
> +			err = scsi_dev_runtime_suspend(dev);
>  	}
>  
>  	/* Insert hooks here for targets, hosts, and transport classes */
> @@ -163,14 +189,36 @@ static int scsi_runtime_suspend(struct device *dev)
>  	return err;
>  }
>  
> +static int scsi_blk_runtime_resume(struct device *dev)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	int err;
> +
> +	blk_pre_runtime_resume(sdev->request_queue);
> +	err = pm_generic_runtime_resume(dev);
> +	blk_post_runtime_resume(sdev->request_queue, err);
> +
> +	return err;
> +}
> +
> +static int scsi_dev_runtime_resume(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;

Blank line.

> +	return scsi_dev_type_resume(dev, pm ? pm->runtime_resume : NULL);
> +}
> +
>  static int scsi_runtime_resume(struct device *dev)
>  {
>  	int err = 0;
> -	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  
>  	dev_dbg(dev, "scsi_runtime_resume\n");
> -	if (scsi_is_sdev_device(dev))
> -		err = scsi_dev_type_resume(dev, pm ? pm->runtime_resume : NULL);
> +	if (scsi_is_sdev_device(dev)) {
> +		struct scsi_device *sdev = to_scsi_device(dev);

Blank line.

> +		if (sdev->request_queue->dev)
> +			err = scsi_blk_runtime_resume(dev);
> +		else
> +			err = scsi_dev_runtime_resume(dev);
> +	}
>  
>  	/* Insert hooks here for targets, hosts, and transport classes */
>  
> @@ -185,10 +233,17 @@ static int scsi_runtime_idle(struct device *dev)
>  
>  	/* Insert hooks here for targets, hosts, and transport classes */
>  
> -	if (scsi_is_sdev_device(dev))
> -		err = pm_schedule_suspend(dev, 100);
> -	else
> +	if (scsi_is_sdev_device(dev)) {
> +		struct scsi_device *sdev = to_scsi_device(dev);

Blank line.

> +		if (sdev->request_queue->dev) {
> +			pm_runtime_mark_last_busy(dev);
> +			err = pm_runtime_autosuspend(dev);
> +		} else {
> +			err = pm_schedule_suspend(dev, 100);
> +		}
> +	} else {
>  		err = pm_runtime_suspend(dev);
> +	}
>  	return err;
>  }

Alan Stern

