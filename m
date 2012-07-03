From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Date: Tue, 3 Jul 2012 15:50:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207031540410.29825-100000@netrider.rowland.org>
References: <20120703173231.GC28804@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:48466 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753188Ab2GCTup (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2012 15:50:45 -0400
In-Reply-To: <20120703173231.GC28804@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 3 Jul 2012, Matthew Wilcox wrote:

> On Tue, Jul 03, 2012 at 11:49:00AM -0400, Alan Stern wrote:
> > On Tue, 3 Jul 2012, James Bottomley wrote:
> > 
> > > >   What happened is that T10
> > > > in their infinite wisdom decided to put things like "supports TRIM" and
> > > > "is actually a 4k block size but fakes 512 byte blocks" in the Read
> > > > Capacity 16 results.  So if we want to support those kinds of things
> > > > (and I think we do), then we need to send Read Capacity 16 to devices.
> > > 
> > > But anyway, we're stuck ... we have to send RC16 first to support these
> > > features.  We did protest to T10 at the time, but to no avail.
> > 
> > Does it have to be sent _first_?
> > 
> > Or would it be okay to send _both_ commands and believe the RC10
> > capacity rather than the RC16 capacity if they differ?
> 
> I have no problem with doing that (and believing RC16 over RC10 if RC10
> claims 0xffffffff, naturally).  The problem, as I understand it, is that
> some devices crash upon receiving RC16 rather than just returning nonsense.

No, that's not the problem we're talking about here.  While it is true
that some devices crash upon receiving RC16, so far we haven't been
sending RC16 to those devices, so they don't matter for the purposes of
this discussion.

In fact, usb-storage already has a NO_READ_CAPACITY_16 flag.  It was
introduced because of a card reader that mistakenly attempts to return
an actual capacity value even when no card is present: It takes the
number of sectors -- which is 0 -- and subtracts 1 as usual.  You can
imagine what happens next.  :-)  That's the only device which
currently has this flag.

The reason for the try_rc_10_first flag is that some devices return
bogus data in response to RC16.  Like, an 800 GB device claiming to
have 3 exabytes.

Alan Stern

