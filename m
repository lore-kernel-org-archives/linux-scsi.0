From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [PATCH v2 4/4] scsi: pm8001: fix dma_unmap_sg() parameter
Date: Mon, 8 Jan 2018 16:53:07 +0800
Message-ID: <8523c545-d485-d446-e0da-4f479401bcfd@hisilicon.com>
References: <1515033405-37477-1-git-send-email-chenxiang66@hisilicon.com>
 <1515033405-37477-5-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:57764 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755984AbeAHIyB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jan 2018 03:54:01 -0500
In-Reply-To: <1515033405-37477-5-git-send-email-chenxiang66@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: john.garry@huawei.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, bryantly@linux.vnet.ibm.com, mikecyr@linux.vnet.ibm.com, artur.paszkiewicz@intel.com, dan.j.williams@intel.com, yuxiangl@marvell.com, jgarzik@pobox.com, jack_wang@usish.com, lindar_liu@usish.com, xjtuwjp@gmail.com

+cc Jack Wang <xjtuwjp@gmail.com>

ÔÚ 2018/1/4 10:36, chenxiang Ð´µÀ:
> For function dma_unmap_sg(), the <nents> parameter should be number of
> elements in the scatterlist prior to the mapping, not after the mapping.
> Fix this usage.
>
> Cc: Jack Wang <jack_wang@usish.com>
> Cc: lindar_liu@usish.com
> Fixes: dbf9bfe6("[SCSI]pm8001: add SAS/SATA/HBA driver")
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>   drivers/scsi/pm8001/pm8001_sas.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 947d601..576a0f0 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -466,7 +466,7 @@ static int pm8001_task_exec(struct sas_task *task,
>   	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
>   	if (!sas_protocol_ata(t->task_proto))
>   		if (n_elem)
> -			dma_unmap_sg(pm8001_ha->dev, t->scatter, n_elem,
> +			dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
>   				t->data_dir);
>   out_done:
>   	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
