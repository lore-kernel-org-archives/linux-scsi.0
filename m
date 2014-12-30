From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical
 max_hw_sectors cap")
Date: Tue, 30 Dec 2014 07:50:32 -0800
Message-ID: <1419954632.2164.1.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1412301017060.30572-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39267 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbaL3Puh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2014 10:50:37 -0500
In-Reply-To: <Pine.LNX.4.44L0.1412301017060.30572-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>, "Kenneth R. Crudup" <kenny@panix.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Tue, 2014-12-30 at 10:34 -0500, Alan Stern wrote:
> On Tue, 30 Dec 2014, Christoph Hellwig wrote:
> 
> > > The only limits usb-storage imposes on max_sectors are those needed to
> > > work around bugs in the devices' USB bridges.  (Okay, there's also
> > > something for tape drive devices, but it probably doesn't belong in
> > > usb-storage -- it should be handled by the SCSI tape driver.)
> > > 
> > > If the ATA layer needs to set a limit on max_sectors, why doesn't it
> > > simply go ahead and do so?
> > 
> > Because the ATA layer doesn't control the device, the bridge does.
> > And it seems like it doesn't communicate the maximum transfer size
> > properly.
> 
> _Is_ there any way to communicate the maximum transfer size?  I'm not
> aware of any SCSI command for it.  It isn't part of the USB
> mass-storage spec.

For the device, it's in the Block limits VPD page.  However, what the
device supports isn't necessarily what the bridge or host bus adapter
will support.  We need to set the limit to the lowest of what the
device, the bridge and the HBA support.  We know the device (provided
the bridge allows VPD inquiries ... not all do) and host, so we really
need to know what the bridge will support.  From the error it does look
like we're running into a bridge limit.

> usb-storage has no clear idea what sort of device lies on the other
> side of the USB bridge.  It might be an ATA drive, it might be a flash
> drive, it might not be a disk at all -- usb-storage does its best not
> to know or care.

That's fine, but is there any way in USB to query the bridge to get it's
transfer characteristics?

> If you think that usb-storage needs to set a maximum transfer size for
> disk drives, it won't be hard to write a patch.  But what about all the
> other possible transports?  Will they each have to implement the same
> transfer limit?  If so, shouldn't the limit be set up from a more
> central location, such as the sd driver?

This isn't a transport problem, this is a bridge problem.  T10 has
always recognised there might be a bridge issue linking two transports,
so it did initially come up with a bridge spec (BCC) but it was
abandoned a decade ago in favour of transparent bridges (every switch in
a FC topology is effectively a transparent bridge) or making them
explicit in the standards, like SAS expanders.

> Why not have sd always set max_sectors_kb to 32767 if it isn't already 
> smaller?  Would that cause any problems?

This wouldn't be sd ... we have lots of requirements for large transfer
sizes for efficiency.  It has to be the layer that knows there's a
bridge, so that would make it usb.

James



