From: Christoph Hellwig <hch@lst.de>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical
	max_hw_sectors cap")
Date: Sat, 27 Dec 2014 16:13:19 +0100
Message-ID: <20141227151319.GA18607@lst.de>
References: <alpine.DEB.2.10.1412211420560.4323@tosh-p75a> <20141223083140.GB2303@lst.de> <alpine.DEB.2.10.1412232342040.4626@tosh-p75a>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1412232342040.4626@tosh-p75a>
Sender: linux-ide-owner@vger.kernel.org
To: "Kenneth R. Crudup" <kenny@panix.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 23, 2014 at 11:48:40PM -0800, Kenneth R. Crudup wrote:
> > Looks like we need to quirk it.  Can you try to echo different limits
> > to the /sys/block/sdc/queue/max_hw_sectors_kb  file for the device to
> > find the limit for it?
> 
> Looks like it's 32767; making it an even 32K sectors starts the EIOs again.
> 
> To recap for the various lists:
> 
>   Vendor: Samsung  Model: D3 Station       Rev: 0202
>   Type:   Direct-Access                    ANSI  SCSI revision: 06
> 
> It's the 4TB model:
> 
> /sys/block/sdc/size:7814037160
> /sys/block/sdc/queue/max_hw_sectors_kb:61440
> 
> Works OK if I echo 32767 > /sys/block/sdc/queue/max_sectors_kb

Interesting.  Basically this is the limit for modern ATA disks:

drivers/ata/libata-core.c:             dev->max_sectors = ATA_MAX_SECTORS_LBA48;
drivers/ata/libata-core.c:             dev->max_sectors = ATA_MAX_SECTORS_LBA48;
include/linux/ata.h:    ATA_MAX_SECTORS_LBA48   = 65535,/* TODO: 65536? */

Seems like the USB bridge isn't properly communicating this limit to the SCSI
layer.  Maybe it's a good idea to generally limit USB storage to this size?

> Has anyone seen a disk out there that's got a (properly-supported)
> "max_hw_sectors_kb" >= 32K? If not, maybe we should clamp that value to
> prevent other misreporting(?) disks?

Yes, lots of SCSI disks and arrays properly support this.
