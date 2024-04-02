Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7323815AD89;
	Tue,  2 Apr 2024 18:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712082370; cv=none; b=pOknKAwKppj6S2SVXKPYCExCUAbR4Jhbir5CeFFo/OyYOtuf58e6jVpleqZlqnH2fKvB+L/4HFHXh+WL4W7Ij8xSSVi98awc7ZPLx0Mrlln3FMYh7tod/aMvsNf7qEy6WbD3KVeV7pepbOgocysMkEISmL+PohoPkOeC6bg9Wgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712082370; c=relaxed/simple;
	bh=+5ZjZD1KOFf6D/Bz7J377g7g4zsrt5xzhzGi/EeRFPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=W/PfnkBA+M9HHa6GYZaDKdYMoN01UHTcjEy8Z4o8aLThsVqrRMYpaLYg43N/oj/7RWK95Y3scGrvrxUwSlMWmc9Jsz3VxRC9yeKel5NM6nxrxFwOA/ku6VciaI+ngWtMKump37Rh93R9eRTlpRzVkMVGSH8fhTQ0XbwIasFbCyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hDaIbRYk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1KPGOuKD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hDaIbRYk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1KPGOuKD"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9799D349E4;
	Tue,  2 Apr 2024 18:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712082364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kZqX9Bz2rdoRUzl+/GOhB8Th41HCYvWJ6oOk+a47rE=;
	b=hDaIbRYkFL/GFLoCtby1KP5jP1VVDfxO0/k5oyHcDZrclfQ67C32+Jmz0Nh/0cRsWwyvPt
	KaUA66vzkg0ffc2mi8FZAKKVUUtoxgLJSi/SbFJpEPvulOxN3FK+OJQG05H7b9TnCWNjOy
	dEjY7jW0zl1TPQUE7Re2YBe/jiVVK1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712082364;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kZqX9Bz2rdoRUzl+/GOhB8Th41HCYvWJ6oOk+a47rE=;
	b=1KPGOuKDfcX7F1f5nVdz+FNtju97aVtNfWgd+UORIwvoP1mhkhaOGm2zTqAQeND34VZZFi
	qgn1wn/WpZ8fukCQ==
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F06113A90;
	Tue,  2 Apr 2024 18:26:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id PdymBbxNDGYbNwAAn2gu4w
	(envelope-from <hare@suse.de>); Tue, 02 Apr 2024 18:26:04 +0000
