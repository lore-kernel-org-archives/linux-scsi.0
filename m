From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion
 (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Wed, 30 Jul 2008 15:06:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807301505110.1993@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
 <1213540781.3517.18.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
 <1213648258.3420.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
 <1214605634.3394.91.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
 <1214841102.3381.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-159658398-1217423163=:1993"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40640 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750804AbYG3NGQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 09:06:16 -0400
In-Reply-To: <1214841102.3381.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-159658398-1217423163=:1993
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi James,

On Mon, 30 Jun 2008, James Bottomley wrote:
> On Mon, 2008-06-30 at 11:25 +0200, Geert Uytterhoeven wrote:
> > On Fri, 27 Jun 2008, James Bottomley wrote:
> > > > git-bisect taught me it was introduced by
> > > > 
> > > > commit 38582a62ecd337de4212004c7d4844899dc57890
> > > > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > Date:   Wed Feb 6 13:01:58 2008 -0600
> > > > 
> > > >     [SCSI] sr: fix test unit ready responses
> > > >     
> > > >     Commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 updated sr.c to use
> > > >     the scsi_test_unit_ready() function.  Unfortunately, this has the
> > > >     wrong characteristic of eating NOT_READY returns which sr.c relies on
> > > >     for tray status.
> > > >     
> > > >     Fix by rolling an internal sr_test_unit_ready() that doesn't do this.
> > > 
> > > OK, I thought I had a test case for this, but when I revert this commit
> > > on git head (and fix up the one reject which just leaves the sr_
> > > function in place) I still produce the same behaviour.
> > > 
> > > What I'm trying is 
> > > 
> > > sg_start -i -l <cdrom>
> > > 
> > > to close the tray followed by your cdparanoia command
> > > 
> > > Could you see if reverting this commit on git head works for you (in
> > > which case I'm not reproducing it correctly)?
> > 
> > On 9bedbcb207ed9a571b239231d99c8fd4a34ae24d, the sequence
> > 
> >     eject; sg_start -i -l /dev/scd0; cdparanoia \
> > 	-d /dev/scd0 -Z -q 1-1[:1] /dev/null || echo failed
> > 
> > fails with
> > 
> >     004: Unable to read table of contents header
> > 
> > After reverting 38582a62ecd337de4212004c7d4844899dc57890, it works.
> > 
> > I added the eject as the PS3 has a slot-loading drive.
> > 
> > With kind regards,
> 
> OK ... but this doesn't happen for me with or without this commit
> reverted.  This is what I see from stracing cdparanoia:
> 
> lstat64("/dev/scd0", {st_mode=S_IFBLK|0660, st_rdev=makedev(11, 0), ...}) = 0
> open("/dev/scd0", O_RDWR|O_NONBLOCK)    = 3
> ioctl(3, SG_IO, 0xbfc0afdc)             = -1 EINVAL (Invalid argument)
> close(3)                                = 0
> open("/dev/scd0", O_RDWR|O_NONBLOCK)    = 3
> dup(3)                                  = 4
> ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0xbfc0b240) = 0
> ioctl(3, SCSI_IOCTL_GET_BUS_NUMBER, 0xbfc0b248) = 0
> ioctl(3, SG_IO, 0xbfc0af8c)             = 0
> ioctl(4, SG_EMULATED_HOST, 0xbfc0b2b8)  = 0
> ioctl(3, SG_IO, 0xbfc0b07c)             = 0
> ioctl(3, SG_IO, 0xbfc0b04c)             = 0
> write(2, "004: Unable to read table of con"..., 45004: Unable to read table of contents header) = 45
> 
> The O_NONBLOCK tells the cdrom layer not to do drive ready processing.
> 
> The three SG_IOs are INQUIRY, MODE_SENSE(10) and READ TOC/PMA/ATIP
> 
> The latter one is returned with a check condition and sense data not
> ready; medium not present - tray open.
> 
> There's no way the drive ready processing can have an effect on this
> sequence unless cdparanoia either invokes it from the cdrom layer or
> processes the not ready itself.  Could you strace your cdparanoia and
> see what sequence it is using?

My cdparanioa is using the exact same sequence.

Sorry it took that long to get back to you (holidays and OLS).

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@eu.sony.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-159658398-1217423163=:1993--
