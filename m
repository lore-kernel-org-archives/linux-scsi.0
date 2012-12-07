From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 5/9] Disallow changing the device state via sysfs into
 "deleted"
Date: Fri, 07 Dec 2012 13:46:33 +0100
Message-ID: <50C1E529.3090107@acm.org>
References: <50C0BEEE.4040907@acm.org> <50C0C046.2060903@acm.org> <50C192CE.3000208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:57668 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964900Ab2LGMqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 07:46:35 -0500
In-Reply-To: <50C192CE.3000208@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 12/07/12 07:55, Hannes Reinecke wrote:
> On 12/06/2012 04:56 PM, Bart Van Assche wrote:
>> Changing the state of a SCSI device via sysfs into "cancel" or
>> "deleted" prevents scsi_remove_host() to remove these devices.
>> Hence do not allow this.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: James Bottomley <JBottomley@Parallels.com>
>> Cc: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_sysfs.c |    7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 4348f12..b319c20 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -591,13 +591,15 @@ sdev_store_delete(struct device *dev, struct
>> device_attribute *attr,
>>   };
>>   static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
>>
>> +#define INVALID_SDEV_STATE 0
>> +
> Shouldn't this become part of the enum?
> Defining it outside only confuses the compiler.
> And the unsuspecting user.

I can do that, but that will require changes in every switch statement 
on enum scsi_device_state because the kernel code is compiled with 
-Wswitch. From the gcc manual: <quote>-Wswitch: Warn whenever a switch 
statement has an index of enumerated type and lacks a case for one or 
more of the named codes of that enumeration. (The presence of a default 
label prevents this warning.)</quote>

Bart.
