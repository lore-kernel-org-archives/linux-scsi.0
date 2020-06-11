Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44F2C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 03:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8894F2075F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 03:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AGO8glTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgFKDhw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 23:37:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39201 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726306AbgFKDhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 23:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591846668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iP2OKVnYkWKfJ9dRhZyN2t/CrSo8rjzv7fCFav4q42E=;
        b=AGO8glTomT4rbEvDc/2GDzT0Pmollj+XTfVadEzLJtMY8e8BSUkWbBY0PQgnunWysj2FTs
        YCUPU6GZWWe9ID4h0OJwzBs6c3ZNMUz8YE5opkJ0J+P40RrZm7xYN0nT6Aqi1QTCIs57Ng
        SvH8wpznpQyOMwH+ArBrxNsvMx5rrTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-i-BlNq4JOjmJcHoK-vl3Sw-1; Wed, 10 Jun 2020 23:37:46 -0400
X-MC-Unique: i-BlNq4JOjmJcHoK-vl3Sw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FBE6107ACCD;
        Thu, 11 Jun 2020 03:37:44 +0000 (UTC)
Received: from T590 (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 592CD5C1B0;
        Thu, 11 Jun 2020 03:37:32 +0000 (UTC)
Date:   Thu, 11 Jun 2020 11:37:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, bvanassche@acm.org, hare@suse.com,
        hch@lst.de, shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH RFC v7 04/12] blk-mq: Facilitate a shared sbitmap per
 tagset
Message-ID: <20200611033728.GC453671@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-5-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591810159-240929-5-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 11, 2020 at 01:29:11AM +0800, John Garry wrote:
> Some SCSI HBAs (such as HPSA, megaraid, mpt3sas, hisi_sas_v3 ..) support
> multiple reply queues with single hostwide tags.
> 
> In addition, these drivers want to use interrupt assignment in
> pci_alloc_irq_vectors(PCI_IRQ_AFFINITY). However, as discussed in [0],
> CPU hotplug may cause in-flight IO completion to not be serviced when an
> interrupt is shutdown. That problem is solved in commit bf0beec0607d
> ("blk-mq: drain I/O when all CPUs in a hctx are offline").
> 
> However, to take advantage of that blk-mq feature, the HBA HW queuess are
> required to be mapped to that of the blk-mq hctx's; to do that, the HBA HW queues
> need to be exposed to the upper layer.
> 
> In making that transition, the per-SCSI command request tags are no
> longer unique per Scsi host - they are just unique per hctx. As such, the
> HBA LLDD would have to generate this tag internally, which has a certain
> performance overhead.
> 
> However another problem is that blk-mq assumes the host may accept
> (Scsi_host.can_queue * #hw queue) commands. In commit 6eb045e092ef ("scsi:
>  core: avoid host-wide host_busy counter for scsi_mq"), the Scsi host busy
> counter was removed, which would stop the LLDD being sent more than
> .can_queue commands; however, it should still be ensured that the block
> layer does not issue more than .can_queue commands to the Scsi host.
> 
> To solve this problem, introduce a shared sbitmap per blk_mq_tag_set,
> which may be requested at init time.
> 
> New flag BLK_MQ_F_TAG_HCTX_SHARED should be set when requesting the
> tagset to indicate whether the shared sbitmap should be used.
> 
> Even when BLK_MQ_F_TAG_HCTX_SHARED is set, a full set of tags and requests
> are still allocated per hctx; the reason for this is that if tags and
> requests were only allocated for a single hctx - like hctx0 - it may break
> block drivers which expect a request be associated with a specific hctx,
> i.e. not always hctx0. This will introduce extra memory usage.
> 
> This change is based on work originally from Ming Lei in [1] and from
> Bart's suggestion in [2].
> 
> [0] https://lore.kernel.org/linux-block/alpine.DEB.2.21.1904051331270.1802@nanos.tec.linutronix.de/
> [1] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/
> [2] https://lore.kernel.org/linux-block/ff77beff-5fd9-9f05-12b6-826922bace1f@huawei.com/T/#m3db0a602f095cbcbff27e9c884d6b4ae826144be
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-mq-tag.c     | 39 +++++++++++++++++++++++++++++++++++++--
>  block/blk-mq-tag.h     | 10 +++++++++-
>  block/blk-mq.c         | 24 +++++++++++++++++++++++-
>  block/blk-mq.h         |  5 +++++
>  include/linux/blk-mq.h |  6 ++++++
>  5 files changed, 80 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index be39db3c88d7..92843e3e1a2a 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -228,7 +228,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
>  	 * We can hit rq == NULL here, because the tagging functions
>  	 * test and set the bit before assigning ->rqs[].
>  	 */
> -	if (rq && rq->q == hctx->queue)
> +	if (rq && rq->q == hctx->queue && rq->mq_hctx == hctx)
>  		return iter_data->fn(hctx, rq, iter_data->data, reserved);
>  	return true;
>  }
> @@ -466,6 +466,7 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>  		     round_robin, node))
>  		goto free_bitmap_tags;
>  
> +	/* We later overwrite these in case of per-set shared sbitmap */
>  	tags->bitmap_tags = &tags->__bitmap_tags;
>  	tags->breserved_tags = &tags->__breserved_tags;

