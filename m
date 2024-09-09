Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A19B28DCC
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725901747; cv=none; b=A6ZUBYTwVjdvdcEVHYot1M12xVUZSg10GSqUt0/e65+Ogfg7wRylZspvUXXSX+yuPpdJFqFplFrON+SMmU4EWfCORIRB1Q/Hpx1FrLVgrjoMMYwKfD5luV8R1BSnLEhC6Kv69nRqaJQyBaAOxyXpreFKYBc8duolLh+Hx/IYeZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725901747; c=relaxed/simple;
	bh=wGe+ilzaY1OcHttngWaHTNcFAmPRINBmzQ0mAwMgjc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F3wFNBEj7hugP3Nb8yEm3PrvHjsod/gCkNuTYxNmI3Lt9xLsIfDXAWv0af9SOn5/gXvb9SlXVw0/IlpcjtUeA2kFhrhE+RnIw2KF4L3FgSRNIvUJb6T9wtNceIEPtVWp0m4Z12BHNTXg5xGNmkR5xx0ssVFP5tTv4Xmx2itBEXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wC8sPSVV; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wC8sPSVV"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2YG94DSkz6ClY8r;
	Mon,  9 Sep 2024 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725901742; x=1728493743; bh=BNICSSQ95tABED1S69DnCSf1
	2RycVpDRPz6lWeephOo=; b=wC8sPSVVEB9LE/XqS7W7NcXyuxUwYp7Vvp36XD2Q
	CEnm+kkOwr6tTkzLxL4elaTHKhQCs+K8kqdPLAMH5xgD0QE8err+zPSZOzobhh2O
	4gU26mnorVeeI99Gqiv/TsLlQ7EbL1Zr3wI+XhuUNF+vBnwZtPdhKdMSpf0FSu9m
	DWST066NycKNlH07zh+ebUEYmM1vt86xylXTPvcERLmxjXJLyA/SQwERf1P9kkgQ
	llw9SxnpzZDepIse8G+PUnocyhxxH3kLajB/wz6gsA4vnY3P5xBKDKS4cqpQL/oD
	5dxpFGqrvGtWIH4PdUEc1To57tDSZZaTAdklBDByszQCXQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ykWz4vygQrkB; Mon,  9 Sep 2024 17:09:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2YG41StJz6ClY8p;
	Mon,  9 Sep 2024 17:08:59 +0000 (UTC)
Message-ID: <a5ed8297-c478-43f0-bbc0-0e27a1586974@acm.org>
Date: Mon, 9 Sep 2024 10:08:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/10] scsi: ufs: core: Introduce
 ufshcd_activate_link()
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Bean Huo <beanhuo@micron.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Andrew Halaney <ahalaney@redhat.com>
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-3-bvanassche@acm.org>
 <1add8a06-74fa-4d31-4f23-30fce2209d5b@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1add8a06-74fa-4d31-4f23-30fce2209d5b@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/24 4:59 PM, Bao D. Nguyen wrote:
> In the original code, if UFSHCD_QUIRK_SKIP_PH_CONFIGURATION is set, 
> ufshcd_device_init() would exit early. However, in this patch, if 
> UFSHCD_QUIRK_SKIP_PH_CONFIGURATION is set, the new function 
> ufshcd_activate_link() would return 0 which would cause the 
> ufshcd_device_init() to continue further down. As a result, the 
> ufshcd_device_init() would fail to handle the 
> UFSHCD_QUIRK_SKIP_PH_CONFIGURATION flag as its original intention, right?

Hi Bao,

I was assuming that UFSHCD_STATE_RESET != 0 but apparently it is zero. I
will fix this patch before I repost this patch series.

Thanks,

Bart.

