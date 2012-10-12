From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v2 4/5] pm: use callbacks from dev_pm_ops for scsi devices
Date: Fri, 12 Oct 2012 14:48:23 +0800
Message-ID: <20121012064822.GB2165@mint-spring.sh.intel.com>
References: <1349932091-6856-5-git-send-email-aaron.lu@intel.com>
 <Pine.LNX.4.44L0.1210111051300.1170-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41359 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab2JLGs0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 02:48:26 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1210111051300.1170-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>

On Thu, Oct 11, 2012 at 10:57:26AM -0400, Alan Stern wrote:
> I have a couple of small changes to suggest.  Nothing major.
> 
> On Thu, 11 Oct 2012, Aaron Lu wrote:
> 
> > @@ -102,26 +77,87 @@ static int scsi_bus_prepare(struct device *dev)
> >  
> >  static int scsi_bus_suspend(struct device *dev)
> >  {
> > -	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
> > +	int err = 0;
> > +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> > +
> > +	if (scsi_is_sdev_device(dev)) {
> > +		/*
> > +		 * sd is the only high-level SCSI driver to implement runtime
> > +		 * PM, and sd treats runtime suspend, system suspend, and
> > +		 * system hibernate identically.
> > +		 */
> 
> It would be better if we don't refer to sd specifically.  The comment 
> could be changed to something like this:
> 
> 		/*
> 		 * All the high-level SCSI drivers that implement runtime PM
> 		 * treat runtime suspend, system suspend, and system
> 		 * hibernate identically.
> 		 */

OK, will do this.

> 
> >  static int scsi_bus_freeze(struct device *dev)
> >  {
> > -	return scsi_bus_suspend_common(dev, PMSG_FREEZE);
> > +	int err = 0;
> > +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> > +
> > +	if (scsi_is_sdev_device(dev)) {
> > +		/* wake up device so that FREEZE will succeed */
> > +		if (pm_runtime_suspended(dev))
> > +			pm_runtime_resume(dev);
> 
> I'm not sure why this is here.  If none of the high-level drivers 
> implement FREEZE then it's not needed.

Agree.
I should have checked the git log to see why it is here.
>From the log, it doesn't seem to have a reason.
Thanks for pointing this out.

> 
> 
> >  static int scsi_bus_poweroff(struct device *dev)
> >  {
> > -	return scsi_bus_suspend_common(dev, PMSG_HIBERNATE);
> > +	int err = 0;
> > +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> > +
> > +	if (scsi_is_sdev_device(dev)) {
> > +		/*
> > +		 * sd is the only high-level SCSI driver to implement runtime
> > +		 * PM, and sd treats runtime suspend, system suspend, and
> > +		 * system hibernate identically.
> > +		 */
> 
> Same change as above for this comment.

OK.

And thanks for reviewing.

-Aaron

