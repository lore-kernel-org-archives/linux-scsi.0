Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65B65B1EB
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2026 16:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841144; cv=none; b=nQbCnrcc6z9siy6gywfBHCUMjQpU5ngSFFm+TGjC/4T+3KctpV1YmAyBReLaFvGjhN2B0JNgNvVZxzQxrfkq629Q0R36zwTnkHqjxbremqQ4VD1ah+4TMUE2OU70W/nmYoEjMPXqoXqCliEdkUI/bDf7Z4TBycJLcuBxuTH3pwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841144; c=relaxed/simple;
	bh=B1eb6IqzBDlJFXQ72gfkaNQqbfxnVfEjWlWpYyR3GrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nYCshUmHci1hoZALGM92i6w2aT/fBIiNBcogUN/rPKwdtBTYkbfkNQ+71d5ei+AFuzONP4atDBglTmSq1LdugHfCuyaSXcRqTkSrShlUnTUEwECU5A5UkvMmz5fuxE0WDyeVYC1lKgw8Q8GpZTc8+KWqOvmmuHeglvfQbJ6aXWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=egro4yRk; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="egro4yRk"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4801c2fae63so26943215e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2026 08:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1768841141; x=1769445941; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9XcvfZWr2HkEDGryCefoUZ45L6w6hxLADVHa9gQVDP8=;
        b=egro4yRkSFBU/aBJzONbn0BtALCEEBQdfoQj/TcnTqQAWI5VDsZHLzRKZM1BAm+/ue
         sj+xzTqM5SftI5QWn/n6pFn8GrwnSKAtznj3K9yFEeAM3rtZYXfdNoE7aAEhNBaKvNK8
         wUnTzCsu5HHqN7kNEnPi9aB47vJ7axUyp1zWZmj8CcIjo/KTbn5kLp83WYFiYN57DJOO
         bQS8kve9jt3c3jrCvo0lpNTETfogqODEe+g8aqqKL7OKCbcDyUDZXN98rtytQEbVxctu
         5bZe0PuYTLslgk00sKYhF96kbQDt/Oo+xYcEW21XKJbjncqDQbTiTJjrTZ/kYd5OdpcN
         72EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841141; x=1769445941;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9XcvfZWr2HkEDGryCefoUZ45L6w6hxLADVHa9gQVDP8=;
        b=bXETvyBFR6jMY9VPb3ouTSqKH9UlDrbTzsrPOb12tVJeC9nkOpb9Xmb4HVKMy/YFBE
         8kBxuKQsG7zf0urKglggKRwHIwZXJOjUHULoUmRUcT7FdwEtaOp41ekE0Im5KJU4kJeg
         3Pj0JzbJaqzlNkuZlq5AAyDhE0+N0p0vAJx+di6eDWaepFyvAaJNULxx0IOfbmMx/dy2
         EG7zHtTm6qsrFLdv7uEY8J/7upy1hFBadRKk2vkTKuu5Zb2YPaYc3LIdrgoSQzAJ7UUv
         WkUknKED1uR2pRpFCiAh9jH7IGDDpjovms4BiDTuBO076+65C6UubdCS+ounSKoWfGSC
         TnVg==
X-Forwarded-Encrypted: i=1; AJvYcCV55z4WLWQc2hDBPjxNJ40dIGTKoZbqUkmcUPrKCWJkLt0i6U8iFkRwQk4J+kqsszcqXuWhuHSRTAOf@vger.kernel.org
X-Gm-Message-State: AOJu0YxW0nKOEwcR8SSa93iuybSAJ3AYFkjk6XIrqfGCGIFBGctqbTca
	yqEfAMv4OwoEbCsylYkq86ehyg6wLC0ZkqNmaaIOajFmXJwJkJdekli2KYvGNZLo78E=
