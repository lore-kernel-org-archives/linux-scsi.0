From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH] scsi: pm8001: clean up structurally dead code when
 PM8001_USE_MSIX is defined (part2)
Date: Sat, 30 Mar 2019 02:30:44 +0530
Message-ID: <2b2ad873-2303-62de-55cd-f63cc31a78b9@codeaurora.org>
References: <20190329153221.29238-1-colin.king@canonical.com>
 <0c08b258-e61d-60ee-7702-728fa96c435d@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0c08b258-e61d-60ee-7702-728fa96c435d@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 3/30/2019 1:38 AM, Mukesh Ojha wrote:
>
> On 3/29/2019 9:02 PM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> When macro PM8001_USE_MSIX is defined there is redundant dead code
>> call to pm8001_cr32.  Clean this up for the defined PM8001_USE_MSIX and
>> undefined PM8001_USE_MSIX cases.
>>
>> Also rename the functions pm8001_chip_is_our_interupt,
>> pm80xx_chip_is_our_interupt and function pointer is_our_interrupt
>> to fix spelling mistakes.
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>
> It would be better if you could split this into two patch, one for 
> dead code and other for renaming.

Also, What is that part2 in the subject ? please remove that too.


>
>
> Otherwise change looks good.
>
> Once you fix above you could include .
> Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
>
> Cheers,
> -Mukesh
>
>
>> ---
>>   drivers/scsi/pm8001/pm8001_hwi.c  | 11 ++++++-----
>>   drivers/scsi/pm8001/pm8001_init.c |  4 ++--
>>   drivers/scsi/pm8001/pm8001_sas.h  |  2 +-
>>   drivers/scsi/pm8001/pm80xx_hwi.c  | 11 ++++++-----
>>   4 files changed, 15 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c 
>> b/drivers/scsi/pm8001/pm8001_hwi.c
>> index e4209091c1da..627075d00918 100644
>> --- a/drivers/scsi/pm8001/pm8001_hwi.c
>> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
>> @@ -4623,17 +4623,18 @@ static int pm8001_chip_phy_ctl_req(struct 
>> pm8001_hba_info *pm8001_ha,
>>       return ret;
>>   }
>>   -static u32 pm8001_chip_is_our_interupt(struct pm8001_hba_info 
>> *pm8001_ha)
>> +static u32 pm8001_chip_is_our_interrupt(struct pm8001_hba_info 
>> *pm8001_ha)
>>   {
>> -    u32 value;
>>   #ifdef PM8001_USE_MSIX
>>       return 1;
>> -#endif
>> +#else
>> +    u32 value;
>> +
>>       value = pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
>>       if (value)
>>           return 1;
>>       return 0;
>> -
>> +#endif
>>   }
>>     /**
>> @@ -5119,7 +5120,7 @@ const struct pm8001_dispatch 
>> pm8001_8001_dispatch = {
>>       .chip_rst        = pm8001_hw_chip_rst,
>>       .chip_iounmap        = pm8001_chip_iounmap,
>>       .isr            = pm8001_chip_isr,
>> -    .is_our_interupt    = pm8001_chip_is_our_interupt,
>> +    .is_our_interrupt    = pm8001_chip_is_our_interrupt,
>>       .isr_process_oq        = process_oq,
>>       .interrupt_enable     = pm8001_chip_interrupt_enable,
>>       .interrupt_disable    = pm8001_chip_interrupt_disable,
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c 
>> b/drivers/scsi/pm8001/pm8001_init.c
>> index a36060c23b37..3374f553c617 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -201,7 +201,7 @@ static irqreturn_t 
>> pm8001_interrupt_handler_msix(int irq, void *opaque)
>>         if (unlikely(!pm8001_ha))
>>           return IRQ_NONE;
>> -    if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
>> +    if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
>>           return IRQ_NONE;
>>   #ifdef PM8001_USE_TASKLET
>> tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id]);
>> @@ -224,7 +224,7 @@ static irqreturn_t 
>> pm8001_interrupt_handler_intx(int irq, void *dev_id)
>>       pm8001_ha = sha->lldd_ha;
>>       if (unlikely(!pm8001_ha))
>>           return IRQ_NONE;
>> -    if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
>> +    if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
>>           return IRQ_NONE;
>>     #ifdef PM8001_USE_TASKLET
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.h 
>> b/drivers/scsi/pm8001/pm8001_sas.h
>> index f88b0d33c385..ac6d8e3f22de 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.h
>> +++ b/drivers/scsi/pm8001/pm8001_sas.h
>> @@ -197,7 +197,7 @@ struct pm8001_dispatch {
>>       int (*chip_ioremap)(struct pm8001_hba_info *pm8001_ha);
>>       void (*chip_iounmap)(struct pm8001_hba_info *pm8001_ha);
>>       irqreturn_t (*isr)(struct pm8001_hba_info *pm8001_ha, u8 vec);
>> -    u32 (*is_our_interupt)(struct pm8001_hba_info *pm8001_ha);
>> +    u32 (*is_our_interrupt)(struct pm8001_hba_info *pm8001_ha);
>>       int (*isr_process_oq)(struct pm8001_hba_info *pm8001_ha, u8 vec);
>>       void (*interrupt_enable)(struct pm8001_hba_info *pm8001_ha, u8 
>> vec);
>>       void (*interrupt_disable)(struct pm8001_hba_info *pm8001_ha, u8 
>> vec);
>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c 
>> b/drivers/scsi/pm8001/pm80xx_hwi.c
>> index 536d2b4384f8..301de40eb708 100644
>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>> @@ -4617,17 +4617,18 @@ static int pm80xx_chip_phy_ctl_req(struct 
>> pm8001_hba_info *pm8001_ha,
>>       return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, 
>> &payload, 0);
>>   }
>>   -static u32 pm80xx_chip_is_our_interupt(struct pm8001_hba_info 
>> *pm8001_ha)
>> +static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info 
>> *pm8001_ha)
>>   {
>> -    u32 value;
>>   #ifdef PM8001_USE_MSIX
>>       return 1;
>> -#endif
>> +#else
>> +    u32 value;
>> +
>>       value = pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
>>       if (value)
>>           return 1;
>>       return 0;
>> -
>> +#endif
>>   }
>>     /**
>> @@ -4724,7 +4725,7 @@ const struct pm8001_dispatch 
>> pm8001_80xx_dispatch = {
>>       .chip_rst        = pm80xx_hw_chip_rst,
>>       .chip_iounmap        = pm8001_chip_iounmap,
>>       .isr            = pm80xx_chip_isr,
>> -    .is_our_interupt    = pm80xx_chip_is_our_interupt,
>> +    .is_our_interrupt    = pm80xx_chip_is_our_interrupt,
>>       .isr_process_oq        = process_oq,
>>       .interrupt_enable    = pm80xx_chip_interrupt_enable,
>>       .interrupt_disable    = pm80xx_chip_interrupt_disable,
