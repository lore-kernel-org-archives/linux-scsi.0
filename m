Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC8B238C0A;
	Tue, 22 Apr 2025 06:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745305075; cv=none; b=IzePdn1t/cBbAlROUBrMinXEjJSuPgnMGcMg81AF64FOwom2gtT70T4dkbXIlq5bZyTJdzOy4bhSpqCXfVNuX60aaS0FU6PdSVdOGgwUrgmV4wgkWuLdyB07TXyJJ2s6qRp8Wi9ARxT2aRTLsP78RVmvDp7GRrEMeqdEMhtm0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745305075; c=relaxed/simple;
	bh=HVyax2u7ZfTCnr06WzTP2vtRB4ILGukLvzv2pmB4Bms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tqF/NwBFzP2ovgSLRqJmxoM9wVV7v/t8KQ3rsG+3VV+5tItAypCpEiQXSnV3KxO9lTvJJvSG0OXa3RLfTfTfTJ3ITMfJ0LxnotRm6NKm63kCkU0qHaTRSKaKAZt7g585KoCV3CdzrYNymn91M6HM3Cogp3YUwvD0WrQvrWLoS5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ba0XNFDY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ba0XNFDY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZhY2z1rPyzm0yQs;
	Tue, 22 Apr 2025 06:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1745305064; x=1747897065; bh=HVyax2u7ZfTCnr06WzTP2vtR
	B4ILGukLvzv2pmB4Bms=; b=Ba0XNFDYqSH363j+i1MsZL9t/KdGidMOjXhRwGoF
	oBbCJ16JqvRLOA6EexgMw6KyMnL/U41L+3v48GlNjtgDSKrfbDdzKEcc0fyf1eG3
	b+KXlkyHFt06X/6je/aaE2Pshy1YmUUNTz4cfsX295SffdXT9bqqnBeaJn3nufM1
	kH667LqSXjO46SkCn3VioJJpjC5KJvu3kFJuLf0jo0yuOfy7aB69FgAREX26NBr3
	gZk3u2d5jJUtK8VUenT4n8onrUTVQZ5nH42NwcEAwWu1pZeW/fZ2bdmEBAbZ06kS
	dvdwKYelyPBWsn/W2Yl6DdPbvYXG6riiT5raZyS4lDSWTQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FXtzAmTMR-Nz; Tue, 22 Apr 2025 06:57:44 +0000 (UTC)
Received: from [192.168.68.114] (84-24-150-169.cable.dynamic.v4.ziggo.nl [84.24.150.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZhY2g2pwwzm0ytT;
	Tue, 22 Apr 2025 06:57:29 +0000 (UTC)
Message-ID: <d78b244b-e032-4d6f-b6bf-87be2a98693d@acm.org>
Date: Mon, 21 Apr 2025 23:57:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
To: Huan Tang <tanghuan@vivo.com>, peter.wang@mediatek.com
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
 avri.altman@wdc.com, ebiggers@google.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, manivannan.sadhasivam@linaro.org,
 martin.petersen@oracle.com, minwoo.im@samsung.com,
 opensource.kernel@vivo.com, quic_nguyenb@quicinc.com
References: <7619479cd692a5ef8bf3bdb8424d173b774dc146.camel@mediatek.com>
 <20250422062555.694-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250422062555.694-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/21/25 11:25 PM, Huan Tang wrote:
> I found that using low-end UFS in SoCs that support MCQ may cause
> device latency to reach extreme values.

Hi Huan,

What is the root-cause of the high latency? If it is the time spent in
UFS interrupt handlers, please try to switch to threaded interrupt
handlers instead of disabling MCQ. See also
https://lore.kernel.org/linux-scsi/20250407-topic-ufs-use-threaded-irq-v3-0-08bee980f71e@linaro.org/

Bart.
