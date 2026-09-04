Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8FC3F0AAF
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 10:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518795; cv=none; b=gxnvHlS/oecoy3nfT1AZFYzW8M8oqSpY7jRkJ/p+DsHhJT82ZgcPuFJk1tNxuYnc2HVaqAi4jUxvvMGaLFs+jO+cIDupdje7ufKfWJayFXplvh6HvWCM9O0F6x5d4s5gx2MUn7ihp36MTKywJELFWx5YoBqnwLY9/aUDGoAPGJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518795; c=relaxed/simple;
	bh=SWLNDM3X58Oi951rjmtN8VDdEwnQ812gsu954cQ4Gzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CAsovmhKoJhPKmQlMrkwRMoEptvXLcn/LlCRR9CrdmKTUPiB+Fm5yGV+OQ4e4qfRuZtCHNV+fZeKoy2yumzOfokICW/l4Q5VMFK+pEO+NyhVic9oLxGkJlCKKUeyO5rwVy9u//CX3yba+LNgbmlCWA5n0V+FkNV1Wsv/kBbw1dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CB/ia8qR; arc=none smtp.client-ip=95.215.58.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CB/ia8qR"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SWLNDM3X58Oi951rjmtN8VDdEwnQ812gsu954cQ4Gzc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788518791; v=1; x=1789123591;
 b=CB/ia8qRm5aT0bckbLlBpkwe21ZtNPXxS/AptttCDMMqcHoDahAo2ZfSRYXJK1GbH34+OhZ2
 +UDpJZ8yj7rScsyYC4mxeZJ/vnO5R8AoTwAtdSO51fnC9nZqAaeUvi/RCcsGzaRjGORveKBSbjI
 o3EVKqUGI7mpibuXjA6G71FQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 61d7ee7e5d4c238e;
	Fri, 04 Sep 2026 10:46:31 +0000
X-Mizu-Trace-ID: 61d7ee7e5d4c238e
X-Migadu-Flow: FLOW_OUT
Message-ID: <f17d5e16-cc0e-4dd1-90c4-c7583cdf5ee9@linux.dev>
Date: Fri, 4 Sep 2026 11:46:30 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 20/27] scsi-multipath: add
 scsi_mpath_{start,end}_request()
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-21-john.g.garry@oracle.com>
 <20260901112533.2BC161F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901112533.2BC161F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:25, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Bypassing `scsi_end_request()` on hard errors in `scsi_queue_rq()` permanently leaks multipath active counters and corrupts state for recycled blk-mq tags.
> --
> 
> commit d6985f792a0819a7b56a04e827a71ff5a8dd2172
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: add scsi_mpath_{start,end}_request()
> 
> This commit adds scsi_mpath_start_request() and scsi_mpath_end_request() to
> handle private multipath request data. It also introduces mpath_nr_active
> per SCSI host to track active requests for queue depth io-policies.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 189263ce56624..5916dead5422e 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
> [ ... ]
>> @@ -1918,6 +1921,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>>   	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
>>   
>> +	if (sdev->scsi_mpath_dev && is_mpath_request(req))
>> +		scsi_mpath_start_request(req);
>> +
>>   	blk_mq_start_request(req);
>>   	if (blk_mq_is_reserved_rq(req)) {
>>   		reason = shost->hostt->queue_reserved_command(shost, cmd);
> 
> [ ... ]
> 
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index 8ecfb94049db5..52227e2cd9749 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
> [ ... ]
>> @@ -58,8 +58,11 @@ struct scsi_pointer {
>>    */
>>   #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
>>   #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
>> +#define SCMD_MPATH_IO_STATS	(1 << 5)
>> +#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
>>   /* flags preserved across unprep / reprep */
>> -#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
>> +#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | \
>> +				SCMD_MPATH_IO_STATS | SCMD_MPATH_CNT_ACTIVE)
> 
> [Severity: High]
> Does preserving these multipath flags across requeue operations cause a leak
> of the mpath_nr_active counter and stale state for recycled tags?
> 
> If a multipath request is dispatched, it calls scsi_mpath_start_request()
> which increments the host's mpath_nr_active counter and sets these flags.
> 
> If this request is requeued (for example, if the host is busy) and then
> re-dispatched while the device is offline or entering recovery,
> scsi_device_state_check() in scsi_queue_rq() will fail early. This causes
> scsi_queue_rq() to return a hard error directly to the block layer.
> 
> Because the block layer completes the request natively on hard dispatch
> errors, it bypasses scsi_end_request(), leaving scsi_mpath_end_request()
> uncalled. The mpath_nr_active counter is leaked.

This seems like something which needs to be fixed in scsi midlayer

> 
> Furthermore, since SCMD_MPATH_IO_STATS and SCMD_MPATH_CNT_ACTIVE are
> preserved in SCMD_PRESERVED_FLAGS, any new request reusing this tag might
> inherit the stale flags, bypassing initialization in
> scsi_mpath_start_request().
> 
> Could there be a mechanism to clear these flags and decrement the counter
> when a requeued request encounters a hard failure during re-dispatch?
> 

