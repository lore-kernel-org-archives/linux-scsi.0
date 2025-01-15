Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05D124A7E8;
	Wed, 15 Jan 2025 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736964775; cv=none; b=TT9dd7Z0r9++xJmNvzAhdBjADeAvlCqyC5uPu5ibjDuxa3dNEq65eM7n3fOlXvnDEabeeHqC3Y3Z31lMbS0FapFazSbmcGNMvQH8BcMWuzsoeo0JpXVQ2OMj+EDKfdT1dfiGXRu/EP05b9RLm2fhh3+EL2i/2qh/DZLOiL/11zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736964775; c=relaxed/simple;
	bh=qrmSa8H3ieYbDLbjU7uhu0Lq7H7t12zernwn8ngg7lU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFITJviGmup3ZIB6QHKNUr6faALrtw3meFt54DIsgbEgesNmNqTMoRWnEiCbilmxgbj84jKgX2kFEIDK5YxpbJt28v87WiTTiBrtomMjGfLuzRKrjfs0LyYUVfhSTdd4g9iHAB6x/6k1wRy1VNBPl5JcZLBYZ+p+SJveL21j0qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=f2ME4wZ3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="f2ME4wZ3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YYDch6dD1z6CmQwP;
	Wed, 15 Jan 2025 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736964763; x=1739556764; bh=5ImNsWm6EBEFksCwY9oNYms5
	pIDh6p3UdOuarbjdmUE=; b=f2ME4wZ3/iK6ndNfMHzo2/mHCG3LlV14e+jUmS3o
	sUTyMD++Jy1CQhIT04WKcEz16p+c7exnZap3tHE6IVFiGiNq/oOVQ4cPP/k/ThN7
	o1GIx6d9W+VVUS8aMRouj9R7cPpTPuoLsLbyom9tOr6/dWCNrAGNAdcyjRvwcrMI
	oxttqj9lCRmoUsZ8t7/MrLfW1KcifvGc0GFrgTSZnS7F1XaKn0wbXVWdcOy5vsZu
	3ZLiPJQNBdjZKeV6mgXYIjjUIN6XixCOW5XGJRShdlt/63k1R96/dPKwDWbBY6kQ
	igQ68rn3lFgqwrtJ70iH86g8I8RMFbC1+UiBLZwzISQ9Jw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JbQFA697lBXW; Wed, 15 Jan 2025 18:12:43 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YYDcP42XNz6CmQwN;
	Wed, 15 Jan 2025 18:12:37 +0000 (UTC)
Message-ID: <44520a93-a52e-4f88-8ca5-5f0fb38df607@acm.org>
Date: Wed, 15 Jan 2025 10:12:35 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
To: DooHyun Hwang <dh0421.hwang@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 quic_mnaresh@quicinc.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
 jangsub.yi@samsung.com, sh043.lee@samsung.com, cw9316.lee@samsung.com,
 sh8267.baek@samsung.com, wkon.kim@samsung.com
References: <CGME20250115022348epcas1p29705c109f51c01e1e91ef227233c7119@epcas1p2.samsung.com>
 <20250115022344.3967-1-dh0421.hwang@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250115022344.3967-1-dh0421.hwang@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/25 6:23 PM, DooHyun Hwang wrote:
> It is found that is UFS device may take longer than 500ms(50ms * 10times)
> to respond to NOP_OUT command.
> 
> The NOP_OUT command timeout was total 500ms that is from
> a timeout value of 50ms(defined by NOP_OUT_TIMEOUT)
> with 10 retries(defined by NOP_OUT_RETRIES)
> 
> This change increase the NOP_OUT command timeout to total 1000ms
> by changing timeout value to 100ms(NOP_OUT_TIMEOUT)
> 
> Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
> ---
>   drivers/ufs/core/ufshcd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cd404ade48dc..bf5c4620ef6b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -57,8 +57,8 @@ enum {
>   };
>   /* NOP OUT retries waiting for NOP IN response */
>   #define NOP_OUT_RETRIES    10
> -/* Timeout after 50 msecs if NOP OUT hangs without response */
> -#define NOP_OUT_TIMEOUT    50 /* msecs */
> +/* Timeout after 100 msecs if NOP OUT hangs without response */
> +#define NOP_OUT_TIMEOUT    100 /* msecs */
>   
>   /* Query request retries */
>   #define QUERY_REQ_RETRIES 3

The above change relies on all device management commands being issued
with the same tag. If a single NOP OUT command may take longer than
500 ms, shouldn't NOP_OUT_TIMEOUT be increased to 1000 ms instead of
100 ms? The number of NOP OUT retries seems high to me and probably can
be reduced?

Thanks,

Bart.
