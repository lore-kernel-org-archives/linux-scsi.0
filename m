Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B80B1DACBE;
	Mon,  6 Jan 2025 10:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161025; cv=none; b=BcW3c1uNgYcamKdF90L4sUqG56t/3VhgGVWnHDJEfqXnJJ0+NldIMcsgz8GOaVb4+nY0BgwNoy36genxefWw/5wgY4Dj/fIZvZnYZ3mqYO5S1zxlyfnZ0zJW+QrpXcbaYEecapdtm8bIqykFekv1MhSQQOa2Z0G8hElAuGK/CCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161025; c=relaxed/simple;
	bh=SkMUfmNVGEp3GjfSVk+aiLBPqi5Z67vJEkjjxoSltas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PMpktaaQmoO1yhnpZA9TiFiXSwCV9jxWljuEmifV3jfYtGlbZsX8MutcSPt/bJoyulCJnKxjpt5ODkGeUOBe9/0uir6mV5zpc35VHG/D5Ed20+K5jnFWENHU8W4rgsa1VVAqrVbfBXUe2a97mE1otzURnx3txk9N0OMsjoMS6KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cISyFrpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cISyFrpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0C0C4CED2;
	Mon,  6 Jan 2025 10:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736161025;
	bh=SkMUfmNVGEp3GjfSVk+aiLBPqi5Z67vJEkjjxoSltas=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cISyFrpkYGIZ0xA4St+nzsQX5WDm6sxgzc+wrYGzjNRhxzimHSKnXZq7QclrbhXwE
	 FMuSeYPq4VMNFQ7rTnYN6sVKskXxXNMPEnDz+MWEroT8P7g2ErJMDekoSvkpc3nFXZ
	 5PK4udGG6H0GLESXC7yq3otBOs9IpW6aeFQWgQAQMnCAXlDMMHHPCr4YEmtkfIa3ZQ
	 /JXAGWghe1vOf1WEhdk5RBuC3C3B5g9gRyotBgWfX7BgMVx0iOJ2LO3M/msXmkddpO
	 RFIJ2fj2GpwyrNB+AYk5NpAAB30BYxbFalF0knbSvf+R1QEifx+9XfEabAUwbtQQIY
	 9K9KfWRS8gdGQ==
Message-ID: <07353499-b62d-488a-9575-12de5d9b6f2e@kernel.org>
Date: Mon, 6 Jan 2025 19:56:19 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] virtio_blk: use queue_limits_commit_update_frozen
 in cache_type_store
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, virtualization@lists.linux.dev,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250106100645.850445-1-hch@lst.de>
 <20250106100645.850445-7-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250106100645.850445-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 7:06 PM, Christoph Hellwig wrote:
> So far cache_type_store didn't freeze the queue, fix that by using the
> queue_limits_commit_update_frozen helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This should be squashed in patch 2, no ?

> ---
>  drivers/block/virtio_blk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 0a987f195630..bbaa26b523b8 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -1105,7 +1105,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
>  		lim.features |= BLK_FEAT_WRITE_CACHE;
>  	else
>  		lim.features &= ~BLK_FEAT_WRITE_CACHE;
> -	i = queue_limits_commit_update(disk->queue, &lim);
> +	i = queue_limits_commit_update_frozen(disk->queue, &lim);
>  	if (i)
>  		return i;
>  	return count;


-- 
Damien Le Moal
Western Digital Research
