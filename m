From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] SG: Move functions to lib/scatterlist.c and add sg chaining allocator helpers
Date: Fri, 21 Dec 2007 20:15:36 +0800
Message-ID: <E1J5gmu-0000JP-00@gondolin.me.apana.org.au>
References: <476A7566.2040802@panasas.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762281AbXLUMQW@vger.kernel.org>
In-Reply-To: <476A7566.2040802@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: jens.axboe@oracle.com, James.Bottomley@steeleye.com, akpm@linux-foundation.org, rusty@rustcorp.com.au, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 416e000..c3ca848 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -7,6 +7,12 @@
> #include <linux/string.h>
> #include <asm/io.h>
> 
> +struct sg_table {
> +       struct scatterlist *sgl;        /* the list */
> +       unsigned int nents;             /* number of mapped entries */
> +       unsigned int orig_nents;        /* original size of list */
> +};

If we're making massive changes like this, let's do it properly
as Rusty has demonstrated so that we support back-chaining as
well as frong-chaining.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
