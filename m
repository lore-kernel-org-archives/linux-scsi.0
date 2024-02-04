Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0381D1C11
	for <linux-scsi@vger.kernel.org>; Sun,  4 Feb 2024 03:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707018996; cv=none; b=XHu0Pl1ThRHmGSqSHnUw4FB635xdKzfedA4k0P3qEEoNgV1VBofxublogzPs7lp85e8mmjK9lsLbZnAyAvdtWpAmsbHREHmZf8EG+25fm85vZjB9DlKOAgBeTSYdtbDMpYOMJ0XpjJMy8/rZYwjxSWhEArQMB19/CMriDJQqT2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707018996; c=relaxed/simple;
	bh=0JBjlqPUHMbHEyHMdArUC8g7ZpnzbIix9oEBDbmi8+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkLaOkMjjlgXlKokl/45XIKmyRTnUm9ydxTS0hKpvaSwwr34NHfLkwJU16+d87nSuxsQHnnnB97eQ3jvQPfmgF6HtahXqcNClOXfiDtpyGzcFlsx1mTjIZ6iWug37+b8VODrLefddQXL5L2QzBzRHakSVx2LY5B12GmIc/o1VhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ifcFTMXr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ifcFTMXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707018992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZOj+yGwgEFZ7jwyaH8tsIMqifZG4xKyDOevxbSz75Uk=;
	b=ifcFTMXr61ef61AxjTj9KmZOlGesHTmFtnl8BVWblyxBsscxvczQ+xecQyITX2eVKWqKCQ
	zpp3HJnd8p+4W4bNs/Od2Y+hFVmtwdS91tKvDX/oqcz/rhdeSN1h8KYVPN9JNlzkt1oQv1
	/4O3fh+SyGCW7iFvqMgSSkFYzxfHEg4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-xFg4ZcuEMwalIHCO5hWchg-1; Sat,
 03 Feb 2024 22:56:28 -0500
X-MC-Unique: xFg4ZcuEMwalIHCO5hWchg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 051523811F25;
	Sun,  4 Feb 2024 03:56:28 +0000 (UTC)
Received: from fedora (unknown [10.72.116.16])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 364C93C2E;
	Sun,  4 Feb 2024 03:56:21 +0000 (UTC)
