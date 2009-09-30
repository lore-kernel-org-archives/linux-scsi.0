From: Michael Reed <mdr@sgi.com>
Subject: Re: qla2xxx: Conditionally disable automatic queue full tracking
Date: Wed, 30 Sep 2009 08:43:18 -0500
Message-ID: <4AC36076.1090001@sgi.com>
References: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com> <4ABB8572.5050902@sgi.com> <67E59C8B-0E12-44EA-983C-38634993DF5A@qlogic.com> <4ABBC53F.9090203@sgi.com> <3E1B3796-029F-4DBE-A414-0358AB257E93@qlogic.com> <4ABBDE68.2020903@sgi.com> <ABA38BF9-3910-45E9-8C2B-C860FD862D59@qlogic.com> <4AC35845.3020104@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:38778 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752094AbZI3NnR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2009 09:43:17 -0400
In-Reply-To: <4AC35845.3020104@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, LinuxSCSI <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "vasu.dev@intel.com" <vasu.dev@intel.com>, Jeremy Higdon <jeremy@sgi.com>



Michael Reed wrote:
> Hi Giri,
> 
> Giridhar Malavali wrote:
>> Michael,
>>
>> Can u please clarify following things.
>>
>> 1) You are ok with scsi mid layer adjusting the queue depth as long as  
>> the ramp-up code does not over shoot the user set threshold.
> 
> Yes.  This was the problem we had with qla2xxx.  Sites would tune
> their cluster to avoid most queue fulls and qla2xxx would merrily
> ramp queue depths back up to 32.
> 
>> 2) You want this to be controlled at device/LUN level. So the  
>> threshold is per LUN rather than target.
> 
> That's the way it is today and we're okay with this arrangement.
> This allows for static "performance" balancing.  Luns designated
> for high throughput can receive more outstanding commands than those
> only lightly used.
> 
>> 3) From your previous mail, I understand that you don't require a  
>> combined limit per target. Say the total queue depth for all LUN's on  
>> a particular target should not exceed some threshold.
> 
> Require, no.  This is the way it is today.  Desirable, YES.
> 
> This would be useful in both single system and cluster environments
> allowing the administrator to not have to be so conservative with
> their per-lun queue depth calculations.  On the raids we use, a
> "target" corresponds to a fibre cable entering a raid
> controller.  Every storage entity presented is a "lun".  The max
> number of outstanding commands is per raid controller.  I think this
> is a good idea and would support its implementation.  :)  I don't
> believe it eliminates the need for the ability to set a queue depth
> "per lun" but I could be talked into that belief.

In general, handling of queue full in a multi-initiator environment
is tricky in that a queue full status may be returned when the
initiator sending the command has no outstanding commands....

Mike

> 
> Mike
> 
>> -- Giri
>>
>>
>>
>>
>> On Sep 24, 2009, at 2:02 PM, Michael Reed wrote:
>>
>>> The LSI fusion FC driver did not exhibit the problem.  It doesn't
>>> dynamically re-adjust the queue depth.  I have limited experience
>>> with Emulex and cannot comment.
>>>
>>> Thank you for offering to do the work.  I'll gladly review and test
>>> anything you'd care to send my way.
>>>
>>> Mike
>>>
>>>
>>> Giridhar Malavali wrote:
>>>> I will be more than willing to do these changes. Just curious, was
>>>> this seen on non qla2xxx drivers too.
>>>>
>>>> -- Giri
>>>>
>>>>
>>>> On Sep 24, 2009, at 12:15 PM, Michael Reed wrote:
>>>>
>>>>> To answer your query, yes.  Ultimately, I believe the ml should be
>>>>> modified to view a user space modification to a lun's queue depth
>>>>> as an upper bound.  I don't care, much, whether the system  
>>>>> dynamically
>>>>> adjusts the queue depth or leaves it alone as long as it honors the
>>>>> value programmed via user space.
>>>>>
>>>>> Are you volunteering to do the work?  :)  How can I help?
>>>>>
>>>>> Thanks,
>>>>> Mike
>>>>>
>>>>>
>>>>> Giridhar Malavali wrote:
>>>>>> Hi Michael,
>>>>>>
>>>>>> Here are the patches..
>>>>>>
>>>>>> http://marc.info/?a=119828370000006&r=1&w=2 .
>>>>>> http://marc.info/?l=linux-scsi&m=125201657106722&w=2
>>>>>>
>>>>>> Thanks,
>>>>>> Giridhar.M.B
>>>>>>
>>>>>>
>>>>>>
>>>>>> On Sep 24, 2009, at 7:42 AM, Michael Reed wrote:
>>>>>>
>>>>>>> Hello,
>>>>>>>
>>>>>>> The purpose of the queue full tracking patch in qla2xxx is to
>>>>>>> keep the driver from changing a user space override of the queue
>>>>>>> depth back to what the driver believes is the "correct" value.
>>>>>>>
>>>>>>> The raid devices that we use have per raid controller queue depth
>>>>>>> limits and have at times demonstrated, uh, bad behavior when
>>>>>>> their queues are full for sustained periods of time.  SGI needs
>>>>>>> to be able to set queue depth for a lun based upon access patterns
>>>>>>> and performance requirements of the entire cluster and know that
>>>>>>> it will be honored as an upper bound.
>>>>>>>
>>>>>>> Might you provide a pointer to the recently submitted patches?
>>>>>>> I haven't followed linux-scsi in a while....  I'll be quite
>>>>>>> happy to take a look.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Mike
>>>>>>>
>>>>>>>
>>>>>>> Giridhar Malavali wrote:
>>>>>>>> Hi Michael/James,
>>>>>>>>
>>>>>>>> 	Patches were submitted to move queue ramp up/down code  
>>>>>>>> recently to
>>>>>>>> scsi mid layer. With this change, I don't see a need for a module
>>>>>>>> parameter to disable queuefull tracking  in qla2xxx driver.  
>>>>>>>> Andrew,
>>>>>>>> mentioned that this got introduced to avoid wobbling behavior on
>>>>>>>> the
>>>>>>>> wire due to queue depth modifications. Just wanted to check  
>>>>>>>> whether
>>>>>>>> the same need to be done in scsi mid layer too.
>>>>>>>>
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Giridhar.M.B
>>>>>>>>
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-
>>>>>>>> scsi" in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo- 
>>>>>>>> info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
