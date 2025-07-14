Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE6724CEE8;
	Mon, 14 Jul 2025 19:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752520675; cv=none; b=KpqTYDjq3zCJmXHwKPW0hhK6tHqyJvQ/FIdpTZSv8V2l282FwWGZiXqU+JyU/mvGUlsh3zkcCMhOgdmXHsNlgynxOYleBM9YA0DQWQ4yMeUWUlsoz+12H68vJdJeKxjZJVaU8PTNBUkiukxZN8DENUi02omidEr4jG39ldEAEQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752520675; c=relaxed/simple;
	bh=LKAYvsGhbzMBfXcm9sHDq2Ipwz7ReozskbUDhi8Wgbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UIXE7l46/TD65WanBm5kBR68RBRyxfwOELvUcuPINO0pHTzQuxNXu137IVWY7tuK+hUYDwERnWHi89qBK82Z2qntzyYXdAB2mmPvNEq4aelN8aP6FKbwNkO0yxHtDev3YXJNPqBqDUhJUJoZbpS1AswRDHEQMbs8Z4cYYlP2+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GF9yyVwn; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GF9yyVwn"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bgsXV6P2hzlv764;
	Mon, 14 Jul 2025 19:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752520665; x=1755112666; bh=F4cHB5ZXO8KGBbrVOmj/9zi9
	SjD1tVKrUlMXzU0k57E=; b=GF9yyVwnnkqpOsS1dlubN5SJd553sN4PN0iXXsk+
	1igwHyZk3w29LTufiNTfvPEM8OZrKm2hFaT1IgQ/D1Ui3L4MM11/fMZrJevlcxW9
	ekI5CUc8ox/D4NODJYmmtWQXByzeTIovtzkgNM3smYSIl+GjkPgCGbRKm/IK21q9
	eGFN6CST7u/a8W864HYrOQewfy22hxVr94MKLPUOxfiuHDms4+mkK2xQw2Jf67fS
	mSB47FGuW5PudltcWnwwcrsjkiZ++jskbqSvsMpTXfu+ca/Cm+pGBui3ueN1ZtgC
	76yLr5Tqr6eLyvOy4PPg+0P2Snp9ijZ7mv3KFa5h0ryoxQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s9Y5YFqX31UN; Mon, 14 Jul 2025 19:17:45 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bgsXQ4MCzzltBDV;
	Mon, 14 Jul 2025 19:17:41 +0000 (UTC)
Message-ID: <a299c187-1a62-45cb-b9fe-13e31a6bf276@acm.org>
Date: Mon, 14 Jul 2025 12:17:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 07/13] blk-zoned: Support pipelining of zoned writes
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-8-bvanassche@acm.org>
 <bf33405e-f8f5-4d7f-b2e9-8fe84fbd1092@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bf33405e-f8f5-4d7f-b2e9-8fe84fbd1092@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/25 10:09 PM, Damien Le Moal wrote:
> On 7/9/25 7:07 AM, Bart Van Assche wrote:
>> @@ -932,7 +939,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
>>   	 * We know such BIO will fail, and that would potentially overflow our
>>   	 * write pointer offset beyond the end of the zone.
>>   	 */
>> -	if (disk_zone_wplug_is_full(disk, zwplug))
>> +	if (!disk->queue->limits.driver_preserves_write_order
>> +	    && disk_zone_wplug_is_full(disk, zwplug))
> 
> Writing to a zone that is full is an error, pipelining or not. So why do you
> change this ? This does not make sense.

Agreed. I will drop this change.

>> @@ -956,7 +964,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
>>   		 * with a start sector not unaligned to the zone write pointer
>>   		 * will fail.
>>   		 */
>> -		if (bio_offset_from_zone_start(bio) != zwplug->wp_offset)
>> +		if (!disk->queue->limits.driver_preserves_write_order
>> +		    && bio_offset_from_zone_start(bio) != zwplug->wp_offset)
> 
> Same here. This does not depend pipelining: write should have been received in
> order and be aligned with the wp. So why change this condition ?

Agreed. I will drop this change too. The reason I hit this and the above
condition is because the blk_zone_wplug_prepare_bio() call in this patch
is misplaced: it should happen after all the 'goto plug' statements
instead of before.

>> @@ -1298,6 +1329,9 @@ static void blk_zone_submit_one_bio(struct blk_zone_wplug *zwplug)
>>   	} else {
>>   		blk_mq_submit_bio(bio);
>>   	}
>> +
>> +	return disk->queue->limits.driver_preserves_write_order &&
>> +		!need_resched();
> 
> I think we really need a helper for that
> "disk->queue->limits.driver_preserves_write_order". But if you make this a
> feature, it will be better.
> 
> Also, here, the test using need_resched() really need a comment explaining why
> you look at that. I do not get it personally.

The need_resched() call was added to break out of the loop if another
thread would be runnable. Anyway, since I'm not sure that call is needed
so I will drop it.

