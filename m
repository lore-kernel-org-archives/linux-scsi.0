From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 10:49:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F6F3632.6020300@pacbell.net>
References: <Pine.LNX.4.44.0309221027480.2160-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta7.pltn13.pbi.net ([64.164.98.8]:52193 "EHLO
	mta7.pltn13.pbi.net") by vger.kernel.org with ESMTP id S263254AbTIVRoC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 13:44:02 -0400
In-Reply-To: <Pine.LNX.4.44.0309221027480.2160-100000@home.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

Linus Torvalds wrote:
> On Mon, 22 Sep 2003, David Brownell wrote:
> 
>>In this case, because it's not "EHCI + USB 2.0 hub", it's still using
>>the OHCI companion controller.  So that wasn't a new case.
> 
> 
> Ok. Here's the broken case with an added usb-2 hub in between. It is 
> indeed a bit different.

Yes.  Instead of getting 64/128 bytes transferred, with -EOVERFLOW
reported, it gets 0/128, with -EPIPE.  And the recovery got a bit
confused; it's a STALL but not from the device, it's from the hub.

It might be worth making EHCI use a different code in that case,
if this class of TT-related errors starts to be trouble.


> Again, this case worked fine with the sd.c changes, so it does seem to be 
> all related to "big" transfers out of the mode page.

Or at any rate, "big enough" to confuse the device.

Thanks for the additional test results.

- Dave


