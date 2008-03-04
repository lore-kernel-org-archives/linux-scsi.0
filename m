From: Mike Anderson <andmike-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open
	file references
Date: Tue, 4 Mar 2008 08:50:47 -0800
Message-ID: <20080304165047.GA31007@linux.vnet.ibm.com>
References: <1204585995.3043.85.camel@localhost.localdomain> <Pine.LNX.4.44L0.0803041101200.4039-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803041101200.4039-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Mon, 3 Mar 2008, James Bottomley wrote:
> 
> > On Mon, 2008-03-03 at 18:04 -0500, Alan Stern wrote:
> > > On Mon, 3 Mar 2008, James Bottomley wrote:
> > > 
> > > > On Mon, 2008-03-03 at 15:16 -0500, Alan Stern wrote:
> > > > > This patch (as1050) adds a new field to struct scsi_device, to keep a
> > > > > count of the number of block-device open file references.  This count
> > > > > will be used by usb-storage to determine whether USB-PERSIST should be
> > > > > forced on during a suspend.
> > > > 
> > > > I don't think this does what's advertised if you mean it to keep a count
> > > > as the atomics seem to imply. (->open is only called on first open and
> > > > ->release on last close.  openers was a historical 2.4 field that used
> > > > to count opens but now just flags whether sd is open or not.
> > > 
> > > Um.  The real purpose of that field is to let usb-storage know whether 
> > > or not the device is open at all.  I used a count because that seemed 
> > > like the only way to do it; it doesn't matter if the count value 
> > > doesn't exactly match the actual number of open file references.
> > 
> > OK, so your change log is "whether the device is open" not "a count of
> > openers".
> 
> Yes, sort of.  That is, the new field is used just for its "whether the 
> device is open" meaning, but the only way to keep track of that is to 
> count the calls to the open and release methods.
> 
> BTW, is it really accurate to say that this isn't a count of the
> openers?  I guess it depends on what you mean by "opener".  IIUC, every
> system call to open(2) will go through the driver's open method and
> thus increment the count, whereas calls to dup(2) or dup2(2) will not.  
> It that correct, or is there a stronger distinction at work?
> 

In do_open there is a different path taken if bd_openers is non zero. 

> > > > Secondly, if you really want an openers count (which I remember SCSI
> > > > rendering a bad idea ages ago), that's held in struct block_device as
> > > > openers, isn't it?  So there's no need to duplicate this in SCSI.
> > > 
> > > But there's no way to get to the block_device structure if all you're 
> > > given is the scsi_device, right?  You would have to know something 
> > > special about it, such as whether it is a disk, a CD, or something 
> > > else.  This is intended to be generic.
> > 
> > OK, but then the obvious question is why this isn't at the block device
> > layer?  It doesn't seem right that we'd have a shadow (and not a very
> > effective one) of bdev->openers just so you can access it from a
> > scsi_device.  We had a similar problem with the AHCI AN patches which
> > were solved by altering the layered accesses.
> 
> Well then, how would you solve the problem?  Given a pointer to the 
> scsi_host, we need to know whether there are any block-device files 
> open for any of the SCSI devices beneath it.  Ideally we would like to 
> know strictly if there are any exclusive opens, but merely knowing 
> about any kind of open device file would be good enough.
> 
> If you can suggest an alternative approach, I'll be glad to change the
> patch.

The field that you are adding is very close in behavior to
(sdev->sdev_gendev.kobj.kref.refcount). Though sd_open increments the sdev
kref through a call chain started by a call to scsi_disk_get the sdev kref
would cover more than block opens which may effect the usefulness in your
case.

-andmike
--
Michael Anderson
andmike-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
