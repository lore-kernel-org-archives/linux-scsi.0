Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1005C2737E0
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 01:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778721993; cv=none; b=Yq9r4ABe9RNYQetQUh5gV0aByRptsL3q/igC/7NNJJlka9PJ8j+dhT+amjGLRYR5Qm8KdyQGqlfFkjsgo1yWCOJumMmgEbPROk6vW8jd62ZEgxC05WauSwz00aeczgDbm1yw0efqxdMhxB8WxoF7jJ1bFileYVtGEp0GjQR9ITk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778721993; c=relaxed/simple;
	bh=J9t7Y3dCSOWjzc2KZXw6OyJ0fX4LV/SSR6k3ZSG8cP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rNWCseTPVD+TvxIeZ43kss0axIU6t4KMvxPJIZErbmnLE3HRabFRd75EIAx/Zl1/hdTzBfdCaLwa8DzXE6WGxHeZYHfiexSQ9OjX7/8y3TZJJ2kfcIMp8pSWxrp3j8EZOESPeKH/fo+XP80Q4EqARR4cnR+ABRsFXNTdF6nhw+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bmuCmMnR; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmuCmMnR"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-13354eb66baso3996942c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 18:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778721991; x=1779326791; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Ow0R4jeXxEVO1Et6duyD4OCmVuya7nxVLjLxDugc27w=;
        b=bmuCmMnRCXsXCzTsUXubTkLmwO6IPgoPx6FKXObYiqcbmIU+alwIetyAUNv8Xyz7HL
         dLx5kgPeW24m2bsnMkdbIdxsbR88IqqWXN22MHNtGAUaRZzhxouqHjGYgLrKBmEtYGh4
         dKvThpsERR55kDN9Yg84Y1zGbEcoEAfjXe5QqWMWHsNO9lwqDMKHTUb/GSZdSskVBCgT
         bB0fgzImxmTuV3Q2qbc0Y3Ahnr1B1omfNjKEfhsEM1QNAkvRJxv1K42xAyYJi50zNk2N
         HFp5P7w03QK4aovo9zDu6zrvKRcCSPIDBCqy7cgKiReNQaceSVzqE3/SSh7+m7oYRCNP
         +/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778721991; x=1779326791;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ow0R4jeXxEVO1Et6duyD4OCmVuya7nxVLjLxDugc27w=;
        b=GPSuMUjlCf12P/khNkCQitX2UQKz3KSxk5Jnfyu6Ikkm2iXmfvVHg3f/l5DCdc/iv+
         l/cEqD6tuibbW4FUzF67IIVtkvX48rBy3eypa0vhkqK0UlV9G+3+Wgis5MYff9n7ZcL1
         rb1b07uECIFHG8XyItLeV3a/uT4G63+NdD+h79iWf+ODwsIUOauaRpuvOXi6igMz3SzO
         5OuHZFtjM4n4VuroCdyl1fjJaHxuoycklq2zkMwyBN0c6MDxT7vTjz6w/F4azBeCNugO
         zmNf5ehIDjNNqqreTiHj/8W1L/mib+QuzMAYm5CQWjpBnp1rdfotVev1oAdrWdIMfAA/
         QzfQ==
X-Forwarded-Encrypted: i=1; AFNElJ/63CBl7RNC+ZJbappktl/7xr4rC+k1C/G6EDqdiC1DMiM/hHMxxYex+/3LEVHDvO9bmFU5e0xXsuni@vger.kernel.org
X-Gm-Message-State: AOJu0YzuRenkEi79XWMsMFVCaMbY//BNJuUaMACcTt2C699W1RUppTDS
	SZVchzHAFqJaUMhcNalnvCFcg4ey9rRvuehc/BvJxdor/2lEjB8HZRwV
X-Gm-Gg: Acq92OEuJXvt/129c/6g6GLdI0pvS9/Nkh2dbTwu5IG6Ph6eNINmVQePHO22Abty89K
	iHI/maqCTpsCfJbXxIqAx9Bb/5rmHuGnEEKEMzmy9eTqE15Qc43vB2LURbwz5rHyIUmkYhI/TQJ
	UNihjGHt1bM6dLWFZTaKXCwobbiFAYBtM+rsHA015ZQ+laFvQjRvqgw8KkKDKZsy5fP/3W+TcG1
	yvxNqHxR9rSDZLW4AtiVQidJg4RTOQY+wMher8R5Nt2NbgHP/4astbrFCk9zf3OPk+gfZ2vu+Bk
	Kyy/cYIZkhq8PA2x7VkGpATRzFXoW72BkgBbawBnBOWQbqRcPiT2bkFLOPdmQ3cv42DCcQp5t4e
	UMIOw1whAXZqpeXlfGUhDC2hnuunKhkZfWwwKpr7GVGmzSxJW1l6AcPUb1D8CALNCCMYtBb/AKX
	c+u8MVe1kgt8Z3qjfH/8mGQUwn3MTqsBo8ZkY8h9K3X8CqglQz+z/doGUFm1Cn6RNBVyqe4Mali
	+yPCVse8dk=
