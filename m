From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to
 MegaRAID SAS drive
Date: Tue, 12 Oct 2010 17:33:04 +0200
Message-ID: <4CB47FB0.5070207@redhat.com>
References: <AANLkTin53S+C_+QzF-drs5BUAx=k7YeiHrTaQGTFSc_a@mail.gmail.com>	 <4CAF3E04.1050304@redhat.com> <1286555954.2985.110.camel@mulgrave.site> <4CAF70CD.6020307@redhat.com> <4CB0D2AF.7080609@redhat.com> <4B6A08C587958942AA3002690DD4F8C30100F5506B@cosmail02.lsi.com> <4CB30F27.9090009@redhat.com> <4B6A08C587958942AA3002690DD4F8C30100FF9C58@cosmail02.lsi.com> <4CB4709D.7020407@redhat.com> <4B6A08C587958942AA3002690DD4F8C30100FFA030@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab0JLPdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2010 11:33:21 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30100FFA030@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, bo yang <boyang1288@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

On 10/12/2010 04:57 PM, Yang, Bo wrote:
> Tomas,
>
> This change will not be in the part of patch 1/5.  But we can submit another new patch for this change after our testing team did the verification.
>   
I'm fine with every approach.

> Also did you get the chance to look at the patches 2/5 to 5/5?  Just give me the feedback.
>   
I just briefly looked at 2-5/5 and haven't found anything obvious.

