From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default
 dma pad mask
Date: Tue, 20 May 2008 22:25:25 +0900
Message-ID: <20080520222531H.tomof@acm.org>
References: <1211259514-9131-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080520023129.2f921f24.akpm@linux-foundation.org>
	<20080520093819.GA9147@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080520093819.GA9147@gondor.apana.org.au>
Sender: linux-ide-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 20 May 2008 17:38:20 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Tue, May 20, 2008 at 02:31:29AM -0700, Andrew Morton wrote:
> >
> > So here you're using it for "dma aligment" whereas crypto is using it
> > (or ARCH_SLAB_MINALIGN!) for "cpu 64-bit alignment".
> 
> No the 64-bit alignment is just an example.  The purpose of
> CRYPTO_MINALIGN is pretty much the same as ARCH_KMALLOC_MINALIGN,
> i.e., the minimum alignment guaranteed by kmalloc.  The only
> reason it exists is because ARCH_KMALLOC_MINALIGN isn't defined
> on all platforms.

struct ablkcipher_request {
	struct crypto_async_request base;

	unsigned int nbytes;

	void *info;

	struct scatterlist *src;
	struct scatterlist *dst;

	void *__ctx[] CRYPTO_MINALIGN_ATTR;
};

Does someone do DMA from/to __ctx?
