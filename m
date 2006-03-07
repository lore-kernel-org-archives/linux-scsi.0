From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: SCSI target and IO-throttling
Date: Tue, 7 Mar 2006 15:32:28 -0800
Message-ID: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com>
References: <AA15D0CE-1FDF-4707-923D-01846551B90E@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:14035 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964806AbWCGXcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 18:32:31 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k27NWUAb003906
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 18:32:30 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k27NWU06226370
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 18:32:30 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k27NWUXO013909
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 18:32:30 -0500
In-Reply-To: <AA15D0CE-1FDF-4707-923D-01846551B90E@egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>

>> With the more primitive transports,
>
>Seems like a somewhat loaded description to me. Personally, I'd pick 
>something more neutral.

Unfortunately, it's exactly what I mean.  I understand that some people 
attach negative connotations to primitivity, but I can't let that get in 
the way of clarity.

>> I believe this is a manual
>> configuration step -- the target has a fixed maximum queue depth 
>> and you
>> tell the driver via some configuration parameter what it is.
>
>Not true. Consider the case where multiple initiators share one 
>logical unit  - there is no guarantee that a single initiator can 
>queue even a single command, since another initiator may have filled 
>the queue at the device.

I'm not sure what it is that you're saying isn't true.  You do give a good 
explanation of why designers would want something more sophisticated than 
this, but that doesn't mean every SCSI implementation actually is.  Are 
you saying there are no SCSI targets so primitive that they have a fixed 
maximum queue depth?  That there are no systems where you manually set the 
maximum requests-in-flight at the initiator in order to optimally drive 
such targets?

>> I saw a broken ISCSI system that had QUEUE FULLs
>> happening, and it was a performance disaster.
>
>Was it a performance disaster because of the broken-ness, or solely 
>because of the TASK SET FULLs?

Because of the broken-ness.  Task Set Full is the symptom, not the 
disease.  I should add that in this system, there was no way to make it 
perform optimally and also see Task Set Full regularly.

You mentioned in another email that FCP is designed to use Task Set Full 
for normal flow control.  I heard that before, but didn't believe it; I 
thought  FCP was more advanced than that.  But I believe it now.  So I was 
wrong to say that Task Set Full happening means a system is misconfigured. 
 But it's still the case that if you can design a system in which Task Set 
Full never happens, it will perform better than one in which it does. 
ISCSI flow control and manual setting of queue sizes in initiators are two 
ways people do that.

>1) Considering only first-order effects, who cares whether the 
>initiator sends sub-optimal requests and the target coalesces them, 
>or if the initiator does the coalescing itself?

I don't know what  a first-order effect is, so this may be out of bounds, 
but here's a reason to care:  the initiator may have more resource 
available to do the work than the target.  We're talking here about a 
saturated target (which, rather than admit it's overwhelmed, keeps 
accepting new tasks).

But it's really the wrong question, because the more important question is 
would you rather have the initiator do the coalescing or nobody?  There 
exist targets that are not capable of combining or ordering tasks, and 
still accept large queues of them.  These are the ones I saw have 
improperly large queues.  A target that can actually make use of a large 
backlog of work, on the other hand, is right to accept one.

I have seen people try to improve performance of a storage system by 
increasing queue depth in the target such as this.  They note that the 
queue is always full, so it must need more queue space.  But this degrades 
performance, because on one of these first-in-first-out targets, the only 
way to get peak capacity is to keep the queue full all the time so as to 
create backpressure and cause the initiator to schedule the work. 
Increasing the queue depth increases the chance that the initiator will 
not have the backlog necessary to do that scheduling.  The correct queue 
depth on this kind of target is the number of requests the target can 
process within the initiator's (and channel's) turnaround time.

>brain-damaged 
>marketing values small average access times more than a small 
>variance in access times, so the device folks do crazy shortest- 
>access-time-first scheduling instead of something more sane and less 
>prone to spreading out the access time distribution like CSCAN.

Since I'm talking about targets that don't do anything close to that 
sophisticated with the stuff in their queue, this doesn't apply.

But I do have to point out that there are systems where throughput is 
everything, and response time, including variability of it, is nothing. In 
fact, the systems I work with are mostly that kind.  For that kind of 
system, you'd want to target to do that kind of scheduling.

>2) If you care about performance, you don't try to fill the device 
>queue; you just want to have enough outstanding so that the device 
>doesn't go idle when there is work to do.

Why would the queue have a greater capacity than what is needed when you 
care about performance?  Is there some non-performance reason to have a 
giant queue?

I still think having a giant queue is not a solution to any flow control 
(or, in the words of the original problem, I/O throttling) problem.  I'm 
even skeptical that there's any size you can make one that would avoid 
queue full conditions.  It would be like avoiding difficult memory 
allocation algorithms by just having a whole lot of memory.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

