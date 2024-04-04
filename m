Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEA221353;
	Thu,  4 Apr 2024 18:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712255491; cv=none; b=YZiPZEHtrghS69DhKmmW/BNEKNKGbPASEvDGCH8g8Iqt+LdRhIQlI1vrxjSflm4xB/7C9gMlLG6wDSINLoxsmycUV6U247wYDe5wEYLLSVmAv+hM7r0VT/J6O+mCE4mdMPNixO3S6jBXZQvPdtGaP4lomZ4iUV3yzXgr1oLiZ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712255491; c=relaxed/simple;
	bh=PcvChjU+05hYidr0P74zTR3IkHY+RRkfWeJpG2/V8HY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NFHAwQUHU++WbQrS6GkhrJSKYuzO+A9EZiLtCTTEdxc3FD8KKJbiWPsLVci/nLX8XDAOzbnEIaV+Iy+sipyw6kNhML2XNKZwwyZg9FstEY8iadM4Fd4i3mdKlGkLBMCQ7UJeOad1Lvgk+wrhVNbinRXbiBnbRchmmz5HvVlUyoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=izqsw0No; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="izqsw0No"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9VZ94bCjzlgTGW;
	Thu,  4 Apr 2024 18:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712255483; x=1714847484; bh=9U54RUAdkZyZ07sY4j66HIye
	Ac7HfOdJglXCmF2TRzg=; b=izqsw0Noej8uUBNstBrjtyH+0urCNSIw0S3CK18n
	WBmYIdk43WSKrLOY4KYgxGqu/kfQAQcCK4OnyzhT2D/pKJ7mi9J8JrYZzWl3mH2f
	eVK/aWiYUHyjx+8Mzm/V5OvxrajFu6S8jD8I05cBM9dWryHEiUiX8Ft7TbVXizzU
	0G29GahTVaquUzqsvCCLS2tH5uPrtDIYY2zFRHrqZF5A0DS0UndVS3NZftFIPup4
	/VBJjdHcNcQ4bL7NmvM7LYiBIVc+HHRQirm1qASzNrRoxTsiABe1AapuU4hLy4r2
	2+BpDpOSIQtbfx27rTejCdfz/hXCraYjKr6v1MfXKlJHfw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vAwPbDjo4E8x; Thu,  4 Apr 2024 18:31:23 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9VZ073Q0zlgTHp;
	Thu,  4 Apr 2024 18:31:20 +0000 (UTC)
Message-ID: <c3bbe9ac-690c-43a7-bc75-3634af5cfe7a@acm.org>
Date: Thu, 4 Apr 2024 11:31:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-8-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240403084247.856481-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 01:42, Damien Le Moal wrote:
> diff --git a/block/bio.c b/block/bio.c
> index d24420ed1c4c..127c06443bca 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1576,6 +1576,12 @@ void bio_endio(struct bio *bio)
>   	if (!bio_integrity_endio(bio))
>   		return;
>   
> +	/*
> +	 * For write BIOs to zoned devices, signal the completion of the BIO so
> +	 * that the next write BIO can be submitted by zone write plugging.
> +	 */
> +	blk_zone_write_bio_endio(bio);
> +
>   	rq_qos_done_bio(bio);

The function name "blk_zone_write_bio_endio()" is misleading since that
function is called for all bio operation types and not only for zoned
write bios. How about renaming blk_zone_write_bio_endio() into 
blk_zone_bio_endio()? If that function is renamed the above comment is
no longer necessary in bio_endio() and can be moved to above the
blk_zone_bio_endio() definition.

> @@ -1003,6 +1007,13 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
> +	/*
> +	 * A front merge for zone writes can happen only if the user submitted
> +	 * writes out of order. Do not attempt this to let the write fail.
> +	 */

"zone writes" -> "zoned writes"?

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 88b541e8873f..2c6a317bef7c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -828,6 +828,8 @@ static void blk_complete_request(struct request *req)
>   		bio = next;
>   	} while (bio);
>   
> +	blk_zone_write_complete_request(req);

Same comment here as above: the function name 
blk_zone_write_complete_request() is misleading since that function is
called for all request types and not only for zoned writes. Please
rename blk_zone_write_complete_request() into
blk_zone_complete_request().

> +	/*
> +	 * If the plug has a cached request for this queue, try use it.
> +	 */

try use it -> try to use it (I know this comes from upstream code).

> +	if (blk_queue_is_zoned(q) && blk_zone_write_plug_bio(bio, nr_segs))
> +		goto queue_exit;

The order of words in the blk_zone_write_plug_bio() function name seems
unusual to me. How about renaming that function into
blk_zone_plug_write_bio()?

> +/*
> + * Zone write plug flags bits:

Zone write -> zoned write

> + *  - BLK_ZONE_WPLUG_PLUGGED: Indicate that the zone write plug is plugged,

Indicate -> Indicates

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

The above code can be made easier to read and more compact by using
guard(spinlock_irqsave)(...) instead of spin_lock_irqsave() + 
spin_unlock_irqrestore().

> +static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
> +						  sector_t sector)
> +{
> +	unsigned int zno = disk_zone_no(disk, sector);
> +	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
> +	struct blk_zone_wplug *zwplug;
> +
> +	rcu_read_lock();
> +
> +	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
> +		if (zwplug->zone_no == zno &&
> +		    atomic_inc_not_zero(&zwplug->ref)) {
> +			rcu_read_unlock();
> +			return zwplug;
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return NULL;
> +}

The above code can also be made more compact by using guard(rcu)()
instead of rcu_read_lock() + rcu_read_unlock().

> +/*
> + * Get a reference on the write plug for the zone containing @sector.
> + * If the plug does not exist, it is allocated and hashed.
> + * Return a pointer to the zone write plug with the plug spinlock held.
> + */

Holding a spinlock upon return is not my favorite approach. Has the
following alternative been considered?
- Remove the spinlock flags argument from this function and instead add
   two other arguments: prev_plug_flags and new_plug_flags.
- If a zone plug is found or allocated, copy the existing zone plug
   flags into *prev_plug_flags and set the zone plug flags that have been
   passed in new_plug_flags (logical or).
- From blk_revalidate_zone_cb(), pass 0 as the new_plug_flags argument.
- From blk_zone_wplug_handle_write, pass BLK_ZONE_WPLUG_PLUGGED as the
   new_plug_flags argument.

Thanks,

Bart.
