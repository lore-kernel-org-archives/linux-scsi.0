From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/17] lpfc: NVME Initiator: Base modifications Part E
Date: Wed, 18 Jan 2017 08:34:21 +0100
Message-ID: <cefa5f07-a3f3-c5dc-2d3a-ddd410d1ffa4@suse.de>
References: <587ec2f1.pGgoAJWGU6FWMEv6%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32781 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751396AbdARJY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 04:24:26 -0500
In-Reply-To: <587ec2f1.pGgoAJWGU6FWMEv6%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part E of parts A..F.
> 
> Part E is limited to lpfc_sli.c. This is the location of most of changes
> for the following:
> - sli3 ring vs sli4 wq splits
> - io abort interfaces
> - actual queuing routines and use of dma and sgl pools
> - service routines to create/delete queues
> 
> *********
> 
> Refer to Part A for a description of base modifications
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 1508 ++++++++++++++++++++++++++++++------------
>  1 file changed, 1093 insertions(+), 415 deletions(-)
> 
[ .. ]
> @@ -3696,6 +3740,51 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
>  }
>  
>  /**
> + * lpfc_sli_flush_nvme_rings - flush all wqes in the nvme rings
> + * @phba: Pointer to HBA context object.
> + *
> + * This function flushes all wqes in the nvme rings and frees all resources
> + * in the txcmplq. This function does not issue abort wqes for the IO
> + * commands in txcmplq, they will just be returned with
> + * IOERR_SLI_DOWN. This function is invoked with EEH when device's PCI
> + * slot has been permanently disabled.
> + **/
> +void
> +lpfc_sli_flush_nvme_rings(struct lpfc_hba *phba)
> +{
> +	LIST_HEAD(txcmplq);
> +	struct lpfc_sli_ring  *pring;
> +	uint32_t i;
> +
> +	if (phba->sli_rev < LPFC_SLI_REV4)
> +		return;
> +
> +	/* Hint to other driver operations that a flush is in progress. */
> +	spin_lock_irq(&phba->hbalock);
> +	phba->hba_flag |= HBA_NVME_IOQ_FLUSH;
> +	spin_unlock_irq(&phba->hbalock);
> +
Is this ever reset?
I don't see it here ...

[ .. ]
> @@ -4380,9 +4469,12 @@ lpfc_sli_chipset_init(struct lpfc_hba *phba)
>   * configured.
>   **/
>  int
> -lpfc_sli_hbq_count(void)
> +lpfc_sli_hbq_count(struct lpfc_hba *phba)
>  {
> -	return ARRAY_SIZE(lpfc_hbq_defs);
> +	int i;
> +
> +	i = ARRAY_SIZE(lpfc_hbq_defs);
> +	return i;
>  }
>  
>  /**
The point of this change being ...?

Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
