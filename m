From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] aacraid: switch to pci_alloc_irq_vectors
Date: Wed, 16 Nov 2016 08:36:57 +0100
Message-ID: <92bffeba-90cd-513e-6a01-8d7b5e8ec328@suse.de>
References: <1478589090-74217-1-git-send-email-hare@suse.de>
 <4D8E82A446BF54499747901DBDEB737A573F569D@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33429 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752058AbcKPHhA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Nov 2016 02:37:00 -0500
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A573F569D@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>

On 11/15/2016 08:33 PM, Raghava Aditya Renukunta wrote:
> Hi Hannes,
> Thank you for the patch
> 
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Monday, November 7, 2016 11:12 PM
>> To: Martin K. Petersen
>> Cc: Christoph Hellwig; James Bottomley; linux-scsi@vger.kernel.org; Hannes
>> Reinecke; Hannes Reinecke; dl-esc-Aacraid Linux Driver
>> Subject: [PATCH] aacraid: switch to pci_alloc_irq_vectors
>>
>> EXTERNAL EMAIL
>>
>>
>> Use pci_alloc_irq_vectors and drop the hand-crafted
>> interrupt affinity routines.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
>> ---
>>  drivers/scsi/aacraid/aacraid.h  |  1 -
>>  drivers/scsi/aacraid/comminit.c | 10 +++-------
>>  drivers/scsi/aacraid/commsup.c  | 25 +++++--------------------
>>  drivers/scsi/aacraid/linit.c    | 20 ++++----------------
>>  4 files changed, 12 insertions(+), 44 deletions(-)
>>
>> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
>> index 969c312..f059c14 100644
>> --- a/drivers/scsi/aacraid/aacraid.h
>> +++ b/drivers/scsi/aacraid/aacraid.h
>> @@ -1246,7 +1246,6 @@ struct aac_dev
>>         u32                     max_msix;       /* max. MSI-X vectors */
>>         u32                     vector_cap;     /* MSI-X vector capab.*/
>>         int                     msi_enabled;    /* MSI/MSI-X enabled */
>> -       struct msix_entry       msixentry[AAC_MAX_MSIX];
>>         struct aac_msix_ctx     aac_msix[AAC_MAX_MSIX]; /* context */
>>         u8                      adapter_shutdown;
>>         u32                     handle_pci_error;
>> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
>> index 341ea32..4f56b10 100644
>> --- a/drivers/scsi/aacraid/comminit.c
>> +++ b/drivers/scsi/aacraid/comminit.c
>> @@ -378,16 +378,12 @@ void aac_define_int_mode(struct aac_dev *dev)
>>         if (msi_count > AAC_MAX_MSIX)
>>                 msi_count = AAC_MAX_MSIX;
>>
>> -       for (i = 0; i < msi_count; i++)
>> -               dev->msixentry[i].entry = i;
>> -
>>         if (msi_count > 1 &&
>>             pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
>>                 min_msix = 2;
>> -               i = pci_enable_msix_range(dev->pdev,
>> -                                   dev->msixentry,
>> -                                   min_msix,
>> -                                   msi_count);
>> +               i = pci_alloc_irq_vectors(dev->pdev,
>> +                                         min_msix, msi_count,
>> +                                         PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
>>                 if (i > 0) {
>>                         dev->msi_enabled = 1;
>>                         msi_count = i;
>> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
>> index 0aeecec..9e7551f 100644
>> --- a/drivers/scsi/aacraid/commsup.c
>> +++ b/drivers/scsi/aacraid/commsup.c
>> @@ -2043,30 +2043,22 @@ int aac_acquire_irq(struct aac_dev *dev)
>>         int i;
>>         int j;
>>         int ret = 0;
>> -       int cpu;
>>
>> -       cpu = cpumask_first(cpu_online_mask);
>>         if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
>>                 for (i = 0; i < dev->max_msix; i++) {
>>                         dev->aac_msix[i].vector_no = i;
>>                         dev->aac_msix[i].dev = dev;
>> -                       if (request_irq(dev->msixentry[i].vector,
>> +                       if (request_irq(pci_irq_vector(dev->pdev, i),
>>                                         dev->a_ops.adapter_intr,
>>                                         0, "aacraid", &(dev->aac_msix[i]))) {
>>                                 printk(KERN_ERR "%s%d: Failed to register IRQ for vector
>> %d.\n",
>>                                                 dev->name, dev->id, i);
>>                                 for (j = 0 ; j < i ; j++)
>> -                                       free_irq(dev->msixentry[j].vector,
>> +                                       free_irq(pci_irq_vector(dev->pdev, j),
>>                                                  &(dev->aac_msix[j]));
>>                                 pci_disable_msix(dev->pdev);
>>                                 ret = -1;
>>                         }
>> -                       if (irq_set_affinity_hint(dev->msixentry[i].vector,
>> -                                                       get_cpu_mask(cpu))) {
>> -                               printk(KERN_ERR "%s%d: Failed to set IRQ affinity for cpu
>> %d\n",
>> -                                           dev->name, dev->id, cpu);
>> -                       }
>> -                       cpu = cpumask_next(cpu, cpu_online_mask);
> 
> Is there a reason why the irq_set_affinity_hint was removed? Will the PCI_IRQ_AFFINITY flag enable hints?
> 
Precisely.
Setting the PCI_IRQ_AFFINITY flag will instruct the PCI subsystem to set
the interrupt affinity.
It will take the physical layout of CPU cores into account, so the
results will be far better matched to the actual system.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
