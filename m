From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 19:19:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301231919.40422.oliver@neukum.name>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301222346.30329.oliver@neukum.name> <3E302A89.8070703@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E302A89.8070703@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Donnerstag, 23. Januar 2003 18:46 schrieb Luben Tuikov:
> Oliver Neukum wrote:
> > Not all the world is a SAN. USB has no possibility to even try an
> > interaction after the device is gone. We have to handle this flexibly.
>
> Thus the example in the original post.  I.e. for simple transports whose
> portals get notified when a device is plugged off (USB), the LLDD
> can notify SCSI Core, by setting a state variable in scsi_device.
> In which case SCSI Core can answer with the proper TARGET error code.
> (This was outlined before, scsi_command->online:1 ...)

Very well, so you agree that the SCSI layer should export to the LLDD
a function to set devices offline?

> > In fact, if a device
> > can vanish without a LLDD knowing about it, this is purely a problem of
> > the SCSI layer.
>
> No, of course not.  (Think of IP.)  When a device vanishes and LLDD doesn't
> know about it (more complicated transports), the CDB will return with
> the proper Service Response, since the transport(s) won't be able to
> deliver it. This will bubble up through SCSI Core and the error returned
> will have to be the same as that of the simpler transports, as outlined
> above.

Yes, sorry. To be precise, this means that the LLDD has to do nothing
special, as it has to implement checking for a failing command anyway.
But it's not entirely the same. If a command cannot be delivered it may or may
not be appropriate to start error recovery. After the LLDD has told
the SCSI layer that it has noticed a device going away, there must be no
error recovery.

> > That means that we have to have a way to ensure that no more commands
> > will reach the LLDD which can be triggered without any commands to be
> > executed at all. This functionality has to come from the scsi mid layer.
>
> For simple transports yes; for more complicated ones, the CDB will
> not be able to be delivered, and will return with error.

Good.
So the first thing a LLDD has to do after it has learned about a device
being removed is to have the device block.
1. set device offline
But commands may still be in flight.IMHO it is not right to assume that
all commands now in flight to a device have failed, as some may have
completed successfully in time, or failed for other reasons than unplugging.
So it should be the LLDD's responsibility to finish the outstanding commands.
Furthermore, there's a window for commands already having passed the check
for offline but not yet being noticed by the LLDD. The simplest solution is to
use a waiting primitive from RCU. So we are at:

1. set device offline
2. synchronize the kernel
3. finish all pending commands

So far with me?
The LLDD could now forget about the device and be done with it.
However there's a problem left. The device may come back.
What happens if a device with the same ID is reconnected?

	Regards
		Oliver

