Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9A576056
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 22:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796302; cv=none; b=NfLhBowPpcT3mv0K7j0UJsd+E1aONsm6vQ6GjkEknjlIQvLxfsG2uewIHffz1sO63FzSCSCAH2B+G8WfPDn0FN878C2WeyBqVmE/Hcvx6yEtpWZzQDGOorTpdP0Xq4ZAsy39/VpfeqMR+J4ydbMTcUoiLY1C+FrH1lO81PlMkkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796302; c=relaxed/simple;
	bh=RsSzkMk7eGXEwXRWXiymUtzm3QExu++3ZTLnCowkYXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NghA0BBFr3HOeMocmIA6uYTOovxpE25l+T+jdiTnTzmMKizHlmFuZnYcqPFHWwEqh8DKsn2/YBvZj3PCcnaBT7Cdin7zApUQFMV9yVBRaJR7n9nEwLVVcYw6MbcoHQTQAFqrD6+YEudoadcAG49IFkIeWptb7FuftckQBG0xBBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mePogHzV; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mePogHzV"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WthRc0pzPzlgTWP;
	Tue, 27 Aug 2024 22:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724796297; x=1727388298; bh=JvTmRJPuiCT8UMKvap8RQod7
	olArKEVDKmBEUp04lNU=; b=mePogHzVrhDzdzbA4r86+CBmriQ9zLGo+u/jw78s
	tvftmkRV01PZwy/pHnAy4ERABBis4h1cyd/SX6JZCA9nSNW3lCyzSxJVZ40l5KAL
	x2u7rIhP7akOvSZdGEyrpBbEAA82bk1t1qyLFEgSVqSHbywJSwgqcbTfLXZMcz9E
	oWJvd1RdDO/XwyZklVmUUdB0OORQ2qIDpUx6+p23ClgurYSyySeYyYYeVt89admD
	dmLQ6sNM1+ZyLrky9ZSRj5oPp1aUApMe7+hYoH9th4J81Vq+KHEx1/8DVq70yCI8
	O8jXFGIdSCLHERlpzS9SBQq9CxLqG0NwVzWBtpqwgatJIg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Qbnu2FKwiYMf; Tue, 27 Aug 2024 22:04:57 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WthRW4bwmzlgTWM;
	Tue, 27 Aug 2024 22:04:55 +0000 (UTC)
Message-ID: <077fee36-725f-488d-ac05-5e61e211c4ac@acm.org>
Date: Tue, 27 Aug 2024 18:04:54 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] ufs: core: Introduce ufshcd_add_scsi_host()
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-2-bvanassche@acm.org>
 <20240825051037.ggp7sjiieksyiapp@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240825051037.ggp7sjiieksyiapp@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/24 1:10 AM, Manivannan Sadhasivam wrote:
> On Thu, Aug 22, 2024 at 02:36:02PM -0700, Bart Van Assche wrote:
>>   /**
>>    * ufshcd_init - Driver initialization routine
>>    * @hba: per-adapter instance
>> @@ -10514,35 +10564,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>>   		hba->is_irq_enabled = true;
>>   	}
>>   
>> -	if (!is_mcq_supported(hba)) {
> 
> I guess this series is based on v6.11-rc1, because starting from -rc2 we have
> lsdb check here.

Hi Manivannan,

My patch series is based on Martin's for-next branch. The
UFSHCD_QUIRK_BROKEN_LSDBS_CAP support has been queued on Martin's
fixes branch. I think this is why the lsdb check is not visible
above. I will analyze whether it is possible to rework this patch
series such that Linus won't have to solve a complicated merge
conflict during the next merge window.

Thanks,

Bart.
