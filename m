From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 10:02:13 -0400
Message-ID: <1184335333.3402.20.camel@localhost.localdomain>
References: <20070704132212.726923000@pademelon.sonytel.be>
	 <20070704132346.591348000@pademelon.sonytel.be>
	 <1184331741.3402.13.camel@localhost.localdomain>
	 <20070713130508.GQ5328@kernel.dk>
	 <Pine.LNX.4.62.0707131518120.18802@pademelon.sonytel.be>
	 <1184333670.3402.17.camel@localhost.localdomain>
	 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44444 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbXGMOCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2007 10:02:14 -0400
In-Reply-To: <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Paul Mackerras <paulus@samba.org>, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>

On Fri, 2007-07-13 at 15:45 +0200, Geert Uytterhoeven wrote:
> On Fri, 13 Jul 2007, James Bottomley wrote:
> > On Fri, 2007-07-13 at 15:25 +0200, Geert Uytterhoeven wrote:
> > > kmap() just returns page_address() on ppc64, as there's no highmem.
> > > kunmap() is a no-op.
> > 
> > > So technically I could just use page_address() directly, but Christoph
> > > wanted
> > > me to keep the kmap()/kunmap() sequence because it's considered a good
> > > practice.
> > 
> > The point isn't what kmap and kunmap do ... it's the addresses they
> > return.  By and large, a kernel virtual address for a page is different
> > from the user virtual address.  If the cache is virtually indexed you
> > get different cache lines for the same page ... and that sets you up
> > with aliases you need to resolve.  parisc is the same ... our
> > kmap/kunmap are nops as well, but our kernel virtual addresses are still
> > different from the user virtual ones.
> 
> IC.
> 
>   - flush_kernel_dcache_page() is a no-op on ppc64
>     (ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE is defined on parisc only).
> 
>   - For reference, drivers/scsi/ipr.c (another ppc64 driver) just uses a plain
>     kmap/memcpy/kunmap sequence
> 
> So what should I do?

Ask someone who knows the architecture ... Anton, Paulus or Benh ... I'm
fairly certain PPC is VIPT and will need some kind of alias
resolution ... perhaps its associative enough not to let the aliases be
a problem.

James


