From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: qla2xxx: Conditionally disable automatic queue full tracking
Date: Thu, 24 Sep 2009 13:55:36 -0700
Message-ID: <3E1B3796-029F-4DBE-A414-0358AB257E93@qlogic.com>
References: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com> <4ABB8572.5050902@sgi.com> <67E59C8B-0E12-44EA-983C-38634993DF5A@qlogic.com> <4ABBC53F.9090203@sgi.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:37857 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbZIXUzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 16:55:38 -0400
In-Reply-To: <4ABBC53F.9090203@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, LinuxSCSI <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "vasu.dev@intel.com" <vasu.dev@intel.com>

I will be more than willing to do these changes. Just curious, was  
this seen on non qla2xxx drivers too.

-- Giri


On Sep 24, 2009, at 12:15 PM, Michael Reed wrote:

> To answer your query, yes.  Ultimately, I believe the ml should be
> modified to view a user space modification to a lun's queue depth
> as an upper bound.  I don't care, much, whether the system dynamically
> adjusts the queue depth or leaves it alone as long as it honors the
> value programmed via user space.
>
> Are you volunteering to do the work?  :)  How can I help?
>
> Thanks,
> Mike
>
>
> Giridhar Malavali wrote:
>> Hi Michael,
>>
>> Here are the patches..
>>
>> http://marc.info/?a=119828370000006&r=1&w=2 .
>> http://marc.info/?l=linux-scsi&m=125201657106722&w=2
>>
>> Thanks,
>> Giridhar.M.B
>>
>>
>>
>> On Sep 24, 2009, at 7:42 AM, Michael Reed wrote:
>>
>>> Hello,
>>>
>>> The purpose of the queue full tracking patch in qla2xxx is to
>>> keep the driver from changing a user space override of the queue
>>> depth back to what the driver believes is the "correct" value.
>>>
>>> The raid devices that we use have per raid controller queue depth
>>> limits and have at times demonstrated, uh, bad behavior when
>>> their queues are full for sustained periods of time.  SGI needs
>>> to be able to set queue depth for a lun based upon access patterns
>>> and performance requirements of the entire cluster and know that
>>> it will be honored as an upper bound.
>>>
>>> Might you provide a pointer to the recently submitted patches?
>>> I haven't followed linux-scsi in a while....  I'll be quite
>>> happy to take a look.
>>>
>>> Thanks,
>>> Mike
>>>
>>>
>>> Giridhar Malavali wrote:
>>>> Hi Michael/James,
>>>>
>>>> 	Patches were submitted to move queue ramp up/down code recently to
>>>> scsi mid layer. With this change, I don't see a need for a module
>>>> parameter to disable queuefull tracking  in qla2xxx driver. Andrew,
>>>> mentioned that this got introduced to avoid wobbling behavior on  
>>>> the
>>>> wire due to queue depth modifications. Just wanted to check whether
>>>> the same need to be done in scsi mid layer too.
>>>>
>>>>
>>>> Thanks,
>>>> Giridhar.M.B
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-
>>>> scsi" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

