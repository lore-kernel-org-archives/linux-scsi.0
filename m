Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56C721FF3F;
	Sat,  8 Nov 2025 01:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762565828; cv=none; b=QGqlwhETtZYCYd5JdsI+PcVu7HMXZ2iWVwR9VFBqcKMBr79AnETo0wtbMsmNDZJ92dfRELrSijfaOoKxYs11QsMFwkeOwnH0U2zvVD3viMFBXR+FGEEXhusq87asiXLKeRIOxpii5N8HLr4ZPN1n7JgkDTE7ML63H5SY6Afck7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762565828; c=relaxed/simple;
	bh=72mVLAxVD5EHRBIMVOq4o8/EIAhIv+TVKp6+oHs4qtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5VIc6JG+PA/vY1EVyDTSl+pAvCVYn9GbRn3bZcc0Tb3CW+3TDI3Xvjz+RC9hbNo3ixVT/EhT2jLTv+1ZhEHUROw5AU4CmDXzNY4OMrN4bX8+byK0wxpQjwf6tiDdKRb9xm5WuSMQFZaZ6fXZJxQgd6Wozi4GYjflc28IDlUYoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/Gx4RG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/Gx4RG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2000C116B1;
	Sat,  8 Nov 2025 01:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762565828;
	bh=72mVLAxVD5EHRBIMVOq4o8/EIAhIv+TVKp6+oHs4qtM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U/Gx4RG27beTG8H75On8fMO8FeNTqI+zKgwnUNBjUwV6SSMqRZgWkhCh7DNJedza1
	 9gnNDoH1aCjguDudefugOoqLrc9nNA2J7Q2RMTcwUWDpO/YalLkHQ42icJ14Nq9CnV
	 RF0iEQzW5lomclcy67K50LbP/pBwSsgO/dg8AvOAOpDeiXDsKLkZc+WwU4UCJPj7v1
	 YJyeKSDdDN8gww8kPNQFiVMnP/WGoOTHdgfzAhK/nb7GH35UmuJ1MyzAnON+ZmpBiw
	 L6fyEsHIRDxuiTzlNgG0Ma6POHasEz5xrB8hdldcrFyT3u/LSF6jHEyZo5vA65yDtE
	 VsSaLil3FvGwg==
Message-ID: <f3d7ceea-2bc1-4006-8df6-006b9d6f1b27@kernel.org>
Date: Sat, 8 Nov 2025 10:37:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v26 10/17] blk-zoned: Document
 disk_zone_wplug_schedule_bio_work() locking
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251107235310.2098676-1-bvanassche@acm.org>
 <20251107235310.2098676-11-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251107235310.2098676-11-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/8/25 08:53, Bart Van Assche wrote:
> Before adding more code in disk_zone_wplug_schedule_bio_work() that depends
> on the zone write plug lock being held, document that all callers hold this
> lock.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

This can go in now, separately from this series.

> ---
>  block/blk-zoned.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index ceb2b432e49e..b55f583cbc86 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -1188,6 +1188,8 @@ void blk_zone_mgmt_bio_endio(struct bio *bio)
>  static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
>  					      struct blk_zone_wplug *zwplug)
>  {
> +	lockdep_assert_held(&zwplug->lock);
> +
>  	/*
>  	 * Take a reference on the zone write plug and schedule the submission
>  	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the


-- 
Damien Le Moal
Western Digital Research
