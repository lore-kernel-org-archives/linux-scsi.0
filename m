Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125662E0938;
	Tue,  2 Sep 2025 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756830899; cv=none; b=l17QwmDfaha5fHVWUfah8BURrqzSnVBSGCWAuwkaA0x1SbgeHLFiaaRNVUz1nxhAtXFmOBE9cOKPQnMDBFa7+NoesAIoxPygBm7OIWExynbZMPVBPzUyiKe12cXx58dcxCdL+mxJPhMtEbACKQYDeIzJWf5j+dhBu6sHQXWCrKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756830899; c=relaxed/simple;
	bh=WKE5YWde9vUZoAR/YE6COM2HF0cSOqVSYHHws5xDHyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hx7EcLYp4zLTCVv9Gy2wp7od2aqjToGu1qf7Au+2/ZUIKzsmp0QXL8GKMprzA8WNWTjP4mWSfMDpsg8AeW9kSSqpDOj8x1Uitsrv3q8WSzDG+hjb+G+X0IxVvntYKVlFpNubOg9IAjIL/J5u1at42xJgsJ0NoZYdLoFSTo3mdQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=se378+Ml; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="se378+Ml"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cGWYY0nNqzlgqTx;
	Tue,  2 Sep 2025 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756830889; x=1759422890; bh=WKE5YWde9vUZoAR/YE6COM2H
	F0cSOqVSYHHws5xDHyk=; b=se378+Ml1jVW4IIN1cr95WhNBuCixzsa0pFwo2Ym
	JYcwfUfqpNLKnL6G46EisGaEQgJUmKAymeMTVpOaQS2owrWwOldYrxY6zPnoTYsp
	bPxXFhktCOeQXU3Onz+ErkAIAPYkZpXpXFmgkFYEd7kKmp+loxgQpbiXbluk2ANb
	kGV/DgnmcY1vkg19OYFo5MpOAGfFFbuZPoDrxIsr8vhjTFfxDoGPYw4L9H+f40o2
	gknZNMvo0iz7HLIv1LwtUpTEpow3s4ilmwXRNFfN3Pxc0yzptchvyxBEMbBwmo0O
	LMNpvDhDGB1u574KdejdD5nC5nwaNYdb6jb5fbbFqAEoJA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5HmvpwhRwGtA; Tue,  2 Sep 2025 16:34:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cGWY55XqyzlgqV7;
	Tue,  2 Sep 2025 16:34:32 +0000 (UTC)
Message-ID: <6e854090-a071-416a-b7a5-cc8ee0122a90@acm.org>
Date: Tue, 2 Sep 2025 09:34:31 -0700
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <17db01dc1ba6$41d37350$c57a59f0$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/25 6:09 PM, DooHyun Hwang wrote:
> The UFS_CMD_ERR stands for "command completion error."

I've never before seen anyone abbreviating "completion" as "CMD".
Please choose a better enumeration label name.

Bart.