> Thanks,
>
> Bo Yang   
>  
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com] 
> Sent: Tuesday, October 12, 2010 10:29 AM
> To: Yang, Bo
> Cc: James Bottomley; bo yang; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Daftardar, Jayant
> Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS drive
>
> On 10/11/2010 05:37 PM, Yang, Bo wrote:
>   
>> Tomas,
>>
>> The reason the driver does flush_scheduled_work() is driver did cancel_delayed_work().  I am not sure driver need to call flush_scheduled_work() if the scheduled work already done, but I will test this changes and submit another patch as soon as it works fine.  
>>   
>>     
> Driver needs to call flush_scheduled_work() because you are adding in this patch a new workqueue:
> INIT_WORK(&instance->work_init, process_fw_state_change_wq); so calling the flush_scheduled_work()
> only if a certain condition is met is the problem. If the condition comes true for both workqueues
> then it would be fine, but I think that it isn't so.
> With this patch we could have a started workqueue (with a long 30 sec sleep) and when the module
> is removed then probably a memory corruption etc. 
>
>
>   
>> This change should not be the part of this patch, we would have the new patch submit after the verification. 
>>   
>>     
> I would prefer to have it in one patch, but if it is for you easier, then do it as you wish.
>
> Tomas
>
>
>   
>> Regards,
>>
>> Bo Yang   
>>  
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com] 
>> Sent: Monday, October 11, 2010 9:21 AM
>> To: Yang, Bo
>> Cc: James Bottomley; bo yang; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
>> Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS drive
>>
>> On 10/11/2010 02:55 PM, Yang, Bo wrote:
>>   
>>     
>>> Tomas,
>>>
>>>   
>>>     
>>>       
>>>> Another correction - flush_scheduled_work is already present in megass_detach_one
>>>> it only should be moved away from the if statement.
>>>>     
>>>>       
>>>>         
>>> The flush_scheduled_work is for schedule_delayed_work().  We need to flush it and remove.
>>>   
>>>     
>>>       
>> I'm not saying it should be removed, I think a move outside from the 'if' block
>> makes it work for ev->hotplug_work and for the newly added instance->work_init
>>
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
>> index 55951f4..7773707 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas.c
>> @@ -4088,9 +4088,9 @@ static void __devexit megasas_detach_one(struct pci_dev *pdev)
>>  		struct megasas_aen_event *ev = instance->ev;
>>  		cancel_delayed_work(
>>  			(struct delayed_work *)&ev->hotplug_work);
>> -		flush_scheduled_work();
>> -		instance->ev = NULL;
>>  	}
>> +	flush_scheduled_work();
>> +	instance->ev = NULL;
>>  
>>  	tasklet_kill(&instance->isr_tasklet);
>>  
>> --
>>
>>   
>>     
>>> -----Original Message-----
>>> From: Tomas Henzl [mailto:thenzl@redhat.com] 
>>> Sent: Saturday, October 09, 2010 4:38 PM
>>> To: James Bottomley
>>> Cc: bo yang; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Yang, Bo
>>> Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS drive
>>>
>>> On 10/08/2010 09:28 PM, Tomas Henzl wrote:
>>>   
>>>     
>>>       
>>>> On 10/08/2010 06:39 PM, James Bottomley wrote:
>>>>   
>>>>     
>>>>       
>>>>         
>>>>> On Fri, 2010-10-08 at 17:51 +0200, Tomas Henzl wrote:
>>>>>   
>>>>>     
>>>>>       
>>>>>         
>>>>>           
>>>>>> On 09/23/2010 04:36 AM, bo yang wrote:
>>>>>>     
>>>>>>       
>>>>>>         
>>>>>>           
>>>>>>             
>>>>>>> This patch is too big.  I am using attachment to submit.  Please
>>>>>>> use attached file to apply.  Also let me know if it can't be accepted.
>>>>>>>
>>>>>>> To add the Online controller reset support, driver need to do:
>>>>>>> a). reset the controller chips -- Xscale and Gen2 which will change
>>>>>>> the function calls and add the reset function related to this two
>>>>>>> chips.
>>>>>>> b). during the reset, driver will store the pending cmds which not
>>>>>>> returned by FW to driver's pending queue.  Driver will re-issue those
>>>>>>> pending cmds again to FW after the OCR finished.
>>>>>>> c). In driver's timeout routine, driver will report to OS as reset.
>>>>>>> Also driver's queue routine will block the cmds until the OCR
>>>>>>> finished.
>>>>>>> d). in Driver's ISR routine, if driver get the FW state as state
>>>>>>> change, FW in Failure status and FW support online controller
>>>>>>> reset (OCR), driver will start to do the controller reset.
>>>>>>> e). In driver's IOCTL routine, the application cmds will wait for the
>>>>>>> OCR to finish, then issue the cmds to FW.
>>>>>>>
>>>>>>> Signed-off-by Bo Yang<bo.yang@lsi.com>
>>>>>>>
>>>>>>> ---
>>>>>>>  drivers/scsi/megaraid/megaraid_sas.c |  756 ++++++++++++++++++++++++++++++++---
>>>>>>>  drivers/scsi/megaraid/megaraid_sas.h |   88 +++-
>>>>>>>  2 files changed, 787 insertions(+), 57 deletions(-)
>>>>>>>       
>>>>>>>         
>>>>>>>           
>>>>>>>             
>>>>>>>               
>>>>>> Hi Bo,
>>>>>> in the workqueue function you sleep for 30s,
>>>>>> it's scheduled here - schedule_work(&instance->work_init);
>>>>>>
>>>>>> +process_fw_state_change_wq(struct work_struct *work)
>>>>>> +{
>>>>>> ...
>>>>>> +		/*waitting for about 20 second before start the second init*/
>>>>>> +		for (wait = 0; wait < 30; wait++) {
>>>>>> +			msleep(1000);
>>>>>> +		}
>>>>>>     
>>>>>>       
>>>>>>         
>>>>>>           
>>>>>>             
>>>>> this lot should be ssleep(20) if you want a 20 sec sleep.
>>>>>   
>>>>>     
>>>>>       
>>>>>         
>>>>>           
>>>> please do that on every place where you use the 
>>>> "for (wait = 0; wait < n; wait++) msleep(1000);" construction
>>>>
>>>>   
>>>>     
>>>>       
>>>>         
>>>>>> - this is not a good practice to sleep for a so long time I think
>>>>>>     
>>>>>>       
>>>>>>         
>>>>>>           
>>>>>>             
>>>> this long sleep might might be ok, if the workqueue is used only rarely
>>>> is it so?
>>>>
>>>>   
>>>>     
>>>>       
>>>>         
>>>>>> - you should use in your exit function some synchronization 
>>>>>>   for example 'cancel_work_sync', without that if someone rmmods your 
>>>>>>   module, it could then lead to a memory corruption
>>>>>>     
>>>>>>       
>>>>>>         
>>>>>>           
>>>>>>             
>>>>> Actually flush_scheduled_work() should be fine ... it will force the
>>>>> module removal to wait for completion ... cancellation can be error
>>>>> prone, so just forcing the wait sounds easier.
>>>>>   
>>>>>     
>>>>>       
>>>>>         
>>>>>           
>>> Another correction - flush_scheduled_work is already present in megass_detach_one
>>> it only should be moved away from the if statement.
>>>
>>>
>>>   
>>>     
>>>       
>>>> someone told that cancel_work_sync is safer then flush_scheduled_work
>>>> but I'm not an expert, so ok 
>>>>
>>>> Tomas
>>>>
>>>>   
>>>>     
>>>>       
>>>>         
>>>>> James
>>>>>
>>>>>
>>>>>         
>>>>>           

