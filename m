From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Mon, 06 Jan 2014 17:15:59 +0800
Message-ID: <52CA744F.2080609@intel.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaAFJPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jan 2014 04:15:45 -0500
In-Reply-To: <52CA5CF4.2080708@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>, Phillip Susi <psusi@ubuntu.com>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On 01/06/2014 03:36 PM, Sujit Reddy Thumma wrote:
> On 1/6/2014 7:44 AM, Phillip Susi wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA512
>>
>> On 12/16/2013 06:30 PM, Phillip Susi wrote:
>>> For some reason, the system hangs on resume if I issue the REQUEST
>>> SENSE command after blk_pre_runtime_suspend.  My understanding is
>>> that the REQ_PM flag should make the command process even though
>>> the queue is RPM_SUSPENDING, but it doesn't seem to work.  Anyone
>>> have any idea why?
>>
>> So I found the problem but I'm confused by it.  I thought that the
>> REQ_PM flag was supposed to make sure the request was dispatched even
>> though the device was still suspended ( or suspending ).  It seems

The blk_pm_peek_request will return NULL if the block queue is runtime
suspended.
The block queue will be transferred to runtime active state once there
is a normal request put into the suspended queue.
A suspended queue means there is no request left.

The REQ_PM flag is used to carry out some last commands for the underlying
device to get into or out of a low power state, and at that time, the
queue's status is either RPM_SUSPENDING or RPM_RESUMING.

My guess why it doesn't work for you is that, when you call
blk_pre_runtime_suspend in sd_resume_work, there are requests left in the
queue so that call will simply fail, it's not meant to be used that way.

It seems you are making use of runtime PM to speed up disk resume, if
that is the case, I think we can simply make sure the disk's block queue
is put into the same state as runtime suspended and then mark it as
runtime suspended during system suspend phase; on system resume, call
pm_request_resume for the device in its system resume callback should be
enough, or if you want to further delay it, just leave it as it is. Once
there is a new request comes in, it will be automatically runtime
resumed(actually, there are some user space tools accessing it during
system resume, so it will be resumed pretty soon after kernel thaw user
space process, unless you have made those app gone). It's simple and clean.
The only problem is, it depends on RUNTIME_PM, while Todd's implementation
doesn't.

>> that this is not the case, and only requests with the type set to
>> REQ_TYPE_PM_RESUME are dispatched during suspend/resume.  The
>> following patch fixes the hang, but I'm not sure why it is needed or
>> if it is generally appropriate:
>>
> 
> Adding Aaron Lu, author of block layer runtime PM.
> I have seen similar issue and fixed it by relaxing the rpm_status check
> to allow processing of requests while suspended -

I'm not sure what exactly the issue you have is, care to explain?

> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 6853ef6..f99165b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2140,8 +2140,7 @@ static void blk_account_io_done(struct request *req)
>   static struct request *blk_pm_peek_request(struct request_queue *q,
>   					   struct request *rq)
>   {
> -	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
> -	    (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM))))
> +	if (q->dev && q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM))

The queue is not supposed to get a REQ_PM request while it is in
RPM_SUSPENDED state, at least, this is the case when we first made this
function.

Thanks,
Aaron

>   		return NULL;
>   	else
>   		return rq;
> 
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 7bd7f0d..c5ce50d 100644
>> - --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -227,7 +227,9 @@ int scsi_execute(struct scsi_device *sdev, const
>> unsigned char *cmd,
>>          req->sense_len = 0;
>>          req->retries = retries;
>>          req->timeout = timeout;
>> - -       req->cmd_type = REQ_TYPE_BLOCK_PC;
>> +       if (flags & REQ_PM)
>> +               req->cmd_type = REQ_TYPE_PM_RESUME;
>> +       else req->cmd_type = REQ_TYPE_BLOCK_PC;
>>          req->cmd_flags |= flags | REQ_QUIET | REQ_PREEMPT;
>>
>>          /*
>>
>>
> 

