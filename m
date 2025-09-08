Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3822C30DD1E;
	Mon,  8 Sep 2025 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757345296; cv=none; b=niS9//dqOtCIneGBmFVNDnlt+VSiBvVBUq54d/xfA3L0tzTZ01BxVd73CX+FKKOqgx88FFIVnWgZPPPtQbYRTRN/Bs6xXdfx9+EbJUxx/bEMN6bFe4Fmoex9a/t/bgGqX21V2Hkssl7ROG5Ka3G0qRITH/4z3MOjHZz7RjYvdog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757345296; c=relaxed/simple;
	bh=IL9lnqQXoeEQECYNv61WPi9hBHFk6AjV/ccUc6R4VhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fOFcNZF9EZBWPSZu/Nr2pU4eAGSznPWDqU6YgOAATAF3xpDZg36pSyvtxmyq9H8/moCrX0tZh71xlch5J4oomJCpLjCQViSVWry0OPbaH8jM9IUk+Y/m2M2kF4fE0QY84uDPz7Tw+yjITML7eogmfu1ZVagxmWtsFMdPB1S0E+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HX1WumBP; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HX1WumBP"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cL9ng4tgMzm0ysv;
	Mon,  8 Sep 2025 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757345284; x=1759937285; bh=ZmP43ztIWQvs8cAYII3r0KAQ
	bnKcLwOTP/pXj06Tob0=; b=HX1WumBP9tHG3MvDrbxHauDTh3flyaZ+1d4u2qsP
	YqLR0qhAL3boFjIV1GN+jbMksvOoIXdiXXUyUYpbMpya8JBQilXwFjX4w5furYy+
	zbQltR3Eo3cOfuDJ8c4/pHtxfKRNQZJrtFqL2mFmMJu5n767l2Vz/WxdppzEm6I9
	Z5t2wnqQb+FuCtxBEn7aWB6kiPRb2SRJYlQMfYVc6efcPAPaS8S+VtsDNpHUgN/L
	CctChEd8pKbm3B4vUGHpxfLEebEq1rhM00bZCluPkC9WJ4ilSld9+/FEyvWKWOYk
	kIjP4CA9+ubPPigPw7pHSnMc+zFBcr8MS5R2C2gqweDxMA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LpbeJA7ztnSv; Mon,  8 Sep 2025 15:28:04 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cL9nN3RF3zm0yT6;
	Mon,  8 Sep 2025 15:27:51 +0000 (UTC)
Message-ID: <e090d044-992f-4f4e-b0ca-c310f733b4ed@acm.org>
Date: Mon, 8 Sep 2025 08:27:50 -0700
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
 <854fad23-e7f8-42c8-b0e2-03460f481366@acm.org>
 <561a01dc2094$51b24b00$f516e100$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <561a01dc2094$51b24b00$f516e100$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 12:43 AM, DooHyun Hwang wrote:
> Would it be acceptable to add UFS_UIC_SEND, UFS_UIC_COMP,
> and UFS_UIC_ERR at the end of the enum?
> 
> I am aware that UFS_DEV_COMP is currently not used in the code,
> but I am concerned about whether it is appropriate to modify
> or remove existing enum labels.

Please take a look at Documentation/process/stable-api-nonsense.rst.
While the Android GKI kernels have a stable ABI, the upstream kernel
does not promise a stable ABI. Hence, the concerns that apply to GKI
kernels regarding changing the numerical value of enum labels do not
apply to the upstream kernel. It is the responsibility of anyone who
backports an upstream patch to a GKI kernel branch to make sure that
the GKI ABI is not modified.

Thanks,

Bart.
