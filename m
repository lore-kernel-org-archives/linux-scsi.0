Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3684CB41;
	Mon,  5 Feb 2024 23:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707176432; cv=none; b=cUxYsDmIurLfqy7YbAg514HjYcThoe2WJLI0G2WZK6tcDX8fPRpC2k8I44JMPq3RUd/Y/50xbv4YOfWH9qUVqcMovPAiHW58b48tjFGuHmIFiQV7kZa8TPCpa+06EjjSSJW4AJrzWe8t/PFOAWZUcqMgWb3oyj8aog7zZVmBF7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707176432; c=relaxed/simple;
	bh=h+gnqVD2ATNthbjte0KY6e0m1YspY1vOlChihcpNHP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wv25z6MHRxJo9vFdB3JMnFnS6PJ/72PflFFeVGfnYnV9GSqZ5uXiYIReISbhC+S483mYA6oDV8BvnpdfWdx1cdCSiCFxXlfgg712LdCjJRr3eu7pHLADyUbyxzjjipuGmAosPJUjEPS4p+P1uCfnakDW62NlR3fSKQFsuqtIcFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBS0b4eC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBS0b4eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83821C433C7;
	Mon,  5 Feb 2024 23:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707176430;
	bh=h+gnqVD2ATNthbjte0KY6e0m1YspY1vOlChihcpNHP8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kBS0b4eCPgni1Iu9vWOrJi8VPyJGcON3gi6uuUTl15ZgcfYGdtESN8S7QEOjZycwJ
	 IDdv6lW4zzhOs2ZITMWNsayll67VV9jQdgI64DzkHIOGP0nx48ss/8nb3LfJVLpj8P
	 MhfVPX8J8mE3BHZ3cKruKT4vCh740yQos/NBkEfkZV4Tww1dcmTe01Xkb63a2cx5X1
	 +gjG73URzIeYifgSe65b7VmZ0dY2jTpQ6/MF7VlsWPinOKretqxNb08BQWsoZLnU7F
	 ewHVQCzftzZv3bokALyhkK4LFOlaIUtJL8IIn5bPGDlrTgNOOyacUOtDah6rgd9dTJ
	 l5L0YQJr8Shgg==
Message-ID: <ce23dd28-50d3-4650-993d-351cbcb45a80@kernel.org>
Date: Tue, 6 Feb 2024 08:40:27 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/26] dm: Use the block layer zone append emulation
Content-Language: en-US
To: Mike Snitzer <snitzer@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-11-dlemoal@kernel.org> <Zb5-2LsnQtJHV2mL@redhat.com>
 <4eb920d7-e2fc-49d0-9eec-5fc152fa21de@kernel.org>
 <ZcFGGdVc7mqCpU7a@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZcFGGdVc7mqCpU7a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 05:33, Mike Snitzer wrote:
> On Mon, Feb 05 2024 at 12:38P -0500,
> Damien Le Moal <dlemoal@kernel.org> wrote:
> 
>> On 2/4/24 02:58, Mike Snitzer wrote:
>>> Love the overall improvement to the DM core code and the broader block
>>> layer by switching to this bio-based ZWP approach.
>>>
>>> Reviewed-by: Mike Snitzer <snitzer@kernel.org>
>>
>> Thanks Mike !
>>
>>> But one incremental suggestion inlined below.
>>
>> I made this change, but in a lightly different form as I noticed that I was
>> getting compile errors when CONFIG_BLK_DEV_ZONED is disabled.
>> The change look like this now:
>>
>> static void dm_split_and_process_bio(struct mapped_device *md,
>> 				     struct dm_table *map, struct bio *bio)
>> {
>> 	...
>> 	need_split = is_abnormal = is_abnormal_io(bio);
>> 	if (static_branch_unlikely(&zoned_enabled))
>> 		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
>>
>> 	...
>>
>> 	/*
>> 	 * Use the block layer zone write plugging for mapped devices that
>> 	 * need zone append emulation (e.g. dm-crypt).
>> 	 */
>> 	if (static_branch_unlikely(&zoned_enabled) &&
>> 	    dm_zone_write_plug_bio(md, bio))
>> 		return;
>>
>> 	...
>>
>> with these added to dm-core.h:
>>
>> static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
>> 					   struct bio *bio)
>> {
>> 	return md->emulate_zone_append && bio_straddle_zones(bio);
>> }
>> static inline bool dm_zone_write_plug_bio(struct mapped_device *md,
>> 					  struct bio *bio)
>> {
>> 	return md->emulate_zone_append && blk_zone_write_plug_bio(bio, 0);
>> }
>>
>> These 2 helpers define to "return false" for !CONFIG_BLK_DEV_ZONED.
>> I hope this works for you. Otherwise, I will drop your review tag when posting V2.
> 
> Why expose them in dm-core.h ?
> 
> Just have what you point in dm-core.h above dm_split_and_process_bio in dm.c ?

I wanted to avoid "#ifdef CONFIG_BLK_DEV_ZONED" in the .c files. But if you are
OK with that, I can move these inline functions in dm.c.


-- 
Damien Le Moal
Western Digital Research

