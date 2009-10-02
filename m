From: James Smart <James.Smart@Emulex.Com>
Subject: Re: qla2xxx: Conditionally disable automatic queue full tracking
Date: Fri, 2 Oct 2009 13:17:48 -0400
Message-ID: <4AC635BC.5060305@emulex.com>
References: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com> <4ABB8572.5050902@sgi.com> <67E59C8B-0E12-44EA-983C-38634993DF5A@qlogic.com> <4ABBC53F.9090203@sgi.com> <3E1B3796-029F-4DBE-A414-0358AB257E93@qlogic.com> <4ABBDE68.2020903@sgi.com> <ABA38BF9-3910-45E9-8C2B-C860FD862D59@qlogic.com> <4AC3A21F.8070705@cs.wisc.edu> <4AC546F8.7060507@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45310 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbZJBRR5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 13:17:57 -0400
In-Reply-To: <4AC546F8.7060507@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Giridhar Malavali <giridhar.malavali@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, LinuxSCSI <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "vasu.dev@intel.com" <vasu.dev@intel.com>, Jeremy Higdon <jeremy@sgi.com>



Michael Reed wrote:
> Mike Christie wrote:
>   
>> On 09/29/2009 08:34 PM, Giridhar Malavali wrote:
>>     
>>> 3) From your previous mail, I understand that you don't require a
>>> combined limit per target. Say the total queue depth for all LUN's on a
>>> particular target should not exceed some threshold.
>>>
>>>       
>> James Smart had done this patch
>> http://marc.info/?l=linux-scsi&m=121070114018354&w=2
>> where it sets the starget->can_queue based on info we get from vendors. 
>> The patch did not get merged. JamesB does not want the 
>> starget->can_queue to be static, and wants code like the queue full 
>> tracking code which dynamically ramps the device queue depth up and down.
>>     
>
> Agree.  Some amount of dynamic management of queue full seems desirable.
> I believe any such dynamic management needs to acknowledge that it
> exists in a multi-initiator environment, i.e., might get a QUEUE_FULL
> with no other commands outstanding.
>
>   
Completely agree - but there are multiple levels to the problem, many of 
which are at odds with each other....

>> I am not sure if JamesB meant that he wants to ramp down the 
>> starget->can_queue based on getting a QEUEU_FULL though. I thought he 
>> just meant he wants it to be dynamic. 
>>     
>
> What does "be dynamic" mean if not adjusted based upon a target's
> response to scsi commands?
>
>   
>> If I am right, then I think we 
>> could use JamesS's patch to set an initial starget->can_queue and add 
>> another field for a max value. Then we could add some code that ramps 
>> down/up based on something like command completion time or throughput or 
>> some other value.
>>     
>
>   
The desire of my patch was to aid single-initiator cases where multiple 
luns share the target, and there is a per-target resource limit, such as 
a maximum number of commands per target port.  Thus, the can_queue caps 
the number of commands allowed to be issued to the target.

In single-initiator, it would effectively stops QUEUE_FULLS from the 
target, aiding two issues:
- If the lun queue levels overcommit the target, I have seen targets 
that are so busy just handling the receive of the cmd frames, that they 
don't have enough cycles to send QUEUE_FULLS back, or punt and drop 
commands on the floor, or in the worse case, are so consumed they stop 
work on everything, including i/o they had already received. Note: these 
behaviors play havoc on any backoff algorithm dependent upon target 
response.  The OEMs try to solve this by providing configuration 
formulas. However, these have so many variables they are very complex to 
do right, and inexperienced admins may not know the formulas at all.  If 
we cap the outstanding i/o count, we never overcommit, and never see 
these headaches.
- Assuming that backoff algorithms are done per-lun, and if per-lun 
queue levels drop to outstanding loads and slowly ramp back up - there's 
an implicit biasing that takes place toward the luns that already have 
i/o outstanding or have yet to send i/o - meaning their queue levels are 
higher than the lun that saw the QUEUE_FULL. As they have more credit to 
submit i/o they may always consume more of the target than the 
backed-off lun, never allow it to get back to a level playing field.  If 
we avoid the QUEUE_FULLS to begin with, this biasing is lessened  (but 
not removed as it moves it back into the io scheduling area, which we 
always have).

In multi-initiator, it really doesn't change the problem, but it will 
lessen the degree to which an over-committed target is overwhelmed, 
which has to be goodness. Especially in cases where the target behaves 
like I described above.

My intent is that the cap per-target is static.  It would be initialized 
from the device record at device detection. I have no problem allowing a 
sysfs parameter to change it's value.  However, I do not believe we want 
a ramp-up/ramp-down on this value.

My ideas for the queuing algorithms is that we would have several 
selectable policies - on both the target and lun. If we did do a 
target-based ramp-up/ramp-down, I would have the device record value I 
added be the "max" (and max can be unlimited), and when the algorithm 
was selected, have the initial value (if necessary) and ramp up/down 
parameters specified.

> We don't necessarily need or want can_queue set by a value encoded into
> a kernel table.  Some of our raid devices' can_queue values vary based
> upon the firmware they are running.  A static table would, at best, be a
> decent starting point.  At worst, it could dramatically over-commit the
> target.  Our raid devices' max can_queue is either per raid controller
> or per host port.
>
> Whatever path we go down, I view having a user programmable upper bound
> as a requirement.
>
>   
Agree. If your device behaves as you stated - then don't set a maximum, 
which is the default backward-compatible part of my patch.

>> If JamesS did mean that he wanted to ramp down the starget->can_queue 
>> based on QUEUE_FULLs then JamesS and JamesB do not agree on that and we 
>> are stuck.
>>     
>
> I don't consider ramp up/down of starget->can_queue a requirement.
> But I also don't consider its presence a problem.
>
>   
Agreed.  My preference is a ramp up/down on a per-lun basis. However, 
you may select an algorithm that manipulates all luns at the same time 
for a target.

> Our requirements are pretty simple: the ability to limit the number
> of commands queued to a target or lun in a multi-initiator environment
> such that no individual initiator can fully consume the resources
> of the target/lun.  I.e., we want a user programmable upper bound
> on all queue_depth and can_queue adjustments.  (Yes, I've stated this
> a few times.  :)
>
>
>   
Easy to state, not so easy to truly do. But I'm in agreement.

-- james s
