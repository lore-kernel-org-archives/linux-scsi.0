From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH] scsi:NCR5380: remove same check condition in
 NCR5380_select
Date: Thu, 2 Aug 2018 19:32:37 +1200
Message-ID: <928ae07a-8c4a-05fc-16af-48fb6e9c341d@gmail.com>
References: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com>
 <c99a75a2905c1eef50f94ccc0871c36af431e21a.camel@wdc.com>
 <5B627E71.5020600@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B627E71.5020600@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "fthain@telegraphics.com.au" <fthain@telegraphics.com.au>, "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org



Am 02.08.2018 um 15:45 schrieb zhong jiang:
> On 2018/8/2 11:26, Bart Van Assche wrote:
>> On Thu, 2018-08-02 at 11:10 +0800, zhong jiang wrote:
>>> The same check condition is redundant, so remove one of them.
>>>
>>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>>> ---
>>>  drivers/scsi/NCR5380.c | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
>>> index 90ea0f5..2ecaf3f 100644
>>> --- a/drivers/scsi/NCR5380.c
>>> +++ b/drivers/scsi/NCR5380.c
>>> @@ -999,8 +999,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
>>>
>>>  	/* Check for lost arbitration */
>>>  	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
>>> -	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
>>> -	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
>>> +	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask)) {
>>>  		NCR5380_write(MODE_REG, MR_BASE);
>>>  		dsprintk(NDEBUG_ARBITRATION, instance, "lost arbitration, deasserting MR_ARBITRATE\n");
>>>  		spin_lock_irq(&hostdata->lock);
>> Has this patch been tested?
>  I check the issue by doubletest.cocci. Just review the code by myself. Maybe I miss something else.
>  please tell let me know if you any objection.

This redundant load of the ICR has been in the driver code for a long 
time. There's a small chance it is intentional, so at least minimal 
testing might be in order.

Finn - does the ICR_ARBITRATION_LOST bit have to be cleared by a write 
to the mode register? In that case, the first load would have been 
redundant and can be omitted without changing driver behaviour?

Cheers,

	Michael


>
>  Thanks
>  zhong jiang
>> Thanks,
>>
>> Bart.
>>
>>
>>
>
>
