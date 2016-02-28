From: "Thomas Schmitt" <scdbackup@gmx.net>
Subject: sr: Failures to read TAO CD track ends
Date: Sun, 28 Feb 2016 14:41:59 +0100
Message-ID: <6531578277915568387@scdbackup.webframe.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61910 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436AbcB1NmC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Feb 2016 08:42:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kzak@redhat.com

Hi,

to solve the long standing problems when reading the end of TAO CD
data tracks, i propose to perform a test READ(10) of the last 2 blocks
on any data CD, before believing in the readable size as deduced from
the reply of READ CAPACITY.

Please instruct me if i have to re-submit this issue somewhere else,
or here with a particular [tag] or other subject attributes.

--------------------------------------------------------------------
Motivation:

I am the developer of libburn.

While exploring the reason why archlinux-2016.02.01-dual.iso does
not boot completely from some CDs in some drives, i had to learn that
the old TAO CD "read-ahead" bug is not completely gone.
I thought so, when i tested my freshly installed Debian 8 kernel 3.16
last year. But i was just lucky with the CD drive i used.

The reason for the Archlinux problem is that blkid meanwhile wants to
read from the end of a CD medium. Its idea of an end stems from
ioctl(BLKGETSIZE) which seems (empirically) to depend on the reply
of SCSI command READ CAPACITY.
(I Cc Karel Zak, whom i have contacted about blkid.)

On many CD drives this young blkid produces no output, thus no link
emerges in /dev/disk/by-label pointing to the device with the ISO,
and thus, after a 30 seconds timeout, the booting Archlinux shows a
rescue prompt.
The booted kernel is version 4.3.3.

There is no problem if the CD was burned by write type SAO.

My above proposal gives hope to fix the TAO problems.

-------------------------------------------------------------------------
Specs:

CD recording is usually done by write types Session-At-Once (SAO) or
Track-At-Once (TAO).
See MMC-5, 7.5 "Write Parameters mode page (Page Code 05h)",
7.5.4.9 "Write Type".

A TAO CD track consists of a single packet which ends by 2 run-out blocks.
See MMC-5, 4.2.3.11 "Recording", Figure 23 "Packet Format".
The run-out blocks are not readable by data read commands like READ(10).
I assume READ CD can read them, but never tried.

-------------------------------------------------------------------------
Why to care for TAO at all:

TAO is default of program wodim, at least of older versions of cdrecord,
and of Brasero when it uses libburn. So TAO CDs are likely to get created
even if SAO would work too.

TAO can burn a stream of which the final size is not predicted. E.g. a
single-pass compressed backup stream. SAO cannot.
TAO is the only write type which can be added to appendable CDs.

-------------------------------------------------------------------------
Experiments:

All my 7 DVD drives can read all data blocks up to the run-out blocks by
READ(10) via ioctl(SG_IO). Of course, the READ(10) commands must not
include the run-out blocks in their Transfer Length request.

5 of 7 drives announce by READ CAPACITY that the last of these
run-out blocks is the last readable block.
This is wrong, of course.

4 of them report by READ TRACK INFORMATION a logical track size which
is 1 block less than the alleged last readable block of READ CAPACITY.
This is the really readable size.
1 drive stubbornly reports the wrong size with any size inquiry command
i know.

Correctly all 7 drives report the start of Lead-out after the two run-out
blocks if i inquire them by READ TOC/PMA/ATIP response format 2 (Raw TOC).
(No promise is given that all blocks up to that address are data blocks.)

Only 2 of 7 can properly boot the Archlinux ISO from a TAO CD.
They return the correct last valid data block number on request of
READ CAPACITY.
Both are quite young. But my newest one of 2015 does lie again.

Manuf.    Model             Age   Conn.     Quality of lies
============================================================
TSSTcorp  DVD-ROM SH-D162C  2002  IDE       consistently wrong
TSSTcorp  CDDVDW SH-S223B   2009  SATA      CAPACITY wrong, TRACK true
HL-DT-ST  BDDVDRW GGC-H20L  2008  SATA      CAPACITY wrong, TRACK true
HL-DT-ST  DVDRAM GH24NSC0   2015  SATA      CAPACITY wrong, TRACK true
HL-DT-ST  BD-RE GGW-H20L    2007  SATA/USB  CAPACITY wrong, TRACK true
Optiarc   BD RW BD-5300S    2011  SATA/USB  consistently true
HL-DT-ST  BD-RE BH16NS40    2013  SATA/USB  consistently true

-------------------------------------------------------------------------
What i believe to see in the kernel:

In my local source of kernel 3.16 and in
  https://github.com/torvalds/linux/blob/master/drivers/scsi/sr.c
i read a theory which i can disprove by my experiments with READ(10)
via ioctl(SG_IO):

       /*
        * The SCSI specification allows for the value
        * returned by READ CAPACITY to be up to 75 2K
        * sectors past the last readable block.
        * Therefore, if we hit a medium error within the
        * last 75 2K sectors, we decrease the saved size
        * value.
        */

No. It is about exactly 2 blocks, exactly at the end of each TAO track.
(I dare everybody to show me the 75 sectors statement in MMC-1 to MMC-6.)

Nevertheless, there is a halfways effective workaround in sr.c which tries
to adjust the device size perception to the number of valid blocks after
a read attempt failed near the end of the track:

                switch (SCpnt->sense_buffer[2]) {
                case MEDIUM_ERROR:
                case VOLUME_OVERFLOW:
                case ILLEGAL_REQUEST:
                        if (!(SCpnt->sense_buffer[0] & 0x90))
                                break;
                        error_sector = (SCpnt->sense_buffer[3] << 24) |
                                (SCpnt->sense_buffer[4] << 16) |
                                (SCpnt->sense_buffer[5] << 8) |
                                SCpnt->sense_buffer[6];
                        ...
                        if (error_sector < get_capacity(cd->disk) &&
                            cd->capacity - error_sector < 4 * 75)
                                set_capacity(cd->disk, error_sector);

I do not find the promise for the "error_sector" information in SPC-3
or MMC-5. Is this an artefact added by the lower level drivers to
the Sense Data from the drive ?

The correction in sr.c seems (empirically) to work with TAO CD tracks of
which the number of blocks is divisible by 2. All valid blocks can be
read by read(2) and mmap(2).

Nevertheless ioctl(BLKGETSIZE) still returns the size as deduced from
READ CAPACITY.
So young blkid explicitly demands the two unreadble blocks and thus fails.

-------------------------------------------------------------------------
The riddle of odd block count:

If the block number is not divisible by 2, then reliably the last valid
block of 2048 bytes cannot be read via read(2) or mmap(2), but still by
READ(10) via ioctl(SG_IO).

The only exception can be seen with my 2 drives which report the
size correctly via READ CAPACITY. They indicate an odd number which
is properly interpreted by kernels 3.1.6, 4.3.0, and 4.3.3.

The other 5 indicate an odd number which is too large by 2.
All three tested kernels then cannot deliver the last valid block
of the CD TAO track.

My only theory for the difference in behavior between odd and even
block count is that the "error_sector" trick in sr.c does not work
properly for odd numbers.

-------------------------------------------------------------------------

Have a nice day :)

Thomas

