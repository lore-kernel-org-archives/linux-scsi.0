From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] Add struct crypto_alg->cra_check_optimized for
	crc32c_intel
Date: Thu, 10 Mar 2011 01:13:07 -0800
Message-ID: <1299748387.5263.45.camel@haakon2.linux-iscsi.org>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
	 <20110310084346.GA10650@gondor.apana.org.au>
	 <1299747264.5263.35.camel@haakon2.linux-iscsi.org>
	 <20110310090929.GA10919@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20110310090929.GA10919@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-03-10 at 17:09 +0800, Herbert Xu wrote:
> On Thu, Mar 10, 2011 at 12:54:24AM -0800, Nicholas A. Bellinger wrote:
> >
> > OK, so you mean each struct crypto_alg should define something like a
> > 'cra_optimized_name' for which request_module(alg->cra_optimized_name)
> > is called somewhere in libcrypto code..?
> 
> No, what I mean is that whenever we look up an algorithm through
> crypto_alg_mod_lookup, we should conditionally call modprobe if
> we havn't done so already.
> 
> So you just need to record one bit of info in each crypto_alg
> object to indicate whether we have invoked modprobe.  I suggest
> adding a CRYPTO_ALG_* bit.
> 

Mmmm, now I am really confused, and please let me apologize in advance
for my lack of experience with libcrypto internals..  ;)

I thought the problem was that CONFIG_CRYPTO_ALGFOO=y and
CONFIG_CRYPTO_ALGFOO_ARCH_HW_OFFLOAD=m would cause the latter to not
explictly call request_module() for this HW offload case..

So what I don't understand how adding a request_module() call to a list
of known modules works when crc32c_intel.ko has not been loaded yet..?

Am I missing something obvious wrt to how crc32c.ko can tell libcrypto
about which architecture dependent optimized modules it should load..?

Best Regards,

--nab
