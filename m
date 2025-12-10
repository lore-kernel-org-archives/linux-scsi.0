Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71521C6B4;
	Wed, 10 Dec 2025 01:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331554; cv=none; b=U+mK6AkHyn5zU178pkslBB7oOMGnlU32M4SyfK1j0hTSjblrNSIp2XGktAG3gggZ1ZGacJKtowL4kIEq9nvNFE9Y2MPNYBTNkcT136I7gRvCEJjz0a5sXhC9GyNLGko7drcFpxR/Nn09d4YFqKcXU6jdueqT3DYS6mOevE0DhgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331554; c=relaxed/simple;
	bh=AgJe5J0QJDmJlbF7iup5O79NcgLId5mfje5CT+C/ZMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VzA5d9Cuav+huNA8045yoSVd0xOuLosSXZsyq7mYjy9BStiFNyCe/rVRfVpeUqzPdgLNnsC3QQ4eM89Dz+jLAKrx8hA2G98zHGkFyuU1W6IoM8CUtOx8HxHf7oZszjpp+mYKfeGBhfeclqhnxIeni9u4VhyILhxwsIZpYHzd4Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msmCws/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msmCws/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8A8C4CEF5;
	Wed, 10 Dec 2025 01:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765331553;
	bh=AgJe5J0QJDmJlbF7iup5O79NcgLId5mfje5CT+C/ZMg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=msmCws/qdAQneeQA18DN78cwmSX/XedgeZS2BtkRoEOd7Um5sHhuwbuV568HxC6p9
	 AGiWVc3x1V5wSBWovLgbyKFGrt4p5XJon1aEduZe+8JDCMtuMqyxo4OYZD4ftZsy0l
	 bRva6upg/pZIVcbDDic9Hgw3GV7brTUnSdjlOEKw5kFkoI13pPQQ3c4kYOV+6U1gkc
	 hNJzbtLISmsanwf5hmtTImgrz23XpqVOtKXFCcFzNW/mUiAfl8M5d7NlFSSHfYJ9UM
	 etqM6lAXGBLZaSz2MFz9B2JkdwMVqNNfQ1LcTK/xN9Mkud4Q3vO4dUjFu1IVBV37+/
	 FtClnkdn49CVw==
Message-ID: <0b3458ab-e419-4ec2-9cba-eb9fd2cd8de9@kernel.org>
Date: Tue, 9 Dec 2025 17:52:33 -0800
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
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org,
 kernel@pankajraghav.com, stable@vger.kernel.org,
 Swarna Prabhu <s.prabhu@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>
References: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
 <20251210014136.2549405-3-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251210014136.2549405-3-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/12/09 17:41, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <sw.prabhu6@gmail.com>
> 
> The WRITE SAME(16) and WRITE SAME(10) scsi commands uses
> a page from a dedicated mempool('sd_page_pool') for its
> payload. This pool was initialized to allocate single
> pages, which was sufficient as long as the device sector
> size did not exceed the PAGE_SIZE.
> 
> Given that block layer now supports block size upto
> 64K ie beyond PAGE_SIZE, adapt sd_set_special_bvec()
> to accommodate that.
> 
> With the above fix, enable sector sizes > PAGE_SIZE in
> scsi sd driver.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
> Note: We are allocating pages of order aligned to 
> BLK_MAX_BLOCK_SIZE for the mempool page allocator
> 'sd_page_pool' all the time. This is because we only
> know that a bigger sector size device is attached at
> sd_probe and it might be too late to reallocate mempool
> with order >0.

That is a lot heavier on the memory for the vast majority of devices which are
512B or 4K block size... It may be better to have the special "large block"
mempool attached to the scsi disk struct and keep the default single page
mempool for all other regular devices.

> 
>  drivers/scsi/sd.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 0252d3f6bed1..17b5c1589eb2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -892,14 +892,24 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
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
>  	page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
>  	if (!page)
>  		return NULL;
> -	clear_highpage(page);
> +
> +	do {
> +		clear_highpage(page + n);
> +		n++;
> +	} while (n < nr_pages);
> +
>  	bvec_set_page(&rq->special_vec, page, data_len, 0);
>  	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
>  	return bvec_virt(&rq->special_vec);
> @@ -915,7 +925,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
>  	unsigned int data_len = 24;
>  	char *buf;
>  
> -	buf = sd_set_special_bvec(rq, data_len);
> +	buf = sd_set_special_bvec(cmd, data_len);
>  	if (!buf)
>  		return BLK_STS_RESOURCE;
>  
> @@ -1004,7 +1014,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
>  	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
>  	u32 data_len = sdp->sector_size;
>  
> -	if (!sd_set_special_bvec(rq, data_len))
> +	if (!sd_set_special_bvec(cmd, data_len))
>  		return BLK_STS_RESOURCE;
>  
>  	cmd->cmd_len = 16;
> @@ -1031,7 +1041,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
>  	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
>  	u32 data_len = sdp->sector_size;
>  
> -	if (!sd_set_special_bvec(rq, data_len))
> +	if (!sd_set_special_bvec(cmd, data_len))
>  		return BLK_STS_RESOURCE;
>  
>  	cmd->cmd_len = 10;
> @@ -2880,10 +2890,7 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
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
> @@ -4368,7 +4375,7 @@ static int __init init_sd(void)
>  	if (err)
>  		goto err_out;
>  
> -	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
> +	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, get_order(BLK_MAX_BLOCK_SIZE));
>  	if (!sd_page_pool) {
>  		printk(KERN_ERR "sd: can't init discard page pool\n");
>  		err = -ENOMEM;


-- 
Damien Le Moal
Western Digital Research
