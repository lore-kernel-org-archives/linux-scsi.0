From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc_user_scan correction
Date: Tue, 22 Apr 2008 17:30:33 -0400
Message-ID: <480E58F9.7060309@emulex.com>
References: <1208885319.12659.7.camel@localhost.localdomain> <480E29FC.3090502@cs.wisc.edu> <480E2A6A.4040309@cs.wisc.edu> <480E36DB.1050708@emulex.com> <480E4096.8070201@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37861 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbYDVVar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 17:30:47 -0400
In-Reply-To: <480E4096.8070201@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

Mike,

You're right.  The nuance is that user_scan *must* be supported if the
transport binds the target to a transport-specific device node that is
not the shost, as user_scan needs to call the scsi_scan_target() with
the parent node the target structure has to be bound to. It's not just
a sysfs interface.

I'll rework the patch and update the user_scan comment to make sure this
is better understood.

-- james s

Mike Christie wrote:
> James Smart wrote:
>>
>>
>> Mike Christie wrote:
>>> Mike Christie wrote:
>>>> Is this is the same as if you did not implement the user_scan 
>>>> callout? scsi_sysfs.c will call
>>>>
>>>> scsi_scan_host_selected(shost, channel, id, lun, 1);
>>>>
>>>> I thought we added the user_scan callback because the transport 
>>>> classes had to pass in the device struct between the host and target 
>>>> so we got
>>>>
>>>> .../host/rport/target/scsi_device
>>>>
>>>> instead of
>>>>
>>>> .../host/target/scsi_device
>>>>
>>>> qla4xxx has the same problem. Do not look at it for help :( It added 
>>>> a mutex and does not deadlock because like the FC class it stats the 
>>>> removal of the rport/session then device so the cache sync always 
>>>> fails (the check ready function always returns DID_NO_CONNECT so the 
>>>> cache sync fails). iscsi tcp/iser/bnx2i works because it has 
>>>> userspace helping out with the removal and shutdown and does it in 
>>>> two stages.
>>>>
>>>
>>> I think we need some loop + locking + refcounting similar to how the 
>>> shost_for_each_device loops over devices.
>>>
>>
>> For FC, I don't believe there's any advantage to looping/locking. There's
>> miniscule advantages of not scanning targets that are just returned back
>> by the driver as not being present.
> 
> I was actually just thinking of refcounting. Because we are coming in 
> from the host the rpot would not have a refcount from the 
> sysfs/userpscae reference. If there were no scsi_devices/targets on the 
> rport and the rport ie being removed then I thought the scsi_scan.c code 
> could be accessing a struct device that was freed or in the middle of 
> being freed.
> 
> 
>>
>> Taking another look at the user_scan sysfs routine, I can only come up 
>> with
>> a few reasons why it exists at all:
>>  - some transports/LLDs, which do target enumeration and auto-scan, can't
>>    handle directed scans to targets that don't exist. I have a hard time
>>    believing this is true.
> 
> I am not sure what you are saying? Is this the same as my comment about
> .../host/rport/target/scsi_device
> vs
> .../host/target/scsi_device
> 
> If you go down scsi_scan_host_selected then we go to
> scsi_scan_host_selected -> scsi_scan_channel -> __scsi_scan_target and 
> the parent that is passed to __scsi_scan_target is the shost, so we get
> .../host/target/scsi_device
> 
> For the transport classes we did scsi_scan_target and pass the rport so 
> we end up with
> .../host/rport/target/scsi_device
> 
> 
