Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CE020ADE7;
	Tue,  8 Oct 2024 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728409358; cv=none; b=nKCJhvagWOX1Kj74Z34VXXtM0nuQ9RSmyrPbSFNqRVXHfHqqRwCZPU3s2Xb3rjyhDtXYLYR1Eu+NssiqvHvdMLZlIcxBTEWCdEXDLDfV/xmFeFKg4SCgxdtM2AO573ctpezi1qQvIxNh2jziSOcsRQGLv3YzWekeMbsluQfs0p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728409358; c=relaxed/simple;
	bh=Q0g58HqaOxFLx9hSEYKxy3f3Vj1QxlCfdqMvR4YEnDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jpaD8CCIuvrLNzwr/FaZmLlIWaolsGcAS0jzQ+Jc6QHVdhLrk5baVtq2mLNVBNWJDzM5sKIc7oE3Juae80pUUwn93Q286m/9NfSvUmTSsC7gqli5oi3qBYd+WEydlHJWfPUxxAGMohI91ge/uBqqE1yM/FnSyQn8MWHg4R7qWzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N9XvX3s8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N9XvX3s8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XNNdS4vhbzlgTWP;
	Tue,  8 Oct 2024 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728409351; x=1731001352; bh=JZhci7ma0ai9ive6gkNamfTH
	wDVRA3njSn1SwC/E96M=; b=N9XvX3s8soO5sMEkAdmxItaDHdgrKxW2hTbYaEOL
	mzlIhD8VviJN79VbqITDTqIuK5YXmx3olER6VDQwqhu/8e2+m26VhWBi75e2ZGYp
	Lt8er3qNvXrnXklccJ57YcAu8aCijgsWbC3z1iaSeLpiFMWtBxk0jf73KHsvS2JX
	gY0kpOue0Ds/hnD+7He7IccpooDuxad0oeeTOJTMUZJx4Ia+GJZmE1iYP37i1ePP
	gPrC3UkvM451uiRfPhwk+28TV+awDgrccHkTRT9y36PQNsECg7TeyBbFDuPkVEW9
	AG8zb2iZaYfb45N5JgVKGweQMCIXwJIMruIROwFIjWzNew==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gT6BVE5RkjYH; Tue,  8 Oct 2024 17:42:31 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XNNdH2mCzzlgTWK;
	Tue,  8 Oct 2024 17:42:27 +0000 (UTC)
Message-ID: <66d8938c-3bf8-49c3-b42a-e2c32f1d1338@acm.org>
Date: Tue, 8 Oct 2024 10:42:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: check asymmetric connected lanes
To: SEO HOYOUNG <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
 quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com,
 junwoo80.lee@samsung.com, wkon.kim@samsung.com
References: <CGME20241008062836epcas2p2caa5c41cf8fe4d1bfe5d923633ea2618@epcas2p2.samsung.com>
 <20241008063842.82769-1-hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241008063842.82769-1-hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/24 11:38 PM, SEO HOYOUNG wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 24a32e2fd75e..1381eb7d506a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4540,6 +4540,14 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
>   		return -EINVAL;
>   	}
>   
> +	if (pwr_info->lane_rx != pwr_info->lane_tx) {
> +		dev_err(hba->dev, "%s: asymmetric connected lanes. rx=%d, tx=%d\n",
> +			__func__,
> +				pwr_info->lane_rx,
> +				pwr_info->lane_tx);
> +		return -EINVAL;
> +	}
> +
>   	/*
>   	 * First, get the maximum gears of HS speed.
>   	 * If a zero value, it means there is no HSGEAR capability.
> @@ -8579,7 +8587,8 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
>   		hba->dev_info.f_power_on_wp_en = flag;
>   
>   	/* Probe maximum power mode co-supported by both UFS host and device */
> -	if (ufshcd_get_max_pwr_mode(hba))
> +	ret = ufshcd_get_max_pwr_mode(hba);
> +	if (ret)
>   		dev_err(hba->dev,
>   			"%s: Failed getting max supported power mode\n",
>   			__func__);

I see two independent changes in the above patch. Should this patch
perhaps be split into two patches?

Thanks,

Bart.
