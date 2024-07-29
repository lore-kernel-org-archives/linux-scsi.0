Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C874515B555;
	Mon, 29 Jul 2024 18:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722277626; cv=none; b=ko9O0vTGSzk1GKZFpxv11pzSzJ93kBo/DgdLPRO2nRyfXEx0pSO+GP1a2SPbuK0xIdFb+uj7WvTVHXxPM6wcGCWdZJZdLsFi1Hjn1Y/Yg7voF1HjW+Egrc9Rzewr2PAOwXW+VtoQCit0s/b5jE7NgawlbcjOJSWT0D7uU55oKP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722277626; c=relaxed/simple;
	bh=wlIq9v2JKAyPHah0itV7ONk1dla/SjhLhFuvbZXtDyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YzzmLMO4t/ZrcqSz1HCuesJqoQT+qWtOxZlfRKQccb5INRgW8Bw2DzSZVkVhYRGcKUT93mRc52JM/LPEus0aGFKlnqRkB6QCdnEwVJTL5/LdKspWLAIDTO/e2CexLmgtdqRq2WT/ZXWCk0WbTUch3WJLJeEzr91FOR7/fjl60Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mwAiiQ1S; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mwAiiQ1S"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WXmzQ4XbKz6CmQwQ;
	Mon, 29 Jul 2024 18:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722277615; x=1724869616; bh=bSTt1oVOPEuRcu3bbOKC1kOd
	5MVAN73nTu2skySOolk=; b=mwAiiQ1SEkEnvxrHwwFkHTNCwnsZ7KrOsyQARzsl
	kjIGttgXNW5mQyDbCRffqFi620I5eW/5zF02d/lUIZyafHfO+JCNsh3Q+oh+bZol
	FGxxLdcLHrzMNqtU5TmpbPU8mSHWDnLwFo3GvxG5b6L3gULP6ZR3lid6G5dCizjS
	RBTVx3DUxe5Vdq2KpgvhJzRpGD+HKq7p5JO17BU90KvueX6Arl8cC2Jh87sGZ/fn
	6KwVgtpiRB/cl4Ncz+Tta4/Uvj8YBBp2oKnhCflARDT/9CCpXpkAhBnQOwCuwzP8
	ynF2sg78RNsBHm84jiJrs1ZPh/LQNch7VnVRwtxclMhzBg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id apKa0hWoTMQ4; Mon, 29 Jul 2024 18:26:55 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WXmzK51c7z6CmQwN;
	Mon, 29 Jul 2024 18:26:53 +0000 (UTC)
Message-ID: <2bb22490-6209-4104-ae97-59d73fcb1d6d@acm.org>
Date: Mon, 29 Jul 2024 11:26:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp
 updating logic
To: Vamshi Gajjela <vamshigajjela@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20240724135126.1786126-1-vamshigajjela@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240724135126.1786126-1-vamshigajjela@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/24/24 6:51 AM, Vamshi Gajjela wrote:
> The ufshcd_add_delay_before_dme_cmd() always introduces a delay of
> MIN_DELAY_BEFORE_DME_CMDS_US between DME commands even when it's not
> required. The delay is added when the UFS host controller supplies the
> quirk UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS.
> 
> Fix the logic to update hba->last_dme_cmd_tstamp to ensure subsequent
> DME commands have the correct delay in the range of 0 to
> MIN_DELAY_BEFORE_DME_CMDS_US.
> 
> Update the timestamp at the end of the function to ensure it captures
> the latest time after any necessary delay has been applied.
> 
> Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
> Fixes: cad2e03d8607 ("ufs: add support to allow non standard behaviours (quirks)")
> Cc: stable@vger.kernel.org
> ---
>   drivers/ufs/core/ufshcd.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index dc757ba47522..406bda1585f6 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4090,11 +4090,16 @@ static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
>   			min_sleep_time_us =
>   				MIN_DELAY_BEFORE_DME_CMDS_US - delta;
>   		else
> -			return; /* no more delay required */
> +			min_sleep_time_us = 0; /* no more delay required */
>   	}
>   
> -	/* allow sleep for extra 50us if needed */
> -	usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
> +	if (min_sleep_time_us > 0) {
> +		/* allow sleep for extra 50us if needed */
> +		usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
> +	}
> +
> +	/* update the last_dme_cmd_tstamp */
> +	hba->last_dme_cmd_tstamp = ktime_get();
>   }

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
