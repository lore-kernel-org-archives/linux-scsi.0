From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Sun, 28 Dec 2014 22:10:01 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1412282200040.24524-100000@netrider.rowland.org>
References: <20141227151319.GA18607@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20141227151319.GA18607@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Kenneth R. Crudup" <kenny@panix.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Sat, 27 Dec 2014, Christoph Hellwig wrote:

> On Tue, Dec 23, 2014 at 11:48:40PM -0800, Kenneth R. Crudup wrote:
> > > Looks like we need to quirk it.  Can you try to echo different limits
> > > to the /sys/block/sdc/queue/max_hw_sectors_kb  file for the device to
> > > find the limit for it?
> > 
> > Looks like it's 32767; making it an even 32K sectors starts the EIOs again.
> > 
> > To recap for the various lists:
> > 
> >   Vendor: Samsung  Model: D3 Station       Rev: 0202
> >   Type:   Direct-Access                    ANSI  SCSI revision: 06
> > 
> > It's the 4TB model:
> > 
> > /sys/block/sdc/size:7814037160
> > /sys/block/sdc/queue/max_hw_sectors_kb:61440
> > 
> > Works OK if I echo 32767 > /sys/block/sdc/queue/max_sectors_kb
> 
> Interesting.  Basically this is the limit for modern ATA disks:
> 
> drivers/ata/libata-core.c:             dev->max_sectors = ATA_MAX_SECTORS_LBA48;
> drivers/ata/libata-core.c:             dev->max_sectors = ATA_MAX_SECTORS_LBA48;
> include/linux/ata.h:    ATA_MAX_SECTORS_LBA48   = 65535,/* TODO: 65536? */
> 
> Seems like the USB bridge isn't properly communicating this limit to the SCSI
> layer.  Maybe it's a good idea to generally limit USB storage to this size?

(Is this a USB device?  Presumably you wouldn't have CC'ed the
linux-usb and usb-storage mailing lists if it wasn't...)

The only limits usb-storage imposes on max_sectors are those needed to
work around bugs in the devices' USB bridges.  (Okay, there's also
something for tape drive devices, but it probably doesn't belong in
usb-storage -- it should be handled by the SCSI tape driver.)

If the ATA layer needs to set a limit on max_sectors, why doesn't it
simply go ahead and do so?

Alan Stern

