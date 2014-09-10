From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: Re: [PATCH 08/11] megaraid_sas : Add module parameter to disable
 IRQ-CPU affinity hint
Date: Wed, 10 Sep 2014 20:29:12 +0530
Message-ID: <CAHsXFKEibg9bY2G0GBpN6EKZkH6wc1mOExGk=vnj0xgPdqdTwQ@mail.gmail.com>
References: <201409061328.s86DSAsY013235@palmhbs0.lsi.com>
	<54105D50.1070309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:52756 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaIJO73 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 10:59:29 -0400
Received: by mail-lb0-f178.google.com with SMTP id c11so5243752lbj.23
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 07:59:13 -0700 (PDT)
In-Reply-To: <54105D50.1070309@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Sumit Saxena <Sumit.Saxena@avagotech.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, jbottomley@parallels.com, aradford <aradford@gmail.com>

On Wed, Sep 10, 2014 at 7:46 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 09/06/2014 03:25 PM, Sumit.Saxena@avagotech.com wrote:
>> For certain deployment, we may need to disable irq cpu affinity hint.
>> This module parameter provides option for use to disable irq cpu affinity hint
>> and allow irqbalancer to handle the rest.
>
> Only curious , in which environments causes this which issues?

For few deployment cases where CPU is managed via Cgroup and user
knows how they are going to use their system resources.
For those cases driver hinting may not be useful. For simplicity
customer might like this type of module parameter.

Kashyap

