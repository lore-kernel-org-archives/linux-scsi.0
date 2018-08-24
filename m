From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 24 Aug 2018 22:54:26 +0100
Message-ID: <CAKv+Gu8dMBUKmw+5rxWoiRKXngPeAsNyXzOY-nZwd3GPi1S5FA@mail.gmail.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
 <yq1in4gq5jf.fsf@oracle.com> <yq1lg8zb2lp.fsf@oracle.com> <20180822062016.GA10356@infradead.org>
 <SN1PR04MB18241CBDC8E4CA5275EE4424EA360@SN1PR04MB1824.namprd04.prod.outlook.com>
 <CAKv+Gu-RwCrdgW69NVpyRLwGPGPCZx+ksTBM7NZk7v0-dzczGg@mail.gmail.com>
 <yq1a7pb9196.fsf@oracle.com> <CAKv+Gu8Y7YmyB5rmxaj-SGB7q03in7ijv2cOifwYnhP5CNastw@mail.gmail.com>
 <yq1tvnj780o.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1tvnj780o.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeffrey Lien <Jeff.Lien@wdc.com>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 24 August 2018 at 22:46, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Ard,
>
>> I'd prefer to handle this without help from userland.
>>
>> It shouldn't be too difficult to register a module notifier that only
>> sets a flag (or the static key, even?), and to free and re-allocate
>> the crc_t10dif transform if the flag is set.
>
> Something like this proof of concept?
>
> diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
> index 1ad33e555805..87d0e8f0794a 100644
> --- a/lib/crc-t10dif.c
> +++ b/lib/crc-t10dif.c
> @@ -15,10 +15,50 @@
>  #include <linux/init.h>
>  #include <crypto/hash.h>
>  #include <linux/static_key.h>
> +#include <linux/notifier.h>
>
>  static struct crypto_shash *crct10dif_tfm;
>  static struct static_key crct10dif_fallback __read_mostly;
>
> +static void crc_t10dif_print(void)
> +{
> +       if (static_key_false(&crct10dif_fallback))
> +               pr_info("CRC T10 DIF calculated using library function\n");
> +       else
> +               pr_info("CRC T10 DIF calculated using crypto hash %s\n",
> +                       crypto_tfm_alg_driver_name(crypto_shash_tfm(crct10dif_tfm)));
> +}
> +
> +static int crc_t10dif_rehash(struct notifier_block *self, unsigned long val, void *data)
> +{
> +#ifdef CONFIG_MODULES
> +       struct module *mod = data;
> +
> +       if (val != MODULE_STATE_LIVE ||
> +           strncmp(mod->name, "crct10dif", strlen("crct10dif")))
> +               return 0;
> +
> +       /* Fall back to library function while we replace the tfm */
> +       static_key_slow_inc(&crct10dif_fallback);
> +
> +       crypto_free_shash(crct10dif_tfm);
> +       crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
> +       if (IS_ERR(crct10dif_tfm)) {
> +               crct10dif_tfm = NULL;
> +               goto out;
> +       }
> +
> +       static_key_slow_dec(&crct10dif_fallback);
> +out:
> +       crc_t10dif_print();
> +       return 0;
> +#endif /* CONFIG_MODULES */
> +}
> +
> +static struct notifier_block crc_t10dif_nb = {
> +       .notifier_call = crc_t10dif_rehash,
> +};
> +
>  __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
>  {
>         struct {
> @@ -49,16 +90,21 @@ EXPORT_SYMBOL(crc_t10dif);
>
>  static int __init crc_t10dif_mod_init(void)
>  {
> +       register_module_notifier(&crc_t10dif_nb);
> +
>         crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
>         if (IS_ERR(crct10dif_tfm)) {
>                 static_key_slow_inc(&crct10dif_fallback);
>                 crct10dif_tfm = NULL;
>         }
> +
> +       crc_t10dif_print();
>         return 0;
>  }
>
>  static void __exit crc_t10dif_mod_fini(void)
>  {
> +       unregister_module_notifier(&crc_t10dif_nb);
>         crypto_free_shash(crct10dif_tfm);
>  }
>

This looks like it should work, yes. It does rely on the module name
to start with 'crct10dif' but I guess that is reasonable, and matches
the current state on all architectures.

Anyone care to boot test this? Jeffrey?
