Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443C7AD4B;
	Wed, 22 Jan 2025 19:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737573341; cv=none; b=a67JnWbprqfUcQmsAtRopHa/y96urgmLlSjMojNhXEO81zYAtLXN6j95sm/zstEZnHzU3rn/tfy2fPoRAwiI2xJ4wtyOXlzb4mFTCMBDy3PrIhwqkKI20WYouP2481q7qDCQkBIdfbNLSotFg0TJxANaauzMWziwYIYdSuxSspI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737573341; c=relaxed/simple;
	bh=g96BqT8SVveiYsu680Vbw80CH/h9KOdOwn5ASWRgqy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UkRM5nEzBt2ZdmSTqkPe+R47Q3xmRAynXRco8wNd6m8hSb+wvWyK30WjNLtejeGzGIKn7qRl2qUhG6lhV/bgxpgoD6X44V0ayxfLH5YyIpFuBnWT0iYDkDYmazqAUe1Rsnv3XD/4XsJ2kHyP1XlbHnTyARe1tR15+c32GuofZFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FkysueDh; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FkysueDh"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YdYgt4JPvzlgMVb;
	Wed, 22 Jan 2025 19:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1737573334; x=1740165335; bh=EirrPfwzbhTSAcLd57hedRna
	Cf/4chopTtE4+AKUp1E=; b=FkysueDhq/Zp0hvDkEoZWA7FPlVXN6rOcgGB5I5C
	IKJc+qi6RlA2rqoxJ3s6TqqB/ZT7aKFBqELNrOfjeMvg7oDdp8+ME8DA+lOX9ptQ
	JwoVD4nf7YhFAeNf0i8s8gqt+dfw2yiNJdbznokBvalr7ZslA/mtoV3IgfCpMvUm
	0ggEmpxkF0BpVzrdz6Iu7KujW12UFLFt22s2mLC6mAzsDM09+vSVRsqQDEKbC8wG
	hpXij+h/63iAWrkO8xAm/F6In1SCrKSa9jRay7Egm0ikGVZ734cPnTW4qHhwZYxm
	b72NYu0s2L2HBznxZvSd6sOoOIi/SDzYSBNGg1T8E8+kmA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jFi6K3CUdDVC; Wed, 22 Jan 2025 19:15:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YdYgm4GBDzlgVnN;
	Wed, 22 Jan 2025 19:15:32 +0000 (UTC)
Message-ID: <4b3a1e3d-b555-4791-ba8b-73986c07c1b9@acm.org>
Date: Wed, 22 Jan 2025 11:15:30 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
References: <20250122062718.3736823-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250122062718.3736823-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 10:27 PM, Avri Altman wrote:
> This commit addresses a lockdep warning triggered by the use of the
> clk_gating.lock before it is properly initialized. The warning is as
> follows:
> 
> [    4.388838] INFO: trying to register non-static key.
> [    4.395673] The code is fine but needs lockdep annotation, or maybe
> [    4.402118] you didn't initialize this object before use?
> [    4.407673] turning off the locking correctness validator.
> [    4.413334] CPU: 5 UID: 0 PID: 58 Comm: kworker/u32:1 Not tainted 6.12-rc1 #185
> [    4.413343] Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
> [    4.413362] Call trace:
> [    4.413364]  show_stack+0x18/0x24 (C)
> [    4.413374]  dump_stack_lvl+0x90/0xd0
> [    4.413384]  dump_stack+0x18/0x24
> [    4.413392]  register_lock_class+0x498/0x4a8
> [    4.413400]  __lock_acquire+0xb4/0x1b90
> [    4.413406]  lock_acquire+0x114/0x310
> [    4.413413]  _raw_spin_lock_irqsave+0x60/0x88
> [    4.413423]  ufshcd_setup_clocks+0x2c0/0x490
> [    4.413433]  ufshcd_init+0x198/0x10ec
> [    4.413437]  ufshcd_pltfrm_init+0x600/0x7c0
> [    4.413444]  ufs_qcom_probe+0x20/0x58
> [    4.413449]  platform_probe+0x68/0xd8
> [    4.413459]  really_probe+0xbc/0x268
> [    4.413466]  __driver_probe_device+0x78/0x12c
> [    4.413473]  driver_probe_device+0x40/0x11c
> [    4.413481]  __device_attach_driver+0xb8/0xf8
> [    4.413489]  bus_for_each_drv+0x84/0xe4
> [    4.413495]  __device_attach+0xfc/0x18c
> [    4.413502]  device_initial_probe+0x14/0x20
> [    4.413510]  bus_probe_device+0xb0/0xb4
> [    4.413517]  deferred_probe_work_func+0x8c/0xc8
> [    4.413524]  process_scheduled_works+0x250/0x658
> [    4.413534]  worker_thread+0x15c/0x2c8
> [    4.413542]  kthread+0x134/0x200
> [    4.413550]  ret_from_fork+0x10/0x20
> 
> To fix this issue, we use the existing `is_initialized` flag in the
> `clk_gating` structure to ensure that the spinlock is only used after it
> has been properly initialized. We check this flag before using the
> spinlock in the `ufshcd_setup_clocks` function.
> 
> It was incorrect in the first place to call `setup_clocks()` before
> `ufshcd_init_clk_gating()`, and the introduction of the new lock
> unmasked this bug.
> 
> Fixes: 209f4e43b806 ("scsi: ufs: core: Introduce a new clock_gating lock")
> Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f6c38cf10382..a778fc51ca2a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9142,7 +9142,7 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
>   			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
>   				clk_disable_unprepare(clki->clk);
>   		}
> -	} else if (!ret && on) {
> +	} else if (!ret && on && hba->clk_gating.is_initialized) {
>   		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
>   			hba->clk_gating.state = CLKS_ON;
>   		trace_ufshcd_clk_gating(dev_name(hba->dev),

Has it been considered to move the spin_lock_init(&hba->clk_gating.lock)
call from ufshcd_init_clk_gating() such that it occurs before its first
use, e.g. just before the ufshcd_hba_init() call in ufshcd_init()?

Thanks,

Bart.
