Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D572FC07E9B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 07:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3F6961186
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 07:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhGTHR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 03:17:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230219AbhGTHRh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 03:17:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626767896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NFMTyImv7wJ/Lu22tt8HP2f3dRmnsJ3zxKWLopmWFOc=;
        b=a2+5tLdqeRW+hQjdJhRcGDfSbmOsIbLJtrWSg9o+TiywjCPZ1+msLR93uqwauPHMdrSSdI
        Y3J2+VYIL++/8NJDXxfqa/uZJGG/4nMMP1T9GprtbSWjXMdWfGsCuXyUMU+nvA6VvYEdWl
        QrlX3VBAXA+70eTZvdez5rjbSDHiSf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-J4Yj1sX1OJCfSEO06gyv9g-1; Tue, 20 Jul 2021 03:58:14 -0400
X-MC-Unique: J4Yj1sX1OJCfSEO06gyv9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76BCF804141;
        Tue, 20 Jul 2021 07:58:12 +0000 (UTC)
Received: from T590 (ovpn-13-101.pek2.redhat.com [10.72.13.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C0DA6E0B7;
        Tue, 20 Jul 2021 07:58:01 +0000 (UTC)
Date:   Tue, 20 Jul 2021 15:57:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, hare@suse.de
Subject: Re: [PATCH 4/9] blk-mq: Add blk_mq_tag_resize_sched_shared_sbitmap()
Message-ID: <YPaCBSrQNP5ciIVh@T590>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
 <1626275195-215652-5-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626275195-215652-5-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2021 at 11:06:30PM +0800, John Garry wrote:
> Put the functionality to resize the sched shared sbitmap in a common
> function.
> 
> Since the same formula is always used to resize, and it can be got from
> the request queue argument, so just pass the request queue pointer.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-mq-sched.c |  3 +--
>  block/blk-mq-tag.c   | 10 ++++++++++
>  block/blk-mq-tag.h   |  1 +
>  block/blk-mq.c       |  3 +--
>  4 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index f5cb2931c20d..1e028183557d 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -584,8 +584,7 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>  					&queue->sched_breserved_tags;
>  	}
>  
> -	sbitmap_queue_resize(&queue->sched_bitmap_tags,
> -			     queue->nr_requests - set->reserved_tags);
> +	blk_mq_tag_resize_sched_shared_sbitmap(queue);
>  
>  	return 0;
>  }
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 86f87346232a..55c7f1bf41c7 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -634,6 +634,16 @@ void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int s
>  	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
>  }
>  
> +/*
> + * We always resize with q->nr_requests - q->tag_set->reserved_tags, so
> + * don't bother passing a size.
> + */
> +void blk_mq_tag_resize_sched_shared_sbitmap(struct request_queue *q)
> +{
> +	sbitmap_queue_resize(&q->sched_bitmap_tags,
> +			     q->nr_requests - q->tag_set->reserved_tags);
> +}

It is a bit hard to follow the resize part of the name, since no size
parameter passed in. Maybe update is better?

-- 
Ming

