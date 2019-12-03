Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E68C43215
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 14:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83B7E2084B
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 14:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfLCOyd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 09:54:33 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2151 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfLCOyd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Dec 2019 09:54:33 -0500
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id EAC0FFFCF4A37B9566E2;
        Tue,  3 Dec 2019 14:54:31 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 3 Dec 2019 14:54:31 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5; Tue, 3 Dec 2019
 14:54:31 +0000
Subject: Re: [PATCH 04/11] blk-mq: Facilitate a shared sbitmap per tagset
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "James Bottomley" <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-5-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ab7555b2-2e95-6fb1-2e44-fe3a323a24e4@huawei.com>
Date:   Tue, 3 Dec 2019 14:54:30 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191202153914.84722-5-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml702-chm.china.huawei.com (10.201.108.51) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>   
> @@ -483,8 +483,8 @@ static int hctx_tags_bitmap_show(void *data, struct seq_file *m)
>   	res = mutex_lock_interruptible(&q->sysfs_lock);
>   	if (res)
>   		goto out;
> -	if (hctx->tags)
> -		sbitmap_bitmap_show(&hctx->tags->bitmap_tags.sb, m);
> +	if (hctx->tags) /* We should just iterate the relevant bits for this hctx FIXME */

Bart's solution to this problem seemed ok, if he doesn't mind us 
borrowing his idea:

https://lore.kernel.org/linux-block/5183ab13-0c81-95f0-95ba-40318569c6c6@huawei.com/T/#m24394fe70b1ea79a154dfd9620f5e553c3e7e7da

See hctx_tags_bitmap_show().

It might be also reasonable to put that in another follow on patch, as 
there would be no enablers of the "shared" bitmap until later patches.

> +		sbitmap_bitmap_show(&hctx->tags->bitmap_tags->sb, m);
>   	mutex_unlock(&q->sysfs_lock);
>   
>   out:
> @@ -518,7 +518,7 @@ static int hctx_sched_tags_bitmap_show(void *data, struct seq_file *m)
>   	if (res)
>   		goto out;
>   	if (hctx->sched_tags)
> -		sbitmap_bitmap_show(&hctx->sched_tags->bitmap_tags.sb, m);
> +		sbitmap_bitmap_show(&hctx->sched_tags->bitmap_tags->sb, m);
>   	mutex_unlock(&q->sysfs_lock);
>   
>   out:
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index ca22afd47b3d..1855f8f5edd4 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -492,6 +492,7 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
>   
>   int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>   {
> +	struct blk_mq_tag_set *tag_set = q->tag_set;
>   	struct blk_mq_hw_ctx *hctx;
>   	struct elevator_queue *eq;
>   	unsigned int i;
> @@ -537,6 +538,19 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>   		blk_mq_debugfs_register_sched_hctx(q, hctx);
>   	}
>   
> +	if (blk_mq_is_sbitmap_shared(tag_set)) {
> +		if (!blk_mq_init_sched_shared_sbitmap(tag_set, q->nr_requests)) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +		queue_for_each_hw_ctx(q, hctx, i) {
> +			struct blk_mq_tags *tags = hctx->sched_tags;
> +
> +			tags->bitmap_tags = &tag_set->__sched_bitmap_tags;
> +			tags->breserved_tags = &tag_set->__sched_breserved_tags;
> +		}
> +	}
> +
>   	return 0;
>   
>   err:
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index f5009587e1b5..2e714123e846 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -20,7 +20,7 @@ bool blk_mq_has_free_tags(struct blk_mq_tags *tags)
>   	if (!tags)
>   		return true;
>   
> -	return sbitmap_any_bit_clear(&tags->bitmap_tags.sb);
> +	return sbitmap_any_bit_clear(&tags->bitmap_tags->sb);
>   }
>   
>   /*
> @@ -43,9 +43,9 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>    */
>   void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool include_reserve)
>   {
> -	sbitmap_queue_wake_all(&tags->bitmap_tags);
> +	sbitmap_queue_wake_all(tags->bitmap_tags);
>   	if (include_reserve)
> -		sbitmap_queue_wake_all(&tags->breserved_tags);
> +		sbitmap_queue_wake_all(tags->breserved_tags);
>   }
>   
>   /*
> @@ -121,10 +121,10 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
>   			WARN_ON_ONCE(1);
>   			return BLK_MQ_TAG_FAIL;
>   		}
> -		bt = &tags->breserved_tags;
> +		bt = tags->breserved_tags;

We could put all of this in an earlier patch (as you had in v4, modulo 
dynamic memory part), which would be easier to review and get accepted.

>   		tag_offset = 0;
>   	} else {
> -		bt = &tags->bitmap_tags;
> +		bt = tags->bitmap_tags;
>   		tag_offset = tags->nr_reserved_tags;
>   	}


[...]

>   	if (!set)
> @@ -3160,6 +3179,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>   			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
>   							false);
>   		} else {
> +			sched_tags = true;
>   			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
>   							nr, true);
>   		}
> @@ -3169,8 +3189,43 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>   			q->elevator->type->ops.depth_updated(hctx);
>   	}
>   
> -	if (!ret)
> +	/*
> +	 * if ret is 0, all queues should have been updated to the same depth
> +	 * if not, then maybe some have been updated - yuk, need to handle this for shared sbitmap...
> +	 * if some are updated, we should probably roll back the change altogether. FIXME
> +	 */

