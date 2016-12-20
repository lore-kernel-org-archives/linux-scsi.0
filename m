From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 10/11] lpfc: Add missing memory barrier
Date: Tue, 20 Dec 2016 14:47:20 +0100
Message-ID: <313785cf-8fbc-0b7b-3227-ad6695ec7cfc@suse.de>
References: <58586832.woeJM8e1raA2NxNi%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755408AbcLTNrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:47:22 -0500
In-Reply-To: <58586832.woeJM8e1raA2NxNi%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> On loosely ordered memory systems (PPC for example), the WQE elements
> were being updated in memory, but not necessarily flushed before the
> separate doorbell was written to hw which would cause hw to dma the
> WQE element. Thus, the hardware occasionally received partially
> updated WQE data.
> 
> Add the memory barrier after updating the WQE memory.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
> v2:
>   revised for checkpatch warning - comment before wmb()
> 
>  drivers/scsi/lpfc/lpfc_sli.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index d0ffcf3..5c8663f 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -120,6 +120,8 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
>  	if (q->phba->sli3_options & LPFC_SLI4_PHWQ_ENABLED)
>  		bf_set(wqe_wqid, &wqe->generic.wqe_com, q->queue_id);
>  	lpfc_sli_pcimem_bcopy(wqe, temp_wqe, q->entry_size);
> +	/* ensure WQE bcopy flushed before doorbell write */
> +	wmb();
>  
>  	/* Update the host index before invoking device */
>  	host_index = q->host_index;
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
