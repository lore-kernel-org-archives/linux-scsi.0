From: David Brownell <david-b@pacbell.net>
Subject: Re: usb-strage not working in the latest kernel 2.4
Date: Mon, 08 Sep 2003 09:04:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F5CA89B.8060003@pacbell.net>
References: <200309070128.KAA28169@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta4.rcsntx.swbell.net ([151.164.30.28]:30627 "EHLO
	mta4.rcsntx.swbell.net") by vger.kernel.org with ESMTP
	id S262573AbTIHP7V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2003 11:59:21 -0400
In-Reply-To: <200309070128.KAA28169@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Tomita, Haruo wrote:
> It is because it is hard to generate an error in testing
> two simultaneously. When testing simultaneously,
> much time is required by the time it generates an error.

This is basically a good thing:  the root causes are
getting fixed one by one, so it needs more time before
one of the remaining problems appears.

Of course, that means it's harder to find/fix whatever
problem you're hitting ... :(



> The reason is not known.
> 
> Haruo> 1. Bulk command transfer result=-104
> 
> [skip]
> 
> Alan> This was the same sort of pattern we saw before.  No data was 
> Alan> transferred from the drive, and the command timed out
> > and was aborted.
> 
> I am also looking at this pattern repeatedly.

Some sort of USB-level trace would be very useful here,
such as from a CATC capture.


> It seems that a device does not answer in the case of kernel 2.4.
> However, when operating by kernel 2.6 and two or more devices
> are connected simultaneously, it operates. 
> I cannot think the error of a device.

I'd almost agree, except that the device stops responding;
and seems to stop responding to anything except (cases I've
seen) that it'll accept more OUT packets ... maybe treating
them as data to write to the disk (one hypothesis).

When a device stops responding, it's hard to think the
problem is anything other than with the device.  (Though
I still don't see where the storage class-specific reset
gets sent by usb-storage, maybe that'd clean up better.)


What's curious is that "two or more devices connected"
behavior.  Are they both doing I/O at the same time?
Having a second active device would change a few things:

  - The EHCI controller will switch between endpoints,
    doing some transfers from one device then the next.

    A second active device means longer gaps between
    packets going to the device ... so if one of those
    devices can't handle continuous streaming of high
    speed packets, it may lock up except when that
    second device increases those gaps.

    Yes, we DO seem to have started seeing such storage
    adapters.  Ones from GeneSys appear to have that
    problem with fast EHCI controllers, like the one in
    NForce2 (which can issue two or more back-to-back
    transfers using the "park" mechanism).

  - Since usb-storage on 2.4 doesn't stream usb-storage
    transfers (64 writes of one page, vs one big write
    of 64 pages), the EHCI controller spends lots of
    time unlinking bulk endpoints (QHs) from its i/o
    queue and linking them right back again.

    The VIA chips have been very sensitive, even buggy,
    in how they handle this logic.  I've been unable to
    convince myself the current EHCI driver has a bug in
    this area -- though maybe it's possible someone else
    would have better luck finding one.

    If this is a factor, then you should be able to
    change the behavior by increasing EHCI_SHRINK_JIFFIES
    (top of ehci-hcd.c), maybe to HZ/100 or so.  I know
    that increasing that from zero was a big win in some
    VT6202 (stability) and VT8235 (performance on 2.4)
    testing, but the other EHCI silicon didn't much care.

That's about all the insight I have to share on this
at the moment.

- Dave


