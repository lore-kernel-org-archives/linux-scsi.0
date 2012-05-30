From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] Stop accepting SCSI requests before removing a device
Date: Wed, 30 May 2012 12:27:36 -0500
Message-ID: <4FC65888.3000907@cs.wisc.edu>
References: <4FA3EF10.3040104@acm.org> <4FA3F059.6020004@acm.org> <4FA43912.2060706@cs.wisc.edu> <4FA43C72.3000108@cs.wisc.edu> <4FA5255C.10803@acm.org> <4FC4E492.1000707@acm.org> <4FC508D2.7040606@cs.wisc.edu> <4FC5C488.4010307@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36953 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab2E3R2C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2012 13:28:02 -0400
In-Reply-To: <4FC5C488.4010307@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 05/30/2012 01:56 AM, Bart Van Assche wrote:
> On 05/29/12 17:35, Mike Christie wrote:
> 
>> On 05/29/2012 10:00 AM, Bart Van Assche wrote:
>>> The patch below makes sure that blk_drain_queue() and blk_cleanup_queue()
>>> wait until all queuecommand invocations have finished and hence fixes a
>>> race between the SCSI error handler and __scsi_remove_device(). Any feedback
>>> is welcome.
>>>
>>> ---
>>>  drivers/scsi/scsi_error.c |   14 +++++++++++++-
>>>  1 files changed, 13 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>> index 386f0c5..947f627 100644 
>>> --- a/drivers/scsi/scsi_error.c
>>> +++ b/drivers/scsi/scsi_error.c
>>> @@ -781,10 +781,17 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>>>  	struct scsi_device *sdev = scmd->device;
>>>  	struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>>>  	struct Scsi_Host *shost = sdev->host;
>>> +	struct request_queue *q = sdev->request_queue;
>>>  	DECLARE_COMPLETION_ONSTACK(done);
>>>  	unsigned long timeleft;
>>>  	struct scsi_eh_save ses;
>>> -	int rtn;
>>> +	int rtn = FAILED;
>>> +
>>> +	spin_lock_irq(q->queue_lock);
>>> +	if (blk_queue_dead(q))
>>> +		goto out_unlock;
>>> +	q->rq.count[BLK_RW_SYNC]++;
>>> +	spin_unlock_irq(q->queue_lock);
>>
>> Are you hitting a case where a scsi_cmnd does not have a request struct
>> that was allocated through the block layer functions like
>> blk_get_request, but is getting sent through this path? What code is
>> doing this?
>>
>> Or, are you hitting a bug where somehow the request is freed (so the
>> rq.count is decremented) but the scsi eh is still working on a scsi_cmnd
>> that had a request struct allocated for it?
>  
> 
> I haven't hit any such bugs. This patch is what I came up with after
> analyzing what would be necessary to make sure that queuecommand isn't
> called anymore after blk_cleanup_queue() finished and also to make sure
> that blk_drain_queue() waits until all active queuecommand calls have

It should be waiting now if the scsi_cmnd has a request backing
shouldn't it? We will allocate a request struct with blk_get_request or
one of the other blk helpers for each scsi_cmnd, and that will increment
the q->rq.count. If we then go down the error path because a cmd timed
out or because scsi_decide_disposition returned FAILED, then we will
still have that request backing the scsi cmnd and the count should still
be incremented for it. When we call scsi_send_eh_cmnd for eh operations
the request is then still there and not freed yet. The request will get
freed later when scsi_eh_flush_done_q is called. In there we will either
retry or call scsi_finish_command which will go through the normal
completion process and eventually call __blk_put_request and freed_request.
