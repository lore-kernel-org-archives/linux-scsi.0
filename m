Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBBF1A8F63
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 05:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742277314; cv=none; b=gMqo1o8JyWmNrHRgVBonrGjS3fPSFSW2Uu62esLqEh1jTbzSa93wK65K4v6L5qz8C2QqAvAqPntmgvMvEkx4bV+Y3qgsV1OsGDN8Wq1w+BwgdpwUyB4aKIXzCcT1BmwMvglpeLpiaqx6sdjlB/bVxFmF6QVe0/vOvHNk4E3ZC6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742277314; c=relaxed/simple;
	bh=rTC0hy1npeusD+pHEhc1NJOVNFWA0AEtSORX8wWQI+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuhvXsCY63s4k6/EIUaxsDx5rgCTEGO1VzbStm7MNhpJwCQif91du17xSDHtTawPPiePttEJL1FZv8q2Xi5sWtDWsL1/Gf7XraluvRHFr+xGkeaDsR2Bl7k77ZUG36SpBo8tpl34Lo9gzfAKf5YgytvkLiC4ra5JruJxnoc/N+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FdOUXVQB; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FdOUXVQB"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-300f92661fcso4470961a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 22:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742277311; x=1742882111; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D+BZ3c/ejBcztfBOuDhdrgt/dZHwQO7qmRn37C3opVM=;
        b=FdOUXVQB3QDIPAO+F7mmQNvJ+bvF2PSC7ro9x55GTF/ykLB+VnOOcatxq+XZ2O/Dvg
         G0V8DxaWOthJVIbcWolIPQVAIc4hIS7HzAhSLqZsaRPatTJUK3WwLMzfMByMDII4cU6M
         ebojUoBU356nKzbFK15dgNXvuEZejjj7ucAGscQLoGJi+MCR2iiYrCv90tIrDymjaqAn
         fWWAgPxf2zLXJW2Qo/csiwOORZ6HvprlesF3kHDnRsnp7UYvkf48P6yO0rXqBhkenX75
         wv/APQ/JJurSBTpOi+iN2PDOtFBM8a1BMOE9NDQ833f0RKKG2gqTqE/jsckZQvYQCkAk
         WyyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742277311; x=1742882111;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+BZ3c/ejBcztfBOuDhdrgt/dZHwQO7qmRn37C3opVM=;
        b=XFdoKTSPnbERmR5bNNQr/ITQJ9wGhQI7ZFNCZV8gKE1q6LSRWzTK82f290dTeVC0hS
         shJr+gcA6l85fhKGSg4mJ+1nt2rr7yWOhn2hBd2AxEIIgk/07BaOKXDjjLPZnIYczw/Z
         iCrJBBjsY8TAZJ9bwjQVLEBOeuREDo6jsfickJuz1rrZOjYyGSnM0O73b5rjnp0nyrJq
         QCCZu66DB9Dey2bsFHkmbuYUdEzpDoqjCFUJhKJYQ+RrwezA0uR1OBNJN8t8lUSPjoCS
         owPW3nlIVWXgYA3IPEVK0aI/bkDTjlMVOs30R5/GEffO379DhRKDLbxzszxNlTq1B2VR
         gE5A==
X-Forwarded-Encrypted: i=1; AJvYcCUvuT3YLWnoyufKk4H2AdSy617w78R3ch3OerO0BLCF7qS7BkxDiW+itFUup2X4HUwomL010HIOSxIQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxIId1f+p3WmrHJipk/w4KZdeg5YRjFY5QVaPFEaoGxKs0bnr8j
	6uwtnKIctmv5nP9bPh713OK5syZ4vWgN94aPgDXuygABEviqWRZFtulVTak52w==
X-Gm-Gg: ASbGncvNZ65hL4uzRwep4KCCSKA3tC86sPhbiQJ9NocE5H7oZdVU/slGkPps1PO0cpo
	flIoi2l30gC3s0O/NOXsZu4DH98b8sWNiGz6lFj3VfAx0VZt8Iilsz+uoipmZLsZ1KpWqIU2MMv
	KFeq8fRwpw9IB2mmzu9alE8Nr0DjjxrA/14DtX1KmPsXA+DQ0rHPMAqIpgYnCWxXif7GyXFyWMf
	jNe9vkXUAYUoKW9XOCPwpWfUl/YuIG0J3+cPwI+M6HrLMzqmyyoKsjTnAUnOhOc3YyfyIt4PY74
	MpwUvA/Ukhb7/Ydl8sflFa/vyjRiZpuvnNvwJd8K+iI2pKiBB/jwiXoe
X-Google-Smtp-Source: AGHT+IGUNLtROl66V0K63WPG8RGa89qgTgQjbzVFC/wAuXSmhpqfSId3mOtA9sk5t/PXh0pRfE5qWA==
X-Received: by 2002:a17:90b:3dc3:b0:2ee:db8a:2a01 with SMTP id 98e67ed59e1d1-301a5bc0dbamr1673620a91.30.1742277311434;
        Mon, 17 Mar 2025 22:55:11 -0700 (PDT)
Received: from thinkpad ([120.56.195.170])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301534f49efsm7196943a91.7.2025.03.17.22.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 22:55:10 -0700 (PDT)
Date: Tue, 18 Mar 2025 11:25:05 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: "qiwu.chen" <qiwuchen55@gmail.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, beanhuo@micron.com, ahalaney@redhat.com,
	ebiggers@google.com, minwoo.im@samsung.com,
	linux-scsi@vger.kernel.org, "qiwu.chen" <qiwu.chen@transsion.com>
Subject: Re: [PATCH] ufs: fix deadlock for the case of pm shutdown during
 suspend transition to resume
