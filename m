Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E47118130D;
	Tue, 29 Oct 2024 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730225485; cv=none; b=HOfdpDEdwU0eUsvqBbZajAP5S5J06NzSHSGj1DnoL/z4mWqQMsdoUYSUvvRD/aROYqBt+dKOmbWsXNRZpAG27tBDqmO4/jVXR/D6JqrGNzOjs8QDnCkEnMFUArRr+fJsco/IoAiyCiXAB3k3ns7I4t1WyZl+uDZV0lsEwZt7KWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730225485; c=relaxed/simple;
	bh=9ox1v674Cs+EqDZWALs9Vbe/MWJ2VAF1Pe0EGOx/H6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k8AcVW2yizowDA53TjPAEWepTVRD/Js2ITUKz0cNRd9PUlmr5Llin3PRnVYDiVr4TTkt4yh5SolpL+oPrn10kYcN3M3PgB2gf/vrVDnYfRjN5HNncuxDBokWpEnYT/bzjFfw2JVjxfOy2vRcqgqXscGwqPHz+JvJ0UYn1u7eGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cslFGdPJ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cslFGdPJ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XdJGs34pLz6CmM6D;
	Tue, 29 Oct 2024 18:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730225475; x=1732817476; bh=Ck0LujQRxT7n4rIz6jg6e1Rc
	zz6xuk2yIdp0i7KBTFE=; b=cslFGdPJb+wG1sTf/oxGC/WPQH/BZlJqq0Op5Pej
	XLzXI0L+mLiQcV1/bJey5zG8wM6JT3vX0Kb58miIMV8Gf8hpgJSpbrnHGMeY+3aW
	1CJv5TqtnR4MX9rCHUmJYXYKxnLIlnXpNdE58HfECr7BWOsEWowV0WTRrZSXFEPW
	sjn5b6PJhAFJUWwh16E0ESMfv7prehbdqkACRFTPpLfVMzIQ5k3YW1xtNQl4sHvH
	xpeLi47ilDAMAxAPS1VOtmuvtzPekt4fDcU5MyAnV7MVh7ZHaGTxvmM8sB+5Yimr
	bjDCOQOYnlzmvGemTsGHXlU+4CzbHrx77dJbn8JEQ7mTBg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OxikW3QDgw6d; Tue, 29 Oct 2024 18:11:15 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XdJGn6zK8z6CmM5x;
	Tue, 29 Oct 2024 18:11:13 +0000 (UTC)
Message-ID: <611fc99e-c947-463a-82e1-9d2a68d67aa4@acm.org>
Date: Tue, 29 Oct 2024 11:11:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating lock
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241029102938.685835-1-avri.altman@wdc.com>
 <20241029102938.685835-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241029102938.685835-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 3:29 AM, Avri Altman wrote:
> +	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock) {
> +		/*
> +		 * In case you are here to cancel this work the gating state
> +		 * would be marked as REQ_CLKS_ON. In this case save time by
> +		 * skipping the gating work and exit after changing the clock
> +		 * state to CLKS_ON.
> +		 */
> +		if (hba->clk_gating.is_suspended || (hba->clk_gating.state != REQ_CLKS_OFF)) {
> +			hba->clk_gating.state = CLKS_ON;
> +			trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
> +			return;
> +		}
> +		if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
> +			return;
>   	}

Please remove the superfluous parentheses from around the REQ_CLKS_OFF 
test and do not exceed the 80 column limit. git clang-format HEAD^ can
help with restricting code to the 80 column limit.

> @@ -2072,18 +2055,18 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
>   
>   	value = !!value;
>   
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	if (value == hba->clk_gating.is_enabled)
> -		goto out;
> +	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock) {
> +		if (value == hba->clk_gating.is_enabled)
> +			goto out;
>   
> -	if (value)
> -		__ufshcd_release(hba);
> -	else
> -		hba->clk_gating.active_reqs++;
> +		if (value)
> +			__ufshcd_release(hba);
> +		else
> +			hba->clk_gating.active_reqs++;
>   
> -	hba->clk_gating.is_enabled = value;
> +		hba->clk_gating.is_enabled = value;
> +	}
>   out:
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   	return count;
>   }

Please use guard() instead of scoped_guard() and remove the "out:"
label.

> @@ -9173,11 +9157,10 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
>   				clk_disable_unprepare(clki->clk);
>   		}
>   	} else if (!ret && on) {
> -		spin_lock_irqsave(hba->host->host_lock, flags);
> -		hba->clk_gating.state = CLKS_ON;
> +		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
> +			hba->clk_gating.state = CLKS_ON;
>   		trace_ufshcd_clk_gating(dev_name(hba->dev),
>   					hba->clk_gating.state);
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
>   	}

The above change moves the trace_ufshcd_clk_gating() call from inside
the region protected by the host lock to outside the region protected
by clk_gating.lock. If this is intentional, shouldn't this be mentioned
in the patch description?

Thanks,

Bart.
