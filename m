From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 19:39:11 +0100
Message-ID: <20080129183910.GI15220@kernel.dk>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:17299 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687AbYA2SjR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 13:39:17 -0500
Content-Disposition: inline
In-Reply-To: <20080129143109.GW15220@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jan 29 2008, Jens Axboe wrote:
> On Tue, Jan 29 2008, Oliver Neukum wrote:
> > Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > >> Greg KH wrote:
> >  
> > > > > No difference, still just a lot of resets.
> > > > > 
> > > > Where you able to figure out which usb storage transport is used?
> > > > 
> > > > in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
> > > > functions. I'm not sure if these get stored in sysfs perhaps. This will
> > > > pinpoint better where to look. Let me research a bit. 
> > > 
> > > Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
> > > transport is 'Bulk'
> > 
> > You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
> > That should tell the reason for the resets.
> 
> Sure, I'll do that. Will post the results tonight.

OK, fresh boot with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG. Plugged
in the device, waited 10 seconds or so and pulled it out. These are the
messages.

It all looks good until the MODE_SENSE command, where it only transfers
4 of 192 bytes.

usb usb5: usb resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 5-0:1.0: hub_resume
hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0000
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
hub 5-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: default language 0x0409
usb 5-1: uevent
usb 5-1: usb_probe_device
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: adding 5-1:1.0 (config #1, interface 0)
usb 5-1:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
usb 5-1: new device strings: Mfr=0, Product=3, SerialNumber=4
usb 5-1: Product: Flash Reader
usb 5-1: SerialNumber: 02206
Initializing USB Mass Storage driver...
usb-storage 5-1:1.0: usb_probe_interface
usb-storage 5-1:1.0: usb_probe_interface - got id
usb-storage: USB Mass Storage device detected
usb-storage: -- associate_dev
usb-storage: Vendor: 0x05e3, Product: 0x0760, Revision: 0x0125
usb-storage: Interface Subclass: 0x06, Protocol: 0x50
usb trans Bulk
usb-storage: Transport: Bulk
usb proto Transparent SCSI
usb-storage: Protocol: Transparent SCSI
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: *** thread sleeping.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
usb-storage: GetMaxLUN command result is 1, data is 3
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command INQUIRY (6 bytes)
usb-storage:  12 00 00 00 24 00
usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
usb-storage: Status code 0; transferred 36/36
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0 ANSI: 0
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x2 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x2 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code 0; transferred 8/8
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command MODE_SENSE (6 bytes)
usb-storage:  1a 00 3f 00 c0 00
usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
usb-storage: Status code -121; transferred 4/192
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -32; transferred 0/13
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Attempting to get CSW (2nd try)...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4 R 188 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x5 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x5 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
usb-storage:  1e 00 00 00 01 00
usb-storage: Bulk Command S 0x43425355 T 0x6 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x6 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x7 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x7 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x8 L 8 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code 0; transferred 8/8
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x8 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command MODE_SENSE (6 bytes)
usb-storage:  1a 00 3f 00 c0 00
usb-storage: Bulk Command S 0x43425355 T 0x9 L 192 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
usb-storage: Status code -121; transferred 4/192
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -32; transferred 0/13
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Attempting to get CSW (2nd try)...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x9 R 188 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb:<7>usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage:  28 00 00 00 00 00 00 00 08 00
usb-storage: Bulk Command S 0x43425355 T 0xa L 4096 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
usb-storage: Status code 0; transferred 4096/4096
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xa R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
 sdb1
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
usb-storage:  1e 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0xb L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xb R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 6:0:0:0: [sdb] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg1 type 0
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command INQUIRY (6 bytes)
usb-storage:  12 00 00 00 24 00
usb-storage: Bulk Command S 0x43425355 T 0xc L 36 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
usb-storage: Status code 0; transferred 36/36
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xc R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
scsi 6:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0 ANSI: 0
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0xd L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0xe L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0xf L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xf R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x10 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x11 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x11 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x12 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x13 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x13 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x14 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x15 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x15 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x16 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x17 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x17 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x18 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x19 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x19 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x1a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x1b L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x1c L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x1d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x1e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x1f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x20 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x21 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x21 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x22 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x23 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x23 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x24 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x25 L 8 F 128 Trg 0 LUN 1 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code -32; transferred 0/8
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x25 R 8 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x26 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code -75; transferred 0/18
usb-storage: -- babble
usb-storage: Bulk data transfer result 0x3
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -75; transferred 0/13
usb-storage: -- babble
usb-storage: Bulk status result = 3
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x27 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x27 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x28 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x29 L 8 F 128 Trg 0 LUN 1 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code -32; transferred 0/8
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x29 R 8 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x2a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code -75; transferred 0/18
usb-storage: -- babble
usb-storage: Bulk data transfer result 0x3
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -75; transferred 0/13
usb-storage: -- babble
usb-storage: Bulk status result = 3
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x2b L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x2b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x2c L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x2d L 8 F 128 Trg 0 LUN 1 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code -32; transferred 0/8
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x2d R 8 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x2e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code -75; transferred 0/18
usb-storage: -- babble
usb-storage: Bulk data transfer result 0x3
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -75; transferred 0/13
usb-storage: -- babble
usb-storage: Bulk status result = 3
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x2f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x2f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x30 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x31 L 8 F 128 Trg 0 LUN 1 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code -32; transferred 0/8
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x31 R 8 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x32 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code -75; transferred 0/18
usb-storage: -- babble
usb-storage: Bulk data transfer result 0x3
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -75; transferred 0/13
usb-storage: -- babble
usb-storage: Bulk status result = 3
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x33 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x33 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x34 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x35 L 8 F 128 Trg 0 LUN 1 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code -32; transferred 0/8
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x35 R 8 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x36 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code -75; transferred 0/18
usb-storage: -- babble
usb-storage: Bulk data transfer result 0x3
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -75; transferred 0/13
usb-storage: -- babble
usb-storage: Bulk status result = 3
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x37 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x37 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x38 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x39 L 8 F 128 Trg 0 LUN 1 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code -32; transferred 0/8
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x39 R 8 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x3a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code -75; transferred 0/18
usb-storage: -- babble
usb-storage: Bulk data transfer result 0x3
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -75; transferred 0/13
usb-storage: -- babble
usb-storage: Bulk status result = 3
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns 0
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x3b L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x3b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x3c L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: usb_sg_init returned -22
usb-storage: Bulk data transfer result 0x4
usb-storage: -- auto-sense failure
usb-storage: storage_pre_reset
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0002
usb 5-1: reset high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 1 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001002 POWER sig=se0 CSC
hub 5-0:1.0: logical disconnect on port 1
usb-storage: storage_post_reset
usb-storage: usb_reset_composite_device returns -19
usb-storage: usb_stor_Bulk_reset called
usb-storage: usb_stor_control_msg: rq=ff rqtype=21 value=0000 index=00 len=0
usb-storage: Soft reset failed: -19
usb-storage: scsi cmd done, result=0x70000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
hub 5-0:1.0: state 7 ports 8 chg 0002 evt 0002
hub 5-0:1.0: port 1, status 0100, change 0000, 12 Mb/s
usb 5-1: USB disconnect, address 2
usb 5-1: unregistering device
usb 5-1: usb_disable_device nuking all URBs
usb 5-1: unregistering interface 5-1:1.0
usb-storage: storage_disconnect() called
usb-storage: usb_stor_stop_transport called
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
sd 6:0:0:1: [sdc] READ CAPACITY failed
sd 6:0:0:1: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
sd 6:0:0:1: [sdc] Sense not available.
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
sd 6:0:0:1: [sdc] Write Protect is off
sd 6:0:0:1: [sdc] Mode Sense: 00 00 00 00
sd 6:0:0:1: [sdc] Assuming drive cache: write through
sd 6:0:0:1: [sdc] Attached SCSI removable disk
sd 6:0:0:1: Attached scsi generic sg2 type 0
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
sd 6:0:0:0: [sdb] READ CAPACITY failed
sd 6:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
sd 6:0:0:0: [sdb] Sense not available.
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: *** thread awakened.
usb-storage: -- exiting
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: queuecommand called
usb-storage: Fail command during disconnect
usb-storage: device scan complete
usb-storage: -- usb_stor_release_resources
usb-storage: -- sending exit command to thread
scsi 6:0:0:0: [sdb] READ CAPACITY failed
scsi 6:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
scsi 6:0:0:0: [sdb] Sense not available.
scsi 6:0:0:0: rejecting I/O to dead device
scsi 6:0:0:0: [sdb] Write Protect is off
scsi 6:0:0:0: [sdb] Mode Sense: 00 00 00 00
scsi 6:0:0:0: [sdb] Assuming drive cache: write through
scsi 6:0:0:0: rejecting I/O to dead device
usb-storage: -- dissociate_dev
usb 5-1:1.0: uevent
usb 5-1: uevent
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub

-- 
Jens Axboe

