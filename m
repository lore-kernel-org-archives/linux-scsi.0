Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352B91384BF;
	Tue, 19 Nov 2024 07:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732002300; cv=none; b=LgN9+sUzqGTZI5uTbXAN2stSrN5hyr80ZkAGiS3fGOn2tRnKsR5EOKv20FQhIVmlOQXr+7TeBO6bSgKHqrk9/TcAtuNh2oh5ei4Ey/VIzXNj1EMkqtqPlp+trXy8OTF48A5f/SlIxjM2a6BOecq7Gvd2XUcgYczOFwxFYgmDErw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732002300; c=relaxed/simple;
	bh=iGNe3Q+wcKdvH8EIwnKew2LtX/mvNPzigSTnBHiGvtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lTIG22LQfVGFfIc2d4jFP5W4VbPrvW3nm3Iyf7sbVyUY6dwDOk/dLL6XKs87teXqPMAPskGsAgPZhkOnV/QL2lEMMayvVRnlwUsgrWpfPrg47kmF21rw/fHsC5q6wnes6yOUtgd9wK7YJ2sNFHHP91d13RCfkHi1XYa6U7zO0og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byA5pXRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byA5pXRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8094C4CED1;
	Tue, 19 Nov 2024 07:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732002299;
	bh=iGNe3Q+wcKdvH8EIwnKew2LtX/mvNPzigSTnBHiGvtE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=byA5pXRZSLRqtoXv6eDpATAYxN2mODJyygFhH1URdXnhyYvVvKgrrmjm9WzAPlYbv
	 mxC/I04lYIil1kJWmmaDE5Ac8uF3d/LHvowsR50E9BsvS5gyNRsK96N7QjD1OZoruV
	 siHyDkhjMxMJ4jsKO0h+v5y70I+h5ewWALf2SKdqxl8zOsoVIok/OnsXmh1Ld1F3Lf
	 /itfKWnICWNjVt/rfY7D492WFF5MpqVilxZclZCbqnqdUCIDOGXONjcg9l+WSG26k1
	 DsrOVLg/QX/pKK9wmHSVU7G0F4mkMo9mX30z5Ubi6WH8szh1y18WebXI4//YXi4KPe
	 U/KRdEE/c1Mhw==
Message-ID: <a64bf902-7cad-45c0-931f-d92c43533864@kernel.org>
Date: Tue, 19 Nov 2024 16:44:57 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 12/26] block: Rework request allocation in
 blk_mq_submit_bio()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-13-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-13-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:28, Bart Van Assche wrote:
> Prepare for allocating a request from a specific hctx by making
> blk_mq_submit_bio() allocate a request later.
> 
> The performance impact of this patch on the hot path is small: if a
> request is cached, one percpu_ref_get(&q->q_usage_counter) call and one
> percpu_ref_put(&q->q_usage_counter) call are added to the hot path.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

The patch looks OK, but I cannot weight on if this is really a "small" impact on
performance. Jens may want to run his perf setup with this to verify.

-- 
Damien Le Moal
Western Digital Research
