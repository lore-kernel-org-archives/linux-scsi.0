Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE125C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 01:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CDF64E64
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 01:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhCSBng (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:43:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14093 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhCSBnd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 21:43:33 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F1mp43Y2sz19GRX;
        Fri, 19 Mar 2021 09:41:32 +0800 (CST)
Received: from [10.174.179.92] (10.174.179.92) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 09:43:20 +0800
Subject: Re: [PATCH v2] scsi: libsas: Reset num_scatter if libata mark qc as
 NODATA
To:     Jolly Shah <jollys@google.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <john.garry@huawei.com>,
        <a.darwish@linutronix.de>, <luojiaxing@huawei.com>,
        <dan.carpenter@oracle.com>, <b.zolnierkie@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210318225632.2481291-1-jollys@google.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <5e7ea537-86ab-f654-1df4-765364116e18@huawei.com>
Date:   Fri, 19 Mar 2021 09:43:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20210318225632.2481291-1-jollys@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.92]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/3/19 6:56, Jolly Shah 写道:
> When the cache_type for the scsi device is changed, the scsi layer
> issues a MODE_SELECT command. The caching mode details are communicated
> via a request buffer associated with the scsi command with data
> direction set as DMA_TO_DEVICE (scsi_mode_select). When this command
> reaches the libata layer, as a part of generic initial setup, libata
> layer sets up the scatterlist for the command using the scsi command
> (ata_scsi_qc_new). This command is then translated by the libata layer
> into ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat). The libata layer
> treats this as a non data command (ata_mselect_caching), since it only
> needs an ata taskfile to pass the caching on/off information to the
> device. It does not need the scatterlist that has been setup, so it does
> not perform dma_map_sg on the scatterlist (ata_qc_issue). Unfortunately,
> when this command reaches the libsas layer(sas_ata_qc_issue), libsas
> layer sees it as a non data command with a scatterlist. It cannot
> extract the correct dma length, since the scatterlist has not been
> mapped with dma_map_sg for a DMA operation. When this partially
> constructed SAS task reaches pm80xx LLDD, it results in below warning.
> 
> "pm80xx_chip_sata_req 6058: The sg list address
> start_addr=0x0000000000000000 data_len=0x0end_addr_high=0xffffffff
> end_addr_low=0xffffffff has crossed 4G boundary"
> 
> This patch updates code to handle ata non data commands separately so
> num_scatter and total_xfer_len remain 0.
> 
> Fixes: 53de092f47ff ("scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA")
> Signed-off-by: Jolly Shah <jollys@google.com>
> ---
> v2:
> - reorganized code to avoid setting num_scatter twice
> 
>   drivers/scsi/libsas/sas_ata.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 024e5a550759..8b9a39077dba 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -201,18 +201,17 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>   		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
>   		task->total_xfer_len = qc->nbytes;
>   		task->num_scatter = qc->n_elem;
> +		task->data_dir = qc->dma_dir;
> +	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
> +		task->data_dir = DMA_NONE;

Hi Jolly & John,

We only set DMA_NONE for ATA_PROT_NODATA, I'm curious about why 
ATA_PROT_NCQ_NODATA and ATAPI_PROT_NODATA do not need to set DMA_NONE?

Thanks,
Jason


>   	} else {
>   		for_each_sg(qc->sg, sg, qc->n_elem, si)
>   			xfer += sg_dma_len(sg);
>   
>   		task->total_xfer_len = xfer;
>   		task->num_scatter = si;
> -	}
> -
> -	if (qc->tf.protocol == ATA_PROT_NODATA)
> -		task->data_dir = DMA_NONE;
> -	else
>   		task->data_dir = qc->dma_dir;
> +	}
>   	task->scatter = qc->sg;
>   	task->ata_task.retry_count = 1;
>   	task->task_state_flags = SAS_TASK_STATE_PENDING;
> 
