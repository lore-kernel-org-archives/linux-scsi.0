Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57443148AD;
	Wed, 15 Oct 2025 07:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760513155; cv=none; b=bPLIwCOTRDm7cbyFC+fMaUpHWrHKTvXtyPEEnKBvmFBTYtfcIcN6XrP/Uk1Uo6mb/JQc0smRHD1HX7kivliDlV2W6gvLnJVMsTiycrCwWAyZKaFblZGdqTcDLp7/Q0bpG9GmYgL7dzjbnM5Atuqt1vQndLOli6F6I8UNw7UsYzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760513155; c=relaxed/simple;
	bh=9SN27HepAKD9IdeWSnnll6V9jDS7tjS+jDxtPqyRdOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CX8ZnrLwxnA8e7jw26bMrGIioLXQeabeW5W/uvvl8lrlSuyH+7o5GPWfvD7c//WRHblopd3orDPdIg5kP+9GOli0nV0uGcSMfQU1U2/PyMGXt5IMr4bB8/ulNGTmPUfpIzzvKq5GEUk26Q/xLOLrjG9hGkdjqma95JqFIiDVUak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cz5mlpOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cz5mlpOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9603EC4CEF8;
	Wed, 15 Oct 2025 07:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760513155;
	bh=9SN27HepAKD9IdeWSnnll6V9jDS7tjS+jDxtPqyRdOU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cz5mlpOtjpQLIZDaOr2GJij59u+wE0Q1FNXPZfaO0Nns4B3d9djIVOb9GIvgZId5f
	 ay6vPv2fBtPVxCekP6GerCmMSGyeQ+9hitzS22duCICu/l4ev9nBa8VVjXuZebbmw8
	 m0YQvzU9YHdpqY2B+Qhht2tO4Z+U/b3MdiqYOG6bFJREbd/fwppzp9KorJMPeQfDSr
	 M8F82P49LW6O+FHI+8KwZYjSIyw+4sfXXnH91ovWnvvXB5JFZpcTz41qpH37yznCjl
	 SO26KyJmFrcY/yDOe2wbGo5eGXWCRgKlUEgxc/nHDh2cHqFnRAALATZzWp1a/i1np8
	 xQd7H+3GbVUGQ==
Message-ID: <9c8923cb-2c1b-4d04-b1ba-796472ce8c53@kernel.org>
Date: Wed, 15 Oct 2025 16:25:53 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 05/20] blk-mq: Run all hwqs for sq scheds if write
 pipelining is enabled
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-6-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251014215428.3686084-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/10/15 6:54, Bart Van Assche wrote:
> One of the optimizations in the block layer is that blk_mq_run_hw_queues()
> only calls blk_mq_run_hw_queue() for a single hardware queue for single
> queue I/O schedulers. Since this optimization may cause I/O reordering,
> disable this optimization if ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING
> has been set. This patch prepares for adding write pipelining support in
> the mq-deadline I/O scheduler.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-mq.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 81952d0ae544..5f07483960f8 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2401,8 +2401,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
>  EXPORT_SYMBOL(blk_mq_run_hw_queue);
>  
>  /*
> - * Return prefered queue to dispatch from (if any) for non-mq aware IO
> - * scheduler.
> + * Return preferred queue to dispatch from for single-queue IO schedulers.
>   */
>  static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
>  {
> @@ -2412,6 +2411,11 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
>  	if (!blk_queue_sq_sched(q))
>  		return NULL;
>  
> +	if (blk_queue_is_zoned(q) && blk_pipeline_zwr(q) &&
> +	    test_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING,
> +		     &q->elevator->flags))

The above test_bit() is already done in blk_pipeline_zwr().
> +		return NULL;
> +
>  	ctx = blk_mq_get_ctx(q);
>  	/*
>  	 * If the IO scheduler does not respect hardware queues when


-- 
Damien Le Moal
Western Digital Research
