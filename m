Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991F1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 08:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379021AbiAYIiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 03:38:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1451168AbiAYIfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 03:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643099736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jmdE/FyqqZW/h993WVIcmcL0hdVF9fjW8merVZKPk2A=;
        b=ftBjBuvUvTjm5FBcg3RBjBcdTfpXw4+6SGm/8V9KUadIweVNUJI0Cw0NRyB/lIeXN3N5wF
        yMuB0tSWgJylM7hRE+IUpqG078F1cORFeFMh17DFuWoET8mXrwx7NMx87uBWPB+akt4MqG
        jAIDcR+SQNJGTXEY3QgEa2uLzjK55ek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-OMpK3gLvO4-6Wz2gTuw3GA-1; Tue, 25 Jan 2022 03:35:32 -0500
X-MC-Unique: OMpK3gLvO4-6Wz2gTuw3GA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE4E539392;
        Tue, 25 Jan 2022 08:35:31 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 122D462D6C;
        Tue, 25 Jan 2022 08:35:13 +0000 (UTC)
Date:   Tue, 25 Jan 2022 16:35:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <Ye+2PHFyY/xNmMzB@T590>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-6-ming.lei@redhat.com>
 <20220124130555.GD27269@lst.de>
 <Ye8xleeYZfmwA3D7@T590>
 <20220125061634.GA26495@lst.de>
 <20220125071906.GA27674@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125071906.GA27674@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 08:19:06AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 25, 2022 at 07:16:34AM +0100, Christoph Hellwig wrote:
> > So why not key off accouning off "rq->bio && rq->bio->bi_bdev"
> > and remove the need for the flag and the second half of the assignment
> > above?  That is much less error probe and removes code size.
> 
> Something like this, lightly tested:
> 
> ---
> From 5499d013341b492899d1fecde7680ff8ebd232e9 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 25 Jan 2022 07:29:06 +0100
> Subject: block: remove the part field from struct request
> 
> All file system I/O and most userspace passthrough bios have bi_bdev set.
> Switch I/O accounting to directly use the bio and stop copying it into a
> separate struct request field.
> 
> This changes behavior in that e.g. /dev/sgX requests are not accounted
> to the gendisk for the SCSI disk any more, which is the correct thing to
> do as they never went through that gendisk, and fixes a potential race
> when the disk driver is unbound while /dev/sgX I/O is in progress.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-merge.c      | 12 ++++++------
>  block/blk-mq.c         | 32 +++++++++++++-------------------
>  block/blk.h            |  6 +++---
>  include/linux/blk-mq.h |  1 -
>  4 files changed, 22 insertions(+), 29 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 4de34a332c9fd..43e46ea2f0152 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -739,11 +739,11 @@ void blk_rq_set_mixed_merge(struct request *rq)
>  
>  static void blk_account_io_merge_request(struct request *req)
>  {
> -	if (blk_do_io_stat(req)) {
> -		part_stat_lock();
> -		part_stat_inc(req->part, merges[op_stat_group(req_op(req))]);
> -		part_stat_unlock();
> -	}
> +	if (!blk_do_io_stat(req))
> +		return;
> +	part_stat_lock();
> +	part_stat_inc(req->bio->bi_bdev, merges[op_stat_group(req_op(req))]);
> +	part_stat_unlock();
>  }
>  
>  static enum elv_merge blk_try_req_merge(struct request *req,
> @@ -947,7 +947,7 @@ static void blk_account_io_merge_bio(struct request *req)
>  		return;
>  
>  	part_stat_lock();
> -	part_stat_inc(req->part, merges[op_stat_group(req_op(req))]);
> +	part_stat_inc(req->bio->bi_bdev, merges[op_stat_group(req_op(req))]);
>  	part_stat_unlock();
>  }
>  
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f3bf3358a3bb2..01b3862347965 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -132,10 +132,12 @@ static bool blk_mq_check_inflight(struct request *rq, void *priv,
>  {
>  	struct mq_inflight *mi = priv;
>  
> -	if ((!mi->part->bd_partno || rq->part == mi->part) &&
> -	    blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
> -		mi->inflight[rq_data_dir(rq)]++;
> +	if (blk_mq_rq_state(rq) != MQ_RQ_IN_FLIGHT)
> +		return true;
> +	if (mi->part->bd_partno && rq->bio && rq->bio->bi_bdev != mi->part)
> +		return true;
>  
> +	mi->inflight[rq_data_dir(rq)]++;
>  	return true;
>  }
>  
> @@ -331,7 +333,6 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
>  	rq->tag = BLK_MQ_NO_TAG;
>  	rq->internal_tag = BLK_MQ_NO_TAG;
>  	rq->start_time_ns = ktime_get_ns();
> -	rq->part = NULL;
>  	blk_crypto_rq_set_defaults(rq);
>  }
>  EXPORT_SYMBOL(blk_rq_init);
> @@ -368,7 +369,6 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
>  		rq->start_time_ns = ktime_get_ns();
>  	else
>  		rq->start_time_ns = 0;
> -	rq->part = NULL;
>  #ifdef CONFIG_BLK_RQ_ALLOC_TIME
>  	rq->alloc_time_ns = alloc_time_ns;
>  #endif
> @@ -687,11 +687,11 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
>  
>  static void blk_account_io_completion(struct request *req, unsigned int bytes)
>  {
> -	if (req->part && blk_do_io_stat(req)) {
> +	if (blk_do_io_stat(req)) {
>  		const int sgrp = op_stat_group(req_op(req));
>  
>  		part_stat_lock();
> -		part_stat_add(req->part, sectors[sgrp], bytes >> 9);
> +		part_stat_add(req->bio->bi_bdev, sectors[sgrp], bytes >> 9);
>  		part_stat_unlock();
>  	}
>  }
> @@ -859,11 +859,12 @@ EXPORT_SYMBOL_GPL(blk_update_request);
>  static void __blk_account_io_done(struct request *req, u64 now)
>  {
>  	const int sgrp = op_stat_group(req_op(req));
> +	struct block_device *bdev = req->bio->bi_bdev;

Then you need to move account_io_done before calling blk_update_request().


thanks,
Ming

