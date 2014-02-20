From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 11/22] lpfc: Remove superfluous call to pci_disable_msix()
Date: Thu, 20 Feb 2014 10:16:37 -0500
Message-ID: <53061C55.9060708@emulex.com>
References: <cover.1391512266.git.agordeev@redhat.com> <6341596a5594023854c22f5ab6ad0a439d26d762.1391512266.git.agordeev@redhat.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <6341596a5594023854c22f5ab6ad0a439d26d762.1391512266.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Alexander,

The change is fine - but not really necessary.  The pci_disable_msix() 
call explicitly checks for enablement so it's safe.

It really is a superfluous change - but if James wants to take it:
Acked-by: James Smart  <james.smart@emulex.com>


-- james  s



On 2/4/2014 6:16 AM, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: James Smart <james.smart@emulex.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>   drivers/scsi/lpfc/lpfc_init.c |    9 ++++++---
>   1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 68c94cc..a9df97a 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8078,7 +8078,7 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
>   	if (rc) {
>   		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>   				"0420 PCI enable MSI-X failed (%d)\n", rc);
> -		goto msi_fail_out;
> +		goto vec_fail_out;
>   	}
>   	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
>   		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> @@ -8156,6 +8156,8 @@ irq_fail_out:
>   msi_fail_out:
>   	/* Unconfigure MSI-X capability structure */
>   	pci_disable_msix(phba->pcidev);
> +
> +vec_fail_out:
>   	return rc;
>   }
>   
> @@ -8644,7 +8646,7 @@ enable_msix_vectors:
>   	} else if (rc) {
>   		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>   				"0484 PCI enable MSI-X failed (%d)\n", rc);
> -		goto msi_fail_out;
> +		goto vec_fail_out;
>   	}
>   
>   	/* Log MSI-X vector assignment */
> @@ -8696,9 +8698,10 @@ cfg_fail_out:
>   			 &phba->sli4_hba.fcp_eq_hdl[index]);
>   	}
>   
> -msi_fail_out:
>   	/* Unconfigure MSI-X capability structure */
>   	pci_disable_msix(phba->pcidev);
> +
> +vec_fail_out:
>   	return rc;
>   }
>   
