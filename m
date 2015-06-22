From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Mon, 22 Jun 2015 13:48:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1506221340180.1799-100000@iolanthe.rowland.org>
References: <1434994588.2237.90.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434994588.2237.90.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>, Jun Itou <itou_jun-6LX5ZuzTTw53+QwDJ9on6Q@public.gmane.org>, Markus Rathgeb <maggu2810-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt <vickm78-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 22 Jun 2015, James Bottomley wrote:

> On Mon, 2015-06-22 at 13:30 -0400, Alan Stern wrote:
> > On Mon, 22 Jun 2015, James Bottomley wrote:
> > 
> > > I'm not sure I entirely like this:  we are back again treating data
> > > corruption problems silently.
> > > 
> > > However, I also believe treating a single flush failure as a critical
> > > filesystem error is also wrong:  The data's all there correctly; all it
> > > does is introduce a potential window were the FS could get corrupted in
> > > the unlikely event the system crashed.
> > > 
> > > Obviously, for a disk with a writeback cache that can't do flush, that
> > > window is much wider and the real solution should be to try to switch
> > > the cache to write through.
> > 
> > I agree.  Doing the switch manually (by writing to the "cache_type" 
> > attribute file) works, but it's a nuisance to do this when you have a 
> > portable USB drive that gets moved among a bunch of machines.
> 
> Perhaps it might be wise to do this to every USB device ... for external
> devices, the small performance gain doesn't really make up for the
> potential data loss.
> 
> > > How about something like this patch?  It transforms FS FLUSH into a log
> > > warning from an error but preserves the error on any other path.  You'll
> > > still get a fairly continuous dump of warnings for one of these devices,
> > > though ... do they respond to mode selects turning off the writeback?
> > 
> > I would be very surprised if any of those drives support MODE SELECT at 
> > all.
> 
> I assume the cache type attribute file you refer to above is just
> pretending their cache is write through rather than actually setting it
> to be so?

Yes; I'm referring to cache_type_store() in sd.c, and writing
"temporary write through", which does not issue a MODE SELECT command.  
It would be easy enough for people to try leaving out the "temporary", 
but I don't expect it to work.

>  The original IDE device had no way of turning their cache
> types to write through either, but the manufacturers were eventually
> convinced of the error of their ways.

In this case the stupidity resides in the USB-ATA bridge.  You can see 
the gory details at

	https://bugzilla.kernel.org/show_bug.cgi?id=89511#c19

> > Maybe your patch will be acceptable, though.  We'll have to hear from 
> > Markus and Matt.
> 
> We'll probably have to take this to fsdevel as well ... they might have
> opinions about whether the FS wants to be informed about flush failure.

Okay.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
