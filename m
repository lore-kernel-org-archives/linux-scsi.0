From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Thu, 21 Aug 2014 13:58:39 +0200
Message-ID: <53F5DEEF.4070406@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com> <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com> <53F5D8DF.4060705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <53F5D8DF.4060705@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/21/2014 01:32 PM, Tomas Henzl wrote:
> On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
>> As result of deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range()  or pci_enable_msi_exact()
>> and pci_enable_msix_range() or pci_enable_msix_exact()
>> interfaces.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: James Smart <james.smart@emulex.com>
>> Cc: linux-scsi@vger.kernel.org
>> Cc: linux-pci@vger.kernel.org
>> ---
>>  drivers/scsi/lpfc/lpfc_init.c | 39 +++++++++++++++++----------------------
>>  1 file changed, 17 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
>> index a5769a9..37f2a20 100644
>> --- a/drivers/scsi/lpfc/lpfc_init.c
>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>> @@ -8211,9 +8211,9 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
>>   * @phba: pointer to lpfc hba data structure.
>>   *
>>   * This routine is invoked to enable the MSI-X interrupt vectors to device
>> - * with SLI-3 interface specs. The kernel function pci_enable_msix() is
>> - * called to enable the MSI-X vectors. Note that pci_enable_msix(), once
>> - * invoked, enables either all or nothing, depending on the current
>> + * with SLI-3 interface specs. The kernel function pci_enable_msix_exact()
>> + * is called to enable the MSI-X vectors. Note that pci_enable_msix_exact(),
>> + * once invoked, enables either all or nothing, depending on the current
>>   * availability of PCI vector resources. The device driver is responsible
>>   * for calling the individual request_irq() to register each MSI-X vector
>>   * with a interrupt handler, which is done in this function. Note that
>> @@ -8237,8 +8237,8 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
>>  		phba->msix_entries[i].entry = i;
>>  
>>  	/* Configure MSI-X capability structure */
>> -	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
>> -				ARRAY_SIZE(phba->msix_entries));
>> +	rc = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
>> +				   LPFC_MSIX_VECTORS);
>>  	if (rc) {
>>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>>  				"0420 PCI enable MSI-X failed (%d)\n", rc);
> Hi Alexander 
>
> the code continues with:
> goto ->  pci_disable_msix(phba->pcidev);
> that call to disable_msix is also superfluous I think
> shouldn't that be fixed too?
> the same is also in lpfc_sli4_enable_msix
>
> Tomas

my bad, this was already fixed in
commit 029165acfa611a3a8838723f6978586ae35ff53d lpfc: Remove superfluous call to pci_disable_msix()

so patch looks good to me now

Reviewed-by: Tomas Henzl

>
>> @@ -8775,16 +8775,14 @@ out:
>>   * @phba: pointer to lpfc hba data structure.
>>   *
>>   * This routine is invoked to enable the MSI-X interrupt vectors to device
>> - * with SLI-4 interface spec. The kernel function pci_enable_msix() is called
>> - * to enable the MSI-X vectors. Note that pci_enable_msix(), once invoked,
>> - * enables either all or nothing, depending on the current availability of
>> - * PCI vector resources. The device driver is responsible for calling the
>> - * individual request_irq() to register each MSI-X vector with a interrupt
>> - * handler, which is done in this function. Note that later when device is
>> - * unloading, the driver should always call free_irq() on all MSI-X vectors
>> - * it has done request_irq() on before calling pci_disable_msix(). Failure
>> - * to do so results in a BUG_ON() and a device will be left with MSI-X
>> - * enabled and leaks its vectors.
>> + * with SLI-4 interface spec. The kernel function pci_enable_msix_range()
>> + * is called to enable the MSI-X vectors. The device driver is responsible
>> + * for calling the individual request_irq() to register each MSI-X vector
>> + * with a interrupt handler, which is done in this function. Note that
>> + * later when device is unloading, the driver should always call free_irq()
>> + * on all MSI-X vectors it has done request_irq() on before calling
>> + * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
>> + * will be left with MSI-X enabled and leaks its vectors.
>>   *
>>   * Return codes
>>   * 0 - successful
>> @@ -8805,17 +8803,14 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
>>  		phba->sli4_hba.msix_entries[index].entry = index;
>>  		vectors++;
>>  	}
>> -enable_msix_vectors:
>> -	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
>> -			     vectors);
>> -	if (rc > 1) {
>> -		vectors = rc;
>> -		goto enable_msix_vectors;
>> -	} else if (rc) {
>> +	rc = pci_enable_msix_range(phba->pcidev, phba->sli4_hba.msix_entries,
>> +				   2, vectors);
>> +	if (rc < 0) {
>>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>>  				"0484 PCI enable MSI-X failed (%d)\n", rc);
>>  		goto vec_fail_out;
>>  	}
>> +	vectors = rc;
>>  
>>  	/* Log MSI-X vector assignment */
>>  	for (index = 0; index < vectors; index++)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
