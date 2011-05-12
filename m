From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone
 (one line)
Date: Thu, 12 May 2011 16:43:36 -0500
Message-ID: <1305236616.2575.95.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1105121711100.1917-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1105121711100.1917-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Charles Hannum <root@ihack.net>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-05-12 at 17:32 -0400, Alan Stern wrote:
> On Thu, 12 May 2011, James Bottomley wrote:
> 
> > > I need someone from USB/SCSI camp to see if this approach makes sense.
> > 
> > I don't really think so, because it's pretending the device cache has
> > flipped to write through.  It's certainly possible to envisage removable
> > media where the cache is in the housing and we still need to preserve
> > the idea of it being write back.
> 
> I don't follow your argument here.  What difference does it make what 
> kind of cache the drive has, if the media is gone?

It depends what the drive is caching and what's removable.  If it's some
type of hybrid, and the cache isn't mapped to the media for instance.

The point really is that if the cache is in the housing, setting it to
write through when it's not is not a correct reflection of reality.

> > Instinct tells me the correct set of fixes is to add a sync cache from
> > release (so we automatically sync on last close, which is usually when
> > an ordered remove happens),
> 
> That certainly makes sense.  Is there any reason why this isn't done 
> already?

None I can think of.  When the caching logic was first done, I don't
think removable media were even considered, so it was all about shutdown
behaviour.

> >  keep the one on shutdown, just in case the
> > system goes down with stuff still mounted and print a nasty message on
> > suspend for a write back device that's been removed.
> 
> There's no need for a nasty message unless the cache is still dirty.  
> Your suggested patch doesn't check for that -- in fact, I don't think
> the driver even knows whether the cache is dirty.  (Not that this 
> matters, seeing as how your patch doesn't print any nasty messages.)

right: We don't currently track dirty state.  We could, I suppose, but I
don't think it's worth it.

> > I also think we shouldn't abort the suspend if the disk doesn't respond
> > correctly to start/stop ... the power is going to be disconnected
> > anyway, so it's no issue if the disk spins for a second or so longer.
> 
> That's a good idea.  On several occasions Linus has mentioned that 
> almost nothing should stop a system suspend.  It's even questionable 
> whether a SYNC failure should stop a suspend ... but that's a separate 
> matter.

Heh, if you want to open that old can of worms again, be my guest ...

> What happens if the medium was recently removed, meaning that 
> sdkp->media_present hasn't yet had a chance to become 0?  The patch 
> needs to handle that case as well, perhaps by adding another check 
> after sd_sync_cache() returns.

or actually, just checking the value when it looks at the return code.

> > The problem this is going to cause is double sync on shutdown (once when
> > final unmount closes the device and once on shutdown) ... do people
> > agree that's a price worth paying?
> 
> I don't think the price will be high.  The second sync will have
> nothing to do, because the first sync will have cleaned out the cache.

Heh, I've got a long inbox full of complaints about the two capacity
messages we used to print on boot ...

James
