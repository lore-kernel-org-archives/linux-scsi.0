Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F1413B284
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 06:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759817916; cv=none; b=gGqbaj0ieyMnaZ1LIMBc282VwsBQWOhLeo1oVcYa9Mv9wHhVhZF6hjzZy/ba2PDPASzZK6+Pr5vZnmPf97PEiUYqNmJedNJkZiTou2Mz4TNdhYrtU++QahEEsdt5sNJkRePBd6jEl3V/foCapq1bKTUNWc2ejDVMuBywUBKG3vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759817916; c=relaxed/simple;
	bh=WSad1HugXe52q/g05va5eYGyhewLw2wPoyXwmeqSge4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sle+6+kHyHrncIHLZP5urFOW+VYjuE1syTDPbzFX3nSoUXAVOdXjJz7v/VI/0UqARVB0LGfdcPRXiNgrQxKQ6wYul8+y30EP5ocTqoXmpan3fv8adPhpeIuq1kdeeDPXDor75bYiXg+f2SsoBtfjW1iCElFBa/SRe47N2/oGh3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yu2bINoj; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yu2bINoj"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-26983b5411aso38483185ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 23:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759817914; x=1760422714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CDwAkbaDlWUjevGfq4nyNlKuzcgWszmvXZ9ur/30uOQ=;
        b=Yu2bINojm2JN+k2n+PPRbpV4xPVuQRuH2HYMRduhiMIsv+wRwppZCERPDTS9+TasIl
         9G00DVWGCUBM6S+qtQ5z1oC9GkJo23hri2/8qLwMHmC8ze5tXdt0+CvoXnWYjYKPLtdU
         0P+uWTPm+mz0JDh/zlUdrEQ2HCEj63YJWT0ca0AT2tDCJLHhMOGR7JRf9NH5kzbeV9qV
         m+uV/amDaLKhV9E1/nibRnNdE6nnQhQqEaHp2N/DkVfhDi9i5PXztzbJcThZQxJXZGrk
         2W0y/Rf9OczQmHwVLAyK73LCz3fnG2qnC5fkiilHfUH19IPQhj6ssO2o4fYpxHX+7HED
         uEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759817914; x=1760422714;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CDwAkbaDlWUjevGfq4nyNlKuzcgWszmvXZ9ur/30uOQ=;
        b=h6Bmt7/VgRTmszSNyLQp6MRiks+Jm+xOouMTexFI6rxl4mQnGtMvKkwx0R/N4mUaVt
         plI1iUHTAyQe82OgTRBgHiti7YY542VPqSYvAiogyrRqaBthRytrgb4YMeLeUwn38dYt
         OmN6lC5TZO9UsJmTig4n29DTionly4wqv2CwOhRPHT9fdLy50LeIGqWVJwTC7Gx2DaRb
         lM2NuR+UNELz6HAraUetsfqOoKvlDO4uHQS3zoHSVAlbMZNrBQPvdrlhlKx5h+tAevDV
         ihIiOBYgszcAOmgF0jYqW/uhLmd97SSCTP1QfITjcXO2w17mY31QpGPk7YJTO+2oUfOT
         PZDw==
X-Forwarded-Encrypted: i=1; AJvYcCUhDk3ltlzwIwrFjq7gOdjCeINo+wT6JP+1zbmaZExXmK3uRnj5iAmlTSmqHAWkifXyvupQ/aafMkrm@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx4+tnBoWfFd7/M43f3th6UEEwwCZvrMnyA6xzGPACYKl6/Mp1
	1x2y4ADpHxjhENuOpXHcgcqiB4V0NWMZNvhsApBdPXYYKtsGM7dbxEX1
