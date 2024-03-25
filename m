Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C731946C;
	Mon, 25 Mar 2024 19:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711395576; cv=none; b=WIqlZehhwva/56LRjQ35r2tgHD2tg8XBk/Ppwckfk8kDH4QnYH8remkWSXKtR0MqHYUYZrp+wOzwP5jeEaiXiFBib4JDLPgtND7uz7IEqZZBL1n487x8FfV8FfEYwqaH0s+OmL0tZu0N4pZRnEyifaclwmsLByfH/j50uvBil9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711395576; c=relaxed/simple;
	bh=IcOW5kKxUwQaOZkIeCcUdo52IxL2CmavyF8jPDipUIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JU4turh0f5eiC44QAMh4LZGZovraguJOMftMOYufWBeBVv+bujvCKIzG9cE0vio0+1esO8pxco10BhshoYz4iDfqC8eXBhPXXcfmh0XCjJRGUdnnVHl2Vx9Biv8LpGVMT1XwB55+4IMb7oNLypgy2AVCSpjU+r7VJqBUanU9Tjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fh35QIW2; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fh35QIW2"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V3NYF4332z6Cnk9T;
	Mon, 25 Mar 2024 19:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711395566; x=1713987567; bh=ONIM4gKc6/2YR/I6xU5AmC9w
	3oIg63fPCPdD0WNgb9o=; b=fh35QIW2D0EUGchkTjkxGleeGI9GUz4E9blsbQR2
	stTmbjXbnLZleaXxlxUMcLZSGvoJJHDAF6GKOIKbCXC7GZ2zBNOrcaVaU0xIB4RO
	gFK/X843n/J3F0qCLA7NiJGssgGaxNlnIvSe9hNKCdNtM6WI/e+qloTvqFoNK6zN
	9+9rNwrj+4d9xrlhOAyHpyUPWTLkYSB+BouA6BM/jt4qJHvkEWuf4y2O8rtT5XsT
	Fqwg7HS1EhVLrwArePQJZIyig0+mf9L87DPba7+2Klq2Yn7hmhhamWOgPDY2k8OW
	2tdKQ8Ix/SEma2nhq1VHIaghppGgKxAxIrqeEy45bc49Eg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id evHBWTi4iquC; Mon, 25 Mar 2024 19:39:26 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V3NY95K0rz6Cnk9N;
	Mon, 25 Mar 2024 19:39:25 +0000 (UTC)
Message-ID: <9025d842-8685-4e64-8c8b-005f4bc25906@acm.org>
Date: Mon, 25 Mar 2024 12:39:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/28] block: Remove req_bio_endio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-3-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> -		if (bio_bytes == bio->bi_iter.bi_size)
> +		if (unlikely(error))
> +			bio->bi_status = error;
> +
> +		if (bio_bytes == bio->bi_iter.bi_size) {

Why no "else" in front of the above if? I think this patch introduces a
behavior change. With the current code, if a zone append operation
fails, bio->bi_status is set to 'error'. With this patch applied, this
becomes BLK_STS_IOERR.

>   			req->bio = bio->bi_next;
> +		} else if (req_op(req) == REQ_OP_ZONE_APPEND) {
> +			/*
> +			 * Partial zone append completions cannot be supported
> +			 * as the BIO fragments may end up not being written
> +			 * sequentially. For such case, force the completed
> +			 * nbytes to be equal to the BIO size so that
> +			 * bio_advance() sets the BIO remaining size to 0 and
> +			 * we end up calling bio_endio() before returning.
> +			 */
> +			bio->bi_status = BLK_STS_IOERR;
> +			bio_bytes = bio->bi_iter.bi_size;
> +		}

Thanks,

Bart.

