Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459555D737
	for <linux-scsi@vger.kernel.org>; Sat,  3 Feb 2024 12:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706962313; cv=none; b=MVYLwHT2pYMJlOpjFI0C+g8nc9eLvYX9osXnWolEhPYkZ4GZtwNTgTS4sp8X4PTpan+RruNCByr1h5KBZHF18zzpQgxa8cZcegr3wC5rN9594mEw4+Rz21OGk2iYFHYZ08OZyE56FyUhfAIf60n4D4A9WH0lNSXSDaTbHaM1cn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706962313; c=relaxed/simple;
	bh=NKqKivxBa1UrOQdEFxuztVX+NR+bchaWhMeL9Kg6RHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmZexVshHHh41Yvz8BoX4dt68OG9Eiu4hQ8B0Aou8rT8x5lzzhCCLPcYHbVlXkcAs8ofynsc6tvKWOJWRwGUtbmxrROI8xfvAVLhaYv9s1Xlj/P7PKR4v9yhzILbRAeemhBgATD+Cquxs8jeJ8Cq15dnA2dSJK3rdd/MeqM+HBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=06yBGLqe; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="06yBGLqe"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3bc21303a35so912746b6e.0
        for <linux-scsi@vger.kernel.org>; Sat, 03 Feb 2024 04:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706962310; x=1707567110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W6At8w3BY+bHriEibzEnUgO2+DI0oRR4cvw0MljHLkA=;
        b=06yBGLqeHFw4mSGiacaeJNTR2oRDBrJ4z/lfOSjnU8WD3Gxu4j3TKz5pJ34XjRxB0E
         uPbyJ7LpxLyYtdVyXT5b5J2/BQXn/Ds6g0EWVkpOu0g/V3Hl1D5JHViMG9RDs1eVNn2T
         K+UZInWXohWBA30YZGuPnz4fTjXjsfeGNivmUUs2eh5SqBglIRlPBahE/qoXG7EVwWER
         DKF7q44T+Zk1B3j5UHsCGhGwFgAM6r2245Zo/sojBP4UU277oNuKXFehXCdG5sKZOvWB
         2Oask9QIYvaT6XUF4U/elkqaOGiULRrqEXUKczUXesl69LXjuNgNnBPZ2FXgg5ugET+o
         L5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706962310; x=1707567110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6At8w3BY+bHriEibzEnUgO2+DI0oRR4cvw0MljHLkA=;
        b=e1ZhXdYvHl7M3ETsu+RPnFw3zse7jCN0YljcdC8cpM6awNlmWDQttaEMuS1pwuY5fM
         FtmwZ95+Tl3KKcTuPPLTyiTkrhxixJ2f3liCG//WorSoJkXv2P+XtFfeiJG924nCce9W
         dj7m42ioe7WeB0ZNvvB68U8ujs5MNkMYmqq+BVxJq3+Fd2+htLjXSYrGZm6wVpCF6ubc
         6B+8ucKAFysoceFf1NXkW63Eile3S/hSgYGPOALFaEh/1TdwMxnw3CigQ88QUU0ObhOg
         c/8D0Qpt4GADkhfkV/IsXyYWibNUm5LK5Bxeue2jtHf8Z+i6PkvE0NA7VriCaD+/fVEO
         /6dA==
X-Forwarded-Encrypted: i=0; AJvYcCX9n/rbtW2TcJzqgd31ELNw64WUx0wh43OCiFGCnQHAp9Q+Qn4eA3VCLl/usMo488HzPkcf+TNBdg2deh/1Hl9EhwE0xZNjVZpBAA==
X-Gm-Message-State: AOJu0Yw6m6WTKAgwsddL56fnwGdiIRKesKbUMpZaDFcCUmJk34IAKNCj
	HsdY/Mc/l7ljylV75HmqdEOi2uLgnwlsK+jiu8snn9EK6zVyJegBurgWihSj5zg=
