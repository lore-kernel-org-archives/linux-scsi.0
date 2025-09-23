Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5D71CAA92
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758643656; cv=none; b=VMuwAtOUKH/dx1OnN1uNc/S1FMPLrA6pRR8chmnw2zb1qWrsXIJEDJj9Z87tQYqdpgXgfDfwMCVDu3A3x2hJDf2ZV1hAFJeLFYxbWqfmpFAnqntK4G8z33RzKUDnp+uP2U8wmM+P2k3AeriiC40X5rNqqQoZM7GHAo2t7Ytn4fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758643656; c=relaxed/simple;
	bh=ZYbnHFvEDrSBovX4ZJeL9LBljBSikTM/e7Ib9zjjw/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FlegfUduuCGNikdBRrMvjKrDxrlP7KFRLsr4cncjgiq+lrIarjEZ4nD4HkPl5HPFOE2mxfJWidcLoyJBW9/QcPWsyVIDfNFwAECTlNe0sgDZDLkxj6pCa3lXS+Hj2ssg3udj/DrGeeg/7E8l4tivMdjoVzyvh7VmvyQtpggc5V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Qpi7tVSN; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Qpi7tVSN"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cWPyF6CCgzm0yVX;
	Tue, 23 Sep 2025 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758643650; x=1761235651; bh=zbruSP7rTY8HLsD8zPBU4YUA
	1qQNLZSLfDKDdyydwSQ=; b=Qpi7tVSNMRGbdpE68cf5HnEM+xqaPx8crt3tHpI8
	Un1gYwGMh0wykFD6zZaTTBQrVWTGlRyiho+3FU65ahZ77IKxYnj0k95OCri3XH+D
	HC/VcVmsXfPnw+w6yFXJjRioorYKhtFgDM6Hn6MMXor4ZJKcShmHkwGj3Z1pA8c8
	pXL8YzcIJ0GlNtYauxLS+W0l+IdVH/ZoCUtBSJcxAgw0Ne7pyXA3Zo5E26Y0/t3U
	wxXIfDtZQKNAT3pGYmxNFqAMAs0SU0wAZAJ7Z04WnTDeamqQhyphQAoZcxMQ0731
	jX1GgpO0aOMdIjTK1pYh7vflQgU9YlvTx/iyAEFZOTT2Iw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Tm3RX5dzHQSk; Tue, 23 Sep 2025 16:07:30 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cWPxn2PtTzm1743;
	Tue, 23 Sep 2025 16:07:07 +0000 (UTC)
Message-ID: <ecc17025-692d-45fe-97eb-9cc4c4ce7a06@acm.org>
Date: Tue, 23 Sep 2025 09:07:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Fix runtime suspend error deadlock
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250923082147.2491450-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250923082147.2491450-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/25 1:20 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> Resolve the deadlock issue during runtime suspend when an
> error triggers the error handler. Prevent the deadlock
> by checking pm_op_in_progress and performing a quick recovery.
> This approach ensures that the error handler does not wait
> indefinitely for runtime PM to resume, allowing runtime
> suspend to proceed smoothly.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Tested-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 88a0e9289ca6..0735bd5df1cc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6681,6 +6681,11 @@ static void ufshcd_err_handler(struct work_struct *work)
>   	}
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
> +	if (hba->pm_op_in_progress) {
> +		ufshcd_link_recovery(hba);
> +		return;
> +	}
> +
>   	ufshcd_err_handling_prepare(hba);
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);

Does this patch introduce a race condition? Can a power management
operation start after hba->pm_op_in_progress has been tested and before
ufshcd_err_handling_prepare() is called? Should the added code perhaps
be surrounded with ufshcd_rpm_get_noresume() and ufshcd_rpm_put()?

Thanks,

Bart.
