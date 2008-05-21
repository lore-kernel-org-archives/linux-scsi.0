From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
Date: Wed, 21 May 2008 21:18:11 +0800
Message-ID: <20080521131811.GA20212@gondor.apana.org.au>
References: <20080521112554.GA19558@gondor.apana.org.au> <20080521210956C.tomof@acm.org> <20080521122218.GA19849@gondor.apana.org.au> <20080521214624Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080521214624Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 21, 2008 at 09:46:24PM +0900, FUJITA Tomonori wrote:
>
> No, you misunderstand my question. I meant, software algorithms don't
> need ARCH_KMALLOC_MINALIGN alignment for __crt_ctx and if we are fine
> with using the ALIGN hack for crypto hardware every time (like
> aes_ctx_common), crypto doesn't need ARCH_KMALLOC_MINALIGN alignment
> for __crt_ctx. Is this right?

The padlock isn't the only hardware device that will require
such alignment.  Now that we have the async interface there will
be more.

> Because there are few architecture that defines
> ARCH_KMALLOC_MINALIGN. So if crypto hardware needs alignement, it's

You keep going back to ARCH_KMALLOC_MINALIGN.  But this has *nothing*
to do with ARCH_KMALLOC_MINALIGN.  The only reason it appears at
all in the crypto code is because it's one of the parameters used
to calculate the minimum alignment guaranteed by kmalloc.

If there were a macro KMALLOC_MINALIGN which did what its name says
then I'd gladly use it.

Cheeres,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
