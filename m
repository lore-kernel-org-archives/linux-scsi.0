From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 12:25:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030117202523.GE1225@beaverton.ibm.com>
References: <10426732153816@kroah.com> <200301170043.36577.oliver@neukum.name> <20030117085047.GB2531@beaverton.ibm.com> <200301171155.36452.oliver@neukum.name> <20030117105414.E359@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030117105414.E359@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver and Alan I am trying to catch up on this thread so I did not
reply directly to your concerns, but I think they are covered below.

Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> On Fri, Jan 17, 2003 at 11:55:36AM +0100, Oliver Neukum wrote:
> > That is simply wrong. Reporting somebody having pulled a plug must
> > not fail. What are you supposed to do with an error here?
> > 
> > There must be a way for a LLD to report that reliably.
> > If the answer is, take that lock, call that function, error all pending
> > requests, release that lock and call that function, it's OK.
> > 
> > But it must work in all cases.
> 
> I absolutely agree.  The device is gone.  I can't do anything about it.
> If the SCSI layer decides it can't let go, what am I supposed to do about
> it?
> 
> In a separate discussion with Mike, he mentioned that you can't
> scsi_remove_device() unless there are no pending commands.
> 
> How the hell is an LLD supposed to assure that!?!?
> 

I believe that the scsi_remove_host function the way it is currently is
not the correct function. The SCSI needs to separate the device gone
from freeing. There maybe some unbounded cleanup as the request_queue
that is exported to the block layer is part of the scsi_device which is
a child of the virtual usb SCSI adapter. The only way to reduce the
unbounded time is possibly we reorganizing some sysfs tree object
layouts.

> The minute I error a command and call scsi_done(), I can get a new one.
> Unless I lock out requests with scsi_block_requests(), but that comes with
> major warnings about needing to get unblocked.
> 

Well in the case of the device really being gone does the LLD need to be
worried about being unblocked. I get the feeling from this thread that
this is probably the wrong interface.

> The way this should work is that the LLD calls scsi_remove_device(), and
> that cuts off the flow of commands.  The LLD can promise to error-out any
> pending commands in the device command queue.
> 
> That is, unless scsi_block_requests() and scsi_unblock_requests() are more
> useful than the documentation suggests... block(), error all commands, 
> unregister()... that would make some sense.  We could call
> scsi_block_request() as soon as we know the unit is gone, and unregister()
> as soon as the queue is empty.


We should really ensure that we have good separation between stopping device
IO, device gone, and release resources.

	- SCSI seems to have the flags to stop the IO, but instead of
	  scsi_block_requests we may want to export the setting of
	  device online. This can be done from sysfs now, but
	  not from the driver ( the driver does have a handle to the
	  device, but it would be better to have an interface in case we
	  need to do something addition operations).

	- Possibly add a scsi_remove_device that would always succeed and
	  a version of scsi_remove_host that calls scsi_remove_device for
	  all devices. Though with the recent change to SCSI remove host to
	  allow non sysfs device registration I do not believe we could
	  ensure devices would be cleaned up.

	- SCSI would need to support ref counting so that resources are
	  not removed to soon.


-andmike
--
Michael Anderson
andmike@us.ibm.com

