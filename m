From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] SCSI: add dynamic Power Management infrastructure
Date: Tue, 4 Mar 2008 11:51:48 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803041130160.4039-100000@iolanthe.rowland.org>
References: <1204586659.3043.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47285 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758548AbYCDQvt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 11:51:49 -0500
In-Reply-To: <1204586659.3043.92.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Mon, 3 Mar 2008, James Bottomley wrote:

> On Mon, 2008-03-03 at 11:09 -0500, Alan Stern wrote:
> > This patch (as1042) introduces dynamic Power Management for the SCSI
> > stack.  It keeps track of devices' logical state and adds a
> > notification callback to tell the host adapter driver when some or all
> > of the devices on a SCSI bus are no longer in use, so the link can be
> > powered down.
> > 
> > It also adds autosuspend capability (disabled initially) that can be
> > controlled by userspace, using the same sort of sysfs API as the USB
> > autosuspend implementation.
> > 
> > Everything is managed by a new Kconfig option:
> > CONFIG_SCSI_DYNAMIC_PM.  If that symbol isn't set then essentially
> > nothing is changed (some code gets moved from one source file to
> > another).
> 
> First the general comments/questions:
> 
> 1. It's done at the wrong level: suspend "device" is actually a target
> function.  There's no way on a multi-lun device we want to keep the
> flags and last_busy anywhere but in the target

Okay.

> 2. As you say in the comment, the thing we're trying to power down is
> the link.  In most SCSI implementations, the link has a rather complex
> relationship to the target, what we want to do in
> periodic_autosuspend_scan() is run over the devices on each link, and if
> they're not busy suspend the link?  What's probably needed is a set of
> adjunct helpers for the transport classes to do this.

I'd love to do it that way, but I don't understand enough about how the 
transport classes work.  If somebody could help out, I'd appreciate it.

> 3. The link power down is much faster than device spin down ... in your
> patch these two things seem to be coupled ... we really need to keep
> them separate.

I don't understand.  Is it safe in general to keep a device spun up
while taking the link down?  Or to avoid sending a SYNCHRONIZE CACHE
command before suspending the link?  I wouldn't think so.  This means
the device suspend routine must be carried out before the link is
suspended.

> 4. The entanglement with error handling is incredibly problematic (since
> eh is a nastily complex state machine in its own right).  What do
> transports that use eh_strategy_handler do about all of this?

They should prevent the link from autosuspending before starting up the
error handler and then allow it again when the handler is done.  
Ideally the core should do this for them automatically, before calling
eh_strategy_handler.

> Then the specific code:
> 
> > +scsi_mod-y                     += scsi_scan.o scsi_sysfs.o scsi_devinfo.o \
> > +                                  scsi_pm.o
> 
> If you just said N to SCSI_DYNAMIC_PM why does it still get compiled in?

Because the scsi_pm.c source file contains some code I moved from other
files, stuff that has to be compiled whether SCSI_DYNAMIC_PM is
configured or not.  When SCSI_DYNAMIC_PM isn't set then the original 
code is used, otherwise new code is used.

I suppose the old code could be left where it was, protected by 
"#ifndef CONFIG_SCSI_DYNAMIC_PM", but it doesn't seem like a good idea 
to have two versions of the same subroutine in two different source 
files.

> > 		.name		= "sd",
> >  		.probe		= sd_probe,
> >  		.remove		= sd_remove,
> > -		.suspend	= sd_suspend,
> > -		.resume		= sd_resume,
> >  		.shutdown	= sd_shutdown,
> >  	},
> >  	.rescan			= sd_rescan,
> >  	.done			= sd_done,
> > +	.suspend		= sd_suspend,
> > +	.resume			= sd_resume,
> >  };
> 
> You're duplicating the driver suspend/resume methods in scsi_driver.

(More precisely, this duplicates the method pointers, not the methods
themselves.)

The only reason for doing it like this was to avoid the "Driver '%s'
needs updating - please use bus_type methods" warning in the driver
core.  It's not otherwise important.

>  We
> just had a discussion about this at the storage summit.  Those methods
> are staying, so we might as well not duplicate them.

Then what about those warnings?

Alan Stern

