From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Fri, 10 Mar 2006 08:26:29 -0500
Message-ID: <CA7E1C74-8394-4289-AE81-C215F22F4E76@egenera.com>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:61918 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1750782AbWCJN0e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 08:26:34 -0500
In-Reply-To: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>


On Mar 7, 2006, at 6:32 PM, Bryan Henderson wrote:

>>> With the more primitive transports,
>>
>> Seems like a somewhat loaded description to me. Personally, I'd pick
>> something more neutral.
>
> Unfortunately, it's exactly what I mean.  I understand that some  
> people
> attach negative connotations to primitivity, but I can't let that  
> get in
> the way of clarity.
>
>>> I believe this is a manual
>>> configuration step -- the target has a fixed maximum queue depth
>>> and you
>>> tell the driver via some configuration parameter what it is.
>>
>> Not true. Consider the case where multiple initiators share one
>> logical unit  - there is no guarantee that a single initiator can
>> queue even a single command, since another initiator may have filled
>> the queue at the device.
>
> I'm not sure what it is that you're saying isn't true.

I'm saying that your blanket statement that "With the more primitive  
transports, I believe this is a manual configuration step -- the  
target has a fixed maximum queue depth and you tell the driver via  
some configuration parameter what it is." is not true.

> You do give a good
> explanation of why designers would want something more  
> sophisticated than
> this, but that doesn't mean every SCSI implementation actually is.

I didn't say every SCSI implementation did anything in particular. On  
the other hand, you did.

> Are
> you saying there are no SCSI targets so primitive that they have a  
> fixed
> maximum queue depth?

Of course I'm not saying that no such systems exist. I'm only  
refuting your claim that they all behave that way.

> That there are no systems where you manually set the
> maximum requests-in-flight at the initiator in order to optimally  
> drive
> such targets?

Of course I'm not saying that no such systems exist. I'm only  
refuting your claim that they all behave that way.

>
>>> I saw a broken ISCSI system that had QUEUE FULLs
>>> happening, and it was a performance disaster.
>>
>> Was it a performance disaster because of the broken-ness, or solely
>> because of the TASK SET FULLs?
>
> Because of the broken-ness.  Task Set Full is the symptom, not the
> disease.  I should add that in this system, there was no way to  
> make it
> perform optimally and also see Task Set Full regularly.
>
> You mentioned in another email that FCP is designed to use Task Set  
> Full
> for normal flow control.  I heard that before, but didn't believe  
> it; I
> thought  FCP was more advanced than that.  But I believe it now.   
> So I was
> wrong to say that Task Set Full happening means a system is  
> misconfigured.

>  But it's still the case that if you can design a system in which  
> Task Set
> Full never happens, it will perform better than one in which it does.

This is not necessarily true. TASK_SET_FULL does consume some  
initiator CPU resources and some bus bandwidth, so if one of those is  
your bottleneck, then yes, avoiding TASK_SET_FULL will improve  
performance. But if the performance bottleneck is the device server  
itself, then to a first approximation it makes no difference to  
performance whether the commands are queued on the initiator side of  
the interface or on the target side of the interface, assuming both  
the initiator and the target are capable of performing the same  
reordering optimizations.

> ISCSI flow control and manual setting of queue sizes in initiators  
> are two
> ways people do that.
>
>> 1) Considering only first-order effects, who cares whether the
>> initiator sends sub-optimal requests and the target coalesces them,
>> or if the initiator does the coalescing itself?
>
> I don't know what  a first-order effect is, so this may be out of  
> bounds,
> but here's a reason to care:  the initiator may have more resource
> available to do the work than the target.  We're talking here about a
> saturated target (which, rather than admit it's overwhelmed, keeps
> accepting new tasks).

Usually the target resource that is the bottleneck is the mechanical  
device, not the CPU. So it usually has the resources to devote to  
reordering the queue. Even disk drives with their $5 CPU have enough  
CPU bandwidth for this.
>
> But it's really the wrong question, because the more important  
> question is
> would you rather have the initiator do the coalescing or nobody? There
> exist targets that are not capable of combining or ordering tasks, and
> still accept large queues of them.

So no target should be able to accept large numbers of queued  
commands because some targets you've worked with are broken? Or we  
should have to manually configure the queue depth on every target  
because some of them are broken?

This also doesn't seem pertinent to TASK_SET_FULL versus iSCSI-style  
windowing, since a broken target can accept a large queue of commands  
no matter what flow-control mechanism is used.

I don't oppose including an option to an initiator that would  
manually set a maximum queue depth for a particular make and model of  
a SCSI target as a device-specific quirk; I just don't think it's  
mandatory, I don't think it's a good idea to have it be a global  
setting, and I also don't think it is the best general solution.

> These are the ones I saw have
> improperly large queues.  A target that can actually make use of a  
> large
> backlog of work, on the other hand, is right to accept one.

Absolutely. And the ones that can't should be sending TASK_SET_FULL  
when they've reached their limit.
>
> I have seen people try to improve performance of a storage system by
> increasing queue depth in the target such as this.  They note that the
> queue is always full, so it must need more queue space.  But this  
> degrades
> performance, because on one of these first-in-first-out targets,  
> the only
> way to get peak capacity is to keep the queue full all the time so  
> as to
> create backpressure and cause the initiator to schedule the work.
> Increasing the queue depth increases the chance that the initiator  
> will
> not have the backlog necessary to do that scheduling.  The correct  
> queue
> depth on this kind of target is the number of requests the target can
> process within the initiator's (and channel's) turnaround time.
>
>> brain-damaged
>> marketing values small average access times more than a small
>> variance in access times, so the device folks do crazy shortest-
>> access-time-first scheduling instead of something more sane and less
>> prone to spreading out the access time distribution like CSCAN.
>
> Since I'm talking about targets that don't do anything close to that
> sophisticated with the stuff in their queue, this doesn't apply.
>
> But I do have to point out that there are systems where throughput is
> everything, and response time, including variability of it, is  
> nothing. In
> fact, the systems I work with are mostly that kind.  For that kind of
> system, you'd want to target to do that kind of scheduling.

Yep, for batch you want SATF scheduling. It's not appropriate as the  
default setting for mass-produced disk devices, however.

>
>> 2) If you care about performance, you don't try to fill the device
>> queue; you just want to have enough outstanding so that the device
>> doesn't go idle when there is work to do.
>
> Why would the queue have a greater capacity than what is needed  
> when you
> care about performance?  Is there some non-performance reason to  
> have a
> giant queue?

Benchmarks which measure whether the device can coalesce 256 512-byte  
sequential writes :-)

Basically it is that for disk devices the optimal queue depth depends  
on the workload, so it's statically-sized for the worst-case.

> I still think having a giant queue is not a solution to any flow  
> control
> (or, in the words of the original problem, I/O throttling) problem.

I did not suggest a giant queue as a "solution". I only replied to  
Vladislav's question as to how disk drives avoid sending  
TASK_SET_FULL all the time. They have queue sizes larger than the  
number of commands that the initiator usually tries to send.

> I'm
> even skeptical that there's any size you can make one that would avoid
> queue full conditions.

Well, if it's bigger than the number of SCSI command buffers  
allocated by the initiator, the target wins and never has to send  
TASK_SET_FULL (unless there are multiple initiators).

> It would be like avoiding difficult memory
> allocation algorithms by just having a whole lot of memory.

Yep. That's a good practical solution, and one which the operating  
system on your desktop computer probably uses :-)

I do take your point; arbitrarily large queues only postpone the  
point at which the target must reply TASK_SET_FULL. Usually that is  
good enough.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


