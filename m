From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH RESUBMIT 3/3] lpfc: remove unnecessary read of PCI_CAP_ID_EXP
Date: Wed, 15 Aug 2012 09:55:34 -0400
Message-ID: <502BAA56.20909@emulex.com>
References: <1341957477-30946-1-git-send-email-jdmason@kudzu.us> <1341957477-30946-4-git-send-email-jdmason@kudzu.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:54908 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2HONzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2012 09:55:37 -0400
In-Reply-To: <1341957477-30946-4-git-send-email-jdmason@kudzu.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Mason <jdmason@kudzu.us>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Acked-By:  James Smart <james.smart@emulex.com>

-- james


On 7/10/2012 5:57 PM, Jon Mason wrote:
> The PCIE capability offset is saved during PCI bus walking.  It will
> remove an unnecessary search in the PCI configuration space if this
> value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
> better way of determining if the device is PCIE or not (as it uses the
> same saved PCIE capability offset).
>
> Signed-off-by: Jon Mason <jdmason@kudzu.us>
> Cc: James Smart <james.smart@emulex.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 411ed48..f30b3d2 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4253,7 +4253,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>   	pci_save_state(pdev);
>   
>   	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
> -	if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
> +	if (pci_is_pcie(pdev))
>   		pdev->needs_freset = 1;
>   
>   	return 0;

