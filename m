From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 23:39:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301232339.40892.oliver@neukum.name>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030123213423.GA26415@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


> No.  You might be in a kernel thread context when you decode an interrupt
> down to determining that a device was removed, but somewhere along the
> line you took an interrupt that told you the device was removed (or else
> the command simply timed out and you are in the error handler for the
> command already).  Are you saying that the USB subsystem queues up those
> interrupt packets and decodes them later (which is fine, I just want to be
> clear on the point)?

Yes, an interrupt occurs, it's queued, a kernel thread woken up, it decodes
the interrupts and notifies the device driver.

> No.  That's what the user space hot plug manager is for.  If you want this
> type of behaviour, you take an interrupt to tell you that the device is
> gone, you mark it gone, the error handler cleans up any outstanding
> commands, then once the device no longer has any commands outstanding
> *then* the hot plug manager can successfully umount/unattach/whatever the
> device and then tell the kernel to actually remove it.  Putting this into
> the scsi stack when it's already in place elsewhere makes no sense to me.

Well, it's a SCSI matter.

> > > If the LLDD is the type such that it knows the device is gone (aka, in
> > > my driver if I get a selection timeout then I know something is fishy
> > > and can proceed from there, iSCSI may not be so lucky), then it has one
> > > of two choices.  1) it may flush any commands that it can out of the
> > > hardware and return them immediately with the same error condition as
> > > the one that it is already returning.  2) it can sit and wait for the
> > > commands to timeout one by one if that's what it wants.  Since the
> > > device has already been marked offline by scsi_set_device_offline() and
> > > the error handler thread is already scheduled to run for the device, 2
> > > is probably the easiest thing for the driver to do.  The error handler
> > > will call the abort/reset
> >
> > Again not for USB and IEEE1394. We'd have to wait for the error handler
> > to finish. Doing it ourselves is easier.
>
> OK, are you reading my comments or not?  I said "since the error handler

Oh, I do. Some of them just seem impractical from a USB point of view.

> thread is already scheduled to run for the device, 2 is probably easiest".
> In other words, you don't have to wait for anything, it's gonna happen
> post-haste.  So since you should already have proper error handling
> functions in place (You do have proper error handler functions in place,
> don't you?), duplicating that code here won't really buy you anything.

I have memory to free. I can do that only after the last command is gone.
I'd have to yield in a loop and count commands. All quite messy.

> OK, let's look at this realistically.  I'm saying you get an interrupt
> telling you that the device is gone and you tell the scsi core the same
> thing.  Immediately after that the scsi core calls your error handler
> routines to clean up any pending commands on the device.  Once all those
> pending commands are cleaned up, the hot plug manager is free to remove
> the device from the system.  Once the hot plug manager calls for the free
> to happen, you get a slave_destroy() call and you free the instances.
> This all happens in a span of a few milliseconds most likely.  Is that
> really so inconvenient for you?

Yes. There is no such thing as "most likely". I have to code for the worst
case. So "most likely" means "maybe never". Either do or don't. We cannot
have a device removal fail for any reason. It drives up complexity by an
order of magnitude.

Besides having a callback going from kernel code through user space
back to kernel code is incredibly ugly.

	Regards
		Oliver

