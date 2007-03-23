From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc: add cfg_use_msi test before pci_msi_disable() calls
Date: Fri, 23 Mar 2007 12:56:30 -0400
Message-ID: <460406BE.30806@emulex.com>
References: <200703231332.l2NDWFXq021381@anacortes.austin.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55906 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934290AbXCWRAb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Mar 2007 13:00:31 -0400
In-Reply-To: <200703231332.l2NDWFXq021381@anacortes.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rlary@austin.ibm.com
Cc: linux-scsi@vger.kernel.org

Richard,

When we put this in, the kernel code that we inspected allowed for
the call if msi was not enabled (check on dev->msi_enabled), and did
nothing. Thus, we believed it was in the scope of the interface.
kfree does the same kind of thing. Testing on 2.6.21-rc4 on a machine
w/o MSI also results in no issues/messages.

Also - cfg_use_msi doesn't actually mean that a successful pci_msi_enable
had been performed. To accurately track it, we'll need a flag bit, which
we thought we could avoid based on the interface. I'd prefer to leave it
as is, unless we truly are mistaken about the interface or coding style.
Is your platform replacing the pci functions ?

-- james s


Richard Lary wrote:
> From: Richard Lary <rlary@us.ibm.com>
> 
> This patch adds test for phba->cfg_use_msi
> before calls to pci_msi_disable() to prevent
> calls to this function when pci_msi_enable()
> has not been called.
> 
> Signed-off-by: Richard Lary <rlary@us.ibm.com>
> ---
> 
> Calling pci_msi_disable() when pci_msi_enable()
> has not been previously called results in
> console error message when removing lpfc.
> 
> $ modprobe -r lpfc
> error[-3]: getting the number of MSI interrupts for fibre-channel
> 
> Applies to: 2.6.21-rc4-git5
> 
> Index: b/drivers/scsi/lpfc/lpfc_init.c
> ===================================================================
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1704,7 +1704,8 @@ out_free_irq:
>  	lpfc_stop_timer(phba);
>  	phba->work_hba_events = 0;
>  	free_irq(phba->pcidev->irq, phba);
> -	pci_disable_msi(phba->pcidev);
> +	if (phba->cfg_use_msi)
> +		pci_disable_msi(phba->pcidev);
>  out_free_sysfs_attr:
>  	lpfc_free_sysfs_attr(phba);
>  out_remove_host:
> @@ -1771,7 +1772,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
>  
>  	/* Release the irq reservation */
>  	free_irq(phba->pcidev->irq, phba);
> -	pci_disable_msi(phba->pcidev);
> +	if (phba->cfg_use_msi)
> +		pci_disable_msi(phba->pcidev);
>  
>  	lpfc_cleanup(phba, 0);
>  	lpfc_stop_timer(phba);
> 
