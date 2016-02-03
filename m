From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Tue, 2 Feb 2016 17:17:19 -0800
Message-ID: <56B1551F.4070800@sandisk.com>
References: <568FE922.9090004@sandisk.com>
 <yq1oachqehs.fsf@sermon.lab.mkp.net>
 <1453251809.2320.56.camel@HansenPartnership.com>
 <56B025E4.9010009@sandisk.com>
 <1454413585.2349.11.camel@HansenPartnership.com> <56B0F58B.60708@sandisk.com>
 <1454460201.2363.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0054.outbound.protection.outlook.com ([207.46.100.54]:11418
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754593AbcBCBRZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 20:17:25 -0500
In-Reply-To: <1454460201.2363.3.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sebastian Herbszt <herbszt@gmx.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/02/2016 04:43 PM, James Bottomley wrote:
> On Tue, 2016-02-02 at 10:29 -0800, Bart Van Assche wrote:
>> On 02/02/2016 03:46 AM, James Bottomley wrote:
>>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>>> index 4f18a85..00bc721 100644
>>> --- a/drivers/scsi/scsi_sysfs.c
>>> +++ b/drivers/scsi/scsi_sysfs.c
>>> @@ -1272,16 +1272,18 @@ static void __scsi_remove_target(struct
>>> scsi_target *starget)
>>>    void scsi_remove_target(struct device *dev)
>>>    {
>>>        struct Scsi_Host *shost = dev_to_shost(dev->parent);
>>> -     struct scsi_target *starget;
>>> +     struct scsi_target *starget, *last_target = NULL;
>>>        unsigned long flags;
>>>
>>>    restart:
>>>        spin_lock_irqsave(shost->host_lock, flags);
>>>        list_for_each_entry(starget, &shost->__targets, siblings) {
>>> -             if (starget->state == STARGET_DEL)
>>> +             if (starget->state == STARGET_DEL ||
>>> +                 starget == last_target)
>>>                        continue;
>>>                if (starget->dev.parent == dev || &starget->dev ==
>>> dev) {
>>>                        kref_get(&starget->reap_ref);
>>> +                     last_target = starget;
>>>                        spin_unlock_irqrestore(shost->host_lock,
>>> flags);
>>>                        __scsi_remove_target(starget);
>>>                        scsi_target_reap(starget);
>>
>> Hello James,
>>
>> Do you think it is a robust approach to store the pointer to the last
>> removed target in the last_target variable ?
>
> Well, yes, I think it will work, if that's what you mean.
>
>>   What if e.g. scsi_target_reap() frees the memory the last_target
>> pointer points at and another thread reallocates a scsi_target data
>> structure ? Can that last data structure have the same address as the
>> contents of the last_target variable ?
>
> Yes, but it doesn't matter, does it?  Add/Remove has always (and will
> always) be racy.  Under current conditions you can still add to the
> target after the list_for_each terminates and have scsi_remove_target()
> return with attached devices.  The only way to close the race is
> basically to forbid scanning as we shut down the host and wait for all
> in-progress scans before starting the final removals.

Hello James,

Although the scenario I described is unlikely if it happens it might be 
really hard to figure out what went wrong for someone who has not 
followed this discussion. This makes me wonder whether the above patch 
is really the best way to fix the reported soft lockup ...

Thanks,

Bart.
