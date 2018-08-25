From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Sat, 25 Aug 2018 14:12:05 +0800
Message-ID: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
 <yq1in4gq5jf.fsf@oracle.com>
 <yq1lg8zb2lp.fsf@oracle.com>
 <20180822062016.GA10356@infradead.org>
 <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
 <CAKv+Gu-RwCrdgW69NVpyRLwGPGPCZx+ksTBM7NZk7v0-dzczGg@mail.gmail.com>
 <yq1a7pb9196.fsf@oracle.com>
 <CAKv+Gu8Y7YmyB5rmxaj-SGB7q03in7ijv2cOifwYnhP5CNastw@mail.gmail.com>
 <yq1tvnj780o.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1tvnj780o.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeffrey Lien <Jeff.Lien@wdc.com>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 24, 2018 at 05:46:15PM -0400, Martin K. Petersen wrote:
>
> +#ifdef CONFIG_MODULES
> +	struct module *mod = data;
> +
> +	if (val != MODULE_STATE_LIVE ||
> +	    strncmp(mod->name, "crct10dif", strlen("crct10dif")))
> +		return 0;
> +
> +	/* Fall back to library function while we replace the tfm */
> +	static_key_slow_inc(&crct10dif_fallback);
> +
> +	crypto_free_shash(crct10dif_tfm);
> +	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
> +	if (IS_ERR(crct10dif_tfm)) {
> +		crct10dif_tfm = NULL;
> +		goto out;
> +	}
> +
> +	static_key_slow_dec(&crct10dif_fallback);

I don't think this is safe unless you do some kind of locking
which would slow down the data path.  The easiest fix would be
to keep the old tfm around forever, or use RCU if RCU read locking
is acceptable to your use-case.

We already have a notifier mechanism in the crypto API for algorithm
registration events.  However, it currently only notifies for untested
algorithms.  So we need to add an event for tested algorithms and also
export this for use outside of the crypto API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
