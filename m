Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9852210A0D;
	Wed,  3 Apr 2024 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712106155; cv=none; b=vBZQAeH8ow2zT3Hpak9WzYcCHpKlX4v/VbvvPIIcIEiT8QlLAVQtmIpUkt+D7MOk7smVc2su3VjD0ZNPPQHWESo1GmL22QyxRi3nL9LHj2dGPQgfpUgS0aSWu2NhVdaeVoZCUIh6Tya6woUPQgea057eujqaZ5v+8sp4DAvQKhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712106155; c=relaxed/simple;
	bh=kzgwLdsL4OudUwPrRRSPRtFvw3mEHVc9aO/Nux6tJOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6Zxpq97ErgTiP+Klh2RxD+iXIOYrnl5iGnafno5fv2DX2bWq2cpvES44yKq8HqpwslAdFV3pWX1FbsG6Yghe2FuCm9rFOnrnqg+aIUjuGdSrTimmmv2WlW4taNVB3KEzouBdoviBHzuASoR9Di1T+xVEMFo0B5SPl9qThGRmPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/WsTKmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/WsTKmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71CEC433C7;
	Wed,  3 Apr 2024 01:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712106155;
	bh=kzgwLdsL4OudUwPrRRSPRtFvw3mEHVc9aO/Nux6tJOs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j/WsTKmGI70YaCEBXfrg3yAAQyr/QbNeES4W3bPqzfs9wnji+dRQOlTQD4J9k7sRY
	 nwlo+vB34Za3Oo5kUbWjbf8xQGMBV8PlGB+2HQLqLQnuJlnWFjJH7UVFJRigzc+9BS
	 zFtRiDHycscQNh6GCixrP5TOx/ezsYoLPxoYdi4MYfXf5OikeDpWNr2AO2WJzLMQak
	 LXAC3824kBL9t6F/UcWVng3ePi1HK6RrbKEmVN8OpB3VbcxLjME1FPMtZnf4mOvjD4
	 c9huh4rdbqqgwyl4EUlZDwfQfuZfEMpe6txECbCWhxO2/mQqqMHouksQ3V9qQetZYe
	 rgBlfwhN8sO2A==
Message-ID: <084cc8bd-bbc7-491f-b196-51ccd3d97620@kernel.org>
Date: Wed, 3 Apr 2024 10:02:32 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/28] block: Introduce zone write plugging
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-8-dlemoal@kernel.org> <20240402161213.GB3527@lst.de>
 <e923b1cf-9683-4029-8a39-c66aa8fb2647@kernel.org>
 <a68d7e70-d82f-4a09-8b9c-db5e902a3663@kernel.dk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a68d7e70-d82f-4a09-8b9c-db5e902a3663@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/3/24 10:01, Jens Axboe wrote:
> On 4/2/24 5:38 PM, Damien Le Moal wrote:
>> On 4/3/24 01:12, Christoph Hellwig wrote:
>>>> +static inline struct blk_zone_wplug *
>>>> +disk_lookup_zone_wplug(struct gendisk *disk, sector_t sector)
>>>> +{
>>>> +	unsigned int zno = disk_zone_no(disk, sector);
>>>> +	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
>>>> +	struct blk_zone_wplug *zwplug;
>>>> +
>>>> +	rcu_read_lock();
>>>> +	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
>>>> +		if (zwplug->zone_no == zno)
>>>> +			goto unlock;
>>>> +	}
>>>> +	zwplug = NULL;
>>>> +
>>>> +unlock:
>>>> +	rcu_read_unlock();
>>>> +	return zwplug;
>>>> +}
>>>
>>> Did we lose an atomic_inc_unless_zero here?  This now just does a lookup
>>> under RCU, but nothing to prevent the zwplug from beeing freed?
>>
>> Nope. When disk_lookup_zone_wplug() is called directly, it is always
>> for handling requests/bios which are holding a reference on the plug
>> and because there are requests/BIOs in-flight, the plug is marked as
>> busy (BLK_ZONE_WPLUG_PLUGGED or BLK_ZONE_WPLUG_ERROR are set). In such
>> state, the plug is always hashed given that
>> disk_should_remove_zone_wplug() retturns false for busy plugs. So
>> there is no reference increase here. The atomic_inc_not_zero() is in
>> disk_get_zone_wplug() which calls disk_lookup_zone_wplug() +
>> atomic_inc_not_zero() within an rcu_read_lock()/rcu_read_unlock()
>> section.
> 
> But doing a lookup under rcu, dropping it, and then returning the unit
> without an increment is just a horrible pattern. Regardless of whether
> it's safe or not. And as most callers do the atomic_inc anyway, some of
> then outside rcu lock, this looks horrible buggy.
> 
> Please just unify it all and have it follow the idiomatic rcu lookup
> pattern, which is:
> 
> rcu_read_lock();
> item = lookup();
> if (atomic_inc_not_zero(item->ref)) {
> 	rcu_read_unlock();
> 	return item;
> }
> 
> rcu_read_unlock();
> return NULL;
> 
> as that is well understood, and your code most certainly does not look
> safe nor sane in that regard.
> 
> And probably kill that atomic_inc() helper you have as well while at it.

OK.

> 

-- 
Damien Le Moal
Western Digital Research

