From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: 30 Mar 2003 10:23:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1049041398.21704.1451.camel@mulgrave>
References: <20030325100704.GC3868@beaverton.ibm.com>
	<1048613872.2070.12.camel@mulgrave>
	<20030325184530.GA1202@beaverton.ibm.com>
	<1048618939.1790.29.camel@mulgrave>
	<20030325232920.GB2692@beaverton.ibm.com>
	<1048779761.1789.21.camel@mulgrave>
	<20030328173253.A32352@one-eyed-alien.net>
	<1048948992.21525.1.camel@mulgrave>
	<20030329125302.A10565@one-eyed-alien.net>
	<1048974903.21704.313.camel@mulgrave>
	<20030329141512.B10565@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030329141512.B10565@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2003-03-29 at 16:15, Matthew Dharm wrote:
> So, the sequence goes something like this:
> 
> (1) user removes device, causing disconnect() callback in USB system to be
> called
> 
> (2) usb-storage driver markes device as gone so as to make all commands
> fail immediately, but does nothing else
> 
> (3) hotplug script is notified of USB device removal, figures out that this
> is a usb-storage device (possibly a USB/SCSI bridge), and invokes the
> hot-unplug for SCSI for each SCSI device (after unmount, etc.)  NOTE: I
> don't know how hotplug is supposed to be able to identify the bridge case.

Ideally, yes.  The driver throwing the hotplug event is supposed to be
able to distinguish between device and bridge removal.

> (4) SCSI hot-unplugging offlines the device, then removes them.
> 
> (5) Someone notices that the dead virtual host has no devices left, and
> signals the usb-storage driver that it's safe to unregister?!??!

That's the (unimplemented in scsi) refcounting in the generic device
core.  In theory, once the struct device belonging to the host's
refcount decrements to zero (and you trigger this by doing a device_put
in the first usb remove), it calls the ->release() hook.  The code
plugged into this hook knows that the devices are gone, so does the
final USB cleanup (and the scsi host removal).

> (6) SCSI mid-layer does cleanup and notifies usb-storage when it is safe to
> free resources
> 
> (7) usb-storage destroys all structures and completes cleanup
> 
> I can see how this all works, except for step #5 -- how does usb-storage
> know that it's time to unregister?
> 
> This seems awfully complicated... usb -> usb-storage -> userspace -> scsi
> -> unknown -> usb-storage -> scsi -> usb-storage is the sequence of events.

Well, USB storage devices with filesystems on top are rather complex
things to clean up after.

> It also means that if the hotplug scripts don't do the job right, we can
> wind up with lots of dead virtual HBAs lying around.  Not fatal, I guess...
> but pretty bad.
> 
> Originally we had been talking about usb -> usb-storage -> scsi ->
> usb-storage as the sequence.  userspace never got involved except as a
> helper -- it was never in the critical path. This also put the
> responsibility for faking-out devices that had been detached but not yet
> logically removed in one central place -- with this model, each HBA is
> responsible for faking-out devices on it's own.

There's just too much specific knowledge to put into the kernel.  Even
if SCSI were to offline the device, who does something about the filesys
or other applications using it?  All you gain is moving one step closer
to the solution, not the solution itself.

The way to think about this, I think, is "what would we do if the user
asked nicely before removing the device" (i.e. requested device ejection
rather than forced it).  Then the above makes perfect sense because we
have to start at the top and move down.  Since requested ejection is the
model for things like hotplug PCI busses, I'm hoping someone else is
thinking about this.

As far as the state of play today, I'm not sure if the SCSI refcounting
is correct or not.  The SCSI list traversals are certainly racy and
unsafe, and we have no SCSI hotplug event.

This is probably because no-one who develops for SCSI has access to true
hotplug hardware.  However, we do have other uses for the hotplug
infrastructure (FC device addition/removal, even SES device handling),
we're just not entirely sure how to proceed.

James


