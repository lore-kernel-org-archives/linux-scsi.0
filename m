From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Patch to clear both bulk pipes
Date: Tue, 11 Jan 2005 16:08:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501111541370.639-100000@ida.rowland.org>
References: <20050111111019.7230bf4d@lembas.zaitcev.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:13060 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262823AbVAKVIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 16:08:25 -0500
In-Reply-To: <20050111111019.7230bf4d@lembas.zaitcev.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 11 Jan 2005, Pete Zaitcev wrote:

> On Tue, 11 Jan 2005 10:45:08 -0500 (EST), Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On the other hand, even if the pipes really are stalled usb-storage ought 
> > to be able to recover.  It will do a device reset, which involves 
> > clearing the halt on both bulk pipes.  So the patch shouldn't be needed.
> 
> It tries to recover. In the case of the IBM HS-20 with TEAC CD-224E, resets
> performed by SCSI do not succeed. I have a usb-storage debugging trace
> attached to this message.

In your trace the resets _do_ succeed.  The problem is something else, see 
below...  And BTW, there were no STALLs.  Clearing a halt isn't the right 
thing to do.  If it worked, it's probably just because of the added time 
delay.

> Also, I captured a few traces with usbmon which show that the usb-storage
> itself does absolutely nothing different in succeeding and failing case,
> including any timing. However, the inquiry data transfer is the first
> bulk transfer performed after the start of probing. No other transfers
> ever fail.

I'm not sure what you mean here.  Surely usb-storage doesn't issue a 
device reset in the succeeding case?  Anyway, apart from some 
internally-generated resets and REQUEST SENSE commands, usb-storage only 
does what the SCSI layer tells it to.  Frequently problems are actually 
caused by the SCSI drivers; that seems to be the case here.

> > Finally, Pete's patch only addresses the case of bulk-only devices.  What 
> > about devices that use one of the other transports?
> 
> They rarely exist these days in my life. I have no idea if they are
> affected. If users do not howl, I have no way to know.

I believe it.  :-)

>  <------ Starting processing CD-ROM here
> USB Mass Storage device found at 6
> usb-storage: USB Mass Storage device detected
> usb-storage: -- associate_dev
> usb-storage: Vendor: 0x05ab, Product: 0x0030, Revision: 0x0100
> usb-storage: Interface Subclass: 0x02, Protocol: 0x50
> usb-storage: Vendor: In-System Design,  Product: USB Storage Adapter
> usb-storage: Transport: Bulk
> usb-storage: Protocol: 8020i
> usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
> usb-storage: GetMaxLUN command result is 1, data is 0
> usb-storage: *** thread sleeping.
> scsi12 : SCSI emulation for USB Mass Storage devices
> 
> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command INQUIRY (6 bytes)
> usb-storage:  12 00 00 00 24 00
> usb-storage: Bulk Command S 0x43425355 T 0x8920 L 36 F 128 Trg 0 LUN 0 CL 12
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
> usb-storage: command_abort called
> usb-storage: usb_stor_stop_transport called
> usb-storage: -- cancelling URB
> usb-storage: Status code -104; transferred 0/36
> usb-storage: -- transfer cancelled
> usb-storage: Bulk data transfer result 0x4
> usb-storage: -- command was aborted

This looks like behavior I've seen on my CDRW drive.  It takes a long time 
to respond to a SCSI command when it's first plugged in.  So the INQUIRY 
times out and the device gets reset, then the SCSI error handler runs.

> usb-storage: usb_stor_Bulk_reset called
> usb-storage: usb_stor_control_msg: rq=ff rqtype=21 value=0000 index=00 len=0
> usb-storage: Soft reset: clearing bulk-in endpoint halt
> usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
> usb-storage: usb_stor_clear_halt: result = 0
> usb-storage: Soft reset: clearing bulk-out endpoint halt
> usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=01 len=0
> usb-storage: usb_stor_clear_halt: result = 0
> usb-storage: Soft reset done

The reset was successful.  Next the error handler issues a bunch of TEST 
UNIT READY commands.  I'll abbreviate the log:

> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage: Bulk Status S 0x53425355 T 0x8920 R 0 Stat 0x1
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x6, ASC: 0x29, ASCQ: 0x0
> usb-storage: Unit Attention: Power on, reset, or bus device reset occurred

That's understandable, since the device was just reset.

> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage: Bulk Status S 0x53425355 T 0x8920 R 0 Stat 0x1
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x2, ASC: 0x4, ASCQ: 0x1
> usb-storage: Not Ready: Logical unit is in process of becoming ready

Presumably this means the disc is spinning up.  The SCSI drivers don't 
seem to handle 0x02/0x04/0x01 very well.  For one thing, the error handler 
takes it as a sign that the device needs another reset:

> usb-storage: scsi cmd done, result=0x2
> usb-storage: *** thread sleeping.
> usb-storage: device_reset called
> usb-storage: usb_stor_Bulk_reset called
> usb-storage: usb_stor_control_msg: rq=ff rqtype=21 value=0000 index=00 len=0
> usb-storage: Soft reset: clearing bulk-in endpoint halt
> usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
> usb-storage: usb_stor_clear_halt: result = 0
> usb-storage: Soft reset: clearing bulk-out endpoint halt
> usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=01 len=0
> usb-storage: usb_stor_clear_halt: result = 0
> usb-storage: Soft reset done

Again the reset succeeded.

> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage: Bulk Status S 0x53425355 T 0x8920 R 0 Stat 0x1
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x6, ASC: 0x29, ASCQ: 0x0
> usb-storage: Unit Attention: Power on, reset, or bus device reset occurred

Again what you would expect.

> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage: Bulk Status S 0x53425355 T 0x8920 R 0 Stat 0x1
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x2, ASC: 0x4, ASCQ: 0x1
> usb-storage: Not Ready: Logical unit is in process of becoming ready

Same as before.  And once again, the error handler thinks something is 
wrong when in fact everything is all right.

> usb-storage: bus_reset called
> usb 1-1.3: reset full speed USB device using address 7
> usb-storage: usb_reset_device returns 0
> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage: Bulk Status S 0x53425355 T 0x8920 R 0 Stat 0x1
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x6, ASC: 0x29, ASCQ: 0x0
> usb-storage: Unit Attention: Power on, reset, or bus device reset occurred

Reporting the bus reset.

> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage: Bulk Status S 0x53425355 T 0x8920 R 0 Stat 0x1
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x2, ASC: 0x4, ASCQ: 0x1
> usb-storage: Not Ready: Logical unit is in process of becoming ready

Still, not a problem but the error handler takes it as a problem.

> usb-storage: scsi cmd done, result=0x2
> usb-storage: *** thread sleeping.
> scsi: Device offlined - not ready after error recovery: host 12 channel 0 id 0 lun 0

So usb-storage is doing everything right.  It's the SCSI error handler
that needs to be fixed.  However you might be able to work around the
problem for now by loading usb-storage with the delay_use module parameter
set to something larger than the default value of 5 seconds, something
large enough so that the drive can spin up fully before it is scanned.

Alan Stern

