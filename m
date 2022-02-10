Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850D5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241097AbiBJLtC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:49:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiBJLtB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:49:01 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273BBB9D
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:49:03 -0800 (PST)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JvZkm0fc2z67nGY;
        Thu, 10 Feb 2022 19:48:16 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 12:49:00 +0100
Received: from [10.47.24.182] (10.47.24.182) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 10 Feb
 2022 11:48:59 +0000
Message-ID: <12d1bc6b-5d16-3b2d-1dec-9fc0d3c863cd@huawei.com>
Date:   Thu, 10 Feb 2022 11:48:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 03/20] scsi: libsas: Remove unnecessary initialization in
 sas_ata_qc_issue()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-4-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220210114218.632725-4-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.24.182]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2022 11:42, Damien Le Moal wrote:
> sas_task_alloc() sets the state flag SAS_TASK_STATE_PENDING for any
> new task allocated. So there is no need to set this flag again in
> sas_ata_qc_issue() after the task allocation.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

I think that my colleague Xiang Chen had the same patch queued locally, 
but yours got to the list first..

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/libsas/sas_ata.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 99549862c9c7..a03a841921db 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -204,7 +204,6 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>   	}
>   	task->scatter = qc->sg;
>   	task->ata_task.retry_count = 1;
> -	task->task_state_flags = SAS_TASK_STATE_PENDING;
>   	qc->lldd_task = task;
>   
>   	task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);

