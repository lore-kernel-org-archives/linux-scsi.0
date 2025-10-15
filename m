Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50415338F45;
	Wed, 15 Oct 2025 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760545954; cv=none; b=l6dLdXGUUZsD0vzHw2nkJ6Mmw231ztli6Y//v2cQwNQuVSVnwDJQhcH/zc+xO505lwo/8EAIkpWqJpXVpEaWBCz0OwZqjUtfcwclmwEN8ID01J9ygWAKT9ckSW1hJAYLiQuOOYSlg5niOciyi6+tpUwliDORBKTfHFEMhOLvXPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760545954; c=relaxed/simple;
	bh=n4bfpfWUkuIt96T+6ivvpwEYLypBYO7q8X0vD17mV7w=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=od3Jon2kfu64haG6chUUwxPwltK2qerRSS+0cc8qGWKctkXsfHyxhk5ERaVd9Cf5OJPTqXJSr2QiE+308FOoKW9VNC+TXBXs7lp8VzLWIbCaXqpr9UpXLC7wl2apTRCkMA8MlYYLdwMX5VoHM6x9DfbDmWdHr4JS92Pcbqgq2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HDJSUVcX; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HDJSUVcX"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmxSv2n3Bzm0ytk;
	Wed, 15 Oct 2025 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:subject:subject:from:from
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760545949; x=1763137950; bh=2XbnKFbDrgZnuQ0fkto9x+nh
	ZLH0G410ifr9/LR49GI=; b=HDJSUVcXGC7yHz5W+ZCG2wXQmENqy9symio6u4yc
	dWsPp7R5ZTCZPa3TgThM+ppyaIRV/h1bnVmm2cIw9EnVFQBS1Ew3yp1Pe6+oNXvg
	RTk1A8oyj3QqnhAghfq3/Vjg4GEQq9ZMFGg04mgCiqooloOLqL7lVAOabuRsix0U
	/ln+4rGESYVWxv+MwEapdYdCKSoSmiM/tqDLSd2/uhF2En2xeTjIrDAJKs+qeKSP
	Ibzo1PE7XvyHNMc5jvgCfxND2gLsO12VdfV4elT6gUnZCCEklQdMMxIJeQ68Gp/Q
	W1Yz8UzX6fcaSqiGdhaO4j7GnC6U2r9zV5P4R4XBd6ke8Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iALI4LsrElHW; Wed, 15 Oct 2025 16:32:29 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmxSp5ZFQzm16kk;
	Wed, 15 Oct 2025 16:32:25 +0000 (UTC)
Message-ID: <ff29e7f3-71bb-4fd0-afe2-59daac21f92a@acm.org>
Date: Wed, 15 Oct 2025 09:32:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v25 07/20] block/mq-deadline: Enable zoned write
 pipelining
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-8-bvanassche@acm.org>
 <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org>
Content-Language: en-US
In-Reply-To: <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/25 12:31 AM, Damien Le Moal wrote:
> On 2025/10/15 6:54, Bart Van Assche wrote:
>> The hwq selected by blk_mq_run_hw_queues() for single-queue I/O schedulers
>> depends on the CPU core that function has been called from. This may lead
>> to concurrent dispatching of I/O requests on different CPU cores and hence
>> may cause I/O reordering. Prevent as follows that zoned writes are
>> reordered:
>> - Set the ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING flag. This disables
>>    the single hwq optimization in the block layer core.
>> - Modify dd_has_work() such that it only reports that any work is pending
>>    for zoned writes if the zoned writes have been submitted to the hwq that
>>    has been passed as argument to dd_has_work().
>> - Modify dd_dispatch_request() such that it only dispatches zoned writes
>>    if the hwq argument passed to this function matches the hwq of the
>>    pending zoned writes.
> 
> One of the goals of zone write plugging was to remove the dependence on IO
> schedulers to control the ordering of write commands to zoned block devices.
> Such change are going backward and I do not like that. What if the user sets
> Kyber or bfq with your zone write pipelining ? Does it break ?

Hi Damien,

As you know the Kyber I/O scheduler dispatch callback only returns requests
for the hardware queue that has been passed as an argument to the dispatch
callback. So it's probably safe to set the
ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING for the Kyber I/O scheduler.
However, that hasn't been done yet.

Since neither Kyber nor BFQ set the flag
ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING, zoned write pipelining will
be left disabled for these I/O schedulers. See also the following code from
a previous patch:

+bool blk_pipeline_zwr(struct request_queue *q)
+{
+	return q->limits.features & BLK_FEAT_ORDERED_HWQ &&
+	       (!q->elevator ||
+		test_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING,
+			 &q->elevator->flags));
+}

> From the very light explanation above, it seems to me that what you are trying
> to do can be generic in the block layer and leave mq-deadline untouched.

I don't think that the race described above can be solved in the block layer.
More in detail, the race condition that I observed several times while running
tests with mq-deadline and zoned write pipelining enabled and without the
mq-deadline patches from this series is as follows:

CPU core a                                  CPU core b
------------------------------------------  ------------------------------------------
blk_mq_run_hw_queue(hctx c)                 blk_mq_run_hw_queue(hctx c)
   blk_mq_sched_dispatch_requests(hctx c)      blk_mq_sched_dispatch_requests(hctx c)
     blk_mq_do_dispatch_sched(hctx c)            blk_mq_do_dispatch_sched(hctx c)
       dd_dispatch_request(hctx c) -> rq e
                                                   dd_dispatch_request(hctx c) -> rq f
       blk_mq_dispatch_rq_list(hctx c)             blk_mq_dispatch_rq_list(hctx c)
                                                     q->mq_ops->queue_rq(hctx c, rq f)
         q->mq_ops->queue_rq(hctx c, rq e)

If requests (e) and (f) refer to the same zone, with write pipelining enabled,
the above sequence causes request reordering. If both requests are regular
writes (not write appends), this will trigger an UNALIGNED WRITE COMMAND error.
I think this can only be solved by modifying an I/O scheduler such that its
dispatch callback only dispatches requests for the hctx that has been passed as
an argument to the dispatch function.

Please note that for my use cases I'm fine with not using any I/O scheduler at
all and hence that I'm fine with dropping the mq-deadline patches from this
series. Is this perhaps what you prefer?

Thanks,

Bart.
