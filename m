From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Tue, 20 Apr 2010 10:37:34 -0700
Message-ID: <20100420173734.GB5518@xanatos>
References: <20100419211539.GB4245@xanatos>
 <Pine.LNX.4.44L0.1004201045180.1837-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004201045180.1837-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dinh.Nguyen-KZfg59tc24xl57MIdRCFDg@public.gmane.org, Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 20, 2010 at 11:39:58AM -0400, Alan Stern wrote:
> On Mon, 19 Apr 2010, Sarah Sharp wrote:
> 
> > Updated description
> > -------------------
> > 
> > Summary:
> > 
> > The Buffalo USB3 hard drive fails to mount after being sent an ATA_16
> > IDENTIFY command.  It does not fail when the device is connected via a
> > USB 2.0 cable and the same command is sent.
> 
> I don't like this summary.

I'm sorry; bear with me as this thread is long and I have little SCSI
experience.

> The failure to mount is caused by a defect
> in the earlier versions of xhci-hcd (no support for USB port reset),
> not by a bug in the drive.  I don't recall seeing a test using the old
> version of hdparm and an updated xhci-hcd, but presumably such a 
> combination would work okay.

Ok, I was confused there.  The buffalo drive has worked fine for me, but
I've been testing with 2.6.33 and beyond.  I was confused about Jonas'
statement that with the latest hdparm "The good news: It doesn't crash
the chip anymore. The drive is still mounted fine after executing
hdparm."  By that I suppose he means the drive doesn't stall on the ATA
12 IDENTIFY DEVICE command.

> The real problem with the Buffalo drive is that it responds with a
> phase error when it receives an ATA_16 IDENTIFY DEVICE command with the
> Sector Count field set to 0.

Ok, I'll revise that.  I wish I had a convenient wiki to stick this
description up, so that everyone could edit it.

> 
> > Details:
> > 
> > There seems to be an issue with how the Buffalo USB3 hard drive handles
> > the SCSI ATA pass through commands.  We found this issue with the Linux
> > userspace program hdparm, using the Ubuntu Linux Karmic distribution.
> > The device responds correctly to an IDENTIFY DEVICE via the ATA_12
> > tunnel, but it responds with a Phase Error when it's sent an IDENTIFY
> > DEVICE via the ATA_16 tunnel, and then stalls.
> 
> You should not say anything about the drive stalling.  For one thing,
> it's misleading: The drive doesn't stall but rather it sends a STALL
> token to indicate that the bulk-IN endpoint is halted.  For another,
> the STALL is sent _before_ the phase error is reported, not after.  
> Lastly, there's absolutely nothing wrong with halting the endpoint like
> this; in fact, the Bulk-Only Transport specification requires it under
> these circumstances.

Yes, I understand.  I had only wanted to mention the stall in case they
looked at the full kernel log file.

> > The hdparm program thinks the Phase Error is an invalid response:
> > 
> > sudo hdparm --verbose /dev/sdb
> > 
> > /dev/sdb:
> > outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
> > SG_IO: ATA_16 status=0x0, host_status=0x7, driver_status=0x0
> > SG_IO: bad response (not CHECK_CONDITION)
> > outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 a1 00
> > SG_IO: ATA_16 status=0x0, host_status=0x7, driver_status=0x0
> > SG_IO: bad response (not CHECK_CONDITION)
> >  HDIO_DRIVE_CMD(identify) failed: Invalid exchange
> >  readonly      =  0 (off)
> >  readahead     = 256 (on)
> >  geometry      = 36365/64/32, sectors = 0, start = 0
> 
> Why include two separate commands here?  I thought you were interested
> only in the response to the ATA_16 IDENTIFY DEVICE (the first outgoing
> cdb above).
> 
> > Stalling on the ATA_16 IDENTIFY device is fine, but the invalid response
> > is not.
> 
> Again, don't mention stalling.  Notice that the information from hdparm
> does not show the exact nature of the problem (i.e., that the drive
> responded with a phase error), only that a problem occurred.  This 
> makes it less useful than you might like.

Ok, so I should probably just include this snippet from the original
kernel log?

