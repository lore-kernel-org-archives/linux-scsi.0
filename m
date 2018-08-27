From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: Introduce notifier for new crypto algorithms
Date: Mon, 27 Aug 2018 14:09:19 +0800
Message-ID: <20180827060918.tfz7ljufqhlej4kq@gondor.apana.org.au>
References: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
 <20180826024006.13800-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180826024006.13800-1-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff.Lien@wdc.com, ard.biesheuvel@linaro.org, david.darrington@wdc.com, hch@infradead.org, jeff.furlong@wdc.com, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tim.c.chen@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 25, 2018 at 10:40:03PM -0400, Martin K. Petersen wrote:
>
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index c0755cf4f53f..87abad3cc322 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -361,15 +361,12 @@ static void crypto_wait_for_test(struct crypto_larval *larval)
>  	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
>  	if (err != NOTIFY_STOP) {
>  		if (WARN_ON(err != NOTIFY_DONE))
> -			goto out;
> +			return;
>  		crypto_alg_tested(larval->alg.cra_driver_name, 0);
>  	}
>  
>  	err = wait_for_completion_killable(&larval->completion);
>  	WARN_ON(err);
> -
> -out:
> -	crypto_larval_kill(&larval->alg);
>  }
>  
>  int crypto_register_alg(struct crypto_alg *alg)
> @@ -390,6 +387,8 @@ int crypto_register_alg(struct crypto_alg *alg)
>  		return PTR_ERR(larval);
>  
>  	crypto_wait_for_test(larval);
> +	crypto_probing_notify(CRYPTO_MSG_ALG_LOADED, larval);
> +	crypto_larval_kill(&larval->alg);

I see that you have moved the larval_kill call into the caller.
This is a problem because there are two callers to wait_for_test.

So it's probably best to leave it in wait_for_test and add the
notify there.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
