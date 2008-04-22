From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc_user_scan correction
Date: Tue, 22 Apr 2008 15:04:59 -0400
Message-ID: <480E36DB.1050708@emulex.com>
References: <1208885319.12659.7.camel@localhost.localdomain> <480E29FC.3090502@cs.wisc.edu> <480E2A6A.4040309@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53766 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbYDVTFN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 15:05:13 -0400
In-Reply-To: <480E2A6A.4040309@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org



Mike Christie wrote:
> Mike Christie wrote:
>> Is this is the same as if you did not implement the user_scan callout? 
>> scsi_sysfs.c will call
>>
>> scsi_scan_host_selected(shost, channel, id, lun, 1);
>>
>> I thought we added the user_scan callback because the transport 
>> classes had to pass in the device struct between the host and target 
>> so we got
>>
>> .../host/rport/target/scsi_device
>>
>> instead of
>>
>> .../host/target/scsi_device
>>
>> qla4xxx has the same problem. Do not look at it for help :( It added a 
>> mutex and does not deadlock because like the FC class it stats the 
>> removal of the rport/session then device so the cache sync always 
>> fails (the check ready function always returns DID_NO_CONNECT so the 
>> cache sync fails). iscsi tcp/iser/bnx2i works because it has userspace 
>> helping out with the removal and shutdown and does it in two stages.
>>
> 
> I think we need some loop + locking + refcounting similar to how the 
> shost_for_each_device loops over devices.
> 

For FC, I don't believe there's any advantage to looping/locking. There's
miniscule advantages of not scanning targets that are just returned back
by the driver as not being present.

Taking another look at the user_scan sysfs routine, I can only come up with
a few reasons why it exists at all:
  - some transports/LLDs, which do target enumeration and auto-scan, can't
    handle directed scans to targets that don't exist. I have a hard time
    believing this is true.
  - There's some performance advantage for walking the transport target
    list rather than cycling on the target ids. But, this interface can't
    performance sensitive. This is the only reason I can see why user_scan
    exists (to filter out non-existent targets).
  - The "rescan" flag needs to be clean.  For transports that auto-scan,
    they have the best knowledge of when rescan should be 0 or 1. This
    protects against a race between the user scan and the 1st-time target
    discovery.

Hmm... this last point gives me concern, as I didn't fix it either.
Thoughts ?  I'm happy leaving it as the default, but the rescan bothers me.

-- james s
