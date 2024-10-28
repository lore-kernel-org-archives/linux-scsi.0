Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70861E009C;
	Mon, 28 Oct 2024 20:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730145895; cv=none; b=UmAgfG607kiS/68nhUAc+sMyHS4zaIooeVO730MIb0qzTwek4rjzGHQ9505Rr6S/Y1D8OKYG+0mMX5aEZwM0IR5dD0ZBUzhgHxzX8SDaXscIh5NvqIG5xxCrHvb5nKQntXoISVIE8UBjyrvcPOSLjQE/fY+Bm2P9ja9pUmHL4yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730145895; c=relaxed/simple;
	bh=98Gf1163nXdxmh5Ws88MulxdhCDgARTvcJ9NEek2Oo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUW2tsgTr/UMEmxd1uEhKHShwzM6Cmtop9IUZj1LHIOznZa2Qt8FuNpmyAWOakqXthBc9BO/lNQ9sEUt1ELcVCjBW6PmKfGstyFfEGR418w+7HPa8gJPCLKYXw0oScQxhRNfJ+4cuXdpx6JdA+yV3Y2dNQxnmNu/S/SoaYlSwZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=47CJgj4P; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="47CJgj4P"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XckrP12TYz6Cnk9N;
	Mon, 28 Oct 2024 20:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730145890; x=1732737891; bh=8ta/AFVX4qafZmAMUdAs4ntk
	nK/4hnAg3wG6yt/M7VY=; b=47CJgj4PPk98Oq9u8b+IhsY0zjCXG4SyK1fQH2oo
	XAIA9VumqQ8gZmR0HlGV1Ll8mlVwtXfDWbqR3HspU/LJAzRdgVDm2F0sf/MKl8bB
	WjdYrhNz33sD8V8O+2KjwMmGTqsUf1eScDQ5JdrDg6sq+kkw0c8EzF2nJdToaylV
	x/hnQxeEF8jC6e7cJYgF2yaRL4qvjtb1efbNYohb0RBsABM6DYcm/mQY/Zox7VKV
	UCiwdN9l3vSBy8pPyfFxqDblLMU5TA7e7Yg2j277zdKwC0q6JQxyRwCkehnWNsYT
	8Xu7KeosWPvkqHJ04+r6vJQusNcZvmBrKHkjxqbnRjWcEw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id h-RQX4FkSRh9; Mon, 28 Oct 2024 20:04:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XckrJ6wgfz6Cnk9M;
	Mon, 28 Oct 2024 20:04:48 +0000 (UTC)
Message-ID: <242b1d10-2c11-4bb3-8f77-c939ecb5f1a0@acm.org>
Date: Mon, 28 Oct 2024 13:04:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Introduce a new clock_gating lock
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241027082519.576869-1-avri.altman@wdc.com>
 <20241027082519.576869-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241027082519.576869-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/24 1:25 AM, Avri Altman wrote:
> Introduce a new clock gating lock to seriliaze access to the clock
                                        ^^^^^^^^^
                                        serialize

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 099373a25017..b7c7a7dd327f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1817,13 +1817,13 @@ static void ufshcd_ungate_work(struct work_struct *work)
>   
>   	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
>   
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	spin_lock_irqsave(&hba->clk_gating.lock, flags);
>   	if (hba->clk_gating.state == CLKS_ON) {
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
>   		return;
>   	}
>   
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
>   	ufshcd_hba_vreg_set_hpm(hba);
>   	ufshcd_setup_clocks(hba, true);

This would be a great opportunity to replace the spinlock calls with
scoped_guard(), isn't it?

> @@ -1928,7 +1928,7 @@ static void ufshcd_gate_work(struct work_struct *work)
>   	unsigned long flags;
>   	int ret;
>   
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	spin_lock_irqsave(&hba->clk_gating.lock, flags);
>   	/*
>   	 * In case you are here to cancel this work the gating state
>   	 * would be marked as REQ_CLKS_ON. In this case save time by
> @@ -1946,7 +1946,7 @@ static void ufshcd_gate_work(struct work_struct *work)
>   	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
>   		goto rel_lock;
>   
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);

Same comment here: please consider using scoped_guard().

>   	/* put the link into hibern8 mode before turning off clocks */
>   	if (ufshcd_can_hibern8_during_gating(hba)) {
> @@ -1977,14 +1977,14 @@ static void ufshcd_gate_work(struct work_struct *work)
>   	 * prevent from doing cancel work multiple times when there are
>   	 * new requests arriving before the current cancel work is done.
>   	 */
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	spin_lock_irqsave(&hba->clk_gating.lock, flags);
>   	if (hba->clk_gating.state == REQ_CLKS_OFF) {
>   		hba->clk_gating.state = CLKS_OFF;
>   		trace_ufshcd_clk_gating(dev_name(hba->dev),
>   					hba->clk_gating.state);
>   	}
>   rel_lock:
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
>   out:
>   	return;
>   }

ufshcd_gate_work() can be simplified by using guard() and
scoped_guard().

> @@ -2015,9 +2015,9 @@ void ufshcd_release(struct ufs_hba *hba)
>   {
>   	unsigned long flags;
>   
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	spin_lock_irqsave(&hba->clk_gating.lock, flags);
>   	__ufshcd_release(hba);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);

For this function and also for later changes, please use guard().

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 9ea2a7411bb5..52c822fe2944 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -413,6 +413,7 @@ enum clk_gating_state {
>    * @active_reqs: number of requests that are pending and should be waited for
>    * completion before gating clocks.
>    * @clk_gating_workq: workqueue for clock gating work.
> + * @lock: serielize access to the clk_gating members
              ^^^^^^^^^
              serialize

I don't think that the added comment is correct - 'lock' is used to
serialize access to some struct ufs_clk_gating members but not for
serializing access to all members. Accesses to e.g. gate_work,
ungate_work and clk_gating_workq are not serialized. Please reorder the
struct ufs_clk_gating members as follows:
- Members that are not serialized first.
- Next, 'lock'.
- Finally, the members serialized by 'lock'.

I think it is common in Linux kernel code that structure members are
organized this way.

Thanks,

Bart.
