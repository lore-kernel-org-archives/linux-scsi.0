Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFB927FB25;
	Mon,  1 Dec 2025 06:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764571222; cv=none; b=FlBwEwNwvbgp7KruUAvl05apW174CL+Mo1BuN8V30oA5yRhoILdCjjHFYBfdWkrYh6402op9l8OkVycMB2EEBqKSjkMxAGghiumyYJyH81VbU79pW09mf2F1Fuj5cYrZ0fKOV+8BhjspgLB3mY341Vz5V0IojcAKtq8RV0F5ceY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764571222; c=relaxed/simple;
	bh=1m17AIJ4mIkKXOjFAy0qHMu9bwOezIlKJxBhJBhTY+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vo3OYRPkFet0+UhwIBxJ70LEdMu8zW5pUOIaf2NsjdAWD58CLyFsvXD6OlpUKLR06mBZtCxNHMRh+C3vzngiwXslN5TFRyBSorC4A/SFvVWHwhSYCnsB7BKxt0+cAIOf/fUtzcx5iT/8Z65SMhNqhO0Limx7bzgU7zIETMCXy54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 671FC68BEB; Mon,  1 Dec 2025 07:40:16 +0100 (CET)
Date: Mon, 1 Dec 2025 07:40:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 3/4] block: add IOC_PR_READ_KEYS ioctl
Message-ID: <20251201064016.GC19461@lst.de>
References: <20251127155424.617569-1-stefanha@redhat.com> <20251127155424.617569-4-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127155424.617569-4-stefanha@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 27, 2025 at 10:54:23AM -0500, Stefan Hajnoczi wrote:
> +static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
> +		struct pr_read_keys __user *arg)
> +{
> +	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
> +	struct pr_keys *keys_info __free(kfree) = NULL;

Please avoid the use of the __free mess and write readable and maintainable
code instead.

> +	struct pr_read_keys inout;

Inout is not a very good variable name, as it doesn't really have much
of meaning.  

> +	if (copy_from_user(&inout, arg, sizeof(inout)))
> +		return -EFAULT;
> +
> +	/*
> +	 * 64-bit hosts could handle more keys than 32-bit hosts, but this
> +	 * limit is more than enough in practice.
> +	 */
> +	if (inout.num_keys > (U32_MAX - sizeof(*keys_info)) /
> +	                     sizeof(keys_info->keys[0]))
> +		return -EINVAL;
> +
> +	keys_info_len = struct_size(keys_info, keys, inout.num_keys);

Do the size check on the calculate len here?

> +		return ret;
> +
> +	/* Copy out individual keys */
> +	keys_ptr = u64_to_user_ptr(inout.keys_ptr);
> +	num_copy_keys = min(inout.num_keys, keys_info->num_keys);
> +	keys_copy_len = num_copy_keys * sizeof(keys_info->keys[0]);

num_copy_keys is only used once, so maybe drop it?

