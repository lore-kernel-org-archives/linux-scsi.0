Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ACA2BE62D
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 11:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753358092; cv=none; b=sWsZXiDAnqHvoROUqxLSW8vW1mzvEv8QR4m7ZnMF/SnLifpa4auXLEwpHxAbz7N8zgEgpXtHhEICstQHlpigiPxIj5ATUqeZWP5EZYtABLP9ttnfjueVN5hlhRbijiGZJLRukEZ/Q8hF1PoTIFbkJQqOUl3zpIYbUvw8RpqT2bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753358092; c=relaxed/simple;
	bh=uBAETq3ZJFHM+cady4LCKCozZZLmtjkngw6fkneCqLI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=H9Q8jSc3+srO6Z+c48knpxdioHP6j/p9gO0nH7+PeLxlIb5BHVy1kEnagTRCv8+/l8+rEaRiAAH6IxmQWTYAjYJhx8+6Uq9UAxUtgRROjkTuM6RwetxfvZG4AkS+KUF4U76D+0MRurEYuqCK9NFd7N3DT4YHG2e2Wc3rpWUJ/Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S0rg0Gn9; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S0rg0Gn9"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a57c8e247cso808516f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 04:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753358089; x=1753962889; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=up8iyGGWArwKLq6YJECftqTB1hFXDbYaDoTw/k4feT4=;
        b=S0rg0Gn9szwtuPXuCtrTbqAlFf0e+LO/P6IskBNFPDcP4BPO04myW4mFy9KLYWjE4I
         ZmXGIURgZvFEJAJ6KByDIlPMVO9QE9VMCq5VgKuuxmZj6F4K5r7UznIqEZvXEeUTG4l1
         4CVVftbnmj8cYloiG+D56XkhK6OctBXMZLy0QPv99b3bxYQ3YvfqtT/w6wEMrefsHndx
         JxBhJSmfhpS3yug3FOuw3ul+JImFNuMf5XBNIP5xgJxT4UKrqN7jRWRat5dfI9YNdMOz
         b4SpL697AwtJzKFTRtg/t85Qg5cg1ZtrARbr5Rc+KM+qI0UOFZ1Yjc4iLLN+tkzV7Pzf
         T2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753358089; x=1753962889;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=up8iyGGWArwKLq6YJECftqTB1hFXDbYaDoTw/k4feT4=;
        b=HHc/NbwSgshyxC/KgTbkaH413awHfzlGySEc5YhKjBPSeY2t5K0/3k7GZZ383jy13V
         1roGCVayzWPc5efKoURzIAnD7mn7iba3zICMyGHrIi6QCr8O1cqVN/Uli7m28myXonJA
         MDUlVnWeb1YsEbdXRlBzYe3thr9sXPXqqYXDB7drvAP1Y+HExqrrUxsWVKpCmzVIcty1
         ay4qPhyuOGwgxm/bw+kkJZJSnnfDgeX6dd+kfQMD1K+DjFuzkaNZtXz0jd0Xwnqv9PqJ
         G/rycg9B50iH3bMGPNJkEKWJIw17hFvTYCOi3BngTKKz7oMzShIAtwgrD0pmnO7Hb0bI
         KLOA==
X-Forwarded-Encrypted: i=1; AJvYcCXdIZbazNMxC9I1RB+54u9z/62hv27jNMHdkYWUidh/+/9/BCBYBAGRqxX77Y+OvoZs8nZrYtxjb3NV@vger.kernel.org
X-Gm-Message-State: AOJu0YyZZ1qh4g+UYEXJNhh6WoEhLr4+Cm85eLARSJpbMR7AXLS3p5N1
	fh6v/nKKAo7JGEffve+dfk0anMoQ6dmfFxOn2UvLK18u+XZzRNKpf33Rm2DBq9dINI4=
X-Gm-Gg: ASbGnctH597wcFSKMsvybeGlRyWRPvCT+RUrgVILGqsksA14221Mwq3EzCDXQpPmZqT
	UkEfdP93yf9HfJBIlMcGYKsi8ITdv1IVBZoD+YDIGKIFaAmivkLfx1U9wlZ7uLYVY928D+jJ/Ml
	g6g6mq3ZUxIeIKwIbgj0H7cUzB4jzWiVNPlo/oiYj31MzgeJ4VtTakKkB4pCL1aKhmcFQ7vVaKi
	/j/FskqijBN19oSc8tt8wWODixJXMF+o08PykH/Ev4a9gLXyMa9slVvdvQHehRYNER0jJPbEyw1
	exiKP6SZsLK+GDH6NtYapAPCOx/U8cR5qj1S/CYUbUzKDTtSTaO505A/j39HW7v3Ig7rYi2tPdA
	PbnPKrZKx9d6m2MbfloEl6XLuSCmd37dCMHB4XOCd6gY/jbjLMlxYhhxZgQcZLYxV+a5uQ3U2Nu
	wjInmpvzCGGw==
