From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Mon, 24 Nov 2008 16:03:01 -0500
Message-ID: <492B1685.4020709@emulex.com>
References: <1227043498.4949.21.camel@ogier> <C49C4ADF-8DA1-4D86-AEBB-AC46A04FCA62@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50130 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYKXVCL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2008 16:02:11 -0500
In-Reply-To: <C49C4ADF-8DA1-4D86-AEBB-AC46A04FCA62@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>



Seokmann Ju wrote:
> A couple of questions.
> 1. Should 'loopback' considered at this time?

:)

This is a topic for the transport generically, independent of any 
pass-thru thing.

> 2. Would  it be valuable to consider sending requests with
>     WWNN:WWPN?

I considered this, especially for the fchost ELS request. But it means 
the LLDD has to do a nameserver query to find the n_port_id
corresponding to the names before it sent the ELS. It started to feel
like too much ancillary stuff for the LLDD to do to support the
request - so I punted.  However, the app, where we typically don't
care if it has to do more work, is free to do this and resolve it to
the basic primitives. :)

>> +/**
>> + * fc_bsg_job_timeout - handler for when a bsg request timesout
>> + * @req:     request that timed out
>> + */
>> +static enum blk_eh_timer_return
>> +fc_bsg_job_timeout(struct request *req)
>> +{
>> +     struct fc_bsg_job *job = (void *) req->special;
>> +     struct Scsi_Host *shost = job->shost;
>> +     struct fc_internal *i = to_fc_internal(shost->transportt);
>> +     unsigned long flags;
>> +     int err = 0, done = 0;
>> +
>> +     if (job->rport && job->rport->port_state == FC_PORTSTATE_BLOCKED)
>> +             return BLK_EH_RESET_TIMER;
>> +
>> +     spin_lock_irqsave(&job->job_lock, flags);
>> +     if (job->state_flags & FC_RQST_STATE_DONE)
>> +             done = 1;
>> +     else
>> +             job->ref_cnt++;
> Any reason to increase ref_cnt here?
> I think that the ref_cnt is already 1 when it came here so that we don't
> want to change it to destroy the job successfully.

Yes - I'm taking an additional reference on the job, so that if the
completion routine is completing in parallel to the timeout code path,
it won't free the job out from under the timeout call that calls back
into the LLDD.


>> +/**
>> + * fc_bsg_request_handler - generic handler for bsg requests
>> + * @q:               request queue to manage
>> + * @shost:   Scsi_Host related to the bsg object
>> + * @rport:   FC remote port related to the bsg object (optional)
>> + * @dev:     device structure for bsg object
>> + */
>> +static void
>> +fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host
>> *shost,
>> +                    struct fc_rport *rport, struct device *dev)
>> +{
>> +     struct request *req;
>> +     struct fc_bsg_job *job;
>> +     enum fc_dispatch_result ret;
>> +
>> +     if (!get_device(dev))
>> +             return;
>> +
>> +     while (!blk_queue_plugged(q)) {
>> +             req = elv_next_request(q);
>> +             if (!req)
>> +                     break;
>> +
>> +             if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED))
>> +                             break;
> Shouldn't this be moved to into fc_bsg_rport_dispatch()?

I had originally done this, but moved it back to this location.

Why ?  if I moved this out, I also had to move out the code between this
and the call to fc_bsg_rport_dispatch() too.  This was just a code
organization choice so I could keep the calls to allocate the job, etc
within this one routine. It also created a nice division on which
code-path-on-error had to be dealt with when it fails.  Now, this
generic routine is the only one that would call blk_complete_request()
or leave the request queued, while the rport/fchost dispatch functions
*always* call the fc_bsg_jobdone() function - on error or completion.

>> +
>> +             spin_unlock_irq(q->queue_lock);
>> +
>> +             ret = fc_req_to_bsgjob(shost, rport, req);
>> +             if (ret) {
>> +                     req->errors = ret;
>> +                     spin_lock_irq(q->queue_lock);
>> +                     blk_complete_request(req);
> Shouldn't this be blk_end_bidi_request()/blk_end_request()?

A good question, that I was hoping to have cleared up. If this was true, 
there were a lot of errors in the last passthru code.

If I remember right - I looked at what was also happening within scsi,
and it sure appeared as if blk_complete_request() will handle the dual
condition fine.

-- james s
