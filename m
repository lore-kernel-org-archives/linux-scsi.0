From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression/bisected] corrupt CD data after media change and
 delay
Date: Fri, 6 Jun 2008 19:27:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806061927230.18142@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
 <1212765202.16182.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-424076481-1212773271=:18142"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:36289 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751173AbYFFR1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 13:27:52 -0400
In-Reply-To: <1212765202.16182.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Martin <tasio@tasio.net>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-424076481-1212773271=:18142
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 6 Jun 2008, James Bottomley wrote:
> On Fri, 2008-06-06 at 16:06 +0200, Geert Uytterhoeven wrote:
> > When mounting a CD/DVD more than 30 seconds after inserting it, and reading
> > from it, we get:
> > 
> >     attempt to access beyond end of device
> >     sr0: rw=0, want=371932, limit=371928
> >     Buffer I/O error on device sr0, logical block 92982
> >     attempt to access beyond end of device
> >     sr0: rw=0, want=371936, limit=371928
> >     Buffer I/O error on device sr0, logical block 92983
> >     attempt to access beyond end of device
> >     sr0: rw=0, want=371940, limit=371928
> >     Buffer I/O error on device sr0, logical block 92984
> >     attempt to access beyond end of device
> >     sr0: rw=0, want=371944, limit=371928
> >     Buffer I/O error on device sr0, logical block 92985
> >     attempt to access beyond end of device
> >     sr0: rw=0, want=371948, limit=371928
> >     Buffer I/O error on device sr0, logical block 92986
> >     ...
> > 
> > It can be reproduced on a PS3 with busybox userland using:
> > 
> >     # Insert first CD
> >     $ mount /dev/sr0 /mnt
> >     $ ls -R /mnt
> >     $ umount /mnt
> >     $ eject
> >     # Remove first CD
> > 
> >     # Insert second CD
> >     # Wait at least 30 seconds
> >     $ mount /dev/sr0 /mnt
> >     $ tar cf /dev/null /mnt
> > 
> > It does not happen when mounting the second CD within 30 seconds after
> > inserting it, which is consistent with
> > 
> >     #define SR_TIMEOUT     (30 * HZ)
> > 
> > I can't seem to reproduce it with a Debian or Fedora Core 6 userland.
> > 
> > The problem is present in 2.6.25.
> > 2.6.24 is OK.
> 
> Hmm ... how are you preventing HAL from automatically mounting the CD?

By not running HAL?

> Also, in the two different situations, what does
> 
> cat /sys/block/sr0/size
> 
> (assuming your cd is sr0) give you?  My first theory is an incorrect
> size propagating from something.

I'll give that a try on Monday...

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
---584349381-424076481-1212773271=:18142--
