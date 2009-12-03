From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/1] lpfc causes hang on SGI ia64 platform
Date: Thu, 03 Dec 2009 12:02:48 -0600
Message-ID: <4B17FD48.60005@sgi.com>
References: <4AB3BD0D.8090902@sgi.com> <4AB3CFC0.7010906@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:45208 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753207AbZLCSCn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2009 13:02:43 -0500
In-Reply-To: <4AB3CFC0.7010906@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>

Hi James (and James),

This patch does not yet appear to have been integrated.

Mike



James Smart wrote:
> Looks good Mike.
> 
> 
> Acked-by: James Smart <james.smart@emulex.com>
> 
> -- james s
> 
> Michael Reed wrote:
>> In testing 2.6.31 on one of our ia64 platforms I've encountered a hang
>> due to the driver using hardware ATEs which are a limited resource.
>> This is because the driver does not set the dma consistent mask to
>> 64 bits.
>>
>> Here's a patch against 2.6.31 which addresses the issue.
>>
>> Signed-off-by: Michael Reed <mdr@sgi.com>
>>
>>
>> --- linux-2.6.31-kdb/drivers/scsi/lpfc/lpfc_init.c	2009-09-09 17:13:59.000000000 -0500
>> +++ linux-2.6.31-kdb-modified/drivers/scsi/lpfc/lpfc_init.c	2009-09-11 14:46:34.894488062 -0500
>> @@ -4355,9 +4355,13 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *
>>  		pdev = phba->pcidev;
>>  
>>  	/* Set the device DMA mask size */
>> -	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)
>> -		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
>> +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0
>> +	 || pci_set_consistent_dma_mask(pdev,DMA_BIT_MASK(64)) != 0) {
>> +		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0
>> +		 || pci_set_consistent_dma_mask(pdev,DMA_BIT_MASK(32)) != 0) {
>>  			return error;
>> +		}
>> +	}
>>  
>>  	/* Get the bus address of Bar0 and Bar2 and the number of bytes
>>  	 * required by each mapping.
>> @@ -5911,9 +5915,13 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba
>>  		pdev = phba->pcidev;
>>  
>>  	/* Set the device DMA mask size */
>> -	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)
>> -		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
>> +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0
>> +	 || pci_set_consistent_dma_mask(pdev,DMA_BIT_MASK(64)) != 0) {
>> +		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0
>> +		 || pci_set_consistent_dma_mask(pdev,DMA_BIT_MASK(32)) != 0) {
>>  			return error;
>> +		}
>> +	}
>>  
>>  	/* Get the bus address of SLI4 device Bar0, Bar1, and Bar2 and the
>>  	 * number of bytes required by each mapping. They are actually
>>
>>
>>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
