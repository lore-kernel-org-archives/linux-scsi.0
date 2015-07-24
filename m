From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Fri, 24 Jul 2015 11:19:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1507241114570.1284-100000@iolanthe.rowland.org>
References: <1435008177.2237.137.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435008177.2237.137.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Dan Williams <dcbw-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jun Itou <itou_jun-6LX5ZuzTTw53+QwDJ9on6Q@public.gmane.org>, Markus Rathgeb <maggu2810-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt <vickm78-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 22 Jun 2015, James Bottomley wrote:

> On Mon, 2015-06-22 at 13:48 -0400, Alan Stern wrote:
> > On Mon, 22 Jun 2015, James Bottomley wrote:
> > 
> > > On Mon, 2015-06-22 at 13:30 -0400, Alan Stern wrote:
> > > > On Mon, 22 Jun 2015, James Bottomley wrote:
> > > > 
> > > > > I'm not sure I entirely like this:  we are back again treating data
> > > > > corruption problems silently.
> > > > > 
> > > > > However, I also believe treating a single flush failure as a critical
> > > > > filesystem error is also wrong:  The data's all there correctly; all it
> > > > > does is introduce a potential window were the FS could get corrupted in
> > > > > the unlikely event the system crashed.
> > > > > 
> > > > > Obviously, for a disk with a writeback cache that can't do flush, that
> > > > > window is much wider and the real solution should be to try to switch
> > > > > the cache to write through.
> > > > 
> > > > I agree.  Doing the switch manually (by writing to the "cache_type" 
> > > > attribute file) works, but it's a nuisance to do this when you have a 
> > > > portable USB drive that gets moved among a bunch of machines.
> > > 
> > > Perhaps it might be wise to do this to every USB device ... for external
> > > devices, the small performance gain doesn't really make up for the
> > > potential data loss.
> > > 
> > > > > How about something like this patch?  It transforms FS FLUSH into a log
> > > > > warning from an error but preserves the error on any other path.  You'll
> > > > > still get a fairly continuous dump of warnings for one of these devices,
> > > > > though ... do they respond to mode selects turning off the writeback?
> > > > 
> > > > I would be very surprised if any of those drives support MODE SELECT at 
> > > > all.
> > > 
> > > I assume the cache type attribute file you refer to above is just
> > > pretending their cache is write through rather than actually setting it
> > > to be so?
> > 
> > Yes; I'm referring to cache_type_store() in sd.c, and writing
> > "temporary write through", which does not issue a MODE SELECT command.  
> > It would be easy enough for people to try leaving out the "temporary", 
> > but I don't expect it to work.
> > 
> > >  The original IDE device had no way of turning their cache
> > > types to write through either, but the manufacturers were eventually
> > > convinced of the error of their ways.
> > 
> > In this case the stupidity resides in the USB-ATA bridge.  You can see 
> > the gory details at
> > 
> > 	https://bugzilla.kernel.org/show_bug.cgi?id=89511#c19
> 
> OK, so that says the SAT in the bridge doesn't know what to do with
> MODE_SELECT (probably unsurprising given that it's a usb bridge).  the
> SATA disk should respond to the ATA command SET FEATURES, though.
> Presuming we can get it through the bridge.
> 
> You can try it with
> 
> hdparm -W 0 <dev>
> 
> optionally with --prefer_ata_12 to do the 12 instead of 16 byte
> encapsulation and see if that makes a difference.

Dan Williams recently posted the content below to the Bugzilla report:

> I have a drive with this problem and I tested 4.0.8 with this hunk 
> added to the patch above.
> 
> UNUSUAL_DEV(  0x0bc2, 0x0888, 0x0000, 0x0000,
>               "Seagate",
>               "USB 2.0 Pocket Hard Drive",
>               USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>               US_FL_NO_SYNCHRONIZE_CACHE),
> 
> I don't have the linux-usb thread around so I can reply to 
> http://www.spinics.net/lists/linux-usb/msg126364.html, but here's the 
> result of:
> 
> [dcbw@localhost ~]$ sudo hdparm -W 0 --prefer-ata12 /dev/sdb
> 
> /dev/sdb:
>  setting drive write-caching to 0 (off)
> SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 
> 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

In English: "Illegal Request: Invalid command operation code".  
Apparently there's no way to tell the drive to change its caching.

> SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 
> 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 
> 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 
> 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 
> 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  write-caching = not supported
> 
> What was the upstream resolution on this one?

So far there isn't any.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
