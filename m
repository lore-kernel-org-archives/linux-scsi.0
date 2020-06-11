Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A10BC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 04:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 220B1207C3
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 04:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E5P6ieTG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgFKEFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 00:05:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47681 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725782AbgFKEFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 00:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591848318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E2e8McLK4lWfa3xkg6el0ZABcLTeHo1YkLTPPnE2G00=;
        b=E5P6ieTG08UV3t6ubccbR4o7yVWfoo7Da+h3CaKyy+iXBY8Qm6+WQxnROvQhlNKjGuIApW
        lQq5K+76sCnmCEdyoWNonOBk4vuYgFQTLW3SmtYzQDES5SSFQk+QHBY9GDX/4ofGDc/icn
        uhEaLBgeAN9/oHy2Ef/YjMC4A5rDUW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-eaHQLtvUOumDqdc6GQhkSw-1; Thu, 11 Jun 2020 00:05:15 -0400
X-MC-Unique: eaHQLtvUOumDqdc6GQhkSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E0BD7BAC;
        Thu, 11 Jun 2020 04:05:13 +0000 (UTC)
Received: from T590 (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7B957CCE6;
        Thu, 11 Jun 2020 04:05:00 +0000 (UTC)
Date:   Thu, 11 Jun 2020 12:04:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, bvanassche@acm.org, hare@suse.com,
        hch@lst.de, shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH RFC v7 05/12] blk-mq: Record nr_active_requests per queue
 for when using shared sbitmap
Message-ID: <20200611040455.GD453671@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-6-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591810159-240929-6-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 11, 2020 at 01:29:12AM +0800, John Garry wrote:
> The per-hctx nr_active value can no longer be used to fairly assign a share
> of tag depth per request queue for when using a shared sbitmap, as it does
> not consider that the tags are shared tags over all hctx's.
> 
> For this case, record the nr_active_requests per request_queue, and make
> the judgment based on that value.
> 
> Also introduce a debugfs version of per-hctx blk_mq_debugfs_attr, omitting
> hctx_active_show() (as blk_mq_hw_ctx.nr_active is no longer maintained for
> the case of shared sbitmap) and other entries which we can add which would
> be revised specifically for when using a shared sbitmap.
> 
> Co-developed-with: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-core.c       |  2 ++
>  block/blk-mq-debugfs.c | 23 ++++++++++++++++++++++-
>  block/blk-mq-tag.c     | 10 ++++++----
>  block/blk-mq.c         |  6 +++---
>  block/blk-mq.h         | 28 +++++++++++++++++++++++++++-
>  include/linux/blkdev.h |  2 ++
>  6 files changed, 62 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 03252af8c82c..c622453c1363 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -529,6 +529,8 @@ struct request_queue *__blk_alloc_queue(int node_id)
>  	q->backing_dev_info->capabilities = BDI_CAP_CGROUP_WRITEBACK;
>  	q->node = node_id;
>  
> +	atomic_set(&q->nr_active_requests_shared_sbitmap, 0);
> +
>  	timer_setup(&q->backing_dev_info->laptop_mode_wb_timer,
>  		    laptop_mode_timer_fn, 0);
>  	timer_setup(&q->timeout, blk_rq_timed_out_timer, 0);
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index a400b6698dff..0fa3af41ab65 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -796,6 +796,23 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_hctx_attrs[] = {
>  	{},
>  };
>  
> +static const struct blk_mq_debugfs_attr blk_mq_debugfs_hctx_shared_sbitmap_attrs[] = {
> +	{"state", 0400, hctx_state_show},
> +	{"flags", 0400, hctx_flags_show},
> +	{"dispatch", 0400, .seq_ops = &hctx_dispatch_seq_ops},
> +	{"busy", 0400, hctx_busy_show},
> +	{"ctx_map", 0400, hctx_ctx_map_show},
> +	{"sched_tags", 0400, hctx_sched_tags_show},
> +	{"sched_tags_bitmap", 0400, hctx_sched_tags_bitmap_show},
> +	{"io_poll", 0600, hctx_io_poll_show, hctx_io_poll_write},
> +	{"dispatched", 0600, hctx_dispatched_show, hctx_dispatched_write},
> +	{"queued", 0600, hctx_queued_show, hctx_queued_write},
> +	{"run", 0600, hctx_run_show, hctx_run_write},
> +	{"active", 0400, hctx_active_show},
> +	{"dispatch_busy", 0400, hctx_dispatch_busy_show},
> +	{}
> +};

You may use macro or whatever to avoid so the duplication.

