From: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Subject: How to fix serial ATA write cache? (was RE: Formatting scsi ioctl
	 command (was RE: Help - looking for a Linux SCSI testing utility))
Date: Sun, 6 Jun 2004 20:16:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1F6D1D1660975A4887628A011443A1BC0305E3F7@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-nj2gw-2.online-age.net ([216.35.73.164]:57746 "EHLO
	ext-nj2gw-2.online-age.net") by vger.kernel.org with ESMTP
	id S264247AbUFGBQw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jun 2004 21:16:52 -0400
Received: from int-nj2gw-2.online-age.net (int-nj2gw-2 [3.159.236.66])
	by ext-nj2gw-2.online-age.net (8.12.9/8.12.9/990426-RLH) with ESMTP id i571Gowj006458
	for <linux-scsi@vger.kernel.org>; Sun, 6 Jun 2004 21:16:50 -0400 (EDT)
Received: from uswaumsxb1medge.med.ge.com (localhost [127.0.0.1])
	by int-nj2gw-2.online-age.net (8.12.9/8.12.8/990426-RLH) with ESMTP id i571Gmhf005312
	for <linux-scsi@vger.kernel.org>; Sun, 6 Jun 2004 21:16:50 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have discovered what the problem is with setting the write cache on a
Serial ATA drive.  It is apparent to me now that my sending ATA commands to
the ioctl was completely wrong.  I will have to send real scsi commands.

The bad news is that I finally dug down deep enough to find out that the
necessary code is not even implemented in libata-scsi.  The SCSI write cache
disable would need to be sent using a MODE SELECT which doesn't look like
it's implemented to me.

I am going to attempt to implement the write cache part of it.  I hope
someone can lend advice if I get in too far over my head ;-)

But it seems to me that the way the MODE SENSE is implemented isn't too good
for this either.  It seems that you would want the mode sense to be updated
dynamically when it happens instead of using data from when the driver was
initialized??  So it seems to me that both the MODE SELECT and MODE SENSE
should be implemented as translated commands instead of simulated commands?

Also could anyone explain the sense bytes in the ata_msense_caching routine?
They are:

 u8 page[7] = { 0xf, 0, 0x10, 0, 0x8, 0xa, 0 };

in that routine.  But I can't figure out what the first 4 bytes are for.  In
the section 9.3.3.1 Caching Page it says that the return values start with
the 0x8, 0xa, { WCE, MF, RCD bits }, and so on and that it is 11 bytes long
instead of 7.  I deleted the first four bytes and added 7 afterward and then
the scsiinfo program could at least read them.  But then I don't know, it's
so old maybe it is wrong???

Any advice would be most appreciated.

Thanks
  -Scott


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Edwards, Scott
(MED, Kelly IT Resouces)
Sent: Thursday, June 03, 2004 4:23 PM
To: 'Matthew Dharm'
Cc: linux-scsi@vger.kernel.org
Subject: Formatting scsi ioctl command (was RE: Help - looking for a
Linux SCSI testing utility)



I am still having trouble getting this command down to the drive.  So I was
wondering two things:

1) Can anybody tell me how the scsi ioctl command needs to be formatted?  

I have tried many combinations and none of them seem to work.  The command
is EF and the subcommand is 82.  Assuming this data structure:

struct sdata {
   unsigned int inlen;
   unsigned int outlen;
   unsigned char cmd[16];
}

how would I put in the command and sub-command?:

struct sdata x = { 0, 0, { 0xEF, 0x00, 0x82, 0x00 } };
struct sdata x = { 0, 0, { 0xEF, 0x82, 0x00, 0x00 } };

I have tried several other variations.  I even tried changing the cmdlen in
drivers/block/scsi_ioctl.c to 2 or 4 if the opcode is 0xEF, just in case it
didn't like getting the 10 bytes from the scsi_command_size table.

2) Is there anyway to see what is actually being sent to the drive?  I have
chased it down through scsi/sd.c, block/scsi_ioctl.c, block/ll_rw_blk.c, and
block.elevator.c.  But after it gets put in the request queue I don't know
how it gets out of the request queue and if there is any way to view what
the command looks like.

Thanks,
  -Scott



-----Original Message-----
From: Matthew Dharm [mailto:mdharm-scsi@one-eyed-alien.net]
Sent: Wednesday, May 26, 2004 3:11 PM
To: Edwards, Scott (MED, Kelly IT Resouces)
Cc: linux-scsi@vger.kernel.org
Subject: Re: Help - looking for a Linux SCSI testing utility


On Wed, May 26, 2004 at 03:24:49PM -0500, Edwards, Scott (MED, Kelly IT
Resouces) wrote:
> 
> I know this is slightly off topic for this list, but I have been
> fighting with this for about a month now and I feel like I'm getting
> nowhere.  I tried the plscsi and scu utilities.  One of them I couldn't
> make heads or tails of.  The other one would read the "inquiry" command
> ok, but I couldn't figure out how to make it give me the output of the
> "IDENTIFY" command (0xEC).  This is what I really need to read.
> 
> I have written (mostly copied from other stuff) a little program to just
> turn off the write cache.  (I have included the source below.)  But
> without being able to read the results of the identify I can't tell if
> it actually works or not.  I have tried writing a program myself that
> just sends the (0xEC) command, but all I get back is 70 00 05 00 00 00
> 00 06 00 00 00 00 20 00 00 00 which I'm guessing are the sense bytes?
> (Excuse my ignorance the last time I messed with this stuff it was
> called SASI instead of SCSI.)

Those do look like sense bytes.  I decode them to mean:
	Illegal Request: invalid command operation code

So it sounds to me like the device got your command, but didn't understand
it.

Matt

-- 
Matthew Dharm                              Home:
mdharm-usb@one-eyed-alien.net 
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
