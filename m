Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D523A5625E3
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788972587; cv=none; b=AqTqTTVQMb/xoaKRdA0TgXfy+qK+aDE4H3gNSuXjyF4QBpFxcUukYu5VAHo5A/aODioJK7Z20lpjIXne0hfWMAtT/E4fSHGibKyZi6uc0DTVBdb0Dj7PrXL6fcEqO2vxzSfZD/+oOo+p5gDjfoXvlcLDMJpF1ByUY3W6lLXI7KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788972587; c=relaxed/simple;
	bh=SRopwMnTeSH33A34bOFlRWWNcUENYIPPjh16jFtatys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rmoiZhv+fvnAFlB1nl5Hnr4UmnL2pRE2zSwMY7oHQbihVIs04RNzfXNE9R15nw1/4kHz/dAKOjoMmdrS+jSjnOBgjAGdooimHlXzhRppNj77ubUxeqODyZJqijA8z7oq+rqxznmB8k34rVp/yGOMUK+EU7FqoDMO1ATeAXbSICM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t+zYHYjk; arc=none smtp.client-ip=91.218.175.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t+zYHYjk"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SRopwMnTeSH33A34bOFlRWWNcUENYIPPjh16jFtatys=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788972580; v=1; x=1789577380;
 b=t+zYHYjk+4w2fcTlQJcoWWUeeSyxe9/umOnRxIq3lqEBWQyJ2NoWGr/N6wTTGHN3qo+Y2b1J
 W5oBP1WynBOQUiGLzyzs1Va/FaWnfUZAYL0kPDdb8NjlX2wFaDQ1hF366g7F48gU9Hfhe46uJnJ
 OJ8puV5kNkUopMhnibT0zDZ8=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 18d23cf7e17806cc;
	Wed, 09 Sep 2026 16:49:30 +0000
X-Mizu-Trace-ID: 18d23cf7e17806cc
X-Migadu-Flow: FLOW_OUT
Message-ID: <60306ea1-f186-4f63-b29b-aebdc0433945@linux.dev>
Date: Wed, 9 Sep 2026 17:49:23 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] scsi: core: Clear cmd->flags for terminal queuing
 error
To: Bart Van Assche <bvanassche@acm.org>,
 James.Bottomley@HansenPartnership.com, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, hare@suse.de
References: <20260908120841.185742-1-john.garry@linux.dev>
 <c46f6c74-2aa0-4aad-a234-7ff4ba367bdb@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <c46f6c74-2aa0-4aad-a234-7ff4ba367bdb@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/9/26 17:32, Bart Van Assche wrote:
> On 9/8/26 5:08 AM, John Garry wrote:
>> If a request can't be queued in scsi_queue_rq(), then we error out with
>> a blk_status_t code. Such a scenario may be the scsi_device has its
>> transport offline.
>>
>> For BLK_STS_RESOURCE or BLK_STS_AGAIN, the request will be requeued in 
>> the
>> block layer. For other errors, the block layer ends the request and so
>> we won't see it again (until recycled).
>>
>> Normally when a request completes scmd->flags is cleared in
>> scsi_end_request().
>>
>> However for the error scenario mentioned above, scsi_end_request() is
>> not called and so scmd->flags is not cleared. As such, when the request
>> is recycled we see the old value in scmd->flags.
>>
>> Fix this issue by clearing scmd->flags in the error scenario mentioned.
>>
>> Signed-off-by: John Garry <john.garry@linux.dev>
>> ---
>> Setting as an RFC as I am not 100% sure that this is correct as there are
>> lots of paths involved. Sashiko pointed out a related issue in
>> https://lore.kernel.org/linux- 
>> scsi/20260729161243.C918D1F00A3A@smtp.kernel.org/,
>> but blk_mq_cleanup_rq() -> scsi_cleanup_rq() -> cmd->flags = 0 is only
>> called for by DM code.
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index af27fd3df8d4..295f8b4afaa7 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1967,6 +1967,7 @@ static blk_status_t scsi_queue_rq(struct 
>> blk_mq_hw_ctx *hctx,
>>            */
>>           if (req->rq_flags & RQF_DONTPREP)
>>               scsi_mq_uninit_cmd(cmd);
>> +        cmd->flags = 0;
>>           scsi_run_queue_async(sdev);
>>           break;
>>       }
> 
> Is there agreement that all block drivers are affected that define a
> .cleanup_rq() callback? 

That is only SCSI (which is affected) and SCSI does define that (callback).

> Would this be a valid alternative (untested)?

Yes, logically this looks the same. However does scsi_cleanup_rq() need 
the unsetting of RQF_DONTPREP at ***, below. I suppose that it is not 
doing any harm if the req is going to end.

static void scsi_cleanup_rq(struct request *rq)
{
	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);

	cmd->flags = 0;

	if (rq->rq_flags & RQF_DONTPREP) {
		scsi_mq_uninit_cmd(cmd);
		rq->rq_flags &= ~RQF_DONTPREP; ***
	}
}

> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index a26a11c73ee3..0be933e26d67 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2126,6 +2126,12 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx 
> *hctx, struct list_head *list,
>               blk_mq_handle_dev_resource(rq, list);
>               goto out;
>           default:
> +            /*
> +             * Make sure to release all allocated resources when
> +             * we hit an error, as we will never see this command
> +             * again.
> +             */
> +            blk_mq_cleanup_rq(rq);
>               blk_mq_end_request(rq, ret);
>           }
>       } while (!list_empty(list));
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 48aab0df30b7..636854bffd1e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1960,13 +1960,6 @@ static blk_status_t scsi_queue_rq(struct 
> blk_mq_hw_ctx *hctx,
>               cmd->result = DID_NO_CONNECT << 16;
>           else
>               cmd->result = DID_ERROR << 16;
> -        /*
> -         * Make sure to release all allocated resources when
> -         * we hit an error, as we will never see this command
> -         * again.
> -         */
> -        if (req->rq_flags & RQF_DONTPREP)
> -            scsi_mq_uninit_cmd(cmd);
>           scsi_run_queue_async(sdev);
>           break;
>       }
> 

cheers,
John

