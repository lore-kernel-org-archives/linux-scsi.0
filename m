Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DE93A0B0F;
	Wed,  7 Jan 2026 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767805069; cv=none; b=jaN9efhGxOLiepUUYB3i2foCKEZnyjQS2+eMstMQ2oEI4Q4g/9B5FeqxGkQ/sQWigD0kpIHj7OWrkYH9VvaF9V/YMLjf6fWq3/IFFu3fhbR4MpHYYZSwKXCxzYcyrUvJ9yD/sFSYX+9Z0/KgXKYMNC1+B6iTox78sDvZ5XTmMXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767805069; c=relaxed/simple;
	bh=rAw+5LZd/B4jlChyb9rk74sfa3DPqho5L0M51lDHHJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c/shTQRWo2DYDKsS4jysUuZf/ZfC+w5EfpP2U0RllFfNlPnfHKGtiX6G9kLAVyi+xishFnrBKHF3zh3zFz3KIqQLCQeT9mVu/20yR3AJ01R+xWfZjB0xB4CRWc72GPsKoNRJZt1vpILey0aPAzb+WO2Os9MfPL2IMYclUzYpLrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4Gz+qQLU; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4Gz+qQLU"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dmZ302H1KzlkMXq;
	Wed,  7 Jan 2026 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1767805049; x=1770397050; bh=otEyuX3K80BYoIYcGZRsH2ma
	7v0aBo0pa0q/PC9OwEc=; b=4Gz+qQLUWeQghZ89CLQ7HDYP9UBzHMpIxZxNjLGV
	eF/OXUHveY0GAGbgGzeKaFF+8MJqQ7Sn/QYFZ1COR7UaltAm/Ie13ySSdUn8A247
	M4+0vuftzuSUc/GySb8DJQ0jGwDIrSsQ0977F+zaes1+hN3OVnNDqYZhMiLJdV4N
	VUuY3XT+WK6iud72WiPrsTgtM8NiCzdXjxw/FnwuVfoSXAFd57Stsx4OheJQBs39
	dFaTdA5MC/NUg1Q8Mky0sdnVSJYccU/7v6aL1lpKVFrkgqWlSvubshF0IKCfdFLz
	UADbbFmwoQh8q7Ou2dacubHK9wicONo7ElVA7u+6zTZ59w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DYajElaLYGq5; Wed,  7 Jan 2026 16:57:29 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dmZ2t4N9Yzm73Bk;
	Wed,  7 Jan 2026 16:57:26 +0000 (UTC)
Message-ID: <7c3c2687-12c8-452d-86d7-78b3168a8f01@acm.org>
Date: Wed, 7 Jan 2026 08:57:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: exynos: call phy_notify_state() from
 hibern8 callbacks
To: Peter Griffin <peter.griffin@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com, andre.draszik@linaro.org, willmcvicker@google.com,
 tudor.ambarus@linaro.org, jyescas@google.com
References: <20260107-ufs-exynos-phy_notify_pmstate-v2-1-2b823a25208b@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260107-ufs-exynos-phy_notify_pmstate-v2-1-2b823a25208b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/26 5:51 AM, Peter Griffin wrote:
> +	union phy_notify phystate = {
> +		.ufs_state = PHY_UFS_HIBERN8_EXIT
> +	};

Should this be declared 'static const'?

> +		phy_notify_state(ufs->phy, phystate);

Can you please ask the maintainer of include/linux/phy/phy.h why
phy_notify is a union since it only has a single member? From that
header file:

union phy_notify {
	enum phy_ufs_state ufs_state;
};

> +	union phy_notify phystate = {
> +		.ufs_state = PHY_UFS_HIBERN8_ENTER
> +	};

Same question here: should this be declared 'static const'?

Thanks,

Bart.
