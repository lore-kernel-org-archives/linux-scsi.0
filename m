Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0BEC4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 10:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7319221924
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 10:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgEAK1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 06:27:35 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2140 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728119AbgEAK1e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 06:27:34 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 3C2CDDF61A8EDBB94371;
        Fri,  1 May 2020 11:27:32 +0100 (IST)
Received: from [127.0.0.1] (10.47.3.165) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 1 May 2020
 11:27:31 +0100
Subject: Re: [PATCH RFC v3 37/41] libsas: add tag to struct sas_task
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-38-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <61c1be62-c2f1-8d0d-9533-ba3cf671d666@huawei.com>
Date:   Fri, 1 May 2020 11:26:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-38-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.3.165]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/04/2020 14:19, Hannes Reinecke wrote:
> All block layer commands now have a tag, so we should be storing
> it in the sas_task structure for easier lookup.

This seems like a decent idea, to put the tag here, so that we don't 
need to do the lookup in the LLDD queuecommand.

However it feels safer to use a sas_task scsicmd->request->tag in the 
LLDD directly, if we can make that possible. More below.

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/libsas/sas_ata.c       | 4 ++++
>   drivers/scsi/libsas/sas_init.c      | 2 ++
>   drivers/scsi/libsas/sas_scsi_host.c | 2 +-
>   include/scsi/libsas.h               | 2 ++
>   4 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 5d716d388707..897007343b3d 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -211,6 +211,10 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>   
>   	task->data_dir = qc->dma_dir;
>   	task->scatter = qc->sg;
> +	if (qc->scsicmd)
> +		task->tag = qc->scsicmd->request->tag;
> +	else
> +		task->tag = qc->tag;

I think that this tag comes from ata_sas_allocate_tag(), and would be 
managed from yet another bitmap for ATA commands tags. Maybe we can 
allocate a sas slow task here, instead of using this tag. Needs more 
checking...

>   	task->ata_task.retry_count = 1;
>   	task->task_state_flags = SAS_TASK_STATE_PENDING;
>   	qc->lldd_task = task;
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 5aa8593b88b5..0d32cb49d0af 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -53,6 +53,7 @@ struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
>   	if (!slow)
>   		goto out_err_slow;
>   
> +	task->tag = -1;
>   	if (shost->nr_reserved_cmds) {
>   		struct scsi_device *sdev;
>   
> @@ -66,6 +67,7 @@ struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
>   		slow->scmd = scsi_get_reserved_cmd(sdev, DMA_NONE, false);
>   		if (!slow->scmd)
>   			goto out_err_scmd;
> +		task->tag = slow->scmd->request->tag;
>   		ASSIGN_SAS_TASK(slow->scmd, task);
>   	}
>   
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index c5a430e3fa2d..585e0df5fce2 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -149,7 +149,7 @@ static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
>   	memcpy(task->ssp_task.LUN, &lun.scsi_lun, 8);
>   	task->ssp_task.task_attr = TASK_ATTR_SIMPLE;
>   	task->ssp_task.cmd = cmd;
> -
> +	task->tag = cmd->request->tag;
>   	task->scatter = scsi_sglist(cmd);
>   	task->num_scatter = scsi_sg_count(cmd);
>   	task->total_xfer_len = scsi_bufflen(cmd);
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index c927228019c9..af864f68b5cc 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -594,6 +594,8 @@ struct sas_task {
>   	u32    total_xfer_len;
>   	u8     data_dir:2;	  /* Use PCI_DMA_... */
>   
> +	u32    tag;

unsigned, yet we assign it -1?

> +
>   	struct task_status_struct task_status;
>   	void   (*task_done)(struct sas_task *);
>   
> 

Thanks!
