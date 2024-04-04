Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3610548FE;
	Thu,  4 Apr 2024 23:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712272080; cv=none; b=nnP9KbsfFlLSQ+Vv7BNUf+PSXXt7zBBGq4ewbqRBzPEOtnxR/CNJOndqbg5/ntICgV2Wlm/L7drpsjwl1xTmXtZ5bX0wRBuOx0a2rejIq+Y8396XdA41WBrGR3sTqNqug3wXdtwMdcu8+3DdOPdGNXoy2FwpEoPK5D4VYTITU/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712272080; c=relaxed/simple;
	bh=abGUlmV1vVQ7YCVI+uOa12GAcN/m/0cKr0bYOhtUNPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GBDjqCPNsn0uq150hPvNFES+qoux1JyPmFw/NJEY7+PAQfHf1MU/vCZEdgdWYE1fJ+uLNPKfMXgNp1263xHJuVok65LxwQV+8phRVUtSbpssF9G6JI6vKaVWKYMPnnP3znMugHg3rRr2UYE0LS3juSRRMoZj84N/D8JBrHzXFHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RE3/C1/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RE3/C1/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0196EC433C7;
	Thu,  4 Apr 2024 23:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712272079;
	bh=abGUlmV1vVQ7YCVI+uOa12GAcN/m/0cKr0bYOhtUNPs=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=RE3/C1/RBawylk74wc2x7EtVz3GJq+PkBS+0Vz7G52YK8kBwlBrGovSyQhgolMP6a
	 VVGS3fopybPMxV1l2hB/Z4L6B6MaA+8uXGjll9/u/ThrZxZCdssLoJbx/PSmLsz8XH
	 HhJ27Lneq4XkyntvRC3J0qgZkRvIcn9QiPKFyFOKKhaCqxtFoQ5D8+0CHNaeCo8Q3J
	 6Haq2wNJ9ZzBWn0bQI77ZsGUn69DnJOfgGVxy+ngqB3D5mjkQtQJzcYAB32FZcikz5
	 qCvNEStdQCHQGJ+9ciGqfjQlqltaTTdwUz6WksMQNj5xplaeg7qO8kAi3XiDnJw15m
	 NRR2vNoQV+Flg==
Message-ID: <6e327f36-9b91-4693-b45f-0a1b006278be@kernel.org>
Date: Fri, 5 Apr 2024 08:07:56 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] block: Introduce zone write plugging
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-8-dlemoal@kernel.org>
 <c3bbe9ac-690c-43a7-bc75-3634af5cfe7a@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <c3bbe9ac-690c-43a7-bc75-3634af5cfe7a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/5/24 03:31, Bart Van Assche wrote:
> On 4/3/24 01:42, Damien Le Moal wrote:
>> diff --git a/block/bio.c b/block/bio.c
>> index d24420ed1c4c..127c06443bca 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -1576,6 +1576,12 @@ void bio_endio(struct bio *bio)
>>   	if (!bio_integrity_endio(bio))
>>   		return;
>>   
>> +	/*
>> +	 * For write BIOs to zoned devices, signal the completion of the BIO so
>> +	 * that the next write BIO can be submitted by zone write plugging.
>> +	 */
>> +	blk_zone_write_bio_endio(bio);
>> +
>>   	rq_qos_done_bio(bio);
> 
> The function name "blk_zone_write_bio_endio()" is misleading since that
> function is called for all bio operation types and not only for zoned
> write bios. How about renaming blk_zone_write_bio_endio() into 
> blk_zone_bio_endio()? If that function is renamed the above comment is
> no longer necessary in bio_endio() and can be moved to above the
> blk_zone_bio_endio() definition.

OK.

> 
>> @@ -1003,6 +1007,13 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
>> +	/*
>> +	 * A front merge for zone writes can happen only if the user submitted
>> +	 * writes out of order. Do not attempt this to let the write fail.
>> +	 */
> 
> "zone writes" -> "zoned writes"?

Well, "writes to zones of a zoned block device" would be the correct way to
describe this. The shortcut is "zone writes" but can be "zoned write" too.

>> +/*
>> + * Zone write plug flags bits:
> 
> Zone write -> zoned write

Nope. This is flags for zone write plugs (as in struct blk_zone_wplug). Not
talking about flags for writes to zones.

>> +static bool disk_insert_zone_wplug(struct gendisk *disk,
>> +				   struct blk_zone_wplug *zwplug)
>> +{
>> +	struct blk_zone_wplug *zwplg;
>> +	unsigned long flags;
>> +	unsigned int idx =
>> +		hash_32(zwplug->zone_no, disk->zone_wplugs_hash_bits);
>> +
>> +	/*
>> +	 * Add the new zone write plug to the hash table, but carefully as we
>> +	 * are racing with other submission context, so we may already have a
>> +	 * zone write plug for the same zone.
>> +	 */
>> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>> +	hlist_for_each_entry_rcu(zwplg, &disk->zone_wplugs_hash[idx], node) {
>> +		if (zwplg->zone_no == zwplug->zone_no) {
>> +			spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>> +			return false;
>> +		}
>> +	}
>> +	hlist_add_head_rcu(&zwplug->node, &disk->zone_wplugs_hash[idx]);
>> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>> +
>> +	return true;
>> +}
> 
> The above code can be made easier to read and more compact by using
> guard(spinlock_irqsave)(...) instead of spin_lock_irqsave() + 
> spin_unlock_irqrestore().

I am not familiar with this annotation and I do not see it used in the block
layer. So I would rather not do that to be clear about locking/unlocking.
Such change can come as cleanups later.

> 
>> +static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
>> +						  sector_t sector)
>> +{
>> +	unsigned int zno = disk_zone_no(disk, sector);
>> +	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
>> +	struct blk_zone_wplug *zwplug;
>> +
>> +	rcu_read_lock();
>> +
>> +	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
>> +		if (zwplug->zone_no == zno &&
>> +		    atomic_inc_not_zero(&zwplug->ref)) {
>> +			rcu_read_unlock();
>> +			return zwplug;
>> +		}
>> +	}
>> +
>> +	rcu_read_unlock();
>> +
>> +	return NULL;
>> +}
> 
> The above code can also be made more compact by using guard(rcu)()
> instead of rcu_read_lock() + rcu_read_unlock().

Same comment as above.

>> +/*
>> + * Get a reference on the write plug for the zone containing @sector.
>> + * If the plug does not exist, it is allocated and hashed.
>> + * Return a pointer to the zone write plug with the plug spinlock held.
>> + */
> 
> Holding a spinlock upon return is not my favorite approach. Has the
> following alternative been considered?
> - Remove the spinlock flags argument from this function and instead add
>    two other arguments: prev_plug_flags and new_plug_flags.
> - If a zone plug is found or allocated, copy the existing zone plug
>    flags into *prev_plug_flags and set the zone plug flags that have been
>    passed in new_plug_flags (logical or).
> - From blk_revalidate_zone_cb(), pass 0 as the new_plug_flags argument.
> - From blk_zone_wplug_handle_write, pass BLK_ZONE_WPLUG_PLUGGED as the
>    new_plug_flags argument.

I would rather not do this because this is a lot more complicated on the caller
sites as all callers would need to check for the UNHASHED case and potentially
retry again. As it is, zone write plugging is already not trivial, so I am
trying to keep things as simple as I can for now ? The function name makes it
*very* clear that it takes the plug spinlock, and that avoids needing the caller
to worry about the state of the plug they will get.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

