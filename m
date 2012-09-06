From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Thu, 06 Sep 2012 17:25:20 +0200
Message-ID: <6471150.bvyUxmYfmp@linux-lqwf.site>
References: <Pine.LNX.4.44L0.1209061103530.1363-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:54093 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab2IFP0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2012 11:26:50 -0400
In-Reply-To: <Pine.LNX.4.44L0.1209061103530.1363-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

On Thursday 06 September 2012 11:06:49 Alan Stern wrote:
> On Thu, 6 Sep 2012, Aaron Lu wrote:
> 
> > > That's why we have an autosuspend delay.  Although for some reason the 
> > > SCSI subsystem doesn't use it currently...  We need to add a call to 
> > > pm_runtime_use_autosuspend() in scsi_sysfs_add_sdev().  Likewise, the 
> > > pm_schedule_suspend() call in scsi_runtime_idle() should be changed to 
> > > pm_runtime_autosuspend().  And there should be calls to 
> > > pm_runtime_set_autosuspend_delay() in the sd and sr drivers.
> > 
> > I tried to use autosuspend when preparing the patch, but the fact that
> > the devices will be polled every 2 seconds make it impossible to enter
> > suspend state if the autosuspend delay is larger than that.
> 
> You can always increase the polling interval.
> 
> But in the long run that wouldn't be a good solution.  What I'd really 
> like is a way to do the status polling without having it reset the 
> idle timer.
> 
> Oliver, what do you think?  Would that be a good solution?

Well, we could introduce a flag into the requests for the polls.
But best would be to simply declare a device immediately idle
as soon as we learn that it has no medium. No special casing
would be needed.

	Regards
		Oliver

