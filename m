Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830A2DF5B
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709894330; cv=none; b=lUh9URBey69dKfufcopmOJAEZn2rmrNhP+jC+1Nj1IulzIfj6WA7MV7PCYlTydrPAI5Q1g2nyYR/t8cbHzR9kUiVQCkPUqFdIzEJTC9M4vdJyhUdmYgXolGrEN/ORZp3ALkVrOSAPe5MZQyw3IWunFB0guYhoVDRgCvVG8cPqTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709894330; c=relaxed/simple;
	bh=DWL5KI8f72C/BRL2RBJsjU5MaVyxUE1IBahPtFwo2Bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IV//Pz27UwmmGVrdTjZv+0DHJaEdcV+jBImjSxD/Y4GVHCn0ejI5wu4+HidGgYKuaAmBH0swERq0mUFLxQrqbnjF6C77sK/j21pAzplbqzEIazzQXl72snHDNVF5SRb13SfsfIdyvIkQAEWQVEQ/6CQ85dR0HmcVh8OLVlflTfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-33db19538d0so457574f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Mar 2024 02:38:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709894327; x=1710499127;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I9DdaLlqFZ5Pr37b+RVdD4qdIRmEBx2b/qz7J0papOo=;
        b=QC30V1/F41Ga4h7NVt+oNS0WpA5y3UERiECXelkwTg/MBtrWbvGKc2tx0Bz9jJbvpW
         mET9bma0aapOOQQhQOx5nlHFrndfEzNBKsiESb67s0PDsvHxj/E6vLaW019jZk5ZVyi6
         sgpqMduBCObTcSTAaGU9qGOjdIjx54bw02BeUo1UkObtau8QfbJViQdhFMGguaMAo71R
         lpsNiBlQgBpGQOqoF+rzo/AH5qW6ypMeJxXINwXw56YyBw2sjxaQ54VFwlUr/R+H0i6P
         eenm7SXfpoGbEV7LhE19OcmXI7x+t+6EJ+Y9SIdBmH/We2m/tCxxPwZH818r0WJXSNj2
         0JrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXLiDGG4Y/7ffwh6IXhfuWqVGRp2CZdCP/aEblEQcOUiDjSd8EGwmem5C8+cP/EZoMw1pNOcx8rxzID3jOYi2e5RNdKZmIqxOyYw==
X-Gm-Message-State: AOJu0YwbR7vDokgJWUDoJ9ZzgmVu/aiKqNBwaFv84bqxaRqIH+KZFybH
	dA8ZWCZaXw5C1hi6VYQ1W1+qqlWsPfqYMZUehrYOjJvtj0RJQ/DJ
X-Google-Smtp-Source: AGHT+IHqoDhk7C8TgEawgARK+27E9PwUyHJu3u3cDnCr70B3ZfQ1u0Thi05yFIXcF58HnCS1NxRhIw==
X-Received: by 2002:a05:6000:11:b0:33e:70a0:40e6 with SMTP id h17-20020a056000001100b0033e70a040e6mr1141532wrx.6.1709894326664;
        Fri, 08 Mar 2024 02:38:46 -0800 (PST)
Received: from [10.100.102.74] (46-117-80-176.bb.netvision.net.il. [46.117.80.176])
        by smtp.gmail.com with ESMTPSA id d30-20020adfa35e000000b0033e79d81b7asm410593wrb.62.2024.03.08.02.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Mar 2024 02:38:46 -0800 (PST)
Message-ID: <2b0bdbfb-1bff-405a-8f95-163a99022d94@grimberg.me>
Date: Fri, 8 Mar 2024 12:38:44 +0200
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
 <7ff7c9cc-6b02-4adc-9b78-8bab26341049@grimberg.me>
 <0b18f1f9-5011-46f4-a0a1-a69cd54bfc88@suse.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <0b18f1f9-5011-46f4-a0a1-a69cd54bfc88@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 07/03/2024 14:13, Hannes Reinecke wrote:
> On 3/7/24 13:01, Sagi Grimberg wrote:
>>
>>
>> On 07/03/2024 13:29, Hannes Reinecke wrote:
>>> On 3/7/24 11:10, Sagi Grimberg wrote:
>>>>
>>>>
>>>> On 19/02/2024 10:59, hare@kernel.org wrote:
>>>>> From: Hannes Reinecke <hare@suse.de>
>>>>>
>>>>> FPIN LI (link integrity) messages are received when the attached
>>>>> fabric detects hardware errors. In response to these messages the
>>>>> affected ports should not be used for I/O, and only put back into
>>>>> service once the ports had been reset as then the hardware might
>>>>> have been replaced.
>>>>
>>>> Does this mean it cannot service any type of communication over
>>>> the wire?
>>>>
>>> It means that the service is impacted, and communication cannot be 
>>> guaranteed (CRC errors, packet loss, you name it).
>>> So the link should be taken out of service until it's been (manually)
>>> replaced.
>>
>> OK, that's what I assumed.
>>
>>>
>>>>> This patch adds a new controller flag 'NVME_CTRL_TRANSPORT_BLOCKED'
>>>>> which will be checked during multipath path selection, causing the
>>>>> path to be skipped.
>>>>
>>>> While this looks sensible to me, it also looks like this introduces 
>>>> a ctrl state
>>>> outside of ctrl->state... Wouldn't it make sense to move the 
>>>> controller to
>>>> NVME_CTRL_DEAD ? or is it not a terminal state?
>>>>
>>> Actually, I was trying to model it alongside the 
>>> 'devloss_tmo'/'fast_io_fail' mechanism we have in SCSI.
>>> Technically the controller is still present, it's just that we 
>>> shouldn't
>>> send I/O to it.
>>
>> Sounds like a dead controller to me.
>>
> Sort of, yes.
>
>>> And I'd rather not disconnect here as we're trying to
>>> do an autoconnect on FC, so manually disconnect would interfere with
>>> that and we probably end in a death spiral doing disconnect/reconnect.
>>
>> I suggested just transitioning the state to DEAD... Not sure how 
>> keep-alives behave though...
>>
> Hmm. The state machine has the transition LIVE->DELETING->DEAD,
> ie a dead controller is on the way out, with all resources being
> reclaimed.
>
> A direct transition would pretty much violate that.
> If we were going that way I'd prefer to have another state
> ('IMPACTED' ? 'LIVE_NOIO' ?) with the transitions
> LIVE->IMPACTED->DELETING->DEAD
>
>>>
>>> We could 'elevate' it to a new controller state, but wasn't sure how 
>>> big
>>> an appetite there is. And we already have flags like 'stopped' which
>>> seem to fall into the same category.
>>
>> stopped is different because it is not used to determine if it is 
>> capable
>> for IO (admin or io queues). Hence it is ok to be a flag.
>>
> Okay.
>
> So yeah, we could introduce a new state, but I guess a direct transition
> to 'DEAD' is not really a good idea.

How common do you think this state would be? On the one hand, having a 
generic
state that the transport is kept a live but simply refuses to accept I/O 
sounds like
a generic state, but I can't think of an equivalent in the other transports.

If this is something that is private to FC, perhaps the right way is to 
add a flag
for it that only fc sets, and when a second usage of it appears, we 
promote it
to a proper controller state. Thoughts?
