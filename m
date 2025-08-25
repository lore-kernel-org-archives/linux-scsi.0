Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6FC126BF1;
	Mon, 25 Aug 2025 01:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756087168; cv=none; b=STQLUtNzGT/hRI5l2IkWb39rmxBo4pA2OuMaauXeupdJwpNXxNhRzpixePLgFjKvr+d2qRd/5ROvNmtpsIGWYTGJ3hUso1HboN2M17j1+h5yl/jDqOGqofq7YOFX9f+IjfWtyAwW1p8a5Xl12UZgpurBXYkvz6fi+M8AJk6s294=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756087168; c=relaxed/simple;
	bh=MutdzAJFjk8Eu30gSpNb8dOm9QLP3AgY1GWhId4n2pQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BCoQEfc3/OJxIWmSCzxhreL7lAL+3RG6axpvb7XR7W54KxxnTeJWypXYUrRsOwAd0XHSeYkCJZ+09RZ/VLKvqKmuZITjmLSkaSs/aPVw4IZRH9jXQsatVbdoBvt9yqLFsqAeXZyP4+7h16uZbOKTUGOKfBZnCmFrnGSH8ZS40Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUXFk3xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUXFk3xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24AAC4CEEB;
	Mon, 25 Aug 2025 01:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756087167;
	bh=MutdzAJFjk8Eu30gSpNb8dOm9QLP3AgY1GWhId4n2pQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DUXFk3xr8ce4qly8l1we901TJcMKS89mXGiczBPWPx/vr137eQgazYo0Zuqq7DQSE
	 BcJ8fCFRSkXUE2IjBYOxiyEbrJ4yJFb+FyJn/obxRp0/GCsQMnS/G2kvqYmXtRl5BK
	 whACSZdwNCagtbbhEyAuKpmSiLb4OeknxWGQPcv0QVSLwUaWG3J7iRp9yueCbK+MM+
	 OPyT8JRzrAPDkzEoLeBVotvEa3XBdJdgdqAPmLrA2pO18lBq+JfhdtcZLqYITx8hDw
	 s3R3UzUxFPlrsCJB4bPzNX9iniyvIvDIzGTWm4bauXN8WAQ8gxgz4n6y5g/mZl6z+e
	 ecA0BD0Z+uvVg==
Message-ID: <7f67d829-51a9-4940-9137-fbf02840eb66@kernel.org>
Date: Mon, 25 Aug 2025 10:56:39 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/3] scsi: sd: Remove redundant printk after kmalloc
 failure
To: Abinash Singh <abinashsinghlalotra@gmail.com>, bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
 <20250824180218.39498-2-abinashsinghlalotra@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250824180218.39498-2-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/25/25 3:02 AM, Abinash Singh wrote:
> The SCSI disk driver prints a warning when kmalloc() fails in
> sd_revalidate_disk(). This is redundant because the page allocator
> already reports failures unless __GFP_NOWARN is used. Keeping the
> extra message only adds noise to the kernel log.
> 
> Remove the unnecessary sd_printk() call. Control flow is unchanged.
> 
> Fixes: e73aec824703 ("[SCSI] sd: make printing use a common prefix")

I do not think this is necessary. Having the message is not a bug.

> Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>

As commented on patch 2, move this patch as patch 2 in the series as it does
not need backporting.

With that, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  drivers/scsi/sd.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5b8668accf8e..aa9d944e27c5 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3712,11 +3712,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		goto out;
>  
>  	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
> -	if (!buffer) {
> -		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
> -			  "allocation failure.\n");
> +	if (!buffer)
>  		goto out;

Nit: you can return 0 directly here. No need for the goto.

> -	}
>  
>  	sd_spinup_disk(sdkp);
>  


-- 
Damien Le Moal
Western Digital Research
