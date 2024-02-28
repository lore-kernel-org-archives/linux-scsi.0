Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC3471ED9
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 18:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146332; cv=none; b=pQLW5JMze0/jRuElfh03ZH2hwNb8uwBlMBqnuxD1dIt24jtwyZUa1gyBG5TGk1DtCVtqMc1NBfJmsijUPdBnV6hNjkw9iCC5KypueHZNLpneQjQjDRzQydsxZA6muCx+M6BGjGPYOw6Jyo/0oVSrZhzabYlngCNrAhX6IB1mM/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146332; c=relaxed/simple;
	bh=5ZS9FxrOG/xMWNM0Aj4L3UmJMmcThm7kpPwCQCTfodA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=afACpVxqarBCNf7jjgRSanBvEs8DRTwUKXVUUsa5RVl+QrvRAn7v+3UUgzv5WDK71HjhiS2G9p4vRliTeNGtatAt5vTbGVu4AWUbsKICCUWbKW1zFWuzyhTJKR7rVQI5y3L1exk3NQvFJUo8usp33uNvwdijYFosDtcZCyv1W74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dc13fb0133so936745ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 10:52:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709146330; x=1709751130;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5U9P+sA+K/dmaZAwTAXy0NC+52ZhbJ5UemQpmzw4EKA=;
        b=JQq6Tw4wqEnmG1X37Ua4Zx5x8ihllTJCoAGwIZjY4WetDHRrHZ0V5i2qtbsvvY4hzE
         Qz/5yO3u+KtXYxG3t2vIpK5YqRIDY34zSLk82WkZiLLbuBeadA4knlRcO81nwKIIQYc7
         hR7aScN3DIzroFdSUhxu7pgWGsZfXivfXvJpfeY8fsQhsdeCIZDUI95UnET679ptYcp5
         uqlXS6TW7iwxYABjgYfK7+8kC5NLM90yB+4ZIFpJ8Anq8XWgyqVeCNsNSTDHiSFzWhJ6
         WkOsC0J2pUxQ6u16UggE8trQ55kDjpUhTxXu4BsB9p5Xz/pXxS0ctFPJH7v85MapjNHd
         yjyA==
X-Forwarded-Encrypted: i=1; AJvYcCUhzM/rWXRwGKkqZ/bngw+z75DpJcF4cvhnM/IOowBo+MTTZJyVf8bva7AQyjDPG5p9ietpq97NcvyBsxMb7Wz+FHQbg1qKFSb7/g==
X-Gm-Message-State: AOJu0Yy7I+cNa38YeWvumKll3+Mlhv02Uv+J3T6FBO/y1EaQlETzPbaj
	pl3rlcfPSuCX3b4J0wEu8D85LWqNr0HWksNyCmoRIeTFQ8gNQKEd
X-Google-Smtp-Source: AGHT+IHy6yPFuR0z8aiAz+5gVd7Be+MCbXxfQb1KCIcvx7lG3F0hxK10bLgxFkYsPWzS3ZTvOp6r9w==
X-Received: by 2002:a17:902:7805:b0:1dc:139:8488 with SMTP id p5-20020a170902780500b001dc01398488mr350136pll.5.1709146330135;
        Wed, 28 Feb 2024 10:52:10 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:3174:8fc0:11f9:afc8? ([2620:0:1000:8411:3174:8fc0:11f9:afc8])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902bf4500b001dcc0d06959sm2917738pls.245.2024.02.28.10.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 10:52:09 -0800 (PST)
Message-ID: <565c6b0b-137f-4d72-b8c6-eb3d34592808@acm.org>
Date: Wed, 28 Feb 2024 10:52:07 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
Content-Language: en-US
To: Ram Prakash Gupta <quic_rampraka@quicinc.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, peter.wang@mediatek.com
Cc: quic_cang@quicinc.com, quic_nguyenb@quicinc.com,
 quic_pragalla@quicinc.com, quic_nitirawa@quicinc.com,
 quic_bhaskarv@quicinc.com, quic_narepall@quicinc.com,
 quic_sartgarg@quicinc.com, linux-scsi@vger.kernel.org,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240228053421.19700-1-quic_rampraka@quicinc.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240228053421.19700-1-quic_rampraka@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 21:34, Ram Prakash Gupta wrote:
> This reverts commit 1d969731b87f122108c50a64acfdbaa63486296e.
> Approx 28% random perf IO degradation is observed by suspending clk
> scaling only when clks are scaled down. Concern for original fix was
> power consumption, which is already taken care by clk gating by putting
> the link into hibern8 state.
> 
> Signed-off-by: Ram Prakash Gupta <quic_rampraka@quicinc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c416826762e9..f6be18db031c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1586,7 +1586,7 @@ static int ufshcd_devfreq_target(struct device *dev,
>   		ktime_to_us(ktime_sub(ktime_get(), start)), ret);
>   
>   out:
> -	if (sched_clk_scaling_suspend_work && !scale_up)
> +	if (sched_clk_scaling_suspend_work)
>   		queue_work(hba->clk_scaling.workq,
>   			   &hba->clk_scaling.suspend_work);

What is the base kernel version for your tests? Was this patch series
included in your kernel tree: "[PATCH V6 0/2] Add CPU latency QoS 
support for ufs driver" 
(https://lore.kernel.org/all/20231219123706.6463-1-quic_mnaresh@quicinc.com/)?

Thanks,

Bart.
