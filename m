From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [usb-storage] Re: usb disk recognized but fails
Date: Tue, 21 Jan 2014 17:12:03 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401211707260.1272-100000@iolanthe.rowland.org>
References: <20140121215636.F5422382@centrum.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140121215636.F5422382-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?q?Milan_Svoboda?= <milan.svoboda-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
Cc: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?utf-8?q?USB_Storage_List?= <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 21 Jan 2014, Milan Svoboda wrote:

> I have applied the patches to a0fa1dd3cdbccec9597fe53b6177a9aa6e20f2f8:

> The kernel logs:
> 
> [  114.854464] usb 3-1: new high-speed USB device number 2 using xhci_hcd
> [  114.920229] usbcore: registered new interface driver usb-storage
> [  114.920647] ums-cypress 3-1:1.0: USB Mass Storage device detected
> [  114.920705] scsi6 : usb-storage 3-1:1.0
> [  114.920816] usbcore: registered new interface driver ums-cypress
> [  115.921301] scsi 6:0:0:0: Direct-Access     WDC WD64 00BPVT-00HXZT0        PQ: 0 ANSI: 0
> [  115.921991] sd 6:0:0:0: [sdb] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
> [  115.922142] sd 6:0:0:0: [sdb] Write Protect is off
> [  115.922145] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
> [  115.922269] sd 6:0:0:0: [sdb] No Caching mode page found
> [  115.922271] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  115.922929] sd 6:0:0:0: [sdb] No Caching mode page found
> [  115.922931] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  115.938479]  sdb: sdb1
> [  115.939112] sd 6:0:0:0: [sdb] No Caching mode page found
> [  115.939115] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  115.939117] sd 6:0:0:0: [sdb] Attached SCSI disk
> [  124.241874] usb 3-1: reset high-speed USB device number 2 using xhci_hcd

This reset is unexplained.  It happened almost 70 seconds before the 
error below.

> [  124.255232] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8801f899f700
> [  124.255237] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8801f899f740
> [  128.552357] vboxdrv: Found 4 processor cores.
> [  128.552802] vboxdrv: fAsync=0 offMin=0x1dd offMax=0x16bc
> [  128.552862] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
> [  128.552864] vboxdrv: Successfully loaded version 4.3.6_OSE (interface 0x001a0007).
> [  128.556554] vboxpci: IOMMU not found (not registered)
> [  191.463779] sd 6:0:0:0: [sdb] Unhandled sense code
> [  191.463786] sd 6:0:0:0: [sdb]  
> [  191.463788] Result: hostbyte=0x07 driverbyte=0x08
> [  191.463791] sd 6:0:0:0: [sdb]  
> [  191.463793] Sense Key : 0x4 [current] 
> [  191.463797] sd 6:0:0:0: [sdb]  
> [  191.463799] ASC=0x0 ASCQ=0x0
> [  191.463802] sd 6:0:0:0: [sdb] CDB: 
> [  191.463803] cdb[0]=0x28: 28 00 4a 85 6e af 00 00 08 00
> [  191.463813] end_request: I/O error, dev sdb, sector 1250258607

Sense Key 4 means Hardware Error.  It's possible that something is 
wrong with your disk.

In any case, can you post a usbmon trace showing what happens starting
from when you plug in the USB disk?  Instructions are in the kernel
source file Documentation/usb/usbmon.txt.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
