Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D692F9FD;
	Mon, 12 Feb 2024 08:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707727663; cv=none; b=OujSjDxiC7fTdCM++nmLi5sgWNRR11WHfwklRqyN9wZG4/g0InCFf9EFcpRpw7y7g+46SC/bO8jGHKCM8IjJOiOD11szhi7rXwzyts8lraLfgmOjC8wWCSaffM8+5U3JTbjcZ4fd6Umn5fOBjS2M9nDDEkWLMqbJv0ZHU1ZFRJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707727663; c=relaxed/simple;
	bh=uVOkGeLMsd1+ZjKq4LCkAfBtM1q49YLd4xP4VmnYMDo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kiV9PFwdFQSCyiIa031yZjBaO5FqyC7YoN988UEwjvWtyO0F/v4iNCl8uY8OKwsXA9v1Oh/EmlCFLLwYEBrEAStkT+qydC31jjjlF90GNi2EXRpX0HPEQiPJEeVpnN6eEpFJlJ3kjSp/hvPz/eIuRPGC87kDYi2QAIkLIYQxTfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JI5zQavR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JI5zQavR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BC6C43390;
	Mon, 12 Feb 2024 08:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707727663;
	bh=uVOkGeLMsd1+ZjKq4LCkAfBtM1q49YLd4xP4VmnYMDo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=JI5zQavRULhgL/JgzNPhtfv/eojP0u55mJLvtoEul5fwp9IO5XYjhVpD87EXzzP1j
	 dQOFg7eVHhZAQRg7kTVwkM4ZDeDa5o/oLwIRvIYIXnynbDIspzZcRRvWGXM+UviL+c
	 9boJuF07K3NcuAHVLO2WN+fP6CC9FQzrnkmPE7590bG419zDCown0i+yAvIPfhadT/
	 YFLL07+DqtJ8b+y3ULE4Ouhgx7SeZ12opUvuz6humQ/D8u4cDq50bc6HA6HypoAgwM
	 pXIaC3qoHJhXJ0WwNjn1s+ByAN4P+aHa0ygizuRoXYgPVLhUZp22Aw/3qUGiUsQeDY
	 mFC1g/IB25NVw==
Message-ID: <2b45ee45-5f2e-4923-9ef6-a7f03bcb65bf@kernel.org>
Date: Mon, 12 Feb 2024 17:47:40 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-26-dlemoal@kernel.org>
 <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
 <f3a2f8b8-32d2-4e42-ba78-1f668d69033f@acm.org>
 <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
 <2e246189-a450-4061-b94c-73637859d073@acm.org>
 <75240a9d-1862-4d09-9721-fd5463c5d4e5@kernel.org>
 <e2a1a020-39e3-4b02-a841-3d53bd854106@acm.org>
 <c03735f3-c036-4f78-ac0b-8f394e947d86@kernel.org>
 <a1531631-dce4-49a6-a589-76fa86e88aeb@acm.org>
 <c582fc6c-618e-4052-9f15-3045df819389@kernel.org>
Organization: Western Digital Research
In-Reply-To: <c582fc6c-618e-4052-9f15-3045df819389@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/24 17:23, Damien Le Moal wrote:
> On 2/11/24 12:40, Bart Van Assche wrote:
>> On 2/9/24 16:06, Damien Le Moal wrote:
>>> On 2/10/24 04:36, Bart Van Assche wrote:
>>>> written zones is typically less than 10. Hence, tracking the partially written
>>>
>>> That is far from guaranteed, especially with devices that have no active zone
>>> limits like SMR drives.
>>
>> Interesting. The zoned devices I'm working with try to keep data in memory
>> for all zones that are neither empty nor full and hence impose an upper limit
>> on the number of open zones.
>>
>>> But in any case, what exactly is your idea here ? Can you actually suggest
>>> something ? Are you suggesting that a sparse array of zone plugs be used, with
>>> an rb-tree or an xarray ? If that is what you are thinking, I can already tell
>>> you that this is the first thing I tried to do. Early versions of this work used
>>> a sparse xarray of zone plugs. But the problem with such approach is that it is
>>> a lot more complicated and there is a need for a single lock to manage that
>>> structure (which is really not good for performance).
>>
>> Hmm ... since the xarray data structure supports RCU I think that locking the
>> entire xarray is only required if the zone condition changes from empty into
>> not empty or from neither empty nor full into full?
>>
>> For the use cases I'm interested in a hash table implementation that supports
>> RCU-lookups probably will work better than an xarray. I think that the hash
>> table implementation in <linux/hashtable.h> supports RCU for lookups, insertion
>> and removal.
> 
> I spent some time digging into this and also revisiting the possibility of using
> an xarray. Conclusion is that this does not work well, at least in no way not
> better than what I did, and most of the time much worse. The reason is that we
> need at the very least to keep this information around:
> 1) If the zone is conventional or not
> 2) The zone capacity of sequential write required zones
> 
> Unless we keep this information, a report zone would be needed before starting
> writing to a zone that does not yet have a zone write plug allocated.
> 
> (1) and (2) above can be trivially combined into a single 32-bits value. But
> that value must exist for all zones. So at the very least, we need nr_zones * 4B
> of memory allocated at all time. For such case (i.e. non-sparse structure),
> xarray or hash table would be more costly in memory than a simple static array.
> 
> Given that we want to allocate/free zone write plugs dynamically as needed, we
> essentially need an array of pointers, so 8B * nr_zones for the base structure.
> From there, ideally, we should be able to use rcu to safely dereference/modify
> the array entries. However, static arrays are not supported by the rcu code from
> what I read.
> 
> Given this, my current approach that uses 16B per zone is the next best thing I
> can think of without introducing a single lock for modifying the array entries.
> 
> If you have any other idea, please share.

Replying to myself as I had an idea:
1) Store the zone capacity in a separate array: 4B * nr_zones needed. Storing
"0" as a value for a zone in that array would indicate that the zone is
conventional. No additional zone bitmap needed.
2) Use a sparse xarray for managing allocated zone write plugs: 64B per
allocated zone write plug needed, which for an SMR drive would generally be at
most 128 * 64B = 8K.

So for an SMR drive with 100,000 zones, that would be a total of 408 KB, instead
of the current 1.6 MB. Will try to prototype this to see how performance goes (I
am worried about the xarray lookup overhead in the hot path).

-- 
Damien Le Moal
Western Digital Research

