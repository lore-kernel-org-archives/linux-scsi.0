Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666F486334;
	Thu, 10 Jul 2025 05:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752124327; cv=none; b=BS5tCjhYK3kH6SaqVb2bXU4BtzOnP9tMA5IOvjtmPtpzEMjC6hQhNkEoJE3zDODClSPgvfaXoznC3eVcISf85yK3AM1eUOAsR7gy3u+msb50S43BbzclaAnYZ/z6W/De7cDETsy7f4u2gXTn1IyRubWNGnXzB6+40DG0Trqna9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752124327; c=relaxed/simple;
	bh=9ipx1PIcaCR8z/8TB7Hq3zIR9LrhbbvCb1EsCWmBziM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzmspxwyPcQxf+xJ3WFku38UCCGWfOxxwA3maI6SonVHNkAjEIJ/nQEct0rHu8tdG9Y8S9xNcCkAMUiLFzKa53smfv2Wp2b5+xNOpzPNAdVeYPS7h49KJvMbX9gRuX1d+iFEhHp9L8DbRhzA1F7C3n6b3p5iYRbgCINpxNUt9js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qGMje1UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qGMje1UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49197C4CEE3;
	Thu, 10 Jul 2025 05:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752124327;
	bh=9ipx1PIcaCR8z/8TB7Hq3zIR9LrhbbvCb1EsCWmBziM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qGMje1UHVygJO9y1hQkc54ypgTS7SjP1cvrlOXM2L6+WGo6+UX2HdrRQF4yOEh77X
	 uDrXt6psZhdWKxfQ2DEJwx9Na8xL30OmbFI8AGFSIfOc0+bkNSUFa3atLw6TWAVRMy
	 ksbR4TT0Wdw2sXgGI0eppIsyKMhbkW/6rUDU9vI1hbozfmByrx9Ty66s7Yold/Rk97
	 G0+iqinLva5D+LqgNFqsWpql5OWh10s1mC4ztZ1OeGRJLkIiMZjkaJccvUZnOWjCsQ
	 60a2xlDNDVJGxjC+c6CUIhAwji7BJjLgRtpLS5XKJVwcgwfT75cskFtkHvxwi0i/VP
	 DNr69RPsMLWzg==
Message-ID: <bf33405e-f8f5-4d7f-b2e9-8fe84fbd1092@kernel.org>
Date: Thu, 10 Jul 2025 14:09:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 07/13] blk-zoned: Support pipelining of zoned writes
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-8-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250708220710.3897958-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 7:07 AM, Bart Van Assche wrote:
> Support pipelining of zoned writes if the block driver preserves the write
> order per hardware queue. Track per zone to which software queue writes
> have been queued. If zoned writes are pipelined, submit new writes to the
> same software queue as the writes that are already in progress. This
> prevents reordering by submitting requests for the same zone to different
> software or hardware queues.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

[...]

> @@ -764,14 +767,18 @@ static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
>  static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
>  					      struct blk_zone_wplug *zwplug)
>  {
> +	int cpu;
> +
> +	lockdep_assert_held(&zwplug->lock);
> +
>  	/*
>  	 * Take a reference on the zone write plug and schedule the submission
>  	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
>  	 * reference we take here.
>  	 */
> -	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
>  	refcount_inc(&zwplug->ref);
> -	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
> +	cpu = zwplug->from_cpu >= 0 ? zwplug->from_cpu : WORK_CPU_UNBOUND;
> +	queue_work_on(cpu, disk->zone_wplugs_wq, &zwplug->bio_work);

Please change this to a more readable form with an expanded "if". The local
variable "cpu" should probably be named "work_cpu" for clarity too.

>  }
>  
>  static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
> @@ -932,7 +939,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
>  	 * We know such BIO will fail, and that would potentially overflow our
>  	 * write pointer offset beyond the end of the zone.
>  	 */
> -	if (disk_zone_wplug_is_full(disk, zwplug))
> +	if (!disk->queue->limits.driver_preserves_write_order
> +	    && disk_zone_wplug_is_full(disk, zwplug))

Writing to a zone that is full is an error, pipelining or not. So why do you
change this ? This does not make sense.

