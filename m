Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B6F1EB9F4;
	Thu, 13 Mar 2025 18:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741889645; cv=none; b=cLTjjdqKMM0gml8o72dFZAFCEcga1B4z8yaZWQTFifZLm3A1XFqj3TWZMOvrLQ9IQuM6bk55izutoS54jTWI3jCK9JypPcKc2IRFKBHH9HXMyhGxHL5LSEgRDu0Fin/y/GWTqoyyRsb2BPzcM6ZCnUjKs5kkrmgiendzu5r4pR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741889645; c=relaxed/simple;
	bh=JsqIMTl34/LNDaxfujHWoB1Q0STvD4LO4oUmAcSG0D8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akVH2LCbvY7s80IzYDVOgp3RaxaxYmjbXqMMEoLqblZwSEff+gMZAMnfinaKP8VTR455YUYcq5nNvTpSrUrfmPaoQrq7t7Mh3+FNs54A8RotEDY6tjwo3zXiJCXkcBm2SVhfvmRqHvdynS2FWzOK1QrKTtxvxjIsuMSNx0KkFPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HPofS2JS; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HPofS2JS"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZDFxd30YSzltJQ0;
	Thu, 13 Mar 2025 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741889636; x=1744481637; bh=1rmpn+TtVY3mB9S4HUrhZhDm
	5b5BiUejJjJzbebaXm0=; b=HPofS2JSXmF1ID+Nw6PGeIvfpB8ylNosure7a2+y
	REUbdGwNwZ5ECldiQSv6ORBHC/01z2cYM7GXFRHZtiqDBtqs05pVdXxfkq4kN+pY
	RCP6T8HmA3+8IWJFTgix29t5W7XpbaiUFVWg4WyRd83JD8AlQ+9tWYlX0JtGETvt
	yczo2jttNbUaWKUV2Zp7WueU1BOnumOVl32KgQAi1K+xV4UCsWz8yRQDLwbQnU1T
	sJfbqZCID/Su2BsBCWdzQfmezmxKxAocw52MPgQKfPG8zxboPpQLQWud6sNQf+ZN
	PmGTlHrcqeBYxpCv7DJhxoZRb7+f1xZRRgIN1fsmi0xeNg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UHCUQAf4DRtP; Thu, 13 Mar 2025 18:13:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZDFxY6vnszltBCt;
	Thu, 13 Mar 2025 18:13:52 +0000 (UTC)
Message-ID: <0991bf65-aa76-46b1-b353-2a19069426d1@acm.org>
Date: Thu, 13 Mar 2025 11:13:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: ufs: critical health condition
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250211065813.58091-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250211065813.58091-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/10/25 10:58 PM, Avri Altman wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cd404ade48dc..ef56a5eb52dc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6216,6 +6216,11 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>   	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
>   		ufshcd_temp_exception_event_handler(hba, status);
>   
> +	if (status & hba->ee_drv_mask & MASK_EE_HEALTH_CRITICAL) {
> +		hba->critical_health_count++;
> +		sysfs_notify(&hba->dev->kobj, NULL, "critical_health");
> +	}
> +
>   	ufs_debugfs_exception_event(hba, status);
>   }

Hi Avri,

sysfs_notify() may sleep and hence must not be called from an interrupt
handler. Please fix.

Thanks,

Bart.
