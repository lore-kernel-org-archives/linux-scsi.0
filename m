From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Tue, 20 Apr 2010 15:48:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004201533220.1837-100000@iolanthe.rowland.org>
References: <20100420173734.GB5518@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20100420173734.GB5518@xanatos>
Sender: linux-hotplug-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 20 Apr 2010, Sarah Sharp wrote:

> > The failure to mount is caused by a defect
> > in the earlier versions of xhci-hcd (no support for USB port reset),
> > not by a bug in the drive.  I don't recall seeing a test using the old
> > version of hdparm and an updated xhci-hcd, but presumably such a 
> > combination would work okay.
> 
> Ok, I was confused there.  The buffalo drive has worked fine for me, but
> I've been testing with 2.6.33 and beyond.  I was confused about Jonas'
> statement that with the latest hdparm "The good news: It doesn't crash
> the chip anymore. The drive is still mounted fine after executing
> hdparm."  By that I suppose he means the drive doesn't stall on the ATA
> 12 IDENTIFY DEVICE command.

He means that the drive doesn't report a phase error on the ATA_16
IDENTIFY DEVICE command, and consequently xhci-hcd doesn't have to try
(and fail) to reset the port.

> Ok, so I should probably just include this snippet from the original
> kernel log?
> 
> Mar 24 18:51:29 js-workstation kernel: [  126.731371] usb-storage: Command (unknown command) (16 bytes)
> Mar 24 18:51:29 js-workstation kernel: [  126.731372] usb-storage:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
> Mar 24 18:51:29 js-workstation kernel: [  126.731378] usb-storage: Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
> Mar 24 18:51:29 js-workstation kernel: [  126.731379] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> Mar 24 18:51:29 js-workstation kernel: [  126.731543] usb-storage: Status code 0; transferred 31/31
> Mar 24 18:51:29 js-workstation kernel: [  126.731544] usb-storage: -- transfer complete
> Mar 24 18:51:29 js-workstation kernel: [  126.731546] usb-storage: Bulk command transfer result=0
> Mar 24 18:51:29 js-workstation kernel: [  126.731547] usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
> Mar 24 18:51:29 js-workstation kernel: [  126.731719] usb-storage: Status code -32; transferred 0/512
> Mar 24 18:51:29 js-workstation kernel: [  126.731723] usb-storage: clearing endpoint halt for pipe 0xc0008280
> Mar 24 18:51:29 js-workstation kernel: [  126.731727] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
> Mar 24 18:51:29 js-workstation kernel: [  126.732152] usb-storage: usb_stor_clear_halt: result = 0
> Mar 24 18:51:29 js-workstation kernel: [  126.732153] usb-storage: Bulk data transfer result 0x2
> Mar 24 18:51:29 js-workstation kernel: [  126.732154] usb-storage: Attempting to get CSW...
> Mar 24 18:51:29 js-workstation kernel: [  126.732155] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> Mar 24 18:51:29 js-workstation kernel: [  126.732430] usb-storage: Status code 0; transferred 13/13
> Mar 24 18:51:29 js-workstation kernel: [  126.732431] usb-storage: -- transfer complete
> Mar 24 18:51:29 js-workstation kernel: [  126.732432] usb-storage: Bulk status result = 0
> Mar 24 18:51:29 js-workstation kernel: [  126.732434] usb-storage: Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
> Mar 24 18:51:29 js-workstation kernel: [  126.732435] usb-storage: -- transport indicates error, resetting

Yes, that would be best.  You might also mention that the drive does 
not return a phase error when it gets an ATA_16 IDENTIFY DEVICE command 
with the Sector Count field set to 1.

> The important bit being that the Status in the CSW is 0x2, which
> drivers/usb/storage/transport.h defines as a US_BULK_STAT_PHASE.

Correct.

> > > The full kernel log is here:
> > > http://minilop.net/~sarah/buffalo-hd-ata-16-issue.log
> > 
> > I just tried to view that page and got a "403 Forbidden" error.
> 
> I'm not sure what's up with that.  The file has the same permissions as
> the bluetooth log file, but I can download the bluetooth log file and
> not the buffalo log file:
> 
> -rw-r--r-- 1 sarah sarah 10980197 2009-06-15 15:53 bluetooth-suspend-external-4.log
> -rw-r--r-- 1 sarah sarah  1419858 2010-04-16 11:13 buffalo-hd-ata-16-issue.log
> 
> I'll ask my "server admin" (i.e. husband) who is currently asleep about
> it.  In the meantime, I've uploaded a tar and a zip file of the log,
> which I've verified you can download:
> 
> http://minilop.net/~sarah/buffalo-hd-ata-16-issue.tar.gz
> http://minilop.net/~sarah/buffalo-hd-ata-16-issue.zip

I was indeed able to download the zip file.  How helpful it will be to
the people at Buffalo is questionable, but at least they can read it if
they want to.

Alan Stern

