From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 14:07:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E303D5E.5020000@splentec.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301222346.30329.oliver@neukum.name> <3E302A89.8070703@splentec.com> <200301231919.40422.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
> 
> Very well, so you agree that the SCSI layer should export to the LLDD
> a function to set devices offline?

I've never really disagreed -- simpler transports will make use
of such a function.  The important point to note is that the error
return value for simpler and more complicated transports has to
be the same (i.e. ones which know about the device disconnect and
others which send out the CDB and which will return with error).

I forgot to mention this with my previous email: think of a LLDD
more as part of the transport than of SCSI Core.

> Yes, sorry. To be precise, this means that the LLDD has to do nothing
> special, as it has to implement checking for a failing command anyway.
> But it's not entirely the same. If a command cannot be delivered it may or may
> not be appropriate to start error recovery. After the LLDD has told
> the SCSI layer that it has noticed a device going away, there must be no
> error recovery.

Error recovery should not be that complicated for device being disconnected,
just error out all commands new and old -- as I've said so many times.
The command structs will return back to LLDD and all will be good.
(Simple transports.)

More complicated transports will just return Service Delivery Failure.

(See below.)

> Good.
> So the first thing a LLDD has to do after it has learned about a device
> being removed is to have the device block.

``block'' (verb) is such a strong word.

* Simple transports: call scsi_set_device_offline(dev) or something like this.

* More complicated transports: SCSI Core sees Service Response of Service
Delivery Failure and it itself calls scsi_set_device_offline(dev).

scsi_set_device_offline(dev) calls a high-level kernel function to start
higher level things (block queue cut off, etc) which *may* need to be done.

The control path will eventually bubble down to SCSI Core which will
error out already queued commands (unless they've returned already
with the appropriate error code), remove the device, etc, etc, etc.

> 1. set device offline
> But commands may still be in flight.IMHO it is not right to assume that
> all commands now in flight to a device have failed, as some may have
> completed successfully in time, or failed for other reasons than unplugging.

They will just return with ok status and after a certain point in time,
all others will return with the appropriate error -- in which case see above.

> So it should be the LLDD's responsibility to finish the outstanding commands.

LLDD cannot really ``finish'' outstanding commands, it's just a transport
portal.

> Furthermore, there's a window for commands already having passed the check
> for offline but not yet being noticed by the LLDD.

They will return with an appropriate error.

> The simplest solution is to
> use a waiting primitive from RCU. So we are at:
> 
> 1. set device offline
> 2. synchronize the kernel
> 3. finish all pending commands

I told you before: 3 starts *before* 2 and 3 is *part* of 2.
Furthermore, after 1 has happened in time, all pending commands
will error out (wrt a time line).

2 is what I call ``higher-level hook'', but it's not really
``synchronization''. Synchronization will take delta-time, it
will not happen instantaneously.

> So far with me?
> The LLDD could now forget about the device and be done with it.

Some LLDD will not have the concept of device -- they'll just
set up the remote procedure call Execute Command and initiate
it, given a target and LUN. Who knows what happens after that?
I mean the command may go through several transports..., the LUN
may get translated a few times, etc.

We have to keep this in mind.
And some other transports will know about devices.

I.e. you have to allow for the possibility of a command
being sent to a non-existent device through LLDD, in which
case the LLDD/transport will have to error it out.

> However there's a problem left. The device may come back.
> What happens if a device with the same ID is reconnected?

-- 
Luben



