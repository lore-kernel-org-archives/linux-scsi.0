Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC91623740
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 21:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705527660; cv=none; b=rwTZaWssAOEphhk+je+7J4VdUTeo+GFUZGtlble+Vz9EYSQ6hIlt/fAtZ2ctGXfnsu1s9Qqh92vMHGKeRSHoS+WpUGmgdRYB5oIkQqei3pzbS6ivFS57dXSD7xidnbdziAcG9gGcRUUXWFp/7VOeZI3BkheRaqRB1/eXc3UmuZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705527660; c=relaxed/simple;
	bh=IA/GVOT/nYaG4QLzwH3nHzODWYVDuIgMXt6khpIlc7I=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=DujUzv+mDUKS6SFcxXnu9HmhabWfPiA5m0JwR1BdAdu/GPxaaAtedeUg1kg97v8GtAyiR8Q0xPJBsMnHpwFyaC2SVOKn3aMuaY6qz+3qQCWjzbRe7JgkLczgnhWIfZDbyyVL9ydmCOxhm6ZAK8QYefvfuipk/XJlTjQgzYxjjIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CmsJg2UP; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CmsJg2UP"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7bed82030faso65214839f.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 13:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705527657; x=1706132457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smBRC0fGIjV7NVWRRSnbObc9QKfnzsw9Zntd5C5Qdwo=;
        b=CmsJg2UPVLGtd2syG2NNQ+fLfwRAsuU4yztxqy6ub0ngFxZR+niAxDvJi+FKaPUoR2
         sMv/IrvDYo++w7n2gBlhU//Z0Z16ZFXpZ0LgQV6dmK9+Fdyq3mxtyvcXt/SBpH1PmSFx
         MmYusewGP5yhVqTxdQ6G91VFf8llcU77XZCoes4uQX5S8rcNd/OB1LB2OOAQrsJ106av
         /88DsJeTZgVsyUQmGvVO30z43L7XW40j/7luJozAKBdA3zyMAvCIGCFo9oWQK2g0KYZ+
         Ymhrkn8roaGQkRmmAy0w7wyq4vI7Du+y0eghPKV7EQVf0arZcDsREJvtbW3XK5tTuJ8m
         qVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705527657; x=1706132457;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=smBRC0fGIjV7NVWRRSnbObc9QKfnzsw9Zntd5C5Qdwo=;
        b=YnX3lTCum3hXTRwvpbbDf/oJ9/o9HG6n5/9aptxcY/BRyHGK3CmbGnjIh5JIKSk/S1
         PdXsLSv3XGKi1iTsEwQO69HIjW6R0EOHlJDAAHvmdl5FtVHofHprRYWR6TSOpqvp2h0Z
         XBeW2XYyDFNpKgkQI0xKGlc+eah+L9RhXoHYbIYiKRQAxTqO9morfzbQQY2vS+T2+uOb
         lhAUjBZEZwaaSBmeYyuSJs9RIhDEyvgQ3mY715Ckp8PMoFCKkWSIhqu2ffJB7Z+hEmUV
         2yAX84RiL/tpoeFZAHt6YRpd4kGzpavrEKfsqJkFj4sWjrKLxDPjpgjVK2XJzS3noWho
         /lAA==
X-Gm-Message-State: AOJu0YwJi2kSg008wjT2MlB8HE0xSMn6DQEyDIWT+rrItfSYpx4she12
	xI28eAf8f1Jnurn0+JFlbF0pzXdz4LBhMA==
X-Google-Smtp-Source: AGHT+IEFCB+mlkil6mSwJtj1E/FwGBlpCCSuAEtTZsOEEjRvUWlgz2WoebfbWy1i24fq79CojzvXCw==
X-Received: by 2002:a6b:5803:0:b0:7bf:4758:2a12 with SMTP id m3-20020a6b5803000000b007bf47582a12mr9490867iob.0.1705527656920;
        Wed, 17 Jan 2024 13:40:56 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g1-20020a05663811c100b0046b451e7b57sm614364jas.45.2024.01.17.13.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 13:40:56 -0800 (PST)
Message-ID: <90de77e4-ed8a-47be-b5df-2178913ec115@kernel.dk>
Date: Wed, 17 Jan 2024 14:40:55 -0700
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
 <9f4a6b8a-1c17-46b7-8344-cbf4bcb406ab@kernel.dk>
 <207a985d-ad4e-4cad-ac07-961633967bfc@kernel.dk>
 <e8c32676-114b-4aaf-8753-5a6d7b04fc4b@kernel.dk>
 <86a1f9e6-d3ae-4051-8528-13a952cf74a1@acm.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <86a1f9e6-d3ae-4051-8528-13a952cf74a1@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 2:33 PM, Bart Van Assche wrote:
> On 1/17/24 13:14, Jens Axboe wrote:
>>   /* Maps an I/O priority class to a deadline scheduler priority. */
>> @@ -600,6 +604,10 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
>>       struct request *rq;
>>       enum dd_prio prio;
>>   +    if (test_bit(0, &dd->dispatch_state) ||
>> +        test_and_set_bit(0, &dd->dispatch_state))
>> +        return NULL;
>> +
>>       spin_lock(&dd->lock);
>>       rq = dd_dispatch_prio_aged_requests(dd, now);
>>       if (rq)
>> @@ -616,6 +624,7 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
>>       }
>>     unlock:
>> +    clear_bit(0, &dd->dispatch_state);
>>       spin_unlock(&dd->lock);
> 
> Can the above code be simplified by using spin_trylock() instead of
> test_bit() and test_and_set_bit()?

It can't, because you can't assume that just because dd->lock is already
being held that dispatch is running.

> Please note that whether or not spin_trylock() is used, there is a
> race condition in this approach: if dd_dispatch_request() is called
> just before another CPU calls spin_unlock() from inside
> dd_dispatch_request() then some requests won't be dispatched until the
> next time dd_dispatch_request() is called.

Sure, that's not surprising. What I cared most about here is that we
should not have a race such that we'd stall. Since we haven't returned
this request just yet if we race, we know at least one will be issued
and we'll re-run at completion. So yeah, we may very well skip an issue,
that's well known within that change, which will be postponed to the
next queue run.

The patch is more to demonstrate that it would not take much to fix this
case, at least, it's a proof-of-concept.

-- 
Jens Axboe

