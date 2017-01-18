From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/17] lpfc: NVME Initiator: Base modifications Part C
Date: Wed, 18 Jan 2017 08:17:30 +0100
Message-ID: <0d7410a8-f7a5-cf97-5c03-c0c2c329f38a@suse.de>
References: <587ec2ef.Y/y2qvlPHm64sAst%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdARHSZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 02:18:25 -0500
In-Reply-To: <587ec2ef.Y/y2qvlPHm64sAst%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part C of parts A..F.
> 
> Part C is the 1st half of the mods to lpfc_init.c. This is the location
> of most of changes for the following:
> - sli3 ring vs sli4 wq splits
> - buffer pools are allocated/freed
> - sgl pools allocated/freed
> - adapter resources split up
> - queue config decided and enacted
> - receive buffer management
> 
> *********
> 
> Refer to Part A for a description of base modifications
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
[ .. ]
> @@ -3315,16 +3421,121 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
[ .. ]
> +	if (phba->sli4_hba.nvme_xri_cnt > phba->sli4_hba.nvme_xri_max) {
> +		/* max nvme xri shrunk below the allocated nvme buffers */
> +		nvme_xri_cnt = phba->sli4_hba.nvme_xri_cnt -
> +					phba->sli4_hba.nvme_xri_max;
> +		/* release the extra allocated nvme buffers */
> +		for (i = 0; i < nvme_xri_cnt; i++) {
> +			list_remove_head(&nvme_sgl_list, lpfc_ncmd,
> +					 struct lpfc_nvme_buf, list);
> +			if (lpfc_ncmd) {
> +				pci_pool_free(phba->lpfc_sg_dma_buf_pool,
> +					      lpfc_ncmd->data,
> +					      lpfc_ncmd->dma_handle);
> +				kfree(lpfc_ncmd);
> +			}
> +		}
> +		spin_lock_irq(&phba->nvme_buf_list_get_lock);
> +		phba->sli4_hba.nvme_xri_cnt -= nvme_xri_cnt;
> +		spin_unlock_irq(&phba->nvme_buf_list_get_lock);
> +	}
> +
Unsafe.
'nvme_xri_cnt' is updated under the lock, but not tested with the lock
held. Please fix.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
