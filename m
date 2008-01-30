From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 2.6.23.14] SCSI : scsi_device_lookup/scsi_device_lookup_by_target
 return NULL for an existent scsi_device
Date: Wed, 30 Jan 2008 16:33:45 -0500
Message-ID: <47A0ED39.3050201@emulex.com>
References: <450760.39028.qm@web53709.mail.re2.yahoo.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62228 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYA3VeE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 16:34:04 -0500
In-Reply-To: <450760.39028.qm@web53709.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagendra Tomar <tomer_iisc@yahoo.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Nagendra Tomar wrote:
> Hello James,
>              My understanding is that the scsi_device in SDEV_DEL state
> is there in the scsi_host->devices/scsi_target->devices queue, just
> because there is some outstanding command holding a reference to it.

Well, there's a lot more reasons than just an outstanding command. The
biggest issue is when there has been a downstream reference to it - such
as by a filesystem or DM object.

Some of the headaches have been these downstream references that are never
released. Ex: DM does not expect devices to come and go yet.

> It will need the device when it completes. Apart from this, for all 
> practical purposes the scsi_device is gone from the system. It could
> as well be removed from scsi_host->devices/scsi_target->devices lists
> and be put in some other list, just to hold the scsi_device till
> commands refering to it are completed. 

Keep thinking about DM references. So... it isn't quite gone from the
system.

> The scanning code should not consider these devices to be present 
> in the system. This is correctly handled today, as 
> scsi_device_lookup/scsi_device_lookup_by_target return NULL if there
> is an SDEV_DEL device in the list. 
> 
> Since a scsi_device in SDEV_DEL state is "gone" from the system we 
> should not hold any fresh references on to this device. The current
> scsi_device_lookup/scsi_device_lookup_by_target implementation rightly
> ensures that. And since all the sysfs linkages are also removed (in
> __scsi_remove_device->device_del), user space can also not reference 
> this device. All is good till now.
> 
> The problem happens when we try to add a new scsi_device with the same 
> HBTL. Since we consider the device "gone" (as described above) we should
> allow a new scsi_device with the same HBTL to be added (to the 
> scsi_host->devices/scsi_target->devices list). This part is also correctly
> implemented.
> scsi_add_device->...->scsi_probe_and_add_lun->scsi_device_lookup_by_target
> will _not_ return the device present in the SDEV_DEL state and hence the
> scanning will go ahead and try to add a new scsi_device (this one in 
> SDEV_RUNNING state) to the devices lists.
> 
> All is good even till now.
> 
> The PROBLEM is, now any scsi_device_lookup call trying to lookup this newly
> added scsi_device, fails. This is because, scsi_device_lookup->__scsi_device_lookup
> returns the first device that it finds in the list, which in this case
> is the one in the SDEV_DEL state. Now the scsi_device_get call that 
> scsi_device_lookup makes to get a reference on that device returns ENXIO
> as the device is in SDEV_DEL state, resulting in scsi_device_lookup to 
> return NULL.

> What scsi_device_get does, is right, as we do not want to hold fresh 
> references on scsi_devices in SDEV_DEL state. The problem is because
> of this we fail to lookup the perfectly legitimate device (in SDEV_RUNNING
> state) with the same HBTL sitting in the list.
> 
> One of the side effects of this is that the scsi_probe_and_add_lun()
> goes ahead with the scanning and tries to add this existent device. 
> This is the real problem.
> 
> My patch avoids this problem by not breaking from the __scsi_device_lookup
> loop, if the device is in SDEV_DEL state. After all we should not consider
> these devices to be part of the system. This will allow us to 
> find the right scsi_device and this "trying to add an existent device"
> problem will be avoided. 

So nothing you've described so far, including your patch, is different
from the discussion in this thread: http://marc.info/?l=linux-scsi&m=115582805811406&w=2
which terminates with a recommendation from James B to avoid this kind of
patch as there's also a lurking issue with the SDEV_CANCEL state.

Given that since this thread:
- the consensus was to resurrect the sdev from the SDEV_DEL state back
   to SDEV_RUNNING
      http://marc.info/?l=linux-scsi&m=117139230702785&w=2
- that patches for the resurrection where implemented post this thread
   and are in the upstream kernel
      http://marc.info/?l=linux-scsi&m=117991046126294&w=2
- and given there is still a set of resurrection fixes outstanding
      http://marc.info/?l=linux-scsi&m=118215727101887&w=2

I don't see any future for your patch.

Please apply the oustanding resurrection patch set and see if the proper
behavior occurs. If it doesn't, please post to l-s again and I'm sure
Hannes and I can consider it further.

> 
> And also why should scsi_device_lookup and __scsi_device_lookup be 
> different in behaviour. One returns devices in SDEV_DEL state, the other
> doesn't. The comments suggest that they can be used interchangibly, but
> for the locking and the extra reference that the scsi_device_lookup holds.

This is somewhat of a different argument. We should answer/solve the resurrection
problem, then see where things lead us.

-- james s

