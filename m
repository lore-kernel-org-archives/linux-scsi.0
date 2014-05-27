From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/3] Remove two cancel_delayed_work() calls from the error
 handler
Date: Tue, 27 May 2014 08:08:39 +0200
Message-ID: <53842BE7.5060304@acm.org>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org> <53842545.50502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:37460 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaE0GIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 02:08:41 -0400
In-Reply-To: <53842545.50502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/27/14 07:40, Hannes Reinecke wrote:
> On 05/26/2014 05:14 PM, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index f17aa7a..5232583 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -193,7 +193,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>>           SCSI_LOG_ERROR_RECOVERY(3,
>>               scmd_printk(KERN_INFO, scmd,
>>                       "scmd %p previous abort failed\n", scmd));
>> -        cancel_delayed_work(&scmd->abort_work);
>> +        WARN_ON_ONCE(delayed_work_pending(&scmd->abort_work));
>>           return FAILED;
>>       }
>>
>>
> The first bit is okay, the second isn't.
> 
> The second bit is for these cases where the abort got scheduled (in
> scsi_abort_command()), but the workqueue didn't get executed by the time
> the next timeout occured.
> I know, highly unlikely, but there is no safeguarding that it _cannot_
> happen.
> So the second cancel_delayed_work() has to stay.

But how could that next timeout occur while abort_work is still pending
? The block layer removes a request from the timeout list before
invoking the timeout handler (see also blk_rq_check_expired()). This
means that no block layer timers are active after abort_work has been
scheduled and before scmd_eh_abort_handler() is called. This also means
that a second timeout can only occur after a SCSI command has been
reinserted to a SCSI device queue. And such a reinsertion can only occur
after scmd_eh_abort_handler() has started. The pending bit is cleared
from a work struct before the associated handler is invoked. This is why
I think the above cancel_delayed_work() statement is not necessary. Or
did I perhaps overlook something ?

Bart.

