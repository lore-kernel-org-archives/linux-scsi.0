Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCC54437;
	Mon,  6 Jan 2025 10:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736160541; cv=none; b=gJgj0z51F2qN1H8xilasb9Av9r8MQ+dK6KYPm4TBhhmeuUHV4MmiKWSbJziLz/WDBLd0RHED7nID3jYrVrV9PNNYvngrZV2ffoAZOw08jH8d9YFPEL8iBGE3PV5ySWHlTK9Gqi75jUI9c6u1oKCgbMUMRa8Me8DIrsANV1zjFqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736160541; c=relaxed/simple;
	bh=rHrPFkcMDrKJSX1xGQ4HM/tkZ2yYSiqYA/+NEKz7qyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cg5Xghb2rejubg7mXmfQJYbeW1GfRfegI/vLAe1J9HpLpP3m/5fTwoaBc+CDmQCAxwmu9msDNG/7OKZa211A9VHmx62PK85z3H0wcBldU5egjpp8xsv/AJ0wLCG8ZsEm7B2tFtlHjpGvZvcA0jdAue2LU7iZiRFot+FTAQQOrkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXFO8k8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXFO8k8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC793C4CED2;
	Mon,  6 Jan 2025 10:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736160541;
	bh=rHrPFkcMDrKJSX1xGQ4HM/tkZ2yYSiqYA/+NEKz7qyo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pXFO8k8sCJfIXYk7LOUU+Dw+pR+yMrkhiW9riaNycbKdwZh53hG3nMH9f1xJ0XDED
	 ZhYHpJxmNfzNNVtDbc/HcF7q15uFl0V78mT6nvYfRmVhMg+hP5GynxKZrHYy4bcVsD
	 8esHUCvdTxSGIqJvNhuxZ6kB1fPwtpOgs2UMN+mvZu8v5+1Nk7K7YAIw4HwwYrkG0c
	 8ujCJDaahyrvbNN+31z53KqzYWCeiVwJ+RLrzySD3ROFIYRf2EJi2avidGqjjTi9g6
	 6w4u0oGNcGup7r1x5dJZOlmEBtZpn2A7qu4sy0fT507ztw6D9Gz2AE7JH1K6GnPP2n
	 UVrjxgt1PgHDg==
Message-ID: <ddc8d362-2cfe-4267-a900-7ea419b15b01@kernel.org>
Date: Mon, 6 Jan 2025 19:48:15 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] block: use queue_limits_commit_update in
 queue_attr_store
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, virtualization@lists.linux.dev,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250106100645.850445-1-hch@lst.de>
 <20250106100645.850445-5-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250106100645.850445-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 7:06 PM, Christoph Hellwig wrote:
> Use queue_limits_commit_update to apply a consistent freeze vs limits
> lock order in queue_attr_store.  Also remove taking the sysfs lock
> as it doesn't protect anything here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Oops. OK. so please disregard my comments on patch 3. This is all fixed here.
May be sqash this patch with patch 3 ?

> ---
>  block/blk-sysfs.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 8d69315e986d..3bac27fcd635 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -687,22 +687,24 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
>  	if (entry->load_module)
>  		entry->load_module(disk, page, length);
>  
> -	mutex_lock(&q->sysfs_lock);
> -	blk_mq_freeze_queue(q);
>  	if (entry->store_limit) {
>  		struct queue_limits lim = queue_limits_start_update(q);
>  
>  		res = entry->store_limit(disk, page, length, &lim);
>  		if (res < 0) {
>  			queue_limits_cancel_update(q);
> -		} else {
> -			res = queue_limits_commit_update(q, &lim);
> -			if (!res)
> -				res = length;
> +			return res;
>  		}
> -	} else {
> -		res = entry->store(disk, page, length);
> +
> +		res = queue_limits_commit_update_frozen(q, &lim);
> +		if (res)
> +			return res;
> +		return length;
>  	}
> +
> +	mutex_lock(&q->sysfs_lock);
> +	blk_mq_freeze_queue(q);
> +	res = entry->store(disk, page, length);
>  	blk_mq_unfreeze_queue(q);
>  	mutex_unlock(&q->sysfs_lock);
>  	return res;


-- 
Damien Le Moal
Western Digital Research
