From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi midlayer: fix sdev reuse after free
Date: Tue, 27 Jun 2006 12:42:08 -0400
Message-ID: <44A15FE0.7000508@emulex.com>
References: <1151348028.5883.16.camel@localhost.localdomain> <1151424211.3340.35.camel@mulgrave.il.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:23955 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161165AbWF0QmQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 12:42:16 -0400
In-Reply-To: <1151424211.3340.35.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Yes - same issue as with the starget - and with the same call for
actions....

What is says is all of this is very broken right now for dynamic
teardown and re-add. Perhaps you want to reconsider the patch that
made it configurable as to whether to tear down the starget tree ?
Granted, you still have to do so on module unload or LLDD detach,
but the common use models usually doesn't make this an issue.

-- james s

James Bottomley wrote:
> On Mon, 2006-06-26 at 14:53 -0400, James Smart wrote:
>>  void __scsi_remove_device(struct scsi_device *sdev)
>>  {
>>  	struct device *dev = &sdev->sdev_gendev;
>> +	unsigned long flags;
>>  
>>  	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>>  		return;
>>  
>> +	spin_lock_irqsave(sdev->host->host_lock, flags);
>> +	list_del(&sdev->siblings);
>> +	list_del(&sdev->same_target_siblings);
>> +	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>>  	class_device_unregister(&sdev->sdev_classdev);
>>  	transport_remove_device(dev);
>>  	device_del(dev);
> 
> Not quite ... we cannot physically remove the device from the list until
> after device_del has been called otherwise we could get namespace reuse
> before it is really free (that's quite a small race window in this case,
> but it does exist).
> 
> James
> 
> 
> 
