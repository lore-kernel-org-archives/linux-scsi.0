From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion
 (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Tue, 30 Sep 2008 14:33:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
 <1213540781.3517.18.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
 <1213648258.3420.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
 <1214605634.3394.91.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
 <1214841102.3381.5.camel@localhost.localdomain> <1214925487.3316.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-203778553-1222778016=:5818"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55142 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751551AbYI3Mdi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 08:33:38 -0400
In-Reply-To: <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Monty Montgomery <monty@xiph.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-203778553-1222778016=:5818
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi Monty,

On Tue, 30 Sep 2008, Monty Montgomery wrote:
> On Wed, Sep 17, 2008 at 11:05 AM, Geert Uytterhoeven
> <Geert.Uytterhoeven@sonycom.com> wrote:
> >> The problem is I don't think the new behaviour is a regression.
> >> cdparanoia requested O_NONBLOCK ... it's a bit counter to this if we
> >> wait for the drive to become ready.
> 
> O_NONBLOCK has nothing to do with the drive being ready.  It means not
> to wait to open a device locked or in use exclusively by another
> process. It does not affect command processing (at least not the way
> cdparanoia is doing it).  If a drive isn't ready, it returns a sense
> key of 'not ready' and the SGIO layer doesn't filter that in any way.
> SGIO itself never waits or takes any special action on 'not ready', it
> merely passes through the comand termination status.
> 
> Note that 'not ready' is not the same as 'no medium'.  One means the
> drive is digesting a new disc, the other means there is no dics (or
> the tray is open).  Some drives do in fact return 'empty' until a new
> disc is completely loaded after tray close.  These drives are in
> violation of spec (but the alternative is to ignore the empty status
> and retry forever, which means there's no recovering from ejecting a
> disc mid-operation, which was also reported as a bug).  On the other
> hand, I've never come across any ATAPI drive that 100% faithfully
> implements the command spec.  All vendors take *substantial*
> liberties.
> 
> > I confirmed (using strace) that my cdparanoia also opens /dev/scd0 with
> > O_NONBLOCK.
> >
> > After applying the patch below to cdparanoia, the problem goes away.
> >
> > --- cdparanoia-3.10.0+debian/interface/scan_devices.c.orig      2008-05-16 06:25:24.000000000 +0200
> > +++ cdparanoia-3.10.0+debian/interface/scan_devices.c   2008-09-17 16:36:14.000000000 +0200
> > @@ -608,7 +608,7 @@
> >
> >   if(specialized_device) {
> >     if(use_sgio)
> > -      i_fd=open(specialized_device,O_RDWR|O_NONBLOCK);
> > +      i_fd=open(specialized_device,O_RDONLY);
> 
> This change means you can only run one cdparanoia per computer as the
> device autoscan code will now block on an in-use drive.
> Also, you're a few releases behind.  10.0 was misreporting drive
> status due to a stupid bug; god only knows what happened in SGIO as
> the error code never got passed up.  10.2 corrects the problem (as
> well as a few other major bugs).  Current SVN will be 10.3 in a few
> more days.

So I tried the version in Debian unstable...

> If the same thing is still happening with 10.2 and the same patch

The same thing happens with cdparanoia-3.10.2+debian.

> still fixes it, then I definitely have some head scratching [and
> kernel perusal] to do.

But the patch above doesn't help. Now cdparanoia crashes with a segmentation
fault:

| 0x0ffd5730 in cdda_read_timed () from /usr/lib/libcdda_interface.so.0
| (gdb) bt
| #0  0x0ffd5730 in cdda_read_timed () from /usr/lib/libcdda_interface.so.0
| #1  0x0ffa7624 in i_read_c_block () from /usr/lib/libcdda_paranoia.so.0
| #2  0x0ffa9114 in paranoia_read_limited () from /usr/lib/libcdda_paranoia.so.0
| #3  0x10004da0 in ?? ()
| #4  0x0fd46704 in ?? () from /lib/libc.so.6
| #5  0x0fd468c0 in __libc_start_main () from /lib/libc.so.6
| #6  0x00000000 in ?? ()

due to the `buffer' parameter being NULL.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-203778553-1222778016=:5818--
