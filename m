From: Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Thu, 6 Sep 2012 06:49:13 +0800
Message-ID: <20120905224912.GA1443@localhost.localdomain>
References: <20120905152251.GA2794@localhost.localdomain>
 <Pine.LNX.4.44L0.1209051154400.1837-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41802 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759768Ab2IEWtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Sep 2012 18:49:20 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1209051154400.1837-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

On Wed, Sep 05, 2012 at 12:08:25PM -0400, Alan Stern wrote:
> On Wed, 5 Sep 2012, Aaron Lu wrote:
> 
> > > > > That flag is badly named. Something like "insert_event_during_suspend"
> > > > > would be better.
> > 
> > This flag means, the reason the device gets runtime resumed is due to
> > user as described by the above situation 2, not by software(e.g. by
> > sr_check_events).
> > 
> > I don't quite understand insert_event_during_suspend mean here...
> 
> It means: An insert event occurred while the device was suspended.

Thanks, I got it now.

> 
> > > > >  And even so I don't see why you wouldn't
> > > > > want to suspend for example a drive with an inserted but unopened disk.
> > > > 
> > > > I assume that Aaron wanted to handle the easiest case first.  Adding 
> > > > suspend/resume handling to the open/close routines can be done later.
> > > 
> > > Sure, but this patch blocks that in contrast to just not implementing it.
> > 
> > It's already implemented. I did it in scsi_cd_get/put.
> > 
> > And the reason I didn't allow runtime suspend for medium inside and door
> > closed case are:
> > 1 ZPODD has a spec and it didn't allow that;
> 
> In theory we should allow runtime suspend in this case too, but leave 
> the power on.  (Although in practice, turning the power off would 
> probably work even though it may violate the spec.)
> 

Agree. But it's not easy to implement with autosuspend.
Please see below.

> > 2 It's not easy to implement. Imagine user just inserts a disc, and the
> > sr_suspend routine checks that door is closed so that it wants to
> > suspend the device. But actually, after user just inserts a disc, he
> > definitely wants to use the device, so it's not a good thing to do. And
> > if ZPODD is used, the device will be powered off instantly when the door
> > is closed, this is not good.
> 
> That's why we have an autosuspend delay.  Although for some reason the 
> SCSI subsystem doesn't use it currently...  We need to add a call to 
> pm_runtime_use_autosuspend() in scsi_sysfs_add_sdev().  Likewise, the 
> pm_schedule_suspend() call in scsi_runtime_idle() should be changed to 
> pm_runtime_autosuspend().  And there should be calls to 
> pm_runtime_set_autosuspend_delay() in the sd and sr drivers.

I tried to use autosuspend when preparing the patch, but the fact that
the devices will be polled every 2 seconds make it impossible to enter
suspend state if the autosuspend delay is larger than that.

-Aaron
