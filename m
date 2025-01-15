Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBB45223;
	Wed, 15 Jan 2025 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736963626; cv=none; b=AVnS0wI8oZ/Z7ZvgWT4S0svZveUg0UwJO+eO0MiDaWrsqUrbdwBcy3x0Beb4YB2/q1XUv2SG4PpgDwhEma6+gO83dKelHkv9M9tHp1nETsHfVk5SUQOl1iWpRZRhkkXsl7W/7xbOP4Q3atgEshjU3Dx5S0Qzg3K9k5N5NE3+rrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736963626; c=relaxed/simple;
	bh=KnvMDcCnWCybnStfvY1jJiCVNzq0woBniXPNPwuLqos=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y2AAx9YeYxbNVWuFA5qJhXSZb7+Vrg0cxudcMCRfK9J4TQW7v9kq3seCIAmHuxbBS3tbXCr62XSEQRAL2XmEwzasI/MAsvA9vnrmJNtvR/2VAOLGOw8Gdrqwngt5Qoco/CPaf1vr5p0ByIehAkDP0dQQVFRBTICBaLcM7kIm1BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ng1loLEu; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ng1loLEu"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YYDBc2k4gzlgMVW;
	Wed, 15 Jan 2025 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736963619; x=1739555620; bh=is/Az9xGToTsuvQhxSyLFLcX
	vYqhkADF/5ojbpYHtBU=; b=Ng1loLEuc/xiqIXDqAxKT0RhMLuNdkB/9Ztk1mYg
	n0Izfs2wFJeOI8t6HeumaGvHR/ZMQ57s34/kmp5CKve9jiZp7LxOGsqpgxBeAhDc
	gXuzQ1VptPRYXKa7lq52Du9YpK6NchNqwhDtNWkSiUqJb0L2jPYugDgXrHXczv1z
	KDrO4ji9MW/EE86h8Ak0ao3rSqvuiQ1XOTqcTPrXCeGWzqCELR0he/gxxjZLvVft
	AHK/62cFZEUlRWvl/XjzCki6DA5xIwSl5vsxvV+Zfv7DENIOUaBrpfGqAMIaqZ87
	9vKHr2cJ9RSbkMewHkPgVzOYKtVxHNQTE1Ha5y9hyLALPw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0lmg9n-RFN6D; Wed, 15 Jan 2025 17:53:39 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YYDBR19J1zlgT1M;
	Wed, 15 Jan 2025 17:53:34 +0000 (UTC)
Message-ID: <ca5482da-1612-4fab-bfeb-bdc72cd65662@acm.org>
Date: Wed, 15 Jan 2025 09:53:33 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: Use str_enable_disable-like helpers
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
References: <20250114200716.969457-1-krzysztof.kozlowski@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250114200716.969457-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/25 12:07 PM, Krzysztof Kozlowski wrote:
> 2. Is slightly shorter thus also easier to read.

Does this change really make code easier to read? It forces readers
of the code to look up a function definition. Isn't there a general
preference in the Linux kernel to inline function definitions if the
function body is shorter than or close to the length of the function
name? I'm referring to functions like this one:

static inline const char *str_up_down(bool v)
{
	return v ? "up" : "down";
}

Bart.
