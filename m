From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Thu, 13 Apr 2006 11:14:36 -0400
Message-ID: <443E6ADC.8080206@emulex.com>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B2A79.4020600@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19883 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750835AbWDMPOx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 11:14:53 -0400
In-Reply-To: <443B2A79.4020600@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org



Mike Christie wrote:
>> - The plugged queue logic needs to be tracked down. Anyone have any
>>   insights ?
> 
> Are you referring to a problem in a function like our prep or request fn 
> where we could plug the queue if the device state is not online?

I believe so. One signature is that the scan i/o failed, starting recovery,
and right as recovery started, the sdev blocked, which caused recovery to
fail and sdev to be taken offline.

 > Do we
> need the scan mutex to change the device state? I mean if a scan has the 
> mutex lock, and the transport class decides to remove the device it 
> tries to grab the scan_mutex by calling scsi_remove_device, but if we 
> moved the state change invocation before the scan_mutex is taken in 
> scsi_remove_device then, I assume eventually the device should get 
> unplugged, the prep or request_fn will see the new state and fail the 
> request.

This may be what's needed. I don't understand all of this path yet, so I
can only speculate (and likely w/ error). Thus, the questions.

> I am also asking because if you change the state from userspace we do 
> not grab the scan_mutex so I did not know if that was bug.
> 
> 
>> - The scan mutex, as coarse as it is, is really broken. It would be
>>   great to reduce the lock holding so the lock isn't held while an
>>   i/o is pending.  This change would be extremely invasive to the scan
>>   code. Any other alternatives ?
>> - If an sdev is "blocked", we shouldn't be wasting our time scanning it.
>>   Should we be adding this checks before sending each scan i/o, or is
>>   there a better lower-level function place this check ? Should we be
> 
> are you referring to our request or prep fn or scsi_dispatch_cmd or 
> something else like when the scan code calls the scsi_execute?

Well, we want to stop the i/o before it gets on the request queue, thus it
should be in scsi_execute(). We tried modifying scsi_execute() to bounce
i/o's (w/ DID_NO_CONNECT) if the sdev was offline.  This made the deadlock
harder to hit, but didn't remove it. We'll probably be augmenting this
with a check for the blocked state as well.

Once the i/o is on the queue, we have to ensure the queues get run, and the
LLDD/transport will bounce the i/o. However, we would have liked to avoid
the delay while waiting on the queue to run.

> 
>>   creating an explicit return code, or continue to piggy-back on
>>   DID_NO_CONNECT ? How do we deal with a scan i/o which may already be
>>   queued when the device is blocked ?
> 
> Are you thinking about adding a abort/cancel_request() callback to the 
> request_queue? Something that could also be called by upper layers like 
> DM, and could eventually end up calling a scsi abort function?

Actually - yes, and I knew things like DM would have liked this. There's
2 states we have to be aware of though... 1st state is where the i/o is
queued, but not yet given to the LLDD (which I believe is the stall case
that is hurting us here). The 2nd case is where the i/o has been issued
to the LLDD, but the sdev blocked is not blocked when the abort is issued.
Unfortunately, since the block state implies a loss of connectivity, we
can't send the abort, so we have to sit and wait until the block times out.
No real way to avoid this delay.

Hope this makes sense.

-- james s

