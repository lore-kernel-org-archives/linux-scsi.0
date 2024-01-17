Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18824B28
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 20:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705522839; cv=none; b=Ar7Ge/D4g5ArvjD89PObw8Tb5qfirqz9rUwl1LAfv4bV7Wgk+9YshP3+6De35cDxMKtFSA0he2MuSP9U5cn43tPbTsNAYEuEB5tB1QFdxs6dWQJOvO17SvrOcQV93COQbO4QSwZOTM9KNmV81P8XaMahJWQBFZ/hNepklbqBDhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705522839; c=relaxed/simple;
	bh=tT0qfVOuAexeqBtyZ5zoGDcKcqX7Y5E/UX2lNdxzzV4=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=d6fMIcS8NuwfykJYdiCClqpHzx0clzLC0P6wFSuyP3fhJJDxzYznStQtHZp5NwRIxYmdmAlWa8AB/kIQfCehMYFJMxoaMHcmYEXmuzPSGMBIR8QMyky3Fnb2Jamn/Ft0d2RIgf0jTUitg7B8UICAWs6QyDp/vZpZ7hqkg9hhN18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EHL+j1dD; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EHL+j1dD"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bb5be6742fso109737939f.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 12:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705522837; x=1706127637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fIoquENYXWJoHN1A2Mrf3K7o57gEP0X/sUWlRZqWpBc=;
        b=EHL+j1dD1GpX6gkLa3ssYkDaVDHQuiQ1NqRU50VjkoLHXYcjzkIuNZVJo6eTJFelwz
         FVBs+Q6XXALrZOuGxd7CDOCGXGohOquuU6IMa5D9YDB+XPVrA/iRK5562vjzteLWN9Mp
         pIXuVGi5/2MZG6rXdJSlvJU5umphsj1RxUr/cQRgg158R0LcKj3LDxKJ6YItGDVmdHJz
         ShPBceZ2R8a5w4iCvxK9Wf3IVQ52Rug9De/Lgbcosn4JML+pnXdbRO++m8dksB6YXDq7
         GYp3MTSrDn1eQe51EJR8wmq1mFX7w0U3HiVzXeX6dCMxgKgyuchJkXZdLSIfttpY7G/7
         9c3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705522837; x=1706127637;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fIoquENYXWJoHN1A2Mrf3K7o57gEP0X/sUWlRZqWpBc=;
        b=D110xxHURpDVS1Q1p6qwnNgxq0EvJLruIwu02ochaCGznI1TGWNXRrM1P9vJv/3aIv
         +UyN74RlW5NJOOeiWxsbOxuPTf2NhviPzP/C+5Ue4wHnQhbi+pI4vFWkVHCS9YALLEl+
         cFZMQreJUZ+29mIT1uAy+IQEb1iZ0HYv2jwKgLSPBXOQc12/E4jm+/IPhW5/XySRK/EE
         MRw5ngds54lBuxzf01uoUZkOpmg5n4+u4oerTyl6s3qwmZ8BQtpYGsQK8z2Qfde6PTxe
         pWTXr0HRTentXL7d5GWhKWxGRTmQ7/fe7ptomWWZ1pg7kc5GIzNCFhd8Cq9Yl6UVcrbC
         aIhw==
X-Gm-Message-State: AOJu0YyYxLhNyUo2d/OuPs7+CTE5+e6jnvvc1Zg50i/wlgRil87q6BsS
	K+A+RVWTg0U2w0uPuqjJRWQTavfm3DnxxQ==
X-Google-Smtp-Source: AGHT+IHNkGqCG/5i9QmTvp4l6I+DJ3/KFjMRzkufzIiVW/B+nmPmgokmhshaLBC+7Igp1Tt+BbP61g==
X-Received: by 2002:a05:6602:2c95:b0:7be:e080:6869 with SMTP id i21-20020a0566022c9500b007bee0806869mr17304148iow.1.1705522837427;
        Wed, 17 Jan 2024 12:20:37 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h14-20020a05660208ce00b007bf021d13ebsm3628383ioz.49.2024.01.17.12.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 12:20:36 -0800 (PST)
Message-ID: <9f4a6b8a-1c17-46b7-8344-cbf4bcb406ab@kernel.dk>
Date: Wed, 17 Jan 2024 13:20:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal
 <dlemoal@kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
 <43cc2e4c-1dce-40ab-b4dc-1aadbeb65371@acm.org>
 <c38ab7b2-63aa-4a0c-9fa6-96be304d8df1@kernel.dk>
 <2955b44a-68c0-4d95-8ff1-da38ef99810f@acm.org>
 <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
 <276eedc2-e3d0-40c7-b355-46232ea65662@kernel.dk>
 <39dfcd32-e5fc-45b9-a0ed-082b879a16a4@acm.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <39dfcd32-e5fc-45b9-a0ed-082b879a16a4@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 1:18 PM, Bart Van Assche wrote:
> On 1/17/24 12:06, Jens Axboe wrote:
>> Case in point, I spent 10 min hacking up some smarts on the insertion
>> and dispatch side, and then we get:
>>
>> IOPS=2.54M, BW=1240MiB/s, IOS/call=32/32
>>
>> or about a 63% improvement when running the _exact same thing_. Looking
>> at profiles:
>>
>> -   13.71%  io_uring  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
>>
>> reducing the > 70% of locking contention down to ~14%. No change in data
>> structures, just an ugly hack that:
>>
>> - Serializes dispatch, no point having someone hammer on dd->lock for
>>    dispatch when already running
>> - Serialize insertions, punt to one of N buckets if insertion is already
>>    busy. Current insertion will notice someone else did that, and will
>>    prune the buckets and re-run insertion.
>>
>> And while I seriously doubt that my quick hack is 100% fool proof, it
>> works as a proof of concept. If we can get that kind of reduction with
>> minimal effort, well...
> 
> If nobody else beats me to it then I will look into using separate
> locks in the mq-deadline scheduler for insertion and dispatch.

That's not going to help by itself, as most of the contention (as I
showed in the profile trace in the email) is from dispatch competing
with itself, and not necessarily dispatch competing with insertion. And
not sure how that would even work, as insert and dispatch are working on
the same structures.

Do some proper analysis first, then that will show you where the problem
is.

-- 
Jens Axboe

