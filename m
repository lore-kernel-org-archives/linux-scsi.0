Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1803B05AF
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370792; cv=none; b=jgq9OSjxt8qhX/+YzjqMZU0K8sfOSjZP5BzIdKbOxAmwOzZNPEOC9PF8hyTf4SBNnlBnfSU5FbA28qGKutVwV8AkRMnmB4ZiusLrI+/T/EJL5rgUvjVeAAwUCVeK6giHuxKeWcZSZvkMtx3JnwAsmfdhrFlKvHgiSS6iSTO1Z88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370792; c=relaxed/simple;
	bh=p83/bTpKodwfCwHT6aBZfNiTrQbF2xQCeFxJ3zFR5Ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J+Wlj8GoSB1BK2xePbpxDUY87XJxAVrack0lwMe37VoLTDIbxLPfb/H9eejJtRoPcEb/C7q7scRCpYuyGaQnkzLLLGcQ6VuMJXo993lvNxDuUW3mJqao4Is+t0ZTBIEjWL/9aUQfdyQKpmzOfCT2rkabX4y08D0IOoSABhhX/5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=schfPzJJ; arc=none smtp.client-ip=91.218.175.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="schfPzJJ"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=p83/bTpKodwfCwHT6aBZfNiTrQbF2xQCeFxJ3zFR5Ag=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789370786; v=1; x=1789975586;
 b=schfPzJJTh79hukwE+5CC7bciH6OYM0aP5DfBDy1y0SVj1MR5v1dzpxXcnx4AXmRw8Jq6Lo4
 LR0z1glBExHNxC7vqb8Nqy18QiGDD1py/hnm0XhQ3t8oPrCBP47lpzv7aqfcQc/f4G54OVkciHZ
 8xvXknJ2ztQHkViK59Lp1lqU=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 52fcd64584e33814;
	Mon, 14 Sep 2026 07:26:16 +0000
X-Mizu-Trace-ID: 52fcd64584e33814
X-Migadu-Flow: FLOW_OUT
Message-ID: <9230447a-77aa-4570-803e-ac62e9128e21@linux.dev>
Date: Mon, 14 Sep 2026 08:26:10 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-mq: cleanup terminal request when it could not be
 queued
To: Bart Van Assche <bvanassche@acm.org>, axboe@kernel.dk,
 James.Bottomley@HansenPartnership.com, mkp@kernel.org, hch@lst.de,
 tom.leiming@gmail.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260911075415.634921-1-john.garry@linux.dev>
 <eb86ffe1-db3d-4b52-b4a7-08c9524a0dae@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <eb86ffe1-db3d-4b52-b4a7-08c9524a0dae@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 16:55, Bart Van Assche wrote:
> On 9/11/26 12:54 AM, John Garry wrote:
>> Sashiko points out that the SCSI midlayer error handling misses some
>> cleanup for when a request could not be queued and won't be requeued [0].
>> Specifically, clearing the SCSI cmd flags member is missing. Normally 
>> that
>> would be cleared in the non-error path in scsi_end_request() (which also
>> calls __blk_mq_end_request()).
>>
>> Callchain blk_mq_cleanup_rq() -> scsi_cleanup_rq() does all the necessary
>> cleanup, so call that in blk_mq_dispatch_rq_list() for when there was an
>> error in the dispatch and the rq will be ended.
>>
>> Note that dm-rq code calls blk_mq_cleanup_rq() for a cloned rq (or 
>> SCSI rq)
>> for when the clone could not be queued and will be retried, but that path
>> does not use the sched code (and blk_mq_dispatch_rq_list()).
>>
>> [0] https://lore.kernel.org/linux- 
>> scsi/20260729161243.C918D1F00A3A@smtp.kernel.org/
>>
>> Suggesested-by: Bart Van Assche <bvanassche@acm.org>
>> Signed-off-by: John Garry <john.garry@linux.dev>
> Does this patch need a Fixes: tag? Anyway:

I can imagine that whatever this fixes pre-dates blk_mq_cleanup_rq(), so 
backporting is a concern. However, the oldest LTS today is 5.10, and 
blk_mq_cleanup_rq() is present there.

Anyway, I would like to get more opinion on whether this is the best 
approach.

> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

thanks

