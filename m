From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: LSF: Multipathing and path checking question
Date: Mon, 20 Apr 2009 14:23:24 -0500
Message-ID: <49ECCBAC.70308@cs.wisc.edu>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de>
	<49E89866.50205@cs.wisc.edu> <49E89E92.7070709@cs.wisc.edu>
	<49EC3010.5050502@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49EC3010.5050502@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Hi Mike,
> 
> Mike Christie wrote:
>> Oops, I mashed two topics together. See below.
>>
>> Mike Christie wrote:
>>> Hannes Reinecke wrote:
>>>> FC Transport already maintains an attribute for the path state, and even
>>>> sends netlink events if and when this attribute changes. For iSCSI I
>>>> have
>>> Are you referring to fc_host_post_event? Is the same thing we talked
>>> about last year, where you wanted events? Is this in multipath tools
>>> now or just in the SLES ones?
>>>
>>> For something like FCH_EVT_LINKDOWN, are you going to fail the path at
>>> that time or when would the multipath path be marked failed?
>>>
>> I was asking this because it seems we have people always making
>> bugzillas saying they did not want the path to be marked failed for
>> short problems.
>>
>> There was the problem where we might get DID_ERROR for temporary dropped
>> frame. That would be fixed by just listening to transport events like
>> you explained.
>>
>> But then I thought there was the case where if we get a linkdown then
>> linkup within a couple seconds, we would not want to transition the
>> multipath path state.
>>
>> So below while you were talking about when to remove the device, I was
>> talking about when to mark the path failed.
>>
>>
> I have the same bugzillas, too :-)
> 
> My proposal is to handle this in several stages:
> 
> - path fails
> -> Send out netlink event
> -> start dev_loss_tmo and fast_fail_io timer
> -> fast_fail_io timer triggers: Abort all oustanding I/O with
>    DID_TRANSPORT_DISRUPTED, return DID_TRANSPORT_FAILFAST for
>    any future I/O, and send out netlink event.


This is almost done. The IOs are failed. There is not netlink event yet.



> -> dev_loss_tmo timer triggers: Remove sdev and cleanup rport.
>    netlink event is sent implicitely by removing the sdev.
> 
> Multipath would then interact with this sequence by:
> 
> - Upon receiving 'path failed' event: mark path as 'ghost' or 'blocked',
>   ie no I/O is currently possible and will be queued (no path switch yet).
> - Upon receiving 'fast_fail_io' event: switch paths and resubmit queued I/Os
> - Upon receiving 'path removed' event: remove path from internal structures,
>   update multipath maps etc.
> 
> The time between 'path failed' and 'fast_fail_io triggers' would then be
> able to capture any jitter / intermittent failures. Between 
> 'fast_fail_io triggers' and 'path removed' the path would be held in some
> sort of 'limbo' in case it comes back again, eg for maintenance/SP update
> etc. And we can even increase this one to rather long timespans (eg hours)
> to give the admin enough time for a manual intervention.
> 
> I still like this proposal as it makes multipath interaction far cleaner.
> And we can do away with path checkers completely here.
> 
>>> You got my hopes up for a solution in the the long explanation, then
>>> you destroyed them :)
>>>
>>>
>>> Was the reason people did not like this because of the scsi device
>>> lifetime issue?
>>>
>>>
>>> I think we still want someone to set the fast io fail tmo for users
>>> when multipath is being used, because we want IO out of the queues and
>>> drivers and sent to the multipath layer before dev_loss_tmo if
>>> dev_loss_tmo is still going to be a lot longer. fast io fail tmo is
>>> usually less than 10 or 5 and for dev_loss_tmo seems like we still
>>> have user setting that to minutes.
>>>
>>>
>>> Can't the transport layers just send two events?
>>> 1. On the initial link down when the port/session is blocked.
>>> 2. When there fast io fail tmos fire.
>>
>> So for #2, I just want a way to figure out when the transport is giving
>> up on executing IO and is going to fail everything. At that time, I was
>> thinking we want to mark the path failed.
>>
> See above. Exactly my proposal.
> 
>> I guess if multipiath tools is going to set fast io fail, it could also
>> use that as its down timer to decide when to fail the path and not have
>> to send SG IO or a bsg transport command.
>>
> But that's a bit of out-guessing the midlayer, no?


Yeah, agree. Just brain storming.



> We're instructing the midlayer to fail all I/O at one point; so it makes
> far more sense to me to have the midlayer telling us when this is going
> to happen instead of trying to figure this one out ourselves.
> 
> For starters we just should send a netlink event when fast_fail_io has
> fired. We could easily integrate that one in multipathd and would gain
> an instant benefit from that as we can switch paths in advance.
> Next step would be to implement an additional sdev state which would
> return 'DID_TRANSPORT_FASTFAIL' for any 'normal' I/O; it would be
> inserted between 'RUNNING' and 'CANCEL'.
> Transition would be possible between 'RUNNING' and 'FASTFAIL', but
> it would only be possible to transition into 'CANCEL' from 'FASTFAIL'.
> 


Yeah, a new sdev state might be nice. Right now this state is handled by 
the classes. For iscsi and FC the port/session will be in 
blocked/ISCSI_SESSION_FAILED. Then internally the classes are decieding 
what to do with IO in the *_chkready functions.




> Oh, and of course we have to persuade Eric Moore et al to implement
> fast_fail_io into mptfc ...

Yeah, last holdout not counting the the old qlogic driver.

But actually in the current code if you just set the fast io fail tmo, 
all IO in the block queues and any incoming IO will get failed. It is 
sort of a partial support. Even if you cannot kill IO in the driver 
because you do not have the terminate rport IO callback you can at least 
get the queues cleared, so that IO does not sit in there.
