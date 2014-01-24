From: Alan Stern <stern@rowland.harvard.edu>
Subject: =?utf-8?q?Re=3A_=5Busb=2Dstorage=5D_Re=3A_usb_disk_recognized_but_fails?=
Date: Fri, 24 Jan 2014 11:07:01 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401241056050.1129-100000@iolanthe.rowland.org>
References: <20140124075752.615F312D@centrum.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49368 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750932AbaAXQHC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 11:07:02 -0500
In-Reply-To: <20140124075752.615F312D@centrum.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthieu Castet <castet.matthieu@free.fr>, =?utf-8?q?Milan_Svoboda?= <milan.svoboda@centrum.cz>
Cc: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp@linux.intel.com>, USB list <linux-usb@vger.kernel.org>, =?utf-8?q?USB_Storage_List?= <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Matthieu:

Can you help with this problem?

On Fri, 24 Jan 2014, Milan Svoboda wrote:

> >I don't see how that could have made any difference.  The Cypress-ATACB 
> >driver works just like the default driver, except for two commands
> >(ATA(12) and ATA(16)) neither of which appeared in the usbmon trace.

That was my fault.  The reason they didn't appear in the trace was 
because the Cypress-ATACB driver filtered them out and replaced them 
with ATACB commands.

> >Your new config enables CONFIG_USB_STORAGE_DEBUG.  More likely that is 
> >the reason for the improvement.  Try taking out that one setting (don't 
> >change anything else) and see what happens.
> >
> 
> I disabled the CONFIG_USB_STORAGE_DEBUG and the kernel mounts the disk without any problem:
> 
> [  158.892294] ehci-pci 0000:00:1d.0: port 1 remote wakeup
> [  158.892310] usb usb2: usb wakeup-resume
> [  158.892314] usb usb2: usb auto-resume
> [  158.892321] ehci-pci 0000:00:1d.0: resume root hub
> [  158.892337] hub 2-0:1.0: hub_resume
> [  158.892358] hub 2-0:1.0: port 1: status 0507 change 0000
> [  158.892404] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
> [  158.895950] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
> [  158.921854] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0002
> [  158.921975] ehci-pci 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [  158.935155] usb 2-1: usb wakeup-resume
> [  158.935179] usb 2-1: finish resume
> [  158.935351] hub 2-1:1.0: hub_resume
> [  158.935479] hub 2-1:1.0: port 1: status 0101 change 0001
> [  159.038465] ehci-pci 0000:00:1d.0: reused qh ffff88007fbbe900 schedule
> [  159.038472] usb 2-1: link qh256-0001/ffff88007fbbe900 start 1 [1/0 us]
> [  159.038498] hub 2-0:1.0: resume on port 1, status 0
> [  159.038503] hub 2-1:1.0: state 7 ports 8 chg 0002 evt 0000
> [  159.038580] hub 2-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
> [  159.105244] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
> [  159.189282] usb 2-1.1: default language 0x0409
> [  159.189773] usb 2-1.1: udev 3, busnum 2, minor = 130
> [  159.189778] usb 2-1.1: New USB device found, idVendor=14cd, idProduct=6116
> [  159.189782] usb 2-1.1: New USB device strings: Mfr=1, Product=3, SerialNumber=2
> [  159.189785] usb 2-1.1: Product: USB 2.0  SATA BRIDGE   
> [  159.189788] usb 2-1.1: Manufacturer: Super Top   
> [  159.189791] usb 2-1.1: SerialNumber: M6116018VE15
> [  159.189934] usb 2-1.1: usb_probe_device
> [  159.189936] usb 2-1.1: configuration #1 chosen from 1 choice
> [  159.190020] usb 2-1.1: adding 2-1.1:1.0 (config #1, interface 0)
> [  159.190085] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0002
> [  159.247165] usb-storage 2-1.1:1.0: usb_probe_interface
> [  159.247172] usb-storage 2-1.1:1.0: usb_probe_interface - got id
> [  159.247174] usb-storage 2-1.1:1.0: USB Mass Storage device detected
> [  159.247232] scsi6 : usb-storage 2-1.1:1.0
> [  159.247285] usbcore: registered new interface driver usb-storage
> [  160.249006] scsi 6:0:0:0: Direct-Access     WDC WD64 00BPVT-00HXZT0        PQ: 0 ANSI: 0
> [  160.249817] sd 6:0:0:0: [sdb] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
> [  160.250442] sd 6:0:0:0: [sdb] Write Protect is off
> [  160.250454] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
> [  160.251056] sd 6:0:0:0: [sdb] No Caching mode page found
> [  160.251059] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  160.253426] sd 6:0:0:0: [sdb] No Caching mode page found
> [  160.253429] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  160.259768]  sdb: sdb1
> [  160.262446] sd 6:0:0:0: [sdb] No Caching mode page found
> [  160.262453] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  160.262458] sd 6:0:0:0: [sdb] Attached SCSI disk

> Then I rebooted to the "normal" kernel (that one that use ums_cypress) and it doesn't work. The same symptoms.

You were right; that driver caused the problem.

Matthieu Castet wrote the Cypress-ATACB driver, so maybe he can help.

As shown above, this device matches the last entry in the
unusual_cypress.h file (the one named "Super Top").  Not shown here is
the bcdDevice value, which is 0x0150.  Should the bcdDevice range for
that unusual_devs entry be restricted to just 0x0219?

Milan, the patch below should prevent the Cypress-ATACB driver from 
binding to your device.  With this change, the original kernel config 
should work.

Alan Stern



Index: usb-3.13/drivers/usb/storage/unusual_cypress.h
===================================================================
--- usb-3.13.orig/drivers/usb/storage/unusual_cypress.h
+++ usb-3.13/drivers/usb/storage/unusual_cypress.h
@@ -31,7 +31,7 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x
 		"Cypress ISD-300LP",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
 
-UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x0219,
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0219, 0x0219,
 		"Super Top",
 		"USB 2.0  SATA BRIDGE",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),