Message-ID: <25fd8351-d649-445f-84fb-ed1705275859@suse.de>
Date: Tue, 2 Apr 2024 20:26:03 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-8-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402123907.512027-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spamd-Result: default: False [-4.29 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[10];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On 4/2/24 14:38, Damien Le Moal wrote:
> Zone write plugging implements a per-zone "plug" for write operations
> to control the submission and execution order of write operations to
> sequential write required zones of a zoned block device. Per-zone
> plugging guarantees that at any time there is at most only one write
> request per zone being executed. This mechanism is intended to replace
> zone write locking which implements a similar per-zone write throttling
> at the scheduler level, but is implemented only by mq-deadline.
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
>   - Untangle zone write ordering from block IO schedulers. This allows
>     removing the restriction on using mq-deadline for writing to zoned
>     block devices. Any block IO scheduler, including "none" can be used.
>   - Zone write plugging operates on BIOs instead of requests. Plugged
>     BIOs waiting for execution thus do not hold scheduling tags and thus
>     are not preventing other BIOs from executing (reads or writes to
>     other zones). Depending on the workload, this can significantly
>     improve the device use (higher queue depth operation) and
>     performance.
>   - Both blk-mq (request based) zoned devices and BIO-based zoned devices
>     (e.g.  device mapper) can use zone write plugging. It is mandatory
>     for the former but optional for the latter. BIO-based drivers can
>     use zone write plugging to implement write ordering guarantees, or
>     the drivers can implement their own if needed.
>   - The code is less invasive in the block layer and is mostly limited to
>     blk-zoned.c with some small changes in blk-mq.c, blk-merge.c and
>     bio.c.
> 
> Zone write plugging is implemented using struct blk_zone_wplug. This
> structure includes a spinlock, a BIO list and a work structure to
> handle the submission of plugged BIOs. Zone write plugs structures are
> managed using a per-disk hash table.
> 
> Plugging of zone write BIOs is done using the function
> blk_zone_write_plug_bio() which returns false if a BIO execution does
> not need to be delayed and true otherwise. This function is called
> from blk_mq_submit_bio() after a BIO is split to avoid large BIOs
> spanning multiple zones which would cause mishandling of zone write
> plugs. This ichange enables by default zone write plugging for any mq
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
> The completion of BIOs and requests flagged trigger respectively calls
> to the functions blk_zone_write_plug_bio_endio() and
> blk_zone_write_plug_complete_request(). The latter function is used to
> trigger submission of the next plugged BIO using the zone plug work.
> blk_zone_write_plug_bio_endio() does the same for BIO-based devices.
> This ensures that at any time, at most one request (blk-mq devices) or
> one BIO (BIO-based devices) is being executed for any zone. The
> handling of zone write plugs using a per-zone plug spinlock maximizes
> parallelism and device usage by allowing multiple zones to be writen
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
> potential performance degradation, blk_mq_submit_bio() calls the
> function blk_zone_write_plug_attempt_merge() to try to merge other
> plugged BIOs with the one just unplugged and submitted. Successful
> merging is signaled using blk_zone_write_plug_bio_merged(), called from
> bio_attempt_back_merge(). Furthermore, to avoid recalculating the number
> of segments of plugged BIOs to attempt merging, the number of segments
> of a plugged BIO is saved using the new struct bio field
> __bi_nr_segments. To avoid growing the size of struct bio, this field is
> added as a union with the bio_cookie field. This is safe to do as
> polling is always disabled for plugged BIOs.
> 
> When BIOs are plugged in a zone write plug, the device request queue
> usage counter is always incremented. This reference is kept and reused
> for blk-mq devices when the plugged BIO is unplugged and submitted
> again using submit_bio_noacct_nocheck(). For this case, the unplugged
> BIO is already flagged with BIO_ZONE_WRITE_PLUGGING and
> blk_mq_submit_bio() proceeds directly to allocating a new request for
> the BIO, re-using the usage reference count taken when the BIO was
> plugged. This extra reference count is dropped in
> blk_zone_write_plug_attempt_merge() for any plugged BIO that is
> successfully merged. Given that BIO-based devices will not take this
> path, the extra reference is dropped after a plugged BIO is unplugged
> and submitted.
> 
> Zone write plugs are dynamically allocated and managed using a hash
> table (an array of struct hlist_head) with RCU protection.
> A zone write plug is allocated when a write BIO is received for the
> zone and not freed until the zone is fully written, reset or finished.
> To detect when a zone write plug can be freed, the write state of each
> zone is tracked using a write pointer offset which corresponds to the
> offset of a zone write pointer relative to the zone start. Write
> operations always increment this write pointer offset. Zone reset
> operations set it to 0 and zone finish operations set it to the zone
> size.
> 
> If a write error happens, the wp_offset value of a zone write plug may
> become incorrect and out of sync with the device managed write pointer.
> This is handled using the zone write plug flag BLK_ZONE_WPLUG_ERROR.
> The function blk_zone_wplug_handle_error() is called from the new disk
> zone write plug work when this flag is set. This function executes a
> report zone to update the zone write pointer offset to the current
> value as indicated by the device. The disk zone write plug work is
> scheduled whenever a BIO flagged with BIO_ZONE_WRITE_PLUGGING completes
> with an error or when bio_zone_wplug_prepare_bio() detects an unaligned
> write. Once scheduled, the disk zone write plugs work keeps running
> until all zone errors are handled.
> 
> To match the new data structures used for zoned disks, the function
> disk_free_zone_bitmaps() is renamed to the more generic
> disk_free_zone_resources(). The function disk_init_zone_resources() is
> also introduced to initialize zone write plugs resources when a gendisk
> is allocated.
> 
> In order to guarantee that the user can simultaneously write up to a
> number of zones equal to a device max active zone limit or max open zone
> limit, zone write plugs are allocated using a mempool sized to the
> maximum of these 2 device limits. For a device that does not have
> active and open zone limits, 128 is used as the default mempool size.
> 
> If a change to the device active and open zone limits is detected, the
> disk mempool is resized when blk_revalidate_disk_zones() is executed.
> 
> This commit contains contributions from Christoph Hellwig <hch@lst.de>.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/bio.c               |    7 +
>   block/blk-merge.c         |   11 +
>   block/blk-mq.c            |   38 +-
>   block/blk-zoned.c         | 1107 ++++++++++++++++++++++++++++++++++++-
>   block/blk.h               |   36 +-
>   block/genhd.c             |    3 +-
>   include/linux/blk-mq.h    |    2 +
>   include/linux/blk_types.h |    8 +-
>   include/linux/blkdev.h    |   13 +
>   9 files changed, 1214 insertions(+), 11 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index d24420ed1c4c..4ece8cef1fbe 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1576,6 +1576,13 @@ void bio_endio(struct bio *bio)
>   	if (!bio_integrity_endio(bio))
>   		return;
>   
> +	/*
> +	 * For BIOs handled through a zone write plug, signal the completion
> +	 * of the BIO so that the next plugged BIO can be submitted.
> +	 */
> +	if (bio_zone_write_plugging(bio))
> +		blk_zone_write_plug_bio_endio(bio);
> +

Can't we move this check into blk_zone_write_plug_bio_endio()?
We'd need to check it anyway ...

>   	rq_qos_done_bio(bio);
>   
>   	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 3363b1321908..7a9f8187ea62 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -377,6 +377,7 @@ struct bio *__bio_split_to_limits(struct bio *bio,
>   		blkcg_bio_issue_init(split);
>   		bio_chain(split, bio);
>   		trace_block_split(split, bio->bi_iter.bi_sector);
> +		WARN_ON_ONCE(bio_zone_write_plugging(bio));
>   		submit_bio_noacct(bio);
>   		return split;
>   	}
> @@ -988,6 +989,9 @@ enum bio_merge_status bio_attempt_back_merge(struct request *req,
>   
>   	blk_update_mixed_merge(req, bio, false);
>   
> +	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
> +		blk_zone_write_plug_bio_merged(bio);
> +
Similar here

>   	req->biotail->bi_next = bio;
>   	req->biotail = bio;
>   	req->__data_len += bio->bi_iter.bi_size;
> @@ -1003,6 +1007,13 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
>   {
>   	const blk_opf_t ff = bio_failfast(bio);
>   
> +	/*
> +	 * A front merge for zone writes can happen only if the user submitted
> +	 * writes out of order. Do not attempt this to let the write fail.
> +	 */
> +	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
> +		return BIO_MERGE_FAILED;
> +
>   	if (!ll_front_merge_fn(req, bio, nr_segs))
>   		return BIO_MERGE_FAILED;
>   
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 88b541e8873f..73f2ca7c738d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -828,6 +828,9 @@ static void blk_complete_request(struct request *req)
>   		bio = next;
>   	} while (bio);
>   
> +	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
> +		blk_zone_write_plug_complete_request(req);
> +
And here.

>   	/*
>   	 * Reset counters so that the request stacking driver
>   	 * can find how many bytes remain in the request
> @@ -939,6 +942,9 @@ bool blk_update_request(struct request *req, blk_status_t error,
>   	 * completely done
>   	 */
>   	if (!req->bio) {
> +		if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
> +			blk_zone_write_plug_complete_request(req);
> +
And here.

>   		/*
>   		 * Reset counters so that the request stacking driver
>   		 * can find how many bytes remain in the request
> @@ -2963,15 +2969,30 @@ void blk_mq_submit_bio(struct bio *bio)
>   	struct request *rq;
>   	blk_status_t ret;
>   
> +	/*
> +	 * If the plug has a cached request for this queue, try use it.
> +	 */
> +	rq = blk_mq_peek_cached_request(plug, q, bio->bi_opf);
> +
> +	/*
> +	 * A BIO that was released from a zone write plug has already been
> +	 * through the preparation in this function, already holds a reference
> +	 * on the queue usage counter, and is the only write BIO in-flight for
> +	 * the target zone. Go straight to preparing a request for it.
> +	 */
> +	if (bio_zone_write_plugging(bio)) {
> +		nr_segs = bio->__bi_nr_segments;
> +		if (rq)
> +			blk_queue_exit(q);
> +		goto new_request;
> +	}
> +
>   	bio = blk_queue_bounce(bio, q);
>   
>   	/*
> -	 * If the plug has a cached request for this queue, try use it.
> -	 *
>   	 * The cached request already holds a q_usage_counter reference and we
>   	 * don't have to acquire a new one if we use it.
>   	 */
> -	rq = blk_mq_peek_cached_request(plug, q, bio->bi_opf);
>   	if (!rq) {
>   		if (unlikely(bio_queue_enter(bio)))
>   			return;
> @@ -2988,6 +3009,10 @@ void blk_mq_submit_bio(struct bio *bio)
>   	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
>   		goto queue_exit;
>   
> +	if (blk_queue_is_zoned(q) && blk_zone_write_plug_bio(bio, nr_segs))
> +		goto queue_exit;
> +
> +new_request:
>   	if (!rq) {
>   		rq = blk_mq_get_new_requests(q, plug, bio, nr_segs);
>   		if (unlikely(!rq))
> @@ -3004,8 +3029,12 @@ void blk_mq_submit_bio(struct bio *bio)
>   
>   	ret = blk_crypto_rq_get_keyslot(rq);
>   	if (ret != BLK_STS_OK) {
> +		bool zwplugging = bio_zone_write_plugging(bio);
> +
>   		bio->bi_status = ret;
>   		bio_endio(bio);
> +		if (zwplugging)
> +			blk_zone_write_plug_complete_request(rq);
>   		blk_mq_free_request(rq);
>   		return;
>   	}
> @@ -3013,6 +3042,9 @@ void blk_mq_submit_bio(struct bio *bio)
>   	if (op_is_flush(bio->bi_opf) && blk_insert_flush(rq))
>   		return;
>   
> +	if (bio_zone_write_plugging(bio))
> +		blk_zone_write_plug_attempt_merge(rq);
> +
And here.

>   	if (plug) {
>   		blk_add_rq_to_plug(plug, rq);
>   		return;
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 23d9bb21c459..c6130f17f359 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -7,6 +7,7 @@
>    *
>    * Copyright (c) 2016, Damien Le Moal
>    * Copyright (c) 2016, Western Digital
> + * Copyright (c) 2024, Western Digital Corporation or its affiliates.
>    */
>   
>   #include <linux/kernel.h>
> @@ -16,8 +17,11 @@
>   #include <linux/mm.h>
>   #include <linux/vmalloc.h>
>   #include <linux/sched/mm.h>
> +#include <linux/spinlock.h>
> +#include <linux/atomic.h>
>   
>   #include "blk.h"
> +#include "blk-mq-sched.h"
>   
>   #define ZONE_COND_NAME(name) [BLK_ZONE_COND_##name] = #name
>   static const char *const zone_cond_name[] = {
> @@ -32,6 +36,64 @@ static const char *const zone_cond_name[] = {
>   };
>   #undef ZONE_COND_NAME
>   
> +/*
> + * Per-zone write plug.
> + * @node: hlist_node structure for managing the plug using a hash table.
> + * @link: To list the plug in the zone write plug error list of the disk.
> + * @ref: Zone write plug reference counter. A zone write plug reference is
> + *       always at least 1 when the plug is hashed in the disk plug hash table.
> + *       The reference is incremented whenever a new BIO needing plugging is
> + *       submitted and when a function needs to manipulate a plug. The
> + *       reference count is decremented whenever a plugged BIO completes and
> + *       when a function that referenced the plug returns. The initial
> + *       reference is dropped whenever the zone of the zone write plug is reset,
> + *       finished and when the zone becomes full (last write BIO to the zone
> + *       completes).
> + * @lock: Spinlock to atomically manipulate the plug.
> + * @flags: Flags indicating the plug state.
> + * @zone_no: The number of the zone the plug is managing.
> + * @wp_offset: The zone write pointer location relative to the start of the zone
> + *             as a number of 512B sectors.
> + * @bio_list: The list of BIOs that are currently plugged.
> + * @bio_work: Work struct to handle issuing of plugged BIOs
> + * @rcu_head: RCU head to free zone write plugs with an RCU grace period.
> + * @disk: The gendisk the plug belongs to.
> + */
> +struct blk_zone_wplug {
> +	struct hlist_node	node;
> +	struct list_head	link;
> +	atomic_t		ref;
> +	spinlock_t		lock;
> +	unsigned int		flags;
> +	unsigned int		zone_no;
> +	unsigned int		wp_offset;
> +	struct bio_list		bio_list;
> +	struct work_struct	bio_work;
> +	struct rcu_head		rcu_head;
> +	struct gendisk		*disk;
> +};
> +
> +/*
> + * Zone write plug flags bits:
> + *  - BLK_ZONE_WPLUG_PLUGGED: Indicate that the zone write plug is plugged,
> + *    that is, that write BIOs are being throttled due to a write BIO already
> + *    being executed or the zone write plug bio list is not empty.
> + *  - BLK_ZONE_WPLUG_ERROR: Indicate that a write error happened which will be
> + *    recovered with a report zone to update the zone write pointer offset.
> + *  - BLK_ZONE_WPLUG_UNHASHED: Indicates that the zone write plug was removed
> + *    from the disk hash table and that the initial reference to the zone
> + *    write plug set when the plug was first added to the hash table has been
> + *    dropped. This flag is set when a zone is reset, finished or become full,
> + *    to prevent new references to the zone write plug to be taken for
> + *    newly incoming BIOs. A zone write plug flagged with this flag will be
> + *    freed once all remaining references from BIOs or functions are dropped.
> + */
> +#define BLK_ZONE_WPLUG_PLUGGED		(1U << 0)
> +#define BLK_ZONE_WPLUG_ERROR		(1U << 1)
> +#define BLK_ZONE_WPLUG_UNHASHED		(1U << 2)
> +
> +#define BLK_ZONE_WPLUG_BUSY	(BLK_ZONE_WPLUG_PLUGGED | BLK_ZONE_WPLUG_ERROR)
> +
>   /**
>    * blk_zone_cond_str - Return string XXX in BLK_ZONE_COND_XXX.
>    * @zone_cond: BLK_ZONE_COND_XXX.
> @@ -425,12 +487,1027 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
>   	return ret;
>   }
>   
> -void disk_free_zone_bitmaps(struct gendisk *disk)
> +static inline bool disk_zone_is_conv(struct gendisk *disk, sector_t sector)
> +{
> +	if (!disk->conv_zones_bitmap)
> +		return false;
> +	return test_bit(disk_zone_no(disk, sector), disk->conv_zones_bitmap);
> +}
> +
> +static inline bool bio_zone_is_conv(struct bio *bio)
> +{
> +	return disk_zone_is_conv(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
> +}
> +
> +static bool disk_insert_zone_wplug(struct gendisk *disk,
> +				   struct blk_zone_wplug *zwplug)
> +{
> +	struct blk_zone_wplug *zwplg;
> +	unsigned long flags;
> +	unsigned int idx =
> +		hash_32(zwplug->zone_no, disk->zone_wplugs_hash_bits);
> +
> +	/*
> +	 * Add the new zone write plug to the hash table, but carefully as we
> +	 * are racing with other submission context, so we may already have a
> +	 * zone write plug for the same zone.
> +	 */
> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> +	hlist_for_each_entry_rcu(zwplg, &disk->zone_wplugs_hash[idx], node) {
> +		if (zwplg->zone_no == zwplug->zone_no) {
> +			spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +			return false;
> +		}
> +	}
> +	hlist_add_head_rcu(&zwplug->node, &disk->zone_wplugs_hash[idx]);
> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +
> +	return true;
> +}
> +
> +static void disk_remove_zone_wplug(struct gendisk *disk,
> +				   struct blk_zone_wplug *zwplug)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> +	zwplug->flags |= BLK_ZONE_WPLUG_UNHASHED;
> +	atomic_dec(&zwplug->ref);
> +	hlist_del_init_rcu(&zwplug->node);
> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +}
> +
> +static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
> +						 struct blk_zone_wplug *zwplug)
> +{
> +	/* If the zone is still busy, the plug cannot be removed. */
> +	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY)
> +		return false;
> +
> +	/* We can remove zone write plugs for zones that are empty or full. */
> +	return !zwplug->wp_offset ||
> +		zwplug->wp_offset >= disk->zone_capacity;
> +}
> +
> +static inline struct blk_zone_wplug *
> +disk_lookup_zone_wplug(struct gendisk *disk, sector_t sector)
> +{
> +	unsigned int zno = disk_zone_no(disk, sector);
> +	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
> +	struct blk_zone_wplug *zwplug;
> +
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
> +		if (zwplug->zone_no == zno)
> +			goto unlock;
> +	}
> +	zwplug = NULL;
> +
> +unlock:
> +	rcu_read_unlock();
> +	return zwplug;
> +}
> +
> +static inline struct blk_zone_wplug *bio_lookup_zone_wplug(struct bio *bio)
> +{
> +	return disk_lookup_zone_wplug(bio->bi_bdev->bd_disk,
> +				      bio->bi_iter.bi_sector);
> +}
> +
> +static inline void blk_get_zone_wplug(struct blk_zone_wplug *zwplug)
> +{
> +	atomic_inc(&zwplug->ref);
> +}
> +
> +static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
> +						  sector_t sector)
> +{
> +	struct blk_zone_wplug *zwplug;
> +
> +	rcu_read_lock();
> +	zwplug = disk_lookup_zone_wplug(disk, sector);
> +	if (zwplug && !atomic_inc_not_zero(&zwplug->ref))
> +		zwplug = NULL;
> +	rcu_read_unlock();
> +
> +	return zwplug;
> +}
> +
> +static void disk_free_zone_wplug_rcu(struct rcu_head *rcu_head)
> +{
> +	struct blk_zone_wplug *zwplug =
> +		container_of(rcu_head, struct blk_zone_wplug, rcu_head);
> +
> +	mempool_free(zwplug, zwplug->disk->zone_wplugs_pool);
> +}
> +
> +static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
> +{
> +	if (atomic_dec_and_test(&zwplug->ref)) {
> +		WARN_ON_ONCE(!bio_list_empty(&zwplug->bio_list));
> +		WARN_ON_ONCE(!list_empty(&zwplug->link));
> +
> +		call_rcu(&zwplug->rcu_head, disk_free_zone_wplug_rcu);
> +	}
> +}
> +
> +static void blk_zone_wplug_bio_work(struct work_struct *work);
> +
> +/*
> + * Get a reference on the write plug for the zone containing @sector.
> + * If the plug does not exist, it is allocated and hashed.
> + * Return a pointer to the zone write plug with the plug spinlock held.
> + */
> +static struct blk_zone_wplug *disk_get_and_lock_zone_wplug(struct gendisk *disk,
> +					sector_t sector, gfp_t gfp_mask,
> +					unsigned long *flags)
> +{
> +	unsigned int zno = disk_zone_no(disk, sector);
> +	struct blk_zone_wplug *zwplug;
> +
> +again:
> +	zwplug = disk_get_zone_wplug(disk, sector);
> +	if (zwplug) {
> +		/*
> +		 * Check that a BIO completion or a zone reset or finish
> +		 * operation has not already removed the zone write plug from
> +		 * the hash table and dropped its reference count. In such case,
> +		 * we need to get a new plug so start over from the beginning.
> +		 */
> +		spin_lock_irqsave(&zwplug->lock, *flags);
> +		if (zwplug->flags & BLK_ZONE_WPLUG_UNHASHED) {
> +			spin_unlock_irqrestore(&zwplug->lock, *flags);
> +			disk_put_zone_wplug(zwplug);
> +			goto again;
> +		}
> +		return zwplug;
> +	}
> +
> +	/*
> +	 * Allocate and initialize a zone write plug with an extra reference
> +	 * so that it is not freed when the zone write plug becomes idle without
> +	 * the zone being full.
> +	 */
> +	zwplug = mempool_alloc(disk->zone_wplugs_pool, gfp_mask);
> +	if (!zwplug)
> +		return NULL;
> +
> +	INIT_HLIST_NODE(&zwplug->node);
> +	INIT_LIST_HEAD(&zwplug->link);
> +	atomic_set(&zwplug->ref, 2);
> +	spin_lock_init(&zwplug->lock);
> +	zwplug->flags = 0;
> +	zwplug->zone_no = zno;
> +	zwplug->wp_offset = sector & (disk->queue->limits.chunk_sectors - 1);
> +	bio_list_init(&zwplug->bio_list);
> +	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
> +	zwplug->disk = disk;
> +
> +	spin_lock_irqsave(&zwplug->lock, *flags);
> +
> +	/*
> +	 * Insert the new zone write plug in the hash table. This can fail only
> +	 * if another context already inserted a plug. Retry from the beginning
> +	 * in such case.
> +	 */
> +	if (!disk_insert_zone_wplug(disk, zwplug)) {
> +		spin_unlock_irqrestore(&zwplug->lock, *flags);
> +		mempool_free(zwplug, disk->zone_wplugs_pool);
> +		goto again;
> +	}
> +
> +	return zwplug;
> +}
> +
> +static struct blk_zone_wplug *bio_get_and_lock_zone_wplug(struct bio *bio,
> +							  unsigned long *flags)
> +{
> +	gfp_t gfp_mask;
> +
> +	if (bio->bi_opf & REQ_NOWAIT)
> +		gfp_mask = GFP_NOWAIT;
> +	else
> +		gfp_mask = GFP_NOIO;
> +
> +	return disk_get_and_lock_zone_wplug(bio->bi_bdev->bd_disk,
> +				bio->bi_iter.bi_sector, gfp_mask, flags);
> +}
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
> +/*
> + * Abort (fail) all plugged BIOs of a zone write plug.
> + */
> +static void disk_zone_wplug_abort(struct blk_zone_wplug *zwplug)
> +{
> +	struct bio *bio;
> +
> +	while ((bio = bio_list_pop(&zwplug->bio_list))) {
> +		blk_zone_wplug_bio_io_error(bio);
> +		disk_put_zone_wplug(zwplug);
> +	}
> +}
> +
> +/*
> + * Abort (fail) all plugged BIOs of a zone write plug that are not aligned
> + * with the assumed write pointer location of the zone when the BIO will
> + * be unplugged.
> + */
> +static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
> +					    struct blk_zone_wplug *zwplug)
> +{
> +	unsigned int zone_capacity = disk->zone_capacity;
> +	unsigned int wp_offset = zwplug->wp_offset;
> +	struct bio_list bl = BIO_EMPTY_LIST;
> +	struct bio *bio;
> +
> +	while ((bio = bio_list_pop(&zwplug->bio_list))) {
> +		if (wp_offset >= zone_capacity ||
> +		     bio_offset_from_zone_start(bio) != wp_offset) {
> +			blk_zone_wplug_bio_io_error(bio);
> +			disk_put_zone_wplug(zwplug);
> +			continue;
> +		}
> +
> +		wp_offset += bio_sectors(bio);
> +		bio_list_add(&bl, bio);
> +	}
> +
> +	bio_list_merge(&zwplug->bio_list, &bl);
> +}
> +
> +/*
> + * Set a zone write plug write pointer offset to either 0 (zone reset case)
> + * or to the zone size (zone finish case). This aborts all plugged BIOs, which
> + * is fine to do as doing a zone reset or zone finish while writes are in-flight
> + * is a mistake from the user which will most likely cause all plugged BIOs to
> + * fail anyway.
> + */
> +static void disk_zone_wplug_set_wp_offset(struct gendisk *disk,
> +					  struct blk_zone_wplug *zwplug,
> +					  unsigned int wp_offset)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&zwplug->lock, flags);
> +
> +	/*
> +	 * Make sure that a BIO completion or another zone reset or finish
> +	 * operation has not already removed the plug from the hash table.
> +	 */
> +	if (zwplug->flags & BLK_ZONE_WPLUG_UNHASHED) {
> +		spin_unlock_irqrestore(&zwplug->lock, flags);
> +		return;
> +	}
> +
> +	/* Update the zone write pointer and abort all plugged BIOs. */
> +	zwplug->wp_offset = wp_offset;
> +	disk_zone_wplug_abort(zwplug);
> +
> +	/*
> +	 * Updating the write pointer offset puts back the zone
> +	 * in a good state. So clear the error flag and decrement the
> +	 * error count if we were in error state.
> +	 */
> +	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
> +		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
> +		spin_lock(&disk->zone_wplugs_lock);
> +		list_del_init(&zwplug->link);
> +		spin_unlock(&disk->zone_wplugs_lock);
> +	}
> +
> +	/*
> +	 * The zone write plug now has no BIO plugged: remove it from the
> +	 * hash table so that it cannot be seen. The plug will be freed
> +	 * when the last reference is dropped.
> +	 */
> +	if (disk_should_remove_zone_wplug(disk, zwplug))
> +		disk_remove_zone_wplug(disk, zwplug);
> +
> +	spin_unlock_irqrestore(&zwplug->lock, flags);
> +}
> +
> +static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
> +						  unsigned int wp_offset)
> +{
> +	struct gendisk *disk = bio->bi_bdev->bd_disk;
> +	struct blk_zone_wplug *zwplug;
> +
> +	/* Conventional zones cannot be reset nor finished. */
> +	if (bio_zone_is_conv(bio)) {
> +		bio_io_error(bio);
> +		return true;
> +	}
> +
> +	/*
> +	 * If we have a zone write plug, set its write pointer offset to 0
> +	 * (reset case) or to the zone size (finish case). This will abort all
> +	 * BIOs plugged for the target zone. It is fine as resetting or
> +	 * finishing zones while writes are still in-flight will result in the
> +	 * writes failing anyway.
> +	 */
> +	zwplug = disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
> +	if (zwplug) {
> +		disk_zone_wplug_set_wp_offset(disk, zwplug, wp_offset);
> +		disk_put_zone_wplug(zwplug);
> +	}
> +
> +	return false;
> +}
> +
> +static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
> +{
> +	struct gendisk *disk = bio->bi_bdev->bd_disk;
> +	struct blk_zone_wplug *zwplug;
> +	sector_t sector;
> +
> +	/*
> +	 * Set the write pointer offset of all zone write plugs to 0. This will
> +	 * abort all plugged BIOs. It is fine as resetting zones while writes
> +	 * are still in-flight will result in the writes failing anyway.
> +	 */
> +	for (sector = 0; sector < get_capacity(disk);
> +	     sector += disk->queue->limits.chunk_sectors) {
> +		zwplug = disk_get_zone_wplug(disk, sector);
> +		if (zwplug) {
> +			disk_zone_wplug_set_wp_offset(disk, zwplug, 0);
> +			disk_put_zone_wplug(zwplug);
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
> +					  struct bio *bio, unsigned int nr_segs)
> +{
> +	/*
> +	 * Grab an extra reference on the BIO request queue usage counter.
> +	 * This reference will be reused to submit a request for the BIO for
> +	 * blk-mq devices and dropped when the BIO is failed and after
> +	 * it is issued in the case of BIO-based devices.
> +	 */
> +	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
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
> +	struct blk_zone_wplug *zwplug;
> +	unsigned long flags;
> +
> +	/*
> +	 * If the BIO was already plugged, then we were called through
> +	 * blk_zone_write_plug_attempt_merge() -> blk_attempt_bio_merge().
> +	 * For this case, blk_zone_write_plug_attempt_merge() will handle the
> +	 * zone write pointer offset update.
> +	 */
> +	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
> +		return;
> +
See? you have to check anyway ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

