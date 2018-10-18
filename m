From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi/mvsas/mv_sas.c: Use dma_pool_zalloc
Date: Thu, 18 Oct 2018 17:32:59 +0100
Message-ID: <28cb824f-28b9-8144-4bea-c4dd33b3b80b@huawei.com>
References: <5bc8af85.1c69fb81.3eebc.a22b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bc8af85.1c69fb81.3eebc.a22b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, keescook@chromium.org, jinpu.wang@profitbricks.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 18/10/2018 17:06, Sabyasachi Gupta wrote:
> Replaced dma_pool_alloc + memset with dma_pool_zalloc
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> ---
>  drivers/scsi/mvsas/mv_sas.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index cff43bd..d00d37d 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -790,12 +790,11 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
>  	slot->n_elem = n_elem;
>  	slot->slot_tag = tag;
>
> -	slot->buf = dma_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
> +	slot->buf = dma_pool_zalloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
>  	if (!slot->buf) {
>  		rc = -ENOMEM;
>  		goto err_out_tag;
>  	}
> -	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
>

How about also fixing these, below, up to use dma_zalloc_coherent() or 
even dmam_alloc_coherent() [as they're manually free'd at removal]:

static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
{
     int i = 0, slot_nr;
     char pool_name[32];
...
     /*
      * alloc and init our DMA areas
      */
     mvi->tx = dma_alloc_coherent(mvi->dev,
                      sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
                      &mvi->tx_dma, GFP_KERNEL);
     if (!mvi->tx)
         goto err_out;
     memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);

...

Thanks,
John

>  	tei.task = task;
>  	tei.hdr = &mvi->slot[tag];
>
