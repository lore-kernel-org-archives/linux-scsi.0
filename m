From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [PATCH] st: implement sysfs based tape statistics v2
Date: Mon, 9 Feb 2015 06:00:38 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BF3F323@G9W0766.americas.hpqcorp.net>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net>
 (shane.seymour@hp.com) <87r3u0mivl.fsf@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:38138 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbbBIGBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2015 01:01:03 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Kai - see last 3 paragraphs for question about if something is a bug or not.

BTW I had a look - I couldn't quickly find out if there was a way to tell if the medium has changed in a tape drive (there could be something device specific). At the device level there's a record of I/O errors:

[root@tapedrive device]# pwd
/sys/class/scsi_tape/st0/device
[root@tapedrive device]# cat ioerr_cnt
0x5

That doesn't distinguish between read or write or any other kind of error though - it doesn't even really have to mean an error since reading with a block size too small also increments the error count:

[root@tapedrive tape-stats]# ./tape_exercise write /dev/st0 /dev/urandom 1000000
About to write from /dev/urandom to /dev/st0, max size = 1000000, blksize = 4096
Write complete on /dev/st0 after 1003520 bytes
./tape_[root@tapedrive tape-stats]# ./tape_exercise read /dev/st0
About to read from /dev/st0 blksize = 256
Failed to read from /dev/st0 using current blksize, will try using a bigger blksize
About to read from /dev/st0 blksize = 512
Failed to read from /dev/st0 using current blksize, will try using a bigger blksize
About to read from /dev/st0 blksize = 1024
Failed to read from /dev/st0 using current blksize, will try using a bigger blksize
About to read from /dev/st0 blksize = 2048
Failed to read from /dev/st0 using current blksize, will try using a bigger blksize
About to read from /dev/st0 blksize = 4096
Reading complete for /dev/st0, 987136 bytes read

[root@tapedrive tape-stats]# cd /sys/class/scsi_tape/st0/device
[root@tapedrive device]# cat ioerr_cnt
0xa

It would seem that ioerr_cnt is probably a count of SCSI check conditions encountered?

Unfortunately for the MTIOCGET ioctl the value of mt_resid is the partition number of the tape not what I would have expected it to be - the residual left after the last read or write that returned an error (and 0 if the last read/write didn't return an error).

Kai - is that a bug? Shouldn't mt_resid be the residual from the last failed read or write indicating how much data didn't make it to the device and 0 on a successful read or write? I've used mt_resid from MTIOCGET on HP-UX previously when issuing reads and repositioning and retrying tape reads when starting with too low a block size to try and automatically determine the block size in use (it's never a good idea to under or overread tape blocks because it always results in check conditions and in the st driver under reading the block size always creates messages in dmesg).

If you don't have time to look at it I may look at if it's possible to provide the correct mt_resid for MTIOCGET - assuming that a long time if misuse prevents us from correcting it. If there's no way to export a partition number for the devices that support it I can add a new sysfs file (call it partition) to export it that way and see if I can get the correct value into mt_resid.

-----Original Message-----
From: Seymour, Shane M 
Sent: Monday, February 09, 2015 10:19 AM
To: 'Dale R. Worley'
Cc: linux-scsi@vger.kernel.org
Subject: RE: [PATCH] st: implement sysfs based tape statistics v2

Both of those things would have to be futures and require discussion - the very original version cleared stats on a device open but I got asked to keep it the stats cumulative so they would be more similar to disk stats. I'm not sure about the bad reads idea I'd have to look and see if some other layer provided device error information. I've got some changes to make and don't want to change it into a moving target that needs more discussion at this point.

-----Original Message-----
From: Dale R. Worley [mailto:worley@alum.mit.edu] 
Sent: Monday, February 09, 2015 4:08 AM
To: Seymour, Shane M
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2

One feature of tape statistics is that they're as much about the *tape* as they are about the *drive*, which is uncommon for block devices.  It might be useful to have a set of counters which is cleared every time a new tape is inserted into the drive.  In particular, "bad reads since this tape was inserted" would be very useful for monitoring the quality of tapes.

Dale
