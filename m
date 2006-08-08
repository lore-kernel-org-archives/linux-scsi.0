From: Michael Reed <mdr@sgi.com>
Subject: Re: [RFC] [Last Rites] fc transport: extensions for fast fail and
 dev loss
Date: Tue, 08 Aug 2006 16:56:08 -0500
Message-ID: <44D90878.7000903@sgi.com>
References: <1150829123.16981.1.camel@localhost.localdomain> <44D8CFD3.9050408@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:40903 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030261AbWHHV4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2006 17:56:11 -0400
In-Reply-To: <44D8CFD3.9050408@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi <linux-scsi@vger.kernel.org>



James Smart wrote:
> Closing Statements:
> 
> I've attached the original RFC below. See
>   http://marc.theaimsgroup.com/?l=linux-scsi&m=115082917628466&w=2
> 
> I've updated it with what I perceive to be the position and resolution
> based on comments.  Keep in mind that we're trying to lay the groundwork
> for common behavior and tunables between the transports.
> 
> Please let me know if I've mis-represented anything, or if there is
> a dissention in the resolution. I'd like to close on this.
> 
> James Smart wrote:
>> Folks,
>>
>> The following addresses some long standing todo items I've had in the
>> FC transport. They primarily arise when considering multipathing, or
>> trying to marry driver internal state to transport state. It is intended
>> that this same type of functionality would be usable in other transports
>> as well.
>>
>> Here's what is contained:
>>
>> - dev_loss_tmo LLDD callback :
>>   Currently, there is no notification to the LLDD of when the transport
>>   gives up on the device returning and starts to return DID_NO_CONNECT
>>   in the queuecommand helper function. This callback notifies the LLDD
>>   that the transport has now given up on the rport, thereby acknowledging
>>   the prior fc_remote_port_delete() call. The callback also expects the
>>   LLDD to initiate the termination of any outstanding i/o on the rport.
> 
> I believe there is no dissention on this change.
> Please note: this is essentially a confirmation from the transport to the
>   LLD that the rport is fully deleted. Thus, the LLD must expect to see
>   these callbacks as a normal part of the rport being terminated (even if
>   it is not blocked).
> 
> I'll move forward with this.

Concur.

> 
>>
>> - fast_io_fail_tmo and LLD callback:
>>   There are some cases where it may take a long while to truly determine
>>   device loss, but the system is in a multipathing configuration that if
>>   the i/o was failed quickly (faster than dev_loss_tmo), it could be
>>   redirected to a different path and completed sooner (assuming the  
>> multipath thing knew that the sdev was blocked).
>>     iSCSI is one of the transports that may vary dev_loss_tmo values
>>   per session, and you would like fast io failure.
> 
> 
> The current transport implementation did not specify what happened to
>   active i/o (given to the driver, in the adapter, but not yet completed
>   back to the midlayer) when a device was blocked, nor during the
>   block-to->dev_loss transition period. It was up to the driver.  Many
>   assumed active i/o was immediately terminated, which is semi-consistent
>   with the behavior of most drivers for most "connectivity loss" scenarios.
> 
> The conversations then started to jump around, considering what i/o's you
>   may want to have fail quickly, etc.
> 
> Here's my opinion:
>   We have the following points in time to look at:
>    (a) the device is blocked by the transport
>    (b) there is a time T, usually in a multipathing environment, where it
>        would be useful to error the i/o early rather than wait for dev_loss
>        It is assumed that any such i/o request would be marked REQ_FASTFAIL
>    (c) the dev_loss_tmo fires - we're to assume the device is gone
>   and at any time post (a), the device may return, unblock and never
>   encounter points (b) and (c).

REQ_FAILFAST is stored in the request structure.  Are there "issues"
with using scsi_cmnd.request in the lldd?