Mar 24 18:51:29 js-workstation kernel: [  126.731371] usb-storage: Command (unknown command) (16 bytes)
Mar 24 18:51:29 js-workstation kernel: [  126.731372] usb-storage:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
Mar 24 18:51:29 js-workstation kernel: [  126.731378] usb-storage: Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
Mar 24 18:51:29 js-workstation kernel: [  126.731379] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Mar 24 18:51:29 js-workstation kernel: [  126.731543] usb-storage: Status code 0; transferred 31/31
Mar 24 18:51:29 js-workstation kernel: [  126.731544] usb-storage: -- transfer complete
Mar 24 18:51:29 js-workstation kernel: [  126.731546] usb-storage: Bulk command transfer result=0
Mar 24 18:51:29 js-workstation kernel: [  126.731547] usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Mar 24 18:51:29 js-workstation kernel: [  126.731719] usb-storage: Status code -32; transferred 0/512
Mar 24 18:51:29 js-workstation kernel: [  126.731723] usb-storage: clearing endpoint halt for pipe 0xc0008280
Mar 24 18:51:29 js-workstation kernel: [  126.731727] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Mar 24 18:51:29 js-workstation kernel: [  126.732152] usb-storage: usb_stor_clear_halt: result = 0
Mar 24 18:51:29 js-workstation kernel: [  126.732153] usb-storage: Bulk data transfer result 0x2
Mar 24 18:51:29 js-workstation kernel: [  126.732154] usb-storage: Attempting to get CSW...
Mar 24 18:51:29 js-workstation kernel: [  126.732155] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Mar 24 18:51:29 js-workstation kernel: [  126.732430] usb-storage: Status code 0; transferred 13/13
Mar 24 18:51:29 js-workstation kernel: [  126.732431] usb-storage: -- transfer complete
Mar 24 18:51:29 js-workstation kernel: [  126.732432] usb-storage: Bulk status result = 0
Mar 24 18:51:29 js-workstation kernel: [  126.732434] usb-storage: Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
Mar 24 18:51:29 js-workstation kernel: [  126.732435] usb-storage: -- transport indicates error, resetting

The important bit being that the Status in the CSW is 0x2, which
drivers/usb/storage/transport.h defines as a US_BULK_STAT_PHASE.

> 
> > The hard drive does not seem to work after this command is sent, and
> > cannot be mounted.  If we inhibit udev from running hdparm (by stopping
> > the udev daemon) then the drive can be mounted successfully.
> 
> First, this is true only if the drive is attached using USB 3.0.  
> Second, after this command the drive still works fine -- xhci-hcd is
> what doesn't work.
> 
> > If the drive is plugged in via a USB 2.0 cable, then the drive works
> > correctly, even though it gets issued the same commands.
> 
> Right.  That's because the larger problem is in xhci-hcd, not in the
> drive.
> 
> > The command before the ATA_16 IDENTIFY DEVICE was a SET FEATURES via the
> > ATA_16 tunnel, and it was responded to properly, so we think it should
> > support the ATA_16 commands.
> 
> This is wrong.  The first command shown above is ATA_16 IDENTIFY 
> DEVICE.  The second command is ATA_16 IDENTIFY PACKET DEVICE.
> 
> To summarize: 0xef is SET FEATURES, 0xec is IDENTIFY DEVICE, and 0xa1 
> is IDENTIFY PACKET DEVICE.  The command byte is the second-to-last in 
> each cdb.

Ok, thanks for that explanation.

> 
> > The full kernel log is here:
> > http://minilop.net/~sarah/buffalo-hd-ata-16-issue.log
> 
> I just tried to view that page and got a "403 Forbidden" error.

I'm not sure what's up with that.  The file has the same permissions as
the bluetooth log file, but I can download the bluetooth log file and
not the buffalo log file:

-rw-r--r-- 1 sarah sarah 10980197 2009-06-15 15:53 bluetooth-suspend-external-4.log
-rw-r--r-- 1 sarah sarah  1419858 2010-04-16 11:13 buffalo-hd-ata-16-issue.log

I'll ask my "server admin" (i.e. husband) who is currently asleep about
it.  In the meantime, I've uploaded a tar and a zip file of the log,
which I've verified you can download:

http://minilop.net/~sarah/buffalo-hd-ata-16-issue.tar.gz
http://minilop.net/~sarah/buffalo-hd-ata-16-issue.zip

> Does 
> it contain the kernel log for the hdparm test shown above, or is it a 
> log for a different test?  My guess is that it's a different test -- 
> you should mention that fact and describe the commands sent in the 
> other test.

It's the original kernel log Jonas sent me.  This was the log from when
udev was invoking hdparm automatically.  Jonas didn't send a kernel log
from his tests with hdparm alone.  But yes, I should mention it's a
different log.

> > The ATA_12 IDENTIFY command
> 
> You mean IDENTIFY DEVICE.  There is no ATA IDENTIFY command.
> 
> >  starts at line 8816.  (It says the command
> > is a BLANK command, but it's incorrectly identified that command.)
> 
> Alan Stern
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
