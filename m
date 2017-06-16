From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/11] Fix crash after firmware flash when IO is running.
Date: Fri, 16 Jun 2017 10:01:08 +0200
Message-ID: <38395160-34aa-13e2-ade4-2166e86091c0@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-8-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752134AbdFPIBK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 04:01:10 -0400
In-Reply-To: <20170616055651.9674-8-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> OS crashes after the completion of firmware download.
> 
> Failure in posting SCSI SGL buffers because number of SGL buffers
> is less than total count. Some of the pending IOs are not completed
> by driver. SGL buffers for these IOs are not added back to the list.
> Pending IOs are not completed because lpfc_wq_list list is
> initialized before completion of pending IOs.
> 
> Postpone lpfc_wq_list reinitialization by moving
> lpfc_sli4_queue_destroy() after lpfc_hba_down_post().
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 4f2cc395597e..8de70b9d79dd 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -4303,7 +4303,6 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba)
>  
>  	/* Perform FCoE PCI function reset before freeing queue memory */
>  	rc = lpfc_pci_function_reset(phba);
> -	lpfc_sli4_queue_destroy(phba);
>  
>  	/* Restore PCI cmd register */
>  	pci_write_config_word(phba->pcidev, PCI_COMMAND, cfg_value);
> @@ -4428,6 +4427,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
>  		pci_disable_pcie_error_reporting(phba->pcidev);
>  
>  	lpfc_hba_down_post(phba);
> +	lpfc_sli4_queue_destroy(phba);
>  
>  	return rc;
>  }
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
