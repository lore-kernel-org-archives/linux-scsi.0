Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CC815A8
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 00:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724285702; cv=none; b=ustUgOoQ2ZsGhbe3fHIa5AmGfUftsHFdjPqgcaHCiPVMkAv38Hr/4EBHJh0t2LNcxbW2sgstFEPxj22ATAWcbv5CkI2wjGG3nRZCE+tpV9i9HM3OQTh8Ke0IEsEp0cOeyaokIjd2Fht5ZoysAU14MsJdJJNxqh0vadjq0SoNZVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724285702; c=relaxed/simple;
	bh=FH8/sa32Ro2RE2ZO0Oq4R9JLVve2Lwm614gTLX4nNec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U4fq0vyWGDS/NiDarfeKGePcsyWjr3QjVoiT0SQKBqOqEA0XbXvFOvKlq8OzmZa3fshxhNlDd5jl1zhCzb/tFMHNuPjzR9Xb5OkrnGVrXbRKwV0Cl4ln4msPOMWA+mYEEoiV5M9qw56DTpmE0x7fHSggcurhgcQVjeBVkqbS1KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k78qqE0F; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k78qqE0F"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wq3cN3Tf4z6ClY9K;
	Thu, 22 Aug 2024 00:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724285695; x=1726877696; bh=53Pd+wLRxmhVk5zVbwIiDohG
	MvUGaKxWkz4d9uACyAM=; b=k78qqE0FnQBkAR07tuh90G5SnpZM5wv6qbSy9ylZ
	8e987v0nnxorv/1tliPjrSd3hv+Sl7oFpLZ/19/d/bkDITfVWVuXukexv+uxRRRv
	n6pONBQrgYhY/1av8xTBTA2iWbeU6h/TO55u03hICFajZpdYI5WKB1YLZjwAGip0
	5th0IMKNnOCgvH1OOhmBd8FZJ+8xoh38tvzoPuszWyFx1O9Kdf9J01XvZdZ9ZcZ6
	KTTf4TKLKzJdCulZdWO1YUEJMP7j8l17bKsWQp91XbJz47G84aTpngNavY4Dtt6+
	8Ey6hXBzLnbyIaEdS3sjOK6uAZUBtre61QjEfKSyZ+424w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mHgVVEgJFJYC; Thu, 22 Aug 2024 00:14:55 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wq3cF4byKz6ClY9J;
	Thu, 22 Aug 2024 00:14:53 +0000 (UTC)
Message-ID: <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
Date: Wed, 21 Aug 2024 17:14:52 -0700
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/24 4:26 PM, Bao D. Nguyen wrote:
> On 8/21/2024 11:29 AM, Bart Van Assche wrote:
>> Accessing a host controller register after the host controller has
>> entered the hibernation state may cause the host controller to exit the
>> hibernation state. Hence rework the hibernation entry code such that it
>> does not modify the interrupt enabled status. Bart,
 >
> I am not clear on the offending condition, particularly the term 
> "hibernation" used in this context. In the function 
> ufshcd_uic_pwr_ctrl() where you are making the change, the host 
> controller is fully active at this point, right?
> Please help me clarify the issue.

Hi Bao,

Isn't "hibernation" terminology that comes from the M-PHY standard?
See also the DME_HIBERNATE_ENTER and DME_HIBERNATE_EXIT constants in
the UFSHCI driver source code. Please let me know if you need more
information.

Bart.
