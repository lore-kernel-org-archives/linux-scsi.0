From: Martin Diehl <lists@mdiehl.de>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 18:58:40 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309221845480.12019-100000@notebook.home.mdiehl.de>
References: <3F6F21BE.9090109@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bart.one-2-one.net ([217.115.142.76]:62479 "EHLO
	bart.webpack.hosteurope.de") by vger.kernel.org with ESMTP
	id S263214AbTIVQ61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 12:58:27 -0400
In-Reply-To: <3F6F21BE.9090109@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Linus Torvalds <torvalds@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 22 Sep 2003, David Brownell wrote:

> > So it is somehow related to USB-1 vs USB-2. I don't understand why the 
> > device would make a difference for something like mode page 8, but it 
> > looks like it transfers data fine for _small_ mode page requests under 
> > USB-1, and under USB-2 it works even for big ones.
> 
> It could be some kind of logic in the device forgetting that to use
> the right maxpacket setting in that specific case.

Just a wild guess: If the device misbehaved on HS/FS transition and would 
send packets >64 bytes in FS mode, I think it would explain the babble 
issue:

* the 128 byte read which reported babble was the first IN transfer >64 
  byte and the babble condition was reported after receiving 64 bytes, 
  i.e. at a point where the HC has stored _less_ data than expected!

* limiting the transfer length to 64 bytes made the babble disappear

* works with EHCI because HS can handle bigger packets

Unfortunately I don't see an easy way to check the sourced packed size on 
the wire - except using a bus analyzer of course.

I'm not sure how uhci behaves with packets exceeding FS max packet size - 
if it doesn't fit into the read buffer it should report babble as well - 
but what if the buffer is big enough and it's just the packet is to big? 
IIRC the TD's actlen is 11-bit anyway. Could it be this device (mis)uses 
HS maxpacket when operating at fullspeed?

Martin


