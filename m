From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Tue, 30 Dec 2014 11:12:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1412301109050.32416-100000@netrider.rowland.org>
References: <1419954632.2164.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1419954632.2164.1.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Kenneth R. Crudup" <kenny@panix.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Tue, 30 Dec 2014, James Bottomley wrote:

> > _Is_ there any way to communicate the maximum transfer size?  I'm not
> > aware of any SCSI command for it.  It isn't part of the USB
> > mass-storage spec.
> 
> For the device, it's in the Block limits VPD page.  However, what the
> device supports isn't necessarily what the bridge or host bus adapter
> will support.  We need to set the limit to the lowest of what the
> device, the bridge and the HBA support.  We know the device (provided
> the bridge allows VPD inquiries ... not all do) and host, so we really
> need to know what the bridge will support.  From the error it does look
> like we're running into a bridge limit.

I see.

> > usb-storage has no clear idea what sort of device lies on the other
> > side of the USB bridge.  It might be an ATA drive, it might be a flash
> > drive, it might not be a disk at all -- usb-storage does its best not
> > to know or care.
> 
> That's fine, but is there any way in USB to query the bridge to get it's
> transfer characteristics?

No, there isn't.  The only query that a USB mass-storage bridge accepts 
is for the maximum LUN value.

> > If you think that usb-storage needs to set a maximum transfer size for
> > disk drives, it won't be hard to write a patch.  But what about all the
> > other possible transports?  Will they each have to implement the same
> > transfer limit?  If so, shouldn't the limit be set up from a more
> > central location, such as the sd driver?
> 
> This isn't a transport problem, this is a bridge problem.  T10 has
> always recognised there might be a bridge issue linking two transports,
> so it did initially come up with a bridge spec (BCC) but it was
> abandoned a decade ago in favour of transparent bridges (every switch in
> a FC topology is effectively a transparent bridge) or making them
> explicit in the standards, like SAS expanders.
> 
> > Why not have sd always set max_sectors_kb to 32767 if it isn't already 
> > smaller?  Would that cause any problems?
> 
> This wouldn't be sd ... we have lots of requirements for large transfer
> sizes for efficiency.  It has to be the layer that knows there's a
> bridge, so that would make it usb.

All right.  How does this patch look?

Alan Stern



Index: usb-3.18/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-3.18.orig/drivers/usb/storage/scsiglue.c
+++ usb-3.18/drivers/usb/storage/scsiglue.c
@@ -114,26 +114,30 @@ static int slave_alloc (struct scsi_devi
 static int slave_configure(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
+	unsigned int max_sectors;
 
-	/* Many devices have trouble transferring more than 32KB at a time,
-	 * while others have trouble with more than 64K. At this time we
-	 * are limiting both to 32K (64 sectores).
+	/*
+	 * Many devices have trouble transferring more than 32 KB at a time,
+	 * while others have trouble with more than 64 KB. At this time we
+	 * are limiting both to 32 KB (64 sectores).
+	 * Still other devices have trouble unless the transfer size is as
+	 * small as possible (one memory page).
+	 *
+	 * Tape drives need much higher max_sector limits, so just
+	 * raise it to the maximum possible (4 GB / 512) and let the
+	 * queue segment size sort out the real limit.
+	 * For safety, limit all other devices to 32 MB transfer size.
 	 */
-	if (us->fflags & (US_FL_MAX_SECTORS_64 | US_FL_MAX_SECTORS_MIN)) {
-		unsigned int max_sectors = 64;
-
-		if (us->fflags & US_FL_MAX_SECTORS_MIN)
-			max_sectors = PAGE_CACHE_SIZE >> 9;
-		if (queue_max_hw_sectors(sdev->request_queue) > max_sectors)
-			blk_queue_max_hw_sectors(sdev->request_queue,
-					      max_sectors);
-	} else if (sdev->type == TYPE_TAPE) {
-		/* Tapes need much higher max_sector limits, so just
-		 * raise it to the maximum possible (4 GB / 512) and
-		 * let the queue segment size sort out the real limit.
-		 */
-		blk_queue_max_hw_sectors(sdev->request_queue, 0x7FFFFF);
-	}
+	if (us->fflags & US_FL_MAX_SECTORS_MIN)
+		max_sectors = PAGE_CACHE_SIZE >> 9;
+	else if (us->fflags & US_FL_MAX_SECTORS_64)
+		max_sectors = 64;
+	else if (sdev->type == TYPE_TAPE)
+		max_sectors = 0x7FFFFF;
+	else
+		max_sectors = 65535;
+	if (queue_max_hw_sectors(sdev->request_queue) > max_sectors)
+		blk_queue_max_hw_sectors(sdev->request_queue, max_sectors);
 
 	/* Some USB host controllers can't do DMA; they have to use PIO.
 	 * They indicate this by setting their dma_mask to NULL.  For