Message-ID: <20250318055505.zihbxmheku43zolv@thinkpad>
References: <20250311084257.8989-1-qiwu.chen@transsion.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250311084257.8989-1-qiwu.chen@transsion.com>

On Tue, Mar 11, 2025 at 04:42:57PM +0800, qiwu.chen wrote:
> There is a deadlock when triggers pm shutdown during suspend-to-idle state transition
> to resume. Here are the issue reproduce steps:
> 1. System enter suspend-to-idle transition and execute suspend callbacks for given devices
> in dpm_suspend(). The suspend callback of ufshcd_wl device - ufshcd_wl_suspend() will down
> hba->host_sem which is supposed to up in ufshcd_wl_resume(). Here is main call trace:
> enter_state
>     suspend_devices_and_enter
>         dpm_suspend_start
> 	    dpm_suspend
> 		device_suspend
> 		    ufshcd_wl_suspend
> 			down(&hba->host_sem) //hold host_sem
> 
> 2. Someone triggers shutdown due to low battery during suspend transition.
> The shutdown flow will hold device lock and execute shutdown callback for given devices
> in device_shutdown(). The shutdown callback of ufshcd_wl device - ufshcd_wl_shutdown()
> will hold ufshcd_wl's device lock and blocked to down hba->host_sem unfortunately.
> Here is the blocked trace of shutdown thread:
> __switch_to+0x174/0x338
> __schedule+0x608/0x9f0
> schedule+0x7c/0xe8
> schedule_timeout+0x44/0x1c8
> __down_common+0xbc/0x238
> __down+0x18/0x28
> down+0x50/0x54
> ufshcd_wl_shutdown+0x28/0xb4   //blocked to down host_sem
> device_shutdown+0x1a0/0x254    //get device lock
> kernel_power_off+0x3c/0xf0
> power_misc_routine_thread+0x814/0x970
> kthread+0x104/0x1d4
> ret_from_fork+0x10/0x20
> 
> 3. Meanwhile, the suspend-to-idle transition is aborted by a wakeup source and go to handle
> resume works, the resume work will be blocked in holding ufshcd_wl device lock forever.
> Here is the blocked trace of resume work:
> __switch_to+0x174/0x338
> __schedule+0x608/0x9f0
> schedule+0x7c/0xe8
> schedule_preempt_disabled+0x24/0x40
> __mutex_lock+0x408/0xdac
> __mutex_lock_slowpath+0x14/0x24
> mutex_lock+0x40/0xec
> __device_resume+0x50/0x360    //blocked in holding device lock, deadlock!
> async_resume+0x24/0x3c
> async_run_entry_fn+0x44/0x118
> process_one_work+0x1e4/0x43c
> worker_thread+0x25c/0x430
> kthread+0x104/0x1d4
> ret_from_fork+0x10/0x20
> 
> Fix the deadlock issue by using atomic operation instead of sleep lock for shutting_down state check.
> 

Using atomic_t for a boolean variable is fundamentally wrong. atomic_t is only
meant for RMW operations. If you care about preventing compiler
optimization/reordering, just use {READ/WRITE}_ONCE.

> Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
> ---
>  drivers/ufs/core/ufshcd-priv.h |  2 +-
>  drivers/ufs/core/ufshcd.c      | 21 +++++++++------------
>  include/ufs/ufshcd.h           |  2 +-
>  3 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index 786f20ef2238..76d323de42f9 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -8,7 +8,7 @@
>  
>  static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
>  {
> -	return !hba->shutting_down;
> +	return !atomic_read(&hba->shutting_down);
>  }
>  
>  void ufshcd_schedule_eh_work(struct ufs_hba *hba);
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3094f3c89e82..b0f5152e5b04 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1729,12 +1729,10 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
>  	if (kstrtou32(buf, 0, &value))
>  		return -EINVAL;
>  
> -	down(&hba->host_sem);
> -	if (!ufshcd_is_user_access_allowed(hba)) {
> -		err = -EBUSY;
> -		goto out;
> -	}
> +	if (!ufshcd_is_user_access_allowed(hba))
> +		return -EBUSY;
>  
> +	down(&hba->host_sem);
>  	value = !!value;
>  	if (value == hba->clk_scaling.is_enabled)
>  		goto out;
> @@ -6416,8 +6414,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>  
>  static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
>  {
> -	return (!hba->is_powered || hba->shutting_down ||
> -		!hba->ufs_device_wlun ||
> +	return (!hba->is_powered || !hba->ufs_device_wlun ||
>  		hba->ufshcd_state == UFSHCD_STATE_ERROR ||
>  		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
>  		   ufshcd_is_link_broken(hba))));
> @@ -6541,10 +6538,13 @@ static void ufshcd_err_handler(struct work_struct *work)
>  	dev_info(hba->dev,
>  		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = %d; saved_uic_err = %d; force_reset = %d%s\n",
>  		 __func__, ufshcd_state_name[hba->ufshcd_state],
> -		 hba->is_powered, hba->shutting_down, hba->saved_err,
> +		 hba->is_powered, atomic_read(&hba->shutting_down), hba->saved_err,
>  		 hba->saved_uic_err, hba->force_reset,
>  		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
>  
> +	if (!ufshcd_is_user_access_allowed(hba))
> +		return;
> +
>  	down(&hba->host_sem);
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (ufshcd_err_handling_should_stop(hba)) {
> @@ -10194,10 +10194,7 @@ static void ufshcd_wl_shutdown(struct device *dev)
>  	struct scsi_device *sdev = to_scsi_device(dev);
>  	struct ufs_hba *hba = shost_priv(sdev->host);
>  
> -	down(&hba->host_sem);
> -	hba->shutting_down = true;
> -	up(&hba->host_sem);

No locking needed just for 'hba::shutting_down', unless the variable it tied to
any block of code.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
