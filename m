From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 17:10:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
 <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-967579323-1184339403=:18802"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49524 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760565AbXGMPKF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jul 2007 11:10:05 -0400
In-Reply-To: <200707131619.54898.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-967579323-1184339403=:18802
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jul 2007, Arnd Bergmann wrote:
> On Friday 13 July 2007, James Bottomley wrote:
> > > IC.
> > > 
> > >   - flush_kernel_dcache_page() is a no-op on ppc64
> > >     (ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE is defined on parisc only).
> > > 
> > >   - For reference, drivers/scsi/ipr.c (another ppc64 driver) just uses a plain
> > >     kmap/memcpy/kunmap sequence
> > > 
> > > So what should I do?
> > 
> > Ask someone who knows the architecture ... Anton, Paulus or Benh ... I'm
> > fairly certain PPC is VIPT and will need some kind of alias
> > resolution ... perhaps its associative enough not to let the aliases be
> > a problem.
> 
> I'm pretty sure that no ppc64 machine needs alias resolution in the kernel,
> although some are VIPT. Last time we discussed this, Segher explained it
> to me, but I don't remember which way Cell does it. IIRC, it automatically
> flushes cache lines that are accessed through aliases.

Thanks for confirming!

> It's probably a good idea to have the flush_kernel_dcache_page() in there
> anyway, if only to serve as an example for people that copy it into
> architecture-independent drivers, same as what we do for the
> k{,un}map_atomic() that is also not required on ppc64.

Now my next question: why should I add it, if currently no single driver in
mainline calls flush_kernel_dcache_page()? 

`git grep' finds it in the following files only:
    Documentation/cachetlb.txt
    arch/parisc/kernel/cache.c
    arch/parisc/kernel/pacache.S
    include/asm-parisc/cacheflush.h
    include/linux/highmem.h

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village Â· Da Vincilaan 7-D1 Â· B-1935 Zaventem Â· Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 Â· B-1840 Londerzeel Â· Belgium	
VAT BE 0413.825.160 Â· RPR Brussels	
Fortis Bank Zaventem Â· Swift GEBABEBB08A Â· IBAN BE39001382358619
---584337861-967579323-1184339403=:18802--
