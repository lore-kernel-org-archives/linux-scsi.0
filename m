From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 9 Sep 2005 10:44:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509091016490.4945-100000@iolanthe.rowland.org>
References: <4320D066.5090806@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:14829 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751388AbVIIOor (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 10:44:47 -0400
In-Reply-To: <4320D066.5090806@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 8 Sep 2005, Luben Tuikov wrote:

> >>So as far as I can see it sends a reset on the wire to the device?
> > 
> > 
> > Sort of.  It's not a low-level hardware reset, it's rather high-level.  
> > If the device's firmware is busy doing something else, or is hung, or
> > doesn't implement resets correctly, then the reset won't work.
> 
> So this is perfect for LU Reset.
> 
> >>>and the other is a USB port reset (which 
> >>>usb-storage issues when asked to do a bus reset).
> >>
> >>As far as I see this resets the port on the host side and then
> >>rediscovers the devices?
> > 
> > 
> > That's right.  (Except there's only one device to rediscover.)  This is a 
> > much lower-level action than the other sort, and is much more likely to 
> > succeed.
> 
> So this is perfect for I_T Nexus Reset.

Forgive me; I haven't read the SAM document and I'm not familiar with all
the strange SCSI terms even in the regular SCSI spec.  You're agreeing
that usb-storage uses the appropriate sort of reset operations at the
correct spots, right?


> >>What code?  What reinvention?
> > 
> > scsi_unjam_host plus the things that it calls.  Why add a private version 
> > of all that to usb-storage when it already exists in scsi_error.c?
> 
> Because it is not implemented correctly.

Are you saying the scsi_unjam_host is wrong ("implemented incorrectly")?  
Can you point out any particular errors in it, or send in a patch to fix
the implementation?


> Think about this:
> 	EH is function of scsi_host.
> 	You can define YOUR OWN EH! in usb storage, which you control!
> 	So that when you want to remove the host you know what position
> 	you're at. ;-)

Well yes, that's true.  But doing it will add extra code to the 
usb-storage driver without making it better or improving its behavior in 
any way.

> Eh, you're missing my point completely.
> Hopefully one day you can see what I mean.

And maybe you'll see what I mean.  (I really _am_ trying to understand, 
but it's always hard to communicate subtle meanings over email.)

> >>You also need to implement kref via kobject for the devices which you/USB Storage
> >>represent to SCSI Core.
> > 
> > Again, I don't need to.  The data used by usb-storage belongs to the
> > private portion of the scsi_host, so it's already protected by the host's
> > kref.
> 
> Well then, if your code is so correct, why are all these problems?

All what problems?  There aren't any problems in usb-storage.  There's an
awkward bit of code in one routine (usb_lock_device_for_reset), but that's
inevitable because of the layering violation implicit in its job.


> >> You also need to get rid of that horrible patchwork
> >>of a solution: dev_semaphore.  Maybe you can take a look in the SAS code and
> >>see how this is all done?
> > 
> > I assume you're referring to the way dev_semaphore is used in the 
> > bus_reset routine?  It's sort of a preventative measure, because the SCSI 
> > core and the driver core haven't quite settled down yet.
> 
> "Settled down" -- you mean, litte design if ever has been done writing this
> thing?  Or do you mean: "one is waiting for the other to change in certain
> ways to make it work"?

What I mean is: I wasn't sure whether scsi_remove_host would wait for the 
error handler to finish.  Until recently it would.  Now with Mike's 
changes it place, it doesn't.  With the changes you've been proposing, 
once again it would.

Since I couldn't depend on any particular behavior, I had to write the 
bus_reset routine in usb-storage so that it would work either way.  That 
meant it needed to acquire the dev_semaphore lock.

After thinking it over last night, I decided that the details of
scsi_remove_host's behavior really should remain private to the SCSI core.  
So far as I'm concerned, it's okay if it doesn't wait for the error
handler to finish and it's okay if it does.  The one _crucial_
requirement is this: It must synchronize with the error handler.  That is,
if the error handler is executing a command or a reset at the time
scsi_remove_host is called, then scsi_remove_host must not return until
the command or reset has completed.  How long it chooses to wait after
that is unimportant.

If scsi_remove_host would make that guarantee, then dev_semaphore could be 
removed from usb-storage's bus_reset.  (It wouldn't hurt to add a comment 
to scsi_remove_host, documenting the guarantee so that it doesn't get 
changed in the future.)


> > Here's the idea.  We want to protect against a race between the error 
> > handler doing a bus reset and the user doing rmmod usb-storage.  With the 
> > current code, I believe scsi_remove_host does not wait for devices to go 
> > out of error recovery.  Here is what might happen without dev_semaphore:
> > 
> > 	Error handler thread		Rmmod thread
> > 	--------------------		------------
> > 	eh calls usb-storage's bus_reset
> > 	-> calls usb_stor_port_reset
> > 	 -> calls usb_lock_device_for_reset
> > 	-> calls usb_reset_device
> > 					Driver core calls usb-storage's
> > 						remove method
> > 					storage_disconnect calls
> > 						quiesce_and_remove_host
> > 					-> locks & releases dev_semaphore (*)
> > 					-> calls scsi_remove_host
> > 						(doesn't wait for eh)
> > 					-> returns to driver core
> 
> How can all this happen if a kref (module count) is upped by one,
> due to SCSI Core using usb-storage?

I do have a blind spot for that, don't I?  All right, this can't happen by 
way of rmmod.  But it can happen if the user unbinds usb-storage via 
sysfs.

> > 	 -> usb_reset_device does
> > 		the port reset
> > 
> > (This picture is over-simplified because the driver core does some locking 
> > of its own before calling the remove method.  Let's not worry about that.)
> > 
> > Now see what has happened.  usb-storage's remove method has returned, so
> > it has given up all claims to the device.  It shouldn't do anything more
> > that will affect the device.  And yet in the eh thread it's about to do a
> > port reset!
> 
> Yes, this is because eh should be in USB Storage.

No, that wouldn't make any difference!  Particularly since the part that
does the port reset already _is_ in usb-storage.

What matters is whether or not scsi_remove_host waits for the reset to 
complete.  Adding a private error handler to usb-storage won't affect 
that.

> What would solve your problem is implementing your own eh and timer hook.
> More so for transports such as USB.

But there isn't a problem to solve!  Everything works as it is.

The only part one might object to is the awkward code in 
usb_lock_device_for_reset.  However, that code will have to remain awkward 
no matter what.  Even with a private error handler for usb-storage that 
will still be true.

Alan Stern

