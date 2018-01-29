From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/19] lpfc: Fix frequency of Release WQE CQEs
Date: Mon, 29 Jan 2018 08:50:05 +0100
Message-ID: <5c5143c3-5a80-0283-60fb-1a8753775182@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60822 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbeA2IBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 03:01:54 -0500
In-Reply-To: <20180124224548.9530-2-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> The driver controls when the hardware sends completions that
> communicate consumption of elements from the WQ. This is done by
> setting a WQEC bit on a WQE.
> 
> The current driver sets it on every Nth WQE posting. However, the
> driver isn't clearing the bit if the WQE is reused. Thus, if the
> queue depth isn't evenly divisible by N, with enough time, it can
> be set on every element, creating a lot of overhead and risking
> CQ full conditions.
> 
> Correct by clearing the bit when not setting it on an Nth element.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 5f5528a12308..149f21f53b13 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -129,6 +129,8 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
>  	/* set consumption flag every once in a while */
>  	if (!((q->host_index + 1) % q->entry_repost))
>  		bf_set(wqe_wqec, &wqe->generic.wqe_com, 1);
> +	else
> +		bf_set(wqe_wqec, &wqe->generic.wqe_com, 0);
>  	if (q->phba->sli3_options & LPFC_SLI4_PHWQ_ENABLED)
>  		bf_set(wqe_wqid, &wqe->generic.wqe_com, q->queue_id);
>  	lpfc_sli_pcimem_bcopy(wqe, temp_wqe, q->entry_size);
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
