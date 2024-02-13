Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5539C17E;
	Tue, 13 Feb 2024 00:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707782759; cv=none; b=R0J+JiWd1zJLYiJhKDyei8l1Xb53HpypFC5dZ+O7UAqIJbYjRMRL4DmGW8a1rs2Si1hHK5sqm465gfOB6ckoPik2hWHp/5BGWRR4h7hsndcLE7UxfP2I8f3CxuI3nf8E0VQj2cduj24NPoxCzbSzcN+Bdn/ETqnDFzpkXRi1Eco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707782759; c=relaxed/simple;
	bh=KXepePgD9sxv2u2ZKdU/Y+qtxJSXw5zEaJKBohhsn5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eq0Z0DDufGgWs+ElT+Jv4kThr1AhWmwJPTvT2pTzlBiek5AvwUs3P8OiReqsPE3hH1IWqxpP8C/S2XFUF+Lv+k9NKAMPDr1ycm+kcRoMm3XLtux5H0dom68PAPlZS8rp/QgP9E/Ly5ebbOkS1VSY0jf/8TATQcLvPQCAHyMiNKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IepsTpxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IepsTpxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D67C433C7;
	Tue, 13 Feb 2024 00:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707782758;
	bh=KXepePgD9sxv2u2ZKdU/Y+qtxJSXw5zEaJKBohhsn5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IepsTpxO/DlN9uPD4xRpW+NkqfFswku/8xmd5ShoEZrHIvc/p+HBOq1M7qbeuq0eh
	 LsLY9w+5c+y8FtyRh/LPWqKtiLp4cN/xcO7BPWneYtybpSi+smmao3lutQ0cZr4cT2
	 uMw4BGP/KosRVXB3pYKA01uuBqsUwiOXyVNsvKy9BPoVbnPDnqVD1OA4EShjuMNk/e
	 AAGLCvybyg/QuuUGMqDcf0BxTd2CXOhVAsYDB75O0jFgzY3fnRv5NVK6bRYY8Habnw
	 onQFwnlU2mA2tSVa2JDTPHJn0odokqRdeyE0Vb0uuj4KJ6e+U6z8OC/+J8keaBlIVO
	 yIe2SBacxxndQ==
Message-ID: <5d5ae964-0bc3-452f-98ff-c355bdf50203@kernel.org>
Date: Tue, 13 Feb 2024 09:05:55 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
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
 <2b45ee45-5f2e-4923-9ef6-a7f03bcb65bf@kernel.org>
 <768a184f-c921-40fc-8405-2777f03e1668@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <768a184f-c921-40fc-8405-2777f03e1668@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/13/24 03:40, Bart Van Assche wrote:
> On 2/12/24 00:47, Damien Le Moal wrote:
>> Replying to myself as I had an idea:
>> 1) Store the zone capacity in a separate array: 4B * nr_zones needed. Storing
>> "0" as a value for a zone in that array would indicate that the zone is
>> conventional. No additional zone bitmap needed.
>> 2) Use a sparse xarray for managing allocated zone write plugs: 64B per
>> allocated zone write plug needed, which for an SMR drive would generally be at
>> most 128 * 64B = 8K.
>>
>> So for an SMR drive with 100,000 zones, that would be a total of 408 KB, instead
>> of the current 1.6 MB. Will try to prototype this to see how performance goes (I
>> am worried about the xarray lookup overhead in the hot path).
> 
> Hi Damien,
> 
> Are there any zoned devices where the sequential write required zones occur before
> the conventional zones? If not, does this mean that the conventional zones always
> occur before the write pointer zones and also that storing the number of conventional
> zones is sufficient?

Not sure where you want to go with this... In any case, there are SMR drives
which have conventional zones before and after the bulk of the capacity as
sequential write required zones. Conventional zones can be anywhere.

> Are there zoned storage devices where each zone has a different capacity? I have
> not yet encountered any such device. I'm wondering whether a single capacity
> variable would be sufficient for the entire device.

Yes, I did this optimization. Right now, for the 28TB SMR disk case, I am down
to a bitmap for conventional zones (16KB) plus max-open-zones * 64 B for the
zone write plugs. Cannot go lower than that. I am still looking into xarray vs
hash table for the zone write plugs for the overhead/performance.


-- 
Damien Le Moal
Western Digital Research