X-Google-Smtp-Source: AGHT+IHqU4+fGOqr+6hwk36/z50UDpr7B1lwfquHREOClNc/Ohn+gEBSJJY/qwk/nminNs/414tyZA==
X-Received: by 2002:a4a:a787:0:b0:59c:7c63:928f with SMTP id l7-20020a4aa787000000b0059c7c63928fmr8736332oom.0.1706962310299;
        Sat, 03 Feb 2024 04:11:50 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWw+Y7AW9dyMB0A0M0XJRjY7ktYhP9Rs6oOd4pjM3Nn23QgvIv2kdSR8OtCYTZbFONZNotZbS/djXmBPiB5wK8MshAwqwVzOHXqYP3QikyM9c5lEiOO9fkF9xPMfdQ8gKSpyPao5UBzBEKLARyyNp9OGzklmYmjlsJC5duJwSmlDhvH7tEAGdm52Cs1CVEXwgwEL8GgSSx7foRnA0CQU/6FpNZedtv8nWbAM/0cIzgWin8=
Received: from ?IPV6:2600:380:9b5a:c5dd:b564:550c:8958:e9dc? ([2600:380:9b5a:c5dd:b564:550c:8958:e9dc])
        by smtp.gmail.com with ESMTPSA id y6-20020a4ab406000000b0059a9652eee4sm814630oon.25.2024.02.03.04.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 04:11:49 -0800 (PST)
Message-ID: <a387f08c-05c1-4c47-8ba1-27493b7853ef@kernel.dk>
Date: Sat, 3 Feb 2024 05:11:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <147de7c4-7050-4b1d-a48c-c0316a81baee@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <147de7c4-7050-4b1d-a48c-c0316a81baee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/24 12:37 AM, Damien Le Moal wrote:
> On 2/2/24 16:30, Damien Le Moal wrote:
>> The patch series introduces zone write plugging (ZWP) as the new
>> mechanism to control the ordering of writes to zoned block devices.
>> ZWP replaces zone write locking (ZWL) which is implemented only by
>> mq-deadline today. ZWP also allows emulating zone append operations
>> using regular writes for zoned devices that do not natively support this
>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>> driver and device mapper zone append emulation to use ZWP emulation.
>>
>> Unlike ZWL which operates on requests, ZWP operates on BIOs. A zone
>> write plug is simply a BIO list that is atomically manipulated using a
>> spinlock and a kblockd submission work. A write BIO to a zone is
>> "plugged" to delay its execution if a write BIO for the same zone was
>> already issued, that is, if a write request for the same zone is being
>> executed. The next plugged BIO is unplugged and issued once the write
>> request completes.
>>
>> This mechanism allows to:
>>  - Untangle zone write ordering from the block IO schedulers. This
>>    allows removing the restriction on using only mq-deadline for zoned
>>    block devices. Any block IO scheduler, including "none" can be used.
>>  - Zone write plugging operates on BIOs instead of requests. Plugged
>>    BIOs waiting for execution thus do not hold scheduling tags and thus
>>    do not prevent other BIOs from being submitted to the device (reads
>>    or writes to other zones). Depending on the workload, this can
>>    significantly improve the device use and the performance.
>>  - Both blk-mq (request) based zoned devices and BIO-based devices (e.g.
>>    device mapper) can use ZWP. It is mandatory for the
>>    former but optional for the latter: BIO-based driver can use zone
>>    write plugging to implement write ordering guarantees, or the drivers
>>    can implement their own if needed.
>>  - The code is less invasive in the block layer and in device drivers.
>>    ZWP implementation is mostly limited to blk-zoned.c, with some small
>>    changes in blk-mq.c, blk-merge.c and bio.c.
>>
>> Performance evaluation results are shown below.
>>
>> The series is organized as follows:
> 
> I forgot to mention that the patches are against Jens block/for-next
> branch with the addition of Christoph's "clean up blk_mq_submit_bio"
> patches [1] and my patch "null_blk: Always split BIOs to respect queue
> limits" [2].

I figured that was the case, I'll get both of these properly setup in a
for-6.9/block branch, just wanted -rc3 to get cut first. JFYI that they
are coming tomorrow.

-- 
Jens Axboe

