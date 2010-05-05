From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/9] blk: Do not abort requests if queue is stopped
Date: Wed, 05 May 2010 13:13:47 -0500
Message-ID: <4BE1B55B.9090007@cs.wisc.edu>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com> <1272944228-30511-2-git-send-email-andmike@linux.vnet.ibm.com> <20100504104537.GN27497@kernel.dk> <20100505045231.GA25395@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35717 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab0EESNR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 14:13:17 -0400
In-Reply-To: <20100505045231.GA25395@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

On 05/04/2010 11:52 PM, Mike Anderson wrote:
> Jens Axboe<jens.axboe@oracle.com>  wrote:
>> On Mon, May 03 2010, Mike Anderson wrote:
>>> If the queue is stopped it could be an indication that other recovery is
>>> happening in this case skip the blk_abort_request.
>>>
>>> Signed-off-by: Mike Anderson<andmike@linux.vnet.ibm.com>
>>> Cc: Jens Axobe<jens.axboe@oracle.com>
>>> ---
>>>   block/blk-timeout.c |    3 ++-
>>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/block/blk-timeout.c b/block/blk-timeout.c
>>> index 1ba7e0a..89fbe0a 100644
>>> --- a/block/blk-timeout.c
>>> +++ b/block/blk-timeout.c
>>> @@ -224,7 +224,8 @@ void blk_abort_queue(struct request_queue *q)
>>>   	list_splice_init(&q->timeout_list,&list);
>>>
>>>   	list_for_each_entry_safe(rq, tmp,&list, timeout_list)
>>> -		blk_abort_request(rq);
>>> +		if (!blk_queue_stopped(q))
>>> +			blk_abort_request(rq);
>>>
>>>   	/*
>>>   	 * Occasionally, blk_abort_request() will return without
>>
>> That seems like a bit of a mixup, what ties a stopped queue to recovery?
>
> This was coding to SCSI behavior again. I tried to reduce the case of
> waking the eh if the transport moved the target into a blocked state. It
> might be redundant as FC has eh blocking and timer_reset. iSCSI has
> blocking but not eh blocking.

All iscsi drivers should have blocking and timer reset now, so if a 
transport problem casues a IO error to be sent to dm, then when 
blk_abort_request is called that should prevent the scsi layer from 
sending the whole host into recovery.


I do not remember the problem with the lack of eh blocking though. Did 
we need that too?
