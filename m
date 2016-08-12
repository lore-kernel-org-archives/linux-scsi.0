From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 11/14] lpfc: Fix crash on adapter reinit
Date: Fri, 12 Aug 2016 11:28:05 +0200
Message-ID: <20160812092805.5bk2vlee6e347aos@c203.arch.suse.de>
References: <57acc58e.tA8AOPGQuf/YmboW%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbcHLJ2H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 05:28:07 -0400
Content-Disposition: inline
In-Reply-To: <57acc58e.tA8AOPGQuf/YmboW%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2016 at 11:35:58AM -0700, James Smart wrote:
> 
> Fix crash on adapter reinit
> 
> Had unset fields passed to pci_pool_destroy() on teardown.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_mem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
> index 3fa6533..62b295d 100644
> --- a/drivers/scsi/lpfc/lpfc_mem.c
> +++ b/drivers/scsi/lpfc/lpfc_mem.c
> @@ -254,11 +254,13 @@ lpfc_mem_free(struct lpfc_hba *phba)
>  			      pool->elements[i].phys);
>  	kfree(pool->elements);
>  
> -	pci_pool_destroy(phba->lpfc_mbuf_pool);
> +	if (phba->lpfc_mbuf_pool)
> +		pci_pool_destroy(phba->lpfc_mbuf_pool);
>  	phba->lpfc_mbuf_pool = NULL;
>  
>  	/* Free DMA buffer memory pool */
> -	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
> +	if (phba->lpfc_scsi_dma_buf_pool)
> +		pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
>  	phba->lpfc_scsi_dma_buf_pool = NULL;
>  
>  	/* Free Device Data memory pool */
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


OK, that one I don't understand.

pci_pool_destroy() is just a wrapper around dma_pool_destroy():
include/linux/pci.h:1267:#define        pci_pool_destroy(pool) dma_pool_destroy(pool)

dma_pool_destroy() in turn has:

270 void dma_pool_destroy(struct dma_pool *pool)
271 {
272         bool empty = false;
273 
274         if (unlikely(!pool))
275                 return;


So why should repeating the check help here?

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
