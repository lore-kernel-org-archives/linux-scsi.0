From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v2 1/4] Wrap crc_t10dif function all to use crypto
 transform framework
Date: Mon, 29 Apr 2013 13:40:30 -0700
Message-ID: <1367268030.27102.172.camel@schen9-DESK>
References: <cover.1366214842.git.tim.c.chen@linux.intel.com>
	 <ea4271721b5ca130849b03da4f172f12f66e5628.1366214842.git.tim.c.chen@linux.intel.com>
	 <20130425132203.GA29501@gondor.apana.org.au>
	 <1366910910.27102.126.camel@schen9-DESK>
	 <20130426125224.GA4855@gondor.apana.org.au>
	 <1366994657.27102.129.camel@schen9-DESK>
	 <20130428001122.GA6973@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20130428001122.GA6973@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2013-04-28 at 08:11 +0800, Herbert Xu wrote:
> On Fri, Apr 26, 2013 at 09:44:17AM -0700, Tim Chen wrote:
> >
> > +	old_tfm = crct10dif_tfm;
> > +	crc_t10dif_newalg = true;
> > +	/* make sure new alg flag is turned on before starting to switch tfm */
> > +	mb();
> > +
> > +	new_tfm = crypto_alloc_shash("crct10dif", 0, 0);
> > +	if (IS_ERR(new_tfm))
> > +		goto done;
> > +
> > +	if (old_tfm)
> > +		if (crypto_tfm_alg_priority(&old_tfm->base) >=
> > +		    crypto_tfm_alg_priority(&new_tfm->base)) {
> > +			crypto_free_shash(new_tfm);
> > +			goto done;
> > +		}
> > +	crct10dif_tfm = new_tfm;
> > +	/* make sure update to tfm pointer is completed */
> > +	mb();
> > +	crypto_free_shash(old_tfm);
> 
> This is not safe at all.  You'd need to use something like RCU.
> 
> However, I think this is an overkill.  Initialising it once should
> be enough.  If someone really wanted to change things at run-time,
> they could always build this as a module and unload/reload it.
> 

If I allocate the transform under the mod init instead, how can I make
sure that the fast version is already registered if I have it compiled
in?  It is not clear to me how that's done looking at the libcrc32c
code.  

Thanks.

Tim
