From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v8 4/4] sd: change to auto suspend mode
Date: Thu, 31 Jan 2013 13:43:24 +0800
Message-ID: <20130131054324.GB14627@aaronlu.sh.intel.com>
References: <1359538494-2936-5-git-send-email-aaron.lu@intel.com>
 <Pine.LNX.4.44L0.1301301032460.1709-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21628 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3AaFml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2013 00:42:41 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301301032460.1709-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>

On Wed, Jan 30, 2013 at 10:38:26AM -0500, Alan Stern wrote:
> On Wed, 30 Jan 2013, Aaron Lu wrote:
> 
> > From: Lin Ming <ming.m.lin@intel.com>
> > 
> > Uses block layer runtime pm helper functions in
> > scsi_runtime_suspend/resume for devices that take advantage of it.
> > 
> > Remove scsi_autopm_* from sd open/release path and check_events path.
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
> A couple of very minor suggestions...
> 
> > --- a/drivers/scsi/scsi_pm.c
> > +++ b/drivers/scsi/scsi_pm.c
> 
> > @@ -144,18 +144,44 @@ static int scsi_bus_restore(struct device *dev)
> >  
> >  #ifdef CONFIG_PM_RUNTIME
> >  
> > +static int scsi_blk_runtime_suspend(struct device *dev)
> > +{
> > +	struct scsi_device *sdev = to_scsi_device(dev);
> 
> For this routine and the other new ones, it may be slightly more
> efficient to pass both dev and sdev as arguments (this depends on how
> smart the compiler's optimizer is).  The caller already knows both of
> them, after all.

What about passing only scsi_device? When device is needed, I can use
&sdev->sdev_gendev. Is this equally efficient?

> >  static int scsi_runtime_suspend(struct device *dev)
> >  {
> >  	int err = 0;
> > -	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> >  
> >  	dev_dbg(dev, "scsi_runtime_suspend\n");
> >  	if (scsi_is_sdev_device(dev)) {
> > -		err = scsi_dev_type_suspend(dev,
> > -				pm ? pm->runtime_suspend : NULL);
> > -		if (err == -EAGAIN)
> > -			pm_schedule_suspend(dev, jiffies_to_msecs(
> > -				round_jiffies_up_relative(HZ/10)));
> > +		struct scsi_device *sdev = to_scsi_device(dev);
> 
> There should be a blank line between the declaration and the
> executable code.

OK, will change this.

> > @@ -185,10 +233,17 @@ static int scsi_runtime_idle(struct device *dev)
> >  
> >  	/* Insert hooks here for targets, hosts, and transport classes */
> >  
> > -	if (scsi_is_sdev_device(dev))
> > -		err = pm_schedule_suspend(dev, 100);
> > -	else
> > +	if (scsi_is_sdev_device(dev)) {
> > +		struct scsi_device *sdev = to_scsi_device(dev);
> 
> Blank line.
> 
> > +		if (sdev->request_queue->dev) {
> > +			pm_runtime_mark_last_busy(dev);
> > +			err = pm_runtime_autosuspend(dev);
> > +		} else {
> > +			err = pm_schedule_suspend(dev, 100);
> > +		}
> > +	} else {
> >  		err = pm_runtime_suspend(dev);
> > +	}
> >  	return err;

Shall we ignore the return value for these pm_xxx_suspend functions?
I mean we do not need to record the return value for them and return it,
since pm core doesn't care the return value of idle callback.

Thanks,
Aaron

