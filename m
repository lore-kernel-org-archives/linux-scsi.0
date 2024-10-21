Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A65E19E968;
	Mon, 21 Oct 2024 20:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729540987; cv=none; b=SEAuJzpA8lBkb8d+48d+v6DwZkUwMECCgp0ZWidZiMIIHXx0mqmVz+QyZZpyR00R1OrtP1w96REKTwzFzunYdDxz4gqqb3YFr/DbE6umOhuvL/YmNSMIhEuFvlPVZZeKi8sLG1j0eCBuC1wUHmN8EP3ZR7J4Qu7wjwiYJ2yZfTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729540987; c=relaxed/simple;
	bh=UvWylO9B6Jf2VwFrBEacupcT8ysDV+xcoKNh/mgpwck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eHbS1Fo9RM9FWIxLs2sMqN/Uafp9SQbcqMP5iIiOagl1QBy/qssCKtHKnUVlnJxyDNxckglPWqj8EYXfzV2OVQJPWbYjuAmaxuzy7Q2JZLOyyfVwCkTKTosThCArhjuQyyLo4WeNBi8ZJ4uEuQa5M20DaliaZXpI8+u4YYV7gmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iwuYN0p3; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iwuYN0p3"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XXR7Y5Bd9zlgMVX;
	Mon, 21 Oct 2024 20:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729540983; x=1732132984; bh=6P+xsL+aOkZWfgD+SKkmyPNz
	41unPwat0uepuJTOhnc=; b=iwuYN0p3zXpaL0/n1r6ezyZsCMYTNvJHSOgUOCSW
	UtyCTjMn4HEQ3wXjVdvV5xR1IN+uSJydZx4wIWmHGe+Oz6zNg81Gbws9PFoVcCJB
	2Evb12xyJQ19URiOE2Kv+UiEZADruYT+sqQmYT+2gSPhhIyY08L0cOi2YQJcBV+8
	wMo15HImrBPrUPlwqkAnVV8nWXt31LAlyyMQlPVLFyA1nPope8B4eHIa9tyHOU1L
	OMCnZ/RuUsIf4Po/cqu3IUaMByzY+VczMPh+4xF67+cOY4Fp/OBeeEfD7bHMVaIF
	HX/zImHtVlhLpx51HEo3unUeEw85Ci6iQ5BXYB283GzAuQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Cnyap0vg_rY8; Mon, 21 Oct 2024 20:03:03 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XXR7V1fRVzlgMVW;
	Mon, 21 Oct 2024 20:03:01 +0000 (UTC)
Message-ID: <c58e4fce-0a74-4469-ad16-f1edbd670728@acm.org>
Date: Mon, 21 Oct 2024 13:02:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: ufs: core: Use reg_lock to protect HCE register
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241021120313.493371-1-avri.altman@wdc.com>
 <20241021120313.493371-5-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241021120313.493371-5-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 5:03 AM, Avri Altman wrote:
> Use the host register lock to serialize access to the Host Controller
> Enable (HCE) register as well, instead of the host_lock.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4eee737a4fd5..3cc8ffc6929f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4795,9 +4795,9 @@ void ufshcd_hba_stop(struct ufs_hba *hba)
>   	 * Obtain the host lock to prevent that the controller is disabled
>   	 * while the UFS interrupt handler is active on another CPU.
>   	 */
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	spin_lock_irqsave(&hba->reg_lock, flags);
>   	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	spin_unlock_irqrestore(&hba->reg_lock, flags);
>   
>   	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
>   					CONTROLLER_ENABLE, CONTROLLER_DISABLE,

Hi Avri,

How about proceeding as follows for ufshcd_hba_stop():
* Remove the comment above the ufshcd_writel() call and add a
   disable_irq() call instead.
* Call enable_irq() after ufshcd_writel() has finished and before
   ufshcd_wait_for_register() is called.
* Do not hold any lock around the ufshcd_writel() call.

Although the legacy interrupt is disabled by some but not all
ufshcd_hba_stop() callers, I think it is safe to nest disable_irq()
calls. From kernel/irq/manage.c:

void __disable_irq(struct irq_desc *desc)
{
	if (!desc->depth++)
		irq_disable(desc);
}

Thanks,

Bart.