>  		return false;
>  
>  	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
> @@ -956,7 +964,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
>  		 * with a start sector not unaligned to the zone write pointer
>  		 * will fail.
>  		 */
> -		if (bio_offset_from_zone_start(bio) != zwplug->wp_offset)
> +		if (!disk->queue->limits.driver_preserves_write_order
> +		    && bio_offset_from_zone_start(bio) != zwplug->wp_offset)

Same here. This does not depend pipelining: write should have been received in
order and be aligned with the wp. So why change this condition ?

>  			return false;
>  	}
>  

> @@ -1033,8 +1044,23 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>  		return true;
>  	}
>  
> -	/* Otherwise, plug and submit the BIO. */
> -	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> +	if (dpwo && zwplug->from_cpu < 0) {
> +		/* No zoned writes are in progress. Select the current CPU. */
> +		zwplug->from_cpu = raw_smp_processor_id();
> +		goto plug;
> +	} else if (dpwo) {
> +		/*
> +		 * The block driver preserves the write order. Submit the bio
> +		 * from zwplug->from_cpu.
> +		 */
> +		goto plug;

Can you change this to:

	if (dpwo) {
		/*
		 * The block driver preserves the write order: if we do not
		 * have any writes in progress already, use the current CPU
		 * to submit the BIO. Otherwise, keep using zwplug->from_cpu.
		 */
		if (zwplug->from_cpu < 0)
			zwplug->from_cpu = raw_smp_processor_id();
		goto plug;
	}

	/*
	 * The block driver does not preserve the write order. Plug and
	 * submit the BIO.
	 */
	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;

That is a lot simpler and easier to read.

> +	} else {
> +		/*
> +		 * The block driver does not preserve the write order. Plug and
> +		 * submit the BIO.
> +		 */
> +		zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> +	}
>  
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
>  

> @@ -1298,6 +1329,9 @@ static void blk_zone_submit_one_bio(struct blk_zone_wplug *zwplug)
>  	} else {
>  		blk_mq_submit_bio(bio);
>  	}
> +
> +	return disk->queue->limits.driver_preserves_write_order &&
> +		!need_resched();

I think we really need a helper for that
"disk->queue->limits.driver_preserves_write_order". But if you make this a
feature, it will be better.

Also, here, the test using need_resched() really need a comment explaining why
you look at that. I do not get it personally.

>  }
>  
>  static void blk_zone_wplug_bio_work(struct work_struct *work)
> @@ -1305,7 +1339,8 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
>  	struct blk_zone_wplug *zwplug =
>  		container_of(work, struct blk_zone_wplug, bio_work);
>  
> -	blk_zone_submit_one_bio(zwplug);
> +	while (blk_zone_submit_one_bio(zwplug))
> +		;

So patch 6 split created that blk_zone_submit_one_bio() function, but all you
do here is this change. I really do not see how that is better. Let's not do
that and simply have the loop expanded here to something like:

	do {
		...
	} while (disk->queue->limits.driver_preserves_write_order &&
		 !need_resched());

>  
>  	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). */
>  	disk_put_zone_wplug(zwplug);
> @@ -1831,6 +1866,7 @@ static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
>  	unsigned int zwp_zone_no, zwp_ref;
>  	unsigned int zwp_bio_list_size;
>  	unsigned long flags;
> +	int from_cpu;
>  
>  	spin_lock_irqsave(&zwplug->lock, flags);
>  	zwp_zone_no = zwplug->zone_no;
> @@ -1838,10 +1874,12 @@ static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
>  	zwp_ref = refcount_read(&zwplug->ref);
>  	zwp_wp_offset = zwplug->wp_offset;
>  	zwp_bio_list_size = bio_list_size(&zwplug->bio_list);
> +	from_cpu = zwplug->from_cpu;
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
>  
> -	seq_printf(m, "%u 0x%x %u %u %u\n", zwp_zone_no, zwp_flags, zwp_ref,
> -		   zwp_wp_offset, zwp_bio_list_size);
> +	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u bio_list_size %u from_cpu %d\n",
> +		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
> +		   zwp_bio_list_size, from_cpu);
>  }
>  
>  int queue_zone_wplugs_show(void *data, struct seq_file *m)


-- 
Damien Le Moal
Western Digital Research
