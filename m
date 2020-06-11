Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481CFC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 13:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2968120691
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 13:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgFKNQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 09:16:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:37300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgFKNQf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 09:16:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 55B51ADAA;
        Thu, 11 Jun 2020 13:16:34 +0000 (UTC)
Subject: Re: [PATCH RFC v7 06/12] blk-mq: Record active_queues_shared_sbitmap
 per tag_set for when using shared sbitmap
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, ming.lei@redhat.com, bvanassche@acm.org,
        hare@suse.com, hch@lst.de, shivasharan.srikanteshwara@broadcom.com
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-7-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a10a20de-d8e2-8505-65ec-1c26bfbf6cfc@suse.de>
Date:   Thu, 11 Jun 2020 15:16:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591810159-240929-7-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/10/20 7:29 PM, John Garry wrote:
> For when using a shared sbitmap, no longer should the number of active
> request queues per hctx be relied on for when judging how to share the tag
> bitmap.
> 
> Instead maintain the number of active request queues per tag_set, and make
> the judgment based on that.
> 
> And since the blk_mq_tags.active_queues is no longer maintained, do not
> show it in debugfs.
> 
> Originally-from: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   block/blk-mq-debugfs.c | 25 ++++++++++++++++++++--
>   block/blk-mq-tag.c     | 47 ++++++++++++++++++++++++++++++++----------
>   block/blk-mq.c         |  2 ++
>   include/linux/blk-mq.h |  1 +
>   include/linux/blkdev.h |  1 +
>   5 files changed, 63 insertions(+), 13 deletions(-)
> 
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 0fa3af41ab65..05b4be0c03d9 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -458,17 +458,37 @@ static void blk_mq_debugfs_tags_show(struct seq_file *m,
>   	}
>   }
>   
> +static void blk_mq_debugfs_tags_shared_sbitmap_show(struct seq_file *m,
> +				     struct blk_mq_tags *tags)
> +{
> +	seq_printf(m, "nr_tags=%u\n", tags->nr_tags);
> +	seq_printf(m, "nr_reserved_tags=%u\n", tags->nr_reserved_tags);
> +
> +	seq_puts(m, "\nbitmap_tags:\n");
> +	sbitmap_queue_show(tags->bitmap_tags, m);
> +
> +	if (tags->nr_reserved_tags) {
> +		seq_puts(m, "\nbreserved_tags:\n");
> +		sbitmap_queue_show(tags->breserved_tags, m);
> +	}
> +}
> +
>   static int hctx_tags_show(void *data, struct seq_file *m)
>   {
>   	struct blk_mq_hw_ctx *hctx = data;
>   	struct request_queue *q = hctx->queue;
> +	struct blk_mq_tag_set *set = q->tag_set;
>   	int res;
>   
>   	res = mutex_lock_interruptible(&q->sysfs_lock);
>   	if (res)
>   		goto out;
> -	if (hctx->tags)
> -		blk_mq_debugfs_tags_show(m, hctx->tags);
> +	if (hctx->tags) {
> +		if (blk_mq_is_sbitmap_shared(set))
> +			blk_mq_debugfs_tags_shared_sbitmap_show(m, hctx->tags);
> +		else
> +			blk_mq_debugfs_tags_show(m, hctx->tags);
> +	}
>   	mutex_unlock(&q->sysfs_lock);
>   
>   out:
> @@ -802,6 +822,7 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_hctx_shared_sbitmap_attrs
>   	{"dispatch", 0400, .seq_ops = &hctx_dispatch_seq_ops},
>   	{"busy", 0400, hctx_busy_show},
>   	{"ctx_map", 0400, hctx_ctx_map_show},
> +	{"tags", 0400, hctx_tags_show},
>   	{"sched_tags", 0400, hctx_sched_tags_show},
>   	{"sched_tags_bitmap", 0400, hctx_sched_tags_bitmap_show},
>   	{"io_poll", 0600, hctx_io_poll_show, hctx_io_poll_write},

I had been pondering this, too, when creating v6. Problem is that it'll 
show the tags per hctx, but as they are shared I guess the list looks 
pretty identical per hctx.
So I guess we should filter the tags per hctx to have only those active 
on that hctx displayed. But when doing so we can only print the 
in-flight tags, the others are not assigned to a hctx and as such we 
can't make a decision on which hctx they'll end up.

> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 7db16e49f6f6..6ca06b1c3a99 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -23,9 +23,19 @@
>    */
>   bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>   {
> -	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
> -	    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> -		atomic_inc(&hctx->tags->active_queues);
> +	struct request_queue *q = hctx->queue;
> +	struct blk_mq_tag_set *set = q->tag_set;
> +
> +	if (blk_mq_is_sbitmap_shared(set)){
> +		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
> +		    !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
> +			atomic_inc(&set->active_queues_shared_sbitmap);
> +
> +	} else {
> +		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
> +		    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> +			atomic_inc(&hctx->tags->active_queues);
> +	}
>   
>   	return true;
>   }
At one point someone would need to educate me what this double 
'test_bit' and 'test_and_set_bit' is supposed to achieve.
Other than deliberately injecting a race condition ...

> @@ -47,11 +57,19 @@ void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool include_reserve)
>   void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>   {
>   	struct blk_mq_tags *tags = hctx->tags;
> -
> -	if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> -		return;
> -
> -	atomic_dec(&tags->active_queues);
> +	struct request_queue *q = hctx->queue;
> +	struct blk_mq_tag_set *set = q->tag_set;
> +
> +	if (blk_mq_is_sbitmap_shared(q->tag_set)){
> +		if (!test_and_clear_bit(QUEUE_FLAG_HCTX_ACTIVE,
> +					&q->queue_flags))
> +			return;
> +		atomic_dec(&set->active_queues_shared_sbitmap);
> +	} else {
> +		if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> +			return;
> +		atomic_dec(&tags->active_queues);
> +	}
>   
>   	blk_mq_tag_wakeup_all(tags, false);
>   }
> @@ -65,12 +83,11 @@ static inline bool hctx_may_queue(struct blk_mq_alloc_data *data,
>   {
>   	struct blk_mq_hw_ctx *hctx = data->hctx;
>   	struct request_queue *q = data->q;
> +	struct blk_mq_tag_set *set = q->tag_set;
>   	unsigned int depth, users;
>   
>   	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
>   		return true;
> -	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> -		return true;
>   
>   	/*
>   	 * Don't try dividing an ant
> @@ -78,7 +95,15 @@ static inline bool hctx_may_queue(struct blk_mq_alloc_data *data,
>   	if (bt->sb.depth == 1)
>   		return true;
>   
> -	users = atomic_read(&hctx->tags->active_queues);
> +	if (blk_mq_is_sbitmap_shared(q->tag_set)) {
> +		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &q->queue_flags))
> +			return true;
> +		users = atomic_read(&set->active_queues_shared_sbitmap);
> +	} else {
> +		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> +			return true;
> +		users = atomic_read(&hctx->tags->active_queues);
> +	}
>   	if (!users)
>   		return true;
>   
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 0f7e062a1665..f73a2f9c58bd 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3350,6 +3350,8 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>   		goto out_free_mq_map;
>   
>   	if (blk_mq_is_sbitmap_shared(set)) {
> +		atomic_set(&set->active_queues_shared_sbitmap, 0);
> +
>   		if (!blk_mq_init_shared_sbitmap(set)) {
>   			ret = -ENOMEM;
>   			goto out_free_mq_rq_maps;
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 7b31cdb92a71..66711c7234db 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -252,6 +252,7 @@ struct blk_mq_tag_set {
>   	unsigned int		timeout;
>   	unsigned int		flags;
>   	void			*driver_data;
> +	atomic_t		active_queues_shared_sbitmap;
>   
>   	struct sbitmap_queue	__bitmap_tags;
>   	struct sbitmap_queue	__breserved_tags;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c536278bec9e..1b0087e8d01a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -619,6 +619,7 @@ struct request_queue {
>   #define QUEUE_FLAG_PCI_P2PDMA	25	/* device supports PCI p2p requests */
>   #define QUEUE_FLAG_ZONE_RESETALL 26	/* supports Zone Reset All */
>   #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
> +#define QUEUE_FLAG_HCTX_ACTIVE 28	/* at least one blk-mq hctx is active */
>   
>   #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>   				 (1 << QUEUE_FLAG_SAME_COMP))
> 
Other than that it looks fine.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
