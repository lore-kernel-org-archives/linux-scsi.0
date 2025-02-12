Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A375E25B689;
	Wed, 12 Feb 2025 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386137; cv=none; b=XLq8AzQtM1eBr58vFvAumI7fBnCkAuIxP2TYDtWCVvWobMKjZPb1XNcMLCqG7VCBlMF9HhTgOpP+dkWz/Ifc6Xm1AssydpDtqUpxklp3jdbspW+e9ASbpP20AdNyRPVyUyxaHDNBUmuyz0MRwBM76ryt17WApG5K7MU3ivNH8fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386137; c=relaxed/simple;
	bh=cJ4xjBVT34Te8xOhdsM+iqRMXJ1gLZlE2BJA8YnTqcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b51NuEYvmHF6UlIelzQfbiBGIHD9Bdx3G/gYEV2ilO9zOf1Cb5KdHIPmSa5+DxzO2WZpWyB4sEGQ+NsSG2JhwtUMfmJaa+49iUEdlFKf/Rum4Bl8enxV4uc/8262NJfK5LonxbEzMV07cQlETYEKFFkEhLztuQ++TQA2si2kDy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wTdGCD0k; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wTdGCD0k"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YtS5F2hGlz6Cl0jX;
	Wed, 12 Feb 2025 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739386124; x=1741978125; bh=Ed3TZsxbinVVCbs1/cx1GNVl
	DZdZKrZvTnFO8NQKKgY=; b=wTdGCD0k40b2735mz65OJarJCV9JIUhCiUHR6QSo
	YyOACUFyIQ/N0QiboV8dW+OTeeW8q+i0nAw8uQ7kKLRYbG6v5PmXFHOGvWhFhbfB
	PZyo5+cfCM41ZCsjtnUTt8fwSAOnfwaG5o/LDCQDjjdEthsi3AQovExhOYGi5Fzz
	xs0X7I3dQpdfpKQQOqP6NooWWaqCKJhQ/2prsHLBOWx2ygOcrMtPQshRDcorS4Bw
	nnCMUfuKOI+EFOSyUCfpROWHGhCcLo0flD+DFODOcZD7P0BxEDdHa6elbRYLYNiu
	/0TomnP62LUVTWDOQzkCYO8LkcxePcRemjPu4z4eDU/g6w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pGMmm2Koljea; Wed, 12 Feb 2025 18:48:44 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YtS561Qf6z6Ckj6B;
	Wed, 12 Feb 2025 18:48:41 +0000 (UTC)
Message-ID: <7a39a882-4f00-483e-942d-36a7cff53954@acm.org>
Date: Wed, 12 Feb 2025 10:48:41 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: hpsa: Use min() to simplify code
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Don Brace <don.brace@microchip.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: storagedev@microchip.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250212115557.111263-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250212115557.111263-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 3:55 AM, Thorsten Blum wrote:
> Use min() to simplify the host_store_hp_ssd_smart_path_status() and
> host_store_raid_offload_debug() functions.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>   drivers/scsi/hpsa.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 84d8de07b7ae..1d19eb2ca1d3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -460,7 +460,7 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
>   
>   	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>   		return -EACCES;
> -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> +	len = min(count, sizeof(tmpbuf) - 1);
>   	strncpy(tmpbuf, buf, len);
>   	tmpbuf[len] = '\0';
>   	if (sscanf(tmpbuf, "%d", &status) != 1)
> @@ -484,7 +484,7 @@ static ssize_t host_store_raid_offload_debug(struct device *dev,
>   
>   	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>   		return -EACCES;
> -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> +	len = min(count, sizeof(tmpbuf) - 1);
>   	strncpy(tmpbuf, buf, len);
>   	tmpbuf[len] = '\0';
>   	if (sscanf(tmpbuf, "%d", &debug_level) != 1)

 From Documentation/process/deprecated.rst:

<quote>
strncpy() on NUL-terminated strings
-----------------------------------
Use of strncpy() does not guarantee that the destination buffer will
be NUL terminated. This can lead to various linear read overflows and
other misbehavior due to the missing termination. It also NUL-pads
the destination buffer if the source contents are shorter than the
destination buffer size, which may be a needless performance penalty
for callers using only NUL-terminated strings.

When the destination is required to be NUL-terminated, the replacement is
strscpy(), though care must be given to any cases where the return value
of strncpy() was used, since strscpy() does not return a pointer to the
destination, but rather a count of non-NUL bytes copied (or negative
errno when it truncates). Any cases still needing NUL-padding should
instead use strscpy_pad().

If a caller is using non-NUL-terminated strings, strtomem() should be
used, and the destinations should be marked with the `__nonstring
<https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html>`_
attribute to avoid future compiler warnings. For cases still needing
NUL-padding, strtomem_pad() can be used.
</quote>

Instead of only changing the calculation of 'len', please change the
strncpy() calls into strscpy() calls.

Thanks,

Bart.
