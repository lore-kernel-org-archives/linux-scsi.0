From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Date: Fri, 6 Jul 2012 10:00:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207060952350.28821-100000@netrider.rowland.org>
References: <20120706030525.GC17681@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:38821 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751701Ab2GFOAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jul 2012 10:00:09 -0400
In-Reply-To: <20120706030525.GC17681@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 5 Jul 2012, Matthew Wilcox wrote:

> > > Sure, it's one extra command, but really, who cares?
> > 
> > Well, some USB devices might care.  Right now we don't send RC16 to 
> > them at all because they get RC10 first and it indicates a capacity 
> > below 2 TB.
> 
> Mmm.  I think I forgot a step:
> 
> Send RC10 (unless the device supports PI, in which case it's probably
> 	enterprisey and well-tested)
> If the device indicates a level < SPC_2, stop here
> Send RC16
> If RC10 capacity agrees with RC16 capacity, use extra RC16 data.
>  (for values of "agrees with" that include the "-1 to use RC16" indicator)

That might or might not work.  I don't know for certain, but it's 
possible that some USB devices do claim a level > SPC_2 and yet can't 
handle RC16.  Of course, we can always set the NO_READ_CAPACITY_16 
flags for these devices as they crop up.

> > In the end, usb-storage may be forced to use the NO_READ_CAPACITY_16 
> > flag with all devices except those we can positively identify as a 
> > USB-(S)ATA bridge.
> 
> Is that really an improvement over nobbling the IDENTIFY results to
> force SCSI_2?

Yes.  There was a good reason for getting rid of that change to the
INQUIRY result (some devices don't like it when the LUN bits are
stuffed into the second byte of each CDB), and I don't want to go back.

Alan Stern

