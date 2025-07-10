Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBD3469D;
	Thu, 10 Jul 2025 04:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122278; cv=none; b=pEwFyQc4FuM9rw0XvSfPFPqul8HUx/zX5FBNQon77AFEXzotW4qn3eHwTWmzctVVpDzU3Q8b21u4hpFBr3H83PEB9EDxKxP3CQQcg/z3d4+Msd++CB1hEkFczfjRyulGxt3M7VzCiRKaZfOs+deF73AL16cHxkie4pIJ7YyxEUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122278; c=relaxed/simple;
	bh=nH2Uzbbah3Fp+qTw/XmILSdL6MP2gErBwVZUPJwW+DY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=chmSTEF3vA8A78gCA/uFB6wMUBfhc54oqsizNu8BHtQyvwYqvBXifiFtt97ThSg+o4rB7D9LFlv35DZ3/zOy3gr5pwRTp9aYnV3msfkGn2xSTi8OBcVu6Y3k8uBeSw7lvaDkjR858yMv/HNA68Q6kbKKrVBfvIU1cv6CHUFkSxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qPEz1Viq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qPEz1Viq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9979AC4CEE3;
	Thu, 10 Jul 2025 04:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752122277;
	bh=nH2Uzbbah3Fp+qTw/XmILSdL6MP2gErBwVZUPJwW+DY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qPEz1ViqIfswuA0QBM87iY/jUrmNbd0hnjNSOmOZ9VAiHKB9OLwckQC65okMtmxu+
	 tyroFFLLFzGS0stBguF1hs/H8BJN4oeT6firDQeUYOT88AiAcK1AkQSWhEr935GyPg
	 Ql/Jn9FP7mtm0Z4kW5/IUH4Y2LZtyGU9aFDwBcnNZaoeymGJuRuC7fnep9rrjuF9w5
	 IOxFCbrecmZZnUTyEB1LohB2R8G5H89taNca578nqpbejXwworBVk1F2e4flRgvvKx
	 s/yil48F4Gy12H+Uy1dyUhHJ3/rtDmuT8jz1oY3M3uauxkEeQT4IYGUQ34wLbM5gdp
	 yaDiSxef4kxOA==
Message-ID: <36c4d262-9329-4484-be79-9780f5429576@kernel.org>
Date: Thu, 10 Jul 2025 13:35:41 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 02/13] blk-mq: Restore the zone write order when
 requeuing
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai3@huawei.com>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-3-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250708220710.3897958-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 7:06 AM, Bart Van Assche wrote:
> Zoned writes may be requeued. This happens if a block driver returns
> BLK_STS_RESOURCE, to handle SCSI unit attentions or by the SCSI error
> handler after error handling has finished. A later patch enables write
> pipelining and increases the number of pending writes per zone. If
> multiple writes are pending per zone, write requests may be requeued in
> another order than submitted. Restore the request order if requests are
> requeued. Add RQF_DONTPREP to RQF_NOMERGE_FLAGS because this patch may
> cause RQF_DONTPREP requests to be sent to the code that checks whether
> a request can be merged and RQF_DONTPREP requests must not be merged.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

[...]

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 0c61492724d2..aa81526ad531 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1557,7 +1557,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
>  		 * already.  Insert it into the hctx dispatch list to avoid
>  		 * block layer merges for the request.
>  		 */
> -		if (rq->rq_flags & RQF_DONTPREP)
> +		if (blk_rq_is_seq_zoned_write(rq))
> +			blk_mq_insert_request(rq, BLK_MQ_INSERT_ORDERED);

Every zone write will go through this, even for devices that do not have
driver_preserves_write_order == true. Given that thi insert ordered function is
heavier than inserting at head, it would be nice to avoid this.

> +		else if (rq->rq_flags & RQF_DONTPREP)
>  			blk_mq_request_bypass_insert(rq, 0);
>  		else
>  			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);



-- 
Damien Le Moal
Western Digital Research
