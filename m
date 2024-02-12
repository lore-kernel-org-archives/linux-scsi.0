Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE8CFBF2;
	Mon, 12 Feb 2024 08:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707726195; cv=none; b=hqfAx/DL9ogkSew82+GJ2iW702P3s72u15qLFShC+Qt39YivN+t3qFsH2MpA5Le7y0aYpGzNsPZ4VJ0idarw0xoMY93x/Gf7M4H1ijJXzeblxi4dWlMEzs5kjVncvojdZJUrnSRYkyMmI5NYFbP3X+9Bxzjq9ctlpRqNMbquwS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707726195; c=relaxed/simple;
	bh=EVwXle+lSOPxDX4v9OTAbG2t1eridiyfsruwEJ2LACc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNe+refEj8ucpeSPOo9nl2fvvISHw2NfUNlgKbSDtfSQnLJ/0LbkKBqCuvMCG0hgzyORo75cHX6oQpghmmBd6BcOOEG5rE43naVL7tXtjtN1MrdH3XAFz1zH4s82g0q8Emv6AKfXpbkyIQv1CELAMkCNN4sarVKn8kotFZeTddA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwVFLSzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwVFLSzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B022C433F1;
	Mon, 12 Feb 2024 08:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707726194;
	bh=EVwXle+lSOPxDX4v9OTAbG2t1eridiyfsruwEJ2LACc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BwVFLSzCzsM/iMaw41khrUGlti9loWxKk9Tir2mmA78hL3YeqC7LoCGYLU43uQITy
	 2/sY8X/GCQz9q4wiXX/Q9ZDD2q2ibIRhABiGl2kQZ5vgPHejFXbJ0qdWQuHhoIjOMb
	 3hpxDfEbeqS1fgIWDnc0LBuUCDDVp/rG8FJiTKHSMJJP9T0H9cqd0ivbAF1kZe1M7n
	 LmFVBKvJVjyq8SzIyO8+JtyPhgfl32ijAo51UcSPgn83oXNrxfa37PdFP5rhygHudn
	 EXFIbFsDXlzasxa/9kTkyf8HnK5Qy65mIpXKZhLsJMHaBktF2si+KH2t6bJLLH4FL/
	 2QAxmWaci94MQ==
Message-ID: <c582fc6c-618e-4052-9f15-3045df819389@kernel.org>
Date: Mon, 12 Feb 2024 17:23:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
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
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a1531631-dce4-49a6-a589-76fa86e88aeb@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/11/24 12:40, Bart Van Assche wrote:
> On 2/9/24 16:06, Damien Le Moal wrote:
>> On 2/10/24 04:36, Bart Van Assche wrote:
>>> written zones is typically less than 10. Hence, tracking the partially written
>>
>> That is far from guaranteed, especially with devices that have no active zone
>> limits like SMR drives.
> 
> Interesting. The zoned devices I'm working with try to keep data in memory
> for all zones that are neither empty nor full and hence impose an upper limit
> on the number of open zones.
> 
>> But in any case, what exactly is your idea here ? Can you actually suggest
>> something ? Are you suggesting that a sparse array of zone plugs be used, with
>> an rb-tree or an xarray ? If that is what you are thinking, I can already tell
>> you that this is the first thing I tried to do. Early versions of this work used
>> a sparse xarray of zone plugs. But the problem with such approach is that it is
>> a lot more complicated and there is a need for a single lock to manage that
>> structure (which is really not good for performance).
> 
> Hmm ... since the xarray data structure supports RCU I think that locking the
> entire xarray is only required if the zone condition changes from empty into
> not empty or from neither empty nor full into full?
> 
> For the use cases I'm interested in a hash table implementation that supports
> RCU-lookups probably will work better than an xarray. I think that the hash
> table implementation in <linux/hashtable.h> supports RCU for lookups, insertion
> and removal.

I spent some time digging into this and also revisiting the possibility of using
an xarray. Conclusion is that this does not work well, at least in no way not
better than what I did, and most of the time much worse. The reason is that we
need at the very least to keep this information around:
1) If the zone is conventional or not
2) The zone capacity of sequential write required zones

Unless we keep this information, a report zone would be needed before starting
writing to a zone that does not yet have a zone write plug allocated.

(1) and (2) above can be trivially combined into a single 32-bits value. But
that value must exist for all zones. So at the very least, we need nr_zones * 4B
of memory allocated at all time. For such case (i.e. non-sparse structure),
xarray or hash table would be more costly in memory than a simple static array.

Given that we want to allocate/free zone write plugs dynamically as needed, we
essentially need an array of pointers, so 8B * nr_zones for the base structure.
From there, ideally, we should be able to use rcu to safely dereference/modify
the array entries. However, static arrays are not supported by the rcu code from
what I read.

Given this, my current approach that uses 16B per zone is the next best thing I
can think of without introducing a single lock for modifying the array entries.

If you have any other idea, please share.

-- 
Damien Le Moal
Western Digital Research

