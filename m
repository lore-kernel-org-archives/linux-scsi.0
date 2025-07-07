Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5CB19E97B;
	Mon,  7 Jul 2025 20:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751919518; cv=none; b=AG7x8RxfsSXvfEF+R5RYSPpQzO7qfqzQZexIg/IcAwuWrynKVKLVUdW7qJ4HWFnp2zkv+doRYP3fZwVBzDlvgpV29FPl3qjnvLSHEcPKi7UqgAc8SgSwXNRqWU33L0fVcGMl42J+3IoWg/MFLozrrCc//uJX1TwDyAmOB154gjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751919518; c=relaxed/simple;
	bh=MH6AW7DZ/+6oxcmK2lbp/E4s2yvinxh6tDS7lCW48ZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hT4p1rjG7muko/hJdwT4EjI+gTx88tBubTTxjlpD4gB8j9nvJ74QSo0ObAcNP307GD7t+BIrUVlPytOhgKrLpDS2BExCRiGCHQexeYAYTLdqlkMvidPw07PZz5xa0pBfY/Al546DEJcfMPMUGIGByKrwn7jWcZzNRdyynZgholU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jSR1FrsC; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jSR1FrsC"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bbbCv3q9Hzm0yt2;
	Mon,  7 Jul 2025 20:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751919513; x=1754511514; bh=MH6AW7DZ/+6oxcmK2lbp/E4s
	2yvinxh6tDS7lCW48ZU=; b=jSR1FrsCl2VS0dFJCuOShZLpG0WDsBAU0/hDbzeA
	l39wESHmTAQftBnRGuphZAqsS/E2PJ1fbQ9oLv378acS3Ffph5wYOsCY0Smes2rY
	BA1hahqSW6U0U1AIBSXluY6UQzf/ROej8ZP9GQux8jacZ2jGAVN/KsNrrsgQlq5Y
	+vYkUfutjXKJ8DS/81QIcoOKKkatBJgIyVuL6COuUZSGaD52LPP+Vs20eN8Foihv
	cvBJZhpBm2+hKEvpIFIsgmGYzOffRQRjpDTWQEh7ingXuV+1yDOUGGj+BBfNup7s
	4g0jFstuvU87VKPYT15PWWxdgsgurgH20P58Iga1mtwwbQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RmX8vjQgZHsO; Mon,  7 Jul 2025 20:18:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bbbCl74C8zm0yVD;
	Mon,  7 Jul 2025 20:18:27 +0000 (UTC)
Message-ID: <bac5f533-0513-4d59-98b8-de44a08daef3@acm.org>
Date: Mon, 7 Jul 2025 13:18:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: exynos: call phy_notify_pmstate() from hibern8
 callbacks
To: Peter Griffin <peter.griffin@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 7:07 AM, Peter Griffin wrote:
> Notify the ufs phy of the hibern8 link state so that it can program the
> appropriate values.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
