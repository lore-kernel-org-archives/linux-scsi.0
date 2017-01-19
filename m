From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 04/17] lpfc: NVME Initiator: Base modifications Part C
Date: Wed, 18 Jan 2017 18:54:37 -0800
Message-ID: <784acc16-b284-6159-4399-dfd39ae1a8bd@gmail.com>
References: <587ec2ef.Y/y2qvlPHm64sAst%jsmart2021@gmail.com>
 <20170118110304.GD3514@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33847 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdASDEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 22:04:49 -0500
Received: by mail-oi0-f65.google.com with SMTP id w144so2278730oiw.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2017 19:03:47 -0800 (PST)
In-Reply-To: <20170118110304.GD3514@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org



On 1/18/2017 3:03 AM, Johannes Thumshirn wrote:
>
>> +	/* maximum number of xris available for nvme buffers */
>> +	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
>> +	phba->sli4_hba.nvme_xri_max = phba->sli4_hba.max_cfg_param.max_xri -
>> +				      els_xri_cnt;
>> +	phba->sli4_hba.nvme_xri_max -= phba->sli4_hba.scsi_xri_max;
> 	nvme_xri_max = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
> 	nvme_xri_max -= phba->sli4_hba.scsi_xri_max;
> 	phba->sli4_hba.nvme_xri_max = nvme_xri_max;
>
> Low hanging anti line-break fruit.

ok - but I didn't think that a style change like this is a mandate.   As 
I'm addressing your other comments, I'll do so.


>>   		}
>> @@ -4273,13 +4489,13 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
>>   			sprintf(message, "Unqualified optics - Replace with "
>>   				"Avago optics for Warranty and Technical "
> Is Avago still correct, or should it read Broadcom?

It's right - Avago.


>> @@ -4854,17 +5070,20 @@ static int
>>   lpfc_enable_pci_dev(struct lpfc_hba *phba)
>>   {
>>   	struct pci_dev *pdev;
>> +	int bars = 0;
>>   
>>   	/* Obtain PCI device reference */
>>   	if (!phba->pcidev)
>>   		goto out_error;
>>   	else
>>   		pdev = phba->pcidev;
>> +	/* Select PCI BARs */
>> +	bars = pci_select_bars(pdev, IORESOURCE_MEM);
>>   	/* Enable PCI device */
>>   	if (pci_enable_device_mem(pdev))
>>   		goto out_error;
>>   	/* Request PCI resource for the device */
>> -	if (pci_request_mem_regions(pdev, LPFC_DRIVER_NAME))
>> +	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
>>   		goto out_disable_device;
>>   	/* Set up device as PCI master and save state for EEH */
>>   	pci_set_master(pdev);
>> @@ -4881,7 +5100,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>>   	pci_disable_device(pdev);
>>   out_error:
>>   	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>> -			"1401 Failed to enable pci device\n");
>> +			"1401 Failed to enable pci device, bars:x%x\n", bars);
>>   	return -ENODEV;
>>   }
> I don't get this change. pci_request_mem_regions does
>
> pci_request_selected_regions(pdev,
> 		pci_select_bars(pdev, IORESOURCE_MEM), name);
>
> if you want to have the bars in the error log please do:
>    	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> 			"1401 Failed to enable pci device, bars:x%x\n",
> 			pci_select_regions(pdev, IORESOURCE_MEM));

I agree - this is weird.  I'll track why it was ever changed and address it.

Other comments are good. I'll address them.

-- james

