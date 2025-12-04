Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5E421FF5F;
	Thu,  4 Dec 2025 02:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764813788; cv=none; b=EESdWFuR5GPeK0sTGKHkB4Rk4+3Ou0jkUaJOAe0oJ9caAYeyD/SuDhXGWrdd/tr5EoxZ01JUxS2t9UrPNZWYFn64pGkKOQfT8ScV76nrkoVlwrXGbCVFF+aN+0Cfl5gYWK4Mg8b9okd8QHUDq7Z12BOg3VRvU6cxZzgIxompYMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764813788; c=relaxed/simple;
	bh=U6A3eosJxLwMAKKIkeQRPfbyPDCCKwI53qjVyG4KFuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m+ULPAJuBnS4wXc4rY+vXpHFI20mlnQPY5srlczQC7YP3O0JdlMhM/zUl4BWowgFEf+N8/P9/cwjOLmHkCRK+4pKPvvYfA60WxsmOMwN6vZpZ7gfR9lJv3+SnvFrkW8EY5jVtaxQKjISvZn1OI/lVVDrZ4jTQ4judS9EpqXDKLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mp2/36xe; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mp2/36xe"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dMHpf5ZY1z1XM0pc;
	Thu,  4 Dec 2025 02:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764813785; x=1767405786; bh=lIH0GpEJ/nKcW86DeKzpmjes
	ZrvNNmcQLxsmmTISIlY=; b=Mp2/36xeeCXJhJLstMrA1FsGR7gSxW1CDiSQuHyh
	NSRk0EjrXl9SYtMr5wiEvDB8pcZgzu5bH3qdig0MnvlKoAEG0mdi+iO/bBAu+GCu
	l2PrrlgsfcmnINS2K0Ak7X4AOYX/8vRKVlb62Fi9DnDrfLK66amu9hURFyd/Gb1l
	D9CdZ1Mw3jWo4XvomtqsWx5B6MpO2ME4NV0y4x7972DxAyoFzNDmc1Ip1qQblLhq
	N4G+sn+s2w8cis6DAHrJbi0QIqs825bbfyEnlwGITISAY1YDiRAAoc0p903XbmaQ
	9nZVrgaA3WhVhlDfT7LWzlrjfcFnyCTh3OSJIPVUrZigdA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Jnn4nwBRFKst; Thu,  4 Dec 2025 02:03:05 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dMHpY1fM9z1XM0pF;
	Thu,  4 Dec 2025 02:03:00 +0000 (UTC)
Message-ID: <98e7be8d-9288-4ecd-9e97-51d4cbe0f47e@acm.org>
Date: Wed, 3 Dec 2025 16:02:58 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 2/2] scsi: scsi_debug: enable sdebug_sector_size >
 PAGE_SIZE
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, kernel@pankajraghav.com,
 Swarna Prabhu <s.prabhu@samsung.com>
References: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
 <20251203230546.1275683-3-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251203230546.1275683-3-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 1:05 PM, sw.prabhu6@gmail.com wrote:
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b2ab97be5db3..b5839e62d3bb 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -8459,13 +8459,8 @@ static int __init scsi_debug_init(void)
>   	} else if (sdebug_ndelay > 0)
>   		sdebug_jdelay = JDELAY_OVERRIDDEN;
>   
> -	switch (sdebug_sector_size) {
> -	case  512:
> -	case 1024:
> -	case 2048:
> -	case 4096:
> -		break;
> -	default:
> +	if (sdebug_sector_size < 512 || sdebug_sector_size > BLK_MAX_BLOCK_SIZE ||
> +	    !is_power_of_2(sdebug_sector_size)) {
>   		pr_err("invalid sector_size %d\n", sdebug_sector_size);
>   		return -EINVAL;
>   	}

Please use blk_validate_block_size() instead of open-coding it.

Thanks,

Bart.
