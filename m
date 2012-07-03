From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Date: Tue, 3 Jul 2012 11:32:31 -0600
Message-ID: <20120703173231.GC28804@parisc-linux.org>
References: <1341296326.3319.17.camel@dabdike> <Pine.LNX.4.44L0.1207031142210.17487-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1207031142210.17487-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 03, 2012 at 11:49:00AM -0400, Alan Stern wrote:
> On Tue, 3 Jul 2012, James Bottomley wrote:
> 
> > >   What happened is that T10
> > > in their infinite wisdom decided to put things like "supports TRIM" and
> > > "is actually a 4k block size but fakes 512 byte blocks" in the Read
> > > Capacity 16 results.  So if we want to support those kinds of things
> > > (and I think we do), then we need to send Read Capacity 16 to devices.
> > 
> > But anyway, we're stuck ... we have to send RC16 first to support these
> > features.  We did protest to T10 at the time, but to no avail.
> 
> Does it have to be sent _first_?
> 
> Or would it be okay to send _both_ commands and believe the RC10
> capacity rather than the RC16 capacity if they differ?

I have no problem with doing that (and believing RC16 over RC10 if RC10
claims 0xffffffff, naturally).  The problem, as I understand it, is that
some devices crash upon receiving RC16 rather than just returning nonsense.

> > I still think a whitelist of USB devices sending proper SCSI level
> > information in the inquiry might be the best way forward.
> 
> I'm doubtful.  It wouldn't be at all surprising for devices to claim 
> they support a particular level when in fact they support some but not 
> all of the required commands.  Then what do you do?  Put them on the 
> whitelist because of the commands they support, or leave them off 
> because of the other ones?  What happens later on when you decide to 
> use more of the required commands?

SCSI has a fairly extensive collection of black/white list flags already
... see scsi_devinfo.[ch].

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