> 
> This is fixed as a side effect of the patch.
> 
> Comments welcome.
> 
> Thanx,
> Tomar
> 
> 
> 
> 
> 
> --- James Smart <James.Smart@Emulex.Com> wrote:
> 
>> This sounds like a return to the old behavior, where sdevs in SDEV_DEL
>> were ignored. However, it too had lots of bad effects. We'd have to go
>> back to the threads over the last 2 years that justified resurrecting
>> the sdev. Start looking at threads like :
>> http://marc.info/?l=linux-scsi&m=115555788730468&w=2
>> http://marc.info/?l=linux-scsi&m=116837744314913&w=2
>> http://marc.info/?l=linux-scsi&m=117139230702785&w=2
>> http://marc.info/?l=linux-scsi&m=117991046126294&w=2
>> Also, there's multiple parts to this - the sdev struct, and the sysfs objects
>> and thus namespace associated with the struct, etc.
>>
>> So, in my mind, if this reverts to ignoring sdevs in SDEV_DEL, and creates
>> a duplicate sdev in SDEV_RUNNING, then it's the wrong patch.  What should
>> be considered is where did the resurrection of the sdev go wrong.  I
>> remember that Hannes did some updates
>> http://marc.info/?l=linux-scsi&m=118215727101887&w=2
>> but I don't believe these ever got merged upstream. Perhaps that's a good
>> place to start.
>>
>> -- james s
>>
>>
>> Nagendra Tomar wrote:
>>> __scsi_device_lookup and __scsi_device_lookup_by_target do not 
>>> check for the sdev_state and hence return scsi_devices with 
>>> sdev_state set to SDEV_DEL also. It has the following side effects.
>>>
>>> We can have two scsi_devices with the same HBTL queued in 
>>> the scsi_host->__devices/scsi_target->devices list, one
>>> in the SDEV_DEL state and the other in, say SDEV_RUNNING state. 
>>>     If the one in the SDEV_DEL state is before the one in SDEV_RUNNING 
>>> state, (which will almost always be the case) the scsi_device_lookup and 
>>> scsi_device_lookup_by_target will never find the totally legitimate
>>> scsi_device (the one in the SDEV_RUNNING state).
>>>
>>> This is because __scsi_device_lookup/__scsi_device_lookup_by_target 
>>> always returns the first one in the list (which in our case is the 
>>> one with the SDEV_DEL state) and the scsi_device_get() which is called by 
>>> scsi_device_lookup/scsi_device_lookup_by_target will return -ENXIO 
>>> for this scsi_device, resulting in scsi_device_lookup and 
>>> scsi_device_lookup_by_target to return NULL.
>>>
>>>         So we _cannot_ lookup a perfectly valid device present in the
>>> list of scsi_devices. 
>>>
>>>         The right thing to do is to not have __scsi_device_lookup
>>> and __scsi_device_lookup_by_target match a device if the scsi_device
>>> state is SDEV_DEL. This will also make these functions similar in 
>>> behaviour to their scsi_device_lookup/scsi_device_lookup_by_target
>>> counterparts, as the comments in the code suggest.
>>>
>>>         One way by which we can have two scsi_devices in the list is 
>>> as follows.        
>>>         Suppose a scsi_device has some outstanding command(s) when 
>>> scsi_remove_device is called for it. Due to the extra ref being held
>>> by the command in flight, the __scsi_remove_device->put_device call 
>>> will not actually free the scsi_device and it will remain in the 
>>> scsi_device list albeit in the SDEV_DEL state. Now if we do a 
>>> scsi_add_device for the same HBTL, a new device with the same HBTL
>>> (this one in SDEV_RUNNING state) gets added to the scsi_device list. 
>>>         
>>>         Infact if we call scsi_add_device one more time, it happily 
>>> goes ahead and tries to add it once more, as 
>>> scsi_probe_and_add_lun->scsi_device_lookup_by_target does not return
>>> the already existing device. This will though result in the kobject 
>>> EEXIST warning dump.
>>>
>>>         The patch below solves the problem described here by not
>>> returning scsi_devices in SDEV_DEL state, thus allowing scsi_device
>>> in SDEV_RUNNING state (if any) to be correctly returned, instead.
>>>
>>>
>>> Thanx,
>>> Tomar
>>>
>>>
>>> Signed-off-by: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
>>> ---
>>>
>>> --- linux-2.6.23.14/drivers/scsi/scsi.c.orig	2008-01-23 18:06:02.000000000 +0530
>>> +++ linux-2.6.23.14/drivers/scsi/scsi.c	2008-01-23 19:17:35.000000000 +0530
>>> @@ -951,7 +951,7 @@ struct scsi_device *__scsi_device_lookup
>>>  	struct scsi_device *sdev;
>>>  
>>>  	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
>>> -		if (sdev->lun ==lun)
>>> +		if (sdev->lun == lun && sdev->sdev_state != SDEV_DEL)
>>>  			return sdev;
>>>  	}
>>>  
>>> @@ -1008,7 +1008,7 @@ struct scsi_device *__scsi_device_lookup
>>>  
>>>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
>>>  		if (sdev->channel == channel && sdev->id == id &&
>>> -				sdev->lun ==lun)
>>> +			sdev->lun == lun && sdev->sdev_state != SDEV_DEL)
>>>  			return sdev;
>>>  	}
>>>
>>>
>>>
>>>       ___________________________________________________________
>>> Support the World Aids Awareness campaign this month with Yahoo! For Good
>> http://uk.promotions.yahoo.com/forgood/
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
> 
> 
>       __________________________________________________________
> Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com
> 
> 
