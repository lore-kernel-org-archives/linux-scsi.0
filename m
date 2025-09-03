Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D35291C3F;
	Wed,  3 Sep 2025 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756915011; cv=none; b=ugWgkNBM+LNlIZhTO4LWdU97r23iW5rtFUUpVAUDrVHIPt/T0RxIM8NtDwMLRq0a4c1qpcW5qo8A8N2hzrTeyRq48WvKdJRd2Fxo6605YZIqlVU+W19zNbQxKemJNhdQ7VKU0XWEsGewLUcHyk8fVEjZDN+8QoXV3cBxGqg33fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756915011; c=relaxed/simple;
	bh=3y/OeHLtZhmJFtl2aB0Vsz631BEjZjuD9mctK915Tcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oIypCHMPddmWDJgVgI24fJ5KGunWOe6DiNXdqg5xY7IzuCXhcVUlMLOpQT3TPNH9GnwHEqQf8je05CjSi3GLPmMpHDkjHnW7+fK9mKt2QCLDPSnKiQ1N4d+H/7UJAzCoMwMEOhUBENK6Y+rgZ9+TSnGWNx17FNkZiPCAeLweios=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SmYanSsk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SmYanSsk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cH6g31PL0zlgqyd;
	Wed,  3 Sep 2025 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756914999; x=1759507000; bh=uxwEnZtSBaI8eE1xPU/YOeBA
	dFGKEdN+2bj9iOVRL8k=; b=SmYanSsks+RAHlXcPcHdi/u37/7qKPHLYscymHwx
	ppS1c9WVtu5xl2oVde93y+8JDG/wYeZEzFOxGLY+HiSAFKL/ToRBJXxBnxYdcohI
	r/0BqnlYU47dstBv79K3hhXGkTHnQ16gWxSEItwRsg2Z4R/QXDbb7VByl8F8q/Qy
	pvI3z4TPTLxgi4FgPLvmUOt2Qt4wLGbJqXDlLSQcIHpaVSFIOx7/NnR42fHZ91NY
	GbhhbXuo72fMIcte7BGFFeUQOUc5fjyeFzfuyf7cs9/APxfMAqE1K7eZM+OZ62/u
	yiMvDn15IGbroSez6MLlnLm+WGU0kLeSQoV9yu0N0sixKA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZVZOk3Tfha6D; Wed,  3 Sep 2025 15:56:39 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cH6fd4l9dzlgqyB;
	Wed,  3 Sep 2025 15:56:24 +0000 (UTC)
Message-ID: <854fad23-e7f8-42c8-b0e2-03460f481366@acm.org>
Date: Wed, 3 Sep 2025 08:56:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs cmd
 error
To: DooHyun Hwang <dh0421.hwang@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 quic_mnaresh@quicinc.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
 jangsub.yi@samsung.com, sh043.lee@samsung.com, cw9316.lee@samsung.com,
 sh8267.baek@samsung.com, wkon.kim@samsung.com
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
 <CGME20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d@epcas1p3.samsung.com>
 <20250417023405.6954-2-dh0421.hwang@samsung.com>
 <239ea120-841f-478d-b6b4-9627aa453795@acm.org>
 <093601dc1ae0$2389c460$6a9d4d20$@samsung.com>
 <27882582-58b8-4ac2-9596-3602098e7c1d@acm.org>
 <17db01dc1ba6$41d37350$c57a59f0$@samsung.com>
 <6e854090-a071-416a-b7a5-cc8ee0122a90@acm.org>
 <2add01dc1c9d$7b5cba30$72162e90$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2add01dc1c9d$7b5cba30$72162e90$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/25 11:39 PM, DooHyun Hwang wrote:
> Could you please provide some guidance or suggestions?

How about this approach?
* In a separate patch, remove UFS_DEV_COMP because it is not used.
* Call the new enumeration label UFS_UIC_ERR (UFS UIC command error)
   since "UIC" is how the UFS standard refers to UIC commands (these are
   called "device commands" in the UFS driver).

If anyone else has a different opinion, please speak up.

Thanks,

Bart.
