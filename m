From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 22:13:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707132212520.23000@chinchilla.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
 <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de>
 <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
 <1184340528.3402.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584336837-1695436844-1184357607=:23000"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S937196AbXGMUNq@vger.kernel.org>
In-Reply-To: <1184340528.3402.32.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584336837-1695436844-1184357607=:23000
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jul 2007, James Bottomley wrote:
> On Fri, 2007-07-13 at 17:10 +0200, Geert Uytterhoeven wrote:
> > On Fri, 13 Jul 2007, Arnd Bergmann wrote:
> > > On Friday 13 July 2007, James Bottomley wrote:
> > > > > IC.
> > > > > 
> > > > >  - flush_kernel_dcache_page() is a no-op on ppc64
> > > > >   (ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE is defined on parisc only).
> > > > > 
> > > > >  - For reference, drivers/scsi/ipr.c (another ppc64 driver) just uses a plain
> > > > >   kmap/memcpy/kunmap sequence
> > > > > 
> > > > > So what should I do?
> > > > 
> > > > Ask someone who knows the architecture ... Anton, Paulus or Benh ... I'm
> > > > fairly certain PPC is VIPT and will need some kind of alias
> > > > resolution ... perhaps its associative enough not to let the aliases be
> > > > a problem.
> > > 
> > > I'm pretty sure that no ppc64 machine needs alias resolution in the kernel,
> > > although some are VIPT. Last time we discussed this, Segher explained it
> > > to me, but I don't remember which way Cell does it. IIRC, it automatically
> > > flushes cache lines that are accessed through aliases.
> > 
> > Thanks for confirming!
> > 
> > > It's probably a good idea to have the flush_kernel_dcache_page() in there
> > > anyway, if only to serve as an example for people that copy it into
> > > architecture-independent drivers, same as what we do for the
> > > k{,un}map_atomic() that is also not required on ppc64.
> > 
> > Now my next question: why should I add it, if currently no single driver in
> > mainline calls flush_kernel_dcache_page()? 
> > 
> > `git grep' finds it in the following files only:
> >     Documentation/cachetlb.txt
> >     arch/parisc/kernel/cache.c
> >     arch/parisc/kernel/pacache.S
> >     include/asm-parisc/cacheflush.h
> >     include/linux/highmem.h
> 
> It's a recent addition to the API ... the previous way of doing it was
> flush_dcache_page() but that's expensive and flushes all the user
> aliases.  Since you know in this case there are no current user aliases
> and you only need to flush the kernel alias, flush_kernel_dcache_page()
> was introduced as the cheaper alternative.

Ah, that explains it. flush_dcache_page() is used in some drivers.
I'll update my patches. Thanks for the comments!

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
---584336837-1695436844-1184357607=:23000--
