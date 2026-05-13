Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC803A9851
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 18:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778697624; cv=none; b=dNIGM+hbr/yE4ZxQgwc86otAoO2RgBoYFodGhjs2V725nfuLBLzEwxSGyrGUb1JO3FQrXceg1dijs5o3F49sVAiMmW+B6UW73/1tAnroGXJRBNmcsIzfPIqYXxsKOES0qKh72x1b34J9aQ3AcIvHqHWsthUBbvr9ucOaBsdt4kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778697624; c=relaxed/simple;
	bh=Sf7HH5W5t6dY0UbzMWb2M4YjTdLvzVmVuDcbnqP7SPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmrAjAlUb1YzSMP0jKPbZd1NlEooHl5i34k8bc8JQSm7EaR2ga2tHb5BbE5aiATZh4FckZv0zLYBDKkvidhQ8mPZfTpdpdD+1SpFD6/oHcBFnoaSm9Y0KReAI85S5JuS2sd16UFum3TgFkUz5tpPQni4IhZZ8BLmspx55D1w2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ergNJ2B2; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ergNJ2B2"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3680540a6efso2901063a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 11:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778697622; x=1779302422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=0z3WTHItJ9pKFSbovpVeFtJ3dLoxFrCzUXGpgTYtaP4=;
        b=ergNJ2B2bSD93fuWN3uIlMD6KzQDhsE2EA5qyBwQ8r9mwznjfc5W7IrdsrEB/vn6Ns
         hxuFOnAywXEMb7TQr6r42ywa3kpuuPcoDIFwLHsOpYCPM2CrQ90L/V0f91Rba2q2RnJK
         detUgk3Co46DfDlixyRgBsnAghXOXsRexWIAboY8DAIZtduOqB+p9nhigCVVa3GPES0w
         IH0cllmvIfHyPxDzlMw++7bBPBpTvD8LHv0Btj6hdd8IHP0q0UwVUzyhAwWg7Kafhpc8
         L2NmbPSqZTK2g853779DObjFqIHZ/NmHDsMgpYvN7X9BQ2SNg4Y+joNQSoqmhjMRvLga
         yxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778697622; x=1779302422;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0z3WTHItJ9pKFSbovpVeFtJ3dLoxFrCzUXGpgTYtaP4=;
        b=kOUPg0CG0Qb31rIBf15ApOH1LY6fHasva2MMwqCwOSOE0w+NuqfAWwvTqxHRGEULXg
         AqJM1BRKJBaYvbcwJaNv8Hjwq5VHRncL2FvBsc0/kloF2PEwcrOyzqL8YfpjyXK2qTzQ
         sX8NMDnX7zzJXxV24r5Zn0mz3Vswc/sngL3kfkU+45E9MOi8SIuaAHG81ke2AaHr38ue
         CO0ZpmaJIpiI81xl8M+iaSSp/QumcqRHqhuuOnjcEwCwFYbk58Y7uRIs0U2sWcFGyPrp
         1nP9SkI0MDYFkV07WuZ98jaQFp8JtYQkdRWn9oX0s41v4n5czuCdFXGWSjHW/GgkPEAb
         qLIw==
X-Gm-Message-State: AOJu0YzeNJqtDS+TNyxdZM+KCIFiXBG4SkD3PnHeKFJnt3T0GZ4LmB+k
	sfZlOUlCn40lXwvMM4AH/dtstyPZFhn0coewVR5DoQ3FKQ/sNaL9UrWc
X-Gm-Gg: Acq92OFQmJMYzt/qmHxQ7NCxH0zG6Gc7MRwrd0CljbKTvLLPYi2hISoNPHp02dNRYtP
	S3Qoc5YjrQ+mCf91QVGumnE+LGbn94mbDr4rCEzgSpytgKDlqwphVUzDc5hpQ/RZJw4iq6QYCNd
	mxdM2aJPACttihMMI8gXWC9/q1R0T32v/0k6vacehFn/5rV9m4BsCdXCa8MXneR+WnbwQ/RTlYY
	LOJN9tTqPTbZ9Zo709RSsDOinUJF9A6d9wikyrHiaVMfPSl0Mc1E1Lptrhcq0XHJeVtAoYkBe/q
	Pubgrc69Fmq6A8uh7usP/Y0MxRCLgK0c+MDYoojWX5Xbnv7NR+SUPWx4pUxAU6ZAFPW451c1oqg
	69F9ez3Wcm50808wROcrWlXm4Zy3gjDT+Dr0475SpCC40cH1TsNV449KsMP2pdhiRkjI1t+YalK
	WE6H0+vBuM190yHzLegWaX+/ShjCKYmaNncIprfsu684mVdxJH0rzvk8spcKxK5GE5GNEA4LIk
X-Received: by 2002:a17:90a:e16:b0:369:a78:6009 with SMTP id 98e67ed59e1d1-3690a786befmr1709446a91.13.1778697621934;
        Wed, 13 May 2026 11:40:21 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf4d92asm3998683a91.8.2026.05.13.11.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 11:40:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8f801fd4-6a52-438f-8c99-1cfa28b058df@roeck-us.net>
Date: Wed, 13 May 2026 11:40:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Convert inquiry information
To: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal
 <dlemoal@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260512194634.58145-1-bvanassche@acm.org>
 <20260512194634.58145-3-bvanassche@acm.org>
 <292bb057-f10e-4af1-b0fe-ca83d4f49d06@kernel.org>
 <8ca0f49a-ae11-452c-987d-d90cce8376dd@acm.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <8ca0f49a-ae11-452c-987d-d90cce8376dd@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/26 10:26, Bart Van Assche wrote:
> On 5/13/26 1:03 AM, Damien Le Moal wrote:
>> On 5/13/26 04:46, Bart Van Assche wrote:
>>> Currently the vendor, model, and revision members of struct scsi_device
>>> are pointers to fixed-length strings that are not NUL-terminated.
>>
>> s/NUL/NULL
> Really? NUL is the correct spelling according to
> https://en.wikipedia.org/wiki/ASCII and also according to any other
> ASCII table I have ever seen.
> 

Maybe the confusion is NULL pointer (or NULL-terminated array)
vs. NUL-terminated string ?

Guenter

