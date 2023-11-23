Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB3ED48;
	Wed, 22 Nov 2023 22:29:14 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SbSr44Tfkz4f3k5r;
	Thu, 23 Nov 2023 14:29:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 599AE1A045C;
	Thu, 23 Nov 2023 14:29:11 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgDX2xE18V5lzFjHBg--.1826S3;
	Thu, 23 Nov 2023 14:29:11 +0800 (CST)
Subject: Re: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
To: Bart Van Assche <bvanassche@acm.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231114180426.1184601-1-bvanassche@acm.org>
 <20231114180426.1184601-3-bvanassche@acm.org>
 <80dee412-2fda-6a23-0b62-08f87bd7e607@huaweicloud.com>
 <d706f265-f991-45c0-a551-34ecdee55f7c@acm.org>
 <d1e94a08-f28e-ddd9-5bda-7fee28b87f31@huaweicloud.com>
 <ef7de6b5-2ed3-469e-bb01-4eacda62cd6a@acm.org>
 <e5e8e995-c38b-7b23-a0a9-5b2f285164c8@huaweicloud.com>
 <5dd7b7f7-bcae-4769-b6c8-ac0da8e69c93@acm.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1b380cbf-40e9-6ba6-62da-d3aad94809d0@huaweicloud.com>
Date: Thu, 23 Nov 2023 14:29:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5dd7b7f7-bcae-4769-b6c8-ac0da8e69c93@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDX2xE18V5lzFjHBg--.1826S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuFW3CFWUJFW7GFy3JF43KFg_yoWfCFy7pF
	4ktFWUWry8tr1kXF4UGr1UXFy7Xr1UGw1UJr1xXa45Jr4Utr12qr18XryjgF18Jr4kGr4U
	Jr4UXrs8Zry7Xr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
	3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2023/11/22 3:32, Bart Van Assche 写道:
> On 11/20/23 17:35, Yu Kuai wrote:
>> I'm not sure that change just one queue instead of all queues using the
>> same tag_set won't case any regression, for example,
>> BLK_MQ_F_TAG_QUEUE_SHARED is not cleared, and other queues are still
>> sharing tags fairly while this queue doesn't.
>>
>> Perhaps can we add a helper similiar to __blk_mq_update_nr_hw_queues
>> to update all queues using the same tag_set?
> 
> Hi Kuai,
> 
> How about the patch below?

Thanks for the patch!
> 
> Thanks,
> 
> Bart.
> 
> 
> diff --git a/Documentation/ABI/stable/sysfs-block 
> b/Documentation/ABI/stable/sysfs-block
> index 1fe9a553c37b..7b66eb938882 100644
> --- a/Documentation/ABI/stable/sysfs-block
> +++ b/Documentation/ABI/stable/sysfs-block
> @@ -269,6 +269,19 @@ Description:
>           specific passthrough mechanisms.
> 
> 
> +What:        /sys/block/<disk>/queue/fair_sharing
> +Date:        November 2023
> +Contact:    linux-block@vger.kernel.org
> +Description:
> +        [RW] If hardware queues are shared across request queues, by
> +        default the request tags are distributed evenly across the
> +        active request queues. If the total number of tags is low and
> +        if the workload differs per request queue this approach may
> +        reduce throughput. This sysfs attribute controls whether or not
> +        the fair tag sharing algorithm is enabled. 1 means enabled
> +        while 0 means disabled.
> +
> +
>   What:        /sys/block/<disk>/queue/fua
>   Date:        May 2018
>   Contact:    linux-block@vger.kernel.org
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 5cbeb9344f2f..f41408103106 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -198,6 +198,7 @@ static const char *const hctx_flag_name[] = {
>       HCTX_FLAG_NAME(NO_SCHED),
>       HCTX_FLAG_NAME(STACKING),
>       HCTX_FLAG_NAME(TAG_HCTX_SHARED),
> +    HCTX_FLAG_NAME(DISABLE_FAIR_TAG_SHARING),
>   };
>   #undef HCTX_FLAG_NAME
> 
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index f75a9ecfebde..eda6bd0611ea 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -416,7 +416,8 @@ static inline bool hctx_may_queue(struct 
> blk_mq_hw_ctx *hctx,
>   {
>       unsigned int depth, users;
> 
> -    if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
> +    if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) ||
> +        (hctx->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING))
>           return true;
> 
>       /*
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 0b2d04766324..0009450dc8cf 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -24,6 +24,7 @@ struct queue_sysfs_entry {
>       struct attribute attr;
>       ssize_t (*show)(struct request_queue *, char *);
>       ssize_t (*store)(struct request_queue *, const char *, size_t);
> +    bool no_sysfs_mutex;
>   };
> 
>   static ssize_t
> @@ -473,6 +474,55 @@ static ssize_t queue_dax_show(struct request_queue 
> *q, char *page)
>       return queue_var_show(blk_queue_dax(q), page);
>   }
> 
> +static ssize_t queue_fair_sharing_show(struct request_queue *q, char 
> *page)
> +{
> +    struct blk_mq_hw_ctx *hctx;
> +    unsigned long i;
> +    bool fair_sharing = true;
> +
> +    /* Serialize against blk_mq_realloc_hw_ctxs() */
> +    mutex_lock(&q->sysfs_lock);
> +    queue_for_each_hw_ctx(q, hctx, i)
> +        if (hctx->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING)
> +            fair_sharing = false;
> +    mutex_unlock(&q->sysfs_lock);
> +
> +    return sysfs_emit(page, "%u\n", fair_sharing);
> +}
> +
> +static ssize_t queue_fair_sharing_store(struct request_queue *q,
> +                    const char *page, size_t count)
> +{
> +    const unsigned int DFTS_BIT = 
> ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
> +    struct blk_mq_tag_set *set = q->tag_set;
> +    struct blk_mq_hw_ctx *hctx;
> +    unsigned long i;
> +    int res;
> +    bool val;
> +
> +    res = kstrtobool(page, &val);
> +    if (res < 0)
> +        return res;
> +
> +    mutex_lock(&set->tag_list_lock);
> +    clear_bit(DFTS_BIT, &set->flags);
> +    list_for_each_entry(q, &set->tag_list, tag_set_list) {
> +        /* Serialize against blk_mq_realloc_hw_ctxs() */

If set/clear bit concurrent with test bit from io path, will there be
problem? Why don't freeze these queues?
> +        mutex_lock(&q->sysfs_lock);
> +        if (val) {
> +            queue_for_each_hw_ctx(q, hctx, i)
> +                clear_bit(DFTS_BIT, &hctx->flags);
> +        } else {
> +            queue_for_each_hw_ctx(q, hctx, i)
> +                set_bit(DFTS_BIT, &hctx->flags);
> +        }
> +        mutex_unlock(&q->sysfs_lock);
> +    }
> +    mutex_unlock(&set->tag_list_lock);
> +
> +    return count;
> +}
> +
>   #define QUEUE_RO_ENTRY(_prefix, _name)            \
>   static struct queue_sysfs_entry _prefix##_entry = {    \
>       .attr    = { .name = _name, .mode = 0444 },    \
> @@ -486,6 +536,14 @@ static struct queue_sysfs_entry _prefix##_entry = 
> {    \
>       .store    = _prefix##_store,            \
>   };
> 
> +#define QUEUE_RW_ENTRY_NO_SYSFS_MUTEX(_prefix, _name)       \
> +    static struct queue_sysfs_entry _prefix##_entry = { \
> +        .attr = { .name = _name, .mode = 0644 },    \
> +        .show = _prefix##_show,                     \
> +        .store = _prefix##_store,                   \
> +        .no_sysfs_mutex = true,                     \
> +    };
> +

