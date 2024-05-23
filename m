Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F7382897;
	Thu, 23 May 2024 22:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716504208; cv=none; b=Uwp8KJSyHWBlfDnj1nl/3hM11tZWMWX397eLgcVyo+ElDywNhPLnYXMCcRflRtq4fZvYIILeRaWOHee3tPzoyiyjpxTeC61XEfPwDHxUeyU/BcLFm1tVjuu4yp548CDSmTTMkRZZQM4Voaae0E1CJr6XhLucB7diEXWX+eyKUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716504208; c=relaxed/simple;
	bh=7ff1AHgvlrtg/MrkCdHs62zO9804eyEfakWj1+z8oy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NdffbBVSauOXe3hn3BafzrysYGPPB1guecv4lcbS/Q3hy/jhWtRap5/qD8oR0+NTVcE/dX7Bgkhus86DTR/ax+q134EBG2/Nbhr8vwJU70HnOz1cfFyvtH9GQcQFOogx88Q+3P/V44Cj16jING+ADabXnyHacSEUygc67Z97HSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QUcsqlRd; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QUcsqlRd"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vljr84b7QzlgMVN;
	Thu, 23 May 2024 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716504196; x=1719096197; bh=vl2befUNFkoJj/EceVT6ZOM7
	RblnlmPSc3ZIyQuGZzs=; b=QUcsqlRdMSmf5MqXe0s19sywYlH4abTBdwJ/uweM
	SlCz2anzBuTzJ67dXL8iR2UEJA9vkjcuUCHcZB+dFzpNW1fcuDoX4Tmfy1ey9tNP
	TmjLtY+CPj3wpAcukUOCC+jYGS05t9Ul5frrkCVF9wwwP7LwuKg6diPd4YZ+xAQs
	2V3l0hffETqE2b+QnEr9ZM90SlIwEV53TvvVbJ94hpVDNh7LtlmUYO7nzPUj2vX6
	IH1d9+w7bjpotzuXADsPABxjycG2d4OAsKP9DsESErLiSmcrW9HoPllwUUI+TPr1
	Bx0mnk0t8jYWbzKArvrJ0YDgpeJc3pA2cATFVldt2k3quA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WzqY_q9Owkow; Thu, 23 May 2024 22:43:16 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vljr10V97zlgMVL;
	Thu, 23 May 2024 22:43:12 +0000 (UTC)
Message-ID: <cdeb291d-0b8f-4c82-be1f-77d5708af685@acm.org>
Date: Thu, 23 May 2024 15:43:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs:mcq:Fixing Error Output for ufshcd_try_to_abort_task
 in ufshcd_mcq_abort
To: Chanwoo Lee <cw9316.lee@samsung.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, stanley.chu@mediatek.com,
 quic_nguyenb@quicinc.com, quic_cang@quicinc.com, powen.kao@mediatek.com,
 yang.lee@linux.alibaba.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20240523002322epcas1p2a63dfc646a2b2dd8fcadad2a8807bcee@epcas1p2.samsung.com>
 <20240523002257.1068373-1-cw9316.lee@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240523002257.1068373-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/24 17:22, Chanwoo Lee wrote:
> An error unrelated to ufshcd_try_to_abort_task is being output and
> can cause confusion. So, I modified it to output the result of abort
> fail. This modification was similarly revised by referring to the
> ufshcd_abort function.
> 
> Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
> ---
>   drivers/ufs/core/ufs-mcq.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 005d63ab1f44..fc24d1af1fe8 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -667,9 +667,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
>   	 * in the completion queue either. Query the device to see if
>   	 * the command is being processed in the device.
>   	 */
> -	if (ufshcd_try_to_abort_task(hba, tag)) {
> +	err = ufshcd_try_to_abort_task(hba, tag);
> +	if (err) {
>   		dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
>   		lrbp->req_abort_skip = true;
> +		err = FAILED;
>   		goto out;
>   	}

Why does the word "Fixing" occur in the title of this patch? I think
that this patch does not affect the value returned by
ufshcd_mcq_abort(). From the start of that function:

	int err = FAILED;

Thanks,

Bart.
