Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E669A35;
	Mon, 12 Feb 2024 01:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707700150; cv=none; b=uANMcYW+OK3wdjLLU49EZbqPb+jPEyG3AeUWeN4Ii7iH+n42AeqmgNj/TSo+vN0p40O91OhM2naSRq+mcN6YPl4VyCBgBZPHtg3esPiW5xydW1+/a2AUFHUd/Re3O0TsGpUmI+JJJOz6m+bFO5J4kEFavlHNN31UVt5F3b1SCGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707700150; c=relaxed/simple;
	bh=TIlEpNe9JZy7KDyKQYhG7js/OcZPF/3Ev9SzrvoENvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=khsx/ceTkTUK3ZRJQnhhlb6ZzmQMh8no6o8vpgkRSyKkwtzXT+FT3q7Hce5fYOaX2QRcL0sRmBcQeIro48iW4yYJX3QP2WDsGE+HOMRrqYlg9o302vCH8bEaYG8HLveVEe+onAeyBwmFh6YHB7/dN3wiiI16Mf4+Ewu4lexJ+tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njjE9daf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njjE9daf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE80EC433F1;
	Mon, 12 Feb 2024 01:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707700149;
	bh=TIlEpNe9JZy7KDyKQYhG7js/OcZPF/3Ev9SzrvoENvw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=njjE9dafwElM5hwl26lzm6QlyaEpbdB8HFwSW7jjtQZplx6U62QOibLzVqGv/rxs0
	 lHGjvDh8z94J0jn1gt84EAareDXJlUUTleIE+17Adw78/+ZBIW4HvNUcHt+2jfDJSo
	 e8vr6uLFtN1GqPNj4qNzmbVJ9xb+pH6ZEYexVOGoNd0L/suuvAxyGEGeXrnmCbz161
	 EZuCeB/tNN64U4y+Gk46256Eh9/raK36f/xNJQGTSK5rpIuReunoZqKAU8epYSiT13
	 alidNLmuYPFvNaAULZBbo24Wu5MV/93ri+9iOVhgsKUP6UKbvvXSopXKc8oRgBHRMj
	 bntwIGkb1I4Pg==
Message-ID: <028b77ed-d6a9-44e6-a603-3558914381a1@kernel.org>
Date: Mon, 12 Feb 2024 10:09:06 +0900
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

I will try to revisit this. But again, that could be an incremental change on
top of this series...

> For the use cases I'm interested in a hash table implementation that supports
> RCU-lookups probably will work better than an xarray. I think that the hash
> table implementation in <linux/hashtable.h> supports RCU for lookups, insertion
> and removal.

It does, but the API for it is not the easiest, and I do not see how that could
be faster than an xarray, especially as the number of zones grows with high
capacity devices (read: potentially more collisions which will slow zone plug
lookups).

-- 
Damien Le Moal
Western Digital Research

