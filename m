From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 09:09:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309220900440.1753-100000@home.osdl.org>
References: <20030922084930.A679@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:54476 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263263AbTIVQKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 12:10:53 -0400
In-Reply-To: <20030922084930.A679@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl


[ Andries added to the cc ]

On Mon, 22 Sep 2003, Patrick Mansfield wrote:
> 
> I can modify the patch for that.

How about just making the sd.c layer more robust? That has worked well in 
the past, and it seems wrong to have to add more and more flags.

In particular, while hunting down the usb-1/usb-2 differences, it became
clear that all the mode sense transfers that _worked_ under usb-1 were
short. With 64 bytes than with 128 bytes it no longer babbled, and the
whole thing worked fine with 11 bytes (the minimum required to get the
caching status).

Adding some printk's showed that the initial (successful) 4-byte page read
resulted in:

 - page len=1538 (pretty obviously crap)
 - header len=8 (correct)
 - block descriptor len=0 (correct)

and the thing is, we were using the "pretty obviously crap" value for 
judging the size of the thing.

So my suggestion would be to just replace that usage (in sd.c):

	len = data.length;
	if (len > 128)
		len = 128;

with something like this instead:

	/* We need three bytes past the block descriptor length */
	len = data.header_length + data.block_descriptor_length + 3;

	/* Sanity check */
	if (len > data.len || len < 11 || len > 128)
		.. fail ..

Basically, Andries Brouwer's strategy of making sd.c more conservative has
been a very successful one in the past. Why not continue on that?

(Btw, where are the different mode sense pages documented?)

		Linus

