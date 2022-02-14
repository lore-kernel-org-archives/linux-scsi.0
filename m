Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC31FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 17:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357280AbiBNR4V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 12:56:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiBNR4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 12:56:20 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DEF2AD2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 09:56:12 -0800 (PST)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyBcK3gVBz67bZ4;
        Tue, 15 Feb 2022 01:51:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Mon, 14 Feb 2022 18:56:07 +0100
Received: from [10.47.81.62] (10.47.81.62) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 17:56:06 +0000
Message-ID: <f9ed7215-81df-7ab6-eec9-c8c0cd7830cf@huawei.com>
Date:   Mon, 14 Feb 2022 17:56:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 01/31] scsi: libsas: Fix sas_ata_qc_issue() handling of
 NCQ NON DATA commands
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-2-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220214021747.4976-2-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.62]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/02/2022 02:17, Damien Le Moal wrote:
> To detect for the DMA_NONE (no data transfer) DMA direction,
> sas_ata_qc_issue() tests if the command protocol is ATA_PROT_NODATA.
> This test does not include the ATA_CMD_NCQ_NON_DATA command as this
> command protocol is defined as ATA_PROT_NCQ_NODATA (equal to
> ATA_PROT_FLAG_NCQ) and not as ATA_PROT_NODATA.
> 
> To include both NCQ and non-NCQ commands when testing for the DMA_NONE
> DMA direction, use "!ata_is_data()".
> 
> Fixes: 176ddd89171d ("scsi: libsas: Reset num_scatter if libata marks qc as NODATA")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Regardless of comment below:
Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/libsas/sas_ata.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index e0030a093994..50f779088b6e 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -197,7 +197,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>   		task->total_xfer_len = qc->nbytes;
>   		task->num_scatter = qc->n_elem;
>   		task->data_dir = qc->dma_dir;
> -	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
> +	} else if (!ata_is_data(qc->tf.protocol)) {

I was thinking ata_is_dma() would be more appropiate, but I suppose we 
don't have to use DMA.

>   		task->data_dir = DMA_NONE; >   	} else {
>   		for_each_sg(qc->sg, sg, qc->n_elem, si)

