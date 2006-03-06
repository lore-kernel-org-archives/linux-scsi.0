From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Mon, 6 Mar 2006 14:55:08 -0500
Message-ID: <AA15D0CE-1FDF-4707-923D-01846551B90E@egenera.com>
References: <OF4F9C2429.293D1C5C-ON88257129.00683373-88257129.0069D5D8@us.ibm.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:17302 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1751490AbWCFTzO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 14:55:14 -0500
In-Reply-To: <OF4F9C2429.293D1C5C-ON88257129.00683373-88257129.0069D5D8@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>


On Mar 6, 2006, at 2:15 PM, Bryan Henderson wrote:

>> On Mar 2, 2006, at 11:21 AM, Vladislav Bolkhovitin wrote:
>>
>>> Could anyone advice how a SCSI target device can IO-throttle its
>>> initiators, i.e. prevent them from queuing too many commands,  
>>> please?
>>>
>>> I suppose, the best way for doing this is to inform the initiators
>>> about the maximum queue depth X of the target device, so any of the
>>> initiators will not send more than X commands. But I have not found
>>> anything similar to that on INQUIRY or MODE SENSE pages. Have I
>>> missed something? Just returning QUEUE FULL status doesn't look to
>>> be correct, because it can lead to out of order commands execution.
>>
>> Returning QUEUE FULL status is correct, unless the initiator does not
>> have any pending commands on the LUN, in which case you should return
>> BUSY. Yes, this can lead to out-of-order execution. That's why tapes
>> have traditionally not used SCSI command queuing.
>
> I'm confused,  Vladislav appears to be asking about flow control  
> such as
> is built into ISCSI, wherein the ISCSI target tells the intitiator how
> many tasks it's willing to work on at once and the initiator stops  
> sending
> new ones when it has hit that limit and waits for one of the  
> previous ones
> to finish.  And the target can continuously change that number.
>
> With the more primitive transports,

Seems like a somewhat loaded description to me. Personally, I'd pick  
something more neutral.

> I believe this is a manual
> configuration step -- the target has a fixed maximum queue depth  
> and you
> tell the driver via some configuration parameter what it is.

Not true. Consider the case where multiple initiators share one  
logical unit  - there is no guarantee that a single initiator can  
queue even a single command, since another initiator may have filled  
the queue at the device.

Another case is a target that has multiple logical units; it is  
conceivable that an implementation may share the device queue  
resources among all logical units. In this case again, there is no  
fixed number of commands that the target can guarantee to queue for a  
logical unit.

> As I understand it, any system in which QUEUE FULL (that's another  
> name
> for SCSI's Task Set Full, isn't it?)

Yes, you're correct. I should have written TASK SET FULL, which is  
the correct name for the SCSI status value that we are discussing.

> errors happen is one that is not
> properly configured.

Absolutely untrue.

> I saw a broken ISCSI system that had QUEUE FULLs
> happening, and it was a performance disaster.

Was it a performance disaster because of the broken-ness, or solely  
because of the TASK SET FULLs?

>>> Apparently, hardware SCSI targets don't suffer from queuing
>>> overflow and don't return all the time QUEUE FULL status, so the
>>> must be a way to do the throttling more elegantly.
>>
>> No, they just have big queues.
>
> Big queues are another serious performance problem, when it means a  
> target
> accepts work faster than it can do it.  I've seen that cause  
> initiators to
> send suboptimal requests (if the target appears to be working at  
> infinite
> speed, the initiator sends small chunks of work as soon as each is  
> ready,
> whereas if the initiator can tell that the target is choked, the  
> initiator
> combines and sorts work while it waits, into a stream the target can
> handle more efficiently).

1) Considering only first-order effects, who cares whether the  
initiator sends sub-optimal requests and the target coalesces them,  
or if the initiator does the coalescing itself?

2) If you care about performance, you don't try to fill the device  
queue; you just want to have enough outstanding so that the device  
doesn't go idle when there is work to do.

The reason why you do this has more to do with the access scheduling  
algorithm in the target more than anything else; brain-damaged  
marketing values small average access times more than a small  
variance in access times, so the device folks do crazy shortest- 
access-time-first scheduling instead of something more sane and less  
prone to spreading out the access time distribution like CSCAN.

> When systems substitute an oversized queue in a
> target for initiator-target flow control, the initiator ends up  
> having to
> compensate with artificial schemes to withhold work from a willing  
> target
> (e.g. Linux "queue plugging").

1) The SCSI architectural standard does not prescribe any method for  
initiator-target flow control other than TASK SET FULL and BUSY.  
There's nothing wrong with X-ON and X-OFF for flow control,  
especially when you cannot deterministically calculate a window size.

2) Tell the device folks to switch from shortest-access-time-first  
scheduling to something less aggressive like CSCAN, and then you  
might be able to tolerate the device queuing better.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


