Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A07C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B873561157
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhI0J2W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:28:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233663AbhI0J2U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 05:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632734803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o8jThrmo0nFh3G8H1yEp6CaUd2Is+ZV2Wqa41t50MPk=;
        b=biWmBryBoJm7jaUc9Gr9oapWA0k1n31EBL28oQktUr4EIYUns6s/kWpuL8ywQVajhsLhxA
        J+hTvyg0nC4VVCVbbCVTxtYwiDSZ3rLB8SdILYk7h5zcrtPe7zFNOPiOU1PqFfpbmDTPT/
        Aax3GkK8899zZZMIQ6ImDLKvi12bxuU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-lOCmrL1JMCCkKwpSynLsFA-1; Mon, 27 Sep 2021 05:26:41 -0400
X-MC-Unique: lOCmrL1JMCCkKwpSynLsFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 775B01023F4D;
        Mon, 27 Sep 2021 09:26:39 +0000 (UTC)
Received: from T590 (ovpn-8-37.pek2.redhat.com [10.72.8.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30A2D19724;
        Mon, 27 Sep 2021 09:26:35 +0000 (UTC)
Date:   Mon, 27 Sep 2021 17:26:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        hare@suse.de
Subject: Re: [PATCH v4 12/13] blk-mq: Use shared tags for shared sbitmap
 support
Message-ID: <YVGORkQuf2FQmxwN@T590>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-13-git-send-email-john.garry@huawei.com>
 <YU/oIu2uQ420ol8F@T590>
 <6f52adfd-6904-6efb-adfc-f5f20eb5c1cf@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f52adfd-6904-6efb-adfc-f5f20eb5c1cf@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 27, 2021 at 10:13:29AM +0100, John Garry wrote:
> On 26/09/2021 04:25, Ming Lei wrote:
> > > c
> > > @@ -27,10 +27,11 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
> > >   	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
> > >   		struct request_queue *q = hctx->queue;
> > >   		struct blk_mq_tag_set *set = q->tag_set;
> > > +		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
> > The local variable of 'set' can be removed and just retrieve 'tags' from
> > hctx->tags.
> > 
> > >   		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
> > >   		    !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
> > > -			atomic_inc(&set->active_queues_shared_sbitmap);
> > > +			atomic_inc(&tags->active_queues);
> > >   	} else {
> > >   		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
> > >   		    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> > > @@ -61,10 +62,12 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
> > >   	struct blk_mq_tag_set *set = q->tag_set;
> > >   	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
> > > +		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
> > > +
> > Same with above.
> 
> ok
> 
> > 
> > >   		if (!test_and_clear_bit(QUEUE_FLAG_HCTX_ACTIVE,
> > >   					&q->queue_flags))
> > >   			return;
> > > -		atomic_dec(&set->active_queues_shared_sbitmap);
> > > +		atomic_dec(&tags->active_queues);
> > >   	} else {
> > >   		if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> > >   			return;
> > > @@ -510,38 +513,10 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
> > >   	return 0;
> > >   }
> 
> ...
> 
> > > -	struct sbitmap_queue	__bitmap_tags;
> > > -	struct sbitmap_queue	__breserved_tags;
> > >   	struct blk_mq_tags	**tags;
> > > +	struct blk_mq_tags	*shared_sbitmap_tags;
> > > +
> > >   	struct mutex		tag_list_lock;
> > >   	struct list_head	tag_list;
> > >   };
> > > @@ -432,6 +429,8 @@ enum {
> > >   	((policy & ((1 << BLK_MQ_F_ALLOC_POLICY_BITS) - 1)) \
> > >   		<< BLK_MQ_F_ALLOC_POLICY_START_BIT)
> > > +#define BLK_MQ_NO_HCTX_IDX	(-1U)
> > > +
> > >   struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
> > >   		struct lock_class_key *lkclass);
> > >   #define blk_mq_alloc_disk(set, queuedata)				\
> > > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > > index 4baf9435232d..17e50e5ef47b 100644
> > > --- a/include/linux/blkdev.h
> > > +++ b/include/linux/blkdev.h
> > > @@ -459,8 +459,7 @@ struct request_queue {
> > >   	atomic_t		nr_active_requests_shared_sbitmap;
> > > -	struct sbitmap_queue	sched_bitmap_tags;
> > > -	struct sbitmap_queue	sched_breserved_tags;
> > > +	struct blk_mq_tags	*shared_sbitmap_tags;
> > Maybe better with shared_sched_sbitmap_tags or sched_sbitmap_tags?
> 
> Yeah, I suppose I should add "sched" to the name, as before.
> 
> BTW, Do you think that I should just change shared_sbitmap -> shared_tags
> naming now globally? I'm thinking now that I should...

Yeah, I think so, but seems you preferred to the name of shared sbitmap, so I
did't mention that, :-)


Thanks,
Ming

