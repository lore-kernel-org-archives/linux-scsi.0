From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Mon, 19 Apr 2010 13:45:37 -0700
Message-ID: <20100419204537.GA4245@xanatos>
References: <4BBF6B2F.9060902@gmail.com>
 <Pine.LNX.4.44L0.1004091504500.1852-100000@iolanthe.rowland.org>
 <20100409215439.GA4779@xanatos>
 <4BC2D049.1090606@gmail.com>
 <20100416182026.GA10023@xanatos>
 <4BCC70F7.9000001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BCC70F7.9000001@gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2010 at 05:04:23PM +0200, Jonas Schwertfeger wrote:
> On 04/16/2010 08:20 PM, Sarah Sharp wrote:
> >I'll see if I can find a contact for this.  I need a couple more details
> >so they can reproduce this.  Jonas, did you ever test the Buffalo drive with
> >Mark Lord's fix to set the sector count to "1"?  Which version of hdparm
> >were you using?  Is that version just in Lucid, or is it in Karmic too?
> 
> Yes, I did try it with Mark's latest version (9.29b) which uses a
> sector count of "1" (version 9.29) and, in addition, uses ATA_12
> (instead of ATA_16) for IDENTIFY (9.29b).  The issue exists in
> Karmic and Lucid.

But there were two separate issues for two separate USB3 hard drives.
Didn't your Buffalo drive need the ATA_12 IDENTIFY with the sector count
set to zero?  And hard drives with the Genesys drive needed the sector
count set to 1?

Your original log showed something issuing an ATA_12 IDENTIFY command:

Mar 24 18:51:29 js-workstation kernel: [  126.720576] usb-storage: Command BLANK (12 bytes)
Mar 24 18:51:29 js-workstation kernel: [  126.720577] usb-storage:  a1 08 2e 00 01 00 00 00 00 ec 00 00
Mar 24 18:51:29 js-workstation kernel: [  126.720584] usb-storage: Bulk Command S 0x43425355 T 0x2d L 512 F 128 Trg 0 LUN 0 CL 12

(It says command BLANK but Douglas Gilbert said it was actually an ATA_12 command).

But the original output you posted from hdparm doesn't list that ATA_12
command:

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


Maybe it was issued by another userspace program?  The kernel log
doesn't show what the device response was, but it could be that the
device actually checks the sector count of the command.  Can you change
the hdparam code to issue the ATA_12 command, but leave the sector count
as zero?

Sarah Sharp

> It seems the report I sent back to Mark, once I tested 9.29b, didn't
> go to all of you but just Mark.  Here it is:
> 
> --------------------------------------------------------
> The good news: It doesn't crash the chip anymore. The drive is still
> mounted fine after executing hdparm.
> 
> The bad news: From the hdparm output it seems like the chip still
> doesn't play nice.
> 
> /dev/sdb:
> outgoing cdb:  a1 08 2e 00 01 00 00 00 40 ec 00 00 00 00 00 00
> data:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> SG_IO: ATA_12 status=0x0, host_status=0x0, driver_status=0x0
> SG_IO: bad response (not CHECK_CONDITION)
> Trying legacy HDIO_DRIVE_CMD
> outgoing cdb:  a1 08 2e 00 01 00 00 00 40 a1 00 00 00 00 00 00
> data:  40 00 ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00
> SG_IO: ATA_12 status=0x2, host_status=0x0, driver_status=0x8
> SG_IO: sb[]:  72 0b 00 00 00 00 00 0e 09 0c 00 04 00 01 00 00 00 00
> 00 00 40 51 00 00 00 00 00 00 00 00 00 00
> SG_IO: desc[]:  09 0c 00 04 00 01 00 00 00 00 00 00
>       ATA_12 stat=51 err=04 nsect=01 lbal=00 lbam=00 lbah=00 dev=40
> I/O error, ata_op=0xa1 ata_status=0x51 ata_error=0x04
>  HDIO_DRIVE_CMD(identify) failed: Input/output error
>  readonly      =  0 (off)
>  readahead     = 256 (on)
>  geometry      = 121601/255/63, sectors = 1953525168, start = 0
> --------------------------------------------------------
> 
> I didn't get a reply from Mark on this yet.  Alan, does this output
> mean something to you?
> 
> -Jonas
