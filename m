Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBA341D65E
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783738; cv=none; b=hS6rncFQxYd1v6jKqllLSZsNmqFVBz6CNq7Z9VhFN+SYGHxkSW0TLFUfWAIrOULXFqblKIc9yc9RYOMGY+5jB6s0eAoMgzgL/QoNlBR7F16G2Gb9hmmno5bLmBm45nXF/htDQpiFL2SUeuRG5f5tvLnbpOEshWzoiZGHWfEIpEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783738; c=relaxed/simple;
	bh=5vkJI9zTlzzch+3lJHnixMQuUkwacMAayJAfA7pqKiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZ4UAuv4A5uSj7U72/uAGqOPi9H6AXMTleBBWhRWCoUcIL86aLJm1fosXfTZhyUFvsXWqUfGS+ZlEZNocSQd4+hlnCdsA+OnOj2U8cDlR2Qy4pBz3gHBnQLXKgsnxOKYuO4AdMrMziJ+AP4wRPwnnOltyOCjiOXyef8XpXOVRcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K1kuYhVM; arc=none smtp.client-ip=91.218.175.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K1kuYhVM"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5vkJI9zTlzzch+3lJHnixMQuUkwacMAayJAfA7pqKiI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788783733; v=1; x=1789388533;
 b=K1kuYhVMVjOKkUeWRlICIomBOmhGixvMtLU38S7VGw4EXBU5XCq6x+TIf/Y/ZrYZbjcFnb3/
 UDG3rsFP29Xv9H34rPFf72xR84aAJmBJYitpBuOotfF34H8C1/+20kfX0Hz6Ywtl5REQsshJ1D3
 sQLAEvrFJqgCjcJLI2yxeDpc=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id ba0837834e12b6c0;
	Mon, 07 Sep 2026 12:22:13 +0000
X-Mizu-Trace-ID: ba0837834e12b6c0
X-Migadu-Flow: FLOW_OUT
Message-ID: <ff023bb0-9bf1-4257-a1c5-46d2dedc3367@linux.dev>
Date: Mon, 7 Sep 2026 13:22:08 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 20/27] scsi-multipath: add
 scsi_mpath_{start,end}_request()
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-21-john.g.garry@oracle.com>
 <20260907120918.DC4D41F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907120918.DC4D41F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 13:09, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Leaked multipath active counter (`mpath_nr_active`) and corrupted IO stats when `scsi_queue_rq` returns a hard error or `blk_mq` cancels a requeued request.
> --
> 
> commit 2b78aa9717f460c8d3814043976386ee7f6864c3
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: add scsi_mpath_{start,end}_request()
> 
> This patch adds scsi_mpath_start_request() and scsi_mpath_end_request() to
> manage multipath request data. It also introduces mpath_nr_active to track
> the number of active requests per SCSI host.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 1a6f5e1fd80cb..193e7e9a2d30b 100644
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
> 
> [Severity: High]

Same response as v7 - I think that the SCSI core needs to be fixed here

> Can this leak the mpath_nr_active counter and corrupt IO stats if a request
> encounters a hard error after being requeued?
> 
> For example, if a request is dispatched and scsi_mpath_start_request()
> increments the counter and sets SCMD_MPATH_CNT_ACTIVE:
> 
> If the dispatch returns a non-fatal error (like BLK_STS_RESOURCE), the
> block layer requeues the request. The SCMD_MPATH_CNT_ACTIVE flag is
> preserved across the requeue via SCMD_PRESERVED_FLAGS.
> 
> On the next dispatch attempt, if the device goes offline,
> scsi_device_state_check() fails early, jumping to the error path in
> scsi_queue_rq():
> 
> 	out_put_budget:
> 	...
> 	default:
> 		if (unlikely(!scsi_device_online(sdev)))
> 			cmd->result = DID_NO_CONNECT << 16;
> 		...
> 		if (req->rq_flags & RQF_DONTPREP)
> 			scsi_mq_uninit_cmd(cmd);
> 
> scsi_queue_rq() then returns the hard error to the block layer, which
> completes the request directly, bypassing scsi_end_request() and
> scsi_mpath_end_request().
> 
> Since the counter and stats are never decremented, will this permanently
> skew the in-flight IO stats and eventually stall I/O when MPATH_IOPOLICY_QD
> is used?
> 
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index 8ecfb94049db5..52227e2cd9749 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
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
> Does adding these flags to SCMD_PRESERVED_FLAGS cause the issue mentioned
> above by masking the fact that the request already holds the mpath active
> counter when it comes back through scsi_queue_rq()?
> 

