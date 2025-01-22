Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBD717BB6;
	Wed, 22 Jan 2025 08:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737533882; cv=none; b=tgAnMoZT5THachXxAmZnagLWw0PxAjdSGUImj09gZlHJTegEg9rKsmM/kvOGFjiVMFYhSTyvjfdkiMMXSvt5sdJJ7w8cAs2/rVi/tyMrE2UpgXKjRyLp7mQTioFulnMukRDPaDylNqK9rQEc3rzqV0VmozBpzybOtnTXsaAbuRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737533882; c=relaxed/simple;
	bh=avrHgzw1P9T9IXEVcGAxCrq39bXXjDj3GgFcHzxWilo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfjcEh8cVWubchabs4rF8is+BRwbvarEGT872ko1OnSpx1Jy40QCiQxYFgDEC6qsAtIM3Puw/SBd4cviV4nWkQcc8nGl+Ph/OD4+2bLLXb14YTToZaLSlaz2a791Jw+Kx+Nn5pFQdXibCwYr1wpYHIwmemAtALXpgPWjrdF4ygk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4crO4+g; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4crO4+g"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2163dc5155fso125593565ad.0;
        Wed, 22 Jan 2025 00:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737533881; x=1738138681; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wUstyvubTl7hy3nrLNdgIBtHnvkx8q+Mg1VvHXxjvSk=;
        b=m4crO4+gTcG6BIKkFscDAmtDFYwI2UUmon8GwS8f2pMvNoLK6j4p9GwfwSqDslE3tT
         Bq+zSyk588yrXZh/G2vANFerMbN6WEgXtU7O+D9VRcR/7hFXhFV5agOIfNKjJ1TsiV5g
         ZXadscestH0L+pEPEIc9Z2lRpadZWwK/OMPSh7q5rTmGEVSh0GF/LH/DbAcp9KqLmiap
         pkER9bBdbg5H4pBo5xXKdOXj777kkDyt76vUxYVrkFusO8T50fEkSv7NYphl5lcAxdUv
         PrUgdpO2mKzkKyZdRsqKlv4RFFvEqR87CLBTwltNWRg+6Vymyl4W5uVZTcPDrGjPDmfe
         eaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737533881; x=1738138681;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wUstyvubTl7hy3nrLNdgIBtHnvkx8q+Mg1VvHXxjvSk=;
        b=G6pflOED6ECmr7oc9WGhrXFdXEhClnyZHa6qaz2Wf8QhUSXU7Teazs6DvtZUStuBrR
         oXJxWFZZYsMM0Beejmw1LIFibyQRW5+PMcrtcphBZE/CMHzxWKHOmiGMfuZP8IULdZ4o
         6y3bLyH/c22VQDiueZ+IGLS79b0GYbGxOErgHBJVFVIc2imNqVKFz56DAXKCo329nUwO
         m+PrtiKQIyHTXiGQJbpxtoP/bw5gxW9hmIKcB/Y+9N+ACGzpXQhIho7rKu+FMYSjHhxs
         1vFt69m31GTKj/OdHyFjqi9qjg2N+E5kRaPEn5yDE5xgXlf+2Ubg29Lgbn9jT7Dc+ZXy
         4hWA==
X-Forwarded-Encrypted: i=1; AJvYcCX3RQuQrNtXNR24tdoss2eqMZYdUrHq1BrfMeqItRDGsokuKQfXB+ySQG0dJ/uyDkLxJoV55PcoVMm56z0=@vger.kernel.org, AJvYcCXriOmVqR8hqXP/LyqfYr536ObeWozESwF6+BSn04Pc/OXnJTmyjiNpzhx//8rbrGCgAzwO89ELYJgWTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjtJkbayJJZXAz+LaZzJGzfZoPcQc2qRtNOysncGo9bDoPSvir
	4QeDsTUfcp2tuRT0d7bce2sq9eH9RsI5uZWME6kg5xkmtor56ezr
X-Gm-Gg: ASbGnctV1LlBFzUdvdq+lXfAdRkMQ7FiPp9JMkoh3yDJ8wxZ9M7Doks08pxsrPoBSAx
	pPy2l3rqDai9vrMi0cbz8ADidDAym6U/MtT6FHPbBP0wj9XGF86XhS6Ih3xpb0yxYS+e0Efy/eL
	CQBGSrJm+sra0bzdt95LBRVqV239vE8de2RkGjJCRuLU8z9hYAC1I7tpmkTmp1fCzLYF1CtD+E1
	Eq+RmtfElhb/MaDfXiOSgELtuHDt7bohkmCeh8xvZlE/odjInu/geQXaqn/aQAndJZeHkyWnPG/
	PjHgDg==
X-Google-Smtp-Source: AGHT+IG4KfdrF7NSr1QBM9cmSA3q1u2DxrcVJIXDfeWeBt21+6O5ARk3wySU/M+13de54YWPEYv2aA==
X-Received: by 2002:a17:902:ea06:b0:216:45eb:5e4d with SMTP id d9443c01a7336-21c352c7921mr272257615ad.6.1737533880593;
        Wed, 22 Jan 2025 00:18:00 -0800 (PST)
Received: from thinkpad ([220.158.156.213])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2ceb73ccsm91251175ad.58.2025.01.22.00.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 00:18:00 -0800 (PST)
Date: Wed, 22 Jan 2025 13:47:56 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: Re: [PATCH] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Message-ID: <20250122081756.hehvpcbyl2nd3yvf@thinkpad>
References: <20250122062718.3736823-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250122062718.3736823-1-avri.altman@wdc.com>

On Wed, Jan 22, 2025 at 08:27:18AM +0200, Avri Altman wrote:
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

If calling setup_clocks() before ufshcd_init_clk_gating() is incorrect, why are
you not reordering it?

Checking for 'clk_gating.is_initialized' looks like a hack.

- Mani

> 
> Fixes: 209f4e43b806 ("scsi: ufs: core: Introduce a new clock_gating lock")
> Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/ufs/core/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f6c38cf10382..a778fc51ca2a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9142,7 +9142,7 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
>  			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
>  				clk_disable_unprepare(clki->clk);
>  		}
> -	} else if (!ret && on) {
> +	} else if (!ret && on && hba->clk_gating.is_initialized) {
>  		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
>  			hba->clk_gating.state = CLKS_ON;
>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
> -- 
> 2.25.1
> 

-- 
மணிவண்ணன் சதாசிவம்
