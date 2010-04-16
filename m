From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 16 Apr 2010 11:20:26 -0700
Message-ID: <20100416182026.GA10023@xanatos>
References: <4BBF6B2F.9060902@gmail.com>
 <Pine.LNX.4.44L0.1004091504500.1852-100000@iolanthe.rowland.org>
 <20100409215439.GA4779@xanatos>
 <4BC2D049.1090606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BC2D049.1090606@gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 12, 2010 at 09:48:25AM +0200, Jonas Schwertfeger wrote:
> On 04/09/2010 11:54 PM, Sarah Sharp wrote:
> >>Now that you mention it, we don't know what sort of chip you have.
> >>Only that the vendor ID is 0x0411 (MelCo., Inc.) and the product ID is
> >>0x0184.
> 
> Buffalo is part of the MelCo Inc. holding.
> 
> >I've just opened the case on my Buffalo hard drive, and the circuit just
> >says Buffalo.  There's an ARM chip and a winbond chip, but not much else
> >to identify it.  I'll ask around the USB-IF PIL lab to try and get a
> >company contact.
> 
> The ARM chip in the Buffalo USB3 drive is the USB3-SATA bridge
> MB86C30A by Fujitsu: http://www.fujitsu.com/downloads/EDG/binary/pdf/catalogs/a04000431e.pdf
> 
> My guess would be that any drive using this chip will choke on the
> identify command. Sarah, any chance you could get a contact at
> Fujitsu?

I'll see if I can find a contact for this.  I need a couple more details
so they can reproduce this.  Jonas, did you ever test the Buffalo drive with
Mark Lord's fix to set the sector count to "1"?  Which version of hdparm
were you using?  Is that version just in Lucid, or is it in Karmic too?

In the meantime, can everyone confirm my summary of the behavior of the
Buffalo device (not the Genesys chip)?




There seems to be an issue with how the Buffalo USB3 hard drive handles
the SCSI ATA pass through commands.  We found this issue when the Linux
userspace program hdparm, using the Ubuntu Linux distribution.  The
device responds correctly to an IDENTIFY DEVICE via the ATA_12 tunnel,
but it stalls when it's sent an IDENTIFY DEVICE via the ATA_16 tunnel.
The command before the ATA_16 IDENTIFY DEVICE was a SET FEATURES via the
ATA_16 tunnel, and it was responded to properly, so we think it should
support the ATA_16 commands.

This problem makes the device unusable under the Linux 2.6.31 and 2.6.32
kernels, as they don't support configured device reset after an endpoint
stall.  The device works on later kernels (2.6.33 and 2.6.34) with that
support.


Details
-------

The hdparm program issues the following commands, and gets the following
responses:

command contents: a1 08 2e 00 01 00 00 00 00 ec 00 00
Bulk Command S 0x43425355 T 0x2d L 512 F 128 Trg 0 LUN 0 CL 12
Bulk Status S 0x53425355 T 0x2d R 0 Stat 0x0
scsi cmd done, result=0x0
   (This is an IDENTIFY DEVICE via the ATA_12 tunnel)

command contents: 85 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
Bulk Command S 0x43425355 T 0x2e L 0 F 0 Trg 0 LUN 0 CL 16
Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
Bulk Status S 0x53425355 T 0x2e R 0 Stat 0x0
scsi cmd done, result=0x0
   (This is a SET FEATURES via the ATA_16 tunnel)

command contents: 85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
Status code -32; transferred 0/512
clearing endpoint halt for pipe 0xc0008280
Bulk status result = 0
Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
-- transport indicates error, resetting
  (This is an IDENTIFY DEVICE via the ATA_16 tunnel)

The full log is here:
http://minilop.net/~sarah/buffalo-hd-ata-16-issue.log

The drive stalls on the last command, which is a valid ATA command.  Can
you confirm if your device supports the SCSI ATA pass through
specification?

http://www.t10.org/cgi-bin/ac.pl?t=f&f=sat2r09.pdf

Sarah Sharp
