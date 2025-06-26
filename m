Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE74A2EFDB1;
	Thu, 26 Jun 2025 19:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750966948; cv=none; b=uzlpZ5HI7+q+6sGznaBD+NlLFPMhegmYV6qiC7UzD2qJ8Hb6NLa7IvJRXm68fyNxVlimyRsn15uCXcuq/+DvqUfDImd1/Zz2tZgOfQ8RL9WNYoib12qx1eNHS/Xyjw6kZZecVl1ukfyUQy8grcji3uAhDSdlSR6Gwd5P7uDPSUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750966948; c=relaxed/simple;
	bh=UhtTgxYsewfDZ1sVGQQs/yjCE8lzSPT1bdNzk+qtaWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s898vSq3sG4aSdNxOxoKoWMvs5vKHaoTzY1UkDarbWGXc0KTh2LLHLND7tnjag8GivrDmWCU+Z+x+tsiXgmSv1SxsVs463TokO9hHpIGNH71tQkAS604KgXiTGfWLqI3pu7FpGC1ELUIByRGueJqtRjPjBV13BGE4MH+QKYt9eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BmGmllty; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BmGmllty"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bSpxF4nwrzm0yQd;
	Thu, 26 Jun 2025 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750966944; x=1753558945; bh=DO4Ajm5yJAUZQO1VLeK2cYaD
	j7dY+GIVytxqX/PfGq0=; b=BmGmlltyEgl4uodyIQrjcGCrwEw6C7kkCr490U4g
	eCuBsiqAsqNmCzIslgtxDY98fP6+tfWpWz1Q3ZlQLvSQMLvi97z5FbuWzjGGNqA4
	zZ2rnmAQuJ1YhY1whRjER/XkHMYVX1OBhqie8RcmAQI7A3Cx1ujtwhKsTFIvHAf5
	oYFk94txNtTqbNFEA8OjqJ6U5FBMdraiETCK4sRKP3IpMGT5h+kX3FQKqIg99jyR
	GHXoA6alWfnOEDBeQrzhAuwvAEJHow6ONVIlfJ/EvFShkD5gk2WrtbFgmZ7S9Gzv
	liNTY2v3LG5j9PY1a7UDtvMaSA+m0WCzuGTu8fE1lORv6g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id j5M4bBBsZHjL; Thu, 26 Jun 2025 19:42:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bSpx82K4Dzm0ySQ;
	Thu, 26 Jun 2025 19:42:19 +0000 (UTC)
Message-ID: <fdcdb18c-91b1-4c31-b24c-5837a8a08ac7@acm.org>
Date: Thu, 26 Jun 2025 12:42:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 04/12] blk-mq: Restore the zoned write order when
 requeuing
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai3@huawei.com>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-5-bvanassche@acm.org>
 <8df3d726-2ad1-4592-aa1f-f3d5eeb17014@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8df3d726-2ad1-4592-aa1f-f3d5eeb17014@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 5:11 PM, Damien Le Moal wrote:
> On 6/17/25 07:33, Bart Van Assche wrote:
>> Zoned writes may be requeued. This happens if a block driver returns
>> BLK_STS_RESOURCE, to handle SCSI unit attentions or by the SCSI error
>> handler after error handling has finished. Requests may be requeued in
>> another order than submitted. Restore the request order if requests are
>> requeued. Add RQF_DONTPREP to RQF_NOMERGE_FLAGS because this patch may
>> cause RQF_DONTPREP requests to be sent to the code that checks whether
>> a request can be merged and RQF_DONTPREP requests must not be merged.
> 
> Shouldn't this last part be a different prep patch ?

No. Without the RQF_NOMERGE_FLAGS change, this patch would introduce a
bug. The bug that would be introduced without the RQF_NOMERGE_FLAGS
change is that merging might happen of RQF_DONTPREP patches. As you know
patch series must be bisectable.

> But overall, the commit message is inadequate because you have not yet enabled
> pipelining, so this patch will only see one write request per zone at most. And
> in that case, we do not care about ordering. We only care about the order of
> requests per zone.

I will add in the patch description that this patch prepares for
enabling write pipelining.

>>   static void blk_mq_insert_request(struct request *rq, blk_insert_t flags)
>>   {
>>   	struct request_queue *q = rq->q;
>> @@ -2649,6 +2665,8 @@ static void blk_mq_insert_request(struct request *rq, blk_insert_t flags)
>>   		spin_lock(&ctx->lock);
>>   		if (flags & BLK_MQ_INSERT_AT_HEAD)
>>   			list_add(&rq->queuelist, &ctx->rq_lists[hctx->type]);
>> +		else if (flags & BLK_MQ_INSERT_ORDERED)
>> +			blk_mq_insert_ordered(rq, &ctx->rq_lists[hctx->type]);
>>   		else
>>   			list_add_tail(&rq->queuelist,
>>   				      &ctx->rq_lists[hctx->type]);
> 
> This pattern is repeated multiple times. Make it a helper ?

The repeated code is too short to make it a helper function. Common
feedback on block layer and NVMe kernel patches is that very short
helper functions reduce code readability and hence that typically
it's better to expand code inline rather than to introduce a very
short helper function.

Thanks,

Bart.
