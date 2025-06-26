Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35CE2F1FF1;
	Thu, 26 Jun 2025 00:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896700; cv=none; b=LFbAVy6+LZaa/e6dlFjV9QmG7sTconfqfprRdCbqnJjH7qg1I66iV2gxiE60v8LRGZviP22QUXwB9OiQxBmN+OObLSxrEXOcbYeD9yj1szlsMPtutvnzrLeHG7GU4fjJhG4D5asuDAQS1HZqRPrbkNjR7rvn5RNMk8jN9Wn4DY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896700; c=relaxed/simple;
	bh=rKgqLLY1s9DsW2W0Md+sYddOuhQ/vSNY3Bn55ln4XwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aMUlI/EK/QIADPAMo+YrdIW2a+OWsMDzAoS+9++Dr2zDIIDDFVoKZ/fSHFB96ajHs78+ae2+UUKPW9oVxc6BqadmguaU8sBdnSK171mABce1oTIEf5a9hWG+TrW9vF1dWccl1gGTdrO/vYuyqOtoccFvcmnYuDrwh4M/oYnvl0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qW5eukb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qW5eukb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8EBC4CEEA;
	Thu, 26 Jun 2025 00:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750896700;
	bh=rKgqLLY1s9DsW2W0Md+sYddOuhQ/vSNY3Bn55ln4XwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qW5eukb81E2vfgPBznxHSwpErK6x2hQ/aqaBhr0msEk2C0+hWyyp8ftZ+aYEAHEk8
	 62WMp20SIKbK2e9Q91hfdiU6BKI+tNK48zpzgk91aNKNGmDkwWSl/JAIZMl6wz9lCW
	 YZwY+h794/4sqlG+0nBflH5gnCBe9A4cG8ZN/OUpjEYZ0vhSX5XpT9aGGLWtXZOc70
	 LiBr3qD7eV8HsVaVhR3buWa0Ra5sWqQ+3Io/dLclFCP29Gn4wDiNPY10/1McaB88TY
	 /5hIDIsr2njSLiUgXIgB+IfxmSqig2qNYR7zJqaObF4HjFl6fUA9rTnNdu5fEAkzoY
	 cpbvVJjycxI1Q==
Message-ID: <8df3d726-2ad1-4592-aa1f-f3d5eeb17014@kernel.org>
Date: Thu, 26 Jun 2025 09:11:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 04/12] blk-mq: Restore the zoned write order when
 requeuing
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai3@huawei.com>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-5-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250616223312.1607638-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 07:33, Bart Van Assche wrote:
> Zoned writes may be requeued. This happens if a block driver returns
> BLK_STS_RESOURCE, to handle SCSI unit attentions or by the SCSI error
> handler after error handling has finished. Requests may be requeued in
> another order than submitted. Restore the request order if requests are
> requeued. Add RQF_DONTPREP to RQF_NOMERGE_FLAGS because this patch may
> cause RQF_DONTPREP requests to be sent to the code that checks whether
> a request can be merged and RQF_DONTPREP requests must not be merged.

Shouldn't this last part be a different prep patch ?

But overall, the commit message is inadequate because you have not yet enabled
pipelining, so this patch will only see one write request per zone at most. And
in that case, we do not care about ordering. We only care about the order of
requests per zone.

>  static void blk_mq_insert_request(struct request *rq, blk_insert_t flags)
>  {
>  	struct request_queue *q = rq->q;
> @@ -2649,6 +2665,8 @@ static void blk_mq_insert_request(struct request *rq, blk_insert_t flags)
>  		spin_lock(&ctx->lock);
>  		if (flags & BLK_MQ_INSERT_AT_HEAD)
>  			list_add(&rq->queuelist, &ctx->rq_lists[hctx->type]);
> +		else if (flags & BLK_MQ_INSERT_ORDERED)
> +			blk_mq_insert_ordered(rq, &ctx->rq_lists[hctx->type]);
>  		else
>  			list_add_tail(&rq->queuelist,
>  				      &ctx->rq_lists[hctx->type]);

This pattern is repeated multiple times. Make it a helper ?



-- 
Damien Le Moal
Western Digital Research
