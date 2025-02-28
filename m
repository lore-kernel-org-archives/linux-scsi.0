Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BB51C1ADB;
	Fri, 28 Feb 2025 19:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740770485; cv=none; b=LWgz7l07Zcew0M/RoVdMAIcOS1Hn5irUXBqo2ZKOofb8zDX1afuXVnVwh14m61rHA/JDlNUBuQTHXe5l3k+UfXBpyFTiDQvkVKGwW2IWt8gsU1FDXWn7ZRB9RqEsgUvI00ZSkxqw78VDpAuVbhSpwlorUXjkNU3JS1VXRFWOKtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740770485; c=relaxed/simple;
	bh=FEsc6aFAVmHqCUEwNlGCIO1d4hA0FEHyKLGIUo13iGE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uwmAOZhTsQdbdEQsqU7TV6dq0KXAYcC1Nvk9jfTcQC8r0MQOaT5nobHy9v7Xgo3yi3IdSGmsvqPUwxFPwAU0uhf20Mew6fkWVao9K38hUR5kM0uIq9Px8YQQqTCAk4j9ICX7jIMm7GItjLuBuyfYYBBDCPYRoZWCm8YWbakEMyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=upmCO2JH; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="upmCO2JH"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z4J3N0hTjzmJ6L2;
	Fri, 28 Feb 2025 19:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740770477; x=1743362478; bh=FEsc6aFAVmHqCUEwNlGCIO1d
	4hA0FEHyKLGIUo13iGE=; b=upmCO2JH6k7i3rWpPugyDfSQasJDc74pLu6GVEVH
	uaA4dFIsnJIDjEvR1aVvWBtL6gcasIvAWnxDehVAs98C1VuAaIwEdoSByHhzW6UY
	oTalkwNtQBy3ZIC4yVQj4nN/NIzkZFbP658Ilt7SNgG5fcHu9BfHNUANlKuxrLbf
	Pq0zftpPGLInvRcrxzlAG/7bcbIHUbzEjXABizCnALDeheyB4Ee4/v5fPRKWkv1y
	drYdQqNenvwCQPMaP90FAuSzZehLZ//ofuBTQJFMRZ8KWlOmNFwVxtZrAZK4bDsz
	kDwI6qpPWn5L5iWPxqB34/kto77mCgZANSODanszmTdyuA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2XrMjxKRLh1p; Fri, 28 Feb 2025 19:21:17 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z4J3F45vCzmV7dH;
	Fri, 28 Feb 2025 19:21:13 +0000 (UTC)
Message-ID: <015ce85d-c62b-472c-8527-33217ad815eb@acm.org>
Date: Fri, 28 Feb 2025 11:21:12 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] scsi: ufs: exynos: put ufs device in reset on .exit()
 and .suspend()
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 krzk@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 willmcvicker@google.com, tudor.ambarus@linaro.org, andre.draszik@linaro.org,
 ebiggers@kernel.org, kernel-team@android.com
References: <20250226220414.343659-1-peter.griffin@linaro.org>
 <20250226220414.343659-7-peter.griffin@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250226220414.343659-7-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 2:04 PM, Peter Griffin wrote:
> GPIO_OUT[0] is connected to the reset pin of embedded UFS device.
> Before powering off the phy assert the reset signal.
Does the above apply to the GS implementation only or does it apply to
all SoC's with an Exynos UFS host controller?

Thanks,

Bart.
