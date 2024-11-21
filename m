Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772FB6F06B;
	Thu, 21 Nov 2024 20:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732221871; cv=none; b=SYQUDw6ZKm0B94uurJsgd6QC9MDbLkXUjzpPtpT0/JpGEpIGmDAzabbHKIFl5kawTpUzlzi0+wzucAOE51RHgJ9j8hU6wAaHCDBoZz1T3DDvNSc1qGWdwNk4/2crngvxXYHkmRDyHur2MXFqxuLho3MZeKDXYk8YxaS8FGPFwW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732221871; c=relaxed/simple;
	bh=wJ5sdqU+h1FpA4uoQmUYeoZU00L0h7RpzZyFK+H9unE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jznQx7DxTGDjPyDeTUxpz6YwCiHLRWCQFj/at4tkNm/un0rhRWKObQqVZb60Fx7GD3lr32dkJlah0TXErJeSe0PyinS/KRs44HuH4UCTPo94rPNnPyVDZHDA2usDHAPhfH1oqjdPgTVGbNiWTokBqWngz1wj6/GWHIV3RRU00Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ms9w8eeF; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ms9w8eeF"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XvVb06LZDz6CmQvG;
	Thu, 21 Nov 2024 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732221865; x=1734813866; bh=xSjvxIJm/rBn1WXHiH+xsQTT
	Era6sqooRTecPptXB/E=; b=ms9w8eeFxn1T3UhejvFcklXPmOfhOyVtp/TRXIFr
	oTSSoCcsew3TZD1V6Lm/IW5kbN2Q3oZidnWoBrHOkKNXMj3WIbvXihfBvZNODyTJ
	wU7GCW1RzaBaSKmdFHAXXXj5+J8D1sgFjcUhIkrdGxxIbSZm9IQsL4RamXljo22y
	R6uXdqRPxBmMISPracyX4rzRwEPh8oTjvUZC+jen7JbwtS0mWg6RcU4zwc2bzWsJ
	FeYkHidKr86SGJn3QpY0AqXynji5GWwVPVFgsN7W51ijupN7+i2ADYVEZ7irEcuy
	ha0T6DZRIVvgKSt7YddXt4FT6Wh2P0RMRUZqTiuEPoME6g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2Qe2q8k669Hk; Thu, 21 Nov 2024 20:44:25 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XvVZw3K8Qz6CmQyY;
	Thu, 21 Nov 2024 20:44:24 +0000 (UTC)
Message-ID: <2955aa00-824d-4803-96f6-35575ae9560e@acm.org>
Date: Thu, 21 Nov 2024 12:44:23 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] scsi: ufs: core: Introduce a new clock_gating lock
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bean Huo <beanhuo@micron.com>
References: <20241118144117.88483-1-avri.altman@wdc.com>
 <20241118144117.88483-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241118144117.88483-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 6:41 AM, Avri Altman wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index be5fe2407382..638d9c0e2603 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1816,19 +1816,17 @@ static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
>   static void ufshcd_ungate_work(struct work_struct *work)
>   {
>   	int ret;
> -	unsigned long flags;
>   	struct ufs_hba *hba = container_of(work, struct ufs_hba,
>   			clk_gating.ungate_work);
>   
>   	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
>   
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	if (hba->clk_gating.state == CLKS_ON) {
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> -		return;
> +	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
> +	{
> +		if (hba->clk_gating.state == CLKS_ON)
> +			return;
>   	}

Here and elsewhere, please move "{" to the end of the "scoped_guard()"
line since that is the style used in all other Linux kernel code (I know
that clang-format gets this wrong).

>   /* host lock must be held before calling this variant */

Please remove this comment since your patch makes it incorrect and
replace it with a lockdep_assert_held() call.

> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	if (ufshcd_has_pending_tasks(hba) ||
> +	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		return;
> +	}
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);

Why explicit lock/unlock calls instead of using scoped_guard()?

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index d7aca9e61684..8f9997b0dbf9 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -403,6 +403,8 @@ enum clk_gating_state {
>    * delay_ms
>    * @ungate_work: worker to turn on clocks that will be used in case of
>    * interrupt context
> + * @clk_gating_workq: workqueue for clock gating work.
> + * @lock: serialize access to some struct ufs_clk_gating members

Please document that @lock is the outer lock relative to the host lock.

Thanks,

Bart.
