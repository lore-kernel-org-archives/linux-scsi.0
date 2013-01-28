From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
Date: Mon, 28 Jan 2013 17:21:21 +0800
Message-ID: <20130128092121.GB2568@aaronlu.sh.intel.com>
References: <50FA3C38.5030308@intel.com>
 <Pine.LNX.4.44L0.1301191259040.13032-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301191259040.13032-100000@netrider.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 19, 2013 at 01:11:45PM -0500, Alan Stern wrote:
> On Sat, 19 Jan 2013, Aaron Lu wrote:
> > Considering ODD's use case, I was thinking of moving the
> > blk_pm_runtime_init call to sd.c, as sr will not use request based auto
> > suspend. Probably right before we decrease usage count for the device in
> > sd_probe_async. What do you think?
> 
> That makes sense.  But then you should review the changes in scsi_pm.c 
> to make sure they will work okay for devices that aren't using 
> block-layer runtime PM.

Now that we have two different runtime PM schemes for scsi device, and
I think there are two ways to make them work:

1 Do it all in scsi_pm.c. In bus' runtime PM callback, check if this
  device is using block layer runtime PM API, and act accordingly;
2 Do it in indivisual drivers' runtime PM callback. Bus' runtime PM
  callbacks just call pm_generic_runtime_xxx, and each driver's runtime
  PM callback will need to do what is appropriate for them.

Personally I want to go with option 1, but I would like to hear your
opinion :-)

And for option 1, the code would be like this:

static int scsi_blk_runtime_suspend(struct device *dev)
{
	struct scsi_device *sdev = to_scsi_device(dev);
	int err;

	err = blk_pre_runtime_suspend(sdev->request_queue);
	if (err)
		return err;
	err = pm_generic_runtime_suspend(dev);
	blk_post_runtime_suspend(sdev->request_queue, err);

	return err;
}

static int scsi_dev_runtime_suspend(struct device *dev)
{
	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
	int err;

	err = scsi_dev_type_suspend(dev, pm ? pm->runtime_suspend : NULL);
	if (err == -EAGAIN)
		pm_schedule_suspend(dev, jiffies_to_msecs(
					round_jiffies_up_relative(HZ/10)));

	return err;
}

static int scsi_runtime_suspend(struct device *dev)
{
	int err = 0;

	dev_dbg(dev, "scsi_runtime_suspend\n");
	if (scsi_is_sdev_device(dev)) {
		struct scsi_device *sdev = to_scsi_device(dev);
		if (sdev->request_queue->dev)
			err = scsi_blk_runtime_suspend(dev);
		else
			err = scsi_dev_runtime_suspend(dev);
	}

	/* Insert hooks here for targets, hosts, and transport classes */

	return err;
}

static int scsi_blk_runtime_resume(struct device *dev)
{
	struct scsi_device *sdev = to_scsi_device(dev);
	int err;

	blk_pre_runtime_resume(sdev->request_queue);
	err = pm_generic_runtime_resume(dev);
	blk_post_runtime_resume(sdev->request_queue, err);

	return err;
}

static int scsi_dev_runtime_resume(struct device *dev)
{
	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
	return scsi_dev_type_resume(dev, pm ? pm->runtime_resume : NULL);
}

static int scsi_runtime_resume(struct device *dev)
{
	int err = 0;

	dev_dbg(dev, "scsi_runtime_resume\n");
	if (scsi_is_sdev_device(dev)) {
		struct scsi_device *sdev = to_scsi_device(dev);
		if (sdev->request_queue->dev)
			err = scsi_blk_runtime_resume(dev);
		else
			err = scsi_dev_runtime_resume(dev);
	}

	/* Insert hooks here for targets, hosts, and transport classes */

	return err;
}

static int scsi_runtime_idle(struct device *dev)
{
	int err;

	dev_dbg(dev, "scsi_runtime_idle\n");

	/* Insert hooks here for targets, hosts, and transport classes */

	if (scsi_is_sdev_device(dev)) {
		struct scsi_device *sdev = to_scsi_device(dev);
		if (sdev->request_queue->dev) {
			pm_runtime_mark_last_busy(dev);
			err = pm_runtime_autosuspend(dev);
		} else {
			err = pm_schedule_suspend(dev, 100);
		}
	} else {
		err = pm_runtime_suspend(dev);
	}
	return err;
}

Please feel free to suggest, thanks.

-Aaron

