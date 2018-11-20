From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi/lpfc/lpfc_sli.c: Use dma_zalloc_coherent
Date: Tue, 20 Nov 2018 13:53:33 -0800
Message-ID: <80744ca9-8439-814b-5564-95cd4dff2094@broadcom.com>
References: <5bf1797b.1c69fb81.2368c.1ccc@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bf1797b.1c69fb81.2368c.1ccc@mx.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 11/18/2018 6:38 AM, Sabyasachi Gupta wrote:
> Replaced dma_alloc_coherent + memset with dma_zalloc_coherent
>
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 783a154..3491ff7 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -6229,7 +6229,7 @@ lpfc_sli4_ras_dma_alloc(struct lpfc_hba *phba,
>   			goto free_mem;
>   		}
>   
> -		dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
> +		dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev,
>   						  LPFC_RAS_MAX_ENTRY_SIZE,
>   						  &dmabuf->phys,
>   						  GFP_KERNEL);
> @@ -6240,7 +6240,6 @@ lpfc_sli4_ras_dma_alloc(struct lpfc_hba *phba,
>   					"6187 DMA Alloc Failed FW logging");
>   			goto free_mem;
>   		}
> -		memset(dmabuf->virt, 0, LPFC_RAS_MAX_ENTRY_SIZE);
>   		dmabuf->buffer_tag = i;
>   		list_add_tail(&dmabuf->list, &ras_fwlog->fwlog_buff_list);
>   	}

Looks fine.

-- james

Reviewed-by:   James Smart   <jsmart2021@gmail.com>
