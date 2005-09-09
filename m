From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Thu, 08 Sep 2005 20:18:34 -0400
Message-ID: <4320D4DA.90004@adaptec.com>
References: <Pine.LNX.4.44L0.0509081441190.5768-100000@iolanthe.rowland.org> <1126210542.4845.66.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:659 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965084AbVIIASk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 20:18:40 -0400
In-Reply-To: <1126210542.4845.66.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On 09/08/05 16:15, James Bottomley wrote:
> On Thu, 2005-09-08 at 14:58 -0400, Alan Stern wrote:
> 
>>On Thu, 8 Sep 2005, James Bottomley wrote:
>>
>>>Actually, no, that's why we have the parallel EH states ... let me put
>>>in the events that trigger state transitions so you can see what
>>>happens:
>>>
>>>
>>>        EH thread finishes
>>>	<---------------
>>>
>>>        EH thread begins
>>>        ---------------->
>>>
>>>
>>>         <--------- 
>>>  running ---------> recovery
>>>    |                   |
>>>    |                   | scsi_remove_host() called
>>>    v   <----------     v
>>>  cancel ----------> recover/cancel
>>>    |                   |
>>>    |                   | scsi_remove_host finishes visibility removal
>>>    v                   v
>>>   del <------------ recover/del
>>>
>>>So the EH is allowed to activate in either running or cancel states, but
>>>goes through its own state transition eventually coming back to del when
>>>it finishes.  Once the EH gets into recover/cancel it can never
>>>transition back to running.
>>
>>Why allow cancel -> recover/cancel?  Once the device is in the cancel 
>>state, there isn't anything useful the error handler can accomplish, is 
>>there?  Failed or timed-out commands should simply return an error.
>>
>>And if you accept that, then what point is there in distinguishing between 
>>cancel and recover/cancel?  As far as I can see, the only significant 
>>difference is that in recover/cancel the error handler is running (but not 
>>accomplishing anything).  Is this related to 1) below?
> 
> 
> Yes, a state machine like I've shown can only be in one state at any
> given time.

And this is fine.

> The problem is what happens if the error handler is running
> when you try to remove the device.  We can reach in and try to stop it,
> but under a state model we'd have to wait until the error handler put
> the device back to running unless we allow a set of state transitions
> that the error handler can go through in parallel with the removal
> (which is the model I've shown above).

I'd suggest "waiting" until EH is done.  EH is just another user
of the SDS.  Thus if the device is physically removed, all tasks
fail and new ones are returned with failed delivery (the SDS tells
you this).

So one state at a time is the way to go.

In effect, a device remove _event_ is queued up, _after_ the
_recover_event_, and executed thereafter, when the state process
of _recover_event_ has finished and the state machine is ready
to transition.

	Luben


> The idea of allowing the error handler to start up in cancel is that not
> every device removal is a forced removal, so you want to permit the
> shutdown commands (like sync cache) and consequent error handling on
> those commands.
> 
> 
>>>It's just nasty on two counts:
>>>
>>>1) we have an incorrect bifurcation in the state model and
>>>2) we never actually enforce any of the state transitions.
>>
>>Can you explain 1) more fully?  I don't really understand what you're 
>>getting at.
> 
> 
> Does the explanation above cover this?
> 
> 
>>As for 2), what do you mean?  In 2.6.13, scsi_device_set_state does not 
>>change the state if the transition is illegal.
> 
> 
> Yes, but we never act on the return value.  if the state is illegal, we
> shouldn't be taking actions believing we're in that state, so we should
> always be checking the returns.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

