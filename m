Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2276FE05;
	Mon, 25 Mar 2024 23:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711409002; cv=none; b=iacjfuxanHtw0Cj0ehfvU7o/P8ktWdEXz3YDqfiAxd8X0Aj0fhNNwscShQJGh7bm9OuWWEzHWoksktGxKqHjrKNMD/mRoJZ+rmEgogbdKFC9yp8F1DxRNjcnXAwZZPpHDY18YkAdezH4IpvNtEjh2d20fcWF0X4+GQ5w6DP6wUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711409002; c=relaxed/simple;
	bh=v5B55OzY0NZ3VEVd9kcrLWRkVYRFdm4B65Y1TGJxHG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GW9ra+E0dJ/Xnyy/46Ni2+Hr5GltbxJocBH+n/TyPd+wV85yPHtq3oRlUtk4A8Io+FZJckmMJGc942caiYGc6vl42UG8B8l8XTS6OY4c9E62C+c5WsODNXRLiNVQtmXv8IpeJ3SMD4dEBA2Oh9R0rtYEGWD2rGcXw7yRmQMs8/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hz9sgYIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hz9sgYIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9ABC433C7;
	Mon, 25 Mar 2024 23:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711409001;
	bh=v5B55OzY0NZ3VEVd9kcrLWRkVYRFdm4B65Y1TGJxHG4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hz9sgYIC2SOdbFKotLWlZBZd1WAHHyiPoFsm18N4IqLgnNRuWVpAjH1og+DLsem0Z
	 QJKv1mDGdvig2Mz+icMG4ek2i+r2gGUav6TXX0hdjakCwjpWoJxWTJUK9XrSLMBFzz
	 IdWtdFN2H4FDmoQAbTMycvHpoNHWhL+HKeJ8WjTKvSp8FCG41h72GftZewMQ4tyCob
	 k22UjU+9jC6Jp2NFH2yji+iSyUQw1vkP7ssTPhEaJRPrRztQaZ1UhhlEb1ge1LRc0z
	 I30qOCglNg4I15nb78IqVs33MqVXe927dYiRIzIdk87l7w/E/ogllvbppvuYzTuUEE
	 VpVBjiGOcYo4Q==
Message-ID: <0d3d0d81-66e0-4c7c-82dd-024972946666@kernel.org>
Date: Tue, 26 Mar 2024 08:23:19 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/28] block: Introduce blk_zone_update_request_bio()
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-4-dlemoal@kernel.org>
 <20a3af4a-3075-4abc-8378-d55ea84a5893@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20a3af4a-3075-4abc-8378-d55ea84a5893@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/24 04:52, Bart Van Assche wrote:
> On 3/24/24 21:44, Damien Le Moal wrote:
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 8aeb8e96f1a7..9e6e2a9a147c 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -820,11 +820,11 @@ static void blk_complete_request(struct request *req)
>>   		/* Completion has already been traced */
>>   		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
>>   
>> -		if (req_op(req) == REQ_OP_ZONE_APPEND)
>> -			bio->bi_iter.bi_sector = req->__sector;
>> -
>> -		if (!is_flush)
>> +		if (!is_flush) {
>> +			blk_zone_update_request_bio(req, bio);
>>   			bio_endio(bio);
>> +		}
> 
> The above change includes a behavior change. It seems wrong to me not
> to call blk_zone_update_request_bio() for REQ_OP_ZONE_APPEND requests if
> RQF_FLUSH_SEQ has been set.

REQ_OP_ZONE_APPEND + RQF_FLUSH_SEQ is not something supported, and this patch
series is not changing that. The reason is that the flush machinery is not
zone-append aware and will break if such request is issued for a device that
does not support fua. We probably should check for this, but that is not
something for this series to do and should be a separate fix.

-- 
Damien Le Moal
Western Digital Research