This actually change all the queues from the same tagset, can we add
this new entry to /sys/class/scsi_host/hostx/xxx ?

Thanks,
Kuai

>   QUEUE_RW_ENTRY(queue_requests, "nr_requests");
>   QUEUE_RW_ENTRY(queue_ra, "read_ahead_kb");
>   QUEUE_RW_ENTRY(queue_max_sectors, "max_sectors_kb");
> @@ -542,6 +600,7 @@ QUEUE_RW_ENTRY(queue_nonrot, "rotational");
>   QUEUE_RW_ENTRY(queue_iostats, "iostats");
>   QUEUE_RW_ENTRY(queue_random, "add_random");
>   QUEUE_RW_ENTRY(queue_stable_writes, "stable_writes");
> +QUEUE_RW_ENTRY_NO_SYSFS_MUTEX(queue_fair_sharing, "fair_sharing");
> 
>   #ifdef CONFIG_BLK_WBT
>   static ssize_t queue_var_store64(s64 *var, const char *page)
> @@ -666,6 +725,7 @@ static struct attribute *blk_mq_queue_attrs[] = {
>       &elv_iosched_entry.attr,
>       &queue_rq_affinity_entry.attr,
>       &queue_io_timeout_entry.attr,
> +    &queue_fair_sharing_entry.attr,
>   #ifdef CONFIG_BLK_WBT
>       &queue_wb_lat_entry.attr,
>   #endif
> @@ -723,6 +783,10 @@ queue_attr_show(struct kobject *kobj, struct 
> attribute *attr, char *page)
> 
>       if (!entry->show)
>           return -EIO;
> +
> +    if (entry->no_sysfs_mutex)
> +        return entry->show(q, page);
> +
>       mutex_lock(&q->sysfs_lock);
>       res = entry->show(q, page);
>       mutex_unlock(&q->sysfs_lock);
> @@ -741,6 +805,9 @@ queue_attr_store(struct kobject *kobj, struct 
> attribute *attr,
>       if (!entry->store)
>           return -EIO;
> 
> +    if (entry->no_sysfs_mutex)
> +        return entry->store(q, page, length);
> +
>       mutex_lock(&q->sysfs_lock);
>       res = entry->store(q, page, length);
>       mutex_unlock(&q->sysfs_lock);
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 1ab3081c82ed..aadb74aa23a3 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -503,7 +503,7 @@ struct blk_mq_tag_set {
>       unsigned int        cmd_size;
>       int            numa_node;
>       unsigned int        timeout;
> -    unsigned int        flags;
> +    unsigned long        flags;
>       void            *driver_data;
> 
>       struct blk_mq_tags    **tags;
> @@ -662,7 +662,8 @@ enum {
>        * or shared hwqs instead of 'mq-deadline'.
>        */
>       BLK_MQ_F_NO_SCHED_BY_DEFAULT    = 1 << 7,
> -    BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
> +    BLK_MQ_F_DISABLE_FAIR_TAG_SHARING = 1 << 8,
> +    BLK_MQ_F_ALLOC_POLICY_START_BIT = 16,
>       BLK_MQ_F_ALLOC_POLICY_BITS = 1,
> 
>       BLK_MQ_S_STOPPED    = 0,
> 
> 
> 
> .
> 

