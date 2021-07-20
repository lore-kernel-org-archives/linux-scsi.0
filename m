Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C69CC07E9B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 07:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 716256100C
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 07:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbhGTHEg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 03:04:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235509AbhGTHEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 03:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626767077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/2lZSmhD31vcZruVYRqo38G8MYnm4DEU8IYQgIxvezE=;
        b=KoMc/OhXe7AjznNoRRrS02Z04z1kHUgp8bL8Zf/eb27UCzQ44On3hFLk+9tqw+tYP9ssn1
        Vv+sUqNuv4F5JASFjYAPlmldgNnPBQCgVaJYgbRFbEWgW1Rbb1pG9PlpMumzX+KOXef8I/
        Qi1Lui79MQkDO3iFvqA1g4NRw174MOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-_8uQXvxQN7i3aKEGaXu9qg-1; Tue, 20 Jul 2021 03:44:33 -0400
X-MC-Unique: _8uQXvxQN7i3aKEGaXu9qg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 643961018721;
        Tue, 20 Jul 2021 07:44:32 +0000 (UTC)
Received: from T590 (ovpn-13-101.pek2.redhat.com [10.72.13.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88A1F1001281;
        Tue, 20 Jul 2021 07:44:24 +0000 (UTC)
Date:   Tue, 20 Jul 2021 15:44:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, hare@suse.de
Subject: Re: [PATCH 2/9] block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ
Message-ID: <YPZ+02j486IuuZ+J@T590>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
 <1626275195-215652-3-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626275195-215652-3-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2021 at 11:06:28PM +0800, John Garry wrote:
> It is a bit confusing that there is BLKDEV_MAX_RQ and MAX_SCHED_RQ, as
> the name BLKDEV_MAX_RQ would imply the max requests always, which it is
> not.
> 
> Rename to BLKDEV_MAX_RQ to BLKDEV_DEFAULT_RQ, matching its usage - that being
> the default number of requests assigned when allocating a request queue.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-core.c       | 2 +-
>  block/blk-mq-sched.c   | 2 +-
>  block/blk-mq-sched.h   | 2 +-
>  drivers/block/rbd.c    | 2 +-
>  include/linux/blkdev.h | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 04477697ee4b..5d71382b6131 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -579,7 +579,7 @@ struct request_queue *blk_alloc_queue(int node_id)
>  
>  	blk_queue_dma_alignment(q, 511);
>  	blk_set_default_limits(&q->limits);
> -	q->nr_requests = BLKDEV_MAX_RQ;
> +	q->nr_requests = BLKDEV_DEFAULT_RQ;

The above assignment isn't necessary since bio based queue doesn't use
->nr_requests. For request based queue, ->nr_requests will be re-set
in either blk_mq_init_sched() or blk_mq_init_allocated_queue(), but
that may not be related with this patch itself.

>  
>  	return q;
>  
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index c838d81ac058..f5cb2931c20d 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -615,7 +615,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  	 * Additionally, this is a per-hw queue depth.
>  	 */
>  	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
> -				   BLKDEV_MAX_RQ);
> +				   BLKDEV_DEFAULT_RQ);
>  
>  	queue_for_each_hw_ctx(q, hctx, i) {
>  		ret = blk_mq_sched_alloc_tags(q, hctx, i);
> diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
> index 5246ae040704..1e46be6c5178 100644
> --- a/block/blk-mq-sched.h
> +++ b/block/blk-mq-sched.h
> @@ -5,7 +5,7 @@
>  #include "blk-mq.h"
>  #include "blk-mq-tag.h"
>  
> -#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
> +#define MAX_SCHED_RQ (16 * BLKDEV_DEFAULT_RQ)
>  
>  void blk_mq_sched_assign_ioc(struct request *rq);
>  
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 531d390902dd..d3f329749173 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -836,7 +836,7 @@ struct rbd_options {
>  	u32 alloc_hint_flags;  /* CEPH_OSD_OP_ALLOC_HINT_FLAG_* */
>  };
>  
> -#define RBD_QUEUE_DEPTH_DEFAULT	BLKDEV_MAX_RQ
> +#define RBD_QUEUE_DEPTH_DEFAULT	BLKDEV_DEFAULT_RQ
>  #define RBD_ALLOC_SIZE_DEFAULT	(64 * 1024)
>  #define RBD_LOCK_TIMEOUT_DEFAULT 0  /* no timeout */
>  #define RBD_READ_ONLY_DEFAULT	false
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 3177181c4326..6a64ea23f552 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -45,7 +45,7 @@ struct blk_stat_callback;
>  struct blk_keyslot_manager;
>  
>  #define BLKDEV_MIN_RQ	4
> -#define BLKDEV_MAX_RQ	128	/* Default maximum */
> +#define BLKDEV_DEFAULT_RQ	128
>  
>  /* Must be consistent with blk_mq_poll_stats_bkt() */
>  #define BLK_MQ_POLL_STATS_BKTS 16
> -- 
> 2.26.2
> 

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

