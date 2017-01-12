From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] mpt3sas: switch to pci_alloc_irq_vectors
Date: Thu, 12 Jan 2017 15:20:59 +0100
Message-ID: <a4797f8e-d8db-36aa-839b-6fed7638ae38@suse.de>
References: <1482240421-14847-1-git-send-email-hare@suse.de>
 <CAK=zhgop+tsMMwiYqYVR3CRZ_Br6uW4pgkNXb4LOrs3GUbA8WA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53715 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbdALOVC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 09:21:02 -0500
In-Reply-To: <CAK=zhgop+tsMMwiYqYVR3CRZ_Br6uW4pgkNXb4LOrs3GUbA8WA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 01/12/2017 01:23 PM, Sreekanth Reddy wrote:
> On Tue, Dec 20, 2016 at 6:57 PM, Hannes Reinecke <hare@suse.de> wrote:
>> Cleanup the MSI-X handling allowing us to use
>> the PCI-layer provided vector allocation.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index a1a5ceb..75149f0 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -1129,7 +1129,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>                 /* TMs are on msix_index == 0 */
>>                 if (reply_q->msix_index == 0)
>>                         continue;
>> -               synchronize_irq(reply_q->vector);
>> +               synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
>>         }
>>  }
>>
>> @@ -1818,11 +1818,8 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>
>>         list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
>>                 list_del(&reply_q->list);
>> -               if (smp_affinity_enable) {
>> -                       irq_set_affinity_hint(reply_q->vector, NULL);
>> -                       free_cpumask_var(reply_q->affinity_hint);
>> -               }
>> -               free_irq(reply_q->vector, reply_q);
>> +               free_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index),
>> +                        reply_q);
>>                 kfree(reply_q);
>>         }
>>  }
>> @@ -1831,13 +1828,13 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>   * _base_request_irq - request irq
>>   * @ioc: per adapter object
>>   * @index: msix index into vector table
>> - * @vector: irq vector
>>   *
>>   * Inserting respective reply_queue into the list.
>>   */
>>  static int
>> -_base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
>> +_base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
>>  {
>> +       struct pci_dev *pdev = ioc->pdev;
>>         struct adapter_reply_queue *reply_q;
>>         int r;
>>
>> @@ -1849,14 +1846,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>         }
>>         reply_q->ioc = ioc;
>>         reply_q->msix_index = index;
>> -       reply_q->vector = vector;
>> -
>> -       if (smp_affinity_enable) {
>> -               if (!zalloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL)) {
>> -                       kfree(reply_q);
>> -                       return -ENOMEM;
>> -               }
>> -       }
>>
>>         atomic_set(&reply_q->busy, 0);
>>         if (ioc->msix_enable)
>> @@ -1865,12 +1854,11 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>         else
>>                 snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
>>                     ioc->driver_name, ioc->id);
>> -       r = request_irq(vector, _base_interrupt, IRQF_SHARED, reply_q->name,
>> -           reply_q);
>> +       r = request_irq(pci_irq_vector(pdev, index), _base_interrupt,
>> +                       IRQF_SHARED, reply_q->name, reply_q);
>>         if (r) {
>>                 pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
>> -                   reply_q->name, vector);
>> -               free_cpumask_var(reply_q->affinity_hint);
>> +                      reply_q->name, pci_irq_vector(pdev, index));
>>                 kfree(reply_q);
>>                 return -EBUSY;
>>         }
>> @@ -1892,7 +1880,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>  static void
>>  _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>>  {
>> -       unsigned int cpu, nr_cpus, nr_msix, index = 0;
>> +       unsigned int cpu, nr_msix;
>>         struct adapter_reply_queue *reply_q;
>>
>>         if (!_base_is_controller_msix_enabled(ioc))
>> @@ -1900,38 +1888,21 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>
>>         memset(ioc->cpu_msix_table, 0, ioc->cpu_msix_table_sz);
>>
>> -       nr_cpus = num_online_cpus();
>>         nr_msix = ioc->reply_queue_count = min(ioc->reply_queue_count,
>>                                                ioc->facts.MaxMSIxVectors);
>>         if (!nr_msix)
>>                 return;
>> -
>> -       cpu = cpumask_first(cpu_online_mask);
>> -
>>         list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
>> -
>> -               unsigned int i, group = nr_cpus / nr_msix;
>> -
>> -               if (cpu >= nr_cpus)
>> -                       break;
>> -
>> -               if (index < nr_cpus % nr_msix)
>> -                       group++;
>> -
>> -               for (i = 0 ; i < group ; i++) {
>> -                       ioc->cpu_msix_table[cpu] = index;
>> -                       if (smp_affinity_enable)
>> -                               cpumask_or(reply_q->affinity_hint,
>> -                                  reply_q->affinity_hint, get_cpu_mask(cpu));
>> -                       cpu = cpumask_next(cpu, cpu_online_mask);
>> +               const cpumask_t *mask = pci_irq_get_affinity(ioc->pdev,
>> +                                                     reply_q->msix_index);
>> +               if (!mask) {
>> +                       pr_warn(MPT3SAS_FMT "no affinity for msi %x\n",
>> +                               ioc->name, reply_q->msix_index);
>> +                       continue;
>>                 }
>> -               if (smp_affinity_enable)
>> -                       if (irq_set_affinity_hint(reply_q->vector,
>> -                                          reply_q->affinity_hint))
>> -                               dinitprintk(ioc, pr_info(MPT3SAS_FMT
>> -                                "Err setting affinity hint to irq vector %d\n",
>> -                                ioc->name, reply_q->vector));
>> -               index++;
>> +
>> +               for_each_cpu(cpu, mask)
>> +                       ioc->cpu_msix_table[cpu] = reply_q->msix_index;
>>         }
>>  }
>>
>
> When PCI_IRQ_AFFINITY is not enabled (suppose when
> 'smp_affinity_enable' module parameter is disabled) while allocation
> MSI-X vectors then I observe that only one MSI-X vector (that too zero
> msix indexed vector) is used and remaining MSI-X won't be used at all.
> Since here cpu_msix_table is not populated and it was just initialized
> to zero. So only zero msix indexed MSI-X vector is used for IOs.
>
> Apart from this, This patch looks good.
>
Okay, I've fixed things up and send a new version.
Please test with that and check if the problems are fixed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