> +
>  static const struct blk_mq_debugfs_attr blk_mq_debugfs_ctx_attrs[] = {
>  	{"default_rq_list", 0400, .seq_ops = &ctx_default_rq_list_seq_ops},
>  	{"read_rq_list", 0400, .seq_ops = &ctx_read_rq_list_seq_ops},
> @@ -878,13 +895,17 @@ void blk_mq_debugfs_register_hctx(struct request_queue *q,
>  				  struct blk_mq_hw_ctx *hctx)
>  {
>  	struct blk_mq_ctx *ctx;
> +	struct blk_mq_tag_set *set = q->tag_set;
>  	char name[20];
>  	int i;
>  
>  	snprintf(name, sizeof(name), "hctx%u", hctx->queue_num);
>  	hctx->debugfs_dir = debugfs_create_dir(name, q->debugfs_dir);
>  
> -	debugfs_create_files(hctx->debugfs_dir, hctx, blk_mq_debugfs_hctx_attrs);
> +	if (blk_mq_is_sbitmap_shared(set))
> +		debugfs_create_files(hctx->debugfs_dir, hctx, blk_mq_debugfs_hctx_shared_sbitmap_attrs);
> +	else
> +		debugfs_create_files(hctx->debugfs_dir, hctx, blk_mq_debugfs_hctx_attrs);
>  
>  	hctx_for_each_ctx(hctx, ctx, i)
>  		blk_mq_debugfs_register_ctx(hctx, ctx);
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 92843e3e1a2a..7db16e49f6f6 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -60,9 +60,11 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>   * For shared tag users, we track the number of currently active users
>   * and attempt to provide a fair share of the tag depth for each of them.
>   */
> -static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
> +static inline bool hctx_may_queue(struct blk_mq_alloc_data *data,
>  				  struct sbitmap_queue *bt)
>  {
> +	struct blk_mq_hw_ctx *hctx = data->hctx;
> +	struct request_queue *q = data->q;
>  	unsigned int depth, users;
>  
>  	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
> @@ -84,15 +86,15 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>  	 * Allow at least some tags
>  	 */
>  	depth = max((bt->sb.depth + users - 1) / users, 4U);
> -	return atomic_read(&hctx->nr_active) < depth;
> +	return __blk_mq_active_requests(hctx, q) < depth;

There is big change on 'users' too:

	users = atomic_read(&hctx->tags->active_queues);

Originally there is single hctx->tags for these HBAs, now there are many
hctx->tags, so 'users' may become much smaller than before.

Maybe '->active_queues' can be moved to tag_set for blk_mq_is_sbitmap_shared().

>  }
>  
>  static int __blk_mq_get_tag(struct blk_mq_alloc_data *data,
>  			    struct sbitmap_queue *bt)
>  {
>  	if (!(data->flags & BLK_MQ_REQ_INTERNAL) &&
> -	    !hctx_may_queue(data->hctx, bt))
> -		return BLK_MQ_NO_TAG;
> +	    !hctx_may_queue(data, bt))
> +		return -1;

BLK_MQ_NO_TAG should have been returned.

>  	if (data->shallow_depth)
>  		return __sbitmap_queue_get_shallow(bt, data->shallow_depth);
>  	else
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 77120dd4e4d5..0f7e062a1665 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -283,7 +283,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
>  	} else {
>  		if (data->hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) {
>  			rq_flags = RQF_MQ_INFLIGHT;
> -			atomic_inc(&data->hctx->nr_active);
> +			__blk_mq_inc_active_requests(data->hctx, data->q);
>  		}
>  		rq->tag = tag;
>  		rq->internal_tag = BLK_MQ_NO_TAG;
> @@ -527,7 +527,7 @@ void blk_mq_free_request(struct request *rq)
>  
>  	ctx->rq_completed[rq_is_sync(rq)]++;
>  	if (rq->rq_flags & RQF_MQ_INFLIGHT)
> -		atomic_dec(&hctx->nr_active);
> +		__blk_mq_dec_active_requests(hctx, q);
>  
>  	if (unlikely(laptop_mode && !blk_rq_is_passthrough(rq)))
>  		laptop_io_completion(q->backing_dev_info);
> @@ -1073,7 +1073,7 @@ bool blk_mq_get_driver_tag(struct request *rq)
>  	if (rq->tag >= 0) {
>  		if (shared) {
>  			rq->rq_flags |= RQF_MQ_INFLIGHT;
> -			atomic_inc(&data.hctx->nr_active);
> +			__blk_mq_inc_active_requests(rq->mq_hctx, rq->q);
>  		}
>  		data.hctx->tags->rqs[rq->tag] = rq;
>  	}
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 1a283c707215..9c1e612c2298 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -202,6 +202,32 @@ static inline bool blk_mq_get_dispatch_budget(struct blk_mq_hw_ctx *hctx)
>  	return true;
>  }
>  
> +static inline void __blk_mq_inc_active_requests(struct blk_mq_hw_ctx *hctx,
> +						struct request_queue *q)
> +{
> +	if (blk_mq_is_sbitmap_shared(q->tag_set))
> +		atomic_inc(&q->nr_active_requests_shared_sbitmap);
> +	else
> +		atomic_inc(&hctx->nr_active);
> +}
> +
> +static inline void __blk_mq_dec_active_requests(struct blk_mq_hw_ctx *hctx,
> +						struct request_queue *q)
> +{
> +	if (blk_mq_is_sbitmap_shared(q->tag_set))
> +		atomic_dec(&q->nr_active_requests_shared_sbitmap);
> +	else
> +		atomic_dec(&hctx->nr_active);
> +}
> +
> +static inline int __blk_mq_active_requests(struct blk_mq_hw_ctx *hctx,
> +					   struct request_queue *q)
> +{
> +	if (blk_mq_is_sbitmap_shared(q->tag_set))

I'd suggest to add one hctx version of blk_mq_is_sbitmap_shared() since
q->tag_set is seldom used in fast path, and hctx->flags is more
efficient than tag_set->flags.


Thanks, 
Ming