X-Gm-Gg: AY/fxX4Cuxf2kNkuCz6xYDoh9aQv1sn/k4MaHntF1+1BqCCagOYycqfNkMJqXa/4ZMf
	kGbnDp3L6HkGElmt+TKhPGt67mIg0zIdAASdUTbu8YGOYZtpuoA4oAD/86VdPRCYhmBX/kyBHXO
	3TK4EL2Ma6yWGaTDejMh9HrSBkfxXGrAtKmDUrpMPUx5UyHoqU/M3MJ7y7uvEx8KMyWhht1GprC
	8W3Or3VfYD6G3NMLZyZLcHxcAO8ULZs+p+/YoqHfztfZfIPa4opLJEqQ0BjqTl/YmqipP70QG3/
	E2Di7h2lOAJLxejIJWtyl/FH0UbPt4xMoR7Jw4OLrsBkCt7WM02S8SWi2dmus33ToaAMVj+7qKd
	xe6fOmglOYt0mijLTpjCm3cxnoS4qqG4uSjLB04gCXu3Git+6MpzsusQ7EaZaRPIgQ21eaFnVbH
	g2XUZ3TD5i4E51BHCyYDsJaZPjQ769d5g/JnPRqYyRhS4EnEOe3VwfN8HE+pWfY+ivclBnlbvBH
	IYFcN1bq5Mb7MvE6DTvvpj5TdFTWfj69RVZHkfSzHZgmTsJ/w==
X-Received: by 2002:a05:600c:1d1d:b0:480:39ad:3b7c with SMTP id 5b1f17b1804b1-4803bdb88bcmr7081335e9.16.1768841140926;
        Mon, 19 Jan 2026 08:45:40 -0800 (PST)
Received: from ?IPV6:2003:fa:af0a:b900:a560:9f31:ade2:1a74? (p200300faaf0ab900a5609f31ade21a74.dip0.t-ipconnect.de. [2003:fa:af0a:b900:a560:9f31:ade2:1a74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e86c1b2sm197523525e9.3.2026.01.19.08.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 08:45:40 -0800 (PST)
Message-ID: <59933d92-eefe-49f6-ad70-79fe7aef0f3c@grsecurity.net>
Date: Mon, 19 Jan 2026 17:45:39 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Justin Tee <justintee8345@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
 linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
References: <20260113222716.2454544-1-minipli@grsecurity.net>
 <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
 <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Justin,

On 16.01.26 23:33, Justin Tee wrote:
> Hi Mathias,
> 
>>> I don't have any hardware to test this on. I just got the report from a
>>> customer of ours regarding the CONFIG_DEBUG_VIRTUAL BUG_ON(). As I don't
>>> have any spec for the hardware either, I assumed a few things, like:
>>> 1/ DPP regions are only supported on SIL4 devices.
>>> 2/ DPP may be shared with other registers (doorbells?) in the same BAR.
>>
>> Sure, we’ll have close look at this patch and test on real hardware.
>> Will report back on our findings.
> 
> This patch has been tested on real hardware and I/O is stalled when
> using DPP.  We can look for an alternative solution.

Hmm, that's bad. However, that makes me think, making the mapping
write-combining may had been a bad idea from the very beginning?

The thing is, the call to set_memory_wc() won't really do what commit
1351e69fc6db ("scsi: lpfc: Add push-to-adapter support to sli4") wanted
it to do. It does change the PTE flags of the mapping, but it operates
on invalid physical addresses as __pa($VMALLOC_ADDR) just won't work.

Given the time when it was developed, memcpy_{from,to}io() was really
slow on modern systems as these would simply be memcpy() and that was
ASM-alternative'd to a 'rep movsb' if the CPU featured X86_FEATURE_ERMS.

However, the LPFC driver already tries to do "big writes" by making use
of __raw_writeq() instead of memcpy_toio(). That should have solved most
of the latency issues back then already which makes me think, simply
dropping the call to set_memory_wc() is probably the next best option.

> 
> Do we happen to have a dmesg log with the call trace observed?

Unfortunately, we don't. We just have a truncated screenshot with RIP in
__phys_addr(), code and register dump. The surrounding symbolization of
register values we have in grsecurity makes it clear, it's lpfc and, in
fact, the set_memory_wc() call in lpfc_wq_create().

Specifically, it's the call to __pa(addr), which is __phys_addr() under
CONFIG_DEBUG_VIRTUAL, triggering the VIRTUAL_BUG_ON(... ||
!phys_addr_valid(x)) which boils down to BUG_ON() under
CONFIG_DEBUG_VIRTUAL.

> 
> I plan on attempting to reproduce what the customer is observing by
> enabling CONFIG_DEBUG_VIRTUAL, and would be helpful to see context
> from a dmesg log.

Just loading lpfc.ko with enabled CONFIG_DEBUG_VIRTUAL on a DPP
supported platform should trigger the bug as the set_memory_wc() is
unconditionally attempted in this case.

Thanks,
Mathias

> 
> Regards,
> Justin
