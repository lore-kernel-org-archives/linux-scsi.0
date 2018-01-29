From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/19] lpfc: move placement of target destroy on driver
 detach
Date: Mon, 29 Jan 2018 08:54:46 +0100
Message-ID: <57deb019-a7d8-3137-bed7-dd642fdf21e4@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-4-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbeA2KXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:23:46 -0500
In-Reply-To: <20180124224548.9530-4-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> Ensure nvme localports/targetports are torn down before
> dismantling the adapter sli interface on driver detachment.
> This aids leaving interfaces live while nvme may be making
> callbacks to abort it.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 5b96bf0d3331..851d4e889042 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -11503,13 +11503,6 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
>  	/* Remove FC host and then SCSI host with the physical port */
>  	fc_remove_host(shost);
>  	scsi_remove_host(shost);
> -	/*
> -	 * Bring down the SLI Layer. This step disables all interrupts,
> -	 * clears the rings, discards all mailbox commands, and resets
> -	 * the HBA FCoE function.
> -	 */
> -	lpfc_debugfs_terminate(vport);
> -	lpfc_sli4_hba_unset(phba);
>  
>  	/* Perform ndlp cleanup on the physical port.  The nvme and nvmet
>  	 * localports are destroyed after to cleanup all transport memory.
> @@ -11518,6 +11511,13 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
>  	lpfc_nvmet_destroy_targetport(phba);
>  	lpfc_nvme_destroy_localport(vport);
>  
> +	/*
> +	 * Bring down the SLI Layer. This step disables all interrupts,
> +	 * clears the rings, discards all mailbox commands, and resets
> +	 * the HBA FCoE function.
> +	 */
> +	lpfc_debugfs_terminate(vport);
> +	lpfc_sli4_hba_unset(phba);
>  
>  	lpfc_stop_hba_timers(phba);
>  	spin_lock_irq(&phba->hbalock);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
