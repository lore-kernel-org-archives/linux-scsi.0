Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F311A706A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 20:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737144753; cv=none; b=pyjss5kV4TsxI8YpiRRCQl12dWkv9IF2kurBvPWAkYJH3PfJgEnk5qTm9WTdKY1+ajuJisKhLVA96wBstjL4TKRjlea99hrCtNJ+jda6B4stImKSnb2Kmz6Yb33FN4P8F27crbIqS7MSubBTP9OwmvIUNKiHgJX+6MSQ66uTd1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737144753; c=relaxed/simple;
	bh=PeeGUPJl2smRX6KHteAej2YYpAbICq/sJBn/TI61EJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQvRixfUX5qp9kGwqvE3x6KQpVlUwUDH282y5jqNxFvyea4/gSKYIRAdy2t/S4sY/lzo6iPP0Xi7ZXb931kuO+kmiPvg03vypzlZv9LFb9/3IzumyUp9ppW9Duda2B+6jM1ptpEycoPwcZPRnxJnpBxCjeU2Yvb/LA0jlMIkQO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FLjWr3Uw; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FLjWr3Uw"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so90992039f.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 12:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737144750; x=1737749550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMbCrPJzL8yTFIs1neOfn76l0nRWVY5b3AebkpdHLgM=;
        b=FLjWr3UwOtkhiWuA2pNj14uVGnGHBTRh4+cBx77NzOVeInM5qc2GUhf3q8O5Rvhjyt
         ZmOtYsi6P8jRGtO8WJ7W/kAOYK8OINX5c94bmaJiVa+ooUb3sm+HM4OnDcMCyu9Z49dj
         /TMpqhW51b+kCknwVZq3ecn1P7uuEcCbv4hAogT1f1vDQVbPH48LfbQCm5fVCu5LpolI
         rLCroJDfR85mvEys4CWosmXn6HkqchCIl86V4Z13lVi+JFZfGrrrQ++TmOZEz3EKrWcc
         gCQmKJDIeEnwkFfU2e6VOCfD/hNReCL7M2ufpx2I/FkvVmfUBzfTcSxuWIt29ZG4hp8z
         3quQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737144750; x=1737749550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zMbCrPJzL8yTFIs1neOfn76l0nRWVY5b3AebkpdHLgM=;
        b=IAEY+zpYufVdCjrsHJ7FS9i3IvRNZLKELAeyIRVp1B+XQt2XJruxdn4VbfKs8d+VFR
         0HoFMcW+yw+6hzj0M8uKKN6BPlbehxOavDmBWO+3w4kcXryAVdDHIESLWUFqx06h0Ygf
         kA/hhdU+z/I9TQIfrl2wTQWB+BReVR4SUoa8gfo0QF9Nh70QtOKUu50WTiTTXt9I7ODA
         /Zzaaw+cPnFh5woTHi/Aty65H5LYmYWmwSRp5P3aw8fHCHmRJ0GKX6rn5EnxMa5WDQDd
         5BkBvzD4aWQBxtY8YoV6I6RUTrC44b6Bh4sUVh8BwKIuJv4c7ClUNYdQIIdKfzASXdAf
         wZ3A==
X-Forwarded-Encrypted: i=1; AJvYcCXHgdF3QgD9iZVS7ErF/GfZ+dHTndr3iLj4pSdhId174F270zWNSLQ25ZjHrx3X/T7d8fUeWNt3iqk1@vger.kernel.org
X-Gm-Message-State: AOJu0YwVm9i5z34J8j0HsbXVn9jD0Y5SzdoGWbjvCfrUa88Hw98B4uZy
	1WJ/W6TMznIhZbAlDJW890d5DggMpttO28r92HybP+G282SheLgKL0WV7Nbxmbc=
X-Gm-Gg: ASbGnctOKlqATT4RysIweFKJheCXDhrbBmn4ckukZ+G6kBgVlg89Ni6gbaxmc7Kkx79
	bsphOE19z1oHkNPiUD1UFsUjHajTi8K1JLhqrx7rXjypV0gN5PwuC37CT4AE4kTW5OvHe6P9yuE
	P5MCYqVf/BTnVV5pPtMADBtBtnNh6AI+VhAwSgNj2ldqIx8tQi48mYtd6cydsS0Ehnq3vT4AKTx
	3fVbBOROjqUlD0C/VgrgDXtg8GMv6PwjxQe3q30HX2CswNwR7PTSw==
X-Google-Smtp-Source: AGHT+IH0zo8wsg4X+Ob1gtuGKlznRlHPjHWRlLXjUWO5neR5ZhhSCiPRfv9A+0zKwVoXupgXoXN8hw==
X-Received: by 2002:a05:6602:6402:b0:841:a678:de3f with SMTP id ca18e2360f4ac-851b602f359mr303626939f.0.1737144750350;
        Fri, 17 Jan 2025 12:12:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea754964basm810406173.59.2025.01.17.12.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:12:29 -0800 (PST)
Message-ID: <fe80050f-a887-452b-b8f1-86f2ea816228@kernel.dk>
Date: Fri, 17 Jan 2025 13:12:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 0/8] device mapper atomic write support
To: Mike Snitzer <snitzer@kernel.org>, John Garry <john.g.garry@oracle.com>,
 mpatocka@redhat.com
Cc: agk@redhat.com, hch@lst.de, song@kernel.org, yukuai3@huawei.com,
 kbusch@kernel.org, sagi@grimberg.me, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org
References: <20250116170301.474130-1-john.g.garry@oracle.com>
 <Z4q45sjEih8vIC-V@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z4q45sjEih8vIC-V@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/25 1:09 PM, Mike Snitzer wrote:
> On Thu, Jan 16, 2025 at 05:02:53PM +0000, John Garry wrote:
>> This series introduces initial device mapper atomic write support.
>>
>> Since we already support stacking atomic writes limits, it's quite
>> straightforward to support.
>>
>> Personalities dm-linear, dm-stripe, and dm-raid1 are supported here, and
>> more personalities could be supported in future.
>>
>> This is still an RFC as I would like to test further.
>>
>> Based on 3d9a9e9a77c5 (block/for-6.14/block) block: limit disk max
>> sectors to (LLONG_MAX >> 9)
>>
>> Changes to v1:
>> - Generic block layer atomic writes enable flag and dm-table rework
>> - Add dm-stripe and dm-raid1 support
>> - Add bio_trim() patch
> 
> This all looks good.
> 
> Mikulas, we need Jens to pick up patches 1 and 2.  I wouldn't be
> opposed to him taking the entire set but I did notice the DM core
> (ioctl) version and the 3 DM targets that have had atomic support
> added need their version numbers bumped.  Given that, likely best for
> you (Mikulas) to pick up patches 3-8 after rebasing on Jens' latest
> for-6.14/block branch (once Jens picks up patches 1 and 2).
> 
> Jens, you cool with picking up patches 1+2 for 6.14?  Or too late and
> we circle back to this for 6.15?

I can do 1+2 for 6.14, they are pretty trivial.

-- 
Jens Axboe
