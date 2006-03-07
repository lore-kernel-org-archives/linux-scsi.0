From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Tue, 7 Mar 2006 13:38:29 -0500
Message-ID: <3A1A3A8E-A392-4DDF-8425-29DE7D8F45CD@egenera.com>
References: <OF4F9C2429.293D1C5C-ON88257129.00683373-88257129.0069D5D8@us.ibm.com> <440DC93B.8000000@vlnb.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:64482 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1750940AbWCGSie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 13:38:34 -0500
In-Reply-To: <440DC93B.8000000@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org


On Mar 7, 2006, at 12:56 PM, Vladislav Bolkhovitin wrote:

> Bryan Henderson wrote:
>>> On Mar 2, 2006, at 11:21 AM, Vladislav Bolkhovitin wrote:
>>>
>>>
>>>> Could anyone advice how a SCSI target device can IO-throttle its  
>>>> initiators, i.e. prevent them from queuing too many commands,  
>>>> please?
>>>>
>>>> I suppose, the best way for doing this is to inform the  
>>>> initiators about the maximum queue depth X of the target device,  
>>>> so any of the initiators will not send more than X commands. But  
>>>> I have not found anything similar to that on INQUIRY or MODE  
>>>> SENSE pages. Have I missed something? Just returning QUEUE FULL  
>>>> status doesn't look to be correct, because it can lead to out of  
>>>> order commands execution.
>>>
>>> Returning QUEUE FULL status is correct, unless the initiator does  
>>> not have any pending commands on the LUN, in which case you  
>>> should return BUSY. Yes, this can lead to out-of-order execution.  
>>> That's why tapes have traditionally not used SCSI command queuing.
>> I'm confused,  Vladislav appears to be asking about flow control  
>> such as is built into ISCSI, wherein the ISCSI target tells the  
>> intitiator how many tasks it's willing to work on at once and the  
>> initiator stops sending new ones when it has hit that limit and  
>> waits for one of the previous ones to finish.  And the target can  
>> continuously change that number.
>
> Yes, exactly.
>
>> With the more primitive transports, I believe this is a manual  
>> configuration step -- the target has a fixed maximum queue depth  
>> and you tell the driver via some configuration parameter what it is.
>
> We currently mostly deal with Fibre Channel, which seems to be a  
> kind of "more primitive transport" without explicit flow control.  
> Actually, I'm very surprised and can't believe that so advanced and  
> expensive technology doesn't have such basic thing as a good flow  
> control. Although, precisely speaking, such flow control is located  
> on level above transport (this is true for iSCSI as well),  
> therefore this is SCSI flaw, not FC.

It has X-ON and X-OFF flow control. Not bad considering it was  
designed in the early 1980's.

X-OFF is TASK_SET_FULL or BUSY
X-ON is a command completing, or if busy was received because the  
initiator did not have any outstanding commands at the target, then X- 
ON is implied after a short time delay.

Since an intelligently-designed initiator isn't going to dump every  
command to the device anyway (after all, the person writing the  
initiator driver wants to have some fun implementing I/O  
optimizations too; can't let those target folk have all the fun :-),  
the XON/XOFF flow control isn't often invoked.

>> As I understand it, any system in which QUEUE FULL (that's another  
>> name for SCSI's Task Set Full, isn't it?) errors happen is one  
>> that is not properly configured.  I saw a broken ISCSI system that  
>> had QUEUE FULLs happening, and it was a performance disaster.
>
> It is what we observe, too much QUEUE FULLs degrade performance  
> considerably.

Sounds like a broken initiator.

>
>>>> Apparently, hardware SCSI targets don't suffer from queuing  
>>>> overflow and don't return all the time QUEUE FULL status, so the  
>>>> must be a way to do the throttling more elegantly.
>>>
>>> No, they just have big queues.
>> Big queues are another serious performance problem, when it means  
>> a target accepts work faster than it can do it.  I've seen that  
>> cause initiators to send suboptimal requests (if the target  
>> appears to be working at infinite speed, the initiator sends small  
>> chunks of work as soon as each is ready, whereas if the initiator  
>> can tell that the target is choked, the initiator combines and  
>> sorts work while it waits, into a stream the target can handle  
>> more efficiently).  When systems substitute an oversized queue in  
>> a target for initiator-target flow control, the initiator ends up  
>> having to compensate with artificial schemes to withhold work from  
>> a willing target (e.g. Linux "queue plugging").
>
> This is one point why I don't like having a overbig queue on the  
> target.

This is just a matter of taste of whether you prefer the optimization  
to be done on the initiator side or the target side. If you prefer it  
to be done on the initiator side, then don't queue large amounts of  
work at the target.

> Another one is initiator side timeouts when the queue so big that  
> it could not been done on time. I described it in the previous email.

This is just a bug in the initiator. It can observe the average  
service time and it knows how many commands it has queued. If it sets  
its timeout anywhere close to the product of those two numbers it is  
buggy.

Regards,
-Steve

-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


