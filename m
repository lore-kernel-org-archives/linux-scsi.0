Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0C01A76DE;
	Wed, 17 Dec 2025 03:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765941895; cv=none; b=mKRIfLVGwDjdMLFq+2YG0fnvmlJuBQPteOCBJyhOR74De3u4Tlp6C+fHJiBUX9d4jK2gSLy+8ey20fWilWXil2PMU8lkabg4/R0jmmriN79gmiZySFJKyybWFXP2GsgdIdrqJMoB+YXhvPqmbG81cww68ayY+glpT5Wuyij5KXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765941895; c=relaxed/simple;
	bh=6H2GznpJGdgOdylSgiQsQMpibA8GOh6K4LJtkHKb4WE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WLoSpPFcb+bUGSPQVcXeqLzpjsS21tEx78C4KiCv+9cqMBbFZ2SlBivr5U3QI1zU7NRbACvWy6dAPyxu8avdK7FXG9tUnblwZxs7RBfX1sKic150s3uEENXpHdkLj5lamILRnIv1Y0Wm0qE/yFMmtCB4c2HDDgallYJ/zI4j7Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwVfW8hK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwVfW8hK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DF9C4CEF1;
	Wed, 17 Dec 2025 03:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765941895;
	bh=6H2GznpJGdgOdylSgiQsQMpibA8GOh6K4LJtkHKb4WE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VwVfW8hKwkA7FMU/JdmxR+LkcNOazVuKpTxt+gpUCuhdLKAHo3GWxROob9zb42CZn
	 lXqT2QwRP86aNlpLPJB8XNs3ic3v8jCt9YFIMrSJVHgMhCyPCz/zDP1v6DbstTaT06
	 LgtHFkL8o64uC+nOnWXXeecW/4ZBEsJ4oYSAp4MzeiSqqKK7lK0k+jWtlnuD0qQes/
	 KKDC+IzhKdPwLwxlYK8fGF+KuQKTp5P2dN8Gaje1Qdevz7loVI9knhmGDUtNlMEGKY
	 FSH7LJWWTHnO+5c9No79CkwkYeJHSp+ynr5vIhAvKdjrDwIqy9DFYTu16u61IAMrWG
	 aq7Bj2hBVNjPg==
Message-ID: <ac537693-ec0c-4c50-8ee9-a02975f0e18c@kernel.org>
Date: Wed, 17 Dec 2025 12:24:52 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] scsi: core: Improve IOPS in case of host-wide tags
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251216223052.350366-1-bvanassche@acm.org>
 <20251216223052.350366-7-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251216223052.350366-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/17/25 07:30, Bart Van Assche wrote:
> The SCSI core uses the budget map to restrict the number of commands
> that are in flight per logical unit. That limit check can be left out if
> host->cmd_per_lun >= host->can_queue and if the host tag set is shared
> across all hardware queues or if there is only one hardware queue  Since

Missing a period at the end of the sentence (before Since). But more
importantly, this does not explain why the above is true, and frankly, I do not
see it...

> scsi_mq_get_budget() shows up in all CPU profiles for fast SCSI devices,
> do not allocate a budget map if cmd_per_lun >= can_queue and if the host
> tag set is shared across all hardware queues.
> 
> For the following test this patch increases IOPS by 5%:
> 
> modprobe scsi_debug delay=0 no_rwlock=1 host_max_queue=192 submit_queues=$(nproc)
> 
> fio --bs=4096 --disable_clat=1 --disable_slat=1 --group_reporting=1 \
>   --gtod_reduce=1 --invalidate=1 --ioengine=io_uring --ioscheduler=none \
>   --norandommap --runtime=60 --rw=randread --thread --time_based=1 \
>   --buffered=0 --numjobs=1 --iodepth=192 --iodepth_batch=24 --name=/dev/sda \
>   --filename=/dev/sda
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi.c      |  6 ++----
>  drivers/scsi/scsi_scan.c | 20 +++++++++++++++++++-
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 76cdad063f7b..3dc93dd9fda2 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -216,9 +216,6 @@ int scsi_device_max_queue_depth(struct scsi_device *sdev)
>   */
>  int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>  {
> -	if (!sdev->budget_map.map)
> -		return -EINVAL;
> -
>  	depth = min_t(int, depth, scsi_device_max_queue_depth(sdev));
>  
>  	if (depth > 0) {
> @@ -229,7 +226,8 @@ int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>  	if (sdev->request_queue)
>  		blk_set_queue_depth(sdev->request_queue, depth);
>  
> -	sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
> +	if (sdev->budget_map.map)
> +		sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
>  
>  	return sdev->queue_depth;
>  }
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 7acbfcfc2172..35bfc118e048 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -215,9 +215,19 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
>  			 SCSI_TIMEOUT, 3, NULL);
>  }
>  
> +static bool scsi_needs_budget_map(struct Scsi_Host *shost, unsigned int depth)
> +{
> +	if (shost->needs_budget_token)
> +		return true;
> +	if (shost->host_tagset || shost->tag_set.nr_hw_queues == 1)
> +		return depth < shost->can_queue;
> +	return true;
> +}
> +
>  static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>  					unsigned int depth)
>  {
> +	struct Scsi_Host *shost = sdev->host;
>  	int new_shift = sbitmap_calculate_shift(depth);
>  	bool need_alloc = !sdev->budget_map.map;
>  	bool need_free = false;
> @@ -225,6 +235,13 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>  	int ret;
>  	struct sbitmap sb_backup;
>  
> +	if (!scsi_needs_budget_map(shost, depth)) {
> +		memflags = blk_mq_freeze_queue(sdev->request_queue);
> +		sbitmap_free(&sdev->budget_map);
> +		blk_mq_unfreeze_queue(sdev->request_queue, memflags);
> +		return 0;
> +	}
> +
>  	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));
>  
>  	/*
> @@ -1120,7 +1137,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  	scsi_cdl_check(sdev);
>  
>  	sdev->max_queue_depth = sdev->queue_depth;
> -	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
> +	WARN_ON_ONCE(sdev->budget_map.map &&
> +		     sdev->max_queue_depth > sdev->budget_map.depth);
>  
>  	/*
>  	 * Ok, the device is now all set up, we can


-- 
Damien Le Moal
Western Digital Research
