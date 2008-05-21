From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default
 dma pad mask
Date: Wed, 21 May 2008 21:09:58 +0900
Message-ID: <20080521210956C.tomof@acm.org>
References: <20080521100529.GA19077@gondor.apana.org.au>
	<20080521200104C.tomof@acm.org>
	<20080521112554.GA19558@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58140 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934265AbYEUMLW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 08:11:22 -0400
In-Reply-To: <20080521112554.GA19558@gondor.apana.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org

On Wed, 21 May 2008 19:25:54 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, May 21, 2008 at 08:01:12PM +0900, FUJITA Tomonori wrote:
> >
> > Why do algorithms require alignments bigger than ARCH_KMALLOC_MINALIGN?
> 
> Because the hardware may require it.  For example, the VIA Padlock
> will fault unless the buffers are 16-byte aligned (it being an
> x86-32 platform).

OK, thanks. So it's about hardware requrement. Let me make sure if I
understand crypto alignment issue.

__crt_ctx needs ARCH_KMALLOC_MINALIGN alignment only because of crypto
hardware. If I misunderstand it, can you answer my question in the
previous mail (it's the part that you cut)? That is, why does
__crt_ctx need ARCH_KMALLOC_MINALIGN alignment with software
algorithms.

The VIA Padlock likes 16-byte aligned __crt_ctx. On x86-32 platform,
ARCH_KMALLOC_MINALIGN is not defined, so __crt_ctx is 8-byte
aligned. struct aes_ctx of The VIA Padlock may not be aligned so you
may need ALIGN hack every time.

But ARCH_KMALLOC_MINALIGN is 128 bytes on some architectures. In this
case, __crt_ctx is 128-byte aligned and struct aes_ctx of The VIA
Padlock is guaranteed to be aligned nicely.
