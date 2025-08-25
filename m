Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA0B1D555;
	Mon, 25 Aug 2025 02:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756087262; cv=none; b=JfGTr9/Qo+r65pRW5F/C6njkGutQ0Iej5CtN+XNv5mtnUL3oakxuiQGP6mf70hp3RtBKcALgZz5o4YTy5qrWQOBHrShXaVBJS5uQBVsMVfXawEZq3O/37nx8vccnsC5FQi8sDNrDlH47LbUMAgqUYFIasT8gWqNYgTQrT5Z1xk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756087262; c=relaxed/simple;
	bh=TCrlxBFeP+9vYrSLJjaxpk5OMuGV1M2/hfVIgdh7Q/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VeelHwfbOCdawAB8BogLrJCVQwhumuvnI8xNX0fIJmTJFE2UiN6pHomqSsSGZOy6epd3yLa2fIlddBtBQ1IymbOQTSkqsMBci3uJytviB8mcw9Lb7OTtKXhbpKu3IR/i8KnwTsJRMnSAhWSNp17HI8RvkI4tfebMXhyehWUoX5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GgmsXD9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgmsXD9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7DFC4CEEB;
	Mon, 25 Aug 2025 02:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756087262;
	bh=TCrlxBFeP+9vYrSLJjaxpk5OMuGV1M2/hfVIgdh7Q/g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GgmsXD9jBFxyvpE9Bx+ZJyVIwCUjdE4fmn2ZXb6Z9He/4FLLfNZ8rF2h7tE6P/iZO
	 4I69yJi/uCmPAmY2ncIwP5cg+g9SEkvYs3wsfqPZjWUH0ItQ8JdURQcBTnPCD0Hezp
	 eQSrMAqBioxStZxrC1QkOsQf65QJFYcxriJmQJMmDcGKbqTTZ1B7vb5VHqQHchqdqz
	 LfpGKtXPBf65VrldOGgAlBTK/mhvIQXeG1KmP5Yd5qmc9IHXLT0boN3CMEvYfssMpQ
	 kFWiK+w5UDq+ozPdCKhHf8wFKmKbqzybZ8JAefELudsa5xP04T4L9x2VUz4rw0FDgN
	 9e9mJwYMf5zrw==
Message-ID: <91f0fb20-1313-47c6-b40f-65520cd8c85b@kernel.org>
Date: Mon, 25 Aug 2025 10:58:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/3] scsi: sd: make sd_revalidate_disk() return void
To: Abinash Singh <abinashsinghlalotra@gmail.com>, bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
 <20250824180218.39498-4-abinashsinghlalotra@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250824180218.39498-4-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/25/25 3:02 AM, Abinash Singh wrote:
> The sd_revalidate_disk() function currently returns 0 for
> both success and memory allocation failure.Since none of its
> callers use the return value, this return code is both unnecessary
> and potentially misleading.
> 
> Change the return type of sd_revalidate_disk() from int to void
> and remove all return value handling. This makes the function
> semantics clearer and avoids confusion about unused return codes.
> 
> Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/sd.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 35856685d7fa..b3926c43e700 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -106,7 +106,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
>  		unsigned int mode);
>  static void sd_config_write_same(struct scsi_disk *sdkp,
>  		struct queue_limits *lim);
> -static int  sd_revalidate_disk(struct gendisk *);
> +static void  sd_revalidate_disk(struct gendisk *);
>  static void sd_unlock_native_capacity(struct gendisk *disk);
>  static void sd_shutdown(struct device *);
>  static void scsi_disk_release(struct device *cdev);
> @@ -3691,7 +3691,7 @@ static void sd_read_block_zero(struct scsi_disk *sdkp)
>   *	performs disk spin up, read_capacity, etc.
>   *	@disk: struct gendisk we care about
>   **/
> -static int sd_revalidate_disk(struct gendisk *disk)
> +static void sd_revalidate_disk(struct gendisk *disk)
>  {
>  	struct scsi_disk *sdkp = scsi_disk(disk);
>  	struct scsi_device *sdp = sdkp->device;
> @@ -3699,7 +3699,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	struct queue_limits *lim = NULL;
>  	unsigned char *buffer = NULL;
>  	unsigned int dev_max;
> -	int err = 0;
> +	int err;
>  
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>  				      "sd_revalidate_disk\n"));
> @@ -3709,11 +3709,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	 * of the other niceties.
>  	 */
>  	if (!scsi_device_online(sdp))
> -		goto out;
> +		return;
>  
>  	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
>  	if (!lim)
> -		goto out;
> +		return;
>  
>  	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
>  	if (!buffer)

OK. So you can ignore the nit I commented on patch 1.

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> @@ -3823,7 +3823,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	kfree(buffer);
>  	kfree(lim);
>  
> -	return err;
>  }
>  
>  /**


-- 
Damien Le Moal
Western Digital Research
