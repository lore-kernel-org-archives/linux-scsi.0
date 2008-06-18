From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media
 change and delay
Date: Wed, 18 Jun 2008 13:13:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806181156460.13297@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
 <Pine.LNX.4.64.0806131932350.30730@vixen.sonytel.be>
 <5a4c581d0806180147qf8fc731y527c79bfb73401b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-698854956-1213787625=:13297"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34615 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752388AbYFRLNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2008 07:13:47 -0400
In-Reply-To: <5a4c581d0806180147qf8fc731y527c79bfb73401b2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, David Martin <tasio@tasio.net>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-698854956-1213787625=:13297
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 18 Jun 2008, Alessandro Suardi wrote:
> On Fri, Jun 13, 2008 at 7:33 PM, Geert Uytterhoeven
> <Geert.Uytterhoeven@sonycom.com> wrote:
> > On Fri, 6 Jun 2008, Geert Uytterhoeven wrote:
> >> When mounting a CD/DVD more than 30 seconds after inserting it, and reading
> >> from it, we get:
> >
> > Apparently the fix didn't make it to all the CCed lists...
> >
> > http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
> 
> Oh, that's in mainline ? I still have the problem of having to

Not yet, it's in the scsi-rc-fixes-2.6 tree.

>  insert DVD / try accessing it and get errors / eject / re-insert
>  and then it magically works... the messages have changed
>  from what they were as reported here
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10116
> 
>  (see comments #8 and #9) to these ones, in 2.6.26-rc6-git4:
> 
> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] Result:
> hostbyte=0x00 driverbyte=0x08
> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] Sense Key : 0x3 [current]
> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] ASC=0x11 ASCQ=0x0
> Jun 17 22:38:43 sandman kernel: end_request: I/O error, dev sr0, sector 232
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 29
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 30
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 31
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 32
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 33
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 34
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 35
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 36
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 37
> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 38
> 
> here I eject and reinsert the disc, and:
> 
> Jun 17 22:39:10 sandman kernel: UDF-fs: No VRS found
> 
>  lo and behold, no problem.
> 
> This does not, alas, happen every time. It might be at the first
>  DVD access after booting the laptop, but I haven't investigated
>  in this detail yet.

Does /sys/block/sr0/size reflect the correct size of the DVD?

Did you try applying the patch?

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
---584349381-698854956-1213787625=:13297--
