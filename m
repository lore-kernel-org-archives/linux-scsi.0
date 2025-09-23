Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91C416DC28
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758642894; cv=none; b=aYVrgeYLNOLoZEfyCU8h7bBzUgUQete35ICNBBag1xiSoVpxF77fKxVvU+E/lhSECTY43YcM0HQKsIMrEZVgLJo9tAcuYX05zO5I6q4gcBogjacwYM2TRHexOZJeNU2fIytOAETZhEb4vL7xuK80LxZHnUUMkhXpWC6GlEKl29c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758642894; c=relaxed/simple;
	bh=9ys+4oRqi7mmePWA84sBB3bccVxKdIM2g1NxO/GRES8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MmASA4+3HEtSIagLrnb/FMfovsUe/4W3EIkWWTJXgtwExl6wdynVbwBad8S7Ckos96oPyC2iTIMssVHffqTWrZTM3h2PVnFXOSaUAP/NxC/TZUih+255DCcAztrFkz4JN6UeDilBHPrw3lXiMHOVk98ULIvurk9dlntLbmiU/So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N30chI8k; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N30chI8k"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cWPgV59P4zm0ytX;
	Tue, 23 Sep 2025 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758642883; x=1761234884; bh=hzXdEbAZvdcjl7GHoIg2QEV7
	fEXYa2beOYMm8hIqXSo=; b=N30chI8ksn2Z0xxLDe9QCltfcCP0lPWZhN6vONPy
	NRKHd6+mXZz6ix1N10I/K+hmilSVbRsGxoBOPVC6W5EAfGsYySYnXJ3Jds0HhuKX
	zLwpe8VPWvVdQ984Ue8Mvlq/WK3CNF6/uh3MrfwAR8fgwlRrv5cuomKNutzGn+i9
	5T1KHwRGzEm7PF5rSqYRv7KLcL5rDdRmY2R84TGW47jjT2V4KVcbB1Czbstr3Qlo
	3eEKpZZo4B9cJgufDH90QTLeBjU75ap4Rj4R4pw+lp33xuOX+ynzIqacSbU2cbaT
	FeGPT8Hiqkqofrrsfd1u2GvcPaDCU8bmVMWfFXj+v96kBQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ikHvNY3E9x2o; Tue, 23 Sep 2025 15:54:43 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cWPgB2Q3fzm0ytP;
	Tue, 23 Sep 2025 15:54:29 +0000 (UTC)
Message-ID: <c9f1ce41-b81d-490e-b919-a6105ed34ff0@acm.org>
Date: Tue, 23 Sep 2025 08:54:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Change MCQ interrupt enable flow
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250923090855.2522149-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250923090855.2522149-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/25 2:08 AM, peter.wang@mediatek.com wrote:
> -static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
> +void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
>   {
>   	u32 old_val = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
>   	u32 new_val = old_val | intrs;
> @@ -377,6 +372,7 @@ static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
>   	if (new_val != old_val)
>   		ufshcd_writel(hba, new_val, REG_INTERRUPT_ENABLE);
>   }
> +EXPORT_SYMBOL_GPL(ufshcd_enable_intr);

Please do not export ufshcd_enable_intr() - this function should not be
called from outside the UFS driver core.

Thanks,

Bart.
