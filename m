Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFB3C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 07:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD6E6113A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 07:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbhIQHme (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 03:42:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231263AbhIQHme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 03:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631864471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=575QboMGZMcDojw4pRwixWQsIs4RvvyjDtIPjUO8XVM=;
        b=WtyyBlKJno8dGFx+KoE9XVboEMRSJ20Vr5lbL2M/KRsfrMICAz3TObaLpxiMZxTNn9lzSC
        +ei+RWLdqUn2QiFEkJUJbag/u0b3reicXt9AAhQOYg/fFVb/PkThkzEHN1uGadUYe+NgXu
        Be/3l7Q3j7b81MV8oI9XSzSXFjjnuII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-GB_QvkfzMh2Z1JOdfOYJ1g-1; Fri, 17 Sep 2021 03:41:10 -0400
X-MC-Unique: GB_QvkfzMh2Z1JOdfOYJ1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 399D11006AA5;
        Fri, 17 Sep 2021 07:41:09 +0000 (UTC)
Received: from T590.Home (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E9AB5C1D1;
        Fri, 17 Sep 2021 07:41:04 +0000 (UTC)
Date:   Fri, 17 Sep 2021 15:41:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <YURGkXQndMxDEWxW@T590.Home>
References: <20210915092547.990285-1-ming.lei@redhat.com>
 <20210915134008.GA13933@lst.de>
 <YUKfl9Qqsluh+5FX@T590>
 <20210916101451.GA26782@lst.de>
 <YUM6uFHqfjWMM5BH@T590>
 <20210916142009.GA12603@lst.de>
 <YUQOBKa67R9pEunr@T590.Home>
 <20210917065305.GA24012@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917065305.GA24012@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 08:53:05AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 17, 2021 at 11:39:48AM +0800, Ming Lei wrote:
> > If we do that, q->disk is really unnecessary, so looks the fix of
> > 'd152c682f03c block: add an explicit ->disk backpointer to the request_queue'
> > isn't good.
> > The original issue added in 'edb0872f44ec block: move the
> > bdi from the request_queue to the gendisk' can be fixed simply by moving
> > the two lines code in blk_unregister_queue() to blk_cleanup_queue():
> > 
> >         kobject_uevent(&q->kobj, KOBJ_REMOVE);
> >         kobject_del(&q->kobj);
> 
> Well, it is still useful to not do the device model dance, especially as
> uses of queue->disk will grow in 5.16.

It isn't an device model dance, since 

> 
> Anyway, can you give this patch a spin?  I've done some basic testing
> including nvme surprise removal locally.  Note that just like
> blk_cleanup_queue this doesn't actually wait for the freeze to finish.
> Eventually we should do that, but I'm sure this will show tons of issues
> with drivers not properly cleaning up.
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5454db2fa263b..18287c443ae81 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -49,7 +49,6 @@
>  #include "blk-mq.h"
>  #include "blk-mq-sched.h"
>  #include "blk-pm.h"
> -#include "blk-rq-qos.h"
>  
>  struct dentry *blk_debugfs_root;
>  
> @@ -385,13 +384,8 @@ void blk_cleanup_queue(struct request_queue *q)
>  	 */
>  	blk_freeze_queue(q);
>  
> -	rq_qos_exit(q);
> -
>  	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
>  
> -	/* for synchronous bio-based driver finish in-flight integrity i/o */
> -	blk_flush_integrity();
> -
>  	blk_sync_queue(q);
>  	if (queue_is_mq(q))
>  		blk_mq_exit_queue(q);
> @@ -470,19 +464,26 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>  
>  static inline int bio_queue_enter(struct bio *bio)
>  {
> -	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> +	struct gendisk *disk = bio->bi_bdev->bd_disk;
>  	bool nowait = bio->bi_opf & REQ_NOWAIT;
>  	int ret;
>  
> -	ret = blk_queue_enter(q, nowait ? BLK_MQ_REQ_NOWAIT : 0);
> +	ret = blk_queue_enter(disk->queue, nowait ? BLK_MQ_REQ_NOWAIT : 0);
>  	if (unlikely(ret)) {
> -		if (nowait && !blk_queue_dying(q))
> +		if (nowait && !blk_queue_dying(disk->queue))
>  			bio_wouldblock_error(bio);
>  		else
>  			bio_io_error(bio);
> +		return ret;
>  	}
>  
> -	return ret;
> +	if (unlikely(!disk_live(disk))) {
> +		blk_queue_exit(disk->queue);
> +		bio_io_error(bio);
> +		return -ENODEV;
> +	}

Is it safe to fail IO in this way? There is still opened bdev, and
usually IO can be done successfully even when disk is being deleted.

Not mention it adds one extra check in real fast path.

> +
> +	return 0;
>  }
>  
>  void blk_queue_exit(struct request_queue *q)
> diff --git a/block/genhd.c b/block/genhd.c
> index 7b6e5e1cf9564..8abe12dca76f2 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -26,6 +26,7 @@
>  #include <linux/badblocks.h>
>  
>  #include "blk.h"
> +#include "blk-rq-qos.h"
>  
>  static struct kobject *block_depr;
>  
> @@ -559,6 +560,8 @@ EXPORT_SYMBOL(device_add_disk);
>   */
>  void del_gendisk(struct gendisk *disk)
>  {
> +	struct request_queue *q = disk->queue;
> +
>  	might_sleep();
>  
>  	if (WARN_ON_ONCE(!disk_live(disk) && !(disk->flags & GENHD_FL_HIDDEN)))
> @@ -572,6 +575,21 @@ void del_gendisk(struct gendisk *disk)
>  	blk_drop_partitions(disk);
>  	mutex_unlock(&disk->open_mutex);
>  
> +	/*
> +	 * Prevent new I/O from crossing bio_queue_enter().
> +	 */
> +	blk_freeze_queue_start(q);
> +	if (queue_is_mq(q))
> +		blk_mq_wake_waiters(q);
> +	/* Make blk_queue_enter() reexamine the DYING flag. */
> +	wake_up_all(&q->mq_freeze_wq);
> +
> +	rq_qos_exit(q);

rq_qos_exit() requires the queue to be frozen, otherwise kernel oops
can be triggered. There may be old submitted bios not completed yet,
and rq_qos_done() can be referring to q->rq_qos.

But if waiting for queue frozen is added, one extra freeze is added,
which will slow done remove disk/queue.


Thanks,
Ming

