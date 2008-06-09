From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media
 change and delay
Date: Mon, 9 Jun 2008 15:54:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806091546260.22138@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
 <1212765202.16182.5.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806091443000.17741@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-744764440-1213019660=:22138"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56521 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753865AbYFINyW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 09:54:22 -0400
In-Reply-To: <Pine.LNX.4.64.0806091443000.17741@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Martin <tasio@tasio.net>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-744764440-1213019660=:22138
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 9 Jun 2008, Geert Uytterhoeven wrote:
> On Fri, 6 Jun 2008, James Bottomley wrote:
> > On Fri, 2008-06-06 at 16:06 +0200, Geert Uytterhoeven wrote:
> > > When mounting a CD/DVD more than 30 seconds after inserting it, and reading
> > > from it, we get:
> > > 
> > >     attempt to access beyond end of device
> > >     sr0: rw=0, want=371932, limit=371928
> > >     Buffer I/O error on device sr0, logical block 92982
> > >     attempt to access beyond end of device
> > >     sr0: rw=0, want=371936, limit=371928
> > >     Buffer I/O error on device sr0, logical block 92983
> > >     attempt to access beyond end of device
> > >     sr0: rw=0, want=371940, limit=371928
> > >     Buffer I/O error on device sr0, logical block 92984
> > >     attempt to access beyond end of device
> > >     sr0: rw=0, want=371944, limit=371928
> > >     Buffer I/O error on device sr0, logical block 92985
> > >     attempt to access beyond end of device
> > >     sr0: rw=0, want=371948, limit=371928
> > >     Buffer I/O error on device sr0, logical block 92986
> > >     ...
> > > 
> > > It can be reproduced on a PS3 with busybox userland using:
> > > 
> > >     # Insert first CD
> > >     $ mount /dev/sr0 /mnt
> > >     $ ls -R /mnt
> > >     $ umount /mnt
> > >     $ eject
> > >     # Remove first CD
> > > 
> > >     # Insert second CD
> > >     # Wait at least 30 seconds
> > >     $ mount /dev/sr0 /mnt
> > >     $ tar cf /dev/null /mnt
> > > 
> > > It does not happen when mounting the second CD within 30 seconds after
> > > inserting it, which is consistent with
> > > 
> > >     #define SR_TIMEOUT     (30 * HZ)
> > > 
> > > I can't seem to reproduce it with a Debian or Fedora Core 6 userland.
> > > 
> > > The problem is present in 2.6.25.
> > > 2.6.24 is OK.
> > 
> > Also, in the two different situations, what does
> > 
> > cat /sys/block/sr0/size
> > 
> > (assuming your cd is sr0) give you?  My first theory is an incorrect
> > size propagating from something.
> 
> Nice first theory!
> 
> Initially /sys/block/sr0/size is 2097151.
> 
> After inserting the first CD, and mounting it, /sys/block/sr0/size is changed
> to the size of the first CD (in 512 byte blocks).
> 
> After ejecting the first CD and inserting the second CD, the behavior is like
> this:
>   1. when immediately mounting the CD, /sys/block/sr0/size is updated to the
>      size of the second CD,
>   2. when waiting more than 30 seconds before mounting the CD,
>      /sys/block/sr0/size is not updated, and keeps the old value.
> 
> Surprisingly, it doesn't behave like this when inserting the first CD.
> /sys/block/sr0/size is always updated, whether I wait 30 seconds before
> mounting it or not.

I managed to reproduce it on my laptop (Core 2 Duo, SATA DVD-RAM, running
Ubuntu 8.04 for amd64), by booting Debian's 2.6.25 kernel into recovery mode.
So the problem is not PS3-specific.

Worse, I never got an updated /sys/block/sr0/size for the second CD, not even
when mounting it ASAP (which is ca. 15-20 seconds after inserting it).  It
always stayed at the value for the first CD.

Note that Debian's tar is `smart' and optimizes `tar cf /dev/null' by never
reading the input files, so you have to e.g. pipe the resulting archive to
`cat > /dev/null' or so.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Technology and Software Centre Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-744764440-1213019660=:22138--
