From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 17/20 v1] [SCSI] mpt3sas: Use alloc_ordered_workqueue()
 API instead of create_singlethread_workqueue() API
Date: Thu, 18 Jun 2015 17:36:36 -0400
Message-ID: <558339E4.6010705@stratus.com>
References: <1434433027-40682-1-git-send-email-Sreekanth.Reddy@avagotech.com>	<5582B51C.8070700@stratus.com> <CAK=zhgoGUC74U6RxxALv=1Y3jbKSAZ+_Ahfa1wLsaMDvin92qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o149.mxlogic.net ([208.65.145.82]:51887 "EHLO
	p02c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbFRVoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2015 17:44:19 -0400
In-Reply-To: <CAK=zhgoGUC74U6RxxALv=1Y3jbKSAZ+_Ahfa1wLsaMDvin92qg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>

On 06/18/2015 09:06 AM, Sreekanth Reddy wrote:
> On Thu, Jun 18, 2015 at 5:40 PM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
>> On 06/16/2015 01:37 AM, Sreekanth Reddy wrote:
>>> Created a thread using alloc_ordered_workqueue() API in order to process
>>> the works from firmware Work-queue sequentially instead of
>>> create_singlethread_workqueue() API.
>>>
>>> Changes in v1:
>>>     No need to check for backport compatibility in the upstream kernel.
>>> so removing the else section where driver use
>>> create_singlethread_workqueue() API if alloc_ordered_workqueue() API is
>>> not defined, This else section is not required since in the latest upstream
>>> kernel this alloc_ordered_workqueue() API is always defined.
>>>
>>> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
>>> ---
>>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>> index b848458..7e5926c 100644
>>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>> @@ -8085,8 +8085,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>       /* event thread */
>>>       snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
>>>           "fw_event%d", ioc->id);
>>> -     ioc->firmware_event_thread = create_singlethread_workqueue(
>>> -         ioc->firmware_event_name);
>>> +     ioc->firmware_event_thread = alloc_ordered_workqueue(
>>> +         ioc->firmware_event_name, WQ_MEM_RECLAIM);
>>>       if (!ioc->firmware_event_thread) {
>>>               pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
>>>                   ioc->name, __FILE__, __LINE__, __func__);
>>>
>>
>> Hi Sreekanth,
>>
>> Is this change still needed after e09c2c2954684 workqueue: apply
>> __WQ_ORDERED to create_singlethread_workqueue() ?  (3.17+)
> 
> I won't say that it is compulsory required, but I feel it is better if
> these changes are included. since initially we thought that thread
> created by using create_singlethread_workqueue() will process the
> works sequentially but in-between  it has broken and then it is fixed
> by Tejun.  So I thought it is better to directly use the
> alloc_ordered_workqueue() as create_singlethead_workqueue() API also
> invoked the same API.

Ok, I was just wondering if maybe create_singlethread_workqueue was
fixed after this patch was initially written.  Since it's effectively
the same...

Reviewed-by: Joe Lawrence <joe.lawrence@stratus.com>

Regards,

-- Joe
