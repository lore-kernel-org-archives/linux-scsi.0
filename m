Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A715A28DB69;
	Tue,  6 May 2025 02:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746498552; cv=none; b=FQODOlF9/NXSaJh8rSY32KqaKEnsuPTsvu6ZRRA1UpJzzUvu4CukPPRjOKxRQGjHK+nw93UUd0QiNhVJLsBYZR49pcjN/C+dwjCetz40nFYdn8Ij5PlJUg3v2zgxnVLKQvO645HQDvuVMqvedAdzHtF4dxFqo2Bq3MZAkS0ZdnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746498552; c=relaxed/simple;
	bh=QAT1WLsb4YEOsXpMRLpMnD8PishjiziOXHhVh/DfJTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E57nXfsGhYSHT0zolVKQPSJPSwocRWUZYakmry1roF4gdagIa45EF72THIsTp5BGB0ED/cHI6BZJw4uFQABYparV5x4zTVymYGE9fSxWzMnXIrplP1noFWb/QRNTLni6OG01uFu1b6wrWIue3ObpESbHmNd7L5pOBwVteadV8eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEpk0Ex8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEpk0Ex8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9145C4CEE4;
	Tue,  6 May 2025 02:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746498551;
	bh=QAT1WLsb4YEOsXpMRLpMnD8PishjiziOXHhVh/DfJTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KEpk0Ex8+wZGFhzgxQNOY0Ch4KcsmvRDAlZ4V0XPR2f4SLqp0sCXAboi6oRkufLfk
	 2Z76bSHCqT9NOIjeI4obIHUMLEZXAwHGGijqDLpbA2JS2eQVzYCCZeWxKv+/WLhOUb
	 9XGHKKLRcHJ7tSsKAFkwq25OXxvy2N0+jeO2tJtT2j6bW7ZIdbkRPSP4mQ5Kxs+NEz
	 Bw/zLhKJtXUFEgfodevBhyVqhcnXfBOA+n5jtaUokqhcW6NV6A6ua13tleZAFo08Et
	 GaHEk3uynHFuxu/k1j1R6Byv8zXF0WvIJzDbVZj3SHCwE3f8X5RgNlkCWu/ChvWSOA
	 zAocSjrhhAi9g==
Message-ID: <32a7f1ad-e28a-4494-9293-96237c4ed70b@kernel.org>
Date: Tue, 6 May 2025 11:29:08 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] block, scsi: sd_zbc: Respect bio vector limits for
 report zones buffer
To: Steve Siwinski <stevensiwinski@gmail.com>, hch@infradead.org
Cc: James.Bottomley@hansenpartnership.com, bgrove@atto.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, ssiwinski@atto.com, axboe@kernel.dk,
 tdoedline@atto.com, linux-block@vger.kernel.org
References: <aBIucgM0vrlfE2f9@infradead.org>
 <20250502193554.113928-1-ssiwinski@atto.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250502193554.113928-1-ssiwinski@atto.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/3/25 04:35, Steve Siwinski wrote:
> The report zones buffer size is currently limited by the HBA's
> maximum segment count to ensure the buffer can be mapped. However,
> the block layer further limits the number of iovec entries to
> 1024 when allocating a bio.
> 
> To avoid allocation of buffers too large to be mapped, further
> restrict the maximum buffer size to BIO_MAX_INLINE_VECS.
> 
> Replace the UIO_MAXIOV symbolic name with the more contextually
> appropriate BIO_MAX_INLINE_VECS.
> 
> Signed-off-by: Steve Siwinski <ssiwinski@atto.com>

This needs a "Fixes" tag:

Fixes: b091ac616846 ("sd_zbc: Fix report zones buffer allocation")
Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 7a447ff600d2..a5364fdc2824 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -180,12 +180,15 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
>  	 * Furthermore, since the report zone command cannot be split, make
>  	 * sure that the allocated buffer can always be mapped by limiting the
>  	 * number of pages allocated to the HBA max segments limit.
> +	 * Since max segments can be larger than the max inline bio vectors,
> +	 * further limit the allocated buffer to BIO_MAX_INLINE_VECS.
>  	 */
>  	nr_zones = min(nr_zones, sdkp->zone_info.nr_zones);
>  	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
>  	bufsize = min_t(size_t, bufsize,
>  			queue_max_hw_sectors(q) << SECTOR_SHIFT);
>  	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
> +	bufsize = min_t(size_t, bufsize, BIO_MAX_INLINE_VECS << PAGE_SHIFT);

I would prefer something like:

	unsigned int max_segments;
	...

	max_segments = min(BIO_MAX_INLINE_VECS, queue_max_segments(q));
	bufsize = min_t(size_t, bufsize, max_segments << PAGE_SHIFT);

>  
>  	while (bufsize >= SECTOR_SIZE) {
>  		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index cafc7c215de8..7cf9506a6c36 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -11,6 +11,8 @@
>  #include <linux/uio.h>
>  
>  #define BIO_MAX_VECS		256U
> +/* BIO_MAX_INLINE_VECS must be at most the size of UIO_MAXIOV */
> +#define BIO_MAX_INLINE_VECS	1024

This should be:

#define BIO_MAX_INLINE_VECS	UIO_MAXIOV

so that we do not end up with inconsistencies with what user space sees as the
maximum value.

>  
>  struct queue_limits;
>  


-- 
Damien Le Moal
Western Digital Research
