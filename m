From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use list_splice for blk_abort_queue
Date: Fri, 27 Feb 2009 12:48:59 +0100
Message-ID: <49A7D32B.4020100@suse.de>
References: <20090227113706.3005518C786@pentland.suse.de> <20090227114057.GC6602@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:41754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZB0LtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 06:49:03 -0500
In-Reply-To: <20090227114057.GC6602@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Hi Jens,

Jens Axboe wrote:
> On Fri, Feb 27 2009, Hannes Reinecke wrote:
>> blk_abort_queue takes the queue_lock with spinlock_irqsave and walks
>> the timer_list with list_for_each_entry_safe. Since a path to a SCSI
>> device just failed, the rport state is FC_PORTSTATE_BLOCKED. This
>> rport state triggers blk_add_timer(), which in turn calls
>> list_add_tail() to move the request to the end of timer_list. Thus,
>> the list_for_each_XXX loop never reaches the end of the timer_list.
>> By using list_splice_init() we're breaking the loop and process only
>> the requests present on the timeout_list when blk_abort_queue() is
>> called.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Tested-by: Christof Schmitt <christof.schmitt@de.ibm.com>
>> ---
>>  block/blk-timeout.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/blk-timeout.c b/block/blk-timeout.c
>> index a095353..67bcc3f 100644
>> --- a/block/blk-timeout.c
>> +++ b/block/blk-timeout.c
>> @@ -209,12 +209,15 @@ void blk_abort_queue(struct request_queue *q)
>>  {
>>  	unsigned long flags;
>>  	struct request *rq, *tmp;
>> +	LIST_HEAD(list);
>> =20
>>  	spin_lock_irqsave(q->queue_lock, flags);
>> =20
>>  	elv_abort_queue(q);
>> =20
>> -	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list)
>> +	list_splice_init(&q->timeout_list, &list);
>> +
>> +	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
>>  		blk_abort_request(rq);
>> =20
>>  	spin_unlock_irqrestore(q->queue_lock, flags);
>> --=20
>> 1.5.3.2
>>
>=20
> Hannes, this fix has been in mainline for about 10 days.
>=20
Ah, sorry. Missed that one.
I'm just about to catch up with unread mails, and you said something
about 'the original author should resend the patch'.
Which I did.

Oh well, sorry for the noise.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
