Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE501CD24;
	Thu, 28 Mar 2024 18:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711649659; cv=none; b=bWDscat1RWlDU4xRnpeYBe+W2GOO3gQ2WVBnbOQsW5Ji317iFtsd4nquTaYYOJfuWgojMbYRCmegZEOGSqjmv/xSW19oL7ux+dIAIhm8ZRxeIJLDMqVBN2cs7qChn2HRdM4/znss6hEv86GTKvqB1H+fWsysIjj/rosfSsnKF00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711649659; c=relaxed/simple;
	bh=gLygC9Vp66UvWQw2Yi8ZCQFXKYiU/tkZw+C8jULcJF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r7Nc5yqD9FTYsEmq/J15Mt8wB26wIdIRVE/tP4VBqPWHBZXhrFyFa9zngsgSdI+pY3+NkQaUE3Jj3tswYCwVx/anNR7XwpkqJsI5Rc5yL1LqSTyW9koSKKpMFPXGF4+qyyJqshhtGRbnl/zOXwEsgED74YEfHSrzGRZlcckobU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iuwosM9K; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iuwosM9K"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5BWR50w5zlgTGW;
	Thu, 28 Mar 2024 18:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711649647; x=1714241648; bh=FMpIw+4/bg5d5JM200rhY7E6
	bZSeI+7NplMoHYYK1Tw=; b=iuwosM9KdXWsyq1U30xWAJpj9J7ys9QDClYZFUv7
	zwclHQgfVB3/WXjHtwTvtqmF4Fl24fpxZ+LuVbvrTG8E04kr0zJYBo/jUI4qZTLr
	Cc0u4SHampfYpUNGkRcJgBF2bEDbRAFDzDlxq2A+/VpcrXYs4VJ5GQq+jNXjW3Gw
	A+OGYyYtSbpE0kdvzObZZKFpxrFcTPb17zUN/xbP7XPGpGGAwHz8V82ejRMexCBm
	Wl/XEo7MzOS++EWAaJOOa+vLo3dL+Elwor9hiJVF5vgfFNp5VFsTHcZ0y7mK+5a8
	93Yji5qC9N8GEucum+kH+PKgQnTvHLpKLwbZZuyBP1ntUg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FpCBlwONxWxa; Thu, 28 Mar 2024 18:14:07 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5BWJ1T3tzlgTHp;
	Thu, 28 Mar 2024 18:14:03 +0000 (UTC)
Message-ID: <a474bae3-e505-4d17-a5e4-ed9928b6cbb3@acm.org>
Date: Thu, 28 Mar 2024 11:14:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/30] block: Do not force full zone append completion
 in req_bio_endio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-2-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> This reverts commit 748dc0b65ec2b4b7b3dbd7befcc4a54fdcac7988.
> 
> Partial zone append completions cannot be supported as there is no
> guarantees that the fragmented data will be written sequentially in the
> same manner as with a full command. Commit 748dc0b65ec2 ("block: fix
> partial zone append completion handling in req_bio_endio()") changed
> req_bio_endio() to always advance a partially failed BIO by its full
> length, but this can lead to incorrect accounting. So revert this
> change and let low level device drivers handle this case by always
> failing completely zone append operations. With this revert, users will
> still see an IO error for a partially completed zone append BIO.
> 
> Fixes: 748dc0b65ec2 ("block: fix partial zone append completion handling in req_bio_endio()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 555ada922cf0..32afb87efbd0 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -770,16 +770,11 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
>   		/*
>   		 * Partial zone append completions cannot be supported as the
>   		 * BIO fragments may end up not being written sequentially.
> -		 * For such case, force the completed nbytes to be equal to
> -		 * the BIO size so that bio_advance() sets the BIO remaining
> -		 * size to 0 and we end up calling bio_endio() before returning.
>   		 */
> -		if (bio->bi_iter.bi_size != nbytes) {
> +		if (bio->bi_iter.bi_size != nbytes)
>   			bio->bi_status = BLK_STS_IOERR;
> -			nbytes = bio->bi_iter.bi_size;
> -		} else {
> +		else
>   			bio->bi_iter.bi_sector = rq->__sector;
> -		}
>   	}
>   
>   	bio_advance(bio, nbytes);

Hi Damien,

This patch looks good to me but shouldn't it be separated from this
patch series? I think that will help this patch to get merged sooner.

Thanks,

Bart.
