From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Reducing the verbosity of inserting a USB storage device
Date: Sun, 20 Sep 2009 21:09:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0909202104300.14465-100000@netrider.rowland.org>
References: <20090920225348.GB3690@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090920225348.GB3690-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 20 Sep 2009, Matthew Wilcox wrote:

> The current kernel is very verbose when you insert a new USB storage
> device:
> 
> usb 1-2: new high speed USB device using ehci_hcd and address 9
> usb 1-2: configuration #1 chosen from 1 choice
> scsi4 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 9
> usb-storage: waiting for device to settle before scanning
> usb-storage: device scan complete
> scsi 4:0:0:0: Direct-Access     GENERIC  USB DISK DEVICE  0100 PQ: 0 ANSI: 0 CCS
> sd 4:0:0:0: Attached scsi generic sg2 type 0
> sd 4:0:0:0: [sdc] 15728128 512-byte hardware sectors: (8.05 GB/7.49 GiB)
> sd 4:0:0:0: [sdc] Write Protect is off
> sd 4:0:0:0: [sdc] Mode Sense: 00 12 00 00
> sd 4:0:0:0: [sdc] Assuming drive cache: write through
> sd 4:0:0:0: [sdc] Assuming drive cache: write through
>  sdc:
> sd 4:0:0:0: [sdc] Attached SCSI removable disk
> 
> I think we can print a bit less information, and format it more densely.
> With the following three patches, my kernel prints:
> 
> usb 1-4: new high speed USB device using ehci_hcd and address 5
> usb 1-4: configuration #1 chosen from 1 choice
> scsi 6:0:0:0: Direct-Access              Flash Disk       5.00 PQ: 0 ANSI: 2
> sd 6:0:0:0: Attached scsi generic sg1 type 0
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> sd 6:0:0:0: [sdb] 2009088 512-byte logical blocks: (1.02 GB/981 MiB)
> sd 6:0:0:0: [sdb] Removable disk, Write Protect is off
>  sdb: unknown partition table
> 
> which doesn't take up nearly as much of my syslog ;-)

I approve of these changes in general, but there should be one more
line of information.  In the "after" example, there's nothing to relate
the USB device mentioned in the first two lines with the SCSI device
mentioned in the remaining six.  I'd like to see one line in between
from usb-storage, to indicate which USB interface is being registered
as which SCSI host.

We don't print anything quite like that right now, so this would have 
to be something new.  The closest we come is the "scsi4 : SCSI 
emulation for USB Mass Storage devices" line, and it doesn't mention 
the USB interface.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
