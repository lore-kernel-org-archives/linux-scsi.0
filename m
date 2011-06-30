From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 03/19] lpfc: remove unnecessary read of PCI_CAP_ID_EXP
Date: Thu, 30 Jun 2011 16:41:47 -0400
Message-ID: <4E0CDF8B.3020505@emulex.com>
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:22472 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751115Ab1F3UmM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2011 16:42:12 -0400
In-Reply-To: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Mason <jdmason@kudzu.us>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Richard Lary <rlary@us.ibm.com>

Jon,

I must NACK this patch to the lpfc driver and recommend that all other patches 
which replace pci_find_capability(pdef, PCI_CAP_ID_EXP) with 
"pci_is_pcie(pdev)" are NACK'd as well.

The reason is due to an issue on PPC platforms whereby use of "pdev->is_pcie" 
and pci_is_pcie() will erroneously fail under some conditions, but explicit 
search for the capability struct via pci_find_capability() is always 
successful.   I expect this to be due a shadowing of pci config space in the 
hal/platform that isn't sufficiently built up.  We detected this issue while 
testing AER/EEH, and are functional only if the pci_find_capability() option 
is used.

-- james s



On 6/27/2011 1:39 PM, Jon Mason wrote:
> The PCIE capability offset is saved during PCI bus walking.  It will
> remove an unnecessary search in the PCI configuration space if this
> value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
> better way of determining if the device is PCIE or not (as it uses the
> same saved PCIE capability offset).
>
> Signed-off-by: Jon Mason<jdmason@kudzu.us>
> ---
>   drivers/scsi/lpfc/lpfc_init.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 148b98d..9000ad0 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3970,7 +3970,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>   	pci_save_state(pdev);
>
>   	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
> -	if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
> +	if (pci_is_pcie(pdev))
>   		pdev->needs_freset = 1;
>
>   	return 0;
