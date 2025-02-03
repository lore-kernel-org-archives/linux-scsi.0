Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15F920C465;
	Mon,  3 Feb 2025 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738604654; cv=none; b=rOAWcz9mdQtjs6VIqPW6xGBqdR79Fqx2PkHoBPe38BDX7foVdBg9hc1LSMt6OvVqZ/6c/r/CDfZ/5ztPsU+Ku2Y069yg+bwyoRSSZfGX7iQeA2Lr77+8lT9ojQLDN6jhT+etGXPcUtL2FOmSGfSL4jcgbTQ2ssLmu6YSds28l5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738604654; c=relaxed/simple;
	bh=2L6FYKexr9/6QuLW+bAyYcB6X0+g6V5gR11a0B3w9I4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=abXxgPRXjKCaOThircYqsvZKunE0TBnqKZxGQ35o4WvGwU82NC2iHorLv1qHHXxsmx9xxDLoE5YnlIwYFUlWEjndUUk+Y4w0NNCEATZLOrLcJ25d9IDrmLpsIvc6oPMbRa0IXx7b633yxXD3h/mH5w47V8Agp7oBzQEk2eFOkAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLoGACk1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLoGACk1"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2166360285dso77623005ad.1;
        Mon, 03 Feb 2025 09:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738604652; x=1739209452; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=yesSbFiyPmcTNKxdhJxue+OpZazjIHnz2CI3z1BKrtc=;
        b=dLoGACk1wdBeSSvoaOZDXX2utVEVsADlIPSsPBsUxWo9OpQ5krdhoQAu/lpKWakjom
         n3zpT3AB7E5tB78wOumjJlHGO0d4I681UYCGRACVZRwrtFulddXG6Oojl765rnzhVmUR
         7GtvvIBwCMLDvHUHmEusm+3yY0viESL1gmXVASvmmdp/c6CjLj4YYvm8LU/vrJ7dDsZK
         +nkQdjOyGpEha1ZHoBEeiUdEgAupYRJMr8C6/VvlqHk48uobkoax/IcCO11InFLiz+y8
         OmEAULynpDaj8fUYdzMPdhPjkYSXgrb34q6xwVsWpgvNwPSInoyH7cuUxD33EUWChw3R
         nHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738604652; x=1739209452;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yesSbFiyPmcTNKxdhJxue+OpZazjIHnz2CI3z1BKrtc=;
        b=Y66nwXl+NgD0LXNf6A/ytEsqjqSv5jZD4JfC7/jTefXvxSd/djI00pJM29jdms3Hsd
         SgK87odk3Lfya/kxpI20J3MEL0r6niUUQyy4p9h+8qfyilKbSQ1O3dn7ClYo5cPlqTaj
         qn8BjNPWMXwzVDKIIAX2EvS3aH7bqycPaHoSpg4UYVhmayEqWf1Mez/BJH7Z+VqRY/9o
         3B5uZMNiROMSchV9QQ6C6Z3toFWaljngCknk92gtKWV2dE8FoyS9kCowUQGpAMIwjqo8
         yzMvVYMXz+t20azRpKeYfk6ltcXUeM9X1ZnFR4yiN+HWohfffqZ7fMks/bWXPY4ucCHP
         WkzA==
X-Forwarded-Encrypted: i=1; AJvYcCW1RvhiDwu2BOzKklx5kbCjRX+X12Y42pyQ1D9KQtOynl2RENWpR2olquQUiBexItuSUAaVSwuO3LclPis=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXZ0eYEohTOKqTH36F25G1SYl39v5YxshjdkHrAw4IsBDlZ5ao
	Rybf0WK/kDLQbXQOZSP5XdREkGpX+p5Vx0NcO/CF4fg50fEak3DxPzfxSw==
