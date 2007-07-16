From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Mon, 16 Jul 2007 16:59:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707161658510.1072@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
 <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de>
 <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
 <1184340528.3402.32.camel@localhost.localdomain>
 <Pine.LNX.4.62.0707132212520.23000@chinchilla.sonytel.be>
 <Pine.LNX.4.62.0707161338230.1072@pademelon.sonytel.be> <20070716121649.GI5195@kernel.dk>
 <1184593643.3447.9.camel@localhost.localdomain> <20070716143852.GW5195@kernel.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1210499770-1184597959=:1072"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42724 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758092AbXGPO7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 10:59:21 -0400
In-Reply-To: <20070716143852.GW5195@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Alessandro Rubini <rubini@vision.unipv.it>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1210499770-1184597959=:1072
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 16 Jul 2007, Jens Axboe wrote:
> On Mon, Jul 16 2007, James Bottomley wrote:
> > On Mon, 2007-07-16 at 14:16 +0200, Jens Axboe wrote:
> > > On Mon, Jul 16 2007, Geert Uytterhoeven wrote:
> > > > On Fri, 13 Jul 2007, Geert Uytterhoeven wrote:
> > > > > Ah, that explains it. flush_dcache_page() is used in some drivers.
> > > > > I'll update my patches. Thanks for the comments!
> > > > 
> > > > Does this look OK?
> > > >   - Replaced KM_USER0 by KM_IRQ0 (all routines are either called from an
> > > >     interrupt handler, from .request_fn (ps3disk), or from .queuecommand
> > > >     (ps3rom))
> > > 
> > > That looks good.
> > > 
> > > >   - Add a call to flush_kernel_dcache_page() in routines that write to buffers
> > > 
> > > Hmm, I would have thought a flush_dcache_page() would be more
> > > appropriate, the backing could be page cache pages.
> > 
> > No ... that was the point of flush_kernel_dcache_page().  The page in
> > question is page cache backed and contains user mappings.  However, the
> > block layer has already done a flush_dcache_page() in get_user_pages()
> > and the user shouldn't be touching memory under I/O (unless they want
> > self induced aliasing problems) so we're free to assume all the user
> > cachelines are purged, hence all we have to do is flush the kernel alias
> > to bring the page up to date and make the users see it correctly.
> 
> Oh indeed, I missed the flush_dcache_page() in get_user_pages().

Good, thanks for reaching a consensus, so I can update my patch series.

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1210499770-1184597959=:1072--
