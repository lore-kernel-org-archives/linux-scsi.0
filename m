From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: Re: [PATCH] mvsas: fix error return code in mvs_task_prep()
Date: Mon, 31 Oct 2016 15:13:57 +0000
Message-ID: <9a9d6b4a-2429-93d6-8ca1-2b89e0f9ef42@osg.samsung.com>
References: <1477926250-10292-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32845
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943917AbcJaPPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2016 11:15:18 -0400
In-Reply-To: <1477926250-10292-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wilfried Weissmann <Wilfried.Weissmann@gmx.at>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Baoyou Xie <baoyou.xie@linaro.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

On 31/10/16 15:04, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/scsi/mvsas/mv_sas.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 86eb199..c7cc803 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -791,8 +791,10 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
>  	slot->slot_tag = tag;
>  
>  	slot->buf = pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
> -	if (!slot->buf)
> +	if (!slot->buf) {
> +		rc = -ENOMEM;
>  		goto err_out_tag;
> +	}
>  	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
>  
>  	tei.task = task;
> 

Looks good to me.

This will make the rc in dev_printk() and prep_out correct.

Thanks,
Luis
