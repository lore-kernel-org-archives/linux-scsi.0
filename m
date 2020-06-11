Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6316EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D5C20760
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgFKKYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 06:24:10 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2301 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726693AbgFKKYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 06:24:09 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id DF66BA7A270A5D09600F;
        Thu, 11 Jun 2020 11:24:06 +0100 (IST)
Received: from [127.0.0.1] (10.210.169.30) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 11 Jun
 2020 11:24:05 +0100
Subject: Re: [PATCH RFC v7 05/12] blk-mq: Record nr_active_requests per queue
 for when using shared sbitmap
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-6-git-send-email-john.garry@huawei.com>
 <20200611040455.GD453671@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9a5dcb3a-8f5c-ab10-7631-4bd1b58b49bb@huawei.com>
Date:   Thu, 11 Jun 2020 11:22:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200611040455.GD453671@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.169.30]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> +static const struct blk_mq_debugfs_attr blk_mq_debugfs_hctx_shared_sbitmap_attrs[] = {
>> +	{"state", 0400, hctx_state_show},
>> +	{"flags", 0400, hctx_flags_show},
>> +	{"dispatch", 0400, .seq_ops = &hctx_dispatch_seq_ops},
>> +	{"busy", 0400, hctx_busy_show},
>> +	{"ctx_map", 0400, hctx_ctx_map_show},
>> +	{"sched_tags", 0400, hctx_sched_tags_show},
>> +	{"sched_tags_bitmap", 0400, hctx_sched_tags_bitmap_show},
>> +	{"io_poll", 0600, hctx_io_poll_show, hctx_io_poll_write},
>> +	{"dispatched", 0600, hctx_dispatched_show, hctx_dispatched_write},
>> +	{"queued", 0600, hctx_queued_show, hctx_queued_write},
>> +	{"run", 0600, hctx_run_show, hctx_run_write},
>> +	{"active", 0400, hctx_active_show},
>> +	{"dispatch_busy", 0400, hctx_dispatch_busy_show},
>> +	{}
>> +};
> 
> You may use macro or whatever to avoid so the duplication.

Let me check alternatives.