It would be appreciated if you could take a look at the reworked version
of this patch below before I repost the entire series. The changes
compared to the patch at the start of this email thread are as follows:
- The ternary operator in the queue_work_on() call has been converted
   into an if/then/else statement.
- The two blk_zone_wplug_prepare_bio() changes have been dropped.
- The behavior changes for zone append writes in
   blk_zone_wplug_handle_write() have been dropped.
- blk_zone_wplug_handle_write() has been changed such that
   blk_zone_wplug_prepare_bio() is only called once for each bio.
- blk_zone_wplug_handle_write() has been modified such that no
   plugging happens if a cached request has been allocated from the
   same cpu as zwplug->from_cpu.
- The function blk_zone_submit_one_bio() has been removed and has been
   inlined into its only caller, blk_zone_wplug_bio_work().

Thanks,

Bart.


[PATCH] blk-zoned: Support pipelining of zoned writes

Support pipelining of zoned writes if the block driver preserves the write
order per hardware queue. Track per zone to which software queue writes
have been queued. If zoned writes are pipelined, submit new writes to the
same software queue as the writes that are already in progress. This
prevents reordering by submitting requests for the same zone to different
software or hardware queues.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  block/blk-mq.c    |  4 +--
  block/blk-zoned.c | 67 ++++++++++++++++++++++++++++++++++++++---------
  2 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5d216940e9fe..76c45bf81b02 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3148,8 +3148,8 @@ void blk_mq_submit_bio(struct bio *bio)
  	/*
  	 * A BIO that was released from a zone write plug has already been
  	 * through the preparation in this function, already holds a reference
-	 * on the queue usage counter, and is the only write BIO in-flight for
-	 * the target zone. Go straight to preparing a request for it.
+	 * on the queue usage counter. Go straight to preparing a request for
+	 * it.
  	 */
  	if (bio_zone_write_plugging(bio)) {
  		nr_segs = bio->__bi_nr_segments;
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index de3fb0cd6d37..d9d624d90693 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -53,6 +53,8 @@ static const char *const zone_cond_name[] = {
   * @zone_no: The number of the zone the plug is managing.
   * @wp_offset: The zone write pointer location relative to the start 
of the zone
   *             as a number of 512B sectors.
+ * @from_cpu: Software queue to submit writes from for drivers that 
preserve
+ *	the write order.
   * @bio_list: The list of BIOs that are currently plugged.
   * @bio_work: Work struct to handle issuing of plugged BIOs
   * @rcu_head: RCU head to free zone write plugs with an RCU grace period.
@@ -65,6 +67,7 @@ struct blk_zone_wplug {
  	unsigned int		flags;
  	unsigned int		zone_no;
  	unsigned int		wp_offset;
+	int			from_cpu;
  	struct bio_list		bio_list;
  	struct work_struct	bio_work;
  	struct rcu_head		rcu_head;
@@ -74,8 +77,7 @@ struct blk_zone_wplug {
  /*
   * Zone write plug flags bits:
   *  - BLK_ZONE_WPLUG_PLUGGED: Indicates that the zone write plug is 
plugged,
- *    that is, that write BIOs are being throttled due to a write BIO 
already
- *    being executed or the zone write plug bio list is not empty.
+ *    that is, that write BIOs are being throttled.
   *  - BLK_ZONE_WPLUG_NEED_WP_UPDATE: Indicates that we lost track of a 
zone
   *    write pointer offset and need to update it.
   *  - BLK_ZONE_WPLUG_UNHASHED: Indicates that the zone write plug was 
removed
@@ -572,6 +574,7 @@ static struct blk_zone_wplug 
*disk_get_and_lock_zone_wplug(struct gendisk *disk,
  	zwplug->flags = 0;
  	zwplug->zone_no = zno;
  	zwplug->wp_offset = bdev_offset_from_zone_start(disk->part0, sector);
+	zwplug->from_cpu = -1;
  	bio_list_init(&zwplug->bio_list);
  	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
  	zwplug->disk = disk;
@@ -768,14 +771,19 @@ static bool blk_zone_wplug_handle_reset_all(struct 
bio *bio)
  static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
  					      struct blk_zone_wplug *zwplug)
  {
+	lockdep_assert_held(&zwplug->lock);
+
  	/*
  	 * Take a reference on the zone write plug and schedule the submission
  	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
  	 * reference we take here.
  	 */
-	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
  	refcount_inc(&zwplug->ref);
-	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
+	if (zwplug->from_cpu >= 0)
+		queue_work_on(zwplug->from_cpu, disk->zone_wplugs_wq,
+			      &zwplug->bio_work);
+	else
+		queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
  }

  static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
@@ -972,9 +980,12 @@ static bool blk_zone_wplug_prepare_bio(struct 
blk_zone_wplug *zwplug,
  	return true;
  }

-static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int 
nr_segs)
+static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int 
nr_segs,
+					int from_cpu)
  {
  	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	const bool ordered_hwq = bio_op(bio) != REQ_OP_ZONE_APPEND &&
+		(disk->queue->limits.features & BLK_FEAT_ORDERED_HWQ);
  	sector_t sector = bio->bi_iter.bi_sector;
  	bool schedule_bio_work = false;
  	struct blk_zone_wplug *zwplug;
@@ -1034,15 +1045,36 @@ static bool blk_zone_wplug_handle_write(struct 
bio *bio, unsigned int nr_segs)
  	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
  		goto add_to_bio_list;

+	if (ordered_hwq && zwplug->from_cpu < 0) {
+		/* No zoned writes are in progress. Select the current CPU. */
+		zwplug->from_cpu = raw_smp_processor_id();
+	}
+	if (ordered_hwq && zwplug->from_cpu == from_cpu) {
+		/*
+		 * The block driver preserves the write order, zoned writes have
+		 * not been plugged and the zoned write will be submitted from
+		 * zwplug->from_cpu. Let the caller submit the bio.
+		 */
+	} else if (ordered_hwq) {
+		/*
+		 * The block driver preserves the write order. Submit the bio
+		 * from zwplug->from_cpu.
+		 */
+		goto plug;
+	} else {
+		/*
+		 * The block driver does not preserve the write order. Plug and
+		 * submit the BIO.
+		 */
+		zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
+	}
+
  	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
  		spin_unlock_irqrestore(&zwplug->lock, flags);
  		bio_io_error(bio);
  		return true;
  	}

-	/* Otherwise, plug and submit the BIO. */
-	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
-
  	spin_unlock_irqrestore(&zwplug->lock, flags);

  	return false;
@@ -1150,7 +1182,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned 
int nr_segs, int rq_cpu)
  		fallthrough;
  	case REQ_OP_WRITE:
  	case REQ_OP_WRITE_ZEROES:
