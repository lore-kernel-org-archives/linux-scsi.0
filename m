From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Thu, 8 Sep 2005 11:19:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081057430.4607-100000@iolanthe.rowland.org>
References: <431F50EF.1060901@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52391 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932670AbVIHPTn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 11:19:43 -0400
In-Reply-To: <431F50EF.1060901@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 7 Sep 2005, Stefan Richter wrote:

> usb-storage implements scsi_mod bus reset as USB port reset. This
> affects only the failing device.

Correct, but you're forgetting that in USB a single device can contain
more than one "interface", and drivers bind to interfaces, not devices.  
Doing a USB port reset has implications beyond those of the single
interface controlled by usb-storage, since it affects the entire device.  
In fact, the current version refuses to do a port reset if there are other
interfaces present.

> There is one scsi_mod bus per SCSI target in usb-storage.

That's not quite entirely true.  There are a few obscure USB mass-storage 
devices that actually are a SCSI host adapter and control a real SCSI bus.  
But for all practical purposes we can forget about them.


On Wed, 7 Sep 2005, Luben Tuikov wrote:

> Is it possible to implement LU Reset TMF for USB storage devices?
> If so, then you do not need to do a "bus reset".

Sorry, I don't know that acronym.  What is TMF?

> *General note:* It is very bad to have to punish all devices on the
> "bus" just because one device failed.  Isn't there a better way
> to recover(*) a failed USB Storage device?

No.  There are only two reset mechanisms available for USB Mass Storage.  
One is a class-specific reset command (which usb-storage issues when asked 
to do a device reset), and the other is a USB port reset (which 
usb-storage issues when asked to do a bus reset).

In practice, it turns out that many (perhaps even most) USB Storage 
devices don't implement the class-specific reset command correctly.  
Windows doesn't use it at all, so far as I know.  This means our only 
realistic option is the USB port reset.

> (*) That doesn't necessarily mean "bring back to life", it could
> also mean "remove".

Well, usb-storage doesn't need to "remove" a failed device.  The SCSI core 
does a perfectly good job just by setting it off-line.  And since there 
aren't other targets sharing the bus, that's good enough.

> That is, a "bus reset" means that also any other device on the "bus" is
> unreachable.  If this is _not_ the case, then a "bus" reset must _not_
> take place.

I'm not sure what that first sentence is intended to mean.  The SCSI error 
handler _does_ issue bus resets even when other devices on the bus are 
still reachable, doesn't it?  Provided the others are idle at the time, 
there shouldn't be any harm in it.

> If you have the means to do transport checking of the state of the
> device, (and it seems like you can for USB Storage, since it is USB after
> all), then you _must_ implement your own eh handler.  This is what
> it is for.  Please, consider.
> 
> 	Luben
> 
> P.S. It may actually simplify things in the USB transport layer _and_ in
> SCSI Core (i.e. no need for those patches).

We are sort of moving in that direction.  usb-storage already does its 
own unsolicited resets when unexpected error occur.  But we don't have 
anything like the error-handler's mechanism for recovering from timeouts 
(TUR, then device reset, then TUR, then bus reset, ...).  There doesn't 
seem to be any point in reinventing all that code.

Alan Stern

