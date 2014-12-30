From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical
 max_hw_sectors cap")
Date: Tue, 30 Dec 2014 08:25:28 -0800
Message-ID: <1419956728.2164.3.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1412301109050.32416-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1412301109050.32416-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Kenneth R. Crudup" <kenny-VmQCmMdMyN0AvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-12-30 at 11:12 -0500, Alan Stern wrote:
> On Tue, 30 Dec 2014, James Bottomley wrote:
> 
> > > _Is_ there any way to communicate the maximum transfer size?  I'm not
> > > aware of any SCSI command for it.  It isn't part of the USB
> > > mass-storage spec.
> > 
> > For the device, it's in the Block limits VPD page.  However, what the
> > device supports isn't necessarily what the bridge or host bus adapter
> > will support.  We need to set the limit to the lowest of what the
> > device, the bridge and the HBA support.  We know the device (provided
> > the bridge allows VPD inquiries ... not all do) and host, so we really
> > need to know what the bridge will support.  From the error it does look
> > like we're running into a bridge limit.
> 
> I see.
> 
> > > usb-storage has no clear idea what sort of device lies on the other
> > > side of the USB bridge.  It might be an ATA drive, it might be a flash
> > > drive, it might not be a disk at all -- usb-storage does its best not
> > > to know or care.
> > 
> > That's fine, but is there any way in USB to query the bridge to get it's
> > transfer characteristics?
> 
> No, there isn't.  The only query that a USB mass-storage bridge accepts 
> is for the maximum LUN value.
> 
> > > If you think that usb-storage needs to set a maximum transfer size for
> > > disk drives, it won't be hard to write a patch.  But what about all the
> > > other possible transports?  Will they each have to implement the same
> > > transfer limit?  If so, shouldn't the limit be set up from a more
> > > central location, such as the sd driver?
> > 
> > This isn't a transport problem, this is a bridge problem.  T10 has
> > always recognised there might be a bridge issue linking two transports,
> > so it did initially come up with a bridge spec (BCC) but it was
> > abandoned a decade ago in favour of transparent bridges (every switch in
> > a FC topology is effectively a transparent bridge) or making them
> > explicit in the standards, like SAS expanders.
> > 
> > > Why not have sd always set max_sectors_kb to 32767 if it isn't already 
> > > smaller?  Would that cause any problems?
> > 
> > This wouldn't be sd ... we have lots of requirements for large transfer
> > sizes for efficiency.  It has to be the layer that knows there's a
> > bridge, so that would make it usb.
> 
> All right.  How does this patch look?

OK, I suppose.  The transfer limits are a little on the low side, but
for usb-storage (i.e. non-UAS) performance devices, they should be OK.
For TYPE_TAPE, you still have no guarantee that the bridge won't screw
up ... and if the argument is that tapes are always connected to
sensible bridges, why aren't SATA devices?

There's also a spelling mistake below.

> Alan Stern
> 
> 
> 
> Index: usb-3.18/drivers/usb/storage/scsiglue.c
> ===================================================================
> --- usb-3.18.orig/drivers/usb/storage/scsiglue.c
> +++ usb-3.18/drivers/usb/storage/scsiglue.c
> @@ -114,26 +114,30 @@ static int slave_alloc (struct scsi_devi
>  static int slave_configure(struct scsi_device *sdev)
>  {
>  	struct us_data *us = host_to_us(sdev->host);
> +	unsigned int max_sectors;
>  
> -	/* Many devices have trouble transferring more than 32KB at a time,
> -	 * while others have trouble with more than 64K. At this time we
> -	 * are limiting both to 32K (64 sectores).
> +	/*
> +	 * Many devices have trouble transferring more than 32 KB at a time,
> +	 * while others have trouble with more than 64 KB. At this time we
> +	 * are limiting both to 32 KB (64 sectores).

sectors

James



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