X-Gm-Gg: ASbGnct8sqppFH/1MK5VKkWk4RumJuKzYJMNHm98ga8uDU+AQFPeOaTSsTNDYkSyDN1
	WtBlpnnY5+4qKdJVpKEDwyxgHys/eVzdcTs60TEF+vj3/ieq37zZ4+a15zvp35mGQ4jxdCGvWPJ
	r7yeaNnXx5G8LjESqQUZqqyF+nu1eXUf1AfDnknsYnGDoIawNwmDBk7DaOfN+sJ85XIuo1kIJkM
	VFbpQJXrXDGDTyzYtuMCjtsbxcrAmdKqCV/GwM99nENUT9TXjMqkJkIqIhX3cXBypt5UrAOIaCK
	pvF1hOZ4jz0vff9HGX1YeKPqe0oebp0vYq0yZ/HD3jtRcbXs5fS0YLWFay73ziVeudFKjDtjtAe
	qFvtsY2dcbypFeP30QuRVfWDVME8zGx4F0gUuUdBk/wzfB0niQX3qboBs7LKR3hAjVMk=
X-Google-Smtp-Source: AGHT+IFEB4BT03PGibT8CSd70pTCt7zClhc5w3shhrha8qeF8hont0hAokJ8+q/qQmhqQ/KGp8jHnw==
X-Received: by 2002:a17:903:1aa7:b0:27e:ec72:f67 with SMTP id d9443c01a7336-28e9a54ee5dmr208134585ad.6.1759817913969;
        Mon, 06 Oct 2025 23:18:33 -0700 (PDT)
Received: from [10.0.2.15] ([14.98.178.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d11191bsm152771835ad.11.2025.10.06.23.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 23:18:33 -0700 (PDT)
Message-ID: <3ab53f69-4e1f-4f76-8605-e95d7516a97d@gmail.com>
Date: Tue, 7 Oct 2025 11:48:29 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Use kmalloc_array to prevent overflow of dynamic
 size calculation
To: Niklas Cassel <cassel@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
 Don Brace <don.brace@microchip.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 storagedev@microchip.com, linux-scsi@vger.kernel.org,
 linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com, bhanuseshukumar@gmail.com
References: <20251001113935.52596-1-bhanuseshukumar@gmail.com>
 <7761904f64c554821e71e30b205e092fc2f8478e.camel@HansenPartnership.com>
 <1c6cceec-da16-4867-88e0-c629accbb35c@gmail.com> <aOOn8TFTseukaZlS@ryzen>
Content-Language: en-US
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
In-Reply-To: <aOOn8TFTseukaZlS@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06/10/25 16:58, Niklas Cassel wrote:
> On Sat, Oct 04, 2025 at 09:55:22AM +0530, Bhanu Seshu Kumar Valluri wrote:
>> On 03/10/25 20:23, James Bottomley wrote:
>>> On Wed, 2025-10-01 at 17:09 +0530, Bhanu Seshu Kumar Valluri wrote:
>>>> Use kmalloc_array to avoid potential overflow during dynamic size
>>>> calculation inside kmalloc.
>>>
>>> This description isn't correct.
>>>
>>> Given this check
>>>
>>>>  
>>>> -	host_memory_descriptor->host_chunk_virt_address =
>>>> kmalloc(sg_count * sizeof(void *), GFP_KERNEL);
>>>
>>> How is it possible that this allocation could ever overflow?
>>>
>>> If you want to change the description to say using kmalloc_array is
>>> better practice or something (and the maintainer concurs) that's fine,
>>> but we can't have a false justification in the kernel git log.
>>>
>>> Regards,
>>>
>>> James
>>>
>> Hi,
>>
>> Thank you for your helpful comment. 
>> I will await till maintainer confirms if it is ok to push this change as v2 with
>> subject line similar what you have suggested.
> 
> You misinterpreted James' reply ("and the maintainer concurs").
> 
> James is one of the two SCSI maintainers, so there is no need to
> delay sending a V2.

Hi Niklas,

Thanks for clarifying  that. I will send v2 patch.

Regards,
Bhanu Seshu Kumar Valluri

