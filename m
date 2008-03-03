From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open
	file references
Date: Mon, 03 Mar 2008 17:13:15 -0600
Message-ID: <1204585995.3043.85.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0803031758310.8280-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0803031758310.8280-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-03-03 at 18:04 -0500, Alan Stern wrote:
> On Mon, 3 Mar 2008, James Bottomley wrote:
> 
> > On Mon, 2008-03-03 at 15:16 -0500, Alan Stern wrote:
> > > This patch (as1050) adds a new field to struct scsi_device, to keep a
> > > count of the number of block-device open file references.  This count
> > > will be used by usb-storage to determine whether USB-PERSIST should be
> > > forced on during a suspend.
> > 
> > I don't think this does what's advertised if you mean it to keep a count
> > as the atomics seem to imply. (->open is only called on first open and
> > ->release on last close.  openers was a historical 2.4 field that used
> > to count opens but now just flags whether sd is open or not.
> 
> Um.  The real purpose of that field is to let usb-storage know whether 
> or not the device is open at all.  I used a count because that seemed 
> like the only way to do it; it doesn't matter if the count value 
> doesn't exactly match the actual number of open file references.

OK, so your change log is "whether the device is open" not "a count of
openers".

> I didn't want to use the openers field in struct scsi_disk because this 
> should apply to CDs and any other block devices as well as to disks.
> 
> > Secondly, if you really want an openers count (which I remember SCSI
> > rendering a bad idea ages ago), that's held in struct block_device as
> > openers, isn't it?  So there's no need to duplicate this in SCSI.
> 
> But there's no way to get to the block_device structure if all you're 
> given is the scsi_device, right?  You would have to know something 
> special about it, such as whether it is a disk, a CD, or something 
> else.  This is intended to be generic.

OK, but then the obvious question is why this isn't at the block device
layer?  It doesn't seem right that we'd have a shadow (and not a very
effective one) of bdev->openers just so you can access it from a
scsi_device.  We had a similar problem with the AHCI AN patches which
were solved by altering the layered accesses.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
