Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3B34A99C;
	Mon,  5 Feb 2024 23:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707176732; cv=none; b=b0ZMOhxak8YD9X6lxcEZbrF1Brq91SwYLFcUyS31ZaQKw3mo+VOEHzhfCVZg81L/ZDMopaboUFHW8jTtIKouLrh2FOBgvbPuAJNAixuDngMA6iGVICuVtP7mihy78RulH1CGru1DdRz8AVBSSnXtOBgqu4T0WmXLTVrvt2M3ljQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707176732; c=relaxed/simple;
	bh=hS641mcs4QTu9xC0rpkEGsLMg7jDwZhVm/wXXeAtWLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KmBX0gjk1T9kqSubxVdTDRfUdogDM//vxK2++7jDWsjVSdv5Fb5H2XOdr7znjP8w2oHkMG9xGHPM8N0bCPKDMFZUiEKLU+SEn4Ue81yJ82Yor7Inv8G1b12Zt46Bj/7284pWUw2QFSoCFh6iQNlIWK3XMx59QwSnDe80uYL5M/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sUbjNEjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sUbjNEjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66784C433C7;
	Mon,  5 Feb 2024 23:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707176731;
	bh=hS641mcs4QTu9xC0rpkEGsLMg7jDwZhVm/wXXeAtWLY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sUbjNEjhs5WG+mp0A2EbwLHwuXnglzjpzeoUacTnDuO4Mav2lw8dY4IGQo+Mi9Opz
	 FqjawVz1f0m+idoWYs6BIw6SK3hu+P+yDYRZQDz8fkOBG7/b8CJ7Tg1aPfiIWsAwLS
	 XGVg+P5ciFvCghVWbMPgvy2Tf2cxei2W0u8J9AFA0xcA+KSDP99PSWf0qEmzjHFaaa
	 nX+gXV9UYHmStmxAZTyACmx5CX/MkEfJMYMGH70559cL12AkVl35ed6mfM7vW3YLBF
	 kHD3DBQPImzK3kuXVQuUJhK01T1JCw7fXesaOKBxP1JXWZgHz3ys9rQ5fw8tj5dWEU
	 H2u9tO4sWBeEQ==
Message-ID: <8d34308f-9465-4858-8ac0-5a5adf0608e5@kernel.org>
Date: Tue, 6 Feb 2024 08:45:29 +0900
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
Content-Transfer-Encoding: 7bit

On 2/6/24 02:28, Bart Van Assche wrote:
> On 2/1/24 23:30, Damien Le Moal wrote:
>> @@ -916,9 +888,8 @@ bool blk_update_request(struct request *req, blk_status_t error,
>>   	if (blk_crypto_rq_has_keyslot(req) && nr_bytes >= blk_rq_bytes(req))
>>   		__blk_crypto_rq_put_keyslot(req);
>>   
>> -	if (unlikely(error && !blk_rq_is_passthrough(req) &&
>> -		     !(req->rq_flags & RQF_QUIET)) &&
>> -		     !test_bit(GD_DEAD, &req->q->disk->state)) {
>> +	if (unlikely(error && !blk_rq_is_passthrough(req) && !quiet) &&
>> +	    !test_bit(GD_DEAD, &req->q->disk->state)) {
> 
> The new indentation of !test_bit(GD_DEAD, &req->q->disk->state) looks odd to me ...
> 
>>   		blk_print_req_error(req, error);
>>   		trace_block_rq_error(req, error, nr_bytes);
>>   	}
>> @@ -930,12 +901,37 @@ bool blk_update_request(struct request *req, blk_status_t error,
>>   		struct bio *bio = req->bio;
>>   		unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
>>   
>> -		if (bio_bytes == bio->bi_iter.bi_size)
>> +		if (unlikely(error))
>> +			bio->bi_status = error;
>> +
>> +		if (bio_bytes == bio->bi_iter.bi_size) {
>>   			req->bio = bio->bi_next;
> 
> The behavior has been changed compared to the original code: the original code
> only tests bio_bytes if error == 0. The new code tests bio_bytes no matter what
> value the 'error' variable has. Is this behavior change intentional?

No. I do not think it is a problem though since if there is an error, bio_bytes
will always be less than bio->bi_iter.bi_size. I will tweak this to restore the
previous behavior.


-- 
Damien Le Moal
Western Digital Research

