From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 11:28:47 -0400
Message-ID: <1184340528.3402.32.camel@localhost.localdomain>
References: <20070704132212.726923000@pademelon.sonytel.be>
	 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
	 <1184335333.3402.20.camel@localhost.localdomain>
	 <200707131619.54898.arnd@arndb.de>
	 <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40949 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932356AbXGMP2t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2007 11:28:49 -0400
In-Reply-To: <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

On Fri, 2007-07-13 at 17:10 +0200, Geert Uytterhoeven wrote:
> On Fri, 13 Jul 2007, Arnd Bergmann wrote:
> > On Friday 13 July 2007, James Bottomley wrote:
> > > > IC.
> > > > 
> > > >  - flush_kernel_dcache_page() is a no-op on ppc64
> > > >   (ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE is defined on parisc only).
> > > > 
> > > >  - For reference, drivers/scsi/ipr.c (another ppc64 driver) just uses a plain
> > > >   kmap/memcpy/kunmap sequence
> > > > 
> > > > So what should I do?
> > > 
> > > Ask someone who knows the architecture ... Anton, Paulus or Benh ... I'm
> > > fairly certain PPC is VIPT and will need some kind of alias
> > > resolution ... perhaps its associative enough not to let the aliases be
> > > a problem.
> > 
> > I'm pretty sure that no ppc64 machine needs alias resolution in the kernel,
> > although some are VIPT. Last time we discussed this, Segher explained it
> > to me, but I don't remember which way Cell does it. IIRC, it automatically
> > flushes cache lines that are accessed through aliases.
> 
> Thanks for confirming!
> 
> > It's probably a good idea to have the flush_kernel_dcache_page() in there
> > anyway, if only to serve as an example for people that copy it into
> > architecture-independent drivers, same as what we do for the
> > k{,un}map_atomic() that is also not required on ppc64.
> 
> Now my next question: why should I add it, if currently no single driver in
> mainline calls flush_kernel_dcache_page()? 
> 
> `git grep' finds it in the following files only:
>     Documentation/cachetlb.txt
>     arch/parisc/kernel/cache.c
>     arch/parisc/kernel/pacache.S
>     include/asm-parisc/cacheflush.h
>     include/linux/highmem.h

It's a recent addition to the API ... the previous way of doing it was
flush_dcache_page() but that's expensive and flushes all the user
aliases.  Since you know in this case there are no current user aliases
and you only need to flush the kernel alias, flush_kernel_dcache_page()
was introduced as the cheaper alternative.

James


