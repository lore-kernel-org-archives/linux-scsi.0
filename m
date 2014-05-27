From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] Remove two cancel_delayed_work() calls from the error
 handler
Date: Tue, 27 May 2014 08:22:51 +0200
Message-ID: <53842F3B.5010106@suse.de>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org> <53842545.50502@suse.de> <53842BE7.5060304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaE0GXI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 02:23:08 -0400
In-Reply-To: <53842BE7.5060304@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

(Resending; mailer rejected it ...)

On 05/27/2014 08:08 AM, Bart Van Assche wrote:
> On 05/27/14 07:40, Hannes Reinecke wrote:
>> On 05/26/2014 05:14 PM, Bart Van Assche wrote:
>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>> index f17aa7a..5232583 100644
>>> --- a/drivers/scsi/scsi_error.c
>>> +++ b/drivers/scsi/scsi_error.c
>>> @@ -193,7 +193,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>>>            SCSI_LOG_ERROR_RECOVERY(3,
>>>                scmd_printk(KERN_INFO, scmd,
>>>                        "scmd %p previous abort failed\n", scmd));
>>> -        cancel_delayed_work(&scmd->abort_work);
>>> +        WARN_ON_ONCE(delayed_work_pending(&scmd->abort_work));
>>>            return FAILED;
>>>        }
>>>
>>>
>> The first bit is okay, the second isn't.
>>
>> The second bit is for these cases where the abort got scheduled (in
>> scsi_abort_command()), but the workqueue didn't get executed by the =
time
>> the next timeout occured.
>> I know, highly unlikely, but there is no safeguarding that it _canno=
t_
>> happen.
>> So the second cancel_delayed_work() has to stay.
>
> But how could that next timeout occur while abort_work is still pendi=
ng
> ? The block layer removes a request from the timeout list before
> invoking the timeout handler (see also blk_rq_check_expired()). This
> means that no block layer timers are active after abort_work has been
> scheduled and before scmd_eh_abort_handler() is called. This also mea=
ns
> that a second timeout can only occur after a SCSI command has been
> reinserted to a SCSI device queue. And such a reinsertion can only oc=
cur
> after scmd_eh_abort_handler() has started. The pending bit is cleared
> from a work struct before the associated handler is invoked. This is =
why
> I think the above cancel_delayed_work() statement is not necessary. O=
r
> did I perhaps overlook something ?
>
Hmm. Okay, convinced.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
