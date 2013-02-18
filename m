From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 4/4] sd: change to auto suspend mode
Date: Mon, 18 Feb 2013 16:55:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1302181655110.6790-100000@netrider.rowland.org>
References: <20130218032039.GA25348@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20130218032039.GA25348@aaronlu.sh.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 18 Feb 2013, Aaron Lu wrote:

> Placing a WARN_ON there seems to suggest drivers should not return
> -EAGAIN, so I think I'll just add back those dropped code to
> sdev_runtime_suspend as you have suggested like this:
> 
> static int sdev_runtime_suspend(struct device *dev)
> {
> 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> 	int (*cb)(struct device *) = pm ? pm->runtime_suspend : NULL;
> 	struct scsi_device *sdev = to_scsi_device(dev);
> 	int ret;
> 
> 	if (sdev->request_queue->dev)
> 		return sdev_blk_runtime_suspend(sdev, cb);
> 
> 	ret = scsi_dev_type_suspend(dev, cb);
> 	if (ret == -EAGAIN)
> 		pm_schedule_suspend(dev, jiffies_to_msecs(
> 					round_jiffies_up_relative(HZ/10)));
> 	return ret;
> }
> 
> Does this look OK?

Yes.

Alan Stern

