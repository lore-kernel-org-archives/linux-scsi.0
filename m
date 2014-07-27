From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH v2 RESEND 18/23] pm8001: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Date: Sun, 27 Jul 2014 12:29:34 +0200
Message-ID: <CAD+HZHWot_ZZr_+kR6_pKc0bRGFCU_k35RM7TRi=aKeeccsh9w@mail.gmail.com>
References: <cover.1405533479.git.agordeev@redhat.com>
	<9bfa1f22a2a59814a4d520bbcce6eba1b6979b31.1405533479.git.agordeev@redhat.com>
	<20140726083301.GI21129@agordeev.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140726083301.GI21129@agordeev.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, lindar_liu <lindar_liu@usish.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Alex,

Looks Ok for me.
Please feel free to add my:
Reviewed-by: Jack Wang <xjtuwjp@gmail.com>

Thanks,
Jack

2014-07-26 10:33 GMT+02:00 Alexander Gordeev <agordeev@redhat.com>:
> On Wed, Jul 16, 2014 at 08:05:22PM +0200, Alexander Gordeev wrote:
>> As result of deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range()  or pci_enable_msi_exact()
>> and pci_enable_msix_range() or pci_enable_msix_exact()
>> interfaces.
>
> Hi Jack, Lindar,
>
> Could you please review this patch?
>
> Thanks!
>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: xjtuwjp@gmail.com
>> Cc: lindar_liu@usish.com
>> Cc: linux-scsi@vger.kernel.org
>> Cc: linux-pci@vger.kernel.org
>> ---
>>  drivers/scsi/pm8001/pm8001_init.c |   39 +++++++++++++++++++------------------
>>  1 files changed, 20 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
>> index e837ece..4057c24 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -729,34 +729,35 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>>               sizeof(pm8001_ha->msix_entries[0]);
>>       for (i = 0; i < max_entry ; i++)
>>               pm8001_ha->msix_entries[i].entry = i;
>> -     rc = pci_enable_msix(pm8001_ha->pdev, pm8001_ha->msix_entries,
>> +     rc = pci_enable_msix_exact(pm8001_ha->pdev, pm8001_ha->msix_entries,
>>               number_of_intr);
>>       pm8001_ha->number_of_intr = number_of_intr;
>> -     if (!rc) {
>> -             PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
>> -                     "pci_enable_msix request ret:%d no of intr %d\n",
>> -                                     rc, pm8001_ha->number_of_intr));
>> +     if (rc)
>> +             return rc;
>>
>> +     PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
>> +             "pci_enable_msix_exact request ret:%d no of intr %d\n",
>> +                             rc, pm8001_ha->number_of_intr));
>>
>> -             for (i = 0; i < number_of_intr; i++) {
>> -                     snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
>> -                                     DRV_NAME"%d", i);
>> -                     pm8001_ha->irq_vector[i].irq_id = i;
>> -                     pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
>> +     for (i = 0; i < number_of_intr; i++) {
>> +             snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
>> +                             DRV_NAME"%d", i);
>> +             pm8001_ha->irq_vector[i].irq_id = i;
>> +             pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
>>
>> -                     rc = request_irq(pm8001_ha->msix_entries[i].vector,
>> -                             pm8001_interrupt_handler_msix, flag,
>> -                             intr_drvname[i], &(pm8001_ha->irq_vector[i]));
>> -                     if (rc) {
>> -                             for (j = 0; j < i; j++)
>> -                                     free_irq(
>> -                                     pm8001_ha->msix_entries[j].vector,
>> +             rc = request_irq(pm8001_ha->msix_entries[i].vector,
>> +                     pm8001_interrupt_handler_msix, flag,
>> +                     intr_drvname[i], &(pm8001_ha->irq_vector[i]));
>> +             if (rc) {
>> +                     for (j = 0; j < i; j++) {
>> +                             free_irq(pm8001_ha->msix_entries[j].vector,
>>                                       &(pm8001_ha->irq_vector[i]));
>> -                             pci_disable_msix(pm8001_ha->pdev);
>> -                             break;
>>                       }
>> +                     pci_disable_msix(pm8001_ha->pdev);
>> +                     break;
>>               }
>>       }
>> +
>>       return rc;
>>  }
>>  #endif
>> --
>> 1.7.7.6
>>
>
> --
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