-		return blk_zone_wplug_handle_write(bio, nr_segs);
+		return blk_zone_wplug_handle_write(bio, nr_segs, rq_cpu);
  	case REQ_OP_ZONE_RESET:
  		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
  	case REQ_OP_ZONE_FINISH:
@@ -1182,6 +1214,9 @@ static void disk_zone_wplug_unplug_bio(struct 
gendisk *disk,

  	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;

+	if (refcount_read(&zwplug->ref) == 2)
+		zwplug->from_cpu = -1;
+
  	/*
  	 * If the zone is full (it was fully written or finished, or empty
  	 * (it was reset), remove its zone write plug from the hash table.
@@ -1283,6 +1318,7 @@ static void blk_zone_wplug_bio_work(struct 
work_struct *work)
  	struct blk_zone_wplug *zwplug =
  		container_of(work, struct blk_zone_wplug, bio_work);
  	struct block_device *bdev;
+	bool ordered_hwq;
  	struct bio *bio;

  	do {
@@ -1303,6 +1339,8 @@ static void blk_zone_wplug_bio_work(struct 
work_struct *work)
  						 bio->bi_iter.bi_sector,
  						 bio_sectors(bio));

+			ordered_hwq = zwplug->disk->queue->limits.features &
+				BLK_FEAT_ORDERED_HWQ;
  			if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
  				blk_zone_wplug_bio_io_error(zwplug, bio);
  				goto again;
@@ -1323,7 +1361,7 @@ static void blk_zone_wplug_bio_work(struct 
work_struct *work)
  		} else {
  			blk_mq_submit_bio(bio);
  		}
-	} while (0);
+	} while (ordered_hwq);

  put_zwplug:
  	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). */
@@ -1850,6 +1888,7 @@ static void queue_zone_wplug_show(struct 
blk_zone_wplug *zwplug,
  	unsigned int zwp_zone_no, zwp_ref;
  	unsigned int zwp_bio_list_size;
  	unsigned long flags;
+	int from_cpu;

  	spin_lock_irqsave(&zwplug->lock, flags);
  	zwp_zone_no = zwplug->zone_no;
@@ -1857,10 +1896,12 @@ static void queue_zone_wplug_show(struct 
blk_zone_wplug *zwplug,
  	zwp_ref = refcount_read(&zwplug->ref);
  	zwp_wp_offset = zwplug->wp_offset;
  	zwp_bio_list_size = bio_list_size(&zwplug->bio_list);
+	from_cpu = zwplug->from_cpu;
  	spin_unlock_irqrestore(&zwplug->lock, flags);

-	seq_printf(m, "%u 0x%x %u %u %u\n", zwp_zone_no, zwp_flags, zwp_ref,
-		   zwp_wp_offset, zwp_bio_list_size);
+	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u bio_list_size 
%u from_cpu %d\n",
+		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
+		   zwp_bio_list_size, from_cpu);
  }

  int queue_zone_wplugs_show(void *data, struct seq_file *m)

