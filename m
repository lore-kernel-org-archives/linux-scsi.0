From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/19] lpfc: Fix PRLI handling when topology type changes
Date: Mon, 29 Jan 2018 09:01:27 +0100
Message-ID: <483e81a6-063c-6fa3-b4eb-20214b66c38f@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-7-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751766AbeA2KXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:23:53 -0500
In-Reply-To: <20180124224548.9530-7-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> The lpfc driver does not discover a target when the topology
> changes from switched-fabric to direct-connect. The target
> rejects the PRLI from the initiator in direct-connect as the
> driver is using the old S_ID from the switched topology.
> 
> The driver was inappropriately clearing the VP bit to register the
> VPI, which is what is associated with the S_ID.
> 
> Fix by leaving the VP bit set (it was set earlier) and as the VFI
> is being re-registered, set the UPDT bit.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_mbox.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
> index 81fb92967b11..c32d4a323db2 100644
> --- a/drivers/scsi/lpfc/lpfc_mbox.c
> +++ b/drivers/scsi/lpfc/lpfc_mbox.c
> @@ -2170,10 +2170,8 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
>  	/* Only FC supports upd bit */
>  	if ((phba->sli4_hba.lnk_info.lnk_tp == LPFC_LNK_TYPE_FC) &&
>  	    (vport->fc_flag & FC_VFI_REGISTERED) &&
> -	    (!phba->fc_topology_changed)) {
> -		bf_set(lpfc_reg_vfi_vp, reg_vfi, 0);
> +	    (!phba->fc_topology_changed))
>  		bf_set(lpfc_reg_vfi_upd, reg_vfi, 1);
> -	}
>  
>  	bf_set(lpfc_reg_vfi_bbcr, reg_vfi, 0);
>  	bf_set(lpfc_reg_vfi_bbscn, reg_vfi, 0);
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
