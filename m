From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Fri, 26 Jun 2015 11:14:17 +0100
Message-ID: <1435313657.2211.70.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1506221324110.1799-100000@iolanthe.rowland.org>
	 <1434994588.2237.90.camel@HansenPartnership.com>
	 <20150626114308.7b5b8006@kant>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150626114308.7b5b8006@kant>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>, Jun Itou <itou_jun-6LX5ZuzTTw53+QwDJ9on6Q@public.gmane.org>, Markus Rathgeb <maggu2810-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt <vickm78-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-06-26 at 11:43 +0200, Stefan Richter wrote:
> On Jun 22 James Bottomley wrote:
> > On Mon, 2015-06-22 at 13:30 -0400, Alan Stern wrote:
> > > On Mon, 22 Jun 2015, James Bottomley wrote:
> > > > Obviously, for a disk with a writeback cache that can't do flush, that
> > > > window is much wider and the real solution should be to try to switch
> > > > the cache to write through.
> > > 
> > > I agree.  Doing the switch manually (by writing to the "cache_type" 
> > > attribute file) works, but it's a nuisance to do this when you have a 
> > > portable USB drive that gets moved among a bunch of machines.
> > 
> > Perhaps it might be wise to do this to every USB device ... for external
> > devices, the small performance gain doesn't really make up for the
> > potential data loss.
> 
> Just a small note on the assumption of externally (and in extension,
> temporarily) attached devices:  Not all USB-attached devices are external,
> and not all external devices are used as removable devices.

The problems don't depend on the connection type: internal devices which
have a writeback cache and don't accept flush commands have data
integrity problems too.  I can't really think of many situations where
you'd be willing to sacrifice data integrity for performance.

James

> (For example, I am using 2 internal CD-ROMs via USB-2 + usb-storage and 2
> internal HDDs via USB 3 + uas in a PC with too few SATA ports and no PCIe
> slot to spare for a controller add-on card, but plenty of USB headers
> available on the mainboard.  Similarly, some NASes have their operating
> system located on a USB-attached device.  Small offices use USB-attached
> disks for backup and won't detach such a disk until rotation for off-site
> deposit.  Not to mention embedded computers with USB-attached but fixed
> disks.)



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
