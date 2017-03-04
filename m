From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: don't dereference dma_buf->iocbq before null
 check
Date: Sat, 4 Mar 2017 09:42:45 -0800
Message-ID: <c7423fa3-299b-c010-bf4e-c34a11c146d3@broadcom.com>
References: <20170224140914.6011-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35740 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752442AbdCDRmv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:42:51 -0500
Received: by mail-wm0-f52.google.com with SMTP id v186so36283391wmd.0
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:42:50 -0800 (PST)
In-Reply-To: <20170224140914.6011-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

Looks good. I included it in the lpfc patch set just posted.

-- james


On 2/24/2017 6:09 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> dma_buf->iocbq is being dereferenced immediately before it is
> being null checked, so we have a potential null pointer dereference
> bug.  Fix this by only dereferencing it only once we have passed
> a null check on the pointer.
>
> Detected by CoverityScan, CID#1411652 ("Dereference before null check")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/lpfc/lpfc_mem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
> index c61d8d6..5986c79 100644
> --- a/drivers/scsi/lpfc/lpfc_mem.c
> +++ b/drivers/scsi/lpfc/lpfc_mem.c
> @@ -646,7 +646,6 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
>   	}
>   
>   	dma_buf->iocbq = lpfc_sli_get_iocbq(phba);
> -	dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
>   	if (!dma_buf->iocbq) {
>   		kfree(dma_buf->context);
>   		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
> @@ -658,6 +657,7 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
>   				"2621 Ran out of nvmet iocb/WQEs\n");
>   		return NULL;
>   	}
> +	dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
>   	nvmewqe = dma_buf->iocbq;
>   	wqe = (union lpfc_wqe128 *)&nvmewqe->wqe;
>   	/* Initialize WQE */
