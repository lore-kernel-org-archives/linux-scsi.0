Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8A8386;
	Thu, 28 Mar 2024 05:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711603221; cv=none; b=thsooqyyNuwCYLzjZRfNPcQeeHs5EXCTydIEKE9Lce3LKEX0VCUfvaUGAOuPN0lSQCk9TPMZRvPBHgUIdyCO3nBVwlBcqnOZioaJ4eEK/pzrDFuip41k0CxClqf8U9AZRwzYiE11nQ3YyS+r71ZO5OY00P7nv4BVVE6vyMClT68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711603221; c=relaxed/simple;
	bh=xhf25+ggxrtfWdpFJalZY7ZD2A9ShjFcxIR0/21YZJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gy+ItZbklqePLp7Ok0WvXhlGgJJfF6Ebj7jcbYArS+2bpE/kvJFIozXS+mEyfy0MqG0v4viWgtBM1i04hrgv+enjASJOu5vt2EXE85k39mlEaJvYsfciBI1y4YfCEtzn4JC2nShxvD7Nwc3IeWhTu/OL6kHCKDjxio0cIYVBY6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=No/9ub/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="No/9ub/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4146FC433C7;
	Thu, 28 Mar 2024 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711603220;
	bh=xhf25+ggxrtfWdpFJalZY7ZD2A9ShjFcxIR0/21YZJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=No/9ub/3qhoe1DZNXgYVGWg7izotLSo1qyyABkeFEKoIHjQ7kr8bxLuw8CPPf2kIP
	 mHENByqIcVBd+Q2SCa4Zs66tKwk/kmU9CFSC/UO25ZM3Y/9g8TnJLS5ZFquZflE4vc
	 YROLnKJhNkLNPlVHs9pU5GlkISJ4somiEisgpvzO8sfMHdJbjH/GfXS/FnwX4LVEpW
	 jlvtqaDz+vZQProMXEuR6IDiIBkIYRGEibAEBjrWmI6Rs0+nuK6Q7Ffdr1P2PvtiDl
	 //6UaH/u0GkJneC4NBEy0Cf37FjZG/wYh/3qCG5ZZgwfu5gGHi5DhO5F94mbV7exMz
	 /gJNujhPDtrjw==
Message-ID: <86114cba-535b-41e9-9b85-bac2fbdc1ed3@kernel.org>
Date: Thu, 28 Mar 2024 14:20:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/30] block: Introduce blk_zone_update_request_bio()
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-5-dlemoal@kernel.org> <20240328041457.GC13510@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240328041457.GC13510@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 13:14, Christoph Hellwig wrote:
>> -		if (req_op(req) == REQ_OP_ZONE_APPEND)
>> -			bio->bi_iter.bi_sector = req->__sector;
>> -
>> -		if (!is_flush)
>> +		if (!is_flush) {
>> +			blk_zone_update_request_bio(req, bio);
>>  			bio_endio(bio);
>> +		}
> 
> As noted by Bart last time around, the blk_zone_update_request_bio
> really should stay out of the !is_flush check, as otherwise we'd
> break zone appends going through the flush state machine.

I do not think that is corect. Because is_flush indicates that RQF_FLUSH_SEQ is
set, that is, we are in the middle of a flush sequence. And flush sequence
progression is handled at the request level, not BIOs. Once the sequence
finishes, then and only then the BIO original endio should be done, meaning that
we will then take this path and actually do blk_zone_update_request_bio() and
bio_endio(). So I still think this is correct.

> 
> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

-- 
Damien Le Moal
Western Digital Research

