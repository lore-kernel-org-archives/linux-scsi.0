Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA88380FD7;
	Mon, 12 Oct 2026 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811644; cv=none; b=RAoSFEnI2hOc+XTGxL8/Nv5225Sb8yl0dr5VVZs/hQB4DlFI0V0D9TkIv0npVqE7D652cJYogZWIS5qqfscBHFJCrUff7pJZIINFy/OBrr9eYthYiMw2jRAScVOiizZ3zPWA5Y0qXyN+19EI9NsiV4gVrpxfOZvzguI1+fS+bV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811644; c=relaxed/simple;
	bh=r6JU9SeZwML2pMNu30LbOZKmxGl34bXURPhEdeUKNVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDprWAmWgs7bZJ7waoN22LlFY194ihk/erTBZ8ob6L6eZwQYGlGiFDhIGjUwPh06GRuSrpWwUXRN8R59pgGHLNv55TuMKzm4XhG6U78WZt8jVokvqY9JJtpaTCQ4+Hp5Z87TzIR6RdLm9iT33/tQBfX+/230NeFU0C/Qbo1wi4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcY5bG/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcY5bG/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83571F0089B;
	Mon, 12 Oct 2026 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811643;
	bh=6LCnfVY7RA6/ry+xagmPyCCWiLVJGyv0SdCQBaLQBC0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GcY5bG/PKmvHkwNCO1xDqBygbHfgKDjrKtGF0JmdysNXJ+vF8vLSTPjEXoXRfrLKH
	 d8KU8GGbxl2QPzH0SGtX+pVwg/NF7OhNP9JNskjp39dH803Rlm02KIQ6cqZZ3lzJl2
	 8gvPIeP5JfsV098hMTj4OBADI/KFim+HImGZf5d1bxhdjlmBkC5LVPNqP1vjDCBjfS
	 6OpxLZSowQkvJFlqfDvcYlJGyXl5WlCbHxptdHDbdB3iPoTblB2X7oI8qYociSpfdC
	 1VdnM8i9WKaB1I3fMJegqgzk/ywp9eP1mXYzSrzSBU4Wcw8tdSgKHG/WAwr+pjx1wK
	 xRPwic37xH2WA==
Message-ID: <8bc84218-3deb-431e-a7e2-3178e976e198@kernel.org>
Date: Mon, 12 Oct 2026 15:27:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/9] block: introduce storage element management
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-4-dlemoal@kernel.org>
 <sashiko-outbox-168172@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <sashiko-outbox-168172@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/12 15:23, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] block: missing queue freeze during zoned device revalidation after element removal
> --
> 
> commit b956da4759d697b5157b820cef7c5479dd817a3b
> Author: Damien Le Moal <dlemoal@kernel.org>
> 
> block: introduce storage element management
> 
> This commit introduces storage element management operations for zoned block
> devices. It adds functions to report, remove, and restore storage elements
> to support features like element depopulation for defective heads.
> 
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index e7f48774ae17e..46822c7a05ecc 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
> 
> [ ... ]
> 
>> +int bdev_remove_storage_element(struct block_device *bdev,
>> +				unsigned int element_id)
>> +{
> 
> [ ... ]
> 
>> +	/*
>> +	 * Freeze and unfreeze the queue to flush any outstanding command.
>> +	 * The caller is responsible for not queuing up more I/Os by higher
>> +	 * level means.
>> +	 */
>> +	memflags = blk_mq_freeze_queue(disk->queue);
>> +	blk_mq_unfreeze_queue(disk->queue, memflags);
>> +
>> +	/* Initiate the storage element removal and wait for its completion. */
>> +	ret = disk->fops->se_ops->remove_element(disk, element_id);
>> +	if (!ret)
>> +		ret = disk_wait_for_se_mgmt_completion(disk, elements,
>> +						       element_id);
>> +
>> +	/*
>> +	 * Always revalidate zones, even in the case of an error as we do not
>> +	 * know what condition the drive zones are in.
>> +	 */
>> +	err = disk_revalidate_zones(disk);
> 
> [Severity: High]
> Could this unfreeze the queue too early?
> 
> The queue is unfrozen before disk_revalidate_zones() is called, which means
> the internal zone arrays and capacities can be modified while I/O is
> potentially in flight. This might allow concurrent readers in the block
> layer, who rely on blk_queue_enter() for protection, to experience torn
> reads or use invalid zone states.
> 
> Would it be safer to hold the queue freeze until after the zone
> revalidation is complete to prevent these concurrent access issues?

Ideally, yes, we should freeze the queue to prevent user IOs from being issued
while an element is being depoped. However, the current queue freeze will block
*all* commands, even internal ones that we need to use to initiate the depop and
poll for completion.

So we cannot hold the queue freeze here. Further patches will improve on this by
introducing a "user freeze" to block only user IO and let internal commands
proceed. But that is for later.

> 
> [ ... ]
> 
>> +int bdev_restore_storage_elements(struct block_device *bdev)
>> +{
> 
> [ ... ]
> 
>> +	/*
>> +	 * Freeze and unfreeze the queue to flush any outstanding commands.
>> +	 * The caller is responsible for not queuing up more I/O by higher
>> +	 * level means.
>> +	 */
>> +	memflags = blk_mq_freeze_queue(disk->queue);
>> +	blk_mq_unfreeze_queue(disk->queue, memflags);
>> +
>> +	/*
>> +	 * Initiate the storage elements restoration and wait for its
>> +	 * completion.
>> +	 */
>> +	ret = disk->fops->se_ops->restore_elements(disk);
>> +	if (!ret)
>> +		ret = disk_wait_for_se_mgmt_completion(disk, elements, 0);
>> +
>> +	/*
>> +	 * Always revalidate zones, even in the case of an error as we do not
>> +	 * know what condition the drive zones are in.
>> +	 */
>> +	err = disk_revalidate_zones(disk);
> 
> [Severity: High]
> Does this share the same queue freeze vulnerability as the removal path?
> 
> Just like in bdev_remove_storage_element(), the queue is unfrozen prior
> to calling disk_revalidate_zones(), leaving the internal state vulnerable
> to concurrent I/O races during restoration.
> 


-- 
Damien Le Moal
Western Digital Research
