Received: from smtp.ideco.ru (smtp.ideco.ru [51.250.56.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774CE3E0C75;
	Fri,  7 Aug 2026 10:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.250.56.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099847; cv=none; b=Lhl15tdg8caJk0NI8DwNRAr6/L0AdeL2riZcj++7spRnkQOTvuzPFeYgi9XRfSSk2XXFhV3vvUwFdNRNG6R3HoedNd5qy34dRwuA+O0g1jcEjKBn9lqjivUh2XwcKaqDL4u7ufjp2Mcsiv0+cVdTT0jEiYZYOxIK/JOwQqiIGIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099847; c=relaxed/simple;
	bh=82Xq3M2OR1LnqSKsLbg9QUYcniIKWFUUSsFBBEOk8KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=thIiXLm4VwTVN2L0D1fTQePILowNWxOZR9cLc1rUzrFpo2pURTE6YxAeRN8lZMDdl49NF45KPncQTSrettey9wtessPzogJB4HjXRVVKxbcd1EsohZqKUm7Kj1N6xYKxLfli+KSx7BoSkK58WnXJroSWwHCqVk5RzhIBYclheio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru; spf=pass smtp.mailfrom=ideco.ru; dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b=ILn87nF6; arc=none smtp.client-ip=51.250.56.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideco.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b="ILn87nF6"
Received: from [169.254.254.254] (localhost [127.0.0.1])
	by smtp.ideco.ru (Postfix) with ESMTP id 5AABD20309B4;
	Fri, 07 Aug 2026 15:44:36 +0500 (+05)
Received: from [198.18.0.1] (unknown [5.131.7.59])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.ideco.ru (Postfix) with ESMTPSA id 7B0992030E86;
	Fri, 07 Aug 2026 15:44:25 +0500 (+05)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.ideco.ru 7B0992030E86
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ideco.ru; s=ics;
	t=1786099474; bh=TWPLC4fjaZ1kAE9Ig/H8XawXPOPZZ0Xjdz0LtGGJCn8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ILn87nF6HmnyB4o4eAGENnVwEObLPgu3JFm90Jd6g9V58wox8wmZJbpx3jv5O0fxg
	 mDFwlCUuDv1rgiM2XEgrpYmv520UfWfouq3ivT7/ab4oubAGASriapP8BPQDqUZAAm
	 1g7/KKs6SOhFG2gkd9U0Zw9phE9Mci8nlCYtclxZoq0dHXzJfOacaVT/iPcPts4vUH
	 VwixNhXjybXHJXF8JRG+km0JK0xNTf3B81QZBKXdx9Dz1cxas71wkJ6JLLMjQreYoB
	 7Z+G7+GWPUUTMa8th0ZDA33EM1nL+x3VRSafhxCybGXzNRiUTxw9pN2mgVZ5bIM1Di
	 r8gbvtItu6VIA==
Message-ID: <55987716-638a-44c0-a49e-435fc4a134c6@ideco.ru>
Date: Fri, 7 Aug 2026 17:43:54 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: fill in DMA padding bytes in scsi_alloc_sgtables
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20260628185229.37957-1-p.vaganov@ideco.ru>
 <0372449f-f41d-4484-a301-2a1bc15b0483@acm.org>
Content-Language: en-US
From: Petr Vaganov <p.vaganov@ideco.ru>
In-Reply-To: <0372449f-f41d-4484-a301-2a1bc15b0483@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Yes, the warning is triggered by kmsan_handle_dma_sg(). However, the 
KMSAN report does not appear to be a false positive. There is an actual 
initialization issue: scsi_alloc_sgtables() extends the last scatterlist 
entry by pad_len, but these additional bytes are not initialized before 
the buffer is mapped for DMA. As a result, uninitialized kernel memory 
may become visible to the device during a DMA_TO_DEVICE transfer.

This is exactly the kind of issue KMSAN is intended to detect. The KMSAN 
documentation explicitly mentions passing uninitialized memory to 
hardware as a security issue.

Initializing the padding unconditionally does add some overhead. 
However, sg_zero_buffer() is only called for requests that actually 
require DMA padding. In my opinion, this overhead is preferable to 
leaving uninitialized kernel memory exposed to the device.

Thanks,
Petr

On 7/23/26 01:27, Bart Van Assche wrote:
> On 6/28/26 11:52 AM, Petr Vaganov wrote:
>> During fuzz testing, the following issue was discovered:
>>
>> BUG: KMSAN: uninit-value in __dma_map_sg_attrs+0x217/0x310
>>   __dma_map_sg_attrs+0x217/0x310
>>   dma_map_sg_attrs+0x4a/0x70
>>   ata_qc_issue+0x9f8/0x1420
>>   __ata_scsi_queuecmd+0x1657/0x1740
>>   ata_scsi_queuecmd+0x79a/0x920
>>   scsi_queue_rq+0x4472/0x4f40
>>   blk_mq_dispatch_rq_list+0x1cca/0x3ee0
>>   __blk_mq_sched_dispatch_requests+0x458/0x630
>>   blk_mq_sched_dispatch_requests+0x15b/0x340
>>   __blk_mq_run_hw_queue+0xe5/0x250
>>   __blk_mq_delay_run_hw_queue+0x138/0x780
>>   blk_mq_run_hw_queue+0x4bb/0x7e0
>>   blk_mq_sched_insert_request+0x2a7/0x4c0
>>   blk_execute_rq+0x497/0x8a0
>>   sg_io+0xbe0/0xe20
>>   scsi_ioctl+0x2b36/0x3c60
>>   sr_block_ioctl+0x319/0x440
>>   blkdev_ioctl+0x80f/0xd70
>>   __se_sys_ioctl+0x219/0x420
>>   __x64_sys_ioctl+0x93/0xe0
>>   x64_sys_call+0x1d6c/0x3ad0
>>   do_syscall_64+0x4c/0xa0
>>   entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>
> dma_map_sg_attrs() shouldn't touch the data buffer. Is the above warning
> triggered because of the kmsan_handle_dma_sg() call in
> __dma_map_sg_attrs()?
>
>
>>           last_sg->length += pad_len;
>> +        sg_zero_buffer(last_sg, 1, pad_len, data_len);
>>           cmd->extra_len += pad_len;
>
> Shouldn't sg_zero_buffer() only be called if CONFIG_UBSAN is enabled to
> prevent that this call negatively affects I/O performance?
>
> Thanks,
>
> Bart. 

