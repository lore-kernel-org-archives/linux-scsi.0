Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D2B365;
	Sat, 10 Feb 2024 00:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707523618; cv=none; b=sXehWZ+J/xVJ2xO4mtj9L0JgiXPHjB56foXbP8U0Vv5GrV6p4BkCIw3aU+X2JjvZUj9aorsFlL4m6YoeHiZXlh7LDdN49hZhnEH0AllxhCiOSrlEGsqz7PvsRvWI7QuBLeomMmGAAehLE+TKuyk1eq3dqjOvXlyMgoAvPAvpeWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707523618; c=relaxed/simple;
	bh=2Zw5SzbJLhz1l16efyBAgdXp5PCq1WwBZxnR19de37U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h5um7paKTSsKag68flHAICJhZyrjCD0fy4TtjuRXWOq3iq8fD1m4QBMp3wNWaTYJXJIcRnHEbWn9kUj69WTEWXzBmwGGBmw4WUxOuMhxA6LIqqPhRUfOz9jdmf5XHca1e1q1oIik1DXe3ggtrgbbsZconiC+6+flodpi8CnUELU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VB8cxc+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VB8cxc+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F182C433F1;
	Sat, 10 Feb 2024 00:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707523617;
	bh=2Zw5SzbJLhz1l16efyBAgdXp5PCq1WwBZxnR19de37U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VB8cxc+TYRhkfc+O6h5ij5L/vLQCo0jtjx3wlcNC4YVpl7+WtQcSC0U5DWP2YHy3k
	 taQklacNMoSR6BOEaEJXpIGvbqiJ1qmW7D6H5pBn7VTh98iR6iCBBMiPVA6rFeJ/oX
	 Q6EzpjGhpHCAERU4dXf1wcHY+enVxaQUwOL/GyS6Sv7okORFZKGyOINVxTD+CPq8Lt
	 1bwkROckISr/6bhLtHquTH+zOl/vMt3vEtI7D4L6OZqmPYcpbbuAm7qDscoEjdSd0G
	 QOIlKMoKT31h//cqF39QIvzSqNRj1x4LMWq73W+h/lgzWwKyFzSJQdlmBilC0B2Tga
	 OpaiGSvS4Tuug==
Message-ID: <c03735f3-c036-4f78-ac0b-8f394e947d86@kernel.org>
Date: Sat, 10 Feb 2024 09:06:54 +0900
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
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <e2a1a020-39e3-4b02-a841-3d53bd854106@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/10/24 04:36, Bart Van Assche wrote:
> On 2/8/24 19:58, Damien Le Moal wrote:
>> We still need to keep in memory the write pointer offset of zones that are not
>> being actively written to but have been previously partially written. So I do
>> not see how excluding empty and full zones from that tracking simplifies
>> anything at all. And the union of wp offset+zone capacity with a pointer to the
>> active zone plug structure is not *that* complicated to handle...
> 
> Multiple zoned storage device have 1000 or more zones. The number of partially

Try multiplying that by 100... 28TB SMR drives have 104000 zones.

> written zones is typically less than 10. Hence, tracking the partially written

That is far from guaranteed, especially with devices that have no active zone
limits like SMR drives.

> zones only will result in significantly less memory being used, fewer CPU cache
> misses and fewer MMU TLB lookup misses. I expect that this will matter since the
> zone information data structure will be accessed every time a zoned write bio is
> processed.

May be. The performance numbers I have suggest that this is not an issue.

But in any case, what exactly is your idea here ? Can you actually suggest
something ? Are you suggesting that a sparse array of zone plugs be used, with
an rb-tree or an xarray ? If that is what you are thinking, I can already tell
you that this is the first thing I tried to do. Early versions of this work used
a sparse xarray of zone plugs. But the problem with such approach is that it is
a lot more complicated and there is a need for a single lock to manage that
structure (which is really not good for performance).

Hence this series which used a statically allocated array of zone plugs to
simplify things. Overall, this series is a significant change to the zone write
path and I wanted something simple/reliable that is not a nightmare to debug and
test. I believe that an xarray based optimization can be re-tried as an
incremental change on top of this series. The nice thing about it is that the
API should not need to change, meaning that all changes can be contained within
blk-zone.c.

But I may be missing entirely your point. So clarify please.

-- 
Damien Le Moal
Western Digital Research

