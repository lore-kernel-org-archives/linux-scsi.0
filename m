Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B74C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D182B6113A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhI0JVu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:21:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233581AbhI0JVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 05:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632734409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tCYMpg/ChC/Ji/lW0LlV5PGYAJ6Ra2J+9wLmvCKh2Ls=;
        b=NACfr1ob4w7nxhKu52sFu2/tIK+612uWvJJqc7PWE6TK0yTp9C7i04qi8sLwPu2EHkgwj7
        sGnFRJfVACq1DGupqE/n5kYIreZ48aGrOsJnn/DpT+/EDNYfN0G18UYFHWlHvj7U5pa81A
        WO16R1N9vsbp77FNEpjPunUEN7Cdum4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-E5j_XAlfML6sCSSR6cdvtQ-1; Mon, 27 Sep 2021 05:20:08 -0400
X-MC-Unique: E5j_XAlfML6sCSSR6cdvtQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9A8F802921;
        Mon, 27 Sep 2021 09:20:06 +0000 (UTC)
Received: from T590 (ovpn-8-37.pek2.redhat.com [10.72.8.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D6595BAE2;
        Mon, 27 Sep 2021 09:20:02 +0000 (UTC)
Date:   Mon, 27 Sep 2021 17:19:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH v4 11/13] blk-mq: Refactor and rename
 blk_mq_free_map_and_{requests->rqs}()
Message-ID: <YVGMvlU5T8zaoEnM@T590>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-12-git-send-email-john.garry@huawei.com>
 <YU/Va9T+zcRNExUF@T590>
 <45c0c587-59a2-1761-e175-3920669d0bfb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45c0c587-59a2-1761-e175-3920669d0bfb@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 27, 2021 at 10:02:40AM +0100, John Garry wrote:
> On 26/09/2021 03:05, Ming Lei wrote:
> > On Fri, Sep 24, 2021 at 04:28:28PM +0800, John Garry wrote:
> > > Refactor blk_mq_free_map_and_requests() such that it can be used at many
> > > sites at which the tag map and rqs are freed.
> > > 
> > > Also rename to blk_mq_free_map_and_rqs(), which is shorter and matches the
> > > alloc equivalent.
> > > 
> > > Suggested-by: Ming Lei<ming.lei@redhat.com>
> > > Signed-off-by: John Garry<john.garry@huawei.com>
> > > Reviewed-by: Hannes Reinecke<hare@suse.de>
> > > ---
> > >   block/blk-mq-tag.c |  3 +--
> > >   block/blk-mq.c     | 40 ++++++++++++++++++++++++----------------
> > >   block/blk-mq.h     |  4 +++-
> > >   3 files changed, 28 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> > > index db99f1246795..a0ecc6d88f84 100644
> > > --- a/block/blk-mq-tag.c
> > > +++ b/block/blk-mq-tag.c
> > > @@ -607,8 +607,7 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
> > >   		if (!new)
> > >   			return -ENOMEM;
> > > -		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
> > > -		blk_mq_free_rq_map(*tagsptr, set->flags);
> > > +		blk_mq_free_map_and_rqs(set, *tagsptr, hctx->queue_num);
> > >   		*tagsptr = new;
> > >   	} else {
> > >   		/*
> > > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > > index 46772773b9c4..464ea20b9bcb 100644
> > > --- a/block/blk-mq.c
> > > +++ b/block/blk-mq.c
> > > @@ -2878,15 +2878,15 @@ static bool __blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
> > >   	return set->tags[hctx_idx];
> > >   }
> > > -static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
> > > -					 unsigned int hctx_idx)
> > > +void blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
> > > +			     struct blk_mq_tags *tags,
> > > +			     unsigned int hctx_idx)
> > >   {
> > >   	unsigned int flags = set->flags;
> > > -	if (set->tags && set->tags[hctx_idx]) {
> > > -		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
> > > -		blk_mq_free_rq_map(set->tags[hctx_idx], flags);
> > > -		set->tags[hctx_idx] = NULL;
> > > +	if (tags) {
> > > +		blk_mq_free_rqs(set, tags, hctx_idx);
> > > +		blk_mq_free_rq_map(tags, flags);
> > >   	}
> > >   }
> > > @@ -2967,8 +2967,10 @@ static void blk_mq_map_swqueue(struct request_queue *q)
> > >   			 * fallback in case of a new remap fails
> > >   			 * allocation
> > >   			 */
> > > -			if (i && set->tags[i])
> > > -				blk_mq_free_map_and_requests(set, i);
> > > +			if (i && set->tags[i]) {
> > > +				blk_mq_free_map_and_rqs(set, set->tags[i], i);
> > > +				set->tags[i] = NULL;
> > > +			}
> > >   			hctx->tags = NULL;
> > >   			continue;
> > > @@ -3264,8 +3266,8 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
> > >   		struct blk_mq_hw_ctx *hctx = hctxs[j];
> > >   		if (hctx) {
> > > -			if (hctx->tags)
> > > -				blk_mq_free_map_and_requests(set, j);
> > > +			blk_mq_free_map_and_rqs(set, set->tags[j], j);
> > > +			set->tags[j] = NULL;
> > >   			blk_mq_exit_hctx(q, set, hctx, j);
> > >   			hctxs[j] = NULL;
> > >   		}
> > > @@ -3361,8 +3363,10 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
> > >   	return 0;
> > >   out_unwind:
> > > -	while (--i >= 0)
> > > -		blk_mq_free_map_and_requests(set, i);
> > > +	while (--i >= 0) {
> > > +		blk_mq_free_map_and_rqs(set, set->tags[i], i);
> > > +		set->tags[i] = NULL;
> > > +	}
> > >   	return -ENOMEM;
> > >   }
> > > @@ -3557,8 +3561,10 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
> > >   	return 0;
> > >   out_free_mq_rq_maps:
> > > -	for (i = 0; i < set->nr_hw_queues; i++)
> > > -		blk_mq_free_map_and_requests(set, i);
> > > +	for (i = 0; i < set->nr_hw_queues; i++) {
> > > +		blk_mq_free_map_and_rqs(set, set->tags[i], i);
> > > +		set->tags[i] = NULL;
> > > +	}
> > >   out_free_mq_map:
> > >   	for (i = 0; i < set->nr_maps; i++) {
> > >   		kfree(set->map[i].mq_map);
> > > @@ -3590,8 +3596,10 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
> > >   {
> > >   	int i, j;
> > > -	for (i = 0; i < set->nr_hw_queues; i++)
> > > -		blk_mq_free_map_and_requests(set, i);
> > > +	for (i = 0; i < set->nr_hw_queues; i++) {
> > > +		blk_mq_free_map_and_rqs(set, set->tags[i], i);
> > > +		set->tags[i] = NULL;
> > > +	}
> > There are 5 callers in which 'set->tags[i]' is cleared, so just
> > wondering why you don't clear set->tags[i] at default in
> > blk_mq_free_map_and_rqs(). And just call __blk_mq_free_map_and_rqs()
> > for the only other user?
> 
> blk_mq_free_map_and_rqs() is not always passed set->tags[i]:
> 
> - blk_mq_tag_update_depth() calls blk_mq_free_map_and_rqs() for sched tags
> 
> - __blk_mq_alloc_rq_maps() calls blk_mq_free_map_and_rqs() for
> shared_sbitmap_tags
> 
> Function __blk_mq_free_map_and_rqs() is not public and really only intended
> for set->tags[i]
> 
> So I did consider passing the address of the tags pointer to
> blk_mq_free_map_and_rqs(), like:
> 
> void blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
> 			struct blk_mq_tag **tags,
> 			unsigned int hctx_idx)
> 
> {
> 	...
> 	*tags = NULL;
> }
> 
> But then the API becomes a bit asymmetric, as we deal with tags pointer
> normally:
> 
> struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
> 					     unsigned int hctx_idx,
> 					     unsigned int depth);
> 
> 
> However, apart from this, I can change __blk_mq_free_map_and_rqs() to
> NULLify set->tags[i], as it is always passed set->tags[i].
> 
> Do you have a preference?

I meant there are 5 following uses in your patch:

+                               blk_mq_free_map_and_rqs(set, set->tags[i], i);
+                               set->tags[i] = NULL;

and one new helper(blk_mq_free_set_map_and_rqs(set, i)?) can be added for just
doing that, 

Thanks,
Ming

