From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
Date: Wed, 21 May 2008 09:26:22 +0800
Message-ID: <20080521012622.GA15850@gondor.apana.org.au>
References: <20080520093819.GA9147@gondor.apana.org.au> <20080520222531H.tomof@acm.org> <20080520153424.GA11687@gondor.apana.org.au> <20080521010942W.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080521010942W.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 21, 2008 at 01:09:41AM +0900, FUJITA Tomonori wrote:
>
> Then, you don't need to use ARCH_KMALLOC_MINALIGN. 8 bytes align works
> for you on all the architectures.

DMA isn't the only thing that requires alignment.  The CPU needs
it too.  Also using a constant like 8 is broken because if we used
a value larger than the alignment guaranteed by kmalloc then the
context may end up unaligned.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
