From: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Subject: RE: Help - looking for a Linux SCSI testing utility
Date: Thu, 27 May 2004 14:41:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1F6D1D1660975A4887628A011443A1BC0305E3D0@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-nj2gw-2.online-age.net ([216.35.73.164]:25056 "EHLO
	ext-nj2gw-2.online-age.net") by vger.kernel.org with ESMTP
	id S265089AbUE0TlQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 15:41:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Erik Mouw' <erik@harddisk-recovery.com>
Cc: linux-scsi@vger.kernel.org


I'm starting to think I have the Midas Touch in reverse.  This looked like
it was going to be a winner, but when I run it, it says the Write Cache is
off.  I'm fairly certain this is not the case, as the manufacturer rep has
confirmed that the default is on, I've hooked it to a different OS and it
says it's on, and all of the journaling file systems (Reiser, XFS, JFS,
ext3) completely fail (which is how I got into this mess in the first
place).

Just for grins I tried to set it on with scsiinfo and it came back and said
the write mode page failed.  I am wondering if because the drive is a Serial
ATA drive and not a real SCSI drive if the mode page stuff works on it?  The
manual the mfr sent says to send an EF command with either a 02/82 to
enable/disable the write cache.  I didn't see anything in there about mode
pages.

Anyway, thanks, you at least gave me a glimmer of hope this morning.  I was
getting pretty discouraged by yesterday afternoon.  I'm going to dig around
in the scsiinfo source and see if I can figure something out.

Thanks again
  -Scott


-----Original Message-----
From: Erik Mouw [mailto:erik@harddisk-recovery.com]
Sent: Thursday, May 27, 2004 8:40 AM
To: Edwards, Scott (MED, Kelly IT Resouces)
Cc: linux-scsi@vger.kernel.org
Subject: Re: Help - looking for a Linux SCSI testing utility


On Wed, May 26, 2004 at 03:24:49PM -0500, Edwards, Scott (MED, Kelly IT
Resouces) wrote:
> I have written (mostly copied from other stuff) a little program to just
> turn off the write cache.  (I have included the source below.)  But
> without being able to read the results of the identify I can't tell if
> it actually works or not.  I have tried writing a program myself that
> just sends the (0xEC) command, but all I get back is 70 00 05 00 00 00
> 00 06 00 00 00 00 20 00 00 00 which I'm guessing are the sense bytes?
> (Excuse my ignorance the last time I messed with this stuff it was
> called SASI instead of SCSI.)

FWIW, scsiinfo can be used to turn off the write cache.

Human readable format:

  dagobert:~# scsiinfo -c /dev/sda 

  Data from Caching Page
  ----------------------
  Write Cache                        1
  Read Cache                         1
  Prefetch units                     0
  Demand Read Retention Priority     0
  Demand Write Retention Priority    0
  Disable Pre-fetch Transfer Length  65535
  Minimum Pre-fetch                  0
  Maximum Pre-fetch                  65535
  Maximum Pre-fetch Ceiling          65535


Compressed format:

  dagobert:~# scsiinfo -cX /dev/sda
  1 1 0 0 0 65535 0 65535 65535 

Now paste that line and change the first 1 into a 0:

  dagobert:~# scsiinfo -cXR /dev/sda 0 1 0 0 0 65535 0 65535 65535 

Read back the information in human readable format:

  dagobert:~# scsiinfo -c /dev/sda

  Data from Caching Page
  ----------------------
  Write Cache                        0
  Read Cache                         1
  Prefetch units                     0
  Demand Read Retention Priority     0
  Demand Write Retention Priority    0
  Disable Pre-fetch Transfer Length  65535
  Minimum Pre-fetch                  0
  Maximum Pre-fetch                  65535
  Maximum Pre-fetch Ceiling          65535

The scsiinfo utility can be found in the "scsitools" package (on Debian
systems, but I suppose it's called the same in other distros).


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
