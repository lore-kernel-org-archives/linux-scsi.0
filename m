From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 17:16:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2C753B.3090805@splentec.com>
References: <10426732153816@kroah.com> <200301170043.36577.oliver@neukum.name> <20030117085047.GB2531@beaverton.ibm.com> <200301171155.36452.oliver@neukum.name> <20030117105414.E359@one-eyed-alien.net> <3E2C3380.3070700@splentec.com> <3E2C5750.2040301@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

David Brownell wrote:
> Luben Tuikov wrote:
> 
>>> The way this should work is that the LLD calls scsi_remove_device(), and
>>> that cuts off the flow of commands.  The LLD can promise to error-out 
>>> any
>>> pending commands in the device command queue.
>>
>>
>>
>> I take it you mean that the transport will tell the LLDD that the device
>> is gone and it (LLDD) call the one above, SCSI Core to remove the device.
>>
>> Hmm, more thinking needs to be done here, as shouldn't this be handled
>> by hotplugging? I.e. Targets do not *initiate* events.
> 
> 
> Not exactly, but the bus driver ("transport"?) certainly does initiate
> reports like "here's a new device on the bus" or "that device is gone".
> That's when hotplugging kicks in (both in-kernel and in-userland).
> 
> And the only way to access a device ("target") on the bus is to give a
> request to that bus driver.  If, when servicing that request, the bus
> driver notices the device is gone ... that can act a lot like a device
> initiating a "device gone" event would look.

David, when I said ``... the transport will tell the LLDD that the
device ...'' this is *exactly* what I meant.  You're just repeating
it here in a more broken-down way.

By transport I mean USB, FC, SPI, etc; LLDD is the transport portal
and the initiator (aka the initiator port).  This terminology is not
really that new, but still not that old, and described in SAM-3.

>> The transport can notify that the device is gone, but an ULP entity will
>> call scsi_remove_device() not the other way around.
> 
> 
> That's how USB works today:  khubd shuts things down.  Device drivers
> get disconnect() callbacks, just as when their modules are removed.

Pardon me, I'm not very familiar with the USB subsystem, but this only
makes sense -- why would anyone do it any other way... :-)

> EXCEPT that "khubd" is part of usbcore (roughly analagous to parts
> of the scsi mid-layer) ... so the drivers acting as host side proxies
> for the target hardware ("usb device") are purely reactive.  Their
> only roles in hotplug scenarios are to bind to devices (when a new
> one appears, using probe callbacks) or unbind from them (when one
> goes away, using disconnect callbacks).

Very nice.

> Those disconnect() callbacks have a few key responsibilities, very
> much including shutting down the entire higher level I/O queue to
> that device.  I think you're saying that SCSI drivers don't have
> such a responsibility (unlike USB or PCI) ... if so, that would
> seem to be worth changing.

We just cannot let a transport event just wipe out a device,
without consulting hotplugging first -- think security.

SCSI drivers' (LLDD) responsibility is changing.  This is inevitable,
due to the reorganization of SAM-3 and SPC-3.  There's no more
such a thing as a ``bus'' in SCSI, e.g. ``Bus'' *may* be a
concept of the transport, and then again it may not.

General:
--------
SCSI was never designed to support Target initiated events.
SAM-3 has no provision for it, except passively when the next
command status is returned (e.g. UA).

For this reason, device removal is *transport* related event --
it has *nothing* to do with the SCSI target/target device, except
that it's gone :-) .

Being pedantic, this would be a /transport initiated event/ .
When this event takes place, the LLDD will notice it, and
let the kernel know about it, via a callback, all the while
the LLDD will return TARGET error (since it's gone), until
is has been told slave_destroy(), after which it should
never be queried of it, and if it is it should return the same
error.

That is, when a transport event takes place, the LLDD doesn't
have to ``run to'' SCSI Core right away. Just let the kernel
know about this event, and start returning errors, on newly
queued commands.

The kernel will decide what to do about this device going away,
i.e. hotplugging, sysop notification, etc.

I guess we're crossing in this discussion in such a way, just
because of USB and SCSI crossing here.  But if we think that
USB is the transport and that it could also be FC, SPI, SSA,
iSCSI, then a general framework of the workings is inevitable.

I.e. when talking about LLDDs we'd concentrate less on ``Target''
and more on ``transport''.

-- 
Luben


