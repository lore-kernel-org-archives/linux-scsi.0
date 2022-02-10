Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99036C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 14:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243204AbiBJOui (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:50:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiBJOui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 09:50:38 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35759EB8
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 06:50:39 -0800 (PST)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jvfn25kT3z67qfF;
        Thu, 10 Feb 2022 22:50:30 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 15:50:37 +0100
Received: from [10.202.227.197] (10.202.227.197) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 14:50:36 +0000
Message-ID: <5074efb5-f3bb-4305-f993-4d97aa2ee2ca@huawei.com>
Date:   Thu, 10 Feb 2022 14:50:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 16/20] scsi: pm8001: simplify pm8001_get_ncq_tag()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-17-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220210114218.632725-17-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.197]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2022 11:42, Damien Le Moal wrote:
> To detect if a command is NCQ, there is no need to test all possible NCQ
> command codes. Instead, use ata_is_ncq() to test the command protocol.
> 

task->ata_task.use_ncq holds ata_is_ncq() and that is checked before 
calling pm8001_get_ncq_tag() in both callsites, so I doubt the point in 
the caller pre-check, so maybe that can be removed

> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/pm8001/pm8001_sas.c | 14 +++++---------
>   1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 6805c7f43e41..711eaf81f546 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -306,16 +306,12 @@ static int pm8001_task_prep_smp(struct pm8001_hba_info *pm8001_ha,
>   u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag)
>   {
>   	struct ata_queued_cmd *qc = task->uldd_task;
> -	if (qc) {
> -		if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
> -		    qc->tf.command == ATA_CMD_FPDMA_READ ||
> -		    qc->tf.command == ATA_CMD_FPDMA_RECV ||
> -		    qc->tf.command == ATA_CMD_FPDMA_SEND ||
> -		    qc->tf.command == ATA_CMD_NCQ_NON_DATA) {
> -			*tag = qc->tag;
> -			return 1;
> -		}
> +
> +	if (qc && ata_is_ncq(qc->tf.protocol)) {
> +		*tag = qc->tag;
> +		return 1;
>   	}
> +
>   	return 0;
>   }
>   

