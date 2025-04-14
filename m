Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEE6199FD0;
	Mon, 14 Apr 2025 05:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609953; cv=none; b=EEhnmlYrxGTZQi4RWynDXFuhMSoTXgGwj1NxQ/ekKdb96G6MvkL298Qvl0XCdeUD0013nCwzASN41zur4Kz/8ERgD6CV28jrz+zahrV2yhy3tvWJg/0jzuaWXcAUKXWWmQ2APd8SmODjAQBgXjhDwIZ9tEUEv09LTeNEaqMudcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609953; c=relaxed/simple;
	bh=movFZRRvE5v0oeb0eX90pONqN9a04JPnhYS2ch2HD8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHwda4CucjEv8yRxZqIuSnC7bNKiPICjPTPkLHGOuj4Ymoiy9kGSQqGDFNo3D7RKZ7RlyTX3QBMPo+IHwwznSjxnIXhCTjRUjmK5d4T9JoTNzmFva+sNQQZCqyC+QPttvBjmjH4We0NSMaxV5UidqXTa+cLty7LobmwTKEDKvJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oiPRtZeQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oiPRtZeQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0DkOPUG1uI8Cd9RIbLn43iY4PyDtDr84EzQV4uSv4RE=; b=oiPRtZeQhSwWdaiPa3dL3Y2J08
	VaI/vTaf5hKEhPBheweu7Qrbfb+AkLZvzsJh5S0e8bqeUg4UMu0HA9aVddIrEJlA1mVDlxYXphmrd
	2oDNLXOKjf/Sv5M7kdESMSJQxzMUg+S3qK0JEaEp+I1OUzikP0NtMRDjUR36C1/m53b3emjWOUaWp
	2+0gmm53pjFGRXngH82EDnFj/+DWtEdGC6dGVGr7yVahgmakt3tw7pxlYSejbG3sgx4EV02u2oadB
	JxjmEGRgiwZr3bpHME0siU+4K6j/Sxuz7CP89zA0qhNN7yrMu98xi191skyOOk/EzU9omvWDzT1go
	d2KKwY4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CkB-00000000k4G-1lAW;
	Mon, 14 Apr 2025 05:52:31 +0000
Date: Sun, 13 Apr 2025 22:52:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Steve Siwinski <stevensiwinski@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	bgrove@atto.com, Steve Siwinski <ssiwinski@atto.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: Limit the report zones buffer size to
 UIO_MAXIOV
Message-ID: <Z_yinytV0e_BbNrF@infradead.org>
References: <20250411203600.84477-1-ssiwinski@atto.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411203600.84477-1-ssiwinski@atto.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 11, 2025 at 04:36:00PM -0400, Steve Siwinski wrote:
> The report zones buffer size is currently limited by the HBA's
> maximum segment count to ensure the buffer can be mapped. However,
> the user-space SG_IO interface further limits the number of iovec
> entries to UIO_MAXIOV when allocating a bio.

Why does the userspace SG_IO interface matter here?
sd_zbc_alloc_report_buffer is only used for the in-kernel
->report_zones call.

> 
> To avoid allocation of buffers too large to be mapped, further
> restrict the maximum buffer size to UIO_MAXIOV * PAGE_SIZE.
> 
> This ensures that the buffer size complies with both kernel
> and user-space constraints.
> 
> Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
> ---
>  drivers/scsi/sd_zbc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 7a447ff600d2..a19e76ec8fb6 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -180,12 +180,15 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
>  	 * Furthermore, since the report zone command cannot be split, make
>  	 * sure that the allocated buffer can always be mapped by limiting the
>  	 * number of pages allocated to the HBA max segments limit.
> +	 * Since max segments can be larger than the max sgio entries, further
> +	 * limit the allocated buffer to the UIO_MAXIOV.
>  	 */
>  	nr_zones = min(nr_zones, sdkp->zone_info.nr_zones);
>  	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
>  	bufsize = min_t(size_t, bufsize,
>  			queue_max_hw_sectors(q) << SECTOR_SHIFT);
>  	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
> +	bufsize = min_t(size_t, bufsize, UIO_MAXIOV * PAGE_SIZE);
>  
>  	while (bufsize >= SECTOR_SIZE) {
>  		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
> -- 
> 2.43.5
> 
> 
---end quoted text---
