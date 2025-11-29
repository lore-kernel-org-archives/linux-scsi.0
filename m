Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9A2262FC1;
	Sat, 29 Nov 2025 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764426717; cv=none; b=qApaM9Ow9o/FnFsJQS8FvGKytewRmmKtUd1I919DFWdVRakXV1P5UJZDc+1d6PY8gQl+hLHo6Ymi69Ww0tkbweUa5jvYIXR18GGLHeKwYOkB7Dg+VzavUnjBHCl+QfxW2hYhbyoQQPf/BnHs7ksaHkUD14X9edW9XYjApSfWoTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764426717; c=relaxed/simple;
	bh=b9WvgFAubhzEgsS0DvAfHxvKsNmcEmEcmJNVo2OtCOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DvfLfVvzMh0SzyJKlW7710dzIdBo4qfrVKxUjdKM+FK74s4H6kLYwBHDMvwVd+JOFHwj5XZhpG1cUx2iYAOKVrrK49kRD+QnnZCDVPKlaXxZDQFCVscRxGVjWrqsMPiAHNzmHBnIAmH0hmQmLM12K0QmxPOS23Y1cb8S8TJkQno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZQd7Dh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZQd7Dh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30437C4CEF7;
	Sat, 29 Nov 2025 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764426716;
	bh=b9WvgFAubhzEgsS0DvAfHxvKsNmcEmEcmJNVo2OtCOw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BZQd7Dh8bF2OS6cYEGrhzmxXIcbNiT8gpCTAcLhVIAbfZeCtUTciycL5zPRZmot14
	 0A0baN2tUIbod/XxTzjPDvGpHLxhEUmPu1e2rLwLhpezv8Qo0CIQER+bOwfuO7jZiX
	 PUJraJXZRLUDp47BHEfBWQtSTja8GI7j/KFz5SUQhPSECKUCJUgfBILMCUrQhZc4zk
	 tEqn60v7NRbmTPwQrfq6T2C14zDLcONAfm6awFySOCrsfMiUryOL/x1G+Y5gziZjUT
	 HErr2i1GjGHk5EnaQueBh1rADNmVILMtIbcoEjUTOtDoOPXYWxLE+rtfAUrRmzZUa8
	 dMB1WBjsvCvZA==
Message-ID: <84343571-2b89-4fa1-8b52-5b6ff1d33e88@kernel.org>
Date: Sat, 29 Nov 2025 15:31:52 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: add IOC_PR_READ_KEYS ioctl
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Mike Christie <michael.christie@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251126163600.583036-1-stefanha@redhat.com>
 <20251126163600.583036-4-stefanha@redhat.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20251126163600.583036-4-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/11/2025 17:35, Stefan Hajnoczi wrote:
> +
>  #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
>  
>  #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
> @@ -64,5 +70,6 @@ struct pr_clear {
>  #define IOC_PR_PREEMPT		_IOW('p', 203, struct pr_preempt)
>  #define IOC_PR_PREEMPT_ABORT	_IOW('p', 204, struct pr_preempt)
>  #define IOC_PR_CLEAR		_IOW('p', 205, struct pr_clear)
> +#define IOC_PR_READ_KEYS	_IOWR('p', 206, struct pr_read_keys)
>  
>  #endif /* _UAPI_PR_H */
> diff --git a/block/ioctl.c b/block/ioctl.c
> index d7489a56b33c3..e87c424c15ae9 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/capability.h>
> +#include <linux/cleanup.h>
>  #include <linux/compat.h>
>  #include <linux/blkdev.h>
>  #include <linux/export.h>
> @@ -423,6 +424,54 @@ static int blkdev_pr_clear(struct block_device *bdev, blk_mode_t mode,
>  	return ops->pr_clear(bdev, c.key);
>  }
>  
> +static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
> +		struct pr_read_keys __user *arg)
> +{
> +	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
> +	struct pr_keys *keys_info __free(kfree) = NULL;


This is an undesired syntax explicitly documented as one to avoid. You
need here proper assignment, not NULL. Please don't use cleanup.h if you
do not intend to follow it because it does not make the code simpler.



Best regards,
Krzysztof
