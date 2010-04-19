From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Mon, 19 Apr 2010 17:04:23 +0200
Message-ID: <4BCC70F7.9000001@gmail.com>
References: <4BBF6B2F.9060902@gmail.com> <Pine.LNX.4.44L0.1004091504500.1852-100000@iolanthe.rowland.org> <20100409215439.GA4779@xanatos> <4BC2D049.1090606@gmail.com> <20100416182026.GA10023@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64954 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0DSPEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2010 11:04:24 -0400
In-Reply-To: <20100416182026.GA10023@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On 04/16/2010 08:20 PM, Sarah Sharp wrote:
> I'll see if I can find a contact for this.  I need a couple more details
> so they can reproduce this.  Jonas, did you ever test the Buffalo drive with
> Mark Lord's fix to set the sector count to "1"?  Which version of hdparm
> were you using?  Is that version just in Lucid, or is it in Karmic too?

Yes, I did try it with Mark's latest version (9.29b) which uses a sector 
count of "1" (version 9.29) and, in addition, uses ATA_12 (instead of 
ATA_16) for IDENTIFY (9.29b).  The issue exists in Karmic and Lucid.

It seems the report I sent back to Mark, once I tested 9.29b, didn't go 
to all of you but just Mark.  Here it is:

--------------------------------------------------------
The good news: It doesn't crash the chip anymore. The drive is still 
mounted fine after executing hdparm.

The bad news: From the hdparm output it seems like the chip still 
doesn't play nice.

/dev/sdb:
outgoing cdb:  a1 08 2e 00 01 00 00 00 40 ec 00 00 00 00 00 00
data:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: ATA_12 status=0x0, host_status=0x0, driver_status=0x0
SG_IO: bad response (not CHECK_CONDITION)
Trying legacy HDIO_DRIVE_CMD
outgoing cdb:  a1 08 2e 00 01 00 00 00 40 a1 00 00 00 00 00 00
data:  40 00 ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00
SG_IO: ATA_12 status=0x2, host_status=0x0, driver_status=0x8
SG_IO: sb[]:  72 0b 00 00 00 00 00 0e 09 0c 00 04 00 01 00 00 00 00 00 
00 40 51 00 00 00 00 00 00 00 00 00 00
SG_IO: desc[]:  09 0c 00 04 00 01 00 00 00 00 00 00
       ATA_12 stat=51 err=04 nsect=01 lbal=00 lbam=00 lbah=00 dev=40
I/O error, ata_op=0xa1 ata_status=0x51 ata_error=0x04
  HDIO_DRIVE_CMD(identify) failed: Input/output error
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 121601/255/63, sectors = 1953525168, start = 0
--------------------------------------------------------

I didn't get a reply from Mark on this yet.  Alan, does this output mean 
something to you?

-Jonas
