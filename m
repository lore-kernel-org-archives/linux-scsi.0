Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DD225558
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 21:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705525377; cv=none; b=nBpPXGKoC62Z2YQxKMduInpWk0y2isg8MaaLyUhksowz2TIHgmshontShZ02Gfwcxi7N8Yj9c/Y6Yg84Qi3V419XZiNYLA9qBjvr4GXJTV64p3Jd817DZqwi4SM+JK0zO5Wpuvg7oSzs+8SIDavn6bbVCYpKG63fmJyBBYFqKQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705525377; c=relaxed/simple;
	bh=dLWBwXlk2TQU5yZga82/ibp2y371ZNEt64HdcSraPxU=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 From:To:Cc:References:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=NKG7ULnjtzMPKbHiT5JNXXdrUaP4rl3H5csCqbzurxc87rMEp5SlXXqZUiZ0bngJwfBk++WBPzA3McU1W1IK7OMIcdmen2Hb4AHupFQSo5iR/qHKkoJ+Br1m5bcrH1iO6yQB/7hh4/RbT+Rm3sTRcstDa10kXiMGr1HoNjiOJfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H1gaA3xz; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H1gaA3xz"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-36191ee7be4so2114965ab.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 13:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705525374; x=1706130174; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xWPWFxixc3gOJ5TuAohxDe3jpGLKyM0nNrCjE6iAnNI=;
        b=H1gaA3xzoeaC0JGPvRpiUa9pujVwZYq3szTIq7pkIeESf90h+mIV0J+himLX73RHhS
         ldQQ6vDIKtg7AKimnGk0d+gDVjE722ufbG5K4BC0lZtbcAqQSrUVaPlrwlrdyH/zIfNZ
         N/vm3xw9lqF53SIY8O1Flh+NQGrEDs2LvmT7nEq5LtUO9I/+96lq20zFxwqBHuaeurN5
         s/FAStiC3UkHZtdqtPBZVhQwMlj4wTz2+xgbI9jrINP7Sruplos/h6YSB2qJmssJu0Jg
         w0O3ebDe+6FKxE2tGghz+CFUlfpRwTYXBi0sjYW64IqQBtG1kYKkjCxB92FcIbIr2YiK
         SEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705525374; x=1706130174;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xWPWFxixc3gOJ5TuAohxDe3jpGLKyM0nNrCjE6iAnNI=;
        b=U98bKpsK3Ccrknt097yWoV9+8RgtfDSQ4gDwQaEGvwpDlWpkjObJBDpNmF1HOM0tQF
         Fz8tbm3J7lTWvASOeCz5pmYxQzO2xII/GY3M9t3TDmCGHPZZYJFasbMUj2P5hldpWIqz
         rCm73/zIhmrEoVY+3EiUb8s1JGoOYU4HWCEZ+BHorG9N9B2rz0au80vM8gd5EFwk5qof
         EDQLp0CF/CI/4rabBzRFXpguohWFI0jtkJiSPImbQbO7SN0FdctD5ooj8hnNc4AAiftC
         9rqUKBFNmIS73q5JZop3k1K2qAG77/EzOJJo6vA1P8m7xRsKNoOQ3FTlSnPVhHyMUaEU
         F8Vg==
X-Gm-Message-State: AOJu0YysXeRCzOeORgBM1XYalMjno6rgjeQqGlNckI8A04YfmyNhrm+L
	XcXeNiAIBc3FbEDOmGx4v/bi6CneU6PT5g==
X-Google-Smtp-Source: AGHT+IEqv20xRorrWet2nJBHIW4ExNsaq6Cj0+pd1nBEWoPOk2NmeNwke4/2lBC1s1s3GmOQvjXZ0g==
X-Received: by 2002:a6b:7e01:0:b0:7be:e328:5e3a with SMTP id i1-20020a6b7e01000000b007bee3285e3amr15427250iom.0.1705525374172;
        Wed, 17 Jan 2024 13:02:54 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l13-20020a02cd8d000000b0046e578ed0aasm609987jap.96.2024.01.17.13.02.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 13:02:53 -0800 (PST)
