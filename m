Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBA35822D;
	Tue,  2 Apr 2024 23:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712101099; cv=none; b=jZfScqcV96xRinRDxjhcs3KgnotYGb9XI68KNr0qXau7Lvs0glQx6H/UdlmHPvlm+D1bOe+RBX58M1Q5h62PTmR8QfMfg4rKRAX65QalvgQRmk5O5VtUVyNhN+qMf3EZC/q+QDoJYdBpXWImpxwCD2MCjPLRnnBT+gOztO4OaYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712101099; c=relaxed/simple;
	bh=sgzdOOTlPRAcyjDATGjL0e/ioWdozPuqfHkfUOvJzhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gj7r3jlr93UtofpkmOFuDgCqFQn71tmuMylFOMkB9DHz0m2XE1fnBSmKKIkyAeLBlgwFqJdPI6Z2fTckejUUrNfurEly9EghB2TuysmoZ9it+P3EvRPlZNV0nai+tg1Zm9yTrnRVnpa5rJdqqgqP1TuQLSlRUkOlLm2+bFGR4y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZV5Bdh8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZV5Bdh8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0203AC433C7;
	Tue,  2 Apr 2024 23:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712101098;
	bh=sgzdOOTlPRAcyjDATGjL0e/ioWdozPuqfHkfUOvJzhY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZV5Bdh8OIS5ylPi6KFi0KwQIIr+qg3NK5KE9CxpEW+4kEjnQNpjSm2REcBpnDM1y+
	 Kf2CB5YvES8uRsi2zfP9lSysTzoC6F6q9erqwbtJIVQq++KjABdyu01CmrecCCkfrz
	 k8eedIkEEjpsf6Vn/GxapPMSpWQp1NhyEXEVu9sUk0BUszhLqY5LGOhrPkZ5rHWwWo
	 seIRIwGopTZkvqiE4f06kP8Pi4azW1VTpGhjZ8NENGen2cGZgXhvfoLIryY+wiEpxG
	 LSblSMkLL0l+uyFjKF0w4ylQxFPTzf/fFMVOqfB2b5UM7/w6TtRGS0/WzIP0ZBGV4o
	 hkSa7cRNSDL5w==
Message-ID: <e923b1cf-9683-4029-8a39-c66aa8fb2647@kernel.org>
Date: Wed, 3 Apr 2024 08:38:15 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/28] block: Introduce zone write plugging
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-8-dlemoal@kernel.org> <20240402161213.GB3527@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240402161213.GB3527@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/3/24 01:12, Christoph Hellwig wrote:
>> +static inline struct blk_zone_wplug *
>> +disk_lookup_zone_wplug(struct gendisk *disk, sector_t sector)
>> +{
>> +	unsigned int zno = disk_zone_no(disk, sector);
>> +	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
>> +	struct blk_zone_wplug *zwplug;
>> +
>> +	rcu_read_lock();
>> +	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
>> +		if (zwplug->zone_no == zno)
>> +			goto unlock;
>> +	}
>> +	zwplug = NULL;
>> +
>> +unlock:
>> +	rcu_read_unlock();
>> +	return zwplug;
>> +}
> 
> Did we lose an atomic_inc_unless_zero here?  This now just does a lookup
> under RCU, but nothing to prevent the zwplug from beeing freed?

Nope. When disk_lookup_zone_wplug() is called directly, it is always for
handling requests/bios which are holding a reference on the plug and because
there are requests/BIOs in-flight, the plug is marked as busy
(BLK_ZONE_WPLUG_PLUGGED or BLK_ZONE_WPLUG_ERROR are set). In such state, the
plug is always hashed given that disk_should_remove_zone_wplug() retturns false
for busy plugs. So there is no reference increase here. The
atomic_inc_not_zero() is in disk_get_zone_wplug() which calls
disk_lookup_zone_wplug() + atomic_inc_not_zero() within an
rcu_read_lock()/rcu_read_unlock() section.

> 
>> +	/* Resize the zone write plug memory pool if needed. */
>> +	if (disk->zone_wplugs_pool->min_nr != pool_size)
>> +		return mempool_resize(disk->zone_wplugs_pool, pool_size);
> 
> Note that a mempool_resize to the current size work just fine.  It takes
> a pointless lock, but given that this is something that doesn't happen
> frequently that probably doesn't matter.
> 
>> +#include <linux/mempool.h>
> 
>> +	mempool_t		*zone_wplugs_pool;
> 
> Please use struct mempool_s here so that you only need a forward
> declaration instead of pulling in another header.

-- 
Damien Le Moal
Western Digital Research

