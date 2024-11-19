Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA541514DC;
	Tue, 19 Nov 2024 07:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732002049; cv=none; b=tDbdz4KSVyYY3KZx9WjMV0H7yv7qQ5lbFrzHF0AQ6/1f+03nSakMSyRBFkAytpL0Id3XXE6PE4H/i+Lz/snMy+hCo2CtzFra434/bbaWe/43exzYKeY/+SKqokK7BQgk4VRQmaxsBY0fs+LE/fie4yCxs697IIE5XR9Sw067ROs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732002049; c=relaxed/simple;
	bh=+fi1GzmWgsYUM24+hhHWpqLQGK3l45iFa7mfvc8LyeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RlO4h542nFGFlUDUM1I21exLbmsiFZoUuC2UjSkIYlUOBRkqkTxVxYm2MB/7yOatP1y9zILY5XmNeNiMWpA6Yp4PY1iw/Attr98btSBWW53muHky9ely580TnRDemqHlnLXJ638dXuwUEC63QDZWHWbjZwUNIh9MLqVB0+ABQGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=So5M+5pj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="So5M+5pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9E1C4CED1;
	Tue, 19 Nov 2024 07:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732002049;
	bh=+fi1GzmWgsYUM24+hhHWpqLQGK3l45iFa7mfvc8LyeA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=So5M+5pjxhrrat+GAI7wFdozURVcOSxieGhGjBsf/NBmJiKXZuiBoA79bQI5AeoCk
	 7rfTq/SLNXOHP8tN2TzKhhUQrW9TyQGGo18ZYew4gxPLXSBFU2dLnZEbhkdWXrXINQ
	 mJQDJeg0/ovsDHlxMl4rgmrfaes77OVfhSEy92A1WHMbKDuL3R0EzLBMBesA0L+lZY
	 857G03fawO4Iu4VLmRicXDrr3fi0sL1ctmvxvFK+Kz2GSN60n36rpdOxdE0SsvNI0G
	 pvfeWHhkhLLmH1hf2+Em5ucacHSNd4CP+jf+KLGOvZZrut/szD5zKywiOiqcZls8ov
	 hp6evq9svgbNA==
Message-ID: <8bf2087a-a903-4339-a7af-3f3f23e3d4d5@kernel.org>
Date: Tue, 19 Nov 2024 16:40:47 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 11/26] block: Optimize blk_mq_submit_bio() for the
 cache hit scenario
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-12-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-12-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:28, Bart Van Assche wrote:
> Help the CPU branch predictor in case of a cache hit by handling the cache
> hit scenario first.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Not sure this really helps but looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
