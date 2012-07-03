From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Date: Tue, 3 Jul 2012 11:49:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207031142210.17487-100000@netrider.rowland.org>
References: <1341296326.3319.17.camel@dabdike>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341296326.3319.17.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@linux-foundation.org>, Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 3 Jul 2012, James Bottomley wrote:

> >   What happened is that T10
> > in their infinite wisdom decided to put things like "supports TRIM" and
> > "is actually a 4k block size but fakes 512 byte blocks" in the Read
> > Capacity 16 results.  So if we want to support those kinds of things
> > (and I think we do), then we need to send Read Capacity 16 to devices.
> > 
> > It's not about "enterprise features" at all, but about supporting the
> > next generation of standard consumer drives.  I'm tempted to say the
> > USB Storage driver needs to go back to the way things were, because I
> > don't see any other way to fix this.
> 
> But anyway, we're stuck ... we have to send RC16 first to support these
> features.  We did protest to T10 at the time, but to no avail.

Does it have to be sent _first_?

Or would it be okay to send _both_ commands and believe the RC10
capacity rather than the RC16 capacity if they differ?

> > I have no idea what Windows is doing to support these features.  That
> > might be a fruitful course of investigation.
> 
> Hopefully one of the USB people can do this.
> 
> I still think a whitelist of USB devices sending proper SCSI level
> information in the inquiry might be the best way forward.

I'm doubtful.  It wouldn't be at all surprising for devices to claim 
they support a particular level when in fact they support some but not 
all of the required commands.  Then what do you do?  Put them on the 
whitelist because of the commands they support, or leave them off 
because of the other ones?  What happens later on when you decide to 
use more of the required commands?

Alan Stern