X-Google-Smtp-Source: AGHT+IGkvmVoNuPoxFqTHfr4B3gyBNvW57QEhDXs+PJErWDJ57DPnQPQLKebMOInDjfI8Vd0mUaJNQ==
X-Received: by 2002:a05:6000:188b:b0:3a5:8934:4940 with SMTP id ffacd0b85a97d-3b768f2d2e0mr5421338f8f.50.1753358088704;
        Thu, 24 Jul 2025 04:54:48 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:cad:2140:e2d3:d328:dc00:f187? ([2a01:e0a:cad:2140:e2d3:d328:dc00:f187])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm18395585e9.28.2025.07.24.04.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 04:54:48 -0700 (PDT)
Message-ID: <53bfd619-4066-4dcb-b3f0-d04177e05355@linaro.org>
Date: Thu, 24 Jul 2025 13:54:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH] scsi: ufs: core: move some irq handling back to hardirq
 (with time limit)
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
 Tudor Ambarus <tudor.ambarus@linaro.org>,
 Will McVicker <willmcvicker@google.com>,
 Manivannan Sadhasivam <mani@kernel.org>, kernel-team@android.com,
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250724-ufshcd-hardirq-v1-1-6398a52f8f02@linaro.org>
 <f2b85e49152b80a63b20aa5ad67dfbee1190e356.camel@linaro.org>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro
In-Reply-To: <f2b85e49152b80a63b20aa5ad67dfbee1190e356.camel@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24/07/2025 13:44, André Draszik wrote:
> On Thu, 2025-07-24 at 10:54 +0100, André Draszik wrote:
>> fio results on Pixel 6:
>>    read / 1 job     original    after    this commit
>>      min IOPS        4,653.60   2,704.40    3,902.80
>>      max IOPS        6,151.80   4,847.60    6,103.40
>>      avg IOPS        5,488.82   4,226.61    5,314.89
>>      cpu % usr           1.85       1.72        1.97
>>      cpu % sys          32.46      28.88       33.29
>>      bw MB/s            21.46      16.50       20.76
>>
>>    read / 8 jobs    original    after    this commit
>>      min IOPS       18,207.80  11,323.00   17,911.80
>>      max IOPS       25,535.80  14,477.40   24,373.60
>>      avg IOPS       22,529.93  13,325.59   21,868.85
>>      cpu % usr           1.70       1.41        1.67
>>      cpu % sys          27.89      21.85       27.23
>>      bw MB/s            88.10      52.10       84.48
>>
>>    write / 1 job    original    after    this commit
>>      min IOPS        6,524.20   3,136.00    5,988.40
>>      max IOPS        7,303.60   5,144.40    7,232.40
>>      avg IOPS        7,169.80   4,608.29    7,014.66
>>      cpu % usr           2.29       2.34        2.23
>>      cpu % sys          41.91      39.34       42.48
>>      bw MB/s            28.02      18.00       27.42
>>
>>    write / 8 jobs   original    after    this commit
>>      min IOPS       12,685.40  13,783.00   12,622.40
>>      max IOPS       30,814.20  22,122.00   29,636.00
>>      avg IOPS       21,539.04  18,552.63   21,134.65
>>      cpu % usr           2.08       1.61        2.07
>>      cpu % sys          30.86      23.88       30.64
>>      bw MB/s            84.18      72.54       82.62
> 
> Given the severe performance drop introduced by the culprit
> commit, it might make sense to instead just revert it for
> 6.16 now, while this patch here can mature and be properly
> reviewed. At least then 6.16 will not have any performance
> regression of such a scale.

The original change was designed to stop the interrupt handler
to starve the system and create display artifact and cause
timeouts on system controller submission. While imperfect,
it would require some fine tuning for smaller controllers
like on the Pixel 6 that when less queues.

Neil

> 
> Cheers,
> Andre'

