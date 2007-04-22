From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] utilities: add helper functions for safe 64-bit integer operations as 32-bit halves
Date: Sun, 22 Apr 2007 10:18:16 +0100
Message-ID: <20070422091816.GC1558@infradead.org>
References: <20070420114337.12a67141.akpm@linux-foundation.org> <1177095007.3718.43.camel@mulgrave.il.steeleye.com> <20070420123041.94aac1e1.akpm@linux-foundation.org> <1177100459.3718.45.camel@mulgrave.il.steeleye.com> <20070420141218.a0222472.akpm@linux-foundation.org> <alpine.DEB.0.98.0704201732240.11655@sigma.j-a-k-j.com> <alpine.DEB.0.98.0704202040150.16687@sigma.j-a-k-j.com> <20070421030825.bed0b8a9.akpm@linux-foundation.org> <20070421220147.7144113e@the-village.bc.nu> <20070421140622.dc197b38.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33303 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565AbXDVJSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2007 05:18:30 -0400
Content-Disposition: inline
In-Reply-To: <20070421140622.dc197b38.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, James Bottomley <James.Bottomley@SteelEye.com>, "Cameron, Steve" <Steve.Cameron@hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, trivial@kernel.org

On Sat, Apr 21, 2007 at 02:06:22PM -0700, Andrew Morton wrote:
> On Sat, 21 Apr 2007 22:01:47 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > > +#define lower_32_bits(n) (sizeof(n) == 8 ? (u32)(n) : (n))
> > > 
> > > n&0xffffffff would be simpler.
> > > 
> > > Do we actually have any call for this?
> > 
> > The only case for all of this we care about is sector_t, which is one
> > type, with specific properties (eg always being positive). The rest is
> > over-engineering. Call it sector_upper32() do it the simple way and stop
> > trying to solve a problem we don't have
> 
> James said we have the same problem with dma_addr_t.

Yes.  It's in fact the far more common case and we have a bread of
macros dealing with the issue in various drivers.
