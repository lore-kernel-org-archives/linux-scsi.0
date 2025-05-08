Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F5021883C;
	Thu,  8 May 2025 23:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745765; cv=none; b=CZI63S7PPadybq37cdFe1+IPAVVEtW5AbifXYk8KKIijqtHYk31F6w0k0D4wPR+Tje2ijZAO5Tdl+YpNFv6PLXaxJ2D+248ooP4dBU69Ou5yinePPLvpWdwdpxcrd12cFCLAgEY068RMpbZVMY8n0CdfUJbFyJBLiHaKovAHick=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745765; c=relaxed/simple;
	bh=pxybTN/WFgrRbAVCsZ8haDtMdQXB0q77B7phekNhxoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BJcnIGjozffHUBK54I9e68dEjYnLCgBDtzw/3pT4tddlyvI+AXH54WXVE4QLUM9Ag7JDGLCkDg34ucMfgMU9WRMf5FN9z0BTYD/Jm/ehGxd0XYcH5i4O5hkkWBjAzTsONGIcGKTt5zUiVdsOICM+hc+7SzImOd2ECqyx2fHQhTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnnn3NnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnnn3NnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBFDC4CEE7;
	Thu,  8 May 2025 23:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746745765;
	bh=pxybTN/WFgrRbAVCsZ8haDtMdQXB0q77B7phekNhxoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cnnn3NnPvzw+2CweegY/sbCnmu+9BxlNfueOs1eJM3aHOe6A5y44z4HKCJPa+VUE9
	 cdQEr2VsiGtbSniJjtZa4r8TDC3ywEFAP3dSl6tgnAVFNx9TCM39X6hEwkAxLBnXzO
	 UkjJPB5rUkL8ZTLHs7L0uOX71NqKXAViJyCtsPI8ALHKtDActvv+z8SL46bYPhMz4I
	 nmTTu/vmbQxeSbHMzdiT/oDk/ATISb4BW7X/C6VzYm3aDwqUxzhkAOFe3IDEUUbN0c
	 E4MWwXDi0DBSC+VnwA9SOv/wZo/8Px4BoepEEuvWI0MZVOGsqD6CDXJMZUaEvtbWZy
	 CEvrAPoYRo8zQ==
Message-ID: <8d605e7b-e4f7-48eb-ad06-0e8a87b620b5@kernel.org>
Date: Fri, 9 May 2025 08:08:12 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] block, scsi: sd_zbc: Respect bio vector limits for
 report zones buffer
To: Steve Siwinski <stevensiwinski@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, axboe@kernel.dk, bgrove@atto.com,
 hch@infradead.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, ssiwinski@atto.com, tdoedline@atto.com,
 stable@vger.kernel.org
References: <32a7f1ad-e28a-4494-9293-96237c4ed70b@kernel.org>
 <20250508200122.243129-1-ssiwinski@atto.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250508200122.243129-1-ssiwinski@atto.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/9/25 5:01 AM, Steve Siwinski wrote:
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
> Fixes: b091ac616846 ("sd_zbc: Fix report zones buffer allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve Siwinski <ssiwinski@atto.com>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
