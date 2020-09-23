Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68131C4727D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 06:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 326DD2388B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 06:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgIWGgr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:36:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:44740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgIWGgq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 02:36:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 162AAAA55;
        Wed, 23 Sep 2020 06:37:21 +0000 (UTC)
Subject: Re: [PATCH V3 for 5.11 04/12] sbitmap: move allocation hint into
 sbitmap
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20200923013339.1621784-1-ming.lei@redhat.com>
 <20200923013339.1621784-5-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <351a36ab-a26c-6042-818d-28e167eb74e0@suse.de>
Date:   Wed, 23 Sep 2020 08:36:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923013339.1621784-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/20 3:33 AM, Ming Lei wrote:
> Allocation hint should have belonged to sbitmap, also when sbitmap's
> depth is high and no need to use mulitple wakeup queues, user can
> benefit from percpu allocation hint too.
> 
> So move allocation hint into sbitmap.
> 
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-mq.c          |   2 +-
>   block/kyber-iosched.c   |   2 +-
>   include/linux/sbitmap.h |  41 ++++++++------
>   lib/sbitmap.c           | 115 ++++++++++++++++++++++++----------------
>   4 files changed, 97 insertions(+), 63 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 45149970b891..88154cea83d8 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2684,7 +2684,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set *set,
>   		goto free_cpumask;
>   
>   	if (sbitmap_init_node(&hctx->ctx_map, nr_cpu_ids, ilog2(8),
> -				gfp, node, false))
> +				gfp, node, false, false))
>   		goto free_ctxs;
>   	hctx->nr_ctx = 0;
>   
> diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
> index cc8bcfe1d587..3949d68ac4c1 100644
> --- a/block/kyber-iosched.c
> +++ b/block/kyber-iosched.c
> @@ -480,7 +480,7 @@ static int kyber_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
>   	for (i = 0; i < KYBER_NUM_DOMAINS; i++) {
>   		if (sbitmap_init_node(&khd->kcq_map[i], hctx->nr_ctx,
>   				      ilog2(8), GFP_KERNEL, hctx->numa_node,
> -				      false)) {
> +				      false, false)) {
>   			while (--i >= 0)
>   				sbitmap_free(&khd->kcq_map[i]);
>   			goto err_kcqs;
> diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
> index 68097b052ec3..103b41c03311 100644
> --- a/include/linux/sbitmap.h
> +++ b/include/linux/sbitmap.h
> @@ -70,6 +70,14 @@ struct sbitmap {
>   	 * @map: Allocated bitmap.
>   	 */
>   	struct sbitmap_word *map;
> +
> +	/*
> +	 * @alloc_hint: Cache of last successfully allocated or freed bit.
> +	 *
> +	 * This is per-cpu, which allows multiple users to stick to different
> +	 * cachelines until the map is exhausted.
> +	 */
> +	unsigned int __percpu *alloc_hint;
>   };
>   
>   #define SBQ_WAIT_QUEUES 8
> @@ -105,14 +113,6 @@ struct sbitmap_queue {
>   	 */
>   	struct sbitmap sb;
>   
> -	/*
> -	 * @alloc_hint: Cache of last successfully allocated or freed bit.
> -	 *
> -	 * This is per-cpu, which allows multiple users to stick to different
> -	 * cachelines until the map is exhausted.
> -	 */
> -	unsigned int __percpu *alloc_hint;
> -
>   	/**
>   	 * @wake_batch: Number of bits which must be freed before we wake up any
>   	 * waiters.
> @@ -152,11 +152,13 @@ struct sbitmap_queue {
>    * @round_robin: If true, be stricter about allocation order; always allocate
>    *               starting from the last allocated bit. This is less efficient
>    *               than the default behavior (false).
> + * @alloc_hint: If true, apply percpu hint for where to start searching for
> + * 		a free bit.
>    *
>    * Return: Zero on success or negative errno on failure.
>    */
>   int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
> -		      gfp_t flags, int node, bool round_robin);
> +		      gfp_t flags, int node, bool round_robin, bool alloc_hint);
>   
>   /**
>    * sbitmap_free() - Free memory used by a &struct sbitmap.
> @@ -164,6 +166,7 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
>    */
>   static inline void sbitmap_free(struct sbitmap *sb)
>   {
> +	free_percpu(sb->alloc_hint);
>   	kfree(sb->map);
>   	sb->map = NULL;
>   }
> @@ -181,19 +184,17 @@ void sbitmap_resize(struct sbitmap *sb, unsigned int depth);
>   /**
>    * sbitmap_get() - Try to allocate a free bit from a &struct sbitmap.
>    * @sb: Bitmap to allocate from.
> - * @alloc_hint: Hint for where to start searching for a free bit.
>    *
>    * This operation provides acquire barrier semantics if it succeeds.
>    *
>    * Return: Non-negative allocated bit number if successful, -1 otherwise.
>    */
> -int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint);
> +int sbitmap_get(struct sbitmap *sb);
>   
>   /**
>    * sbitmap_get_shallow() - Try to allocate a free bit from a &struct sbitmap,
>    * limiting the depth used from each word.
>    * @sb: Bitmap to allocate from.
> - * @alloc_hint: Hint for where to start searching for a free bit.
>    * @shallow_depth: The maximum number of bits to allocate from a single word.
>    *
>    * This rather specific operation allows for having multiple users with
> @@ -205,8 +206,7 @@ int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint);
>    *
>    * Return: Non-negative allocated bit number if successful, -1 otherwise.
>    */
> -int sbitmap_get_shallow(struct sbitmap *sb, unsigned int alloc_hint,
> -			unsigned long shallow_depth);
> +int sbitmap_get_shallow(struct sbitmap *sb, unsigned long shallow_depth);
>   
>   /**
>    * sbitmap_any_bit_set() - Check for a set bit in a &struct sbitmap.
> @@ -320,6 +320,18 @@ static inline void sbitmap_deferred_clear_bit(struct sbitmap *sb, unsigned int b
>   	set_bit(SB_NR_TO_BIT(sb, bitnr), addr);
>   }
>   
> +/*
> + * Pair of sbitmap_get, and this one applies both cleared bit and
> + * allocation hint.
> + */
> +static inline void sbitmap_put(struct sbitmap *sb, unsigned int bitnr)
> +{
> +	sbitmap_deferred_clear_bit(sb, bitnr);
> +
> +	if (likely(sb->alloc_hint && !sb->round_robin && bitnr < sb->depth))
> +                *this_cpu_ptr(sb->alloc_hint) = bitnr;
> +}
> +
>   static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
>   {
>   	return test_bit(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
> @@ -368,7 +380,6 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq, unsigned int depth,
>   static inline void sbitmap_queue_free(struct sbitmap_queue *sbq)
>   {
>   	kfree(sbq->ws);
> -	free_percpu(sbq->alloc_hint);
>   	sbitmap_free(&sbq->sb);
>   }
>   
> diff --git a/lib/sbitmap.c b/lib/sbitmap.c
> index 4e4423414f4d..16f59e99143e 100644
> --- a/lib/sbitmap.c
> +++ b/lib/sbitmap.c
> @@ -9,52 +9,51 @@
>   #include <linux/sbitmap.h>
>   #include <linux/seq_file.h>
>   
> -static int init_alloc_hint(struct sbitmap_queue *sbq, gfp_t flags)
> +static int init_alloc_hint(struct sbitmap *sb, gfp_t flags)
>   {
> -	unsigned depth = sbq->sb.depth;
> +	unsigned depth = sb->depth;
>   
> -	sbq->alloc_hint = alloc_percpu_gfp(unsigned int, flags);
> -	if (!sbq->alloc_hint)
> +	sb->alloc_hint = alloc_percpu_gfp(unsigned int, flags);
> +	if (!sb->alloc_hint)
>   		return -ENOMEM;
>   
> -	if (depth && !sbq->sb.round_robin) {
> +	if (depth && !sb->round_robin) {
>   		int i;
>   
>   		for_each_possible_cpu(i)
> -			*per_cpu_ptr(sbq->alloc_hint, i) = prandom_u32() % depth;
> +			*per_cpu_ptr(sb->alloc_hint, i) = prandom_u32() % depth;
>   	}
> -
>   	return 0;
>   }
>   
> -static inline unsigned update_alloc_hint_before_get(struct sbitmap_queue *sbq,
> +static inline unsigned update_alloc_hint_before_get(struct sbitmap *sb,
>   						    unsigned int depth)
>   {
>   	unsigned hint;
>   
> -	hint = this_cpu_read(*sbq->alloc_hint);
> +	hint = this_cpu_read(*sb->alloc_hint);
>   	if (unlikely(hint >= depth)) {
>   		hint = depth ? prandom_u32() % depth : 0;
> -		this_cpu_write(*sbq->alloc_hint, hint);
> +		this_cpu_write(*sb->alloc_hint, hint);
>   	}
>   
>   	return hint;
>   }
>   
> -static inline void update_alloc_hint_after_get(struct sbitmap_queue *sbq,
> +static inline void update_alloc_hint_after_get(struct sbitmap *sb,
>   					       unsigned int depth,
>   					       unsigned int hint,
>   					       unsigned int nr)
>   {
>   	if (nr == -1) {
>   		/* If the map is full, a hint won't do us much good. */
> -		this_cpu_write(*sbq->alloc_hint, 0);
> -	} else if (nr == hint || unlikely(sbq->sb.round_robin)) {
> +		this_cpu_write(*sb->alloc_hint, 0);
> +	} else if (nr == hint || unlikely(sb->round_robin)) {
>   		/* Only update the hint if we used it. */
>   		hint = nr + 1;
>   		if (hint >= depth - 1)
>   			hint = 0;
> -		this_cpu_write(*sbq->alloc_hint, hint);
> +		this_cpu_write(*sb->alloc_hint, hint);
>   	}
>   }
>   
> @@ -91,7 +90,8 @@ static inline bool sbitmap_deferred_clear(struct sbitmap *sb, int index)
>   }
>   
>   int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
> -		      gfp_t flags, int node, bool round_robin)
> +		      gfp_t flags, int node, bool round_robin,
> +		      bool alloc_hint)
>   {
>   	unsigned int bits_per_word;
>   	unsigned int i;
> @@ -123,9 +123,18 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
>   		return 0;
>   	}
>   
> +	if (alloc_hint) {
> +		if (init_alloc_hint(sb, flags))
> +			return -ENOMEM;
> +	} else {
> +		sb->alloc_hint = NULL;
> +	}
> +
>   	sb->map = kcalloc_node(sb->map_nr, sizeof(*sb->map), flags, node);
> -	if (!sb->map)
> +	if (!sb->map) {
> +		free_percpu(sb->alloc_hint);
>   		return -ENOMEM;
> +	}
>   
>   	for (i = 0; i < sb->map_nr; i++) {
>   		sb->map[i].depth = min(depth, bits_per_word);
> @@ -204,7 +213,7 @@ static int sbitmap_find_bit_in_index(struct sbitmap *sb, int index,
>   	return nr;
>   }
>   
> -int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
> +static int __sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
>   {
>   	unsigned int i, index;
>   	int nr = -1;
> @@ -236,10 +245,29 @@ int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
>   
>   	return nr;
>   }
> +
> +int sbitmap_get(struct sbitmap *sb)
> +{
> +	int nr;
> +
> +	if (likely(sb->alloc_hint)) {
> +		unsigned int hint, depth;
> +
> +		depth = READ_ONCE(sb->depth);
> +		hint = update_alloc_hint_before_get(sb, depth);
> +		nr = __sbitmap_get(sb, hint);
> +		update_alloc_hint_after_get(sb, depth, hint, nr);
> +	} else {
> +		nr = __sbitmap_get(sb, 0);
> +	}
> +
> +	return nr;
> +}
>   EXPORT_SYMBOL_GPL(sbitmap_get);
>   
Can't you move the 'alloc_hint' test into update_alloc_hint_before_get()?
That way we can simplify the code and would avoid the 'if' clause here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