Date: Sun, 4 Feb 2024 11:56:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>, ming.lei@redhat.com
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Message-ID: <Zb8K4uSN3SNeqrPI@fedora>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240202073104.2418230-7-dlemoal@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Fri, Feb 02, 2024 at 04:30:44PM +0900, Damien Le Moal wrote:
> Zone write plugging implements a per-zone "plug" for write operations to
> tightly control the submission and execution order of writes to
> sequential write required zones of a zoned block device. Per-zone
> plugging of writes guarantees that at any time at most one write request
> per zone is in flight. This mechanism is intended to replace zone write
> locking which is controlled at the scheduler level and implemented only
> by mq-deadline.
> 
> Unlike zone write locking which operates on requests, zone write
> plugging operates on BIOs. A zone write plug is simply a BIO list that
> is atomically manipulated using a spinlock and a kblockd submission
> work. A write BIO to a zone is "plugged" to delay its execution if a
> write BIO for the same zone was already issued, that is, if a write
> request for the same zone is being executed. The next plugged BIO is
> unplugged and issued once the write request completes.
> 
> This mechanism allows to:
>  - Untangles zone write ordering from block IO schedulers. This allows
>    removing the restriction on using only mq-deadline for zoned block
>    devices. Any block IO scheduler, including "none" can be used.
>  - Zone write plugging operates on BIOs instead of requests. Plugged
>    BIOs waiting for execution thus do not hold scheduling tags and thus
>    are not preventing other BIOs to proceed (reads or writes to other
>    zones). Depending on the workload, this can significantly improve
>    the device use and performance.
>  - Both blk-mq (request) based zoned devices and BIO-based devices (e.g.
>    device mapper) can use zone write plugging. It is mandatory for the
>    former but optional for the latter: BIO-based driver can use zone
>    write plugging to implement write ordering guarantees, or the drivers
>    can implement their own if needed.
>  - The code is less invasive in the block layer and is mostly limited to
>    blk-zoned.c with some small changes in blk-mq.c, blk-merge.c and
>    bio.c.
> 
> Zone write plugging is implemented using struct blk_zone_wplug. This
> structurei includes a spinlock, a BIO list and a work structure to
> handle the submission of plugged BIOs.
> 
> Plugging of zone write BIOs is done using the function
> blk_zone_write_plug_bio() which returns false if a BIO execution does
> not need to be delayed and true otherwise. This function is called
> from blk_mq_submit_bio() after a BIO is split to avoid large BIOs
> spanning multiple zones which would cause mishandling of zone write
> plugging. This enables by default zone write plugging for any mq
> request-based block device. BIO-based device drivers can also use zone
> write plugging by expliclty calling blk_zone_write_plug_bio() in their
> ->submit_bio method. For such devices, the driver must ensure that a
> BIO passed to blk_zone_write_plug_bio() is already split and not
> straddling zone boundaries.
> 
> Only write and write zeroes BIOs are plugged. Zone write plugging does
> not introduce any significant overhead for other operations. A BIO that
> is being handled through zone write plugging is flagged using the new
> BIO flag BIO_ZONE_WRITE_PLUGGING. A request handling a BIO flagged with
> this new flag is flagged with the new RQF_ZONE_WRITE_PLUGGING flag.
> The completion processing of BIOs and requests flagged trigger
> respectively calls to the functions blk_zone_write_plug_bio_endio() and
> blk_zone_write_plug_complete_request(). The latter function is used to
> trigger submission of the next plugged BIO using the zone plug work.
> blk_zone_write_plug_bio_endio() does the same for BIO-based devices.
> This ensures that at any time, at most one request (blk-mq devices) or
> one BIO (BIO-based devices) are being executed for any zone. The
> handling of zone write plug using a per-zone plug spinlock maximizes
> parrallelism and device usage by allowing multiple zones to be writen
> simultaneously without lock contention.
> 
> Zone write plugging ignores flush BIOs without data. Hovever, any flush
> BIO that has data is always plugged so that the write part of the flush
> sequence is serialized with other regular writes.
> 
> Given that any BIO handled through zone write plugging will be the only
> BIO in flight for the target zone when it is executed, the unplugging
> and submission of a BIO will have no chance of successfully merging with
> plugged requests or requests in the scheduler. To overcome this
> potential performance loss, blk_mq_submit_bio() calls the function
> blk_zone_write_plug_attempt_merge() to try to merge other plugged BIOs
> with the one just unplugged. Successful merging is signaled using
> blk_zone_write_plug_bio_merged(), called from bio_attempt_back_merge().
> Furthermore, to avoid recalculating the number of segments of plugged
> BIOs to attempt merging, the number of segments of a plugged BIO is
> saved using the new struct bio field __bi_nr_segments. To avoid growing
> the size of struct bio, this field is added as a union with the
> bio_cookie field. This is safe to do as polling is always disabled for
> plugged BIOs.
> 
> When BIOs are plugged in a zone write plug, the device request queue
> usage counter is always incremented. This kept and reused when the
> plugged BIO is unplugged and submitted again using
> submit_bio_noacct_nocheck(). For this case, the unplugged BIO is already
> flagged with BIO_ZONE_WRITE_PLUGGING and blk_mq_submit_bio() proceeds
> directly to allocating a new request for the BIO, re-using the usage
> reference count taken when the BIO was plugged. This extra reference
> count is dropped in blk_zone_write_plug_attempt_merge() for any plugged
> BIO that is successfully merged. Given that BIO-based devices will not
> take this path, the extra reference is dropped when a plugged BIO is
> unplugged and submitted.
> 
> To match the new data structures used for zoned disks, the function
> disk_free_zone_bitmaps() is renamed to the more generic
> disk_free_zone_resources().
> 
> This commit contains contributions from Christoph Hellwig <hch@lst.de>.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  block/bio.c               |   7 +
>  block/blk-merge.c         |  11 +
>  block/blk-mq.c            |  28 +++
>  block/blk-zoned.c         | 408 +++++++++++++++++++++++++++++++++++++-
>  block/blk.h               |  32 ++-
>  block/genhd.c             |   2 +-
>  include/linux/blk-mq.h    |   2 +
>  include/linux/blk_types.h |   8 +-
>  include/linux/blkdev.h    |   8 +
>  9 files changed, 496 insertions(+), 10 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index b9642a41f286..c8b0f7e8c713 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1581,6 +1581,13 @@ void bio_endio(struct bio *bio)
>  	if (!bio_integrity_endio(bio))
>  		return;
>  
> +	/*
> +	 * For BIOs handled through a zone write plugs, signal the end of the
> +	 * BIO to the zone write plug to submit the next plugged BIO.
> +	 */
> +	if (bio_zone_write_plugging(bio))
> +		blk_zone_write_plug_bio_endio(bio);
> +
>  	rq_qos_done_bio(bio);
>  
>  	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index a1ef61b03e31..2b5489cd9c65 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -377,6 +377,7 @@ struct bio *__bio_split_to_limits(struct bio *bio,
>  		blkcg_bio_issue_init(split);
>  		bio_chain(split, bio);
>  		trace_block_split(split, bio->bi_iter.bi_sector);
> +		WARN_ON_ONCE(bio_zone_write_plugging(bio));
>  		submit_bio_noacct(bio);
>  		return split;
>  	}
> @@ -980,6 +981,9 @@ enum bio_merge_status bio_attempt_back_merge(struct request *req,
>  
>  	blk_update_mixed_merge(req, bio, false);
>  
> +	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
> +		blk_zone_write_plug_bio_merged(bio);
> +
>  	req->biotail->bi_next = bio;
>  	req->biotail = bio;
>  	req->__data_len += bio->bi_iter.bi_size;
> @@ -995,6 +999,13 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
>  {
>  	const blk_opf_t ff = bio_failfast(bio);
>  
> +	/*
> +	 * A front merge for zone writes can happen only if the user submitted
> +	 * writes out of order. Do not attempt this to let the write fail.
> +	 */
> +	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
> +		return BIO_MERGE_FAILED;
> +
>  	if (!ll_front_merge_fn(req, bio, nr_segs))
>  		return BIO_MERGE_FAILED;
>  
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f02e486a02ae..aa49bebf1199 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -830,6 +830,9 @@ static void blk_complete_request(struct request *req)
>  		bio = next;
>  	} while (bio);
>  
> +	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
> +		blk_zone_write_plug_complete_request(req);
> +
>  	/*
>  	 * Reset counters so that the request stacking driver
>  	 * can find how many bytes remain in the request
> @@ -943,6 +946,9 @@ bool blk_update_request(struct request *req, blk_status_t error,
>  	 * completely done
>  	 */
>  	if (!req->bio) {
> +		if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
> +			blk_zone_write_plug_complete_request(req);
> +
>  		/*
>  		 * Reset counters so that the request stacking driver
>  		 * can find how many bytes remain in the request
> @@ -2975,6 +2981,17 @@ void blk_mq_submit_bio(struct bio *bio)
>  	struct request *rq;
>  	blk_status_t ret;
>  
> +	/*
> +	 * A BIO that was released form a zone write plug has already been
> +	 * through the preparation in this function, already holds a reference
> +	 * on the queue usage counter, and is the only write BIO in-flight for
> +	 * the target zone. Go straight to allocating a request for it.
> +	 */
> +	if (bio_zone_write_plugging(bio)) {
> +		nr_segs = bio->__bi_nr_segments;
> +		goto new_request;
> +	}
> +
>  	bio = blk_queue_bounce(bio, q);
>  	bio_set_ioprio(bio);
>  
> @@ -3001,7 +3018,11 @@ void blk_mq_submit_bio(struct bio *bio)
>  	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
>  		goto queue_exit;
>  
> +	if (blk_queue_is_zoned(q) && blk_zone_write_plug_bio(bio, nr_segs))
> +		goto queue_exit;
> +
>  	if (!rq) {
> +new_request:
>  		rq = blk_mq_get_new_requests(q, plug, bio, nr_segs);
>  		if (unlikely(!rq))
>  			goto queue_exit;
> @@ -3017,8 +3038,12 @@ void blk_mq_submit_bio(struct bio *bio)
>  
>  	ret = blk_crypto_rq_get_keyslot(rq);
>  	if (ret != BLK_STS_OK) {
> +		bool zwplugging = bio_zone_write_plugging(bio);
> +
>  		bio->bi_status = ret;
>  		bio_endio(bio);
> +		if (zwplugging)
> +			blk_zone_write_plug_complete_request(rq);
>  		blk_mq_free_request(rq);
>  		return;
>  	}
> @@ -3026,6 +3051,9 @@ void blk_mq_submit_bio(struct bio *bio)
>  	if (op_is_flush(bio->bi_opf) && blk_insert_flush(rq))
>  		return;
>  
> +	if (bio_zone_write_plugging(bio))
> +		blk_zone_write_plug_attempt_merge(rq);
> +
>  	if (plug) {
>  		blk_add_rq_to_plug(plug, rq);
>  		return;
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index d343e5756a9c..f6d4f511b664 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -7,11 +7,11 @@
>   *
>   * Copyright (c) 2016, Damien Le Moal
>   * Copyright (c) 2016, Western Digital
> + * Copyright (c) 2024, Western Digital Corporation or its affiliates.
>   */
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/rbtree.h>
>  #include <linux/blkdev.h>
>  #include <linux/blk-mq.h>
>  #include <linux/mm.h>
> @@ -19,6 +19,7 @@
>  #include <linux/sched/mm.h>
>  
>  #include "blk.h"
> +#include "blk-mq-sched.h"
>  
>  #define ZONE_COND_NAME(name) [BLK_ZONE_COND_##name] = #name
>  static const char *const zone_cond_name[] = {
> @@ -33,6 +34,27 @@ static const char *const zone_cond_name[] = {
>  };
>  #undef ZONE_COND_NAME
>  
> +/*
> + * Per-zone write plug.
> + */
> +struct blk_zone_wplug {
> +	spinlock_t		lock;
> +	unsigned int		flags;
> +	struct bio_list		bio_list;
> +	struct work_struct	bio_work;
> +};
> +
> +/*
> + * Zone write plug flags bits:
> + *  - BLK_ZONE_WPLUG_CONV: Indicate that the zone is a conventional one. Writes
> + *    to these zones are never plugged.
> + *  - BLK_ZONE_WPLUG_PLUGGED: Indicate that the zone write plug is plugged,
> + *    that is, that write BIOs are being throttled due to a write BIO already
> + *    being executed or the zone write plug bio list is not empty.
> + */
> +#define BLK_ZONE_WPLUG_CONV	(1U << 0)
> +#define BLK_ZONE_WPLUG_PLUGGED	(1U << 1)

BLK_ZONE_WPLUG_PLUGGED == !bio_list_empty(&zwplug->bio_list), so looks
this flag isn't necessary.

> +
>  /**
>   * blk_zone_cond_str - Return string XXX in BLK_ZONE_COND_XXX.
>   * @zone_cond: BLK_ZONE_COND_XXX.
> @@ -429,12 +451,374 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
>  	return ret;
>  }
>  
> -void disk_free_zone_bitmaps(struct gendisk *disk)
> +#define blk_zone_wplug_lock(zwplug, flags) \
> +	spin_lock_irqsave(&zwplug->lock, flags)
> +
> +#define blk_zone_wplug_unlock(zwplug, flags) \
> +	spin_unlock_irqrestore(&zwplug->lock, flags)
> +
> +static inline void blk_zone_wplug_bio_io_error(struct bio *bio)
> +{
> +	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> +
> +	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
> +	bio_io_error(bio);
> +	blk_queue_exit(q);
> +}
> +
> +static int blk_zone_wplug_abort(struct gendisk *disk,
> +				struct blk_zone_wplug *zwplug)
> +{
> +	struct bio *bio;
> +	int nr_aborted = 0;
> +
> +	while ((bio = bio_list_pop(&zwplug->bio_list))) {
> +		blk_zone_wplug_bio_io_error(bio);
> +		nr_aborted++;
> +	}
> +
> +	return nr_aborted;
> +}
> +
> +/*
> + * Return the zone write plug for sector in sequential write required zone.
> + * Given that conventional zones have no write ordering constraints, NULL is
> + * returned for sectors in conventional zones, to indicate that zone write
> + * plugging is not needed.
> + */
> +static inline struct blk_zone_wplug *
> +disk_lookup_zone_wplug(struct gendisk *disk, sector_t sector)
> +{
> +	struct blk_zone_wplug *zwplug;
> +
> +	if (WARN_ON_ONCE(!disk->zone_wplugs))
> +		return NULL;
> +
> +	zwplug = &disk->zone_wplugs[disk_zone_no(disk, sector)];
> +	if (zwplug->flags & BLK_ZONE_WPLUG_CONV)
> +		return NULL;
> +	return zwplug;
> +}
> +
> +static inline struct blk_zone_wplug *bio_lookup_zone_wplug(struct bio *bio)
> +{
> +	return disk_lookup_zone_wplug(bio->bi_bdev->bd_disk,
> +				      bio->bi_iter.bi_sector);
> +}
> +
> +static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
> +					  struct bio *bio, unsigned int nr_segs)
> +{
> +	/*
> +	 * Keep a reference on the BIO request queue usage. This reference will
> +	 * be dropped either if the BIO is failed or after it is issued and
> +	 * completes.
> +	 */
> +	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);

It is fragile to get nested usage_counter, and same with grabbing/releasing it
from different contexts or even functions, and it could be much better to just
let block layer maintain it.

From patch 23's change:

+	 * Zoned block device information. Reads of this information must be
+	 * protected with blk_queue_enter() / blk_queue_exit(). Modifying this

Anytime if there is in-flight bio, the block device is opened, so both gendisk and
request_queue are live, so not sure if this .q_usage_counter protection
is needed.

+	 * information is only allowed while no requests are being processed.
+	 * See also blk_mq_freeze_queue() and blk_mq_unfreeze_queue().
 	 */

> +
> +	/*
> +	 * The BIO is being plugged and thus will have to wait for the on-going
> +	 * write and for all other writes already plugged. So polling makes
> +	 * no sense.
> +	 */
> +	bio_clear_polled(bio);
> +
> +	/*
> +	 * Reuse the poll cookie field to store the number of segments when
> +	 * split to the hardware limits.
> +	 */
> +	bio->__bi_nr_segments = nr_segs;
> +
> +	/*
> +	 * We always receive BIOs after they are split and ready to be issued.
> +	 * The block layer passes the parts of a split BIO in order, and the
> +	 * user must also issue write sequentially. So simply add the new BIO
> +	 * at the tail of the list to preserve the sequential write order.
> +	 */
> +	bio_list_add(&zwplug->bio_list, bio);
> +}
> +
> +/*
> + * Called from bio_attempt_back_merge() when a BIO was merged with a request.
> + */
> +void blk_zone_write_plug_bio_merged(struct bio *bio)
> +{
> +	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
> +}
> +
> +/*
> + * Attempt to merge plugged BIOs with a newly formed request of a BIO that went
> + * through zone write plugging (either a new BIO or one that was unplugged).
> + */
> +void blk_zone_write_plug_attempt_merge(struct request *req)
> +{
> +	struct blk_zone_wplug *zwplug = bio_lookup_zone_wplug(req->bio);
> +	sector_t req_back_sector = blk_rq_pos(req) + blk_rq_sectors(req);
> +	struct request_queue *q = req->q;
> +	unsigned long flags;
> +	struct bio *bio;
> +
> +	/*
> +	 * Completion of this request needs to be handled with
> +	 * blk_zone_write_complete_request().
> +	 */
> +	req->rq_flags |= RQF_ZONE_WRITE_PLUGGING;
> +
> +	if (blk_queue_nomerges(q))
> +		return;
> +
> +	/*
> +	 * Walk through the list of plugged BIOs to check if they can be merged
> +	 * into the back of the request.
> +	 */
> +	blk_zone_wplug_lock(zwplug, flags);
> +	while ((bio = bio_list_peek(&zwplug->bio_list))) {
> +		if (bio->bi_iter.bi_sector != req_back_sector ||
> +		    !blk_rq_merge_ok(req, bio))
> +			break;
> +
> +		WARN_ON_ONCE(bio_op(bio) != REQ_OP_WRITE_ZEROES &&
> +			     !bio->__bi_nr_segments);
> +
> +		bio_list_pop(&zwplug->bio_list);
> +		if (bio_attempt_back_merge(req, bio, bio->__bi_nr_segments) !=
> +		    BIO_MERGE_OK) {
> +			bio_list_add_head(&zwplug->bio_list, bio);
> +			break;
> +		}
> +
> +		/*
> +		 * Drop the extra reference on the queue usage we got when
> +		 * plugging the BIO.
> +		 */
> +		blk_queue_exit(q);
> +
> +		req_back_sector += bio_sectors(bio);
> +	}
> +	blk_zone_wplug_unlock(zwplug, flags);
> +}
> +
> +static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
> +{
> +	struct blk_zone_wplug *zwplug;
> +	unsigned long flags;
> +
> +	/*
> +	 * BIOs must be fully contained within a zone so that we use the correct
> +	 * zone write plug for the entire BIO. For blk-mq devices, the block
> +	 * layer should already have done any splitting required to ensure this
> +	 * and this BIO should thus not be straddling zone boundaries. For
> +	 * BIO-based devices, it is the responsibility of the driver to split
> +	 * the bio before submitting it.
> +	 */
> +	if (WARN_ON_ONCE(bio_straddle_zones(bio))) {
> +		bio_io_error(bio);
> +		return true;
> +	}
> +
> +	zwplug = bio_lookup_zone_wplug(bio);
> +	if (!zwplug)
> +		return false;
> +
> +	blk_zone_wplug_lock(zwplug, flags);
> +
> +	/* Indicate that this BIO is being handled using zone write plugging. */
> +	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
> +
> +	/*
> +	 * If the zone is already plugged, add the BIO to the plug BIO list.
> +	 * Otherwise, plug and let the BIO execute.
> +	 */
> +	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED) {
> +		blk_zone_wplug_add_bio(zwplug, bio, nr_segs);
> +		blk_zone_wplug_unlock(zwplug, flags);
> +		return true;
> +	}
> +
> +	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> +
> +	blk_zone_wplug_unlock(zwplug, flags);
> +
> +	return false;
> +}
> +
> +/**
> + * blk_zone_write_plug_bio - Handle a zone write BIO with zone write plugging
> + * @bio: The BIO being submitted
> + *
> + * Handle write and write zeroes operations using zone write plugging.
> + * Return true whenever @bio execution needs to be delayed through the zone
> + * write plug. Otherwise, return false to let the submission path process
> + * @bio normally.
> + */
> +bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
> +{
> +	if (!bio->bi_bdev->bd_disk->zone_wplugs)
> +		return false;
> +
> +	/*
> +	 * If the BIO already has the plugging flag set, then it was already
> +	 * handled through this path and this is a submission from the zone
> +	 * plug bio submit work.
> +	 */
> +	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
> +		return false;
> +
> +	/*
> +	 * We do not need to do anything special for empty flush BIOs, e.g
> +	 * BIOs such as issued by blkdev_issue_flush(). The is because it is
> +	 * the responsibility of the user to first wait for the completion of
> +	 * write operations for flush to have any effect on the persistence of
> +	 * the written data.
> +	 */
> +	if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
> +		return false;
> +
> +	/*
> +	 * Regular writes and write zeroes need to be handled through the target
> +	 * zone write plug. This includes writes with REQ_FUA | REQ_PREFLUSH
> +	 * which may need to go through the flush machinery depending on the
> +	 * target device capabilities. Plugging such writes is fine as the flush
> +	 * machinery operates at the request level, below the plug, and
> +	 * completion of the flush sequence will go through the regular BIO
> +	 * completion, which will handle zone write plugging.
> +	 */
> +	switch (bio_op(bio)) {
> +	case REQ_OP_WRITE:
> +	case REQ_OP_WRITE_ZEROES:
> +		return blk_zone_wplug_handle_write(bio, nr_segs);
> +	default:
> +		return false;
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(blk_zone_write_plug_bio);
> +
> +static void blk_zone_write_plug_unplug_bio(struct blk_zone_wplug *zwplug)
> +{
> +	unsigned long flags;
> +
> +	blk_zone_wplug_lock(zwplug, flags);
> +
> +	/* Schedule submission of the next plugged BIO if we have one. */
> +	if (!bio_list_empty(&zwplug->bio_list))
> +		kblockd_schedule_work(&zwplug->bio_work);
> +	else
> +		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
> +
> +	blk_zone_wplug_unlock(zwplug, flags);
> +}
> +
> +void blk_zone_write_plug_bio_endio(struct bio *bio)
> +{
> +	/* Make sure we do not see this BIO again by clearing the plug flag. */
> +	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
> +
> +	/*
> +	 * For BIO-based devices, blk_zone_write_plug_complete_request()
> +	 * is not called. So we need to schedule execution of the next
> +	 * plugged BIO here.
> +	 */
> +	if (bio->bi_bdev->bd_has_submit_bio) {
> +		struct blk_zone_wplug *zwplug = bio_lookup_zone_wplug(bio);
> +
> +		blk_zone_write_plug_unplug_bio(zwplug);
> +	}
> +}
> +
> +void blk_zone_write_plug_complete_request(struct request *req)
> +{
> +	struct gendisk *disk = req->q->disk;
> +	struct blk_zone_wplug *zwplug =
> +		disk_lookup_zone_wplug(disk, req->__sector);
> +
> +	req->rq_flags &= ~RQF_ZONE_WRITE_PLUGGING;
> +
> +	blk_zone_write_plug_unplug_bio(zwplug);
> +}
> +
> +static void blk_zone_wplug_bio_work(struct work_struct *work)
> +{
> +	struct blk_zone_wplug *zwplug =
> +		container_of(work, struct blk_zone_wplug, bio_work);
> +	unsigned long flags;
> +	struct bio *bio;
> +
> +	/*
> +	 * Unplug and submit the next plugged BIO. If we do not have any, clear
> +	 * the plugged flag.
> +	 */
> +	blk_zone_wplug_lock(zwplug, flags);
> +
> +	bio = bio_list_pop(&zwplug->bio_list);
> +	if (!bio) {
> +		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
> +		blk_zone_wplug_unlock(zwplug, flags);
> +		return;
> +	}
> +
> +	blk_zone_wplug_unlock(zwplug, flags);
> +
> +	/*
> +	 * blk-mq devices will reuse the reference on the request queue usage
> +	 * we took when the BIO was plugged, but the submission path for
> +	 * BIO-based devices will not do that. So drop this reference here.
> +	 */
> +	if (bio->bi_bdev->bd_has_submit_bio)
> +		blk_queue_exit(bio->bi_bdev->bd_disk->queue);

But I don't see where this reference is reused for blk-mq in this patch,
care to point it out?


Thanks, 
Ming

