Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD905228;
	Mon,  8 Apr 2024 01:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712539572; cv=none; b=bXMnyj6wdtylO5es5zwV6HewX1BkO6UCwaI7fD/MwFeVDLTYP5pwn3b0jMuHqmKtXDdu2mgEp4HxRiDi1MuHx8SCtUUtBKEm6iNlXjQXYN3QMcWDfQLdfIJFweOC7MIlmijwLhKofqb1ORdRJtnhN6wa5GU5RzXDInFdU5TfmGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712539572; c=relaxed/simple;
	bh=+UQXNtn1Uy7xaukPw1RWns7kxpirCo4Jp35Je0Y1ODU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AcaihnLkCruAm+3FohUJbp+cM8kpoAn4/iZqCO9lhgQOkoZLexh/lSmnNrAT3A31pkSx79bHg4TlNEJdUB2mEEd6UQJhhJOHUBG1jajAHttMmI1wd8XVlPIVh8bwQ5qppjsqTRVJFud/kl0/pEikU4w+12ZfjdaJ/Uere5TSRJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dn5qm8kW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dn5qm8kW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326A9C433C7;
	Mon,  8 Apr 2024 01:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712539571;
	bh=+UQXNtn1Uy7xaukPw1RWns7kxpirCo4Jp35Je0Y1ODU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dn5qm8kWLR9O4+p065nJcW0gqIUM2WETkhmlR6RkFFI1xAJkjzP9f/XpTgyeityUt
	 B+EnDeNGzLRbp4JuEfmYaG6ngRXx+raxAMp1hX/TzeLWJl4NJZ4BroeZ81oLkgJPj0
	 vbRrUJ2ShzKqlU/RBXr7W1JQUj3mAw/Hrd8ekOb9jZAVouzNyGOx/BAccqOd8neBAc
	 Fx0LjWPA1U1p2bp2M8jvfoBDxNJ0TKNBI1xBmVPi4oBaPUcqnIrJVBYrf84pNz1sG1
	 m+e+fYp89HYiyEzV6Inyp8kz6Xv359sHhcyIwhSRTR2szx9jNMNfcnzlFs/FeJMAeZ
	 00G0LnUFBjQzA==
Message-ID: <51f5c3eb-df8b-4e9a-97e3-7f100d98fd1d@kernel.org>
Date: Mon, 8 Apr 2024 10:26:08 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/28] dm: Use the block layer zone append emulation
To: Mike Snitzer <snitzer@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
 <20240405044207.1123462-13-dlemoal@kernel.org> <ZhAc5JL9KwoDdiOO@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZhAc5JL9KwoDdiOO@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/6/24 00:46, Mike Snitzer wrote:
>> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
>> index eb9832b22b14..174fda0a301c 100644
>> --- a/drivers/md/dm-zone.c
>> +++ b/drivers/md/dm-zone.c
>> @@ -226,41 +154,32 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
>>  static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>>  {
>>  	struct gendisk *disk = md->disk;
>> -	unsigned int noio_flag;
>>  	int ret;
>>  
>> -	/*
>> -	 * Check if something changed. If yes, cleanup the current resources
>> -	 * and reallocate everything.
>> -	 */
>> +	/* Revalidate ionly if something changed. */
> 
> Just noticed this ionly typo ^ Please fix.

Good catch. Thanks. Fixed it. Also fixed a tab that became spaces in the
declaration of dm_blk_report_zones() in drivers/md/dm.h.


-- 
Damien Le Moal
Western Digital Research

