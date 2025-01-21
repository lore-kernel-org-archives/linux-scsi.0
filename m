Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3206D1714B3
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2025 18:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483800; cv=none; b=C9/sJun7hHnhyoqBxCaY8u00plW4tkK2PZKqi8c6kYsYhO2SVuGTAyRRjHLLxDY4vbhbe2I77eXKJ/5h7u7/gVehy+x7BsHFhU/wBAWenwelruRJOizPzzxSKLvZbRdtXTdW8GvFnAPVOhdYBnM/5tBx7m61TtFwNIKYwlaLv2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483800; c=relaxed/simple;
	bh=VuXWFDnoRZbhO4q2a80xz8xghdCD9e0oRWGp3LZ1wuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jm0/z8ewvHDS7KJ7pMkI9DirzKPb9k011Gt5nprb5dXbGBvzRJw7CP5z5RWtQofv01LfHDM5gg8zvQ/MMK145kAsTzClFNvQB8dEzTuckT91Ecqvxu0UX3QGsP7koAkupl+5h8d6OECCeGUJBQnIInAAhkKoVvrOBVDXRZwUM3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DXU6V+Ke; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DXU6V+Ke"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YcwYn3fbfzlfh9R;
	Tue, 21 Jan 2025 18:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1737483787; x=1740075788; bh=3sc2L0qCx/C7nNhvs7REn70F
	qHQeC2m1fOvzCP5HHFk=; b=DXU6V+Ke/ZauAFUcoRX1VX6QfbpU8GHEVJ6w/at2
	oZH2tesdPfnFACg2r3zJqpwr2ohqkbETYaZ27jKE9PFLEJC5t0B10H01QPxpxcYc
	wkqFvyj0YcQx7yAD+DJjnC3xTVy+EnZjtLvg9GTzAE1gAKOJVBQ5XcJs89bj3d7p
	ZaoaAaIRq96re94az3OYgJtqgY6HiNs24FkX3nBhWbbo56Q6a7dTFvG1FepYFDjZ
	4BrUlc233fzpvk9RY1tBzEaHR5SyUKla5PadPB7vDiz96Jl/FN95oyxgNIzztlRm
	0rmpp5K3YLjeAQifXfZXmFgb22POnaGJ6Tu7dGR3ahyA2A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id adWHPPi9YW1I; Tue, 21 Jan 2025 18:23:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YcwYk5k7pzlfh95;
	Tue, 21 Jan 2025 18:23:06 +0000 (UTC)
Message-ID: <da2b7f34-506c-4de8-8322-5ec1fbae8873@acm.org>
Date: Tue, 21 Jan 2025 10:23:05 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix error return with query response
To: Seunghui Lee <sh043.lee@samsung.com>, linux-scsi@vger.kernel.org,
 Bean Huo <huobean@gmail.com>
References: <CGME20250118023817epcas1p1a7cb68709776f01c5ebeeb02908ed157@epcas1p1.samsung.com>
 <20250118023808.24726-1-sh043.lee@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250118023808.24726-1-sh043.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/25 6:38 PM, Seunghui Lee wrote:
> There is currently no mechanism to return error from query responses.
> Return the error and print the corresponding error message with it.
> 
> Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
> ---
> Changes to v1:
> - modify the error message with response in UPIU(Bean Huo's suggestion)
> ---
>   drivers/ufs/core/ufshcd.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 9c26e8767515..97e50bccb95c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3118,8 +3118,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>   	case UPIU_TRANSACTION_QUERY_RSP: {
>   		u8 response = lrbp->ucd_rsp_ptr->header.response;
>   
> -		if (response == 0)
> +		if (response == 0) {
>   			err = ufshcd_copy_query_response(hba, lrbp);
> +		} else {
> +			err = -EINVAL;
> +			dev_err(hba->dev, "%s: unexpected response in Query RSP: %x\n",
> +					__func__, response);
> +		}
>   		break;
>   	}
>   	case UPIU_TRANSACTION_REJECT_UPIU:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
