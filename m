Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA081B667;
	Mon,  5 Feb 2024 05:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707111507; cv=none; b=sJ+MSTamdaMbDh2fFiYRqU6xkzhX4bwimi9F/zGQ9uhB92yYWdaal+cFZeXgPHS5S5TGl/OqlGbMETVCoNl4g5eUGeMgg5mkgbgUjrPe0ZCvm/fANUeiWdLcUbqXOTZHdGP0SbJrAvPUeSIIka2Avogt7Mna0ohiWbEYzXYPHf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707111507; c=relaxed/simple;
	bh=tUgu2sLJMlUkExCLPysJsL7ktho+RO6M+qUo//JRR1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pdp258xtUwt0hH0aRwtmbpBnIQLYrH6I1xTW159uM8je4i4YNOhKDoCQycckorYLAbEiA0nwBIYajSAw8RzVBeMf91eRdtgMXqjbgT2I1W1Jg1W1iEYHNp42FA3tlFiVuj/3g8yrGFvI1jDGfqFNKlSOu92kJMZ9bjjjJilO10k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CxZ+knDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CxZ+knDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C270C433F1;
	Mon,  5 Feb 2024 05:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707111507;
	bh=tUgu2sLJMlUkExCLPysJsL7ktho+RO6M+qUo//JRR1Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CxZ+knDIUWeftYCFVtoaE7X7q2oV4jklT4YM8F34TAiwQpJXg7/CkZC9fRJH2SY4+
	 +JqlMbzfDegS/mUWy6hZMNfvCq53+MKK6f5b8/MXPZ1/3lcVjSWjRORKuo8Lj1xwdm
	 MwX5bzxUgpilF/3nBMT5KyTaDsDAwMtDMrozeE2YNTen8qOIwbi0hZsaOFzJehZquf
	 ubRL3cbK9KLUi0zldHsA0CdEHBTAHZqLOiN556ksSXlojN5TqKOILNYLVAM4cM1VvG
	 mVbrWvwMNubByR1bRSdlPnYDe6atJ0EfTqnaOHy57XfX+y69Yj6mhYYjeWSQ76GgPE
	 bBID2KU6DlMXQ==
Message-ID: <4eb920d7-e2fc-49d0-9eec-5fc152fa21de@kernel.org>
Date: Mon, 5 Feb 2024 14:38:25 +0900
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
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Zb5-2LsnQtJHV2mL@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/24 02:58, Mike Snitzer wrote:
> Love the overall improvement to the DM core code and the broader block
> layer by switching to this bio-based ZWP approach.
> 
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>

Thanks Mike !

> But one incremental suggestion inlined below.

I made this change, but in a lightly different form as I noticed that I was
getting compile errors when CONFIG_BLK_DEV_ZONED is disabled.
The change look like this now:

static void dm_split_and_process_bio(struct mapped_device *md,
				     struct dm_table *map, struct bio *bio)
{
	...
	need_split = is_abnormal = is_abnormal_io(bio);
	if (static_branch_unlikely(&zoned_enabled))
		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);

	...

	/*
	 * Use the block layer zone write plugging for mapped devices that
	 * need zone append emulation (e.g. dm-crypt).
	 */
	if (static_branch_unlikely(&zoned_enabled) &&
	    dm_zone_write_plug_bio(md, bio))
		return;

	...

with these added to dm-core.h:

static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
					   struct bio *bio)
{
	return md->emulate_zone_append && bio_straddle_zones(bio);
}
static inline bool dm_zone_write_plug_bio(struct mapped_device *md,
					  struct bio *bio)
{
	return md->emulate_zone_append && blk_zone_write_plug_bio(bio, 0);
}

These 2 helpers define to "return false" for !CONFIG_BLK_DEV_ZONED.
I hope this works for you. Otherwise, I will drop your review tag when posting V2.

-- 
Damien Le Moal
Western Digital Research

