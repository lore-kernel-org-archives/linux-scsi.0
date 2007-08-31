From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] usb-storage and Motorola Z6
Date: Fri, 31 Aug 2007 16:56:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0708311636090.24258-100000@netrider.rowland.org>
References: <20070831190405.GA7506@kocom.akoenecke.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3902 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932301AbXHaU4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 16:56:22 -0400
In-Reply-To: <20070831190405.GA7506@kocom.akoenecke.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Koenecke <akoenecke@akoenecke.de>
Cc: USB users list <linux-usb-users@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 31 Aug 2007, Andreas Koenecke wrote:

> * Mittwoch, 29. August 2007 um 10:07 (-0400) schrieb Alan Stern:
> > 
> > You can edit the source code of the SCSI core to make it ignore the PQ 
> > value.  In the file drivers/scsi/scsi_sysfs.c, find the 
> > scsi_bus_match() routine and change the last line from:
> > 
> > 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
> > 
> > to
> > 
> > 	return 1;
> 
> OK, I have done it. But there ist still no success.
> When I connect the phone the messages are:
> --------------------------------------------------------------------------------------------
> Aug 31 20:14:53 kocom kernel: usb 3-1: new high speed USB device using ehci_hcd and address 2
> Aug 31 20:14:53 kocom kernel: usb 3-1: configuration #1 chosen from 1 choice
> Aug 31 20:14:53 kocom kernel: usbcore: registered new interface driver libusual
> Aug 31 20:14:53 kocom kernel: Initializing USB Mass Storage driver...
> Aug 31 20:14:53 kocom kernel: scsi3 : SCSI emulation for USB Mass Storage devices
> Aug 31 20:14:53 kocom kernel: usb-storage: device found at 2
> Aug 31 20:14:53 kocom kernel: usb-storage: waiting for device to settle before scanning
> Aug 31 20:14:53 kocom kernel: usbcore: registered new interface driver usb-storage
> Aug 31 20:14:53 kocom kernel: USB Mass Storage support registered.
> Aug 31 20:14:58 kocom kernel: usb-storage: device scan complete
> Aug 31 20:14:58 kocom kernel: scsi 3:0:0:0: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
> Aug 31 20:14:58 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
> Aug 31 20:14:58 kocom kernel: scsi 3:0:0:1: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
> Aug 31 20:14:58 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
> Aug 31 20:14:58 kocom kernel: sd 3:0:0:0: [sdb] Attached SCSI removable disk
> Aug 31 20:14:58 kocom kernel: sd 3:0:0:0: Attached scsi generic sg2 type 0
> Aug 31 20:14:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
> Aug 31 20:14:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
> Aug 31 20:14:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
> Aug 31 20:14:59 kocom kernel: sd 3:0:0:1: [sdc] Attached SCSI removable disk
> Aug 31 20:14:59 kocom kernel: sd 3:0:0:1: Attached scsi generic sg3 type 0

That's pretty much okay.  Apart from the resets, it indicates that the 
computer did detect and install the two logical drives, sdb and sdc.

> Aug 31 20:14:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
> Aug 31 20:15:01 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
...

All those reset messages are caused by a bug in the device.  Every 
command sent to the device is labelled with a "Tag" value; it shows up 
in the debugging log on each "Bulk Command" line as the number 
following the T.  For example:

	Bulk Command S 0x43425355 T 0x4 L 18 F 128 Trg 0 LUN 0 CL 6

Here the Tag is 0x4.  In its status response, the device must include a
matching Tag value to indicate which command the status is for.  If you
look at the debugging log, you'll see the status line for this
particular command was:

	Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0

The Tag is 0x3, which doesn't match!  The device made this mistake 15
times in 410 commands, apparently at random, and each time the computer
issued a reset to try and fix the problem.  That's a pretty serious 
bug in the Z6.

If you want to work around this bug, you can edit the file 
drivers/usb/storage/transport.c.  In the usb_stor_Bulk_transport() 
routine, edit this line:

        if (bcs->Tag != us->tag || bcs->Status > US_BULK_STAT_PHASE) {

and change it to:

        if (bcs->Status > US_BULK_STAT_PHASE) {

> /proc/partition and 'fdisk' show no sdb or sdc.

That's a separate matter.  The log shows that the computer sent 
numerous TEST UNIT READY commands to the device, and every time the 
device answered with a code that means "Not ready, medium not present".  
In other words, it's saying that it needs to have a memory card or 
something like that inserted.

Alan Stern