X-Gm-Gg: ASbGncuQYvXko32wLGCo/wzx1/yheZCQ0MvIVX3EMpn9miE9pNSjkYa90ouryjELTKf
	Jd01mMh5fufifIJwJzi5k8IIoqErMorNdXU3fFQ4vWdtMEJUEKDrRbrUqCfgYYcFxhNnMlBr+Co
	a3m1OlZkA9E/VzA2jfbMk4HcIGpizGw7Dh57l1+DAq8ao9Pe/oTQLng0fdJbUKX/Hx3rDbz0zhf
	RCZtjk/TlU57XsiGFrBIwOjRRsZQl0hx7B+ac523A2DYwOLHPR22BhViyqM8TKovlc1eEfjbidp
	WdP1i1qwAmK6nWNwUnSNmReHYK79SDTtH6KSpnU8gqGVv2SacbES8uXj2FTRlASz
X-Google-Smtp-Source: AGHT+IGCRUZFgQJJyzOqhEUeQNsH5YT+VSexaVeuCic/SDpP/rvXN6UlrzuIFuc+kStPE6UADvI1Pw==
X-Received: by 2002:a17:902:fc4e:b0:216:6c88:efd9 with SMTP id d9443c01a7336-21dd7c6290cmr392371925ad.15.1738604651709;
        Mon, 03 Feb 2025 09:44:11 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32eb424sm78120315ad.146.2025.02.03.09.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 09:44:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <a451e938-5385-4ab0-b063-b962b10f3458@roeck-us.net>
Date: Mon, 3 Feb 2025 09:44:09 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: Add support for critical health
 notification
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Bart Van Assche <bvanassche@acm.org>
References: <20250203152735.825010-1-avri.altman@wdc.com>
 <20250203152735.825010-3-avri.altman@wdc.com>
 <d45b05fb-e98b-4df8-a33f-37ecdd23f67d@roeck-us.net>
 <BL0PR04MB6564CE4996D99B8566F27E0CFCF52@BL0PR04MB6564.namprd04.prod.outlook.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <BL0PR04MB6564CE4996D99B8566F27E0CFCF52@BL0PR04MB6564.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/25 09:25, Avri Altman wrote:
>> On 2/3/25 07:27, Avri Altman wrote:
>>> The UFS 4.1 standard, released on January 8, 2025, introduces several
>>> new features, including a new exception event: HEALTH_CRITICAL. This
>>> event notifies the host of a device's critical health condition,
>>> indicating that the device is approaching the end of its lifetime
>>> based on the number of program/erase cycles performed.
>>>
>>> We utilize the hwmon (hardware monitoring) subsystem to propagate this
>>> information via the chip alarm channel.
>>>
>>
>> That is outside the scope of the hardware monitoring subsystem, the
>> "alarms" attribute is deprecated and must not be used in new drivers, and it
>> isn't actually implemented by this code.
> OK.  Thanks for letting me know.
> Do you see any other path I can take within the hwmon,
> To let the upper stack / HAL know that the ufs device is reaching its EOL ?
> Or should I look elsewhere?
> 

Again, this is not a hardware monitoring attribute. Normally I'd assume
that information like this is reported, for example, via smartctl or
whatever similar mechanism is available for ufs devices.

Just to give an example: smartctl reports for one of the nvme drives
in my system:

SMART/Health Information (NVMe Log 0x02)
Critical Warning:                   0x00
Temperature:                        39 Celsius
Available Spare:                    100%
Available Spare Threshold:          10%
Percentage Used:                    0%
Data Units Read:                    10,835,485 [5.54 TB]
Data Units Written:                 4,931,062 [2.52 TB]
Host Read Commands:                 149,936,032
Host Write Commands:                36,799,659
Controller Busy Time:               318
Power Cycles:                       12
Power On Hours:                     326
Unsafe Shutdowns:                   4
Media and Data Integrity Errors:    0
Error Information Log Entries:      0
Warning  Comp. Temperature Time:    0
Critical Comp. Temperature Time:    0
Temperature Sensor 1:               39 Celsius
Temperature Sensor 2:               41 Celsius

Per your logic, all of that could be declared to be "hardware monitoring".
That simply doesn't make sense. All that information is reported by smartctl,
and it can and should be monitored using smartd or a similar tool. There is
no need to invent a new mechanism to do the same. If smartmontools don't
support ufs, such support should be added there, and not be pressed into
some unrelated kernel subsystem.

Thanks,
Guenter

