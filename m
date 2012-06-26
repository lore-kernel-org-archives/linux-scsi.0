From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Tue, 26 Jun 2012 17:03:17 +0200
Message-ID: <4FE9CF35.5070407@suse.de>
References: <4FE8A9FC.6040805@acm.org> <4FE8AAB9.9060602@acm.org> <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com> <4FE95ADE.2080102@acm.org> <4FE97D2F.9070705@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab2FZPDV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jun 2012 11:03:21 -0400
In-Reply-To: <4FE97D2F.9070705@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 06/26/2012 11:13 AM, Mike Christie wrote:
> On 06/26/2012 01:46 AM, Bart Van Assche wrote:
>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>>>> index 6dfb978..c26ef49 100644
>>>>>> --- a/drivers/scsi/scsi_lib.c
>>>>>> +++ b/drivers/scsi/scsi_lib.c
>>>>>> @@ -406,10 +406,7 @@ static void scsi_run_queue(struct request_q=
ueue *q)
>>>>>>  	LIST_HEAD(starved_list);
>>>>>>  	unsigned long flags;
>>>>>> =20
>>>>>> -	/* if the device is dead, sdev will be NULL, so no queue to ru=
n */
>>>>>> -	if (!sdev)
>>>>>> -		return;
>>>>>> -
>>>>>> +	BUG_ON(!sdev);
>>>>
>>>> Needs to be a blk_queue_dead() check as well.
>>
>> Callers of scsi_run_queue() don't hold the queue lock. Does it make
>> sense to test whether the queue is dead without the queue lock being=
 held ?
>>
>=20
> I think there is still another bug in this path when it is called fro=
m
> the requeue path. If scsi_requeue_command requeues a command and that
> gets executed by some other thread before scsi_requeue_command calls
> scsi_run_queue then we could end up accessing freed memory.
>=20
> It looks possible some other thread is doing
> blk_cleanup_queue->blk_drain_queue and that calls blk_run_queue and t=
hat
> kills/fails the IO that scsi_requeue_command had queued. Then
> blk_cleanup_queue could complete and we could end up doing the last p=
ut
> on the device and freeing the queue and sdev before scsi_requeue_comm=
and
> can call scsi_run_queue. scsi_run_queue could then be accessing freed
> memory.
>=20
> I think we need a get/put:
>=20
> scsi_requeue_command....
>=20
> get_device(&sdev->sdev_gendev);
>=20
> spin_lock_irqsave(q->queue_lock, flags);
> scsi_unprep_request(req);
> blk_requeue_request(q, req);
> spin_unlock_irqrestore(q->queue_lock, flags);
>=20
> scsi_run_queue(q);
>=20
> put_device(&sdev->sdev_gendev);
>=20
> This will prevent some other path from freeing the queue/sdev from un=
der us.

<clapping hands>
Congrats, Mike.

This looks like the bug I have been hunting since nearly a year now.
(and which I've been pestering folks at the Storage Summit :-)

So yeah, definitely a good idea.
I'll give it a shout and see if it improves things.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
