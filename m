From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 18:23:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123232325.GE26415@redhat.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301232339.40892.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 23, 2003 at 11:39:40PM +0100, Oliver Neukum wrote:
> 
> > No.  You might be in a kernel thread context when you decode an interrupt
> > down to determining that a device was removed, but somewhere along the
> > line you took an interrupt that told you the device was removed (or else
> > the command simply timed out and you are in the error handler for the
> > command already).  Are you saying that the USB subsystem queues up those
> > interrupt packets and decodes them later (which is fine, I just want to be
> > clear on the point)?
> 
> Yes, an interrupt occurs, it's queued, a kernel thread woken up, it decodes
> the interrupts and notifies the device driver.

Fine.  In that code, when it detects a device being removed, it would do 
this:

spin_lock_irqsave(&device->host->host_lock);
scsi_set_device_offline(device);
spin_unlock_irqrestore(&device->host->host_lock);

and it will, from that point on, never get another command for that 
device.  Now, what would you normally do after that?

> > No.  That's what the user space hot plug manager is for.  If you want this
> > type of behaviour, you take an interrupt to tell you that the device is
> > gone, you mark it gone, the error handler cleans up any outstanding
> > commands, then once the device no longer has any commands outstanding
> > *then* the hot plug manager can successfully umount/unattach/whatever the
> > device and then tell the kernel to actually remove it.  Putting this into
> > the scsi stack when it's already in place elsewhere makes no sense to me.
> 
> Well, it's a SCSI matter.

Unmounting a mounted filesystem is not a scsi matter.  It's not even clear 
that it's what we want in all cases.  As I mentioned in a separate private 
email, I would find it cool as hell if I could mount my USB2.0 mp3 player 
that looks like a regular hard disk and have it configured as a permanent 
mount that simply deferred I/O errors indefinitely.  Then I would be free 
to write new files to the filesystem and if the device was plugged in they 
would get sent immediately and if it wasn't then the writes would just be 
buffered until the next time the hard disk was plugged in.  Then, when it 
did get a hotplug event, if there are any buffered up events in the device 
request queue we could just kick the request queue and everything would 
get written out. 

That would just be cool as hell, but not very feasible if I follow your 
plan.  That's why I think the user space hot plug manager should decide 
what to do in these cases.

> Oh, I do. Some of them just seem impractical from a USB point of view.
> 
> > thread is already scheduled to run for the device, 2 is probably easiest".
> > In other words, you don't have to wait for anything, it's gonna happen
> > post-haste.  So since you should already have proper error handling
> > functions in place (You do have proper error handler functions in place,
> > don't you?), duplicating that code here won't really buy you anything.
> 
> I have memory to free. I can do that only after the last command is gone.
> I'd have to yield in a loop and count commands. All quite messy.

No.  You would implement a slave_destroy() entry point in your driver and 
*forget* about counting commands or yielding in a loop.  It *simplifies* 
low level drivers when they use the facilities provided.  The 
infrastructure is all there, but if you want to reimplement it yourself in 
your driver, go right ahead.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
