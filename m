From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: Fix a reference counting bug
Date: Tue, 4 Oct 2016 10:08:42 +0200
Message-ID: <60c9c051-0c74-5a73-c261-9a23a8ff21c6@suse.de>
References: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
 <afae74e6-6bb6-aa3f-01c4-6c0b5558772d@suse.de>
 <99110c0a-370e-e31e-d6e3-72d247a5a355@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752174AbcJDIIv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Oct 2016 04:08:51 -0400
In-Reply-To: <99110c0a-370e-e31e-d6e3-72d247a5a355@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/29/2016 07:01 PM, Bart Van Assche wrote:
> On 09/28/2016 10:46 PM, Hannes Reinecke wrote:
>> On 09/29/2016 01:45 AM, Bart Van Assche wrote:
>>> The code at the end of alua_rtpg_work() is as follows:
>>>
>>>     scsi_device_put(sdev);
>>>     kref_put(&pg->kref, release_port_group);
>>>
>>> Make sure that all code that queues the work item associated
>>> with alua_rtpg_work() holds both references.
>>>
>>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>>> Cc: Hannes Reinecke <hare@suse.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>  drivers/scsi/device_handler/scsi_dh_alua.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
>>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>>> index 752b5c9..f7099e2 100644
>>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>>> @@ -889,6 +889,7 @@ static void alua_rtpg_queue(struct
>>> alua_port_group *pg,
>>>          /* Do not queue if the worker is already running */
>>>          if (!(pg->flags & ALUA_PG_RUNNING)) {
>>>              kref_get(&pg->kref);
>>> +            scsi_device_get(sdev);
>>>              start_queue = 1;
>>>          }
>>>      }
>>>
>> Nack.
>>
>> The scsi device reference tracks ->rtpg_sdev, not the queue item.
>> So we only need to take the scsi device reference if we're assigning a
>> new value to ->rtpg_sdev, which we are not.
> 
> Hello Hannes,
> 
> If queue_delayed_work() returns 0 that means that a call to
> alua_rtpg_work() has already been scheduled. alua_rtpg_work() will drop
> the reference on pg->rtpg_sdev. Are you sure that alua_rtpg_queue()
> should call scsi_device_put(sdev) in that case?
> 
Ah, now I see what you mean.
However, your patch is still incorrect; when doing so we'll end up with
a duplicate reference if the call to queue_delayed_work() succeeds.

I'll be sending an updated patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
