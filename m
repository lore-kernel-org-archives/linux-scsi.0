From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Mon, 19 Apr 2010 14:15:39 -0700
Message-ID: <20100419211539.GB4245@xanatos>
References: <20100416182026.GA10023@xanatos>
 <Pine.LNX.4.44L0.1004161517260.1923-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:65063 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751896Ab0DSVQL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2010 17:16:11 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004161517260.1923-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

Updated bug description below.

On Fri, Apr 16, 2010 at 03:25:42PM -0400, Alan Stern wrote:
> On Fri, 16 Apr 2010, Sarah Sharp wrote:
> 
> > In the meantime, can everyone confirm my summary of the behavior of the
> > Buffalo device (not the Genesys chip)?
> > 
> > 
> > 
> > 
> > There seems to be an issue with how the Buffalo USB3 hard drive handles
> > the SCSI ATA pass through commands.  We found this issue when the Linux
> > userspace program hdparm, using the Ubuntu Linux distribution.  The
> > device responds correctly to an IDENTIFY DEVICE via the ATA_12 tunnel,
> > but it stalls when it's sent an IDENTIFY DEVICE via the ATA_16 tunnel.
> 
> "Stalls" isn't the right word.  It responds with "Phase Error" in
> bCSWStatus.  Less precisely but more succinctly, it returns a Phase
> Error.
> 
> > The command before the ATA_16 IDENTIFY DEVICE was a SET FEATURES via the
> > ATA_16 tunnel, and it was responded to properly, so we think it should
> > support the ATA_16 commands.
> > 
> > This problem makes the device unusable under the Linux 2.6.31 and 2.6.32
> 
> Only when running USB 3.  The devices work okay with USB 2.
> 
> > kernels, as they don't support configured device reset after an endpoint
> > stall.  The device works on later kernels (2.6.33 and 2.6.34) with that
> > support.
> > 
> > 
> > Details
> > -------
> > 
> > The hdparm program issues the following commands, and gets the following
> > responses:
> > 
> > command contents: a1 08 2e 00 01 00 00 00 00 ec 00 00
> > Bulk Command S 0x43425355 T 0x2d L 512 F 128 Trg 0 LUN 0 CL 12
> > Bulk Status S 0x53425355 T 0x2d R 0 Stat 0x0
> > scsi cmd done, result=0x0
> >    (This is an IDENTIFY DEVICE via the ATA_12 tunnel)
> > 
> > command contents: 85 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
> > Bulk Command S 0x43425355 T 0x2e L 0 F 0 Trg 0 LUN 0 CL 16
> > Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
> 
> This "T 0x2f" line doesn't belong here (it appears below).  Copy & 
> Paste error?
> 
> > Bulk Status S 0x53425355 T 0x2e R 0 Stat 0x0
> > scsi cmd done, result=0x0
> >    (This is a SET FEATURES via the ATA_16 tunnel)
> > 
> > command contents: 85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
> > Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
> > Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
> 
> And this "Bulk Status" line doesn't belong here.  Again, it appears 
> below.
> 
> > Status code -32; transferred 0/512
> > clearing endpoint halt for pipe 0xc0008280
> > Bulk status result = 0
> > Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
> > -- transport indicates error, resetting
> >   (This is an IDENTIFY DEVICE via the ATA_16 tunnel)
> > 
> > The full log is here:
> > http://minilop.net/~sarah/buffalo-hd-ata-16-issue.log
> > 
> > The drive stalls on the last command, which is a valid ATA command.  Can
> 
> It returns an error on the last command.  (It also stalls, but that's
> okay -- stalling an endpoint during a command is normal and it should
> work fine with USB 3.)
> 
> > you confirm if your device supports the SCSI ATA pass through
> > specification?
> > 
> > http://www.t10.org/cgi-bin/ac.pl?t=f&f=sat2r09.pdf
> 
> That link doesn't work.  The standard is not freely available.
> 
> Alan Stern
> 

Updated description
-------------------

Summary:

The Buffalo USB3 hard drive fails to mount after being sent an ATA_16
IDENTIFY command.  It does not fail when the device is connected via a
USB 2.0 cable and the same command is sent.

Details:

There seems to be an issue with how the Buffalo USB3 hard drive handles
the SCSI ATA pass through commands.  We found this issue with the Linux
userspace program hdparm, using the Ubuntu Linux Karmic distribution.
The device responds correctly to an IDENTIFY DEVICE via the ATA_12
tunnel, but it responds with a Phase Error when it's sent an IDENTIFY
DEVICE via the ATA_16 tunnel, and then stalls.

The hdparm program thinks the Phase Error is an invalid response:

sudo hdparm --verbose /dev/sdb

/dev/sdb:
outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
SG_IO: ATA_16 status=0x0, host_status=0x7, driver_status=0x0
SG_IO: bad response (not CHECK_CONDITION)
outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 a1 00
SG_IO: ATA_16 status=0x0, host_status=0x7, driver_status=0x0
SG_IO: bad response (not CHECK_CONDITION)
 HDIO_DRIVE_CMD(identify) failed: Invalid exchange
 readonly      =  0 (off)
 readahead     = 256 (on)
 geometry      = 36365/64/32, sectors = 0, start = 0

Stalling on the ATA_16 IDENTIFY device is fine, but the invalid response
is not.

The hard drive does not seem to work after this command is sent, and
cannot be mounted.  If we inhibit udev from running hdparm (by stopping
the udev daemon) then the drive can be mounted successfully.

If the drive is plugged in via a USB 2.0 cable, then the drive works
correctly, even though it gets issued the same commands.

The command before the ATA_16 IDENTIFY DEVICE was a SET FEATURES via the
ATA_16 tunnel, and it was responded to properly, so we think it should
support the ATA_16 commands.

The full kernel log is here:
http://minilop.net/~sarah/buffalo-hd-ata-16-issue.log

The ATA_12 IDENTIFY command starts at line 8816.  (It says the command
is a BLANK command, but it's incorrectly identified that command.)

Sarah Sharp
