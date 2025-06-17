Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43D2550A9;
	Tue, 17 Jun 2025 20:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750192536; cv=none; b=iaS2dwdNYalvTosiPyW0nQ1JDFHzp0JpHx680e64MsUrMsU8/e8NR7vxSldiutvyNGUH2TGFEWdguV8tXbsr41ENJ26y9+lerW44QxlZOhYoWbng0ZfETI0fnrXdVnAioAhXhUOEV7UxETyxL6QK3zGuXzZTu+gZDwwwWoDltqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750192536; c=relaxed/simple;
	bh=rPE7MoPsrOZc3jaN64uddrrPIwCUoTZyGIJniPvCk3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KgqN1BdJfu1HY7C7K+OHRj7esGCb+k/swSCDZRfLbPJ+ovXui+vPIv2ygq46m2+hhrC+G++xteEMB0EKbemL251AAxeNmg3f6KGhWDucJ3aSUZN+Uz1+oGtslfY/MWye/5rySvoL5T1ejXctlgevjTdQZlyyMivpkAVgFyX4TdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VC7zLJTJ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VC7zLJTJ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bMJXj66trzlgqxs;
	Tue, 17 Jun 2025 20:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750192532; x=1752784533; bh=NJM5Xr7XT4s74chXxnwo4y3s
	j6gq5yvpkyrSo5mt9+s=; b=VC7zLJTJvjF9wYq8W0LcwySjpV990r8rOOwJ92S6
	dQfBP1HHXYtg3fyh2XnLJVR250lzKf2/epwW2FxJ6dA58bHaiL1JsNH1feDX2tv3
	aHLqxWmx4TxXjwU83B5aqz3Y2HtMUAqwbI4psr3lqSgdCpgojRRsfSr8XjpneKR5
	JXk5M1CBE0lDgq96eRYxdBYEvVOqjN51jKxNTYOTqNdkdzp/CX9wniRW+OkjDZoA
	bSF1k+w5L9M6ywDhZ8EYjUYp+DzRJESE0q3xrplwMcXyvRr8wHdJyFkNyziAVpkX
	ujeFJqKH9IdzbBMsWDq3Rjl8AmLox4dmQ+ikZ0xiK4Xo5Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id T29ELpj76Ixo; Tue, 17 Jun 2025 20:35:32 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bMJXd0RTmzlgqxr;
	Tue, 17 Jun 2025 20:35:27 +0000 (UTC)
Message-ID: <289fa5bc-ffb5-4ceb-a03c-dd79f282d2fe@acm.org>
Date: Tue, 17 Jun 2025 13:35:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: Clear ucd_rsp_ptr for UPIU requests once
To: Avri Altman <avri.altman@sandisk.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250617095611.89229-1-avri.altman@sandisk.com>
 <20250617095611.89229-2-avri.altman@sandisk.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250617095611.89229-2-avri.altman@sandisk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 2:56 AM, Avri Altman wrote:
> Previously, the response buffer (ucd_rsp_ptr) was cleared in multiple
> UPIU preparation functions. Do it once.
> 
> Signed-off-by: Avri Altman <avri.altman@sandisk.com>
> ---
>   drivers/ufs/core/ufshcd.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0a702356a715..c2048aca09fc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2826,8 +2826,6 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
>   	/* Copy the Descriptor */
>   	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
>   		memcpy(ucd_req_ptr + 1, query->descriptor, len);
> -
> -	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
>   }
>   
>   static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
> @@ -2840,8 +2838,6 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
>   		.transaction_code = UPIU_TRANSACTION_NOP_OUT,
>   		.task_tag = lrbp->task_tag,
>   	};
> -
> -	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
>   }
>   
>   /**
> @@ -2867,6 +2863,8 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
>   	else
>   		ret = -EINVAL;
>   
> +	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
> +
>   	return ret;
>   }

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
