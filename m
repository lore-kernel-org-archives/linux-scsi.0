From: James Smart <james.smart@emulex.com>
Subject: Warning: qla4xxx/qla2xxx/lpfc   : removal of PCI_CAP_ID_EXP
Date: Fri, 1 Jul 2011 10:48:53 -0400
Message-ID: <3ad06450-f7bc-4367-88de-615c530054e2@exht1.ad.emulex.com>
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us> <4E0CDF8B.3020505@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:32425 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756804Ab1GAOtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2011 10:49:18 -0400
In-Reply-To: <4E0CDF8B.3020505@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: James Smart <james.smart@emulex.com>, Jon Mason <jdmason@kudzu.us>, Richard Lary <rlary@us.ibm.com>, Ravi Anand <ravi.anand@qlogic.com>, vikas.chaudhary@qlogic.com, iscsi-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>

All,

I wanted to communicate a potential warning to those drivers that had a patch 
submitted to replace config space searches of PCI_CAP_ID_EXP with shorthand 
options such as is_pcie and pci_is_pcie().

Testing with the lpfc driver and AER/EEH identified cases where the short-hand 
search options would fail on PPC platforms.  The only successful option in all 
cases was the explicit search via PCI_CAP_ID_EXP.   Therefore, I recommend 
that this change not be accepted until the platform level issue can be 
identified and corrected.

-- james s



On 6/30/2011 4:41 PM, James Smart wrote:
> Jon,
>
> I must NACK this patch to the lpfc driver and recommend that all other patches
> which replace pci_find_capability(pdef, PCI_CAP_ID_EXP) with
> "pci_is_pcie(pdev)" are NACK'd as well.
>
> The reason is due to an issue on PPC platforms whereby use of "pdev->is_pcie"
> and pci_is_pcie() will erroneously fail under some conditions, but explicit
> search for the capability struct via pci_find_capability() is always
> successful.   I expect this to be due a shadowing of pci config space in the
> hal/platform that isn't sufficiently built up.  We detected this issue while
> testing AER/EEH, and are functional only if the pci_find_capability() option
> is used.
>
> -- james s
>
>
>
> On 6/27/2011 1:39 PM, Jon Mason wrote:
>> The PCIE capability offset is saved during PCI bus walking.  It will
>> remove an unnecessary search in the PCI configuration space if this
>> value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
>> better way of determining if the device is PCIE or not (as it uses the
>> same saved PCIE capability offset).
>>
>> Signed-off-by: Jon Mason<jdmason@kudzu.us>
>> ---
>>    drivers/scsi/lpfc/lpfc_init.c |    2 +-
>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
>> index 148b98d..9000ad0 100644
>> --- a/drivers/scsi/lpfc/lpfc_init.c
>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>> @@ -3970,7 +3970,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>>    	pci_save_state(pdev);
>>
>>    	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
>> -	if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
>> +	if (pci_is_pcie(pdev))
>>    		pdev->needs_freset = 1;
>>
>>    	return 0;

