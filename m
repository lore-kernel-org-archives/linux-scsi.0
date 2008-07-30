From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
Date: Tue, 29 Jul 2008 23:08:42 -0500
Message-ID: <1217390922.6103.79.camel@localhost.localdomain>
References: <103966.68801.qm@web83207.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60261 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbYG3EIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 00:08:47 -0400
In-Reply-To: <103966.68801.qm@web83207.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Frost <artusemrys@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Matt Frost <artusemrys@sbcglobal.net>, linux-scsi <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>

On Tue, 2008-07-29 at 17:06 -0700, Matthew Frost wrote:
> James and co., 
> 
> Bug report: regression in 2.6.27-rc1 -- scsi WRT usb-storage
> Origin: Commit de72aa4c2b82a6cffe15d86a8d391ded4fb57602, "[SCSI] erase
> invalid data returned by device"
> Location: drivers/scsi_lib.c
> Device: Secure Digital HC 4GB card in USB 2.0 card reader

Actually, this is a USB issue ... I've added the correct cc's

James


> Summary:
> Between 2.6.26-rc9-git10 and rc9-git11, the kernel stopped properly
> recognizing my USB-card-reader-mounted SDHC 4GB card.  The problem seems to
> come up between usb-storage recognizing the device, and the handoff to scsi
> to read the disk properties.  The bug remains in 2.6.26 and 2.6.27-rc1;
> kernels before 2.6.26-rc9-git10 are unaffected.  On the same EHCI controller,
> an old-spec SD 1GB card and its reader are unaffected by this bug.
> 
> The normal recognition and initialization of the device (from rc9-git9 dmesg)
> goes like this:
> 
> PCI: Setting latency timer of device 0000:00:1d.7 to 64
> ehci_hcd 0000:00:1d.7: EHCI Host Controller
> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> PCI: cache line size of 128 is not supported by device 0000:00:1d.7
> ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe4000000
> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 6 ports detected
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.26-rc9-git9 ehci_hcd
> usb usb1: SerialNumber: 0000:00:1d.7
> --%<--
> usb 1-1: new high speed USB device using ehci_hcd and address 2
> usb 1-1: configuration #1 chosen from 1 choice
> usb 1-1: New USB device found, idVendor=058f, idProduct=6331
> usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-1: Product: Mass Storage Device
> usb 1-1: Manufacturer: Generic
> usb 1-1: SerialNumber: 058F091111B
> --%<--
> usb 1-2: new high speed USB device using ehci_hcd and address 3
> usb 1-2: configuration #1 chosen from 1 choice
> usb 1-2: New USB device found, idVendor=090c, idProduct=6000
> usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-2: Product: USB2.0 Card Reader
> usb 1-2: Manufacturer: Generic       ,   .
> usb 1-2: SerialNumber: 12345678901234567890
> --%<--
> Initializing USB Mass Storage driver...
> scsi4 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> scsi5 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 3
> usb-storage: waiting for device to settle before scanning
> --%<--
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usbcore: registered new interface driver libusual
> --%<--
> usb-storage: device scan complete
> scsi 4:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI: 0
> usb-storage: device scan complete
> scsi 5:0:0:0: Direct-Access     Generic                   6000 PQ: 0 ANSI: 0
> CCS
> sd 4:0:0:0: [sde] 1953792 512-byte hardware sectors (1000 MB)
> sd 4:0:0:0: [sde] Write Protect is off
> sd 4:0:0:0: [sde] Mode Sense: 03 00 00 00
> sd 4:0:0:0: [sde] Assuming drive cache: write through
> sd 4:0:0:0: [sde] 1953792 512-byte hardware sectors (1000 MB)
> sd 4:0:0:0: [sde] Write Protect is off
> sd 4:0:0:0: [sde] Mode Sense: 03 00 00 00
> sd 4:0:0:0: [sde] Assuming drive cache: write through
>  sde: sde1
> sd 4:0:0:0: [sde] Attached SCSI removable disk
> sd 4:0:0:0: Attached scsi generic sg6 type 0
> sd 5:0:0:0: [sdf] 7861248 512-byte hardware sectors (4025 MB)
> sd 5:0:0:0: [sdf] Write Protect is off
> sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> sd 5:0:0:0: [sdf] Assuming drive cache: write through
> sd 5:0:0:0: [sdf] 7861248 512-byte hardware sectors (4025 MB)
> sd 5:0:0:0: [sdf] Write Protect is off
> sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> sd 5:0:0:0: [sdf] Assuming drive cache: write through
>  sdf: sdf1
> sd 5:0:0:0: [sdf] Attached SCSI removable disk
> sd 5:0:0:0: Attached scsi generic sg7 type 0
> 
> (sde is the 1GB SD card/reader, sdf is the 4GB SDHC card/reader.)
> 
> After the bug, initialization looks the same until the device scan finishes. 
> Handoff to scsi produces the following (taken from rc9-git12):
> 
> usb-storage: device scan complete
> scsi 4:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI: 0
> usb-storage: device scan complete
> scsi 5:0:0:0: Direct-Access     Generic                   6000 PQ: 0 ANSI: 0
> CCS
> sd 4:0:0:0: [sde] 1953792 512-byte hardware sectors (1000 MB)
> sd 4:0:0:0: [sde] Write Protect is off
> sd 4:0:0:0: [sde] Mode Sense: 03 00 00 00
> sd 4:0:0:0: [sde] Assuming drive cache: write through
> sd 4:0:0:0: [sde] 1953792 512-byte hardware sectors (1000 MB)
> sd 4:0:0:0: [sde] Write Protect is off
> sd 4:0:0:0: [sde] Mode Sense: 03 00 00 00
> sd 4:0:0:0: [sde] Assuming drive cache: write through
>  sde: sde1
> sd 4:0:0:0: [sde] Attached SCSI removable disk
> sd 4:0:0:0: Attached scsi generic sg6 type 0
> sd 5:0:0:0: [sdf] Sector size 0 reported, assuming 512.
> sd 5:0:0:0: [sdf] 1 512-byte hardware sectors (0 MB)
> sd 5:0:0:0: [sdf] Write Protect is off
> sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> sd 5:0:0:0: [sdf] Assuming drive cache: write through
> sd 5:0:0:0: [sdf] Sector size 0 reported, assuming 512.
> sd 5:0:0:0: [sdf] 1 512-byte hardware sectors (0 MB)
> sd 5:0:0:0: [sdf] Write Protect is off
> sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> sd 5:0:0:0: [sdf] Assuming drive cache: write through
>  sdf: sdf1
>  sdf: p1 exceeds device capacity
> sd 5:0:0:0: [sdf] Attached SCSI removable disk
> sd 5:0:0:0: Attached scsi generic sg7 type 0
> 
> And after boot, the following set of errors recurs until device removal.
> Device removal, in this case, was necessary to get LILO to update (-git12
> again):
> 
> attempt to access beyond end of device
> sdf: rw=0, want=8200, limit=1
> Buffer I/O error on device sdf1, logical block 0
> attempt to access beyond end of device
> sdf: rw=0, want=8208, limit=1
> Buffer I/O error on device sdf1, logical block 1
> attempt to access beyond end of device
> sdf: rw=0, want=8216, limit=1
> Buffer I/O error on device sdf1, logical block 2
> attempt to access beyond end of device
> sdf: rw=0, want=8224, limit=1
> Buffer I/O error on device sdf1, logical block 3
> attempt to access beyond end of device
> sdf: rw=0, want=8200, limit=1
> Buffer I/O error on device sdf1, logical block 0
> attempt to access beyond end of device
> sdf: rw=0, want=8200, limit=1
> Buffer I/O error on device sdf1, logical block 0
> attempt to access beyond end of device
> sdf: rw=0, want=8208, limit=1
> Buffer I/O error on device sdf1, logical block 1
> attempt to access beyond end of device
> sdf: rw=0, want=8216, limit=1
> Buffer I/O error on device sdf1, logical block 2
> attempt to access beyond end of device
> sdf: rw=0, want=8224, limit=1
> Buffer I/O error on device sdf1, logical block 3
> attempt to access beyond end of device
> sdf: rw=0, want=8200, limit=1
> Buffer I/O error on device sdf1, logical block 0
> attempt to access beyond end of device
> sdf: rw=0, want=8200, limit=1
> Buffer I/O error on device sdf1, logical block 0
> attempt to access beyond end of device
> sdf: rw=0, want=8208, limit=1
> Buffer I/O error on device sdf1, logical block 1
> attempt to access beyond end of device
> sdf: rw=0, want=8216, limit=1
> Buffer I/O error on device sdf1, logical block 2
> attempt to access beyond end of device
> sdf: rw=0, want=8224, limit=1
> Buffer I/O error on device sdf1, logical block 3
> attempt to access beyond end of device
> sdf: rw=0, want=8200, limit=1
> Buffer I/O error on device sdf1, logical block 0
> usb 1-2: USB disconnect, address 3
> 
> I'm not well-versed in git, so I looked through the diff between rc9-git10
> and rc9-git11.  This is what looks like the offending addition:
> 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index a82d2fe..cbf55d5 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -207,6 +207,15 @@ int scsi_execute(struct scsi_device *sdev, const
> unsigned char *cmd,
> >  	 */
> >  	blk_execute_rq(req->q, NULL, req, 1);
> >  
> > +	/*
> > +	 * Some devices (USB mass-storage in particular) may transfer
> > +	 * garbage data together with a residue indicating that the data
> > +	 * is invalid.  Prevent the garbage from being misinterpreted
> > +	 * and prevent security leaks by zeroing out the excess data.
> > +	 */
> > +	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
> > +		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
> > +
> >  	ret = req->errors;
> >   out:
> >  	blk_put_request(req);
> 
> I looked through the online git log, and it's part of commit
> de72aa4c2b82a6cffe15d86a8d391ded4fb57602, under "[SCSI] erase invalid data
> returned by device".  Reverting this part by itself restores the correct
> handling of the device in 2.6.27-rc1.
> 
> Perhaps there's a better way to do what this patch is trying to do, because
> it seems to be erasing the valid data returned by my device.  If you want me
> to test out options, I'd be glad to, since I have the "offending" hardware. 
> Specifics: A-Data 4GB TurboSD Class 6 SDHC card, 4GB, in a Rosewill RSD-CR102
> card reader.
> 
> (Please include me on replies, I've stopped being a subscriber.)
> 
> Thanks!
> 
> Matthew Frost
> artusemrys sbcglobal net