You may skip to allocate anything for blk_mq_is_sbitmap_shared(), and
similar change for blk_mq_free_tags().

>  
> @@ -475,7 +476,32 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>  	return -ENOMEM;
>  }
>  
> -struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
> +bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set)
> +{
> +	unsigned int depth = tag_set->queue_depth - tag_set->reserved_tags;
> +	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(tag_set->flags);
> +	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
> +	int node = tag_set->numa_node;
> +
> +	if (bt_alloc(&tag_set->__bitmap_tags, depth, round_robin, node))
> +		return false;
> +	if (bt_alloc(&tag_set->__breserved_tags, tag_set->reserved_tags,
> +		     round_robin, node))
> +		goto free_bitmap_tags;
> +	return true;
> +free_bitmap_tags:
> +	sbitmap_queue_free(&tag_set->__bitmap_tags);
> +	return false;
> +}
> +
> +void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set)
> +{
> +	sbitmap_queue_free(&tag_set->__bitmap_tags);
> +	sbitmap_queue_free(&tag_set->__breserved_tags);
> +}
> +
> +struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
> +				     unsigned int total_tags,
>  				     unsigned int reserved_tags,
>  				     int node, int alloc_policy)
>  {
> @@ -502,6 +528,10 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>  
>  void blk_mq_free_tags(struct blk_mq_tags *tags)
>  {
> +	/*
> +	 * Do not free tags->{bitmap, breserved}_tags, as this may point to
> +	 * shared sbitmap
> +	 */
>  	sbitmap_queue_free(&tags->__bitmap_tags);
>  	sbitmap_queue_free(&tags->__breserved_tags);
>  	kfree(tags);
> @@ -560,6 +590,11 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>  	return 0;
>  }
>  
> +void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int size)
> +{
> +	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
> +}
> +
>  /**
>   * blk_mq_unique_tag() - return a tag that is unique queue-wide
>   * @rq: request for which to compute a unique tag
> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> index cebf7a4b280a..cf39dd13a24d 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -25,7 +25,12 @@ struct blk_mq_tags {
>  };
>  
>  
> -extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node, int alloc_policy);
> +extern bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set);
> +extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set);
> +extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *tag_set,
> +					    unsigned int nr_tags,
> +					    unsigned int reserved_tags,
> +					    int node, int alloc_policy);
>  extern void blk_mq_free_tags(struct blk_mq_tags *tags);
>  
>  extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
> @@ -34,6 +39,9 @@ extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
>  extern int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>  					struct blk_mq_tags **tags,
>  					unsigned int depth, bool can_grow);
> +extern void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set,
> +					     unsigned int size);
> +
>  extern void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
>  void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
>  		void *priv);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 90b645c3092c..77120dd4e4d5 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2229,7 +2229,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  	if (node == NUMA_NO_NODE)
>  		node = set->numa_node;
>  
> -	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
> +	tags = blk_mq_init_tags(set, nr_tags, reserved_tags, node,
>  				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
>  	if (!tags)
>  		return NULL;
> @@ -3349,11 +3349,28 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>  	if (ret)
>  		goto out_free_mq_map;
>  
> +	if (blk_mq_is_sbitmap_shared(set)) {
> +		if (!blk_mq_init_shared_sbitmap(set)) {
> +			ret = -ENOMEM;
> +			goto out_free_mq_rq_maps;
> +		}
> +
> +		for (i = 0; i < set->nr_hw_queues; i++) {
> +			struct blk_mq_tags *tags = set->tags[i];
> +
> +			tags->bitmap_tags = &set->__bitmap_tags;
> +			tags->breserved_tags = &set->__breserved_tags;
> +		}

I am wondering why you don't put ->[bitmap|breserved]_tags initialization into
blk_mq_init_shared_sbitmap().


Thanks, 
Ming