Message-ID: <207a985d-ad4e-4cad-ac07-961633967bfc@kernel.dk>
Date: Wed, 17 Jan 2024 14:02:51 -0700
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
 <276eedc2-e3d0-40c7-b355-46232ea65662@kernel.dk>
 <39dfcd32-e5fc-45b9-a0ed-082b879a16a4@acm.org>
 <9f4a6b8a-1c17-46b7-8344-cbf4bcb406ab@kernel.dk>
In-Reply-To: <9f4a6b8a-1c17-46b7-8344-cbf4bcb406ab@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 1:20 PM, Jens Axboe wrote:
> On 1/17/24 1:18 PM, Bart Van Assche wrote:
>> On 1/17/24 12:06, Jens Axboe wrote:
>>> Case in point, I spent 10 min hacking up some smarts on the insertion
>>> and dispatch side, and then we get:
>>>
>>> IOPS=2.54M, BW=1240MiB/s, IOS/call=32/32
>>>
>>> or about a 63% improvement when running the _exact same thing_. Looking
>>> at profiles:
>>>
>>> -   13.71%  io_uring  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
>>>
>>> reducing the > 70% of locking contention down to ~14%. No change in data
>>> structures, just an ugly hack that:
>>>
>>> - Serializes dispatch, no point having someone hammer on dd->lock for
>>>    dispatch when already running
>>> - Serialize insertions, punt to one of N buckets if insertion is already
>>>    busy. Current insertion will notice someone else did that, and will
>>>    prune the buckets and re-run insertion.
>>>
>>> And while I seriously doubt that my quick hack is 100% fool proof, it
>>> works as a proof of concept. If we can get that kind of reduction with
>>> minimal effort, well...
>>
>> If nobody else beats me to it then I will look into using separate
>> locks in the mq-deadline scheduler for insertion and dispatch.
> 
> That's not going to help by itself, as most of the contention (as I
> showed in the profile trace in the email) is from dispatch competing
> with itself, and not necessarily dispatch competing with insertion. And
> not sure how that would even work, as insert and dispatch are working on
> the same structures.
> 
> Do some proper analysis first, then that will show you where the problem
> is.

Here's a quick'n dirty that brings it from 1.56M to:

IOPS=3.50M, BW=1711MiB/s, IOS/call=32/32

by just doing something stupid - if someone is already dispatching, then
don't dispatch anything. Clearly shows that this is just dispatch
contention. But a 160% improvement from looking at the initial profile I
sent and hacking up something stupid in a few minutes does show that
there's a ton of low hanging fruit here.

This is run on nvme, so there's going to be lots of hardware queues.
This may even be worth solving in blk-mq rather than try and hack around
it in the scheduler, blk-mq has no idea that mq-deadline is serializing
all hardware queues like this. Or we just solve it in the io scheduler,
since that's the one with the knowledge.

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8..822337521fc5 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -80,6 +80,11 @@ struct dd_per_prio {
 };
 
 struct deadline_data {
+	spinlock_t lock;
+	spinlock_t zone_lock ____cacheline_aligned_in_smp;
+
+	unsigned long dispatch_state;
+
 	/*
 	 * run time data
 	 */
@@ -100,9 +105,6 @@ struct deadline_data {
 	int front_merges;
 	u32 async_depth;
 	int prio_aging_expire;
-
-	spinlock_t lock;
-	spinlock_t zone_lock;
 };
 
 /* Maps an I/O priority class to a deadline scheduler priority. */
@@ -600,6 +602,10 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	struct request *rq;
 	enum dd_prio prio;
 
+	if (test_bit(0, &dd->dispatch_state) &&
+	    test_and_set_bit(0, &dd->dispatch_state))
+		return NULL;
+
 	spin_lock(&dd->lock);
 	rq = dd_dispatch_prio_aged_requests(dd, now);
 	if (rq)
@@ -616,6 +622,7 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	}
 
 unlock:
+	clear_bit(0, &dd->dispatch_state);
 	spin_unlock(&dd->lock);
 
 	return rq;

-- 
Jens Axboe

