From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] USB storage timeout and oops
Date: Wed, 4 Jun 2003 10:17:00 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306041001030.780-100000@ida.rowland.org>
References: <20030603221419.GA2027@ventus.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3076 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263023AbTFDODa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2003 10:03:30 -0400
In-Reply-To: <20030603221419.GA2027@ventus.lan>
List-Id: linux-scsi@vger.kernel.org
To: Major A <andras@users.sourceforge.net>
Cc: linux-usb-devel <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

This is good.  And quite interesting.  It illustrates a problem with the 
current SCSI code as well as a problem with the USB drivers.

By the way, Andras, was the device plugged directly into your computer's
USB port or did you use an intermediate hub?

On Tue, 3 Jun 2003, Major A wrote:

> > Jun  3 23:06:27 ventus kernel: usb-storage: Status code 0; transferred 131072/131072

That's the last successful read.  Following this we have a sequence of
failed DATA-IN and control transfers, with one successful DATA-OUT.  Why
that should have worked when the others failed is beyond me.

<snip>

> > Jun  3 23:07:17 ventus kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
> > Jun  3 23:07:17 ventus kernel: usb-storage:  00 00 00 00 00 00
> > Jun  3 23:07:17 ventus kernel: usb-storage: Bulk command S 0x43425355 T 0x129 Trg 0 LUN 0 L 0 F 0 CL 6
> > Jun  3 23:07:17 ventus kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> > Jun  3 23:07:17 ventus kernel: usb-storage: Status code 0; transferred 31/31
> > Jun  3 23:07:17 ventus kernel: usb-storage: -- transfer complete
> > Jun  3 23:07:17 ventus kernel: usb-storage: Bulk command transfer result=0

That's the successful DATA-OUT.

<snip>

> > Jun  3 23:08:07 ventus kernel: usb-storage: usb_storage_bus_reset called
> > Jun  3 23:08:07 ventus kernel: hub 5-2:0: port 2 not reset yet, waiting 10ms
> > Jun  3 23:08:07 ventus kernel: usb-storage: usb_reset_device returns -19

ENODEV from a port reset?  Sounds like a problem with the root hub driver
or the controller itself.  Or else the device crashed _really_ hard.

> > Jun  3 23:08:07 ventus kernel: scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 0 lun 0
> > Jun  3 23:08:07 ventus kernel: SCSI disk error : <2 0 0 0> return code = 0x6050000
> > Jun  3 23:08:07 ventus kernel: end_request: I/O error, dev sda, sector 47975616

Here the SCSI layer gave up on the device and set it offline.  All the I/O
requests from this point will fail.

> > Jun  3 23:08:07 ventus kernel: usb-storage: queuecommand() called
> > Jun  3 23:08:07 ventus kernel: Buffer I/O error on device sda1, logical block 5996948
> > Jun  3 23:08:07 ventus kernel: usb-storage: *** thread awakened.
> > Jun  3 23:08:07 ventus kernel: usb-storage: Command WRITE_10 (10 bytes)

But oddly enough, even though the device is off-line the SCSI driver has
queued another WRITE command.  That shouldn't have happened, and of course
it fails.

> Anything after this is just reiserfs complaining. What I did, BTW, is
> to boot the computer, mount the external drive, during which reiserfs
> checks the transaction log (which in this case was non-empty, so it 
> definitely wrote data to the disk), then after a few directory
> listings I do an "md5sum *.png > md5sums" in one of the directories on
> the disk, and this pretty instantly causes the abovementioned
> timeout/oops/whatever.
>
> Hope this helps a bit. If you need more info, please let me know what
> I have to do in order to get it as I'm not really familiar with the
> debug options.

Alan Stern


