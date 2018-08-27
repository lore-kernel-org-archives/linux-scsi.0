From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] crc-t10dif: Pick better transform if one becomes
 available
Date: Mon, 27 Aug 2018 14:13:26 +0800
Message-ID: <20180827061326.oqclv2sncoayt3al@gondor.apana.org.au>
References: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
 <20180826024006.13800-1-martin.petersen@oracle.com>
 <20180826024006.13800-2-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180826024006.13800-2-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff.Lien@wdc.com, ard.biesheuvel@linaro.org, david.darrington@wdc.com, hch@infradead.org, jeff.furlong@wdc.com, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tim.c.chen@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 25, 2018 at 07:40:04PM -0700, Martin K. Petersen wrote:
>
> +static int crc_t10dif_rehash(struct notifier_block *self, unsigned long val, void *data)
> +{
> +	struct crypto_alg *alg = data;
> +	struct crypto_shash *new, *old;
> +
> +	if (val != CRYPTO_MSG_ALG_LOADED ||
> +	    static_key_false(&crct10dif_fallback) ||
> +	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
> +		return 0;
> +
> +	spin_lock(&crc_t10dif_mutex);
> +	old = rcu_dereference_protected(crct10dif_tfm,
> +					lockdep_is_held(&crc_t10dif_mutex));
> +	if (!old) {
> +		spin_unlock(&crc_t10dif_mutex);
> +		return 0;
> +	}
> +	new = crypto_alloc_shash("crct10dif", 0, 0);

You cannot allocate crypto tfm objects while holding a spin lock
because they need to allocate memory with GFP_KERNEL.

How about using a mutex?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
