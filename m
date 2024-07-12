Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6165D43AA9;
	Fri, 12 Jul 2024 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720805689; cv=none; b=AZmxJQaciU0IxcsZ6nuJllxd3l0fClJb9AKk9NGXOaeWldG4sXy67kaO8b5LnpQg6X2I4hC3oWB9IFbQtUIbPZu/OgCToEU9gUtjWswVYN+xmBR6n/F48EkD3X51lyeNgFLus0YLbbsYzXY9fVc4kQ2MgRlrp8sVxWLFXkvu0d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720805689; c=relaxed/simple;
	bh=wP1Oy5PNk2xewF/or15izPFpyMMyadp3VxKcTcG0p1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cfpmiBMqENVqzdrwRLbVQhzov1yg1Ok70JI+ymaWJqsK1xGCUsjZfOBHjJB/6xV/vEJxR0iWR+1BDjpFjRUF/IgVrhZBcrquCKT/N8Ep/z+1KE5JmLg39xU5T0vJjHEHVZsJkjFWBuU6IVQBUX0DfmNLrDZ7BMwmxqJbAJp9A1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zaELPM1f; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zaELPM1f"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WLJd24fv3zllBcw;
	Fri, 12 Jul 2024 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720805680; x=1723397681; bh=IcY7aS/6gAbWolfcseNQxvK5
	EoTGz5G/d07NVTpVUZc=; b=zaELPM1febTZZlObTTPvoM5HruQwYv4MnHTZ+CqR
	FiFCVl5pTzx38l5gfKMs2HiFxT8j594YEXOj78JpKWFvpTp/ByyP2fqdXVBF+Eoc
	/g+6rLG8waSwevWuiH7/h4uUX9sRxbX13YWRDjUAA+UBdYfeAHMpmnFY/qUpNZ+l
	TwGfw6ChA8pKruY9d2I52rqJKAYYi8lPtaiHiuwHxON3yu+UezHQ5nroE1YT/cuC
	pxGaLnHkG/W91gX9kwCeORDHBDCZM3WoFmAkNSLjX/ACI2uqonJKAwKcS3O5sCbH
	762L6Cqji1aOctirEvi4U9M+PbuGIjZBpH+G9QRmG2KC1w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RXA_HOuy2F21; Fri, 12 Jul 2024 17:34:40 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WLJcn2ZqqzllBck;
	Fri, 12 Jul 2024 17:34:32 +0000 (UTC)
Message-ID: <d1d20f65-faa9-414f-b7fb-4b53794c0acb@acm.org>
Date: Fri, 12 Jul 2024 10:34:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: fix deadlock when rtc update
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com,
 beanhuo@micron.com, stable@vger.kernel.org
References: <20240712094355.21572-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240712094355.21572-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/24 2:43 AM, peter.wang@mediatek.com wrote:
> Three have deadlock when runtime suspend wait flush rtc work,
> and rtc work call ufshcd_rpm_put_sync to wait runtime resume.

"Three have"? The above description is very hard to understand. Please
improve it.

> -	 /* Update RTC only when there are no requests in progress and UFSHCI is operational */
> -	if (!ufshcd_is_ufs_dev_busy(hba) && hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL)
> +	 /*
> +	  * Update RTC only when
> +	  * 1. there are no requests in progress
> +	  * 2. UFSHCI is operational
> +	  * 3. pm operation is not in progress
> +	  */
> +	if (!ufshcd_is_ufs_dev_busy(hba) &&
> +	    hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL &&
> +	    !hba->pm_op_in_progress)
>   		ufshcd_update_rtc(hba);
>   
>   	if (ufshcd_is_ufs_dev_active(hba) && hba->dev_info.rtc_update_period)

The above seems racy to me. I don't think there is any mechanism that
prevents that hba->pm_op_in_progress is set after it has been checked
and before ufshcd_update_rtc() is called. Has it been considered to add
an ufshcd_rpm_get_sync_nowait() call before the hba->pm_op_in_progress
check and a ufshcd_rpm_put_sync() call after the ufshcd_update_rtc()
call?

Thanks,

Bart.
