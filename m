From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Help - looking for a Linux SCSI testing utility
Date: Thu, 27 May 2004 16:40:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040527144020.GE10466@harddisk-recovery.com>
References: <1F6D1D1660975A4887628A011443A1BC0305E3CF@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from users.linvision.com ([62.58.92.114]:38603 "HELO bitwizard.nl")
	by vger.kernel.org with SMTP id S264584AbUE0OkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 10:40:21 -0400
Content-Disposition: inline
In-Reply-To: <1F6D1D1660975A4887628A011443A1BC0305E3CF@uswaumsx13medge.med.ge.com>
List-Id: linux-scsi@vger.kernel.org
To: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Cc: linux-scsi@vger.kernel.org

On Wed, May 26, 2004 at 03:24:49PM -0500, Edwards, Scott (MED, Kelly IT Resouces) wrote:
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
