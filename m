Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A578FEC5
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724360913; cv=none; b=ayZBSOv1YWtlSHpX6SPFrNkdaXIz82QRtiickp0bThjDPvhCpG8wqHWlLFc8lnTnreEEITQCLxo0vm19/KNRW3OuGolbhwfJZ8frvyHPmRRGgAvx+/OmJLAKmeoK6D1HV+4DxRixWya9KcqqFXJp0wRr8NoPgyJFIiZ5TMbTCqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724360913; c=relaxed/simple;
	bh=IkIgCi3ITaln7WsiJmBx37tRXyoMdJ5+CAdYY0iK/As=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AQ41x7/Nn/dZp7MiPjuHBRcDrGzCWoeVsPljN8qLzpQBcr7psRpBYTWD7N6+jApZ2GXV2sCtwwkjGuFsJXs1b67hL+UFlt1VnND7kru2QSRP2f1mjgBuGDdDT9BlJc9QN40PSS4Rlah03DJGkQVcQK58G9eq/CrNQmM0TPIa6wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tJ1jb15G; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tJ1jb15G"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WqbQk6ZdXzlgVnf;
	Thu, 22 Aug 2024 21:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724360906; x=1726952907; bh=xAG2InRE+wn2CqYMs/czQLoI
	M1rfZqDvHKokQ/Ewv2M=; b=tJ1jb15Gkqfsy4aaf60cnQBQmsRFyWl1pnKD3Nf8
	PbyD+4ib2dLPqeeg9auNRjv29BUhZqduW1cJoVvGsK/7kSmEJT+ynCSdTyiEjzxr
	9FD3DgfRSwETw2pJ9wJlTdUMtyz5HWj1wTtn3XKwL6uDIHB2nD2xNF6vBi3+giB2
	HDJ2U9KTsC6MMwcWfdPWJevwXrxzAXZyq8keUXK3uSaLss2WJfGh2h8DOIE8Jzgf
	vwrlmSai8n2DI+V0wpjMJ69n/xXbsTfgjaLNTjL3WenIj730eHwQq9WEQNiuKYTQ
	NSMvnOa9PO7nQcuHaH+o2EQJe9iIoZlNWcVoZei2exfBNg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ea1LiOhysz31; Thu, 22 Aug 2024 21:08:26 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WqbQd1dfHzlgVnK;
	Thu, 22 Aug 2024 21:08:25 +0000 (UTC)
Message-ID: <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
Date: Thu, 22 Aug 2024 14:08:24 -0700
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
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 1:54 PM, Bao D. Nguyen wrote:
> I am just curious about providing workaround for a hardware issue in the 
> ufs core driver. Sometimes I notice the community is not accepting such 
> a change and push the change to be implemented in the vendor/platform 
> drivers.

There are two reasons why I propose to implement this workaround as a
change for the UFS driver core:
- I am not aware of any way to implement the behavior change in a vendor
   driver without modifying the UFS driver core.
- The workaround results in a simplification of the UFS driver core
   code. More lines are removed from the UFS driver than added.

Although it would be possible to select whether the old or the new
behavior is selected by introducing yet another host controller quirk, I
prefer not to do that because it would make the UFSHCI driver even more
complex.

> In your proposed change to ufshcd_uic_cmd_compl(), you are signalling 
> both complete(&cmd->done) and complete(hba->uic_async_done) for a single 
> ufshcd_uic_pwr_ctrl() command which can cause issues.

Please take another look at patch 2/2. With or without this patch
applied, only hba->uic_async_done is signaled when a power mode UIC
command completes.

Thanks,

Bart.