> 
>> +
>>   static const struct blk_mq_debugfs_attr blk_mq_debugfs_ctx_attrs[] = {
>>   	{"default_rq_list", 0400, .seq_ops = &ctx_default_rq_list_seq_ops},
>>   	{"read_rq_list", 0400, .seq_ops = &ctx_read_rq_list_seq_ops},
>> @@ -878,13 +895,17 @@ void blk_mq_debugfs_register_hctx(struct request_queue *q,
>>   				  struct blk_mq_hw_ctx *hctx)
>>   {
>>   	struct blk_mq_ctx *ctx;
>> +	struct blk_mq_tag_set *set = q->tag_set;
>>   	char name[20];
>>   	int i;
>>   
>>   	snprintf(name, sizeof(name), "hctx%u", hctx->queue_num);
>>   	hctx->debugfs_dir = debugfs_create_dir(name, q->debugfs_dir);
>>   
>> -	debugfs_create_files(hctx->debugfs_dir, hctx, blk_mq_debugfs_hctx_attrs);
>> +	if (blk_mq_is_sbitmap_shared(set))
>> +		debugfs_create_files(hctx->debugfs_dir, hctx, blk_mq_debugfs_hctx_shared_sbitmap_attrs);
>> +	else
>> +		debugfs_create_files(hctx->debugfs_dir, hctx, blk_mq_debugfs_hctx_attrs);
>>   
>>   	hctx_for_each_ctx(hctx, ctx, i)
>>   		blk_mq_debugfs_register_ctx(hctx, ctx);
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index 92843e3e1a2a..7db16e49f6f6 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -60,9 +60,11 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>>    * For shared tag users, we track the number of currently active users
>>    * and attempt to provide a fair share of the tag depth for each of them.
>>    */
>> -static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>> +static inline bool hctx_may_queue(struct blk_mq_alloc_data *data,
>>   				  struct sbitmap_queue *bt)
>>   {
>> +	struct blk_mq_hw_ctx *hctx = data->hctx;
>> +	struct request_queue *q = data->q;
>>   	unsigned int depth, users;
>>   
>>   	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
>> @@ -84,15 +86,15 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>>   	 * Allow at least some tags
>>   	 */
>>   	depth = max((bt->sb.depth + users - 1) / users, 4U);
>> -	return atomic_read(&hctx->nr_active) < depth;
>> +	return __blk_mq_active_requests(hctx, q) < depth;
> 
> There is big change on 'users' too:
> 
> 	users = atomic_read(&hctx->tags->active_queues);
> 
> Originally there is single hctx->tags for these HBAs, now there are many
> hctx->tags, so 'users' may become much smaller than before.

Can you please check how I handled that in the next patch? There we 
record the number of active request queues per set.

(I will note that I could have combined some of these patches, but I 
liked the piecemeal appraoch, and none of these paths are enabled until 
later).

> 
> Maybe '->active_queues' can be moved to tag_set for blk_mq_is_sbitmap_shared().
> 
>>   }
>>   
>>   static int __blk_mq_get_tag(struct blk_mq_alloc_data *data,
>>   			    struct sbitmap_queue *bt)
>>   {
>>   	if (!(data->flags & BLK_MQ_REQ_INTERNAL) &&
>> -	    !hctx_may_queue(data->hctx, bt))
>> -		return BLK_MQ_NO_TAG;
>> +	    !hctx_may_queue(data, bt))
>> +		return -1;
> 
> BLK_MQ_NO_TAG should have been returned.

OK, I missed that in the rebase.

> 
>>   	if (data->shallow_depth)
>>   		return __sbitmap_queue_get_shallow(bt, data->shallow_depth);
>>   	else
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 77120dd4e4d5..0f7e062a1665 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -283,7 +283,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
>>   	} else {
>>   		if (data->hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) {
>>   			rq_flags = RQF_MQ_INFLIGHT;
>> -			atomic_inc(&data->hctx->nr_active);
>> +			__blk_mq_inc_active_requests(data->hctx, data->q);
>>   		}
>>   		rq->tag = tag;
>>   		rq->internal_tag = BLK_MQ_NO_TAG;
>> @@ -527,7 +527,7 @@ void blk_mq_free_request(struct request *rq)
>>   
>>   	ctx->rq_completed[rq_is_sync(rq)]++;
>>   	if (rq->rq_flags & RQF_MQ_INFLIGHT)
>> -		atomic_dec(&hctx->nr_active);
>> +		__blk_mq_dec_active_requests(hctx, q);
>>   
>>   	if (unlikely(laptop_mode && !blk_rq_is_passthrough(rq)))
>>   		laptop_io_completion(q->backing_dev_info);
>> @@ -1073,7 +1073,7 @@ bool blk_mq_get_driver_tag(struct request *rq)
>>   	if (rq->tag >= 0) {
>>   		if (shared) {
>>   			rq->rq_flags |= RQF_MQ_INFLIGHT;
>> -			atomic_inc(&data.hctx->nr_active);
>> +			__blk_mq_inc_active_requests(rq->mq_hctx, rq->q);
>>   		}
>>   		data.hctx->tags->rqs[rq->tag] = rq;
>>   	}
>> diff --git a/block/blk-mq.h b/block/blk-mq.h
>> index 1a283c707215..9c1e612c2298 100644
>> --- a/block/blk-mq.h
>> +++ b/block/blk-mq.h
>> @@ -202,6 +202,32 @@ static inline bool blk_mq_get_dispatch_budget(struct blk_mq_hw_ctx *hctx)
>>   	return true;
>>   }
>>   
>> +static inline void __blk_mq_inc_active_requests(struct blk_mq_hw_ctx *hctx,
>> +						struct request_queue *q)
>> +{
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set))
>> +		atomic_inc(&q->nr_active_requests_shared_sbitmap);
>> +	else
>> +		atomic_inc(&hctx->nr_active);
>> +}
>> +
>> +static inline void __blk_mq_dec_active_requests(struct blk_mq_hw_ctx *hctx,
>> +						struct request_queue *q)
>> +{
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set))
>> +		atomic_dec(&q->nr_active_requests_shared_sbitmap);
>> +	else
>> +		atomic_dec(&hctx->nr_active);
>> +}
>> +
>> +static inline int __blk_mq_active_requests(struct blk_mq_hw_ctx *hctx,
>> +					   struct request_queue *q)
>> +{
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set))
> 
> I'd suggest to add one hctx version of blk_mq_is_sbitmap_shared() since
> q->tag_set is seldom used in fast path, and hctx->flags is more
> efficient than tag_set->flags.

OK

Thanks,
John
