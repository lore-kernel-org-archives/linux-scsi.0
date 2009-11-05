From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] fc class: fail fast bsg requests
Date: Thu, 05 Nov 2009 12:55:35 -0600
Message-ID: <4AF31FA7.3020602@cs.wisc.edu>
References: <1257441489-9055-1-git-send-email-michaelc@cs.wisc.edu> <4AF31BFA.1030305@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53335 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbZKESzh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2009 13:55:37 -0500
In-Reply-To: <4AF31BFA.1030305@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Smart wrote:
> Does this really do what you want ?  Don't you want something that 
> dequeues the request, and errors it out ?

The dequeue and fail happens just below the code in the patch:

                 req = blk_fetch_request(q);
                 if (!req)
                         break;

                 if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
                         req->errors = -ENXIO;
                         spin_unlock_irq(q->queue_lock);
                         blk_end_request(req, -ENXIO, blk_rq_bytes(req));
                         spin_lock_irq(q->queue_lock);

So for the patch if failfast is not set but the port is blocked we leave 
it in the queue. If the port is blocked and fail fast is set we fail the 
IO in the above code chunk.

> 
> The break from the look doesn't remove the request from the request 
> queue. It just stops servicing it.  Thus, we have the "goose" function 
> that kicks in if the rport comes back, and if it doesn't, the queue gets 
> removed (hmmm... now that I think about it - I'm not sure what happens 
> if the request queue has items on it and the device gets torn down. Are 
> we doing the right thing by references, etc?).

It looks like in that case requests get stuck in the queue and would 
never get freed.

> 
> So - to have what you want, I would think we need to add:
> - something that gooses the queue when fastfail io timeout expires
> - allows the requests to enter between fastfail io timeout and nodev
>   timeout and fails them.
> 
> It also says we aren't discriminating based on request type - e.g. any 
> bsg request fails back immediately after fastfail io timer. Nothing ever 
> waits until nodev tmo unless fastfail isn't configured.
> 
> Right ?
> 
> -- james s
> 
> 
> michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> If the port state is blocked and the fast io fail tmo has
>> fired then this patch will fail bsg requests immediately.
>> This is needed if userspace is sending IOs to test the transport
>> like with fcping, so it will not have to wait for the dev loss tmo.
>> With this patch he bsg req fast io fail code behaves like the normal
>> and sg io/passthrough fast io fail.
>>
>> Patch was made over scsi-rc-fixes. It is only compiled tested.
>> I found this while looking over the iscsi bsg patch.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: james.smart@emulex.com <james.smart@emulex.com>
>> ---
>>  drivers/scsi/scsi_transport_fc.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_fc.c 
>> b/drivers/scsi/scsi_transport_fc.c
>> index c6f70da..1004684 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -3769,8 +3769,9 @@ fc_bsg_request_handler(struct request_queue *q, 
>> struct Scsi_Host *shost,
>>          return;
>>  
>>      while (!blk_queue_plugged(q)) {
>> -        if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED))
>> -                break;
>> +        if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED) &&
>> +            !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
>> +            break;
>>  
>>          req = blk_fetch_request(q);
>>          if (!req)

