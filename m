Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996FC217442;
	Tue, 12 Nov 2024 18:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731436191; cv=none; b=twDpNu8wpcEMfH1HCOS1Zd9YAxOGKCImBsP6iCdpp/T6KjrJYwjTmkHrKK1aW2KEPKt4CLaxpl0yloCgtrxd2Sp4AUYoXqZ1DktNxbJy0attmdfpvreAHbTxgfGz/PcCoSfyUkFiMcd6QXpfR/3XXWDR1MSRRDz+1m9iC79fPDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731436191; c=relaxed/simple;
	bh=W7DJhPC2cI4B1hls9mrVYtcxp53BRxGE+EAAK8hoUwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4G8ZAu4Qn7TbNEicTzF1zZyBetbsTYMeUoloxMlcFEKnEtry4lnFA42EG6gXnVYTtJwD7mlBVVSomtKclUhPImMgsPwOUBwWhdCRrllj7OpzrKzzeDEsedb8jNmECbsow9v6qd71+Ynnv5jx2xGJgQmd510paBufTS0pXLgsgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zKLfz999; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zKLfz999"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xnw1g0ttMz6Cp2tZ;
	Tue, 12 Nov 2024 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731436180; x=1734028181; bh=oPBj+L8mtHTtVAb4BNIxLmXH
	B/1C8no7WxMT/ljz+Wc=; b=zKLfz999pjxdgJbaeWGIeI0ouu+PGa/XktxIGznD
	BxCOFVw2Dla+T2Nht+ldbL4QK+ysaqgqNPFDeKolXfalJadVup12/aUWnSMA/N65
	2DZ8/SRWsCIiZz1LisfR8l4wI1+6tEeOr4Mm7keqi9au9Dfd8BNzddaMjXAZqbnp
	cMg8UXVAuSL4KKNKhItSbWKx/i8+nCyUXK1SkDxuPrnwjhWwovvRB+feHD67E2m6
	89wiYey9uavqhEESgEVzwHtzGwM7Gwa49DY/tPWVbH9mIim0C3aVp+IKpVEjcNfm
	8eRBT50T6Evp/W+0ywC1Zmf5DxN1gwcMoNFfq1UTQkYhfg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TvZPjWSXIV_9; Tue, 12 Nov 2024 18:29:40 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xnw1Z4ZRTz6ClbFZ;
	Tue, 12 Nov 2024 18:29:38 +0000 (UTC)
Message-ID: <aa3b1983-d166-451f-899f-74d6f75687ed@acm.org>
Date: Tue, 12 Nov 2024 10:29:35 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] block: remove the write_hint field from struct
 request
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20241112170050.1612998-1-hch@lst.de>
 <20241112170050.1612998-2-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241112170050.1612998-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 9:00 AM, Christoph Hellwig wrote:
> -	/* Don't merge requests with different write hints. */
> -	if (req->write_hint != next->write_hint)
> -		return NULL;
> +	if (req->bio && next->bio) {
> +		/* Don't merge requests with different write hints. */
> +		if (req->bio->bi_write_hint != next->bio->bi_write_hint)
> +			return NULL;
> +	}

The above two if-statements can be combined into a single if-statement.

> @@ -1001,9 +1003,11 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
>   	if (!bio_crypt_rq_ctx_compatible(rq, bio))
>   		return false;
>   
> -	/* Don't merge requests with different write hints. */
> -	if (rq->write_hint != bio->bi_write_hint)
> -		return false;
> +	if (rq->bio) {
> +		/* Don't merge requests with different write hints. */
> +		if (rq->bio->bi_write_hint != bio->bi_write_hint)
> +			return false;
> +	}

Same comment here: the above two if-statements can also be combined into 
a single if-statement.

Otherwise this patch looks good to me.

Thanks,

Bart.
