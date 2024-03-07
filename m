Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CE526AF5
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 12:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709812886; cv=none; b=dx9Iamx/RFWZbEYiacipYuRLrbbS5d2dM5Ui4FZGfc/h7z8xV7EHRGPmM8UyKtgl9a+k/f+tUViOoBLZwIzjpBWBDoJgJj9bmGwL2iHj8eYeVhqjzpMr4xyO9XNkFQqoLWH6I6XmJVs1f6hWO5CiDCYiI3ts+d++DswYLiAdzz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709812886; c=relaxed/simple;
	bh=vMWexk4o0w5tHKnMG94oOSXEzghcC+F64ycDSLUmFlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qVDfvhgXS9EsQDUAdM5DRx7u9K2zXeyGtdkVBcfu4CUaR2OnSpplgN/qLWvRYK+XM+arQjjwM+UqRaIvcyBshCSWZ5VpDfDLr9A1q1MKvTYyCepu1rAF2gCRh26S92PuvMomw7ae3JYQx1JDqwJX913kkXPdqz1DqTyg4+Jlo3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33e12bcf6adso261541f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Mar 2024 04:01:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709812883; x=1710417683;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oF6KmtBzNdpCIaFyLBmiCqb1PMnj7ILp5AYIpT88ggk=;
        b=qtfhQPoCiGMWfpWN/gxItvb8qscVScexTUpM//xzz+MCjIYKe5qAR+b+mlkrT/0PVs
         LFnDi5JoJtXmcSI9dyYUzyVojpBBcqZUbTG+MEieLJ72Iw16arCbuVaUlcXRHt5weYzL
         wqRHXd8CUVmpY8osvBe03vXkIuDxiCbVclpvWX88xjWdYN8GBbDB7ZAzSlDoX6QHf3K+
         Aagt9NAsMSDb2qnQdZa1kCGuysO2zr+9C8o++PN0fhZvJfxOrV9tB0TODNgwHBBdFl/0
         gfSKYIlE5rvS5S4Z5hMZ2QrDujvMSQ4Y7Fo8ozuq/PEY8m0sWNgBNyLeBx0bkKZLX5QP
         LUTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzowMvdBJ3itCxGC37i60n1EPQSu3a2OrqYeTOWgCPnPi8RNTpw9GpekAA9KAeFkCGv85IYdZEC30DZ7B6rbN1aLv0aFwvJrfZxg==
X-Gm-Message-State: AOJu0YzhXVel6NuIWM/gPbDHTId9eTfSV9azWKhgWqNWxqzdO/6eQ8XF
	2M/TLVIaGf/L2P0VA/j2KUl/Kj8eIGLkhRmjNVZ1jSUy9eTupMHd
X-Google-Smtp-Source: AGHT+IE8EIJv4HKsw1/7TPhcT7wGmEYZ7Bg11FYc3xz7mIiR/pat54vciH562myB00TqCIW4zTWYkw==
X-Received: by 2002:adf:dd87:0:b0:33e:4503:3ba4 with SMTP id x7-20020adfdd87000000b0033e45033ba4mr3637618wrl.7.1709812883215;
        Thu, 07 Mar 2024 04:01:23 -0800 (PST)
Received: from [10.100.102.74] (46-117-80-176.bb.netvision.net.il. [46.117.80.176])
        by smtp.gmail.com with ESMTPSA id j16-20020a5d6190000000b0033e0019b814sm20008084wru.34.2024.03.07.04.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 04:01:22 -0800 (PST)
Message-ID: <7ff7c9cc-6b02-4adc-9b78-8bab26341049@grimberg.me>
Date: Thu, 7 Mar 2024 14:01:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] nvme-fc: FPIN link integrity handling
Content-Language: he-IL, en-US
To: Hannes Reinecke <hare@suse.de>, hare@kernel.org,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, James Smart <james.smart@broadcom.com>,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240219085929.31255-1-hare@kernel.org>
 <1dfa9a4e-e4a2-4d48-b569-85e48ce4311c@grimberg.me>
 <1c3eea31-b80f-4b95-ab15-ac42f7c45c16@suse.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <1c3eea31-b80f-4b95-ab15-ac42f7c45c16@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 07/03/2024 13:29, Hannes Reinecke wrote:
> On 3/7/24 11:10, Sagi Grimberg wrote:
>>
>>
>> On 19/02/2024 10:59, hare@kernel.org wrote:
>>> From: Hannes Reinecke <hare@suse.de>
>>>
>>> FPIN LI (link integrity) messages are received when the attached
>>> fabric detects hardware errors. In response to these messages the
>>> affected ports should not be used for I/O, and only put back into
>>> service once the ports had been reset as then the hardware might
>>> have been replaced.
>>
>> Does this mean it cannot service any type of communication over
>> the wire?
>>
> It means that the service is impacted, and communication cannot be 
> guaranteed (CRC errors, packet loss, you name it).
> So the link should be taken out of service until it's been (manually)
> replaced.

OK, that's what I assumed.

>
>>> This patch adds a new controller flag 'NVME_CTRL_TRANSPORT_BLOCKED'
>>> which will be checked during multipath path selection, causing the
>>> path to be skipped.
>>
>> While this looks sensible to me, it also looks like this introduces a 
>> ctrl state
>> outside of ctrl->state... Wouldn't it make sense to move the 
>> controller to
>> NVME_CTRL_DEAD ? or is it not a terminal state?
>>
> Actually, I was trying to model it alongside the 
> 'devloss_tmo'/'fast_io_fail' mechanism we have in SCSI.
> Technically the controller is still present, it's just that we shouldn't
> send I/O to it.

Sounds like a dead controller to me.

> And I'd rather not disconnect here as we're trying to
> do an autoconnect on FC, so manually disconnect would interfere with
> that and we probably end in a death spiral doing disconnect/reconnect.

I suggested just transitioning the state to DEAD... Not sure how keep-alives
behave though...

>
> We could 'elevate' it to a new controller state, but wasn't sure how big
> an appetite there is. And we already have flags like 'stopped' which
> seem to fall into the same category.

stopped is different because it is not used to determine if it is capable
for IO (admin or io queues). Hence it is ok to be a flag.

>
> So I'd rather not touch the state machine.

I'm just trying to understand if it falls into one of the existing 
states that
we have today. Because it sounds awfully like DEAD to me.
