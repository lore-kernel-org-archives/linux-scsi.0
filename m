Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1CA657B9;
	Fri,  9 Feb 2024 06:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707461620; cv=none; b=Zq/XjFJuUHJKYf4wwq4EBwE7IABmKf5AoE9U40D9npiLbXpQLmO3H7pCVlEHCHWun6K+yTgjn7tLJy0VvJXtVxCCn9kQ47XjG0EpraRB7oP9BdLcvgJI61BWRrqFv0qnuziITY8xbbjEM/Jsvcbrp3MGw0vfApyJmqb7gKP5P1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707461620; c=relaxed/simple;
	bh=eCw7STPKXS+agLadcrN5bno4acjIX2Vj7SN1t1guTTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXensqoJwrO9Ad6CKLM7QEwUx43bq9RtK0oIf9SMTDQU3aGVq1N/6fAShbwVQJVwN7ic/Sv7QV6jZFCdcCJGUhVORQjV8V19LVAHDkFY1I+jjxeZDFZ9SxBp6urAGwy7yipMoHavw6nEDxqlt/nakxPM14gGwm5I1CuBH1eQrm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZ75NaXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZ75NaXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2397C433F1;
	Fri,  9 Feb 2024 06:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707461620;
	bh=eCw7STPKXS+agLadcrN5bno4acjIX2Vj7SN1t1guTTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GZ75NaXlVXr12MeJ7UTInLufoEUASxRkASW7RN421i1RqFCu10pF0cPq04yb8bYC3
	 /iLTJXWFrT+tBWun5q5GYHNSdFM3nVoQ2L/NHfXY3/DZDFdukPnudYT34id7t/bOZt
	 JUCKPlIEUYbB5JKrZOq+QqYJtq8GsHJe5zl59k6vCLjcMMDOzKPAJsYjpPBQx3BOq3
	 JCAVtCJr+GycKbsl958fi9ohPiqLXpH5XHnaZR4mgWZdCsUwdAcZ/Y/5aJn++WHL9m
	 ffcXicsnjIq7aieac+mjrpfXnQNhsntN5M0/qz+PHJyQyMA5ZTriJlx43kNRFtHwrW
	 3qSlwyIUWbAxw==
Message-ID: <393e6c27-330f-47fd-ae38-09467419adf4@kernel.org>
Date: Fri, 9 Feb 2024 15:53:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/26] block: Remove req_bio_endio()
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-3-dlemoal@kernel.org>
 <f7dd57a7-1612-457e-aec0-5cf2c4d98b78@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <f7dd57a7-1612-457e-aec0-5cf2c4d98b78@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/6/24 02:28, Bart Van Assche wrote:
> On 2/1/24 23:30, Damien Le Moal wrote:
>> @@ -916,9 +888,8 @@ bool blk_update_request(struct request *req, blk_status_t
>> error,
>>       if (blk_crypto_rq_has_keyslot(req) && nr_bytes >= blk_rq_bytes(req))
>>           __blk_crypto_rq_put_keyslot(req);
>>   -    if (unlikely(error && !blk_rq_is_passthrough(req) &&
>> -             !(req->rq_flags & RQF_QUIET)) &&
>> -             !test_bit(GD_DEAD, &req->q->disk->state)) {
>> +    if (unlikely(error && !blk_rq_is_passthrough(req) && !quiet) &&
>> +        !test_bit(GD_DEAD, &req->q->disk->state)) {
> 
> The new indentation of !test_bit(GD_DEAD, &req->q->disk->state) looks odd to me

But it is actually correct because that test bit is not part of the unlikely().
Not sure if that is intentional though.

> ...
> 
>>           blk_print_req_error(req, error);
>>           trace_block_rq_error(req, error, nr_bytes);
>>       }
>> @@ -930,12 +901,37 @@ bool blk_update_request(struct request *req,
>> blk_status_t error,
>>           struct bio *bio = req->bio;
>>           unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
>>   -        if (bio_bytes == bio->bi_iter.bi_size)
>> +        if (unlikely(error))
>> +            bio->bi_status = error;
>> +
>> +        if (bio_bytes == bio->bi_iter.bi_size) {
>>               req->bio = bio->bi_next;
> 
> The behavior has been changed compared to the original code: the original code
> only tests bio_bytes if error == 0. The new code tests bio_bytes no matter what
> value the 'error' variable has. Is this behavior change intentional?

No change actually. The bio_bytes test was in blk_update_request() already.

> 
> Otherwise this patch looks good to me.
> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

