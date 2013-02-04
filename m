From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Mon, 04 Feb 2013 16:04:57 +0800
Message-ID: <510F6BA9.1050701@intel.com>
References: <Pine.LNX.4.44L0.1302021003390.25931-100000@netrider.rowland.org> <510E025A.9000103@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <510E025A.9000103@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Derek Basehore <dbasehore@chromium.org>, James Bottomley <JBottomley@Parallels.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/03/2013 02:23 PM, Aaron Lu wrote:
> No, the modification is actually for disk.
> With v8 of block layer runtime PM, it is no longer the case runtime
> suspend is the same as system suspend for hard disk that utilize block
> layer runtime PM: we quiesce the device and run its suspend callback for
> the device during system suspend but we didn't touch the queue's
> rpm_status as we do in runtime_suspend callback. So I did some
> modifications to scsi_pm.c to make runtime suspend and system suspend do
> exactly the same thing for disk type scsi device, no matter if they are
> using block layer runtime PM or not.
> 
> Probably I had better post code here, this is a replacement for the
> patch 4 of v8 block layer runtime PM patchset(I omit the sd part, since
> it is irrevelant), please kindly review, see if you like it :-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 8f6b12c..d9956b6 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -16,17 +16,44 @@
>  
>  #include "scsi_priv.h"
>  
> +static int sdev_blk_suspend(struct scsi_device *sdev)
> +{
> +	int err;
> +
> +	err = blk_pre_runtime_suspend(sdev->request_queue);
> +	if (err)
> +		return err;
> +	err = pm_generic_runtime_suspend(&sdev->sdev_gendev);
> +	blk_post_runtime_suspend(sdev->request_queue, err);
> +
> +	return err;
> +}
> +
>  static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struct device *))
>  {
> +	struct scsi_device *sdev = to_scsi_device(dev);
>  	int err;
>  
> -	err = scsi_device_quiesce(to_scsi_device(dev));
> +	err = scsi_device_quiesce(sdev);
>  	if (err == 0) {
> -		if (cb) {
> +		if (sdev->request_queue->dev)
> +			err = sdev_blk_suspend(sdev);
> +		else if (cb)
>  			err = cb(dev);
> -			if (err)
> -				scsi_device_resume(to_scsi_device(dev));
> -		}
> +
> +		if (err)
> +			scsi_device_resume(sdev);
>  	}
>  	dev_dbg(dev, "scsi suspend: %d\n", err);
>  	return err;

I just realized that this will not work, as we can't request that there
is no request pending in the device's request queue when doing system
suspend. And if we can't request this, we will not be able to runtime
resume the device due to nr_pending may not be zero when new request
comes after system resumed, though this can be solved if we modify the
runtime resume policy.

During my test, I'm not doing any IO when suspend, so the nr_pending is
zero and it worked...

Please ignore my suggestion for this thread, sorry for the noise.

-Aaron

