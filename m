Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE0D1A8F97;
	Fri, 18 Jul 2025 07:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752822947; cv=none; b=o+wodlWsvLTl/dqW91mXa/f301d6/VQfErQ4gXaDrLAc2U06VKITEIb9wV5u86+isHEC2wdSqljX8nWLNUu3OV5wG/pCQbIWd6LG5kpHbChxXiGN6AD/IuXkRv4PV+cl+yJwcLxNk7cO0eXZ2wPUWUp3xAWts5HNpBYOHsEYuxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752822947; c=relaxed/simple;
	bh=xevuuyn6rIUbMJbEs/q63q1rNzMUeVVOGcNjY0l544k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hepWP0g0l1OfhBTOK3iRIlQ3hLu8yeXtEi/qKwKAxBvgJpCDPzgBXe9DEFv3h3H4wmoCPD/Q3hSgq5vABWp88phUOSYWV3GnhKFv6EVRMUACqM+K+EupX92bue1XVdS1W+Dq+vB6mKHQXxbIT8SghJcGtPE2MvU6hPuoUWbthq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MRu94qEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRu94qEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DF6C4CEED;
	Fri, 18 Jul 2025 07:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752822946;
	bh=xevuuyn6rIUbMJbEs/q63q1rNzMUeVVOGcNjY0l544k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MRu94qEESdMCEpmPMg8IGrgvU57x6+EtXB7uvtBCoBCWVcdA1LrvATQr3m/YWxQV6
	 l7JPS6eKQyPEmvx+boTTlthnU+4dDLvJq6qv29PId7gZ4SelLg5oZDFUPE/BGtvNre
	 F64dDcRIvJO9dN33JyqfYvSEM1JeqTwHiKmQo7NkVu9s6BDurtB+KDhOmNBl5ES7h2
	 bCgPxhPi7lw/Qearj4OvwpK4jrmgHohYNJJGWiMIq1KmuKzKTpVG2ccoTs2WrZkeKZ
	 52R/QJk3/P8AxX2cKGeB/xIPXJ43ChygQ5Sn++biQYVFtVwrjMPRNM7H/qdRdSz9/z
	 ZUHvBG0Xzstbg==
Message-ID: <27e39d44-430c-42fd-81cc-a36fc0191d0d@kernel.org>
Date: Fri, 18 Jul 2025 16:15:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 05/12] blk-zoned: Move code from
 disk_zone_wplug_add_bio() into its caller
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <20250717205808.3292926-6-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250717205808.3292926-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/25 05:58, Bart Van Assche wrote:
> Move the following code into the only caller of disk_zone_wplug_add_bio():
>  - The code for clearing the REQ_NOWAIT flag.
>  - The code that sets the BLK_ZONE_WPLUG_PLUGGED flag.
>  - The disk_zone_wplug_schedule_bio_work() call.
> 
> No functionality has been changed.
> 
> This patch prepares for zoned write pipelining by removing the code from
> disk_zone_wplug_add_bio() that does not apply to all zoned write pipelining
> bio processing cases.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

[...]

> @@ -993,6 +976,7 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>  {
>  	struct gendisk *disk = bio->bi_bdev->bd_disk;
>  	sector_t sector = bio->bi_iter.bi_sector;
> +	bool schedule_bio_work = false;
>  	struct blk_zone_wplug *zwplug;
>  	gfp_t gfp_mask = GFP_NOIO;
>  	unsigned long flags;
> @@ -1039,12 +1023,16 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>  	 * Add REQ_NOWAIT BIOs to the plug list to ensure that we will not see a
>  	 * BLK_STS_AGAIN failure if we let the BIO execute.
>  	 */
> -	if (bio->bi_opf & REQ_NOWAIT)
> -		goto plug;
> +	if (bio->bi_opf & REQ_NOWAIT) {
> +		bio->bi_opf &= ~REQ_NOWAIT;
> +		if (!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED))
> +			goto plug;

See below.

> +		goto add_to_bio_list;
> +	}
>  
>  	/* If the zone is already plugged, add the BIO to the plug BIO list. */
>  	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
> -		goto plug;
> +		goto add_to_bio_list;
>  
>  	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
>  		spin_unlock_irqrestore(&zwplug->lock, flags);
> @@ -1060,7 +1048,13 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>  	return false;
>  
>  plug:
> +	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> +	schedule_bio_work = true;

Since there is only a single "goto plug", I would simply move the 2 lines above
together with the goto plug and replace that goto with goto add_to_bio_list.

> +
> +add_to_bio_list:
>  	disk_zone_wplug_add_bio(disk, zwplug, bio, nr_segs);
> +	if (schedule_bio_work)
> +		disk_zone_wplug_schedule_bio_work(disk, zwplug);
>  
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
>  


-- 
Damien Le Moal
Western Digital Research