>
> Thanks,
> Tomas
>
>>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_base.c | 60 +++++++++++++++++++------------
>>  1 file changed, 38 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index 07255c1..086beee 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -89,6 +89,10 @@ module_param(resetwaittime, int, S_IRUGO);
>>  MODULE_PARM_DESC(resetwaittime, "Wait time in seconds after I/O timeout "
>>                "before resetting adapter. Default: 180");
>>
>> +int smp_affinity_enable = 1;
>> +module_param(smp_affinity_enable, int, S_IRUGO);
>> +MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disbale Default: enable(1)");
>> +
>>  MODULE_LICENSE("GPL");
>>  MODULE_VERSION(MEGASAS_VERSION);
>>  MODULE_AUTHOR("megaraidlinux@lsi.com");
>> @@ -5160,8 +5164,9 @@ retry_irq_register:
>>                               printk(KERN_DEBUG "megasas: Failed to "
>>                                      "register IRQ for vector %d.\n", i);
>>                               for (j = 0; j < i; j++) {
>> -                                     irq_set_affinity_hint(
>> -                                             instance->msixentry[j].vector, NULL);
>> +                                     if (smp_affinity_enable)
>> +                                             irq_set_affinity_hint(
>> +                                                     instance->msixentry[j].vector, NULL);
>>                                       free_irq(
>>                                               instance->msixentry[j].vector,
>>                                               &instance->irq_context[j]);
>> @@ -5170,11 +5175,14 @@ retry_irq_register:
>>                               instance->msix_vectors = 0;
>>                               goto retry_irq_register;
>>                       }
>> -                     if (irq_set_affinity_hint(instance->msixentry[i].vector,
>> -                             get_cpu_mask(cpu)))
>> -                             dev_err(&instance->pdev->dev, "Error setting"
>> -                                     "affinity hint for cpu %d\n", cpu);
>> -                     cpu = cpumask_next(cpu, cpu_online_mask);
>> +                     if (smp_affinity_enable) {
>> +                             if (irq_set_affinity_hint(instance->msixentry[i].vector,
>> +                                     get_cpu_mask(cpu)))
>> +                                     dev_err(&instance->pdev->dev,
>> +                                             "Error setting affinity hint "
>> +                                             "for cpu %d\n", cpu);
>> +                             cpu = cpumask_next(cpu, cpu_online_mask);
>> +                     }
>>               }
>>       } else {
>>               instance->irq_context[0].instance = instance;
>> @@ -5233,8 +5241,9 @@ retry_irq_register:
>>       instance->instancet->disable_intr(instance);
>>       if (instance->msix_vectors)
>>               for (i = 0; i < instance->msix_vectors; i++) {
>> -                     irq_set_affinity_hint(
>> -                             instance->msixentry[i].vector, NULL);
>> +                     if (smp_affinity_enable)
>> +                             irq_set_affinity_hint(
>> +                                     instance->msixentry[i].vector, NULL);
>>                       free_irq(instance->msixentry[i].vector,
>>                                &instance->irq_context[i]);
>>               }
>> @@ -5397,8 +5406,9 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
>>
>>       if (instance->msix_vectors)
>>               for (i = 0; i < instance->msix_vectors; i++) {
>> -                     irq_set_affinity_hint(
>> -                             instance->msixentry[i].vector, NULL);
>> +                     if (smp_affinity_enable)
>> +                             irq_set_affinity_hint(
>> +                                     instance->msixentry[i].vector, NULL);
>>                       free_irq(instance->msixentry[i].vector,
>>                                &instance->irq_context[i]);
>>               }
>> @@ -5507,8 +5517,9 @@ megasas_resume(struct pci_dev *pdev)
>>                               printk(KERN_DEBUG "megasas: Failed to "
>>                                      "register IRQ for vector %d.\n", i);
>>                               for (j = 0; j < i; j++) {
>> -                                     irq_set_affinity_hint(
>> -                                             instance->msixentry[j].vector, NULL);
>> +                                     if (smp_affinity_enable)
>> +                                             irq_set_affinity_hint(
>> +                                                     instance->msixentry[j].vector, NULL);
>>                                       free_irq(
>>                                               instance->msixentry[j].vector,
>>                                               &instance->irq_context[j]);
>> @@ -5516,11 +5527,14 @@ megasas_resume(struct pci_dev *pdev)
>>                               goto fail_irq;
>>                       }
>>
>> -                     if (irq_set_affinity_hint(instance->msixentry[i].vector,
>> -                             get_cpu_mask(cpu)))
>> -                             dev_err(&instance->pdev->dev, "Error setting"
>> -                                     "affinity hint for cpu %d\n", cpu);
>> -                     cpu = cpumask_next(cpu, cpu_online_mask);
>> +                     if (smp_affinity_enable) {
>> +                             if (irq_set_affinity_hint(instance->msixentry[i].vector,
>> +                                     get_cpu_mask(cpu)))
>> +                                     dev_err(&instance->pdev->dev, "Error "
>> +                                             "setting affinity hint for cpu "
>> +                                             "%d\n", cpu);
>> +                             cpu = cpumask_next(cpu, cpu_online_mask);
>> +                     }
>>               }
>>       } else {
>>               instance->irq_context[0].instance = instance;
>> @@ -5638,8 +5652,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
>>
>>       if (instance->msix_vectors)
>>               for (i = 0; i < instance->msix_vectors; i++) {
>> -                     irq_set_affinity_hint(
>> -                             instance->msixentry[i].vector, NULL);
>> +                     if (smp_affinity_enable)
>> +                             irq_set_affinity_hint(
>> +                                     instance->msixentry[i].vector, NULL);
>>                       free_irq(instance->msixentry[i].vector,
>>                                &instance->irq_context[i]);
>>               }
>> @@ -5727,8 +5742,9 @@ static void megasas_shutdown(struct pci_dev *pdev)
>>       instance->instancet->disable_intr(instance);
>>       if (instance->msix_vectors)
>>               for (i = 0; i < instance->msix_vectors; i++) {
>> -                     irq_set_affinity_hint(
>> -                             instance->msixentry[i].vector, NULL);
>> +                     if (smp_affinity_enable)
>> +                             irq_set_affinity_hint(
>> +                                     instance->msixentry[i].vector, NULL);
>>                       free_irq(instance->msixentry[i].vector,
>>                                &instance->irq_context[i]);
>>               }
>



-- 
Device Driver Developer @ Avagotech
Kashyap D. Desai
Note - my new email address
kashyap.desai@avagotech.com
