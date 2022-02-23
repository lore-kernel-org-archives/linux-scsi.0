Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534DEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 02:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbiBWCJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 21:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiBWCJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 21:09:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CD935FFE
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 18:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645582116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gK04vuf2B7TP6AyCZ7iOGVpTZr/vcEI2ew7H/GaHVyg=;
        b=iH9GK/WYEWYrzRD7Cj1ZndW+Ui9/W+SGh71oLdRvZwEZFo+vVy7g+qaAxysP/QZ5wIxGEj
        FlFvbfDxawiZiHwjeWYxa5g7logwZ4JT7YI6BSwYI+wTFBJTWpMQoHjSM0onWqv+g7lXUW
        ZQyUsvvVf9snpxoKVKTciQueQvlw7kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-S90CxYFOOHaaVcnQJdN7bQ-1; Tue, 22 Feb 2022 21:08:35 -0500
X-MC-Unique: S90CxYFOOHaaVcnQJdN7bQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE3B91854E26;
        Wed, 23 Feb 2022 02:08:33 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 106662AFAA;
        Wed, 23 Feb 2022 02:08:25 +0000 (UTC)
Date:   Wed, 23 Feb 2022 10:08:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/12] blk-mq: do not include passthrough requests in I/O
 accounting
Message-ID: <YhWXFMhdms1QO1dL@T590>
References: <20220222141450.591193-1-hch@lst.de>
 <20220222141450.591193-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222141450.591193-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2022 at 03:14:39PM +0100, Christoph Hellwig wrote:
> I/O accounting buckets I/O into the read/write/discard categories into
> which passthrough I/O does not fit at all.  It also accounts to the
> block_device, which may not even exist for passthrough I/O.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c | 6 +-----
>  block/blk.h    | 2 +-
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index a05ce77250316..ee80853473d1e 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -883,11 +883,7 @@ static inline void blk_account_io_done(struct request *req, u64 now)
>  
>  static void __blk_account_io_start(struct request *rq)
>  {
> -	/* passthrough requests can hold bios that do not have ->bi_bdev set */
> -	if (rq->bio && rq->bio->bi_bdev)
> -		rq->part = rq->bio->bi_bdev;
> -	else if (rq->q->disk)
> -		rq->part = rq->q->disk->part0;
> +	rq->part = rq->bio->bi_bdev;
>  
>  	part_stat_lock();
>  	update_io_ticks(rq->part, jiffies, false);
> diff --git a/block/blk.h b/block/blk.h
> index ebaa59ca46ca6..6f21859c7f0ff 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -325,7 +325,7 @@ int blk_dev_init(void);
>   */
>  static inline bool blk_do_io_stat(struct request *rq)
>  {
> -	return (rq->rq_flags & RQF_IO_STAT) && rq->q->disk;
> +	return (rq->rq_flags & RQF_IO_STAT) && !blk_rq_is_passthrough(rq);

I guess this way may cause regression for workloads with lots of userspace IO
from user viewpoint?


Thanks,
Ming

