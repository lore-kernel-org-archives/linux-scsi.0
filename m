Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6790B1E480;
	Mon, 25 Nov 2024 23:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732576047; cv=none; b=mgKq59m/yKiqzSjtG41SayBsp4qxL9HZswGaAU6NnEkxKL7xgByAjgpZFO+YHDZa6QBAqzT2NLksKAsbTEd3QgOXneenohHePeiq9Ej0hfdcgDrhiaV1k2HsjhZZ5XL3m7hKBCaiH8pfZX6nYi20jeSP1KPqeE59B88fEJ9IxSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732576047; c=relaxed/simple;
	bh=+lfGohwuR97mU5HxNgXuGfnRwlDPqgNmpJ3ELBsOXjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f7X2W42w63e9ueytq9A9liBIudFyf6CoMvILT6Wrn/AGZ+TVXT27WNkGgguh7nRrBvhBctfFNqCRjz7g9+Beukg0f+BlUnD/HIa+EeS+CtejnyU2kwcFp8YwUVxYawUg7/o7PaP6Qh6otugI3MaxbKY2YRAG5rc3waJ3sooUS0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XAw4xmdx; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XAw4xmdx"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xy1Z458N2zlgVnN;
	Mon, 25 Nov 2024 23:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732576042; x=1735168043; bh=o9fVWxijBFqZDAMDhn0yP2y3
	eJvptu/TPVSxNtR12YU=; b=XAw4xmdx58Bcd4qXvRK69DLQTJbRfdOSxF3N93hH
	loZRRkVGfxUKs0lpP+avk0hIdLtjN/8g1hztyvrFWYvk8Tn6ckA90bpNsuCXDtGG
	sE0n9RZnd+0iOQUivMIs6S+d1FPi02K3WDlKiHqGqVDURxMcbrOnDyCLwarI3Cyj
	ydAUezVPWrXw1kJoGAd+DRiq+xL6Cw0k/ECXSuKLnr7H7tY3ABBF/7MjhRTtfgGb
	IifvNFwRaFrJkVWCcXYc4ZXEdUf/Glrn+LpiQap5egh9v8DB2FbNhikqRb+gUFSn
	YrLlmc7+w7vmfAQ2nvGPnRFDo4okVl8NUjv+aa4gX3Fs1A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Vj10AufvVppq; Mon, 25 Nov 2024 23:07:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xy1Z10bcdzlgVXv;
	Mon, 25 Nov 2024 23:07:20 +0000 (UTC)
Message-ID: <87f1bb6b-6a8e-4bfd-8c1f-d63c857a176e@acm.org>
Date: Mon, 25 Nov 2024 15:07:18 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Do not hold any lock in ufshcd_hba_stop
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241124110747.206651-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241124110747.206651-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/24 3:07 AM, Avri Altman wrote:
> This change is motivated by Bart's suggestion in [1], which enables to
> further reduce the scsi host lock usage in the ufs driver. The reason
> why it make sense, because although the legacy interrupt is disabled by
> some but not all ufshcd_hba_stop() callers, it is safe to nest
> disable_irq() calls as it checks the irq depth.
> 
> [1] https://lore.kernel.org/linux-scsi/c58e4fce-0a74-4469-ad16-f1edbd670728@acm.org/
> 
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index acc3607bbd9c..09a5ff49da5a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4811,16 +4811,11 @@ EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
>    */
>   void ufshcd_hba_stop(struct ufs_hba *hba)
>   {
> -	unsigned long flags;
>   	int err;
>   
> -	/*
> -	 * Obtain the host lock to prevent that the controller is disabled
> -	 * while the UFS interrupt handler is active on another CPU.
> -	 */
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	ufshcd_disable_irq(hba);
>   	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	ufshcd_enable_irq(hba);
>   
>   	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
>   					CONTROLLER_ENABLE, CONTROLLER_DISABLE,

Shouldn't the ufshcd_enable_irq() call be moved below the 
ufshcd_wait_for_register() call? Otherwise a race condition could cause
the interrupt handler to be triggered while the controller is being
disabled.

Thanks,

Bart.
