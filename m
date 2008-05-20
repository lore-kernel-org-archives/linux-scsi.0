From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
Date: Tue, 20 May 2008 18:55:12 +0900
Message-ID: <20080520095512.GA18633@linux-sh.org>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1211259514-9131-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080520023129.2f921f24.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta23.gyao.ne.jp ([125.63.38.249]:38876 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765349AbYETJ5M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 05:57:12 -0400
Content-Disposition: inline
In-Reply-To: <20080520023129.2f921f24.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org, Herbert Xu <herbert@gondor.apana.org.au>

On Tue, May 20, 2008 at 02:31:29AM -0700, Andrew Morton wrote:
> Why does ARCH_KMALLOC_MINALIGN even exist?  What is its mandate?  Sigh.
> 
> It's not really related to your patch (although your patch compounds
> the problem a little).  But we should sit down and work out what we
> actually want to do here.  Something like:
> 
> In each architecture's arch/foo/Kconfig, define
> 
> 	CONFIG_ARCH_DMA_ALIGN
> 
> and
> 
> 	CONFIG_ARCH_64BIT_POINTER_ALIGN
> 
> and then use them.  Note that these have nothing to do with each other,
> as far as I can tell.
> 
> Which leaves the question: "what should slab use"?  Maybe
> CONFIG_ARCH_DMA_ALIGN?  But that depends what ARCH_KMALLOC_MINALIGN is
> supposed to exist for.
> 
> ick.
> 
The only platforms that set ARCH_KMALLOC_MINALIGN appear to do so for DMA
alignment reasons, so your Kconfig option there seems reasonable.

The ARCH_SLAB_MINALIGN you can blame me for:

	http://marc.info/?l=linux-kernel&m=110227138116749&w=2
