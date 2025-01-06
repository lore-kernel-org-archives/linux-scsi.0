Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66C8126BF9;
	Mon,  6 Jan 2025 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736160426; cv=none; b=kYO6BZlDPDqgiHlGajfT6J04AatRI+R5U1Qy2BzI0TtXqmaAK+x0Eof+66pfc4HxfCQpAF4x7DqIZH8ZdxG5KAn3msQPC1fm3uVgxORY6uWovv0ZMZS/8K3IOgu8XzPr/x3Gwxv+D8IieGLg5JpoC10uk1DTx9T5O35yqXDSvSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736160426; c=relaxed/simple;
	bh=wej234ibZ1R8OLTpkTc9rxS5V8U0eLOGtXxAG8f0G9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JCyA0BtXaG/X1epDNvuOpfjB4VsIddbmVxqEN84flL6IYPdefvvOhPElgK7FpB1cfff6oyLe0Fji35O+DGjEC+n3yjllJBV+StpLn4VxkDGk+7kfD6vqUxUFVjzdl723h7IsKXkDIlJwhK9rJoj/+EhlQFx6FGFbBv6hBkk+zqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtMzyfuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtMzyfuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D402C4CEDD;
	Mon,  6 Jan 2025 10:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736160425;
	bh=wej234ibZ1R8OLTpkTc9rxS5V8U0eLOGtXxAG8f0G9Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QtMzyfuDr2WNgnvsHFz2I+5Ou4y6rqsWJjZ/PHVKqnL013v7PDKnnIUaTpUxxBneH
	 bb6oZLKYhNfPUaCgUIofZ+nJZAKLILSD41nmIXtic/DvtGzLHz5cIBWRcYtKermD8J
	 ZzjiokHMuU2Q7TTVFQmG9aOuuzCC5Vp8ePniWkR3PwEpBHGNPZi+r48oP0x7LOQAxK
	 2S4KCGRdrNmKdImmai72QHvLxq+PQah2S8cMd4tXmZWJ72b0Sgq3yR1wj4EB8Vf32P
	 Bo+ibYFAdtZVy7+36citiVsHaS1FduSGAwv+aZk06ZWiyGRuvIdEE9tExdorHxco5s
	 qEUq74Bc6OqpQ==
Message-ID: <a461bbbc-f251-4f44-89c7-f80f72e6e96d@kernel.org>
Date: Mon, 6 Jan 2025 19:46:19 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] block: add a store_limit operations for sysfs
 entries
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, virtualization@lists.linux.dev,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250106100645.850445-1-hch@lst.de>
 <20250106100645.850445-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250106100645.850445-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 7:06 PM, Christoph Hellwig wrote:
> De-duplicate the code for updating queue limits by adding a store_limit
> method that allows having common code handle the actual queue limits
> update.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

[...]

> @@ -706,11 +687,24 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
>  	if (entry->load_module)
>  		entry->load_module(disk, page, length);
>  
> -	blk_mq_freeze_queue(q);
>  	mutex_lock(&q->sysfs_lock);
> -	res = entry->store(disk, page, length);
> -	mutex_unlock(&q->sysfs_lock);
> +	blk_mq_freeze_queue(q);

The freeze must NOT be done for the "if (entry->store_limit)" case. So this
needs to go int the "else". Otherwise, you still have freeze the take limit
lock order which can cause the ABBA deadlocks in SCSI sd.

> +	if (entry->store_limit) {
> +		struct queue_limits lim = queue_limits_start_update(q);
> +
> +		res = entry->store_limit(disk, page, length, &lim);
> +		if (res < 0) {
> +			queue_limits_cancel_update(q);
> +		} else {
> +			res = queue_limits_commit_update(q, &lim);

Here you must use queue_limits_commit_update_frozen().

> +			if (!res)
> +				res = length;
> +		}
> +	} else {
> +		res = entry->store(disk, page, length);
> +	}
>  	blk_mq_unfreeze_queue(q);

And this one needs to go in the else after the call to entry->store().

> +	mutex_unlock(&q->sysfs_lock);
>  	return res;
>  }
>  


-- 
Damien Le Moal
Western Digital Research
