Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E612D520
	for <linux-scsi@vger.kernel.org>; Sat,  5 Oct 2024 01:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728092472; cv=none; b=P05dfh56QUYOdz3C32txM5//HFDriKGvQECWKXE6hghdfADPz45MdAjB0YXMkRvQi6Umh5db0rtD2F1yVypCzYhQa3tozNVpTUi2Xqb6NWvTfpysbJAYnAmS02k6vQaISfBM9Lxvh0e/Ub4VSFAwZOWb5n+uktETheaHe2mRezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728092472; c=relaxed/simple;
	bh=RoscfG4izei2jeMKMWExFvYBHrkJAjn0P0P4nvoPNus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JjtR8gbNnpnImRyndnKPPTWHKyi4OTofYJxiCPw0lRribgMC6APTEGfxBVO4llC01IqM3ULwrwveQ6AX7ldgZZx46RI9jcsqg5ttmIgQyNx+TBTU6TL43ZOrQZ5HMSWlwzoUh5mD0xRvzW0Gh0a3MElusXmM7sI2DrHGB9fUxDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GSqmSQw/; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GSqmSQw/"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20bb610be6aso30271825ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Oct 2024 18:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728092469; x=1728697269; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IUj5Q8Oaq99Jq3sBB6jeIQ4hAZm7itRv4sV13fDobkk=;
        b=GSqmSQw/uw2yQQK5wbsacuftoIs5s/dXa6DjG7Nw4a2xnA6P9HR2E7eFLziklJ63Lg
         nf0MHoZGMOLx1JACukv6SjC9PaoooyJRCjfxjajNEk4abZDINB4qxY5LpXVAdJYAAQe5
         VkFvybDd1wLMtPA05uQ4D1XlHz0mbKw9SB4THJ8MqX/5hr3yL+XXJh/BC7IAL2/QZmIt
         RBFO6oBl+LhlvkmdJ4ISX6c8YaEACOZ/W8xLMojCkWUE0zYj070Axy9C8dnzTD4oD3mq
         JI3RW2WJdUq4WqXWQVHYEKTKoLtZ1rACSuxdsGe/4Snwc+Mc+NrjyvirpcX+48FyOMm2
         GR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728092469; x=1728697269;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUj5Q8Oaq99Jq3sBB6jeIQ4hAZm7itRv4sV13fDobkk=;
        b=p//Ts9KcFJv24PLLH2zyLiEyTckVGVmSFYIodEQHj9frxQkynYncW0VmDZ+DxP1m6A
         sFYzTs1LJZ4rIFOgIoQyNqD2pl8IaNx5G55ktWFmcKGqQ4X9BHVB8+Dq8BVE8CuJUhh3
         QNeLSBgibm40O9qq4C73tFDqRv1qEVoAMM9RUP6J+pwPz0pH3MynCb98qeKANLZbr2Pc
         bMX4U59HzeKleR+x36pGJ9GQHmCjeDQlvWVoGqVrWwZYIr/jRjUG6xWM7wKlLNWH1hOj
         H5KBrdL6GUUPyquwivHWeDqVoQIW6V+QRjBUZzebUj3UCMVN/koxkv8CxlBYNHu7EZNh
         +rZw==
X-Forwarded-Encrypted: i=1; AJvYcCVTmNPKWFK0MuRa0QyqFXs25e2K+Wh3xDXjPNSymsx3sFjH7lxbYYTWy8bAqwJW3qcO33AsPiCKp1uh@vger.kernel.org
X-Gm-Message-State: AOJu0YwnTgcJNMMYZWI8FFNH+5twlIUEG/jSbI7cbu64nYGyCx4RxAvm
	RPYw19gEHLvC4ZF7y/uWxIWotCi2HwB4+UUGXyLuW9vA33LAulH3wF50h5h7b8s=
X-Google-Smtp-Source: AGHT+IHvZWO7L9pO25Kvnfy0cJ2v4rBQB23dVFBbTWYiGKsJlCF/PSI0q+ybt7P6TqG0rO3g149Q5Q==
X-Received: by 2002:a17:902:fc84:b0:20b:a6f5:2768 with SMTP id d9443c01a7336-20bfde650dfmr59873175ad.10.1728092469699;
        Fri, 04 Oct 2024 18:41:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138cff51sm4634235ad.87.2024.10.04.18.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 18:41:08 -0700 (PDT)
Message-ID: <c5c3c7d7-2db9-44fe-a316-b0b5bab30f1e@kernel.dk>
Date: Fri, 4 Oct 2024 19:41:07 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: blktests failures with v6.12-rc1 kernel
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Bart Van Assche <bvanassche@acm.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <xpe6bea7rakpyoyfvspvin2dsozjmjtjktpph7rep3h25tv7fb@ooz4cu5z6bq6>
 <e6e6f77b-f5c6-4b1e-8ab2-b492755857f0@acm.org>
 <dvpmtffxeydtpid3gigfmmc2jtp2dws6tx4bc27hqo4dp2adhv@x4oqoa2qzl2l>
 <5cff6598-21f3-4e85-9a06-f3a28380585b@linux.dev>
 <9fe72efb-46b8-4a72-b29c-c60a8c64f88c@acm.org>
 <b60fa0ab-591b-41e8-9fca-399b6a25b6d9@linux.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b60fa0ab-591b-41e8-9fca-399b6a25b6d9@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/4/24 7:26 PM, Zhu Yanjun wrote:
> 
> ? 2024/10/5 0:31, Bart Van Assche ??:
>> On 10/4/24 5:40 AM, Zhu Yanjun wrote:
>>> So I add a jiffies (u64) value into the name.
>>
>> I don't think that embedding the value of the jiffies counter in the kmem cache names is sufficient to make cache names unique. That sounds like a fragile approach to me.
> 
> Sorry. I can not get you. Why jiffies counter is not sufficient to
> make cache names unique? And why is it a fragile approach?

1 jiffy is an eternity, what happens if someone calls
kmem_cache_create() twice in that window?

> I read your latest commit. In your commit, the ida is used to make
> cache names unique. It is a good approach if it can fix this problem.

That seems over-engineered. Seems to me that either these things should
share a slab cache (why do they need one each, if they are the same
sized object?!). And if they really do need one, surely something ala:

static atomic_long_t slab_index;

sprintf(slab_name, "foo-%ld", atomic_inc_return(&slab_index));

would be all you need.

-- 
Jens Axboe
