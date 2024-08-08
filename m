Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E57137776;
	Thu,  8 Aug 2024 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723137398; cv=none; b=GLt3vLhzgoN104PaRjgQI4YwMdLd0btITf7iyu4HJIIn4VpdiubUdT0WvmgCV17ZQTFdccNyQMR4zdqF8B7GXnn8NSSux6lTlZzKTUbJs7U1rSSHzcZFJ8i+blqffhTMMAj5cR+2P4DMpj9vYvyYeM/UIkDBwnu4ScXH7Vc0wvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723137398; c=relaxed/simple;
	bh=YCEks2jSYE+Y+beWjU9A08zC4ZKnR2oVQuBWf9QRUP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nF/gXAXMh9Z4h8uCxwPpRG31G3QbxMGP2qLx3re7KMA/F+ZgcKtjjU31i4Bv/phh5dpc5XZQwZuA/H63Gw1vMELgoCnRt/NDiRQ/NWiPF+MMbSDNTslcBY4IdXeB2ZaVhe9k4FrahYjYgQ995nx5CU9/j/rs2mVbM98kYZ6R/yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BkRSzsC3; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BkRSzsC3"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wftxc1BMyzlgVnF;
	Thu,  8 Aug 2024 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723137391; x=1725729392; bh=5z/+6d3TBHzOihEc5ritmsUc
	TMc3HUf7Lt4I6AXLv3s=; b=BkRSzsC3cp/phSg9k67c1unrgu9Eq93H/A1dtoHD
	xMOXI8XXRcSqG6pXMjPty3huhvIu1uJ5HQSLK7pjPh3bN+LO7APeT9pCo8Eaoegf
	MVI4SfIIc52Zl+LVbyyK1vV2X23Av5Q1GyqvNb9hMS5aRhR88hOy4lBCObDt55Q2
	l4Xrpwat0+14A4H0FODlgVrYSuZ7YXTgASMJCzUSxGgHtm6Sh0FngCMc0TehXsta
	Yk5K3E5u8D6MSQtLv/N1+niDv0hyMkIEGHkN203sfPEHMvbdJ3MH1+oW+5TPeTCf
	cNbbsdA7qhKqQkhaOJPJJJSBik9rtp7DpcYXTv4ICkl/Mg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WfVJzHCZUj_l; Thu,  8 Aug 2024 17:16:31 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WftxR2LMLzlgTGW;
	Thu,  8 Aug 2024 17:16:27 +0000 (UTC)
Message-ID: <1ab182e1-775e-4f44-85f2-6262530c99b9@acm.org>
Date: Thu, 8 Aug 2024 10:16:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Add missing check for alloc_ordered_workqueue
To: Ma Ke <make24@iscas.ac.cn>, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 ahalaney@redhat.com, beanhuo@micron.com, subhashj@codeaurora.org,
 quic_asutoshd@quicinc.com, vviswana@codeaurora.org, quic_cang@quicinc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20240808055400.2784028-1-make24@iscas.ac.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240808055400.2784028-1-make24@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 10:54 PM, Ma Ke wrote:
> As it may return NULL pointer and cause NULL pointer dereference. Add check
> for the return value of alloc_ordered_workqueue.
> 
> Cc: stable@vger.kernel.org
> Fixes: 10e5e37581fc ("scsi: ufs: Add clock ungating to a separate workqueue")
> Signed-off-by: Ma Ke <make24@iscas.ac.cn>
> ---
>   drivers/ufs/core/ufshcd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5e3c67e96956..41842f2cd454 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2139,6 +2139,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
>   		 hba->host->host_no);
>   	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
>   					WQ_MEM_RECLAIM | WQ_HIGHPRI);
> +	if (!hba->clk_gating.clk_gating_workq)
> +		return;
>   
>   	ufshcd_init_clk_gating_sysfs(hba);

This patch doesn't solve anything since hba->clk_gating.clk_gating_workq
is not used in ufshcd_init_clk_gating() after that workqueue has been
created. Additionally, this patch doesn't prevent that the UFS driver
will attempt to queue work on hba->clk_gating.clk_gating_workq if
allocation of that workqueue fails. If it would be possible to vote on
Linux kernel patches, my vote would be -2.

Bart.


