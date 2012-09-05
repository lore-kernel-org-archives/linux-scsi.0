From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Wed, 5 Sep 2012 12:08:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209051154400.1837-100000@iolanthe.rowland.org>
References: <20120905152251.GA2794@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120905152251.GA2794@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 5 Sep 2012, Aaron Lu wrote:

> > > > That flag is badly named. Something like "insert_event_during_suspend"
> > > > would be better.
> 
> This flag means, the reason the device gets runtime resumed is due to
> user as described by the above situation 2, not by software(e.g. by
> sr_check_events).
> 
> I don't quite understand insert_event_during_suspend mean here...

It means: An insert event occurred while the device was suspended.

> > > >  And even so I don't see why you wouldn't
> > > > want to suspend for example a drive with an inserted but unopened disk.
> > > 
> > > I assume that Aaron wanted to handle the easiest case first.  Adding 
> > > suspend/resume handling to the open/close routines can be done later.
> > 
> > Sure, but this patch blocks that in contrast to just not implementing it.
> 
> It's already implemented. I did it in scsi_cd_get/put.
> 
> And the reason I didn't allow runtime suspend for medium inside and door
> closed case are:
> 1 ZPODD has a spec and it didn't allow that;

In theory we should allow runtime suspend in this case too, but leave 
the power on.  (Although in practice, turning the power off would 
probably work even though it may violate the spec.)

> 2 It's not easy to implement. Imagine user just inserts a disc, and the
> sr_suspend routine checks that door is closed so that it wants to
> suspend the device. But actually, after user just inserts a disc, he
> definitely wants to use the device, so it's not a good thing to do. And
> if ZPODD is used, the device will be powered off instantly when the door
> is closed, this is not good.

That's why we have an autosuspend delay.  Although for some reason the 
SCSI subsystem doesn't use it currently...  We need to add a call to 
pm_runtime_use_autosuspend() in scsi_sysfs_add_sdev().  Likewise, the 
pm_schedule_suspend() call in scsi_runtime_idle() should be changed to 
pm_runtime_autosuspend().  And there should be calls to 
pm_runtime_set_autosuspend_delay() in the sd and sr drivers.

Alan Stern

