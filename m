From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 11:40:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309221133220.2153-100000@home.osdl.org>
References: <3F6F3632.6020300@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:59319 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261954AbTIVSkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 14:40:37 -0400
In-Reply-To: <3F6F3632.6020300@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>


On Mon, 22 Sep 2003, David Brownell wrote:
> > Again, this case worked fine with the sd.c changes, so it does seem to be 
> > all related to "big" transfers out of the mode page.
> 
> Or at any rate, "big enough" to confuse the device.

Yes. Additional testing (making the code just increase the size of the 
transfer until it fails) shows that a size of 63 still works, but a size 
of 64 bytes fails.

Actually - with a 64-byte transfer, we appear to get the 64 bytes ok, but 
the subsequent CSW status word read fails, so the 64-byte case seems to be 
the one that starts confusing the device.

If I remember right, USB-1 "big packets" are 64 bytes in size, and a 
64-byte bulk transfer would be two packets (one full-sized one, one 
zero-sized one). So this seems to support the notion that the device is 
fine as long as it can fit the whole bulk transfer in just one packet.

Which cleanly explains why EHCI "just worked". 

			Linus

