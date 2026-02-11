Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F272F6574;
	Wed, 11 Feb 2026 08:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770800117; cv=none; b=Mla4DjD6JO0VP5Svlwj7SeBcKk4ncdTPXIP/GQ0GTi6wgycoI1z402zatNutSJfU2zIjS3k8CQwpy7lF9Pw0lrHQsYYkkO3ebTXbYt2yPRKyOYk6zOAf88kq3luIe66OsY2KCEw9lVwZ1y/hmFdiB2qtJCLkkV9EmMmJ7S+C9HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770800117; c=relaxed/simple;
	bh=SRECHDvO140WFtKA/tFIseU6GpR6GBPAjB+p1GDmUUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W7lA6SvS9CJXi1lXBpVnCqukQ9u6Qqo+A+pzPm1hYRD+58D+LKnbsSZ/nt7r2hR30liKo4E1ucRpUZO4l7rE4eoNpsYwyMw44GtT0S7dLKvEDs+BDRUp7zp/k6g9CpFV1gaxtzmVxql8CkAQRMqnylNOeRoNO7EcpXIO3FFZiqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fr0Z7yie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fr0Z7yie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970FBC4CEF7;
	Wed, 11 Feb 2026 08:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770800117;
	bh=SRECHDvO140WFtKA/tFIseU6GpR6GBPAjB+p1GDmUUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fr0Z7yieEv0LIAjum5RT2T8qYxo7Nm8PDKxPN//GKUHV8kQOiG2ZxiivhMIpKCYoZ
	 wcK/BYM6I8xXd7yVqDjfdm7SaWO+NxLxq7XsnTtHZXG0P3OsZJ9WlHZObVwOUGnOqO
	 QcUnUq+q1wjTADkYjVPYtobcFHfQlgIC6TgJTq/9msJEBh1GIn1TtAKKqcFX0bf6YQ
	 XEcLV2iSci7EG5t4ASiqONx6kAIkiJIQd9zYM0PgB66KJqlmudiS0r4iOXOt1i11Hm
	 hqgQhtKapn+OXuHketPIxlUTtgOWthHlksDvdBojyMBOfdH0e9C0sFkNdMlQ1YqLtT
	 4G9w8YnDgD0bA==
Message-ID: <b88f01b8-6f02-402a-90b1-cc5016d1eee3@kernel.org>
Date: Wed, 11 Feb 2026 17:55:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: sd: fix write_same(16/10) to enable sector size
 > PAGE_SIZE
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, pankaj.raghav@linux.dev,
 bvanassche@acm.org, stable@vger.kernel.org,
 Swarna Prabhu <s.prabhu@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>
References: <20260211015043.2608866-1-sw.prabhu6@gmail.com>
 <20260211015043.2608866-2-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260211015043.2608866-2-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/11/26 10:50, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <sw.prabhu6@gmail.com>
> 
> The WRITE SAME(16) and WRITE SAME(10) scsi commands uses
> a page from a dedicated mempool('sd_page_pool') for its
> payload. This pool was initialized to allocate single
> pages, which was sufficient as long as the device sector
> size did not exceed the PAGE_SIZE.
> 
> Given that block layer now supports block size upto
> 64K ie beyond PAGE_SIZE, initialize large page pool in
> 'sd_probe()' if a higher sector device is attached ensuring
> atomicity. Adapt 'sd_set_special_bvec()' to use large page
> pool when a higher sector size device is attached.
> 
> With the above fix, enable sector sizes > PAGE_SIZE in
> scsi sd driver.

This is not a fix (as in a bug fix) but rather a new feature.

> Cc: stable@vger.kernel.org

Why ? Before this patch, scsi allows only up to 4K sector size, which is not >
PAGE_SIZE.

> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/scsi/sd.c | 79 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 67 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f50b92e63201..0e0c5dd1c668 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -112,8 +112,11 @@ static void sd_shutdown(struct device *);
>  static void scsi_disk_release(struct device *cdev);
>  
>  static DEFINE_IDA(sd_index_ida);
> +static DEFINE_MUTEX(sd_mutex_lock);
>  
>  static mempool_t *sd_page_pool;
> +static mempool_t *sd_large_page_pool;
> +static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
>  static struct lock_class_key sd_bio_compl_lkclass;
>  
>  static const char *sd_cache_types[] = {
> @@ -922,14 +925,27 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
>  		(logical_block_size >> SECTOR_SHIFT);
>  }
>  
> -static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
> +static void *sd_set_special_bvec(struct scsi_cmnd *cmd, unsigned int data_len)
>  {
>  	struct page *page;
> +	struct request *rq = scsi_cmd_to_rq(cmd);
> +	struct scsi_device *sdp = cmd->device;
> +	unsigned sector_size = sdp->sector_size;
> +	unsigned int nr_pages = DIV_ROUND_UP(sector_size, PAGE_SIZE);
> +	int n = 0;
>  
> -	page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
> +	if (sector_size > PAGE_SIZE)
> +		page = mempool_alloc(sd_large_page_pool, GFP_ATOMIC);
> +	else
> +		page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
>  	if (!page)
>  		return NULL;
> -	clear_highpage(page);
> +
> +	do {
> +		clear_highpage(page + n);
> +		n++;
> +	} while (n < nr_pages);

A for loop would be a lot cleaner and simpler.

> +
>  	bvec_set_page(&rq->special_vec, page, data_len, 0);
>  	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
>  	return bvec_virt(&rq->special_vec);
> @@ -945,7 +961,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
>  	unsigned int data_len = 24;
>  	char *buf;
>  
> -	buf = sd_set_special_bvec(rq, data_len);
> +	buf = sd_set_special_bvec(cmd, data_len);
>  	if (!buf)
>  		return BLK_STS_RESOURCE;
>  
> @@ -1034,7 +1050,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
>  	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
>  	u32 data_len = sdp->sector_size;
>  
> -	if (!sd_set_special_bvec(rq, data_len))
> +	if (!sd_set_special_bvec(cmd, data_len))
>  		return BLK_STS_RESOURCE;
>  
>  	cmd->cmd_len = 16;
> @@ -1061,7 +1077,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
>  	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
>  	u32 data_len = sdp->sector_size;
>  
> -	if (!sd_set_special_bvec(rq, data_len))
> +	if (!sd_set_special_bvec(cmd, data_len))
>  		return BLK_STS_RESOURCE;
>  
>  	cmd->cmd_len = 10;
> @@ -1507,9 +1523,15 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
>  static void sd_uninit_command(struct scsi_cmnd *SCpnt)
>  {
>  	struct request *rq = scsi_cmd_to_rq(SCpnt);
> +	struct scsi_device *sdp = SCpnt->device;
> +	unsigned sector_size = sdp->sector_size;
>  
> -	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
> -		mempool_free(rq->special_vec.bv_page, sd_page_pool);
> +	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD) {
> +		if (sector_size > PAGE_SIZE)
> +			mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
> +		else
> +			mempool_free(rq->special_vec.bv_page, sd_page_pool);
> +	}
>  }
>  
>  static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
> @@ -2920,10 +2942,7 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
>  			  "assuming 512.\n");
>  	}
>  
> -	if (sector_size != 512 &&
> -	    sector_size != 1024 &&
> -	    sector_size != 2048 &&
> -	    sector_size != 4096) {
> +	if (blk_validate_block_size(sector_size)) {
>  		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
>  			  sector_size);
>  		/*
> @@ -4044,6 +4063,21 @@ static int sd_probe(struct device *dev)
>  	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
>  
>  	sd_revalidate_disk(gd);
> +	if (sdp->sector_size > PAGE_SIZE) {
> +		mutex_lock(&sd_mutex_lock);
> +		if (!sd_large_page_pool) {
> +			sd_large_page_pool = mempool_create_page_pool(
> +					SD_MEMPOOL_SIZE, get_order(BLK_MAX_BLOCK_SIZE));
> +			if (!sd_large_page_pool) {
> +				printk(KERN_ERR "sd: can't create large page mempool\n");
> +				error = -ENOMEM;
> +				mutex_unlock(&sd_mutex_lock);
> +				goto out_free_index;
> +			}
> +		}
> +		atomic_inc(&sd_large_page_pool_users);
> +		mutex_unlock(&sd_mutex_lock);
> +	}

It would be a lot nicer to have this defined as a helper function that goes
together with a pool destroy function (see below).

>  
>  	if (sdp->removable) {
>  		gd->flags |= GENHD_FL_REMOVABLE;
> @@ -4061,6 +4095,14 @@ static int sd_probe(struct device *dev)
>  	if (error) {
>  		device_unregister(&sdkp->disk_dev);
>  		put_disk(gd);
> +		if (sdp->sector_size > PAGE_SIZE) {
> +			mutex_lock(&sd_mutex_lock);
> +			if (atomic_dec_and_test(&sd_large_page_pool_users)) {
> +				mempool_destroy(sd_large_page_pool);
> +				sd_large_page_pool = NULL;
> +			}
> +			mutex_unlock(&sd_mutex_lock);
> +		}

This hunk is repeated twice. Make this a helper please.

>  		goto out;
>  	}
>  
> @@ -4101,6 +4143,7 @@ static int sd_probe(struct device *dev)
>  static int sd_remove(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	struct scsi_device *sdp = sdkp->device;
>  
>  	scsi_autopm_get_device(sdkp->device);
>  
> @@ -4110,6 +4153,16 @@ static int sd_remove(struct device *dev)
>  		sd_shutdown(dev);
>  
>  	put_disk(sdkp->disk);
> +
> +	if (sdp->sector_size > PAGE_SIZE) {
> +		mutex_lock(&sd_mutex_lock);
> +		if (atomic_dec_and_test(&sd_large_page_pool_users)) {
> +			mempool_destroy(sd_large_page_pool);
> +			sd_large_page_pool = NULL;
> +		}
> +		mutex_unlock(&sd_mutex_lock);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -4446,6 +4499,8 @@ static void __exit exit_sd(void)
>  
>  	scsi_unregister_driver(&sd_template.gendrv);
>  	mempool_destroy(sd_page_pool);
> +	if (sd_large_page_pool)
> +		mempool_destroy(sd_large_page_pool);
>  
>  	class_unregister(&sd_disk_class);
>  


-- 
Damien Le Moal
Western Digital Research
