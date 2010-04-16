From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 16 Apr 2010 15:25:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004161517260.1923-100000@iolanthe.rowland.org>
References: <20100416182026.GA10023@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20100416182026.GA10023@xanatos>
Sender: linux-hotplug-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 16 Apr 2010, Sarah Sharp wrote:

> In the meantime, can everyone confirm my summary of the behavior of the
> Buffalo device (not the Genesys chip)?
> 
> 
> 
> 
> There seems to be an issue with how the Buffalo USB3 hard drive handles
> the SCSI ATA pass through commands.  We found this issue when the Linux
> userspace program hdparm, using the Ubuntu Linux distribution.  The
> device responds correctly to an IDENTIFY DEVICE via the ATA_12 tunnel,
> but it stalls when it's sent an IDENTIFY DEVICE via the ATA_16 tunnel.

"Stalls" isn't the right word.  It responds with "Phase Error" in
bCSWStatus.  Less precisely but more succinctly, it returns a Phase
Error.

> The command before the ATA_16 IDENTIFY DEVICE was a SET FEATURES via the
> ATA_16 tunnel, and it was responded to properly, so we think it should
> support the ATA_16 commands.
> 
> This problem makes the device unusable under the Linux 2.6.31 and 2.6.32

Only when running USB 3.  The devices work okay with USB 2.

> kernels, as they don't support configured device reset after an endpoint
> stall.  The device works on later kernels (2.6.33 and 2.6.34) with that
> support.
> 
> 
> Details
> -------
> 
> The hdparm program issues the following commands, and gets the following
> responses:
> 
> command contents: a1 08 2e 00 01 00 00 00 00 ec 00 00
> Bulk Command S 0x43425355 T 0x2d L 512 F 128 Trg 0 LUN 0 CL 12
> Bulk Status S 0x53425355 T 0x2d R 0 Stat 0x0
> scsi cmd done, result=0x0
>    (This is an IDENTIFY DEVICE via the ATA_12 tunnel)
> 
> command contents: 85 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
> Bulk Command S 0x43425355 T 0x2e L 0 F 0 Trg 0 LUN 0 CL 16
> Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16

This "T 0x2f" line doesn't belong here (it appears below).  Copy & 
Paste error?

> Bulk Status S 0x53425355 T 0x2e R 0 Stat 0x0
> scsi cmd done, result=0x0
>    (This is a SET FEATURES via the ATA_16 tunnel)
> 
> command contents: 85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
> Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
> Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2

And this "Bulk Status" line doesn't belong here.  Again, it appears 
below.

> Status code -32; transferred 0/512
> clearing endpoint halt for pipe 0xc0008280
> Bulk status result = 0
> Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
> -- transport indicates error, resetting
>   (This is an IDENTIFY DEVICE via the ATA_16 tunnel)
> 
> The full log is here:
> http://minilop.net/~sarah/buffalo-hd-ata-16-issue.log
> 
> The drive stalls on the last command, which is a valid ATA command.  Can

It returns an error on the last command.  (It also stalls, but that's
okay -- stalling an endpoint during a command is normal and it should
work fine with USB 3.)

> you confirm if your device supports the SCSI ATA pass through
> specification?
> 
> http://www.t10.org/cgi-bin/ac.pl?t=f&f=sat2r09.pdf

That link doesn't work.  The standard is not freely available.

Alan Stern

