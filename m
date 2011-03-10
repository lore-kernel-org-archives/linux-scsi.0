From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Add struct crypto_alg->cra_check_optimized for
	crc32c_intel
Date: Thu, 10 Mar 2011 17:09:29 +0800
Message-ID: <20110310090929.GA10919@gondor.apana.org.au>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org> <20110310084346.GA10650@gondor.apana.org.au> <1299747264.5263.35.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1299747264.5263.35.camel@haakon2.linux-iscsi.org>
Sender: linux-crypto-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 10, 2011 at 12:54:24AM -0800, Nicholas A. Bellinger wrote:
>
> OK, so you mean each struct crypto_alg should define something like a
> 'cra_optimized_name' for which request_module(alg->cra_optimized_name)
> is called somewhere in libcrypto code..?

No, what I mean is that whenever we look up an algorithm through
crypto_alg_mod_lookup, we should conditionally call modprobe if
we havn't done so already.

So you just need to record one bit of info in each crypto_alg
object to indicate whether we have invoked modprobe.  I suggest
adding a CRYPTO_ALG_* bit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
