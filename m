From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 14:00:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E318D5F.20200@splentec.com>
References: <Pine.LNX.4.44L0.0301241026060.821-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Doug Ledford <dledford@redhat.com>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
 >
> Matt's current proposed patch has the USB LLDD calling
> scsi_unregister_host()  (because the device is respresented as an emulated

A LLDD should and must *not* call scsi_unregister_host().  This brakes
all hierarchy.

Let's not make a distinction between a USB LLDD and any LLDD wrt hotplugging,
else we'll have a big mess and plenty of code duplication.

When a device gets unplugged and the LLDD notices it, it will set the device
to off in its own tables, call scsi_set_device_offline(dev) and from that
point on *if* any commands for that device step in through queuecommand()
method, they will return with the appropriate error.

scsi_set_device_offline(dev) will do whatever it has to do, which IMHO
is to, as Doug suggested, start error recovery (i.e. less code, less code
duplication in LLDD), and call an upper level hook. *

* Though I'm not quite certain where that error recovery should
be started... Maybe that upper level hook after doing whatever it
has to do, it will start the error recovery, or maybe it doesn't matter
for now.  But, an upper level hook call is, IMHO, mandatory for many
reasons.

Now, here we have the alternatives: scsi_set_device_offline() calls
slave_destroy(), or slave_destory() is called later on when upper
level structs has been cleaned.

In fact, it wouldn't matter, if SCSI Core takes over error return,
via post scsi_set_device_offline(dev) call.

> host adapter) when it learns that the device is gone.  Provided that
> routine doesn't block for very long, provided it handles all the details
> of hotplug notifications, and provided it guarantees that after it returns
> there will be no more calls to the emulated adapter, I don't see any
> problem.  The LLDD can go ahead and remove all records of the former
> device, secure in the knowledge that all pointers to data structures and
> entry points have been erased.

A LLDD shouldn't be so concerned with ``blocking'', unless *it* sets timers
on calls to an upper level like SCSI Core functions.

A LLDD has quite a clean and clear function it's supposed to do.

-- 
Luben



