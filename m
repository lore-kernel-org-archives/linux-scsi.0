From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Tue, 30 Dec 2014 10:34:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1412301017060.30572-100000@netrider.rowland.org>
References: <20141230112809.GA1360@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20141230112809.GA1360@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Kenneth R. Crudup" <kenny@panix.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Tue, 30 Dec 2014, Christoph Hellwig wrote:

> > The only limits usb-storage imposes on max_sectors are those needed to
> > work around bugs in the devices' USB bridges.  (Okay, there's also
> > something for tape drive devices, but it probably doesn't belong in
> > usb-storage -- it should be handled by the SCSI tape driver.)
> > 
> > If the ATA layer needs to set a limit on max_sectors, why doesn't it
> > simply go ahead and do so?
> 
> Because the ATA layer doesn't control the device, the bridge does.
> And it seems like it doesn't communicate the maximum transfer size
> properly.

_Is_ there any way to communicate the maximum transfer size?  I'm not
aware of any SCSI command for it.  It isn't part of the USB
mass-storage spec.

usb-storage has no clear idea what sort of device lies on the other
side of the USB bridge.  It might be an ATA drive, it might be a flash
drive, it might not be a disk at all -- usb-storage does its best not
to know or care.

If you think that usb-storage needs to set a maximum transfer size for
disk drives, it won't be hard to write a patch.  But what about all the
other possible transports?  Will they each have to implement the same
transfer limit?  If so, shouldn't the limit be set up from a more
central location, such as the sd driver?

Why not have sd always set max_sectors_kb to 32767 if it isn't already 
smaller?  Would that cause any problems?

Alan Stern

