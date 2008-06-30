From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion
 (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Mon, 30 Jun 2008 11:25:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
 <1213540781.3517.18.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
 <1213648258.3420.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
 <1214605634.3394.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1262841680-1214817928=:10868"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48558 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754474AbYF3JZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2008 05:25:33 -0400
In-Reply-To: <1214605634.3394.91.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1262841680-1214817928=:10868
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi James,

On Fri, 27 Jun 2008, James Bottomley wrote:
> > git-bisect taught me it was introduced by
> > 
> > commit 38582a62ecd337de4212004c7d4844899dc57890
> > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date:   Wed Feb 6 13:01:58 2008 -0600
> > 
> >     [SCSI] sr: fix test unit ready responses
> >     
> >     Commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 updated sr.c to use
> >     the scsi_test_unit_ready() function.  Unfortunately, this has the
> >     wrong characteristic of eating NOT_READY returns which sr.c relies on
> >     for tray status.
> >     
> >     Fix by rolling an internal sr_test_unit_ready() that doesn't do this.
> 
> OK, I thought I had a test case for this, but when I revert this commit
> on git head (and fix up the one reject which just leaves the sr_
> function in place) I still produce the same behaviour.
> 
> What I'm trying is 
> 
> sg_start -i -l <cdrom>
> 
> to close the tray followed by your cdparanoia command
> 
> Could you see if reverting this commit on git head works for you (in
> which case I'm not reproducing it correctly)?

On 9bedbcb207ed9a571b239231d99c8fd4a34ae24d, the sequence

    eject; sg_start -i -l /dev/scd0; cdparanoia \
	-d /dev/scd0 -Z -q 1-1[:1] /dev/null || echo failed

fails with

    004: Unable to read table of contents header

After reverting 38582a62ecd337de4212004c7d4844899dc57890, it works.

I added the eject as the PS3 has a slot-loading drive.

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
---584349381-1262841680-1214817928=:10868--
