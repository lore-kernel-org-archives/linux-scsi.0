Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7BB24A17
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705521988; cv=none; b=DyPSVVIgzjCcUClOtXBYUUEL2PXj8wRoGUb8YKcqSQPHhSaRM/5jUFsFqcb6N7hJpqU3sP1pg7ChVjc9Q6FWcEJiLbm69dKukt1BRPxu9rXJd3o/EdMkGQw9UaQAtQJd5NS72HuTM7Qa3eUteU8eFOT9swUVMkVymAUncqADe+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705521988; c=relaxed/simple;
	bh=XrCbn8NqIBW6LmrHSdKJd3VVhmxEPJ9wyh9xzdzr2XE=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 From:To:Cc:References:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=NWRMkBXtglWwbvtsf6RZT0VxaC+/sZAOFntsIKQPSdOxUZmhBx0PAD8YW8pYhljFhPD7H4SNqKVyLKP6OE9mJQbXUzP85VxjULFBQ8G9WI5rcbPZKceaSgvg7/1VhMRz8SPnNXZcLt7O7NK9Qtz/zidiZIZJaVJuVAK9KMxAQZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f75+nqwo; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f75+nqwo"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7bee9f626caso58677439f.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 12:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705521986; x=1706126786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RylSDua2BnQBNhz0ri2mwOlsrVpcdZ7iruL97tOno0k=;
        b=f75+nqwoq7ZxV7xGHotenGl/cZzlI+RaJFg3Zwq29j5zkRa9kpPTenYIQp2z6vg1a3
         lESAs0E0dY9VDGaWqJdLi2J3UzUwKzddLDJ0ZrNze7BgLnv9J+b+vJaYDEc3Z6Q4MDYG
         CZWRqiy6Ug3LY+H1wCwm7Q6kwRtzOjMrftPcO2Kr90t9/221p4KH/aUs50+Ws38pNuW7
         K+7mheiA+TOzku7498h21ghIMyXf+MFAZanYRyrVL3FgYAAsxT49eg123YPJfVOpdYTT
         46HGlyBuzc+QR5tPK/sCxUSlLcR1hTHq1AFM/y2pIIkpTbiS8zGX4N1qOXyYuV56wEPt
         yD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705521986; x=1706126786;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RylSDua2BnQBNhz0ri2mwOlsrVpcdZ7iruL97tOno0k=;
        b=tWGBl+i1hayFBc2YviYs74mDhjbDT8mJsT5CjsV+640Dj3r+hrM2XEIQB+JvACOflO
         yQYBdxD/SnBcUNa2IFOEyXCrXMLz6atUXsFBzkn6bQuwL+ZNy+xdSPyQ3SKyhQ1ZRkQt
         jeJJxKiBlVm96LhCoSxA2395yw3eLEJOEgtbdoQNBKLeQFz/RUv5I48VoGSTPc2siblR
         eiOtHdfk8Qfcd38K8jlq9ffwEsqsCqZZFHzkr4BPaoubB6o5FgGDPeJJTy8JPQSQrDcc
         QYyqMuYK/hU+NHXMht5jdZfMGpBe1NL0lzPrzWM0+9BTnRzxm0eICW5QmWQjmUqhi6n9
         BMsQ==
X-Gm-Message-State: AOJu0YyCZJZSyRLkALK60+HR8NfX167+6LWEL29h/6fWMhdr/c7VnuV5
	WX3dC/q/7ctxGn2LK7DavGOVm4LpVvDBmA==
X-Google-Smtp-Source: AGHT+IGWsohYVR1pZF1dkrm0P3WI2640KWeQttN82iMT/+YWYam6SPj4ldcXSQVyCmlk/vJ0pfftEA==
X-Received: by 2002:a5e:834b:0:b0:7bc:2603:575f with SMTP id y11-20020a5e834b000000b007bc2603575fmr3270490iom.0.1705521985985;
        Wed, 17 Jan 2024 12:06:25 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l16-20020a056638221000b0046df601152dsm589695jas.66.2024.01.17.12.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 12:06:25 -0800 (PST)
Message-ID: <276eedc2-e3d0-40c7-b355-46232ea65662@kernel.dk>
Date: Wed, 17 Jan 2024 13:06:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
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
In-Reply-To: <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 11:43 AM, Jens Axboe wrote:
> Certainly slower. Now let's try and have the scheduler place the same 4
> threads where it sees fit:
> 
> IOPS=1.56M, BW=759MiB/s, IOS/call=32/31
> 
> Yikes! That's still substantially more than 200K IOPS even with heavy
> contention, let's take a look at the profile:
> 
> -   70.63%  io_uring  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
>    - submitter_uring_fn
>       - entry_SYSCALL_64
>       - do_syscall_64
>          - __se_sys_io_uring_enter
>             - 70.62% io_submit_sqes
>                  blk_finish_plug
>                  __blk_flush_plug
>                - blk_mq_flush_plug_list
>                   - 69.65% blk_mq_run_hw_queue
>                        blk_mq_sched_dispatch_requests
>                      - __blk_mq_sched_dispatch_requests
>                         + 60.61% dd_dispatch_request
>                         + 8.98% blk_mq_dispatch_rq_list
>                   + 0.98% dd_insert_requests
> 
> which is exactly as expected, we're spending 70% of the CPU cycles
> banging on dd->lock.

Case in point, I spent 10 min hacking up some smarts on the insertion
and dispatch side, and then we get:

IOPS=2.54M, BW=1240MiB/s, IOS/call=32/32

or about a 63% improvement when running the _exact same thing_. Looking
at profiles:

-   13.71%  io_uring  [kernel.kallsyms]  [k] queued_spin_lock_slowpath

reducing the > 70% of locking contention down to ~14%. No change in data
structures, just an ugly hack that:

- Serializes dispatch, no point having someone hammer on dd->lock for
  dispatch when already running
- Serialize insertions, punt to one of N buckets if insertion is already
  busy. Current insertion will notice someone else did that, and will
  prune the buckets and re-run insertion.

And while I seriously doubt that my quick hack is 100% fool proof, it
works as a proof of concept. If we can get that kind of reduction with
minimal effort, well...

-- 
Jens Axboe

