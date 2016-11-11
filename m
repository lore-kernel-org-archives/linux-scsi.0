From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] megaraid_sas: switch to pci_alloc_irq_vectors
Date: Fri, 11 Nov 2016 15:59:05 +0100
Message-ID: <30690328-e04f-7f41-d2d0-6d05c41b3290@suse.de>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
 <1478857492-4581-2-git-send-email-hare@suse.de>
 <7d5dca7d9f030cb76de03d90a8b02340@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752140AbcKKO7I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 09:59:08 -0500
In-Reply-To: <7d5dca7d9f030cb76de03d90a8b02340@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 11/11/2016 12:32 PM, Sumit Saxena wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Friday, November 11, 2016 3:15 PM
>> To: Martin K. Petersen
>> Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
>> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
>> Subject: [PATCH 1/5] megaraid_sas: switch to pci_alloc_irq_vectors
>>
>> Cleanup the MSI-X handling allowing us to use the PCI-layer provided
> vector
>> allocation.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>> drivers/scsi/megaraid/megaraid_sas.h      |  1 -
>> drivers/scsi/megaraid/megaraid_sas_base.c | 63
> ++++++++++++++-----------------
>> 2 files changed, 29 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>> b/drivers/scsi/megaraid/megaraid_sas.h
>> index ca86c88..8f1d2b4 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
[ .. ]
>> @@ -6163,9 +6153,14 @@ static void megasas_shutdown_controller(struct
>> megasas_instance *instance,
>> 		goto fail_ready_state;
>>
>> 	/* Now re-enable MSI-X */
>> -	if (instance->msix_vectors &&
>> -	    pci_enable_msix_exact(instance->pdev, instance->msixentry,
>> -				  instance->msix_vectors))
>> +	if (instance->msix_vectors)
>> +		irq_flags = PCI_IRQ_MSIX;
>> +	if (smp_affinity_enable)
>> +		irq_flags |= PCI_IRQ_AFFINITY;
>> +	rval = pci_alloc_irq_vectors(instance->pdev, 1,
>> +				     instance->msix_vectors ?
>> +				     instance->msix_vectors : 1,
> irq_flags);
>> +	if (rval < 0)
> If smp_affinity_enable parameter is set to 1(which is default) and legacy
> interrupts are setup, then here driver will pass irq_flags set to
> (PCI_IRQ_LEGACY | PCI_IRQ_AFFINITY) while calling function
> pci_alloc_irq_vectors().
> Should not driver set PCI_IRQ_AFFINITY only for MSI-x interrupts? Setting
> PCI_IRQ_AFFINITY for legacy interrupts may restrict all interrupts
> completion to single CPU(because IRQ affinity will be set) as there will
> be single IRQ for legacy interrupts ?
> 
You are right; irq affinity only makes sense for MSI-X.
I'll be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
