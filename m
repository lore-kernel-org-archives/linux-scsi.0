From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fc_user_scan correction
Date: Tue, 22 Apr 2008 14:51:42 -0500
Message-ID: <480E41CE.9020004@cs.wisc.edu>
References: <1208885319.12659.7.camel@localhost.localdomain> <480E29FC.3090502@cs.wisc.edu> <480E2A6A.4040309@cs.wisc.edu> <480E36DB.1050708@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54577 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764507AbYDVTvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 15:51:51 -0400
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
> 
> Taking another look at the user_scan sysfs routine, I can only come up with
> a few reasons why it exists at all:
>  - some transports/LLDs, which do target enumeration and auto-scan, can't
>    handle directed scans to targets that don't exist. I have a hard time
>    believing this is true.
>  - There's some performance advantage for walking the transport target
>    list rather than cycling on the target ids. But, this interface can't
>    performance sensitive. This is the only reason I can see why user_scan
>    exists (to filter out non-existent targets).
>  - The "rescan" flag needs to be clean.  For transports that auto-scan,
>    they have the best knowledge of when rescan should be 0 or 1. This
>    protects against a race between the user scan and the 1st-time target
>    discovery.
> 

Oh yeah, the original reason is here
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=e02f3f59225d8c3b2a0ad0dc941a09865e27da61
