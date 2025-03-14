Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645CBF510;
	Fri, 14 Mar 2025 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741968074; cv=none; b=UJ4s2H0MTaWzLpHZXlzTjrLsny39VHhVguDKtpHl4QWySexQilBwJlC1WysYVmY+pM9am7d4Dryeut9ka7Pf4JpeOUfkQqSm0Wsafsoj/N3DSqTwfAEYoBQYMGd/bgda56NPzbgEhCANL99HETy9rUNEMLqbuiG2jRMWDB8PmVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741968074; c=relaxed/simple;
	bh=rXJyhLZM0wQnuMA6BY86fx7l1XvsG57/1opLs9TF2k0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bNsLtgZX6Kzv89+MXbw72OQ4px54dNfHAACjxGGwujvw451kLh0gSnJNRqpIE4AJH9gTipb9zLj3mvYXL9oDFY4WP077kbBl/1EvuLAP4FS2PbJ28rwAZ1fmeCGnoBBTdzL0LMiwfVFJea5UcPOnOI7q4WblHb164r9/dR98jN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aEo7PzKD; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aEo7PzKD"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZDpxw2lf2zlxdd0;
	Fri, 14 Mar 2025 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741968065; x=1744560066; bh=rXJyhLZM0wQnuMA6BY86fx7l
	1XvsG57/1opLs9TF2k0=; b=aEo7PzKDFvqEu1SpnvxvHFFD23HwXN7o7B14pn+T
	nkwZ6O9nOQH4aWdeR8HCx33d5yIF/mdttl6f8EPzQkHK89SXd4Aho16S0ZythcsP
	cA55cJMCbIm1djaeOSyu/7qaO7aeA1833OZRGaX9DadZ5HxBo1TI1cr9soH9bfHD
	wnaUbzJ0XHfIC70bsVsj8EiPqpvZcUoYWhej0mi5Gfl2aT+H6gq9VNVScFj+5d+n
	lzoAfEyyK0aWgBiIJ0MXXoOJ/s9zttde3/k41PbTePU2bK2JJoKHnHnf5CLeSXOU
	60V4UHspkVUPt/ftllQT+ZYtSTbT+s52m5FjnGxjdmKcPw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DP3PM_usb6m4; Fri, 14 Mar 2025 16:01:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZDpxW0567zlfdj2;
	Fri, 14 Mar 2025 16:00:46 +0000 (UTC)
Message-ID: <0d7a8cad-adfc-4cac-bcc6-65d1f9c86b43@acm.org>
Date: Fri, 14 Mar 2025 09:00:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Add dma-coherent for gs101 UFS dt node
To: Peter Griffin <peter.griffin@linaro.org>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 Tudor Ambarus <tudor.ambarus@linaro.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, kernel-team@android.com,
 willmcvicker@google.com, stable@vger.kernel.org
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/25 8:38 AM, Peter Griffin wrote:
> ufs-exynos driver enables the shareability option for gs101 which
> means the descriptors need to be allocated as cacheable.

Shouldn't that code be modified such that the shareability option is
only set if the dma-coherent property is present in the device tree?

Thanks,

Bart.
