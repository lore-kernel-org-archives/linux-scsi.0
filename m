From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Thu, 8 Sep 2005 14:36:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081330530.5768-100000@iolanthe.rowland.org>
References: <432061B5.1000407@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:61863 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964925AbVIHSgx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 14:36:53 -0400
In-Reply-To: <432061B5.1000407@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 8 Sep 2005, Luben Tuikov wrote:

> > No.  There are only two reset mechanisms available for USB Mass Storage.  
> 
> I see.
> 
> > One is a class-specific reset command (which usb-storage issues when asked 
> > to do a device reset),
> 
> So as far as I can see it sends a reset on the wire to the device?

Sort of.  It's not a low-level hardware reset, it's rather high-level.  
If the device's firmware is busy doing something else, or is hung, or
doesn't implement resets correctly, then the reset won't work.

> > and the other is a USB port reset (which 
> > usb-storage issues when asked to do a bus reset).
> 
> As far as I see this resets the port on the host side and then
> rediscovers the devices?

That's right.  (Except there's only one device to rediscover.)  This is a 
much lower-level action than the other sort, and is much more likely to 
succeed.


> > Well, usb-storage doesn't need to "remove" a failed device.  The SCSI core 
> > does a perfectly good job just by setting it off-line.  And since there 
> > aren't other targets sharing the bus, that's good enough.
> 
> Well what happens when I just unplug the device?

For a brief time (maybe 1/4 second) all commands will return DID_ERROR
and resets will return FAILED.  Then usbcore will realize that the device
has been unplugged and will call the usb-storage disconnect method, which
in turn will call scsi_remove_host.

Does that answer your question?  For more, see below.


> > We are sort of moving in that direction.  usb-storage already does its 
> > own unsolicited resets when unexpected error occur.  But we don't have 
> > anything like the error-handler's mechanism for recovering from timeouts 
> > (TUR, then device reset, then TUR, then bus reset, ...).  There doesn't 
> > seem to be any point in reinventing all that code.
> 
> What code?  What reinvention?

scsi_unjam_host plus the things that it calls.  Why add a private version 
of all that to usb-storage when it already exists in scsi_error.c?

> You _need_ to implement a timeout and eh hook if you want to do this
> in any sane way.

No I don't.  There already is a timeout in the SCSI core
(scmd->eh_timeout); I don't need to add another one.

> You also need to implement kref via kobject for the devices which you/USB Storage
> represent to SCSI Core.

Again, I don't need to.  The data used by usb-storage belongs to the
private portion of the scsi_host, so it's already protected by the host's
kref.

>  You also need to get rid of that horrible patchwork
> of a solution: dev_semaphore.  Maybe you can take a look in the SAS code and
> see how this is all done?

I assume you're referring to the way dev_semaphore is used in the 
bus_reset routine?  It's sort of a preventative measure, because the SCSI 
core and the driver core haven't quite settled down yet.

Here's the idea.  We want to protect against a race between the error 
handler doing a bus reset and the user doing rmmod usb-storage.  With the 
current code, I believe scsi_remove_host does not wait for devices to go 
out of error recovery.  Here is what might happen without dev_semaphore:

	Error handler thread		Rmmod thread
	--------------------		------------
	eh calls usb-storage's bus_reset
	-> calls usb_stor_port_reset
	 -> calls usb_lock_device_for_reset
	-> calls usb_reset_device
					Driver core calls usb-storage's
						remove method
					storage_disconnect calls
						quiesce_and_remove_host
					-> locks & releases dev_semaphore (*)
					-> calls scsi_remove_host
						(doesn't wait for eh)
					-> returns to driver core
	 -> usb_reset_device does
		the port reset

(This picture is over-simplified because the driver core does some locking 
of its own before calling the remove method.  Let's not worry about that.)

Now see what has happened.  usb-storage's remove method has returned, so
it has given up all claims to the device.  It shouldn't do anything more
that will affect the device.  And yet in the eh thread it's about to do a
port reset!

Since in reality the bus_reset routine acquires dev_semaphore, the rmmod
thread will wait at (*) until the reset has finished.  Alternatively, if
scsi_remove_host waited until the device was out of error recovery, then
we would be okay without using dev_semaphore.

The complication exists inside usb_lock_device_for_reset.  That routine
ends up calling down_trylock and looping with a timeout, because of the 
potential for a complicated deadlock that I have described before.


There's one more thing worth mentioning.  Thanks to the resets carried out
internally by usb-storage, we may decide it's easiest not to implement the
bus_reset method at all!  That would certainly solve all the problems with
dev_semaphore.  :-)

Alan Stern

