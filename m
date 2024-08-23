Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC75A934
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 02:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724378818; cv=none; b=OoWOKqk1r4Ho1ynfdsU/7J0nRaINwsgSnwtKi3qYkQg61ScwGcl0JM26eSVkEL4P2IkSHZ3xp/5UUkNAWHFzzK+T/T9eUslV2Kq360RsGunNE+mioTNQdeqMK1l8U4PtT5lqgSAi3D/o1nXree0R+m4b+pSZdoBxfHyerxoGRP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724378818; c=relaxed/simple;
	bh=hn2LpM+GC2Y6DJO5FO9nWXbmB1/AlZGK7n5z3NT43E0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AhjY5Km30KTMQHc5Ux+5I6NwQna5fQg+N6x9vg82qBH3xUs8+zcGcPiFfnrUchmh2AgtAZ7GNgnERXbn8GrQJH3Z/Co89h2ETcNCGjD/cf8eFzD8wUZp6bNV2mbiPPgqzyIcGMZhYQCLt4ns9CC5sxdaZcHE+ptj4UG1ULvhCdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gmusOzsl; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gmusOzsl"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqk3375DnzlgVnK;
	Fri, 23 Aug 2024 02:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724378811; x=1726970812; bh=oqAuOwcX/z5dHla+zSNXdtfa
	KaVlcHR852eGvMyOpxE=; b=gmusOzslo79n4ZeEwtH8fmUIJjrFXKZbLP/rMZBr
	nC4k2/JRrQc9FtNtUUjYnl5FZZlxy52u2cILBKTW2kyNjvQdvW41MnWyawxe2oSX
	G4ekNAzaNV6GAbkwTzNF1rZWnXsZja4mc60ofuRh3LN2TuqEjeqyZ1v/k4hhV4NC
	71JXtTJwiUxjFfr9zamTL+Igd8J4aTvHR25ogjZyGSxyeo8DdsMEICviBRZAJ7dL
	IDW0PjY3y5KU8055HbcGL9s1FI3n2L4eOYMjjwGQngLBCcHnpGxoEGGZwuyrCEcH
	yQdiNGDcD7NUpHytIR17tsYbbExSuWQJNf28bgTvFHffVQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id T3639KqRSL57; Fri, 23 Aug 2024 02:06:51 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqk2w0KS8zlgVnF;
	Fri, 23 Aug 2024 02:06:47 +0000 (UTC)
Message-ID: <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
Date: Thu, 22 Aug 2024 19:06:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 4:34 PM, Bao D. Nguyen wrote:
> Let's say you are sending a ufshcd_uic_pwr_ctrl() command. You will get 
> 2 uic completion interrupts:
> [1] ufshcd_uic_cmd_compl() is called for the first interrupt which 
> happens to be UFSHCD_UIC_PWR_MASK only. At the end of the 
> ufshcd_uic_pwr_ctrl(), you would set the hba->active_uic_cmd to NULL.

That's not correct. ufshcd_uic_pwr_ctrl() only clears
hba->active_uic_cmd after the power mode change interrupt has been
processed.

> [2]The second uic completion interrupt for UIC_COMMAND_COMP is delayed.
> This interrupt is newly introduced by this patch.

If UIC_COMMAND_COMPL is delivered after UFSHCD_UIC_PWR_MASK then the
UIC_COMMAND_COMPL interrupt will be ignored because hba->active_uic_cmd
is cleared by ufshcd_uic_pwr_ctrl() after it has processed the
power mode change interrupt.

> Now let's say you have a new UIC command coming via 
> ufshcd_send_uic_cmd(). The ufshcd_dispatch_uic_cmd() will update your 
> hba->active_uic_cmd to the new uic_cmd.

UIC command processing is serialized by hba->uic_cmd_mutex. Hence only
one UIC command is processed at any given time.

Does this address your concerns?

Thanks,

Bart.
