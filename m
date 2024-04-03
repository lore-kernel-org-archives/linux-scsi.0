Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17E115AC4;
	Wed,  3 Apr 2024 00:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712104414; cv=none; b=mBIHp9hgS7MNLZtcG0AKWmWnMSu1IuWAQBZFY6xdgUq3ZVzay5SGCCOc6YK73Q4d9hHf4tbnpDmKfAy8tajbm1F2TH7iyn257uNQi0Wj32lhXjmsbWmXMvhvHlBRGC5RZROwnkw1d2/xfPJIRJ9bomuWglJDMCws7O/80a2sL24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712104414; c=relaxed/simple;
	bh=9rVFT8lEiXwwEQGVXwFX3otLVQCYNh4uDYylC4oXnT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uumJEb3PEayHC8XGUJl4S2PKnzgj+DEXc9o3A/GBZAxOa1Nqx7Es0ats/m9jtEFxpD3PrvZIzCuPTyU5654afaPSkABum563eKmY2R495RPb3QhTIOclLQAXA1XoDnZlC2rNLFlycmi2Uv1x9QIz/SltW0hltbeC8RUF2f8gaSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hIvT5O9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hIvT5O9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49C1C433F1;
	Wed,  3 Apr 2024 00:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712104413;
	bh=9rVFT8lEiXwwEQGVXwFX3otLVQCYNh4uDYylC4oXnT8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=hIvT5O9g/kS5pPbKKfu8tYXKO6LLPT1S2P6ShP5DThpaqhnFYWotIK3vzLOCuTLNs
	 2ItIfydaybA/kQP9c4kRpVQBo15OOl57fVMDxB35dDmx+bYjZcLHe1oqVTJRujN/Bb
	 vpWvJm65jTpGIqJIZhFYVV9YrxLuPuaKlC0Dsy2mjA76P1Y7xRexmeMhmZXErrK/H3
	 fVPkNkFxdAZkZHbaMe6k29VpRkAow/13qUiTEHnisBDf8QdGMsAmd7x5qHLOqEdMWG
	 OPy3u6S8CElVS1LqzjncpJHaY9kR38z+c5XWtYr7ujHR1C6v8kmx031RxsQs4nCmY7
	 YoHCFyCr1LOsA==
Message-ID: <2703a06b-9144-4f44-b14e-fb94cc235b9d@kernel.org>
Date: Wed, 3 Apr 2024 09:33:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/28] block: Introduce zone write plugging
To: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-8-dlemoal@kernel.org>
 <25fd8351-d649-445f-84fb-ed1705275859@suse.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <25fd8351-d649-445f-84fb-ed1705275859@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/3/24 03:26, Hannes Reinecke wrote:
>> diff --git a/block/bio.c b/block/bio.c
>> index d24420ed1c4c..4ece8cef1fbe 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -1576,6 +1576,13 @@ void bio_endio(struct bio *bio)
>>       if (!bio_integrity_endio(bio))
>>           return;
>>   +    /*
>> +     * For BIOs handled through a zone write plug, signal the completion
>> +     * of the BIO so that the next plugged BIO can be submitted.
>> +     */
>> +    if (bio_zone_write_plugging(bio))
>> +        blk_zone_write_plug_bio_endio(bio);
>> +
> 
> Can't we move this check into blk_zone_write_plug_bio_endio()?
> We'd need to check it anyway ...

The goal here is to avoid a useless function call for regular devices or read
BIOs. There is no double check as the flag is not checked again in
blk_zone_write_plug_bio_endio(). Same comment for the other points you raised
(except the last one, see below).

If you really insist, I could play games with inline functions to "hide" the
check though.

>> +/*
>> + * Called from bio_attempt_back_merge() when a BIO was merged with a request.
>> + */
>> +void blk_zone_write_plug_bio_merged(struct bio *bio)
>> +{
>> +    struct blk_zone_wplug *zwplug;
>> +    unsigned long flags;
>> +
>> +    /*
>> +     * If the BIO was already plugged, then we were called through
>> +     * blk_zone_write_plug_attempt_merge() -> blk_attempt_bio_merge().
>> +     * For this case, blk_zone_write_plug_attempt_merge() will handle the
>> +     * zone write pointer offset update.
>> +     */
>> +    if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
>> +        return;
>> +
> See? you have to check anyway ...

This is the only function checking again, and for a good reason as the comment
above the check explains.

> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research

