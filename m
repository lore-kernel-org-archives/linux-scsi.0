From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/6] mpt fusion - fibre channel target discovery prematurely
 terminates
Date: Wed, 24 May 2006 13:48:19 -0500
Message-ID: <4474AA73.900@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D7011BBF2@NAMAIL4.ad.lsil.com> <447205A7.2020600@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:52622 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932457AbWEXSsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 May 2006 14:48:25 -0400
In-Reply-To: <447205A7.2020600@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

I've done some investigation into WHY mpt_config() is returning EAGAIN
during my board reset testing.  It's not because there are no message
frames, it is because mpt_get_msg_frame() is checking ioc->active and
finding it zero.  ioc->active is set to zero in mpt_do_ioc_recovery()
and it remains zero until the board reset is complete.  This takes
some time.

With this new understanding, I've tested an alternate bit of code.
The fc routine in question examines ioc->active, and if zero, it exits.
The existing code in the driver already reschedules the work once
the ioc becomes active.  So, I can get rid of the sleep.  (Yeah.)

Thank you for making me re-examine this issue.  A better fix was
^^^^^^^^^
available.

I'll repost the patches later today.

Mike



Michael Reed wrote:
> 
> Moore, Eric wrote:
>> On Monday, May 22, 2006 12:06 PM,  Michael Reed wrote:
>>> Changing mpt_config() to sleep changes the behavior in that 
>>> EAGAIN might no longer
>>> be returned.  lan, ctl, sas, spi, and fc all make use of 
>>> mpt_config().  This may be
>>> non-trivial with regard to testing.  Or it may not.  And, as 
>>> James points out,
>>> we have to assure that the caller is in a context which can sleep.
>>>
>> The caller context of mpt_config() *MUST* be able to sleep.   
>> Towards this end of this function we call wait_event().  This is
>> because we are waiting on the firmware reply.  If the fw reply
>> doesn't come, then watchdog timer kicks in, then mpt_timer_expired 
>> is called.
>>
>>
>>> Can we leave the interface alone for the moment and accept the patch
>>> as written?  Then, look at changing mpt_config() and the evaluate the
>>> testing burden that the change might impose?
>>>
>> James?
>>
>>> My vested interest is in getting the functionality into certain
>>> distros of interest.  I have no problem with rearchitecting the
>>> patchset as described above.  I'm just concerned with the timing.
>>> I suspect that the testing required will push the patch's acceptance
>>> beyond my potential window of opportunity.  As written, the change
>>> is confined to fibre channel so will not potentially introduce
>>> regressions into the other drivers.
>>>
>> How?
>>
>> I doubt there would be regressions.  We would need to implement timeout
>> on not receiving a mf, then return EAGAIN as we do today.
> 
> Then is there a reason to implement the change at all?  If the caller
> can still receive EAGAIN, the caller still has to handle it.
> Or just view it as an opaque error as callers do today.
> 
> Mike
> 
>> Eric 
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
