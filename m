Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBC412838B;
	Tue, 26 Mar 2024 03:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422726; cv=none; b=stX7QQ31EbYSRY89p1PJz188nQF3ShaACGLrBofMtiPIg4jbgeIvtEvzqaypSQvJNTd3Rf9FIYBUJkihAoHz8tBWqctOI1OWM0pTHTL8dcFmG1QgdHS2O/oeURfhZ35avyQKJDkwxWdEGBl7ShNgCi2olHgRUwPrbtykI0HP2DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422726; c=relaxed/simple;
	bh=zRJ0PkouhwYaZlMIw+G0AYkZMTYCIB1ZRHyeYjgdIPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pwUuBRpLm8n6woN1BZeg7aOGLUl+nPvd6GRAir5fGLbasy+6NOvJJqL+qIZP3dcf9ELqyAL8nrjUxezc/BYrEhl06jUp3fZ1152oiZ/UQAL/YrLM6vjDgbrFuQfmJ6Sj7wCiWdPtRhzDdTufyr9r1OR+YhiBYvOErM8pAzA6gNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hohgZAsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hohgZAsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61C9C433C7;
	Tue, 26 Mar 2024 03:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422725;
	bh=zRJ0PkouhwYaZlMIw+G0AYkZMTYCIB1ZRHyeYjgdIPs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hohgZAsYFDUgJdyTz3p5FqmsBREU2D0BQ2HjsBRjPwqFJRCdW69ISwzk/RXSLsjKM
	 f9shzVjYFnePlP3X+iSeZxakXPHqy3Uz8OGkI9Awyol0esN/imYJb5JQ1ZB3wpvji3
	 xXUAQMA7SUCJ7PGa5Uyw6Rpd1fuft94xRYlvgJUKazM2MIUHl5Bjjy1ZJTmXyeky2j
	 sf99LF2A4LYP5E3MgwAC/6Ho6hmQ1N7WxX5bjewmVhBc2u5Nf2wcxFQ/5PITX7SAn5
	 rjkYhnS904PjgaLOhgepeJT5Jw6SiohULw+/uVGPCq4hjzIEB5yYftUQkR0JjcRYDk
	 3jgJ3WvNLBDdw==
Message-ID: <839ebf2a-4dc6-433b-bc47-fd7915ed0ecf@kernel.org>
Date: Tue, 26 Mar 2024 12:12:03 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-8-dlemoal@kernel.org>
 <f3b298bb-b68a-4375-a3b4-fc91229740c1@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <f3b298bb-b68a-4375-a3b4-fc91229740c1@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/24 06:53, Bart Van Assche wrote:
> On 3/24/24 21:44, Damien Le Moal wrote:
>> +/*
>> + * Per-zone write plug.
>> + */
>> +struct blk_zone_wplug {
>> +	struct hlist_node	node;
>> +	struct list_head	err;
>> +	atomic_t		ref;
>> +	spinlock_t		lock;
>> +	unsigned int		flags;
>> +	unsigned int		zone_no;
>> +	unsigned int		wp_offset;
>> +	struct bio_list		bio_list;
>> +	struct work_struct	bio_work;
>> +};
> 
> Please document what 'lock' protects. Please also document the unit of
> wp_offset.
> 
> Since there is an atomic reference count in this data structure, why is
> the flag BLK_ZONE_WPLUG_FREEING required? Can that flag be replaced by
> checking whether or not 'ref' is zero?

Nope, we cannot. The reason is that BIO issuing and zone reset/finish can be
concurrently processed and we need to be ready for a user doing really stupid
things like resetting or finishing a zone while BIOs for that zone are being
issued. When zone reset/finish is processed, the plug is removed from the hash
table, but disk_get_zone_wplug_locked() may still get a reference to it because
we do not have the plug locked yet. Hence the flag, to prevent reusing the plug
for the reset/finished zone that was already removed from the hash table. This
is mentioned with a comment in disk_get_zone_wplug_locked():

	/*
	 * Check that a BIO completion or a zone reset or finish
	 * operation has not already flagged the zone write plug for
	 * freeing and dropped its reference count. In such case, we
	 * need to get a new plug so start over from the beginning.
	 */

The reference count dropping to 0 will then be the trigger for actually freeing
the plug, after all in-flight or plugged BIOs are completed (most likely failed).

>> -void disk_free_zone_bitmaps(struct gendisk *disk)
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
> Since this function inserts an element into disk->zone_wplugs_hash[],
> can it happen that another thread removes that element from the hash
> list before this function returns?

No, that cannot happen. Both insertion and deletion of plugs in the hash table
are serialized with disk->zone_wplugs_lock. See disk_remove_zone_wplug().

-- 
Damien Le Moal
Western Digital Research

