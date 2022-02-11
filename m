Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB5BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 12:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350309AbiBKMvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:51:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350299AbiBKMvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 07:51:07 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5CAE5A
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 04:51:05 -0800 (PST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JwD3s6mrZz6H71R;
        Fri, 11 Feb 2022 20:50:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 11 Feb 2022 13:51:03 +0100
Received: from [10.47.87.89] (10.47.87.89) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 11 Feb
 2022 12:51:03 +0000
Message-ID: <84d4c573-661a-39d5-f639-a3eb9ba8c0ee@huawei.com>
Date:   Fri, 11 Feb 2022 12:51:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 21/24] scsi: pm8001: Fix pm8001_task_exec()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
 <20220211073704.963993-22-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220211073704.963993-22-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.89]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/02/2022 07:37, Damien Le Moal wrote:

Hi Damien,

> The n_elem local variable in pm8001_task_exec() is initialized to 0 and
> changed set to the number of DMA scatter elements for a needed for a
> task command only for ATA commands and for SAS commands that have a
> non-zero number of sg segments. n_elem is never initialized to 0 for SAS

Do you mean re-initialized?

I thought the current code was ok, as we init n_elem = 0 and we only 
ever loop once. Am I missing something?

Thanks,
john

> commands that do not no sg segments, potentially leading to an incorrect
> value of n_elem being used for a task. Add the missing 0 initialization.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>   drivers/scsi/pm8001/pm8001_sas.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 7b749da82a61..8cd7e7837f41 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -383,7 +383,7 @@ static int pm8001_task_exec(struct sas_task *task,
>   	struct sas_task *t = task;
>   	struct task_status_struct *ts = &t->task_status;
>   	struct pm8001_ccb_info *ccb;
> -	u32 tag = 0xdeadbeef, rc = 0, n_elem = 0;
> +	u32 tag = 0xdeadbeef, rc = 0, n_elem;
>   	unsigned long flags = 0;
>   	enum sas_protocol task_proto = t->task_proto;
>   
> @@ -440,6 +440,8 @@ static int pm8001_task_exec(struct sas_task *task,
>   					rc = -ENOMEM;
>   					goto err_out_tag;
>   				}
> +			} else {
> +				n_elem = 0;
>   			}
>   		} else {
>   			n_elem = t->num_scatter;

