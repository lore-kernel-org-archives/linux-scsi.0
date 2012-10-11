From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 4/5] pm: use callbacks from dev_pm_ops for scsi devices
Date: Thu, 11 Oct 2012 10:57:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1210111051300.1170-100000@iolanthe.rowland.org>
References: <1349932091-6856-5-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59647 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753926Ab2JKO51 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2012 10:57:27 -0400
In-Reply-To: <1349932091-6856-5-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>

I have a couple of small changes to suggest.  Nothing major.

On Thu, 11 Oct 2012, Aaron Lu wrote:

> @@ -102,26 +77,87 @@ static int scsi_bus_prepare(struct device *dev)
>  
>  static int scsi_bus_suspend(struct device *dev)
>  {
> -	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
> +	int err = 0;
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +
> +	if (scsi_is_sdev_device(dev)) {
> +		/*
> +		 * sd is the only high-level SCSI driver to implement runtime
> +		 * PM, and sd treats runtime suspend, system suspend, and
> +		 * system hibernate identically.
> +		 */

It would be better if we don't refer to sd specifically.  The comment 
could be changed to something like this:

		/*
		 * All the high-level SCSI drivers that implement runtime PM
		 * treat runtime suspend, system suspend, and system
		 * hibernate identically.
		 */

>  static int scsi_bus_freeze(struct device *dev)
>  {
> -	return scsi_bus_suspend_common(dev, PMSG_FREEZE);
> +	int err = 0;
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +
> +	if (scsi_is_sdev_device(dev)) {
> +		/* wake up device so that FREEZE will succeed */
> +		if (pm_runtime_suspended(dev))
> +			pm_runtime_resume(dev);

I'm not sure why this is here.  If none of the high-level drivers 
implement FREEZE then it's not needed.


>  static int scsi_bus_poweroff(struct device *dev)
>  {
> -	return scsi_bus_suspend_common(dev, PMSG_HIBERNATE);
> +	int err = 0;
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +
> +	if (scsi_is_sdev_device(dev)) {
> +		/*
> +		 * sd is the only high-level SCSI driver to implement runtime
> +		 * PM, and sd treats runtime suspend, system suspend, and
> +		 * system hibernate identically.
> +		 */

Same change as above for this comment.

Alan Stern

