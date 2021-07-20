Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5396DC07E9B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 07:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31145610FB
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 07:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhGTHL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 03:11:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231211AbhGTHKO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 03:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626767452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=31b1F8Fs9meCS0LWk72Ne5IXkpfxV4uBGgF8zXGM3V4=;
        b=X05CLxkBiMvQVnuwvdobu9LPdd53JX46wcIiBz617srGboiOXe/K22wJUIbgDsRnJxsOfJ
        kOws8sKAc0fLjtMcGn2xcubqm/Q+qASk1WUstb/A9uS7XPYlcEYHYq2NMXUDkrodKQzE6j
        XjYoDEJpjhG8j2sq0sRGhSOiqZVeUTU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-d-TlirZ1NjmM2LMdE6L2HA-1; Tue, 20 Jul 2021 03:50:47 -0400
X-MC-Unique: d-TlirZ1NjmM2LMdE6L2HA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92D581966320;
        Tue, 20 Jul 2021 07:50:46 +0000 (UTC)
Received: from T590 (ovpn-13-101.pek2.redhat.com [10.72.13.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30A895C1C5;
        Tue, 20 Jul 2021 07:50:32 +0000 (UTC)
Date:   Tue, 20 Jul 2021 15:50:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, hare@suse.de
Subject: Re: [PATCH 3/9] blk-mq: Relocate shared sbitmap resize in
 blk_mq_update_nr_requests()
Message-ID: <YPaARLPPZxcbat8H@T590>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
 <1626275195-215652-4-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626275195-215652-4-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2021 at 11:06:29PM +0800, John Garry wrote:
> For shared sbitmap, if the call to blk_mq_tag_update_depth() was
> successful for any hctx when hctx->sched_tags is not set, then it would be
> successful for all (due to nature in which blk_mq_tag_update_depth()
> fails).
> 
> As such, there is no need to call blk_mq_tag_resize_shared_sbitmap() for
> each hctx. So relocate the call until after the hctx iteration under the
> !q->elevator check, which is equivalent (to !hctx->sched_tags).
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-mq.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index ae28f470893c..56e3c6fdba60 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3624,8 +3624,6 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>  		if (!hctx->sched_tags) {
>  			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
>  							false);
> -			if (!ret && blk_mq_is_sbitmap_shared(set->flags))
> -				blk_mq_tag_resize_shared_sbitmap(set, nr);
>  		} else {
>  			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
>  							nr, true);
> @@ -3643,9 +3641,14 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>  	}
>  	if (!ret) {
>  		q->nr_requests = nr;
> -		if (q->elevator && blk_mq_is_sbitmap_shared(set->flags))
> -			sbitmap_queue_resize(&q->sched_bitmap_tags,
> -					     nr - set->reserved_tags);
> +		if (blk_mq_is_sbitmap_shared(set->flags)) {
> +			if (q->elevator) {
> +				sbitmap_queue_resize(&q->sched_bitmap_tags,
> +						     nr - set->reserved_tags);
> +			} else {
> +				blk_mq_tag_resize_shared_sbitmap(set, nr);
> +			}

The above two {} can be removed.

-- 
Ming

