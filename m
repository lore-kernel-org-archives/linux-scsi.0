Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418B1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 13:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 288AC20760
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 13:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgFKNTa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 09:19:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:40640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgFKNTa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 09:19:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D685EAF73;
        Thu, 11 Jun 2020 13:19:30 +0000 (UTC)
Subject: Re: [PATCH RFC v7 07/12] blk-mq: Add support in
 hctx_tags_bitmap_show() for a shared sbitmap
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, ming.lei@redhat.com, bvanassche@acm.org,
        hare@suse.com, hch@lst.de, shivasharan.srikanteshwara@broadcom.com
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-8-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9f4741c5-d117-d764-cf3a-a57192a788c3@suse.de>
Date:   Thu, 11 Jun 2020 15:19:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591810159-240929-8-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/10/20 7:29 PM, John Garry wrote:
> Since a set-wide shared tag sbitmap may be used, it is no longer valid to
> examine the per-hctx tagset for getting the active requests for a hctx
> (when a shared sbitmap is used).
> 
> As such, add support for the shared sbitmap by using an intermediate
> sbitmap per hctx, iterating all active tags for the specific hctx in the
> shared sbitmap.
> 
> Originally-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de> #earlier version
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   block/blk-mq-debugfs.c | 62 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 62 insertions(+)
> 
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 05b4be0c03d9..4da7e54adf3b 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -495,6 +495,67 @@ static int hctx_tags_show(void *data, struct seq_file *m)
>   	return res;
>   }
>   
> +struct hctx_sb_data {
> +	struct sbitmap		*sb;	/* output bitmap */
> +	struct blk_mq_hw_ctx	*hctx;	/* input hctx */
> +};
> +
> +static bool hctx_filter_fn(struct blk_mq_hw_ctx *hctx, struct request *req,
> +			   void *priv, bool reserved)
> +{
> +	struct hctx_sb_data *hctx_sb_data = priv;
> +
> +	if (hctx == hctx_sb_data->hctx)
> +		sbitmap_set_bit(hctx_sb_data->sb, req->tag);
> +
> +	return true;
> +}
> +
> +static void hctx_filter_sb(struct sbitmap *sb, struct blk_mq_hw_ctx *hctx)
> +{
> +	struct hctx_sb_data hctx_sb_data = { .sb = sb, .hctx = hctx };
> +
> +	blk_mq_queue_tag_busy_iter(hctx->queue, hctx_filter_fn, &hctx_sb_data);
> +}
> +
> +static int hctx_tags_shared_sbitmap_bitmap_show(void *data, struct seq_file *m)
> +{
> +	struct blk_mq_hw_ctx *hctx = data;
> +	struct request_queue *q = hctx->queue;
> +	struct blk_mq_tag_set *set = q->tag_set;
> +	struct sbitmap shared_sb, *sb;
> +	int res;
> +
> +	if (!set)
> +		return 0;
> +
> +	/*
> +	 * We could use the allocated sbitmap for that hctx here, but
> +	 * that would mean that we would need to clean it prior to use.
> +	 */
> +	res = sbitmap_init_node(&shared_sb,
> +				set->__bitmap_tags.sb.depth,
> +				set->__bitmap_tags.sb.shift,
> +				GFP_KERNEL, NUMA_NO_NODE);
> +	if (res)
> +		return res;
> +	sb = &shared_sb;
> +
> +	res = mutex_lock_interruptible(&q->sysfs_lock);
> +	if (res)
> +		goto out;
> +	if (hctx->tags) {
> +		hctx_filter_sb(sb, hctx);
> +		sbitmap_bitmap_show(sb, m);
> +	}
> +
> +	mutex_unlock(&q->sysfs_lock);
> +
> +out:
> +	sbitmap_free(&shared_sb);
> +	return res;
> +}
> +
>   static int hctx_tags_bitmap_show(void *data, struct seq_file *m)
>   {
>   	struct blk_mq_hw_ctx *hctx = data;
> @@ -823,6 +884,7 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_hctx_shared_sbitmap_attrs
>   	{"busy", 0400, hctx_busy_show},
>   	{"ctx_map", 0400, hctx_ctx_map_show},
>   	{"tags", 0400, hctx_tags_show},
> +	{"tags_bitmap", 0400, hctx_tags_shared_sbitmap_bitmap_show},
>   	{"sched_tags", 0400, hctx_sched_tags_show},
>   	{"sched_tags_bitmap", 0400, hctx_sched_tags_bitmap_show},
>   	{"io_poll", 0600, hctx_io_poll_show, hctx_io_poll_write},
> 
Ah, right. Here it is.

But I don't get it; why do we have to allocate a temporary bitmap and 
can't walk the existing shared sbitmap?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