If you don't have a shared sched bitmap - which I didn't think we needed 
- then all we need is a simple sbitmap_queue_resize(&tagset->__bitmap_tags)

Otherwise it's horrible to resize shared sched bitmaps...

> +	if (!ret) {
> +		if (blk_mq_is_sbitmap_shared(set)) {
> +			if (sched_tags) {
> +				blk_mq_exit_shared_sched_sbitmap(set);
> +				if (!blk_mq_init_sched_shared_sbitmap(set, nr))
> +					return -ENOMEM; /* fixup error handling */
> +
> +				queue_for_each_hw_ctx(q, hctx, i) {
> +					hctx->sched_tags->bitmap_tags =
> +						&set->__sched_bitmap_tags;
> +					hctx->sched_tags->breserved_tags =
> +						&set->__sched_breserved_tags;
> +				}
> +			} else {
> +				blk_mq_exit_shared_sbitmap(set);
> +				if (!blk_mq_init_shared_sbitmap(set))
> +					return -ENOMEM; /* fixup error handling */
> +
> +				queue_for_each_hw_ctx(q, hctx, i) {
> +					hctx->tags->bitmap_tags =
> +						&set->__bitmap_tags;
> +					hctx->tags->breserved_tags =
> +						&set->__breserved_tags;
> +				}
> +			}
> +		}
>   		q->nr_requests = nr;
> +	}
> +	/*
> +	 * if ret != 0, q->nr_requests would not be updated, yet the depth
> +	 * for some hctx may have changed - is that right?
> +	 */
>   
>   	blk_mq_unquiesce_queue(q);
>   	blk_mq_unfreeze_queue(q);
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 78d38b5f2793..4c1ea206d3f4 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -166,6 +166,11 @@ struct blk_mq_alloc_data {
>   	struct blk_mq_hw_ctx *hctx;
>   };
>   
> +static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set *tag_set)
> +{
> +	return !!(tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED);

Bart already gave some comments on this

> +}
> +
>   static inline struct blk_mq_tags *blk_mq_tags_from_data(struct blk_mq_alloc_data *data)
>   {
>   	if (data->flags & BLK_MQ_REQ_INTERNAL)
> diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
> index 34dcea0ef637..a7a537501d70 100644
> --- a/block/kyber-iosched.c
> +++ b/block/kyber-iosched.c
> @@ -359,7 +359,7 @@ static unsigned int kyber_sched_tags_shift(struct request_queue *q)
>   	 * All of the hardware queues have the same depth, so we can just grab
>   	 * the shift of the first one.
>   	 */
> -	return q->queue_hw_ctx[0]->sched_tags->bitmap_tags.sb.shift;
> +	return q->queue_hw_ctx[0]->sched_tags->bitmap_tags->sb.shift;
>   }
>   
>   static struct kyber_queue_data *kyber_queue_data_alloc(struct request_queue *q)
> @@ -502,7 +502,7 @@ static int kyber_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
>   	khd->batching = 0;
>   
>   	hctx->sched_data = khd;
> -	sbitmap_queue_min_shallow_depth(&hctx->sched_tags->bitmap_tags,
> +	sbitmap_queue_min_shallow_depth(hctx->sched_tags->bitmap_tags,
>   					kqd->async_depth);
>   
>   	return 0;
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 147185394a25..10c9ed3dbe80 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -109,6 +109,12 @@ struct blk_mq_tag_set {
>   	unsigned int		flags;		/* BLK_MQ_F_* */
>   	void			*driver_data;
>   
> +	struct sbitmap_queue	__bitmap_tags;
> +	struct sbitmap_queue	__breserved_tags;
> +
> +	struct sbitmap_queue	__sched_bitmap_tags;
> +	struct sbitmap_queue	__sched_breserved_tags;
> +
>   	struct blk_mq_tags	**tags;
>   
>   	struct mutex		tag_list_lock;
> @@ -226,6 +232,9 @@ struct blk_mq_ops {
>   enum {
>   	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
>   	BLK_MQ_F_TAG_QUEUE_SHARED	= 1 << 1,
> +	BLK_MQ_F_TAG_HCTX_SHARED	= 1 << 2,
> +	BLK_MQ_F_TAG_BITMAP_ALLOCATED	= 1 << 3,
> +	BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED = 1 << 4,
>   	BLK_MQ_F_BLOCKING	= 1 << 5,
>   	BLK_MQ_F_NO_SCHED	= 1 << 6,
>   	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
> 