> 
>   As for what happens to active i/o :
> 
>   always: the driver can fail an i/o at any point in time if it deems
>           it appropriate.
> 
>   at (a): There are scenarios where a short link perturbation may occur,
>           which may not disrupt the i/o. Therefore, we should not force
>           io to be terminated.
> 
>   at (b): Minimally, we should terminate all active i/o requests marked
>           as type REQ_FASTFAIL. From an api perspective, driver support
>           for this is optional. And we must also assume that there will
>           be implementations which have to abort all i/o in order to
>           terminate those marked REQ_FASTFAIL. Is this acceptable ?
>           (it meets the "always" condition above)
> 
>           Q: so far we've limited the io to those w/ REQ_FASTFAIL.
>             Would we ever want to allow a user to fast fail all i/o
>             regardless of the request flags ? (in case they flags
>             weren't getting set on all the i/o the user wanted to
>             see fail ?)

REQ_FAILFAST appears to influence retries during error recovery so
there may be unexpected side effects of doing this.  But, that said,
I'd say yes.  From my perspective, I'd make this the default behavior.

In talking with our volume manager people, the question raised was
"Why would you want some i/o to fail quickly and some not?"
They even considered non-i/o scsi commands.

I think that if the default behavior is to have fast_io_fail_tmo
enabled, then it should be controlled by REQ_FAILFAST in the
request.  If the default is to have the timer disabled, i.e.,
an admin has to enable it (or define when it's enabled) then
when enabled it should apply to every i/o.  In examining the
patch, it appears to be disabled by default, so our conclusion
is that all i/o should fast fail when enabled.  We also concur
with having fast_io_fail_tmo disabled by default.

I guess this implies leave REQ_FAILFAST to error recovery.  :)

Mike



> 
>           There's a desire to address pending i/o (those on the block
>           request queue or new requests going there) so that if we've
>           crossed point (b) that we also fail them.  The proposal is
>           to add a new state (device ? or queue ?), which would occur
>           as of point (b). All REQ_FASTFAIL io on the queue, as well
>           as on a new io, will be failed with a new i/o status if in
>           this state. Non-REQ_FASTFAIL i/o would continue to enter/sit
>           on the request queue until dev_loss_tmo fires.
> 
>   at (c): per the dev_loss_tmo callback, all i/o should be terminated.
>           Their completions do not have to be synchronous to the return
>           from the callback - they can occur afterward.
> 
> 
> Comments ?
> 
> Assuming that folks agree, I'd like to do this in 2 patches:
>  - one that puts in the transport fast_io_fail_tmo and LLD callback
>  - another that adds the new state, io completion status, and does the
>    handling of the request queue REQ_FASTFAIL i/o.
> 
>>
>> - fast_loss_time recommendation:
>>   In discussing how a admin should set dev_loss_tmo in a multipathing
>>   environment, it became apparent that we expected the admin to know
>>   a lot. They had to know the transport type, what the minimum setting
>>   can be that still survives normal link bouncing, and they may even
>>   have to know about device specifics.  For iSCSI, the proper loss time
>>   may vary widely from session to session.
>>
>>   This attribute is an exported "recommendation" by the LLDD and
>> transport
>>   on what the lowest setting for dev_loss_tmo should be for a
>> multipathing
>>   environment. Thus, the admin only needs to cat this attribute to obtain
>>   the value to echo into dev_loss_tmo.
> 
> The only objection was from Christoph - wanting a utility to get/set this
> stuff. However, the counter was this attribute was still meaningful, as it
> was the conduit to obtain a recommendation from the transport/LLD.
> 
> So - I assume this proceeds as is - with a change in it's description.
> 
>>  
>> I have one criticism of these changes. The callbacks are calling into
>> the LLDD with an rport post the driver's rport_delete call. What it means
>> is that we are essentially extending the lifetime of an rport until the
>> dev_loss_tmo call occurs.
> 
> It's ok - and adding the appropriate comments are fine.
> 
> 
> Thanks.
> 
> -- james s
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
