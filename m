From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] iscsi driver update 4.0.1.8
Date: Fri, 16 Jul 2004 10:01:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F809F5.10501@us.ibm.com>
References: <200407151602.45830.naveenb@cisco.com> <40F6BDC7.2090405@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:34994 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266591AbUGPRGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 13:06:14 -0400
In-Reply-To: <40F6BDC7.2090405@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: naveenb@cisco.com, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:

> Naveen Burmi wrote:
> 
>> This version of the iSCSI driver (4.0.1.8) contains the following changes
>> since 4.0.1.7:
>>
>> 1. The issue of deadlock due to multiple kmaps has been partially 
>> resolved.
>>    We now use sendpage along the xmit path.
>> 2. The driver used to overwrite scsi midlayer naming. This has been 
>> removed.
>>    Now proc_name field is used for iSCSI device lookup in sysfs.
>> 3. The driver's queuecommand now returns SCSI_MLQUEUE_DEVICE_BUSY and
>>    SCSI_MLQUEUE_HOST_BUSY on failure.
>> 4. We have removed bus reset handler from the code.
>>
>> The following items are being worked on/debated:
>>
>> a) Per target probe via hotplug.
>> In earlier reviews, it was debated that the hotplug mechanism should 
>> be used
>> for target activation. Though scsi_scan_host() is exported,
>> scsi_scan_host_selected() isn't. So, an adapter scan is exported to LLDD
>> whereas anything else (target or lun scan) has to go through hotplug.
>> Network oriented storage like iSCSI has to deal with delays in targets
>> getting discovered through SendTargets discovery and poll for SLP
>> discoveries.
>> It would help a lot to use scsi_scan_host_selected() in such cases and 
>> needs
>> to be exported for such LLDDs.
> 
> 
> What is wrong with doing everything from userspace? If we do discovery 
> in userspace and send down that info from usrspace, why not kick off the 
> scanning from userspace once the establish session ioctl has completed? 
> The driver today does not handle userspace initiated scans correctly, so 
> this needs to be addressed regardless?
> 

I sent a patch to linux-iscsi yesterday that implements James's 
suggestion to do a scsi-host-per-transport-endpoint. As we discussed, 
with this change we do not have any special needs (like to scan specific 
targets), so we can just use scsi_scan_host() like regular drivers do.

Also per our discussion, handling the report luns data changed 
asynchronous event is not critical to the driver at this point, so it 
may be best to work on critical cleanups and worry about events when 
SCSI-ml has a well designed event mechanism or when we have finished the 
basic driver items. This should also reduce the work any reviewer would 
have to do for the driver when we feel we are ready for a review.