X-Received: by 2002:a05:7300:e78d:b0:2fc:9aa8:83da with SMTP id 5a478bee46e88-3011a369aa2mr3335097eec.29.1778721991110;
        Wed, 13 May 2026 18:26:31 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302973bcd0csm1239878eec.24.2026.05.13.18.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 18:26:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ab7c7a3a-332a-4316-93de-c6e9b5ca6c62@roeck-us.net>
Date: Wed, 13 May 2026 18:26:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: mpt3sas: add hwmon support
To: Louis Sautier <sautier.louis@gmail.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260512214703.655633-1-sautier.louis@gmail.com>
 <20260512214703.655633-3-sautier.louis@gmail.com>
 <934b475d-1d77-4670-af10-4f3f2ddad61d@roeck-us.net>
 <4e757864-c062-4467-83b4-1e0d08b68b2d@gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAmgrMyQFCSbODQkACgkQyx8mb86fmYGcWRAA
 oRwrk7V8fULqnGGpBIjp7pvR187Yzx+lhMGUHuM5H56TFEqeVwCMLWB2x1YRolYbY4MEFlQg
 VUFcfeW0OknSr1s6wtrtQm0gdkolM8OcCL9ptTHOg1mmXa4YpW8QJiL0AVtbpE9BroeWGl9v
 2TGILPm9mVp+GmMQgkNeCS7Jonq5f5pDUGumAMguWzMFEg+Imt9wr2YA7aGen7KPSqJeQPpj
 onPKhu7O/KJKkuC50ylxizHzmGx+IUSmOZxN950pZUFvVZH9CwhAAl+NYUtcF5ry/uSYG2U7
 DCvpzqOryJRemKN63qt1bjF6cltsXwxjKOw6CvdjJYA3n6xCWLuJ6yk6CAy1Ukh545NhgBAs
 rGGVkl6TUBi0ixL3EF3RWLa9IMDcHN32r7OBhw6vbul8HqyTFZWY2ksTvlTl+qG3zV6AJuzT
 WdXmbcKN+TdhO5XlxVlbZoCm7ViBj1+PvIFQZCnLAhqSd/DJlhaq8fFXx1dCUPgQDcD+wo65
 qulV/NijfU8bzFfEPgYP/3LP+BSAyFs33y/mdP8kbMxSCjnLEhimQMrSSo/To1Gxp5C97fw5
 3m1CaMILGKCmfI1B8iA8zd8ib7t1Rg0qCwcAnvsM36SkrID32GfFbv873bNskJCHAISK3Xkz
 qo7IYZmjk/IJGbsiGzxUhvicwkgKE9r7a1rOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAmgrMyQFCSbODQkACgkQyx8mb86fmYHlgg/9
 H5JeDmB4jsreE9Bn621wZk7NMzxy9STxiVKSh8Mq4pb+IDu1RU2iLyetCY1TiJlcxnE362kj
 njrfAdqyPteHM+LU59NtEbGwrfcXdQoh4XdMuPA5ADetPLma3YiRa3VsVkLwpnR7ilgwQw6u
 dycEaOxQ7LUXCs0JaGVVP25Z2hMkHBwx6BlW6EZLNgzGI2rswSZ7SKcsBd1IRHVf0miwIFYy
 j/UEfAFNW+tbtKPNn3xZTLs3quQN7GdYLh+J0XxITpBZaFOpwEKV+VS36pSLnNl0T5wm0E/y
 scPJ0OVY7ly5Vm1nnoH4licaU5Y1nSkFR/j2douI5P7Cj687WuNMC6CcFd6j72kRfxklOqXw
 zvy+2NEcXyziiLXp84130yxAKXfluax9sZhhrhKT6VrD45S6N3HxJpXQ/RY/EX35neH2/F7B
 RgSloce2+zWfpELyS1qRkCUTt1tlGV2p+y2BPfXzrHn2vxvbhEn1QpQ6t+85FKN8YEhJEygJ
 F0WaMvQMNrk9UAUziVcUkLU52NS9SXqpVg8vgrO0JKx97IXFPcNh0DWsSj/0Y8HO/RDkGXYn
 FDMj7fZSPKyPQPmEHg+W/KzxSSfdgWIHF2QaQ0b2q1wOSec4Rti52ohmNSY+KNIW/zODhugJ
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <4e757864-c062-4467-83b4-1e0d08b68b2d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/13/26 18:11, Louis Sautier wrote:
> On 13/05/2026 05:57, Guenter Roeck wrote:
>>>    Documentation/hwmon/index.rst        |   1 +
>>>    Documentation/hwmon/mpt3sas.rst      |  57 ++++++++
>>
>> This is not appropriate. The description is wrong and misleading.
>> mpt3sas is _not_ a hwmon driver. It is a chip access driver which
>> happens to support hardware monitoring.
>>
>> If this is part of the mpt3sas code and not a separate driver,
>> please keep it there.
>>
>> Thanks,
>> Guenter
> 
> Hi,
> 
> Sorry about that, I had assumed this directory was also meant to contain
> documentation for chip drivers that support hardware monitoring.
> 

My recommendation is to implement drivers such as this one as auxiliary drivers.
Most people don't want to do that. I accept that, but then I don't want to carry
the documentation either.

Thanks,
Guenter

