From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fc_user_scan correction
Date: Tue, 22 Apr 2008 14:46:30 -0500
Message-ID: <480E4096.8070201@cs.wisc.edu>
References: <1208885319.12659.7.camel@localhost.localdomain> <480E29FC.3090502@cs.wisc.edu> <480E2A6A.4040309@cs.wisc.edu> <480E36DB.1050708@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54563 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbYDVTqi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 15:46:38 -0400
In-Reply-To: <480E36DB.1050708@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> 
> 
> Mike Christie wrote:
>> Mike Christie wrote:
>>> Is this is the same as if you did not implement the user_scan 
>>> callout? scsi_sysfs.c will call
>>>
>>> scsi_scan_host_selected(shost, channel, id, lun, 1);
>>>
>>> I thought we added the user_scan callback because the transport 
>>> classes had to pass in the device struct between the host and target 
>>> so we got
>>>
>>> .../host/rport/target/scsi_device
>>>
>>> instead of
>>>
>>> .../host/target/scsi_device
>>>
>>> qla4xxx has the same problem. Do not look at it for help :( It added 
>>> a mutex and does not deadlock because like the FC class it stats the 
>>> removal of the rport/session then device so the cache sync always 
>>> fails (the check ready function always returns DID_NO_CONNECT so the 
>>> cache sync fails). iscsi tcp/iser/bnx2i works because it has 
>>> userspace helping out with the removal and shutdown and does it in 
>>> two stages.
>>>
>>
>> I think we need some loop + locking + refcounting similar to how the 
>> shost_for_each_device loops over devices.
>>
> 
> For FC, I don't believe there's any advantage to looping/locking. There's
> miniscule advantages of not scanning targets that are just returned back
> by the driver as not being present.

I was actually just thinking of refcounting. Because we are coming in 
from the host the rpot would not have a refcount from the 
sysfs/userpscae reference. If there were no scsi_devices/targets on the 
rport and the rport ie being removed then I thought the scsi_scan.c code 
could be accessing a struct device that was freed or in the middle of 
being freed.


> 
> Taking another look at the user_scan sysfs routine, I can only come up with
> a few reasons why it exists at all:
>  - some transports/LLDs, which do target enumeration and auto-scan, can't
>    handle directed scans to targets that don't exist. I have a hard time
>    believing this is true.

I am not sure what you are saying? Is this the same as my comment about
.../host/rport/target/scsi_device
vs
.../host/target/scsi_device

If you go down scsi_scan_host_selected then we go to
scsi_scan_host_selected -> scsi_scan_channel -> __scsi_scan_target and 
the parent that is passed to __scsi_scan_target is the shost, so we get
.../host/target/scsi_device

For the transport classes we did scsi_scan_target and pass the rport so 
we end up with
.../host/rport/target/scsi_device

