From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/5] SCSI EH cleanup
Date: Thu, 23 Feb 2017 08:27:26 +0100
Message-ID: <99107fe7-c21a-6416-3748-f9497d6ceb60@suse.de>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
 <1D08B61A9CF0974AA09887BE32D889DA0ADA73@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47208 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdBWH2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 02:28:45 -0500
In-Reply-To: <1D08B61A9CF0974AA09887BE32D889DA0ADA73@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/22/2017 08:44 PM, Bart Van Assche wrote:
> On 02/22/2017 08:07 AM, Hannes Reinecke wrote:
>> this is a resend of a small patchset for cleaning up SCSI EH.
>> Primary goal is to make asynchronous aborts mandatory; there hasn't
>> been a single report so far where asynchronous abort won't work, so
>> the 'no_async_abort' flag has never been used and will be removed
>> with this patchset.
>> Additionally there's a cleanup for handle failed EH commands, and
>> to detect retries of failed commands.
>>
>> As usual, comments and reviews are welcome.
> 
> Hello Hannes,
> 
> Supporting asynchronous aborts means that if no response is received for
> an abort after a certain time that the abort has to be considered as
> failed. A SCSI LLD may have to allocate resources before a TMF can be
> sent (e.g. ib_srp has to do that). These resources have to be cleaned up
> if a TMF times out. We don't want to see a TMF timeout handler in every
> LLD that supports asynchronous aborts. So we need a TMF timeout handler
> in the SCSI core. Have you considered to allocate a new SCSI request for
> submitting a TMF instead of overwriting fields in an existing scsi_cmnd
> structure? In that case we will be able to reuse the block layer timeout
> handler.
> 
TMF timeout is a completely different issue, and isn't touched at all by
this patchset.

ATM the SCSI core expects any of the eh_XXX callback functions to be
synchronous, ie any TMF timeout handling is delegated to the driver.

I plan to change that for the eh_abort() call, as most HBAs will be
receiving a completion for both commands, the TMF and the associated
command. So for these drivers there is not point in assuming a
synchronous call; we can easily make this call asynchronous and wait for
the completion to deliver the final status.
And indeed have a generic TMF timeout handling in the SCSI core.

And yes, I have considered allocating a separate command for TMFs.
In fact, I'll be looking at implementing a RQF_RESET meta request (much
like the RQF_FLUSH request we already have).
That would neatly solve the problem sg_reset has nowadays (namely that
it doesn't have a SCSI command attached to it), and it would also
decouple the failed command from the error handling itself.
With that we could return the command to the block layer even when EH is
still running, giving us better failover response times.

> Something else I noticed is that the access of .eh_action in
> scsi_eh_done() races with the shost->eh_action = NULL assigment in
> scsi_send_eh_cmnd(). Shouldn't these accesses be protected by locking?
> 
No, I don't think so.
The only place where this can race is once wait_for_completion_timeout()
has timed out.
There indeed is a chance that scsi_eh_done() is called just before
shost->eh_action = NULL.
But then this is not really critical as the 'done' structure itself is
still valid until scsi_send_eh_cmnd() itself is finished.
And calling 'complete' at any time before that will just be a no-op as
the waiting is already terminated.

One _might_ consider a really fucked-up architecture where the assignment
	eh_action = scmd->device->host->eh_action;
is executed before 'shost->eh_action = NULL', but the final
	complete(eh_action)
is executed after the entire scsi_send_eh_cmnd() function has completed.
So from that point we should be issuing a 'wmb' or somesuch after
shost->eh_action = NULL.
However, I do consider this highly unlikely.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
