From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Date: Mon, 2 Jul 2012 18:41:22 -0600
Message-ID: <20120703004122.GA28804@parisc-linux.org>
References: <20120701172012.078559139@decadent.org.uk> <4FF14957.3040007@redhat.com> <CA+55aFyRTXqSvf9m08gbHCB0WhVF14Y6J2-AiFGiuTStq0Jr6Q@mail.gmail.com> <1341261568.3319.7.camel@dabdike> <CA+55aFymdk8Sn8CVXRZgRvR96jCZG3LQRNU3U0dMkS3Ut2CemQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFymdk8Sn8CVXRZgRvR96jCZG3LQRNU3U0dMkS3Ut2CemQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <jbottomley@parallels.com>, Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 02, 2012 at 03:23:18PM -0700, Linus Torvalds wrote:
> >  Martin Petersen did extensive testing of devices when we
> > changed it and doing RC16 first is hedged around by claiming support not
> > only for SCSI_3 but also for SBC_2 in your INQUIRY data.
> 
> Umm. That just smells like BS to me.
> 
> The "extensive testing" part was clearly not true, and it seems that
> SCSI people sometimes forget that the biggest user (by *far*) is the
> USB storage layer.

As James said, *at the time*, USB overrode the SBC_2 claims from USB
devices and forced them to be SCSI_2.  So no amount of testing we did
would have uncovered this.

> Also, your protection claim seems to be invalidated by the actual
> code. Yes, it checks if the device claims to support protection. But
> it *also* says "let's do that 16b command if "scsi_level >
> SCSI_SPC_2". So your claim that it hedges around it by looking at the
> inquiry data is pure crap. It's simply not true. Just look at the
> code:

I wrote this code ... James' memory is off.  What happened is that T10
in their infinite wisdom decided to put things like "supports TRIM" and
"is actually a 4k block size but fakes 512 byte blocks" in the Read
Capacity 16 results.  So if we want to support those kinds of things
(and I think we do), then we need to send Read Capacity 16 to devices.

It's not about "enterprise features" at all, but about supporting the
next generation of standard consumer drives.  I'm tempted to say the
USB Storage driver needs to go back to the way things were, because I
don't see any other way to fix this.

I have no idea what Windows is doing to support these features.  That
might be a fruitful course of investigation.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
