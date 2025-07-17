Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04B41BC9E2
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752774459; cv=none; b=EOanJWpweAf7cv0Dd9rY2kf1sL2v+yb5gCAEUxOpqDkFPGzjdVaB0nP6CxG0QaEggYqqhIWHhDW9LbGlTuM1SXhskdjSKmayBTshz0GKWDx6jjjTarYUWswyKnSzObU0aaYvc6nATmBYy3BEoWpt2W/gmwvE9PZUIunbiEs9ujo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752774459; c=relaxed/simple;
	bh=dA+yHrjkjOaVtmGJMYO7hse3EJTQLq52MQfJKcQagW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LGpYBGK+cl5amrjokMme7XYvbHzlIaIQYOlmfBYtPQTZvpoaxgiE32Np4b3saKXcy2aS0TyFNmJm+gGcLXlwGv6wih4y4J+WEDmPhWP8ZCPmoD/9ma7OkowskLbP5sGyluldDX665P6kl3ou4zpLE84n47B87sos6Uexez+UQQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZH3iJjdM; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZH3iJjdM"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjgNy6rBBzm0yQ1;
	Thu, 17 Jul 2025 17:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752774449; x=1755366450; bh=Wxc/D2OGZCJYQkLf7TYwnJjU
	RNKhMbd43jAkbR+GLDE=; b=ZH3iJjdMhycbVR/3/xFRmwGwzJR23YjsudUYmAOm
	4Ehp6u0voM/GUrr2WbPpPGAccak7s4fzuScRxk7p2Yx7SMKV6ncBz4b4BEICkDm2
	JVainCUqql1P03gju5dwqdcD2zbfeoonnC8aGq+vYHVLwSwKOX9dPUXv6+u6m5QY
	AEvOJDvXydQpD848h0wJ/nw6fpmiKRrsXfAp1VvKou8eL1XNqn1yOtxAx2ns+HJ3
	9Iq6H8sdpjBo0hPBZwjhBgTCuHs0yVsFD2BNbBFtsfQuExc/Itqoqq8C1QRW2rHO
	2xe8uxhy0Ef8Jjytnk0GdCeGQG8LsVrHOi249MVAPMnHoA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yLFKpMYn2FsV; Thu, 17 Jul 2025 17:47:29 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjgNp0mqczm1748;
	Thu, 17 Jul 2025 17:47:21 +0000 (UTC)
Message-ID: <2743ce40-72fa-4c87-a2cc-528b51418aec@acm.org>
Date: Thu, 17 Jul 2025 10:47:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
To: Seunghui Lee <sh043.lee@samsung.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 sdriver.sec@samsung.com
References: <CGME20250717081220epcas1p224952b344389e4967beb893297f1ae02@epcas1p2.samsung.com>
 <20250717081213.6811-1-sh043.lee@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250717081213.6811-1-sh043.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/25 1:12 AM, Seunghui Lee wrote:
> If the h8 exit fails during runtime resume process,
> the runtime thread enters runtime suspend immediately
> and the error handler operates at the same time.
> It becomes stuck and cannot be recovered through the error handler.
> To fix this, use link recovery instead of the error handler.
> 
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
> Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
> ---
> Changes from v1:
>   * Add the Fixes tag as Beanhuo's requested.
> ---
>   drivers/ufs/core/ufshcd.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 50adfb8b335b..dc2845c32d72 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4340,7 +4340,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>   	hba->uic_async_done = NULL;
>   	if (reenable_intr)
>   		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
> -	if (ret) {
> +	if (ret && !hba->pm_op_in_progress) {
>   		ufshcd_set_link_broken(hba);
>   		ufshcd_schedule_eh_work(hba);
>   	}
> @@ -4348,6 +4348,14 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   	mutex_unlock(&hba->uic_cmd_mutex);
>   
> +	/*
> +	 * If the h8 exit fails during the runtime resume process,
> +	 * it becomes stuck and cannot be recovered through the error handler.
> +	 * To fix this, use link recovery instead of the error handler.
> +	 */
> +	if (ret && hba->pm_op_in_progress)
> +		ret = ufshcd_link_recovery(hba);
> +
>   	return ret;
>   }

There are multiple calls to ufshcd_uic_pwr_ctrl() from outside the
runtime power management callbacks. Hence, hba->pm_op_in_progress may
be changed from another thread while ufshcd_uic_pwr_ctrl() is in
progress. Hence, ufshcd_uic_pwr_ctrl() calls from outside runtime power
management callbacks should be serialized against these callbacks, e.g.
by surrounding these calls with pm_runtime_get_sync() and
pm_runtime_put().

Thanks,

Bart.
