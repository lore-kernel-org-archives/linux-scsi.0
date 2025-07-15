Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4DA2264D5;
	Tue, 15 Jul 2025 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752598647; cv=none; b=IJ6cC2n01/ZwXA3AbfqqXFdgwO5wAI6CWxNA0/pTdeAu5SZYXEFepFzdu302mRasjNDyzqjMN6dnbf9dCaP5i01rKh1kG8qHR65gw1dA0Ca71VACLOFfAsV+Xgv8bnEYC6HoqIwQwhrWNUyQ4HYTAcMpERhMnV42Ji+RiAVpTqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752598647; c=relaxed/simple;
	bh=oXDP5W6ruPXMloIGWP6N8fqg75lcZA+WIEvRQZYSJck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fe/pCI/WdGrHHCatb4OW8ac6wP9fipNeAC2maRLRBaFORCo3AV/DRBvqBi/GoLOi/yziruu8NwGQhTNDLizYdcEn3tYI8SDFY71EzdBByN4XMdKvEh2ElCwBWOwV5OJlviTSs5pamIIx1qP4m1FjrdwpvUKjqW/G3gCjhi2q7PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wnw1Vnd+; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wnw1Vnd+"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bhQN500RPzlgqxr;
	Tue, 15 Jul 2025 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752598643; x=1755190644; bh=5/3hasJlZZslHaoIJpIUIG0J
	gPXZITf394ehkRTNpds=; b=wnw1Vnd+tM0eSbP2lP1qcrVk+l2pcTtQnF1MkRPc
	kHALdve2CVOlu/i6iwN9cC5dmOH5HUscHCEe4Hufw01FFWtzK16dqINqdBA5gwfS
	hgEa9YI8+ThqiJKl1IO9nxHecOocZ1ZfCx8+4SIPD9tDMkcRcJq/6YeL9+6AGjSN
	YOVLvuT/7SkLri+lT0LLCc4KjQV0ChwFmMM7VLbpRwY/8OQV4R8SQXSbOxw6JXlD
	VpUENmhczjJbinWbTikfn6Zg+o9vYKHqAgmbW0gzMH/dNMgYDWXj/BfA1ORgHbQ0
	0ZGYprZHmdYBzFvpvuDsxGYEfsMezsf9uLqSRlnE2/IEFg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QyYDtz6TKa28; Tue, 15 Jul 2025 16:57:23 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bhQMz4Z6Szlgqxh;
	Tue, 15 Jul 2025 16:57:18 +0000 (UTC)
Message-ID: <9500a7cb-7b60-45c5-bd9c-1ee921ab4b58@acm.org>
Date: Tue, 15 Jul 2025 09:57:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: fix out of bounds error in /drivers/scsi
To: Krzysztof Kozlowski <krzk@kernel.org>, jackysliu <1972843537@qq.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
 <tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com>
 <bf166912-80ef-435e-885d-affce237afe7@acm.org>
 <8aa33d58-c46f-46d3-b10c-f6b9998cb8a8@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8aa33d58-c46f-46d3-b10c-f6b9998cb8a8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 8:36 AM, Krzysztof Kozlowski wrote:
> On 15/07/2025 15:00, Bart Van Assche wrote:
>> On 6/18/25 9:03 PM, jackysliu wrote:
>>> 6.15-stable review patch, vulnerability exists since v6.9
>>>
>>> Out-of-bounds vulnerability found in ./drivers/scsi/sd.c
>>> The vulnerability is found by  is found by Wukong-Agent
>>>    (formerly Tencent Woodpecker), a code security AI agent,
>>>    through static code analysis.
>>>
>>> sd_read_block_limits_ext Function Due to Unreasonable boundary checks.
>>> Out-of-bounds read vulnerability exists in the
>>> Linux kernel's SCSI disk driver (./drivers/scsi/sd.c).
>>> The flaw occurs in the sd_read_block_limits_ext function
>>>    when processing Vital Product Data (VPD) page B7 (Block Limits Extension)
>>>    responses from storage devices
>>>
>>> A maliciously crafted 4-byte VPD page (0xB7) would cause Out-of-Bounds
>>> Memory Read, leading to potential system Instability
>>> and Driver State Corruption.
>>
>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 
> Just checking - are you sure? Please be careful with this work, that's
> AI generated stuff which in some cases did not even compile or did not
> actually follow C code.

As one can see here, an in-depth review was performed before I replied
with "Reviewed-by":
https://lore.kernel.org/linux-scsi/07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org/

Bart.
