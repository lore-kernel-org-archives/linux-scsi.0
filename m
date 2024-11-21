Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B291570802;
	Thu, 21 Nov 2024 03:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732159410; cv=none; b=O6w84i+oUkPDlT5O64AdOnPwLS1pywRIsz/mhkcQXOogVpfXrOdcX55WWoGwh6yjavGxyVur3wVAhzl6NOG9VR7un06qwr6r2eP24ccbHYUHhvY9E0FIvbP11DmMT3xWxDfc0P3ENyk/dzcOJaIi6N559mMA/psXYX+yho9Uvbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732159410; c=relaxed/simple;
	bh=x6Q0rpsw68dChahrF8RvYvX1AOXMz0ZDez+WkifETpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tAF0jdxy1cmXAucp3YMr/90hNtXjPaILmwKtdiwid2P8aos4wFU6pXGbqSbltt5z60wJ3OUfRo2BlCRr/8hkcPcekSkqQ7TD6qKjpWwLpsiQZX2SQViS5FNhUQIDR3vMf5gvii+axr6z+wQegKfsOyv5zV58zEYOjKox6BQ7g+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GI/D5Xjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GI/D5Xjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF75C4CECD;
	Thu, 21 Nov 2024 03:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732159410;
	bh=x6Q0rpsw68dChahrF8RvYvX1AOXMz0ZDez+WkifETpQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GI/D5Xjs0CHwuWcEB12bX1Jp7Ml0VBqXithM8CWfJCzAymdb7uFGn48x/ar/4uASX
	 BiajM7aoe00qMkgD/H4I6EzTWiF7oVLGItattmJb4W4NO1BEy/49ZL2r3KtuF98kBA
	 +TMQSI5drruiupJzFtnX1kwylh+oeEQLgzR0WEk3OX1qT6jO+XTvGAiwKYrXfjsHgn
	 ZGpqYT8NvvWlV6pjV2q+Im348JaQjTdcN1Ig6N/Yu7sM88CTrbhiVVF44M7DoYmms3
	 Cljn5aLJokMf9xRM4k5jAYJzfvTJg+rNXg+MFQy173hk0ByOljemPON5ViOuEZQvO3
	 /1/aR9ihNY/og==
Message-ID: <c257a046-5f9f-40eb-8ef8-f36a3f1174e6@kernel.org>
Date: Thu, 21 Nov 2024 12:23:28 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 04/26] blk-zoned: Only handle errors after pending
 zoned writes have completed
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-5-bvanassche@acm.org>
 <7f4058f9-df04-404c-b4f0-25bf0e8e4886@kernel.org>
 <719628f8-5ac2-48b5-8458-68540ae0b2f1@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <719628f8-5ac2-48b5-8458-68540ae0b2f1@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 05:51, Bart Van Assche wrote:
>>> +/*
>>> + * Change the zone state to "error" if a request is requeued to postpone
>>> + * processing of requeued requests until all pending requests have either
>>> + * completed or have been requeued.
>>> + */
>>> +void blk_zone_write_plug_requeue_request(struct request *rq)
>>> +{
>>> +	struct gendisk *disk = rq->q->disk;
>>> +	struct blk_zone_wplug *zwplug;
>>> +
>>> +	if (!disk->zone_wplugs_hash_bits || !blk_rq_is_seq_zoned_write(rq))
>>> +		return;
>>
>> I think the disk->zone_wplugs_hash_bits check needs to go inside
>> disk_get_zone_wplug() as that will avoid a similar check in
>> blk_zone_write_plug_free_request() too. That said, I am not even convinced it
>> is needed at all since these functions should be called only for a zoned drive
>> which should have its zone wplug hash setup.
> 
> Moving the disk->zone_wplugs_hash_bits check sounds good to me.
> 
> I added this check after hitting an UBSAN report that indicates that
> disk->zone_wplugs_hash_bits was used before it was changed into a non-
> zero value. sd_revalidate_disk() submits a very substantial number of
> SCSI commands before it calls blk_revalidate_disk_zones(), the function
> that sets disk->zone_wplugs_hash_bits.

But non of the commands are writes to sequential zones, so the hash bits check
should not even be necessary, no ?

-- 
Damien Le Moal
Western Digital Research
