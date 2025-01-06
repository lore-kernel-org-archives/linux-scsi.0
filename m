Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AC012F59C;
	Mon,  6 Jan 2025 10:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736159990; cv=none; b=qZt+AY/CBRnecC/uEhDJktqk+EPO5PPhgG73P90+PnWOlmiURfIbbIQsaoKhbvrz4ji8Ud6LPM1oaKUNVHklln3kbzuPrvxdaizyDeY8QZaJesR8oJaqA5TK27LL4mzsy65ohtNUy+QmRi4UIHPEV7j2fvGDTEsf61P2mpXbQSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736159990; c=relaxed/simple;
	bh=yxjR/msICYPQyNZp7VDsz8GJNakeVo6N3uxmzscuuTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aZ7V0HS/nF1lN3XAUck+DndM7BpX42gAHSwdEBenMkfSEAJemIQAiKjq9UxAsQlNcHRFWyjYtk8BofSJB5xWLdZNnqA6VQBJGq1UPn//arJeno8IUvcVJFDqZ10YYBT7OehBgX6Yd0zjqKVwLuIJutOBzgZYlD8TBIwJK8rtD10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVVmQ8ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVVmQ8ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386FBC4CED2;
	Mon,  6 Jan 2025 10:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736159989;
	bh=yxjR/msICYPQyNZp7VDsz8GJNakeVo6N3uxmzscuuTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UVVmQ8ZK+ThglmGt6ZKcBZ8e3Syi47x1JsCOXZmKrmzeT8NL8LNSml09e4pLj8f0q
	 pHDd+4P6vumMFzMhsTDORIlbRMMJ4rjGHC76Vml3Sk/7tYcG2Vn/vWhAiJXJl5EGmT
	 iyD26odNze8G9REiz4+4dDmA0loqA7KflPCNGYVjESgmfSAO28o9ClZPouZNzagXE5
	 /g46KRsdgZckZ3u0NMMDyFJVMHNIWnwLC73TJUunDcfVDBw0ZMMOYc8KNjO85mCbr1
	 lNDjWjuppATfLW58GzGKlE3+/LYQDLzYckJvXDH1dKkCcJuDAIw1BPoAibDflN/A+1
	 urF5oZuX6khnQ==
Message-ID: <89e35fd6-830c-46b7-a0c3-284bc120d424@kernel.org>
Date: Mon, 6 Jan 2025 19:39:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] block: fix docs for freezing of queue limits
 updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, virtualization@lists.linux.dev,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250106100645.850445-1-hch@lst.de>
 <20250106100645.850445-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250106100645.850445-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 7:06 PM, Christoph Hellwig wrote:
> queue_limits_commit_update is the function that needs to operate on a
> frozen queue, not queue_limits_start_update.  Update the kerneldoc
> comments to reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-settings.c   | 3 ++-
>  include/linux/blkdev.h | 3 +--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 8f09e33f41f6..4187c3e8a07f 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -413,7 +413,8 @@ int blk_set_default_limits(struct queue_limits *lim)
>   * @lim:	limits to apply
>   *
>   * Apply the limits in @lim that were obtained from queue_limits_start_update()
> - * and updated by the caller to @q.
> + * and updated by the caller to @q.  The caller must have frozen the queue or
> + * ensured that there is outstanding I/O by other means.

...ensure that there are no outstanding I/Os by other means.

>   *
>   * Returns 0 if successful, else a negative error code.
>   */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 5d40af2ef971..e781d4e6f92d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -944,8 +944,7 @@ static inline unsigned int blk_boundary_sectors_left(sector_t offset,
>   * the caller can modify.  The caller must call queue_limits_commit_update()
>   * to finish the update.
>   *
> - * Context: process context.  The caller must have frozen the queue or ensured
> - * that there is outstanding I/O by other means.
> + * Context: process context.
>   */
>  static inline struct queue_limits
>  queue_limits_start_update(struct request_queue *q)


-- 
Damien Le Moal
Western Digital Research
