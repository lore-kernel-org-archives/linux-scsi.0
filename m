From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] Add struct crypto_alg->cra_check_optimized for
	crc32c_intel
Date: Mon, 14 Mar 2011 05:14:17 -0700
Message-ID: <1300104857.28255.77.camel@haakon2.linux-iscsi.org>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
	 <20110310084346.GA10650@gondor.apana.org.au>
	 <1299747264.5263.35.camel@haakon2.linux-iscsi.org>
	 <20110310090929.GA10919@gondor.apana.org.au>
	 <1299748387.5263.45.camel@haakon2.linux-iscsi.org>
	 <1299751517.5263.60.camel@haakon2.linux-iscsi.org>
	 <20110313090158.GA12473@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20110313090158.GA12473@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-03-13 at 17:01 +0800, Herbert Xu wrote:
> On Thu, Mar 10, 2011 at 02:05:17AM -0800, Nicholas A. Bellinger wrote:
> >
> > We are still expecting the libcrypto consumer (iscsi_target_mod.ko) to
> > call the arch independent crypto_alloc_hash("crc32c", ...) in order to
> > have libcrypto backend logic perform a request_module() upon
> > architecture dependent offload modules (like crc32c_intel.ko) that
> > libcrypto consumers are not (and should not) be calling directly via
> > crypto_alloc_host("crc32c_intel", ...), correct..?
> 
> Right.
> 
> > Where I am getting confused is wrt to a new crypto_alg_mod_lookup() ->
> > request_module() call for a struct shash_alg that has not yet be loaded
> > via arch/x86/crypto/crc32c-intel.c:crc32c_intel_mod_init() ->
> > crypto_register_shash().
> 
> If you look at crypto_alg_mod_lookup, basically there are two paths.
> Either we already have a registered algorithm of the requested name,
> or we don't.
> 
> In the first case, we won't invoke request_module and in the second
> case we will.
> 
> So what I'm suggesting is that in the first case we also invoke
> request_module conditionally.  Now exactly what that condition is
> is the tricky bit.
> 
> The easiest is to flip a bit in the algorithm we just found.  This
> isn't optimal as it'll mean that for each unregistered algorithm
> we'll end up modprobing twice, but that shouldn't be too bad I
> think.
> 

Hi Herbert,

Thanks for your feedback on this issue, and again my apologies for the
lack of experience beyond the external libcrypto API.  I will take
another look this week and see if something can be produced more along
the lines of what you had in mind to resolve this special case.  In the
mean time the extra crypto_alloc_hash("crc32c-intel", ...) calls have
been removed from RFC-v2 iscsi-target code posted earlier this morning.

Please feel free to add any other pointers and I will have a look.

Best Regards,

--nab
