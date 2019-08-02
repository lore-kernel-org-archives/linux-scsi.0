From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/8] block: Add encryption context to struct
 bio
Date: Fri, 2 Aug 2019 13:46:45 -0700
Message-ID: <7856ad79-6224-532d-ff9f-50ffc00f7203@kernel.dk>
References: <20190710225609.192252-1-satyat@google.com>
 <20190710225609.192252-3-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190710225609.192252-3-satyat@google.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Satya Tangirala <satyat@google.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: Kuohong Wang <kuohong.wang@mediatek.com>, Ladvine D Almeida <ladvine.dalmeida@synopsys.com>, Barani Muthukumaran <bmuthuku@qti.qualcomm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Parshuram Raju Thombare <pthombar@cadence.com>
List-Id: linux-scsi@vger.kernel.org

On 7/10/19 4:56 PM, Satya Tangirala wrote:
> We must have some way of letting a storage device driver know what
> encryption context it should use for en/decrypting a request. However,
> it's the filesystem/fscrypt that knows about and manages encryption
> contexts. As such, when the filesystem layer submits a bio to the block
> layer, and this bio eventually reaches a device driver with support for
> inline encryption, the device driver will need to have been told the
> encryption context for that bio.
> 
> We want to communicate the encryption context from the filesystem layer
> to the storage device along with the bio, when the bio is submitted to the
> block layer. To do this, we add a struct bio_crypt_ctx to struct bio, which
> can represent an encryption context (note that we can't use the bi_private
> field in struct bio to do this because that field does not function to pass
> information across layers in the storage stack). We also introduce various
> functions to manipulate the bio_crypt_ctx and make the bio/request merging
> logic aware of the bio_crypt_ctx.

A few minor comments below. Don't see something totally horrible with
your approach.


> diff --git a/block/bio-crypt-ctx.c b/block/bio-crypt-ctx.c
> new file mode 100644
> index 000000000000..8b884ef32007
> --- /dev/null
> +++ b/block/bio-crypt-ctx.c
> @@ -0,0 +1,117 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2019 Google LLC
> + */
> +
> +#include <linux/bio.h>
> +#include <linux/blkdev.h>
> +#include <linux/slab.h>
> +#include <linux/keyslot-manager.h>
> +
> +struct bio_crypt_ctx *bio_crypt_alloc_ctx(gfp_t gfp_mask)
> +{
> +	return kzalloc(sizeof(struct bio_crypt_ctx), gfp_mask);
> +}

I think you'll want this to be mempool backed.

> +EXPORT_SYMBOL(bio_crypt_alloc_ctx);
> +
> +void bio_crypt_free_ctx(struct bio *bio)
> +{
> +	kzfree(bio->bi_crypt_context);
> +	bio->bi_crypt_context = NULL;
> +}
> +EXPORT_SYMBOL(bio_crypt_free_ctx);
> +
> +int bio_crypt_clone(struct bio *dst, struct bio *src, gfp_t gfp_mask)
> +{
> +	if (!bio_is_encrypted(src))
> +		return 0;

Was going to suggest dumping this helper, but that won't work for the
case where inline encryption isn't enabled. How about renaming it so it
is easier to grok what it tests, bio_has_crypt_ctx() or something like
that.

> +	dst->bi_crypt_context = bio_crypt_alloc_ctx(gfp_mask);
> +	if (!dst->bi_crypt_context)
> +		return -ENOMEM;

That's why you need the mempool...

> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 17713d7d98d5..f416e7f38270 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -531,6 +531,9 @@ static inline int ll_new_hw_segment(struct request_queue *q,
>   	if (blk_integrity_merge_bio(q, req, bio) == false)
>   		goto no_merge;
>   
> +	if (WARN_ON(!bio_crypt_ctx_compatible(bio, req->bio)))
> +		goto no_merge;

This is really a debug check, as that shouldn't happen unless you have a
bug in your merge helpers. I think we can do one of two things here:

1) Rely on this check only for merging, similarly to what the integrity
   code does. This means the WARN() goes away and (most of) the  other
   merge checks can go away.

2) Keep it, but change it to a WARN_ON_ONCE().

> @@ -696,8 +699,13 @@ static enum elv_merge blk_try_req_merge(struct request *req,
>   {
>   	if (blk_discard_mergable(req))
>   		return ELEVATOR_DISCARD_MERGE;
> -	else if (blk_rq_pos(req) + blk_rq_sectors(req) == blk_rq_pos(next))
> +	else if (blk_rq_pos(req) + blk_rq_sectors(req) == blk_rq_pos(next)) {
> +		if (!bio_crypt_ctx_back_mergeable(
> +			req->bio, blk_rq_sectors(req), next->bio)) {
> +			return ELEVATOR_NO_MERGE;
> +		}
>   		return ELEVATOR_BACK_MERGE;
> +	}

Weird line breaks aside, see above comment. More in this file.

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index ef9c6e2e92bc..4e664d6441d5 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -572,6 +572,196 @@ enum blk_crypt_mode_num {
>   	 */
>   };
>   
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +struct bio_crypt_ctx {
> +	int keyslot;
> +	u8 *raw_key;
> +	enum blk_crypt_mode_num crypt_mode;
> +	u64 data_unit_num;
> +	unsigned int data_unit_size_bits;
> +
> +	/*
> +	 * The keyslot manager where the key has been programmed
> +	 * with keyslot.
> +	 */
> +	struct keyslot_manager *processing_ksm;
> +
> +	/*
> +	 * Copy of the bvec_iter when this bio was submitted.
> +	 * We only want to en/decrypt the part of the bio
> +	 * as described by the bvec_iter upon submission because
> +	 * bio might be split before being resubmitted
> +	 */
> +	struct bvec_iter crypt_iter;
> +	u64 sw_data_unit_num;
> +};

[snip]

Let's move that to a separate file, with the other crypt specific bits.
Just include it from bio.h.


> +static inline u64 bio_crypt_data_unit_num(struct bio *bio)
> +{
> +	WARN_ON(!bio_is_encrypted(bio));
> +	return bio->bi_crypt_context->data_unit_num;
> +}
> +
> +static inline u64 bio_crypt_sw_data_unit_num(struct bio *bio)
> +{
> +	WARN_ON(!bio_is_encrypted(bio));
> +	return bio->bi_crypt_context->sw_data_unit_num;
> +}

These WARN()'s are a bit weird.

> +static inline u64 bio_crypt_data_unit_num(struct bio *bio)
> +{
> +	WARN_ON(1);
> +	return 0;
> +}

And this one definitely needs to go.

> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 95202f80676c..0b794fe3530a 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -137,6 +137,8 @@ static inline void bio_issue_init(struct bio_issue *issue,
>   			((u64)size << BIO_ISSUE_SIZE_SHIFT));
>   }
>   
> +struct bio_crypt_ctx;

Place this with the other forward declarations.

-- 
Jens Axboe
