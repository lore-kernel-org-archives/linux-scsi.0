From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Sun, 04 Apr 2004 20:54:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4070D891.9040409@pacbell.net>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>	<1081092223.2034.8.camel@mulgrave>  <407050F4.2090607@pacbell.net> <1081104161.2112.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta4.rcsntx.swbell.net ([151.164.30.28]:52634 "EHLO
	mta4.rcsntx.swbell.net") by vger.kernel.org with ESMTP
	id S263079AbUDEDzL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Apr 2004 23:55:11 -0400
In-Reply-To: <1081104161.2112.34.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> So you dispute this assertion in the email you quoted above:
> 
>>>Since we cannot solve that
>>>race, there's no reason to try to solve the "some parts of the kernel
>>>know but others don't" part of the race.
> 
> 
> On what basis?  This, I think, is the core of the differences between

On the basis of faulty assumptions embedded therein.  Notably
"cannot solve that race" (I elaborate below on exactly how that
information _is_ passed along from USB, which is specifically
what you said "cannot" be solved) ... so also the conclusion
that there's "no reason to try" fixing things.


> us.  I don't see why an asynchronous event should proceed up the stack
> in an orderly synchronised manner.

Some such events don't; but this isn't one of them.  And the
reason it _does_ is to make sure drivers can always prevent
oopsing on device unplug ... and to help eliminate HCD-specific
behaviors from the equation.  (There were a lot of those in 2.4,
which made robust device unplugging rather hard to achieve.)


> It goes like this:
> 
> - Initially, only the device knows, so commands outstanding time out

Well, hardware timeouts or other protocol faults will happen
when the device doesn't respond to I/O from the host.  Those
will be reported in the usual way.  When they happen in other
contexts, such faults may be recoverable ... there's no way
yet to know that these particular ones won't be.


That ends when khubd gets notified, by the hub, that the device
is gone.  At which point (a) the USB device gets marked as gone,
so that usbcore will reject further requests with -ESHUTDOWN,
(b) all pending I/Os are canceled with -ESHUTDOWN status, and
except for UHCI, (c) HCDs force those the URBs back to drivers,
as part of cleaning up the remaining hardware state.

At that point, usbcore and the HCD are all but done with the
device, and the only question is when the memory associated
with the usb_interface and usb_device objects gets its last
reference dropped, so the memory gets freed.  The current UHCI
answer may surprise some drivers, even though the 2.4 stack
could do the same thing.  The time from (a) to (c) will usually
be tens of milliseconds, at most; average time before khubd
notices will be around 1/8 second.


Then (d) for each driver bound to an interface on that device,
the USB disconnect() method is called.  Driver responsibility
is to drop all those interface and device references ASAP.

Plus, in the typical case where drivers are using implicit
refcounts to claim interface/device handles, never issuing
requests using them after the disconnect() returns, since that
releases the implicit reference acquired during probe().


> - Then, the USB driver knows, so it errors incoming commands (and
> presumably returns with error any outstanding untimed out ones)

I don't think any single point (a)-(d) matches that
description.  As soon as it gets -ESHUTDOWN it "knows",
even before (d), for example ... though it's more
natural to wait till (d) before starting to clean up
the device state.


> - Then, SCSI knows, so we forbid user I/O

SCSI knows by the fact that the host was unregistered in (d),
rarely more than ~300 msec after physical disconnect.

The problem here was that the "forbid" is borked.  Maybe not
in SCSI (there are other layers involved), but oopsably.


> The point is, that any I/O after disconnection gets an error ... the
> error just comes from different places as the knowledge propagates
> upwards.

Which directly follows from what I said ... USB propagates
that knowledge in carefully defined ways.   Other layers can
do the same, although clearly state associated with open file
descriptors needs to use a slightly different strategy.  And
that strategy is what Alan's original comment was about.

- Dave

